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

        my $child_ct = MT::Test::Permission->make_content_type(
            blog_id => $blog_id,
            name    => 'child',
        );
        my @child_cds;
        push @child_cds,
            MT::Test::Permission->make_content_data(
            blog_id         => $blog_id,
            content_type_id => $child_ct->id,
            ) for 1 .. 3;

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
};

done_testing;

