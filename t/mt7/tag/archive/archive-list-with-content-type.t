use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
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
use Path::Tiny;
use utf8;

$test_env->prepare_fixture('db');

my $site_path    = File::Spec->catdir( $test_env->root, 'site' );
my $archive_path = File::Spec->catdir( $test_env->root, 'site/archive' );

mkdir $site_path;
mkdir $archive_path;

my $objs = MT::Test::Fixture->prepare(
    {   author => [qw/author/],
        blog   => [
            {   name         => 'my_blog',
                theme_id     => 'mont-blanc',
                site_path    => $site_path,
                archive_path => $archive_path,
            }
        ],
        content_type => {
            news => [
                cf_text => 'multi_line_text',
            ],
            topics => [
                cf_text => 'multi_line_text',
            ],
        },
        content_data => {
            news2018 => {
                content_type => 'news',
                author       => 'author',
                authored_on  => '20180202000000',
                label        => 'news2018',
                data         => {
                    cf_text => 'news2018 body',
                },
            },
            topics2018 => {
                content_type => 'topics',
                author       => 'author',
                authored_on  => '20180303000000',
                label        => 'topics2018',
                data         => {
                    cf_text => 'topics2018 body',
                },
            },
            topics2017 => {
                content_type => 'topics',
                author       => 'author',
                authored_on  => '20170404000000',
                label        => 'topics2017',
                data         => {
                    cf_text => 'topics2017 body',
                },
            },
        },
        template => [
            {   archive_type => 'ContentType',
                name         => 'tmpl_news',
                content_type => 'news',
                text         => 'test',
                mapping      => [
                    {   file_template => 'news/%y/%m/%-f',
                        is_preferred  => 1,
                    },
                ],
            },
            {   archive_type => 'ContentType',
                name         => 'tmpl_topics',
                content_type => 'topics',
                text         => 'test',
                mapping      => [
                    {   file_template => 'topics/%y/%m/%-f',
                        is_preferred  => 1,
                    },
                ],
            },
            {   archive_type => 'ContentType-Yearly',
                name         => 'tmpl_news_archive',
                content_type => 'news',
                mapping      => [
                    {   file_template => 'news/%y/%i',
                        is_preferred  => 1,
                    },
                ],
                text         => <<'TMPL',
●content_type なし
<mt:ArchiveList type="ContentType-Yearly">
<a href="<mt:ArchiveLink>"><mt:ArchiveDate format="%Y">年</a>
</mt:ArchiveList>

●content_type="ニュース"
<mt:ArchiveList type="ContentType-Yearly"  content_type="news">
<a href="<mt:ArchiveLink>"><mt:ArchiveDate format="%Y">年</a>
</mt:ArchiveList>

●content_type="トピックス"
<mt:ArchiveList type="ContentType-Yearly"  content_type="topics">
<a href="<mt:ArchiveLink>"><mt:ArchiveDate format="%Y">年</a>
</mt:ArchiveList>
TMPL
            },
            {   archive_type => 'ContentType-Yearly',
                name         => 'tmpl_topics_archive',
                content_type => 'topics',
                text         => 'test',
                mapping      => [
                    {   file_template => 'topics/%y/%i',
                        is_preferred  => 1,
                    },
                ],
            },
        ],
    }
);

MT->publisher->rebuild;

my $html = path( $archive_path, 'news/2018/index.html' )->slurp_utf8;
$html =~ s/(?:\r?\n)+/\n/gs;
my $expected = <<"HTML";
●content_type なし
<a href="/nana/archives/news/2018/">2018年</a>
●content_type="ニュース"
<a href="/nana/archives/news/2018/">2018年</a>
●content_type="トピックス"
<a href="/nana/archives/topics/2018/">2018年</a>
<a href="/nana/archives/topics/2017/">2017年</a>
HTML

is $html => $expected or note $html;

done_testing;
