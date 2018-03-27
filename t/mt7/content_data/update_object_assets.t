## -*- mode: perl; coding: utf-8 -*-

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

my $author_id = 1;
my $blog_id   = 1;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

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
            name            => 'asset',
        );
        my $asset_audio_field = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $content_type->id,
            type            => 'asset_audio',
            name            => 'asset_audio',
        );
        my $asset_video_field = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $content_type->id,
            type            => 'asset_video',
            name            => 'asset_video',
        );
        my $asset_image_field = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $content_type->id,
            type            => 'asset_image',
            name            => 'asset_image',
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
    }
);

my $asset_file = MT::Asset->load(
    {   blog_id => $blog_id,
        class   => 'file',
    }
);
my $asset_audio = MT::Asset->load(
    {   blog_id => $blog_id,
        class   => 'audio',
    }
);
my $asset_video = MT::Asset->load(
    {   blog_id => $blog_id,
        class   => 'video',
    }
);
my $asset_image = MT::Asset->load(
    {   blog_id => $blog_id,
        class   => 'image',
    }
);

my $content_type = MT::ContentType->load( { blog_id => $blog_id } );

my $asset_field = MT::ContentField->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'asset',
    }
);
my $asset_audio_field = MT::ContentField->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'asset_audio',
    }
);
my $asset_video_field = MT::ContentField->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'asset_video',
    }
);
my $asset_image_field = MT::ContentField->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'asset_image',
    }
);

my $content_data = MT::ContentData->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
    },
);

is( MT->model('objectasset')->count( { object_ds => 'content_field' } ),
    0, 'no old MT::ObjectAsset' );

my @object_assets
    = MT->model('objectasset')->load( { object_ds => 'content_data' } );
is( scalar @object_assets, 4, '4 new MT::ObjectAsset' );

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

subtest 'Do not remove unchanged record' => sub {
    $content_data->save or die $content_data->errstr;

    is( MT->model('objectasset')->count( { object_ds => 'content_data' } ),
        4, '4 MT::ObjectAsset' );

    for my $oa (@object_assets) {
        my $oa_id = $oa->id;
        ok( MT->model('objectasset')->exist($oa_id),
            "MT::ObjectAsset (ID:$oa_id) is not removed"
        );
    }
};

done_testing;

