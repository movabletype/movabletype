#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(CMSSearchLimit => 3);
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use Test::Deep 'cmp_bag';
use MT::Test::Fixture::SearchReplace;

$test_env->prepare_fixture('search_replace');

my $objs    = MT::Test::Fixture::SearchReplace->load_objs;
my $author  = MT->model('author')->load(1);
my $blog_id = $objs->{blog_id};

subtest 'site dialog in "Site Export"' => sub {

    for my $num (1 .. 27) {
        my $datetime = sprintf('202207040102%02d', $num);
        my $site     = MT::Test::Permission->make_website(
            authored_on => $datetime,
            created_on  => $datetime,
            modified_on => $datetime,
            name        => sprintf("site-%02d-name", $num),
        );
    }

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({
        __mode    => 'dialog_select_website',
        multi     => 1,
        idfield   => 'selected_blog_ids',
        namefield => 'selected_blogs',
        dialog    => 1,
    });
    is $app->modal_title, 'Select Site', 'right title';

    subtest 'ajax initial(reset)' => sub {
        $app->post_ok({
            __mode      => 'dialog_select_website',
            _type       => 'blog',
            search_type => 'website',
            json        => 1,
            dialog      => 1,
            multi       => 1,
            idfield     => 'selected_blog_ids',
            namefield   => 'selected_blogs',
        });
        my ($labels, $pager, $have_more) = search_result_site($app);
        is scalar(@$labels),    25, 'right length';
        is $pager->{limit},     25;
        is $pager->{listTotal}, 28;
        is $pager->{offset},    0;
        is $pager->{rows},      25;
    };

    subtest 'ajax search' => sub {
        $app->post_ok({
            __mode      => 'dialog_select_website',
            _type       => 'blog',
            search_type => 'website',
            json        => 1,
            dialog      => 1,
            multi       => 1,
            idfield     => 'selected_blog_ids',
            namefield   => 'selected_blogs',
            search      => '-name',
        });
        my ($labels, $pager, $have_more) = search_result_site($app);
        is_deeply($labels, ['site-03-name', 'site-02-name', 'site-01-name']);
        is $pager, undef;
    };

    for my $label ('site-27-name', 'site-01-name') {
        subtest qq(ajax search beyond CMSSearchLimit "$label") => sub {
            $app->post_ok({
                __mode      => 'dialog_select_website',
                _type       => 'blog',
                search_type => 'website',
                json        => 1,
                dialog      => 1,
                multi       => 1,
                idfield     => 'selected_blog_ids',
                namefield   => 'selected_blogs',
                search      => $label,
            });
            my ($labels, $pager, $have_more) = search_result_site($app);
            is_deeply($labels, [$label]);
            is $pager, undef;
        };
    }
};

subtest 'content_data' => sub {
    my $ct_id  = $objs->{content_type}{ct}{content_type}->id;
    my $ct_id2 = $objs->{content_type}{ct2}{content_type}->id;
    my $cf_id  = $objs->{content_type}{ct}{content_field}{cf_content_type}->id;
    my $cd_id  = $objs->{content_data}{cd2}->id;
    my $cf_id2 = $objs->{content_type}{ct2}{content_field}{cf_single_line_text}->id;

    for my $num (1 .. 27) {
        my $datetime = sprintf('202207040102%02d', $num);
        my $cd       = MT::Test::Permission->make_content_data(
            authored_on     => $datetime,
            created_on      => $datetime,
            modified_on     => $datetime,
            blog_id         => $blog_id,
            content_type_id => $ct_id2,
            identifier      => sprintf("cd-%02d-id",    $num),
            label           => sprintf("cd-%02d-label", $num),
            data => { $cf_id2 => sprintf("cd-%02d-cf", $num) },
        );
    }

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({
        __mode           => 'dialog_content_data_modal',
        blog_id          => $blog_id,
        content_field_id => $cf_id,
        dialog           => 1,
    });
    is $app->modal_title, 'Choose Content Type', 'right title';
    my @option_names = $app->wq_find('#search_cols option')->text;
    @option_names = map { $_ =~ s/^\s+|\s+$//g; $_ } @option_names;
    cmp_bag(\@option_names, ['Data Label', 'Basename', 'single line text', 'single line text no data', 'number']);
    note explain(\@option_names);

    subtest 'ajax initial' => sub {
        $app->post_ok({
            __mode           => 'dialog_list_content_data',
            offset           => 0,
            blog_id          => $blog_id,
            content_type_id  => $ct_id2,
            can_multi        => 1,
            dialog           => 1,
            dialog_view      => 1,
            json             => 1,
        });
        my ($labels, $pager, $have_more) = search_result_cd($app);
        is scalar(@$labels),    25, 'right length';
        is $pager->{limit},     25;
        is $pager->{listTotal}, 28;
        is $pager->{offset},    0;
        is $pager->{rows},      25;
        is $have_more,          undef;
    };

    subtest 'ajax search' => sub {
        $app->post_ok({
            __mode           => 'dialog_list_content_data',
            offset           => 0,
            blog_id          => $blog_id,
            content_type_id  => $ct_id2,
            can_multi        => 1,
            dialog           => 1,
            dialog_view      => 1,
            json             => 1,
            is_limited       => 1,
            search_cols      => 'label',
            search           => '-label',
        });
        my ($labels, $pager, $have_more) = search_result_cd($app);
        is_deeply($labels, ['cd-27-label', 'cd-26-label', 'cd-25-label']);
        is $pager,              undef;
        is $have_more->{limit}, 3;
    };

    subtest 'ajax search within content field' => sub {
        $app->post_ok({
            __mode           => 'dialog_list_content_data',
            offset           => 0,
            blog_id          => $blog_id,
            content_type_id  => $ct_id2,
            can_multi        => 1,
            dialog           => 1,
            dialog_view      => 1,
            json             => 1,
            is_limited       => 1,
            search_cols      => '__field:'. $cf_id2,
            search           => '-cf',
        });
        my ($labels, $pager, $have_more) = search_result_cd($app);
        is_deeply($labels, ['cd-27-label', 'cd-26-label', 'cd-25-label']);
        is $pager,              undef;
        is $have_more->{limit}, 3;
    };

    for my $label ('cd-27-label', 'cd-01-label') {
        subtest qq(ajax search beyond CMSSearchLimit "$label") => sub {
            $app->post_ok({
                __mode           => 'dialog_list_content_data',
                offset           => 0,
                blog_id          => $blog_id,
                content_type_id  => $ct_id2,
                can_multi        => 1,
                dialog           => 1,
                dialog_view      => 1,
                json             => 1,
                is_limited       => 1,
                search_cols      => 'label',
                search           => $label,
            });
            my ($labels, $pager, $have_more) = search_result_cd($app);
            is_deeply($labels, [$label]);
            is $pager,              undef;
            is $have_more->{limit}, 1;
        };
    }
};

sub search_result_site {
    my $app = shift;
    return search_result($app, 'td.panel-label-tr');
}

sub search_result_cd {
    my $app = shift;
    return search_result($app, 'td.content-data-label');
}

sub search_result {
    my ($app, $label_selector) = @_;
    my $json = MT::Util::from_json($app->content);

    require Web::Query::LibXML;
    my @labels = Web::Query::LibXML->new($json->{html})->find($label_selector)->text;
    @labels = map { $_ =~ s/^\s+|\s+$//g; $_ } @labels;

    note explain({
        labels    => \@labels,
        pager     => $json->{pager},
        have_more => $json->{have_more},
    });

    return \@labels, $json->{pager}, $json->{have_more};
}

done_testing;
