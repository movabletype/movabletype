# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::CMS::ContentType;

use strict;
use warnings;

use File::Spec;
use JSON  ();
use POSIX ();
use Data::Dumper;

use MT;
use MT::CMS::Common;
use MT::CategorySet;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ContentType;
use MT::ContentData;
use MT::DateTime;
use MT::Entry;
use MT::Log;
use MT::Util ();
use MT::Serialize;

sub edit {
    my ( $app, $param ) = @_;
    my $cfg = $app->config;

    return $app->return_to_dashboard( redirect => 1 )
        unless $app->blog;

    my $id = $app->param('id') || undef;
    my $class = $app->model('content_type');

    # Content Type
    my $field_data;
    if ($id) {
        my $obj = $class->load($id)
            or return $app->error(
            $app->translate(
                "Load failed: [_1]",
                $class->errstr || $app->translate("(no reason given)")
            )
            );

        $param->{name}             = $obj->name;
        $param->{description}      = $obj->description;
        $param->{unique_id}        = $obj->unique_id;
        $param->{user_disp_option} = $obj->user_disp_option;

        $field_data = $obj->fields;
    }
    if ( $app->param('error') ) {
        for my $col (qw{ name description user_disp_option }) {
            $param->{$col} = $app->param($col);
        }

        $field_data = $app->param('data');
        if ( $field_data =~ /^".*"$/ ) {
            $field_data =~ s/^"//;
            $field_data =~ s/"$//;
            $field_data = MT::Util::decode_js($field_data);
        }
        $field_data = JSON::decode_json( MT::Util::decode_url($field_data) );
    }

    # Content Field
    my @fields;
    my $content_field_types = $app->registry('content_field_types');
    for my $f (@$field_data) {
        my $type = $f->{type};
        $type =~ s/_/-/g;

        my $typeLabel = $content_field_types->{ $f->{type} }->{label};
        $typeLabel = $typeLabel->()
            if 'CODE' eq ref $typeLabel;

        my $options = $f->{options};
        if ( $options->{required} ) {
            $options->{required} = 'checked';
        }
        else {
            $options->{required} = '';
        }

        my $pre_load_handler
            = $content_field_types->{ $f->{type} }{options_pre_load_handler};
        if ($pre_load_handler) {
            if ( !ref $pre_load_handler ) {
                $pre_load_handler = MT->handler_to_coderef($pre_load_handler);
            }
            if ( 'CODE' eq ref $pre_load_handler ) {
                $pre_load_handler->( $app, $options );
            }
        }

        my $field = {
            type      => $type,
            typeLabel => $typeLabel,
            label     => $f->{options}->{label},
            id        => $f->{id},
            order     => $f->{order},
            options   => $options,
            ( $f->{unique_id} ? ( unique_id => $f->{unique_id} ) : () ),
        };

        push @fields, $field;
    }
    $param->{fields} = JSON::to_json( @fields ? \@fields : [] );

    # Content Field Types
    my @type_array = map {
        my $label = $content_field_types->{$_}{label};
        $label = $label->()
            if ref $label eq 'CODE';
        my $type = $_;
        $type =~ s/_/-/g;
        my $hash = {};
        $hash->{type}  = $type;
        $hash->{label} = $label;
        $hash->{order} = $content_field_types->{$_}{order};
        $hash;
    } keys %$content_field_types;
    @type_array = sort { $a->{order} <=> $b->{order} } @type_array;
    $param->{content_field_types} = JSON::to_json( \@type_array );

    foreach my $name (qw( saved err_msg id name )) {
        $param->{$name} = $app->param($name) if $app->param($name);
    }

    # Content Field Options
    foreach my $key ( keys %$content_field_types ) {

        # Params
        my $options_html_params
            = $content_field_types->{$key}{options_html_params};
        if ($options_html_params) {
            if ( !ref $options_html_params ) {
                $options_html_params
                    = MT->handler_to_coderef($options_html_params);
            }
            if ( 'CODE' eq ref $options_html_params ) {
                $options_html_params = $options_html_params->( $app, $param );
            }
        }

        # Template
        if ( my $options_html = $content_field_types->{$key}{options_html} ) {
            my $plugin = $content_field_types->{$key}{plugin};
            my $tmpl;
            if ( !ref $options_html ) {
                if ( $options_html =~ /\.tmpl$/ ) {
                    $tmpl
                        = $plugin->id eq 'core'
                        ? $app->load_tmpl($options_html)
                        : $plugin->load_tmpl($options_html);
                }
                else {
                    $options_html = MT->handler_to_coderef($options_html);
                }
            }
            if ( 'CODE' eq ref $options_html ) {
                $options_html = $options_html->($plugin);

                require MT::Template;
                $tmpl = MT::Template->new(
                    type   => 'scalarref',
                    source => ref $options_html
                    ? $options_html
                    : \$options_html
                );
            }

            if ($tmpl) {
                $tmpl->param($options_html_params)
                    if $options_html_params;
                my $out = $tmpl->output();
                $out = $plugin->translate_templatized($out)
                    if $plugin->id ne 'core'
                    and $out =~ m/<(?:__trans|mt_trans) /i;
                push @{ $param->{options_htmls} },
                    { id => $key, html => $out };
            }
        }
    }

    $app->build_page( $app->load_tmpl('edit_content_type.tmpl'), $param );
}

sub tmpl_param_list_common {
    my ( $cb, $app, $param, $tmpl ) = @_;
    if ($app->mode eq 'list'
        && (   $app->param('_type') eq 'content_data'
            && $app->param('type') =~ /^content_data_(\d+)$/ )
        )
    {
        my $content_type_id = $1;
        my $content_type    = MT::ContentType->load($content_type_id);
        $param->{disable_user_disp_option} = !$content_type->user_disp_option;

        my $component = MT->component('core');
        my $filename
            = File::Spec->catfile( $component->path, 'tmpl', 'cms', 'listing',
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

sub save {
    my ($app) = @_;
    my $cfg   = $app->config;
    my $param = {};
    my $user  = $app->user;

    # Permission Check
    $app->validate_magic
        or return $app->errtrans("Invalid request.");
    my $perms = $app->permissions
        or return $app->permission_denied();

    my $content_type_id = $app->param('id');
    if ( !$content_type_id ) {
        return $app->permission_denied()
            unless $perms->can_do('create_new_content_type');
    }
    else {
        return $app->permission_denied()
            unless $perms->can_do('edit_all_content_types');
    }

    my $blog_id = $app->param('blog_id')
        or return $app->errtrans("Invalid request.");

    # Load or create object
    my ( $obj, $orig_obj );
    my $ct_class = MT->model('content_type');
    if ($content_type_id) {
        $obj = $ct_class->load($content_type_id)
            or return $app->error(
            $app->translate(
                'Cannot load content type #[_1]',
                $content_type_id
            )
            );
        return $app->error( $app->translate('Invalid parameter') )
            unless $obj->blog_id == $blog_id;
        $orig_obj = $obj->clone;
    }
    else {
        $obj      = $ct_class->new;
        $orig_obj = $obj->clone;
    }

    # Validation for content type
    my $name = $app->param('name');

    if ( !$name ) {
        my %param = ();
        $param{error} = $app->translate("The content type name is required.");
        $app->mode('view');
        return $app->forward( "view", \%param );
    }
    elsif ( length $name > 255 ) {
        my %param = ();
        $param{error} = $app->translate(
            "The content type name must be shorter than 255 characters.");
        $app->mode('view');
        return $app->forward( "view", \%param );
    }

    # Duplication check
    my $exists = $ct_class->count(
        {   name => $name,
            ( $content_type_id ? ( id => $content_type_id ) : () ),
        },
        { ( $content_type_id ? ( not => { id => 1 } ) : () ) }
    );
    if ($exists) {
        my %param = ();
        $param{error}
            = $app->translate( "Name \"[_1]\" is already used.", $name );
        $app->mode('view');
        return $app->forward( "view", \%param );
    }

    # Content Fields
    my $field_list;
    if ( my $data = $app->param('data') ) {
        if ( $data =~ /^".*"$/ ) {
            $data =~ s/^"//;
            $data =~ s/"$//;
            $data = MT::Util::decode_js($data);
        }
        my $decode = JSON->new->utf8(0);
        $field_list = $decode->decode($data);
    }
    else {
        $field_list = [];
    }

    # Prepare save field data
    my @field_objects       = ();
    my $cf_class            = MT->model('content_field');
    my $content_field_types = $app->registry('content_field_types');
    foreach my $field (@$field_list) {
        my $type = $field->{type};

        if ( !exists $content_field_types->{$type} ) {
            $type =~ s/-/_/g;
            $field->{type} = $type;
        }

        # Validation
        if ( my $err_msg
            = _validate_content_field_type_options( $app, $field ) )
        {
            my %param = ();
            $param{error} = $err_msg;
            $app->mode('view');
            return $app->forward( "view", \%param );
        }

        # Create or load content field
        my $content_field;
        if ( $content_type_id && $field->{id} ) {
            $content_field = $cf_class->load( $field->{id} )
                or return $app->errtrans(
                "Cannot load content field data (ID: [_1])",
                $field->{id} );
        }
        else {
            $content_field = $cf_class->new;
            $content_field->blog_id($blog_id);
            $content_field->type($type);
        }

        $content_field->name( $field->{options}->{label} );
        $content_field->description( $field->{description} );
        $content_field->required( $field->{required} );

        # Pre save manipurator
        my $options = $field->{options};
        delete $options->{id} if exists $options->{id};

        if ( my $pre_save
            = $content_field_types->{$type}{options_pre_save_handler} )
        {
            if ( !ref $pre_save ) {
                $pre_save = MT->handler_to_coderef($pre_save);
            }
            if ( 'CODE' eq ref $pre_save ) {
                $pre_save->( $app, $type, $content_field, $options );
                $field->{options} = $options;
            }
        }

        # Push content field object
        push @field_objects,
            {
            object => $content_field,
            data   => $field,
            };
    }

    # Update content type object
    my $description = $app->param('description');
    my $display_option = $app->param('user_disp_option') ? 1 : 0;
    $obj->blog_id($blog_id);
    $obj->name($name);
    $obj->description($description);
    $obj->user_disp_option($display_option);

    # Save content fields
    my @field_data = ();
    foreach my $field_data (@field_objects) {
        my $content_field = $field_data->{object};
        my $field         = $field_data->{data};

        $content_field->modified_by( $user->id ) if $content_field->id;
        $content_field->save
            or return $app->error(
            $app->translate(
                "Saving content field failed: [_1]",
                $content_field->errstr
            )
            );

        my $type_label = $content_field_types->{ $field->{type} }->{label};
        $type_label = $type_label->() if 'CODE' eq ref $type_label;
        my $store_data = {
            id         => $content_field->id,
            unique_id  => $content_field->unique_id,
            order      => $field->{order},
            type       => $field->{type},
            type_label => $type_label,
            options    => $field->{options},
        };
        push @field_data, $store_data;
    }

    # Remove fields
    if ($content_type_id) {
        my @field_ids = map { $_->{object}->id } @field_objects;
        $cf_class->remove(
            {   content_type_id => $content_type_id,
                ( @field_ids ? ( id => \@field_ids ) : () ),
            },
            { ( @field_ids ? ( not => { id => 1 } ) : () ), }
        );
    }

    $obj->fields( \@field_data );

    $app->run_callbacks( 'cms_pre_save.content_type', $app, $obj, $orig_obj )
        || return $app->error(
        $app->translate(
            "Saving [_1] failed: [_2]", $ct_class->class_label,
            $app->errstr
        )
        );

    $obj->modified_by( $user->id ) if $obj->id;

    $obj->save
        or return $app->error(
        $app->translate( "Saving content type failed: [_1]", $obj->errstr ) );

    $app->run_callbacks( 'cms_post_save.content_type', $app, $obj,
        $orig_obj );

    # Set content_type id for each content_field
    foreach my $field_data (@field_objects) {
        my $content_field = $field_data->{object};
        $content_field->content_type_id( $obj->id );
        $content_field->save
            or return $app->error(
            $app->translate(
                "Saving content field failed: [_1]",
                $content_field->errstr
            )
            );
    }

    return $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                blog_id => $blog_id,
                _type   => 'content_type',
                id      => $obj->id,
                saved   => 1,
            }
        )
    );
}

sub _validate_content_field_type_options {
    my ( $app, $field ) = @_;

    my $type    = $field->{type};
    my $options = $field->{options};
    my $label   = $options->{label};

    my $content_field_types = $app->registry('content_field_types');
    my $field_label         = $content_field_types->{$type}{label};

    # Common options (label, description, required and display option)
    if ( !$options->{label} ) {
        return $app->translate(
            "A label for content field of '[_1]' is required.",
            $field_label );
    }
    if ( length( $options->{label} ) > 255 ) {
        return $app->translate(
            "A label for content field of '[_1]' should be shorter than 255 characters.",
            $field_label
        );
    }
    if ( length( $options->{description} ) > 1024 ) {
        return $app->translate(
            "A description for content field of '[_1]' should be shorter than 255 characters.",
            $field_label
        );
    }

    # Validation for each content field
    if ( my $validator
        = $content_field_types->{$type}{options_validation_handler} )
    {
        if ( !ref $validator ) {
            $validator = MT->handler_to_coderef($validator);
        }
        if ( 'CODE' eq ref $validator ) {
            my $err
                = $validator->( $app, $type, $label, $field_label, $options );
            return $err if $err;
        }
    }

    return;
}

sub select_list_content_type {
    my ($app) = @_;
    my $cfg   = $app->config;
    my $param = {};

    my $blog_id = $app->param('blog_id')
        or return $app->errtrans("Invalid request.");

    my @content_types;
    my $iter = MT::ContentType->load_iter( { blog_id => $blog_id } );
    while ( my $ct = $iter->() ) {
        push @content_types, $ct;
    }
    $param->{content_types} = \@content_types;

    $app->build_page( $app->load_tmpl('content_data/select_list.tmpl'),
        $param );
}

sub select_edit_content_type {
    my ($app) = @_;
    my $cfg   = $app->config;
    my $param = {};

    my $blog_id = $app->param('blog_id')
        or return $app->errtrans("Invalid request.");

    my @array;
    my $iter = MT::ContentType->load_iter( { blog_id => $blog_id } );
    while ( my $content_type = $iter->() ) {
        my $hash = {};
        $hash->{id}      = $content_type->id;
        $hash->{blog_id} = $content_type->blog_id;
        $hash->{name}    = $content_type->name;
        my $unique_id = $content_type->unique_id;

        $hash->{can_edit} = 1
            if (
            $app->permissions->can_do( 'manage_content_type:' . $unique_id )
            || $app->permissions->can_do('edit_all_content_types') );
        push @array, $hash;
    }
    $param->{content_types} = \@array;

    $app->build_page( $app->load_tmpl('content_data/select_edit.tmpl'),
        $param );
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

sub dialog_content_data_modal {
    my $app = shift;

    my ( $can_multi, $content_type_id, $content_type_name );
    my $content_field_id = $app->param('content_field_id');
    if ($content_field_id) {
        if ( my $content_field = MT::ContentField->load($content_field_id) ) {
            my $options = $content_field->options;
            $can_multi = $options->{multiple} ? 1 : 0;
            $content_type_id = $content_field->related_content_type_id;
            if ( my $content_type = $content_field->related_content_type ) {
                $content_type_name = $content_type->name;
            }
        }
    }

    my $param = {
        can_multi         => $can_multi,
        content_field_id  => $content_field_id,
        content_type_id   => $content_type_id,
        content_type_name => $content_type_name,
    };

    $app->load_tmpl( 'dialog/content_data_modal.tmpl', $param );
}

sub dialog_list_content_data {
    my $app              = shift;
    my $blog             = $app->blog;
    my $content_field_id = $app->param('content_field_id') || 0;
    my $content_field    = MT::ContentField->load($content_field_id);

    return $app->return_to_dashboard( redirect => 1 )
        unless $blog && $content_field->related_content_type_id;

    # TODO: permission check

    my $terms = {
        blog_id         => $blog->id,
        content_type_id => $content_field->related_content_type_id,
    };
    my $args = {
        sort      => 'modified_on',
        direction => 'descend',
    };
    my $hasher = _build_content_data_hasher($app);

    my $dialog    = $app->param('dialog')    ? 1 : 0;
    my $no_insert = $app->param('no_insert') ? 1 : 0;

    $app->listing(
        {   terms    => $terms,
            args     => $args,
            type     => 'cd',
            code     => $hasher,
            template => 'include/content_data_list.tmpl',
            params   => {
                (   $blog
                    ? ( blog_id      => $blog->id,
                        blog_name    => $blog->name || '',
                        edit_blog_id => $blog->id,
                        ( $blog->is_blog ? ( blog_view => 1 ) : () ),
                        )
                    : (),
                ),
                can_multi => $content_field->options->{multiple} ? 1 : 0,
                dialog_view => 1,
                dialog      => $dialog,
                no_insert   => $no_insert,
            },
        }
    );
}

sub _build_content_data_hasher {
    my $app = shift;
    sub {
        my ( $obj, $row, %param ) = @_;

        $row->{id}            = $obj->id;
        $row->{modified_date} = MT::Util::format_ts( "%Y-%m-%d %H:%M:%S",
            $obj->modified_on, $obj->blog,
            $app->user ? $app->user->preferred_language : undef );
        $row->{author_name}
            = $obj->author
            ? ( $obj->author->nickname || $obj->author->name )
            : $app->translate('*User deleted*');

        $row;
    };
}

sub content_actions {
    my $app = MT->instance;

    return {
        new => {
            label => 'Create new content type',
            order => 100,
            mode  => 'view',
            args  => sub {
                return {
                    _type   => 'content_type',
                    blog_id => $app->blog->id,
                };
            },
            class => 'icon-create',
        }
    };
}

sub list_actions {
    {   delete => {
            label      => 'Delete',
            order      => 100,
            button     => 1,
            js_message => 'delete',
            code       => '$Core::MT::CMS::Common::delete',
        }
    };
}

sub init_content_type {
    my ( $cb, $app ) = @_;
    my $core = $app->component('core');

    my $core_listing_screens         = $core->registry('listing_screens');
    my $content_data_listing_screens = _make_content_data_listing_screens();
    for my $key ( keys %{$content_data_listing_screens} ) {
        $core_listing_screens->{$key} = $content_data_listing_screens->{$key};
    }

    my $core_list_props         = $core->registry('list_properties');
    my $content_data_list_props = MT::ContentData::make_list_props();
    for my $key ( keys %{$content_data_list_props} ) {
        $core_list_props->{$key} = $content_data_list_props->{$key};
    }
}

sub _make_content_data_listing_screens {
    my $props = {};

    my $iter = MT->model('content_type')->load_iter;
    while ( my $ct = $iter->() ) {
        my $key = 'content_data.content_data_' . $ct->id;
        $props->{$key} = {
            primary             => 'id',
            default_sort_key    => 'modified_on',
            screen_label        => 'Manage ' . $ct->name,
            object_label        => $ct->name,
            object_label_plural => $ct->name,
            object_type         => 'content_data',
            scope_mode          => 'this',
            use_filters         => 0,
            view                => [ 'website', 'blog' ],
            feed_link           => sub {

                # TODO: fix permission
                my ($app) = @_;
                return 1 if $app->user->is_superuser;

                if ( $app->blog ) {
                    return 1
                        if $app->user->can_do( "get_${key}_feed",
                        at_least_one => 1 );
                }
                else {
                    my $iter = MT->model('permission')->load_iter(
                        {   author_id => $app->user->id,
                            blog_id   => { not => 0 },
                        }
                    );
                    my $cond;
                    while ( my $p = $iter->() ) {
                        $cond = 1, last
                            if $p->can_do("get_${key}_feed");
                    }
                    return $cond ? 1 : 0;
                }
                0;
            },
        };
    }

    return $props;
}

sub list_boilerplates {
    my $app = shift;
    my $param
        = { page_title => $app->translate('Manage Content Type Boilerplates'),
        };
    $app->load_tmpl( 'not_implemented_yet.tmpl', $param );
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $orig_obj ) = @_;

    return 1 unless $orig_obj;

    my $author = $app->user;

    my $message;
    my $meta_message;
    if ( !$orig_obj->id ) {
        $message
            = $app->translate(
            "Content Type '[_1]' (ID:[_2]) added by user '[_3]'",
            $obj->name, $obj->id, $author->name );
    }
    else {
        # check to see what changed and add a flag to meta_messages
        my %cols = %{ $obj->column_defs };
        foreach my $key (
            qw{ created_on created_by modified_on modified_by id fields })
        {
            delete $cols{$key};
        }

        my @meta_messages = ();
        for my $col ( keys %cols ) {
            my $old
                = defined $orig_obj->$col()
                ? $orig_obj->$col()
                : "";
            my $new = defined $obj->$col() ? $obj->$col() : "";
            if ( $new ne $old ) {
                $old = "none" if $old eq "";
                $new = "none" if $new eq "";
                push(
                    @meta_messages,
                    $app->translate(
                        "[_1] changed from [_2] to [_3]",
                        $col, $old, $new
                    )
                );
            }
        }

        my %new_fields = map { $_->{unique_id} => $_ } @{ $obj->fields };
        my %old_fields = map { $_->{unique_id} => $_ } @{ $orig_obj->fields };
        for my $field_id ( keys %new_fields ) {
            if ( !exists $old_fields{$field_id} ) {
                push(
                    @meta_messages,
                    $app->translate(
                        "A content field '[_1]' ([_2]) was added",
                        $new_fields{$field_id}->{options}->{label},
                        $new_fields{$field_id}->{type_label}
                    )
                );
            }
            elsif ( exists $old_fields{$field_id} ) {
                my $old_val = MT::Util::perl_sha1_digest_hex(
                    Dumper( $old_fields{$field_id}->{options} ) );
                my $new_val = MT::Util::perl_sha1_digest_hex(
                    Dumper( $new_fields{$field_id}->{options} ) );
                if ( $old_val ne $new_val ) {
                    push(
                        @meta_messages,
                        $app->translate(
                            "A content field options of '[_1]' ([_2]) was changed",
                            $old_fields{$field_id}->{options}->{label},
                            $old_fields{$field_id}->{type_label}
                        )
                    );
                }
                delete $old_fields{$field_id};
            }
        }
        if ( keys %old_fields ) {
            my $deleted = join ',',
                map { $old_fields{$_}->{options}->{label} } keys %old_fields;
            push(
                @meta_messages,
                $app->translate(
                    "Some content fields were deleted: ([_1])", $deleted
                )
            );

        }

        if ( scalar(@meta_messages) > 0 ) {
            $meta_message = join( ", ", @meta_messages );
        }

        $message
            = $app->translate(
            "Content Type '[_1]' (ID:[_2]) edited by user '[_3]'",
            $obj->name, $obj->id, $author->name );
    }
    require MT::Log;
    $app->log(
        {   message => $message,
            level   => MT::Log::INFO(),
            class   => 'content_type',
            $orig_obj->id ? ( category => 'edit' ) : ( category => 'new' ),
            ( $meta_message ? ( metadata => $meta_message ) : () ),
        }
    );

    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Content Type '[_1]' (ID:[_2]) deleted by '[_3]'",
                $obj->name, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'content_type',
            category => 'delete'
        }
    );
}

1;
