#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginSwitch => ['BlockEditor=1'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

BEGIN {
    use File::Basename qw( dirname );
    use File::Spec;
    my $plugin_home = dirname(dirname(File::Spec->rel2abs(__FILE__)));
    push @INC, "$plugin_home/lib", "$plugin_home/extlib";
}

use File::Basename qw( basename );
use File::Path qw( mkpath );
use File::Spec;
use MT::Test;
use MT::Test::App;
use MT::Test::Image;
use MT::Test::Permission;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $website = MT::Test::Permission->make_website(
        name      => 'block editor asset dialog list child assets website',
        site_path => $ENV{MT_TEST_ROOT},
    );
    my $blog1 = MT::Test::Permission->make_blog(
        name      => 'block editor asset dialog list child assets blog 1',
        parent_id => $website->id,
    );
    my $blog2 = MT::Test::Permission->make_blog(
        name      => 'block editor asset dialog list child assets blog 2',
        parent_id => $website->id,
    );

    for my $asset_spec (
        [ $website, 'Website Image' ],
        [ $blog1,   'Blog 1 Image' ],
        [ $blog2,   'Blog 2 Image' ],
        )
    {
        my ($blog, $label) = @$asset_spec;
        mkpath($blog->site_path) unless -d $blog->site_path;
        my ($guard, $jpg_file) = MT::Test::Image->tempfile(
            DIR    => $blog->site_path,
            SUFFIX => '.jpg',
        );
        close $guard;
        my $basename = basename($jpg_file);
        MT::Test::Permission->make_asset(
            class        => 'image',
            blog_id      => $blog->id,
            file_name    => $basename,
            file_path    => File::Spec->catfile('%r', $basename),
            file_ext     => 'jpg',
            label        => $label,
            description  => $label,
        );
    }

    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );
    my $ukawa = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Jiro Ukawa',
    );
    my $author     = MT::Role->load({ name => MT->translate('Author') });
    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

    require MT::Association;
    MT::Association->link($aikawa => $author => $website);
    MT::Association->link($aikawa => $author => $blog1);
    MT::Association->link($ukawa  => $site_admin => $website);
    MT::Association->link($ukawa  => $site_admin => $blog1);
});

my $mt      = MT->instance;
my $admin   = $mt->model('author')->load(1);
my $aikawa  = $mt->model('author')->load({ name => 'aikawa' });
my $ukawa   = $mt->model('author')->load({ name => 'ukawa' });
my $website = $mt->model('website')->load({
    name => 'block editor asset dialog list child assets website',
});

sub dialog_rows {
    my ($user) = @_;
    my %params = (
        __mode      => 'blockeditor_dialog_list_asset',
        __type      => 'asset',
        edit_field  => 'editor-input-content',
        blog_id     => $website->id,
        dialog_view => 1,
        filter      => 'class',
        filter_val  => 'image',
        can_multi   => 1,
        dialog      => 1,
        json        => 1,
        offset      => 0,
    );

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    my $res = $app->post_ok(\%params);
    my $json = MT::Util::from_json($res->decoded_content);
    return $json->{pager}{rows};
}

$test_env->update_config(RequireAdministerSiteForChildAssets => 1);

subtest 'enabled setting excludes child assets without administer_site' => sub {
    is dialog_rows($aikawa), 1, 'website asset only';
};

subtest 'enabled setting includes all child assets for admin' => sub {
    is dialog_rows($admin), 3, 'website and all child assets';
};

subtest 'enabled setting includes administered child assets for site admin' => sub {
    is dialog_rows($ukawa), 2, 'website and administered child blog assets';
};

$test_env->update_config(RequireAdministerSiteForChildAssets => 0);

subtest 'disabled setting includes permitted child assets' => sub {
    is dialog_rows($aikawa), 2, 'website and permitted child blog assets';
};

subtest 'disabled setting includes permitted child assets for site admin' => sub {
    is dialog_rows($ukawa), 2, 'website and permitted child blog assets';
};

subtest 'disabled setting still includes all child assets for admin' => sub {
    is dialog_rows($admin), 3, 'website and all child assets';
};

done_testing;
