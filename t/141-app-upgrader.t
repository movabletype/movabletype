#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib 'lib', 'extlib', 't/lib', '../lib', '../extlib';
use MT::Test qw( :app :newdb );
use MT::Test::Permission;
use MT::Test::Upgrade;
use MT::Theme;
use Test::More;

my ( $app, $out );

subtest 'Upgrade from MT4 to MT7' => sub {
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

    my $site_admin
        = MT::Role->load( { name => MT->translate('Site Administrator') } );
    my $blog = MT::Blog->load( $blog_ids[0] );
    $admin->add_role( $site_admin, $blog );

    my @roles;
    my $iter = $admin->role_iter( { blog_id => $blog->id } );
    while ( my $r = $iter->() ) {
        push @roles, $r;
    }
    is( scalar @roles, 1, 'Administrator has one role.' );
    is( $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );
    my $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_site'),
        'Administrator has "administer_site" permission.' );

    MT::Test::Upgrade->upgrade( from => 4.0077 );

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
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );

    $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_site'),
        'Administrator has "administer_site" permission.' );

};

subtest 'Upgrade from MT5 to MT7' => sub {
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

    my $site_admin
        = MT::Role->load( { name => MT->translate('Site Administrator') } );
    $admin->add_role( $site_admin, $blog );

    my @roles;
    my $iter = $admin->role_iter( { blog_id => $blog->id } );
    while ( my $r = $iter->() ) {
        push @roles, $r;
    }
    is( scalar @roles, 1, 'Administrator has one role.' );
    is( $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );
    my $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_site'),
        'Administrator has "administer_site" permission.' );

    MT::Test::Upgrade->upgrade( from => 5.0036 );

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
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );

    $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_site'),
        'Administrator has "administer_site" permission.' );

    my @migrate_roles = (
        'Designer (MT6)',
        'Author (MT6)',
        'Contributor (MT6)',
        'Editor (MT6)'
    );
    foreach my $role_name (@migrate_roles) {
        my $role_count
            = MT::Role->count( { name => MT->translate($role_name) } );
        is( $role_count, 1, $role_name . ' has one role.' );
    }

};

subtest 'Upgrade from MT6 to MT7' => sub {
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

    my $site_admin
        = MT::Role->load( { name => MT->translate('Site Administrator') } );
    $admin->add_role( $site_admin, $blog );

    my @roles;
    my $iter = $admin->role_iter( { blog_id => $blog->id } );
    while ( my $r = $iter->() ) {
        push @roles, $r;
    }
    is( scalar @roles, 1, 'Administrator has one role.' );
    is( $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );
    my $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_site'),
        'Administrator has "administer_site" permission.' );

    MT::Test::Upgrade->upgrade( from => 6.0010 );

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
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );

    $perms = $admin->permissions( $blog->id );
    ok( $perms->has('administer_site'),
        'Administrator has "administer_site" permission.' );

    my @migrate_roles = (
        'Designer (MT6)',
        'Author (MT6)',
        'Contributor (MT6)',
        'Editor (MT6)'
    );
    foreach my $role_name (@migrate_roles) {
        my $role_count
            = MT::Role->count( { name => MT->translate($role_name) } );
        is( $role_count, 1, $role_name . ' has one role.' );
    }

};

done_testing;
