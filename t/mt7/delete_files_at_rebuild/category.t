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

my $category1 = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    label   => 'category1',
);

my $category2 = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    label   => 'category2',
);

# Mapping
my $tmpl_individual = MT::Test::Permission->make_template(
    blog_id => $blog_id,
    name    => 'Individual',
    type    => 'individual',
    text    => 'individual',
);
my $map_individual = MT::Test::Permission->make_templatemap(
    template_id   => $tmpl_individual->id,
    blog_id       => $blog_id,
    archive_type  => 'Individual',
    file_template => '%y/%m/%-f',
    is_preferred  => 1,
);

my $tmpl_archive = MT::Test::Permission->make_template(
    blog_id => $blog_id,
    name    => 'Category Test',
    type    => 'archive',
    text    => 'test',
);
my $map_category = MT::Test::Permission->make_templatemap(
    template_id   => $tmpl_archive->id,
    blog_id       => $blog_id,
    archive_type  => 'Category',
    file_template => '%c/%f',
    is_preferred  => 1,
);

my $blog = MT::Blog->load($blog_id);
$blog->site_path( $test_env->root . '/site' );
$blog->archive_path( join "/", $test_env->root, "site/archive" );
$blog->save;

subtest 'create entry' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save_entry',
            _type                   => 'entry',
            author_id               => $author->id,
            blog_id                 => $blog_id,
            return_args      => "__mode=view&_type=entry&blog_id=$blog_id",
            save_revision    => 1,
            entry_prefs      => 'Default',
            custom_prefs     => [qw( tags category feedback assets )],
            title            => 'entry1',
            convert_breaks   => 'richtext',
            text             => '<p>test entry</p>',
            text_more        => '',
            status           => 2,
            authored_on_date => '2018-08-31',
            authored_on_time => '00:00:00',
            basename         => 'entry1',
            'add_category_id_' . $category1->id => 'on',
            category_ids                        => $category1->id,
        },
    );
    delete $app->{__test_output};

    ok -e File::Spec->catfile( $blog->archive_path, 'category1/index.html' );

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

subtest 'update entry (change category)' => sub {
    my $entry1
        = MT->model('entry')
        ->load( { blog_id => $blog_id, title => 'entry1' } )
        or die;
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save_entry',
            _type                   => 'entry',
            id                      => $entry1->id,
            author_id               => $author->id,
            blog_id                 => $blog_id,
            return_args => "__mode=view&_type=entry&blog_id=$blog_id&id="
                . $entry1->id,
            save_revision    => 1,
            entry_prefs      => 'Default',
            custom_prefs     => [qw( tags category feedback assets )],
            title            => 'entry1',
            convert_breaks   => 'richtext',
            text             => '<p>test entry</p>',
            text_more        => '',
            old_status       => 2,
            status           => 2,
            authored_on_date => '2018-08-31',
            authored_on_time => '00:00:00',
            basename         => 'entry1',
            'add_category_id_' . $category2->id => 'on',
            category_ids                        => $category2->id,
        },
    );
    delete $app->{__test_output};

    ok !-e File::Spec->catfile( $blog->archive_path, 'category1/index.html' );
    ok -e File::Spec->catfile( $blog->archive_path, 'category2/index.html' );

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

subtest 'create other entry' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $author,
            __test_follow_redirects => 1,
            __mode                  => 'save_entry',
            _type                   => 'entry',
            author_id               => $author->id,
            blog_id                 => $blog_id,
            return_args      => "__mode=view&_type=entry&blog_id=$blog_id",
            save_revision    => 1,
            entry_prefs      => 'Default',
            custom_prefs     => [qw( tags category feedback assets )],
            title            => 'entry2',
            convert_breaks   => 'richtext',
            text             => '<p>test other entry</p>',
            text_more        => '',
            status           => 2,
            authored_on_date => '2018-10-31',
            authored_on_time => '00:00:00',
            basename         => 'entry2',
            'add_category_id_' . $category2->id => 'on',
            category_ids                        => $category2->id,
        },
    );
    delete $app->{__test_output};

    ok !-e File::Spec->catfile( $blog->archive_path, 'category1/index.html' );
    ok -e File::Spec->catfile( $blog->archive_path, 'category2/index.html' );

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
