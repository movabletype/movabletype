#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    plan skip_all => 'Not for external CGI mode' if $ENV{MT_TEST_RUN_APP_AS_CGI};
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    # Move addons/Cloud.pack/config.yaml to config.yaml.disabled.
    # An error occurs in save_community_prefs mode when Cloud.pack installed.
    $test_env->skip_if_addon_exists('Cloud.pack');
}

use MT;
use MT::Association;
use MT::CMS::User;
use MT::Role;

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

MT->instance;
my $user        = MT::Author->load(1);
my $mock_author = Test::MockModule->new('MT::Author');
our $is_superuser = 0;
$mock_author->mock('is_superuser', sub { $is_superuser });
my $blog = MT::Blog->load(1);
my $website = MT::Website->load(2);
is(!!$website->is_blog, '', 'Is a website');

my $admin_role = MT::Role->load({ permissions => { like => '%administer_site%' } });
require MT::Association;
MT::Association->link($user, $admin_role, $website);

my %callbacks = ();
my $mock_mt   = Test::MockModule->new('MT');
$mock_mt->mock(
    'run_callbacks',
    sub {
        my ($app, $meth, @param) = @_;
        $callbacks{$meth} ||= [];
        push @{ $callbacks{$meth} }, \@param;
        $mock_mt->original('run_callbacks')->(@_);
    });

subtest 'Check callbacks for each config screens' => sub {
    my @screens = ({
            __mode => 'cfg_prefs',
            name   => 'General Settings',
        },
        {
            __mode => 'cfg_entry',
            name   => 'Compose Settings',
        },
        {
            __mode => 'cfg_web_services',
            name   => 'Web Services Settings',
        },
    );

    for my $s (@screens) {
        subtest $s->{name} . ' screen' => sub {
            %callbacks = ();

            plan skip_all => 'This test is skip for this screen'
                if $s->{skip};

            my $app = MT::Test::App->new('MT::App::CMS');
            $app->login($user);
            $app->get_ok({
                __mode  => $s->{__mode},
                blog_id => $website->id
            });

            for my $t (qw(blog website)) {
                for my $name (qw(cms_object_scope_filter cms_view_permission_filter cms_edit)) {
                    my $cb = 'MT::App::CMS::' . $name . '.' . $t;
                    is(
                        scalar @{ $callbacks{$cb} || [] },
                        1, $cb . ' has been called once'
                    );
                }
            }

            $app->content_like(
                qr/name="__mode"\s*value="save"(?:(?!form).)*name="_type"\s*value="website"/sm,
                '"website" is specified for "_type"'
            );
        };
    }
};

subtest 'Check callbacks for each config screens for global level' => sub {
    local $is_superuser = 1;

    my @screens = ({
            __mode => 'cfg_web_services',
            name   => 'Web Services Settings',
            like   => qr/__mode" value="save_cfg_system_web_services"/,
        },
    );

    for my $s (@screens) {
        subtest $s->{name} . ' screen' => sub {
            %callbacks = ();

            plan skip_all => 'This test is skip for this screen'
                if $s->{skip};

            my $app = MT::Test::App->new('MT::App::CMS');
            $app->login($user);
            $app->get_ok({
                __mode  => $s->{__mode},
                blog_id => 0,
            });

            for my $t (qw(blog)) {
                for my $name (qw(cms_edit)) {
                    my $cb = 'MT::App::CMS::' . $name . '.' . $t;
                    is(
                        scalar @{ $callbacks{$cb} || [] },
                        1, $cb . ' has been called once'
                    );
                }
            }

            $app->content_like($s->{like}, 'output');
        };
    }
};

subtest 'Check callbacks for saving' => sub {
    %callbacks = ();

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    my $res = $app->post_ok({
        __mode   => 'save',
        _type    => 'website',
        id       => $website->id,
        blog_id  => $website->id,
        site_url => q(),
    });

    for my $t (qw(blog website)) {
        for my $name (qw(cms_save_permission_filter cms_save_filter cms_pre_save cms_post_save)) {
            my $cb = 'MT::App::CMS::' . $name . '.' . $t;
            is(
                scalar @{ $callbacks{$cb} || [] },
                1, $cb . ' has been called once'
            );
        }
    }

    like $app->message_text => qr/Your preferences have been saved/, 'Saved successfully';
};

subtest 'Check disable image popup' => sub {
    my %params = (
        __mode  => 'cfg_entry',
        blog_id => $website->id
    );
    subtest 'check image popup is enabled' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->get_ok(\%params);
        note $app->wq_find("#image_default_link_popup")->as_html;
        is($app->wq_find("#image_default_link_popup")->size, 1, 'image popup check is show');
    };

    subtest 'change DisableImagePopup 1' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $test_env->update_config(DisableImagePopup => 1);
        $app->get_ok(\%params);
        note $app->wq_find("#image_default_link_popup")->as_html;
        is($app->wq_find("#image_default_link_popup")->size, 0, 'image popup check is hide');
        $test_env->update_config(DisableImagePopup => 0);
    };

    subtest 'empty popup_image template' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        my $tmpl = MT->model('template')->load({
            blog_id => $website->id,
            type    => 'popup_image'
        });
        $tmpl->text('');
        $tmpl->save;
        $app->post_ok(\%params);
        note $app->_find_text('.custom-control .alert');
        is($app->_find_text('.custom-control .alert'), q{'Popup image' template does not exist or is empty and cannot be selected.}, 'empty error');
    };

    subtest 'remove popup_image template' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        MT->model('template')->remove({
            blog_id => $website->id,
            type    => 'popup_image'
        });
        $app->get_ok(\%params);
        note $app->_find_text('.custom-control .alert');
        is($app->_find_text('.custom-control .alert'), q{'Popup image' template does not exist or is empty and cannot be selected.}, 'empty error');
    };
};

subtest 'save_favorite_blogs' => sub {
    subtest 'Add website' => sub {
        $user->favorite_sites([]);
        $user->favorite_blogs([]);
        $user->save;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->post_ok({
            __mode  => 'save_favorite_blogs',
            id       => $website->id
        });
        is $app->content, 'true';

        is_deeply $user->favorite_blogs, [];
        is_deeply $user->favorite_websites, [$website->id];
    };

    subtest 'Add blog' => sub {
        $user->favorite_sites([]);
        $user->favorite_blogs([]);
        $user->save;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->post_ok({
            __mode  => 'save_favorite_blogs',
            id       => $blog->id
        });
        is $app->content, 'true';

        is_deeply $user->favorite_blogs, [$blog->id];
        is_deeply $user->favorite_websites, [$website->id];
    };
};

subtest 'save_starred_sites' => sub {
    subtest 'Update favorite sites' => sub {
        $user->starred_sites([]);
        $user->save;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->js_post_ok({
            __mode => 'save_starred_sites',
            id     => [1, 2],
        });

        is_deeply $user->starred_sites, [1, 2];
    };

    subtest 'Update favorite sites with the empty array' => sub {
        $user->starred_sites([1, 2]);
        $user->save;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->js_post_ok({
            __mode => 'save_starred_sites',
        });

        is_deeply $user->starred_sites, [];
    };

    subtest 'Update favorite sites with the largest number of cases' => sub {
        $user->starred_sites([]);
        $user->save;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->js_post_ok({
            __mode => 'save_starred_sites',
            id     => [(1 .. $MT::Author::MAX_STARRED_SITES)],
        });

        is scalar @{ $user->starred_sites }, $MT::Author::MAX_STARRED_SITES;
    };

    subtest 'Failed to register more than the maximum number' => sub {
        $user->starred_sites([]);
        $user->save;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';
        $app->post({
            __mode => 'save_starred_sites',
            id     => [(1 .. $MT::Author::MAX_STARRED_SITES + 1)],
        });
        $app->status_is(400);
        ok $app->json->{error};
    };
};

done_testing;
