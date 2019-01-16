use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
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

use File::Find;
use File::Path;

use MT;
use MT::Test qw( :db :data );
use MT::Test::Permission;

my $app = MT->instance;

my $blog_id      = 1;
my $blog         = $app->model('blog')->load($blog_id) or die;
my $archive_path = $blog->site_path;
$blog->archive_path($archive_path);
$blog->save or die;

my $map_daily = $app->model('templatemap')->load(
    {   archive_type => 'Daily',
        blog_id      => $blog_id,
        is_preferred => 1,
    }
) or die;

my @archive_types = qw(
    Author-Daily Author-Monthly Author-Weekly Author-Yearly
    Category-Daily Category-Monthly Category-Weekly Category-Yearly
    Yearly
);
for my $at (@archive_types) {
    MT::Test::Permission->make_templatemap(
        archive_type => $at,
        blog_id      => $blog_id,
        is_preferred => 1,
        template_id  => $map_daily->template_id,
    );
}

File::Path::rmtree($archive_path) or die;

my $file_count = _count_files($archive_path);
is( $file_count, 0, 'Remove all files' );

$app->request->reset;

my @maps = sort { $a->archive_type cmp $b->archive_type }
    $app->model('templatemap')->load( { blog_id => $blog_id } );
for my $map (@maps) {
    my $at = $map->archive_type;

    ok( !eval {
            $app->rebuild(
                BlogID      => $blog_id,
                ArchiveType => $at,
                TemplateMap => $map->id,
            );
        },
        "Died when TemplateMap parameter is templatemap_id ($at)",
    );
    is( _count_files($archive_path),
        $file_count, "No files have been output ($at)" );

    ok( $app->rebuild(
            BlogID      => $blog_id,
            ArchiveType => $at,
            TemplateMap => $map,
        ),
        "Succeeded when TemplateMap parameter is templatemap instance ($at)",
    );
    my $next_count = _count_files($archive_path);
    ok( $next_count > $file_count, "Some files have been output ($at)" );
    $file_count = $next_count;
}

done_testing;

sub _count_files {
    my ($dir) = @_;
    my $count = 0;
    return $count unless -d $dir;
    File::Find::find(
        {   no_chdir => 1,
            wanted   => sub {
                if ( -f $File::Find::name ) {
                    $count++;
                }
            },
        },
        $dir,
    );
    return $count;
}

