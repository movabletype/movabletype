#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use File::Find;
use File::Path;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        EntriesPerRebuild    => 5,
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $admin = MT->model('author')->load(1) or die;
$admin->basename('admin');
$admin->save or die;

my $website = MT->model('website')->load(1) or die;
my $website_archive_path = join '/', $test_env->root, 'site', 'archive';
$website->archive_path($website_archive_path);
$website->theme_id('classic_website');
$website->save or die;

my $ct1 = MT::Test::Permission->make_content_type( blog_id => $website->id );
my $ct2 = MT::Test::Permission->make_content_type( blog_id => $website->id );
my $ct3 = MT::Test::Permission->make_content_type( blog_id => $website->id );

my $cd1_ct1 = MT::Test::Permission->make_content_data(
    authored_on     => '20181128181600',
    blog_id         => $website->id,
    content_type_id => $ct1->id,
    identifier      => 'cd1_ct1',
    label           => 'cd1_ct1',
);

my $cd1_ct2 = MT::Test::Permission->make_content_data(
    authored_on     => '20201128181600',
    blog_id         => $website->id,
    content_type_id => $ct2->id,
    identifier      => 'cd1_ct2',
    label           => 'cd1_ct2',
);
my $cd2_ct2 = MT::Test::Permission->make_content_data(
    authored_on     => '20221128181600',
    blog_id         => $website->id,
    content_type_id => $ct2->id,
    identifier      => 'cd2_ct2',
    label           => 'cd2_ct2',
);

my $cd_ct3_authored_on = 20241128181600;    # 20_241_128_181_600
my @cd_ct3;

for my $count ( 1 .. 11 ) {
    my $cd_label = "cd${count}_ct3";
    my $cd       = MT::Test::Permission->make_content_data(
        authored_on     => $cd_ct3_authored_on,
        blog_id         => $website->id,
        content_type_id => $ct3->id,
        identifier      => $cd_label,
        label           => $cd_label,
    );
    push @cd_ct3, $cd;
    $cd_ct3_authored_on += 20_000_000_000;
}

my $tmpl_ct1 = MT::Test::Permission->make_template(
    blog_id         => $website->id,
    content_type_id => $ct1->id,
);
my $tmpl_ct1_listing = MT::Test::Permission->make_template(
    blog_id         => $website->id,
    content_type_id => $ct1->id,
);
my $map_ct_ct1 = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType',
    blog_id      => $website->id,
    template_id  => $tmpl_ct1->id,
);
my $map_ct_daily_ct1 = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Daily',
    blog_id      => $website->id,
    template_id  => $tmpl_ct1_listing->id,
);

my $tmpl_ct2 = MT::Test::Permission->make_template(
    blog_id         => $website->id,
    content_type_id => $ct2->id,
);
my $tmpl_ct2_listing = MT::Test::Permission->make_template(
    blog_id         => $website->id,
    content_type_id => $ct2->id,
);
my $map_ct_ct2 = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType',
    blog_id      => $website->id,
    template_id  => $tmpl_ct2->id,
);
my $map_ct_author_monthly_ct2 = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Author-Monthly',
    blog_id      => $website->id,
    template_id  => $tmpl_ct2_listing->id,
);

my $tmpl_ct3 = MT::Test::Permission->make_template(
    blog_id         => $website->id,
    content_type_id => $ct3->id,
);
my $tmpl_ct3_listing = MT::Test::Permission->make_template(
    blog_id         => $website->id,
    content_type_id => $ct3->id,
);
my $map_ct_ct3 = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType',
    blog_id      => $website->id,
    template_id  => $tmpl_ct3->id,
);
my $map_ct_author_ct3 = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Author',
    blog_id      => $website->id,
    template_id  => $tmpl_ct3_listing->id,
);
my $map_ct_yearly_ct3 = MT::Test::Permission->make_templatemap(
    archive_type => 'ContentType-Yearly',
    blog_id      => $website->id,
    template_id  => $tmpl_ct3_listing->id,
);

subtest 'ct1' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $admin,
            __test_follow_redirects => 1,
            __mode                  => 'publish_ct_templates',
            type                    => 'template',
            blog_id                 => $website->id,
            id => [ $tmpl_ct1->id, $tmpl_ct1_listing->id ],
        }
    );
    delete $app->{__test_output};
    my $file_count = 0;
    File::Find::find(
        {   no_chdir => 1,
            wanted   => sub {
                if ( -f $File::Find::name ) {
                    note $File::Find::name ;
                    $file_count++;
                }
            },
        },
        $website_archive_path,
    );
    ok( -f "$website_archive_path/2018/11/cd1-ct1.html",
        'cd1-ct1.html exists' );
    ok( -f "$website_archive_path/2018/11/28/index.html",
        'ContentType-Daily archive exists' );
    is( $file_count, 2, 'Build files only for ct1' );

    is( File::Path::rmtree($website_archive_path),
        6, 'Remove files and directories' );
};

subtest 'ct2' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $admin,
            __test_follow_redirects => 1,
            type                    => 'template',
            blog_id                 => $website->id,
            id      => [ $tmpl_ct1->id, $tmpl_ct1_listing->id ],
            __mode  => 'publish_ct_templates',
            type    => 'template',
            blog_id => $website->id,
            id      => [ $tmpl_ct2->id, $tmpl_ct2_listing->id ],
        },
    );
    delete $app->{__test_output};
    my $file_count = 0;
    File::Find::find(
        {   no_chdir => 1,
            wanted   => sub {
                note $File::Find::name ;
                if ( -f $File::Find::name ) {
                    $file_count++;
                }
            },
        },
        $website_archive_path,
    );
    ok( -f "$website_archive_path/2020/11/cd1-ct2.html",
        'cd1-ct2.html exists' );
    ok( -f "$website_archive_path/2022/11/cd2-ct2.html",
        'cd2-ct2.html exists' );
    ok( -f "$website_archive_path/author/admin/2020/11/index.html",
        'ContentType-Author-Monthly archive exists' );
    ok( -f "$website_archive_path/author/admin/2022/11/index.html",
        'ContentType-Author-Monthly archive exists' );
    is( $file_count, 4, 'Build files only for ct2' );

    is( File::Path::rmtree($website_archive_path),
        15, 'Remove files and directories' );
};

subtest 'ct3' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $admin,
            __test_follow_redirects => 1,
            __mode                  => 'publish_ct_templates',
            type                    => 'template',
            blog_id                 => $website->id,
            id => [ $tmpl_ct3->id, $tmpl_ct3_listing->id ],
        },
    );
    delete $app->{__test_output};
    my $file_count = 0;
    File::Find::find(
        {   no_chdir => 1,
            wanted   => sub {
                note $File::Find::name ;
                if ( -f $File::Find::name ) {
                    $file_count++;
                }
            },
        },
        $website_archive_path,
    );

    my $year  = 2024;
    my $count = 1;
    for my $cd (@cd_ct3) {
        ok( -f "$website_archive_path/$year/11/cd$count-ct3.html",
            "cd$count-ct3.html exists" );
        ok( -f "$website_archive_path/$year/index.html",
            "ContentType-Yearly archive exists"
        );
        $year += 2;
        $count++;
    }
    ok( -f "$website_archive_path/author/admin/index.html",
        "ContentType-Author archive exists" );
    is( $file_count, scalar(@cd_ct3) * 2 + 1, 'Build files only for ct3' );

    is( File::Path::rmtree($website_archive_path),
        48, 'Remove files and directories' );
};

subtest 'ct1 and ct2' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $admin,
            __test_follow_redirects => 1,
            __mode                  => 'publish_ct_templates',
            __mode                  => 'publish_ct_templates',
            type                    => 'template',
            blog_id                 => $website->id,
            id                      => [
                $tmpl_ct1->id, $tmpl_ct1_listing->id,
                $tmpl_ct2->id, $tmpl_ct2_listing->id
            ],
        },
    );
    delete $app->{__test_output};
    my $file_count = 0;
    File::Find::find(
        {   no_chdir => 1,
            wanted   => sub {
                note $File::Find::name ;
                if ( -f $File::Find::name ) {
                    $file_count++;
                }
            },
        },
        $website_archive_path,
    );
    ok( -f "$website_archive_path/2018/11/cd1-ct1.html",
        'cd1-ct1.html exists' );
    ok( -f "$website_archive_path/2018/11/28/index.html",
        'ContentType-Daily archive exists' );
    ok( -f "$website_archive_path/2020/11/cd1-ct2.html",
        'cd1-ct2.html exists' );
    ok( -f "$website_archive_path/2022/11/cd2-ct2.html",
        'cd2-ct2.html exists' );
    ok( -f "$website_archive_path/author/admin/2020/11/index.html",
        'ContentType-Author-Monthly archive exists' );
    ok( -f "$website_archive_path/author/admin/2022/11/index.html",
        'ContentType-Author-Monthly archive exists' );
    is( $file_count, 6, 'Build file only for ct1 and ct2' );

    is( File::Path::rmtree($website_archive_path),
        20, 'Remove files and directories' );
};

done_testing;

