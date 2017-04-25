# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package ContentType::App::CMS;

use strict;
use warnings;

use JSON ();

use MT;
use MT::CMS::Common;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ContentType;
use MT::ContentData;
use MT::Log;

{
    # TBD: Move to Core.

    no warnings 'redefine', 'once';

    *MT::Author::can_manage_content_types = sub {
        my $author = shift;
        return $author->is_superuser(@_);
    };

    *MT::Permission::can_edit_content_data = sub {
        my $self = shift;
        my ( $content_data, $author, $status ) = @_;
        die unless $author->isa('MT::Author');
        return 1 if $author->is_superuser();
        unless ( ref $content_data ) {
            $content_data = MT::ContentData->load($content_data)
                or return;
        }

        if (   !ref $self
            || $self->author_id != $author->id
            || $self->blog_id != $content_data->blog_id )
        {
            $self = $author->permissions( $content_data->blog_id )
                or return;
        }

        my $content_data_name = 'content_data_' . $content_data->id;

        return 1
            if $self->can_do("edit_all_${content_data_name}");

        my $own_content_data = $content_data->author_id == $author->id;

        if ( defined $status ) {
            return $own_content_data
                ? $self->can_do("edit_own_published_${content_data_name}")
                : $self->can_do("edit_all_published_${content_data_name}");
        }
        else {
            return $own_content_data
                ? $self->can_do("edit_own_unpublished_${content_data_name}")
                : $self->can_do("edit_all_unpublished_${content_data_name}");
        }
    };
}

sub init_app {
    my ( $cb, $app ) = @_;

    my @content_types = MT::ContentType->load();
    foreach my $content_type (@content_types) {
        my $obj_name = 'content_data_' . $content_type->id;

        $app->add_callback( "cms_pre_load_filtered_list.${obj_name}",
            0, $app, \&cms_pre_load_filtered_list );

        # feed
        $app->add_callback( "ActivityFeed.${obj_name}", 5, $app,
            '$ContentType::ContentType::Feed::feed_content_data' );
        $app->add_callback( "ActivityFeed.filter_object.${obj_name}",
            5, $app, '$ContentType::ContentType::Feed::filter_content_data' );
        $content_type->generate_object_log_class;
    }
    return 1;
}

sub tmpl_param_edit_role {
    my ( $cb, $app, $param, $tmpl ) = @_;

    $param->{content_type_perm_groups} = MT::ContentType->permission_groups;

    # Insert content type permission template.
    my $privileges_settinggroup_node
        = $tmpl->getElementById('role-privileges');
    my $content_type_permission_node = $tmpl->createElement( 'loop',
        { name => 'content_type_perm_groups' } );
    $content_type_permission_node->innerHTML(
        _content_type_permission_tmpl() );
    $privileges_settinggroup_node->appendChild($content_type_permission_node);
}

sub _content_type_permission_tmpl {
    return <<'__TMPL__';
    <mt:setvarblock name="ct_perm_group"><mt:var name="__VALUE__"></mt:setvarblock>
    <mtapp:setting
      id="<mt:var name="ct_perm_group">"
      label="<mt:var name="ct_perm_group">"
    >
      <ul class="fixed-width multiple-selection">
      <mt:loop name="loaded_permissions">
      <mt:if name="group" eq="$ct_perm_group">
        <li><label for="<mt:var name="id">"><input id="<mt:var name="id">" type="checkbox" onclick="togglePerms(this, '<mt:var name="children">')" class="<mt:var name="id"> cb" name="permission" value="<mt:var name="id">"<mt:if name="can_do"> checked="checked"</mt:if>> <mt:var name="label" escape="html"></label></li>
      </mt:if>
      </mt:loop>
      </ul>
    </mtapp:setting>
__TMPL__
}

sub cfg_content_type {
    my ( $app, $param ) = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;

    require MT::Promise;
    my $content_type_id = $q->param('id');
    my $obj_promise     = MT::Promise::delay(
        sub {
            return undef unless $content_type_id;
            return MT::ContentType->load( { id => $content_type_id } )
                || undef;
        }
    );

    my $content_type = $obj_promise->force();
    if ($content_type) {
        $param->{name}       = $content_type->name;
        $param->{unique_key} = $content_type->unique_key;
        my @array = map {
            $_->{content_field_id} = $_->{id};
            delete $_->{id};
            $_;
        } @{ $content_type->fields };
        @array = sort { $a->{order} <=> $b->{order} } @array;
        $param->{fields} = \@array;
    }

    foreach my $name (qw( saved err_msg id name )) {
        $param->{$name} = $q->param($name) if $q->param($name);
    }
    $app->build_page( $plugin->load_tmpl('cfg_content_type.tmpl'), $param );
}

sub save_cfg_content_type {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;
    my $param  = {};

    $app->validate_magic
        or return $app->errtrans("Invalid request.");
    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ( $perms
        && $perms->can_administer_blog );

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");

    my $content_type_id = $q->param('id');
    my $name            = $q->param('name');
    my $edited          = $q->param('edited');

    return $app->redirect(
        $app->uri(
            'mode' => 'cfg_content_type',
            args   => {
                id      => $content_type_id,
                err_msg => $plugin->translate(
                    "Name \"[_1]\" is already used.", $name
                ),
            }
        )
    ) if !$content_type_id && MT::ContentType->count( { name => $name } );

    my $content_type
        = $content_type_id
        ? MT::ContentType->load($content_type_id)
        : MT::ContentType->new();

    $content_type->blog_id($blog_id);
    $content_type->name($name);

    my @fields = map {
        $_->{order} = $q->param( 'order-' . $_->{id} );
        $_->{label} = $q->param('content-label') == $_->{id} ? 1 : 0;
        $_;
    } @{ $content_type->fields };
    $content_type->fields( \@fields );

    $content_type->save
        or return $app->error(
        $plugin->translate(
            "Saving content type failed: [_1]",
            $content_type->errstr
        )
        );

    return $app->redirect(
        $app->uri(
            'mode' => 'cfg_content_type',
            args   => {
                blog_id => $blog_id,
                id      => $content_type->id,
                saved   => 1,
            }
        )
    );
}

sub cfg_content_field {
    my ( $app, $param ) = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;

    my $blog_id                 = $q->param('blog_id');
    my $content_field_id        = $q->param('id');
    my $content_field_type      = $q->param('type') || '';
    my $related_cat_list_id     = $q->param('related_cat_list_id') || '';
    my $related_content_type_id = $q->param('related_content_type_id') || '';

    require MT::Promise;
    my $obj_promise = MT::Promise::delay(
        sub {
            return undef unless $content_field_id;
            return MT::ContentField->load($content_field_id) || undef;
        }
    );

    my $content_field = $obj_promise->force();
    if ($content_field) {
        $param->{name}    = $content_field->name;
        $param->{type}    = $content_field->type;
        $param->{default} = $content_field->default;
        $param->{options} = $content_field->options;
        $param->{related_cat_list_id}
            = $content_field->related_cat_list_id || '';
        $param->{related_content_type_id}
            = $content_field->related_content_type_id;
        $param->{unique_key} = $content_field->unique_key;
        $content_field_type = $content_field->type;
        $related_cat_list_id = $content_field->related_cat_list_id || '';
        $related_content_type_id = $content_field->related_content_type_id;
    }

    my $content_field_types = $app->registry('content_field_types');
    my @type_array          = map {
        my $hash = {};
        $hash->{type}     = $_;
        $hash->{label}    = $content_field_types->{$_}{label};
        $hash->{options}  = $content_field_types->{$_}{options};
        $hash->{order}    = $content_field_types->{$_}{order};
        $hash->{selected} = $_ eq $content_field_type ? 1 : 0;
        $hash;
    } keys %$content_field_types;
    @type_array = sort { $a->{order} <=> $b->{order} } @type_array;
    $param->{content_field_types} = \@type_array;

    my %content_field_types_options = map { ( $_->{type} => $_->{options} ) }
        grep { $_->{options} } @type_array;
    $param->{content_field_types_options}
        = JSON::encode_json( \%content_field_types_options );

    my @cat_lists_param;
    my @category_lists
        = MT->model('category_list')->load( { blog_id => $blog_id } );
    for my $cl (@category_lists) {
        push @cat_lists_param,
            {
            id       => $cl->id,
            name     => $cl->name,
            selected => $cl->id eq $related_cat_list_id,
            };
    }
    $param->{category_lists} = \@cat_lists_param;

    my @content_types = MT::ContentType->load( { blog_id => $blog_id } );
    my @c_array = map {
        my $hash = {};
        $hash->{id}   = $_->id;
        $hash->{name} = $_->name;
        $hash->{selected}
            = (    $_->id
                && $related_content_type_id
                && $_->id == $related_content_type_id ) ? 1 : 0;
        $hash;
    } @content_types;
    $param->{content_types} = \@c_array;

    foreach my $name (
        qw( saved err_msg content_type_id id name type default options ))
    {
        $param->{$name} = $q->param($name) if $q->param($name);
    }
    $app->build_page( $plugin->load_tmpl('cfg_content_field.tmpl'), $param );
}

sub save_cfg_content_field {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;
    my $param  = {};

    $app->validate_magic
        or return $app->errtrans("Invalid request.");
    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ( $perms
        && $perms->can_administer_blog );

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");
    my $content_type_id = scalar $q->param('content_type_id')
        or return $app->errtrans("Invalid request.");

    my $content_field_id        = $q->param('id');
    my $name                    = $q->param('name');
    my $type                    = $q->param('type');
    my $default                 = $q->param('default');
    my $options                 = $q->param('options');
    my $related_cat_list_id     = $q->param('related_cat_list_id');
    my $related_content_type_id = $q->param('related_content_type_id');

    return $app->redirect(
        $app->uri(
            'mode' => 'cfg_content_field',
            args   => {
                blog_id         => $blog_id,
                content_type_id => $content_type_id,
                id              => $content_field_id,
                err_msg         => $plugin->translate(
                    "Name \"[_1]\" is already used.", $name
                ),
                name                    => $name,
                type                    => $type,
                default                 => $default,
                options                 => $options,
                related_cat_list_id     => $related_cat_list_id,
                related_content_type_id => $related_content_type_id,
            }
        )
        )
        if !$content_field_id
        && MT::ContentField->count(
        { content_type_id => $content_type_id, name => $name } );

    my $content_field
        = $content_field_id
        ? MT::ContentField->load($content_field_id)
        : MT::ContentField->new();

    $content_field->blog_id($blog_id);
    $content_field->content_type_id($content_type_id);
    $content_field->name($name);
    $content_field->type($type);
    $content_field->options($options);
    $content_field->related_cat_list_id( $related_cat_list_id         || 0 );
    $content_field->related_content_type_id( $related_content_type_id || 0 );

    $content_field->save
        or return $app->error(
        $plugin->translate(
            "Saving content field failed: [_1]",
            $content_field->errstr
        )
        );

    my $content_type = MT::ContentType->load($content_type_id);
    my $fields       = $content_type->fields;
    if ( grep { $_->{id} == $content_field->id } @$fields ) {
        @$fields = map {
            if ( $_->{id} == $content_field->id ) {
                $_->{name} = $name;
                $_->{type} = $type;
            }
            $_;
        } @$fields;
    }
    else {
        push @$fields,
            {
            id         => $content_field->id,
            name       => $name,
            type       => $type,
            order      => scalar(@$fields) + 1,
            label      => ( scalar(@$fields) ? 0 : 1 ),
            unique_key => $content_field->unique_key,
            };
    }
    $content_type->fields($fields);

    $content_type->save
        or return $app->error(
        $plugin->translate(
            "Saving content type failed: [_1]",
            $content_type->errstr
        )
        );

    return $app->redirect(
        $app->uri(
            'mode' => 'cfg_content_field',
            args   => {
                blog_id         => $blog_id,
                content_type_id => $content_type_id,
                id              => $content_field->id,
                saved           => 1,
            }
        )
    );
}

sub delete_content_field {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;
    my $param  = {};

    #$app->validate_magic
    #    or return $app->errtrans("Invalid request.");
    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ( $perms
        && $perms->can_administer_blog );

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");
    my $content_type_id = scalar $q->param('content_type_id')
        or return $app->errtrans("Invalid request.");
    my $content_field_id = scalar $q->param('id')
        or return $app->errtrans("Invalid request.");

    my $content_field = MT::ContentField->load($content_field_id);
    $content_field->remove()
        or return $app->error(
        $plugin->translate(
            "Remove content field failed: [_1]",
            $content_field->errstr
        )
        );

    my $content_type = MT::ContentType->load($content_type_id);
    my @fields
        = grep { $_->{id} ne $content_field_id } @{ $content_type->fields };
    $content_type->fields( \@fields );

    $content_type->save
        or return $app->error(
        $plugin->translate(
            "Saving content type failed: [_1]",
            $content_type->errstr
        )
        );

    return $app->redirect(
        $app->uri(
            'mode' => 'cfg_content_type',
            args   => {
                blog_id => $blog_id,
                id      => $content_type_id,
                saved   => 1,
            }
        )
    );
}

sub select_list_content_type {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;
    my $param  = {};

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");

    my @content_types = MT::ContentType->load( { blog_id => $blog_id } );
    $param->{content_types} = \@content_types;

    $app->build_page( $plugin->load_tmpl('select_list_content_type.tmpl'),
        $param );
}

sub select_edit_content_type {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;
    my $param  = {};

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");

    my @content_types = MT::ContentType->load( { blog_id => $blog_id } );
    my @array;
    foreach my $content_type (@content_types) {
        my $hash = {};
        $hash->{id}      = $content_type->id;
        $hash->{blog_id} = $content_type->blog_id;
        $hash->{name}    = $content_type->name;
        my $unique_key = $content_type->unique_key;
        $hash->{can_edit} = 1
            if $app->permissions->can_do(
            'manage_content_type:' . $unique_key );
        push @array, $hash;
    }
    $param->{content_types} = \@array;

    $app->build_page( $plugin->load_tmpl('select_edit_content_type.tmpl'),
        $param );
}

sub edit_content_data {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;
    my $param  = {};

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");
    my $content_type_id = scalar $q->param('content_type_id')
        or return $app->errtrans("Invalid request.");

    my $content_type = MT::ContentType->load($content_type_id);

    $param->{name} = $content_type->name;

    my $array           = $content_type->fields;
    my $ct_unique_key   = $content_type->unique_key;
    my $content_data_id = scalar $q->param('id');

    my $data;
    if ($content_data_id) {
        my $content_data = MT::ContentData->load($content_data_id);
        $data = $content_data->data;
    }

    my $content_field_types = $app->registry('content_field_types');
    @$array = map {
        my $e_unique_key = $_->{unique_key};
        $_->{can_edit} = 1
            if $app->permissions->can_do( 'content_type:'
                . $ct_unique_key
                . '-content_field:'
                . $e_unique_key );
        $_->{content_field_id} = $_->{id};
        delete $_->{id};

        $_->{value}
            = $q->param( $_->{content_field_id} )
            ? $q->param( $_->{content_field_id} )
            : $content_data_id ? $data->{ $_->{content_field_id} }
            :                    '';

        my $content_field_type = $content_field_types->{ $_->{type} };
        if ( my $field_html = $content_field_type->{field_html} ) {
            if ( !ref $field_html ) {
                if ( $field_html =~ /\.tmpl$/ ) {
                    my $field_html_params
                        = $content_field_type->{field_html_params};
                    if ( !ref $field_html_params ) {
                        $field_html_params
                            = MT->handler_to_coderef($field_html_params);
                    }
                    if ( 'CODE' eq ref $field_html_params ) {
                        $field_html_params = $field_html_params->(
                            $app, $_->{content_field_id},
                            $_->{value}
                        );
                    }
                    $field_html = $plugin->load_tmpl( $field_html,
                        $field_html_params );
                }
                else {
                    $field_html = MT->handler_to_coderef($field_html);
                }
            }
            if ( 'CODE' eq ref $field_html ) {
                $_->{field_html}
                    = $field_html->( $app, $_->{content_field_id},
                    $_->{value} );
            }
            else {
                $_->{field_html} = $field_html;
            }
        }
        $_->{data_type} = $content_field_types->{ $_->{type} }{data_type};

        $_;
    } @$array;

    $param->{fields} = $array;

    foreach my $name (qw( saved err_msg content_type_id id )) {
        $param->{$name} = $q->param($name) if $q->param($name);
    }
    $app->build_page( $plugin->load_tmpl('edit_content_data.tmpl'), $param );
}

sub save_content_data {
    my ($app)  = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;
    my $param  = {};

    $app->validate_magic
        or return $app->errtrans("Invalid request.");
    my $perms = $app->permissions;
    return $app->permission_denied()
        unless $app->user->is_superuser()
        || ( $perms
        && $perms->can_administer_blog );

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");
    my $content_type_id = scalar $q->param('content_type_id')
        or return $app->errtrans("Invalid request.");

    my $content_type = MT::ContentType->load($content_type_id);
    my $fields       = $content_type->fields;

    my $content_data_id = scalar $q->param('id');

    my $content_field_types = $app->registry('content_field_types');

    my $data = {};
    foreach my $f (@$fields) {
        my $content_field_type = $content_field_types->{ $f->{type} };
        $data->{ $f->{id} }
            = _get_form_data( $app, $content_field_type, $f->{id} );
    }
    foreach my $f (@$fields) {
        my $content_field_type = $content_field_types->{ $f->{type} };
        my $param_name         = 'content-field-' . $f->{id};
        if ( my $ss_validator = $content_field_type->{ss_validator} ) {
            if ( !ref $ss_validator ) {
                $ss_validator = MT->handler_to_coderef($ss_validator);
            }
            if ( 'CODE' eq ref $ss_validator ) {
                $app->error(undef);
                my $result = $ss_validator->( $app, $f->{id} );
                if ( my $err = $app->errstr ) {
                    $data->{blog_id}         = $blog_id;
                    $data->{content_type_id} = $content_type_id;
                    $data->{id}              = $content_data_id;
                    $data->{err_msg}         = $err;
                    return $app->redirect(
                        $app->uri(
                            'mode' => 'edit_content_data',
                            args   => $data,
                        )
                    );
                }
            }
        }
    }

    my $content_data
        = $content_data_id
        ? MT::ContentData->load($content_data_id)
        : MT::ContentData->new();

    $content_data->author_id( $app->user->id ) unless $content_data->id;
    $content_data->blog_id($blog_id);
    $content_data->content_type_id($content_type_id);
    $content_data->data($data);
    $content_data->modified_by( $app->user->id ) if $content_data->id;
    $content_data->save
        or return $app->error(
        $plugin->translate(
            "Saving [_1] failed: [_2]", $content_type->name,
            $content_data->errstr
        )
        );

    return $app->redirect(
        $app->uri(
            'mode' => 'edit_content_data',
            args   => {
                blog_id         => $blog_id,
                content_type_id => $content_type_id,
                id              => $content_data->id,
                saved           => 1,
            }
        )
    );
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;
    my $object_ds = $filter->object_ds;
    $object_ds =~ /content_data_(\d+)/;
    my $content_type_id = $1;
    $load_options->{terms}{content_type_id} = $content_type_id;
}

sub _get_form_data {
    my ( $app, $content_field_type, $id ) = @_;

    if ( my $data_getter = $content_field_type->{data_getter} ) {
        if ( !ref $data_getter ) {
            $data_getter = MT->handler_to_coderef($data_getter);
        }
        if ( 'CODE' eq ref $data_getter ) {
            return $data_getter->( $app, $id );
        }
        else {
            return $data_getter;
        }
    }
    else {
        my $value = $app->param( 'content-field-' . $id );
        if ( defined $value && $value ne '' ) {
            $value;
        }
        else {
            undef;
        }
    }
}

sub delete_content_data {
    my $app = shift;
    $app->param( '_type', 'content_data' );
    MT::CMS::Common::delete($app);
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    my $content_type = $obj->content_type or return;

    $app->log(
        {   message => $app->translate(
                "[_1] (ID:[_2]) deleted by '[_3]'", $content_type->name,
                $obj->id,                           $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'content_data_' . $content_type->id,
            category => 'delete'
        }
    );
}

1;
