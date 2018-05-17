#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :app :newdb );
use MT::Test::Permission;
use MT::Test::Upgrade;
use MT::Theme;

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
