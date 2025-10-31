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

my $request_count      = 0;
my $mock_response_code = 200;
my $mock_json;
my @mock_versions      = ({
        version         => '9.0.4',
        release_version => '',
        security_update => '',
        news_url        => 'https://www.sixapart.jp/movabletype/news/9.0.4'
    },
    {
        version         => '8.8.0',
        release_version => '',
        security_update => '',
        news_url        => 'https://www.sixapart.jp/movabletype/news/8.8.0'
    },
    {
        version         => '8.4.4',
        release_version => '',
        security_update => '8.4.3',
        news_url        => 'https://www.sixapart.jp/movabletype/news/8.4.4'
    },
    {
        version         => '8.0.7',
        release_version => '',
        security_update => '8.0.7',
        news_url        => 'https://www.sixapart.jp/movabletype/news/8.0.7',
    });

my $mock = Test::MockModule->new(ref(MT->new_ua));
$mock->redefine(
    "request",
    sub {
        my ($ua, $req) = @_;
        unless ($req->method =~ /get/i && $req->uri eq const('LATEST_VERSION_URL')) {
            return $mock->original("request")->(@_);
        }

        return HTTP::Response->new($mock_response_code, 'not found', [], '') if $mock_response_code == 404;

        $request_count++;
        return HTTP::Response->new(200, 'success', [], $mock_json || MT::Util::to_json(\@mock_versions));
    });

subtest 'unit test for updates_widget method' => sub {
    my $mt = MT->instance;
    my $tmpl;
    my $param;

    subtest 'minor version without security' => sub {
        $MT::VERSION_ID = '8.4.4';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,                           2, 'right number of versions';
            is $versions->[0]->{version},            '9.0.4';
            is $versions->[0]->{news_url},           'https://www.sixapart.jp/movabletype/news/9.0.4';
            is $versions->[0]->{is_security_update}, undef;
            is $versions->[1]->{version},            '8.8.0';
            is $versions->[1]->{news_url},           'https://www.sixapart.jp/movabletype/news/8.8.0';
            is $versions->[1]->{is_security_update}, undef;
            is $request_count,                       1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'patch version without security' => sub {
        $MT::VERSION_ID = '8.4.3';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,                           3, 'right number of versions';
            is $versions->[0]->{version},            '9.0.4';
            is $versions->[0]->{is_security_update}, undef;
            is $versions->[1]->{version},            '8.8.0';
            is $versions->[1]->{is_security_update}, undef;
            is $versions->[2]->{version},            '8.4.4';
            is $versions->[2]->{is_security_update}, undef;
            is $request_count,                       1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'patch version with security' => sub {
        $MT::VERSION_ID = '8.4.2';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,                           3, 'right number of versions';
            is $versions->[0]->{version},            '9.0.4';
            is $versions->[0]->{is_security_update}, undef;
            is $versions->[1]->{version},            '8.8.0';
            is $versions->[1]->{is_security_update}, undef;
            is $versions->[2]->{version},            '8.4.4';
            is $versions->[2]->{is_security_update}, 1;
            is $request_count,                       1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'patch version with security' => sub {
        $MT::VERSION_ID = '8.0.6';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,                           3, 'right number of versions';
            is $versions->[0]->{version},            '9.0.4';
            is $versions->[0]->{is_security_update}, undef;
            is $versions->[1]->{version},            '8.8.0';
            is $versions->[1]->{is_security_update}, undef;
            is $versions->[2]->{version},            '8.0.7';
            is $versions->[2]->{is_security_update}, 1;
            is $request_count,                       1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'patch version with security' => sub {
        $MT::VERSION_ID = '8.0.7';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,                           2, 'right number of versions';
            is $versions->[0]->{version},            '9.0.4';
            is $versions->[0]->{is_security_update}, undef;
            is $versions->[1]->{version},            '8.8.0';
            is $versions->[1]->{is_security_update}, undef;
            is $request_count,                       1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'major version only' => sub {
        $MT::VERSION_ID = '8.8.0';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,                           1, 'right number of versions';
            is $versions->[0]->{version},            '9.0.4';
            is $versions->[0]->{is_security_update}, undef;
            is $request_count,                       1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'no updates available' => sub {
        $MT::VERSION_ID = '9.0.4';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,     0, 'right number of versions';
            is $request_count, 1, 'up to 1 because of cache';
        }
    };

    teardown();

    subtest 'make sure the json order doesnt matter' => sub {
        unshift @mock_versions, {
            version         => '8.7.0',
            release_version => '',
            security_update => '',
            news_url        => 'https://www.sixapart.jp/movabletype/news/8.8.0'
        };

        $MT::VERSION_ID = '8.4.4';
        for (1, 2) {
            $param = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,                2, 'right number of versions';
            is $versions->[0]->{version}, '9.0.4';
            is $versions->[1]->{version}, '8.8.0';
            is $request_count,            1, 'up to 1 because of cache';
        }

        shift @mock_versions;
        teardown();
    };

    subtest 'wrong formatted json' => sub {
        unshift @mock_versions, {
            version         => 'WRONG_FORMAT',
            release_version => '',
            security_update => '',
            news_url        => ''
        };

        $MT::VERSION_ID = '8.4.4';
        $param          = {};
        MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
        my $versions = $param->{available_versions};
        is @$versions,                    0, 'right number of versions';
        is $param->{update_check_failed}, 1, 'right message';

        shift @mock_versions;
        teardown();
    };

    subtest 'wrong formatted json2' => sub {
        $mock_json = 'broken}';
        $MT::VERSION_ID = '8.4.4';
        $param          = {};
        MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
        my $versions = $param->{available_versions};
        is @$versions,                    0, 'right number of versions';
        is $param->{update_check_failed}, 1, 'right message';

        teardown();
    };

    subtest 'empty result is cached' => sub {
        $mock_json = '[]';
        $MT::VERSION_ID = '8.4.4';
        for (1, 2) {
            $param          = {};
            MT::CMS::Dashboard::updates_widget($mt, $tmpl, $param);
            my $versions = $param->{available_versions};
            is @$versions,                    0, 'right number of versions';
            is $param->{update_check_failed}, undef, 'right message';
            is $request_count,            1, 'up to 1 because of cache';
        }

        teardown();
    };
};

subtest 'test actual output' => sub {

    my $admin = MT::Author->load(1);
    my $app   = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    subtest 'minor version without security' => sub {
        $MT::VERSION_ID = '8.4.4';
        $app->get_ok({ __mode => 'dashboard', blog_id => 0 });
        my @versions;
        $app->wq_find('#updates ul li')->each(sub { push @versions, $_->text });
        is @versions, 2, 'right number of versions';
        like $versions[0], qr/9.0.4/, 'right version';
        like $versions[1], qr/8.8.0/, 'right version';
    };

    teardown();

    subtest 'up to date' => sub {
        $MT::VERSION_ID = '9.0.4';
        $app->get_ok({ __mode => 'dashboard', blog_id => 0 });
        my @versions;
        $app->wq_find('#updates ul li')->each(sub { push @versions, $_->text });
        is @versions, 0, 'right number of versions';
        my $message = $app->wq_find('#updates p')->text;
        like $message, qr/Movable Type is up to date\./, 'right message';
    };

    teardown();

    subtest 'failed' => sub {
        $MT::VERSION_ID     = '9.0.4';
        $mock_response_code = 404;
        $app->get_ok({ __mode => 'dashboard', blog_id => 0 });
        my @versions;
        $app->wq_find('#updates ul li')->each(sub { push @versions, $_->text });
        is @versions, 0, 'right number of versions';
        my $message = $app->wq_find('#updates p')->text;
        like $message, qr/Update check failed\. Please check server network settings\./, 'right message';
    };

    teardown();
};

sub teardown {
    my $cache = MT->model('session')->load({
        id   => 'Update Check',
        kind => 'DW',
    });
    $cache->remove if $cache;
    $request_count      = 0;
    $mock_response_code = 200;
    $mock_json          = undef;
}

done_testing;
