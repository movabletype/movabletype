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

use MT::Test::Fixture::ContentData;
use MT::Test::DataAPI;
use JSON;

$test_env->prepare_fixture('content_data/dirty');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $objs    = MT::Test::Fixture::ContentData->load_objs;
my $author  = $app->model('author')->load(1);
my $blog_id = $objs->{blog_id};
my $blog    = $objs->{blog}{'My Site'};
my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;

# test.
my $suite = suite();
test_data_api($suite);

# end
done_testing;

sub suite {
    my @tests = (

        # search - normal tests

        {   path   => '/v4/search',
            method => 'GET',
            params => {
                search             => 'text',
                SearchContentTypes => $ct_id,
                cdSearch           => 1,
                IncludeBlogs       => $blog_id,
                limit              => 20,
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = decode_json($body);
                is @{$result->{items}} => 2;
                note explain $result;
            }
        },
        {   path   => '/v4/search',
            method => 'GET',
            params => {
                search             => 'text',
                SearchContentTypes => $ct_id,
                cdSearch           => 1,
                content_field      => 'single_line_text',
                IncludeBlogs       => $blog_id,
                limit              => 20,
            },
            complete => sub {
                my ( $data, $body ) = @_;
                my $result = decode_json($body);
                is @{$result->{items}} => 2;
                note explain $result;
            }
        },
    );

    my @ok_tests = grep {!$_->{code}} @tests;

    # Respect DataAPIDisableSite
    my @extra_tests;
    for my $ok_test (@ok_tests) {
        my %new_test = %$ok_test;
        delete $new_test{complete};
        $new_test{code} = 403;
        push @extra_tests, \%new_test;
    }
    $extra_tests[0]{setup} = sub {
        $app->config->DataAPIDisableSite($blog->id);
        $app->config->save_config;
        $blog->allow_data_api(0);
        $blog->save;
    };
    push @tests, @extra_tests;

    # Respect DataAPIDisableSite (but a superuser ignores it)
    my @extra_tests_for_superuser;
    for my $ok_test (@ok_tests) {
        my %new_test = %$ok_test;
        $new_test{is_superuser} = 1;
        push @extra_tests_for_superuser, \%new_test;
    }
    push @tests, @extra_tests_for_superuser;

    # Make Superuser Respect DataAPIDisableSite
    my @extra_tests_for_respecting_superuser;
    for my $ok_test (@ok_tests) {
        my %new_test = %$ok_test;
        delete $new_test{complete};
        $new_test{code} = 403;
        $new_test{is_superuser} = 1;
        push @extra_tests_for_respecting_superuser, \%new_test;
    }
    $extra_tests_for_respecting_superuser[0]{setup} = sub {
        $app->config->SuperuserRespectsDataAPIDisableSite(1);
        $app->config->save_config;
    };
    push @tests, @extra_tests_for_respecting_superuser;

    \@tests;
}
