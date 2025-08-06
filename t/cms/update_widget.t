#!/usr/bin/perl

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

use MT;
use MT::Object;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;
use MT::CMS::Dashboard;
use MT::I18N qw( const );
use Test::MockModule;

$test_env->prepare_fixture('db');

my $request_count = 0;

my $mock = Test::MockModule->new(ref(MT->new_ua));
$mock->redefine(
    "request",
    sub {
        my ($ua, $req) = @_;
        unless ($req->method =~ /get/i && $req->uri eq const('LATEST_VERSION_URL')) {
            return $mock->original("request")->(@_);
        }

        $request_count++;
        return HTTP::Response->new(200, 'success', [], <<'EOF' );
{
"version": "8.7.0",
"release_version": "",
"news_url": "https://www.sixapart.jp/movabletype/news/8.7.0"
}
EOF
    });

subtest 'unit test for updates_widget method' => sub {
    my $mt = MT->instance;
    my $tmpl;
    my $param;

    subtest 'an update available' => sub {
        $MT::VERSION_ID = '8.6.0';

        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            is $param->{available_version}, '8.7.0';
            is $param->{news_url},          'https://www.sixapart.jp/movabletype/news/8.7.0';
            is $request_count,              1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'no updates available' => sub {
        $MT::VERSION_ID = '8.8.0';

        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            is $param->{available_version}, undef;
            is $param->{news_url},          undef;
            is $request_count,              1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'edge case' => sub {
        $MT::VERSION_ID = '8.7.0';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            is $param->{available_version}, undef;
            is $param->{news_url},          undef;
            is $request_count,              1, 'up to 1 because of cache';
        }
    };
};

sub teardown {
    my $cache = MT->model('session')->load({
        id   => 'Update Check',
        kind => 'DW',
    });
    $cache->remove if $cache;
    $request_count = 0;
}

done_testing;
