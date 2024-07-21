package CopyThisContentData::CMS;
use strict;
use warnings;

use MT::CMS::ContentData;

sub hdlr_copy_this_content_data {
    my $app = shift;

    $app->validate_param({
        origin => [qw/ID/],
    }) or return;

    my $blog_id      = $app->blog ? $app->blog->id : undef;
    my $id           = $app->param('origin');
    my $content_data = $id ? $app->model('content_data')->load($id) : undef;

    return $app->errtrans('Invalid request') unless $blog_id && $content_data;
    return $app->permission_denied
        unless MT::CMS::ContentData::can_save( undef, $app, undef,
        $content_data )
        && MT::CMS::ContentData::can_save( undef, $app, $id, $content_data );

    MT::CMS::ContentData::edit($app);
}

1;

