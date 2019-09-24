#!/usr/bin/perl -w

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

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $admin = MT::Author->load(1);
$admin->email('test@localhost.localdomain');
$admin->save;

sub _contains {
    my ( $html, $str ) = @_;
    ok $html =~ /\Q$str\E/, "contains $str";
}

sub _doesnt_contain {
    my ( $html, $str ) = @_;
    ok $html !~ /\Q$str\E/, "doesn't contain $str";
}

sub _bad_url_isnt_exposed {
    my ( $html, $url ) = @_;
    ok $html !~ qr/(<(a|form|meta)\s[^>]+\Q$url\E[^>]+>)/s
        or note "$url is exposed as $1";
}

subtest 'invalid start_recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'start_recover',
            return_to => 'http://foo',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Reset Password' );
    _doesnt_contain( $html, 'Invalid request' );
    _bad_url_isnt_exposed( $html, 'http://foo' );
};

subtest 'valid start_recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'start_recover',
            return_to => 'http://narnia.na',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Reset Password' );
    _doesnt_contain( $html, 'Invalid request' );
    _contains( $html, 'http://narnia.na' );
};

subtest 'invalid recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => 'http://foo',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Invalid request' );
    _doesnt_contain( $html, 'Reset Password' );
    _doesnt_contain( $html, 'http://foo' );
    _bad_url_isnt_exposed( $html, 'http://foo' );
};

subtest 'valid recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => 'http://narnia.na',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'Invalid request' );
    _contains( $html, 'Reset Password' );
    _contains( $html, 'http://narnia.na' );
};

subtest 'valid recover with userinfo' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => 'http://foo:bar@narnia.na',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'Invalid request' );
    _contains( $html, 'Reset Password' );
    _contains( $html ,'http://foo:bar@narnia.na' );
};

subtest 'invalid recover with userinfo' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => 'http://foo:bar@foo',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Invalid request' );
    _doesnt_contain( $html, 'Reset Password' );
    _doesnt_contain( $html, 'http://foo:bar@foo' );
    _bad_url_isnt_exposed( $html, 'http://foo:bar@foo' );
};

subtest 'relative' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => '/path',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'Invalid request' );
    _contains( $html, '/path' );
    _contains( $html, 'Reset Password' );
};

subtest 'valid recover without scheme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => '//narnia.na',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'Invalid request' );
    _contains( $html, '//narnia.na' );
    _contains( $html, 'Reset Password' );
};

subtest 'invalid recover without scheme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => '//foo',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Invalid request' );
    _doesnt_contain( $html, '//foo' );
    _bad_url_isnt_exposed( $html, '//foo' );
};

subtest 'weird uri that URI module happens to consider relative' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => ':@',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Invalid request' );
    _doesnt_contain( $html, ':@' );
    _bad_url_isnt_exposed( $html, ':@' );
};

subtest 'weird uri that URI module happens to consider relative' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    my $res = $app->get(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => '://narnia.na',
        },
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Invalid request' );
    _doesnt_contain( $html, '://narnia.na' );
};

done_testing;
