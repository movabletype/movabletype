use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test::Fixture;
use MT::RebuildTrigger ':constants';
use MT::Test::App;
use MT::EntryStatus;
use MT::ContentStatus;
use Path::Tiny;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{
        name         => 'Test Site',
        theme_id     => 'classic_website',
        site_path    => 'TEST_ROOT/site',
        archive_path => 'TEST_ROOT/site/archive',
    }],
    blog => [{
        name         => 'Test Child Site',
        theme_id     => 'classic_blog',
        site_path    => 'TEST_ROOT/site/child/',
        archive_path => 'TEST_ROOT/site/child/archive',
        parent       => 'Test Site',
    }],
    content_type => {
        ct => {
            name    => 'ct',
            website => 'Test Site',
            fields  => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
            ],
        },
        child_ct => {
            name   => 'child_ct',
            blog   => 'Test Child Site',
            fields => [
                cf_single_line_text => {
                    type => 'single_line_text',
                    name => 'single line text',
                },
            ],
        },
    },
    content_data => {
        cd => {
            content_type => 'ct',
            website      => 'Test Site',
            data         => {
                cf_single_line_text => 'test single line text',
            },
        },
        child_cd => {
            content_type => 'child_ct',
            blog         => 'Test Child Site',
            data         => {
                cf_single_line_text => 'test child single line text',
            },
        },
    },
    template => [{
            archive_type => 'ContentType',
            name         => 'tmpl_ct',
            content_type => 'ct',
            website      => 'Test Site',
            text         => '<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields>',
            mapping      => [{
                file_template => 'ct/%i',
                is_preferred  => 1,
            }],
        }, {
            archive_type => 'ContentType',
            name         => 'tmpl_child_ct',
            content_type => 'child_ct',
            blog         => 'Test Child Site',
            text         => '<mt:ContentFields><mt:ContentField><mt:ContentFieldValue></mt:ContentField></mt:ContentFields>',
            mapping      => [{
                file_template => 'ct/%i',
                is_preferred  => 1,
            }],
        }, {
            name    => 'tmpl_index',
            website => 'Test Site',
            text    => '<mt:Date format="%Y-%m-%d %H:%M:%S">',
            outfile => 'TEST_ROOT/site/custom_index.html',
            type    => 'index',
        }, {
            name    => 'tmpl_child_index',
            blog    => 'Test Child Site',
            text    => '<mt:Date format="%Y-%m-%d %H:%M:%S">',
            outfile => 'TEST_ROOT/site/child/custom_index.html',
            type    => 'index',
        }
    ],
});

my $parent = $objs->{website}{'Test Site'};
my $child  = $objs->{blog}{'Test Child Site'};

my $ct       = $objs->{content_type}{ct}{content_type};
my $child_ct = $objs->{content_type}{child_ct}{content_type};

my $admin = MT::Author->load(1);

MT->publisher->rebuild(BlogID => $parent->id);
MT->publisher->rebuild(BlogID => $child->id);

my $EventType = $ENV{MT_TEST_REBUILD_TRIGGER_EVENT_TYPE} || EVENT_SAVE;

# If a piece of content data in the parent is saved, rebuild indices in the child
MT::RebuildTrigger->new(
    blog_id        => $child->id,
    object_type    => TYPE_CONTENT_TYPE,
    action         => ACTION_RI,
    event          => $EventType,
    target         => TARGET_BLOG,
    target_blog_id => $parent->id,
    ct_id          => $ct->id,
)->save;

# If a piece of content data in the child is saved, rebuild indices in the parent
MT::RebuildTrigger->new(
    blog_id        => $parent->id,
    object_type    => TYPE_CONTENT_TYPE,
    action         => ACTION_RI,
    event          => $EventType,
    target         => TARGET_BLOG,
    target_blog_id => $child->id,
    ct_id          => $child_ct->id,
)->save;

# Broken case 1
MT::RebuildTrigger->new(
    blog_id        => $child->id,
    object_type    => TYPE_CONTENT_TYPE,
    action         => ACTION_RI,
    event          => $EventType,
    target         => TARGET_BLOG,
    target_blog_id => $parent->id,
)->save;

# Broken case 2
MT::RebuildTrigger->new(
    blog_id        => $parent->id,
    object_type    => TYPE_CONTENT_TYPE,
    action         => ACTION_RI,
    event          => $EventType,
    target         => TARGET_BLOG,
    target_blog_id => $child->id,
)->save;

$test_env->ls;

subtest 'single edit, content data, parent to child' => sub {

    subtest 'If a piece of public content data in the parent is saved and remains public' => sub {
        my $cd = $objs->{content_data}{cd};
        my $cf = $objs->{content_type}{ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $parent->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        sleep 1 while $mtime + 1 > time;

        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' edited');

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is still public";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };

    subtest 'If a piece of public content data in the parent is saved and turns into a draft' => sub {
        my $cd = $objs->{content_data}{cd};
        my $cf = $objs->{content_type}{ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $parent->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        sleep 1 while $mtime + 1 > time;

        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' draft');
        $form->value(status => MT::ContentStatus::HOLD());

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::HOLD(), "content data turns into a draft now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };

    subtest 'If a piece of draft content data in the parent is saved and remains draft' => sub {
        my $cd = $objs->{content_data}{cd};
        my $cf = $objs->{content_type}{ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::HOLD(), "content data is a draft";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $parent->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        sleep 1 while $mtime + 1 > time;

        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' draft');
        $form->value(status => MT::ContentStatus::HOLD());

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::HOLD(), "content data is still a draft";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
    };

    subtest 'If a piece of draft content data in the parent is saved and turns into public' => sub {
        my $cd = $objs->{content_data}{cd};
        my $cf = $objs->{content_type}{ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::HOLD(), "content data is a draft";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $parent->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        sleep 1 while $mtime + 1 > time;

        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' public');
        $form->value(status => MT::ContentStatus::RELEASE());

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::RELEASE(), "content data turns into public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };

    subtest 'If a piece of public content data in the parent turns into unpublished' => sub {
        my $cd = $objs->{content_data}{cd};
        my $cf = $objs->{content_type}{ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        # set past unpublished_on directly because Web UI doesn't allow that
        $cd->unpublished_on('20000101000000');
        $cd->save or die $cd->errstr;

        sleep 1 while $mtime + 1 > time;

        MT->publisher->unpublish_past_contents;    # instead of _run_rpt for consistency

        $cd->refresh;
        is $cd->status => MT::ContentStatus::UNPUBLISH(), "content data is unpublished now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_UNPUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }

        # restore the previous state
        $cd->unpublished_on(undef);
        $cd->status(MT::ContentStatus::RELEASE());
        $cd->save or die $cd->errstr;
        MT->publisher->rebuild(BlogID => $child->id);
    };

    subtest 'If a piece of scheduled content data for the future in the parent turns into public' => sub {
        my $cd = $objs->{content_data}{cd};
        my $cf = $objs->{content_type}{ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public";

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $parent->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        # public content data should become draft first to remove the published ones
        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' draft');
        $form->value(status => MT::ContentStatus::HOLD());

        $app->post_ok($form->click);

        $form  = $app->form;
        $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' scheduled');
        $form->value(status => MT::ContentStatus::FUTURE());

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::FUTURE(), "content data is scheduled to be public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        sleep 1 while $mtime + 1 > time;

        MT->publisher->publish_future_contents;    # instead of _run_rpt for consistency

        $cd->refresh;
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };
};

subtest 'single edit, content data, child to parent' => sub {

    subtest 'If a piece of public content data in the parent is saved and remains public' => sub {
        my $cd = $objs->{content_data}{child_cd};
        my $cf = $objs->{content_type}{child_ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $child->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        sleep 1 while $mtime + 1 > time;

        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' edited');

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is still public";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };

    subtest 'If a piece of public content data in the child is saved and turns into a draft' => sub {
        my $cd = $objs->{content_data}{child_cd};
        my $cf = $objs->{content_type}{child_ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $child->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        sleep 1 while $mtime + 1 > time;

        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' draft');
        $form->value(status => MT::ContentStatus::HOLD());

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::HOLD(), "content data turns into a draft now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };

    subtest 'If a piece of draft content data in the child is saved and remains draft' => sub {
        my $cd = $objs->{content_data}{child_cd};
        my $cf = $objs->{content_type}{child_ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::HOLD(), "content data is a draft";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $child->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        sleep 1 while $mtime + 1 > time;

        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' draft');
        $form->value(status => MT::ContentStatus::HOLD());

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::HOLD(), "content data is still a draft";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
    };

    subtest 'If a piece of draft content data in the child is saved and turns into public' => sub {
        my $cd = $objs->{content_data}{child_cd};
        my $cf = $objs->{content_type}{child_ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::HOLD(), "content data is a draft";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $child->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        sleep 1 while $mtime + 1 > time;

        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' public');
        $form->value(status => MT::ContentStatus::RELEASE());

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::RELEASE(), "content data turns into public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };

    subtest 'If a piece of public content data in the parent turns into unpublished' => sub {
        my $cd = $objs->{content_data}{child_cd};
        my $cf = $objs->{content_type}{child_ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        # set past unpublished_on directly because Web UI doesn't allow that
        $cd->unpublished_on('20000101000000');
        $cd->save or die $cd->errstr;

        sleep 1 while $mtime + 1 > time;

        MT->publisher->unpublish_past_contents;    # instead of _run_rpt for consistency

        $cd->refresh;
        is $cd->status => MT::ContentStatus::UNPUBLISH(), "content data is unpublished now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_UNPUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }

        # restore the previous state
        $cd->unpublished_on(undef);
        $cd->status(MT::ContentStatus::RELEASE());
        $cd->save or die $cd->errstr;
        MT->publisher->rebuild(BlogID => $parent->id);
    };

    subtest 'If a piece of scheduled content data for the future in the child turns into public' => sub {
        my $cd = $objs->{content_data}{child_cd};
        my $cf = $objs->{content_type}{child_ct}{content_field}{cf_single_line_text};
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public";

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            blog_id         => $child->id,
            id              => $cd->id,
            content_type_id => $cd->content_type_id,
        });

        # public content data should become draft first to remove the published ones
        my $form  = $app->form;
        my $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' draft');
        $form->value(status => MT::ContentStatus::HOLD());

        $app->post_ok($form->click);

        $form  = $app->form;
        $input = $form->find_input('content-field-' . $cf->id);
        $input->value($input->value . ' scheduled');
        $form->value(status => MT::ContentStatus::FUTURE());

        $app->post_ok($form->click);

        $cd->refresh;
        is $cd->status => MT::ContentStatus::FUTURE(), "content data is scheduled to be public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        sleep 1 while $mtime + 1 > time;

        MT->publisher->publish_future_contents;    # instead of _run_rpt for consistency

        $cd->refresh;
        is $cd->status => MT::ContentStatus::RELEASE(), "content data is public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };
};

done_testing;
