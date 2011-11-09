# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::BackupRestore::ObjectCreator;
use strict;
use warnings;

my $CbName = "MT::BackupRestore::ObjectRestoreFilter";

sub new {
    my $class   = shift;
    my (%param) = @_;
    my $self    = bless \%param, $class;
    $self->set_is_pp(0);
    if ( UNIVERSAL::isa( MT->instance, 'MT::App' ) ) {
        $self->{app_user} = MT->instance->user->id;
    }

    return $self;
}

# callback to print status massages
sub run_callback {
    my ( $self, @msgs ) = @_;
    $self->{callback}->( $self->{state} . " " . join( '', @msgs ) );
}

# Set the current class that we are handling right now, so the upcomming
# status massages will print it
sub set_new_class {
    my ( $self, $class_name ) = @_;
    my $state = MT->translate( 'Restoring [_1] records:', $class_name );
    $self->{state} = $state;
}

# The XML::SAX::PurePerl does not do the UTF8 decoding for us
sub set_is_pp {
    my ( $self, $is_pp ) = @_;
    $self->{decoder} = $is_pp ? \&__decoder_from_utf8 : sub { $_[0] };
}

# Main entry for this object - gets a hash-ref, create an object from it,
# and saves it.
sub save_object {
    my ( $self, $obj, $data ) = @_;

    $obj = $self->__object_from_data( $obj, $data );
    return unless $obj;

    my $name    = $data->{LocalName};
    my $ns      = $data->{NamespaceURI};
    my $objects = $self->{objects};
    my $class   = MT->model($name);

    my $old_id = $obj->id;
    delete $obj->{column_values}->{id};
    delete $obj->{changed_cols}->{id};

    # a type-specific handling, if exists
    my $mns     = MT::BackupRestore::NS_MOVABLETYPE() eq $ns ? '' : ":$ns";
    my $cb_name = "$CbName.$name$mns";
    my $result  = MT->run_callbacks( $cb_name, $self, $class, $obj, $old_id,
        $objects );
    return unless $result;

    $result = $obj->id ? $obj->update() : $obj->insert();

    if ( not $result ) {
        push @{ $self->{errors} }, $obj->errstr;
        $self->{callback}->( $obj->errstr );
        return;
    }

    if ( $class =~ /MT::Asset(::.+)*/ ) {
        $class = 'MT::Asset';
    }

    $self->{objects}->{"$class#$old_id"} = $obj;
    my $records = $self->{records} || 0;
    $self->run_callback(
        MT->translate( "[_1] records restored...", $records ),
        $data->{LocalName} )
        if $records && ( $records % 10 == 0 );
    $self->{records} = $records + 1;
    my $cb = "restored.$name";
    $cb .= ":$ns"
        if MT::BackupRestore::NS_MOVABLETYPE() ne $ns;
    MT->run_callbacks( $cb, $obj, $self->{callback} );
    $obj->call_trigger( 'post_save', $obj );
}

sub __object_from_data {
    my ( $self, $column_data, $xml_data ) = @_;

    my $name    = $xml_data->{LocalName};
    my $ns      = $xml_data->{NamespaceURI};
    my $objects = $self->{objects};

    my ( $class, $obj );
    if ( MT::BackupRestore::NS_MOVABLETYPE() eq $ns ) {
        $class = MT->model($name);
        $obj   = $class->new;
    }
    else {

        # this is a non-MT object. try to use callback
        # but first, we kept the attributes in column_data
        my $deferred = $self->{deferred};
        my $callback = $self->{callback};
        my $attrs = $xml_data->{Attributes} = $column_data->{'%attributes'};
        $obj = MT->run_callbacks( "Restore.$name:$ns",
            $xml_data, $objects, $deferred, $callback );
        return unless $obj and ref $obj;
        delete $column_data->{'%attributes'};
        $class = ref $obj;
    }

    # Pass through even if an blog doesn't restore
    # the parent object
    my $success = $class->restore_parent_ids( $column_data, $objects );

    if ( !$success && ( 'blog' ne $name ) ) {
        $self->{deferred}->{ $class . '#' . $column_data->{id} } = 1;
        return;
    }

    while ( my ( $key, $value ) = each %$column_data ) {
        if ( ref $value ) {

            # this is a text sub-element. join it.
            $value = $self->__solicitate_text( $class, $key, $value );
            $column_data->{$key} = $value;
        }
    }

    require MT::Meta;
    my @metacolumns = MT::Meta->metadata_by_class( ref($obj) );
    my %metacolumns = map { $_->{name} => $_->{type} } @metacolumns;
    $self->{metacolumns}{ ref($obj) } = \%metacolumns;

    my %realcolumn_data
        = map { $_ => $self->{decoder}->( $column_data->{$_} ) }
        grep { !exists( $metacolumns{$_} ) }
        keys %$column_data;

    if ( !$success && 'blog' eq $name ) {
        $realcolumn_data{parent_id} = undef;
    }

    $obj->set_values( \%realcolumn_data );
    $obj->column( 'external_id', $realcolumn_data{external_id} )
        if $name eq 'author'
            && defined $realcolumn_data{external_id};
    foreach my $metacol ( keys %metacolumns ) {
        next
            if ( 'vclob' eq $metacolumns{$metacol} )
            || ( 'vblob' eq $metacolumns{$metacol} );
        $obj->$metacol( $column_data->{$metacol} );
    }
    return $obj;
}

# text fields that are represented by their own element in the XML
# need to be soliciated and decoded
sub __solicitate_text {
    my ( $self, $class, $column_name, $text_data ) = @_;
    my $text = join '', @$text_data;

    my $defs = $class->column_defs;
    if ( exists( $defs->{$column_name} ) ) {
        if ( 'blob' eq $defs->{$column_name}->{type} ) {
            $text = MIME::Base64::decode_base64($text);
            if ( substr( $text, 0, 4 ) eq 'SERG' ) {
                $text = MT::Serialize->unserialize($text);
            }
            return $$text;
        }
        else {
            return $self->{decoder}->($text);
        }
    }
    elsif ( my $metacolumns = $self->{metacolumns}{$class} ) {
        if ( my $type = $metacolumns->{$column_name} ) {
            if ( 'vblob' eq $type ) {
                $text = MIME::Base64::decode_base64($text);
                $text = MT::Serialize->unserialize($text);
                return $$text;
            }
            else {
                return $self->{decoder}->($text);
            }
        }
    }
    return;
}

sub __decoder_from_utf8 {
    my ($str) = @_;

    $str = Encode::decode_utf8($str) unless Encode::is_utf8($str);
    return $str;
}

#####################################################################
#
# class-specific pre-restoring callbacks

MT->add_callback( "$CbName.tag", 5, undef, \&__save_tag );

sub __save_tag {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;
    if ( my $tag
        = MT::Tag->load( { name => $obj->name }, { binary => { name => 1 } } )
        )
    {
        $self->{objects}->{"$class#$old_id"} = $tag;
        $self->{callback}->("\n");
        $self->{callback}->(
            MT->translate( "Tag '[_1]' exists in the system.", $obj->name ) );
        return 0;
    }
    return 1;
}

MT->add_callback( "$CbName.trackback", 5, undef, \&__save_trackback );

sub __save_trackback {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;
    my $term;
    my $message;
    if ( $obj->entry_id ) {
        $term = { entry_id => $obj->entry_id };
    }
    elsif ( $obj->category_id ) {
        $term = { category_id => $obj->category_id };
    }
    if ( my $tb = $class->load($term) ) {
        $obj->id( $tb->id );
    }
    return 1;
}

MT->add_callback( "$CbName.permission", 5, undef, \&__save_permission );

sub __save_permission {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;
    my $perm = $class->exist(
        {   author_id => $obj->author_id,
            blog_id   => $obj->blog_id
        }
    );
    return 0 if $perm;
    return 1;
}

MT->add_callback( "$CbName.objectscore", 5, undef, \&__save_objectscore );

sub __save_objectscore {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;
    my $score = $class->exist(
        {   author_id => $obj->author_id,
            object_id => $obj->object_id,
            object_ds => $obj->object_ds,
        }
    );
    return 0 if $score;
    return 1;
}

MT->add_callback( "$CbName.field", 5, undef, \&__save_field );

sub __save_field {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;

    # Available in propack only
    if ( $obj->blog_id == 0 ) {
        my $field = $class->exist(
            {   blog_id  => 0,
                basename => $obj->basename,
            }
        );
        return 0 if $field;
    }
    return 1;
}

MT->add_callback( "$CbName.role", 5, undef, \&__save_role );

sub __save_role {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;
    my $role = $class->load( { name => $obj->name } );
    if ($role) {
        my $old_perms = join '',
            sort { $a cmp $b } split( ',', $obj->permissions );
        my $cur_perms = join '',
            sort { $a cmp $b } split( ',', $role->permissions );
        if ( $old_perms eq $cur_perms ) {
            $self->{objects}->{"$class#$old_id"} = $role;
            return 0;
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
    return 1;
}

MT->add_callback( "$CbName.filter", 5, undef, \&__save_filter );

sub __save_filter {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;

    if ( $objects->{ "MT::Author#" . $obj->author_id } ) {
        my $existing_obj = $class->load(
            {   author_id => $obj->author_id,
                label     => $obj->label,
                object_ds => $obj->object_ds,
            }
        );
        if ($existing_obj) {
            $obj->id( $existing_obj->id );
        }
    }

    # Callback for restoring ID in the filter items
    MT->run_callbacks( 'restore_filter_item_ids', $obj, undef, $objects );
    return 1;
}

MT->add_callback( "$CbName.plugindata", 5, undef, \&__save_plugindata );

sub __save_plugindata {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;

    # Skipping System level plugindata
    # when it was found in the database.

    if ( $obj->key !~ /^configuration:blog:(\d+)$/i ) {
        if ( my $obj
            = MT->model('plugindata')->load( { key => $obj->key, } ) )
        {
            $self->{callback}->("\n");
            $self->{callback}->(
                MT->translate(
                    "The system level settings for plugin '[_1]' already exist.  Skipping this record.",
                    $obj->plugin
                )
            );
            return 0;
        }
    }
    return 1;
}

MT->add_callback( "$CbName.author", 5, undef, \&__save_author );

sub __save_author {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;
    my $existing_obj = $class->load( { name => $obj->name() } );
    return 1 unless $existing_obj;

    if ( $self->{app_user} && ( $existing_obj->id == $self->{app_user} ) ) {
        MT->log(
            {   message => MT->translate(
                    "User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.",
                    $obj->name
                ),
                level => MT::Log::INFO(),
                metadata =>
                    'Permissions and Associations have been restored.',
                class    => 'system',
                category => 'restore',
            }
        );
        $objects->{ "$class#" . $old_id } = $existing_obj;
        return 0;
    }
    else {
        MT->log(
            {   message => MT->translate(
                    "User with the same name '[_1]' found (ID:[_2]).  Restore replaced this user with the data backed up.",
                    $obj->name,
                    $old_id
                ),
                level => MT::Log::INFO(),
                metadata =>
                    'Permissions and Associations have been restored as well.',
                class    => 'system',
                category => 'restore',
            }
        );
        $obj->id( $existing_obj->id );

        my $child_classes = $obj->properties->{child_classes} || {};
        for my $class ( keys %$child_classes ) {
            eval "use $class;";
            $class->remove( { author_id => $obj->id, blog_id => '0' } );
        }
        $obj->userpic_asset_id(0);
        return 1;
    }
}

MT->add_callback( "$CbName.template", 5, undef, \&__save_template );

sub __save_template {
    my ( $cb, $self, $class, $obj, $old_id, $objects ) = @_;
    if ( !$obj->blog_id ) {
        my $existing_obj = $class->load(
            {   blog_id => 0,
                (   $obj->identifier
                    ? ( identifier => $obj->identifier )
                    : ( name => $obj->name )
                ),
            }
        );
        if ($existing_obj) {
            if ( $self->{overwrite_template} ) {
                $obj->id( $existing_obj->id );
            }
            else {
                $objects->{"$class#$old_id"} = $existing_obj;
                return 0;
            }
        }
    }
    return 1;
}

1;
