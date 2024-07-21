package CopyThisContentData::CMS;
use strict;
use warnings;

use JSON ();

use MT::CMS::ContentData;
use MT::Serialize;

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

    $app->param( 'reedit', 1 );

    my $serialized_data = JSON::encode_json( $content_data->data );
    $app->param( 'serialized_data', $serialized_data );

    if (my $convert_breaks = MT::Serialize->unserialize($content_data->convert_breaks)) {
        for my $content_field_id (keys %{$$convert_breaks}) {
            my $key = "content-field-${content_field_id}_convert_breaks";
            $app->param($key, $$convert_breaks->{$content_field_id});
        }
    }

    MT::CMS::ContentData::edit($app);
}

1;

