use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use File::Spec;
use File::Path;
use Test::Deep qw(cmp_bag);

$test_env->prepare_fixture('db');

my $site_path    = File::Spec->catdir($test_env->root, 'site');
my $archive_path = File::Spec->catdir($test_env->root, 'site/archive');

mkdir $site_path;
mkdir $archive_path;

my $objs = MT::Test::Fixture->prepare({
    author => [qw/author/],
    blog   => [{
        name                  => 'my_blog',
        theme_id              => 'mont-blanc',
        site_path             => $site_path,
        archive_path          => $archive_path,
        publish_empty_archive => 1,
    }],
    category_set => {
        catset_type => [qw/news topic/],
        catset_year => [qw/2018 2019 2020/],
    },
    content_type => {
        ct => [
            cf_category_type => {
                type         => 'categories',
                category_set => 'catset_type',
                options      => { multiple => 1 },
            },
            cf_category_year => {
                type         => 'categories',
                category_set => 'catset_year',
                options      => { multiple => 1 },
            },
        ],
    },
    content_data => {
        first_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20200202000000',
            label        => 'first_cd',
            status       => 'publish',
            data         => {
                cf_category_type => [qw/news topic/],
                cf_category_year => [qw/2020 2019/],
            },
        },
    },
    template => [{
            archive_type => 'ContentType-Category',
            name         => 'tmpl_ct',
            content_type => 'ct',
            text         => 'test',
            mapping      => [{
                file_template => '%-c/%i',
                cat_field     => 'cf_category_type',
                is_preferred  => 1,
            }],
        },
    ],
});

my $admin = MT::Author->load(1);
my $blog  = $objs->{blog}{my_blog};
my $ct    = $objs->{content_type}{ct}{content_type};
my $cd    = $objs->{content_data}{first_cd};

sub get_files {
    my @files;
    $test_env->ls(
        $archive_path,
        sub {
            my $file = shift;
            return unless -f $file;
            my $path = File::Spec->abs2rel($file, $archive_path);
            $path =~ s|\\|/|g if $^O eq 'MSWin32';
            push @files, $path;
        });
    @files;
}

subtest 'publish' => sub {
    my @files = get_files();
    ok !@files, "no files";
    note explain \@files if @files;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $blog->id,
        content_type_id => $ct->id,
        id              => $cd->id,
    });
    my $res = $app->post_form_ok({ status => MT::ContentStatus::RELEASE() });

    @files = get_files();
    my @expected = qw(
        news/index.html
        topic/index.html
    );
    cmp_bag \@files, \@expected, "all files exist";
};

subtest 'unpublish' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $blog->id,
        content_type_id => $ct->id,
        id              => $cd->id,
    });
    my $res = $app->post_form_ok({ status => MT::ContentStatus::HOLD() });

    my @files = get_files();
    my @expected = qw(
        news/index.html
        topic/index.html
    );
    cmp_bag \@files, \@expected, "all the index files still exist even if nothing remains in their categories";
};

subtest 'publish again' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $blog->id,
        content_type_id => $ct->id,
        id              => $cd->id,
    });
    my $res = $app->post_form_ok({ status => MT::ContentStatus::RELEASE() });

    my @files = get_files();
    my @expected = qw(
        news/index.html
        topic/index.html
    );
    cmp_bag \@files, \@expected, "all the files still exist";
};

subtest 'unpublish after disabling publish_empty_archive' => sub {
    $blog->publish_empty_archive(0);
    $blog->save;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $blog->id,
        content_type_id => $ct->id,
        id              => $cd->id,
    });
    my $res = $app->post_form_ok({ status => MT::ContentStatus::HOLD() });

    my @files = get_files();
    my @expected = qw();
    cmp_bag \@files, \@expected, "all the index files are gone now";
};

subtest 'publish again' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $blog->id,
        content_type_id => $ct->id,
        id              => $cd->id,
    });
    my $res = $app->post_form_ok({ status => MT::ContentStatus::RELEASE() });

    my @files = get_files();
    my @expected = qw(
        news/index.html
        topic/index.html
    );
    cmp_bag \@files, \@expected, "all the files still exist";
};

subtest 'publish everything again' => sub {
    $blog->publish_empty_archive(1);
    $blog->save;

    rmtree($site_path);
    mkpath($site_path);

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    $app->get_ok({
        __mode  => 'rebuild_confirm',
        blog_id => $blog->id,
    });
    my $res = $app->post_form_ok({});

    my @files = get_files();
    my @expected = qw(
        news/index.html
        topic/index.html
    );
    cmp_bag \@files, \@expected, "all the files still exist";
};

done_testing;
