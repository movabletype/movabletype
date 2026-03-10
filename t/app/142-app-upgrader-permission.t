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
}

use MT::Test qw(:newdb);
use MT::Test::Permission;
use MT::Test::Upgrade;
use MT::Test::App;
use MT::Theme;

$test_env->fix_mysql_create_table_sql;

sub setup_upgrade_test {
    my %args          = @_;
    my $require_admin = $args{require_admin} || 0;

    MT::Test->init_db;

    my $cfg = MT->config;
    my $version = MT->version_number;
    my $schema  = MT->schema_version - 0.0001;
    $cfg->MTVersion($version);
    $cfg->SchemaVersion($schema);
    $cfg->RequireUpgradePermission($require_admin);
    $cfg->save_config;

    my $config = MT::Config->load;
    my $data   = $config->data;
    my @lines  = split /\n/, $data;
    my @new_lines;
    foreach my $line (@lines) {
        if ( $line =~ /^MTVersion/ ) {
            $line = "MTVersion $version";
        }
        elsif ( $line =~ /^SchemaVersion/ ) {
            $line = "SchemaVersion $schema";
        }
        push @new_lines, $line;
    }
    my $new_data = join "\n", @new_lines;
    $config->data($new_data);
    $config->save or die $config->errstr;
}

subtest 'Upgrade permission check' => sub {
    my $test_user_name = 'restricted_user';
    my $test_password  = 'test1234';

    subtest 'Superuser: allowed when RequireUpgradePermission=1' => sub {
        setup_upgrade_test( require_admin => 1 );
        my $app = MT::Test::App->new(
            app_class   => 'MT::App::Upgrader',
            no_redirect => 1
        );
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => 'Melody',
                password => 'Nelson',
            }
        );
        like $res->decoded_content => qr/Upgrading database/,
          "Superuser should see upgrade runner";
    };

    subtest 'Superuser: allowed when RequireUpgradePermission=0' => sub {
        setup_upgrade_test( require_admin => 0 );
        my $app = MT::Test::App->new(
            app_class   => 'MT::App::Upgrader',
            no_redirect => 1
        );
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => 'Melody',
                password => 'Nelson',
            }
        );
        like $res->decoded_content => qr/Upgrading database/,
          "Superuser should see upgrade runner";
    };

    subtest 'Non-superuser: allowed when RequireUpgradePermission=0' => sub {
        setup_upgrade_test( require_admin => 0 );
        my $author = MT::Test::Permission->make_author(
            name     => $test_user_name,
            password => $test_password,
            nickname => 'Test User',
        );
        ok( !$author->is_superuser, "author is not superuser" );

        my $app = MT::Test::App->new(
            app_class   => 'MT::App::Upgrader',
            no_redirect => 1
        );
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => $test_user_name,
                password => $test_password,
            }
        );
        like $res->decoded_content => qr/Upgrading database/,
          "Non-superuser should see upgrade runner";
    };

    subtest 'Non-superuser: denied when RequireUpgradePermission=1' => sub {
        setup_upgrade_test( require_admin => 1 );
        my $author = MT::Test::Permission->make_author(
            name     => $test_user_name,
            password => $test_password,
            nickname => 'Test User',
        );
        ok( !$author->is_superuser, "author is not superuser" );

        my $app = MT::Test::App->new(
            app_class   => 'MT::App::Upgrader',
            no_redirect => 1
        );
        my $res = $app->post(
            {
                __mode   => 'upgrade',
                username => $test_user_name,
                password => $test_password,
            }
        );
        like $app->last_location => qr/__mode=upgrade_pending/,
          "Non-superuser should be redirected to upgrade_pending";
    };
};

done_testing;
