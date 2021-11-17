# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ContentField;

use strict;
use warnings;
use base qw( MT::Object );

use MT;
use MT::CategorySet;
use MT::ContentType;
use MT::ContentType::UniqueID;

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'                      => 'integer not null auto_increment',
            'blog_id'                 => 'integer not null',
            'content_type_id'         => 'integer',
            'type'                    => 'string(255)',
            'name'                    => 'string(255)',
            'default'                 => 'string(255)',
            'description'             => 'string(255)',
            'required'                => 'boolean',
            'related_content_type_id' => 'integer',
            'related_cat_set_id'      => 'integer',
            'unique_id'               => 'string(40) not null',
        },
        indexes => {
            blog_id         => 1,
            content_type_id => 1,
            unique_id       => { unique => 1 },
        },
        datasource      => 'cf',
        long_datasource => 'content_field',
        primary_key     => 'id',
        audit           => 1,
        child_classes   => [
            'MT::ContentFieldIndex', 'MT::ObjectAsset',
            'MT::ObjectCategory',    'MT::ObjectTag'
        ],
        child_of => [ 'MT::Blog', 'MT::ContentType' ],
    }
);

__PACKAGE__->add_callback( 'post_save', 5, MT->component('core'),
    \&_post_save );

__PACKAGE__->add_callback( 'pre_remove', 5, MT->component('core'),
    \&_pre_remove );

sub class_label {
    MT->translate("Content Field");
}

sub class_label_plural {
    MT->translate("Content Fields");
}

sub list_props {
    return +{
        id => {
            base    => '__virtual.id',
            display => 'none',
        },
        created_on => {
            base    => '__virtual.created_on',
            display => 'none',
        },
        label => {
            bulk_sort => sub {
                my ( $props, $objs ) = @_;
                return @$objs unless @$objs;
                sort { $a->name cmp $b->name } @$objs;
            },
            display => 'none',
        },
        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
        type => {
            auto    => 1,
            display => 'none',
        },
        user_custom => {
            bulk_sort => sub {
                my ( $props, $objs ) = @_;
                return @$objs unless @$objs;
                my $content_type = $objs->[0]->content_type;
                return @$objs unless $content_type;
                my %obj_hash = map { $_->id => $_ } @$objs;
                my @field_ids = map { $_->{id} } @{ $content_type->fields };
                map      { $obj_hash{$_} }
                    grep { exists $obj_hash{$_} } @field_ids;
            },
            display => 'none',
        },
        content => {
            base    => '__virtual.content',
            fields  => [qw(name)],
            display => 'none',
        },
    };
}

sub unique_id {
    my $self = shift;
    if ( $self->id || !@_ ) {
        $self->column('unique_id');
    }
    else {
        $self->column( 'unique_id', @_ );
    }
}

sub save {
    my $self = shift;

    if ( !$self->id && !defined $self->unique_id ) {
        MT::ContentType::UniqueID::set_unique_id($self);
    }

    $self->SUPER::save(@_);
}

sub remove {
    my ( $self, $terms, $args ) = @_;

    if ( !ref $self ) {
        my @content_fields = __PACKAGE__->load( $terms, $args );
        foreach my $content_field (@content_fields) {
            require MT::Role;
            my @roles = MT::Role->load(
                {   'permissions' => {
                        like => '%-content_field:'
                            . $content_field->unique_id . '%'
                    }
                }
            );
            my $perm_name
                = 'content_type:.*?'
                . '-content_field:'
                . $content_field->unique_id;
            foreach my $role (@roles) {
                my $permissions = $role->permissions;
                my @permissions = split ',', $permissions;
                @permissions = grep { $_ !~ /'$perm_name'/ } @permissions;
                @permissions = map { $_ =~ s/'//g; $_; } @permissions;
                $role->clear_full_permissions;
                $role->set_these_permissions(@permissions);
                $role->save;
            }
            $content_field->remove();
        }
    }
    else {
        my $ret = $self->SUPER::remove(@_);
        $self->remove_children if $self->id;
        MT->app->reboot;
        return $ret;
    }

    1;
}

sub content_type {
    my $obj = shift;
    my $content_type
        = MT->model('content_type')->load( $obj->content_type_id || 0 );
    return $content_type;
}

sub permission {
    my ( $obj, $order ) = @_;
    my $content_type = $obj->content_type;
    my $permitted_action
        = 'content_type:'
        . $content_type->unique_id
        . '-content_field:'
        . $obj->unique_id;
    my $name = 'blog.' . $permitted_action;
    return +{
        $name => {
            group => $content_type->permission_group,
            label => $obj->name,
            permitted_action => { $permitted_action => 1 },
            $order ? ( order => $order ) : (),
            content_type_unique_id => $content_type->unique_id,
        }
    };
}

sub _post_save {
    my ( $cb, $obj, $original ) = @_;

    MT->app->reboot;
}

sub _pre_remove {
    my ( $cb, $obj, $original ) = @_;

    my $content_type = MT::ContentType->load( $obj->content_type_id || 0 );
    my $perm_name
        = 'content_type:'
        . $content_type->unique_id
        . '-content_field:'
        . $obj->unique_id;
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

sub related_content_type {
    my $self = shift;
    $self->cache_property(
        'related_content_type',
        sub {
            return unless $self->type eq 'content_type';
            MT::ContentType->load( $self->related_content_type_id || 0 );
        },
    );
}

sub related_cat_set {
    my $self = shift;
    $self->cache_property(
        'related_cat_set',
        sub {
            return unless $self->type eq 'category';
            MT::CategorySet->load( $self->related_cat_set_id || 0 );
        },
    );
}

sub options {
    my $self = shift;
    ( $self->content_type->get_field( $self->id ) || {} )->{options} || {};
}

{
    my %Request_cache;

    sub get_parent_content_type_ids {
        my $class = shift;
        my ( $ct_id, $loop_count ) = @_;

        $loop_count ||= 0;
        return if $loop_count >= 3;

        %Request_cache = () unless $loop_count;
        return $Request_cache{$ct_id} if exists $Request_cache{$ct_id};

        my %parent_ct_id_hash;
        my $iter = __PACKAGE__->load_iter(
            { related_content_type_id => $ct_id },
            { fetchonly               => { content_type_id => 1 } },
        );
        while ( my $cf = $iter->() ) {
            $parent_ct_id_hash{ $cf->content_type_id } = 1;
        }
        for my $parent_ct_id ( keys %parent_ct_id_hash ) {
            my $grantparent_ct_ids
                = __PACKAGE__->get_parent_content_type_ids( $parent_ct_id,
                $loop_count + 1 );
            $parent_ct_id_hash{$_} = 1 for @{ $grantparent_ct_ids || [] };
        }
        $Request_cache{$ct_id}
            = %parent_ct_id_hash ? [ keys %parent_ct_id_hash ] : undef;
    }
}

sub is_parent_content_type_id {
    my $class = shift;
    my ( $ct_id, $child_ct_id ) = @_;
    return unless $ct_id && $child_ct_id;
    my $parent_ct_ids
        = __PACKAGE__->get_parent_content_type_ids($child_ct_id) || [];
    ( grep { $_ == $ct_id } @{$parent_ct_ids} ) ? 1 : 0;
}

sub type_registry {
    my $self = shift;
    return unless defined $self->type && $self->type ne '';
    MT->registry( 'content_field_types', $self->type )
      or $self->error(
        MT->translate(
            "Cannot load content field data_type [_1]", $self->type
        )
      );

}

sub data_type {
    my $self = shift;
    my $type_registry = $self->type_registry or return;
    $type_registry->{data_type};
}

sub load_by_id_or_name {
    my ( $class, $id_or_name, $ct_id ) = @_;

    my $cf;
    if ( $id_or_name =~ /\A[0-9]+\z/ ) {
        $cf = $class->load($id_or_name);
        return $cf if $cf;
    }
    if ( $id_or_name =~ /\A[a-zA-Z0-9]{40}\z/ ) {
        $cf = $class->load( { unique_id => $id_or_name } );
        return $cf if $cf;
    }
    if ( defined $ct_id ) {
        $cf = $class->load(
            { name => $id_or_name, content_type_id => $ct_id } );
    }
    $cf;
}

1;
