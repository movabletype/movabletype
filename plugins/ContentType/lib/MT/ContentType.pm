# Movable Type (r) (C) 2006-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentType;

use strict;
use base qw( MT::Object );

use JSON ();

use MT::ContentType::UniqueKey;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'          => 'integer not null auto_increment',
            'blog_id'     => 'integer not null',
            'name'        => 'string(255)',
            'description' => 'text',
            'version'     => 'integer',
            'unique_key'  => 'blob',
            'fields'      => 'blob',
        },
        indexes     => { blog_id => 1 },
        datasource  => 'content_type',
        primary_key => 'id',
        audit       => 1,
        child_of      => [ 'MT::Blog', 'MT::Website' ],
        child_classes => [
            'MT::ContentData', 'MT::ContentField', 'MT::ContentFieldIndex'
        ],
    }
);

sub class_label {
    MT->translate("Content Type");
}

sub class_label_plural {
    MT->translate("Content Types");
}

sub unique_key {
    my $self = shift;
    $self->column('unique_key');
}

sub save {
    my $self = shift;

    unless ( $self->id ) {
        my $unique_key
            = MT::ContentType::UniqueKey::generate_unique_key( $self->name );
        $self->column( 'unique_key', $unique_key );
    }

    $self->SUPER::save(@_);
}

sub parents {
    my $obj = shift;
    {   blog_id => {
            class    => [ MT->model('blog'), MT->model('website') ],
            optional => 1
        },
    };
}

sub fields {
    my $obj = shift;
    if (@_) {
        my @fields = ref $_[0] eq 'ARRAY' ? @{ $_[0] } : @_;
        my $sorted_fields = _sort_fields( \@fields );
        my $json = eval { JSON::encode_json($sorted_fields) } || '[]';
        $obj->column( 'fields', $json );
    }
    else {
        my $fields
            = eval { JSON::decode_json( $obj->column('fields') ) } || [];
        _sort_fields($fields);
    }
}

sub _sort_fields {
    my $fields = shift;
    return [] unless $fields && ref $fields eq 'ARRAY';
    my @sorted_fields = sort { $a->{order} <=> $b->{order} } @{$fields};
    \@sorted_fields;
}

sub get_field {
    my $self = shift;
    my ($field_id) = @_ or return;
    my ($field)
        = grep { $_->{id} && $_->{id} == $field_id } @{ $self->fields };
    $field;
}

sub label_field {
    my $self = shift;
    @{ $self->fields } ? $self->fields->[0] : undef;
}

sub field_objs {
    my $obj = shift;
    my @field_objs
        = map { MT->model('content_field')->load( $_->{id} || 0 ) }
        @{ $obj->fields };
    return \@field_objs;
}

sub permissions {
    my $self = shift;
    return +{ $self->permission, %{ $self->field_permissions } };
}

sub permission {
    my $self = shift;
    (   $self->_create_content_data_permission,
        $self->_publish_content_data_permission,
        $self->_edit_all_content_data_permission,
    );
}

sub _create_content_data_permission {
    my $self            = shift;
    my $permission_name = 'blog.create_content_data:' . $self->unique_key;
    (   $permission_name => {
            group => $self->permission_group,
            label => 'Create Content Data',
            order => 100,
        }
    );
}

sub _publish_content_data_permission {
    my $self            = shift;
    my $permission_name = 'blog.publish_content_data:' . $self->unique_key;
    (   $permission_name => {
            group            => $self->permission_group,
            label            => 'Publish Content Data',
            order            => 200,
            permitted_action => {
                'edit_own_published_content_data_' . $self->id   => 1,  # TODO
                'edit_own_unpublished_content_data_' . $self->id => 1,  # TODO
                'publish_own_content_data_'
                    . $self->id => 1,    # TODO: unique_id?
            },
        }
    );
}

sub _edit_all_content_data_permission {
    my $self            = shift;
    my $permission_name = 'blog.edit_all_content_data:' . $self->unique_key;
    (   $permission_name => {
            group            => $self->permission_group,
            label            => 'Edit All Content Data',
            order            => 300,
            permitted_action => {
                'edit_all_content_data_' . $self->id => 1,  # TODO: unique_id?
                'edit_all_published_content_data_' . $self->id   => 1,  # TODO
                'edit_all_unpublished_content_data_' . $self->id => 1,  # TODO
                'publish_all_content_data_'
                    . $self->id => 1,    # TODO: unique_id?
            },
        }
    );
}

sub field_permissions {
    my $obj = shift;
    my %permissions;
    my $order = 200;
    for my $f ( @{ $obj->field_objs } ) {
        %permissions = ( %permissions, %{ $f->permission($order) } );
        $order += 100;
    }
    return \%permissions;
}

sub permission_group {
    my $obj = shift;
    return '"' . $obj->name . '" content type';
}

# class method
sub permission_groups {
    my $class         = shift;
    my @content_types = __PACKAGE__->load;
    my @groups        = map { $_->permission_group } @content_types;
    return \@groups;
}

# class method
sub all_permissions {
    my $class = shift;
    my @content_types = eval { __PACKAGE__->load }
        || ();    # TODO: many error occurs without "eval" in test.
    my %all_permission = map { %{ $_->permissions } } @content_types;
    return \%all_permission;
}

sub post_save {
    my ( $cb, $obj, $original ) = @_;

    MT->app->reboot;
}

sub post_remove {
    my ( $cb, $obj, $original ) = @_;

    $obj->remove_children( { key => 'content_type_id' } );

    my $perm_name = 'manage_content_type:' . $obj->unique_key;
    require MT::Role;
    my @roles = MT::Role->load_by_permission($perm_name);
    foreach my $role (@roles) {
        my $permissions = $role->permissions;
        my @permissions = split ',', $permissions;
        @permissions = grep { $_ !~ /$perm_name/ } @permissions;
        @permissions = map { $_ =~ s/'//g; $_; } @permissions;
        $role->clear_full_permissions;
        $role->set_these_permissions(@permissions);
        $role->save;
    }

    MT->app->reboot;
}

sub generate_object_log_class {
    my $self = shift;
    return unless $self->id;

    eval $self->_generate_object_log_code;
    die $@ if $@;
}

sub _generate_object_log_code {
    my $self = shift;
    my $id   = $self->id;

    return <<"__CODE__";
package MT::Log::ContentData${id};
use strict;
use warnings;
use base qw( MT::Log );

use MT;

__PACKAGE__->install_properties({ class_type => 'content_data_${id}' });

sub class_label {
    MT->translate('Content Data');
}

sub metadata_class {
    'MT::ContentData';
}

sub description {
    my \$self = shift;
    if ( my \$content_data = \$self->metadata_object ) {
        \$content_data->to_hash->{'cd.text_html'};
    } else {
        MT->translate( 'Content Data # [_1] not found.', \$self->metadata );
    }
}

1;
__CODE__
}

1;
