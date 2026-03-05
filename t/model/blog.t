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

use MT;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

MT::Test->init_cms;

# Create records
my $admin = MT::Author->load(1);
ok($admin);

my $app = MT->instance;
$app->user($admin);

my $website = MT::Website->load();

subtest 'clone_children' => sub {
    my $child_site   = MT::Test::Permission->make_blog(parent_id => $website->id);
    my $content_type = MT::Test::Permission->make_content_type(blog_id => $child_site->id);
    $content_type->fields([]);
    $content_type->save or die $content_type->errstr;
    my $tmpl_ct = MT::Test::Permission->make_template(
        blog_id         => $child_site->id,
        content_type_id => $content_type->id,
        type            => 'ct',
    );
    my $tmpl_ct_archive = MT::Test::Permission->make_template(
        blog_id         => $child_site->id,
        content_type_id => $content_type->id,
        type            => 'ct_archive',
    );
    my $map_ct = MT::Test::Permission->make_templatemap(
        archive_type  => 'ContentType',
        blog_id       => $child_site->id,
        file_template => 'author/%-a/%-f',
        is_preferred  => 1,
        template_id   => $tmpl_ct->id,
    );
    my $map_ct_archive = MT::Test::Permission->make_templatemap(
        archive_type  => 'ContentType-Daily',
        blog_id       => $child_site->id,
        file_template => '%y/%m/%d/%f',
        is_preferred  => 1,
        template_id   => $tmpl_ct_archive->id,
    );

    my $clone_site = $child_site->clone_with_children({
        classes => {
            'MT::Template' => 1,
        } });

    ok $clone_site, 'source child site has been cloned';

    ok(
        MT->model('template')->count({ blog_id => $clone_site->id }) > 0,
        'templates have been cloned from source child site',
    );
    is(
        MT->model('template')->count({
            blog_id => $child_site->id,
            type    => ['ct', 'ct_archive'],
        }),
        2,
        'source child site has templates related content type',
    );
    is(
        MT->model('template')->count({
            blog_id => $clone_site->id,
            type    => ['ct', 'ct_archive'],
        }),
        0,
        'cloned child site does not have templates related content type',
    );

    ok(
        MT->model('templatemap')->count({ blog_id => $clone_site->id }) > 0,
        'template maps have been cloned from source child site',
    );
    is(
        MT->model('templatemap')->count({
            blog_id      => $child_site->id,
            archive_type => { like => '%ContentType%' },
        }),
        2,
        'source child site has template maps related content type',
    );
    is(
        MT->model('templatemap')->count({
            blog_id      => $clone_site->id,
            archive_type => { like => '%ContentType%' },
        }),
        0,
        'cloned child site does not have template maps related content type',
    );
};

done_testing;
