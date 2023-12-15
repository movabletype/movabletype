use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval qq{ use Plack::Test; 1 }
        or plan skip_all => 'Plack::Test is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PSGIServeStatic => 1,
        StaticFilePath  => 'TEST_ROOT/my_static',

        SupportDirectoryURL  => '/my_support',
        SupportDirectoryPath => 'TEST_ROOT/my_support',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use HTTP::Request::Common;
use File::Path;

use MT;
use MT::Test::Image;
use MT::PSGI;

my $mt = MT->instance;

mkpath($test_env->path('my_static/images'));
my $image_file = $test_env->path('my_static/images/my_test_image.png');

my $image = MT::Test::Image->write(
    file => $image_file,
    type => 'png',
);

my $my_favicon_file = $test_env->path('my_static/images/favicon.ico');
my $my_favicon      = MT::Test::Image->write(
    file => $my_favicon_file,
    type => 'gif',
);

mkpath($test_env->path('my_support/uploads'));
my $uploaded_file = $test_env->path('my_support/uploads/uploaded_image.png');

my $uploaded_image = MT::Test::Image->write(
    file => $uploaded_file,
    type => 'png',
);

subtest 'StaticFilePath is set' => sub {
    my $apps      = MT::PSGI->new->to_app;
    my $test_apps = Plack::Test->create($apps);
    subtest 'file under StaticFilePath' => sub {
        my $res = $test_apps->request(GET '/mt-static/images/my_test_image.png');
        ok $res->is_success, "got an image from StaticFilePath";
    };
    subtest 'file under MT_HOME' => sub {
        my $res = $test_apps->request(GET '/mt-static/images/spacer.gif');
        ok $res->is_success, "got spacer.gif from MT_HOME/mt-static";
    };
    subtest 'favicon' => sub {
        my $res = $test_apps->request(GET '/favicon.ico');
        ok $res->is_success;
        my $size = $res->content_length;
        is $size => -s $my_favicon_file, "got favicon from StaticFilePath";
    };
};

subtest 'StaticFilePath is not set' => sub {
    $mt->config(StaticFilePath => undef);
    delete $mt->{__static_file_path};
    my $apps      = MT::PSGI->new->to_app;
    my $test_apps = Plack::Test->create($apps);
    subtest 'file under StaticFilePath' => sub {
        my $res = $test_apps->request(GET '/mt-static/images/my_test_image.png');
        ok !$res->is_success, "the image from StaticFilePath is not found";
    };
    subtest 'file under MT_HOME' => sub {
        my $res = $test_apps->request(GET '/mt-static/images/spacer.gif');
        ok $res->is_success, "still got spacer.gif from MT_HOME/mt-static";
    };
    subtest 'favicon' => sub {
        my $res = $test_apps->request(GET '/favicon.ico');
        ok $res->is_success;
        my $size = $res->content_length;
        isnt $size => -s $my_favicon_file, "got favicon from MT_HOME";
    };
};

subtest 'SupportDirectoryURL is set' => sub {
    my $apps      = MT::PSGI->new->to_app;
    my $test_apps = Plack::Test->create($apps);
    subtest 'file under SupportDirectoryPath' => sub {
        my $res = $test_apps->request(GET '/my_support/uploads/uploaded_image.png');
        ok $res->is_success, "got an image from SupportDirectoryURL";
    };
};

done_testing;
