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
        theme_id     => 'classic_test_website',
        site_path    => 'TEST_ROOT/site',
        archive_path => 'TEST_ROOT/site/archive',
    }],
    blog => [{
        name         => 'Test Child Site',
        theme_id     => 'classic_test_blog',
        site_path    => 'TEST_ROOT/site/child/',
        archive_path => 'TEST_ROOT/site/child/archive',
        parent       => 'Test Site',
    }],
    entry => [{
            basename => 'test_entry',
            title    => 'test entry',
            text     => 'test entry body',
            status   => 'publish',
            website  => 'Test Site',
        }, {
            basename => 'test_child_entry',
            title    => 'test child entry',
            text     => 'test child entry body',
            status   => 'publish',
            blog     => 'Test Child Site',
        }
    ],
    template => [{
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

my $admin = MT::Author->load(1);

MT->publisher->rebuild(BlogID => $parent->id);
MT->publisher->rebuild(BlogID => $child->id);

my $EventType = $ENV{MT_TEST_REBUILD_TRIGGER_EVENT_TYPE} || EVENT_SAVE;

# If an entry/page in the parent is saved, rebuild indices in the child
MT::RebuildTrigger->new(
    blog_id        => $child->id,
    object_type    => TYPE_ENTRY_OR_PAGE,
    action         => ACTION_RI,
    event          => $EventType,
    target         => TARGET_BLOG,
    target_blog_id => $parent->id,
)->save;

# If an entry/page in the child is saved, rebuild indices in the parent
MT::RebuildTrigger->new(
    blog_id        => $parent->id,
    object_type    => TYPE_ENTRY_OR_PAGE,
    action         => ACTION_RI,
    event          => $EventType,
    target         => TARGET_BLOG,
    target_blog_id => $child->id,
)->save;

$test_env->ls;

subtest 'single edit, entry, parent to child' => sub {

    subtest 'If a public entry in the parent is saved and remains public' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $parent->id,
            id      => $entry->id,
        });

        sleep 1 while $mtime + 1 > time;

        $app->post_form_ok({
            text => $entry->text . ' edited',
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is still public";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };

    subtest 'If a public entry in the parent is saved and turns into a draft' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $parent->id,
            id      => $entry->id,
        });

        sleep 1 while $mtime + 1 > time;

        $app->post_form_ok({
            text   => $entry->text . ' draft',
            status => MT::EntryStatus::HOLD(),
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::HOLD(), "entry turns into a draft now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };

    subtest 'If a draft entry in the parent is saved and remains draft' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::HOLD(), "entry is a draft";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $parent->id,
            id      => $entry->id,
        });

        sleep 1 while $mtime + 1 > time;

        $app->post_form_ok({
            text   => $entry->text . ' draft',
            status => MT::EntryStatus::HOLD(),
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::HOLD(), "entry is still a draft";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
    };

    subtest 'If a draft entry in the parent is saved and turns into public' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::HOLD(), "entry is a draft";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $parent->id,
            id      => $entry->id,
        });

        sleep 1 while $mtime + 1 > time;

        $app->post_form_ok({
            text   => $entry->text . ' public',
            status => MT::EntryStatus::RELEASE(),
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry turns into public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };

    subtest 'If a public entry in the parent turns into unpublished' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        # set past unpublished_on directly because Web UI doesn't allow that
        $entry->unpublished_on('20000101000000');
        $entry->save or die $entry->errstr;

        sleep 1 while $mtime + 1 > time;

        MT->publisher->unpublish_past_entries;    # instead of _run_rpt for consistency

        $entry->refresh;
        is $entry->status => MT::EntryStatus::UNPUBLISH(), "entry is unpublished now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_UNPUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }

        # restore the previous state
        $entry->unpublished_on(undef);
        $entry->status(MT::EntryStatus::RELEASE());
        $entry->save or die $entry->errstr;
        MT->publisher->rebuild(BlogID => $child->id);
    };

    subtest 'If a scheduled entry for the future in the parent turns into public' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $parent->id,
            id      => $entry->id,
        });

        # public entry should become draft first to remove the published ones
        $app->post_form_ok({
            text   => $entry->text . ' draft',
            status => MT::EntryStatus::HOLD(),
        });

        $app->post_form_ok({
            text   => $entry->text . ' scheduled',
            status => MT::EntryStatus::FUTURE(),
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::FUTURE(), "entry is scheduled to be public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        sleep 1 while $mtime + 1 > time;

        MT->publisher->publish_future_posts;    # instead of _run_rpt for consistency

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };
};

sub _get_client_param {
    my $app     = shift;
    my ($param) = $app->content =~ /var listClient = new ListClient\((\{.+?\})\)/s;
    $param =~ s/^\s+objectType: objectType,$//;
    $param =~ s/:/=>/g;
    eval $param;
}

subtest 'batch edit, entry, parent to child' => sub {

    subtest 'If a public entry in the parent is bulk-saved and remains public' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $parent->id,
        });

        my $client_param = _get_client_param($app);
        my $res          = $app->post_ok({
            __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'open_batch_editor',
            blog_id     => $parent->id,
            id          => $entry->id,
            magic_token => $client_param->{magicToken},
            return_args => $client_param->{returnArgs},
        });

        sleep 1 while $mtime + 1 > time;

        my $form = $app->form;
        for my $input ($form->inputs) {
            my $name = $input->name or next;
            if ($name =~ /^status_/) {
                $input->value(MT::EntryStatus::RELEASE());
            }
            if ($name =~ /^title_/) {
                $input->value($input->value . ' edited');
            }
            if ($name eq '__mode') {
                $input->readonly(0);
                $input->value('save_entries');
            }
        }
        $app->post_ok($form->click);

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is still public";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };

    subtest 'If a public entry in the parent is bulk-saved and turns into a draft' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $parent->id,
        });

        my $client_param = _get_client_param($app);
        my $res          = $app->post_ok({
            __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'open_batch_editor',
            blog_id     => $parent->id,
            id          => $entry->id,
            magic_token => $client_param->{magicToken},
            return_args => $client_param->{returnArgs},
        });

        sleep 1 while $mtime + 1 > time;

        my $form = $app->form;
        for my $input ($form->inputs) {
            my $name = $input->name or next;
            if ($name =~ /^status_/) {
                $input->value(MT::EntryStatus::HOLD());
            }
            if ($name =~ /^title_/) {
                $input->value($input->value . ' draft');
            }
            if ($name eq '__mode') {
                $input->readonly(0);
                $input->value('save_entries');
            }
        }
        $app->post_ok($form->click);

        $entry->refresh;
        is $entry->status => MT::EntryStatus::HOLD(), "entry turns into a draft now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };

    subtest 'If a draft entry in the parent is bulk-saved and remains draft' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::HOLD(), "entry is a draft";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $parent->id,
        });

        my $client_param = _get_client_param($app);
        my $res          = $app->post_ok({
            __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'open_batch_editor',
            blog_id     => $parent->id,
            id          => $entry->id,
            magic_token => $client_param->{magicToken},
            return_args => $client_param->{returnArgs},
        });

        sleep 1 while $mtime + 1 > time;

        my $form = $app->form;
        for my $input ($form->inputs) {
            my $name = $input->name or next;
            if ($name =~ /^status_/) {
                $input->value(MT::EntryStatus::HOLD());
            }
            if ($name =~ /^title_/) {
                $input->value($input->value . ' draft');
            }
            if ($name eq '__mode') {
                $input->readonly(0);
                $input->value('save_entries');
            }
        }
        $app->post_ok($form->click);

        $entry->refresh;
        is $entry->status => MT::EntryStatus::HOLD(), "entry is still a draft";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
    };

    subtest 'If a draft entry in the parent is bulk-saved and turns into public' => sub {
        my $entry = $objs->{entry}{test_entry};
        is $entry->status => MT::EntryStatus::HOLD(), "entry is a draft";

        my $custom_index = path($test_env->path('site/child/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $parent->id,
        });

        my $client_param = _get_client_param($app);
        my $res          = $app->post_ok({
            __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'open_batch_editor',
            blog_id     => $parent->id,
            id          => $entry->id,
            magic_token => $client_param->{magicToken},
            return_args => $client_param->{returnArgs},
        });

        sleep 1 while $mtime + 1 > time;

        my $form = $app->form;
        for my $input ($form->inputs) {
            my $name = $input->name or next;
            if ($name =~ /^status_/) {
                $input->value(MT::EntryStatus::RELEASE());
            }
            if ($name =~ /^title_/) {
                $input->value($input->value . ' public');
            }
            if ($name eq '__mode') {
                $input->readonly(0);
                $input->value('save_entries');
            }
        }
        $app->post_ok($form->click);

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry turns into public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the child has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the child remains the same";
        }
    };
};

#----------------------------------------

subtest 'single edit, entry, child to parent' => sub {

    subtest 'If a public entry in the child is saved and remains public' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $child->id,
            id      => $entry->id,
        });

        sleep 1 while $mtime + 1 > time;

        $app->post_form_ok({
            text => $entry->text . ' edited',
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is still public";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };

    subtest 'If a public entry in the child is saved and turns into a draft' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $child->id,
            id      => $entry->id,
        });

        sleep 1 while $mtime + 1 > time;

        $app->post_form_ok({
            text   => $entry->text . ' draft',
            status => MT::EntryStatus::HOLD(),
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::HOLD(), "entry turns into a draft now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };

    subtest 'If a draft entry in the child is saved and remains draft' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::HOLD(), "entry is a draft";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $child->id,
            id      => $entry->id,
        });

        sleep 1 while $mtime + 1 > time;

        $app->post_form_ok({
            text   => $entry->text . ' draft',
            status => MT::EntryStatus::HOLD(),
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::HOLD(), "entry is still a draft";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
    };

    subtest 'If a draft entry in the child is saved and turns into public' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::HOLD(), "entry is a draft";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $child->id,
            id      => $entry->id,
        });

        sleep 1 while $mtime + 1 > time;

        $app->post_form_ok({
            text   => $entry->text . ' public',
            status => MT::EntryStatus::RELEASE(),
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry turns into public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };

    subtest 'If a public entry in the child turns into unpublished' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        # set past unpublished_on directly because Web UI doesn't allow that
        $entry->unpublished_on('20000101000000');
        $entry->save or die $entry->errstr;

        sleep 1 while $mtime + 1 > time;

        MT->publisher->unpublish_past_entries;    # instead of _run_rpt for consistency

        $entry->refresh;
        is $entry->status => MT::EntryStatus::UNPUBLISH(), "entry is unpublished now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_UNPUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }

        # restore the previous state
        $entry->unpublished_on(undef);
        $entry->status(MT::EntryStatus::RELEASE());
        $entry->save or die $entry->errstr;
        MT->publisher->rebuild(BlogID => $parent->id);
    };

    subtest 'If a scheduled entry for the future in the child turns into public' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $child->id,
            id      => $entry->id,
        });

        # public entry should become draft first to remove the published ones
        $app->post_form_ok({
            text   => $entry->text . ' draft',
            status => MT::EntryStatus::HOLD(),
        });

        $app->post_form_ok({
            text   => $entry->text . ' scheduled',
            status => MT::EntryStatus::FUTURE(),
        });

        $entry->refresh;
        is $entry->status => MT::EntryStatus::FUTURE(), "entry is scheduled to be public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        sleep 1 while $mtime + 1 > time;

        MT->publisher->publish_future_posts;    # instead of _run_rpt for consistency

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };
};

subtest 'batch edit, entry, child to parent' => sub {

    subtest 'If a public entry in the child is bulk-saved and remains public' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $child->id,
        });

        my $client_param = _get_client_param($app);
        my $res          = $app->post_ok({
            __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'open_batch_editor',
            blog_id     => $child->id,
            id          => $entry->id,
            magic_token => $client_param->{magicToken},
            return_args => $client_param->{returnArgs},
        });

        sleep 1 while $mtime + 1 > time;

        my $form = $app->form;
        for my $input ($form->inputs) {
            my $name = $input->name or next;
            if ($name =~ /^status_/) {
                $input->value(MT::EntryStatus::RELEASE());
            }
            if ($name =~ /^title_/) {
                $input->value($input->value . ' edited');
            }
            if ($name eq '__mode') {
                $input->readonly(0);
                $input->value('save_entries');
            }
        }
        $app->post_ok($form->click);

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is still public";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };

    subtest 'If a public entry in the child is bulk-saved and turns into a draft' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::RELEASE(), "entry is public";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $child->id,
        });

        my $client_param = _get_client_param($app);
        my $res          = $app->post_ok({
            __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'open_batch_editor',
            blog_id     => $child->id,
            id          => $entry->id,
            magic_token => $client_param->{magicToken},
            return_args => $client_param->{returnArgs},
        });

        sleep 1 while $mtime + 1 > time;

        my $form = $app->form;
        for my $input ($form->inputs) {
            my $name = $input->name or next;
            if ($name =~ /^status_/) {
                $input->value(MT::EntryStatus::HOLD());
            }
            if ($name =~ /^title_/) {
                $input->value($input->value . ' draft');
            }
            if ($name eq '__mode') {
                $input->readonly(0);
                $input->value('save_entries');
            }
        }
        $app->post_ok($form->click);

        $entry->refresh;
        is $entry->status => MT::EntryStatus::HOLD(), "entry turns into a draft now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };

    subtest 'If a draft entry in the child is bulk-saved and remains draft' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::HOLD(), "entry is a draft";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $child->id,
        });

        my $client_param = _get_client_param($app);
        my $res          = $app->post_ok({
            __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'open_batch_editor',
            blog_id     => $child->id,
            id          => $entry->id,
            magic_token => $client_param->{magicToken},
            return_args => $client_param->{returnArgs},
        });

        sleep 1 while $mtime + 1 > time;

        my $form = $app->form;
        for my $input ($form->inputs) {
            my $name = $input->name or next;
            if ($name =~ /^status_/) {
                $input->value(MT::EntryStatus::HOLD());
            }
            if ($name =~ /^title_/) {
                $input->value($input->value . ' draft');
            }
            if ($name eq '__mode') {
                $input->readonly(0);
                $input->value('save_entries');
            }
        }
        $app->post_ok($form->click);

        $entry->refresh;
        is $entry->status => MT::EntryStatus::HOLD(), "entry is still a draft";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
    };

    subtest 'If a draft entry in the child is bulk-saved and turns into public' => sub {
        my $entry = $objs->{entry}{test_child_entry};
        is $entry->status => MT::EntryStatus::HOLD(), "entry is a draft";

        my $custom_index = path($test_env->path('site/custom_index.html'));
        my $mtime        = $custom_index->stat->mtime;
        my $html         = $custom_index->slurp;

        my $app = MT::Test::App->new;
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'entry',
            blog_id => $child->id,
        });

        my $client_param = _get_client_param($app);
        my $res          = $app->post_ok({
            __mode      => 'itemset_action',
            _type       => 'entry',
            action_name => 'open_batch_editor',
            blog_id     => $child->id,
            id          => $entry->id,
            magic_token => $client_param->{magicToken},
            return_args => $client_param->{returnArgs},
        });

        sleep 1 while $mtime + 1 > time;

        my $form = $app->form;
        for my $input ($form->inputs) {
            my $name = $input->name or next;
            if ($name =~ /^status_/) {
                $input->value(MT::EntryStatus::RELEASE());
            }
            if ($name =~ /^title_/) {
                $input->value($input->value . ' public');
            }
            if ($name eq '__mode') {
                $input->readonly(0);
                $input->value('save_entries');
            }
        }
        $app->post_ok($form->click);

        $entry->refresh;
        is $entry->status => MT::EntryStatus::RELEASE(), "entry turns into public now";

        my $new_mtime = $custom_index->stat->mtime;
        my $new_html  = $custom_index->slurp;
        if ($EventType == EVENT_SAVE or $EventType == EVENT_PUBLISH) {
            ok $mtime < $new_mtime && $html ne $new_html, "custom_index in the parent has been rebuilt by the trigger";
        } else {
            ok $mtime == $new_mtime && $html eq $new_html, "custom_index in the parent remains the same";
        }
    };
};

done_testing;
