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
use MT::Test::Fixture;
use MT::Test::App;
use MT::ContentData;

my %spec = (
    author => [qw/author/],
    blog   => [
        {   name          => 'My Site',
            server_offset => 0,
            site_path     => 'TEST_ROOT/site',
            archive_path  => 'TEST_ROOT/site/archive',
        }
    ],
    content_type => {
        ct => {
            name   => 'test content data',
            fields => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
                cf_tag1 => {
                    type    => 'tags',
                    name    => 'tags1',
                    options => {
                        multiple => 1,
                        can_add  => 1,
                    },
                },
                cf_tag2 => {
                    type    => 'tags',
                    name    => 'tags2',
                    options  => {
                        multiple => 1,
                        can_add  => 0,
                    },
                },
            ],
        },
    },
);

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare(\%spec);

my $admin = $objs->{author}{author};
my $blog_id = $objs->{blog}{'My Site'}->id;
my $content_type_id = $objs->{content_type}{ct}{content_type}->id;

subtest 'Add item with exists tags' => sub {

    # Tags already using in some models
    MT::Test::Permission->make_tag( name => 'tag1' );
    MT::Test::Permission->make_tag( name => 'tag2' );

    ok $content_type_id, "ContentType(id: ${content_type_id}) is valid.";
    my $content_data_type = "content_data_${content_type_id}";

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode          => 'view',
        type            => $content_data_type,
        content_type_id => $content_type_id,
        blog_id         => $blog_id,
        _type           => 'content_data',
    });

    $app->post_form_ok(
        'edit-content-type-data-form',
        {   data_label  => 'test-1',
            'content-field-1' => 'test-1',
            'content-field-2' => 'tag1, tag2',
            'content-field-3' => 'tag1, tag2',
        }
    );

    my @items = MT->model('content_data')->load({
        blog_id         => $blog_id,
        content_type_id => $content_type_id,
    });

    is scalar(@items), 1, "One content data added.";
};

subtest 'Verify added content_data' => sub {
    my $app = MT->instance;

    my @items = MT->model('content_data')->load({
        blog_id         => $blog_id,
        content_type_id => $content_type_id,
    });
    my $obj = $items[0];
    my $errors = MT::ContentData::verify_content_data($app, $obj->content_type, $obj);
    is $errors, undef, "Verified.";
};

subtest 'Add new tags with tags-field permitted add tags' => sub {
    my $content_data_type = "content_data_${content_type_id}";

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode          => 'view',
        type            => $content_data_type,
        content_type_id => $content_type_id,
        blog_id         => $blog_id,
        _type           => 'content_data',
    });

    $app->post_form_ok(
        'edit-content-type-data-form',
        {   data_label  => 'test-2',
            'content-field-1' => 'test-2',
            'content-field-2' => 'tag3, tag4',
        }
    );

    my @tags = MT::Tag->load( { name => [ 'tag3', 'tag4' ] } );
    is scalar(@tags), 2, "Tags (tag3, tag4) added.";
};

subtest 'Not permitted add tags' => sub {
    my $content_data_type = "content_data_${content_type_id}";

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->get_ok({
        __mode          => 'view',
        type            => $content_data_type,
        content_type_id => $content_type_id,
        blog_id         => $blog_id,
        _type           => 'content_data',
    });

    $app->post_form_ok(
        'edit-content-type-data-form',
        {   data_label  => 'test-3',
            'content-field-1' => 'test-3',
            'content-field-3' => 'tag5, tag6',
        }
    );

    $app->content_like(
        qr/Cannot create tags/,
        "ss_validator is working." );

    my @tags = MT::Tag->load( { name => [ 'tag5', 'tag6' ] } );
    is scalar(@tags), 0, "Tags (tag5, tag6) not added.";
};

done_testing;
