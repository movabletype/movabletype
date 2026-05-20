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

use MT::Test::App;
use MT::Util::UniqueID;
use CGI::Cookie;

my $app = MT::Test::App->new;
$app->{no_redirect} = 1;

MT->add_callback(
    'MT::App::CMS::init_request',
    10, undef,
    sub {
        my $cookie_name  = 'mt_user';
        my $cookie_value = join '::', 'Melody', MT::Util::UniqueID::create_session_id();
        $_[1]->{cookies}          = { $cookie_name => CGI::Cookie->new(-name => $cookie_name, -value => $cookie_value) };
        $_[1]->{upgrade_required} = 1;
    });

my $res = eval { $app->get_ok };
ok $res && $res->code == 302,                                                    'redirected';
ok $res && $res->header('Location') eq '/cgi-bin/mt-upgrade.cgi?__mode=install', 'correct location';

done_testing;
