#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Base;
use MT::Test::ArchiveType;

use MT;
use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

my $blog_id = 2;

my $ct = $app->model('content_type')->load(
    {   blog_id => $blog_id,
        name    => 'ct_with_same_catset'
    }
) or die;

my ($cf_same_date, $cf_same_datetime );
for my $cf (@{ $ct->fields }) {
    if ( $cf->{name} eq 'cf_same_date' ) {
        $cf_same_date = $cf;
    } elsif ( $cf->{name} eq 'cf_same_datetime' ) {
        $cf_same_datetime = $cf;
    }
}
die unless $cf_same_date && $cf_same_datetime;

my $cd_same_apple_orange = $app->model('content_data')->load(
    {   content_type_id => $ct->id,
        label           => 'cd_same_apple_orange',
    }
) or die;

my $cd_same_apple_orange_plus
    = $app->model('content_data')
    ->new( map { $_ => $cd_same_apple_orange->$_ }
        qw( author_id authored_on blog_id content_type_id status ) );
$cd_same_apple_orange_plus->label('cd_same_apple_orange_plus');
my $data = $cd_same_apple_orange->data;
$data->{ $cf_same_date->{id} }++;
$data->{ $cf_same_datetime->{id} } ++;
$cd_same_apple_orange_plus->data( $data );
$cd_same_apple_orange_plus->authored_on( $cd_same_apple_orange_plus->authored_on + 1 );
$cd_same_apple_orange_plus->save or die;

filters {
    MT::Test::ArchiveType->filter_spec
};

my @ct_archive_maps = grep { $_->archive_type =~ /^ContentType-/ }
    MT::Test::ArchiveType->template_maps;
MT::Test::ArchiveType->run_tests(@ct_archive_maps);

done_testing;

__END__

=== MTContents sort_by="field:cf_same_date" sort_order="ascend" (date, cat_apple)
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_date',
}
--- template
<MTContents sort_by="field:cf_same_date" sort_order="ascend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_contenttype_author
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
10: cd_same_same_date | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26186
--- expected_contenttype_author_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
--- expected_contenttype_category_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM

=== MTContents sort_by="field:cf_same_date" sort_order="descend" (date, cat_apple)
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    dt_field       => 'cf_same_date',
    category       => 'cat_apple',
}
--- template
<MTContents sort_by="field:cf_same_date" sort_order="descend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_contenttype_author
10: cd_same_same_date | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26186
--- expected_contenttype_author_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM

=== MTContents sort_by="field:cf_same_datetime" sort_order="ascend" (datetime, cat_apple)
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_datetime',
}
--- template
<MTContents sort_by="field:cf_same_datetime" sort_order="ascend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_contenttype_author
10: cd_same_same_date | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM

=== MTContents sort_by="field:cf_same_datetime" sort_order="descend" (datetime, cat_apple)
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_datetime',
}
--- template
<MTContents sort_by="field:cf_same_datetime" sort_order="descend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_contenttype_author
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
10: cd_same_same_date | October 31, 2018 12:00 AM
--- expected_contenttype_author_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
--- expected_contenttype_category_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM

=== MTContents sort_order="ascend" (date, cat_apple) ($use_stash == 1) MTC-26223
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26224
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_date',
}
--- template
<MTContents sort_order="ascend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_contenttype_author
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
10: cd_same_same_date | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM

=== MTContents sort_order="descend" (date, cat_apple) ($use_stash == 1) MTC-26223
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26224
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_date',
}
--- template
<MTContents sort_order="descend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_contenttype_author
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
10: cd_same_same_date | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26225
--- expected_contenttype_author_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
--- expected_contenttype_category_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM

=== MTContents blog_id="[% blog_id %]" sort_order="ascend" (date, cat_apple) ($use_stash == 0) MTC-26223
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_date',
}
--- template
<MTContents blog_id="[% blog_id %]" sort_order="ascend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26225
https://movabletype.atlassian.net/browse/MTC-26227
--- expected_contenttype_author_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category
6: cd_same_apple_orange | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26228
--- expected_contenttype_category_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM

=== MTContents blog_id="[% blog_id %]" sort_order="descend" (date, cat_apple) ($use_stash == 0) MTC-26223
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_date',
}
--- template
<MTContents blog_id="[% blog_id %]" sort_order="descend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26225
https://movabletype.atlassian.net/browse/MTC-26227
--- expected_contenttype_author_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26228
--- expected_contenttype_category_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM

=== MTContents site_id="[% blog_id %]" sort_order="ascend" (date, cat_apple) ($use_stash == 0) MTC-26223
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_date',
}
--- template
<MTContents site_id="[% blog_id %]" sort_order="ascend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26225
https://movabletype.atlassian.net/browse/MTC-26227
--- expected_contenttype_author_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category
6: cd_same_apple_orange | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26228
--- expected_contenttype_category_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_daily
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
6: cd_same_apple_orange | October 31, 2018 12:00 AM
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM

=== MTContents site_id="[% blog_id %]" sort_order="descend" (date, cat_apple) ($use_stash == 0) MTC-26223
--- stash
{
    cd             => 'cd_same_apple_orange',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    dt_field       => 'cf_same_date',
}
--- template
<MTContents site_id="[% blog_id %]" sort_order="descend"><MTContentID>: <MTContentLabel> | <MTContentDate>
</MTContents>
--- expected_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26225
https://movabletype.atlassian.net/browse/MTC-26227
--- expected_contenttype_author_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_author_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
7: cd_same_apple_orange_peach | October 31, 2017 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26228
--- expected_contenttype_category_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_category_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_daily
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_monthly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_weekly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM
--- expected_contenttype_yearly
11: cd_same_apple_orange_plus | October 31, 2018 12:00 AM
6: cd_same_apple_orange | October 31, 2018 12:00 AM

