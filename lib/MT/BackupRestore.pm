# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::BackupRestore;
use strict;

use Symbol;
use base qw( MT::ErrorHandler );

use constant NS_MOVABLETYPE => 'http://www.sixapart.com/ns/movabletype';

use File::Spec;
use File::Copy;

sub _populate_obj_to_backup {
    my $pkg = shift;
    my ($blog_ids, $skip, $later) = @_;

    my %populated;
    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        # author will be handled at last
        $populated{MT->model('author')} = 1;
    }

    my @obj_to_backup;
    my $types = MT->registry('object_types');
    foreach my $key (keys %$types) {
        next if $key =~ /\w+\.\w+/; # skip subclasses
        my $class = MT->model($key);
        next unless $class;
        next if $class eq $key; # FIXME: to remove plugin object_classes
        next if exists $skip->{$class};
        next if exists $later->{$class};
        next if exists $populated{$class};
        $pkg->_create_obj_to_backup(
            $class, $blog_ids, \@obj_to_backup, \%populated, $later);
    }
    foreach my $class (keys %$later) {
        next if exists $skip->{$class};
        $pkg->_create_obj_to_backup(
            $class, $blog_ids, \@obj_to_backup, \%populated, {});
    }

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        # Author has two ways to be associated to a blog
        my $class = MT->model('author');
        unshift @obj_to_backup, {$class => { 
            terms => undef,  
            args => { 'join' =>  
                [ MT->model('association'), 'author_id', { blog_id => $blog_ids }, { unique => 1 } ] 
            }}}; 
        unshift @obj_to_backup, {$class => { 
            terms => undef,  
            args => { 'join' =>  
                [ MT->model('permission'), 'author_id', { blog_id => $blog_ids }, { unique => 1 } ] 
            }}}; 
    }
    return \@obj_to_backup;
}

sub _create_obj_to_backup {
    my $pkg = shift;
    my ($class, $blog_ids, $obj_to_backup, $populated, $later) = @_;

    my $columns = $class->column_names;
    foreach my $column (@$columns) {
        if ( $column =~ /^(\w+)_id$/ ) {
            my $parent = $1;
            my $p_class = MT->model($parent);
            next unless $p_class;
            next if exists $later->{$p_class};
            next if exists $populated->{$p_class};
            $pkg->_create_obj_to_backup(
                $p_class, $blog_ids, $obj_to_backup, $populated, $later);
        }
    }
    
    if ( $class->can('backup_terms_args') ) {
        push @$obj_to_backup, { $class => $class->backup_terms_args($blog_ids) };
    }
    else {
        push @$obj_to_backup, $pkg->_default_terms_args($class, $blog_ids);
    }

    $populated->{$class} = 1;
}

sub _default_terms_args {
    my $pkg = shift;
    my ($class, $blog_ids) = @_;

    if (defined($blog_ids) && scalar(@$blog_ids)) {
        return { $class =>
          {
            terms => { 'blog_id' => $blog_ids }, 
            args => undef
          }
        };
    }
    else {
        return
          {
            $class => { terms => undef, args => undef }
          };
    }
}
    

sub backup {
    my $class = shift;
    my ($blog_ids, $printer, $splitter, $finisher, $progress, $size, $enc, $metadata) = @_;
    push @$blog_ids, '0'
        if defined($blog_ids) && scalar(@$blog_ids);
    my $obj_to_backup = $class->_populate_obj_to_backup(
        $blog_ids,
        {
            MT->model('config') => 1, 
            MT->model('session') => 1,
            MT->model('ts_job') => 1,
            MT->model('ts_error') => 1,
            MT->model('ts_exitstatus') => 1,
            MT->model('ts_funcmap') => 1,
        },
        {
            MT->model('placement') => 1, 
            MT->model('ping') => 1, 
            MT->model('objecttag') => 1, 
            MT->model('objectasset') => 1, 
            MT->model('objectscore') => 1,
        }
    );

    my $header .= "<movabletype xmlns='" . NS_MOVABLETYPE . "'\n";
    $header .= join ' ', map { $_ . "='" . $metadata->{$_} . "'" } keys %$metadata;
    $header .= ">\n";
    $header = "<?xml version='1.0' encoding='$enc'?>\n$header" if $enc !~ m/utf-?8/i;
    $printer->($header);

    my $files = {};
    _loop_through_objects(
        $printer, $splitter, $finisher, $progress, $size, $obj_to_backup, $files);

    my $else_xml = MT->run_callbacks('Backup', $blog_ids, $progress);
    $printer->($else_xml) if $else_xml ne '1';

    $printer->('</movabletype>');
    $finisher->($files);
}

sub _loop_through_objects {
    my ($printer, $splitter, $finisher, $progress, $size, $obj_to_backup, $files) = @_;

    my $counter = 1;
    my $bytes = 0;
    my %author_ids_seen;
    for my $class_hash (@$obj_to_backup) {
        my ($class, $term_arg) = each(%$class_hash);
        eval "require $class;";
        my $children = $class->properties->{child_classes} || {};
        for my $child_class (keys %$children) {
            eval "require $child_class;";
        }
        if (my $err = $@) {
            $progress->("$err\n", 'Error');
            next;
        }
        my $records = 0;
        my $state = MT->translate('Backing up [_1] records:', $class);
        $progress->($state, $class->class_type || $class->datasource);
        my $offset = 0;
        my $terms = $term_arg->{terms} || {};
        my $args = $term_arg->{args};
        unless ( exists $args->{sort} ) {
            $args->{sort} = 'id';
            $args->{direction} = 'ascend';
        }
        while (1) {
            $args->{offset} = $offset;
            $args->{limit} = 50;
            my @objects;
            eval {
                @objects = $class->load($terms, $args);
            };
            if (my $err = $@) {
                $progress->("$class:$err\n", 'Error');
            }
            last unless @objects;
            $offset += scalar @objects;
            for my $object (@objects) {
                if ( ( $class eq MT->model('author') )
                  && ( exists $author_ids_seen{$object->id} ) ) {
                    next;
                }
                $bytes += $printer->($object->to_xml(undef, $args) . "\n");
                $records++;
                if ($size && ($bytes >= $size)) {
                    $splitter->(++$counter);
                    $bytes = 0;
                }
                if ( $class eq MT->model('author') ) {
                    # Authors may be duplicated because of how terms and args are created.
                    $author_ids_seen{$object->id} = 1;
                } elsif ( $class->datasource eq 'asset' ) {
                    $files->{$object->id} = [$object->url, $object->file_path, $object->file_name];
                }
            }
            $progress->($state . " " . MT->translate("[_1] records backed up...", $records), $class->datasource)
                if $records && ($records % 100 == 0);
        }
        if ($records) {
            $progress->($state . " " . MT->translate("[_1] records backed up.", $records), $class->class_type || $class->datasource);
        } else {
            $progress->($state . " " . MT->translate("There were no [_1] records to be backed up.", $class), $class->class_type || $class->datasource);
        }
    }
}

sub restore_file {
    my $class = shift;
    my ($fh, $errormsg, $schema_version, $overwrite, $callback) = @_;

    my $objects = {};
    my $deferred = {};
    my $errors = [];

    my ($blog_ids, $asset_ids) = eval { $class->restore_process_single_file(
        $fh, $objects, $deferred, $errors, $schema_version, $overwrite, $callback
    ); };
    $$errormsg = join('; ', @$errors);
    #my @blog_ids;
    #while (my ($key, $value) = each %$objects) {
    #    if ($key =~ /MT::Blog#/) {
    #        push @blog_ids, $value->id;
    #    }
    #}
    ($deferred, $blog_ids);
}
 
sub restore_process_single_file {
    my $class = shift;
    my ($fh, $objects, $deferred, $errors, $schema_version, $overwrite,  $callback) = @_;
    
    my %restored_blogs = map { $objects->{$_}->id => 1; } grep { 'blog' eq $objects->{$_}->datasource } keys %$objects;

    require XML::SAX;
    require MT::BackupRestore::BackupFileHandler;
    my $handler = MT::BackupRestore::BackupFileHandler->new(
        callback => $callback,
        objects => $objects,
        deferred => $deferred,
        errors => $errors,
        schema_version => $schema_version,
        overwrite_template => $overwrite,
    );

    require MT::Util;
    my $parser = MT::Util::sax_parser();
    $callback->(ref($parser) . "\n") if MT->config->DebugMode;
    $parser->{Handler} = $handler;
    eval { $parser->parse_file($fh); };
    if (my $e = $@) {
        push @$errors, $e;
        $callback->($e);
        die $e if $handler->{critical}; 
    }

    my @blog_ids;
    my @asset_ids;

    while (my ($key, $value) = each %$objects) {
        if ('blog' eq $value->datasource) {
            push @blog_ids, $value->id unless exists $restored_blogs{$value->id};
        } elsif ('asset' eq $value->datasource) {
            my ($old_id) = $key =~ /^.+#(\d+)$/;
            push @asset_ids, $value->id, $old_id;
        }
    }
    my $blog_ids = scalar(@blog_ids) ? \@blog_ids : undef;
    my $asset_ids = scalar(@asset_ids) ? \@asset_ids : undef;
    ($blog_ids, $asset_ids);
}

sub restore_directory {
    my $class = shift;
    my ($dir, $errors, $error_assets, $schema_version, $callback) = @_;

    my $manifest;
    my @files;
    opendir my $dh, $dir or push(@$errors, MT->translate("Can't open directory '[_1]': [_2]", $dir, "$!")), return undef;
    for my $f (readdir $dh) {
        next if $f !~ /^.+\.manifest$/i;
        $manifest = File::Spec->catfile($dir, $f);
        last;
    }
    closedir $dh;
    unless ($manifest) {
        push @$errors, MT->translate("No manifest file could be found in your import directory [_1].", $dir);
        return (undef, undef);
    }

    my $fh = gensym;
    open $fh, "<$manifest" or push(@$errors, MT->translate("Can't open [_1].", $manifest)), return 0;
    my $backups = __PACKAGE__->process_manifest($fh);
    close $fh;
    unless($backups) {
        push @$errors, MT->translate("Manifest file [_1] was not a valid Movable Type backup manifest file.", $manifest);
        return (undef, undef);
    }

    $callback->(MT->translate("Manifest file: [_1]", $manifest) . "\n");

    my %objects;
    my $deferred = {};

    my $files = $backups->{files};
    my @blog_ids;
    my @asset_ids;
    for my $file (@$files) {
        my $fh = gensym;
        my $filepath = File::Spec->catfile($dir, $file);
        open $fh, "<$filepath" or push @$errors, MT->translate("Can't open [_1]."), next;

        my ($tmp_blog_ids, $tmp_asset_ids) = eval { __PACKAGE__->restore_process_single_file(
            $fh, \%objects, $deferred, $errors, $schema_version, $callback); };

        close $fh;
        last if $@;

        push @blog_ids, @$tmp_blog_ids if defined $tmp_blog_ids;
        push @asset_ids, @$tmp_asset_ids if defined $tmp_asset_ids;
    }
    my $blog_ids = scalar(@blog_ids) ? \@blog_ids : undef;
    my $asset_ids = scalar(@asset_ids) ? \@asset_ids : undef;
    ($deferred, $blog_ids, $asset_ids);
}

sub process_manifest {
    my $class = shift;
    my ($stream) = @_;

    if ((ref($stream) eq 'Fh') || (ref($stream) eq 'GLOB')){
        seek($stream, 0, 0) or return undef;
        require XML::SAX;
        require MT::BackupRestore::ManifestFileHandler;
        my $handler = MT::BackupRestore::ManifestFileHandler->new();

        require MT::Util;
        my $parser = MT::Util::sax_parser();
        $parser->{Handler} = $handler;
        eval { $parser->parse_file($stream); };
        if (my $e = $@) {
            die $e;
        }
        return $handler->{backups};
    }
    return undef;
}

sub restore_asset {
    my $class = shift;
    my ($file, $asset, $old_id, $fmgr, $errors, $callback) = @_;

    my $id = $asset->id;

    my $path = $asset->file_path;
    unless (defined($path)) {
        $callback->(MT->translate('Path was not found for the file ([_1]).', $id));
        return 0;
    }
    my ($vol, $dir, $fn) = File::Spec->splitpath($path);
    my $voldir =  "$vol$dir";
    if (!-w $voldir) {
        unless (defined $fmgr) {
            my $blog = MT->model('blog')->load($asset->blog_id);
            $fmgr = $blog->file_mgr if $blog;
        }
        unless (defined $fmgr) {
            # we do need utf8_off here
            $errors->{$id} = MT->translate('[_1] is not writable.', MT::I18N::utf8_off($voldir)) ;
        } else {
            $voldir =~ s|/$|| unless $voldir eq '/';  ## OS X doesn't like / at the end in mkdir().
            unless ($fmgr->exists($voldir)) {
                $fmgr->mkpath($voldir) or
                    $errors->{$id} = MT->translate("Error making path '[_1]': [_2]", $path, $fmgr->errstr);
            }
        }
    }
    if (-w $voldir) {
        my $filename = "$old_id-" . $asset->file_name;
        $callback->(MT->translate("Copying [_1] to [_2]...", $filename, $path));
        copy($file, $path)
            or $errors->{$id} = $!;
    }

    $callback->(exists($errors->{$id}) ?
        MT->translate('Failed: ') . $errors->{$id} :
        MT->translate("Done.")
    );
    $callback->("\n");
}

sub _restore_asset_multi {
    my $class = shift;
    my ($asset_element, $objects, $errors, $callback, $blogs_meta) = @_;

    my $old_id = $asset_element->{asset_id};
    if (!defined($old_id)) {
        $callback->(MT->translate('ID for the file was not set.'));
        return 0;
    }
    my $asset_class = MT->model('asset');
    my $asset = $objects->{"$asset_class#$old_id"};
    unless (defined($asset)) {
        $callback->(MT->translate('The file ([_1]) was not restored.', $old_id));
        return 0;
    }

    my $fmgr;
    if (exists $blogs_meta->{$asset->blog_id}) {
        my $meta = $blogs_meta->{$asset->blog_id};
        my $path = $asset->file_path;
        my $url = $asset->url;
        if (my $archive_path = $meta->{'archive_path'}) {
            my $old_archive_path = $meta->{'old_archive_path'};
            $path =~ s/\Q$old_archive_path\E/$archive_path/i;
            $asset->file_path($path);
        }
        if (my $archive_url = $meta->{'archive_url'}) {
            my $old_archive_url = $meta->{'old_archive_url'};
            $url =~ s/\Q$old_archive_url\E/$archive_url/i;
            $asset->url($url);
        }
        if (my $site_path = $meta->{'site_path'}) {
            my $old_site_path = $meta->{'old_site_path'};
            $path =~ s/\Q$old_site_path\E/$site_path/i;
            $asset->file_path($path);
        }
        if (my $site_url = $meta->{'site_url'}) {
            my $old_site_url = $meta->{'old_site_url'};
            $url =~ s/\Q$old_site_url\E/$site_url/i;
            $asset->url($url);
        }
        $callback->(MT->translate("Changing path for the file '[_1]' (ID:[_2])...", $asset->label, $asset->id));
        $asset->save or $callback->(MT->translate("failed") . "\n");
        $callback->(MT->translate("ok") . "\n");

        my $blog = MT->model('blog')->load($asset->blog_id);
        $fmgr = $blog->file_mgr;
    }
    my $file = $asset_element->{fh};
    $class->restore_asset($file, $asset, $old_id, $fmgr, $errors, $callback);
}

package MT::Object;

sub _is_element {
    my $obj = shift;
    my ($def) = @_;
    return (('text' eq $def->{type}) || (('string' eq $def->{type}) && (255 < $def->{size}))) ? 1 : 0;
}

sub to_xml {
    my $obj = shift;
    my ($namespace, $args) = @_;

    my $coldefs = $obj->column_defs;
    my $colnames = $obj->column_names;
    my $xml;

    my $elem = $obj->datasource;
    $xml = '<' . $elem;
    $xml .= " xmlns='$namespace'" if defined($namespace) && $namespace;

    my (@elements, @blobs, @meta);
    for my $name (@$colnames) {
        if ($obj->column($name) || (defined($obj->column($name)) && ('0' eq $obj->column($name)))) {
            if ( ( $obj->properties->{meta_column} || '' ) eq $name ) {
                push @meta, $name;
                next;
            }
            elsif ($obj->_is_element($coldefs->{$name})) {
                push @elements, $name;
                next;
            } elsif ('blob' eq $coldefs->{$name}->{type}) {
                push @blobs, $name;
                next;
            }
            $xml .= " $name='" . MT::Util::encode_xml($obj->column($name), 1) . "'";
        }
    }
    $xml .= '>';
    $xml .= "<$_>" . MT::Util::encode_xml($obj->column($_), 1) . "</$_>" foreach @elements;
    require MIME::Base64;
    $xml .= "<$_>" . MIME::Base64::encode_base64($obj->column($_), '') . "</$_>" foreach @blobs;
    foreach my $meta_col (@meta) {
        my $hashref = $obj->$meta_col;
        $xml .= "<$meta_col>" . 
                MIME::Base64::encode_base64(MT::Serialize->serialize(\$hashref), '') .
                "</$meta_col>";
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
    my ($key, $val, $data, $objects) = @_;

    return 0 unless 'ARRAY' eq ref($val);
    return 1 if 0 == $data->{$key}; 

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
    my ($data, $objects) = @_;

    my $parents = $obj->parents;
    my $count = scalar(keys %$parents);

    my $done = 0;
    while (my ($key, $val) = each(%$parents)) {
        $val = [ $val ] unless (ref $val);
        if ('ARRAY' eq ref($val)) {
            $done += $obj->_restore_id($key, $val, $data, $objects);
        }
        elsif ('HASH' eq ref($val)) {
            my $v = $val->{class};
            $v = [ $v ] unless (ref $v);
            my $result = 0;
            if (my $relations = $val->{relations}) {
                my $col = $relations->{key};
                my $ds = $data->{$col};
                my $ev = $relations->{$ds . '_id'};
                $ev = MT->model($ds) unless $ev;
                return 0 unless $ev;
                $ev = [ $ev ] unless (ref $ev);
                $done += $obj->_restore_id($key, $ev, $data, $objects);
            }
            else {
                $result = $obj->_restore_id($key, $v, $data, $objects);
                $result = 1 if exists($val->{optional}) && $val->{optional};
                $data->{$key} = -1 
                  if !$result && (exists($val->{orphanize}) && $val->{orphanize});
                $done += $result;
            }
        }
    }
    ($count == $done) ? 1 : 0;   
}

package MT::Blog;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return
          {
            terms => { id => $blog_ids }, 
            args => undef,
          };
    }
    else {
        return { terms => undef, args => undef };
    }
}

package MT::Tag;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return
          {
            terms => undef, 
            args =>
              {
                'join' =>
                  [
                    'MT::ObjectTag', 
                    'tag_id',
                    { blog_id => $blog_ids }, 
                    { unique => 1 }
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

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return
          {
            terms => undef, 
            args =>
              {
                'join' =>
                  [
                    'MT::Association',
                    'role_id',
                    { blog_id => $blog_ids },
                    { unique => 1 }
                  ]
              }
          };
    }
    else {
        return { terms => undef, args => undef };
    }
}

package MT::Asset;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    if ( defined($blog_ids) && scalar(@$blog_ids) ) {
        return
          {
            terms => { 'blog_id' => $blog_ids, 'class' => '*' }, 
            args => undef
          }
    }
    else {
        return { terms => { 'class' => '*' }, args => undef };
    }
}

my $assets_seen = {};

sub to_xml {
    my $obj = shift;
    my $xml = q();

    return $xml if exists $assets_seen->{$obj->id};

    if ($obj->parent) {
        my $parent = MT->model('asset')->load($obj->parent);
        $xml .= $parent->to_xml(@_);
        $xml .= "\n";
    }

    $xml .= $obj->SUPER::to_xml(@_);
    $assets_seen->{$obj->id} = 1;
    $xml;
}

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
        parent  => MT->model('asset')
    };
}

package MT::PluginData;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    return { terms => undef, args => undef };
}

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    if ($data->{key} =~ /^configuration:blog:(\d+)$/i) {
        my $new_blog = $objects->{'MT::Blog#' . $1};
        if ($new_blog) {
            $data->{key} = 'configuration:blog:' . $new_blog->id;
        }
    }
    return 1;
}

package MT::Association;

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    my ($u, $b, $g, $r) = (0, 0, 0, 0);

    my $processor = sub {
        my ($elem) = @_;
        my $class = MT->model($elem);
        my $old_id = $data->{$elem . '_id'};
        my $new_obj = $objects->{"$class#$old_id"};
        return 0 unless defined($new_obj) && $new_obj;
        $data->{$elem . '_id'} = $new_obj->id;
        return 1;
    };

    $u = $processor->('author');
    $g = $processor->('group');
    $b = $processor->('blog');
    $r = $processor->('role');

    # Combination allowed are:
    # USER_BLOG_ROLE  => 1;
    # GROUP_BLOG_ROLE => 2;
    # USER_GROUP      => 3;
    # USER_ROLE       => 4;
    # GROUP_ROLE      => 5;

    ($u && $g) || ($u && $r) || ($g && $r) ? 1 : 0; # || ($u && $b && $r) || ($g && $b && $r)
}

package MT::Category;

my $category_seen = {};

sub to_xml {
    my $obj = shift;
    my $xml = q();

    return $xml if exists $category_seen->{$obj->id};
    
    if ('0' ne $obj->parent) {
        $xml .= $obj->parent_category->to_xml(@_);
        $xml .= "\n";
    }

    $xml .= $obj->SUPER::to_xml(@_);
    $category_seen->{$obj->id} = 1;
    $xml;
}

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
        parent  => [ MT->model('category'), MT->model('folder') ],
    };
}

package MT::Comment;

sub parents {
    my $obj = shift;
    {
        entry_id => [ MT->model('entry'), MT->model('page') ],
        blog_id => MT->model('blog'),
        commenter_id => { class => MT->model('author'), optional => 1 },
    };
}

package MT::Entry;

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
        author_id => { class => MT->model('author'), optional => 1, orphanize => 1 },
    };
}

package MT::Notification;

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
    };
}

package MT::ObjectTag;

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
        tag_id => MT->model('tag'),
        object_id => { relations => {
            key => 'object_datasource',
            entry_id => [ MT->model('entry'), MT->model('page') ],
        }}
    };
}

package MT::Permission;

sub parents {
    my $obj = shift;
    {
        blog_id => { class => MT->model('blog'), optional => 1 },
        author_id => { class => MT->model('author'), optional => 1 },
    };
}

package MT::Placement;

sub parents {
    my $obj = shift;
    {
        category_id => [ MT->model('category'), MT->model('folder') ],
        blog_id => MT->model('blog'),
        entry_id => [ MT->model('entry'), MT->model('page') ],
    };
}

package MT::TBPing;

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
        tb_id => MT->model('trackback'),
    };
}

package MT::Template;

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
    };
}

package MT::TemplateMap;

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
        template_id  => MT->model('template')
    };
}

package MT::Trackback;

sub restore_parent_ids {
    my $obj = shift;
    my ($data, $objects) = @_;

    my $result = 0;
    my $blog_class = MT->model('blog');
    my $new_blog = $objects->{$blog_class . '#' . $data->{blog_id}};
    if ($new_blog) {
        $data->{blog_id} = $new_blog->id;
    } else {
        return 0;
    }                            
    if (my $cid = $data->{category_id}) {
        my $cat_class = MT->model('category');
        my $new_obj = $objects->{$cat_class . '#' . $cid};
        unless ($new_obj) {
            $cat_class = MT->model('folder');
            $new_obj = $objects->{$cat_class . '#' . $cid};
        }
        if ($new_obj) {
            $data->{category_id} = $new_obj->id;
            $result = 1;
        }
    } elsif (my $eid = $data->{entry_id}) {
        my $entry_class = MT->model('entry');
        my $new_obj = $objects->{$entry_class . '#' . $eid};
        unless ($new_obj) {
            $entry_class = MT->model('page');
            $new_obj = $objects->{$entry_class . '#' . $eid};
        }
        if ($new_obj) {
            $data->{entry_id} = $new_obj->id;
            $result = 1;
        }
    }
    $result;
}

package MT::ObjectAsset;

sub parents {
    my $obj = shift;
    {
        blog_id => MT->model('blog'),
        asset_id => MT->model('asset'),
        object_id => { relations => {
            key => 'object_ds',
            entry_id => [ MT->model('entry'), MT->model('page') ],
        }}
    };
}

package MT::ObjectScore;

sub backup_terms_args {
    my $class = shift;
    my ($blog_ids) = @_;

    return { terms => undef, args => undef };
}

sub parents {
    my $obj = shift;
    {
        author_id => MT->model('author'),
        object_id => { relations => {
            key => 'object_ds',
            entry_id => [ MT->model('entry'), MT->model('page') ],
        }}
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

=item Restore

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

$callback is a code reference which will print out the passed paramter.
Callback method can use this to communicate with users.

If a plugin has an MT::Object derived type, the plugin will register 
a callback to Restore.<element_name>:<xmlnamespace> callback, 
so later the restore operation will call the callback function with 
parameters described above.  XML Namespace is required to be registered, 
so an xml node can be resolved into what plugins to be called back, 
and can be distinguished the same element name with each other.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
