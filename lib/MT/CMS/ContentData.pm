# Movable Type (r) (C) 2007-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::CMS::ContentData;

use strict;
use warnings;

use MT::Blog;
use MT::ContentType;
use MT::Log;

sub edit {
    my ($app) = @_;
    my $q     = $app->param;
    my $blog  = $app->blog;
    my $cfg   = $app->config;
    my $param = {};
    my $data;

    my $blog_id = scalar $q->param('blog_id')
        or return $app->errtrans("Invalid request.");
    my $content_type_id = scalar $q->param('content_type_id')
        or return $app->errtrans("Invalid request.");
    my $content_type = MT::ContentType->load($content_type_id)
        or return $app->errtrans('Invalid request.');

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
    my $ct_unique_id    = $content_type->unique_id;
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

        $param->{title} = $content_data->title;

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
        $param->{title} = $app->param('title');

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
    my $convert_breaks
        = $content_data
        ? MT::Serialize->unserialize( $content_data->convert_breaks )
        : undef;
    my $blockeditor_data
        = $content_data
        ? $content_data->block_editor_data()
        : undef;
    my $content_field_types = $app->registry('content_field_types');
    @$array = map {
        my $e_unique_id = $_->{unique_id};
        $_->{can_edit} = 1
            if $app->permissions->can_do( 'content_type:'
                . $ct_unique_id
                . '-content_field:'
                . $e_unique_id );
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
            if ( $_->{type} eq 'select_box' || $_->{type} eq 'checkboxes' ) {
                my $delimiter = quotemeta( $_->{options_delimiter} || ',' );
                my @values = split $delimiter, $_->{options}{initial_value};
                $_->{value} = \@values;
            }
            else {
                $_->{value} = $_->{options}{initial_value};
            }
        }

        my $content_field_type = $content_field_types->{ $_->{type} };

        if ( my $field_html_params
            = $content_field_type->{field_html_params} )
        {
            if ( !ref $field_html_params ) {
                $field_html_params
                    = MT->handler_to_coderef($field_html_params);
            }
            if ( 'CODE' eq ref $field_html_params ) {
                $field_html_params = $field_html_params->( $app, $_ );
            }

            if ( ref $field_html_params eq 'HASH' ) {
                for my $key ( keys %{$field_html_params} ) {
                    unless ( exists $_->{$key} ) {
                        $_->{$key} = $field_html_params->{$key};
                    }
                }
            }
        }

        if ( my $field_html = $content_field_type->{field_html} ) {
            if ( !ref $field_html ) {
                if ( $field_html =~ /\.tmpl$/ ) {
                    my $plugin = $content_field_type->{plugin};
                    $field_html
                        = $plugin->id eq 'core'
                        ? $app->load_tmpl($field_html)
                        : $plugin->load_tmpl($field_html);
                    $field_html = $field_html->text if $field_html;
                }
                else {
                    $field_html = MT->handler_to_coderef($field_html);
                }
            }
            if ( 'CODE' eq ref $field_html ) {
                $_->{field_html} = $field_html->( $app, $_ );
            }
            else {
                $_->{field_html} = $field_html;
            }
        }

        $_->{data_type} = $content_field_types->{ $_->{type} }{data_type};
        if ( $_->{type} eq 'multi_line_text' ) {
            if ( $convert_breaks
                && exists $$convert_breaks->{ $_->{content_field_id} } )
            {
                $_->{convert_breaks}
                    = $$convert_breaks->{ $_->{content_field_id} };
            }
            else {
                $_->{convert_breaks} = $_->{options}{input_format};
            }
        }
        $_;
    } @$array;

    $param->{fields} = $array;
    if ($blockeditor_data) {
        $param->{block_editor_data} = $blockeditor_data;
    }

    foreach my $name (qw( saved err_msg content_type_id id )) {
        $param->{$name} = $q->param($name) if $q->param($name);
    }

    $param->{new_object}          = $content_data_id ? 0 : 1;
    $param->{object_label}        = $content_type->name;
    $param->{sitepath_configured} = $blog && $blog->site_path ? 1 : 0;

    ## Load text filters if user displays them
    my $filters = MT->all_text_filters;
    $param->{text_filters} = [];
    for my $filter ( keys %$filters ) {
        if ( my $cond = $filters->{$filter}{condition} ) {
            $cond = MT->handler_to_coderef($cond) if !ref($cond);
            next unless $cond->('content-type');
        }
        push @{ $param->{text_filters} },
            {
            filter_key   => $filter,
            filter_label => $filters->{$filter}{label},
            filter_docs  => $filters->{$filter}{docs},
            };
    }
    $param->{text_filters} = [ sort { $a->{filter_key} cmp $b->{filter_key} }
            @{ $param->{text_filters} } ];
    unshift @{ $param->{text_filters} },
        {
        filter_key   => '0',
        filter_label => $app->translate('None'),
        };

    $app->setup_editor_param($param);

    $app->build_page( $app->load_tmpl('edit_content_data.tmpl'), $param );
}

sub post_save {
    my ( $eh, $app, $obj, $orig_obj ) = @_;

    if ( $app->can('autosave_session_obj') ) {
        my $sess_obj = $app->autosave_session_obj;
        $sess_obj->remove if $sess_obj;
    }

    # TODO: save log

    1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    if ( $app->can('autosave_session_obj') ) {
        my $sess_obj = $app->autosave_session_obj;
        $sess_obj->remove if $sess_obj;
    }

    my $content_type = $obj->content_type or return;

    # TODO: add content data label.
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

sub data_convert_to_html {
    my $app     = shift;
    my $format  = $app->param('format') || '';
    my @formats = split /\s*,\s*/, $format;
    my $field   = $app->param('field') || return '';

    my $text = $app->param($field) || '';

    my $result = {
        $field => $app->apply_text_filters( $text, \@formats ),
        format => $formats[0],
        field  => $field,
    };
    return $app->json_result($result);
}

sub make_content_actions {
    my $iter            = MT::ContentType->load_iter;
    my $content_actions = {};
    while ( my $ct = $iter->() ) {
        my $key = 'content_data.content_data_' . $ct->id;
        $content_actions->{$key} = {
            new => {
                label => 'Create new ' . $ct->name,
                order => 100,
                mode  => 'view',
                args  => {
                    blog_id         => $ct->blog_id,
                    content_type_id => $ct->id,
                },
                class => 'icon-create',
            }
        };
    }
    $content_actions;
}

sub make_list_actions {
    my $common_delete_action = {
        delete => {
            label      => 'Delete',
            order      => 100,
            code       => '$Core::MT::CMS::ContentType::delete_content_data',
            button     => 1,
            js_message => 'delete',
        }
    };
    my $iter         = MT::ContentType->load_iter;
    my $list_actions = {};
    while ( my $ct = $iter->() ) {
        my $key = 'content_data_' . $ct->id;
        $list_actions->{$key} = $common_delete_action;
    }
    $list_actions;
}

sub make_menus {
    my $menus         = {};
    my $blog_order    = 100;
    my $website_order = 100;
    my $iter = MT::ContentType->load_iter( undef, { sort => 'name' } );
    while ( my $ct = $iter->() ) {
        my $blog = MT::Blog->load( $ct->blog_id ) or next;
        my $key = 'content_data:' . $ct->id;
        $menus->{$key} = {
            label => $ct->name,
            mode  => 'list',
            args  => {
                _type   => 'content_data',
                type    => 'content_data_' . $ct->id,
                blog_id => $ct->blog_id,
            },
            order => $blog->is_blog ? $blog_order : $website_order,
            view  => $blog->is_blog ? 'blog'      : 'website',
        };
        if ( $blog->is_blog ) {
            $blog_order += 100;
        }
        else {
            $website_order += 100;
        }
    }
    $menus;
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options, $cols ) = @_;

    my $object_ds = $filter->object_ds;
    $object_ds =~ /content_data_(\d+)/;
    my $content_type_id = $1;
    $load_options->{terms}{content_type_id} = $content_type_id;
}

sub start_import {
    my $app = shift;
    my $param = { page_title => $app->translate('Import Site Content'), };
    $app->load_tmpl( 'not_implemented_yet.tmpl', $param );
}

sub start_export {
    my $app = shift;
    my $param = { page_title => $app->translate('Export Site Content'), };
    $app->load_tmpl( 'not_implemented_yet.tmpl', $param );
}

1;

