# Movable Type (r) (C) 2006-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentField;

use strict;
use base qw( MT::Object );

use MT::ContentType;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'                      => 'integer not null auto_increment',
            'blog_id'                 => 'integer not null',
            'content_type_id'         => 'integer',
            'type'                    => 'string(255)',
            'name'                    => 'string(255)',
            'default'                 => 'string(255)',
            'description'             => 'string(255)',
            'options'                 => 'string(255)',
            'required'                => 'boolean',
            'related_content_type_id' => 'integer',
            'unique_key'              => 'blob',
        },
        indexes     => { blog_id => 1, content_type_id => 1 },
        datasource  => 'content_field',
        primary_key => 'id',
        audit       => 1,
        child_of    => ['MT::ContentType'],
    }
);

sub class_label {
    MT->translate("Content Field");
}

sub class_label_plural {
    MT->translate("Content Fields");
}

sub content_type {
    my $obj = shift;
    my $content_type
        = MT->model('content_type')->load( $obj->content_type_id );
    return $content_type;
}

sub permission {
    my ( $obj, $order ) = @_;
    my $content_type = $obj->content_type;
    my $permitted_action
        = 'content_type:'
        . $content_type->unique_key
        . '-entity:'
        . $obj->unique_key;
    my $name = 'blog.' . $permitted_action;
    return +{
        $name => {
            group            => $content_type->permission_group,
            label            => 'Manage "' . $obj->name . '" entity',
            permitted_action => { $permitted_action => 1 },
            $order ? ( order => $order ) : (),
        }
    };
}

sub post_save {
    my ( $cb, $obj, $original ) = @_;

    MT->app->reboot;
}

sub post_remove {
    my ( $cb, $obj, $original ) = @_;

    my $content_type = MT::ContentType->load( $obj->content_type_id );
    my $perm_name
        = 'content_type:'
        . $content_type->unique_key
        . '-entity:'
        . $obj->unique_key;
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

1;
