#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;

use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

### Make test data
$test_env->prepare_fixture('db_data');

my $site = MT::Test::Permission->make_website( name => 'my website' );

my $user = MT::Test::Permission->make_author(
    name     => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $content_type = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'test content type',
);

my $content_field = MT::Test::Permission->make_content_field(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'single line text',
    type            => 'single_line_text',
);

my $field_data = [
    {   id        => $content_field->id,
        order     => 1,
        type      => $content_field->type,
        options   => { label => $content_field->name, },
        unique_id => $content_field->unique_id,
    },
];
$content_type->fields($field_data);
$content_type->save or die $content_type->errstr;

my $permitted_action
    = 'content_type:'
    . $content_type->unique_id
    . '-content_field:'
    . $content_field->unique_id;
my $create_action = "create_content_data:" . $content_type->unique_id;

my $edit_field_role = MT::Test::Permission->make_role(
    name => 'Edit Content Field "' . $content_field->name . '"',
    permissions => "'" . $create_action . "','" . $permitted_action . "'"
);
require MT::Association;
MT::Association->link( $user => $edit_field_role => $site );

MT::Test->init_app;

my $content_field_id = $content_field->id;
my $check_text       = 'name="content-field-' . $content_field->id;

# Run
my ( $app, $out );
$app = _run_app(
    'MT::App::CMS',
    {   __test_user      => $user,
        __request_method => 'GET',
        __mode           => 'view',
        blog_id          => $content_type->blog_id,
        content_type_id  => $content_type->id,
        _type            => 'content_data',
        type             => 'content_data_' . $content_type->id
    },
);

$out = delete $app->{__test_output};
ok( $out =~ /$check_text/, 'edit content data screen by permitted user' );

MT::Association->unlink( $user => $edit_field_role => $site );

$app = _run_app(
    'MT::App::CMS',
    {   __test_user      => $user,
        __request_method => 'GET',
        __mode           => 'view',
        blog_id          => $content_type->blog_id,
        content_type_id  => $content_type->id,
        _type            => 'content_data',
        type             => 'content_data_' . $content_type->id
    },
);
$out = delete $app->{__test_output};
ok( $out !~ /$check_text/, 'edit content data screen by non permitted user' );

done_testing();
