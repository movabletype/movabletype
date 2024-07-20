package CopyThisContentData::CMS;
use strict;
use warnings;

use MT::CMS::ContentData;

sub hdlr_copy_this_content_data {
    my $app = shift;

    my $blog_id      = $app->blog ? $app->blog->id : undef;
    my $id           = $app->param('id');
    my $content_data = $id ? $app->model('content_data')->load($id) : undef;

    return $app->errtrans('Invalid request') unless $blog_id && $content_data;
    return $app->permission_denied
        unless MT::CMS::ContentData::can_save( undef, $app, undef,
        $content_data )
        && MT::CMS::ContentData::can_save( undef, $app, $id, $content_data );

    my $content_type_id = $content_data->content_type_id;

    $app->redirect(
        $app->uri(
            mode => 'view',
            args => {
                _type           => 'content_data',
                type            => 'content_data_' . $content_type_id,
                blog_id         => $blog_id,
                content_type_id => $content_type_id,
                origin          => $id,
            },
        )
    );
}

1;

