#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::Deep;
use MT::Test::Env;

our $test_env;
BEGIN {
    plan skip_all => 'Test fails if MT_TEST_RUN_APP_AS_CGI=1' if $ENV{MT_TEST_RUN_APP_AS_CGI};

    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
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
    my $blog_entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $admin->id,
    );
    $blog_entry->save;

    # Page
    my $website_page = MT::Test::Permission->make_page(
        blog_id   => $website->id,
        author_id => $admin->id,
    );
    $website_page->save;

    # Asset
    foreach ( 0..1 ) {
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
        $website_asset->save;
    }
});

my $website = MT::Website->load({ name => 'my website' });
my $blog = MT::Blog->load({ name => 'my blog' });
my $admin = MT->model('author')->load(1);
my @assets = MT::Asset->load({ class => '*' });
my @asset_ids = map { $_->id; } @assets;

subtest 'Saving/Removing record of relationship between entry and asset' => sub {
    my $entry = MT::Entry->load({ blog_id => $blog->id, author_id => $admin->id });

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->post_form_ok({
        title => 'changed-1',
        include_asset_ids => join(",", @asset_ids),
    });

    my @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'entry',
            object_id => $entry->id,
        }
    );
    cmp_deeply(
        [ map { $_->asset_id; } @obj_assets ],
        set(@asset_ids),
        "Save records in successfully"
    );

    $app->post_form_ok({
        title => 'changed-2',
        include_asset_ids => $asset_ids[0],
    });

    @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'entry',
            object_id => $entry->id,
        }
    );
    is scalar(@obj_assets), 1, "Remove record in successfully";
    is $obj_assets[0]->asset_id, $asset_ids[0], "Updating succeed";
};

subtest 'Saving/Removing record of relationship between page and asset' => sub {
    my $page = MT::Page->load({ blog_id => $website->id, author_id => $admin->id });

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'page',
        blog_id => $website->id,
        id      => $page->id,
    });
    $app->post_form_ok({
        title => 'changed-1',
        include_asset_ids => join(",", @asset_ids),
    });

    my @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'entry',
            object_id => $page->id,
        }
    );
    cmp_deeply(
        [ map { $_->asset_id; } @obj_assets ],
        set(@asset_ids),
        "Save records in successfully"
    );

    $app->post_form_ok({
        title => 'changed-2',
        include_asset_ids => $asset_ids[0],
    });

    @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'entry',
            object_id => $page->id,
        }
    );
    is scalar(@obj_assets), 1, "Remove record in successfully";
    is $obj_assets[0]->asset_id, $asset_ids[0], "Updating succeed";
};

subtest 'Logging at failed saving/removing record of relationship between entry and asset' => sub {
    my $entry = MT::Entry->load({ blog_id => $blog->id, author_id => $admin->id });

    # Fail association only.
    no strict 'refs';
    local *{"MT::ObjectAsset::save"} = sub { return $_[0]->error('Error message.'); };
    local *{"MT::ObjectAsset::remove"} = sub { return $_[0]->error('Error message.'); };

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->post_form_ok({
        title => 'saving',
        include_asset_ids => join(",", @asset_ids),
    });

    $entry = MT::Entry->load({ blog_id => $blog->id, author_id => $admin->id });
    is $entry->title, 'saving', "save_entry succeed";

    my @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'entry',
            object_id => $entry->id,
        }
    );
    is scalar(@obj_assets), 1, "Expect: Saving failed";

    $app->post_form_ok({
        title => 'removing',
        include_asset_ids => '',
    });

    $entry = MT::Entry->load({ blog_id => $blog->id, author_id => $admin->id });
    is $entry->title, 'removing', "save_entry succeed";

    @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'entry',
            object_id => $entry->id,
        }
    );
    is scalar(@obj_assets), 1, "Expect: Removing failed";

    my @logs = MT::Log->load({ level => MT::Log::ERROR() });
    ok((grep {
        $_->message =~ /Failed to save relationship between Entry/;
    } @logs), "Logged failure to save");
    ok((grep {
        $_->message =~ /Failed to remove relationship between Entry/;
    } @logs), "Logged failure to remove");
};

subtest 'Logging at failed saving/removing record of relationship between page and asset' => sub {
    my $page = MT::Page->load({ blog_id => $website->id, author_id => $admin->id });

    # Fail association only.
    no strict 'refs';
    local *{"MT::ObjectAsset::save"} = sub { return $_[0]->error('Error message.'); };
    local *{"MT::ObjectAsset::remove"} = sub { return $_[0]->error('Error message.'); };

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'page',
        blog_id => $website->id,
        id      => $page->id,
    });
    $app->post_form_ok({
        title => 'saving',
        include_asset_ids => join(",", @asset_ids),
    });

    $page = MT::Page->load({ blog_id => $website->id, author_id => $admin->id });
    is $page->title, 'saving', "save_entry succeed";

    my @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'entry',
            object_id => $page->id,
        }
    );
    is scalar(@obj_assets), 1, "Expect: Saving failed";

    $app->post_form_ok({
        title => 'removing',
        include_asset_ids => '',
    });

    $page = MT::Page->load({ blog_id => $website->id, author_id => $admin->id });
    is $page->title, 'removing', "save_entry succeed";

    @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'entry',
            object_id => $page->id,
        }
    );
    is scalar(@obj_assets), 1, "Expect: Removing failed";

    my @logs = MT::Log->load({ level => MT::Log::ERROR() });
    ok((grep {
        $_->message =~ /Failed to save relationship between Page/;
    } @logs), "Logged failure to save");
    ok((grep {
        $_->message =~ /Failed to remove relationship between Page/;
    } @logs), "Logged failure to remove");
};

done_testing();
