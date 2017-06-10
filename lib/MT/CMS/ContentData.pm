package MT::CMS::ContentData;
use strict;
use warnings;

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

1;

