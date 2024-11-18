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
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );

    # Author
    my $admin = MT->model('author')->load(1);

    # Entry
    my $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $admin->id,
    );
    $website_entry->tags('@entry');
    $website_entry->save;

    # Entry
    my $website_entry2 = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $admin->id,
    );
    $website_entry2->tags('@entry2');
    $website_entry2->save;

    # Entry(for rename_tag only entry)
    my $blog_entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $admin->id,
    );
    $blog_entry->tags('@entry3');
    $blog_entry->save;

    # Page
    my $website_page = MT::Test::Permission->make_page(
        blog_id   => $website->id,
        author_id => $admin->id,
    );
    $website_page->tags('@page');
    $website_page->save;

    # Asset
    my $website_asset = MT::Test::Permission->make_asset(
        class        => 'image',
        blog_id      => $website->id,
        url          => 'http://narnia.na/nana/images/test.jpg',
        file_path    => File::Spec->catfile($ENV{MT_HOME}, "t", 'images', 'test.jpg'),
        file_name    => 'test.jpg',
        file_ext     => 'jpg',
        image_width  => 640,
        image_height => 480,
        mime_type    => 'image/jpeg',
        label        => 'Userpic A',
        description  => 'Userpic A',
    );
    $website_asset->tags('@asset');
    $website_asset->save;
});

my $website = MT::Website->load({ name => 'my website' });
my $blog = MT::Blog->load({ name => 'my blog' });

my $admin = MT->model('author')->load(1);

note 'Test in website scope';
subtest 'Test in website scope' => sub {

    note 'Build in filter check';
    subtest 'Built in filter check' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'tag',
            blog_id => $website->id,
        });

        $app->content_like(
            qr/Tags with Entries/,
            'System filter "Tags with Entries" exists'
        );

        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'tag',
            blog_id    => $website->id,
            columns    => 'name',
            fid        => '_allpass',
        });

        my @tags = qw( @entry @page @asset );
        foreach my $t (@tags) {
            $app->content_like(qr/$t/, "Got \"$t\" in website");
        }

        $app->post_ok({
            __mode     => 'filtered_list',
            datasource => 'tag',
            blog_id    => $website->id,
            columns    => 'name',
            fid        => 'entry',
            items      => "[{\"type\":\"for_entry\",\"args\":{\"value\":\"\",\"label\":\"\"}}]",
        });

        $app->content_like(qr/\@entry/, "Got \"\@entry\" in website");
        $app->content_unlike(qr/\@page/,  "Did not get \"\@page\" in website");
        $app->content_unlike(qr/\@asset/, "Did not get \"\@asset\" in website");
    };

    note 'Display options check';
    subtest 'Display options check' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'tag',
            blog_id => $website->id,
        });

        my $checkbox = quotemeta('<label for="custom-prefs-entry_count">Entries</label>');
        $checkbox = qr/$checkbox/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like($checkbox, 'Has "Entries" setting in Display Options');
        }
    };

    note 'Rename tag check';
    subtest 'Rename tag check' => sub {
        my $entry = MT::Entry->load({ blog_id => $website->id, author_id => $admin->id });
        $entry->tags('Alpha one');
        $entry->save;
        my $tag = MT::Tag->load({ name => 'Alpha one' });
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->js_post_ok({
            __mode     => 'rename_tag',
            blog_id    => $website->id,
            tag_name   => 'Alpha two',
            __id       => $tag->id,
            datasource => 'tag',
            xhr        => 'false',
        });

        my $tag2 = MT::Tag->load({ name => 'Alpha two' });
        ok( MT::ObjectTag->exist({ tag_id => $tag2->id }), "Exists renamed tag" );
        is( $tag->id, $tag2->id, "Rewrite only name field" );

        $entry = MT::Entry->load( $entry->id );
        is_deeply( [ $entry->tags ], [ 'Alpha two' ], "Rename succeeded");
    };

    note 'Rename tag check: exists tagname';
    subtest 'Rename tag check' => sub {
        my $entry = MT::Entry->load({ blog_id => $website->id, author_id => $admin->id });
        $entry->tags('Alpha one');
        $entry->save;
        my $tag = MT::Tag->load({ name => 'Alpha one' });
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->js_post_ok({
            __mode     => 'rename_tag',
            blog_id    => $website->id,
            tag_name   => '@entry2',
            __id       => $tag->id,
            datasource => 'tag',
            xhr        => 'false',
        });

        my $tag2 = MT::Tag->load({ name => '@entry2' });
        ok( MT::ObjectTag->exist({ tag_id => $tag2->id }), "Exists renamed tag" );
        is( MT::ObjectTag->exist({ tag_id => $tag->id }), undef, "Remove unused tag" );

        $entry = MT::Entry->load( $entry->id );
        is_deeply( [ $entry->tags ], [ '@entry2' ], "Rename succeeded");
    };

    note 'Rename tag check: only entry';
    subtest 'Rename tag check' => sub {
        my $entry = MT::Entry->load({ blog_id => $blog->id, author_id => $admin->id });
        $entry->tags('Alpha one');
        $entry->save;
        my $tag = MT::Tag->load({ name => 'Alpha one' });
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->js_post_ok({
            __mode     => 'rename_tag',
            __type     => 'entry',
            blog_id    => $blog->id,
            tag_name   => 'Alpha two',
            __id       => $tag->id,
            datasource => 'tag',
            xhr        => 'false',
        });

        my $tag2 = MT::Tag->load({ name => 'Alpha two' });
        ok( MT::ObjectTag->exist({ tag_id => $tag2->id }), "Exists renamed tag" );
        is( MT::ObjectTag->exist({ tag_id => $tag->id }), undef, "Remove unused tag" );

        $entry = MT::Entry->load( $entry->id );
        is_deeply( [ $entry->tags ], [ 'Alpha two' ], "Rename succeeded");
    };
};

done_testing();
