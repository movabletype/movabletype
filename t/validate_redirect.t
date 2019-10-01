#!/usr/bin/perl -w

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;

use MT::Test qw/:db :data/;
use MT::Test::App;

my $mt = MT->new() or die MT->errstr;
$mt->config( 'MailTransfer', 'debug' );

my $admin = MT::Author->load(1);
$admin->email('test@localhost.localdomain');
$admin->save;

subtest 'invalid start_recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->get(
        {   __mode    => 'start_recover',
            return_to => 'http://foo',
        },
    );
    $app->status_is(200);
    $app->content_like('Reset Password');
    $app->content_unlike('Invalid request');
    $app->content_doesnt_expose('http://foo');
};

subtest 'valid start_recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->get(
        {   __mode    => 'start_recover',
            return_to => 'http://narnia.na',
        },
    );
    $app->status_is(200);
    $app->content_like('Reset Password');
    $app->content_unlike('Invalid request');
    $app->content_like('http://narnia.na');
};

subtest 'invalid recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => 'http://foo',
        },
    );
    $app->status_is(200);
    $app->content_like('Invalid request');
    $app->content_unlike('Reset Password');
    $app->content_unlike('http://foo');
    $app->content_doesnt_expose('http://foo');
};

subtest 'valid recover' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => 'http://narnia.na',
        },
    );
    $app->status_is(200);
    $app->content_unlike('Invalid request');
    $app->content_like('Reset Password');
    $app->content_like('http://narnia.na');
};

subtest 'valid recover with userinfo' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => 'http://foo:bar@narnia.na',
        },
    );
    $app->status_is(200);
    $app->content_unlike('Invalid request');
    $app->content_like('Reset Password');
    $app->content_like('http://foo:bar@narnia.na');
};

subtest 'invalid recover with userinfo' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => 'http://foo:bar@foo',
        },
    );
    $app->status_is(200);
    $app->content_like('Invalid request');
    $app->content_unlike('Reset Password');
    $app->content_unlike('http://foo:bar@foo');
    $app->content_doesnt_expose('http://foo:bar@foo');
};

subtest 'relative' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => '/path',
        },
    );
    $app->status_is(200);
    $app->content_unlike('Invalid request');
    $app->content_like('/path');
    $app->content_like('Reset Password');
};

subtest 'valid recover without scheme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => '//narnia.na',
        },
    );
    $app->status_is(200);
    $app->content_unlike('Invalid request');
    $app->content_like('//narnia.na');
    $app->content_like('Reset Password');
};

subtest 'invalid recover without scheme' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => '//foo',
        },
    );
    $app->status_is(200);
    $app->content_like('Invalid request');
    $app->content_unlike('//foo');
    $app->content_doesnt_expose('//foo');
};

subtest 'weird uri that URI module happens to consider relative' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => ':@',
        },
    );
    $app->status_is(200);
    $app->content_like('Invalid request');
    $app->content_unlike(':@');
    $app->content_doesnt_expose(':@');
};

subtest 'weird uri that URI module happens to consider relative' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post(
        {   __mode    => 'recover',
            email     => $admin->email,
            return_to => '://narnia.na',
        },
    );
    $app->status_is(200);
    $app->content_like('Invalid request');
    $app->content_unlike('://narnia.na');
};

done_testing;
