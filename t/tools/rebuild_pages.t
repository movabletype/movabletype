use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    plan skip_all => 'Takes too long on Win32' if $^O eq 'MSWin32';

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
use File::Find ();
use File::Path qw/rmtree/;
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
        content_type => {
            ct_one => {
                fields => [ title_field => 'single_line_text' ],
            },
            ct_two => {
                fields => [ title_field => 'single_line_text' ],
            },
        },
        content_data => {
            (   map {
                    sprintf( 'cd_one_%02d', $_ ) => {
                        content_type => 'ct_one',
                        author       => 'admin',
                        status       => 'publish',
                        identifier   => sprintf( 'cd-one-%02d', $_ ),
                        authored_on  =>
                            ( $start + ONE_DAY * $_ )->strftime('%Y%m%d%H%M%S'),
                        data => { title_field => "content one $_" },
                    }
                } ( 1 .. 25 )
            ),
            (   map {
                    sprintf( 'cd_two_%02d', $_ ) => {
                        content_type => 'ct_two',
                        author       => 'admin',
                        status       => 'publish',
                        identifier   => sprintf( 'cd-two-%02d', $_ ),
                        authored_on  =>
                            ( $start + ONE_DAY * $_ )->strftime('%Y%m%d%H%M%S'),
                        data => { title_field => "content two $_" },
                    }
                } ( 1 .. 25 )
            ),
        },
        template => [
            {   archive_type => 'ContentType',
                content_type => 'ct_one',
                name         => 'ct_one_archive',
                mapping      => [ { file_template => 'ct_one/%y/%m/%-f' } ],
            },
            {   archive_type => 'ContentType',
                content_type => 'ct_two',
                name         => 'ct_two_archive',
                mapping      => [ { file_template => 'ct_two/%y/%m/%-f' } ],
            },
        ],
    }
);

ok my $blog = $objs->{blog}{my_blog};

my $home      = $ENV{MT_HOME};
my $site_root = File::Spec->catdir( $test_env->root, 'site' );

sub run_rebuild_pages {
    my @options = @_;
    my @cmd     = (
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
        @options,
    );

    run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;

    ok $stdout !~ /failed/, "no failures" or diag $stdout;
    ok $? == 0, "no errors" or diag $stderr;

    return $stdout;
}

sub built_types {
    my $stdout = shift;
    my @types  = $stdout =~ /^\t(\S+) built success\.$/gm;
    return [ sort @types ];
}

sub published_files {
    return () unless -d $site_root;
    my @files;
    File::Find::find(
        {   wanted   => sub { push @files, $File::Find::name if -f },
            no_chdir => 1,
        },
        $site_root
    );
    return @files;
}

subtest 'rebuild all archive types' => sub {
    rmtree $site_root;

    my $stdout = run_rebuild_pages();

    is_deeply built_types($stdout),
        [ sort 'index', split( /,/, $blog->archive_type ) ],
        'all archive types are built successfully'
        or diag $stdout;

    my @files = published_files();
    is scalar( grep m{/archive/\d{4}/\d{2}/entry\d+\.html$}, @files ), 50,
        'all individual archives are built';
    is scalar( grep m{/page\d+\.html$}, @files ), 50,
        'all page archives are built';
    is scalar( grep m{/archive/ct_one/\d{4}/\d{2}/cd-one-\d+\.html$},
        @files ), 25, 'all content type archives of ct_one are built';
    is scalar( grep m{/archive/ct_two/\d{4}/\d{2}/cd-two-\d+\.html$},
        @files ), 25, 'all content type archives of ct_two are built';
    ok scalar( grep m{/archive/\d{4}/\d{2}/index\.html$}, @files ),
        'monthly archives are built';
    ok scalar( grep m{/archive/cat\d+/index\.html$}, @files ),
        'category archives are built';
    ok scalar( grep m{/site/index\.html$}, @files ),
        'index templates are built';
};

subtest 'rebuild only entry archives' => sub {
    rmtree $site_root;

    my $stdout = run_rebuild_pages( '--type', 'Individual' );

    is_deeply built_types($stdout), ['Individual'],
        'only Individual is built'
        or diag $stdout;

    my @files = published_files();
    is scalar( grep m{/archive/\d{4}/\d{2}/entry\d+\.html$}, @files ), 50,
        'all individual archives are built';
    is scalar(@files), 50, 'no other files are built'
        or diag explain \@files;
};

subtest 'rebuild only content type archives' => sub {
    rmtree $site_root;

    my $stdout = run_rebuild_pages( '--type', 'ContentType' );

    is_deeply built_types($stdout), ['ContentType'],
        'only ContentType is built'
        or diag $stdout;

    my @files = published_files();
    is scalar( grep m{/archive/ct_one/\d{4}/\d{2}/cd-one-\d+\.html$},
        @files ), 25, 'all content type archives of ct_one are built';
    is scalar( grep m{/archive/ct_two/\d{4}/\d{2}/cd-two-\d+\.html$},
        @files ), 25, 'all content type archives of ct_two are built';
    ok !scalar( grep m{/entry\d+\.html$}, @files ),
        'no entry archives are built';
    is scalar(@files), 50, 'no other files are built'
        or diag explain \@files;
};

done_testing;
