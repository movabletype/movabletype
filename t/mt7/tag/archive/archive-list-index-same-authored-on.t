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
        DefaultLanguage      => 'en_US',  ## for now
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

# set same cd_authored_on
my $cd_same_peach  = $objs->{content_data}{cd_same_peach}  or die;
my $cd_other_apple = $objs->{content_data}{cd_other_apple} or die;
$cd_other_apple->authored_on( $cd_same_peach->authored_on );
$cd_other_apple->save or die;

my $ct = $objs->{content_type}{ct_with_same_catset}{content_type}
    or die;

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
\$fileinfo->LoadByIntId($finfo_id);
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

=== MTContents for ct_with_same_catset (MTC-26286)
--- template
<MTArchiveList type="[% archive_type %]" content_type="ct_with_same_catset"><MTArchiveTitle>
<MTContents sort_order="ascend"><MTContentLabel>
</MTContents>
</MTArchiveList>
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

=== MTContents for ct_with_other_catset (MTC-26286)
--- template
<MTArchiveList type="[% archive_type %]" content_type="ct_with_other_catset"><MTArchiveTitle>
<MTContents sort_order="ascend"><MTContentLabel>
</MTContents>
</MTArchiveList>
--- expected_author
author1
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_author_daily
author1: December  3, 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author1: December  3, 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2: December  3, 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2: December  3, 2015
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_author_monthly
author1: December 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author1: December 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2: December 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2: December 2015
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_author_weekly
author1: December  2, 2018 - December  8, 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author1: December  3, 2017 - December  9, 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2: November 27, 2016 - December  3, 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2: November 29, 2015 - December  5, 2015
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_author_yearly
author1: 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author1: 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2: 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

author2: 2015
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_category
cat_compass
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_pencil
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_ruler
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_category_daily
cat_compass: December  3, 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser: December  3, 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser: December  3, 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_pencil: December  3, 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_ruler: December  3, 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_category_monthly
cat_compass: December 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser: December 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser: December 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_pencil: December 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_ruler: December 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_category_weekly
cat_compass: December  3, 2017 - December  9, 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser: December  2, 2018 - December  8, 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser: November 27, 2016 - December  3, 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_pencil: November 27, 2016 - December  3, 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_ruler: December  2, 2018 - December  8, 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_category_yearly
cat_compass: 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser: 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_eraser: 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_pencil: 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

cat_ruler: 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_contenttype
cd_other_apple
cd_other_apple

cd_other_apple_orange_dog_cat
cd_other_apple_orange_dog_cat

cd_other_all_fruit_rabbit
cd_other_all_fruit_rabbit

cd_other_same_date
cd_other_same_date
--- expected_contenttype_author
author1
cd_other_all_fruit_rabbit
cd_other_same_date

author2
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_contenttype_author_daily
author1: November  1, 2004
cd_other_all_fruit_rabbit
cd_other_same_date

author2: October 31, 2016
cd_other_apple

author2: November  1, 2006
cd_other_apple_orange_dog_cat
--- expected_contenttype_author_monthly
author1: November 2004
cd_other_all_fruit_rabbit
cd_other_same_date

author2: October 2016
cd_other_apple

author2: November 2006
cd_other_apple_orange_dog_cat
--- expected_contenttype_author_weekly
author1: October 31, 2004 - November  6, 2004
cd_other_all_fruit_rabbit
cd_other_same_date

author2: October 30, 2016 - November  5, 2016
cd_other_apple

author2: October 29, 2006 - November  4, 2006
cd_other_apple_orange_dog_cat
--- expected_contenttype_author_yearly
author1: 2004
cd_other_all_fruit_rabbit
cd_other_same_date

author2: 2016
cd_other_apple

author2: 2006
cd_other_apple_orange_dog_cat
--- expected_contenttype_category
cat_apple
cd_other_all_fruit_rabbit
cd_other_apple_orange_dog_cat
cd_other_apple

cat_orange
cd_other_all_fruit_rabbit
cd_other_apple_orange_dog_cat

cat_peach
cd_other_all_fruit_rabbit

cat_strawberry
cd_other_all_fruit_rabbit
--- expected_contenttype_category_daily
cat_apple: October 31, 2016
cd_other_apple

cat_apple: November  1, 2006
cd_other_apple_orange_dog_cat

cat_apple: November  1, 2004
cd_other_all_fruit_rabbit

cat_orange: November  1, 2006
cd_other_apple_orange_dog_cat

cat_orange: November  1, 2004
cd_other_all_fruit_rabbit

cat_peach: November  1, 2004
cd_other_all_fruit_rabbit

cat_strawberry: November  1, 2004
cd_other_all_fruit_rabbit
--- expected_contenttype_category_monthly
cat_apple: October 2016
cd_other_apple

cat_apple: November 2006
cd_other_apple_orange_dog_cat

cat_apple: November 2004
cd_other_all_fruit_rabbit

cat_orange: November 2006
cd_other_apple_orange_dog_cat

cat_orange: November 2004
cd_other_all_fruit_rabbit

cat_peach: November 2004
cd_other_all_fruit_rabbit

cat_strawberry: November 2004
cd_other_all_fruit_rabbit
--- expected_contenttype_category_weekly
cat_apple: October 30, 2016 - November  5, 2016
cd_other_apple

cat_apple: October 29, 2006 - November  4, 2006
cd_other_apple_orange_dog_cat

cat_apple: October 31, 2004 - November  6, 2004
cd_other_all_fruit_rabbit

cat_orange: October 29, 2006 - November  4, 2006
cd_other_apple_orange_dog_cat

cat_orange: October 31, 2004 - November  6, 2004
cd_other_all_fruit_rabbit

cat_peach: October 31, 2004 - November  6, 2004
cd_other_all_fruit_rabbit

cat_strawberry: October 31, 2004 - November  6, 2004
cd_other_all_fruit_rabbit
--- expected_contenttype_category_yearly
cat_apple: 2016
cd_other_apple

cat_apple: 2006
cd_other_apple_orange_dog_cat

cat_apple: 2004
cd_other_all_fruit_rabbit

cat_orange: 2006
cd_other_apple_orange_dog_cat

cat_orange: 2004
cd_other_all_fruit_rabbit

cat_peach: 2004
cd_other_all_fruit_rabbit

cat_strawberry: 2004
cd_other_all_fruit_rabbit
--- expected_contenttype_daily
October 31, 2016
cd_other_apple

November  1, 2006
cd_other_apple_orange_dog_cat

November  1, 2004
cd_other_all_fruit_rabbit
cd_other_same_date
--- expected_contenttype_monthly
October 2016
cd_other_apple

November 2006
cd_other_apple_orange_dog_cat

November 2004
cd_other_all_fruit_rabbit
cd_other_same_date
--- expected_contenttype_weekly
October 30, 2016 - November  5, 2016
cd_other_apple

October 29, 2006 - November  4, 2006
cd_other_apple_orange_dog_cat

October 31, 2004 - November  6, 2004
cd_other_all_fruit_rabbit
cd_other_same_date
--- expected_contenttype_yearly
2016
cd_other_apple

2006
cd_other_apple_orange_dog_cat

2004
cd_other_all_fruit_rabbit
cd_other_same_date
--- expected_daily
December  3, 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

December  3, 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

December  3, 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

December  3, 2015
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_individual
entry_author1_ruler_eraser
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

entry_author1_ruler_eraser
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

entry_author1_compass
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

entry_author2_pencil_eraser
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

entry_author2_no_category
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_monthly
December 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

December 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

December 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

December 2015
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_page
page_author2_no_folder
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

page_author2_water
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

page_author1_coffee
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

page_author1_coffee
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_weekly
December  2, 2018 - December  8, 2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

December  3, 2017 - December  9, 2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

November 27, 2016 - December  3, 2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

November 29, 2015 - December  5, 2015
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
--- expected_yearly
2018
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

2017
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

2016
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple

2015
cd_other_all_fruit_rabbit
cd_other_same_date
cd_other_apple_orange_dog_cat
cd_other_apple
