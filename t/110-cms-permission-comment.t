#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

### Make test data

# Website
my $website = MT::Test::Permission->make_website();

# Blog
my $blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);
my $second_blog = MT::Test::Permission->make_blog(
    parent_id => $website->id,
);

# Author
my $aikawa = MT::Test::Permission->make_author(
    name => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $ichikawa = MT::Test::Permission->make_author(
    name => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);

my $ukawa = MT::Test::Permission->make_author(
    name => 'ukawa',
    nickname => 'Saburo Ukawa',
);

my $egawa = MT::Test::Permission->make_author(
    name => 'egawa',
    nickname => 'Shiro Egawa',
);

my $ogawa = MT::Test::Permission->make_author(
    name => 'ogawa',
    nickname => 'Goro Ogawa',
);

my $kagawa = MT::Test::Permission->make_author(
    name => 'kagawa',
    nickname => 'Ichiro Kagawa',
);

my $kikkawa = MT::Test::Permission->make_author(
    name => 'kikkawa',
    nickname => 'Jiro Kikkawa',
);

my $kumekawa = MT::Test::Permission->make_author(
    name => 'kumekawa',
    nickname => 'Saburo Kumekawa',
);

my $kemikawa = MT::Test::Permission->make_author(
    name => 'kemikawa',
    nickname => 'Shiro Kemikawa',
    type => MT::Author::COMMENTER(),
);

my $admin = MT::Author->load(1);

# Role
my $manage_feedback = MT::Test::Permission->make_role(
   name  => 'Manage Feedback',
   permissions => "'manage_feedback'",
);

my $manage_pages = MT::Test::Permission->make_role(
   name  => 'Manage Pages',
   permissions => "'manage_pages'",
);

my $publish_post = MT::Test::Permission->make_role(
   name  => 'Publish Post',
   permissions => "'publish_post'",
);

my $create_post = MT::Test::Permission->make_role(
   name  => 'Create Post',
   permissions => "'create_post'",
);

my $designer = MT::Role->load( { name => MT->translate( 'Designer' ) } );
my $commenter = MT::Role->load( { name => MT->translate( 'Commenter' ) } );

require MT::Association;
MT::Association->link( $aikawa => $manage_feedback => $blog );
MT::Association->link( $ichikawa => $manage_pages => $blog );
MT::Association->link( $ukawa => $publish_post => $blog );
MT::Association->link( $kikkawa => $designer => $blog );
MT::Association->link( $kumekawa => $publish_post => $blog );
MT::Association->link( $kemikawa => $commenter => $blog );

MT::Association->link( $egawa => $manage_feedback => $second_blog );
MT::Association->link( $ogawa => $manage_pages => $second_blog );
MT::Association->link( $kagawa => $publish_post => $second_blog );
MT::Association->link( $egawa => $create_post => $blog );
MT::Association->link( $ogawa => $create_post => $blog );
MT::Association->link( $kagawa => $create_post => $blog );

# Entry
my $entry = MT::Test::Permission->make_entry(
    blog_id        => $blog->id,
    author_id      => $ukawa->id,
);

my $page = MT::Test::Permission->make_page(
    blog_id        => $blog->id,
    author_id      => $ichikawa->id,
);

# Comment
my $comment = MT::Test::Permission->make_comment(
    entry_id => $entry->id,
    blog_id  => $blog->id,
    commenter_id => $kemikawa->id,
);

my $comment2 = MT::Test::Permission->make_comment(
    entry_id => $page->id,
    blog_id  => $blog->id,
    commenter_id => $kemikawa->id,
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
    ok( $out !~ m!permission to approve this comment!i, "approve_item by admin" );

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
    ok( $out !~ m!permission to approve this comment!i, "approve_item by permitted user" );

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
    ok( $out =~ m!permission to approve this comment!i, "approve_item by other blog" );

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
    ok( $out =~ m!permission to approve this comment!i, "approve_item by other permission" );
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
    ok( $out, "Request: ban_commenter" );
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
    ok( $out !~ m!Permission denied!i, "ban_commenter by permitted user (SC0)" );

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
    ok( $out, "Request: ban_commenter" );
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
    ok( $out =~ m!Permission denied!i, "ban_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
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
    ok( $out, "Request: ban_commenter" );
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
    ok( $out =~ m!Permission denied!i, "ban_commenter by permitted user (SC1)" );

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
    ok( $out, "Request: ban_commenter" );
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
    ok( $out =~ m!Permission denied!i, "ban_commenter by other permission (SC1)" );

    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }
};

subtest 'mode = dialog_post_comment' => sub {
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
    ok( $out, "Request: dialog_post_comment" );
    ok( $out !~ m!Permission denied!i, "dialog_post_comment by admin" );

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
    ok( $out, "Request: dialog_post_comment" );
    ok( $out !~ m!Permission denied!i, "dialog_post_comment by permitted user" );

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
    ok( $out, "Request: dialog_post_comment" );
    ok( $out =~ m!Permission denied!i, "dialog_post_comment by other blog" );

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
    ok( $out, "Request: dialog_post_comment" );
    ok( $out =~ m!Permission denied!i, "dialog_post_comment by other permission" );
};

subtest 'mode = do_reply' => sub {
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
    ok( $out, "Request: do_reply" );
    ok( $out !~ m!Permission denied!i, "do_reply by admin" );

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
    ok( $out !~ m!Permission denied!i, "do_reply by permitted user (manage_feedback)" );

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
    ok( $out !~ m!Permission denied!i, "do_reply by permitted user (manage_pages)" );

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
    ok( $out !~ m!Permission denied!i, "do_reply by permitted user (publish_post)" );

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
    ok( $out, "Request: do_reply" );
    ok( $out =~ m!Permission denied!i, "do_reply by other user" );

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
    ok( $out =~ m!Permission denied!i, "do_reply by other blog (manage_feedback)" );

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
    ok( $out, "Request: do_reply" );
    ok( $out =~ m!Permission denied!i, "do_reply by other blog (manage_pages)" );

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
    ok( $out, "Request: do_reply" );
    ok( $out =~ m!Permission denied!i, "do_reply by other blog (publish_post)" );

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
    ok( $out, "Request: do_reply" );
    ok( $out =~ m!Permission denied!i, "do_reply by other permission" );
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
    ok( $out, "Request: empty_junk" );
    ok( $out !~ m!Permission denied!i, "empty_junk by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'empty_junk',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: empty_junk" );
    ok( $out !~ m!Permission denied!i, "empty_junk by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'empty_junk',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: empty_junk" );
    ok( $out =~ m!Permission denied!i, "empty_junk by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'empty_junk',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: empty_junk" );
    ok( $out =~ m!Permission denied!i, "empty_junk by other permission" );
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
    ok( $out, "Request: handle_junk" );
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
    ok( $out, "Request: handle_junk" );
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
    ok( $out, "Request: handle_junk" );
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
    ok( $out, "Request: handle_junk" );
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
    ok( $out, "Request: handle_junk" );
    ok( $out =~ m!permission=1!i, "handle_junk by other permission" );
};

subtest 'mode = list_comment' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'list_comment',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_comment" );
    ok( $out !~ m!Permission denied!i, "list_comment by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'list_comment',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_comment" );
    ok( $out !~ m!Permission denied!i, "list_comment by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'list_comment',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_comment" );
    ok( $out =~ m!Permission denied!i, "list_comment by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'list_comment',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: list_comment" );
    ok( $out =~ m!Permission denied!i, "list_comment by other permission" );
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
    ok( $out, "Request: not_junk" );
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
    ok( $out, "Request: not_junk" );
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
    ok( $out, "Request: handle_junk" );
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
    ok( $out, "Request: not_junk" );
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
    ok( $out, "Request: not_junk" );
    ok( $out =~ m!permission=1!i, "not_junk by other permission" );
};

subtest 'mode = reply' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out !~ m!Permission denied!i, "reply by admin" );

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
    ok( $out !~ m!Permission denied!i, "reply by permitted user (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out !~ m!Permission denied!i, "reply by permitted user (manage_pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ukawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out !~ m!Permission denied!i, "reply by permitted user (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kumekawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out =~ m!Permission denied!i, "reply by other user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out !~ m!Permission denied!i, "reply by other blog (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ogawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out !~ m!Permission denied!i, "reply by other blog (manage_pages)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kagawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out !~ m!Permission denied!i, "reply by other blog (publish_post)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'reply',
            blog_id          => $blog->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply" );
    ok( $out =~ m!Permission denied!i, "reply by other permission" );
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
    ok( $out, "Request: reply_preview" );
    ok( $out !~ m!Permission denied!i, "reply_preview by admin" );

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
    ok( $out !~ m!Permission denied!i, "reply_preview by permitted user (manage_feedback)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $ichikawa,
            __request_method => 'POST',
            __mode           => 'reply_preview',
            blog_id          => $blog->id,
            reply_to         => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: reply_preview" );
    ok( $out !~ m!Permission denied!i, "reply_preview by permitted user (manage_pages)" );

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
    ok( $out !~ m!Permission denied!i, "reply_preview by permitted user (publish_post)" );

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
    ok( $out !~ m!Permission denied!i, "reply_preview by other blog (manage_feedback)" );

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
    ok( $out !~ m!Permission denied!i, "reply_preview by other blog (manage_pages)" );

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
    ok( $out !~ m!Permission denied!i, "reply_preview by other blog (publish_post)" );

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
    ok( $out, "Request: reply_preview" );
    ok( $out =~ m!Permission denied!i, "reply_preview by other permission" );
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
    ok( $out, "Request: save_commenter_perm" );
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
    ok( $out !~ m!Permission denied!i, "save_commenter_perm by permitted user" );

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
    ok( $out, "Request: save_commenter_perm" );
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
    ok( $out =~ m!Permission denied!i, "save_commenter_perm by other permission" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
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
    ok( $out, "Request: save_commenter_perm" );
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
    ok( $out =~ m!Permission denied!i, "save_commenter_perm by permitted user" );

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
    ok( $out, "Request: save_commenter_perm" );
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
    ok( $out =~ m!Permission denied!i, "save_commenter_perm by other permission" );

    if ( $perm ) {
        $perm->blog_id( $blog->id );
        $perm->save;
    }
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
    ok( $out, "Request: trust_commenter" );
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
    ok( $out !~ m!Permission denied!i, "trust_commenter by permitted user (SC0)" );

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
    ok( $out =~ m!Permission denied!i, "trust_commenter by other blog (SC0)" );

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
    ok( $out =~ m!Permission denied!i, "trust_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
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
    ok( $out, "Request: trust_commenter" );
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
    ok( $out =~ m!Permission denied!i, "trust_commenter by permitted user (SC1)" );

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
    ok( $out =~ m!Permission denied!i, "trust_commenter by other blog (SC1)" );

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
    ok( $out =~ m!Permission denied!i, "trust_commenter by other permission (SC1)" );

    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }
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
    ok( $out !~ m!permission to approve this comment!i, "unapprove_item by admin" );

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
    ok( $out !~ m!permission to approve this comment!i, "unapprove_item by permitted user" );

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
    ok( $out =~ m!permission to approve this comment!i, "unapprove_item by other blog" );

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
    ok( $out =~ m!permission to approve this comment!i, "unapprove_item by other permission" );
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
    ok( $out, "Request: save" );
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
    ok( $out, "Request: save" );
    ok( $out =~ m!Invalid Request!i, "save (new) by permitted user" );
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
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission denied!i, "save (edit) by admin" );

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
    ok( $out !~ m!Permission denied!i, "save (edit) by permitted user (feedback)" );

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
    ok( $out !~ m!Permission denied!i, "save (edit) by permitted user (pages)" );

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
    ok( $out, "Request: save" );
    ok( $out !~ m!Permission denied!i, "save (edit) by permitted user (publish)" );

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
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission denied!i, "save (edit) by other blog" );

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
    ok( $out, "Request: save" );
    ok( $out =~ m!Permission denied!i, "save (edit) by other permission" );
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
    ok( $out, "Request: edit" );
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
    ok( $out, "Request: edit" );
    ok( $out =~ m!Invalid Request!i, "edit (new) by permitted user" );
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
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "edit (edit) by admin" );

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
    ok( $out !~ m!Permission denied!i, "edit (edit) by permitted user (feedback)" );

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
    ok( $out !~ m!Permission denied!i, "edit (edit) by permitted user (pages)" );

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
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "edit (edit) by permitted user (publish)" );

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
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission denied!i, "edit (edit) by other blog" );

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
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission denied!i, "edit (edit) by other permission" );
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
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "delete by admin" );

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
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "delete by permitted user (feedback)" );

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
            id               => $comment->id,
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "delete by permitted user (pages)" );

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
    ok( $out, "Request: edit" );
    ok( $out !~ m!Permission denied!i, "delete by permitted user (publish)" );

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
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission denied!i, "delete by other blog" );

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
    ok( $out, "Request: edit" );
    ok( $out =~ m!Permission denied!i, "delete by other permission" );
};

subtest 'action = unapprove_comment' => sub {
    $comment = MT::Test::Permission->make_comment(
        entry_id => $entry->id,
        blog_id  => $blog->id,
    );
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'unapprove_comment',
            blog_id          => $blog->id,
            _type            => 'comment',
            action_name      => 'unapprove_comment',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'unapprove_comment',
            id               => $comment->id,
            plugin_action_selector => 'unapprove_comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_comment" );
    ok( $out !~ m!Permission denied!i, "unapprove_comment by admin" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'unapprove_comment',
            _type            => 'comment',
            action_name      => 'unapprove_comment',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'unapprove_comment',
            id               => $comment->id,
            plugin_action_selector => 'unapprove_comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_comment" );
    ok( $out !~ m!Permission denied!i, "unapprove_comment by permitted user" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'unapprove_comment',
            _type            => 'comment',
            action_name      => 'unapprove_comment',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'unapprove_comment',
            id               => $comment->id,
            plugin_action_selector => 'unapprove_comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_comment" );
    ok( $out =~ m!Permission denied!i, "unapprove_comment by other blog" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'unapprove_comment',
            action_name      => 'unapprove_comment',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            blog_id          => $blog->id,
            plugin_action_selector => 'unapprove_comment',
            id               => $comment->id,
            plugin_action_selector => 'unapprove_comment',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unapprove_comment" );
    ok( $out =~ m!Permission denied!i, "unapprove_comment by other permission" );
};

subtest 'action = ban_commenter' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'ban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'ban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out !~ m!Permission denied!i, "ban_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'ban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'ban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out !~ m!Permission denied!i, "ban_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'ban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'ban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i, "ban_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'ban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'ban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i, "ban_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'ban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'ban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out !~ m!Permission denied!i, "ban_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'ban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'ban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i, "ban_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'ban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'ban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i, "ban_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'ban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'ban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'ban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: ban_commenter" );
    ok( $out =~ m!Permission denied!i, "ban_commenter by other permission (SC1)" );

    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }
};

subtest 'action = unban_commenter' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'unban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out !~ m!Permission denied!i, "unban_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'unban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out !~ m!Permission denied!i, "unban_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'unban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out =~ m!Permission denied!i, "unban_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'unban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out =~ m!Permission denied!i, "unban_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'unban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out !~ m!Permission denied!i, "unban_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'unban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out =~ m!Permission denied!i, "unban_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'unban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out =~ m!Permission denied!i, "unban_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'unban_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban_commenter" );
    ok( $out =~ m!Permission denied!i, "unban_commenter by other permission (SC1)" );

    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }
};

subtest 'action = trust_commenter' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'trust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'trust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out !~ m!Permission denied!i, "trust_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'trust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'trust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out !~ m!Permission denied!i, "trust_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'trust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'trust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i, "trust_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'trust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'trust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i, "trust_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'trust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'trust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out !~ m!Permission denied!i, "trust_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'trust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'trust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i, "trust_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'trust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'trust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i, "trust_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'trust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'trust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'trust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: trust_commenter" );
    ok( $out =~ m!Permission denied!i, "trust_commenter by other permission (SC1)" );

    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }
};

subtest 'action = untrust_commenter' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'untrust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out !~ m!Permission denied!i, "untrust_commenter by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'untrust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out !~ m!Permission denied!i, "untrust_commenter by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'untrust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!Permission denied!i, "untrust_commenter by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'untrust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!Permission denied!i, "untrust_commenter by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'untrust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out !~ m!Permission denied!i, "untrust_commenter by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'untrust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!Permission denied!i, "untrust_commenter by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'untrust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!Permission denied!i, "untrust_commenter by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'comment',
            action_name      => 'untrust_commenter',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust_commenter',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust_commenter',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust_commenter" );
    ok( $out =~ m!Permission denied!i, "untrust_commenter by other permission (SC1)" );

    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }
};

subtest 'action = untrust' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'untrust',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust" );
    ok( $out !~ m!Permission denied!i, "untrust by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'untrust',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust" );
    ok( $out !~ m!Permission denied!i, "untrust by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'untrust',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust" );
    ok( $out =~ m!Permission denied!i, "untrust by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'untrust',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust" );
    ok( $out =~ m!Permission denied!i, "untrust by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'untrust',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust" );
    ok( $out !~ m!Permission denied!i, "untrust by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'untrust',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust" );
    ok( $out =~ m!Permission denied!i, "untrust by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'untrust',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust" );
    ok( $out =~ m!Permission denied!i, "untrust by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'untrust',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'untrust',
            id               => $comment->commenter_id,
            plugin_action_selector => 'untrust',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: untrust" );
    ok( $out =~ m!Permission denied!i, "untrust by other permission (SC1)" );

    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }
};

subtest 'action = unban' => sub {
    MT->config( 'SingleCommunity', 0, 1 );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'unban',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban" );
    ok( $out !~ m!Permission denied!i, "unban by admin (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'unban',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban" );
    ok( $out !~ m!Permission denied!i, "unban by permitted user (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'unban',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban" );
    ok( $out =~ m!Permission denied!i, "unban by other blog (SC0)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'unban',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban" );
    ok( $out =~ m!Permission denied!i, "unban by other permission (SC0)" );

    MT->config( 'SingleCommunity', 1, 1 );
    require MT::Permission;
    my $perm = MT::Permission->load({
        author_id => $kemikawa->id,
        blog_id   => $blog->id,
    });
    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'unban',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban" );
    ok( $out !~ m!Permission denied!i, "unban by admin (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $aikawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'unban',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban" );
    ok( $out =~ m!Permission denied!i, "unban by permitted user (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $egawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'unban',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban" );
    ok( $out =~ m!Permission denied!i, "unban by other blog (SC1)" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $kikkawa,
            __request_method => 'POST',
            __mode           => 'itemset_action',
            _type            => 'commenter',
            action_name      => 'unban',
            itemset_action_input => '',
            return_args      => '__mode%3Dlist_comment%26blog_id%3D'.$blog->id,
            plugin_action_selector => 'unban',
            id               => $comment->commenter_id,
            plugin_action_selector => 'unban',
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: unban" );
    ok( $out =~ m!Permission denied!i, "unban by other permission (SC1)" );

    if ( $perm ) {
        $perm->blog_id( 0 );
        $perm->save;
    }
};

done_testing();
