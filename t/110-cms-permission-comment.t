#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Copy;
use File::Spec;

# Disable Cloud.pack temporarily.
BEGIN {
    my $cloudpack_config
        = File::Spec->catfile(qw/ addons Cloud.pack config.yaml /);
    my $cloudpack_config_rename
        = File::Spec->catfile(qw/ addons Cloud.pack config.yaml.disabled /);

    if ( -f $cloudpack_config ) {
        move( $cloudpack_config, $cloudpack_config_rename )
            or plan skip_all => "$cloudpack_config cannot be moved.";
    }
}

# Recover Cloud.pack.
END {
    my $cloudpack_config
        = File::Spec->catfile(qw/ addons Cloud.pack config.yaml /);
    my $cloudpack_config_rename
        = File::Spec->catfile(qw/ addons Cloud.pack config.yaml.disabled /);

    if ( -f $cloudpack_config_rename ) {
        move( $cloudpack_config_rename, $cloudpack_config );
    }
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website( name => 'my website' );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'second blog',
    );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $ichikawa = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );

    my $ukawa = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Saburo Ukawa',
    );

    my $egawa = MT::Test::Permission->make_author(
        name     => 'egawa',
        nickname => 'Shiro Egawa',
    );

    my $ogawa = MT::Test::Permission->make_author(
        name     => 'ogawa',
        nickname => 'Goro Ogawa',
    );

    my $kagawa = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro Kagawa',
    );

    my $kikkawa = MT::Test::Permission->make_author(
        name     => 'kikkawa',
        nickname => 'Jiro Kikkawa',
    );

    my $kumekawa = MT::Test::Permission->make_author(
        name     => 'kumekawa',
        nickname => 'Saburo Kumekawa',
    );

    my $kemikawa = MT::Test::Permission->make_author(
        name     => 'kemikawa',
        nickname => 'Shiro Kemikawa',
        type     => MT::Author::COMMENTER(),
    );

    my $admin = MT::Author->load(1);

    # Role
    my $manage_feedback = MT::Test::Permission->make_role(
        name        => 'Manage Feedback',
        permissions => "'manage_feedback'",
    );

    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $publish_post = MT::Test::Permission->make_role(
        name        => 'Publish Post',
        permissions => "'publish_post'",
    );

    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );

    my $designer  = MT::Role->load( { name => MT->translate('Designer') } );
    my $commenter = MT::Role->load( { name => MT->translate('Commenter') } );

    require MT::Association;
    MT::Association->link( $aikawa   => $manage_feedback => $blog );
    MT::Association->link( $ichikawa => $manage_pages    => $blog );
    MT::Association->link( $ukawa    => $publish_post    => $blog );
    MT::Association->link( $kikkawa  => $designer        => $blog );
    MT::Association->link( $kumekawa => $publish_post    => $blog );
    MT::Association->link( $kemikawa => $commenter       => $blog );

    MT::Association->link( $egawa  => $manage_feedback => $second_blog );
    MT::Association->link( $ogawa  => $manage_pages    => $second_blog );
    MT::Association->link( $kagawa => $publish_post    => $second_blog );

    # Entry
    my $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ukawa->id,
        title     => 'my entry',
    );

    my $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
        title     => 'my page',
    );

    # Comment
    my $comment = MT::Test::Permission->make_comment(
        entry_id     => $entry->id,
        blog_id      => $blog->id,
        commenter_id => $kemikawa->id,
    );

    my $comment2 = MT::Test::Permission->make_comment(
        entry_id     => $page->id,
        blog_id      => $blog->id,
        commenter_id => $kemikawa->id,
    );
});

my $website = MT::Website->load( { name => 'my website' } );
my $blog    = MT::Blog->load( { name => 'my blog' } );

my $aikawa   = MT::Author->load( { name => 'aikawa' } );
my $ichikawa = MT::Author->load( { name => 'ichikawa' } );
my $ukawa    = MT::Author->load( { name => 'ukawa' } );
my $egawa    = MT::Author->load( { name => 'egawa' } );
my $ogawa    = MT::Author->load( { name => 'ogawa' } );
my $kagawa   = MT::Author->load( { name => 'kagawa' } );
my $kikkawa  = MT::Author->load( { name => 'kikkawa' } );
my $kumekawa = MT::Author->load( { name => 'kumekawa' } );
my $kemikawa = MT::Author->load( { name => 'kemikawa' } );

my $admin = MT::Author->load(1);

require MT::Role;
my $designer  = MT::Role->load( { name => MT->translate('Designer') } );
my $commenter = MT::Role->load( { name => MT->translate('Commenter') } );

require MT::Page;
my $entry = MT::Entry->load( { title => 'my entry' } );
my $page  = MT::Page->load( { title => 'my page' } );
my $comment = MT::Comment->load(
    {
        entry_id     => $entry->id,
        blog_id      => $blog->id,
        commenter_id => $kemikawa->id,
    }
);

my $comment2 = MT::Comment->load(
    {
        entry_id     => $page->id,
        blog_id      => $blog->id,
        commenter_id => $kemikawa->id,
    }
);

# Run
my ( $app, $out );

subtest 'mode = approve_item' => sub {
    $comment->visible(0);
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'approve_item',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: approve_item" );
    ok( $out !~ m!permission to approve this comment!i,
        "approve_item by admin" );

    $comment->visible(0);
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'approve_item',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: approve_item" );
    ok( $out !~ m!permission to approve this comment!i,
        "approve_item by permitted user" );

    $comment->visible(0);
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'approve_item',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: approve_item" );
    ok( $out =~ m!permission to approve this comment!i,
        "approve_item by other blog" );

    $comment->visible(0);
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'approve_item',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: approve_item" );
    ok( $out =~ m!permission to approve this comment!i,
        "approve_item by other permission" );

    done_testing();
};
subtest 'mode = ban_commenter' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'ban_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: ban_commenter" );
    ok( $out !~ m!Permission denied!i, "ban_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'ban_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out !~ m!Permission denied!i,
        "ban_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'ban_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i, "ban_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'ban_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i,
        "ban_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'ban_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: ban_commenter" );
    ok( $out !~ m!Permission denied!i, "ban_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'ban_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i,
        "ban_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'ban_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i, "ban_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'ban_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i,
        "ban_commenter by other permission (SC1)" );

    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    done_testing();
};

subtest 'mode = dialog_post_comment' => sub {
    $comment->publish;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_post_comment',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_post_comment" );
    ok( $out !~ m!permission=1!i, "dialog_post_comment by admin" );

    $comment->publish;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'dialog_post_comment',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_post_comment" );
    ok( $out !~ m!permission=1!i, "dialog_post_comment by permitted user" );

    $comment->publish;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'dialog_post_comment',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_post_comment" );
    ok( $out =~ m!permission=1!i, "dialog_post_comment by other blog" );

    $comment->publish;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'dialog_post_comment',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: dialog_post_comment" );
    ok( $out =~ m!permission=1!i, "dialog_post_comment by other permission" );

    done_testing();
};

subtest 'mode = do_reply' => sub {
    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: do_reply" );
    ok( $out !~ m!permission=1!i, "do_reply by admin" );

    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: do_reply" );
    ok( $out !~ m!permission=1!i,
        "do_reply by permitted user (manage_feedback)" );

    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: do_reply" );
    ok( $out !~ m!permission=1!i,
        "do_reply by permitted user (manage_pages)" );

    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: do_reply" );
    ok( $out !~ m!permission=1!i,
        "do_reply by permitted user (publish_post)" );

    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: do_reply" );
    ok( $out !~ m!permission=1!i, "do_reply by other user" );

    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: do_reply" );
    ok( $out =~ m!permission=1!i,
        "do_reply by other blog (manage_feedback)" );

    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: do_reply" );
    ok( $out =~ m!permission=1!i, "do_reply by other blog (manage_pages)" );

    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: do_reply" );
    ok( $out =~ m!permission=1!i, "do_reply by other blog (publish_post)" );

    $comment->approve;
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'do_reply',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: do_reply" );
    ok( $out =~ m!permission=1!i, "do_reply by other permission" );

    done_testing();
};

subtest 'mode = empty_junk' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'empty_junk',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: empty_junk" );
    ok( $out !~ m!permission=1!i, "empty_junk by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'empty_junk',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: empty_junk" );
    ok( $out !~ m!permission=1!i, "empty_junk by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'empty_junk',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: empty_junk" );
    ok( $out =~ m!permission=1!i, "empty_junk by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'empty_junk',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: empty_junk" );
    ok( $out =~ m!permission=1!i, "empty_junk by other permission" );

    done_testing();
};

subtest 'mode = handle_junk' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'handle_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: handle_junk" );
    ok( $out !~ m!permission=1!i, "handle_junk by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'handle_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: handle_junk" );
    ok( $out !~ m!permission=1!i, "handle_junk by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'handle_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: handle_junk" );
    ok( $out !~ m!permission=1!i, "handle_junk by own entry" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'handle_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: handle_junk" );
    ok( $out =~ m!permission=1!i, "handle_junk by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'handle_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: handle_junk" );
    ok( $out =~ m!permission=1!i, "handle_junk by other permission" );

    done_testing();
};

subtest 'mode = list' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out !~ m!permission=1!i, "list by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'list',
            blog_id          => $blog->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: list" );
    ok( $out =~ m!permission=1!i, "list by other permission" );

    done_testing();
};

subtest 'mode = not_junk' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'not_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: not_junk" );
    ok( $out !~ m!permission=1!i, "not_junk by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'not_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: not_junk" );
    ok( $out !~ m!permission=1!i, "not_junk by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'not_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: handle_junk" );
    ok( $out !~ m!permission=1!i, "handle_junk by own entry" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'not_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: not_junk" );
    ok( $out =~ m!permission=1!i, "not_junk by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'not_junk',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: not_junk" );
    ok( $out =~ m!permission=1!i, "not_junk by other permission" );

    done_testing();
};

subtest 'mode = reply' => sub {
    plan skip_all => 'https://movabletype.fogbugz.com/default.asp?106816';

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply" );
    ok( $out !~ m!permission=1!i, "reply by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out !~ m!permission=1!i,
        "reply by permitted user (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply" );
    ok( $out !~ m!permission=1!i, "reply by permitted user (manage_pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply" );
    ok( $out !~ m!permission=1!i, "reply by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply" );
    ok( $out =~ m!permission=1!i, "reply by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply" );
    ok( $out =~ m!permission=1!i, "reply by other blog (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply" );
    ok( $out =~ m!permission=1!i, "reply by other blog (manage_pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply" );
    ok( $out =~ m!permission=1!i, "reply by other blog (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply" );
    ok( $out =~ m!permission=1!i, "reply by other permission" );

    done_testing();
};

subtest 'mode = reply_preview' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply_preview" );
    ok( $out !~ m!permission=1!i, "reply_preview by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply_preview" );
    ok( $out !~ m!permission=1!i,
        "reply_preview by permitted user (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply_preview" );
    ok( $out !~ m!permission=1!i,
        "reply_preview by permitted user (manage_pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply_preview" );
    ok( $out !~ m!permission=1!i,
        "reply_preview by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply_preview" );
    ok( $out !~ m!permission=1!i,
        "reply_preview by other blog (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply_preview" );
    ok( $out !~ m!permission=1!i,
        "reply_preview by other blog (manage_pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply_preview" );
    ok( $out !~ m!permission=1!i,
        "reply_preview by other blog (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: reply_preview" );
    ok( $out !~ m!permission=1!i, "reply_preview by other permission" );

    done_testing();
};

subtest 'mode = save_commenter_perm' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_commenter_perm',
            blog_id          => $blog->id,
            commenter_id     => $kemikawa->id,
            action           => 'trust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: save_commenter_perm" );
    ok( $out !~ m!Permission denied!i, "save_commenter_perm by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_commenter_perm',
            blog_id          => $blog->id,
            commenter_id     => $kemikawa->id,
            action           => 'trust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_commenter_perm" );
    ok( $out !~ m!Permission denied!i,
        "save_commenter_perm by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save_commenter_perm',
            blog_id          => $blog->id,
            commenter_id     => $kemikawa->id,
            action           => 'trust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: save_commenter_perm" );
    ok( $out =~ m!Permission denied!i, "save_commenter_perm by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'save_commenter_perm',
            blog_id          => $blog->id,
            commenter_id     => $kemikawa->id,
            action           => 'trust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_commenter_perm" );
    ok( $out =~ m!Permission denied!i,
        "save_commenter_perm by other permission" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save_commenter_perm',
            blog_id          => $blog->id,
            commenter_id     => $kemikawa->id,
            action           => 'trust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: save_commenter_perm" );
    ok( $out !~ m!Permission denied!i, "save_commenter_perm by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save_commenter_perm',
            blog_id          => $blog->id,
            commenter_id     => $kemikawa->id,
            action           => 'trust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_commenter_perm" );
    ok( $out =~ m!Permission denied!i,
        "save_commenter_perm by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save_commenter_perm',
            blog_id          => $blog->id,
            commenter_id     => $kemikawa->id,
            action           => 'trust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: save_commenter_perm" );
    ok( $out =~ m!Permission denied!i, "save_commenter_perm by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'save_commenter_perm',
            blog_id          => $blog->id,
            commenter_id     => $kemikawa->id,
            action           => 'trust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save_commenter_perm" );
    ok( $out =~ m!Permission denied!i,
        "save_commenter_perm by other permission" );

    if ($perm) {
        $perm->blog_id( $blog->id );
        $perm->save;
    }

    done_testing();
};

subtest 'mode = trust_commenter' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'trust_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: trust_commenter" );
    ok( $out !~ m!Permission denied!i, "trust_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'trust_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out !~ m!Permission denied!i,
        "trust_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'trust_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i,
        "trust_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'trust_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i,
        "trust_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'trust_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                          "Request: trust_commenter" );
    ok( $out !~ m!Permission denied!i, "trust_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'trust_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i,
        "trust_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'trust_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i,
        "trust_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'trust_commenter',
            blog_id          => $blog->id,
            id               => $commenter->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i,
        "trust_commenter by other permission (SC1)" );

    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    done_testing();
};

subtest 'mode = unapprove_item' => sub {
    $comment->visible(1);
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'unapprove_item',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_item" );
    ok( $out !~ m!permission to approve this comment!i,
        "unapprove_item by admin" );

    $comment->visible(1);
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'unapprove_item',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_item" );
    ok( $out !~ m!permission to approve this comment!i,
        "unapprove_item by permitted user" );

    $comment->visible(1);
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'unapprove_item',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_item" );
    ok( $out =~ m!permission to approve this comment!i,
        "unapprove_item by other blog" );

    $comment->visible(1);
    $comment->save;
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'unapprove_item',
            blog_id          => $blog->id,
            id               => $comment->id,
            _type            => 'comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_item" );
    ok( $out =~ m!permission to approve this comment!i,
        "unapprove_item by other permission"
    );

    done_testing();
};

subtest 'mode = save (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'comment',
            entry_id         => 1
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'comment',
            entry_id         => 1
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (new) by permitted user" );

    done_testing();
};

subtest 'mode = save (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out !~ m!permission=1!i,
        "save (edit) by permitted user (feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: save" );
    ok( $out =~ m!permission=1!i,
        "save (edit) by not permitted user (pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out !~ m!permission=1!i, "save (edit) by permitted user (publish)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save (edit) by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: save" );
    ok( $out =~ m!permission=1!i, "save (edit) by other permission" );

    done_testing();
};

subtest 'mode = edit (new)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            entry_id         => 1
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (new) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            entry_id         => 1
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (new) by permitted user" );

    done_testing();
};

subtest 'mode = edit (edit)' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit (edit) by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!permission=1!i,
        "edit (edit) by permitted user (feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out =~ m!permission=1!i,
        "edit (edit) by not permitted user (pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "edit (edit) by permitted user (publish)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit (edit) by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "edit (edit) by other permission" );

    done_testing();
};

subtest 'mode = delete' => sub {
    $comment = MT::Test::Permission->make_comment(
        entry_id => $entry->id,
        blog_id  => $blog->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "delete by admin" );

    $comment = MT::Test::Permission->make_comment(
        entry_id => $entry->id,
        blog_id  => $blog->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "delete by permitted user (feedback)" );

    $comment = MT::Test::Permission->make_comment(
        entry_id => $entry->id,
        blog_id  => $blog->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment2->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "delete by not permitted user (pages)" );

    $comment = MT::Test::Permission->make_comment(
        entry_id => $entry->id,
        blog_id  => $blog->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out !~ m!permission=1!i, "delete by permitted user (publish)" );

    $comment = MT::Test::Permission->make_comment(
        entry_id => $entry->id,
        blog_id  => $blog->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "delete by other blog" );

    $comment = MT::Test::Permission->make_comment(
        entry_id => $entry->id,
        blog_id  => $blog->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'edit',
            blog_id          => $blog->id,
            _type            => 'comment',
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                     "Request: edit" );
    ok( $out =~ m!permission=1!i, "delete by other permission" );

    done_testing();
};

subtest 'action = unapprove_comment' => sub {
    $comment = MT::Test::Permission->make_comment(
        entry_id => $entry->id,
        blog_id  => $blog->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            blog_id              => $blog->id,
            _type                => 'comment',
            action_name          => 'unapprove_comment',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'unapprove_comment',
            id                     => $comment->id,
            plugin_action_selector => 'unapprove_comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unapprove_comment" );
    ok( $out !~ m!not implemented!i, "unapprove_comment by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unapprove_comment',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'unapprove_comment',
            id                     => $comment->id,
            plugin_action_selector => 'unapprove_comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unapprove_comment" );
    ok( $out !~ m!not implemented!i, "unapprove_comment by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unapprove_comment',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'unapprove_comment',
            id                     => $comment->id,
            plugin_action_selector => 'unapprove_comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unapprove_comment" );
    ok( $out =~ m!not implemented!i, "unapprove_comment by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unapprove_comment',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            blog_id                => $blog->id,
            plugin_action_selector => 'unapprove_comment',
            id                     => $comment->id,
            plugin_action_selector => 'unapprove_comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_comment" );
    ok( $out =~ m!not implemented!i,
        "unapprove_comment by other permission" );

    done_testing();
};

subtest 'action = ban_commenter' => sub {
    MT->config( 'SingleCommunity', 0 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'ban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'ban_commenter',
            id                     => $comment->id,
            plugin_action_selector => 'ban_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: ban_commenter" );
    ok( $out !~ m!not implemented!i, "ban_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'ban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'ban_commenter',
            id                     => $comment->id,
            plugin_action_selector => 'ban_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out !~ m!not implemented!i,
        "ban_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'ban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'ban_commenter',
            id                     => $comment->id,
            plugin_action_selector => 'ban_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: ban_commenter" );
    ok( $out =~ m!not implemented!i, "ban_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'ban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'ban_commenter',
            id                     => $comment->id,
            plugin_action_selector => 'ban_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!not implemented!i,
        "ban_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'ban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'ban_commenter',
            id                     => $comment->id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: ban_commenter" );
    ok( $out !~ m!not implemented!i, "ban_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'ban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'ban_commenter',
            id                     => $comment->id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out !~ m!not implemented!i,
        "ban_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'ban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'ban_commenter',
            id                     => $comment->id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: ban_commenter" );
    ok( $out !~ m!not implemented!i, "ban_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'ban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'ban_commenter',
            id                     => $comment->id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!not implemented!i,
        "ban_commenter by other permission (SC1)" );

    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    done_testing();
};

subtest 'action = unban_commenter' => sub {
    MT->config( 'SingleCommunity', 0 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => 0,
        }
    );
    if ($perm) {
        $perm->blog_id( $blog->id );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban_commenter" );
    ok( $out !~ m!not implemented!i, "unban_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out !~ m!not implemented!i,
        "unban_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban_commenter" );
    ok( $out =~ m!not implemented!i, "unban_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out =~ m!not implemented!i,
        "unban_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1 );
    $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban_commenter" );
    ok( $out !~ m!not implemented!i, "unban_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out !~ m!not implemented!i,
        "unban_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban_commenter" );
    ok( $out !~ m!not implemented!i, "unban_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'unban_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out =~ m!not implemented!i,
        "unban_commenter by other permission (SC1)" );

    done_testing();
};

subtest 'action = trust_commenter' => sub {
    MT->config( 'SingleCommunity', 0 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => 0,
        }
    );
    if ($perm) {
        $perm->blog_id( $blog->id );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'trust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'trust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: trust_commenter" );
    ok( $out !~ m!not implemented!i, "trust_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'trust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'trust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out !~ m!not implemented!i,
        "trust_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'trust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'trust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: trust_commenter" );
    ok( $out =~ m!not implemented!i, "trust_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'trust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'trust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!not implemented!i,
        "trust_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'trust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'trust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: trust_commenter" );
    ok( $out !~ m!not implemented!i, "trust_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'trust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'trust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!not implemented!i,
        "trust_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'trust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'trust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: trust_commenter" );
    ok( $out =~ m!not implemented!i, "trust_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'trust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'trust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!not implemented!i,
        "trust_commenter by other permission (SC1)" );

    done_testing();
};

subtest 'action = untrust_commenter' => sub {
    MT->config( 'SingleCommunity', 0 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => 0,
        }
    );
    if ($perm) {
        $perm->blog_id( $blog->id );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'untrust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust_commenter" );
    ok( $out !~ m!not implemented!i, "untrust_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'untrust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out !~ m!not implemented!i,
        "untrust_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'untrust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!not implemented!i,
        "untrust_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'untrust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!not implemented!i,
        "untrust_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'untrust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust_commenter" );
    ok( $out !~ m!not implemented!i, "untrust_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'untrust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!not implemented!i,
        "untrust_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'untrust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!not implemented!i,
        "untrust_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'comment',
            action_name          => 'untrust_commenter',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust_commenter',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!not implemented!i,
        "untrust_commenter by other permission (SC1)" );

    done_testing();
};

subtest 'action = untrust' => sub {
    MT->config( 'SingleCommunity', 0 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => 0,
        }
    );
    if ($perm) {
        $perm->blog_id( $blog->id );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'untrust',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust" );
    ok( $out !~ m!not implemented!i, "untrust by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'untrust',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust" );
    ok( $out =~ m!not implemented!i, "untrust by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'untrust',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust" );
    ok( $out =~ m!not implemented!i, "untrust by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'untrust',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust" );
    ok( $out =~ m!not implemented!i, "untrust by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1 );
    $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'untrust',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust" );
    ok( $out !~ m!not implemented!i, "untrust by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'untrust',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust" );
    ok( $out =~ m!not implemented!i, "untrust by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'untrust',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust" );
    ok( $out =~ m!not implemented!i, "untrust by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'untrust',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'untrust',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: untrust" );
    ok( $out =~ m!not implemented!i, "untrust by other permission (SC1)" );

    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    done_testing();
};

subtest 'action = unban' => sub {
    MT->config( 'SingleCommunity', 0 );
    require MT::Permission;
    my $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => 0,
        }
    );
    if ($perm) {
        $perm->blog_id( $blog->id );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'unban',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban" );
    ok( $out !~ m!not implemented!i, "unban by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'unban',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban" );
    ok( $out =~ m!not implemented!i, "unban by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'unban',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban" );
    ok( $out =~ m!not implemented!i, "unban by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'unban',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban',
            blog_id                => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban" );
    ok( $out =~ m!not implemented!i, "unban by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1 );
    $perm = MT::Permission->load(
        {   author_id => $kemikawa->id,
            blog_id   => $blog->id,
        }
    );
    if ($perm) {
        $perm->blog_id(0);
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $admin,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'unban',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban" );
    ok( $out !~ m!not implemented!i, "unban by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $aikawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'unban',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban" );
    ok( $out =~ m!not implemented!i, "unban by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $egawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'unban',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban" );
    ok( $out =~ m!not implemented!i, "unban by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user          => $kikkawa,
            __request_method     => 'POST',
            __mode               => 'itemset_action',
            _type                => 'commenter',
            action_name          => 'unban',
            itemset_action_input => '',
            return_args => '__mode%3Dlist&_type%3Dcomment%26blog_id%3D'
                . $blog->id,
            plugin_action_selector => 'unban',
            id                     => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out,                        "Request: unban" );
    ok( $out =~ m!not implemented!i, "unban by other permission (SC1)" );

    done_testing();
};

done_testing();
