# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::BackupRestore;
use strict;
use warnings;

use MT::BackupRestore::ContentTypePermission;
use MT::Serialize;
use MT::Util qw( encode_url );
use Symbol;
use base qw( MT::ErrorHandler );

sub NS_MOVABLETYPE {'http://www.sixapart.com/ns/movabletype'}

use File::Spec;
use File::Copy;

MT->add_callback(
    'restore',
    3,
    MT->instance,
    sub {
        my ( $cb, $objects, $deferred, $errors, $callback ) = @_;
        MT::BackupRestore->cb_restore_objects( $objects, $callback );
    }
);

MT->add_callback(
    'restore_asset',
    3,
    MT->instance,
    sub {
        my ( $cb, $asset, $callback ) = @_;
        MT::BackupRestore->cb_restore_asset( $asset, $callback );
    }
);

sub core_backup_instructions {

    # The list of classes that require specific orders
    # and/or special instructions.
    # Every other class will have the order of '500'.
    return {
        'website'       => { 'order' => 350 },
        'blog'          => { 'order' => 400 },
        'author'        => { 'order' => 420 },
        'category_set'  => { 'order' => 480 },
        'content_type'  => { 'order' => 480 },
        'cf'            => { 'order' => 490 },
        'content_field' => { 'order' => 490 },

        # These 'association' classes should be backed up
        # after the object classes.
        'association' => { 'order' => 510 },
        'placement'   => { 'order' => 510 },
        'trackback'   => { 'order' => 510 },
        'filter'      => { 'order' => 510 },

        # Ping should be backed up after Trackback.
        'tbping'   => { 'order' => 520 },
        'ping'     => { 'order' => 520 },
        'ping_cat' => { 'order' => 520 },

        # Comment should be backed up after TBPing
        # because saving a comment ultimately triggers
        # MT::TBPing::save.
        'comment'      => { 'order' => 530 },
        'cd'           => { 'order' => 530 },
        'content_data' => { 'order' => 530 },

        # ObjetScore should be backed up after Comment.
        'objectscore'    => { 'order' => 540 },
        'objectasset'    => { 'order' => 540 },
        'objecttag'      => { 'order' => 540 },
        'objectcategory' => { 'order' => 540 },

        # Session, config and TheSchwartz packages are never backed up.
        'session'             => { 'skip' => 1 },
        'config'              => { 'skip' => 1 },
        'ts_job'              => { 'skip' => 1 },
        'ts_error'            => { 'skip' => 1 },
        'ts_exitstatus'       => { 'skip' => 1 },
        'ts_funcmap'          => { 'skip' => 1 },
        'touch'               => { 'skip' => 1 },
        'failedlogin'         => { 'skip' => 1 },
        'accesstoken'         => { 'skip' => 1 },
        'cf_idx'              => { 'skip' => 1 },
        'content_field_index' => { 'skip' => 1 },
        'log'                 => { 'skip' => 1 },
    };
}

sub _populate_obj_to_backup {
    my $pkg = shift;
    my ($blog_ids) = @_;

    my %populated;
    if ( defined($blog_ids) && scalar(@$blog_ids) ) {

        # author will be handled at last
        $populated{ MT->model('author') } = 1;

        # Do not run the process of backing up websites when backing up blog.
        unless ( MT->model('website')
            ->exist( { id => \@$blog_ids, class => 'website' } ) )
        {
            $populated{ MT->model('website') } = 1;
        }
    }

    my @object_hashes;
    my $types        = MT->registry('object_types');
    my $instructions = MT->registry('backup_instructions');
    foreach my $key ( keys %$types ) {
        next if $key =~ /\w+\.\w+/;    # skip subclasses
        my $class = MT->model($key);
        next unless $class;
        next if $class eq $key;    # FIXME: to remove plugin object_classes
        next
            if exists( $instructions->{$key} )
            && exists( $instructions->{$key}{skip} )
            && $instructions->{$key}{skip};
        next if exists $populated{$class};
        my $order
            = exists( $instructions->{$key} )
            && exists( $instructions->{$key}{order} )
            ? $instructions->{$key}{order}
            : 500;

        if ( $class->can('create_obj_to_backup') ) {
            $class->create_obj_to_backup( $blog_ids, \@object_hashes,
                \%populated, $order );
        }
        else {
            $pkg->_create_obj_to_backup( $class, $blog_ids, \@object_hashes,
                \%populated, $order );
        }
    }

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {

        # Author has two ways to be associated to a blog
        my $class = MT->model('author');
        unshift @object_hashes,
            {
            $class => {
                terms => undef,
                args  => {
                    'join' => [
                        MT->model('association'), 'author_id',
                        { blog_id => $blog_ids }, { unique => 1 }
                    ]
                }
            },
            'order' => 500
            };
        unshift @object_hashes,
            {
            $class => {
                terms => undef,
                args  => {
                    'join' => [
                        MT->model('permission'), 'author_id',
                        { blog_id => $blog_ids }, { unique => 1 }
                    ]
                }
            },
            'order' => 500
            };

        # Author could also be in objectscore table.
        unshift @object_hashes,
            {
            $class => {
                terms => undef,
                args  => {
                    'join' => [
                        MT->model('objectscore'), 'author_id',
                        undef, { unique => 1 }
                    ],
                }
            },
            'order' => 500
            };
        unshift @object_hashes,
            {
            $class => {
                terms => undef,
                args  => {
                    'join' => [
                        MT->model('objectscore'), 'object_id',
                        { object_ds => 'author' }, { unique => 1 }
                    ],
                }
            },
            'order' => 500
            };

        # And objectscores.
        my $oc = MT->model('objectscore');
        push @object_hashes,
            {
            $oc => {
                terms => { object_ds => 'author' },
                args  => undef,
            },
            'order' => 510,
            };

        # And Filter.
        unshift @object_hashes,
            {
            $class => {
                terms => undef,
                args  => {
                    'join' => [
                        MT->model('filter'), 'author_id',
                        { blog_id => $blog_ids }, { unique => 1 }
                    ]
                }
            },
            'order' => 500
            };
    }
    @object_hashes = sort { $a->{order} <=> $b->{order} } @object_hashes;
    my @obj_to_backup;
    foreach my $hash (@object_hashes) {
        delete $hash->{order};
        push @obj_to_backup, $hash;
    }
    return \@obj_to_backup;
}

sub _create_obj_to_backup {
    my $pkg = shift;
    my ( $class, $blog_ids, $obj_to_backup, $populated, $order ) = @_;

    my $instructions = MT->registry('backup_instructions');
    my $columns      = $class->column_names;
    foreach my $column (@$columns) {
        if ( $column =~ /^(\w+)_id$/ ) {
            my $parent  = $1;
            my $p_class = MT->model($parent);
            next unless $p_class;
            next if exists $populated->{$p_class};
            next
                if exists( $instructions->{$parent} )
                && exists( $instructions->{$parent}{skip} )
                && $instructions->{$parent}{skip};
            my $p_order
                = exists( $instructions->{$parent} )
                && exists( $instructions->{$parent}{order} )
                ? $instructions->{$parent}{order}
                : 500;
            $pkg->_create_obj_to_backup( $p_class, $blog_ids, $obj_to_backup,
                $populated, $p_order );
        }
    }

    if ( $class->can('backup_terms_args') ) {
        push @$obj_to_backup,
            {
            $class  => $class->backup_terms_args($blog_ids),
            'order' => $order
            };
    }
    else {
        push @$obj_to_backup,
            $pkg->_default_terms_args( $class, $blog_ids, $order );
    }

    $populated->{$class} = 1;
}

sub _default_terms_args {
    my $pkg = shift;
    my ( $class, $blog_ids, $order ) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            $class => {
                terms => { 'blog_id' => $blog_ids },
                args  => undef
            },
            'order' => $order,
        };
    }
    else {
        return {
            $class  => { terms => undef, args => undef },
            'order' => $order,
        };
    }
}

sub backup {
    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info('--- Start export.');

    my $class = shift;
    my ($blog_ids, $printer, $splitter, $finisher,
        $progress, $size,    $enc,      $metadata
    ) = @_;

# removed global items from backup for blog-specific backups as this creates multiple copies of global items
# when multiple blogs from the same instance are restored one-by-one. ideally, this should be a user setting on the backup form
# push @$blog_ids, '0' if defined($blog_ids) && scalar(@$blog_ids);

    MT::Util::Log->debug(' Start _populate_obj_to_backup.');

    my $obj_to_backup = $class->_populate_obj_to_backup($blog_ids);

    MT::Util::Log->debug(' End   _populate_obj_to_backup.');

    my $header = "<movabletype xmlns='" . NS_MOVABLETYPE . "'\n";
    $header .= join ' ',
        map { $_ . "='" . $metadata->{$_} . "'" } keys %$metadata;
    $header .= ">\n";
    $header = "<?xml version='1.0'?>\n$header";
    $printer->($header);

    my $files = {};

    MT::Util::Log->debug(' Start _loop_through_objects.');

    my $backuped_objs
        = _loop_through_objects( $printer, $splitter, $finisher, $progress,
        $size, $obj_to_backup, $files, $header );

    MT::Util::Log->debug(' End   _loop_through_objects.');

    my $else_xml = MT->run_callbacks( 'Backup', $blog_ids, $progress );
    $printer->($else_xml) if $else_xml ne '1';
    my @else_xml;

    MT::Util::Log->debug(' Start callbacks "backup.plugin_objects".');

    MT->run_callbacks( 'backup.plugin_objects', $blog_ids, $progress,
        \@else_xml, $backuped_objs );

    MT::Util::Log->debug(' End   callbacks "backup.plugin_objects".');

    $printer->($_) foreach @else_xml;

    $printer->('</movabletype>');
    $finisher->($files);

    MT::Util::Log->info('--- End   export.');
}

sub _loop_through_objects {
    my ( $printer, $splitter, $finisher, $progress, $size, $obj_to_backup,
        $files, $header )
        = @_;

    my $counter = 1;
    my $bytes   = 0;
    my %object_seen;
    my %backuped_objs_store;
    my $author_pkg = MT->model('author');

    my $can_read_disk_usage;
    eval "require Filesys::DfPortable;";
    if ( !$@ ) {
        $can_read_disk_usage = 1;
    }

    my $temp_dir = MT->config('ExportTempDir') || MT->config('TempDir');
    for my $class_hash (@$obj_to_backup) {
        if ($can_read_disk_usage) {
            my $ref = Filesys::DfPortable::dfportable($temp_dir);
            if ( $ref->{per} == 100 ) {
                die MT->translate("\nCannot write file. Disk full.");
            }
        }

        my ( $class, $term_arg ) = each(%$class_hash);
        eval "require $class;";
        my $children = $class->properties->{child_classes} || {};
        for my $child_class ( keys %$children ) {
            eval "require $child_class;";
        }
        if ( my $err = $@ ) {
            $progress->( "$err\n", 'Error' );
            next;
        }
        my @metacolumns;
        if ( exists( $class->properties->{meta} )
            && $class->properties->{meta} )
        {
            require MT::Meta;
            @metacolumns = MT::Meta->metadata_by_class($class);
        }
        my $records = 0;
        my $state = MT->translate( 'Exporting [_1] records:', $class );
        $progress->( $state, $class->class_type || $class->datasource );
        my $limit         = 50;
        my $offset        = 0;
        my $terms         = $term_arg->{terms} || {};
        my $args          = $term_arg->{args};
        my $backuped_objs = ( $backuped_objs_store{$class} ||= [] );

        unless ( exists $args->{sort} ) {
            $args->{sort}      = 'id';
            $args->{direction} = 'ascend';
        }
        while (1) {
            $args->{offset} = $offset;
            $args->{limit}  = $limit + 1;
            my $iter;
            eval { $iter = $class->load_iter( $terms, $args ); };
            if ( my $err = $@ ) {
                $progress->( "$class:$err\n", 'Error' );
            }
            last unless $iter;
            my $count = 0;
            my $next  = 0;
            while ( my $object = $iter->() ) {
                if ( $count == $limit ) {
                    $iter->end;
                    $next = 1;
                    $offset += $count;
                    last;
                }
                $count++;
                if (exists $object_seen{ $class->datasource . '/'
                            . $object->id } )
                {
                    next;
                }
                if ( $class->datasource eq 'author' ) {

        # Authors may be duplicated because of how terms and args are created.
                    $object_seen{ 'author/' . $object->id } = 1;
                }
                elsif ( $class->datasource eq 'asset' ) {
                    $object_seen{ 'asset/' . $object->id } = 1;
                    $files->{ $object->id } = [
                        $object->url, $object->file_path,
                        $object->file_name
                    ];
                    if ( $object->parent
                        and not $object_seen{ 'asset/' . $object->parent } )
                    {
                        my $parent
                            = MT->model('asset')->load( $object->parent );
                        next unless $parent;
                        $object_seen{ 'asset/' . $parent->id } = 1;
                        $bytes += $printer->(
                            $parent->to_xml( undef, \@metacolumns ) . "\n" );
                        $files->{ $parent->id } = [
                            $parent->url, $parent->file_path,
                            $parent->file_name
                        ];
                        $records++;
                    }
                }
                elsif ( $class->datasource eq 'category' ) {
                    $object_seen{ 'category/' . $object->id } = 1;
                    foreach my $parent ( reverse $object->parent_categories )
                    {
                        next
                            if
                            exists $object_seen{ 'category/' . $parent->id };
                        $object_seen{ 'category/' . $parent->id } = 1;
                        $bytes += $printer->(
                            $parent->to_xml( undef, \@metacolumns ) . "\n" );
                        $records++;
                    }
                }
                $bytes += $printer->(
                    $object->to_xml( undef, \@metacolumns ) . "\n" );
                $records++;
                push @$backuped_objs, $object->id;
                if ( $size && ( $bytes >= $size ) ) {
                    $splitter->( ++$counter, $header );
                    $bytes = 0;
                }
            }
            last unless $next;
            $progress->(
                $state . " "
                    . MT->translate( "[_1] records exported...", $records ),
                $class->datasource
            ) if $records && ( $records % 100 == 0 );
        }
        if ($records) {
            $progress->(
                $state . " "
                    . MT->translate( "[_1] records exported.", $records ),
                $class->class_type || $class->datasource
            );
        }
        else {
            $progress->(
                $state . " "
                    . MT->translate(
                    "There were no [_1] records to be exported.", $class
                    ),
                $class->class_type || $class->datasource
            );
        }
    }
    return \%backuped_objs_store;
}

sub restore_file {
    my $class = shift;
    my ( $fh, $errormsg, $schema_version, $overwrite, $callback ) = @_;

    my $objects  = {};
    my $deferred = {};
    my $errors   = [];

    my ( $blog_ids, $asset_ids ) = eval {
        $class->restore_process_single_file( $fh, $objects, $deferred,
            $errors, $schema_version, $overwrite, $callback );
    };

    unless ($@) {
        MT->run_callbacks( 'restore', $objects, $deferred, $errors,
            $callback );
    }
    $$errormsg = join( '; ', @$errors );
    ( $deferred, $blog_ids );
}

sub restore_process_single_file {
    my $class = shift;
    my ( $fh, $objects, $deferred, $errors, $schema_version, $overwrite,
        $callback )
        = @_;

    require XML::SAX;
    require MT::Util;
    my $parser = MT::Util::sax_parser();

    require MT::BackupRestore::BackupFileScanner;
    my $scanner = MT::BackupRestore::BackupFileScanner->new();
    my $pos     = tell($fh);
    $parser->{Handler} = $scanner;
    eval { $parser->parse_file($fh); };
    if ( my $e = $@ ) {
        push @$errors, $e;
        $callback->($e);
        die $e;
    }
    seek( $fh, $pos, 0 );

    my %restored_blogs = map { $objects->{$_}->id => 1; }
        grep { 'blog' eq $objects->{$_}->datasource } keys %$objects;

    require MT::BackupRestore::BackupFileHandler;
    my $handler = MT::BackupRestore::BackupFileHandler->new(
        callback           => $callback,
        objects            => $objects,
        deferred           => $deferred,
        errors             => $errors,
        schema_version     => $schema_version,
        overwrite_template => $overwrite,
    );

    $parser = MT::Util::sax_parser();
    $callback->( ref($parser) . "\n" ) if MT->config->DebugMode;
    $handler->{is_pp} = ref($parser) eq 'XML::SAX::PurePerl' ? 1 : 0;
    $parser->{Handler} = $handler;
    eval { $parser->parse_file($fh); };
    if ( my $e = $@ ) {
        push @$errors, $e;
        $callback->($e);
        die $e if $handler->{critical};
    }

    my @blog_ids;
    my @asset_ids;

    while ( my ( $key, $value ) = each %$objects ) {
        if ( 'blog' eq $value->datasource ) {
            push @blog_ids, $value->id
                unless exists $restored_blogs{ $value->id };
        }
        elsif ( 'asset' eq $value->datasource ) {
            my ($old_id) = $key =~ /^.+#(\d+)$/;
            push @asset_ids, $value->id, $old_id;
        }
    }

    my $blog_ids  = scalar(@blog_ids)  ? \@blog_ids  : undef;
    my $asset_ids = scalar(@asset_ids) ? \@asset_ids : undef;
    ( $blog_ids, $asset_ids );
}

sub restore_directory {
    my $class = shift;
    my ( $dir, $errors, $error_assets, $schema_version, $overwrite,
        $callback )
        = @_;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info(' Start restore_directory');

    my $manifest;
    opendir my $dh,
        $dir
        or push( @$errors,
        MT->translate( "Cannot open directory '[_1]': [_2]", $dir, "$!" ) ),
        return undef;
    for my $f ( readdir $dh ) {
        next if $f !~ /^.+\.manifest$/i;
        $manifest = File::Spec->catfile( $dir,
            Encode::decode( MT->config->PublishCharset, $f ) );
        last;
    }
    closedir $dh;
    unless ($manifest) {
        push @$errors,
            MT->translate(
            "No manifest file could be found in your import directory [_1].",
            $dir
            );
        return ( undef, undef );
    }

    my $fh = gensym;
    open $fh, "<", $manifest
        or push( @$errors, MT->translate( "Cannot open [_1].", $manifest ) ),
        return 0;
    my $backups = __PACKAGE__->process_manifest($fh);
    close $fh;
    unless ($backups) {
        push @$errors,
            MT->translate(
            "Manifest file [_1] was not a valid Movable Type backup manifest file.",
            $manifest
            );
        return ( undef, undef );
    }

    $callback->( MT->translate( "Manifest file: [_1]", $manifest ) . "\n" );

    my %objects;
    my $deferred = {};

    my $files = $backups->{files};
    my @blog_ids;
    my @asset_ids;
    for my $file (@$files) {
        my $fh = gensym;
        my $filepath = File::Spec->catfile( $dir, $file );
        open $fh, "<", $filepath
            or push @$errors, MT->translate("Cannot open [_1]."), next;

        my ( $tmp_blog_ids, $tmp_asset_ids ) = eval {
            __PACKAGE__->restore_process_single_file( $fh, \%objects,
                $deferred, $errors, $schema_version, $overwrite, $callback );
        };

        close $fh;
        last if $@;

        push @blog_ids,  @$tmp_blog_ids  if defined $tmp_blog_ids;
        push @asset_ids, @$tmp_asset_ids if defined $tmp_asset_ids;
    }

    MT::Util::Log->debug('  Start callback restore.');

    unless ($@) {
        MT->run_callbacks( 'restore', \%objects, $deferred, $errors,
            $callback );
    }

    MT::Util::Log->debug('  End   callback restore.');

    my $blog_ids  = scalar(@blog_ids)  ? \@blog_ids  : undef;
    my $asset_ids = scalar(@asset_ids) ? \@asset_ids : undef;

    MT::Util::Log->info(' End   restore_directory');

    ( $deferred, $blog_ids, $asset_ids );
}

sub process_manifest {
    my $class = shift;
    my ($stream) = @_;

    if ( UNIVERSAL::isa( $stream, 'Fh' ) || ( ref($stream) eq 'GLOB' ) ) {
        seek( $stream, 0, 0 ) or return undef;
        require XML::SAX;
        require MT::BackupRestore::ManifestFileHandler;
        my $handler = MT::BackupRestore::ManifestFileHandler->new();

        require MT::Util;
        my $parser = MT::Util::sax_parser();
        $parser->{Handler} = $handler;
        eval { $parser->parse_file($stream); };
        if ( my $e = $@ ) {
            die $e;
        }
        return $handler->{backups};
    }
    return undef;
}

sub restore_asset {
    my $class = shift;
    my ( $file, $asset, $old_id, $fmgr, $errors, $callback ) = @_;

    my $id = $asset->id;

    my $path = $asset->file_path;
    unless ( defined($path) ) {
        $callback->(
            MT->translate( 'Path was not found for the file, [_1].', $id ) );
        return 0;
    }
    my ( $vol, $dir, $fn ) = File::Spec->splitpath($path);
    my $voldir = "$vol$dir";
    if ( !-w $voldir ) {
        unless ( defined $fmgr ) {
            my $blog = MT->model('blog')->load( $asset->blog_id );
            $fmgr = $blog->file_mgr if $blog;
        }
        unless ( defined $fmgr ) {
            $errors->{$id}
                = MT->translate( '[_1] is not writable.', $voldir );
        }
        else {
            $voldir =~ s|/$||
                unless $voldir eq
                '/';    ## OS X doesn't like / at the end in mkdir().
            unless ( $fmgr->exists($voldir) ) {
                $fmgr->mkpath($voldir)
                    or $errors->{$id}
                    = MT->translate( "Error making path '[_1]': [_2]",
                    $path, $fmgr->errstr );
            }
        }
    }
    if ( -w $voldir ) {
        my $filename = "$old_id-" . $asset->file_name;
        $callback->(
            MT->translate( "Copying [_1] to [_2]...", $filename, $path ) );
        $file = MT::FileMgr::Local::_local($file)
            unless ref($file);
        copy( $file, MT::FileMgr::Local::_local($path) )
            or $errors->{$id} = $!;
    }

    if ( exists $errors->{$id} ) {
        return $callback->(
            MT->translate('Failed: ') . $errors->{$id} . "\n" );
    }

    $callback->( MT->translate("Done.") . "\n" );

    MT->run_callbacks( 'restore_asset', $asset, $callback );

    1;
}

sub _sync_asset_id {
    my ( $text, $related ) = @_;

    my $new_text = $text;

    $new_text
        =~ s!(<form[^>]*?\s)mt:asset-id=(["'])(\d+)(["'])(?=[^>]*?>.+?</form>)!
        my $asset = $related->{$3};
        $1 . ( $asset ? ( 'mt:asset-id=' . $2 . $asset->id . $4 ) : ' ' );
    !igem;
    return $new_text ? $new_text : $text;
}

sub cb_restore_objects {
    my $pkg = shift;
    my ( $all_objects, $callback ) = @_;

    my %entries;
    my %assets;
    my %content_types;
    my @content_data;
    for my $key ( keys %$all_objects ) {
        my $obj = $all_objects->{$key};
        if ( $obj->properties->{audit} ) {
            my $author_class = MT->model('author');
            if (   $obj->created_by
                && $all_objects->{ "$author_class#" . $obj->created_by } )
            {
                my $new_id
                    = $all_objects->{ "$author_class#" . $obj->created_by }
                    ->id;
                $obj->created_by($new_id);
            }
            if (   $obj->modified_by
                && $all_objects->{ "$author_class#" . $obj->modified_by } )
            {
                my $new_id
                    = $all_objects->{ "$author_class#" . $obj->modified_by }
                    ->id;
                $obj->modified_by($new_id);
            }
            $obj->save;
        }

        if ( $key =~ /^MT::Entry#(\d+)$/ ) {
            my $new_id = $all_objects->{$key}->id;
            $entries{$new_id} = $all_objects->{$key};
        }
        elsif ( $key =~ /^MT::Asset#(\d+)$/ ) {
            my $old_id = $1;
            my $new_id = $all_objects->{$key}->id;
            $assets{$new_id} = {
                object => $all_objects->{$key},
                old_id => $old_id,
            };
        }
        elsif ( $key =~ /^MT::Author#(\d+)$/ ) {

            # restore userpic association now
            my $new_author = $all_objects->{$key};
            if ( !$all_objects->{$key}->{no_overwrite} ) {
                if ( my $userpic_id = $new_author->userpic_asset_id ) {
                    if ( my $new_asset
                        = $all_objects->{ 'MT::Asset#' . $userpic_id } )
                    {
                        $new_author->userpic_asset_id( $new_asset->id );
                    }
                }
            }

            # also restore ids of favorite blogs
            if ( my $favorites = $new_author->favorite_blogs ) {
                next unless 'ARRAY' eq ref($favorites);
                my @new_favs;
                if (@$favorites) {
                    foreach my $old_id (@$favorites) {
                        my $blog = $all_objects->{ 'MT::Blog#' . $old_id };
                        push @new_favs, $blog->id if $blog;
                    }
                }
                $new_author->favorite_blogs( \@new_favs ) if @new_favs;
            }
            if ( my $favorites = $new_author->favorite_websites ) {
                next unless 'ARRAY' eq ref($favorites);
                my @new_favs;
                if (@$favorites) {
                    foreach my $old_id (@$favorites) {
                        my $blog = $all_objects->{ 'MT::Website#' . $old_id };
                        push @new_favs, $blog->id if $blog;
                    }
                }
                $new_author->favorite_websites( \@new_favs ) if @new_favs;
            }
            $new_author->update;

            # call trigger to save meta
            $new_author->call_trigger( 'post_save', $new_author );
        }
        elsif ( $key =~ /^MT::Role#(\d+)$/ ) {
            my $role                = $all_objects->{$key};
            my $updated_permissions = MT::BackupRestore::ContentTypePermission
                ->update_permissions( $role->permissions, $all_objects );
            if ($updated_permissions) {
                $role->permissions($updated_permissions);
                $role->save;
            }
        }
        elsif ( $key =~ /^MT::(?:Blog|Website)#(\d+)$/ ) {
            my $blog   = $all_objects->{$key};
            my $orders = {
                category => 'MT::Category#',
                folder   => 'MT::Folder#',
            };
            foreach my $c ( keys %$orders ) {
                my $col = "${c}_order";
                if ( my $cat_order = $blog->$col ) {
                    my @cats = split ',', $cat_order;
                    my @new_cats
                        = map $_->id,
                        grep defined $_,
                        map $all_objects->{ $orders->{$c} . $_ },
                        @cats;
                    $blog->$col( join ',', @new_cats );
                    $blog->save;
                }
            }
        }
        elsif ( $key =~ /^MT::CategorySet#\d+$/ ) {
            my $category_set = $all_objects->{$key};
            my $old_order    = $category_set->order or next;
            my $new_order    = join ',', map { $_->id }
                grep { defined $_ }
                map  { $all_objects->{"MT::Category#$_"} }
                split ',', $old_order;
            $category_set->order($new_order);
            $category_set->save;
        }
        elsif ( $key =~ /^MT::ContentType#\d+$/ ) {
            my $content_type = $all_objects->{$key};
            if ( $content_type->data_label ) {
                my $new_data_label_field
                    = $all_objects->{ 'MT::ContentField#uid:'
                        . $content_type->data_label };
                $content_type->data_label(
                      $new_data_label_field
                    ? $new_data_label_field->unique_id
                    : undef
                );
            }
            my $old_fields = $content_type->fields;
            my @new_fields;
            for my $f (@$old_fields) {
                my $old_id = $f->{id} or next;
                my $new_field = $all_objects->{"MT::ContentField#$old_id"}
                    or next;
                $f->{id}        = $new_field->id;
                $f->{unique_id} = $new_field->unique_id;
                my $field_type_registry
                    = MT->registry( 'content_field_types', $f->{type} );
                if ( my $handler
                    = $field_type_registry->{site_import_handler} )
                {
                    if ( $handler = MT->handler_to_coderef($handler) ) {
                        $handler->( $f, $new_field, $all_objects );
                    }
                }
                push @new_fields, $f;
            }
            $content_type->fields( \@new_fields );
            $content_type->save or die $content_type->errstr;
            $content_types{ $content_type->id } = $content_type;
        }
        elsif ( $key =~ /^MT::ContentData#\d+$/ ) {
            push @content_data, $all_objects->{$key};
        }
    }

    my $i = 0;
    $callback->(
        MT->translate( "Importing asset associations ... ( [_1] )", $i++ ),
        'cb-restore-entry-asset'
    );
    for my $obj_id ( keys %entries ) {
        my $entry = $entries{$obj_id};

        my @placements = MT->model('objectasset')->load(
            {   object_id => $obj_id,
                object_ds => 'entry',
                blog_id   => $entry->blog_id
            }
        );
        next unless @placements;

        my %related;
        for my $placement (@placements) {
            my $asset_hash = $assets{ $placement->asset_id };
            next unless $asset_hash;
            $related{ $asset_hash->{old_id} } = $asset_hash->{object};
        }

        if ( $entry->class == 'entry' ) {
            $callback->(
                MT->translate(
                    "Importing asset associations in entry ... ( [_1] )",
                    $i++
                ),
                'cb-restore-entry-asset'
            );
        }
        else {
            $callback->(
                MT->translate(
                    "Importing asset associations in page ... ( [_1] )", $i++
                ),
                'cb-restore-entry-asset'
            );
        }

        for my $col (qw( text text_more )) {
            my $text = $entry->$col;
            next unless $text;
            $text = _sync_asset_id( $text, \%related );
            $entry->$col($text);
        }
        $entry->update()
            ;    # directly call update to bypass processing in save()
    }
    $callback->( MT->translate("Done.") . "\n" );

    $i = 0;
    $callback->(
        MT->translate( "Importing content data ... ( [_1] )", $i++ ),
        'cb-restore-content-data-data'
    );
    for my $content_data (@content_data) {
        my $old_data     = $content_data->data;
        my $content_type = $content_types{ $content_data->content_type_id };
        my %new_data;
        for my $old_field_id ( keys %{ $old_data || {} } ) {
            my $new_field = $all_objects->{"MT::ContentField#$old_field_id"}
                or next;
            $new_data{ $new_field->id } = $old_data->{$old_field_id};
            my $field_data = $content_type->get_field( $new_field->id );
            my $field_type_registry
                = MT->registry( 'content_field_types', $field_data->{type} );
            if ( my $handler
                = $field_type_registry->{site_data_import_handler} )
            {
                if ( $handler = MT->handler_to_coderef($handler) ) {
                    $new_data{ $new_field->id } = $handler->(
                        $field_data, $new_data{ $new_field->id },
                        $content_data, $all_objects
                    );
                }
            }
        }
        $content_data->data( \%new_data );

        if ( my $raw_convert_breaks = $content_data->convert_breaks ) {
            if ( my $convert_breaks
                = MT::Serialize->unserialize($raw_convert_breaks) )
            {
                if (   $convert_breaks
                    && $$convert_breaks
                    && ref $$convert_breaks eq 'HASH' )
                {
                    my %new_convert_breaks;
                    for my $old_field_id ( keys %{$$convert_breaks} ) {
                        my $new_field
                            = $all_objects->{"MT::ContentField#$old_field_id"}
                            or next;
                        $new_convert_breaks{ $new_field->id }
                            = $$convert_breaks->{$old_field_id};
                    }
                    my $new_raw_conver_breaks
                        = MT::Serialize->serialize( \{%new_convert_breaks} );
                    $content_data->convert_breaks($new_raw_conver_breaks);
                }
            }
        }

        if ( MT->component('BlockEditor') ) {
            require BlockEditor::BackupRestore;
            BlockEditor::BackupRestore->update_cd_block_editor_data(
                $content_data, $all_objects );
        }

        $callback->(
            MT->translate( "Importing content data ... ( [_1] )", $i++ ),
            'cb-restore-content-data-data'
        );
        $content_data->save or die $content_data->errstr;
    }
    $callback->( MT->translate("Done.") . "\n" );

    $i = 0;
    $callback->(
        MT->translate( "Rebuilding permissions ... ( [_1] )", $i++ ),
        'cb-restore-permission'
    );
    my $iter = MT->model('permission')->load_iter;
    while ( my $permission = $iter->() ) {
        $permission->permissions('');
        $permission->rebuild;
        $callback->(
            MT->translate( "Rebuilding permissions ... ( [_1] )", $i++ ),
            'cb-restore-permission'
        );
    }
    $callback->( MT->translate("Done.") . "\n" );

    1;
}

sub _sync_asset_url {
    my ( $text, $asset ) = @_;

    my $filename = quotemeta( encode_url( $asset->file_name ) );
    my $url      = $asset->url;
    my $id       = $asset->id;
    my @children
        = MT->model('asset')
        ->load(
        { parent => $asset->id, blog_id => $asset->blog_id, class => '*' } );
    my %children = map {
        $_->id => {
            'filename' => quotemeta( encode_url( $_->file_name ) ),
            'url'      => $_->url
            }
    } @children;

    $text
        =~ s!<form([^>]*?\s)mt:asset-id=(["'])$id(["'])([^>]*?)>(.+?)</form>!
        my $result = '<form' . $1 . 'mt:asset-id=' . $2 . $id . $3 . $4 . '>';
        my $html = $5;
        $html =~ s#<a([^>]*? )href=(["'])[^>]+?/$filename(["'])([^>]*?)>#<a$1href=$2$url$3$4>#gim;
        $html =~ s#<img([^>]*? )src=(["'])[^>]+?/$filename(["'])([^>]*?)(/? *)>#<img$1src=$2$url$3$4$5>#gim;
        if ( %children ) {
            for my $child (values %children) {
                my $child_filename = $child->{filename};
                my $child_url = $child->{url};
                $html =~ s#<img([^>]*? )src=(["'])[^>]+?/$child_filename(["'])([^>]*?)>#<img$1src=$2$child_url$3$4>#gim;
                $html =~ s#<a([^>]*? )href=(["'])[^>]+?/$child_filename(["'])([^>]*?)>#<a$1href=$2$child_url$3$4>#gim;
                $html =~ s#<a([^>]*? )onclick=(["'])[^>]+?/$child_filename(["'])([^>]*?)>#<a$1onclick=$2$child_url$3$4>#gim;
            }
        }
        $result .= $html . '</form>';
        $result;
    !igem;
    $text;
}

sub cb_restore_asset {
    my $pkg = shift;
    my ( $asset, $callback ) = @_;

    my @placements = MT->model('objectasset')->load(
        {   asset_id  => $asset->id,
            object_ds => 'entry',
            blog_id   => $asset->blog_id
        }
    );

    my $i = 0;
    $callback->(
        MT->translate( 'Importing url of the assets ( [_1] )...', $i++ ),
        'cb-restore-asset-url'
    );
    for my $placement (@placements) {
        my $entry = MT->model('entry')->load( $placement->object_id );
        next unless $entry;

        if ( $entry->class eq 'entry' ) {
            $callback->(
                MT->translate(
                    'Importing url of the assets in entry ( [_1] )...', $i++
                ),
                'cb-restore-asset-url'
            );
        }
        else {
            $callback->(
                MT->translate(
                    'Importing url of the assets in page ( [_1] )...', $i++
                ),
                'cb-restore-asset-url'
            );
        }
        for my $col (qw( text text_more )) {
            my $text = $entry->$col;
            next unless $text;
            $text = _sync_asset_url( $text, $asset );
            $entry->$col($text);
        }
        $entry->update()
            ;    # directly call update to bypass processing in save()
    }
    $callback->( MT->translate("Done.") . "\n" );
    1;
}

sub _restore_asset_multi {
    my $class = shift;
    my ( $asset_element, $objects, $errors, $callback, $blogs_meta ) = @_;

    my $old_id = $asset_element->{asset_id};
    if ( !defined($old_id) ) {
        $callback->( MT->translate('ID for the file was not set.') );
        return 0;
    }
    my $asset_class = MT->model('asset');
    my $asset       = $objects->{"$asset_class#$old_id"};
    unless ( defined($asset) ) {
        $callback->(
            MT->translate( 'The file ([_1]) was not imported.', $old_id ) );
        return 0;
    }

    my $fmgr;
    if ( exists $blogs_meta->{ $asset->blog_id } ) {
        my $blog = MT->model('blog')->load( $asset->blog_id )
            or return 0;

        my $meta = $blogs_meta->{ $asset->blog_id };
        my $path = $asset->file_path;
        my $url  = $asset->url;
        if ( my $archive_path = $meta->{'archive_path'} ) {
            my $old_archive_path = $meta->{'old_archive_path'};
            $path =~ s/\Q$old_archive_path\E/$archive_path/i;
            $asset->file_path($path);
        }
        if ( my $archive_url = $meta->{'archive_url'} ) {
            my $old_archive_url = $meta->{'old_archive_url'};
            $url =~ s/\Q$old_archive_url\E/$archive_url/i;
            $asset->url($url);
        }
        if ( my $site_path = $meta->{'site_path'} ) {
            my $old_site_path = $meta->{'old_site_path'};
            $path =~ s/\Q$old_site_path\E/$site_path/i;
            $asset->file_path($path);
        }
        if ( my $site_url = $meta->{'site_url'} ) {
            my $old_site_url = $meta->{'old_site_url'};
            $url =~ s/\Q$old_site_url\E/$site_url/i;
            $asset->url($url);
        }
        $callback->(
            MT->translate(
                "Changing path for the file '[_1]' (ID:[_2])...",
                $asset->label, $asset->id
            )
        );
        $asset->save or $callback->( MT->translate("failed") . "\n" );
        $callback->( MT->translate("ok") . "\n" );

        $fmgr = $blog->file_mgr;
    }
    my $file = $asset_element->{fh};
    $class->restore_asset( $file, $asset, $old_id, $fmgr, $errors,
        $callback );
}

package MT::Object;

sub _is_element {
    my $obj = shift;
    my ($def) = @_;
    return (   ( 'text' eq $def->{type} )
            || ( ( 'string' eq $def->{type} ) && ( 255 < $def->{size} ) ) )
        ? 1
        : 0;
}

sub to_xml {
    my $obj = shift;
    my ( $namespace, $metacolumns ) = @_;

    my $coldefs  = $obj->column_defs;
    my $colnames = $obj->column_names;
    my $xml;

    my $elem = $obj->datasource;
    unless ( UNIVERSAL::isa( $obj, 'MT::Log' ) ) {
        if ( $obj->properties
            && ( my $ccol = $obj->properties->{class_column} ) )
        {
            if ( my $class = $obj->$ccol ) {

                # use class_type value instead if
                # the value resolves to a Perl package
                $elem = $class
                    if defined( MT->model($class) );
            }
        }
    }

    $xml = '<' . $elem;
    $xml .= " xmlns='$namespace'" if defined($namespace) && $namespace;

    my ( @elements, @blobs, @meta );
    for my $name (@$colnames) {
        if ($obj->column($name)
            || ( defined( $obj->column($name) )
                && ( '0' eq $obj->column($name) ) )
            )
        {
            if ( ( $obj->properties->{meta_column} || '' ) eq $name ) {
                push @meta, $name;
                next;
            }
            elsif ( $obj->_is_element( $coldefs->{$name} ) ) {
                push @elements, $name;
                next;
            }
            elsif ( 'blob' eq $coldefs->{$name}->{type} ) {
                push @blobs, $name;
                next;
            }
            $xml .= " $name='"
                . MT::Util::encode_xml( $obj->column($name), 1, 1 ) . "'";
        }
    }
    my ( @meta_elements, @meta_blobs );
    if ( defined($metacolumns) && @$metacolumns ) {
        foreach my $metacolumn (@$metacolumns) {
            my $name = $metacolumn->{name};
            if ( $obj->$name
                || ( defined( $obj->$name ) && ( '0' eq $obj->$name ) ) )
            {
                if ( 'vclob' eq $metacolumn->{type} ) {
                    push @meta_elements, $name;
                }
                elsif ( 'vblob' eq $metacolumn->{type} ) {
                    push @meta_blobs, $name;
                }
                else {
                    $xml .= " $name='"
                        . MT::Util::encode_xml( $obj->$name, 1, 1 ) . "'";
                }
            }
        }
    }
    $xml .= '>';
    $xml .= "<$_>" . MT::Util::encode_xml( $obj->column($_), 1, 1 ) . "</$_>"
        foreach @elements;
    require MIME::Base64;
    foreach my $blob_col (@blobs) {
        my $val = $obj->column($blob_col);
        if ( substr( $val, 0, 4 ) eq 'SERG' ) {
            $xml
                .= "<$blob_col>"
                . MIME::Base64::encode_base64( $val, '' )
                . "</$blob_col>";
        }
        else {
            $xml .= "<$blob_col>"
                . MIME::Base64::encode_base64(
                Encode::encode( MT->config->PublishCharset, $val ), '' )
                . "</$blob_col>";
        }
    }
    foreach my $meta_col (@meta) {
        my $hashref = $obj->$meta_col;
        $xml .= "<$meta_col>"
            . MIME::Base64::encode_base64(
            MT::Serialize->serialize( \$hashref ), '' )
            . "</$meta_col>";
    }
    $xml .= "<$_>" . MT::Util::encode_xml( $obj->$_, 1, 1 ) . "</$_>"
        foreach @meta_elements;
    foreach my $vblob_col (@meta_blobs) {
        my $vblob = $obj->$vblob_col;
        $xml .= "<$vblob_col>"
            . MIME::Base64::encode_base64(
            MT::Serialize->serialize( \$vblob ), '' )
            . "</$vblob_col>";
    }
    $xml .= '</' . $elem . '>';
    $xml;
}

sub parents {
    my $obj = shift;
    {};
}

sub _restore_id {
    my $obj = shift;
    my ( $key, $val, $data, $objects ) = @_;

    return 0 unless 'ARRAY' eq ref($val);
    return 1 unless $data->{$key};

    my $new_obj;
    my $old_id = $data->{$key};
    foreach (@$val) {
        $new_obj = $objects->{"$_#$old_id"};
        last if $new_obj;
    }
    return 0 unless $new_obj;
    $data->{$key} = $new_obj->id;
    return 1;
}

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;

    my $parents = $obj->parents;
    my $count   = scalar( keys %$parents );

    my $done = 0;
    while ( my ( $key, $val ) = each(%$parents) ) {
        $val = [$val] unless ( ref $val );
        if ( 'ARRAY' eq ref($val) ) {
            $done += $obj->_restore_id( $key, $val, $data, $objects );
        }
        elsif ( 'HASH' eq ref($val) ) {
            my $v = $val->{class};
            $v = [$v] unless ( ref $v );
            my $result = 0;
            if ( my $relations = $val->{relations} ) {
                my $col = $relations->{key};
                my $ds  = $data->{$col};
                my $ev  = $relations->{ $ds . '_id' };
                $ev = MT->model($ds) unless $ev;
                return 0 unless $ev;
                $ev = [$ev] unless ( ref $ev );
                $done += $obj->_restore_id( $key, $ev, $data, $objects );
            }
            else {
                $result = $obj->_restore_id( $key, $v, $data, $objects );
                $result = 1 if exists( $val->{optional} ) && $val->{optional};
                $data->{$key} = -1
                    if !$result
                    && ( exists( $val->{orphanize} )
                    && $val->{orphanize} );
                $done += $result;
            }
        }
    }
    ( $count == $done ) ? 1 : 0;
}

package MT::Website;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            terms => { 'id' => $blog_ids, class => 'website' },
            args  => undef,
        };
    }
    else {
        return { terms => undef, args => undef };
    }
}

package MT::Blog;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    my $column     = 'id';
    my $blog_class = MT->model('blog');
    if ( my @blogs = $blog_class->load(@$blog_ids) ) {
        my $is_blog;
        foreach my $blog (@blogs) {
            $is_blog = 1, last
                if $blog->is_blog();
        }
        $column = 'parent_id'
            if !$is_blog;
    }

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            terms => { $column => $blog_ids, class => 'blog' },
            args  => undef,
        };
    }
    else {
        return { terms => { class => 'blog' }, args => undef };
    }
}

sub parents {
    my $obj = shift;
    { parent_id => MT->model('website'), };
}

package MT::Tag;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            terms => undef,
            args  => {
                'join' => [
                    'MT::ObjectTag', 'tag_id',
                    { blog_id => $blog_ids }, { unique => 1 }
                ]
            }
        };
    }
    else {
        return { terms => undef, args => undef };
    }
}

package MT::Role;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    unless ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return { terms => undef, args => undef };
    }

    my %role_id;
    my $iter = MT->model('role')->load_iter(
        undef,
        {   'join' => MT->model('association')->join_on(
                'role_id',
                { blog_id => $blog_ids },
                { unique  => 1 }
            )
        }
    );
    while ( my $role = $iter->() ) {
        $role_id{ $role->id } = 1;
    }

    my ( %content_type_uid_role, %content_field_uid_role );
    $iter = MT->model('role')->load_iter;
    while ( my $role = $iter->() ) {
        my $content_type_uids = MT::BackupRestore::ContentTypePermission
            ->get_content_type_uids( $role->permissions );
        $content_type_uid_role{$_} = $role->id for @$content_type_uids;
        my $content_field_uids = MT::BackupRestore::ContentTypePermission
            ->get_content_field_uids( $role->permissions );
        $content_field_uid_role{$_} = $role->id for @$content_field_uids;
    }

    if (%content_type_uid_role) {
        my $ct_iter = MT->model('content_type')->load_iter(
            {   blog_id   => $blog_ids,
                unique_id => [ keys %content_type_uid_role ],
            }
        );
        while ( my $content_type = $ct_iter->() ) {
            $role_id{ $content_type_uid_role{ $content_type->unique_id } }
                = 1;
        }
    }

    if (%content_field_uid_role) {
        my $cf_iter = MT->model('content_field')->load_iter(
            {   blog_id   => $blog_ids,
                unique_id => [ keys %content_field_uid_role ]
            }
        );
        while ( my $content_field = $cf_iter->() ) {
            $role_id{ $content_field_uid_role{ $content_field->unique_id } }
                = 1;
        }
    }

    my $role_ids = %role_id ? [ keys %role_id ] : 0;
    { terms => { id => $role_ids }, args => undef };
}

package MT::Asset;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            terms => {
                'blog_id' => $blog_ids,
                'class'   => $class->properties->{class_type}
            },
            args => undef
        };
    }
    else {
        return {
            terms => { 'class' => $class->properties->{class_type} },
            args  => undef
        };
    }
}

sub parents {
    my $obj = shift;
    {   blog_id => [ MT->model('blog'), MT->model('website') ],
        parent  => MT->model('asset')
    };
}

package MT::PluginData;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        my @terms;
        foreach my $id (@$blog_ids) {
            push @terms, '-or' if @terms;
            push @terms, { key => { like => "configuration:blog:$id%" } };
        }
        push @terms, '-or' if @terms;
        push @terms, { key => { not_like => "%blog:%" } };
        return {
            terms => \@terms,
            args  => undef
        };
    }
    else {
        return { terms => undef, args => undef };
    }
}

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;

    if ( $data->{key} =~ /^configuration:blog:(\d+)$/i ) {
        my $new_blog = $objects->{ 'MT::Blog#' . $1 };
        $new_blog = $objects->{ 'MT::Website#' . $1 }
            unless $new_blog;

        if ($new_blog) {
            $data->{key} = 'configuration:blog:' . $new_blog->id;
        }
    }
    return 1;
}

package MT::Association;

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;

    my ( $author, $blog, $group, $role ) = ( 0, 0, 0, 0 );

    my $processor = sub {
        my ($elem)  = @_;
        my $class   = MT->model($elem);
        my $old_id  = $data->{ $elem . '_id' };
        my $new_obj = $objects->{"$class#$old_id"};
        if ( !$new_obj && $class->isa('MT::Blog') ) {
            $class   = MT->model('website');
            $new_obj = $objects->{"$class#$old_id"};
        }
        return 0 unless defined($new_obj) && $new_obj;
        $data->{ $elem . '_id' } = $new_obj->id;
        return 1;
    };

    $author = $processor->('author');
    $group  = $processor->('group');
    $blog = $processor->('blog');
    $role = $processor->('role');

    # Combination allowed are:
    # USER_BLOG_ROLE  => 1;
    # GROUP_BLOG_ROLE => 2;
    # USER_GROUP      => 3;
    # USER_ROLE       => 4;
    # GROUP_ROLE      => 5;

    ( $author && $group )
        || ( $author && $role )
        || ( $group  && $role )
        ? 1
        : 0;    # || ($author && $blog && $role) || ($group && $blog && $role)
}

package MT::Category;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            terms => {
                blog_id         => $blog_ids,
                category_set_id => '*',
            },
            args => undef,
        };
    }
    else {
        return {
            terms => { category_set_id => '*' },
            args  => undef,
        };
    }
}

sub parents {
    my $obj = shift;
    {   blog_id => [ MT->model('blog'),     MT->model('website') ],
        parent  => [ MT->model('category'), MT->model('folder') ],
        category_set_id =>
            { class => MT->model('category_set'), optional => 1 },
    };
}

package MT::CategorySet;

sub parents {
    my $obj = shift;
    { blog_id => [ MT->model('blog'), MT->model('website') ], };
}

package MT::ContentType;

sub parents {
    my $obj = shift;
    { blog_id => [ MT->model('blog'), MT->model('website') ] };
}

package MT::ContentField;

sub parents {
    my $obj = shift;
    {   blog_id => [ MT->model('blog'), MT->model('website') ],
        content_type_id => [ MT->model('content_type') ],
        related_content_type_id =>
            { class => MT->model('content_type'), optional => 1 },
        related_cat_set_id =>
            { class => MT->model('category_set'), optional => 1 },
    };
}

package MT::ContentData;

sub parents {
    my $obj = shift;
    {   blog_id => [ MT->model('blog'), MT->model('website') ],
        author_id =>
            { class => MT->model('author'), optional => 1, orphanize => 1 },
        content_type_id => [ MT->model('content_type') ],
    };
}

package MT::Comment;

sub parents {
    my $obj = shift;
    {   entry_id => [ MT->model('entry'), MT->model('page') ],
        blog_id  => [ MT->model('blog'),  MT->model('website') ],
        commenter_id => { class => MT->model('author'), optional => 1 },
    };
}

package MT::Entry;

sub parents {
    my $obj = shift;
    {   blog_id => [ MT->model('blog'), MT->model('website') ],
        author_id =>
            { class => MT->model('author'), optional => 1, orphanize => 1 },
    };
}

package MT::FileInfo;

sub parents {
    my $obj = shift;
    {   entry_id => {
            class    => [ MT->model('entry'), MT->model('page') ],
            optional => 1
        },
        blog_id => {
            class    => [ MT->model('blog'), MT->model('website') ],
            optional => 1
        },
        templatemap_id =>
            { class => MT->model('templatemap'), optional => 1 },
        template_id => { class => MT->model('template'), optional => 1 },
        category_id => {
            class    => [ MT->model('category'), MT->model('folder') ],
            optional => 1
        },
        author_id => { class => MT->model('author'), optional => 1 },
    };
}

package MT::Notification;

sub parents {
    my $obj = shift;
    { blog_id => [ MT->model('blog'), MT->model('website') ], };
}

package MT::ObjectTag;

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;

    if ( $data->{blog_id} ||= 0 ) {
        my $blog_class = MT->model('blog');
        my $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        if ( !$new_blog ) {
            $blog_class = MT->model('website');
            $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        }
        return 0 if !$new_blog;
        $data->{blog_id} = $new_blog->id;
    }

    my $tag_class = MT->model('tag');
    my $new_tag   = $objects->{ $tag_class . '#' . $data->{tag_id} }
        or return 0;
    $data->{tag_id} = $new_tag->id;

    my $object_id_class = MT->model( $data->{object_datasource} ) or return 0;
    my $new_object_id_object
        = $objects->{ $object_id_class . '#' . $data->{object_id} };
    if ( !$new_object_id_object ) {
        if ( $data->{object_datasource} eq 'entry' ) {
            $object_id_class = MT->model('page');
        }
        else {
            return 0;
        }
        $new_object_id_object
            = $objects->{ $object_id_class . '#' . $data->{object_id} }
            or return 0;
    }
    $data->{object_id} = $new_object_id_object->id;

    if ( $data->{cf_id} ||= 0 ) {
        my $content_field_class = MT->model('content_field');
        my $new_content_field
            = $objects->{ $content_field_class . '#' . $data->{cf_id} }
            or return 0;
        $data->{cf_id} = $new_content_field->id;
    }

    1;
}

sub parents {
    my $obj = shift;
    {   blog_id   => [ MT->model('blog'), MT->model('website') ],
        tag_id    => MT->model('tag'),
        cf_id     => MT->model('content_field'),
        object_id => {
            relations => {
                key             => 'object_datasource',
                entry_id        => [ MT->model('entry'), MT->model('page') ],
                content_data_id => MT->model('content_data'),
            }
        }
    };
}

package MT::Permission;

sub parents {
    my $obj = shift;
    {   blog_id => [ MT->model('blog'), MT->model('website') ],
        author_id => { class => MT->model('author'), optional => 1 },
    };
}

package MT::Placement;

sub parents {
    my $obj = shift;
    {   category_id => [ MT->model('category'), MT->model('folder') ],
        blog_id     => [ MT->model('blog'),     MT->model('website') ],
        entry_id    => [ MT->model('entry'),    MT->model('page') ],
    };
}

package MT::TBPing;

sub parents {
    my $obj = shift;
    {   blog_id => [ MT->model('blog'), MT->model('website') ],
        tb_id   => MT->model('trackback'),
    };
}

package MT::Template;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            terms => { 'blog_id' => $blog_ids },
            args => { sort => [ { column => 'type' }, { column => 'id' } ] },
        };
    }
    else {
        return {
            terms => undef,
            args  => { sort => [ { column => 'type' }, { column => 'id' } ] },
        };
    }
}

sub parents {
    my $obj = shift;
    {   blog_id => [ MT->model('blog'), MT->model('website') ],
        content_type_id =>
            { class => MT->model('content_type'), optional => 1 },
    };
}

package MT::TemplateMap;

sub parents {
    my $obj = shift;
    {   blog_id     => [ MT->model('blog'), MT->model('website') ],
        template_id => MT->model('template'),
        cat_field_id =>
            { class => MT->model('content_field'), optional => 1 },
        dt_field_id => { class => MT->model('content_field'), optional => 1 },
    };
}

package MT::Trackback;

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;

    my $result     = 0;
    my $blog_class = MT->model('blog');
    my $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
    if ( !$new_blog ) {
        $blog_class = MT->model('website');
        $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
    }
    return 0 if !$new_blog;
    $data->{blog_id} = $new_blog->id;
    if ( my $cid = $data->{category_id} ) {
        my $cat_class = MT->model('category');
        my $new_obj   = $objects->{ $cat_class . '#' . $cid };
        unless ($new_obj) {
            $cat_class = MT->model('folder');
            $new_obj   = $objects->{ $cat_class . '#' . $cid };
        }
        if ($new_obj) {
            $data->{category_id} = $new_obj->id;
            $result = 1;
        }
    }
    elsif ( my $eid = $data->{entry_id} ) {
        my $entry_class = MT->model('entry');
        my $new_obj     = $objects->{ $entry_class . '#' . $eid };
        unless ($new_obj) {
            $entry_class = MT->model('page');
            $new_obj     = $objects->{ $entry_class . '#' . $eid };
        }
        if ($new_obj) {
            $data->{entry_id} = $new_obj->id;
            $result = 1;
        }
    }
    $result;
}

sub parents {
    my $obj = shift;
    {   blog_id     => [ MT->model('blog'),     MT->model('website') ],
        entry_id    => [ MT->model('entry'),    MT->model('page') ],
        category_id => [ MT->model('category'), MT->model('folder') ],
    };
}

package MT::ObjectAsset;

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;

    if ( $data->{blog_id} ||= 0 ) {
        my $blog_class = MT->model('blog');
        my $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        if ( !$new_blog ) {
            $blog_class = MT->model('website');
            $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        }
        return 0 if !$new_blog;
        $data->{blog_id} = $new_blog->id;
    }

    my $asset_class = MT->model('asset');
    my $new_asset   = $objects->{ $asset_class . '#' . $data->{asset_id} };
    return 0 if !$new_asset;
    $data->{asset_id} = $new_asset->id;

    my $object_id_class = MT->model( $data->{object_ds} ) or return 0;
    my $new_object_id_object
        = $objects->{ $object_id_class . '#' . $data->{object_id} };
    if ( !$new_object_id_object ) {
        if ( $data->{object_ds} eq 'blog' ) {
            $object_id_class = MT->model('website');
        }
        elsif ( $data->{object_ds} eq 'entry' ) {
            $object_id_class = MT->model('page');
        }
        elsif ( $data->{object_ds} eq 'category' ) {
            $object_id_class = MT->model('folder');
        }
        else {
            return 0;
        }
        $new_object_id_object
            = $objects->{ $object_id_class . '#' . $data->{object_id} }
            or return 0;
    }
    $data->{object_id} = $new_object_id_object->id;

    if ( $data->{cf_id} ||= 0 ) {
        my $content_field_class = MT->model('content_field');
        my $new_content_field
            = $objects->{ $content_field_class . '#' . $data->{cf_id} }
            or return 0;
        $data->{cf_id} = $new_content_field->id;
    }

    1;
}

sub parents {
    my $obj = shift;
    {   blog_id   => [ MT->model('blog'), MT->model('website') ],
        asset_id  => MT->model('asset'),
        cf_id     => MT->model('content_field'),
        object_id => {
            relations => {
                key         => 'object_ds',
                entry_id    => [ MT->model('entry'), MT->model('page') ],
                category_id => [ MT->model('category'), MT->model('folder') ],
                blog_id     => [ MT->model('blog'), MT->model('website') ],
                content_data_id => [ MT->model('content_data') ],
            }
        }
    };
}

package MT::ObjectCategory;

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;

    if ( $data->{blog_id} ||= 0 ) {
        my $blog_class = MT->model('blog');
        my $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        if ( !$new_blog ) {
            $blog_class = MT->model('website');
            $new_blog   = $objects->{ $blog_class . '#' . $data->{blog_id} };
        }
        return 0 if !$new_blog;
        $data->{blog_id} = $new_blog->id;
    }

    my $category_class = MT->model('category');
    my $new_category
        = $objects->{ $category_class . '#' . $data->{category_id} };
    if ( !$new_category ) {
        $category_class = MT->model('folder');
        $new_category
            = $objects->{ $category_class . '#' . $data->{category_id} };
    }
    return 0 unless $new_category;
    $data->{category_id} = $new_category->id;

    my $object_id_class = MT->model( $data->{object_ds} ) or return 0;
    my $new_object_id_object
        = $objects->{ $object_id_class . '#' . $data->{object_id} };
    if ( !$new_object_id_object ) {
        if ( $data->{object_ds} eq 'entry' ) {
            $object_id_class = MT->model('page');
        }
        else {
            return 0;
        }
        $new_object_id_object
            = $objects->{ $object_id_class . '#' . $data->{object_id} }
            or return 0;
    }
    $data->{object_id} = $new_object_id_object->id;

    if ( $data->{cf_id} ||= 0 ) {
        my $content_field_class = MT->model('content_field');
        my $new_content_field
            = $objects->{ $content_field_class . '#' . $data->{cf_id} }
            or return 0;
        $data->{cf_id} = $new_content_field->id;
    }

    1;
}

sub parents {
    my $obj = shift;
    {   blog_id     => [ MT->model('blog'),     MT->model('website') ],
        category_id => [ MT->model('category'), MT->model('folder') ],
        cf_id       => MT->model('content_field'),
        object_id   => {
            relations => {
                key             => 'object_ds',
                entry_id        => [ MT->model('entry'), MT->model('page') ],
                content_data_id => MT->model('content_data'),
            },
        },
    };
}

package MT::ObjectScore;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    # authors are processed in _populate_obj_to_backup method
    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return {
            terms => { object_ds => [ 'entry', 'page' ], },
            args  => {
                'join' => MT->model('entry')->join_on(
                    undef,
                    {   id      => \'=objectscore_object_id',
                        blog_id => $blog_ids,
                    },
                    { unique => 1, }
                )
            }
        };
    }
    return { terms => undef, args => undef };
}

sub parents {
    my $obj = shift;
    {   author_id => MT->model('author'),
        object_id => {
            relations => {
                key      => 'object_ds',
                entry_id => [ MT->model('entry'), MT->model('page') ],
            }
        }
    };
}

package MT::IPBanList;

sub parents {
    my $obj = shift;
    { blog_id => [ MT->model('blog'), MT->model('website') ], };
}

package MT::Blocklist;

sub parents {
    my $obj = shift;
    { blog_id => [ MT->model('blog'), MT->model('website') ], };
}

package MT::Filter;

sub restore_parent_ids {
    my $obj = shift;
    my ( $data, $objects ) = @_;
    my $new_blog = $objects->{ 'MT::Blog#' . $data->{blog_id} };
    $new_blog = $objects->{ 'MT::Website#' . $data->{blog_id} }
        unless $new_blog;

    if ($new_blog) {
        $data->{blog_id} = $new_blog->id;
        $obj->blog_id( $data->{blog_id} );
    }

    # Old author_id is changed to new author_id.
    my $old_author_id  = $data->{'author_id'};
    my $new_author_obj = $objects->{"MT::Author#$old_author_id"};
    if ( defined($new_author_obj) && $new_author_obj ) {
        $data->{'author_id'} = $new_author_obj->id;
    }

    return 1;
}

sub parents {
    my $obj = shift;
    {   author_id => { class => MT->model('author'), optional => 1 },
        blog_id   => { class => MT->model('blog'),   optional => 1 },
    };
}

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    # Only the filter belonging to specified
    # websites and blogs are extracted.
    my $terms = undef;
    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        $terms = { blog_id => $blog_ids };
    }

    return {
        terms => $terms,
        args  => {
            join => [
                MT->model('author'), undef,
                { id => \'=filter_author_id' }, { unique => 1 }
            ],
        },
    };
}

1;
__END__

=head1 NAME

MT::BackupRestore

=head1 METHODS

=head2 backup

TODO Backup I<MT::Tag>, I<MT::Author>, I<MT::Blog>, I<MT::Role>, 
I<MT::Category>, I<MT::Asset>, and I<MT::Entry>.  Each object will
be back up by MT::Object#to_xml call, which will do the actual
Object ==>> XML serialization.

=head2 restore_file

TODO Restore MT system from an XML file which contains MT backup
information (created by backup subroutine).

=head2 restore_process_single_file

TODO A method which will do the actual heavy lifting of the
process to restore objects from an XML file.  Returns array of blog_ids
which are restored in the very session, and hash of asset_ids.

=head2 restore_directory

TODO A method which reads specified directory, find a manifest file,
and do the multi-file restore operation directed by the manifest file.

=head2 restore_object_asset

Accepts an asset object just restored, populate associated entries,
and scan text and text_more for each entry.  If association marker
(<form> tag) is found, replace asset id and URL to the new ones.

=head2 restore_asset

TODO A method which restores the assets' actual files to the
specified directory.  It also creates subdirectory by request.

=head2 process_manifest

TODO A method which is called from MT::App::CMS to process an uploaded
manifest file which is to be the source of the multi-file restore
operation in the MT::App::CMS.

=head1 Callbacks

For plugins which uses MT::Object-derived types, backup and restore
operation call callbacks for plugins to inject XMLs so they are
also backup, and read XML to restore objects so they are also restored.

Callbacks called by the package are as follows:

=over 4

=item Backup

Deprecated. please use the 'backup.plugin_objects' callback
    
Calling convention is:

    callback($cb, $blog_ids, $progress)

The callback is used for MT::Object-derived types used by plugins
to be backup.  The callback must return the object's XML representation
in a string, or 1 for nothing.  $blog_ids has an ARRAY reference to
blog_ids which indicates what weblog a user chose to backup.  It may
be an empty array if a user chose Everything.  $progress is a CODEREF
used to report progress to the user.

If a plugin has an MT::Object derived type, the plugin will register 
a callback to Backup callback, and Backup process will call the callbacks
to give plugins a chance to add their own data to the backup file.
Otherwise, plugin's object classes is likely be ignored in backup operation.

=item backup.plugin_objects

Calling convention is:

    callback($cb, $blog_ids, $progress, $else_xml, $backuped_objs)

$blog_ids has an ARRAY reference to blog_ids which indicates what weblog 
a user chose to backup.  It may be an empty array if a user chose 
Everything.  $progress is a CODEREF used to report progress to the user.
$backuped_objs is a hash-ref, whose keys are classes, and values are arrays
containing IDs of objects of this class that were already backuped

The result of this callback should be an XML part to be included in the 
backup XML. Please push your results into @$else_xml (which is an array-ref)

=item Restore.<element_name>:<xmlnamespace>

Restore callbacks are called in convention like below:

    callback($cb, $data, $objects, $deferred, $callback);

Where $data is a parameter which was passed to XML::SAX::Base's 
start_element callback method.

$objects is an hash reference which contains all the restored objects
in the restore session.  The hash keys are stored in the format
MT::ObjectClassName#old_id, and hash values are object reference
of the actually restored objects (with new id).  Old ids are ids
which are stored in the XML files, while new ids are ids which
are restored.

$deferred is an hash reference which contains information about
restore-deferred objects.  Deferred objects are those objects
which appeared in the XMl file but could not be restored because
any parent objects are missing.  The hash keys are stored in
the format MT::ObjectClassName#old_id and hash values are 1.

$callback is a code reference which will print out the passed parameter.
Callback method can use this to communicate with users.

If a plugin has an MT::Object derived type, the plugin will register 
a callback to Restore.<element_name>:<xmlnamespace> callback, 
so later the restore operation will call the callback function with 
parameters described above.  XML Namespace is required to be registered, 
so an xml node can be resolved into what plugins to be called back, 
and can be distinguished the same element name with each other.

=item restore
    
Calling convention is:

    callback($cb, $objects, $deferred, $errors, $callback);

This callback is called when all of the XML files in the particular
restore session are restored, thus, when $objects and $deferred
would not have any more objects in them.  This callback is useful
for object classes which have relationships with other classes,
for the kind of classes may not be able to handle relationship
correctly until the associated objects would be successfully
restored.

NOTE that this callback is called BEFORE blogs' site_path and
site_url are updated.  Therefore, blog objects and other objects
which contains path information such as assets still have old
url and path in I<$objects>.

$objects is an hash reference which contains all the restored objects
in the restore session.  The hash keys are stored in the format
MT::ObjectClassName#old_id, and hash values are object reference
of the actually restored objects (with new id).  Old ids are ids
which are stored in the XML files, while new ids are ids which
are restored.

$deferred is an hash reference which contains information about
restore-deferred objects.  Deferred objects are those objects
which appeared in the XMl file but could not be restored because
any parent objects are missing.  The hash keys are stored in
the format MT::ObjectClassName#old_id and hash values are 1.

$callback is a code reference which will print out the passed parameter.
Callback method can use this to communicate with users.

=item restore_asset
    
Calling convention is:

    callback($cb, $asset, $callback);

This callback is called when asset's actual file is restored.
$asset has new url and path.

$callback is a code reference which will print out the passed parameter.
Callback method can use this to communicate with users.

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
