#!/usr/bin/perl

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

use MT::Test::Tag;

plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
    error    => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $blog_01 = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog 01',
        );
        my @archive_types;
        foreach my $key1 ( ( '', 'ContentType' ) ) {
            foreach my $key2 ( ( '', 'Author', 'Category' ) ) {
                foreach my $key3 (
                    ( '', 'Daily', 'Weekly', 'Monthly', 'Yearly' ) )
                {
                    my $at = join '-', ( $key1 || () ), ( $key2 || () ),
                        ( $key3 || () );
                    $at ||= 'Individual,Page';
                    push @archive_types, $at;
                }
            }
        }
        my $archive_types = join ',', @archive_types;
        $blog_01->archive_type($archive_types);
        $blog_01->save;

        my $blog_02 = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog 02',
        );

        my $content_type_01 = MT::Test::Permission->make_content_type(
            blog_id => $blog_01->id,
            name    => 'test content type 01',
        );

        my $content_type_02 = MT::Test::Permission->make_content_type(
            blog_id => $blog_01->id,
            name    => 'test content type 02',
        );

        my $cf_category_01 = MT::Test::Permission->make_content_field(
            blog_id         => $blog_01->id,
            content_type_id => $content_type_01->id,
            name            => 'Category Field 01',
            type            => 'categories',
        );

        my $cf_category_02 = MT::Test::Permission->make_content_field(
            blog_id         => $blog_01->id,
            content_type_id => $content_type_02->id,
            name            => 'Category Field 02',
            type            => 'categories',
        );

        my $category_set_01 = MT::Test::Permission->make_category_set(
            blog_id => $blog_01->id,
            name    => 'test category set 01',
        );

        my $category_set_02 = MT::Test::Permission->make_category_set(
            blog_id => $blog_01->id,
            name    => 'test category set 02',
        );

        my $category_set_03 = MT::Test::Permission->make_category_set(
            blog_id => $blog_02->id,
            name    => 'test category set 03',
        );

        my $category_01 = MT::Test::Permission->make_category(
            blog_id         => $blog_01->id,
            category_set_id => $category_set_01->id,
            label           => 'Category 01',
        );

        my $category_02 = MT::Test::Permission->make_category(
            blog_id         => $blog_01->id,
            category_set_id => $category_set_02->id,
            label           => 'Category 02',
        );

        my $fields_01 = [
            {   id      => $cf_category_01->id,
                order   => 15,
                type    => $cf_category_01->type,
                options => {
                    label        => $cf_category_01->name,
                    category_set => $category_set_01->id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
            },
        ];

        my $fields_02 = [
            {   id      => $cf_category_02->id,
                order   => 15,
                type    => $cf_category_02->type,
                options => {
                    label        => $cf_category_02->name,
                    category_set => $category_set_02->id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
            },
        ];

        $content_type_01->fields($fields_01);
        $content_type_01->save or die $content_type_01->errstr;

        $content_type_02->fields($fields_02);
        $content_type_02->save or die $content_type_02->errstr;
    }
);

my $blog_01 = MT::Blog->load( { name => 'test blog 01' } );

MT::Test::Tag->run_perl_tests( $blog_01->id );

MT::Test::Tag->run_php_tests( $blog_01->id );

__END__

=== mt:Archives template_params="archive_template"
--- template
<mt:Archives><mt:if name="template_params" key="archive_template"><mt:var name="template_params" key="archive_template"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

=== mt:Archives template_params="archive_listing"
--- template
<mt:Archives><mt:if name="template_params" key="archive_listing"><mt:var name="template_params" key="archive_listing"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1

=== mt:Archives template_params="datebased_archive"
--- template
<mt:Archives><mt:if name="template_params" key="datebased_archive"><mt:var name="template_params" key="datebased_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1

=== mt:Archives template_params="entry_archive"
--- template
<mt:Archives><mt:if name="template_params" key="entry_archive"><mt:var name="template_params" key="entry_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="entry_template"
--- template
<mt:Archives><mt:if name="template_params" key="entry_template"><mt:var name="template_params" key="entry_template"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="page_archive"
--- template
<mt:Archives><mt:if name="template_params" key="page_archive"><mt:var name="template_params" key="page_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="page_template"
--- template
<mt:Archives><mt:if name="template_params" key="page_template"><mt:var name="template_params" key="page_template"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="feedback_template"
--- template
<mt:Archives><mt:if name="template_params" key="feedback_template"><mt:var name="template_params" key="feedback_template"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="datebased_only_archive"
--- template
<mt:Archives><mt:if name="template_params" key="datebased_only_archive"><mt:var name="template_params" key="datebased_only_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="datebased_daily_archive"
--- template
<mt:Archives><mt:if name="template_params" key="datebased_daily_archive"><mt:var name="template_params" key="datebased_daily_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="datebased_weekly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="datebased_weekly_archive"><mt:var name="template_params" key="datebased_weekly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="datebased_monthly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="datebased_monthly_archive"><mt:var name="template_params" key="datebased_monthly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="datebased_yearly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="datebased_yearly_archive"><mt:var name="template_params" key="datebased_yearly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="author_archive"
--- template
<mt:Archives><mt:if name="template_params" key="author_archive"><mt:var name="template_params" key="author_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="author_based_archive"
--- template
<mt:Archives><mt:if name="template_params" key="author_based_archive"><mt:var name="template_params" key="author_based_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0

=== mt:Archives template_params="author_daily_archive"
--- template
<mt:Archives><mt:if name="template_params" key="author_daily_archive"><mt:var name="template_params" key="author_daily_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0

=== mt:Archives template_params="author_weekly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="author_weekly_archive"><mt:var name="template_params" key="author_weekly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0

=== mt:Archives template_params="author_monthly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="author_monthly_archive"><mt:var name="template_params" key="author_monthly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0

=== mt:Archives template_params="author_yearly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="author_yearly_archive"><mt:var name="template_params" key="author_yearly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0

=== mt:Archives template_params="category_archive"
--- template
<mt:Archives><mt:if name="template_params" key="category_archive"><mt:var name="template_params" key="category_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0

=== mt:Archives template_params="category_based_archive"
--- template
<mt:Archives><mt:if name="template_params" key="category_based_archive"><mt:var name="template_params" key="category_based_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1

=== mt:Archives template_params="category_set_based_archive"
--- template
<mt:Archives><mt:if name="template_params" key="category_set_based_archive"><mt:var name="template_params" key="category_set_based_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1

=== mt:Archives template_params="category_daily_archive"
--- template
<mt:Archives><mt:if name="template_params" key="category_daily_archive"><mt:var name="template_params" key="category_daily_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0

=== mt:Archives template_params="category_weekly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="category_weekly_archive"><mt:var name="template_params" key="category_weekly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0

=== mt:Archives template_params="category_monthly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="category_monthly_archive"><mt:var name="template_params" key="category_monthly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0

=== mt:Archives template_params="category_yearly_archive"
--- template
<mt:Archives><mt:if name="template_params" key="category_yearly_archive"><mt:var name="template_params" key="category_yearly_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1

=== mt:Archives template_params="contenttype_archive"
--- template
<mt:Archives><mt:if name="template_params" key="contenttype_archive"><mt:var name="template_params" key="contenttype_archive"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0

=== mt:Archives template_params="contenttype_archive_listing"
--- template
<mt:Archives><mt:if name="template_params" key="contenttype_archive_listing"><mt:var name="template_params" key="contenttype_archive_listing"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1

=== mt:Archives template_params="archive_class"
--- template
<mt:Archives><mt:if name="template_params" key="archive_class"><mt:var name="template_params" key="archive_class"><mt:else>0</mt:if><mt:unless name="__last__">,</mt:unless></mt:Archives>
--- expected
entry-archive,page-archive,datebased-daily-archive,datebased-weekly-archive,datebased-monthly-archive,datebased-yearly-archive,author-archive,author-daily-archive,author-weekly-archive,author-monthly-archive,author-yearly-archive,category-archive,category-daily-archive,category-weekly-archive,category-monthly-archive,category-yearly-archive,contenttype-archive,contenttype-daily-archive,contenttype-weekly-archive,contenttype-monthly-archive,contenttype-yearly-archive,contenttype-author-archive,contenttype-author-daily-archive,contenttype-author-weekly-archive,contenttype-author-monthly-archive,contenttype-author-yearly-archive,contenttype-category-archive,contenttype-category-daily-archive,contenttype-category-weekly-archive,contenttype-category-monthly-archive,contenttype-category-yearly-archive

