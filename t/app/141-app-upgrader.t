#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    plan skip_all => "Not for external CGI server" if $ENV{MT_TEST_RUN_APP_AS_CGI};

    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw(:newdb);
use MT::Test::Permission;
use MT::Test::Upgrade;
use MT::Test::App;
use MT::Theme;

$test_env->fix_mysql_create_table_sql;

subtest 'v5_assign_blog_date_language' => sub {
    require MT::Upgrade::v5;
    for my $conf_lang ('ja', 'en_US') {
        for my $db_lang ('ja', 'en-us', 'un-kn', 'en-US') {
            subtest $conf_lang. ':'. $db_lang => sub {
                MT->config(DefaultLanguage => $conf_lang);
                MT::Test->init_db;
                my $site = MT::Website->load({id => 1});
                $site->date_language($db_lang);
                $site->language($db_lang);
                $site->save;
                my $updater = MT::Upgrade::v5::upgrade_functions()->{v5_assign_blog_date_language}->{updater};
                MT::Upgrade::core_update_records('MT::Upgrade', %$updater);
                $site = MT::Website->load({id => 1});
                is $site->date_language, $db_lang, 'right date_language';
                is $site->language, $db_lang ne 'un-kn' ? $db_lang : $conf_lang, 'right language';
            };
        }
    }
};

subtest 'Upgrade from MT4 to MT7' => sub {
    MT::Test->init_db;
    MT::Website->remove_all;

    my @blog_ids;
    foreach (0 .. 2) {
        my $blog = MT::Test::Permission->make_blog(parent_id => 0,);
        ok($blog, 'Create blog.');
        push @blog_ids, $blog->id;
    }
    my $admin = MT::Author->load(1);
    $admin->favorite_blogs(\@blog_ids);
    $admin->save or die $admin->errstr;

    is(MT::Website->count(), 0, 'There is no website.');
    is(MT::Blog->count(),    3, 'There are three blogs.');

    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });
    my $blog       = MT::Blog->load($blog_ids[0]);
    $admin->add_role($site_admin, $blog);

    my @roles;
    my $iter = $admin->role_iter({ blog_id => $blog->id });
    while (my $r = $iter->()) {
        push @roles, $r;
    }
    is(scalar @roles, 1, 'Administrator has one role.');
    is(
        $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );
    my $perms = $admin->permissions($blog->id);
    ok(
        $perms->has('administer_site'),
        'Administrator has "administer_site" permission.'
    );

    my $cfg = MT->config;
    $cfg->MTVersion(4.38);
    $cfg->SchemaVersion(4.0077);
    $cfg->save_config;

    my $config = MT::Config->load;
    my $data   = $config->data;
    my @lines  = split /\n/, $data;
    my @new_lines;
    foreach my $line (@lines) {
        if ($line =~ /^MTVersion/) {
            $line = 'MTVersion 4.38';
        } elsif ($line =~ /^SchemaVersion/) {
            $line = 'SchemaVersion 4.0077';
        }
        push @new_lines, $line;
    }
    my $new_data = join "\n", @new_lines;
    $config->data($new_data);
    $config->save or die $config->errstr;

    my $app = MT::Test::App->new('MT::App::Upgrader');
    my $res = $app->post({
        __mode   => 'upgrade',
        username => 'Melody',
        password => 'Nelson',
    });

    my $json_steps = $app->_app->response;
    while (@{ $json_steps->{steps} || [] }) {

        require MT::Util;
        $json_steps = MT::Util::to_json($json_steps->{steps});

        $res = $app->post({
            username => 'Melody',
            password => 'Nelson',
            __mode   => 'run_actions',
            steps    => $json_steps,
        });
        (my $json = $res->decoded_content) =~ s/^.*JSON://s;

        require JSON;
        $json_steps = JSON::from_json($json);

        ok(!$json_steps->{error}, 'Request has no error.') or do {
            note "ERROR: " . $json_steps->{error};
            last;
        };

    }

    my @websites = MT::Website->load();
    is(scalar @websites, 3, 'There are three websites.');
    for my $site (@websites) {
        is $site->date_language, 'en_us', 'right date_language';
        is $site->language,      'en_US', 'right language';
    }

    is(MT::Blog->count(),    0, 'There is no blog.');

    $admin = MT::Author->load(1);
    ok(
        !$admin->favorite_blogs,
        'Administrator does not have favorite_blogs'
    );
    my $favorite_websites = $admin->favorite_websites;
    is(
        scalar @$favorite_websites,
        3, 'Administrator has three favorite_websites.'
    );

    $iter  = $admin->role_iter({ blog_id => $blog->id });
    @roles = ();
    while (my $r = $iter->()) {
        push @roles, $r;
    }
    is(scalar @roles, 1, 'Administrator has one role.');
    is(
        $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );

    $perms = $admin->permissions($blog->id);
    ok(
        $perms->has('administer_site'),
        'Administrator has "administer_site" permission.'
    );

};

subtest 'Upgrade from MT5 to MT7' => sub {
    MT::Test->init_db;

    my $blog = MT::Test::Permission->make_blog(parent_id => 0,);
    ok($blog, 'Create blog.');

    is(MT::Website->count(), 1, 'There is one website.');
    is(MT::Blog->count(),    1, 'There is one blog.');

    my $website = MT::Website->load(1);
    my $admin   = MT::Author->load(1);
    $admin->favorite_websites([$website->id]);
    $admin->favorite_blogs([$blog->id]);
    $admin->save or die $admin->errstr;

    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });
    $admin->add_role($site_admin, $blog);

    my @roles;
    my $iter = $admin->role_iter({ blog_id => $blog->id });
    while (my $r = $iter->()) {
        push @roles, $r;
    }
    is(scalar @roles, 1, 'Administrator has one role.');
    is(
        $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );
    my $perms = $admin->permissions($blog->id);
    ok(
        $perms->has('administer_site'),
        'Administrator has "administer_site" permission.'
    );

    MT::Test::Upgrade->upgrade(from => 5.0036);

    is(MT::Website->count(), 1, 'There is one website.');
    is(MT::Blog->count(),    1, 'There is one blog.');

    $admin = MT::Author->load(1);
    is(
        scalar @{ $admin->favorite_websites },
        1, "Administrator has one favorite_websites."
    );
    is(
        $admin->favorite_websites->[0],
        $website->id, "Favorite_websites ID is " . $website->id . "."
    );
    is(
        scalar @{ $admin->favorite_blogs },
        1, "Administrator has one favorite_blogs."
    );
    is(
        $admin->favorite_blogs->[0],
        $blog->id, "Favorite_blogs ID is " . $blog->id . "."
    );

    $iter  = $admin->role_iter({ blog_id => $blog->id });
    @roles = ();
    while (my $r = $iter->()) {
        push @roles, $r;
    }
    is(scalar @roles, 1, "Administrator has one role.");
    is(
        $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );

    $perms = $admin->permissions($blog->id);
    ok(
        $perms->has('administer_site'),
        'Administrator has "administer_site" permission.'
    );

    my @migrate_roles = (
        'Designer (MT6)',
        'Author (MT6)',
        'Contributor (MT6)',
        'Editor (MT6)'
    );
    foreach my $role_name (@migrate_roles) {
        my $role_count = MT::Role->count({ name => MT->translate($role_name) });
        is($role_count, 1, $role_name . ' has one role.');
    }

};

subtest 'Upgrade from MT6 to MT7' => sub {
    MT::Test->init_db;

    my $blog = MT::Test::Permission->make_blog(parent_id => 0,);
    ok($blog, 'Create blog.');

    is(MT::Website->count(), 1, 'There is one website.');
    is(MT::Blog->count(),    1, 'There is one blog.');

    my $website = MT::Website->load(1);
    my $admin   = MT::Author->load(1);
    $admin->favorite_websites([$website->id]);
    $admin->favorite_blogs([$blog->id]);
    $admin->save or die $admin->errstr;

    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });
    $admin->add_role($site_admin, $blog);

    my @roles;
    my $iter = $admin->role_iter({ blog_id => $blog->id });
    while (my $r = $iter->()) {
        push @roles, $r;
    }
    is(scalar @roles, 1, 'Administrator has one role.');
    is(
        $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );
    my $perms = $admin->permissions($blog->id);
    ok(
        $perms->has('administer_site'),
        'Administrator has "administer_site" permission.'
    );

    MT::Test::Upgrade->upgrade(from => 6.0010);

    is(MT::Website->count(), 1, 'There is one website.');
    is(MT::Blog->count(),    1, 'There is one blog.');

    $admin = MT::Author->load(1);
    is(
        scalar @{ $admin->favorite_websites },
        1, "Administrator has one favorite_websites."
    );
    is(
        $admin->favorite_websites->[0],
        $website->id, "Favorite_websites ID is " . $website->id . "."
    );
    is(
        scalar @{ $admin->favorite_blogs },
        1, "Administrator has one favorite_blogs."
    );
    is(
        $admin->favorite_blogs->[0],
        $blog->id, "Favorite_blogs ID is " . $blog->id . "."
    );

    $iter  = $admin->role_iter({ blog_id => $blog->id });
    @roles = ();
    while (my $r = $iter->()) {
        push @roles, $r;
    }
    is(scalar @roles, 1, "Administrator has one role.");
    is(
        $roles[0]->name,
        MT->translate('Site Administrator'),
        'Administrator has "Site Administrator" role.'
    );

    $perms = $admin->permissions($blog->id);
    ok(
        $perms->has('administer_site'),
        'Administrator has "administer_site" permission.'
    );

    my @migrate_roles = (
        'Designer (MT6)',
        'Author (MT6)',
        'Contributor (MT6)',
        'Editor (MT6)'
    );
    foreach my $role_name (@migrate_roles) {
        my $role_count = MT::Role->count({ name => MT->translate($role_name) });
        is($role_count, 1, $role_name . ' has one role.');
    }

};

subtest 'MultiBlogMigrationPartial' => sub {
    my $model = MT->model('rebuild_trigger');
    # ri:2:entry_save:0|ri:2:entry_save:0|ri:2:entry_save:0

    subtest 'unserialize single' => sub {
        my $rt = MT::Upgrade::v7::_v7_migrate_rebuild_trigger_unserialize('ri:2:entry_save');
        is(ref $rt,             $model, 'right class');
        is($rt->target,         MT::RebuildTrigger::TARGET_BLOG);
        is($rt->action,         MT::RebuildTrigger::ACTION_RI);
        is($rt->object_type,    MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE);
        is($rt->target_blog_id, 2);
        is($rt->event,          MT::RebuildTrigger::EVENT_SAVE);
    };

    subtest 'unserialize single target=0' => sub {
        my $rt = MT::Upgrade::v7::_v7_migrate_rebuild_trigger_unserialize('ri:0:entry_save');
        is(ref $rt, $model, 'right class');
        is($rt->target_blog_id, 0);
    };

    subtest 'unserialize single target=_blogs_in_website' => sub {
        my $rt = MT::Upgrade::v7::_v7_migrate_rebuild_trigger_unserialize('ri:_blogs_in_website:entry_save');
        is(ref $rt,             $model, 'right class');
        is($rt->target,         MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE);
        is($rt->target_blog_id, 0);
    };

    subtest 'unserialize single target=_all' => sub {
        my $rt = MT::Upgrade::v7::_v7_migrate_rebuild_trigger_unserialize('ri:_all:entry_save');
        is(ref $rt,             $model, 'right class');
        is($rt->target,         MT::RebuildTrigger::TARGET_ALL);
        is($rt->target_blog_id, 0);
    };

    subtest 'unserialize single error' => sub {
        my @wrong_inputs = (
            'xx:2:entry_save',
            'ri::entry_save',
            'ri:x:entry_save',
            'ri:1_:entry_save',
            'ri:2:XXXX_save',
            'ri:2:entry_XXXX',
            "ri:2:entry_XXXX\n",
            "\nri:2:entry_XXXX",
        );
        for (@wrong_inputs) {
            my $rt = MT::Upgrade::v7::_v7_migrate_rebuild_trigger_unserialize($_);
            is(ref $rt, '',    'error');
            is($rt,     undef, 'error');
        }
    };
};

subtest 'MultiBlogMigration' => sub {
    MT::Test->init_db;

    my $parent1 = MT::Test::Permission->make_blog(parent_id => 0);
    my $parent2 = MT::Test::Permission->make_blog(parent_id => 0);
    my $child1  = MT::Test::Permission->make_blog(parent_id => $parent1->id);
    my $child2  = MT::Test::Permission->make_blog(parent_id => $parent2->id);
    my $child3  = MT::Test::Permission->make_blog(parent_id => $parent2->id);
    my $child4  = MT::Test::Permission->make_blog(parent_id => $parent2->id);

    my $pd0 = MT::PluginData->new('plugin' => 'MultiBlog', 'key' => 'configuration');
    $pd0->data({ default_access_allowed => 0 });
    $pd0->save;

    my %test_data = (default_mtmulitblog_blogs => 1, default_mtmultiblog_action => 2, blog_content_accessible => 3);

    my $pd1 = MT::PluginData->new('plugin' => 'MultiBlog', 'key' => 'configuration:blog:' . $parent2->id);
    $pd1->data(\%test_data);
    $pd1->save;
    my $pd2 = MT::PluginData->new('plugin' => 'MultiBlog', 'key' => 'configuration:blog:' . $child2->id);
    $pd2->data({
        %test_data,
        rebuild_triggers => join('|', 'ri:_all:entry_save', 'ri:123:entry_unpub', 'rip:_blogs_in_website:comment_pub'),
    });
    $pd2->save;

    my $pd3 = MT::PluginData->new('plugin' => 'MultiBlog', 'key' => 'configuration:blog:' . $child3->id);
    $pd3->data(\'1');    # broken data emulation
    $pd3->save;

    my $pd4 = MT::PluginData->new('plugin' => 'MultiBlog', 'key' => 'configuration:blog:' . $child4->id);
    $pd4->data({
        %test_data,
        rebuild_triggers => 'ri:_all:entry_xxxx',
    });
    $pd4->save;

    is(MT->config('DefaultAccessAllowed'), 1);
    is(MT::RebuildTrigger->count,          0);

    MT::Test::Upgrade->upgrade(from => 6.0010);

    my ($last_log1, $last_log2) = MT::Log->load({}, { sort => 'id', direction => 'descend', limit => 2 });
    is($last_log1->blog_id, $child4->id);
    like($last_log1->message, qr/Some MultiBlog/);
    is($last_log2->blog_id, $child3->id);
    like($last_log2->message, qr/MultiBlog/);

    is(MT->config('DefaultAccessAllowed'),                    0);
    is(MT::Blog->load($parent1->id)->default_mt_sites_sites,  undef);
    is(MT::Blog->load($parent1->id)->default_mt_sites_action, undef);
    is(MT::Blog->load($parent1->id)->blog_content_accessible, undef);
    is(MT::Blog->load($parent2->id)->default_mt_sites_sites,  1);
    is(MT::Blog->load($parent2->id)->default_mt_sites_action, 2);
    is(MT::Blog->load($parent2->id)->blog_content_accessible, 3);
    is(MT::Blog->load($child1->id)->default_mt_sites_sites,   undef);
    is(MT::Blog->load($child1->id)->default_mt_sites_action,  undef);
    is(MT::Blog->load($child1->id)->blog_content_accessible,  undef);
    is(MT::Blog->load($child2->id)->default_mt_sites_sites,   1);
    is(MT::Blog->load($child2->id)->default_mt_sites_action,  2);
    is(MT::Blog->load($child2->id)->blog_content_accessible,  3);
    is(MT::Blog->load($child3->id)->default_mt_sites_sites,   undef);
    is(MT::Blog->load($child3->id)->default_mt_sites_action,  undef);
    is(MT::Blog->load($child3->id)->blog_content_accessible,  undef);
    is(MT::RebuildTrigger->count,                             3);

    $test_env->clear_mt_cache;

    my @triggers = MT::RebuildTrigger->load();
    is($triggers[0]->target,         MT::RebuildTrigger::TARGET_ALL);
    is($triggers[0]->action,         MT::RebuildTrigger::ACTION_RI);
    is($triggers[0]->blog_id,        5);
    is($triggers[0]->object_type,    MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE);
    is($triggers[0]->target_blog_id, 0);
    is($triggers[0]->event,          MT::RebuildTrigger::EVENT_SAVE);
    is($triggers[1]->target,         MT::RebuildTrigger::TARGET_BLOG);
    is($triggers[1]->action,         MT::RebuildTrigger::ACTION_RI);
    is($triggers[1]->blog_id,        5);
    is($triggers[1]->object_type,    MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE);
    is($triggers[1]->target_blog_id, 123);
    is($triggers[1]->event,          MT::RebuildTrigger::EVENT_UNPUBLISH);
    is($triggers[2]->target,         MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE);
    is($triggers[2]->action,         MT::RebuildTrigger::ACTION_RI);
    is($triggers[2]->blog_id,        5);
    is($triggers[2]->object_type,    MT::RebuildTrigger::TYPE_COMMENT);
    is($triggers[2]->target_blog_id, 0);
    is($triggers[2]->event,          MT::RebuildTrigger::EVENT_PUBLISH);
};

done_testing;
