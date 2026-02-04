use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
        DebugMode => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file( 'plugins/ValidatorTest/config.yaml', <<'YAML' );
name: ValidatorTest
key:  ValidatorTest
id:   ValidatorTest

param_validator:
    EXTRA: |
        sub {
            my ($app, $name, $value, @params) = @_;
            return if $value eq 'extra';
            return 'Only "extra" passes';
        }
YAML

}

use MT::Test;
use MT::App::CMS;
use CGI;

sub setup_app {
    my %param = @_;
    my $app = MT::App::CMS->new;
    my $cgi = CGI->new;
    for my $name (keys %param) {
        my $value = $param{$name};
        $cgi->param($name => ref $value eq 'ARRAY' ? @$value : $value);
    }
    delete $app->{init_request};
    $app->init_request(CGIObject => $cgi);
    $app->error('');
    return $app;
}

subtest 'test id' => sub {
    my $app = setup_app(foo_id => 1);
    ok $app->validate_param({
        foo_id => [qw/ID/],
    }), "no error";
    $app->param(foo_id => '1.boo');
    ok !$app->validate_param({
        foo_id => [qw/ID/],
    }), "error";
    note $app->errstr;
};

subtest 'test ids' => sub {
    my $app = setup_app(foo_id => 1, bar_id => '1,2');
    ok $app->validate_param({
        foo_id => [qw/IDS/],
        bar_id => [qw/IDS/],
    }), "no error";
    $app->param(bar_id => '1,2,boo');
    ok !$app->validate_param({
        foo_id => [qw/IDS/],
        bar_id => [qw/IDS/],
    }), "error";
    note $app->errstr;
};

subtest 'test multi ids' => sub {
    my $app = setup_app(foo_id => 1, bar_id => ['1,2', '3,4']);
    ok $app->validate_param({
        foo_id => [qw/IDS MULTI/],
        bar_id => [qw/IDS MULTI/],
    }), "no error";
    $app->param(bar_id => '1,2', '3,4,boo');
    ok !$app->validate_param({
        foo_id => [qw/IDS MULTI/],
        bar_id => [qw/IDS MULTI/],
    }), "error";
    note $app->errstr;
};

subtest 'test extra' => sub {
    my $app = setup_app(foo => 'extra');
    ok $app->validate_param({
        foo => [qw/EXTRA/],
    }), "no error";
    $app->param(foo => 'not extra');
    ok !$app->validate_param({
        foo => [qw/EXTRA/],
    }), "error";
    note $app->errstr;
};

subtest 'test maybe' => sub {
    my $app = setup_app(foo_id => 1);
    ok $app->validate_param({
        foo_id => [qw/MAYBE_ID/],
    }), "no error";
    $app->param(foo_id => '1.boo');
    ok $app->validate_param({
        foo_id => [qw/MAYBE_ID/],
    }), "no error";
    note $app->errstr;
};

subtest 'test disable' => sub {
    my $app = setup_app(foo_id => 1);
    $app->config->DisableValidateParam(1);
    ok $app->validate_param({
        foo_id => [qw/ID/],
    }), "no error";
    $app->param(foo_id => '1.boo');
    ok $app->validate_param({
        foo_id => [qw/ID/],
    }), "no error (disabled)";
    note $app->errstr;
};
done_testing;
