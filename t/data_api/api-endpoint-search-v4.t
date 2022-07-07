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

$test_env->prepare_fixture('content_data');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $objs    = MT::Test::Fixture::ContentData->load_objs;
my $author  = $app->model('author')->load(1);
my $blog_id = $objs->{blog_id};
my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;

# test.
my $suite = suite();
test_data_api($suite);

# end
done_testing;

sub suite {
    return +[

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
    ];
}
