#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'upgrader-test.cfg';
}

use lib 'lib', 'extlib', 't/lib', '../lib', '../extlib';
use MT::Test qw( :app :newdb );
use MT::Test::Permission;
use Test::More;

my ( $app, $out );

subtest 'Check displaying both website and blog themes in install view' =>
    sub {
    $app = _run_app(
        'MT::App::Upgrader',
        {   __request_method       => 'POST',
            __mode                 => 'init_user',
            admin_username         => 'admin',
            admin_nickname         => 'admin',
            admin_email            => 'miuchi+test@sixapart.com',
            use_system_email       => 'on',
            preferred_language     => 'en-us',
            admin_password         => 'password',
            admin_password_confirm => 'password',
            continue               => 1,
        },
    );
    $out = delete $app->{__test_output};

    my $title = '<title>Create Your First Website | Movable Type</title>';
    like( $out, qr/$title/, '"Create Website" view is displayed.' );
    my $optgrp_website = quotemeta '<optgroup label="Website">';
    like( $out, qr/$optgrp_website/,
        '"Create Website" view has website\'s optgroup tag.' );
    my $optgrp_blog = quotemeta '<optgroup label="Blog">';
    like( $out, qr/$optgrp_blog/,
        '"Create Website" view has blog\'s optgroup tag.' );
    };

subtest 'Upgrade from MT4 to MT6' => sub {
    MT::Test->init_db;
    MT::Website->remove_all;

    my @blog_ids;
    foreach ( 0 .. 2 ) {
        my $blog = MT::Test::Permission->make_blog( parent_id => 0, );
        ok( $blog, 'Create blog.' );
        push @blog_ids, $blog->id;
    }
    my $admin = MT::Author->load(1);
    $admin->favorite_blogs( \@blog_ids );
    $admin->save or die $admin->errstr;

    is( MT::Website->count(), 0, 'There is no website.' );
    is( MT::Blog->count(),    3, 'There are three blogs.' );

    my $blog_admin
        = MT::Role->load( { name => MT->translate('Blog Administrator') } );
    my $blog = MT::Blog->load( $blog_ids[0] );
    $admin->add_role( $blog_admin, $blog );

    my @roles;
    my $iter = $admin->role_iter( { blog_id => $blog->id } );
    while ( my $r = $iter->() ) {
        push @roles, $r;
    }
    is( scalar @roles, 1, 'Administrator has one role.' );
    is( $roles[0]->name,
        MT->translate('Blog Administrator'),
        'Administrator has "Blog Administrator" role.'
    );
    my $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_blog'),
        'Administrator has "administer_blog" permission.' );
    ok( !$perms->has('administer_website'),
        'Administer does not have "administer_website" permission.' );

    my $cfg = MT->config;
    $cfg->MTVersion(4.38);
    $cfg->SchemaVersion(4.0077);
    $cfg->save_config;

    my $config = MT::Config->load;
    my $data   = $config->data;
    my @lines  = split /\n/, $data;
    my @new_lines;
    foreach my $line (@lines) {
        if ( $line =~ /^MTVersion/ ) {
            $line = 'MTVersion 4.38';
        }
        elsif ( $line =~ /^SchemaVersion/ ) {
            $line = 'SchemaVersion 4.0077';
        }
        push @new_lines, $line;
    }
    my $new_data = join "\n", @new_lines;
    $config->data($new_data);
    $config->save or die $config->errstr;

    $app = _run_app(
        'MT::App::Upgrader',
        {   __request_method => 'POST',
            __mode           => 'upgrade',
            username         => 'Melody',
            password         => 'Nelson',
        },
    );
    $out = delete $app->{__test_output};

    my $json_steps = $app->response;
    while ( @{ $json_steps->{steps} || [] } ) {

        require MT::Util;
        $json_steps = MT::Util::to_json( $json_steps->{steps} );

        require MT::App::Upgrader;
        $app = _run_app(
            'MT::App::Upgrader',
            {   __request_method => 'POST',
                username         => 'Melody',
                password         => 'Nelson',
                __mode           => 'run_actions',
                steps            => $json_steps,
            },
        );
        $out = delete $app->{__test_output};

        $out =~ s/^.*JSON://s;

        require JSON;
        $json_steps = JSON::from_json($out);

        ok( !$json_steps->{error}, 'Request has no error.' );

    }

    is( MT::Website->count(), 3, 'There are three websites.' );
    is( MT::Blog->count(),    0, 'There is no blog.' );

    $admin = MT::Author->load(1);
    ok( !$admin->favorite_blogs,
        'Administrator does not have favorite_blogs' );
    my $favorite_websites = $admin->favorite_websites;
    is( scalar @$favorite_websites,
        3, 'Administrator has three favorite_websites.' );

    $iter = $admin->role_iter( { blog_id => $blog->id } );
    @roles = ();
    while ( my $r = $iter->() ) {
        push @roles, $r;
    }
    is( scalar @roles, 1, 'Administrator has one role.' );
    is( $roles[0]->name,
        MT->translate('Website Administrator'),
        'Administrator has "Website Administrator" role.'
    );

    $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_blog'),
        'Administrator has "administer_blog" permission.' );
    ok( $perms->has('administer_website'),
        'Administrator has "administer_website" permission.' );
};

subtest 'Upgrade from MT5 to MT6' => sub {
    MT::Test->init_db;

    my $blog = MT::Test::Permission->make_blog( parent_id => 0, );
    ok( $blog, 'Create blog.' );

    is( MT::Website->count(), 1, 'There is one website.' );
    is( MT::Blog->count(),    1, 'There is one blog.' );

    my $website = MT::Website->load(1);
    my $admin   = MT::Author->load(1);
    $admin->favorite_websites( [ $website->id ] );
    $admin->favorite_blogs(    [ $blog->id ] );
    $admin->save or die $admin->errstr;

    my $blog_admin
        = MT::Role->load( { name => MT->translate('Blog Administrator') } );
    $admin->add_role( $blog_admin, $blog );

    my @roles;
    my $iter = $admin->role_iter( { blog_id => $blog->id } );
    while ( my $r = $iter->() ) {
        push @roles, $r;
    }
    is( scalar @roles, 1, 'Administrator has one role.' );
    is( $roles[0]->name,
        MT->translate('Blog Administrator'),
        'Administrator has "Blog Administrator" role.'
    );
    my $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_blog'),
        'Administrator has "administer_blog" permission.' );
    ok( !$perms->has('administer_website'),
        'Administrator does not have "administer_website" permission.' );

    my $cfg = MT->config;
    $cfg->MTVersion(5.2);
    $cfg->SchemaVersion(5.0036);
    $cfg->save_config;

    my $config = MT::Config->load;
    my $data   = $config->data;
    my @lines  = split /\n/, $data;
    my @new_lines;
    foreach my $line (@lines) {
        if ( $line =~ /^MTVersion/ ) {
            $line = 'MTVersion 5.2';
        }
        elsif ( $line =~ /^SchemaVersion/ ) {
            $line = 'SchemaVersion 5.0036';
        }
        push @new_lines, $line;
    }
    my $new_data = join "\n", @new_lines;
    $config->data($new_data);
    $config->save or die $config->errstr;

    $app = _run_app(
        'MT::App::Upgrader',
        {   __request_method => 'POST',
            __mode           => 'upgrade',
            username         => 'Melody',
            password         => 'Nelson',
        },
    );
    $out = delete $app->{__test_output};

    my $json_steps = $app->response;
    while ( @{ $json_steps->{steps} || [] } ) {

        require MT::Util;
        $json_steps = MT::Util::to_json( $json_steps->{steps} );

        require MT::App::Upgrader;
        $app = _run_app(
            'MT::App::Upgrader',
            {   __request_method => 'POST',
                username         => 'Melody',
                password         => 'Nelson',
                __mode           => 'run_actions',
                steps            => $json_steps,
            },
        );
        $out = delete $app->{__test_output};

        $out =~ s/^.*JSON://s;

        require JSON;
        $json_steps = JSON::from_json($out);

        ok( !$json_steps->{error}, 'Request has no error.' );

    }

    is( MT::Website->count(), 1, 'There is one website.' );
    is( MT::Blog->count(),    1, 'There is one blog.' );

    $admin = MT::Author->load(1);
    is( scalar @{ $admin->favorite_websites },
        1, "Administrator has one favorite_websites." );
    is( $admin->favorite_websites->[0],
        $website->id, "Favorite_websites ID is " . $website->id . "." );
    is( scalar @{ $admin->favorite_blogs },
        1, "Administrator has one favorite_blogs." );
    is( $admin->favorite_blogs->[0],
        $blog->id, "Favorite_blogs ID is " . $blog->id . "." );

    $iter = $admin->role_iter( { blog_id => $blog->id } );
    @roles = ();
    while ( my $r = $iter->() ) {
        push @roles, $r;
    }
    is( scalar @roles, 1, "Administrator has one role." );
    is( $roles[0]->name,
        MT->translate('Blog Administrator'),
        'Administrator has "Blog Administrator" role.'
    );

    $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_blog'),
        'Administrator has "administer_blog" permission.' );
    ok( !$perms->has('administer_website'),
        'Administrator does not have "administer_website" permission.' );
};

done_testing;
