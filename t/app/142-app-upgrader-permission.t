#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    plan skip_all => "Not for external CGI server"
      if $ENV{MT_TEST_RUN_APP_AS_CGI};

    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',
        PluginPath      => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file( 'plugins/UpgradeOnlyPerm/config.yaml', <<'YAML' );
id: UpgradeOnlyPerm
name: Upgrade Only Permission Plugin
permissions:
    system.upgrade_only:
        group: sys_admin
        label: Upgrade Only
        order: 1500
        permitted_action:
            upgrade_system: 1
YAML

}

use MT::Test qw(:newdb);
use MT::Test::Permission;
use MT::Test::Upgrade;
use MT::Test::App;
use MT::Theme;

$test_env->fix_mysql_create_table_sql;

use constant TEST_USERNAME => 'restricted_user';
use constant TEST_PASSWORD => 'test1234';

sub setup_upgrade_test {
    my %args             = @_;
    my $strict_mode      = $args{strict_mode}      || 0;
    my $grant_permission = $args{grant_permission} || 0;

    MT::Test->init_db;

    my $cfg = MT->config;
    $cfg->MTVersion(9.000001);
    $cfg->SchemaVersion(9.0000);
    $cfg->RequireStrictUpgradePermission($strict_mode);
    $cfg->save_config;

    my $config = MT::Config->load;
    my $data   = $config->data;
    my @lines  = split /\n/, $data;
    my @new_lines;
    foreach my $line (@lines) {
        if ( $line =~ /^MTVersion/ ) {
            $line = 'MTVersion 9.000001';
        }
        elsif ( $line =~ /^SchemaVersion/ ) {
            $line = 'SchemaVersion 9.0000';
        }
        push @new_lines, $line;
    }
    my $new_data = join "\n", @new_lines;
    $config->data($new_data);
    $config->save or die $config->errstr;

    my $author = MT::Test::Permission->make_author(
        name     => TEST_USERNAME,
        password => TEST_PASSWORD,
        nickname => 'Restricted User',
    );

    if ($grant_permission) {
        my $perm =
          MT::Permission->load( { author_id => $author->id, blog_id => 0 } );
        $perm->permissions("'upgrade_only'");
        $perm->save or die $perm->errstr;
    }

    return $author;
}

subtest 'Upgrade permission check' => sub {
    subtest 'Admin always allowed' => sub {
        setup_upgrade_test( strict_mode => 1 );
        my $app = MT::Test::App->new('MT::App::Upgrader');
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => 'Melody',
                password => 'Nelson',
            }
        );
        ok( $res->decoded_content !~ /No permissions\./,
            "Admin user allowed to upgrade" );
    };

    subtest 'No strict mode: denied without permission' => sub {
        my $author =
          setup_upgrade_test( strict_mode => 0, grant_permission => 0 );

        ok( !$author->is_superuser, "author is not superuser" );
        ok( !$author->can_do('upgrade_system'),
            "author does not have upgrade_system permission" );

        my $app = MT::Test::App->new('MT::App::Upgrader');
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => TEST_USERNAME,
                password => TEST_PASSWORD,
            }
        );
        ok( $res->decoded_content =~ /No permissions\./, "Should deny access" );
    };

    subtest 'No strict mode: denied with permission' => sub {
        my $author =
          setup_upgrade_test( strict_mode => 0, grant_permission => 1 );

        ok( !$author->is_superuser, "author is not superuser" );
        ok(
            $author->can_do('upgrade_system'),
            "author has upgrade_system permission"
        );

        my $app = MT::Test::App->new('MT::App::Upgrader');
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => TEST_USERNAME,
                password => TEST_PASSWORD,
            }
        );
        ok( $res->decoded_content =~ /No permissions\./, "Should deny access" );
    };

    subtest 'Strict mode: denied without permission' => sub {
        my $author =
          setup_upgrade_test( strict_mode => 1, grant_permission => 0 );

        ok( !$author->is_superuser, "author is not superuser" );
        ok( !$author->can_do('upgrade_system'),
            "author does not have upgrade_system permission" );

        my $app = MT::Test::App->new('MT::App::Upgrader');
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => TEST_USERNAME,
                password => TEST_PASSWORD,
            }
        );
        ok( $res->decoded_content =~ /No permissions\./, "Should deny access" );
    };

    subtest 'Strict mode: allowed with permission' => sub {
        my $author =
          setup_upgrade_test( strict_mode => 1, grant_permission => 1 );

        ok( !$author->is_superuser, "author is not superuser" );
        ok(
            $author->can_do('upgrade_system'),
            "author has upgrade_system permission"
        );

        my $app = MT::Test::App->new('MT::App::Upgrader');
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => TEST_USERNAME,
                password => TEST_PASSWORD,
            }
        );
        ok( $res->decoded_content !~ /No permissions\./,
            "Should allow access" );
    };
};

done_testing;
