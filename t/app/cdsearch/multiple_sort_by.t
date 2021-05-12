use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use open qw/:std :utf8/;
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use utf8;
use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;
use Test::Deep;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare(
    {   author       => [qw/author/],
        website      => [ { name => 'My Site', theme_id => 'mont-blanc' } ],
        content_type => {
            ct1 => [
                cf_text => 'single_line_text',
                cf_label => 'text_label',
            ],
            ct2 => [
                cf_text => 'single_line_text',
                cf_label => 'text_label',
            ],
            ct3 => [
                cf_text => 'single_line_text',
                cf_label => 'text_label',
            ],
        },
        content_data => {
            cd1_1 => {
                content_type => 'ct1',
                author       => 'author',
                authored_on  => '20210110000000',
                data         => {
                    cf_text => "cd1-1",
                    cf_label => "ct1",
                },
            },
            cd1_2 => {
                content_type => 'ct1',
                author       => 'author',
                authored_on  => '20210115000000',
                data         => {
                    cf_text => "cd1-2",
                    cf_label => "ct1",
                },
            },
            cd2_1 => {
                content_type => 'ct2',
                author       => 'author',
                authored_on  => '20210111000000',
                data         => {
                    cf_text => "cd2-1",
                    cf_label => "ct2",
                },
            },
            cd2_2 => {
                content_type => 'ct2',
                author       => 'author',
                authored_on  => '20210113000000',
                data         => {
                    cf_text => "cd2-2",
                    cf_label => "ct2",
                },
            },
            cd3_1 => {
                content_type => 'ct3',
                author       => 'author',
                authored_on  => '20210112000000',
                data         => {
                    cf_text => "cd3-1",
                    cf_label => "ct3",
                },
            },
            cd3_2 => {
                content_type => 'ct3',
                author       => 'author',
                authored_on  => '20210114000000',
                data         => {
                    cf_text => "cd3-2",
                    cf_label => "ct3",
                },
            },
        },
        template => [
            {   archive_type => 'ContentType',
                name         => 'tmpl_ct1',
                content_type => 'ct1',
                type         => 'ct',
                text         => <<'TMPL',
<mt:ContentLabel>
TMPL
                mapping => [ { file_template => 'ct/%y/%m/%-f', }, ],
            },
            {   archive_type => 'ContentType',
                name         => 'tmpl_ct2',
                content_type => 'ct2',
                type         => 'ct',
                text         => <<'TMPL',
<mt:ContentLabel>
TMPL
                mapping => [ { file_template => 'ct/%y/%m/%-f', }, ],
            },
            {   archive_type => 'ContentType',
                name         => 'tmpl_ct3',
                content_type => 'ct3',
                type         => 'ct',
                text         => <<'TMPL',
<mt:ContentLabel>
TMPL
                mapping => [ { file_template => 'ct/%y/%m/%-f', }, ],
            },
            {   name    => 'tmpl_cdsearch',
                outfile => 'cdsearch.html',
                type    => 'index',
                text    => <<'TMPL',
<!doctype html>
<html>
<head><title>cd search</title></head>
<body>
  <form method="get" id="search" action="<$mt:CGIPath$><$mt:ContentDataSearchScript$>">
    <button type="submit" name="button" class="searchBtn"></button>

    <input type="text" name="search" value="<MTIfStatic><mt:IfStraightSearch><$mt:SearchString$></mt:IfStraightSearch></MTIfStatic>" placeholder="キーワードを検索" class="searchWord">
    <mt:If name="search_results">
    <input type="hidden" name="IncludeBlogs" value="<$mt:SearchIncludeBlogs$>">
    <input type="hidden" name="blog_id" value="<$mt:SiteID$>">
    <input type="hidden" name="SearchContentTypes" value="ct">
    <mt:Else>
    <input type="hidden" name="IncludeBlogs" value="<$mt:SiteID$>">
    <input type="hidden" name="blog_id" value="<$mt:SiteID$>">
    <input type="hidden" name="SearchContentTypes" value="ct">
    </mt:If>
    <input type="hidden" name="limit" value="<$mt:SearchMaxResults$>">
  </form>
</body>
</html>
TMPL
            },
            {   name       => 'tmpl_cdsearch_results',
                identifier => 'cd_search_results',
                type       => 'cd_search_results',
                text       => <<'TMPL',
<!doctype html>
<html>
<head><title>results</title></head>
<body>
<mt:SearchResults>
  <div class="cf"><mt:ContentField content_field="cf_text"><$mt:ContentFieldValue$></mt:ContentField></div>
  <mt:SearchResultsFooter>
    <div id="footer">
      <mt:IfPreviousResults><a href="<$mt:PreviousLink$>" rel="prev" onclick="return swapContent(-1);">&lt; 前</a>&nbsp;&nbsp;</mt:IfPreviousResults><mt:PagerBlock><mt:IfCurrentPage><$mt:Var name="__value__"$><mt:Else><a href="<$mt:PagerLink$>"><$mt:Var name="__value__"$></a></mt:IfCurrentPage><mt:Unless name="__last__">&nbsp;</mt:Unless></mt:PagerBlock><mt:IfMoreResults>&nbsp;&nbsp;<a href="<$mt:NextLink$>" rel="next" onclick="return swapContent();">次 &gt;</a></mt:IfMoreResults>
    </div>
  </mt:SearchResultsFooter>
</mt:SearchResults>
</body>
</html>
TMPL
            }
        ],
    }
);

my $blog_id = $objs->{blog_id};

subtest 'no sort' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    my $res = $app->get(
        {   search             => 'cd',
            IncludeBlogs       => $blog_id,
            blog_id            => $blog_id,
            limit              => 20,
        }
    );
    ok my $html = $res->decoded_content;
    my @found;
    $app->wq_find("div.cf")->each(sub { push @found, $_->text });
    cmp_deeply \@found => [qw(
        cd1-2
        cd3-2
        cd2-2
        cd3-1
        cd2-1
        cd1-1
    )];
};

subtest 'sort by text label' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    my $res = $app->get(
        {   search             => 'cd',
            IncludeBlogs       => $blog_id,
            blog_id            => $blog_id,
            limit              => 20,
            SearchSortBy       => 'field:cf_label',
            SearchResultDisplay => 'ascend',
        }
    );
    ok my $html = $res->decoded_content;
    my @found;
    $app->wq_find("div.cf")->each(sub { push @found, $_->text });
    cmp_deeply \@found => [qw(
        cd1-1
        cd1-2
        cd2-1
        cd2-2
        cd3-1
        cd3-2
    )];
note explain \@found;
};

subtest 'sort by ct_id' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    my $res = $app->get(
        {   search             => 'cd',
            IncludeBlogs       => $blog_id,
            blog_id            => $blog_id,
            limit              => 20,
            SearchSortBy       => 'content_type_id,label',
            SearchResultDisplay => 'ascend',
        }
    );
    ok my $html = $res->decoded_content;
    my @found;
    $app->wq_find("div.cf")->each(sub { push @found, $_->text });
    cmp_deeply \@found => [qw(
        cd1-1
        cd1-2
        cd2-1
        cd2-2
        cd3-1
        cd3-2
    )];
note explain \@found;
};

done_testing;
