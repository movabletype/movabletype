#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Find;
use File::Path;

use MT::Test::ArchiveType;
use MT::Test::Fixture::ArchiveType;

use MT;
use MT::Template::Context;
my $app = MT->instance;

$test_env->prepare_fixture('db');

my $blog_id = 1;
my $website = $app->model('website')->load($blog_id) or die;
$website->archive_path( $test_env->root . '/site/archive' );
$website->save or die;

my $catset1 = MT::Test::Permission->make_category_set(
    blog_id => $blog_id,
    name    => 'catset1',
);
my $cs1_foo = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset1->id,
    label           => 'foo',
);
my $cs1_bar = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset1->id,
    label           => 'bar',
);
my $cs1_baz = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset1->id,
    label           => 'baz',
);

my $catset2 = MT::Test::Permission->make_category_set(
    blog_id => $blog_id,
    name    => 'catset2',
);
my $cs2_apple = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset2->id,
    label           => 'apple',
);
my $cs2_peach = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset2->id,
    label           => 'peach',
);
my $cs2_orange = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset2->id,
    label           => 'orange',
);

my $ct = MT::Test::Permission->make_content_type( blog_id => $blog_id );
my $cf_cat1 = MT::Test::Permission->make_content_field(
    blog_id            => $blog_id,
    content_type_id    => $ct->id,
    name               => 'cf_cat1',
    related_cat_set_id => $catset1->id,
    type               => 'categories',
);
my $cf_cat2 = MT::Test::Permission->make_content_field(
    blog_id            => $blog_id,
    content_type_id    => $ct->id,
    name               => 'cf_cat2',
    related_cat_set_id => $catset2->id,
    type               => 'categories',
);
my $cf_date = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'cf_date',
    type            => 'date_only',
);
$ct->fields(
    [   {   id      => $cf_cat1->id,
            order   => 1,
            type    => $cf_cat1->type,
            options => {
                category_set => $catset1->id,
                label        => $cf_cat1->name,
                multiple     => 1,
            },
            unique_id => $cf_cat1->unique_id,
        },
        {   id      => $cf_cat2->id,
            order   => 2,
            type    => $cf_cat2->type,
            options => {
                category_set => $catset2->id,
                label        => $cf_cat2->name,
                multiple     => 1,
            },
            unique_id => $cf_cat2->unique_id,
        },
        {   id      => $cf_date->id,
            order   => 3,
            type    => $cf_date->type,
            options => {
                label    => $cf_date->name,
                required => 1,
            },
            uqniue_id => $cf_date->unique_id,
        },
    ]
);
$ct->save or die;

my $cd = MT::Test::Permission->make_content_data(
    authored_on     => '20181203200000',
    blog_id         => $blog_id,
    content_type_id => $ct->id,
);
$cd->data(
    {   $cf_cat1->id => [ $cs1_baz->id,    $cs1_foo->id ],
        $cf_cat2->id => [ $cs2_orange->id, $cs2_apple->id ],
        $cf_date->id => '20251203200000',
    }
);
$cd->save or die;

my $tmpl_ct_archive = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    type            => 'ct_archive',
);
my $map_ct_archive_content_type_daily
    = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Daily',
    blog_id      => $blog_id,
    cat_field_id => $cf_cat1->id,
    file_template => '%-c/%y/%m/%d/%i', # ContentType-Category-Daily's default
    is_preferred  => 1,
    template_id => $tmpl_ct_archive->id,
    );
my $map_ct_archive_content_type_author_monthly
    = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Author-Monthly',
    blog_id      => $blog_id,
    cat_field_id => $cf_cat2->id,
    dt_field_id  => $cf_date->id,
    file_template => '%-c/%y/%m/%i',  # ContentType-Category-Monthly's default
    is_preferred  => 1,
    template_id => $tmpl_ct_archive->id,
    );

subtest 'save content_data' => sub {
    $app->rebuild_content_data( ContentData => $cd ) or die;

    my %expected = _get_expected_hash();

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                    if ( exists $expected{$File::Find::name} ) {
                        $expected{$File::Find::name} = 1;
                    }
                }
            },
            no_chdir => 1,
        },
        $website->archive_path,
    );

    my $no_tested_count = grep { !$expected{$_} } keys %expected;
    is( $no_tested_count, 0, 'all files have been built' );
};

File::Path::rmtree( $website->archive_path ) or die;
MT->request->reset;

subtest 'save & publish template' => sub {

    $app->rebuild(
        BlogID      => $blog_id,
        ArchiveType => 'ContentType-Daily',
        NoIndexes   => 1,
        Limit       => $app->config->EntriesPerRebuild,
        TemplateID  => $tmpl_ct_archive->id,
    ) or die;
    $app->rebuild(
        BlogID      => $blog_id,
        ArchiveType => 'ContentType-Author-Monthly',
        NoIndexes   => 1,
        Limit       => $app->config->EntriesPerRebuild,
        TemplateID  => $tmpl_ct_archive->id,
    ) or die;

    my %expected = _get_expected_hash();

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                    if ( exists $expected{$File::Find::name} ) {
                        $expected{$File::Find::name} = 1;
                    }
                }
            },
            no_chdir => 1,
        },
        $website->archive_path,
    );
    my $no_tested_count = grep { !$expected{$_} } keys %expected;
    is( $no_tested_count, 0, 'all files have been built' );
};

sub _get_expected_hash {
    return
        map { $website->archive_path . $_ => 0 }
        ( '/baz/2018/12/03/index.html', '/orange/2025/12/index.html', );
}

done_testing;

