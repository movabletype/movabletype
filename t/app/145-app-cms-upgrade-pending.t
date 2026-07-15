use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

MT->add_callback( 'MT::App::CMS::init_request', 10, undef,
    sub { delete $_[1]->{upgrade_required} },
);

my $test_name = 'restricted_user';
my $test_pass = 'test1234';

sub setup_upgrade_test {
    my %args          = @_;
    my $require_admin = $args{require_admin} || 0;

    MT::Test->init_db;

    $test_env->update_config(
        MTVersion                => MT->version_number,
        SchemaVersion            => MT->schema_version - 0.0001,
        RequireUpgradePermission => $require_admin,
    );

    MT::Test::Permission->make_author(
        name     => $test_name,
        password => $test_pass,
        nickname => 'Test User',
    );

    my $plugin = $args{plugin} || '';
    if ($plugin eq 'blog') {
        $test_env->save_file('plugins/BlogPlugin/config.yaml', <<'YAML');
name: BlogPlugin
version: 1
schema_version: 1
object_types:
  website:
    new_column: integer
  blog:
    new_column: integer
YAML
    }
    if ($plugin eq 'author') {
        $test_env->save_file('plugins/AuthorPlugin/config.yaml', <<'YAML');
name: AuthorPlugin
version: 1
schema_version: 1
object_types:
  author:
    new_column: integer
YAML
    }
}

for my $plugin ('no plugin', 'blog', 'author') {

    subtest $plugin => sub {

subtest 'Superuser: redirected to upgrade' => sub {
    setup_upgrade_test(require_admin => 0, plugin => $plugin);
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => 'Melody', password => 'Nelson' } );
    note $app->last_location;
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Superuser: redirected to upgrade' => sub {
    setup_upgrade_test(require_admin => 1, plugin => $plugin);
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => 'Melody', password => 'Nelson' } );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Non-superuser: redirected to upgrade when RequireUpgradePermission=0' => sub {
    setup_upgrade_test(require_admin => 0, plugin => $plugin);
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => $test_name, password => $test_pass } );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Non-superuser: upgrade pending when RequireUpgradePermission=1' => sub {
    setup_upgrade_test(require_admin => 1, plugin => $plugin);
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->post_ok( { username => $test_name, password => $test_pass } );
    $app->content_like( qr/Upgrade Pending/,
        "Non-superuser should see upgrade_pending page" );
};

subtest 'Not logged in: redirected to upgrade when RequireUpgradePermission=0' => sub {
    setup_upgrade_test(require_admin => 0, plugin => $plugin);
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->get_ok( {} );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

subtest 'Not logged in: redirected to upgrade when RequireUpgradePermission=1' => sub {
    setup_upgrade_test(require_admin => 1, plugin => $plugin);
    my $app =
      MT::Test::App->new( app_class => 'MT::App::CMS', no_redirect => 1 );
    $app->get_ok( {} );
    like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
};

    };

}

done_testing;
