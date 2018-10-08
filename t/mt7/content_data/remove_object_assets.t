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
            ]
        );
        $content_type->save or die $content_type->errstr;

        my $content_data = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $content_type->id,
            data            => {
                $asset_field->id       => [ $asset_file->id ],
                $asset_audio_field->id => [ $asset_audio->id ],
            },
        );
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
my $content_data = MT::ContentData->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
    },
);

subtest 'initial state' => sub {
    is( scalar @{ $content_data->data->{ $asset_field->id } },
        1, '1 data exists in asset field' );
    my @objassets = MT->model('objectasset')
        ->load( { object_ds => 'content_data', cf_id => $asset_field->id } );
    is( scalar @objassets, 1, '1 MT::ObjectAsset for asset field exists' );
    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $asset_field->id,
        }
    );
    is( scalar @cf_idx, 1, '1 MT::ContentFieldIndex for asset field exists' );

    is( scalar @{ $content_data->data->{ $asset_audio_field->id } },
        1, '1 data exists in asset_audio field' );
    my @objassets_for_audio
        = MT->model('objectasset')
        ->load(
        { object_ds => 'content_data', cf_id => $asset_audio_field->id } );
    is( scalar @objassets_for_audio,
        1, '1 MT::ObjectAsset for asset_audio field exists' );
    my @cf_idx_for_audio = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $asset_audio_field->id,
        }
    );
    is( scalar @cf_idx_for_audio,
        1, '1 MT::ContentFieldIndex for asset_audio field exists' );
};

subtest 'remove asset' => sub {
    my $asset_file = MT->model('asset')->load(
        {   blog_id => $blog_id,
            class   => 'file',
        }
    );
    $asset_file->remove or die $asset_file->errstr;

    $content_data->refresh;
    is( scalar @{ $content_data->data->{ $asset_field->id } },
        0, '1 data has been removed from asset field' );

    my @objassets = MT->model('objectasset')
        ->load( { object_ds => 'content_data', cf_id => $asset_field->id } );
    is( scalar @objassets,
        0, '1 MT::ObjectAsset has been removed from asset field' );

    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $asset_field->id,
        }
    );
    is( scalar @cf_idx,
        0, '1 MT::ContentFieldIndex has been removed from asset field' );
};

subtest 'remove objectasset' => sub {
    my $objasset = MT->model('objectasset')->load(
        {   object_ds => 'content_data',
            cf_id     => $asset_audio_field->id,
        }
    ) or die MT->model('objectasset')->errstr;
    MT->model('objectasset')->remove(
        {   object_ds => 'content_data',
            id        => $objasset->id,
        }
    );

    $content_data->refresh;
    is( scalar @{ $content_data->data->{ $asset_audio_field->id } },
        0, '1 data has been removed from asset_audio field' );

    my @objassets
        = MT->model('objectasset')
        ->load(
        { object_ds => 'content_data', cf_id => $asset_audio_field->id } );
    is( scalar @objassets,
        0, '1 MT::ObjectAsset has been removed from asset_audio field' );

    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $asset_audio_field->id,
        }
    );
    is( scalar @cf_idx,
        0,
        '1 MT::ContentFieldIndex has been removed from asset_audio field' );

};

done_testing;

