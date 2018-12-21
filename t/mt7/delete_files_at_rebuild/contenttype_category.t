#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_APP}    = 'MT::App::CMS';
}

use File::Find ();

use MT;
use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

my $blog_id = 1;

$test_env->prepare_fixture('db');

my $author = MT->model('author')->load(1) or die;

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content type',
    blog_id => $blog_id,
);
my $ct_id = $ct->id;

my $cf_category = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'categories',
    type            => 'categories',
);

my $cf_datetime = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'datetime',
    type            => 'date_and_time',
);

my $category_set = MT::Test::Permission->make_category_set(
    blog_id => $blog_id,
    name    => 'test category set',
);
my $category1 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category1',
);
my $category2 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category2',
);

$ct->fields(
    [   {   id      => $cf_category->id,
            name    => $cf_category->name,
            options => {
                category_set => $category_set->id,
                label        => $cf_category->name,
            },
            order     => 1,
            type      => $cf_category->type,
            unique_id => $cf_category->unique_id,
        },
        {   id      => $cf_datetime->id,
            name    => $cf_datetime->name,
            options => {
                label    => $cf_datetime->name,
                required => 1,
            },
            order     => 2,
            type      => $cf_datetime->type,
            unique_id => $cf_datetime->unique_id,
        },
    ]
);
$ct->save or die $ct->error;

# Mapping
my $tmpl_ct = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'ContentType Test ct',
    type            => 'ct',
    text            => 'test',
);
my $map_ct = MT::Test::Permission->make_templatemap(
    template_id   => $tmpl_ct->id,
    blog_id       => $blog_id,
    archive_type  => 'ContentType',
    file_template => 'author/%-a/%-f',
    cat_field_id  => $cf_category->id,
    dt_field_id   => $cf_datetime->id,
    is_preferred  => 1,
);

my $tmpl_ct_archive = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'ContentType Test',
    type            => 'ct_archive',
    text            => 'test',
);
my $map_ct_category = MT::Test::Permission->make_templatemap(
    template_id   => $tmpl_ct_archive->id,
    blog_id       => $blog_id,
    archive_type  => 'ContentType-Category',
    file_template => '%c/%f',
    cat_field_id  => $cf_category->id,
    dt_field_id   => $cf_datetime->id,
    is_preferred  => 1,
);

my $blog = MT::Blog->load($blog_id);
$blog->site_path( $test_env->root . '/site' );
$blog->archive_path( join "/", $test_env->root, "site/archive" );
$blog->save;

subtest 'create content_data' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save',
            _type                   => 'content_data',
            return_args =>
                "__mode=view&blog_id=$blog_id&type=content_data_$ct_id&_type=content_data&content_type_id=$ct_id",
            blog_id                             => $blog_id,
            content_type_id                     => $ct_id,
            save_revision                       => 1,
            data_label                          => 'cd1',
            'content-field-' . $cf_category->id => $category1->id,
            'category-' . $cf_category->id      => $category1->id,
            'date-' . $cf_datetime->id          => '2018-08-31',
            'time-' . $cf_datetime->id          => '00:00:00',
            authored_on_date                    => '2017-05-30',
            authored_on_time                    => '16:36:00',
            status                              => 2,
        },
    );
    delete $app->{__test_output};

    ok -e File::Spec->catfile( $blog->archive_path, "category1/index.html" );

    my @finfos = MT::FileInfo->load( { blog_id => $blog_id } );
    is @finfos => 2, "2 FileInfo";

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                }
            },
            no_chdir => 1,
        },
        $blog->archive_path
    );
};

subtest 'update content_data (change date_and_time field)' => sub {
    my $cd1
        = MT->model('content_data')
        ->load( { blog_id => $blog_id, label => 'cd1' } )
        or die;
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save',
            _type                   => 'content_data',
            return_args =>
                "__mode=view&blog_id=$blog_id&type=content_data_$ct_id&_type=content_data&content_type_id=$ct_id&id="
                . $cd1->id,
            id                                  => $cd1->id,
            identifier                          => $cd1->identifier,
            blog_id                             => $blog_id,
            content_type_id                     => $ct_id,
            save_revision                       => 1,
            data_label                          => 'cd1',
            'content-field-' . $cf_category->id => $category1->id,
            'category-' . $cf_category->id      => $category1->id,
            'date-' . $cf_datetime->id          => '2018-10-31',
            'time-' . $cf_datetime->id          => '00:00:00',
            authored_on_date                    => '2017-05-30',
            authored_on_time                    => '16:36:00',
            status                              => 2,
        },
    );
    delete $app->{__test_output};

    ok -e File::Spec->catfile( $blog->archive_path, "category1/index.html" );

    my @finfos = MT::FileInfo->load( { blog_id => $blog_id } );
    is @finfos => 2, "2 FileInfo";

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                }
            },
            no_chdir => 1,
        },
        $blog->archive_path
    );
};

subtest 'create other content_data' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save',
            _type                   => 'content_data',
            return_args =>
                "__mode=view&blog_id=$blog_id&type=content_data_$ct_id&_type=content_data&content_type_id=$ct_id",
            blog_id                             => $blog_id,
            content_type_id                     => $ct_id,
            save_revision                       => 1,
            data_label                          => 'cd2',
            'content-field-' . $cf_category->id => $category1->id,
            'category-' . $cf_category->id      => $category1->id,
            'date-' . $cf_datetime->id          => '2018-12-31',
            'time-' . $cf_datetime->id          => '00:00:00',
            authored_on_date                    => '2017-05-30',
            authored_on_time                    => '16:36:00',
            status                              => 2,
        },
    );
    delete $app->{__test_output};

    ok -e File::Spec->catfile( $blog->archive_path, "category1/index.html" );

    my @finfos = MT::FileInfo->load( { blog_id => $blog_id } );
    is @finfos => 3, "3 FileInfo";

    File::Find::find(
        {   wanted => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name;
                }
            },
            no_chdir => 1,
        },
        $blog->archive_path
    );
};

done_testing;
