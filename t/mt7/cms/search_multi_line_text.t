use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare(
    {   website => [
            {   name          => 'My Site',
                server_offset => 0,
                site_path     => 'TEST_ROOT/site',
                archive_path  => 'TEST_ROOT/site/archive',
            }
        ],
        content_type => {
            ct => {
                name   => 'ct',
                fields => [
                    cf_multi => {
                        type => 'multi_line_text',
                        name => 'multi line text',
                    },
                    cf_text => {
                        type => 'single_line_text',
                        name => 'single line text',
                    },
                ],
            },
            ct2 => {
                name   => 'ct2',
                fields => [
                    cf_ct => {
                        type   => 'content_type',
                        name   => 'content type',
                        source => 'ct',
                    },
                ],
            },
        },
        content_data => {
            cd => {
                content_type => 'ct',
                data         => { cf_multi => 'multi line text', cf_text => undef, },
            },
            cd2 => {
                content_type => 'ct2',
                data         => { cf_ct => ['cd'], },
            },
        },
    }
);

my $blog_id = $objs->{blog_id};
my $ct_id   = $objs->{content_type}{ct2}{content_type}->id;

my $admin = MT::Author->load(1);

my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);

$app->get_ok(
    {   __mode  => 'search_replace',
        blog_id => $blog_id,
    }
);

$app->post_form_ok(
    {   content_type_id => $ct_id,
        search          => "unknown",
        do_search       => 1,
    }
);
ok !$app->generic_error, "no error";
note $app->generic_error if $app->generic_error;

done_testing;
