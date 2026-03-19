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
        DefaultLanguage => 'en_US',
        AdminThemeId => 'admin2023',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;
use Data::Dumper;

$test_env->prepare_fixture('db');

my $parent      = MT::Test::Permission->make_website(name => 'parent');
my $child       = MT::Test::Permission->make_blog(parent_id => $parent->id, name => 'child');
my $create_post = MT::Test::Permission->make_role(name => 'Create Post', permissions => "'create_post'");


subtest 'access to dashboard with perms' => sub {
    my $user = MT::Test::Permission->make_author(name => 'user',  nickname => 'user');

    MT::Association->link($user => $create_post => $parent);
    MT::Association->link($user => $create_post => $child);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    # access_to_dashbboard( $app, $site, $perm_err, [link_parent, link_child] );
    # when $site is undef, acess to system dashboard.
    # If only 2 args are given, tests are skipped (access only).
    # link_*
    #   0 ... not display
    #   1 ... display but no link
    #   2 ... link
    access_to_dashboard( $app, undef,   0, [2, 2] );
    access_to_dashboard( $app, $parent, 0, [2, 2] );
    access_to_dashboard( $app, $child,  0, [0, 0] );
};


subtest 'access to dashboard without parent perm' => sub {
    my $user = MT::Test::Permission->make_author(name => 'user',  nickname => 'user');

    MT::Association->link($user => $create_post => $parent);
    MT::Association->link($user => $create_post => $child);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    access_to_dashboard( $app, undef   );
    access_to_dashboard( $app, $parent );
    access_to_dashboard( $app, $child  );

    MT::Association->unlink($user => $create_post => $parent);

    access_to_dashboard( $app, undef,   0, [2, 2] );
    access_to_dashboard( $app, $parent, 0, [1, 2] );
    access_to_dashboard( $app, $child,  0, [0, 0] );
};


subtest 'access to dashboard without child perm' => sub {
    my $user = MT::Test::Permission->make_author(name => 'user',  nickname => 'user');

    MT::Association->link($user => $create_post => $parent);
    MT::Association->link($user => $create_post => $child);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    access_to_dashboard( $app, undef   );
    access_to_dashboard( $app, $parent );
    access_to_dashboard( $app, $child  );

    MT::Association->unlink($user => $create_post => $child);

    access_to_dashboard( $app, undef,   0, [2, 0] );
    access_to_dashboard( $app, $parent, 0, [0, 0] );
    access_to_dashboard( $app, $child,  1 );
};


subtest 'access to dashboard without any perms' => sub {
    my $user = MT::Test::Permission->make_author(name => 'user',  nickname => 'user');

    MT::Association->link($user => $create_post => $parent);
    MT::Association->link($user => $create_post => $child);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);

    access_to_dashboard( $app, undef   );
    access_to_dashboard( $app, $parent );
    access_to_dashboard( $app, $child  );

    MT::Association->unlink($user => $create_post => $parent);
    MT::Association->unlink($user => $create_post => $child);

    access_to_dashboard( $app, undef,   0, [0, 0] );
    access_to_dashboard( $app, $parent, 1 );
    access_to_dashboard( $app, $child,  1 );
};



done_testing;


sub access_to_dashboard {
    my ( $app, $site, $perm_err, $link_tests ) = @_;

    $app->get_ok({
        __mode => 'dashboard',
        ($site ? (blog_id => $site->id) : ()),
    });

    return if @_ == 2;

    if ( $perm_err ) {
        $app->has_permission_error('denied ' . ($site ? $site->name : 'system'));
        if ( $link_tests ) {
            ok 0, "we have link tests but perm error";
        }
        return;
    }
    else {
        $app->has_no_permission_error('perm to ' . ($site ? $site->name : 'system'));
    }

    test_link( $app, $link_tests );
}


sub test_link {
    my ( $app, $link_tests ) = @_;
    my ( $link_parent, $link_child ) = @$link_tests;
    my $exp_link_num = scalar(grep { $_ == 2 } @$link_tests);

    my $elems = $app->wq_find('.mt-primaryNavigation__sites');
    my $html  = $elems->as_html;
    my @links = map { $_->as_html } $elems->find('a');

    is scalar(@links), $exp_link_num, "expected link num $exp_link_num";

    if ( $link_parent == 2 ) {
        ok( (grep { qr/parent/ } @links)[0], 'parent link' );
    }
    elsif ( $link_parent == 1 ) {
        like $html, qr/>\s*parent\s*</, 'parent name only';
    }
    else {
        unlike $html, qr/>\s*parent\s*</, 'no parent';
    }

    if ( $link_child == 2 ) {
        ok( (grep { qr/child/ } @links)[0], 'child link' );
    }
    elsif ( $link_child == 1 ) {
        like $html, qr/>\s*child\s*</, 'child name only';
    }
    else {
        unlike $html, qr/>\s*child\s*</, 'no child';
    }

}
