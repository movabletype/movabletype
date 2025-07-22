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

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use File::Path qw(remove_tree);

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{
        name         => 'testsite',
        theme_id     => 'classic_test_website',
        site_path    => 'TEST_ROOT/site',
        archive_path => 'TEST_ROOT/site/archive',
    }],
    category => [
        'cat_clip',
        { label => 'cat_compass', parent => 'cat_clip' },
        { label => 'cat_ruler',   parent => 'cat_compass' },
        'cat_eraser',
        'cat_pencil',
    ],
    category_set => {
        catset_fruit => [
            'cat_apple', 'cat_strawberry',
            { label => 'cat_orange', parent => 'cat_strawberry' },
            'cat_peach',
        ],
        catset_animal => [
            'cat_giraffe',
            { label => 'cat_dog', parent => 'cat_giraffe' },
            { label => 'cat_cat', parent => 'cat_dog' },
            'cat_monkey',
            'cat_rabbit',
        ],
    },
    content_type => {
        ct => [
            cf_single_line_text => 'single_line_text',
            cf_catset           => {
                type         => 'categories',
                category_set => 'catset_fruit',
                options      => { multiple => 1 },
            },
        ],
    },
    template => [{
            name         => 'tmpl_ct',
            archive_type => 'ContentType',
            content_type => 'ct',
            text         => '<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields>',
            mapping      => [{
                file_template => 'ct/%f',
                is_preferred  => 1,
            }],
        }, {
            name         => 'tmpl_ct_archive',
            archive_type => 'ContentType-Category',
            content_type => 'ct',
            text         => '<mt:Contents><mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents>',
            mapping      => [{
                file_template => 'ct/%-c/%i',
                is_preferred  => 1,
                cat_field     => 'cf_catset',
            }],
        }
    ],
});

my $site = $objs->{website}{testsite};

my $new_entry  = $test_env->path('site/archive/1978/01/new-entry.html');
my $new_entry2 = $test_env->path('site/archive/1978/01/new-entry2.html');
my $new_cd     = $test_env->path('site/archive/ct/new_cd.html');
my $new_cd2    = $test_env->path('site/archive/ct/new_cd2.html');

my $cat_clip    = $test_env->path('site/archive/cat-clip/index.html');
my $cat_compass = $test_env->path('site/archive/cat-clip/cat-compass/index.html');
my $cat_peach   = $test_env->path('site/archive/ct/cat-peach/index.html');
my $cat_orange  = $test_env->path('site/archive/ct/cat-strawberry/cat-orange/index.html');

my $admin = MT::Author->load(1);

for my $publish_empty_archive (0, 1) {
    $site->publish_empty_archive($publish_empty_archive);
    $site->save;

    $_->remove for values %{ $objs->{entry} || {} };
    delete $objs->{entry};

    $_->remove for values %{ $objs->{content_data} || {} };
    delete $objs->{content_data};

    $test_env->clear_mt_cache;

    remove_tree($test_env->path('site/archive'));

    subtest 'nothing is published yet' => sub {
        MT->publisher->rebuild(BlogID => $site->id);

        $test_env->ls;

        ok !-f $new_entry,  "new entry does not exist";
        ok !-f $new_entry2, "new entry2 does not exist";
        ok !-f $new_cd,     "new cd does not exist";
        ok !-f $new_cd2,    "new cd2 does not exist";

        ok !-f $cat_clip,    "cat clip does not exist";
        ok !-f $cat_compass, "cat compass does not exist";
        ok !-f $cat_peach,   "cat peach does not exist";
        ok !-f $cat_orange,  "cat orange does not exist";
    };

    subtest 'publish entries and content data' => sub {
        MT::Test::Fixture->add(
            $objs, {
                entry => [{
                        title      => 'new entry',
                        basename   => 'new_entry',
                        status     => 'publish',
                        categories => [qw(cat_clip)],
                    }, {
                        title      => 'new entry2',
                        basename   => 'new_entry2',
                        status     => 'publish',
                        categories => [qw(cat_compass)],
                    }
                ],
                content_data => {
                    cd => {
                        content_type => 'ct',
                        identifier   => 'new_cd',
                        data         => {
                            cf_single_line_text => 'new content data',
                            cf_catset           => [qw(cat_peach)],
                        },
                    },
                    cd2 => {
                        content_type => 'ct',
                        identifier   => 'new_cd2',
                        data         => {
                            cf_single_line_text => 'new content data2',
                            cf_catset           => [qw(cat_orange)],
                        },
                    },
                },
            },
        );

        MT->publisher->rebuild(BlogID => $site->id);

        $test_env->ls;

        ok -f $new_entry,  "new entry does exist";
        ok -f $new_entry2, "new entry2 does exist";
        ok -f $new_cd,     "new cd does exist";
        ok -f $new_cd2,    "new cd2 does exist";

        ok -f $cat_clip,    "cat clip does exist";
        ok -f $cat_compass, "cat compass does exist";
        ok -f $cat_peach,   "cat peach does exist";
        ok -f $cat_orange,  "cat orange does exist";
    };

    subtest 'delete one of the entries' => sub {
        for my $retry (0, 1) {
            if ($retry) {
                sleep 1;
                MT->publisher->rebuild(BlogID => $site->id);
            } else {
                my $entry = $objs->{entry}{new_entry};
                my $app   = MT::Test::App->new;
                $app->login($admin);
                $app->get_ok({
                    __mode  => 'view',
                    _type   => 'entry',
                    blog_id => $site->id,
                    id      => $entry->id,
                });

                sleep 1;

                $app->post_form_ok({
                    __mode => 'delete',
                });

            }
            # $test_env->ls;
        }

        ok !-f $new_entry, "new entry is gone anyway";
        ok -f $new_entry2, "new entry2 does exist";
        ok -f $new_cd,     "new cd does exist";
        ok -f $new_cd2,    "new cd2 does exist";

        if ($publish_empty_archive) {
            ok -f $cat_clip, "cat clip still exists";
        } else {
            ok !-f $cat_clip, "cat clip is gone";
        }
        ok -f $cat_compass, "cat compass does exist";
        ok -f $cat_peach,   "cat peach does exist";
        ok -f $cat_orange,  "cat orange does exist";
    };

    subtest 'unpublish one of the entries' => sub {
        for my $retry (0, 1) {
            if ($retry) {
                sleep 1;
                MT->publisher->rebuild(BlogID => $site->id);
            } else {
                my $entry = $objs->{entry}{new_entry2};
                my $app   = MT::Test::App->new;
                $app->login($admin);
                $app->get_ok({
                    __mode  => 'view',
                    _type   => 'entry',
                    blog_id => $site->id,
                    id      => $entry->id,
                });

                sleep 1;

                require MT::EntryStatus;
                my $form   = $app->form;
                my $status = $form->find_input('status', 'option');
                $status->value(MT::EntryStatus::HOLD());

                $app->post_ok($form->click);
            }
            # $test_env->ls;
        }

        ok !-f $new_entry,  "new entry is already gone";
        ok !-f $new_entry2, "new entry2 is gone anyway";
        ok -f $new_cd,      "new cd does exist";
        ok -f $new_cd2,     "new cd2 does exist";

        if ($publish_empty_archive) {
            ok -f $cat_clip,    "cat clip still exists";
            ok -f $cat_compass, "cat compass still exists";
        } else {
            ok !-f $cat_clip,    "cat clip is already gone";
            ok !-f $cat_compass, "cat compass is gone";
        }
        ok -f $cat_peach,  "cat peach does exist";
        ok -f $cat_orange, "cat orange does exist";
    };

    subtest 'delete one of the content data' => sub {
        for my $retry (0, 1) {
            if ($retry) {
                sleep 1;
                MT->publisher->rebuild(BlogID => $site->id);
            } else {
                my $cd  = $objs->{content_data}{cd};
                my $app = MT::Test::App->new;
                $app->login($admin);
                $app->get_ok({
                    __mode          => 'view',
                    _type           => 'content_data',
                    content_type_id => $cd->content_type_id,
                    blog_id         => $site->id,
                    id              => $cd->id,
                });

                sleep 1;

                $app->post_form_ok({
                    __mode => 'delete',
                });

            }
            # $test_env->ls;
        }

        ok !-f $new_entry,  "new entry is already gone";
        ok !-f $new_entry2, "new entry2 is already gone";
        ok !-f $new_cd,     "new cd is gone anyway";
        ok -f $new_cd2,     "new cd2 does exist";

        if ($publish_empty_archive) {
            ok -f $cat_clip,    "cat clip stil exists";
            ok -f $cat_compass, "cat compass still exists";
            ok -f $cat_peach,   "cat peach still exists";
        } else {
            ok !-f $cat_clip,    "cat clip is already gone";
            ok !-f $cat_compass, "cat compass is already gonet";
            ok !-f $cat_peach,   "cat peach is gone";
        }
        ok -f $cat_orange, "cat orange does exist";
    };

    subtest 'unpublish one of the content data' => sub {
        for my $retry (0, 1) {
            if ($retry) {
                sleep 1;
                MT->publisher->rebuild(BlogID => $site->id);
            } else {
                my $cd  = $objs->{content_data}{cd2};
                my $app = MT::Test::App->new;
                $app->login($admin);
                $app->get_ok({
                    __mode          => 'view',
                    _type           => 'content_data',
                    content_type_id => $cd->content_type_id,
                    blog_id         => $site->id,
                    id              => $cd->id,
                });

                sleep 1;

                require MT::ContentStatus;
                my $form   = $app->form;
                my $status = $form->find_input('status', 'option');
                $status->value(MT::ContentStatus::HOLD());

                $app->post_ok($form->click);

            }
            # $test_env->ls;
        }

        ok !-f $new_entry,  "new entry is already gone";
        ok !-f $new_entry2, "new entry2 is already gone";
        ok !-f $new_cd,     "new cd is already gone";
        ok !-f $new_cd2,    "new cd2 is gone anyway";

        if ($publish_empty_archive) {
            ok -f $cat_clip,    "cat clip still exists";
            ok -f $cat_compass, "cat compass still exists";
            ok -f $cat_peach,   "cat peach still exists";
            ok -f $cat_orange,  "cat orange still exists";
        } else {
            ok !-f $cat_clip,    "cat clip is already gone";
            ok !-f $cat_compass, "cat compass is already gone";
            ok !-f $cat_peach,   "cat peach is already gone";
            ok !-f $cat_orange,  "cat orange is gone";
        }
    };
}

done_testing;
