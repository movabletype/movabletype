use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

MT->add_callback( 'MT::App::CMS::init_request', 10, undef,
    sub { delete $_[1]->{upgrade_required} },
);

sub setup_upgrade_test {
    my %args          = @_;
    my $require_admin = $args{require_admin} || 0;

    MT::Test->init_db;

    my $cfg = MT->config;
    $cfg->MTVersion(9.000001);
    $cfg->SchemaVersion(9.0000);
    $cfg->RequireUpgradePermission($require_admin);
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
}

subtest 'Superuser: redirected to upgrade' => sub {
    setup_upgrade_test( require_admin => 0 );
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => 'Melody', password => 'Nelson' } );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Superuser: redirected to upgrade' => sub {
    setup_upgrade_test( require_admin => 1 );
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => 'Melody', password => 'Nelson' } );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Non-superuser: redirected to upgrade when RequireUpgradePermission=0' => sub {
    my $test_name = 'restricted_user';
    my $test_pass = 'test1234';

    setup_upgrade_test( require_admin => 0 );
    my $author = MT::Test::Permission->make_author(
        name     => $test_name,
        password => $test_pass,
        nickname => 'Test User',
    );
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => $test_name, password => $test_pass } );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Non-superuser: upgrade pending when RequireUpgradePermission=1' => sub {
    my $test_name = 'restricted_user';
    my $test_pass = 'test1234';

    setup_upgrade_test( require_admin => 1 );
    my $author = MT::Test::Permission->make_author(
        name     => $test_name,
        password => $test_pass,
        nickname => 'Test User',
    );
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => $test_name, password => $test_pass } );
    $app->content_like( qr/Upgrade Pending/,
        "Non-superuser should see upgrade_pending page" );
};

subtest 'Not logged in: redirected to upgrade when RequireUpgradePermission=0' => sub {
    setup_upgrade_test( require_admin => 0 );
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->get_ok( {} );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Not logged in: redirected to upgrade when RequireUpgradePermission=1' => sub {
    setup_upgrade_test( require_admin => 1 );
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->get_ok( {} );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

done_testing;
