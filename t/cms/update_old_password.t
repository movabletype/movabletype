use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;
use MT::Util;
use MT::Util::Log;
use utf8;
use Encode;

$test_env->prepare_fixture('db');

my $author = MT::Author->load(1);

my $raw_pass = 'test';

subtest 'crypt password' => sub {
    my $prev_pass = crypt($raw_pass, 'cr');
    $author->column(password => $prev_pass);
    $author->save;

    _test_password($raw_pass, $prev_pass);
};

subtest 'sha1 password' => sub {
    my $prev_pass = '{SHA}s1$' . MT::Util::perl_sha1_digest_hex('s1' . $raw_pass);
    $author->column(password => $prev_pass);
    $author->save;

    _test_password($raw_pass, $prev_pass);
};

sub _test_password {
    my ($pass, $prev_pass) = @_;
    note "PREV_PASS: $prev_pass";

    my $log_class = MT->model('log');

    for my $ct (0, 1) {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->get_ok({});
        like $app->header_title => qr/Sign in/, "sign in";
        $log_class->remove;
        $app->post_form_ok({
            username => $author->name,
            password => encode_utf8($pass),
        });
        my $logfile = MT::Util::Log->_get_logfile_path;
        ok -f $logfile, "logfile ($logfile) exists";
        my $log = $test_env->slurp_logfile;
        like $log               => qr/logged in successfully/, "logged in successfully ($ct)";
        like $app->header_title => qr/Dashboard/,              "dashboard ($ct)";

        my @objs = MT::Log->load({class => '*'});
        ok grep({$_->message => qr/logged in successfully/} @objs), "has a log object";

        $test_env->remove_logfile;
        $test_env->clear_mt_cache;
        $author = MT::Author->load(1);
        my $current_pass = $author->column('password');
        if (!$ct) {
            isnt $current_pass => $prev_pass, "password has changed";
            $prev_pass = $current_pass;
        } else {
            is $current_pass => $prev_pass, "password is not changed";
        }
        note "CURRENT_PASS: $current_pass";
    }
}

done_testing;
