#!/Usr/bin/perl

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

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(name => 'my website');

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $ichikawa = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    require MT::Role;
    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

    require MT::Association;
    MT::Association->link($aikawa => $site_admin => $blog);
});

my $website = MT::Website->load({ name => 'my website' });
my $blog    = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });

my $admin = MT::Author->load(1);

require MT::Role;
my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

subtest 'mode = save' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'association',
        blog_id => 0,
    });
    $app->has_invalid_request("save by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'association',
        blog_id => 0,
    });
    $app->has_invalid_request("save by non permitted user");
};

subtest 'mode = edit' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'association',
        blog_id => 0,
    });
    $app->has_invalid_request("edit by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'association',
        blog_id => 0,
    });
    $app->has_invalid_request("edit by non permitted user");
};

subtest 'mode = delete' => sub {
    my $assoc = MT::Association->link($ichikawa => $site_admin => $blog);
    my $app   = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'association',
        blog_id => 0,
        id      => $assoc->id,
    });
    $app->has_no_permission_error("delete by admin");

    $assoc = MT::Association->link($ichikawa => $site_admin => $blog);
    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'delete',
        _type   => 'association',
        blog_id => 0,
        id      => $assoc->id,
    });
    $app->has_permission_error("delete by non permitted user");
};

done_testing();
