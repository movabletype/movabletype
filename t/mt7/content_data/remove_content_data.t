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

        my @asset_file;
        for ( 0 .. 2 ) {
            my $asset = MT::Test::Permission->make_asset(
                blog_id => $blog_id,
                class   => 'file',
            );
            push @asset_file, $asset;
        }

        my @tags;
        for my $name ( 'foo', 'bar', 'baz' ) {
            my $tag = MT::Test::Permission->make_tag( name => $name );
            push @tags, $tag;
        }

        my $category_set
            = MT::Test::Permission->make_category_set( blog_id => $blog_id );
        my @categories;
        for ( 0 .. 2 ) {
            my $cat = MT::Test::Permission->make_category(
                blog_id         => $blog_id,
                category_set_id => $category_set->id,
            );
            push @categories, $cat;
        }

        my $child_ct = MT::Test::Permission->make_content_type(
            blog_id => $blog_id,
            name    => 'child',
        );
        my $asset_field = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $child_ct->id,
            type            => 'asset',
            name            => 'asset',
        );
        my $tags_field = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $child_ct->id,
            type            => 'tags',
            name            => 'tags',
        );
        my $categories_field = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $child_ct->id,
            type            => 'categories',
            name            => 'categories',
        );
        $child_ct->fields(
            [   {   id        => $asset_field->id,
                    order     => 1,
                    type      => $asset_field->type,
                    options   => { label => $asset_field->name, },
                    unique_id => $asset_field->unique_id,
                },
                {   id        => $tags_field->id,
                    order     => 2,
                    type      => $tags_field->type,
                    options   => { label => $tags_field->name, },
                    unique_id => $tags_field->unique_id,
                },
                {   id        => $categories_field->id,
                    order     => 3,
                    type      => $categories_field->type,
                    options   => { label => $categories_field->name, },
                    unique_id => $categories_field->unique_id,
                },
            ]
        );
        $child_ct->save or die $child_ct->errstr;
        my @child_cds;

        for my $i ( 0 .. 2 ) {
            my $cd = MT::Test::Permission->make_content_data(
                blog_id         => $blog_id,
                content_type_id => $child_ct->id,
                data            => {
                    $asset_field->id      => [ $asset_file[$i]->id ],
                    $tags_field->id       => [ $tags[$i]->id ],
                    $categories_field->id => [ $categories[$i]->id ],
                },
            );
            push @child_cds, $cd;
        }

        my $parent_ct = MT::Test::Permission->make_content_type(
            blog_id => $blog_id,
            name    => 'parent',
        );
        my $ct_field = MT::Test::Permission->make_content_field(
            blog_id                 => $blog_id,
            content_type_id         => $parent_ct->id,
            type                    => 'content_type',
            name                    => 'child',
            related_content_type_id => $child_ct->id,
        );
        $parent_ct->fields(
            [   {   id      => $ct_field->id,
                    order   => 1,
                    type    => $ct_field->type,
                    options => {
                        label    => $ct_field->name,
                        multiple => 1,
                        source   => $child_ct->id,
                    },
                    unique_id => $ct_field->unique_id,
                },
            ]
        );
        $parent_ct->save or die $parent_ct->errstr;
        MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $parent_ct->id,
            data => { $ct_field->id => [ map { $_->id } @child_cds ], },
        );
    }
);

my $child_ct = MT->model('content_type')->load(
    {   blog_id => $blog_id,
        name    => 'child',
    }
);
my $parent_ct = MT->model('content_type')->load(
    {   blog_id => $blog_id,
        name    => 'parent',
    }
);
my $ct_field = MT->model('content_field')->load(
    {   blog_id         => $blog_id,
        content_type_id => $parent_ct->id,
        type            => 'content_type',
    }
);
my $parent_cd = MT->model('content_data')->load(
    {   blog_id         => $blog_id,
        content_type_id => $parent_ct->id,
    }
);

subtest 'initial state' => sub {
    is( scalar @{ $parent_cd->data->{ $ct_field->id } },
        3, '3 data exist in content_type field' );
    my @cf_idxes = MT->model('content_field_index')->load(
        {   content_data_id  => $parent_cd->id,
            content_field_id => $ct_field->id,
        }
    );
    is( scalar @cf_idxes, 3, '3 MT::ContentFieldIndex exist' );

    my @objassets
        = MT->model('objectasset')->load( { object_ds => 'content_data' } );
    is( @objassets, 3, '3 MT:::ObjectAsset exist' );

    my @objtags = MT->model('objecttag')
        ->load( { object_datasource => 'content_data' } );
    is( @objtags, 3, '3 MT::ObjectTag exist' );

    my @objcats = MT->model('objectcategory')
        ->load( { object_ds => 'content_data' } );
    is( @objcats, 3, '3 MT::ObjectCategory exist' );
};

subtest 'remove content_data by instance method' => sub {
    my $child_cd = MT->model('content_data')->load(
        {   blog_id         => $blog_id,
            content_type_id => $child_ct->id,
        }
    ) or die MT->model('content_data')->errstr;
    $child_cd->remove or die $child_cd->errstr;

    $parent_cd->refresh;
    is( scalar @{ $parent_cd->data->{ $ct_field->id } },
        2, '1 data has been removed from content_type field' );

    my @cf_idxes = MT->model('content_field_index')->load(
        {   content_data_id  => $parent_cd->id,
            content_field_id => $ct_field->id,
        }
    );
    is( scalar @cf_idxes, 2, '1 MT::ContentFieldIndex has been removed' );

    my @objassets
        = MT->model('objectasset')->load( { object_ds => 'content_data' } );
    is( @objassets, 2, '1 MT:::ObjectAsset has been removed' );

    my @objtags = MT->model('objecttag')
        ->load( { object_datasource => 'content_data' } );
    is( @objtags, 2, '1 MT::ObjectTag has been removed' );

    my @objcats = MT->model('objectcategory')
        ->load( { object_ds => 'content_data' } );
    is( @objcats, 2, '1 MT::ObjectCategory has been removed' );
};

subtest 'remove content_data by class method' => sub {
    my $child_cd = MT->model('content_data')->load(
        {   blog_id         => $blog_id,
            content_type_id => $child_ct->id,
        }
    ) or die MT->model('content_data')->errstr;
    MT->model('content_data')->remove(
        {   blog_id         => $blog_id,
            content_type_id => $child_ct->id,
            id              => $child_cd->id,
        }
    ) or die MT->model('content_data')->errstr;

    $parent_cd->refresh;
    is( scalar @{ $parent_cd->data->{ $ct_field->id } },
        1, '1 data has been removed from content_type field' );

    my @cf_idxes = MT->model('content_field_index')->load(
        {   content_data_id  => $parent_cd->id,
            content_field_id => $ct_field->id,
        }
    );
    is( scalar @cf_idxes, 1, '1 MT::ContentFieldIndex has been removed' );

    my @objassets
        = MT->model('objectasset')->load( { object_ds => 'content_data' } );
    is( @objassets, 1, '1 MT:::ObjectAsset has been removed' );

    my @objtags = MT->model('objecttag')
        ->load( { object_datasource => 'content_data' } );
    is( @objtags, 1, '1 MT::ObjectTag has been removed' );

    my @objcats = MT->model('objectcategory')
        ->load( { object_ds => 'content_data' } );
    is( @objcats, 1, '1 MT::ObjectCategory has been removed' );
};

done_testing;

