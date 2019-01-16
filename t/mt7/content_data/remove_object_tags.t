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

        my @tags;
        for my $name ( 'foo', 'bar', 'baz' ) {
            my $tag = MT::Test::Permission->make_tag( name => $name );
            push @tags, $tag;
        }

        my $content_type
            = MT::Test::Permission->make_content_type( blog_id => $blog_id );
        my $tags_field = MT::Test::Permission->make_content_field(
            blog_id         => $blog_id,
            content_type_id => $content_type->id,
            type            => 'tags',
        );
        $content_type->fields(
            [   {   id      => $tags_field->id,
                    order   => 1,
                    type    => $tags_field->type,
                    options => {
                        label    => $tags_field->name,
                        multiple => 1,
                    },
                    unique_id => $tags_field->unique_id,
                }
            ]
        );
        $content_type->save or die $content_type->errstr;

        my $content_data = MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $content_type->id,
            data => { $tags_field->id => [ map { $_->id } @tags ] },
        );
    }
);

my $content_type = MT::ContentType->load( { blog_id => $blog_id } );
my $content_data = MT::ContentData->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
    }
);
my $tags_field = MT::ContentField->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'tags',
    }
);

subtest 'initial state' => sub {
    is( scalar @{ $content_data->data->{ $tags_field->id } },
        3, '3 data exist in tags field' );

    my @objtags = MT->model('objecttag')
        ->load( { object_datasource => 'content_data' } );
    is( scalar @objtags, 3, '3 MT::ObjectTag exist' );

    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $tags_field->id,
        }
    );
    is( scalar @cf_idx, 3, '3 MT::ContenFieldIndex exist' );
};

subtest 'remove objecttag from instance method' => sub {
    my $objtag = MT->model('objecttag')
        ->load( { object_datasource => 'content_data' } );
    $objtag->remove or die $objtag->errstr;

    $content_data->refresh;
    is( scalar @{ $content_data->data->{ $tags_field->id } },
        2, '1 data has been removed in tags field' );

    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $tags_field->id,
        }
    );
    is( scalar @cf_idx, 2, '1 MT::ContenFieldIndex has been removed' );
};

subtest 'remove objecttag from class method' => sub {
    my $objtag = MT->model('objecttag')
        ->load( { object_datasource => 'content_data' } );
    MT->model('objecttag')
        ->remove( { object_datasource => 'content_data', id => $objtag->id } )
        or die MT->model('objecttag')->errstr;

    $content_data->refresh;
    is( scalar @{ $content_data->data->{ $tags_field->id } },
        1, '1 data has been removed in tags field' );

    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $tags_field->id,
        }
    );
    is( scalar @cf_idx, 1, '1 MT::ContenFieldIndex has been removed' );
};

done_testing;

