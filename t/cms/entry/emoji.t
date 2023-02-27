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
use MT::Test::Emoji;
use MT::Test::Fixture;

$test_env->skip_unless_mysql_supports_utf8mb4;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [ { name => 'my site', theme => 'classic website' } ],
});

my $blog_id = $objs->{blog_id};
my $admin   = MT::Author->load(1);

subtest 'Title/Text' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);

    $app->get_ok(
        {   __mode  => 'view',
            _type   => 'entry',
            blog_id => $blog_id,
        }
    );

    my $title = random_emoji_string(30);
    my $text  = random_emoji_string(300);

    $app->post_form_ok(
        {   title            => $title,
            text             => $text,
            authored_on_date => '2020-02-02',
            authored_on_time => '00:00:00',
            basename         => 'post',
        }
    );
    my $message = $app->message_text // '';
    like $message => qr/This entry has been saved./, "correct message";

    my $entry = MT::Entry->load(1);
    is $entry->title => $title, "title";
    is $entry->text  => $text,  "text";

    MT->instance->publisher->rebuild(BlogID => $blog_id);
    $test_env->ls;

    my $post_file = $test_env->path("2020/02/post.html");
    my $post = $test_env->slurp( $post_file, ':utf8' );
    like $post => qr/\Q$title/, "post contains title";
    like $post => qr/\Q$text/, "post contains text";
};

done_testing;
