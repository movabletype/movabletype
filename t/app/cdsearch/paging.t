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

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare(
    {   author       => [qw/author/],
        website      => [ { name => 'My Site', theme_id => 'mont-blanc' } ],
        content_type => { ct => [ cf_text => 'single_line_text' ] },
        content_data => {
            (   map {
                    (   "cd$_" => {
                            content_type => 'ct',
                            author       => 'author',
                            authored_on  => '20200202000000',
                            label        => "cd$_",
                            data         => { cf_text => "テスト$_", },
                        },
                    )
                } 1 .. 10
            ),
        },
        template => [
            {   archive_type => 'ContentType',
                name         => 'tmpl_ct',
                content_type => 'ct',
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
  <div>
    <mt:ContentField content_field="cf_text"><$mt:ContentFieldValue$></mt:ContentField>
  </div>
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

subtest 'no paging' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    my $res = $app->get(
        {   search             => 'テスト',
            IncludeBlogs       => $blog_id,
            blog_id            => $blog_id,
            SearchContentTypes => 'ct',
            limit              => 20,
        }
    );
    ok my $html = $res->decoded_content;
    my @found = $html =~ /(テスト[0-9]+)/g;
    is @found => 10;
    my ($footer) = $html =~ m!<div id="footer">(.+?)</div>!s;
    my @links = $footer =~ m!(<a [^>]+></a>)!g;
    ok !@links, 'no footer links';
};

subtest 'page 1' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    my $res = $app->get(
        {   search             => 'テスト',
            IncludeBlogs       => $blog_id,
            blog_id            => $blog_id,
            SearchContentTypes => 'ct',
            limit              => 3,
        }
    );
    ok my $html = $res->decoded_content;
    my @found = $html =~ /(テスト[0-9]+)/g;
    is @found => 3;
    my ($footer) = $html =~ m!<div id="footer">(.+?)</div>!s;
    ok my @links = $footer =~ m!(<a [^>]+>.*?</a>)!g;
    ok $links[0]  !~ /前/, "first link is not a link to the previous page";
    ok $links[-1] =~ /次/, "last link is a link to the next page";
    ok !grep( !/href="[^"]*mt-cdsearch\.cgi/, @links ),
        "no links that don't contain mt-cdsearch.cgi";
};

subtest 'page 2' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    my $res = $app->get(
        {   search             => 'テスト',
            IncludeBlogs       => $blog_id,
            blog_id            => $blog_id,
            SearchContentTypes => 'ct',
            limit              => 3,
            page               => 2,
        }
    );
    ok my $html = $res->decoded_content;
    my @found = $html =~ /(テスト[0-9]+)/g;
    is @found => 3;
    my ($footer) = $html =~ m!<div id="footer">(.+?)</div>!s;
    my @links = $footer =~ m!(<a [^>]+>.*?</a>)!g;
    ok $links[0]  =~ /前/, "first link is a link to the previous page";
    ok $links[-1] =~ /次/, "last link is a link to the next page";
    ok !grep( !/href="[^"]*mt-cdsearch\.cgi/, @links ),
        "no links that don't contain mt-cdsearch.cgi";
};

subtest 'page 4' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    my $res = $app->get(
        {   search             => 'テスト',
            IncludeBlogs       => $blog_id,
            blog_id            => $blog_id,
            SearchContentTypes => 'ct',
            limit              => 3,
            page               => 4,
        }
    );
    ok my $html = $res->decoded_content;
    my @found = $html =~ /(テスト[0-9]+)/g;
    is @found => 1;
    my ($footer) = $html =~ m!<div id="footer">(.+?)</div>!s;
    my @links = $footer =~ m!(<a [^>]+>.*?</a>)!g;
    ok $links[0]  =~ /前/, "first link is a link to the previous page";
    ok $links[-1] !~ /次/, "last link is not a link to the next page";
    ok !grep( !/href="[^"]*mt-cdsearch\.cgi/, @links ),
        "no links that don't contain mt-cdsearch.cgi";
};

done_testing;
