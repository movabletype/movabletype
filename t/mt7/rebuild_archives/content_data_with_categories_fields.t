use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_APP}    = 'MT::App::CMS';
}

use MT;
use MT::Test;
use MT::Test::App;
use MT::Test::Fixture::ArchiveType;
use Test::Deep qw/cmp_bag/;

$test_env->prepare_fixture('archive_type');

my $objs = MT::Test::Fixture::ArchiveType->load_objs;

my $blog_id = $objs->{blog_id};
my $admin   = MT::Author->load(1);

my $ct_id = $objs->{content_type}{ct_with_same_catset}{content_type}->id;
my $cd_id = $objs->{content_data}{cd_same_apple_orange_peach}->id;

my @files;
$test_env->ls(
    sub {
        my $file = shift;
        push @files, $file;
    }
);

my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);

my $res = $app->get(
    {   __mode          => 'view',
        _type           => 'content_data',
        type            => 'content_data',
        blog_id         => $blog_id,
        content_type_id => $ct_id,
        id              => $cd_id,
    }
);

my $form = $app->forms;
$res = $app->post( $form->click('status') );

my @new_files;
$test_env->ls(
    sub {
        my $file = shift;
        push @new_files, $file;
    }
);

# Nothing should be removed (or added)
cmp_bag( \@new_files, \@files );

done_testing;
