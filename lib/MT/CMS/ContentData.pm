package MT::CMS::ContentData;
use strict;
use warnings;

use MT::Blog;
use MT::ContentType;
use MT::Log;

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
                mode  => 'edit_content_data',
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

