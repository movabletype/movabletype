use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
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
use MT::Test::Fixture::Mtc31522;
use Test::Deep qw/cmp_bag/;

$test_env->prepare_fixture('mtc31522');

my $objs = MT::Test::Fixture::Mtc31522->load_objs;

my $blog_id = $objs->{blog_id};
my $admin   = MT::Author->load(1);
my $ct_id   = $objs->{content_type}{ct1}{content_type}->id;
my $cd_id   = $objs->{content_data}{data2}->id;

MT->publisher->rebuild(BlogID => $blog_id);

# Avoid "Ignore recently rebuilt tmpl1/b.html" while updating content data
sleep 2;

my @files;
$test_env->ls(sub {
    my $file = shift;
    push @files, $file;
});

is scalar(grep { /tmpl1\/b\.html$/ } @files), 1, 'tmpl1/b.html exists';
is scalar(grep { /tmpl2\/b\.html$/ } @files), 1, 'tmpl2/b.html exists';

my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);

$app->get_ok({
    __mode          => 'view',
    _type           => 'content_data',
    type            => 'content_data_' . $ct_id,
    blog_id         => $blog_id,
    content_type_id => $ct_id,
    id              => $cd_id,
});

my $form = $app->forms;
$app->post_ok($form->click('status'));

my @new_files;
$test_env->ls(sub {
    my $file = shift;
    push @new_files, $file;
});

# Nothing should be removed (or added)
cmp_bag(\@new_files, \@files);

done_testing;
