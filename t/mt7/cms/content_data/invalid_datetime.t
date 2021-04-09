use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',      ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;
        MT::Test::Fixture->prepare(
            {   author       => [qw/author/],
                website      => [ { name => 'My Site' } ],
                content_type => { ct => [ cf_text => 'single_line_text' ] },
            }
        );
    }
);

my $admin   = MT::Author->load(1);
my $blog_id = MT::Website->load( { name => 'My Site' } )->id;
my $ct_id   = MT::ContentType->load( { name => 'ct' } )->id;

no Carp::Always;

subtest 'Empty publish date' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        'edit-content-type-data-form',
        {   data_label        => 'cd',
            'content-field-1' => 'text',
            authored_on_date  => undef,
            authored_on_time  => '00:00:00',
        }
    );
    my $message = $app->message_text // '';
    like $message => qr/Invalid date/, "correct message";
};

subtest 'Empty publish time' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );

    $app->post_form_ok(
        'edit-content-type-data-form',
        {   data_label        => 'cd',
            'content-field-1' => 'text',
            authored_on_date  => '2020-02-02',
            authored_on_time  => undef,
        }
    );
    my $message = $app->message_text // '';
    like $message => qr/Invalid date/, "correct message";
};

subtest 'Empty unpublish date' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    $app->get_ok(
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );
    $app->post_form_ok(
        {   data_label          => 'cd',
            'content-field-1'   => 'text',
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
        {   __mode          => 'view',
            _type           => 'content_data',
            content_type_id => $ct_id,
            blog_id         => $blog_id,
        }
    );
    $app->post_form_ok(
        {   data_label          => 'cd',
            'content-field-1'   => 'text',
            unpublished_on_date => '2020-02-02',
            unpublished_on_time => undef,
        }
    );
    my $message = $app->message_text // '';
    like $message => qr/Invalid date/, "correct message";
};

done_testing();
