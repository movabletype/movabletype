#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);

my $website = MT->model('website')->load(1);
$website->set_values({ name => 'First Website', });
$website->save or die $website->errstr;

my $blog = MT::Test::Permission->make_blog(
    name      => 'First Blog',
    parent_id => $website->id,
);

my $dt = MT->model('repair_task')->new;
$dt->set_values({
    author_id   => 1,
    status      => 0,
    department  => 'PluginData',
    params      => q[{foo:'bar',baz:'yada'}],
    description => 'Description',
});
$dt->save or die $dt->errstr;

my ($app, $out);
subtest 'In system scope' => sub {
    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
    subtest 'Blog boilerplate' => sub {
        $app = _run_app(
            'MT::App::CMS',
            {
                __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'filtered_list',
                datasource       => 'repair_task',
                columns          => 'department',
                fid              => '_allpass',
            },
        );
        $out = delete $app->{__test_output};
        like($out, qr/PluginData/, 'department is "PluginData"');
    };
};

done_testing;
