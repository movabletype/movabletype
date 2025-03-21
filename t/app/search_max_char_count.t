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

use MT::Test::App;

$test_env->prepare_fixture('db');

my $error_tmpl = 'Too long query. Please simplify your query to %d characters or less and try again.';

subtest 'SearchMaxCharCount = 0' => sub {
    MT->config->SearchMaxCharCount(0, 1);
    MT->config->ContentDataSearchMaxCharCount(undef, 1);
    MT->config->save_config;

    my $error = $error_tmpl;
    $error =~ s/%d.+$//;

    {
        my $app = MT::Test::App->new('MT::App::Search');

        subtest 'new_search' => sub {
            $app->get_ok({ search => 'a' x 100 });
            $app->content_unlike($error, 'limit not exceeded');
        };

        subtest 'new_search (tag)' => sub {
            $app->get_ok({ tag => 'a' x 100 });
            $app->content_unlike($error, 'limit not exceeded');
        };
    }

    subtest 'cd_search' => sub {
        my $app = MT::Test::App->new('MT::App::Search::ContentData');

        $app->get_ok({ search => 'a' x 100 });
        $app->content_unlike($error, 'limit not exceeded');
    };
};

subtest "SearchMaxCharCount = 10" => sub {
    my $search_max_char_count = MT->config->SearchMaxCharCount(10, 1);
    MT->config->ContentDataSearchMaxCharCount(undef, 1);
    MT->config->save_config;

    my $error = sprintf $error_tmpl, $search_max_char_count;

    {
        my $app = MT::Test::App->new('MT::App::Search');

        subtest 'new_search' => sub {
            $app->get_ok({ search => 'b' x $search_max_char_count });
            $app->content_unlike($error, 'limit not exceeded');

            $app->get_ok({ search => 'b' x ($search_max_char_count + 1) });
            $app->content_like($error, 'limit exceeded');
        };

        subtest 'new_search (tag)' => sub {
            $app->get_ok({ tag => 'b' x $search_max_char_count });
            $app->content_unlike($error, 'limit not exceeded');

            $app->get_ok({ tag => 'b' x ($search_max_char_count + 1) });
            $app->content_like($error, 'limit exceeded');
        };
    }

    subtest 'cd_search' => sub {
        my $app = MT::Test::App->new('MT::App::Search::ContentData');

        $app->get_ok({ search => 'b' x $search_max_char_count });
        $app->content_unlike($error, 'limit not exceeded');

        $app->get_ok({ search => 'b' x ($search_max_char_count + 1) });
        $app->content_like($error, 'limit exceeded');
    };
};

subtest 'SearchMaxCharCount = 20, ContentDataSearchMaxCharCount = 5' => sub {
    my $search_max_char_count    = MT->config->SearchMaxCharCount(20, 1);
    my $cd_search_max_char_count = MT->config->ContentDataSearchMaxCharCount(5, 1);
    MT->config->save_config;

    {
        my $error = sprintf $error_tmpl, $search_max_char_count;

        my $app = MT::Test::App->new('MT::App::Search');

        subtest 'new_search' => sub {
            $app->get_ok({ search => 'c' x $search_max_char_count });
            $app->content_unlike($error, 'limit not exceeded');

            $app->get_ok({ search => 'c' x ($search_max_char_count + 1) });
            $app->content_like($error, 'limit exceeded');
        };

        subtest 'new_search (tag)' => sub {
            $app->get_ok({ tag => 'c' x $search_max_char_count });
            $app->content_unlike($error, 'limit not exceeded');

            $app->get_ok({ tag => 'c' x ($search_max_char_count + 1) });
            $app->content_like($error, 'limit exceeded');
        };
    }

    subtest 'cd_search' => sub {
        my $error = sprintf $error_tmpl, $cd_search_max_char_count;

        my $app = MT::Test::App->new('MT::App::Search::ContentData');

        $app->get_ok({ search => 'c' x $cd_search_max_char_count });
        $app->content_unlike($error, 'limit not exceeded');

        $app->get_ok({ search => 'c' x ($cd_search_max_char_count + 1) });
        $app->content_like($error, 'limit exceeded');
    };
};

subtest 'SearchMaxCharCount = 0, ContentDataSearchMaxCharCount = 15' => sub {
    MT->config->SearchMaxCharCount(0, 1);
    my $cd_search_max_char_count = MT->config->ContentDataSearchMaxCharCount(15, 1);
    MT->config->save_config;

    {
        my $error = $error_tmpl;
        $error =~ s/%d.+$//;

        my $app = MT::Test::App->new('MT::App::Search');

        subtest 'new_search' => sub {
            $app->get_ok({ search => 'd' x 100 });
            $app->content_unlike($error, 'limit not exceeded');
        };

        subtest 'new_search (tag)' => sub {
            $app->get_ok({ tag => 'd' x 100 });
            $app->content_unlike($error, 'limit not exceeded');
        };
    }

    subtest 'cd_search' => sub {
        my $error = sprintf $error_tmpl, $cd_search_max_char_count;

        my $app = MT::Test::App->new('MT::App::Search::ContentData');

        $app->get_ok({ search => 'd' x $cd_search_max_char_count });
        $app->content_unlike($error, 'limit not exceeded');

        $app->get_ok({ search => 'd' x ($cd_search_max_char_count + 1) });
        $app->content_like($error, 'limit exceeded');
    };
};

done_testing;
