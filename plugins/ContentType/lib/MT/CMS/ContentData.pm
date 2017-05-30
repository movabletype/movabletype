package MT::CMS::ContentData;
use strict;
use warnings;

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

1;

