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
$website->site_path( $test_env->root . '/site' );
$website->archive_path( $test_env->root . '/site/archive' );
$website->save or die;

my $catset = MT::Test::Permission->make_category_set( blog_id => $blog_id );
my $cat1 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset->id,
    label           => 'foo',
);
my $cat2 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset->id,
    label           => 'bar',
);
my $cat3 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $catset->id,
    label           => 'baz',
);

my $ct = MT::Test::Permission->make_content_type( blog_id => $blog_id );
my $cf_cat1 = MT::Test::Permission->make_content_field(
    blog_id            => $blog_id,
    content_type_id    => $ct->id,
    name               => 'cf_cat1',
    related_cat_set_id => $catset->id,
    type               => 'categories',
);
my $cf_cat2 = MT::Test::Permission->make_content_field(
    blog_id            => $blog_id,
    content_type_id    => $ct->id,
    name               => 'cf_cat2',
    related_cat_set_id => $catset->id,
    type               => 'categories',
);
my $cf_datetime = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'cf_datetime',
    type            => 'date_and_time',
);
$ct->fields(
    [   {   id      => $cf_cat1->id,
            order   => 1,
            type    => $cf_cat1->type,
            options => {
                category_set => $cf_cat1->id,
                label        => $cf_cat1->name,
            },
            unique_id => $cf_cat1->unique_id,
        },
        {   id      => $cf_cat2->id,
            order   => 2,
            type    => $cf_cat2->type,
            options => {
                category_set => $cf_cat2->id,
                label        => $cf_cat2->name,
            },
            unique_id => $cf_cat2->unique_id,
        },
        {   id        => $cf_datetime->id,
            order     => 3,
            type      => $cf_datetime->type,
            options   => { label => $cf_datetime->name, },
            unique_id => $cf_datetime->unique_id,
        },
    ]
);
$ct->save or die;

my $cd1 = MT::Test::Permission->make_content_data(
    authored_on     => '20181203180700',
    blog_id         => $blog_id,
    content_type_id => $ct->id,
);
$cd1->data(
    {   $cf_cat1->id     => [ $cat1->id ],
        $cf_cat2->id     => [ $cat2->id ],
        $cf_datetime->id => '20180905000000',
    }
);
$cd1->save or die;

my $cd2 = MT::Test::Permission->make_content_data(
    authored_on     => '19981203180700',
    blog_id         => $blog_id,
    content_type_id => $ct->id,
);
$cd2->data(
    {   $cf_cat1->id     => [ $cat1->id ],
        $cf_cat2->id     => [ $cat2->id ],
        $cf_datetime->id => '19980905000000',
    }
);
$cd2->save or die;

my $cd3 = MT::Test::Permission->make_content_data(
    authored_on     => '20381203180700',
    blog_id         => $blog_id,
    content_type_id => $ct->id,
);
$cd3->data(
    {   $cf_cat1->id     => [ $cat1->id ],
        $cf_cat2->id     => [ $cat2->id ],
        $cf_datetime->id => '20380905000000',
    }
);
$cd3->save or die;

my $cd_other_cat = MT::Test::Permission->make_content_data(
    authored_on     => '20281203180700',
    blog_id         => $blog_id,
    content_type_id => $ct->id,
);
$cd_other_cat->data(
    {   $cf_cat1->id     => [ $cat2->id ],
        $cf_cat2->id     => [ $cat3->id ],
        $cf_datetime->id => '20280905000000',
    }
);
$cd_other_cat->save or die;

my $cd_non_next_prev_cat = MT::Test::Permission->make_content_data(
    authored_on     => '20081203180700',
    blog_id         => $blog_id,
    content_type_id => $ct->id,
);
$cd_non_next_prev_cat->data(
    {   $cf_cat1->id     => [ $cat1->id ],
        $cf_cat2->id     => [ $cat2->id ],
        $cf_datetime->id => '20080905000000',
    }
);
$cd_non_next_prev_cat->save or die;

my $tmpl_ct_archive = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    type            => 'ct_archive',
);
my $map_ct_archive_category_daily = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Category-Daily',
    blog_id      => $blog_id,
    cat_field_id => $cf_cat1->id,
    is_preferred => 1,
    template_id  => $tmpl_ct_archive->id,
);
my $map_ct_archive_category_monthly = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Category-Monthly',
    blog_id      => $blog_id,
    cat_field_id => $cf_cat2->id,
    dt_field_id  => $cf_datetime->id,
    is_preferred => 1,
    template_id  => $tmpl_ct_archive->id,
);
my $map_ct_archive_weekly = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Weekly',
    blog_id      => $blog_id,
    cat_field_id => $cf_cat1->id,
    file_template =>
        '%-c/%y/%m/%d-week/%i',    # ContentType-Category-Weekly's default
    is_preferred => 1,
    template_id  => $tmpl_ct_archive->id,
);
my $map_ct_archive_author_yearly = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Author-Yearly',
    blog_id      => $blog_id,
    cat_field_id => $cf_cat2->id,
    dt_field_id  => $cf_datetime->id,
    file_template => '%-c/%y/%i',    # ContentType-Category-Yearly's default
    is_preferred  => 1,
    template_id => $tmpl_ct_archive->id,
);

subtest 'save content_data' => sub {

    $app->rebuild_content_data(
        BuildDependencies => 1,
        ContentData       => $cd1,
    ) or die $app->errstr;

    my @urls = (

        # ContentType-Category-Daily
        '/foo/2008/12/03/index.html',
        '/foo/2038/12/03/index.html',
        '/foo/2018/12/03/index.html',

        # ContentType-Category-Monthly
        '/bar/2008/09/index.html',
        '/bar/2038/09/index.html',
        '/bar/2018/09/index.html',

        # ContentType-Weekly
        '/foo/2008/11/30-week/index.html',
        '/bar/2028/12/03-week/index.html',
        '/foo/2018/12/02-week/index.html',

        # ContentType-Author-Yearly
        '/bar/2008/index.html',
        '/baz/2028/index.html',
        '/bar/2018/index.html',
    );
    my %expected = map { $website->archive_path . $_ => 0 } @urls;

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                    if ( exists $expected{$File::Find::name} ) {
                        $expected{$File::Find::name} = 1;
                    }
                    else {
                        $expected{$File::Find::name} = -1;
                    }
                }
            },
            no_chdir => 1,
        },
        $website->archive_path
    );

    my $no_tested_count = grep { $expected{$_} != 1 } keys %expected;
    is( $no_tested_count, 0, 'all files have been built' );

    my @fileinfo = $app->model('fileinfo')->load( { blog_id => $blog_id } );
    is( @fileinfo, 12, 'there are 12 fileinfoes' );

    for my $url (@urls) {
        is( scalar( grep { $_->url eq $url } @fileinfo ),
            1, "fileinfo: $url" );
    }
};

File::Path::rmtree( $website->archive_path ) or die;
MT->request->reset;
MT::ObjectDriver::Driver::Cache::RAM->clear_cache();

subtest 'save & publish template' => sub {
    my @archive_types = qw(
        ContentType-Category-Daily
        ContentType-Category-Monthly
        ContentType-Weekly
        ContentType-Author-Yearly
    );
    for my $at (@archive_types) {
        $app->rebuild(
            BlogID      => $blog_id,
            ArchiveType => $at,
            NoIndexes   => 1,
            Limit       => $app->config->EntriesPerRebuild,
            TemplateID  => $tmpl_ct_archive->id,
        ) or die $app->errstr;
    }

    my @urls = (

        # ContentType-Category-Daily
        "/foo/2018/12/03/index.html",
        "/foo/2008/12/03/index.html",
        "/foo/2038/12/03/index.html",
        "/bar/2028/12/03/index.html",
        "/foo/1998/12/03/index.html",

        # ContentType-Category-Monthly
        "/bar/2018/09/index.html",
        "/bar/2008/09/index.html",
        "/bar/2038/09/index.html",
        "/baz/2028/09/index.html",
        "/bar/1998/09/index.html",

        # ContentType-Weekly
        "/foo/2018/12/02-week/index.html",
        "/foo/2008/11/30-week/index.html",
        "/bar/2028/12/03-week/index.html",
        "/foo/2038/11/28-week/index.html",
        "/foo/1998/11/29-week/index.html",

        # ContentType-Author-Yearly
        "/bar/2018/index.html",
        "/bar/2008/index.html",
        "/baz/2028/index.html",
        "/bar/2038/index.html",
        "/bar/1998/index.html",

    );
    my %expected = map { $website->archive_path . $_ => 0 } @urls;

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                    if ( exists $expected{$File::Find::name} ) {
                        $expected{$File::Find::name} = 1;
                    }
                    else {
                        $expected{$File::Find::name} = -1;
                    }
                }
            },
            no_chdir => 1,
        },
        $website->archive_path
    );

    my @fileinfo = $app->model('fileinfo')->load( { blog_id => $blog_id } );
    is( @fileinfo, 20, 'there are 20 fileinfoes' );

    for my $url (@urls) {
        is( scalar( grep { $_->url eq $url } @fileinfo ),
            1, "fileinfo: $url" );
    }
};

done_testing;

