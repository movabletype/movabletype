# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package ContentType::App::CMS;

use strict;
use warnings;

use File::Spec;
use JSON  ();
use POSIX ();

use MT;
use MT::CMS::Common;
use MT::CategoryList;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ContentType;
use MT::ContentData;
use MT::DateTime;
use MT::Entry;
use MT::Log;
use MT::Util ();

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

sub tmpl_param_list_common {
    my ( $cb, $app, $param, $tmpl ) = @_;
    if (   $app->mode eq 'list'
        && $app->param('_type') =~ /^content_data_\d+$/ )
    {
        my $component = MT->component('ContentType');
        my $filename
            = File::Spec->catfile( $component->path, 'tmpl', 'listing',
            'content_data_list_header.tmpl' );
        push @{ $param->{list_headers} },
            {
            filename  => $filename,
            component => $component->id,
            };

        $param->{saved_deleted} = $app->param('saved_deleted') ? 1 : 0;
    }
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

sub cfg_content_type_description {
    my ( $app, $param ) = @_;
    my $q      = $app->param;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;

    $app->build_page( $plugin->load_tmpl('cfg_content_type_description.tmpl'),
        $param );
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
        $param->{name}        = $content_type->name;
        $param->{description} = $content_type->description;
        $param->{unique_key}  = $content_type->unique_key;
        my @array = map {
            $_->{content_field_id} = $_->{id};
            delete $_->{id};
            my $type    = $_->{type};
            my @options = ();
            foreach my $key ( keys %{ $_->{options} } ) {
                if ( $type eq 'date_and_time' && $key eq 'initial_value' ) {
                    my ( $date, $time ) = split ' ', $_->{options}{$key};
                    push @options,
                        {
                        key   => 'initial_date',
                        value => $date
                        },
                        {
                        key   => 'initial_time',
                        value => $time
                        };
                }
                elsif (
                    (      $type eq 'select_box'
                        || $type eq 'radio'
                        || $type eq 'checkbox'
                    )
                    && $key eq 'values'
                    )
                {
                    my $count  = 1;
                    my $values = delete $_->{options}{$key};
                    foreach my $pair ( @{$values} ) {
                        push @options,
                            {
                            key   => 'values_key_' . $count,
                            value => $pair->{key},
                            },
                            {
                            key   => 'values_value_' . $count,
                            value => $pair->{value},
                            };
                        $count++;
                    }
                }
                else {
                    push @options,
                        {
                        key   => $key,
                        value => $_->{options}{$key}
                        };
                }
            }
            $_->{options} = \@options;
            $_;
        } @{ $content_type->fields };
        @array = sort { $a->{order} <=> $b->{order} } @array;
        $param->{fields} = \@array;
    }

    # Content Field Types
    my $content_field_types = $app->registry('content_field_types');
    my @type_array          = map {
        my $hash = {};
        $hash->{type}    = $_;
        $hash->{label}   = $content_field_types->{$_}{label};
        $hash->{options} = $content_field_types->{$_}{options};
        $hash->{order}   = $content_field_types->{$_}{order};
        $hash;
    } keys %$content_field_types;
    @type_array = sort { $a->{order} <=> $b->{order} } @type_array;
    $param->{content_field_types} = \@type_array;

    # Content Filed Type Options
    my %content_field_types_option_settings = ();
    my %content_field_types_options         = map {
        my $type_name = $_->{type};
        (   $_->{type} => [
                map {
                    if ( ref($_) eq 'HASH' ) {
                        my $key = ( keys( %{$_} ) )[0];
                        $content_field_types_option_settings{$type_name}{$key}
                            = $_->{$key};
                        $key;
                    }
                    else {
                        $_;
                    }
                } @{ $_->{options} }
            ]
            )
        }
        grep { $_->{options} } @type_array;
    $param->{content_field_types_options}
        = JSON::encode_json( \%content_field_types_options );

    foreach my $name (qw( saved err_msg id name )) {
        $param->{$name} = $q->param($name) if $q->param($name);
    }

    my @category_lists;
    my $cl_iter = MT::CategoryList->load_iter( { blog_id => $app->blog->id },
        { fetchonly => { id => 1, name => 1 } } );
    while ( my $cat_list = $cl_iter->() ) {
        push @category_lists,
            {
            id   => $cat_list->id,
            name => $cat_list->name,
            };
    }
    $param->{category_lists} = \@category_lists;

    my @content_types;
    my $ct_iter = MT::ContentType->load_iter( { blog_id => $app->blog->id },
        { fetchonly => { id => 1, name => 1 } } );
    while ( my $ct = $ct_iter->() ) {
        next if ( $content_type_id || 0 ) == $ct->id;
        push @content_types,
            {
            id   => $ct->id,
            name => $ct->name,
            };
    }
    $param->{content_types} = \@content_types;

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

    my $option_list;
    if ( my $data = $q->param('data') ) {
        if ( $data =~ /^".*"$/ ) {
            $data =~ s/^"//;
            $data =~ s/"$//;
            $data = MT::Util::decode_js($data);
        }
        my $decode = JSON->new->utf8(0);
        $option_list = $decode->decode($data);
    }
    else {
        $option_list = {};
    }

    my $name        = $option_list->{name};
    my $description = $option_list->{description};

    return $app->redirect(
        $app->uri(
            'mode' => 'cfg_content_type',
            args   => {
                blog_id => $blog_id,
                id      => $content_type_id,
                err_msg => $plugin->translate("Name is required."),
            }
        )
    ) unless $name;

    return $app->redirect(
        $app->uri(
            'mode' => 'cfg_content_type',
            args   => {
                blog_id => $blog_id,
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

    $content_type->save
        or return $app->error(
        $plugin->translate(
            "Saving content type failed: [_1]",
            $content_type->errstr
        )
        );

    my @fields = ();
    foreach my $field_id ( keys %{ $option_list->{fields} } ) {
        my $type    = $option_list->{fields}{$field_id}{type};
        my $options = $option_list->{fields}{$field_id}{options};
        my $label   = $options->{label};
        if ( $type eq 'date_and_time' ) {
            my $date = delete $options->{initial_date};
            my $time = delete $options->{initial_time};
            $options->{initial_value} = "$date $time";
        }
        elsif ($type eq 'select_box'
            || $type eq 'radio'
            || $type eq 'checkbox' )
        {
            my $count  = 1;
            my @values = ();
            while ( $options->{ 'values_key_' . $count } ) {
                my $key   = delete $options->{ 'values_key_' . $count };
                my $value = delete $options->{ 'values_value_' . $count };
                push @values,
                    {
                    key   => $key,
                    value => $value
                    };
                $count++;
            }
            $options->{values} = \@values;
        }
        my $content_field;
        if ( $content_type_id && !$option_list->{fields}{$field_id}{new} ) {
            $content_field = MT::ContentField->load(
                {   content_type_id => $content_type_id,
                    name            => $label
                }
            );
        }
        unless ($content_field) {
            $content_field = MT::ContentField->new;
            $content_field->blog_id($blog_id);
            $content_field->content_type_id( $content_type->id );
            $content_field->type($type);
        }
        $content_field->name($label);
        $content_field->default( $options->{initial_value} );
        $content_field->description( $options->{description} );
        $content_field->required( $options->{required} );

        if ( $content_field->type eq 'category' ) {
            $content_field->related_cat_list_id( $options->{category_list} );
        }
        else {
            $content_field->related_cat_list_id(undef);
        }

        if ( $content_field->type eq 'content_type' ) {
            $content_field->related_content_type_id(
                $options->{content_type} );
        }
        else {
            $content_field->related_content_type_id(undef);
        }

        $content_field->save
            or return $app->error(
            $plugin->translate(
                "Saving content field failed: [_1]",
                $content_type->errstr
            )
            );
        delete $option_list->{fields}{$field_id}{new}
            if defined $option_list->{fields}{$field_id}{new};
        $option_list->{fields}{$field_id}{options} = $options;
        push @fields,
            {
            id         => $content_field->id,
            unique_key => $content_field->unique_key,
            %{ $option_list->{fields}{$field_id} }
            };
    }

    # Remove fields
    foreach my $field_id (
        split( ',', ( $option_list->{removed_fields} || '' ) ) )
    {
        MT::ContentField->remove( { id => $field_id } )
            or return $app->error(
            $plugin->translate(
                "Removing content type failed: [_1]",
                $content_type->errstr
            )
            );
    }

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

    my %content_field_types_option_settings = ();
    my %content_field_types_options         = map {
        my $type_name = $_->{type};
        (   $_->{type} => [
                map {
                    if ( ref($_) eq 'HASH' ) {
                        my $key = ( keys( %{$_} ) )[0];
                        $content_field_types_option_settings{$type_name}{$key}
                            = $_->{$key};
                        $key;
                    }
                    else {
                        $_;
                    }
                } @{ $_->{options} }
            ]
            )
        }
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

    my $options_html = '';

    foreach my $name ( keys %content_field_types_options ) {
        $options_html .= '<div id="' . $name . '-options">' . "\n";
        foreach my $option_name ( @{ $content_field_types_options{$name} } ) {
            my $option_settings
                = $content_field_types_option_settings{$name}{$option_name};
            if ( ref $option_settings eq 'HASH'
                && $option_settings->{field_html} )
            {
                my $field_html = $option_settings->{field_html};
                if ( !ref $field_html ) {
                    if ( $field_html =~ /\.tmpl$/ ) {
                        my $field_html_params
                            = $option_settings->{field_html_params};
                        if ( !ref $field_html_params ) {
                            $field_html_params
                                = MT->handler_to_coderef($field_html_params);
                        }
                        if ( 'CODE' eq ref $field_html_params ) {
                            $field_html_params = $field_html_params->(
                                $app,
                                {   type_name   => $name,
                                    option_name => $option_name
                                }
                            );
                        }
                        $field_html_params->{type_name}   = $name;
                        $field_html_params->{option_name} = $option_name;
                        $field_html_params->{label} = $plugin->translate(
                            $field_html_params->{label} );
                        $field_html = $plugin->load_tmpl( $field_html,
                            $field_html_params );
                        if ($field_html) {
                            $field_html = $field_html->output();
                        }
                    }
                    else {
                        $field_html = MT->handler_to_coderef($field_html);
                    }
                }
                if ( 'CODE' eq ref $field_html ) {
                    $options_html .= $field_html->(
                        $app,
                        { type_name => $name, option_name => $option_name }
                    );
                }
                else {
                    $options_html .= $field_html;
                }
            }
            else {
                my $tmpl
                    = $plugin->load_tmpl(
                    'content_field_type_options/' . $option_name . '.tmpl',
                    { name => $name } );
                if ($tmpl) {
                    $options_html .= $tmpl->output();
                }
            }
        }
        $options_html .= '</div>' . "\n";
    }
    $param->{options_html} = $options_html;

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
    my $blog   = $app->blog;
    my $plugin = $app->component("ContentType");
    my $cfg    = $app->config;
    my $param  = {};
    my $data;

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");
    my $content_type_id = scalar $q->param('content_type_id')
        or return $app->errtrans("Invalid request.");
    my $content_type = MT::ContentType->load($content_type_id)
        or return $app->errtrans('Invalid request.');

    $q->param( '_type', 'cd' );

    if ( $q->param('_recover') ) {
        my $sess_obj = $app->autosave_session_obj;
        if ($sess_obj) {
            my $autosave_data = $sess_obj->thaw_data;
            if ($autosave_data) {
                $q->param( $_, $autosave_data->{$_} )
                    for keys %$autosave_data;
                $app->delete_param('id')
                    if defined $q->param('id') && !$q->param('id');
                $data = $autosave_data->{data};
                $param->{'recovered_object'} = 1;
            }
            else {
                $param->{'recovered_failed'} = 1;
            }
        }
        else {
            $param->{'recovered_failed'} = 1;
        }
    }

    if ( !$q->param('reedit') ) {
        if ( my $sess_obj = $app->autosave_session_obj ) {
            $param->{autosaved_object_exists} = 1;
            $param->{autosaved_object_ts}
                = MT::Util::epoch2ts( $blog, $sess_obj->start );
        }
    }

    $param->{autosave_frequency} = $app->config->AutoSaveFrequency;
    $param->{name}               = $content_type->name;

    my $array           = $content_type->fields;
    my $ct_unique_key   = $content_type->unique_key;
    my $content_data_id = scalar $q->param('id');

    $param->{use_revision} = $blog->use_revision ? 1 : 0;

    my $content_data;
    if ($content_data_id) {
        $content_data = MT::ContentData->load($content_data_id)
            or return $app->error(
            $app->translate(
                'Load failed: [_1]',
                MT::ContentData->errstr
                    || $app->translate('(no reason given)')
            )
            );

        if ( $blog->use_revision ) {

            my $original_revision = $content_data->revision;
            my $rn                = $q->param('r');
            if ( defined $rn && $rn != $content_data->current_revision ) {
                my $status_text
                    = MT::Entry::status_text( $content_data->status );
                $param->{current_status_text} = $status_text;
                $param->{current_status_label}
                    = $app->translate($status_text);
                my $rev
                    = $content_data->load_revision( { rev_number => $rn } );
                if ( $rev && @$rev ) {
                    $content_data = $rev->[0];
                    my $values = $content_data->get_values;
                    $param->{$_} = $values->{$_} for keys %$values;
                    $param->{loaded_revision} = 1;
                }
                $param->{rev_number} = $rn;
                $param->{no_snapshot} = 1 if $q->param('no_snapshot');
            }
            $param->{rev_date} = MT::Util::format_ts(
                '%Y-%m-%d %H:%M:%S',
                $content_data->modified_on,
                $blog, $app->user ? $app->user->preferred_language : undef
            );
        }

        my $status = $q->param('status') || $content_data->status;
        $status =~ s/\D//g;
        $param->{status} = $status;
        $param->{ 'status_' . MT::Entry::status_text($status) } = 1;

        $param->{authored_on_date} = $q->param('authored_on_date')
            || MT::Util::format_ts( '%Y-%m-%d', $content_data->authored_on,
            $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{authored_on_time} = $q->param('authored_on_time')
            || MT::Util::format_ts( '%H:%M:%S', $content_data->authored_on,
            $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{unpublished_on_date} = $q->param('unpublished_on_date')
            || MT::Util::format_ts( '%Y-%m-%d', $content_data->unpublished_on,
            $blog, $app->user ? $app->user->preferred_language : undef );
        $param->{unpublished_on_time} = $q->param('unpublished_on_time')
            || MT::Util::format_ts( '%H:%M:%S', $content_data->unpublished_on,
            $blog, $app->user ? $app->user->preferred_language : undef );
    }
    else {
        my $def_status;
        if ( $def_status = $q->param('status') ) {
            $def_status =~ s/\D//g;
            $param->{status} = $def_status;
        }
        else {
            $def_status = $blog->status_default;
        }
        $param->{ "status_" . MT::Entry::status_text($def_status) } = 1;

        my @now = MT::Util::offset_time_list( time, $blog );
        $param->{authored_on_date} = $q->param('authored_on_date')
            || POSIX::strftime( '%Y-%m-%d', @now );
        $param->{authored_on_time} = $q->param('authored_on_time')
            || POSIX::strftime( '%H:%M:%S', @now );
        $param->{unpublished_on_date} = $q->param('unpublished_on_date');
        $param->{unpublished_on_time} = $q->param('unpublished_on_time');
    }

    $data = $content_data->data if $content_data && !$data;

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

        if ( $q->param( $_->{content_field_id} ) ) {
            $_->{value} = $q->param( $_->{content_field_id} );
        }
        elsif ( $content_data_id || $data ) {
            $_->{value} = $data->{ $_->{content_field_id} };
        }
        else {
            # TODO: fix after updating values option.
            if ( $_->{type} eq 'select_box' || $_->{type} eq 'checkbox' ) {
                my $delimiter = quotemeta( $_->{options_delimiter} || ',' );
                my @values = split $delimiter, $_->{options}{initial_value};
                $_->{value} = \@values;
            }
            else {
                $_->{value} = $_->{options}{initial_value};
            }
        }

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
                    $field_html = $field_html->output if $field_html;
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

    $param->{new_object}          = $content_data_id ? 0 : 1;
    $param->{object_label}        = $content_type->name;
    $param->{sitepath_configured} = $blog && $blog->site_path ? 1 : 0;

    $app->build_page( $plugin->load_tmpl('edit_content_data.tmpl'), $param );
}

sub save_content_data {
    my ($app)  = @_;
    my $blog   = $app->blog;
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

    if ( $app->param('_autosave') ) {
        return _autosave_content_data( $app, $data );
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

    my $orig = $content_data->clone;
    my $status_old = $content_data_id ? $content_data->status : 0;

    if ( $content_data->id ) {
        $content_data->modified_by( $app->user->id );
    }
    else {
        $content_data->author_id( $app->user->id );
        $content_data->blog_id($blog_id);
    }
    $content_data->content_type_id($content_type_id);
    $content_data->data($data);

    if ( $app->param('scheduled') ) {
        $content_data->status( MT::Entry::FUTURE() );
    }
    else {
        $content_data->status( scalar $q->param('status') );
    }
    if ( ( $content_data->status || 0 ) != MT::Entry::HOLD() ) {
        if ( !$blog->site_path || !$blog->site_url ) {
            return $app->error(
                $app->translate(
                    "Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined."
                )
            );
        }
    }

    my $ao_d = $q->param('authored_on_date');
    my $ao_t = $q->param('authored_on_time');
    my $uo_d = $q->param('unpublished_on_date');
    my $uo_t = $q->param('unpublished_on_time');

    # TODO: permission check
    if ($ao_d) {
        my %param = ();
        my $ao    = $ao_d . ' ' . $ao_t;
        unless ( $ao
            =~ m!^(\d{4})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?$!
            )
        {
            $param{error} = $app->translate(
                "Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.",
                $ao
            );
        }
        unless ( $param{error} ) {
            my $s = $6 || 0;
            $param{error} = $app->translate(
                "Invalid date '[_1]'; 'Published on' dates should be real dates.",
                $ao
                )
                if (
                   $s > 59
                || $s < 0
                || $5 > 59
                || $5 < 0
                || $4 > 23
                || $4 < 0
                || $2 > 12
                || $2 < 1
                || $3 < 1
                || ( MT::Util::days_in( $2, $1 ) < $3
                    && !MT::Util::leap_day( $0, $1, $2 ) )
                );
        }
        $param{return_args} = $app->param('return_args');
        return $app->forward( "view", \%param ) if $param{error};
        my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4, $5,
            ( $6 || 0 );
        $content_data->authored_on($ts);
    }

    # TODO: permission check
    if ( $content_data->status != MT::Entry::UNPUBLISH() ) {
        if ( $uo_d || $uo_t ) {
            my %param = ();
            my $uo    = $uo_d . ' ' . $uo_t;
            $param{error} = $app->translate(
                "Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.",
                $uo
                )
                unless ( $uo
                =~ m!^(\d{4})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?$!
                );
            unless ( $param{error} ) {
                my $s = $6 || 0;
                $param{error} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates should be real dates.",
                    $uo
                    )
                    if (
                       $s > 59
                    || $s < 0
                    || $5 > 59
                    || $5 < 0
                    || $4 > 23
                    || $4 < 0
                    || $2 > 12
                    || $2 < 1
                    || $3 < 1
                    || ( MT::Util::days_in( $2, $1 ) < $3
                        && !MT::Util::leap_day( $0, $1, $2 ) )
                    );
            }
            my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4, $5,
                ( $6 || 0 );
            unless ( $param{error} ) {
                $param{error} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.",
                    $uo
                    )
                    if (
                    MT::DateTime->compare(
                        blog => $blog,
                        a    => { value => time(), type => 'epoch' },
                        b    => $ts
                    ) > 0
                    );
            }
            if ( !$param{error} && $content_data->authored_on ) {
                $param{error} = $app->translate(
                    "Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.",
                    $uo
                    )
                    if (
                    MT::DateTime->compare(
                        blog => $blog,
                        a    => $content_data->authored_on,
                        b    => $ts
                    ) > 0
                    );
            }
            $param{show_input_unpublished_on} = 1 if $param{error};
            $param{return_args} = $app->param('return_args');
            return $app->forward( "view", \%param ) if $param{error};
            $content_data->unpublished_on($ts);
        }
        else {
            $content_data->unpublished_on(undef);
        }
    }

    $app->run_callbacks( 'cms_pre_save.cd', $app, $content_data, $orig );

    $content_data->save
        or return $app->error(
        $plugin->translate(
            "Saving [_1] failed: [_2]", $content_type->name,
            $content_data->errstr
        )
        );

    $app->run_callbacks( 'cms_post_save.cd', $app, $content_data, $orig );

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

sub _autosave_content_data {
    my ( $app, $data ) = @_;

    my $sess_obj = $app->autosave_session_obj(1) or return;
    $sess_obj->data('');
    my %data = $app->param_hash;
    delete $data{_autosave};
    delete $data{magic_token};
    $data{data} = $data;

    foreach my $c ( keys %data ) {
        $sess_obj->set( $c, $data{$c} );
    }
    $sess_obj->start(time);
    $sess_obj->save;
    $app->send_http_header("text/javascript+json");
    $app->{no_print_body} = 1;
    $app->print_encode("true");

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

    my $orig_type = $app->param('_type');
    my ($content_type_id) = $orig_type =~ /^content_data_(\d+)$/;

    $app->param( '_type', 'cd' );
    unless ( $app->param('content_type_id') ) {
        $app->param( 'content_type_id', $content_type_id );
    }

    MT::CMS::Common::delete($app);
}

1;
