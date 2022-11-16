# MTC-27944

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
use File::Spec;
use Web::Query::LibXML;

$test_env->prepare_fixture('db');

my $site_path    = File::Spec->catdir($test_env->root, 'site');
my $archive_path = File::Spec->catdir($test_env->root, 'site/archive');

mkdir $site_path;
mkdir $archive_path;

my $objs = MT::Test::Fixture->prepare({
    author => [qw/author/],
    website => [{
        name         => 'my_site',
        theme_id     => 'mont-blanc',
        site_path    => $site_path,
        archive_path => $archive_path,
    }],
    category_set => {
        my_category_set => [qw/aaa bbb ccc/],
    },
    content_type => {
        ct => [
            cf_title          => 'single_line_text',
            my_category_set_a => {
                type         => 'categories',
                category_set => 'my_category_set',
            },
            my_category_set_b => {
                type         => 'categories',
                category_set => 'my_category_set',
            },
        ],
    },
    content_data => {
        first_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20220101000000',
            label        => 'first_cd',
            data         => {
                cf_title          => 'title',
                my_category_set_a => [qw/aaa/],
                my_category_set_b => [qw//],
            },
        },
        second_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20220102000000',
            label        => 'second_cd',
            data         => {
                cf_title          => 'title2',
                my_category_set_a => [qw/aaa/],
                my_category_set_b => [qw/bbb/],
            },
        },
        third_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20220103000000',
            label        => 'third_cd',
            data         => {
                cf_title          => 'title3',
                my_category_set_a => [qw/aaa/],
                my_category_set_b => [qw/ccc/],
            },
        },
        fourth_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20220104000000',
            label        => 'fourth_cd',
            data         => {
                cf_title          => 'title4',
                my_category_set_a => [qw/bbb/],
                my_category_set_b => [qw//],
            },
        },
        fifth_cd => {
            content_type => 'ct',
            author       => 'author',
            authored_on  => '20200202000000',
            label        => 'fifth_cd',
            data         => {
                cf_title          => 'title5',
                my_category_set_a => [qw//],
                my_category_set_b => [qw/bbb/],
            },
        },
    },
    template => [{
            type => 'index',
            name => 'tmpl',
            outfile => 'test.html',
            text => <<'TMPL',
<html>
<body>
<mt:CategorySets name="my_category_set">
<mt:SubCategories top="1">
<p><mt:CategoryLabel></p>
<p class="<mt:CategoryLabel>-a">category A: <mt:CategoryCount content_type="ct" content_field="my_category_set_a"></p>
<p class="<mt:CategoryLabel>-b">category B: <mt:CategoryCount content_type="ct" content_field="my_category_set_b"></p>
</mt:SubCategories>
</mt:CategorySets>
</body>
</html>
TMPL
        },
    ],
});

my $admin = MT::Author->load(1);
my $site  = $objs->{website}{my_site};

MT->publisher->rebuild(BlogID => $site->id);

ok my $html = $test_env->slurp($test_env->path("site/test.html"));

note $html;

my $wq = Web::Query::LibXML->new($html);
is $wq->find('p.aaa-a')->text => 'category A: 3';
is $wq->find('p.aaa-b')->text => 'category B: 0';
is $wq->find('p.bbb-a')->text => 'category A: 1';
is $wq->find('p.bbb-b')->text => 'category B: 2';
is $wq->find('p.ccc-a')->text => 'category A: 0';
is $wq->find('p.ccc-b')->text => 'category B: 1';

done_testing;
