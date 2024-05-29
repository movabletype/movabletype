use strict;
use warnings;
use FindBin ();
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
use MT::Test ();
use MT::Test::App;
use MT::Test::Fixture;
use MT::Test::Fixture::ContentData;

$test_env->prepare_fixture('db');

my $spec = MT::Test::Fixture::ContentData->fixture_spec;

$spec->{template} = [{
        name    => 'tmpl_cdsearch',
        outfile => 'cdsearch.html',
        type    => 'index',
        text    => <<'TMPL',
<!doctype html>
<html>
<head><title>cd search</title></head>
<body>
  <form method="get" id="search" action="<$mt:CGIPath$><$mt:ContentDataSearchScript$>">
    <button type="submit" name="button" class="searchBtn"></button>

    <input type="text" name="search" value="<MTIfStatic><mt:IfStraightSearch><$mt:SearchString$></mt:IfStraightSearch></MTIfStatic>" class="searchWord">
    <mt:If name="search_results">
    <input type="hidden" name="IncludeBlogs" value="<$mt:SearchIncludeBlogs$>">
    <input type="hidden" name="blog_id" value="<$mt:SiteID$>">
    <input type="hidden" name="SearchContentTypes" value="ct_multi">
    <mt:Else>
    <input type="hidden" name="IncludeBlogs" value="<$mt:SiteID$>">
    <input type="hidden" name="blog_id" value="<$mt:SiteID$>">
    <input type="hidden" name="SearchContentTypes" value="ct_multi">
    </mt:If>
    <input type="hidden" name="limit" value="<$mt:SearchMaxResults$>">
  </form>
</body>
</html>
TMPL
    },
    {
        name       => 'tmpl_cdsearch_results',
        identifier => 'cd_search_results',
        type       => 'cd_search_results',
        text       => <<'TMPL',
<!doctype html>
<html>
<head><title>results</title></head>
<body>
<div id="results">
<mt:SearchResults>
  <div id="cd<mt:ContentID>" class="<mt:ContentLabel>">
    <mt:ContentLabel>
    <mt:ContentFields>[<mt:ContentField><mt:ContentFieldType>: <mt:ContentFieldLabel>: <$mt:ContentFieldValue$></mt:ContentField>]
    </mt:ContentFields>
  </div>
</mt:SearchResults>
</div>
</body>
</html>
TMPL
    }];

$spec->{tag} = [map({ 'tag' . $_ } 1 .. 15), '0'];
for my $i (1..15) {
    $spec->{content_data}{"cd_tag$i"} = {
        content_type => 'ct',
        author       => 'author',
        data         => {
            cf_tags => ["tag$i"],
        },
    };
}

for my $i (1..15) {
    $spec->{image}{"$i.jpg"} = {
        label       => "Sample Image $i",
        description => "Sample photo $i",
    };
    $spec->{content_data}{"cd_image$i"} = {
        content_type  => 'ct',
        author        => 'author',
        data          => {
            cf_image => ["$i.jpg"],
        },
    };
}

$spec->{category_set}{"test category set"} = [map{ "category$_" } 1 .. 15];
for my $i (1..15) {
    $spec->{content_data}{"cd_category$i"} = {
        content_type      => 'ct',
        author            => 'author',
        data              => {
            cf_categories => ["category$i"],
        },
    };
}

my $objs = MT::Test::Fixture->prepare($spec);

my $blog_id       = $objs->{blog_id};
my $ct_id         = $objs->{content_type}{ct}{content_type}->id;
my $ct_name       = $objs->{content_type}{ct}{content_type}->name;
my $ct2_id        = $objs->{content_type}{ct2}{content_type}->id;
my $ct0_id        = $objs->{content_type}{ct0}{content_type}->id;
my $ct_multi_id   = $objs->{content_type}{ct_multi}{content_type}->id;
my $ct_multi_name = $objs->{content_type}{ct_multi}{content_type}->name;

subtest 'everything but 0' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search  => 'test',
        blog_id => $blog_id,
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd cd_multi2 cd_multi cd2/];
};

subtest 'only ct_multi' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search             => 'test',
        blog_id            => $blog_id,
        SearchContentTypes => $ct_multi_id,
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd_multi2 cd_multi/];
};

subtest 'not ct_multi' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search             => 'test',
        blog_id            => $blog_id,
        SearchContentTypes => "NOT $ct_multi_id",
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd cd2/];
};

subtest 'ct or ct_multi' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search             => 'test',
        blog_id            => $blog_id,
        SearchContentTypes => "$ct_id OR $ct_multi_id",
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd cd_multi2 cd_multi/];
};

subtest 'not ct and not ct_multi' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search             => 'test',
        blog_id            => $blog_id,
        SearchContentTypes => "NOT $ct_id AND NOT $ct_multi_id",
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd2/];
};

subtest '(ct or ct_multi)' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search             => 'test',
        blog_id            => $blog_id,
        SearchContentTypes => "($ct_id OR $ct_multi_id)",
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd cd_multi2 cd_multi/];
};

subtest 'string name' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search             => 'test',
        blog_id            => $blog_id,
        SearchContentTypes => qq{"$ct_name"},
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd/];
};

subtest 'OR-ed string names' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search             => 'test',
        blog_id            => $blog_id,
        SearchContentTypes => qq{"$ct_name" OR "$ct_multi_name"},
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd cd_multi2 cd_multi/];
};

subtest 'No uuv with bogus SearchMaxResults' => sub {
    my @warnings;
    local $SIG{__WARN__} = sub { push @warnings, @_ };
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        search             => 'test',
        blog_id            => $blog_id,
        SearchContentTypes => qq{"$ct_name" OR "$ct_multi_name"},
        SearchMaxResults   => 'test',
    });
    ok !@warnings, "no warnings" or note explain \@warnings;
    ok $app->generic_error, "showed an error message: " . $app->generic_error;
};

subtest 'tag field' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        blog_id            => $blog_id,
        SearchContentTypes => qq{"$ct_name"},
        content_field      => 'tags:1',
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd cd_tag1/];
};

subtest 'image field' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        blog_id            => $blog_id,
        SearchContentTypes => qq{"$ct_name"},
        content_field      => 'asset_image:1',
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd_image1/];
};

subtest 'category field' => sub {
    my $app = MT::Test::App->new('MT::App::Search::ContentData');
    $app->get_ok({
        blog_id            => $blog_id,
        SearchContentTypes => qq{"$ct_name"},
        content_field      => 'categories:2',
    });
    my @divs = $app->wq_find('div#results div');
    is_deeply [map { $_->attr('class') } @divs] => [qw/cd cd_category1/];
};

done_testing;
