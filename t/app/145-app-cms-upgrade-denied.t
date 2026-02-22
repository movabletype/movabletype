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
    MT::Test->init_db;

    my $cfg = MT->config;
    $cfg->MTVersion(9.000001);
    $cfg->SchemaVersion(9.0000);
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

use constant TEST_USERNAME => 'restricted_user';
use constant TEST_PASSWORD => 'test1234';

subtest 'Superuser: redirected to upgrade' => sub {
    setup_upgrade_test();
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => 'Melody', password => 'Nelson' } );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Non-superuser: upgrade denied' => sub {
    setup_upgrade_test();
    my $author = MT::Test::Permission->make_author(
        name     => TEST_USERNAME,
        password => TEST_PASSWORD,
        nickname => 'Test User',
    );
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => TEST_USERNAME, password => TEST_PASSWORD } );
    $app->content_like(
qr/Please contact your Movable Type administrator for assistance with upgrading Movable Type\./
    );
};

subtest 'Not logged in: redirected to upgrade' => sub {
    setup_upgrade_test();
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->get_ok( {} );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

done_testing;
