#!/usr/bin/perl

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
        name      => 'asset dialog list child assets website',
        site_path => $ENV{MT_TEST_ROOT},
    );
    my $blog1 = MT::Test::Permission->make_blog(
        name      => 'asset dialog list child assets blog 1',
        parent_id => $website->id,
    );
    my $blog2 = MT::Test::Permission->make_blog(
        name      => 'asset dialog list child assets blog 2',
        parent_id => $website->id,
    );

    my $ct = MT::Test::Permission->make_content_type(
        name    => 'asset dialog list child assets content type',
        blog_id => $website->id,
    );
    my $cf_image = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'asset dialog list child assets image',
        type            => 'asset_image',
    );
    $ct->fields([
        {   id      => $cf_image->id,
            order   => 1,
            type    => $cf_image->type,
            options => {
                label        => $cf_image->name,
                multiple     => 1,
                allow_upload => 1,
            },
            unique_id => $cf_image->unique_id,
        },
    ]);
    $ct->save;

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

my $mt       = MT->instance;
my $admin    = $mt->model('author')->load(1);
my $aikawa   = $mt->model('author')->load({ name => 'aikawa' });
my $ukawa    = $mt->model('author')->load({ name => 'ukawa' });
my $website  = $mt->model('website')->load({ name => 'asset dialog list child assets website' });
my $cf_image = $mt->model('cf')->load({ name => 'asset dialog list child assets image' });

sub dialog_rows {
    my ($user, %extra) = @_;
    my %params = (
        __mode      => 'dialog_list_asset',
        _type       => 'asset',
        dialog_view => 1,
        dialog      => 1,
        json        => 1,
        offset      => 0,
        filter      => 'class',
        filter_val  => 'image',
        blog_id     => $website->id,
        %extra,
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

subtest 'content_field_id does not expand child blogs' => sub {
    is dialog_rows($aikawa, content_field_id => $cf_image->id),
        1,
        'website asset only';
};

done_testing;
