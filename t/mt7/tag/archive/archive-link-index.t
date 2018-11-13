#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::ArchiveType;
use MT::Test::Tag;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

filters {
    archive_type => [qw( chomp )],
    template     => [qw( chomp )],
    expected     => [qw( chomp )],
};

$test_env->prepare_fixture('archive_type');
my $objs    = MT::Test::Fixture::ArchiveType->load_objs;
my $blog_id = $objs->{blog_id};
for my $cd_label ( keys %{ $objs->{content_data} } ) {
    my $key = $cd_label . '_unique_id';
    my $cd  = $objs->{content_data}->{$cd_label};
    MT::Test::Tag->vars->{$key} = $cd->unique_id;
}

my @archive_types = sort MT->publisher->archive_types;
my $archive_types = join ',', @archive_types;

foreach my $archive_type (@archive_types) {
    MT::Test::Tag->run_perl_tests(
        $blog_id,
        sub {
            my ( $ctx, $block ) = @_;
            my $site = $ctx->stash('blog');
            $site->archive_type(
                defined $block->archive_type
                ? $block->archive_type
                : $archive_types
            );
        },
        $archive_type
    );
    MT::Test::Tag->run_php_tests(
        $blog_id,
        sub {
            my ($block) = @_;
            my $archive_type
                = defined $block->archive_type
                ? $block->archive_type
                : $archive_types;
            return <<"PHP";
\$site = \$ctx->stash('blog');
\$site->archive_type = "$archive_type";
\$site->save();
PHP
        },
        $archive_type
    );
}

done_testing;

__END__

=== Some ArchiveTypes with type
--- template
<mt:ArchiveList type="[% archive_type %]"><mt:ArchiveLink type="[% archive_type %]">
</mt:ArchiveList>
--- expected_todo_individual
http://narnia.na/2018/12/entry-author1-ruler-eraser.html
http://narnia.na/2018/12/entry-author1-ruler-eraser-1.html
http://narnia.na/2017/12/entry-author1-compass.html
http://narnia.na/2016/12/entry-author2-pencil-eraser.html
http://narnia.na/2015/12/entry-author2-no-category.html
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26131
--- expected_todo_page
http://narnia.na/page-author2-no-folder.html
http://narnia.na/folder-water/page-author2-water.html
http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-coffee.html
http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-publish.html
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26131
--- expected_daily
http://narnia.na/2018/12/03/
http://narnia.na/2017/12/03/
http://narnia.na/2016/12/03/
http://narnia.na/2015/12/03/
--- expected_weekly
http://narnia.na/2018/12/02-week/
http://narnia.na/2017/12/03-week/
http://narnia.na/2016/11/27-week/
http://narnia.na/2015/11/29-week/
--- expected_monthly
http://narnia.na/2018/12/
http://narnia.na/2017/12/
http://narnia.na/2016/12/
http://narnia.na/2015/12/
--- expected_yearly
http://narnia.na/2018/
http://narnia.na/2017/
http://narnia.na/2016/
http://narnia.na/2015/
--- expected_author
http://narnia.na/author/author1/
http://narnia.na/author/author2/
--- expected_php_todo_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26105
--- expected_author_daily
http://narnia.na/author/author1/2018/12/03/
http://narnia.na/author/author1/2017/12/03/
http://narnia.na/author/author2/2016/12/03/
http://narnia.na/author/author2/2015/12/03/
--- expected_author_weekly
http://narnia.na/author/author1/2018/12/02-week/
http://narnia.na/author/author1/2017/12/03-week/
http://narnia.na/author/author2/2016/11/27-week/
http://narnia.na/author/author2/2015/11/29-week/
--- expected_author_monthly
http://narnia.na/author/author1/2018/12/
http://narnia.na/author/author1/2017/12/
http://narnia.na/author/author2/2016/12/
http://narnia.na/author/author2/2015/12/
--- expected_author_yearly
http://narnia.na/author/author1/2018/
http://narnia.na/author/author1/2017/
http://narnia.na/author/author2/2016/
http://narnia.na/author/author2/2015/
--- expected_category
http://narnia.na/cat-clip/cat-compass/
http://narnia.na/cat-eraser/
http://narnia.na/cat-pencil/
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_category_daily
http://narnia.na/cat-clip/cat-compass/2017/12/03/
http://narnia.na/cat-eraser/2018/12/03/
http://narnia.na/cat-eraser/2016/12/03/
http://narnia.na/cat-pencil/2016/12/03/
http://narnia.na/cat-clip/cat-compass/cat-ruler/2018/12/03/
--- expected_php_todo_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26129
--- expected_category_weekly
http://narnia.na/cat-clip/cat-compass/2017/12/03-week/
http://narnia.na/cat-eraser/2018/12/02-week/
http://narnia.na/cat-eraser/2016/11/27-week/
http://narnia.na/cat-pencil/2016/11/27-week/
http://narnia.na/cat-clip/cat-compass/cat-ruler/2018/12/02-week/
--- expected_php_todo_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26129
--- expected_category_monthly
http://narnia.na/cat-clip/cat-compass/2017/12/
http://narnia.na/cat-eraser/2018/12/
http://narnia.na/cat-eraser/2016/12/
http://narnia.na/cat-pencil/2016/12/
http://narnia.na/cat-clip/cat-compass/cat-ruler/2018/12/
--- expected_php_todo_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26129
--- expected_category_yearly
http://narnia.na/cat-clip/cat-compass/2017/
http://narnia.na/cat-eraser/2018/
http://narnia.na/cat-eraser/2016/
http://narnia.na/cat-pencil/2016/
http://narnia.na/cat-clip/cat-compass/cat-ruler/2018/
--- expected_php_todo_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26129
--- expected_contenttype
http://narnia.na/2018/10/[% cd_same_apple_orange_unique_id %].html
http://narnia.na/2018/10/[% cd_same_same_date_unique_id %].html
http://narnia.na/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
http://narnia.na/2016/10/[% cd_same_peach_unique_id %].html
http://narnia.na/2008/11/[% cd_other_apple_unique_id %].html
http://narnia.na/2006/11/[% cd_other_apple_orange_dog_cat_unique_id %].html
http://narnia.na/2004/11/[% cd_other_all_fruit_rabbit_unique_id %].html
http://narnia.na/2004/11/[% cd_other_same_date_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26128
--- expected_contenttype_author
http://narnia.na/author/author1/
http://narnia.na/author/author2/
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26126
--- expected_contenttype_author_daily
http://narnia.na/author/author1/2018/10/31/
http://narnia.na/author/author1/2017/10/31/
http://narnia.na/author/author1/2004/11/01/
http://narnia.na/author/author2/2016/10/31/
http://narnia.na/author/author2/2008/11/01/
http://narnia.na/author/author2/2006/11/01/
--- expected_contenttype_author_weekly
http://narnia.na/author/author1/2018/10/28-week/
http://narnia.na/author/author1/2017/10/29-week/
http://narnia.na/author/author1/2004/10/31-week/
http://narnia.na/author/author2/2016/10/30-week/
http://narnia.na/author/author2/2008/10/26-week/
http://narnia.na/author/author2/2006/10/29-week/
--- expected_contenttype_author_monthly
http://narnia.na/author/author1/2018/10/
http://narnia.na/author/author1/2017/10/
http://narnia.na/author/author1/2004/11/
http://narnia.na/author/author2/2016/10/
http://narnia.na/author/author2/2008/11/
http://narnia.na/author/author2/2006/11/
--- expected_contenttype_author_yearly
http://narnia.na/author/author1/2018/
http://narnia.na/author/author1/2017/
http://narnia.na/author/author1/2004/
http://narnia.na/author/author2/2016/
http://narnia.na/author/author2/2008/
http://narnia.na/author/author2/2006/
--- expected_php_todo_contenttype_author_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26127
--- expected_contenttype_category
http://narnia.na/cat-apple/
http://narnia.na/cat-strawberry/cat-orange/
http://narnia.na/cat-peach/
http://narnia.na/cat-strawberry/
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26036
https://movabletype.atlassian.net/browse/MTC-26039
https://movabletype.atlassian.net/browse/MTC-26108
--- expected_contenttype_category_daily
http://narnia.na/cat-apple/2008/11/01/
http://narnia.na/cat-apple/2006/11/01/
http://narnia.na/cat-apple/2004/11/01/
http://narnia.na/cat-strawberry/cat-orange/2006/11/01/
http://narnia.na/cat-strawberry/cat-orange/2004/11/01/
http://narnia.na/cat-peach/2004/11/01/
http://narnia.na/cat-strawberry/2004/11/01/
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26038
https://movabletype.atlassian.net/browse/MTC-26039
https://movabletype.atlassian.net/browse/MTC-26107
https://movabletype.atlassian.net/browse/MTC-26118
--- expected_contenttype_category_weekly
http://narnia.na/cat-apple/2008/10/26-week/
http://narnia.na/cat-apple/2006/10/29-week/
http://narnia.na/cat-apple/2004/10/31-week/
http://narnia.na/cat-strawberry/cat-orange/2006/10/29-week/
http://narnia.na/cat-strawberry/cat-orange/2004/10/31-week/
http://narnia.na/cat-peach/2004/10/31-week/
http://narnia.na/cat-strawberry/2004/10/31-week/
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26038
https://movabletype.atlassian.net/browse/MTC-26039
https://movabletype.atlassian.net/browse/MTC-26107
https://movabletype.atlassian.net/browse/MTC-26118
--- expected_contenttype_category_monthly
http://narnia.na/cat-apple/2008/11/
http://narnia.na/cat-apple/2006/11/
http://narnia.na/cat-apple/2004/11/
http://narnia.na/cat-strawberry/cat-orange/2006/11/
http://narnia.na/cat-strawberry/cat-orange/2004/11/
http://narnia.na/cat-peach/2004/11/
http://narnia.na/cat-strawberry/2004/11/
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26038
https://movabletype.atlassian.net/browse/MTC-26039
https://movabletype.atlassian.net/browse/MTC-26107
https://movabletype.atlassian.net/browse/MTC-26118
--- expected_contenttype_category_yearly
http://narnia.na/cat-apple/2008/
http://narnia.na/cat-apple/2006/
http://narnia.na/cat-apple/2004/
http://narnia.na/cat-strawberry/cat-orange/2006/
http://narnia.na/cat-strawberry/cat-orange/2004/
http://narnia.na/cat-peach/2004/
http://narnia.na/cat-strawberry/2004/
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26038
https://movabletype.atlassian.net/browse/MTC-26039
https://movabletype.atlassian.net/browse/MTC-26107
https://movabletype.atlassian.net/browse/MTC-26118
--- expected_contenttype_daily
http://narnia.na/2008/11/01/
http://narnia.na/2006/11/01/
http://narnia.na/2004/11/01/
--- expected_php_todo_contenttype_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26130
--- expected_contenttype_weekly
http://narnia.na/2008/10/26-week/
http://narnia.na/2006/10/29-week/
http://narnia.na/2004/10/31-week/
--- expected_php_todo_contenttype_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26130
--- expected_contenttype_monthly
http://narnia.na/2008/11/
http://narnia.na/2006/11/
http://narnia.na/2004/11/
--- expected_php_todo_contenttype_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26130
--- expected_contenttype_yearly
http://narnia.na/2008/
http://narnia.na/2006/
http://narnia.na/2004/
