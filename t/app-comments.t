use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    $test_env = MT::Test::Env->new(
        CaptchaSourceImageBase => '__MT_HOME__',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::App;
use MT::Test::Permission;

use_ok 'MT::App::Comments';

is( MT::App::Comments::HOLD(),    1, 'MT::Entry::HOLD() is imported' );
is( MT::App::Comments::RELEASE(), 2, 'MT::Entry::RELEASE() is imported' );
is( MT::App::Comments::FUTURE(),  4, 'MT::Entry::FUTURE() is imported' );

$test_env->prepare_fixture('db_data');

my $blog = MT::Blog->load(1);
$blog->commenter_authenticators('MovableType');
$blog->save;

my $melody = MT::Author->load(1);
$melody->name('Melody');
$melody->nickname('Melody');
$melody->email('melody@localhost.localdomain');
$melody->save;

sub _login_as_commenter {
    my ( $app, $user ) = @_;

    $app->login($user);

    my $session = MT::App::make_session($user);
    $app->{session} = $session->id;

    my $mock = Test::MockModule->new('MT::App');
    $mock->redefine(
        'get_commenter_session',
        sub {
            my $mt = shift;
            return ( $mt->session, $user );
        }
    );
    $mock;
}

subtest 'post' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $guard_login = _login_as_commenter( $app, $melody );

    subtest 'success' => sub {
        my $res = $app->post(
            {   __mode   => 'post',
                blog_id  => 1,
                entry_id => 1,
                __lang   => 'en-us',
                sid      => $app->{session},
                text     => 'Comment Text',
            }
        );
        $app->status_is(200);
        $app->content_like('Confirmation');
        $app->content_like('Your comment has been submitted');
        $app->content_unlike('Comment Submission Error');
        $app->content_unlike('Invalid request');
    };

    subtest 'failure' => sub {
        my $error = join(':', __FILE__, __LINE__);
        my $mock = Test::MockModule->new('MT::Comment');
        $mock->mock('save', sub { $_[0]->error($error) });

        my $res = $app->post(
            {   __mode   => 'post',
                blog_id  => 1,
                entry_id => 1,
                __lang   => 'en-us',
                sid      => $app->{session},
                text     => 'Comment Text',
            }
        );
        $app->status_is(200);
        $app->content_like('An error occurred');
        $app->content_unlike('Confirmation');
        $app->content_unlike('Your comment has been submitted');
        my $log = MT->model('log')->load({class => 'comment'}, {sort => 'id', direction => 'descend'});
        like $log->message, qr/\Q$error\E/;
    };
};

done_testing;
