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
    dt_field     => [qw( chomp )],
    expected     => [qw( chomp )],
};

$test_env->prepare_fixture('archive_type');
my $objs    = MT::Test::Fixture::ArchiveType->load_objs;
my $blog_id = $objs->{blog_id};

my @archive_types = sort MT->publisher->archive_types;
my $archive_types = join ',', @archive_types;

my $ct = MT->model('content_type')->load(
    {   blog_id => $blog_id,
        name    => 'ct_with_same_catset',
    }
) or die;

my $tmpl = MT::Test::Permission->make_template(
    blog_id => $blog_id,
    type    => 'index',
    outfile => 'index.html',
);

MT->publisher->rebuild( BlogID => $blog_id );
my $fileinfo = MT::FileInfo->load( { template_id => $tmpl->id } );
my $finfo_id = $fileinfo->id;

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

            _update_map( $archive_type, $block );
        },
        $archive_type
    );
    MT::Test::Tag->run_php_tests(
        $blog_id,
        sub {
            my ($block) = @_;

            _update_map( $archive_type, $block );

            my $blog_archive_type
                = defined $block->archive_type
                ? $block->archive_type
                : $archive_types;
            return <<"PHP";
\$blog->archive_type = "$blog_archive_type";
require_once('class.mt_fileinfo.php');
\$fileinfo = new FileInfo;
\$fileinfo->Load($finfo_id);
\$ctx->stash('_fileinfo', \$fileinfo);
PHP
        },
        $archive_type
    );
}

sub _update_map {
    my ( $archive_type, $block ) = @_;

    return unless $archive_type =~ /^ContentType/;

    my $map = MT->model('templatemap')->load(
        {   archive_type => $archive_type,
            blog_id      => $blog_id,
            is_preferred => 1,
        },
        {   join => MT->model('template')->join_on(
                undef,
                {   id              => \'= templatemap_template_id',
                    content_type_id => $ct->id,
                },
            ),
        }
    ) or die;

    if ( $block->dt_field ) {
        my $dt_field = MT->model('content_field')->load(
            {   blog_id         => $blog_id,
                content_type_id => $ct->id,
                name            => $block->dt_field,
            }
        ) or die;
        $map->dt_field_id( $dt_field->id );
    }
    else {
        $map->dt_field_id(undef);
    }
    $map->update or die;
}

done_testing;

__END__

=== Some ArchiveTitles with type
--- template
<mt:ArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2018
author1: December  3, 2017
author2: December  3, 2016
author2: December  3, 2015
--- expected_author_monthly
author1: December 2018
author1: December 2017
author2: December 2016
author2: December 2015
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
--- expected_author_yearly
author1: 2018
author1: 2017
author2: 2016
author2: 2015
--- expected_category
cat_compass
cat_eraser
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_eraser: December  3, 2018
cat_eraser: December  3, 2016
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_eraser: December 2018
cat_eraser: December 2016
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_eraser: December  2, 2018 - December  8, 2018
cat_eraser: November 27, 2016 - December  3, 2016
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_eraser: 2018
cat_eraser: 2016
cat_pencil: 2016
cat_ruler: 2018
--- expected_contenttype
cd_same_apple_orange
cd_same_same_date
cd_same_apple_orange_peach
cd_same_peach
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: October 31, 2018
author1: October 31, 2017
author2: October 31, 2016
--- expected_contenttype_author_monthly
author1: October 2018
author1: October 2017
author2: October 2016
--- expected_contenttype_author_weekly
author1: October 28, 2018 - November  3, 2018
author1: October 29, 2017 - November  4, 2017
author2: October 30, 2016 - November  5, 2016
--- expected_contenttype_author_yearly
author1: 2018
author1: 2017
author2: 2016
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
--- expected_contenttype_category_daily
cat_apple: October 31, 2018
cat_apple: October 31, 2017
cat_orange: October 31, 2017
cat_peach: October 31, 2016
--- expected_contenttype_category_monthly
cat_apple: October 2018
cat_apple: October 2017
cat_orange: October 2017
cat_peach: October 2016
--- expected_contenttype_category_weekly
cat_apple: October 28, 2018 - November  3, 2018
cat_apple: October 29, 2017 - November  4, 2017
cat_orange: October 29, 2017 - November  4, 2017
cat_peach: October 30, 2016 - November  5, 2016
--- expected_contenttype_category_yearly
cat_apple: 2018
cat_apple: 2017
cat_orange: 2017
cat_peach: 2016
--- expected_contenttype_daily
October 31, 2018
October 31, 2017
October 31, 2016
--- expected_contenttype_monthly
October 2018
October 2017
October 2016
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 30, 2016 - November  5, 2016
--- expected_contenttype_yearly
2018
2017
2016
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_yearly
2018
2017
2016
2015

=== Some ArchiveTitles with archive_type
--- template
<mt:ArchiveList archive_type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2018
author1: December  3, 2017
author2: December  3, 2016
author2: December  3, 2015
--- expected_author_monthly
author1: December 2018
author1: December 2017
author2: December 2016
author2: December 2015
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
--- expected_author_yearly
author1: 2018
author1: 2017
author2: 2016
author2: 2015
--- expected_category
cat_compass
cat_eraser
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_eraser: December  3, 2018
cat_eraser: December  3, 2016
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_eraser: December 2018
cat_eraser: December 2016
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_eraser: December  2, 2018 - December  8, 2018
cat_eraser: November 27, 2016 - December  3, 2016
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_eraser: 2018
cat_eraser: 2016
cat_pencil: 2016
cat_ruler: 2018
--- expected_contenttype
cd_same_apple_orange
cd_same_same_date
cd_same_apple_orange_peach
cd_same_peach
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: October 31, 2018
author1: October 31, 2017
author2: October 31, 2016
--- expected_contenttype_author_monthly
author1: October 2018
author1: October 2017
author2: October 2016
--- expected_contenttype_author_weekly
author1: October 28, 2018 - November  3, 2018
author1: October 29, 2017 - November  4, 2017
author2: October 30, 2016 - November  5, 2016
--- expected_contenttype_author_yearly
author1: 2018
author1: 2017
author2: 2016
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
--- expected_contenttype_category_daily
cat_apple: October 31, 2018
cat_apple: October 31, 2017
cat_orange: October 31, 2017
cat_peach: October 31, 2016
--- expected_contenttype_category_monthly
cat_apple: October 2018
cat_apple: October 2017
cat_orange: October 2017
cat_peach: October 2016
--- expected_contenttype_category_weekly
cat_apple: October 28, 2018 - November  3, 2018
cat_apple: October 29, 2017 - November  4, 2017
cat_orange: October 29, 2017 - November  4, 2017
cat_peach: October 30, 2016 - November  5, 2016
--- expected_contenttype_category_yearly
cat_apple: 2018
cat_apple: 2017
cat_orange: 2017
cat_peach: 2016
--- expected_contenttype_daily
October 31, 2018
October 31, 2017
October 31, 2016
--- expected_contenttype_monthly
October 2018
October 2017
October 2016
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 30, 2016 - November  5, 2016
--- expected_contenttype_yearly
2018
2017
2016
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_yearly
2018
2017
2016
2015

=== Empty with type
--- archive_type
--- template
<mt:ArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109

=== Empty with archive_type
--- archive_type
--- template
<mt:ArchiveList archive_type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109

=== None with type
--- archive_type
None
--- template
<mt:ArchiveList type="[% archive_type %]"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26109

=== sort_order="ascend"
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="ascend" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2017
author1: December  3, 2018
author2: December  3, 2015
author2: December  3, 2016
--- expected_author_monthly
author1: December 2017
author1: December 2018
author2: December 2015
author2: December 2016
--- expected_author_weekly
author1: December  3, 2017 - December  9, 2017
author1: December  2, 2018 - December  8, 2018
author2: November 29, 2015 - December  5, 2015
author2: November 27, 2016 - December  3, 2016
--- expected_author_yearly
author1: 2017
author1: 2018
author2: 2015
author2: 2016
--- expected_category
cat_compass
cat_eraser
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_eraser: December  3, 2016
cat_eraser: December  3, 2018
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_eraser: December 2016
cat_eraser: December 2018
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_eraser: November 27, 2016 - December  3, 2016
cat_eraser: December  2, 2018 - December  8, 2018
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_eraser: 2016
cat_eraser: 2018
cat_pencil: 2016
cat_ruler: 2018
--- expected_contenttype
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: October 31, 2017
author1: October 31, 2018
author2: October 31, 2016
--- expected_contenttype_author_monthly
author1: October 2017
author1: October 2018
author2: October 2016
--- expected_contenttype_author_weekly
author1: October 29, 2017 - November  4, 2017
author1: October 28, 2018 - November  3, 2018
author2: October 30, 2016 - November  5, 2016
--- expected_contenttype_author_yearly
author1: 2017
author1: 2018
author2: 2016
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
--- expected_contenttype_category_daily
cat_apple: October 31, 2017
cat_apple: October 31, 2018
cat_orange: October 31, 2017
cat_peach: October 31, 2016
--- expected_contenttype_category_monthly
cat_apple: October 2017
cat_apple: October 2018
cat_orange: October 2017
cat_peach: October 2016
--- expected_contenttype_category_weekly
cat_apple: October 29, 2017 - November  4, 2017
cat_apple: October 28, 2018 - November  3, 2018
cat_orange: October 29, 2017 - November  4, 2017
cat_peach: October 30, 2016 - November  5, 2016
--- expected_contenttype_category_yearly
cat_apple: 2017
cat_apple: 2018
cat_orange: 2017
cat_peach: 2016
--- expected_contenttype_daily
October 31, 2016
October 31, 2017
October 31, 2018
--- expected_contenttype_monthly
October 2016
October 2017
October 2018
--- expected_contenttype_weekly
October 30, 2016 - November  5, 2016
October 29, 2017 - November  4, 2017
October 28, 2018 - November  3, 2018
--- expected_contenttype_yearly
2016
2017
2018
--- expected_daily
December  3, 2015
December  3, 2016
December  3, 2017
December  3, 2018
--- expected_individual
entry_author2_no_category
entry_author2_pencil_eraser
entry_author1_compass
entry_author1_ruler_eraser
entry_author1_ruler_eraser
--- expected_monthly
December 2015
December 2016
December 2017
December 2018
--- expected_page
page_author1_coffee
page_author1_coffee
page_author2_water
page_author2_no_folder
--- expected_weekly
November 29, 2015 - December  5, 2015
November 27, 2016 - December  3, 2016
December  3, 2017 - December  9, 2017
December  2, 2018 - December  8, 2018
--- expected_yearly
2015
2016
2017
2018

=== sort_order="descend"
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="descend" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author2
author1
--- expected_author_daily
author2: December  3, 2016
author2: December  3, 2015
author1: December  3, 2018
author1: December  3, 2017
--- expected_author_monthly
author2: December 2016
author2: December 2015
author1: December 2018
author1: December 2017
--- expected_author_weekly
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
--- expected_author_yearly
author2: 2016
author2: 2015
author1: 2018
author1: 2017
--- expected_category
cat_ruler
cat_pencil
cat_eraser
cat_compass
--- expected_category_daily
cat_ruler: December  3, 2018
cat_pencil: December  3, 2016
cat_eraser: December  3, 2018
cat_eraser: December  3, 2016
cat_compass: December  3, 2017
--- expected_category_monthly
cat_ruler: December 2018
cat_pencil: December 2016
cat_eraser: December 2018
cat_eraser: December 2016
cat_compass: December 2017
--- expected_category_weekly
cat_ruler: December  2, 2018 - December  8, 2018
cat_pencil: November 27, 2016 - December  3, 2016
cat_eraser: December  2, 2018 - December  8, 2018
cat_eraser: November 27, 2016 - December  3, 2016
cat_compass: December  3, 2017 - December  9, 2017
--- expected_category_yearly
cat_ruler: 2018
cat_pencil: 2016
cat_eraser: 2018
cat_eraser: 2016
cat_compass: 2017
--- expected_contenttype
cd_same_apple_orange
cd_same_same_date
cd_same_apple_orange_peach
cd_same_peach
--- expected_contenttype_author
author2
author1
--- expected_contenttype_author_daily
author2: October 31, 2016
author1: October 31, 2018
author1: October 31, 2017
--- expected_contenttype_author_monthly
author2: October 2016
author1: October 2018
author1: October 2017
--- expected_contenttype_author_weekly
author2: October 30, 2016 - November  5, 2016
author1: October 28, 2018 - November  3, 2018
author1: October 29, 2017 - November  4, 2017
--- expected_contenttype_author_yearly
author2: 2016
author1: 2018
author1: 2017
--- expected_contenttype_category
cat_peach
cat_orange
cat_apple
--- expected_contenttype_category_daily
cat_peach: October 31, 2016
cat_orange: October 31, 2017
cat_apple: October 31, 2018
cat_apple: October 31, 2017
--- expected_contenttype_category_monthly
cat_peach: October 2016
cat_orange: October 2017
cat_apple: October 2018
cat_apple: October 2017
--- expected_contenttype_category_weekly
cat_peach: October 30, 2016 - November  5, 2016
cat_orange: October 29, 2017 - November  4, 2017
cat_apple: October 28, 2018 - November  3, 2018
cat_apple: October 29, 2017 - November  4, 2017
--- expected_contenttype_category_yearly
cat_peach: 2016
cat_orange: 2017
cat_apple: 2018
cat_apple: 2017
--- expected_contenttype_daily
October 31, 2018
October 31, 2017
October 31, 2016
--- expected_contenttype_monthly
October 2018
October 2017
October 2016
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
October 30, 2016 - November  5, 2016
--- expected_contenttype_yearly
2018
2017
2016
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_yearly
2018
2017
2016
2015

=== sort_order="ascend"
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="ascend" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2017
author1: December  3, 2018
author2: December  3, 2015
author2: December  3, 2016
--- expected_author_monthly
author1: December 2017
author1: December 2018
author2: December 2015
author2: December 2016
--- expected_author_weekly
author1: December  3, 2017 - December  9, 2017
author1: December  2, 2018 - December  8, 2018
author2: November 29, 2015 - December  5, 2015
author2: November 27, 2016 - December  3, 2016
--- expected_author_yearly
author1: 2017
author1: 2018
author2: 2015
author2: 2016
--- expected_category
cat_compass
cat_eraser
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_eraser: December  3, 2016
cat_eraser: December  3, 2018
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_eraser: December 2016
cat_eraser: December 2018
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_eraser: November 27, 2016 - December  3, 2016
cat_eraser: December  2, 2018 - December  8, 2018
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_eraser: 2016
cat_eraser: 2018
cat_pencil: 2016
cat_ruler: 2018
--- expected_contenttype
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: October 31, 2017
author1: October 31, 2018
author2: October 31, 2016
--- expected_contenttype_author_monthly
author1: October 2017
author1: October 2018
author2: October 2016
--- expected_contenttype_author_weekly
author1: October 29, 2017 - November  4, 2017
author1: October 28, 2018 - November  3, 2018
author2: October 30, 2016 - November  5, 2016
--- expected_contenttype_author_yearly
author1: 2017
author1: 2018
author2: 2016
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
--- expected_contenttype_category_daily
cat_apple: October 31, 2017
cat_apple: October 31, 2018
cat_orange: October 31, 2017
cat_peach: October 31, 2016
--- expected_contenttype_category_monthly
cat_apple: October 2017
cat_apple: October 2018
cat_orange: October 2017
cat_peach: October 2016
--- expected_contenttype_category_weekly
cat_apple: October 29, 2017 - November  4, 2017
cat_apple: October 28, 2018 - November  3, 2018
cat_orange: October 29, 2017 - November  4, 2017
cat_peach: October 30, 2016 - November  5, 2016
--- expected_contenttype_category_yearly
cat_apple: 2017
cat_apple: 2018
cat_orange: 2017
cat_peach: 2016
--- expected_contenttype_daily
October 31, 2016
October 31, 2017
October 31, 2018
--- expected_contenttype_monthly
October 2016
October 2017
October 2018
--- expected_contenttype_weekly
October 30, 2016 - November  5, 2016
October 29, 2017 - November  4, 2017
October 28, 2018 - November  3, 2018
--- expected_contenttype_yearly
2016
2017
2018
--- expected_daily
December  3, 2015
December  3, 2016
December  3, 2017
December  3, 2018
--- expected_individual
entry_author2_no_category
entry_author2_pencil_eraser
entry_author1_compass
entry_author1_ruler_eraser
entry_author1_ruler_eraser
--- expected_monthly
December 2015
December 2016
December 2017
December 2018
--- expected_page
page_author1_coffee
page_author1_coffee
page_author2_water
page_author2_no_folder
--- expected_weekly
November 29, 2015 - December  5, 2015
November 27, 2016 - December  3, 2016
December  3, 2017 - December  9, 2017
December  2, 2018 - December  8, 2018
--- expected_yearly
2015
2016
2017
2018

=== date_only field
--- dt_field
cf_same_date
--- template
<mt:ArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2018
author1: December  3, 2017
author2: December  3, 2016
author2: December  3, 2015
--- expected_author_monthly
author1: December 2018
author1: December 2017
author2: December 2016
author2: December 2015
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
--- expected_author_yearly
author1: 2018
author1: 2017
author2: 2016
author2: 2015
--- expected_category
cat_compass
cat_eraser
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_eraser: December  3, 2018
cat_eraser: December  3, 2016
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_eraser: December 2018
cat_eraser: December 2016
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_eraser: December  2, 2018 - December  8, 2018
cat_eraser: November 27, 2016 - December  3, 2016
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_eraser: 2018
cat_eraser: 2016
cat_pencil: 2016
cat_ruler: 2018
--- expected_contenttype
cd_same_peach
cd_same_apple_orange_peach
cd_same_same_date
cd_same_apple_orange
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: September 26, 2020
author1: September 26, 2019
author2: September 26, 2021
--- expected_contenttype_author_monthly
author1: September 2020
author1: September 2019
author2: September 2021
--- expected_contenttype_author_weekly
author1: September 20, 2020 - September 26, 2020
author1: September 22, 2019 - September 28, 2019
author2: September 26, 2021 - October  2, 2021
--- expected_contenttype_author_yearly
author1: 2020
author1: 2019
author2: 2021
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
--- expected_contenttype_category_daily
cat_apple: September 26, 2020
cat_apple: September 26, 2019
cat_orange: September 26, 2020
cat_peach: September 26, 2021
--- expected_contenttype_category_monthly
cat_apple: September 2020
cat_apple: September 2019
cat_orange: September 2020
cat_peach: September 2021
--- expected_contenttype_category_weekly
cat_apple: September 20, 2020 - September 26, 2020
cat_apple: September 22, 2019 - September 28, 2019
cat_orange: September 20, 2020 - September 26, 2020
cat_peach: September 26, 2021 - October  2, 2021
--- expected_contenttype_category_yearly
cat_apple: 2020
cat_apple: 2019
cat_orange: 2020
cat_peach: 2021
--- expected_contenttype_daily
September 26, 2021
September 26, 2020
September 26, 2019
--- expected_contenttype_monthly
September 2021
September 2020
September 2019
--- expected_contenttype_weekly
September 26, 2021 - October  2, 2021
September 20, 2020 - September 26, 2020
September 22, 2019 - September 28, 2019
--- expected_contenttype_yearly
2021
2020
2019
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_yearly
2018
2017
2016
2015

=== date_only field, sort_order="ascend"
--- dt_field
cf_same_date
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="ascend" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2017
author1: December  3, 2018
author2: December  3, 2015
author2: December  3, 2016
--- expected_author_monthly
author1: December 2017
author1: December 2018
author2: December 2015
author2: December 2016
--- expected_author_weekly
author1: December  3, 2017 - December  9, 2017
author1: December  2, 2018 - December  8, 2018
author2: November 29, 2015 - December  5, 2015
author2: November 27, 2016 - December  3, 2016
--- expected_author_yearly
author1: 2017
author1: 2018
author2: 2015
author2: 2016
--- expected_category
cat_compass
cat_eraser
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_eraser: December  3, 2016
cat_eraser: December  3, 2018
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_eraser: December 2016
cat_eraser: December 2018
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_eraser: November 27, 2016 - December  3, 2016
cat_eraser: December  2, 2018 - December  8, 2018
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_eraser: 2016
cat_eraser: 2018
cat_pencil: 2016
cat_ruler: 2018
--- expected_contenttype
cd_same_apple_orange
cd_same_apple_orange_peach
cd_same_same_date
cd_same_peach
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: September 26, 2019
author1: September 26, 2020
author2: September 26, 2021
--- expected_contenttype_author_monthly
author1: September 2019
author1: September 2020
author2: September 2021
--- expected_contenttype_author_weekly
author1: September 22, 2019 - September 28, 2019
author1: September 20, 2020 - September 26, 2020
author2: September 26, 2021 - October  2, 2021
--- expected_contenttype_author_yearly
author1: 2019
author1: 2020
author2: 2021
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
--- expected_contenttype_category_daily
cat_apple: September 26, 2019
cat_apple: September 26, 2020
cat_orange: September 26, 2020
cat_peach: September 26, 2021
--- expected_contenttype_category_monthly
cat_apple: September 2019
cat_apple: September 2020
cat_orange: September 2020
cat_peach: September 2021
--- expected_contenttype_category_weekly
cat_apple: September 22, 2019 - September 28, 2019
cat_apple: September 20, 2020 - September 26, 2020
cat_orange: September 20, 2020 - September 26, 2020
cat_peach: September 26, 2021 - October  2, 2021
--- expected_contenttype_category_yearly
cat_apple: 2019
cat_apple: 2020
cat_orange: 2020
cat_peach: 2021
--- expected_contenttype_daily
September 26, 2019
September 26, 2020
September 26, 2021
--- expected_contenttype_monthly
September 2019
September 2020
September 2021
--- expected_contenttype_weekly
September 22, 2019 - September 28, 2019
September 20, 2020 - September 26, 2020
September 26, 2021 - October  2, 2021
--- expected_contenttype_yearly
2019
2020
2021
--- expected_daily
December  3, 2015
December  3, 2016
December  3, 2017
December  3, 2018
--- expected_individual
entry_author2_no_category
entry_author2_pencil_eraser
entry_author1_compass
entry_author1_ruler_eraser
entry_author1_ruler_eraser
--- expected_monthly
December 2015
December 2016
December 2017
December 2018
--- expected_page
page_author1_coffee
page_author1_coffee
page_author2_water
page_author2_no_folder
--- expected_weekly
November 29, 2015 - December  5, 2015
November 27, 2016 - December  3, 2016
December  3, 2017 - December  9, 2017
December  2, 2018 - December  8, 2018
--- expected_yearly
2015
2016
2017
2018

=== date_only field, sort_order="descend"
--- dt_field
cf_same_date
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="descend" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author2
author1
--- expected_author_daily
author2: December  3, 2016
author2: December  3, 2015
author1: December  3, 2018
author1: December  3, 2017
--- expected_author_monthly
author2: December 2016
author2: December 2015
author1: December 2018
author1: December 2017
--- expected_author_weekly
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
--- expected_author_yearly
author2: 2016
author2: 2015
author1: 2018
author1: 2017
--- expected_category
cat_ruler
cat_pencil
cat_eraser
cat_compass
--- expected_category_daily
cat_ruler: December  3, 2018
cat_pencil: December  3, 2016
cat_eraser: December  3, 2018
cat_eraser: December  3, 2016
cat_compass: December  3, 2017
--- expected_category_monthly
cat_ruler: December 2018
cat_pencil: December 2016
cat_eraser: December 2018
cat_eraser: December 2016
cat_compass: December 2017
--- expected_category_weekly
cat_ruler: December  2, 2018 - December  8, 2018
cat_pencil: November 27, 2016 - December  3, 2016
cat_eraser: December  2, 2018 - December  8, 2018
cat_eraser: November 27, 2016 - December  3, 2016
cat_compass: December  3, 2017 - December  9, 2017
--- expected_category_yearly
cat_ruler: 2018
cat_pencil: 2016
cat_eraser: 2018
cat_eraser: 2016
cat_compass: 2017
--- expected_contenttype
cd_same_peach
cd_same_apple_orange_peach
cd_same_same_date
cd_same_apple_orange
--- expected_contenttype_author
author2
author1
--- expected_contenttype_author_daily
author2: September 26, 2021
author1: September 26, 2020
author1: September 26, 2019
--- expected_contenttype_author_monthly
author2: September 2021
author1: September 2020
author1: September 2019
--- expected_contenttype_author_weekly
author2: September 26, 2021 - October  2, 2021
author1: September 20, 2020 - September 26, 2020
author1: September 22, 2019 - September 28, 2019
--- expected_contenttype_author_yearly
author2: 2021
author1: 2020
author1: 2019
--- expected_contenttype_category
cat_peach
cat_orange
cat_apple
--- expected_contenttype_category_daily
cat_peach: September 26, 2021
cat_orange: September 26, 2020
cat_apple: September 26, 2020
cat_apple: September 26, 2019
--- expected_contenttype_category_monthly
cat_peach: September 2021
cat_orange: September 2020
cat_apple: September 2020
cat_apple: September 2019
--- expected_contenttype_category_weekly
cat_peach: September 26, 2021 - October  2, 2021
cat_orange: September 20, 2020 - September 26, 2020
cat_apple: September 20, 2020 - September 26, 2020
cat_apple: September 22, 2019 - September 28, 2019
--- expected_contenttype_category_yearly
cat_peach: 2021
cat_orange: 2020
cat_apple: 2020
cat_apple: 2019
--- expected_contenttype_daily
September 26, 2021
September 26, 2020
September 26, 2019
--- expected_contenttype_monthly
September 2021
September 2020
September 2019
--- expected_contenttype_weekly
September 26, 2021 - October  2, 2021
September 20, 2020 - September 26, 2020
September 22, 2019 - September 28, 2019
--- expected_contenttype_yearly
2021
2020
2019
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_yearly
2018
2017
2016
2015

=== date_and_time field
--- dt_field
cf_same_datetime
--- template
<mt:ArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2018
author1: December  3, 2017
author2: December  3, 2016
author2: December  3, 2015
--- expected_author_monthly
author1: December 2018
author1: December 2017
author2: December 2016
author2: December 2015
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
--- expected_author_yearly
author1: 2018
author1: 2017
author2: 2016
author2: 2015
--- expected_category
cat_compass
cat_eraser
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_eraser: December  3, 2018
cat_eraser: December  3, 2016
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_eraser: December 2018
cat_eraser: December 2016
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_eraser: December  2, 2018 - December  8, 2018
cat_eraser: November 27, 2016 - December  3, 2016
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_eraser: 2018
cat_eraser: 2016
cat_pencil: 2016
cat_ruler: 2018
--- expected_contenttype
cd_same_apple_orange
cd_same_apple_orange_peach
cd_same_peach
cd_same_same_date
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: November  1, 2008
author1: November  1, 2006
author1: November  1, 2004
author2: November  1, 2004
--- expected_contenttype_author_monthly
author1: November 2008
author1: November 2006
author1: November 2004
author2: November 2004
--- expected_contenttype_author_weekly
author1: October 26, 2008 - November  1, 2008
author1: October 29, 2006 - November  4, 2006
author1: October 31, 2004 - November  6, 2004
author2: October 31, 2004 - November  6, 2004
--- expected_contenttype_author_yearly
author1: 2008
author1: 2006
author1: 2004
author2: 2004
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
--- expected_contenttype_category_daily
cat_apple: November  1, 2008
cat_apple: November  1, 2006
cat_orange: November  1, 2006
cat_peach: November  1, 2004
--- expected_contenttype_category_monthly
cat_apple: November 2008
cat_apple: November 2006
cat_orange: November 2006
cat_peach: November 2004
--- expected_contenttype_category_weekly
cat_apple: October 26, 2008 - November  1, 2008
cat_apple: October 29, 2006 - November  4, 2006
cat_orange: October 29, 2006 - November  4, 2006
cat_peach: October 31, 2004 - November  6, 2004
--- expected_contenttype_category_yearly
cat_apple: 2008
cat_apple: 2006
cat_orange: 2006
cat_peach: 2004
--- expected_contenttype_daily
November  1, 2008
November  1, 2006
November  1, 2004
--- expected_contenttype_monthly
November 2008
November 2006
November 2004
--- expected_contenttype_weekly
October 26, 2008 - November  1, 2008
October 29, 2006 - November  4, 2006
October 31, 2004 - November  6, 2004
--- expected_contenttype_yearly
2008
2006
2004
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_yearly
2018
2017
2016
2015

=== date_and_time field, sort_order="ascend"
--- dt_field
cf_same_datetime
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="ascend" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author1
author2
--- expected_author_daily
author1: December  3, 2017
author1: December  3, 2018
author2: December  3, 2015
author2: December  3, 2016
--- expected_author_monthly
author1: December 2017
author1: December 2018
author2: December 2015
author2: December 2016
--- expected_author_weekly
author1: December  3, 2017 - December  9, 2017
author1: December  2, 2018 - December  8, 2018
author2: November 29, 2015 - December  5, 2015
author2: November 27, 2016 - December  3, 2016
--- expected_author_yearly
author1: 2017
author1: 2018
author2: 2015
author2: 2016
--- expected_category
cat_compass
cat_eraser
cat_pencil
cat_ruler
--- expected_category_daily
cat_compass: December  3, 2017
cat_eraser: December  3, 2016
cat_eraser: December  3, 2018
cat_pencil: December  3, 2016
cat_ruler: December  3, 2018
--- expected_category_monthly
cat_compass: December 2017
cat_eraser: December 2016
cat_eraser: December 2018
cat_pencil: December 2016
cat_ruler: December 2018
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cat_eraser: November 27, 2016 - December  3, 2016
cat_eraser: December  2, 2018 - December  8, 2018
cat_pencil: November 27, 2016 - December  3, 2016
cat_ruler: December  2, 2018 - December  8, 2018
--- expected_category_yearly
cat_compass: 2017
cat_eraser: 2016
cat_eraser: 2018
cat_pencil: 2016
cat_ruler: 2018
--- expected_contenttype
cd_same_peach
cd_same_same_date
cd_same_apple_orange_peach
cd_same_apple_orange
--- expected_contenttype_author
author1
author2
--- expected_contenttype_author_daily
author1: November  1, 2004
author1: November  1, 2006
author1: November  1, 2008
author2: November  1, 2004
--- expected_contenttype_author_monthly
author1: November 2004
author1: November 2006
author1: November 2008
author2: November 2004
--- expected_contenttype_author_weekly
author1: October 31, 2004 - November  6, 2004
author1: October 29, 2006 - November  4, 2006
author1: October 26, 2008 - November  1, 2008
author2: October 31, 2004 - November  6, 2004
--- expected_contenttype_author_yearly
author1: 2004
author1: 2006
author1: 2008
author2: 2004
--- expected_contenttype_category
cat_apple
cat_orange
cat_peach
--- expected_contenttype_category_daily
cat_apple: November  1, 2006
cat_apple: November  1, 2008
cat_orange: November  1, 2006
cat_peach: November  1, 2004
--- expected_contenttype_category_monthly
cat_apple: November 2006
cat_apple: November 2008
cat_orange: November 2006
cat_peach: November 2004
--- expected_contenttype_category_weekly
cat_apple: October 29, 2006 - November  4, 2006
cat_apple: October 26, 2008 - November  1, 2008
cat_orange: October 29, 2006 - November  4, 2006
cat_peach: October 31, 2004 - November  6, 2004
--- expected_contenttype_category_yearly
cat_apple: 2006
cat_apple: 2008
cat_orange: 2006
cat_peach: 2004
--- expected_contenttype_daily
November  1, 2004
November  1, 2006
November  1, 2008
--- expected_contenttype_monthly
November 2004
November 2006
November 2008
--- expected_contenttype_weekly
October 31, 2004 - November  6, 2004
October 29, 2006 - November  4, 2006
October 26, 2008 - November  1, 2008
--- expected_contenttype_yearly
2004
2006
2008
--- expected_daily
December  3, 2015
December  3, 2016
December  3, 2017
December  3, 2018
--- expected_individual
entry_author2_no_category
entry_author2_pencil_eraser
entry_author1_compass
entry_author1_ruler_eraser
entry_author1_ruler_eraser
--- expected_monthly
December 2015
December 2016
December 2017
December 2018
--- expected_page
page_author1_coffee
page_author1_coffee
page_author2_water
page_author2_no_folder
--- expected_weekly
November 29, 2015 - December  5, 2015
November 27, 2016 - December  3, 2016
December  3, 2017 - December  9, 2017
December  2, 2018 - December  8, 2018
--- expected_yearly
2015
2016
2017
2018

=== date_and_time field, sort_order="descend"
--- dt_field
cf_same_datetime
--- template
<mt:ArchiveList type="[% archive_type %]" sort_order="descend" content_type="ct_with_same_catset"><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_author
author2
author1
--- expected_author_daily
author2: December  3, 2016
author2: December  3, 2015
author1: December  3, 2018
author1: December  3, 2017
--- expected_author_monthly
author2: December 2016
author2: December 2015
author1: December 2018
author1: December 2017
--- expected_author_weekly
author2: November 27, 2016 - December  3, 2016
author2: November 29, 2015 - December  5, 2015
author1: December  2, 2018 - December  8, 2018
author1: December  3, 2017 - December  9, 2017
--- expected_author_yearly
author2: 2016
author2: 2015
author1: 2018
author1: 2017
--- expected_category
cat_ruler
cat_pencil
cat_eraser
cat_compass
--- expected_category_daily
cat_ruler: December  3, 2018
cat_pencil: December  3, 2016
cat_eraser: December  3, 2018
cat_eraser: December  3, 2016
cat_compass: December  3, 2017
--- expected_category_monthly
cat_ruler: December 2018
cat_pencil: December 2016
cat_eraser: December 2018
cat_eraser: December 2016
cat_compass: December 2017
--- expected_category_weekly
cat_ruler: December  2, 2018 - December  8, 2018
cat_pencil: November 27, 2016 - December  3, 2016
cat_eraser: December  2, 2018 - December  8, 2018
cat_eraser: November 27, 2016 - December  3, 2016
cat_compass: December  3, 2017 - December  9, 2017
--- expected_category_yearly
cat_ruler: 2018
cat_pencil: 2016
cat_eraser: 2018
cat_eraser: 2016
cat_compass: 2017
--- expected_contenttype
cd_same_apple_orange
cd_same_apple_orange_peach
cd_same_peach
cd_same_same_date
--- expected_contenttype_author
author2
author1
--- expected_contenttype_author_daily
author2: November  1, 2004
author1: November  1, 2008
author1: November  1, 2006
author1: November  1, 2004
--- expected_contenttype_author_monthly
author2: November 2004
author1: November 2008
author1: November 2006
author1: November 2004
--- expected_contenttype_author_weekly
author2: October 31, 2004 - November  6, 2004
author1: October 26, 2008 - November  1, 2008
author1: October 29, 2006 - November  4, 2006
author1: October 31, 2004 - November  6, 2004
--- expected_contenttype_author_yearly
author2: 2004
author1: 2008
author1: 2006
author1: 2004
--- expected_contenttype_category
cat_peach
cat_orange
cat_apple
--- expected_contenttype_category_daily
cat_peach: November  1, 2004
cat_orange: November  1, 2006
cat_apple: November  1, 2008
cat_apple: November  1, 2006
--- expected_contenttype_category_monthly
cat_peach: November 2004
cat_orange: November 2006
cat_apple: November 2008
cat_apple: November 2006
--- expected_contenttype_category_weekly
cat_peach: October 31, 2004 - November  6, 2004
cat_orange: October 29, 2006 - November  4, 2006
cat_apple: October 26, 2008 - November  1, 2008
cat_apple: October 29, 2006 - November  4, 2006
--- expected_contenttype_category_yearly
cat_peach: 2004
cat_orange: 2006
cat_apple: 2008
cat_apple: 2006
--- expected_contenttype_daily
November  1, 2008
November  1, 2006
November  1, 2004
--- expected_contenttype_monthly
November 2008
November 2006
November 2004
--- expected_contenttype_weekly
October 26, 2008 - November  1, 2008
October 29, 2006 - November  4, 2006
October 31, 2004 - November  6, 2004
--- expected_contenttype_yearly
2008
2006
2004
--- expected_daily
December  3, 2018
December  3, 2017
December  3, 2016
December  3, 2015
--- expected_individual
entry_author1_ruler_eraser
entry_author1_ruler_eraser
entry_author1_compass
entry_author2_pencil_eraser
entry_author2_no_category
--- expected_monthly
December 2018
December 2017
December 2016
December 2015
--- expected_page
page_author2_no_folder
page_author2_water
page_author1_coffee
page_author1_coffee
--- expected_weekly
December  2, 2018 - December  8, 2018
December  3, 2017 - December  9, 2017
November 27, 2016 - December  3, 2016
November 29, 2015 - December  5, 2015
--- expected_yearly
2018
2017
2016
2015

=== ArchiveList + Contents (MTC-26234)
--- template
<mt:ArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
<mt:Contents sort_order="ascend"><mt:ContentLabel>
</mt:Contents>
</mt:ArchiveList>
--- expected_author
author1
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_author_daily
author1: December  3, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author1: December  3, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: December  3, 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_author_monthly
author1: December 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author1: December 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: December 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: December 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author1: December  3, 2017 - December  9, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: November 27, 2016 - December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: November 29, 2015 - December  5, 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_author_yearly
author1: 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author1: 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category
cat_compass
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category_daily
cat_compass: December  3, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December  3, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil: December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler: December  3, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category_monthly
cat_compass: December 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil: December 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler: December 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December  2, 2018 - December  8, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: November 27, 2016 - December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil: November 27, 2016 - December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler: December  2, 2018 - December  8, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category_yearly
cat_compass: 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil: 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler: 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_contenttype
cd_same_apple_orange
cd_same_apple_orange

cd_same_same_date
cd_same_same_date

cd_same_apple_orange_peach
cd_same_apple_orange_peach

cd_same_peach
cd_same_peach
--- expected_contenttype_author
author1
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2
cd_same_peach
--- expected_contenttype_author_daily
author1: October 31, 2018
cd_same_apple_orange
cd_same_same_date

author1: October 31, 2017
cd_same_apple_orange_peach

author2: October 31, 2016
cd_same_peach
--- expected_contenttype_author_monthly
author1: October 2018
cd_same_apple_orange
cd_same_same_date

author1: October 2017
cd_same_apple_orange_peach

author2: October 2016
cd_same_peach
--- expected_contenttype_author_weekly
author1: October 28, 2018 - November  3, 2018
cd_same_apple_orange
cd_same_same_date

author1: October 29, 2017 - November  4, 2017
cd_same_apple_orange_peach

author2: October 30, 2016 - November  5, 2016
cd_same_peach
--- expected_contenttype_author_yearly
author1: 2018
cd_same_apple_orange
cd_same_same_date

author1: 2017
cd_same_apple_orange_peach

author2: 2016
cd_same_peach
--- expected_contenttype_category
cat_apple
cd_same_apple_orange_peach
cd_same_apple_orange

cat_orange
cd_same_apple_orange_peach

cat_peach
cd_same_peach
--- expected_contenttype_category_daily
cat_apple: October 31, 2018
cd_same_apple_orange

cat_apple: October 31, 2017
cd_same_apple_orange_peach

cat_orange: October 31, 2017
cd_same_apple_orange_peach

cat_peach: October 31, 2016
cd_same_peach
--- expected_contenttype_category_monthly
cat_apple: October 2018
cd_same_apple_orange

cat_apple: October 2017
cd_same_apple_orange_peach

cat_orange: October 2017
cd_same_apple_orange_peach

cat_peach: October 2016
cd_same_peach
--- expected_contenttype_category_weekly
cat_apple: October 28, 2018 - November  3, 2018
cd_same_apple_orange

cat_apple: October 29, 2017 - November  4, 2017
cd_same_apple_orange_peach

cat_orange: October 29, 2017 - November  4, 2017
cd_same_apple_orange_peach

cat_peach: October 30, 2016 - November  5, 2016
cd_same_peach
--- expected_contenttype_category_yearly
cat_apple: 2018
cd_same_apple_orange

cat_apple: 2017
cd_same_apple_orange_peach

cat_orange: 2017
cd_same_apple_orange_peach

cat_peach: 2016
cd_same_peach
--- expected_contenttype_daily
October 31, 2018
cd_same_apple_orange
cd_same_same_date

October 31, 2017
cd_same_apple_orange_peach

October 31, 2016
cd_same_peach
--- expected_contenttype_monthly
October 2018
cd_same_apple_orange
cd_same_same_date

October 2017
cd_same_apple_orange_peach

October 2016
cd_same_peach
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018
cd_same_apple_orange
cd_same_same_date

October 29, 2017 - November  4, 2017
cd_same_apple_orange_peach

October 30, 2016 - November  5, 2016
cd_same_peach
--- expected_contenttype_yearly
2018
cd_same_apple_orange
cd_same_same_date

2017
cd_same_apple_orange_peach

2016
cd_same_peach
--- expected_daily
December  3, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December  3, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December  3, 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_individual
entry_author1_ruler_eraser
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

entry_author1_ruler_eraser
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

entry_author1_compass
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

entry_author2_pencil_eraser
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

entry_author2_no_category
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_monthly
December 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_page
page_author2_no_folder
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

page_author2_water
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

page_author1_coffee
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

page_author1_coffee
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_weekly
December  2, 2018 - December  8, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December  3, 2017 - December  9, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

November 27, 2016 - December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

November 29, 2015 - December  5, 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_yearly
2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

=== ArchiveList + Contents + datetime (MTC-26234)
--- dt_field
cf_same_datetime
--- template
<mt:ArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><mt:ArchiveTitle>
<mt:Contents sort_order="ascend"><mt:ContentLabel>
</mt:Contents>
</mt:ArchiveList>
--- expected_author
author1
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_author_daily
author1: December  3, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author1: December  3, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: December  3, 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_author_monthly
author1: December 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author1: December 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: December 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: December 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author1: December  3, 2017 - December  9, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: November 27, 2016 - December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: November 29, 2015 - December  5, 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_author_yearly
author1: 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author1: 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

author2: 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category
cat_compass
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category_daily
cat_compass: December  3, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December  3, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil: December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler: December  3, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category_monthly
cat_compass: December 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil: December 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler: December 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: December  2, 2018 - December  8, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: November 27, 2016 - December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil: November 27, 2016 - December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler: December  2, 2018 - December  8, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_category_yearly
cat_compass: 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_eraser: 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_pencil: 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

cat_ruler: 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_contenttype
cd_same_apple_orange
cd_same_apple_orange

cd_same_apple_orange_peach
cd_same_apple_orange_peach

cd_same_peach
cd_same_peach

cd_same_same_date
cd_same_same_date
--- expected_contenttype_author
author1
cd_same_same_date
cd_same_apple_orange_peach
cd_same_apple_orange

author2
cd_same_peach
--- expected_contenttype_author_daily
author1: November  1, 2008
cd_same_apple_orange

author1: November  1, 2006
cd_same_apple_orange_peach

author1: November  1, 2004
cd_same_same_date

author2: November  1, 2004
cd_same_peach
--- expected_contenttype_author_monthly
author1: November 2008
cd_same_apple_orange

author1: November 2006
cd_same_apple_orange_peach

author1: November 2004
cd_same_same_date

author2: November 2004
cd_same_peach
--- expected_contenttype_author_weekly
author1: October 26, 2008 - November  1, 2008
cd_same_apple_orange

author1: October 29, 2006 - November  4, 2006
cd_same_apple_orange_peach

author1: October 31, 2004 - November  6, 2004
cd_same_same_date

author2: October 31, 2004 - November  6, 2004
cd_same_peach
--- expected_contenttype_author_yearly
author1: 2008
cd_same_apple_orange

author1: 2006
cd_same_apple_orange_peach

author1: 2004
cd_same_same_date

author2: 2004
cd_same_peach
--- expected_contenttype_category
cat_apple
cd_same_apple_orange_peach
cd_same_apple_orange

cat_orange
cd_same_apple_orange_peach

cat_peach
cd_same_peach
--- expected_contenttype_category_daily
cat_apple: November  1, 2008
cd_same_apple_orange

cat_apple: November  1, 2006
cd_same_apple_orange_peach

cat_orange: November  1, 2006
cd_same_apple_orange_peach

cat_peach: November  1, 2004
cd_same_peach
--- expected_contenttype_category_monthly
cat_apple: November 2008
cd_same_apple_orange

cat_apple: November 2006
cd_same_apple_orange_peach

cat_orange: November 2006
cd_same_apple_orange_peach

cat_peach: November 2004
cd_same_peach
--- expected_contenttype_category_weekly
cat_apple: October 26, 2008 - November  1, 2008
cd_same_apple_orange

cat_apple: October 29, 2006 - November  4, 2006
cd_same_apple_orange_peach

cat_orange: October 29, 2006 - November  4, 2006
cd_same_apple_orange_peach

cat_peach: October 31, 2004 - November  6, 2004
cd_same_peach
--- expected_contenttype_category_yearly
cat_apple: 2008
cd_same_apple_orange

cat_apple: 2006
cd_same_apple_orange_peach

cat_orange: 2006
cd_same_apple_orange_peach

cat_peach: 2004
cd_same_peach
--- expected_todo_contenttype_daily
November  1, 2008
cd_same_apple_orange

November  1, 2006
cd_same_apple_orange_peach

November  1, 2004
cd_same_peach
cd_same_same_date
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26229
--- expected_todo_contenttype_monthly
November 2008
cd_same_apple_orange

November 2006
cd_same_apple_orange_peach

November 2004
cd_same_peach
cd_same_same_date
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26229
--- expected_todo_contenttype_weekly
October 26, 2008 - November  1, 2008
cd_same_apple_orange

October 29, 2006 - November  4, 2006
cd_same_apple_orange_peach

October 31, 2004 - November  6, 2004
cd_same_peach
cd_same_same_date
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26229
--- expected_todo_contenttype_yearly
2008
cd_same_apple_orange

2006
cd_same_apple_orange_peach

2004
cd_same_peach
cd_same_same_date
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26229
--- expected_daily
December  3, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December  3, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December  3, 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_individual
entry_author1_ruler_eraser
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

entry_author1_ruler_eraser
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

entry_author1_compass
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

entry_author2_pencil_eraser
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

entry_author2_no_category
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_monthly
December 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_page
page_author2_no_folder
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

page_author2_water
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

page_author1_coffee
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

page_author1_coffee
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_weekly
December  2, 2018 - December  8, 2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

December  3, 2017 - December  9, 2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

November 27, 2016 - December  3, 2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

November 29, 2015 - December  5, 2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date
--- expected_yearly
2018
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

2017
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

2016
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

2015
cd_same_peach
cd_same_apple_orange_peach
cd_same_apple_orange
cd_same_same_date

=== ArchiveList + Entries (MTC-26278)
--- template
<MTArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><MTArchiveTitle>:
<MTEntries sort_order="ascend"> <MTEntryID>:<MTEntryTitle>
</MTEntries>
</MTArchiveList>
--- expected_author
author1:
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author2:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
--- expected_author_daily
author1: December  3, 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author1: December  3, 2017:
 3:entry_author1_compass

author2: December  3, 2016:
 4:entry_author2_pencil_eraser

author2: December  3, 2015:
 5:entry_author2_no_category
--- expected_author_monthly
author1: December 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author1: December 2017:
 3:entry_author1_compass

author2: December 2016:
 4:entry_author2_pencil_eraser

author2: December 2015:
 5:entry_author2_no_category
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author1: December  3, 2017 - December  9, 2017:
 3:entry_author1_compass

author2: November 27, 2016 - December  3, 2016:
 4:entry_author2_pencil_eraser

author2: November 29, 2015 - December  5, 2015:
 5:entry_author2_no_category
--- expected_author_yearly
author1: 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author1: 2017:
 3:entry_author1_compass

author2: 2016:
 4:entry_author2_pencil_eraser

author2: 2015:
 5:entry_author2_no_category
--- expected_category
cat_compass:
 3:entry_author1_compass

cat_eraser:
 4:entry_author2_pencil_eraser
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_pencil:
 4:entry_author2_pencil_eraser

cat_ruler:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_category_daily
cat_compass: December  3, 2017:
 3:entry_author1_compass

cat_eraser: December  3, 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_eraser: December  3, 2016:
 4:entry_author2_pencil_eraser

cat_pencil: December  3, 2016:
 4:entry_author2_pencil_eraser

cat_ruler: December  3, 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_category_monthly
cat_compass: December 2017:
 3:entry_author1_compass

cat_eraser: December 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_eraser: December 2016:
 4:entry_author2_pencil_eraser

cat_pencil: December 2016:
 4:entry_author2_pencil_eraser

cat_ruler: December 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017:
 3:entry_author1_compass

cat_eraser: December  2, 2018 - December  8, 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_eraser: November 27, 2016 - December  3, 2016:
 4:entry_author2_pencil_eraser

cat_pencil: November 27, 2016 - December  3, 2016:
 4:entry_author2_pencil_eraser

cat_ruler: December  2, 2018 - December  8, 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_category_yearly
cat_compass: 2017:
 3:entry_author1_compass

cat_eraser: 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_eraser: 2016:
 4:entry_author2_pencil_eraser

cat_pencil: 2016:
 4:entry_author2_pencil_eraser

cat_ruler: 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype
cd_same_apple_orange:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cd_same_same_date:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cd_same_apple_orange_peach:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cd_same_peach:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_author
author1:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author2:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_author_daily
author1: October 31, 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author1: October 31, 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author2: October 31, 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_author_monthly
author1: October 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author1: October 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author2: October 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_author_weekly
author1: October 28, 2018 - November  3, 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author1: October 29, 2017 - November  4, 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author2: October 30, 2016 - November  5, 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_author_yearly
author1: 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author1: 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

author2: 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_category
cat_apple:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_orange:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_peach:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_category_daily
cat_apple: October 31, 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_apple: October 31, 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_orange: October 31, 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_peach: October 31, 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_category_monthly
cat_apple: October 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_apple: October 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_orange: October 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_peach: October 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_category_weekly
cat_apple: October 28, 2018 - November  3, 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_apple: October 29, 2017 - November  4, 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_orange: October 29, 2017 - November  4, 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_peach: October 30, 2016 - November  5, 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_category_yearly
cat_apple: 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_apple: 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_orange: 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

cat_peach: 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_daily
October 31, 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

October 31, 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

October 31, 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_monthly
October 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

October 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

October 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_weekly
October 28, 2018 - November  3, 2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

October 29, 2017 - November  4, 2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

October 30, 2016 - November  5, 2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_contenttype_yearly
2018:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

2017:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

2016:
 5:entry_author2_no_category
 4:entry_author2_pencil_eraser
 3:entry_author1_compass
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser
--- expected_daily
December  3, 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

December  3, 2017:
 3:entry_author1_compass

December  3, 2016:
 4:entry_author2_pencil_eraser

December  3, 2015:
 5:entry_author2_no_category
--- expected_individual
entry_author1_ruler_eraser:
 1:entry_author1_ruler_eraser

entry_author1_ruler_eraser:
 2:entry_author1_ruler_eraser

entry_author1_compass:
 3:entry_author1_compass

entry_author2_pencil_eraser:
 4:entry_author2_pencil_eraser

entry_author2_no_category:
 5:entry_author2_no_category
--- expected_monthly
December 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

December 2017:
 3:entry_author1_compass

December 2016:
 4:entry_author2_pencil_eraser

December 2015:
 5:entry_author2_no_category
--- expected_page
page_author2_no_folder:
 10:page_author2_no_folder

page_author2_water:
 9:page_author2_water

page_author1_coffee:
 7:page_author1_coffee

page_author1_coffee:
 8:page_author1_coffee
--- expected_weekly
December  2, 2018 - December  8, 2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

December  3, 2017 - December  9, 2017:
 3:entry_author1_compass

November 27, 2016 - December  3, 2016:
 4:entry_author2_pencil_eraser

November 29, 2015 - December  5, 2015:
 5:entry_author2_no_category
--- expected_yearly
2018:
 1:entry_author1_ruler_eraser
 2:entry_author1_ruler_eraser

2017:
 3:entry_author1_compass

2016:
 4:entry_author2_pencil_eraser

2015:
 5:entry_author2_no_category
