# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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
use MT::ContentFieldType::Common qw( field_type_icon );
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

    $app->validate_param({
        id => [qw/ID/],
    }) or return;

    return $app->return_to_dashboard( redirect => 1 )
        unless $app->blog;

    my $id = $app->param('id') || undef;
    my $class = $app->model('content_type');

    return $app->permission_denied
        unless can_view( undef, $app, $id );

    # Content Type
    my $field_data;
    if ( $param->{error} ) {
        $field_data = delete $param->{data};
        if ($field_data) {
            if ( $field_data =~ /^".*"$/ ) {
                $field_data =~ s/^"//;
                $field_data =~ s/"$//;
                $field_data = MT::Util::decode_js($field_data);
            }
            $field_data
                = JSON->new->utf8(0)->decode( MT::Util::decode_url($field_data) );
        }
    }
    else {
        if ($id) {
            my $obj = $class->load($id)
                or return $app->error(
                $app->translate(
                    "Load failed: [_1]",
                    $class->errstr || $app->translate("(no reason given)")
                )
                );

            return $app->trans_error('Invalid request.')
                unless $obj->blog_id == $app->blog->id;

            $param->{name}             = $obj->name;
            $param->{description}      = $obj->description;
            $param->{unique_id}        = $obj->unique_id;
            $param->{user_disp_option} = $obj->user_disp_option;
            $param->{label_field}      = $obj->data_label;

            $field_data = $obj->fields;
        }
        else {
            $param->{new_object} = 1;
            $param->{name}       = '';
        }
    }

    # Content Field
    my $random_id = sub {
        my $id;
        my @pool = ( 'a' .. 'z', 0 .. 9 );
        for ( 1 .. 5 ) { $id .= $pool[ rand @pool ] }
        return $id;
    };

    my @fields;
    my $content_field_types = $app->registry('content_field_types');
    for my $f (@$field_data) {
        my $type = $f->{type};
        $type =~ s/-/_/g;

        my $typeLabel = $content_field_types->{$type}->{label};
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
            = $content_field_types->{$type}{options_pre_load_handler};
        if ($pre_load_handler) {
            if ( !ref $pre_load_handler ) {
                $pre_load_handler = MT->handler_to_coderef($pre_load_handler);
            }
            if ( 'CODE' eq ref $pre_load_handler ) {
                $pre_load_handler->( $app, $options );
            }
        }

        # Can be used as a data label?
        my $can_data_label
            = $content_field_types->{$type}->{can_data_label_field} || 0;

        $type =~ s/_/-/g;
        my $field = {
            type      => $type,
            typeLabel => $typeLabel,
            label     => $f->{options}->{label},
            (     ( defined $f->{id} )
                ? ( id => $f->{id}, realId => $f->{id} )
                : ( id => $random_id->() )
            ),
            order   => $f->{order},
            options => $options,
            ( $f->{unique_id} ? ( unique_id => $f->{unique_id} ) : () ),
            canDataLabel => $can_data_label,
        };

        push @fields, $field;
    }
    $param->{fields} = JSON::to_json( @fields ? \@fields : [] );

    # Content Field Types
    my @type_array;
    my @unavailable_fields;
    for my $key ( keys %$content_field_types ) {
        my $label = $content_field_types->{$key}{label};
        $label = $label->()
            if ref $label eq 'CODE';
        my $type = $key;
        $type =~ s/_/-/g;

        my $warning;
        if ( my $validation
            = $content_field_types->{$key}{field_type_validation_handler} )
        {
            $validation = MT->handler_to_coderef($validation);
            $warning
                = $validation->( $app, $key, $content_field_types->{$key} )
                if $validation && ref $validation eq 'CODE';
        }

        # field type icon
        my $icon;
        if ( my $handler = $content_field_types->{$key}{icon_handler} ) {
            $handler = MT->handler_to_coderef(
                $content_field_types->{$key}{icon_handler} );
            if ( 'CODE' eq ref $handler ) {
                $icon
                    = $handler->( $app, $key, $content_field_types->{$key} );
            }
        }
        else {
            my $icon_class
                = $content_field_types->{$key}{icon_class} || undef;
            my $icon_title
                = $content_field_types->{$key}{icon_title} || undef;
            $icon = field_type_icon( $icon_class, $icon_title );
        }

        # Can be used as a data label?
        my $can_data_label
            = $content_field_types->{$key}->{can_data_label_field} ? 1 : 0;

        my $values = {
            type       => $type,
            label      => $label,
            order      => $content_field_types->{$key}{order},
            icon       => $icon,
            data_label => $can_data_label,
        };

        if ($warning) {
            $values->{warning} = $warning;
            push @unavailable_fields, $values;
        }
        else {
            push @type_array, $values;
        }
    }
    @type_array = sort { $a->{order} <=> $b->{order} } @type_array;
    $param->{content_field_types}             = \@type_array;
    $param->{content_field_types_json}        = JSON::to_json( \@type_array );
    $param->{unavailable_content_field_types} = \@unavailable_fields
        if @unavailable_fields;

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
                $options_html = $options_html->( $app, $param );

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

    $app->add_breadcrumb(
        $app->translate('Content Types'),
        $app->uri(
            mode => 'list',
            args => {
                _type   => 'content_type',
                blog_id => $app->blog->id,
            },
        ),
    );
    if ($id) {
        $app->add_breadcrumb( $param->{name} );
    }
    else {
        $app->add_breadcrumb( $app->translate('Create Content Type') );
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
}

sub save {
    my ($app) = @_;
    my $cfg   = $app->config;
    my $user  = $app->user;

    $app->validate_param({
        blog_id          => [qw/ID/],
        data             => [qw/MAYBE_STRING/],
        description      => [qw/MAYBE_STRING/],
        id               => [qw/ID/],
        label_field      => [qw/MAYBE_STRING/],
        name             => [qw/MAYBE_STRING/],
        user_disp_option => [qw/MAYBE_STRING/],
    }) or return;

    my %param = ();
    for my $col (qw{ name description user_disp_option label_field data }) {
        $param{$col} = $app->param($col);
    }

    # Permission Check
    $app->validate_magic
        or return $app->errtrans("Invalid request.");
    my $perms = $app->permissions
        or return $app->permission_denied();

    my $content_type_id = $app->param('id');

    return $app->permission_denied
        unless can_save( undef, $app, $content_type_id );

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
        $param{error} = $app->translate("The content type name is required.");
        $app->mode('view');
        return $app->forward( "view", \%param );
    }
    elsif ( length $name > 255 ) {
        $param{error} = $app->translate(
            "The content type name must be shorter than 255 characters.");
        $app->mode('view');
        return $app->forward( "view", \%param );
    }

    # Duplication check
    my $exists = $ct_class->count(
        {   name    => $name,
            blog_id => $blog_id,
            ( $content_type_id ? ( id => $content_type_id ) : () ),
        },
        { ( $content_type_id ? ( not => { id => 1 } ) : () ) }
    );
    if ($exists) {
        $param{error}
            = $app->translate( 'Name \'[_1]\' is already used.', $name );
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

    # Duplication check (just in case; this check should have been done before saving using JS)
    my %seen_field_names;
    for my $field (@$field_list) {
        my $name    = $field->{options}{label};
        my $lc_name = lc $name;
        if ( $seen_field_names{$lc_name} ) {
            my $prev = $seen_field_names{$lc_name};
            if ($prev ne $name) {
                $param{error} = $app->translate( 'Field \'[_1]\' and \'[_2]\' must not coexist within the same content type.', $prev, $name );
            } else {
                $param{error} = $app->translate( 'Field \'[_1]\' must be unique in this content type.', $name );
            }
            $app->mode('view');
            return $app->forward( "view", \%param );
        }
        $seen_field_names{$lc_name} = $name;
    }

    # Prepare save field data
    my @field_objects       = ();
    my $cf_class            = MT->model('content_field');
    my $content_field_types = $app->registry('content_field_types');
    my $data_label_field    = $app->param('label_field') || '';
    foreach my $field (@$field_list) {
        my $type     = $field->{type};
        my $field_id = $field->{id};

        if ( !exists $content_field_types->{$type} ) {
            $type =~ s/-/_/g;
            $field->{type} = $type;
        }

        # Validation
        if ( my $err_msg
            = _validate_content_field_type_options( $app, $field ) )
        {
            $param{error} = $err_msg;
            $app->mode('view');
            return $app->forward( "view", \%param );
        }

        # Create or load content field
        my $content_field;
        if ( $content_type_id && $field_id ) {
            $content_field = $cf_class->load($field_id)
                or return $app->errtrans(
                "Cannot load content field data (ID: [_1])", $field_id );
            $field->{label_field} = 1
                if $data_label_field
                && $data_label_field eq $content_field->unique_id;
        }
        else {
            $content_field = $cf_class->new;
            $content_field->blog_id($blog_id);
            $content_field->type($type);
            $field->{label_field} = 1
                if $data_label_field
                && $data_label_field eq $field->{options}->{id};
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
    my $display_option
        = $obj->id ? $app->param('user_disp_option') ? 1 : 0 : 1;
    $obj->blog_id($blog_id);
    $obj->name($name);
    $obj->description($description);
    $obj->user_disp_option($display_option);

    # Save content fields
    my @field_data = ();
    my $set_data_label;
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

        if ( $field->{label_field} ) {
            $obj->data_label( $content_field->unique_id );
            $set_data_label = 1;
        }
    }

    # Delete data_label if content field is not found in this type
    $obj->data_label(undef) unless $set_data_label;

    # Remove fields
    if ($content_type_id) {
        my @field_ids = map { $_->{object}->id } @field_objects;

        my $iter = $cf_class->load_iter(
            {   content_type_id => $content_type_id,
                ( @field_ids ? ( id => \@field_ids ) : () ),
            },
            { ( @field_ids ? ( not => { id => 1 } ) : () ), }
        );
        while ( my $content_field = $iter->() ) {
            if (   $content_field->type eq 'date_and_time'
                || $content_field->type eq 'date_only' )
            {
                if ( MT->model('templatemap')
                    ->count( { dt_field_id => $content_field->id } ) )
                {
                    $app->add_return_arg( not_deleted => 1 );
                    return $app->call_return;
                }
            }
            elsif ( $content_field->type eq 'categories' ) {
                if ( MT->model('templatemap')
                    ->count( { cat_field_id => $content_field->id } ) )
                {
                    $app->add_return_arg( not_deleted => 1 );
                    return $app->call_return;
                }
            }
        }

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

    $app->validate_param({
        content_field_id => [qw/ID/],
    }) or return;

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

    $app->validate_param({
        content_field_id => [qw/ID/],
        dialog           => [qw/MAYBE_STRING/],
        no_insert        => [qw/MAYBE_STRING/],
    }) or return;

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
            type     => 'content_data',
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

        $row->{id} = $obj->id;
        $row->{label}
            = $obj->label || MT->translate( 'No Label (ID:[_1])', $obj->id );
        $row->{modified_date} = MT::Util::format_ts( "%Y-%m-%d %H:%M:%S",
            $obj->modified_on, $obj->blog,
            $app->user ? $app->user->preferred_language : undef );
        $row->{author_name}
            = $obj->author
            ? ( $obj->author->nickname || $obj->author->name )
            : $app->translate('*User deleted*');
        $row->{preview_data} = $obj->preview_data;

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

    require MT::Object;
    my $driver = eval { MT::Object->driver };
    return
        unless $driver
        && $driver->table_exists( $app->model('content_type') );

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

    my $core_system_filters         = $core->registry('system_filters');
    my $content_data_system_filters = _make_content_data_system_filters($app);
    for my $key ( keys %{$content_data_system_filters} ) {
        $core_system_filters->{$key} = $content_data_system_filters->{$key};
    }

    my $core_tag_list_props = $core->registry( 'list_properties', 'tag' );
    my $tag_list_props = MT->model('content_type')->make_tag_list_props;
    for my $key ( keys %$tag_list_props ) {
        $core_tag_list_props->{$key} = $tag_list_props->{$key};
    }

    my $core_tag_system_filters = $core->registry( 'system_filters', 'tag' );
    my $tag_system_filters
        = MT->model('content_type')->make_tag_system_filters;
    for my $key ( keys %$tag_system_filters ) {
        $core_tag_system_filters->{$key} = $tag_system_filters->{$key};
    }
}

sub _make_content_data_system_filters {
    my ($app) = @_;
    my $common_system_filters
        = $app->registry( 'system_filters', 'content_data' );
    return {}
        unless $common_system_filters
        && ref $common_system_filters eq 'HASH'
        && %$common_system_filters;

    my $system_filters = {};
    for my $content_type ( @{ $app->model('content_type')->load_all } ) {
        my $key = 'content_data.content_data_' . $content_type->id;
        $system_filters->{$key} = {};
        for my $common_sf_key ( keys %$common_system_filters ) {
            $system_filters->{$key}{$common_sf_key}
                = $common_system_filters->{$common_sf_key};
        }
    }
    $system_filters;
}

sub _make_content_data_listing_screens {
    my $props = {};

    my $iter = MT->model('content_type')->load_iter;
    while ( my $ct = $iter->() ) {
        my $key = 'content_data.content_data_' . $ct->id;
        $props->{$key} = {
            primary          => 'label',
            default_sort_key => 'modified_on',
            screen_label     => sub {
                MT->translate( 'Manage [_1]', $ct->name );
            },
            object_label        => $ct->name,
            object_label_plural => $ct->name,
            object_type         => 'content_data',
            scope_mode          => 'this',
            use_filters         => 0,
            view                => [ 'website', 'blog' ],
            condition           => sub {
                my ($app) = @_;
                my $blog_id = $app->blog ? $app->blog->id : 0;
                return $app->trans_error('Invalid request.')
                    unless $blog_id == $ct->blog_id;
                1;
            },
            permission => sub {
                return [
                    'access_to_content_data_list_' . $ct->unique_id,
                    'access_to_content_data_list',
                ];
            },
            data_api_permission => undef,
            feed_link => sub {

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
    $app->add_breadcrumb( $app->translate('Content Type Boilerplates') );
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
            $orig_obj->id ? ( level => MT::Log::NOTICE() ) : ( level => MT::Log::INFO() ),
            class   => 'content_type',    ## trans('content_type')
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
            level    => MT::Log::NOTICE(),
            class    => 'content_type',
            category => 'delete'
        }
    );
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    my $user = $app->user or return;
    return unless $app->blog;

    my $blog_perm = $user->permissions( $app->blog->id );

    return 1
        if $user->can_do('edit_all_content_types')
        || ( $blog_perm && $blog_perm->can_do('edit_all_content_types') );

    return 1
        if !$id
        && ( $user->can_do('create_new_content_type')
        || ( $blog_perm && $blog_perm->can_do('create_new_content_type') ) );

    0;
}

sub can_view {
    my ( $eh, $app, $id ) = @_;
    my $user = $app->user or return;
    return unless $app->blog;

    my $blog_perm = $user->permissions( $app->blog->id );

    $user->can_do('edit_all_content_types')
        || ( $blog_perm && $blog_perm->can_do('edit_all_content_types') );
}

sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;
    my $user = $app->user or return;
    return unless $app->blog;

    my $blog_perm = $user->permissions( $app->blog->id );

    $user->can_do('manage_content_types')
        || ( $blog_perm && $blog_perm->can_do('manage_content_types') );
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $user = $app->user or return;
    return unless $app->blog;

    my $blog_perm = $user->permissions( $app->blog->id );

    $user->can_do('delete_content_type')
        || ( $blog_perm && $blog_perm->can_do('delete_content_type') );
}

sub build_content_type_table {
    my $app = shift;
    my (%args) = @_;

    my $iter;
    if ( $args{load_args} ) {
        $iter = MT->model('content_type')->load_iter( @{ $args{load_args} } );
    }
    elsif ( $args{iter} ) {
        $iter = $args{iter};
    }
    elsif ( $args{items} ) {
        $iter = sub { shift @{ $args{items} } };
    }
    return [] unless $iter;
    my $limit         = $args{limit};
    my $is_power_edit = $args{is_power_edit} || 0;
    my $param         = $args{param} || {};

    my @data;
    while ( my $content_type = $iter->() ) {
        my $row = {
            id          => $content_type->id,
            blog_id     => $content_type->blog_id,
            name        => $content_type->name,
            description => $content_type->description,
        };
        $row->{object} = $content_type;
        push @data, $row;
    }

    if (@data) {
        $param->{content_type_table}[0]{object_loop} = \@data;
        $param->{object_loop} = $param->{content_type_table}[0]{object_loop};
    }

    \@data;
}

1;
