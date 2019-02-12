use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
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

use MT::Test::ArchiveType;
use MT::Test::Fixture::ArchiveType;

use MT;
use MT::Template::Context;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');
my $objs         = MT::Test::Fixture::ArchiveType->load_objs;
my $blog_id      = $objs->{blog_id} or die;
my $blog         = $app->model('blog')->load($blog_id) or die;
my $site_path    = $blog->site_path( $blog->site_path . '/site' );
my $archive_path = $blog->archive_path . '/archive';
$blog->archive_path($archive_path);
$blog->save or die $blog->errstr;

$app->request->reset;

my $ct_id = $objs->{content_type}{ct_with_same_catset}{content_type}->id
    or die;

my $file_count = _count_files($site_path);

my @maps = sort { $a->archive_type cmp $b->archive_type }
    MT::Test::ArchiveType->template_maps;
for my $map (@maps) {
    next
        unless !$map->template->content_type_id
        || $map->template->content_type_id == $ct_id;

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
    is( _count_files($site_path),
        $file_count, "No files have been output ($at)" );

    ok( $app->rebuild(
            BlogID      => $blog_id,
            ArchiveType => $at,
            TemplateMap => $map,
        ),
        "Succeeded when TemplateMap parameter is templatemap instance ($at)",
    );
    my $next_count = _count_files($site_path);
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

