## -*- mode: perl; coding: utf-8 -*-

use strict;
use warnings;

use Test::More;

use lib qw( t/lib lib extlib );
use MT::Test qw( :db );
use MT::Test::Permission;
use MT::Test::Upgrade;

my $blog_id = 1;

my $asset_file = MT::Test::Permission->make_asset(
    blog_id => $blog_id,
    class   => 'file',
);
my $asset_audio = MT::Test::Permission->make_asset(
    blog_id => $blog_id,
    class   => 'audio',
);
my $asset_video = MT::Test::Permission->make_asset(
    blog_id => $blog_id,
    class   => 'video',
);
my $asset_image = MT::Test::Permission->make_asset(
    blog_id => $blog_id,
    class   => 'image',
);

my $content_type
    = MT::Test::Permission->make_content_type( blog_id => $blog_id );

my $asset_field = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    type            => 'asset',
);
my $asset_audio_field = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    type            => 'asset_audio',
);
my $asset_video_field = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    type            => 'asset_video',
);
my $asset_image_field = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    type            => 'asset_image',
);

$content_type->fields(
    [   {   id      => $asset_field->id,
            order   => 1,
            type    => $asset_field->type,
            options => {
                label    => $asset_field->name,
                multiple => 1,
            },
            unique_id => $asset_field->unique_id,
        },
        {   id      => $asset_audio_field->id,
            order   => 2,
            type    => $asset_audio_field->type,
            options => {
                label    => $asset_audio_field->name,
                multiple => 1,
            },
            unique_id => $asset_audio_field->unique_id,
        },
        {   id      => $asset_video_field->id,
            order   => 3,
            type    => $asset_video_field->type,
            options => {
                label    => $asset_video_field->name,
                multiple => 1,
            },
            unique_id => $asset_video_field->unique_id,
        },
        {   id      => $asset_image_field->id,
            order   => 4,
            type    => $asset_image_field->type,
            options => {
                label    => $asset_image_field->name,
                multiple => 1,
            },
            unique_id => $asset_image_field->unique_id,
        },
    ]
);
$content_type->save or die $content_type->errstr;

my $content_data = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    data            => {
        $asset_field->id       => [ $asset_file->id ],
        $asset_audio_field->id => [ $asset_audio->id ],
        $asset_video_field->id => [ $asset_video->id ],
        $asset_image_field->id => [ $asset_image->id ],
    },
);

my @object_assets = MT->model('objectasset')->load(
    {   blog_id   => $blog_id,
        object_ds => 'content_data',
        object_id => $content_data->id,
    }
);
is( scalar @object_assets, 4, '4 new MT::ObjectAsset' );

for my $oa (@object_assets) {
    $oa->object_ds('content_field');
    $oa->object_id( $oa->cf_id );
    $oa->cf_id(0);
    $oa->save or die $oa->errstr;
}

is( MT->model('objectasset')->count( { object_ds => 'content_field' } ),
    4, '4 old MT::ObjectAsset' );
is( MT->model('objectasset')->count( { object_ds => 'content_data' } ),
    0, 'no new MT::ObjectAsset' );

MT::Test::Upgrade->upgrade( from => 7.0020 );

is( MT->model('objectasset')->count( { object_ds => 'content_field' } ),
    0, 'no old MT::ObjectAsset' );
is( MT->model('objectasset')->count( { object_ds => 'content_data' } ),
    4, '4 new MT::ObjectAsset' );

my $terms = {
    blog_id   => $blog_id,
    object_ds => 'content_data',
    object_id => $content_data->id,
};
is( MT->model('objectasset')->count(
        {   %$terms,
            cf_id    => $asset_field->id,
            asset_id => $asset_file->id,
        }
    ),
    1,
    'MT::ObjectAsset of file'
);
is( MT->model('objectasset')->count(
        {   %$terms,
            cf_id    => $asset_audio_field->id,
            asset_id => $asset_audio->id,
        }
    ),
    1,
    'MT::ObjectAsset of audio'
);
is( MT->model('objectasset')->count(
        {   %$terms,
            cf_id    => $asset_video_field->id,
            asset_id => $asset_video->id,
        }
    ),
    1,
    'MT::ObjectAsset of video'
);
is( MT->model('objectasset')->count(
        {   %$terms,
            cf_id    => $asset_image_field->id,
            asset_id => $asset_image->id,
        }
    ),
    1,
    'MT::ObjectAsset of image'
);

done_testing;

