#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

MT::Test->init_db;
MT->instance;

my $website = MT::Test::Permission->make_website(name => 'my website');

sub _get_config_value {
    $test_env->clear_mt_cache;
    my $config = MT::Config->load(1) or return;
    my ($line) = $config->data =~ /^(DataAPIDisableSite.+)$/m;
    my ($key, $value) = split / /, $line;
    $value;
}

my $admin = MT->model('author')->load(1);
my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);
$app->get_ok({
    __mode          => 'cfg_web_services',
    _type           => 'website',
    id              => $website->id,
    blog_id         => $website->id,
});
$app->post_form_ok({
    enable_data_api => undef,
});

ok(grep { $website->id eq $_ } split(',', _get_config_value()), 'Include updated website');

$website->remove;

ok(!grep { $website->id eq $_ } split(',', _get_config_value()), 'Not include updated website');

done_testing;
