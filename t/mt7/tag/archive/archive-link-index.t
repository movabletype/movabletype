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
for my $ct_name ( keys %{$objs->{content_type}} ) {
    my $key = $ct_name . '_unique_id';
    my $ct = $objs->{content_type}{$ct_name}{content_type};
    MT::Test::Tag->vars->{$key} = $ct->unique_id;
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
<mt:ArchiveList type="[% archive_type %]" content_type="[% ct_with_same_catset_unique_id %]"><mt:ArchiveLink type="[% archive_type %]">
</mt:ArchiveList>
--- expected_individual
http://narnia.na/2018/12/entry-author1-ruler-eraser.html
http://narnia.na/2018/12/entry-author1-ruler-eraser-1.html
http://narnia.na/2017/12/entry-author1-compass.html
http://narnia.na/2016/12/entry-author2-pencil-eraser.html
http://narnia.na/2015/12/entry-author2-no-category.html
--- expected_page
http://narnia.na/page-author2-no-folder.html
http://narnia.na/folder-water/page-author2-water.html
http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-coffee.html
http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-publish.html
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
http://narnia.na/ct/2018/10/[% cd_same_apple_orange_unique_id %].html
http://narnia.na/ct/2018/10/[% cd_same_same_date_unique_id %].html
http://narnia.na/ct/2017/10/[% cd_same_apple_orange_peach_unique_id %].html
http://narnia.na/ct/2016/10/[% cd_same_peach_unique_id %].html
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26128
--- expected_contenttype_author
http://narnia.na/ct/author/author1/
http://narnia.na/ct/author/author2/
--- expected_contenttype_author_daily
http://narnia.na/ct/author/author1/2018/10/31/
http://narnia.na/ct/author/author1/2017/10/31/
http://narnia.na/ct/author/author2/2016/10/31/
--- expected_contenttype_author_weekly
http://narnia.na/ct/author/author1/2018/10/28-week/
http://narnia.na/ct/author/author1/2017/10/29-week/
http://narnia.na/ct/author/author2/2016/10/30-week/
--- expected_contenttype_author_monthly
http://narnia.na/ct/author/author1/2018/10/
http://narnia.na/ct/author/author1/2017/10/
http://narnia.na/ct/author/author2/2016/10/
--- expected_contenttype_author_yearly
http://narnia.na/ct/author/author1/2018/
http://narnia.na/ct/author/author1/2017/
http://narnia.na/ct/author/author2/2016/
--- expected_contenttype_category
http://narnia.na/ct/cat-apple/
http://narnia.na/ct/cat-strawberry/cat-orange/
http://narnia.na/ct/cat-peach/
http://narnia.na/ct/cat-strawberry/
--- expected_contenttype_category_daily
http://narnia.na/ct/cat-apple/2018/10/31/
http://narnia.na/ct/cat-apple/2017/10/31/
http://narnia.na/ct/cat-strawberry/cat-orange/2017/10/31/
http://narnia.na/ct/cat-peach/2016/10/31/
--- expected_php_todo_contenttype_category_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26118
--- expected_todo_contenttype_category_weekly
http://narnia.na/ct/cat-apple/2018/10/28-week/
http://narnia.na/ct/cat-apple/2017/10/29-week/
http://narnia.na/ct/cat-strawberry/cat-orange/2017/10/29-week/
http://narnia.na/ct/cat-peach/2016/10/30-week/
--- expected_php_todo_contenttype_category_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26118
--- expected_todo_contenttype_category_monthly
http://narnia.na/ct/cat-apple/2018/10/
http://narnia.na/ct/cat-apple/2017/10/
http://narnia.na/ct/cat-strawberry/cat-orange/2017/10/
http://narnia.na/ct/cat-peach/2016/10/
--- expected_php_todo_contenttype_category_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26118
--- expected_todo_contenttype_category_yearly
http://narnia.na/ct/cat-apple/2018/
http://narnia.na/ct/cat-apple/2017/
http://narnia.na/ct/cat-strawberry/cat-orange/2017/
http://narnia.na/ct/cat-peach/2016/
--- expected_php_todo_contenttype_category_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26118
--- expected_contenttype_daily
http://narnia.na/ct/2018/10/31/
http://narnia.na/ct/2017/10/31/
http://narnia.na/ct/2016/10/31/
--- expected_contenttype_weekly
http://narnia.na/ct/2018/10/28-week/
http://narnia.na/ct/2017/10/29-week/
http://narnia.na/ct/2016/10/30-week/
--- expected_contenttype_monthly
http://narnia.na/ct/2018/10/
http://narnia.na/ct/2017/10/
http://narnia.na/ct/2016/10/
--- expected_contenttype_yearly
http://narnia.na/ct/2018/
http://narnia.na/ct/2017/
http://narnia.na/ct/2016/

=== Some ArchiveTypes without content_type
--- template
<mt:ArchiveList type="[% archive_type %]"><mt:ArchiveLink type="[% archive_type %]">
</mt:ArchiveList>
--- expected_individual
http://narnia.na/2018/12/entry-author1-ruler-eraser.html
http://narnia.na/2018/12/entry-author1-ruler-eraser-1.html
http://narnia.na/2017/12/entry-author1-compass.html
http://narnia.na/2016/12/entry-author2-pencil-eraser.html
http://narnia.na/2015/12/entry-author2-no-category.html
--- expected_page
http://narnia.na/page-author2-no-folder.html
http://narnia.na/folder-water/page-author2-water.html
http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-coffee.html
http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-publish.html
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
--- expected_error_contenttype
No Content Type could be found.
--- expected_error_contenttype_author
No Content Type could be found.
--- expected_error_contenttype_author_daily
No Content Type could be found.
--- expected_error_contenttype_author_weekly
No Content Type could be found.
--- expected_error_contenttype_author_monthly
No Content Type could be found.
--- expected_error_contenttype_author_yearly
No Content Type could be found.
--- expected_error_contenttype_category
No Content Type could be found.
--- expected_error_contenttype_category_daily
No Content Type could be found.
--- expected_error_contenttype_category_weekly
No Content Type could be found.
--- expected_error_contenttype_category_monthly
No Content Type could be found.
--- expected_error_contenttype_category_yearly
No Content Type could be found.
--- expected_error_contenttype_daily
No Content Type could be found.
--- expected_error_contenttype_weekly
No Content Type could be found.
--- expected_error_contenttype_monthly
No Content Type could be found.
--- expected_error_contenttype_yearly
No Content Type could be found.

