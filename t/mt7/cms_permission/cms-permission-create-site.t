#!/usr/bin/perl

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

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Site
    my $site = MT::Test::Permission->make_website(name => 'my website');

    # Author
    my $user = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    # Role
    my $create_site_role = MT::Test::Permission->make_role(
        name        => 'Create Child Site',
        permissions => "'create_site'",
    );

    require MT::Association;
    MT::Association->link($user => $create_site_role => $site);

});

require MT::Website;
my $site = MT::Website->load({ name => 'my website' });

require MT::Author;
my $admin = MT::Author->load(1);
my $user  = MT::Author->load({ name => 'aikawa' });

require MT::Role;
my $create_site_role = MT::Role->load({ name => MT->translate('Create Child Site') });

subtest 'mode = save (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode    => 'save',
        _type     => 'blog',
        name      => 'BlogName',
        parent_id => $site->id,
        blog_id   => $site->id,
    });
    $app->has_no_permission_error("save (new) by permitted user");

    MT::Association->unlink($user => $create_site_role => $site);

    $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode    => 'save',
        _type     => 'blog',
        name      => 'BlogName',
        parent_id => $site->id,
        blog_id   => $site->id,
    });
    $app->has_permission_error("save (new) by permitted user");
};

done_testing();
