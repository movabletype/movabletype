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

    my @sites;

    for my $num (1 .. 27) {
        my $datetime = sprintf('202207040102%02d', $num);
        my $site     = MT::Test::Permission->make_website(
            authored_on => $datetime,
            created_on  => $datetime,
            modified_on => $datetime,
            name        => sprintf("site-%02d-name", $num),
        );
        push @sites, $site;
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

    $_->remove for @sites;

    subtest 'search by falsy strings' => sub {
        my $site1 = MT::Test::Permission->make_website(name => 'test0');
        my $site2 = MT::Test::Permission->make_website(name => 'NOT INTERESTED');
        my @sites = MT::Blog->load({class=> 'website'});
        for (@sites) {
            $_->site_path('/tmp/dummy'); # avoid TEST_ROOT happen to include 0
            $_->save;
        }

        my $app = MT::Test::App->new;
        $app->login($author);

        subtest 'zero' => sub {
            $app->post_ok({
                __mode      => 'dialog_select_website',
                _type       => 'blog',
                search_type => 'website',
                json        => 1,
                dialog      => 1,
                multi       => 1,
                idfield     => 'selected_blog_ids',
                namefield   => 'selected_blogs',
                search      => '0',
            });
            my ($labels, $pager, $have_more) = search_result_site($app);
            is_deeply($labels, ['test0']);
            is $pager, undef;
        };

        $_->remove for ($site1, $site2);
    };
};

{
    my @cds = MT::ContentData->load();
    $_->remove for @cds;
}

subtest 'content data' => sub {

    subtest 'case1' => sub {
        my $ct_id  = $objs->{content_type}{ct}{content_type}->id;
        my $ct_id2 = $objs->{content_type}{ct2}{content_type}->id;
        my $cf_id  = $objs->{content_type}{ct}{content_field}{cf_content_type}->id;
        my $cd_id  = $objs->{content_data}{cd2}->id;
        my $cf_id2 = $objs->{content_type}{ct2}{content_field}{cf_single_line_text}->id;

        my @cds;

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
            push @cds, $cd;
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
            is $pager->{listTotal}, 27;
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
            TODO: {
                local $TODO = q!have_more isn't always given because the search loop may reduce data into less than CMSSearchLimit!;
                is $have_more->{limit}, 3;
            }
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
                is $pager,     undef;
                is $have_more, undef;
            };
        }

        $_->remove for @cds;
    };

    subtest 'various fields' => sub {

        my $cfs = $objs->{content_type}{ct_multi}{content_field};
        my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;

        my $tag1     = MT::Test::Permission->make_tag(name => 'xyz061');
        my $tag2     = MT::Test::Permission->make_tag(name => 'xyz062');
        my $cat1     = MT::Test::Permission->make_category(label => 'xyz071');
        my $cat2     = MT::Test::Permission->make_category(label => 'xyz072');
        my $image_id = $objs->{image}->{'test2.jpg'}->id;

        # create matrix data
        #    |field1  |field2  |field3  |...
        # cd1|xyz01   |        |        |
        # cd2|        |xyz02   |        |
        # cd3|        |        |xyz03   |
        # ...
        my %cf_tests = (
            cf_single_line_text => { value => "xyz01 xyz01",                    search => 'xyz01' },
            cf_multi_line_text  => { value => "xyz02\nxyz02",                   search => 'xyz02' },
            cf_number           => { value => '9992598785499925987854',         search => '25987854' },
            cf_url              => { value => 'https://example.jp/xyz03/xyz03', search => 'xyz03' },
            cf_embedded_text    => { value => 'xyz04 \n xyz04',                 search => 'xyz04' },
            cf_select_box       => { value => [1, 1],                           search => 'abc' },
            cf_radio            => { value => [2, 2],                           search => 'def' },
            cf_checkboxes       => { value => [3, 3],                           search => 'ghi' },
            cf_list             => { value => ['xyz051', 'xyz052', 'unknown'],  search => 'xyz05' },
            cf_tags             => { value => [$tag1->id, $tag2->id],           search => 'xyz06' },
            cf_categories       => { value => [$cat1->id, $cat2->id],           search => 'xyz07' },
            cf_image            => { value => [$image_id],                      search => 'Sample Image' },
        );
        my @cds;
        my $authored_on = 20230612223000;
        for my $field (sort keys %cf_tests) {
            my $cd = MT::Test::Permission->make_content_data(
                authored_on     => $authored_on++,
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                identifier      => $field,
                label           => $field,
                data            => { $cfs->{$field}->id => $cf_tests{$field}->{value} },
            );
            push @cds, $cd;
        }
        push @cds, MT::Test::Permission->make_content_data(
            authored_on     => $authored_on++,
            blog_id         => $blog_id,
            content_type_id => $ct_id,
            identifier      => "label",
            label           => "label-xyz08",
            data            => { $cfs->{cf_single_line_text}->id => "NOT INTERESTED" },
        );
        push @cds, MT::Test::Permission->make_content_data(
            authored_on     => $authored_on++,
            blog_id         => $blog_id,
            content_type_id => $ct_id,
            identifier      => "identifier-xyz09",
            label           => "identifier",
            data            => { $cfs->{cf_single_line_text}->id => "NOT INTERESTED" },
        );

        # make container
        my ($ct_container, $cf_container) = do {
            my $ct = MT::Test::Permission->make_content_type(blog_id => $blog_id, name => 'multi container');
            my $cf = MT::Test::Permission->make_content_field(
                blog_id                 => $blog_id,
                content_type_id         => $ct->id,
                name                    => 'content_type',
                type                    => 'content_type',
                related_content_type_id => $ct->id,
            );
            $ct->fields([{
                id        => $cf->id,
                order     => 1,
                type      => $cf->type,
                name      => $cf->name,
                options   => { label => $cf->name, source => $ct_id },
                unique_id => $cf->unique_id,
            }]);
            $ct->save or die $ct->errstr;
            ($ct, $cf);
        };

        my $app = MT::Test::App->new;
        $app->login($author);
        $app->get_ok({
            __mode           => 'dialog_content_data_modal',
            blog_id          => $blog_id,
            content_field_id => $cf_container->id,
            dialog           => 1,
        });
        is $app->modal_title, 'Choose multi container', 'right title';
        my @option_names = $app->wq_find('#search_cols option')->text;
        @option_names = map { $_ =~ s/^\s+|\s+$//g; $_ } @option_names;
        cmp_bag(\@option_names, ['Data Label', 'Basename', $cf_container->type]);

        subtest 'ajax initial' => sub {
            $app->post_ok({
                __mode           => 'dialog_list_content_data',
                offset           => 0,
                blog_id          => $blog_id,
                content_type_id  => $ct_id,
                can_multi        => 1,
                dialog           => 1,
                dialog_view      => 1,
                json             => 1,
            });
            my ($labels, $pager, $have_more) = search_result_cd($app);
            is scalar(@$labels),    scalar(@cds), 'right length';
            is $pager->{limit},     25;
            is $pager->{listTotal}, scalar(@cds);
            is $pager->{offset},    0;
            is $pager->{rows},      scalar(@cds);
            is $have_more,          undef;
        };

        subtest 'search for label' => sub {
            $app->post_ok({
                __mode          => 'dialog_list_content_data',
                offset          => 0,
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                can_multi       => 1,
                dialog          => 1,
                dialog_view     => 1,
                json            => 1,
                is_limited      => 1,
                search          => 'xyz08',
            });
            my ($labels, $pager, $have_more) = search_result_cd($app);
            is_deeply($labels, ['label-xyz08']);
            is $pager,     undef;
            is $have_more, undef;
        };

        subtest 'search for identifier' => sub {
            $app->post_ok({
                __mode          => 'dialog_list_content_data',
                offset          => 0,
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                can_multi       => 1,
                dialog          => 1,
                dialog_view     => 1,
                json            => 1,
                is_limited      => 1,
                search          => 'xyz09',
            });
            my ($labels, $pager, $have_more) = search_result_cd($app);
            is_deeply($labels, ['identifier']);
            is $pager,     undef;
            is $have_more, undef;
        };

        my %ref_fields =
            map { $_ => 1 } ('cf_categories', 'cf_tags', 'cf_select_box', 'cf_radio', 'cf_checkboxes', 'cf_image');

        for my $field (sort keys %cf_tests) {
            subtest "search for $field" => sub {
                plan skip_all => 'skip for now (MTC-29012)'
                    if MT->config->DisableRegexpSearch && $ref_fields{$field};
                my $search = $cf_tests{$field}->{search};
                my $value  = $cf_tests{$field}->{value};

                $app->post_ok({
                    __mode          => 'dialog_list_content_data',
                    offset          => 0,
                    blog_id         => $blog_id,
                    content_type_id => $ct_id,
                    can_multi       => 1,
                    dialog          => 1,
                    dialog_view     => 1,
                    json            => 1,
                    is_limited      => 1,
                    search          => $search,
                });
                my ($labels, $pager, $have_more) = search_result_cd($app);
                is_deeply($labels, [$field]);
                is $pager,     undef;
                is $have_more, undef;
            };
        }

        subtest 'multiple results in right order' => sub {
            my $cms_search_limit_org = MT->config('CMSSearchLimit');
            $test_env->update_config(CMSSearchLimit => 25);

            $app->post_ok({
                __mode          => 'dialog_list_content_data',
                offset          => 0,
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                can_multi       => 1,
                dialog          => 1,
                dialog_view     => 1,
                json            => 1,
                is_limited      => 1,
                search          => 'xyz',
            });
            my ($labels, $pager, $have_more) = search_result_cd($app);
            my @fields = (
                'identifier',
                'label-xyz08',
                'cf_url',
                'cf_tags',
                'cf_single_line_text',
                'cf_multi_line_text',
                'cf_list',
                'cf_embedded_text',
                'cf_categories',
            );
            @fields = grep { !$ref_fields{$_} } @fields if MT->config->DisableRegexpSearch;
            cmp_bag($labels, [@fields]); # TODO: test also the order by is_deeply. Note the order is not compatible to cms search
            is $pager,     undef;
            is $have_more, undef;

            $test_env->update_config(CMSSearchLimit => $cms_search_limit_org);
        };

        subtest 'no result' => sub {
            $app->post_ok({
                __mode          => 'dialog_list_content_data',
                offset          => 0,
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                can_multi       => 1,
                dialog          => 1,
                dialog_view     => 1,
                json            => 1,
                is_limited      => 1,
                search          => 'xyz9999',
            });
            my ($labels, $pager, $have_more) = search_result_cd($app);
            is_deeply($labels, []);
            is $pager,     undef;
            is $have_more, undef;
        };

        $_->remove for @cds;
    };

    subtest 'search by falsy strings' => sub {
        my $ct_id = $objs->{content_type}{ct}{content_type}->id;
        my $cf_id = $objs->{content_type}{ct}{content_field}{cf_single_line_text}->id;

        my @cds;

        for my $label ('label 0', 'NOT INTERESTED') {
            my $cd = MT::Test::Permission->make_content_data(
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                identifier      => $label,
                label           => $label,
                data            => { $cf_id => '---' },
            );
            push @cds, $cd;
        }

        my $app = MT::Test::App->new;
        $app->login($author);

        subtest 'zero' => sub {

            $app->post_ok({
                __mode          => 'dialog_list_content_data',
                offset          => 0,
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                can_multi       => 1,
                dialog          => 1,
                dialog_view     => 1,
                json            => 1,
                is_limited      => 1,
                search_cols     => 'label',
                search          => '0',
            });
            my ($labels, $pager, $have_more) = search_result_cd($app);
            is_deeply($labels, ['label 0']);
            is $pager, undef;
        };

        subtest 'null string' => sub {

            $app->post_ok({
                __mode          => 'dialog_list_content_data',
                offset          => 0,
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                can_multi       => 1,
                dialog          => 1,
                dialog_view     => 1,
                json            => 1,
                is_limited      => 1,
                search_cols     => 'label',
                search          => '',
            });
            my ($labels, $pager, $have_more) = search_result_cd($app);
            is_deeply($labels, ['label 0', 'NOT INTERESTED']);
            is $pager->{listTotal}, 2;
        };

        $_->remove for (@cds);
    };
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
