#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DisableContentFieldPermission => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test::App;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

MT->instance;
my $admin       = MT::Author->load(1);
my $parent_site = MT::Website->load;

my $content_type = MT::Test::Permission->make_content_type(blog_id => $parent_site->id);
my $single_field = MT::Test::Permission->make_content_field(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'single',
    type            => 'single_line_text',
);
my $fields = [{
    id        => $single_field->id,
    order     => 1,
    type      => $single_field->type,
    options   => { label => $single_field->name },
    unique_id => $single_field->unique_id,
}];
$content_type->fields($fields);
$content_type->save or die $content_type->errstr;

my $content_field_permission = 'content_type:' . $content_type->unique_id . '-content_field:' . $single_field->unique_id;
my $content_field_role       = MT::Test::Permission->make_role(
    name        => 'content field',
    permissions => "'${content_field_permission}'",
);

my $author_role = MT::Role->load({ name => 'Author' });

my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);

subtest 'create role' => sub {
    $app->get_ok({
        __mode  => 'view',
        _type   => 'role',
        blog_id => 0,
    });
    is $app->wq_find('div#disabled-content-field-permissions')->size, 0;
    $app->content_unlike(qr/<input id="${content_field_permission}" /);
};

subtest 'edit role (content field perrmissions do not exist)' => sub {
    $app->get_ok({
        __mode  => 'view',
        _type   => 'role',
        blog_id => 0,
        id      => $author_role->id,
    });
    is $app->wq_find('div#disabled-content-field-permissions')->size, 0;
    $app->content_unlike(qr/<input id="${content_field_permission}" /);
};

subtest 'edit role (content field perrmissions exist)' => sub {
    $app->get_ok({
        __mode  => 'view',
        _type   => 'role',
        blog_id => 0,
        id      => $content_field_role->id,
    });
    is $app->wq_find('div#disabled-content-field-permissions')->size, 1;
    $app->content_unlike(qr/<input id="${content_field_permission}" /);
};

done_testing;
