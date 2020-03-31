use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use IPC::Run3 qw/run3/;
use File::Spec;
use Time::Piece;
use Time::Seconds;
use Time::Local qw/timegm/;

my $start = Time::Piece->new( timegm( 0, 0, 0, 1, 1, 2020 ) );

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare(
    {   author => [
            {   name         => 'admin',
                password     => 'pass',
                is_superuser => 1,
            }
        ],
        blog => [
            {   name      => 'my_blog',
                site_path => File::Spec->catdir( $test_env->root . '/site' ),
                archive_path =>
                    File::Spec->catdir( $test_env->root . '/site/archive' ),
            }
        ],
        category => [qw/cat1 cat2/],
        entry    => [
            map {
                +{  basename => "entry$_",
                    title    => "entry$_",
                    author   => 'admin',
                    status   => 'publish',
                    authored_on =>
                        ( $start + ONE_DAY * $_ )->strftime('%Y%m%d%H%M%S'),
                    atom_id    => "atom$_",
                    categories => [qw/cat1 cat2/],
                }
            } ( 1 .. 50 )
        ],
        folder => [qw/folder1 folder2/],
        page   => [
            map {
                +{  basename => "page$_",
                    title    => "page$_",
                    author   => 'admin',
                    status   => 'publish',
                    authored_on =>
                        ( $start + ONE_DAY * $_ )->strftime('%Y%m%d%H%M%S'),
                    folders => [qw/folder1 folder2/],
                }
            } ( 1 .. 50 )
        ],
    }
);

ok my $blog = $objs->{blog}{my_blog};

my $home = $ENV{MT_HOME};

my @cmd = (
    $^X,
    '-I',
    File::Spec->catdir( $home, 't/lib' ),
    File::Spec->catfile( $home, 'tools/rebuild-pages' ),
    '--user',
    'admin',
    '--pass',
    'pass',
    '--blog_id',
    $blog->id,
);

run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;

ok $stdout !~ /failed/, "no failures" or diag $stdout;
note $stderr if $stderr;

done_testing;

