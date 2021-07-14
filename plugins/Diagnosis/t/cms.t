#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use Web::Query::LibXML;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
my $admin2 = MT::Author->new(id => 2, name => 'foo', 'password' => 'foo')->save;

subtest 'search_replace' => sub {
    for my $blog_id (0, 1) {
        subtest 'blog_id=' . $blog_id => sub {
            my $app = _run_app(
                'MT::App::CMS', {
                    __test_user      => $admin,
                    __request_method => 'GET',
                    blog_id          => $blog_id,
                    __mode           => 'search_replace',
                });
            my $wq = Web::Query::LibXML->new( delete $app->{__test_output} );
            my $html = $wq->find('.mt-mainContent')->as_html();
            unlike($html, qr/repair_?task/i, 'tab is not displayed');
            unlike($html, qr/Diagnosis/i, 'no Diagnosis');
            done_testing();
        };
    }
    done_testing();
};

subtest 'menu in website scope' => sub {
    my $app = _run_app(
        'MT::App::CMS', {
            __test_user => $admin,
            __mode      => 'dashboard',
            blog_id     => 1,
        });
    my $wq = Web::Query::LibXML->new( delete $app->{__test_output} );
    my $html = $wq->find('.mt-primaryNavigation')->as_html();
    unlike($html, qr/Diagnosis/i, 'no Diagnosis');
    done_testing();
};

subtest 'listing screen' => sub {

    my $app = _run_app(
        'MT::App::CMS', {
            __test_user => $admin,
            __mode      => 'list',
            _type       => 'repair_task',
            blog_id     => 0,
        });
    my $wq = Web::Query::LibXML->new( delete $app->{__test_output} );
    my $html = $wq->find('.mt-mainContent')->as_html();
    like($html, qr/Diagnosis/, '');
    my $html2 = $wq->find('ul#primaryNavigation')->as_html();
    like($html2, qr/Diagnosis/i, 'Diagnosis exists');
    done_testing();
};

subtest 'listing screen by non super user' => sub {

    subtest 'listing' => sub {
        my $app = _run_app(
            'MT::App::CMS', {
                __test_user => $admin2,
                __mode      => 'list',
                _type       => 'repair_task',
                blog_id     => 0,
            });
        my $wq = Web::Query::LibXML->new( delete $app->{__test_output} );
        my $html = $wq->find('.mt-mainContent')->as_html();
        unlike($html, qr/Diagnosis/, 'Not permitted');
        done_testing();
    };
    subtest 'menu' => sub {
        my $app = _run_app(
            'MT::App::CMS', {
                __test_user => $admin2,
                _type       => 'dashboard',
                blog_id     => 0,
            });
        my $wq = Web::Query::LibXML->new( delete $app->{__test_output} );
        my $html2 = $wq->find('ul#primaryNavigation')->as_html();
        unlike($html2, qr/Diagnosis/i, 'No Diagnosis');
        done_testing();
    };
    done_testing();
};

done_testing();
