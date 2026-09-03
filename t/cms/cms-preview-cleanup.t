#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PreviewInNewWindow      => 1,
        TemporaryFileExpiration => 0,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use Web::Query::LibXML;
use File::Path;
use Test::Deep qw(cmp_bag);

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{
        name      => 'my_site',
        theme_id  => 'mont-blanc',
        site_path => 'TEST_ROOT/site',
    }],
    category     => [qw(cat dog)],
    folder       => [qw(foo bar)],
    content_type => {
        ct => {
            fields => [
                title => { type => 'single_line_text' },
            ],
        },
    },
    template => [{
            archive_type => 'Individual',
            name         => 'tmpl_individual',
            text         => <<'TMPL',
<mt:EntryTitle>
TMPL
            mapping => [{
                file_template => 'entry/%c/%f',
                is_preferred  => 1,
            }],
        }, {
            archive_type => 'Page',
            name         => 'tmpl_page',
            text         => <<'TMPL',
<mt:PageTitle>
TMPL
            mapping => [{
                file_template => 'page/%c/%f',
                is_preferred  => 1,
            }],
        }, {
            archive_type => 'ContentType',
            content_type => 'ct',
            name         => 'tmpl_ct',
            text         => <<'TMPL',
<mt:Contents name="ct"><mt:ContentFields><mt:ContentField><mt:ContentFieldLabel>: <mt:ContentFieldValue>
</mt:ContentField></mt:ContentFields></mt:Contents>
TMPL
            mapping => [{
                file_template => 'ct/%y/%f',
                is_preferred  => 1,
            }],
        }, {
            name    => 'tmpl_index',
            outfile => 'tmpl/index.html',
            type    => 'index',
            text    => <<'TMPL',
index template
TMPL
        },
    ],
});

my $admin = MT::Author->load(1);
my $site  = $objs->{website}{my_site};

subtest 'entry' => sub {
    my $cat = $objs->{category}{cat}{ $site->id };
    my $dog = $objs->{category}{dog}{ $site->id };

    rmtree($site->site_path);

    my $app = MT::Test::App->new;
    $app->login($admin);

    for my $run_rpt (0, 1) {
        $app->get_ok({
            __mode  => 'view',
            _type   => 'entry',
            blog_id => $site->id,
        });
        my $form = $app->form;
        $form->value('title' => 'Entry Title');

        # first preview
        {
            my $mode_input = $form->find_input('__mode');
            $mode_input->readonly(0);
            $mode_input->value('preview_entry');

            my $category_ids_input = $form->find_input('category_ids');
            $category_ids_input->readonly(0);
            $category_ids_input->value($cat->id);

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files   = grep /mt-preview/, $test_env->files;
            my $has_cat_preview = grep { m!/cat/mt-preview-.*html! } @preview_files;
            ok $has_cat_preview, "found ../cat/mt-preview... file";
        }

        # second preview
        {
            my $category_ids_input = $form->find_input('category_ids');
            $category_ids_input->readonly(0);
            $category_ids_input->value($dog->id);

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files   = grep /mt-preview/, $test_env->files;
            my $has_cat_preview = grep { m!/entry/cat/mt-preview-.*html! } @preview_files;
            ok $has_cat_preview, "found ../entry/cat/mt-preview... file";

            my $has_dog_preview = grep { m!/entry/dog/mt-preview-.*html! } @preview_files;
            ok $has_dog_preview, "found ../entry/dog/mt-preview... file";
        }

        # both should be removed after saving
        if ($run_rpt) {
            sleep 2;

            _run_rpt();

            my @preview_files = grep /mt-preview/, $test_env->files;
            ok !@preview_files, "no preview files" or note explain \@preview_files;

            my @tfs = MT->model('session')->load({ kind => 'TF' });
            ok !@tfs, "no TF sessions left";
        } else {
            my $mode_input = $form->find_input('__mode');
            $mode_input->readonly(0);
            $mode_input->value('save_entry');

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files = grep /mt-preview/, $test_env->files;
            ok !@preview_files, "no preview files" or note explain \@preview_files;

            my @tfs = MT->model('session')->load({ kind => 'TF' });
            ok !@tfs, "no TF sessions left";
        }
    }
};

subtest 'page' => sub {
    my $foo = $objs->{folder}{foo}{ $site->id };
    my $bar = $objs->{folder}{bar}{ $site->id };

    rmtree($site->site_path);

    my $app = MT::Test::App->new;
    $app->login($admin);

    for my $run_rpt (0, 1) {
        $app->get_ok({
            __mode  => 'view',
            _type   => 'page',
            blog_id => $site->id,
        });
        my $form = $app->form;
        $form->value('title' => 'Page Title');

        # first preview
        {
            my $mode_input = $form->find_input('__mode');
            $mode_input->readonly(0);
            $mode_input->value('preview_entry');

            my $category_ids_input = $form->find_input('category_ids');
            $category_ids_input->readonly(0);
            $category_ids_input->value($foo->id);

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error" or die $app->content;

            my @preview_files   = grep /mt-preview/, $test_env->files;
            my $has_foo_preview = grep { m!/page/foo/mt-preview-.*html! } @preview_files;
            ok $has_foo_preview, "found ../page/foo/mt-preview... file";
        }

        # second preview
        {
            my $category_ids_input = $form->find_input('category_ids');
            $category_ids_input->readonly(0);
            $category_ids_input->value($bar->id);

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files   = grep /mt-preview/, $test_env->files;
            my $has_foo_preview = grep { m!/page/foo/mt-preview-.*html! } @preview_files;
            ok $has_foo_preview, "found ../page/foo/mt-preview... file";

            my $has_bar_preview = grep { m!/page/bar/mt-preview-.*html! } @preview_files;
            ok $has_bar_preview, "found ../page/bar/mt-preview... file";
        }

        # both should be removed after saving
        if ($run_rpt) {
            sleep 2;

            _run_rpt();

            my @preview_files = grep /mt-preview/, $test_env->files;
            ok !@preview_files, "no preview files" or note explain \@preview_files;

            my @tfs = MT->model('session')->load({ kind => 'TF' });
            ok !@tfs, "no TF sessions left";
        } else {
            my $mode_input = $form->find_input('__mode');
            $mode_input->readonly(0);
            $mode_input->value('save_entry');

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files = grep /mt-preview/, $test_env->files;
            ok !@preview_files, "no preview files" or note explain \@preview_files;

            my @tfs = MT->model('session')->load({ kind => 'TF' });
            ok !@tfs, "no TF sessions left";
        }
    }
};

subtest 'content data' => sub {
    my $ct = $objs->{content_type}{ct}{content_type};
    my $cf = $objs->{content_type}{ct}{content_field}{category};

    rmtree($site->site_path);

    my $app = MT::Test::App->new;
    $app->login($admin);

    for my $run_rpt (0, 1) {
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            type            => 'content_data_' . $ct->id,
            content_type_id => $ct->id,
            blog_id         => $site->id,
        });
        my $form = $app->form;
        $form->value('data_label', 'cd');

        # test with category field does not work as content data relies on the stored primary object category

        # first preview
        {
            my $mode_input = $form->find_input('__mode');
            $mode_input->readonly(0);
            $mode_input->value('preview_content_data');

            my $authored_on_year_input = $form->find_input('authored_on_year');
            my $year                   = $authored_on_year_input->value;

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error" or die $app->content;

            my @preview_files = grep /mt-preview/, $test_env->files;
            my $has_preview   = grep { m!/ct/$year/mt-preview-.*html! } @preview_files;
            ok $has_preview, "found ../ct/$year/mt-preview... file";
        }

        # second preview
        {
            my $authored_on_date_input = $form->find_input('authored_on_date');
            my $authored_on_date       = $authored_on_date_input->value;
            $authored_on_date =~ s/20[0-9][0-9]/2000/;
            $authored_on_date_input->value($authored_on_date);

            my $authored_on_year_input = $form->find_input('authored_on_year');
            my $year                   = $authored_on_year_input->value;
            $authored_on_year_input->value(2000);

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files         = grep /mt-preview/, $test_env->files;
            my $has_this_year_preview = grep { m!/$year/mt-preview-.*html! } @preview_files;
            ok $has_this_year_preview, "found ../ct/$year/mt-preview... file";

            my $has_past_preview = grep { m!/ct/2000/mt-preview-.*html! } @preview_files;
            ok $has_past_preview, "found ../ct/2000/mt-preview... file";
        }

        # both should be removed after saving
        if ($run_rpt) {
            sleep 2;

            _run_rpt();

            my @preview_files = grep /mt-preview/, $test_env->files;
            ok !@preview_files, "no preview files" or note explain \@preview_files;

            my @tfs = MT->model('session')->load({ kind => 'TF' });
            ok !@tfs, "no TF sessions left";
        } else {
            my $mode_input = $form->find_input('__mode');
            $mode_input->readonly(0);
            $mode_input->value('save');

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files = grep /mt-preview/, $test_env->files;
            ok !@preview_files, "no preview files" or note explain \@preview_files;

            my @tfs = MT->model('session')->load({ kind => 'TF' });
            ok !@tfs, "no TF sessions left";
        }
    }
};

subtest 'template' => sub {
    my $tmpl = $objs->{template}{ $site->id }{tmpl_index};

    rmtree($site->site_path);

    my $app = MT::Test::App->new;
    $app->login($admin);

    for my $run_rpt (0, 1) {
        $app->get_ok({
            __mode  => 'view',
            _type   => 'template',
            blog_id => $site->id,
            id      => $tmpl->id,
        });
        my $form = $app->form;

        # first preview
        {
            my $mode_input = $form->find_input('__mode');
            $mode_input->readonly(0);
            $mode_input->value('preview_template');

            my $outfile_input = $form->find_input('outfile');
            $outfile_input->value("tmpl/index.html");

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error" or die $app->content;

            my @preview_files = grep /mt-preview/, $test_env->files;
            my $has_preview   = grep { m!/tmpl/mt-preview-.*html! } @preview_files;
            ok $has_preview, "found ../tmpl/mt-preview... file";
        }

        # second preview
        {
            my $outfile_input = $form->find_input('outfile');
            $outfile_input->value("tmpl/renamed/index.html");

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files        = grep /mt-preview/, $test_env->files;
            my $has_previous_preview = grep { m!/tmpl/mt-preview-.*html! } @preview_files;
            ok $has_previous_preview, "found ../tmpl/mt-preview... file";

            my $has_renamed_preview = grep { m!/tmpl/renamed/mt-preview-.*html! } @preview_files;
            ok $has_renamed_preview, "found ../tmpl/renamed/mt-preview... file";
        }

        # both should be removed after saving
        if ($run_rpt) {
            sleep 2;

            _run_rpt();

            my @preview_files = grep /mt-preview/, $test_env->files;
            ok !@preview_files, "no preview files" or note explain \@preview_files;

            my @tfs = MT->model('session')->load({ kind => 'TF' });
            ok !@tfs, "no TF sessions left";
        } else {
            my $mode_input = $form->find_input('__mode');
            $mode_input->readonly(0);
            $mode_input->value('save');

            $app->post_ok($form->click);
            ok !$app->generic_error, "no generic error";

            my @preview_files = grep /mt-preview/, $test_env->files;
            ok !@preview_files, "no preview files" or note explain \@preview_files;

            my @tfs = MT->model('session')->load({ kind => 'TF' });
            ok !@tfs, "no TF sessions left";
        }
    }
};

done_testing();
