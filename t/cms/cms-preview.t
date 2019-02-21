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

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $blog_id = 1;
my $blog    = MT::Blog->load($blog_id);

my $admin = MT::Author->load(1);

my $author = MT::Test::Permission->make_author(
    name     => 'author',
    nickname => 'author',
);

# Entry
my $entry1 = MT::Test::Permission->make_entry(
    blog_id     => $blog->id,
    author_id   => $author->id,
    authored_on => '20180829000000',
    title       => 'entry',
    status      => MT::EntryStatus::RELEASE(),
);

# Content
my $content_type
    = MT::Test::Permission->make_content_type( blog_id => $blog_id );
my $cf_single = MT::Test::Permission->make_content_field(
    blog_id         => 1,
    content_type_id => $content_type->id,
    name            => 'single',
    type            => 'single_line_text',
);
$content_type->fields(
    [   {   id        => $cf_single->id,
            name      => $cf_single->name,
            options   => { label => $cf_single->name, },
            order     => 1,
            type      => $cf_single->type,
            unique_id => $cf_single->unique_id,
        },
    ]
);
$content_type->save or die $content_type->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    label           => 'label',
    data            => { $cf_single->id => 'single line text' },
    identifier      => 'my content data',
    status          => MT::ContentStatus::RELEASE(),
);

# Mapping
my $template1 = MT::Test::Permission->make_template(
    blog_id => $blog->id,
    name    => 'Test template',
    type    => 'individual',
    text    => 'Individual test',
);
my $template2 = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    name            => 'Test template',
    type            => 'ct',
    text            => 'ContentType test',
    content_type_id => $content_type->id,
);
my $template_map1 = MT::Test::Permission->make_templatemap(
    template_id   => $template1->id,
    blog_id       => $blog->id,
    archive_type  => 'Individual',
    file_template => 'entry/%y/%m/%f',
    is_preferred  => 1,
);
my $template_map2 = MT::Test::Permission->make_templatemap(
    template_id   => $template2->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType',
    file_template => 'cd/%y/%m/%f',
    is_preferred  => 1,
);

MT->add_callback(
    'cms_pre_preview',
    1, undef,
    sub {
        my ( $cb, $app, $obj, $data ) = @_;
        if ( my $class = ref($obj) ) {
            my $ds = $class->datasource;
            my $data;
            $data = MT->model($ds)->load( $obj->id );
            my $saved = $data->save;
            ok( $saved,
                "saving $class succeeded in cms_pre_preview callback" );
            warn $data->errstr unless $saved;
        }
    }
);

my ( $app, $out );

subtest 'entry' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user         => $admin,
            __request_method    => 'POST',
            __mode              => 'preview_entry',
            blog_id             => $blog->id,
            id                  => $entry1->id,
            title               => 'The rewritten title',
            tags                => 'tag1,tag2',
            authored_on_date    => '20190215',
            authored_on_time    => '000000',
            unpublished_on_date => '20190216',
            unpublished_on_time => '000000',
            rev_numbers         => '0,0',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out && $out !~ m!permission=1!i, "preview_entry method succeeded" );

    my $entry2 = MT->model('entry')->load( $entry1->id );
    ok( $entry2->title eq 'entry',
        'original entry has not been changed (maybe cache)' );
    $entry2->refresh;
    ok( $entry2->title eq 'entry',
        'original entry has not been changed (not cache)' );
};

subtest 'content_data' => sub {
    my $field_name = 'content-field-' . $cf_single->id;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user         => $admin,
            __request_method    => 'POST',
            __mode              => 'preview_content_data',
            blog_id             => $blog->id,
            content_type_id     => $content_type->id,
            id                  => $cd1->id,
            data_label          => 'The rewritten label',
            $field_name         => 'The rewritten text',
            authored_on_date    => '20190215',
            authored_on_time    => '000000',
            unpublished_on_date => '20190216',
            unpublished_on_time => '000000',
            rev_numbers         => '0,0',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out && $out !~ m!permission=1!i,
        "preview_content_data method succeeded"
    );

    my $cd2 = MT->model('cd')->load( $cd1->id );
    ok( $cd2->data->{ $cf_single->id } eq 'single line text',
        'original content_data has not been changed (maybe cache)'
    );
    $cd2->refresh;
    ok( $cd2->data->{ $cf_single->id } eq 'single line text',
        'original content_data has not been changed (not cache)'
    );
};

subtest 'template' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'preview_template',
            blog_id          => $blog->id,
            id               => $template1->id,
            name             => 'The rewritten name',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out && $out !~ m!permission=1!i,
        "preview_template method succeeded"
    );

    my $template2 = MT->model('template')->load( $template1->id );
    ok( $template2->name eq 'Test template',
        'original template has not been changed (maybe cache)' );
    $template2->refresh;
    ok( $template2->name eq 'Test template',
        'original template has not been changed (not cache)' );
};

done_testing();
