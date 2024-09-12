#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::DataAPI;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $website = $app->model('website')->load(2);
$website->max_revisions_cd(20);
$website->save;

my $author_site_administrator = MT::Test::Permission->make_author;
my $role_site_administrator   = MT->model('role')->load({ name => 'Site Administrator' }) or die MT->model('role')->errstr;
MT->model('association')->link($author_site_administrator => $role_site_administrator => $website);

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[
        # MTC-26217
        {
            path      => '/v4/sites/2',
            method    => 'GET',
            author_id => $author_site_administrator->id,
            complete  => sub {
                my ($data, $body) = @_;

                my $got = $app->current_format->{unserialize}->($body);

                is($got->{maxRevisionsContentData}, 20, 'maxRevisionsContentData');
            },
        },
    ];
}
