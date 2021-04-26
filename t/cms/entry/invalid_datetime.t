use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $blog_id = MT::Blog->load(1)->id;
my $admin   = MT::Author->load(1);

no Carp::Always;

subtest 'Empty publish date' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );
    $app->post_form_ok(
        {   title            => 'test1',
            authored_on_date => undef,
            authored_on_time => '00:00:00',
        }
    );
    my $message = $app->message_text // '';
    like $message => qr/Invalid date/, "correct message";
};

subtest 'Empty publish time' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );
    $app->post_form_ok(
        {   title            => 'test1',
            authored_on_date => '2020-02-02',
            authored_on_time => undef,
        }
    );
    my $message = $app->message_text // '';
    like $message => qr/Invalid date/, "correct message";
};

subtest 'Empty unpublish date' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );
    $app->post_form_ok(
        {   title               => 'test1',
            unpublished_on_date => undef,
            unpublished_on_time => '00:00:00',
        }
    );
    my $message = $app->message_text // '';
    like $message => qr/Invalid date/, "correct message";
};

subtest 'Empty unpublish time' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );
    $app->post_form_ok(
        {   title               => 'test1',
            unpublished_on_date => '2020-02-02',
            unpublished_on_time => undef,
        }
    );
    my $message = $app->message_text // '';
    like $message => qr/Invalid date/, "correct message";
};

done_testing();
