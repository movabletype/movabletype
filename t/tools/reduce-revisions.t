use strict;
use warnings;
use utf8;
use IPC::Run3 qw/run3/;
use File::Spec;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new();
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Revisable;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare(
    {   author => [
            {   name         => 'admin',
                password     => 'pass',
                is_superuser => 1,
            }
        ],
        blog         => [ { name     => 'my_blog', } ],
        entry        => [ { basename => "entry1", } ],
        content_type => { ct => [ cf_title => 'single_line_text', ], },
        content_data => {
            cd => {
                content_type => 'ct',
                label        => 'cd1',
                data         => {},
            },
        },
        template => [
            {   name => 'template1',
                text => 'test',
            },
        ],
    }
);

my $ds_spec = {
    entry => {
        fixture => 'entry',
        field   => 'status',
    },
    cd => {
        fixture => 'content_data',
        field   => 'status',
    },
    template => {
        fixture => 'template',
        field   => 'text',
    },
};

my $site = $objs->{blog}{my_blog};

for my $ds ( 'template', 'cd', 'entry' ) {
    my $col = 'max_revisions_' . $ds;
    is $site->$col, undef, 'revision_max is undef for brandnew sites';

    my $obj = $objs->{ $ds_spec->{$ds}->{fixture} }{ $ds . '1' };

    for ( 1 .. 20 ) {
        my $rev_obj = $obj->clone();
        $rev_obj->{changed_revisioned_cols} = [ $ds_spec->{$ds}->{field} ];
        $rev_obj->save_revision('test');
    }

    {
        my $count = MT->model( $ds . ':revision' )->count( { $ds . '_id' => $obj->id } );
        is $count, 20, 'excessive';
    }

    {
        my ( $stdin, $stdout, $stderr ) = do_command();
        my $count = MT->model( $ds . ':revision' )->count( { $ds . '_id' => $obj->id } );
        is $count, 20, 'not deleted yet';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 5, 'right number of tests processed';
        is( ( $stdout =~ qr{Detected: (\d+)} )[0], 1, 'right amount detected' );
    }

    {
        my ( $stdin, $stdout, $stderr ) = do_command(1);
        my $count = MT->model( $ds . ':revision' )->count( { $ds . '_id' => $obj->id } );
        is $count, 19, 'deleted';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 5, 'right number of tests processed';
        is( ( $stdout =~ qr{Deleted: (\d+)} )[0], 1, 'right amount detected' );
    }

    {
        my ( $stdin, $stdout, $stderr ) = do_command(1);
        my $count = MT->model( $ds . ':revision' )->count( { $ds . '_id' => $obj->id } );
        is $count, 19, 'no more deletion';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 6, 'right number of tests processed';
        is( ( $stdout =~ qr{Deleted: (\d+)} )[0], 0, 'right amount detected' );
    }

    $site->$col(3);
    $site->save();

    {
        my ( $stdin, $stdout, $stderr ) = do_command(1);
        my $count = MT->model( $ds . ':revision' )->count( { $ds . '_id' => $obj->id } );
        is $count, 2, 'deleted';
        my $oks = () = $stdout =~ /OK\./g;
        is $oks, 5, 'right number of tests processed';
        is( ( $stdout =~ qr{Deleted: (\d+)} )[0], 17, 'right amount detected' );
    }
}

sub do_command {
    my $delete = shift;
    my @cmd    = (
        $^X, '-I',
        File::Spec->catdir( $ENV{MT_HOME}, 't/lib' ),
        File::Spec->catfile( $ENV{MT_HOME}, 'tools/reduce-revisions' ),
        $delete ? '--delete' : '',
    );

    run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;
    note $stderr if $stderr;

    return $stdin, $stdout, $stderr;
}

done_testing;
