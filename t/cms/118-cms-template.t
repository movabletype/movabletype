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
use MT::Association;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture('db');

# Website
my $website = MT->model('website')->load();

# Author
my $admin = MT->model('author')->load(1);

# Run tests
subtest 'Manage Website Templates' => sub {
    plan 'skip_all';
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list_template',
        blog_id => $website->id,
    });

    my $entry_archive = quotemeta('<li><a href="' . $app->mt_uri . '?__mode=view&amp;_type=template&amp;type=individual&amp;blog_id=' . $website->id . '" class="icon-left icon-create">Entry</a></li>');
    $app->content_like(
        qr/$entry_archive/,
        '"Entry" archive template creating link exists in "Manage Website Templates" view'
    );

    my $entry_listing = quotemeta('<li><a href="' . $app->mt_uri . '?__mode=view&amp;_type=template&amp;type=archive&amp;blog_id=' . $website->id . '" class="icon-left icon-create">Entry Listing</a></li>');
    $app->content_like(
        qr/$entry_listing/,
        '"Entry Listing" archive template creating link exists in "Manage Website Templates" view'
    );

    my $preferred_archive = quotemeta '<p><span class="alert-warning-inline">No archives are active</p>';
    $app->content_unlike(
        qr/$preferred_archive/,
        '"No archives are active" message is not displayed'
    );
};

SKIP: {
    skip 'new UI', 1 unless $ENV{MT_TEST_NEW_UI};

    subtest 'Edit archive template in website' => sub {
        my @options = (
            '<option value="Daily">Daily</option>',
            '<option value="Weekly">Weekly</option>',
            '<option value="Monthly">Monthly</option>',
            '<option value="Yearly">Yearly</option>',
            '<option value="Author">Author</option>',
            '<option value="Author-Daily">Author Daily</option>',
            '<option value="Author-Weekly">Author Weekly</option>',
            '<option value="Author-Monthly">Author Monthly</option>',
            '<option value="Author-Yearly">Author Yearly</option>',
            '<option value="Category">Category</option>',
            '<option value="Category-Daily">Category Daily</option>',
            '<option value="Category-Weekly">Category Weekly</option>',
            '<option value="Category-Monthly">Category Monthly</option>',
            '<option value="Category-Yearly">Category Yearly</option>',
        );

        my $tmpl = MT::Test::Permission->make_template(
            blog_id => $website->id,
            type    => 'archive',
        );

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'template',
            blog_id => $website->id,
            id      => $tmpl->id,
        });

        foreach my $opt (@options) {
            my $opt_quotemeta = quotemeta $opt;
            $app->content_like(
                qr/$opt_quotemeta/,
                'Archive template in website has "' . $opt . '"'
            );
        }
    };
}

subtest 'Save prefs check' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    my $res = $app->post_ok({
        __mode           => 'save_template_prefs',
        blog_id          => $website->id,
        syntax_highlight => 'sync',
    });
    my $json = MT::Util::from_json($res->decoded_content);

    ok(
        $res->header('content-type') =~ m/application\/json/,
        'Content-Type is application/json'
    );
    ok($json->{result}{success}, 'Json result is success');
};

done_testing;
