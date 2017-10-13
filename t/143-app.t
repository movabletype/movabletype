#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw( lib extlib ../lib ../extlib t/lib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

subtest 'Check transencoding in validate_request_params().' => sub {
    my $flag = 0;

    my $module = Test::MockModule->new('MT::I18N::default');
    $module->mock( 'encode_text_encode',
        sub { $flag++; $module->original('encode_text_encode')->(@_) },
    );

    local $ENV{CONTENT_TYPE} = 'text/plain; charset=UTF-8';
    my $app = MT->app;
    $app->param( 'dummy', 'ダミーパラメータ' );
    $app->validate_request_params;

    is( $flag, 0,
        'MT::I18N::default::encode_text_encode() is not executed when charset is UTF-8.'
    );
};

subtest 'If Content-Type has multi paramters' => sub {
    local $ENV{CONTENT_TYPE}
        = 'multipart/form-data; charset=utf-8; boundary=0xKhTmLbOuNdArY-CAF30B04-D79D-4CD9-9B7D-57302B6F9649';
    my $app = MT->app;
    $app->param( 'dummy', 'ダミーパラメータ' );
    eval { $app->validate_request_params };

    is( scalar(@_), 0, 'No error occurs in validate_request_params().' );
};

done_testing;
