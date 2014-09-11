# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::BackupRestore::BackupFileHandler;

use strict;
use XML::SAX::Base;
use MIME::Base64;
use File::Basename;
use File::Spec;

@MT::BackupRestore::BackupFileHandler::ISA = qw(XML::SAX::Base);

my $is_mswin32 = $^O eq 'MSWin32' ? 1 : 0;

sub new {
    my $class   = shift;
    my (%param) = @_;
    my $self    = bless \%param, $class;
    return $self;
}

sub start_document {
    my $self = shift;
    my $data = shift;

    $self->{start} = 1;
    *_decode = sub { $_[0] }
        unless $self->{is_pp};

    1;
}

sub start_element {
    my $self = shift;
    my $data = shift;

    return if $self->{skip};

    my $name  = $data->{LocalName};
    my $attrs = $data->{Attributes};
    my $ns    = $data->{NamespaceURI};

    if ( $self->{start} ) {
        die MT->translate(
            'The uploaded file was not a valid Movable Type backup manifest file.'
            )
            if !( ( 'movabletype' eq $name )
            && ( MT::BackupRestore::NS_MOVABLETYPE() eq $ns ) );

        $self->{backup_what} = $attrs->{'{}backup_what'}->{Value};

        #unless ($self->{ignore_schema_conflicts}) {
        my $schema = $attrs->{'{}schema_version'}->{Value};

#if (('ignore' ne $self->{schema_version}) && ($schema > $self->{schema_version})) {
        if ( $schema != $self->{schema_version} ) {
            $self->{critical} = 1;
            my $message = MT->translate(
                'The uploaded backup manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not restore this backup to this version of Movable Type.',
                $schema, $self->{schema_version}
            );
            MT->log(
                {   message  => $message,
                    level    => MT::Log::ERROR(),
                    class    => 'system',
                    category => 'restore',
                }
            );
            die $message;
        }

        #}
        $self->{start} = 0;
        return 1;
    }

    my $objects  = $self->{objects};
    my $deferred = $self->{deferred};
    my $callback = $self->{callback};

    if ( my $current = $self->{current} ) {

        # this is an element for a text column of the object
        $self->{current_text} = [$name];
    }
    else {
        if ( MT::BackupRestore::NS_MOVABLETYPE() eq $ns ) {
            my $class = MT->model($name);
            unless ($class) {
                push @{ $self->{errors} },
                    MT->translate(
                    '[_1] is not a subject to be restored by Movable Type.',
                    $name );
            }
            else {
                if ( $self->{current_class} ne $class ) {
                    if ( my $c = $self->{current_class} ) {
                        my $state   = $self->{state};
                        my $records = $self->{records};
                        $callback->(
                            $state . " "
                                . MT->translate(
                                "[_1] records restored.", $records
                                ),
                            $c->class_type || $c->datasource
                        );
                    }
                    $self->{records}       = 0;
                    $self->{current_class} = $class;
                    my $state
                        = MT->translate( 'Restoring [_1] records:', $class );
                    $callback->( $state, $name );
                    $self->{state} = $state;
                }
                my %column_data
                    = map { $attrs->{$_}->{LocalName} => $attrs->{$_}->{Value} }
                    keys(%$attrs);

                # Replace directory separators properly.
                if (   $class =~ /^MT::Asset/
                    || $class eq 'MT::Blog'
                    || $class eq 'MT::Website' )
                {
                    my $key
                        = $class =~ /^MT::Asset/
                        ? 'file_path'
                        : 'upload_path';
                    my ($separator)
                        = ( $column_data{$key} =~ m!^%\w(/|\\)! );
                    if ( $separator eq '/' && $is_mswin32 ) {

                        # *nix => Windows
                        $column_data{$key} =~ s!/!\\!g;
                    }
                    elsif ( $separator eq '\\' && !$is_mswin32 ) {

                        # Windows => *nix
                        $column_data{$key} =~ s!\\!/!g;
                    }
                }

                my $obj;
                if ( 'author' eq $name ) {
                    $obj = $class->load( { name => $column_data{name} } );
                    if ($obj) {
                        if ( UNIVERSAL::isa( MT->instance, 'MT::App' )
                            && ( $obj->id == MT->instance->user->id ) )
                        {
                            MT->log(
                                {   message => MT->translate(
                                        "A user with the same name as the current user ([_1]) was found in the backup.  Skipping this user record.",
                                        $obj->name
                                    ),
                                    level => MT::Log::INFO(),
                                    metadata =>
                                        'Permissions and associations have been restored.',
                                    class    => 'system',
                                    category => 'restore',
                                }
                            );
                            $objects->{ "$class#" . $column_data{id} } = $obj;
                            $objects->{ "$class#" . $column_data{id} }
                                ->{no_overwrite} = 1;
                            $self->{current} = $obj;
                            $self->{loaded}  = 1;
                            $self->{skip} += 1;
                        }
                        else {
                            MT->log(
                                {   message => MT->translate(
                                        "A user with the same name '[_1]' was found in the backup (ID:[_2]).  Restore replaced this user with the data from the backup.",
                                        $obj->name,
                                        $obj->id
                                    ),
                                    level => MT::Log::INFO(),
                                    metadata =>
                                        'Permissions and associations have been restored as well.',
                                    class    => 'system',
                                    category => 'restore',
                                }
                            );
                            my $old_id = delete $column_data{id};
                            $objects->{"$class#$old_id"} = $obj;
                            $objects->{"$class#$old_id"}->{no_overwrite} = 1;
                            delete $column_data{userpic_asset_id}
                                if exists $column_data{userpic_asset_id};

                            my $success
                                = $obj->restore_parent_ids( \%column_data,
                                $objects );
                            if ($success) {
                                my %realcolumns = map {
                                    $_ =>
                                        _decode( delete( $column_data{$_} ) )
                                } @{ $obj->column_names };
                                $obj->set_values( \%realcolumns );
                                $obj->$_( $column_data{$_} )
                                    foreach keys(%column_data);
                                $obj->column( 'external_id',
                                    $realcolumns{external_id} )
                                    if defined $realcolumns{external_id};
                                $self->{current} = $obj;
                            }
                            else {
                                $deferred->{ $class . '#' . $column_data{id} }
                                    = 1;
                                $self->{deferred} = $deferred;
                                $self->{skip} += 1;
                            }
                            $self->{loaded} = 1;
                        }
                    }
                }
                elsif ( 'template' eq $name ) {
                    if ( !$column_data{blog_id} ) {
                        $obj = $class->load(
                            {   blog_id => 0,
                                (   $column_data{identifier}
                                    ? ( identifier =>
                                            $column_data{identifier} )
                                    : ( name => $column_data{name} )
                                ),
                            }
                        );
                        if ($obj) {
                            my $old_id = delete $column_data{id};
                            $objects->{"$class#$old_id"} = $obj;
                            if ( $self->{overwrite_template} ) {
                                my %realcolumns = map {
                                    $_ =>
                                        _decode( delete( $column_data{$_} ) )
                                } @{ $obj->column_names };
                                $obj->set_values( \%realcolumns );
                                $obj->$_( $column_data{$_} )
                                    foreach keys(%column_data);
                                $self->{current} = $obj;
                                $self->{loaded}  = 1;
                            }
                            else {
                                $self->{skip} += 1;
                            }
                        }
                    }
                }
                elsif ( 'filter' eq $name ) {
                    if ( $objects->{ "MT::Author#" . $column_data{author_id} }
                        )
                    {
                        $obj = $class->load(
                            {   author_id => $column_data{author_id},
                                label     => $column_data{label},
                                object_ds => $column_data{object_ds},
                            }
                        );
                        if ($obj) {
                            $obj->restore_parent_ids( \%column_data,
                                $objects );
                            my $old_id = $column_data{id};
                            $objects->{"$class#$old_id"} = $obj;
                            $self->{current}             = $obj;
                            $self->{loaded}              = 1;

                            $self->{skip} += 1;
                        }
                    }
                }
                elsif ( 'image' eq $name ) {
                    if ( !$column_data{blog_id} ) {
                        $obj = $class->load(
                            {   file_path => $column_data{file_path},
                                blog_id   => 0,
                            }
                        );
                        if ($obj) {
                            if ($obj->created_on == $column_data{created_on} )
                            {

                                # The same file is already registered

                                my $old_id = $column_data{id};

                                my %realcolumns = map {
                                    $_ =>
                                        _decode( delete( $column_data{$_} ) )
                                } @{ $obj->column_names };
                                $obj->set_values( \%realcolumns );
                                $obj->$_( $column_data{$_} )
                                    foreach keys(%column_data);

                                $objects->{ "$class#" . $old_id } = $obj;
                                $self->{current}                  = $obj;
                                $self->{loaded}                   = 1;
                            }
                            else {

                                # The different file that has the same name is
                                # registered

                                $obj = undef;

                                my $middle_path = $column_data{created_on};

                                {
                                    my ( $name, $path )
                                        = fileparse(
                                        $column_data{file_path} );
                                    $column_data{file_path}
                                        = File::Spec->catfile( $path,
                                        $middle_path, $name );
                                }

                                {
                                    my ( $path, $name )
                                        = (
                                        $column_data{url} =~ m{(.*/)(.*)}s );
                                    $column_data{url}
                                        = $path . $middle_path . '/' . $name;
                                }
                            }
                        }
                    }
                }

                unless ($obj) {
                    $obj = $class->new;
                }
                unless ( $obj->id ) {

                    # Pass through even if an blog doesn't restore
                    # the parent object
                    my $success
                        = $obj->restore_parent_ids( \%column_data, $objects );
                    if ( $success || ( !$success && 'blog' eq $name ) ) {
                        require MT::Meta;
                        my @metacolumns
                            = MT::Meta->metadata_by_class( ref($obj) );
                        my %metacolumns
                            = map { $_->{name} => $_->{type} } @metacolumns;
                        $self->{metacolumns}{ ref($obj) } = \%metacolumns;
                        my %realcolumn_data
                            = map { $_ => _decode( $column_data{$_} ) }
                            grep { !exists( $metacolumns{$_} ) }
                            keys %column_data;

                        if ( !$success && 'blog' eq $name ) {
                            $realcolumn_data{parent_id} = undef;
                        }

                        $obj->set_values( \%realcolumn_data );
                        $obj->column( 'external_id',
                            $realcolumn_data{external_id} )
                            if $name eq 'author'
                            && defined $realcolumn_data{external_id};
                        foreach my $metacol ( keys %metacolumns ) {
                            next
                                if ( 'vclob' eq $metacolumns{$metacol} )
                                || ( 'vblob' eq $metacolumns{$metacol} );
                            $obj->$metacol(
                                $metacolumns{$metacol} =~ /^vchar/
                                ? _decode( $column_data{$metacol} )
                                : $column_data{$metacol}
                            );
                        }

                        # Restore modulesets
                        if ( 'template' eq $name
                            && $obj->type eq 'widgetset' )
                        {
                            my @old_ids = split ',', $obj->modulesets;
                            my @new_ids;
                            foreach my $old_id (@old_ids) {
                                my $new_id
                                    = $self->{objects}->{"$class#$old_id"}
                                    ? $self->{objects}->{"$class#$old_id"}->id
                                    : $old_id;
                                push @new_ids, $new_id;
                            }
                            $obj->modulesets( join ',', @new_ids );
                        }

                        $self->{current} = $obj;
                    }
                    else {
                        $deferred->{ $class . '#' . $column_data{id} } = 1;
                        $self->{deferred} = $deferred;
                        $self->{skip} += 1;
                    }
                }
            }
        }
        else {
            my $obj = MT->run_callbacks( "Restore.$name:$ns",
                $data, $objects, $deferred, $callback );
            $self->{current} = $obj if defined($obj) && ( '1' ne $obj );
        }
    }
    1;
}

sub characters {
    my $self = shift;
    my $data = shift;

    return if $self->{skip};
    return if !exists( $self->{current} );
    if ( my $text_data = $self->{current_text} ) {
        push @$text_data, $data->{Data};
        $self->{current_text} = $text_data;
    }
    1;
}

sub end_element {
    my $self = shift;
    my $data = shift;

    if ( $self->{skip} ) {
        $self->{skip} -= 1;
        return;
    }

    my $name  = $data->{LocalName};
    my $ns    = $data->{NamespaceURI};
    my $class = MT->model($name);

    if ( my $obj = $self->{current} ) {
        if ( my $text_data = delete $self->{current_text} ) {
            my $column_name = shift @$text_data;
            my $text;
            $text .= $_ foreach @$text_data;

            my $defs = $obj->column_defs;
            if ( exists( $defs->{$column_name} ) ) {
                if ( 'blob' eq $defs->{$column_name}->{type} ) {
                    $text = MIME::Base64::decode_base64($text);
                    if ( substr( $text, 0, 4 ) eq 'SERG' ) {
                        $text = MT::Serialize->unserialize($text);
                        $obj->$column_name($$text);
                    }
                    else {
                        $obj->column( $column_name, $text );
                    }
                }
                else {
                    $obj->column( $column_name, _decode($text) );
                }
            }
            elsif ( my $metacolumns = $self->{metacolumns}{ ref($obj) } ) {
                if ( my $type = $metacolumns->{$column_name} ) {
                    if ( 'vblob' eq $type ) {
                        $text = MIME::Base64::decode_base64($text);
                        $text = MT::Serialize->unserialize($text);
                        $obj->$column_name($$text);
                    }
                    else {
                        $obj->$column_name( _decode($text) );
                    }
                }
            }
        }
        else {
            my $old_id = $obj->id;
            unless (
                (      ( 'author' eq $name )
                    || ( 'template' eq $name )
                    || ( 'filter' eq $name )
                    || ( 'image' eq $name )
                    || ( 'plugindata' eq $name )
                )
                && ( exists $self->{loaded} )
                )
            {
                delete $obj->{column_values}->{id};
                delete $obj->{changed_cols}->{id};
            }
            delete $self->{loaded};

            my $exists = 0;
            if ( 'tag' eq $name ) {
                if (my $tag = MT::Tag->load(
                        { name   => $obj->name },
                        { binary => { name => 1 } }
                    )
                    )
                {
                    $exists = 1;
                    $self->{objects}->{"$class#$old_id"} = $tag;
                    $self->{callback}->("\n");
                    $self->{callback}->(
                        MT->translate(
                            "Tag '[_1]' exists in the system.",
                            $obj->name
                        )
                    );
                }
            }
            elsif ( 'trackback' eq $name ) {
                my $term;
                my $message;
                if ( $obj->entry_id ) {
                    $term = { entry_id => $obj->entry_id };
                }
                elsif ( $obj->category_id ) {
                    $term = { category_id => $obj->category_id };
                }
                if ( my $tb = $class->load($term) ) {
                    $exists = 1;
                    my $changed = 0;
                    if ( $obj->passphrase ) {
                        $tb->passphrase( $obj->passphrase );
                        $changed = 1;
                    }
                    if ( $obj->is_disabled ) {
                        $tb->is_disabled( $obj->is_disabled );
                        $changed = 1;
                    }
                    $tb->save if $changed;
                    $self->{objects}->{"$class#$old_id"} = $tb;
                    my $records = $self->{records};
                    $self->{callback}->(
                        $self->{state} . " "
                            . MT->translate(
                            "[_1] records restored...", $records
                            ),
                        $data->{LocalName}
                    ) if $records && ( $records % 10 == 0 );
                    $self->{records} = $records + 1;
                }
            }
            elsif ( 'permission' eq $name ) {
                my $perm = $class->exist(
                    {   author_id => $obj->author_id,
                        blog_id   => $obj->blog_id
                    }
                );
                $exists = 1 if $perm;
            }
            elsif ( 'objectscore' eq $name ) {
                my $score = $class->exist(
                    {   author_id => $obj->author_id,
                        object_id => $obj->object_id,
                        object_ds => $obj->object_ds,
                    }
                );
                $exists = 1 if $score;
            }
            elsif ( 'field' eq $name ) {

                # Available in propack only
                if ( $obj->blog_id == 0 ) {
                    my $field = $class->exist(
                        {   blog_id  => 0,
                            basename => $obj->basename,
                        }
                    );
                    $exists = 1 if $field;
                }
            }
            elsif ( 'role' eq $name ) {
                my $role = $class->load( { name => $obj->name } );
                if ($role) {
                    my $old_perms = join '',
                        sort { $a <=> $b } split( ',', $obj->permissions );
                    my $cur_perms = join '',
                        sort { $a <=> $b } split( ',', $role->permissions );
                    if ( $old_perms eq $cur_perms ) {
                        $self->{objects}->{"$class#$old_id"} = $role;
                        $exists = 1;
                    }
                    else {

                        # restore in a different name
                        my $i        = 1;
                        my $new_name = $obj->name . " ($i)";
                        while ( $class->exist( { name => $new_name } ) ) {
                            $new_name = $obj->name . ' (' . ++$i . ')';
                        }
                        $obj->name($new_name);
                        MT->log(
                            {   message => MT->translate(
                                    "The role '[_1]' has been renamed to '[_2]' because a role with the same name already exists.",
                                    $role->name,
                                    $new_name
                                ),
                                level    => MT::Log::INFO(),
                                class    => 'system',
                                category => 'restore',
                            }
                        );
                    }
                }
            }
            elsif ( 'filter' eq $name ) {
                my $objects = $self->{objects};

                # Callback for restoring ID in the filter items
                MT->run_callbacks( 'restore_filter_item_ids', $obj, undef,
                    $objects );
            }
            elsif ( 'plugindata' eq $name ) {

                # Skipping System level plugindata
                # when it was found in the database.

                if ( $obj->key !~ /^configuration:blog:(\d+)$/i ) {
                    if (my $obj = MT->model('plugindata')->load(
                            { key => $obj->key, plugin => $obj->plugin }
                        )
                        )
                    {
                        $exists = 1;
                        $self->{callback}->("\n");
                        $self->{callback}->(
                            MT->translate(
                                "The system level settings for plugin '[_1]' already exist.  Skipping this record.",
                                $obj->plugin
                            )
                        );
                    }
                }
            }
            unless ($exists) {
                my $result;
                if ( $obj->id ) {
                    $result = $obj->update();
                }
                else {
                    $result = $obj->insert();
                }
                if ($result) {
                    if ( $class =~ /MT::Asset(::.+)*/ ) {
                        $class = 'MT::Asset';
                    }
                    $self->{objects}->{"$class#$old_id"} = $obj;
                    my $records = $self->{records};
                    $self->{callback}->(
                        $self->{state} . " "
                            . MT->translate(
                            "[_1] records restored...", $records
                            ),
                        $data->{LocalName}
                    ) if $records && ( $records % 10 == 0 );
                    $self->{records} = $records + 1;
                    my $cb = "restored.$name";
                    $cb .= ":$ns"
                        if MT::BackupRestore::NS_MOVABLETYPE() ne $ns;
                    MT->run_callbacks( $cb, $obj, $self->{callback} );
                    $obj->call_trigger( 'post_save', $obj );
                }
                else {
                    push @{ $self->{errors} }, $obj->errstr;
                    $self->{callback}->( $obj->errstr );
                }
            }
            delete $self->{current};
        }
    }
}

sub end_document {
    my $self = shift;
    my $data = shift;

    if ( my $c = $self->{current_class} ) {
        my $state   = $self->{state};
        my $records = $self->{records};
        $self->{callback}->(
            $state . " "
                . MT->translate( "[_1] records restored.", $records ),
            $c->class_type || $c->datasource
        );
    }

    1;
}

sub _decode {
    my ($str) = @_;

    $str = Encode::decode_utf8($str) unless Encode::is_utf8($str);
    return $str;
}

1;
