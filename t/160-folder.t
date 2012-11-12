#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;
use lib qw(lib extlib t/lib);
use MT::Test qw(:app :data);

my $folder_class = MT->model('folder');

subtest 'remove' => sub {
    my $category_id = 1;
    my $init        = sub {
        MT->model('category')->remove_all();
        $folder_class->remove_all();
        my $folder = $folder_class->new;
        $folder->set_values(
            {   id      => $category_id,
                label   => 'Test',
                blog_id => 1,
            }
        );
        $folder->save or die;
    };
    my $check = sub {
        my $folder = $folder_class->load($category_id);
        ok( !$folder, 'removed' );
    };

    subtest 'call with an object' => sub {
        $init->();
        $folder_class->load($category_id)->remove;
        $check->();
        done_testing();
    };

    subtest 'call with a class' => sub {
        $init->();
        $folder_class->remove( { id => $category_id } );
        $check->();
        done_testing();
    };

    done_testing();
};

done_testing();
