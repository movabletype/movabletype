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

use MT::ContentStatus;
use MT::Template::Context;

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

        my $blog = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog'
        );
        $blog->archive_type('ContentType-Author,ContentType-Category');
        $blog->save;

        my $content_type_01 = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type 01',
        );

        my $content_type_02 = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type 02',
        );

        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $blog->id,
            name    => 'test category set',
        );

        my $cf_datetime_01 = MT::Test::Permission->make_content_field(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            name            => 'date and time',
            type            => 'date_and_time',
        );
        my $cf_datetime_02 = MT::Test::Permission->make_content_field(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            name            => 'date and time',
            type            => 'date_and_time',
        );

        my $cf_category_01 = MT::Test::Permission->make_content_field(
            blog_id            => $blog->id,
            content_type_id    => $content_type_01->id,
            name               => 'categories 01',
            type               => 'categories',
            related_cat_set_id => $category_set->id,
        );

        my $cf_category_02 = MT::Test::Permission->make_content_field(
            blog_id            => $blog->id,
            content_type_id    => $content_type_02->id,
            name               => 'categories 02',
            type               => 'categories',
            related_cat_set_id => $category_set->id,
        );

        my $category_01 = MT::Test::Permission->make_category(
            blog_id         => $blog->id,
            category_set_id => $category_set->id,
            label           => 'category 01',
        );

        my $fields_01 = [
            {   id        => $cf_datetime_01->id,
                order     => 1,
                type      => $cf_datetime_01->type,
                options   => { label => $cf_datetime_01->name },
                unique_id => $cf_datetime_01->unique_id,
            },
            {   id      => $cf_category_01->id,
                order   => 2,
                type    => $cf_category_01->type,
                options => {
                    label        => $cf_category_01->name,
                    category_set => $category_set->id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
            },
        ];

        my $fields_02 = [
            {   id        => $cf_datetime_02->id,
                order     => 1,
                type      => $cf_datetime_02->type,
                options   => { label => $cf_datetime_02->name },
                unique_id => $cf_datetime_02->unique_id,
            },
            {   id      => $cf_category_02->id,
                order   => 2,
                type    => $cf_category_02->type,
                options => {
                    label        => $cf_category_02->name,
                    category_set => $category_set->id,
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

        my $author_01 = MT::Test::Permission->make_author(
            name     => 'yishikawa',
            nickname => 'Yuki Ishikawa',
        );

        my $author_02 = MT::Test::Permission->make_author(
            name     => 'myanagida',
            nickname => 'Masahiro Yanagida',
        );

        my $content_data_01 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20170927112314',
            identifier      => 'mtIfArchiveType-test-data 01',
            author_id       => $author_01->id,
            data            => {
                $cf_category_01->id => [ $category_01->id ],
                $cf_datetime_01->id => '20170701080500',
            },
        );

        my $content_data_02 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20180927112314',
            identifier      => 'mtIfArchiveType-test-data 02',
            author_id       => $author_01->id,
            data            => {
                $cf_category_01->id => [ $category_01->id ],
                $cf_datetime_01->id => '20180801080500',
            },
        );

        my $content_data_03 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20190927112314',
            identifier      => 'mtIfArchiveType-test-data 03',
            author_id       => $author_02->id,
            data            => {
                $cf_category_01->id => [ $category_01->id ],
                $cf_datetime_01->id => '20190901080500',
            },
        );

        my $content_data_04 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20170927112314',
            identifier      => 'mtIfArchiveType-test-data 04',
            author_id       => $author_01->id,
            data            => {
                $cf_category_02->id => [ $category_01->id ],
                $cf_datetime_02->id => '20181010180500',
            },
        );

        my $template_01 = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            name            => 'ContentType Test 01',
            type            => 'ct',
            text            => 'test 01',
        );
        my $template_02 = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            name            => 'ContentType Test 02',
            type            => 'ct',
            text            => 'test 02',
        );

        my $map_01 = MT::Test::Permission->make_templatemap(
            template_id   => $template_01->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Weekly',
            file_template => '%y/%m/%d-week/%i',
            is_preferred  => 1,
            dt_field_id   => $cf_datetime_01->id,
        );

        my $map_02 = MT::Test::Permission->make_templatemap(
            template_id   => $template_02->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Weekly',
            file_template => '%y/%m/%d-week/%i',
            is_preferred  => 1,
            dt_field_id   => $cf_datetime_02->id,
        );
    }
);

my $blog = MT::Blog->load( { name => 'test blog' } );

my $content_type_01
    = MT::ContentType->load( { name => 'test content type 01' } );

$vars->{content_type_01_unique_id} = $content_type_01->unique_id;
$vars->{content_type_01_name}      = $content_type_01->name;
$vars->{content_type_01_id}        = $content_type_01->id;

MT::Test::Tag->run_perl_tests( $blog->id );

my ($template)
    = MT->model('template')
    ->load( { content_type_id => $content_type_01->id } );
my @maps = MT->model('templatemap')->load( { template_id => $template->id } );
foreach my $map (@maps) {
    $map->build_type(3);
    $map->save;
}

MT::Test::Tag->run_php_tests( $blog->id );

__END__


=== mt:IfArchiveType type="ContentType"
--- template
<mt:ArchiveList type="ContentType" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111


=== mt:IfArchiveType type="ContentType-Daily"
--- template
<mt:ArchiveList type="ContentType-Daily" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Daily" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType type="ContentType-Weekly"
--- template
<mt:ArchiveList type="ContentType-Weekly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Weekly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType type="ContentType-Monthly"
--- template
<mt:ArchiveList type="ContentType-Monthly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Monthly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType type="ContentType-Yearly"
--- template
<mt:ArchiveList type="ContentType-Yearly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Yearly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType type="ContentType-Author"
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Author" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
11

=== mt:IfArchiveType type="ContentType-Author-Daily"
--- template
<mt:ArchiveList type="ContentType-Author-Daily" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Author-Daily" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType type="ContentType-Author-Weekly"
--- template
<mt:ArchiveList type="ContentType-Author-Weekly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Author-Weekly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType type="ContentType-Author-Monthly"
--- template
<mt:ArchiveList type="ContentType-Author-Monthly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Author-Monthly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType type="ContentType-Author-Yearly"
--- template
<mt:ArchiveList type="ContentType-Author-Yearly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Author-Yearly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType type="ContentType-Category"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Category" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList></mt:CategorySets>
--- expected
1

=== mt:IfArchiveType type="ContentType-Category-Daily"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Daily" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Category-Daily" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList></mt:CategorySets>
--- expected
111

=== mt:IfArchiveType type="ContentType-Category-Weekly"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Weekly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Category-Weekly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList></mt:CategorySets>
--- expected
111

=== mt:IfArchiveType type="ContentType-Category-Monthly"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Monthly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Category-Monthly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList></mt:CategorySets>
--- expected
111

=== mt:IfArchiveType type="ContentType-Category-Yearly"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Yearly" content_type="[% content_type_01_unique_id %]"><mt:IfArchiveType type="ContentType-Category-Yearly" content_type="[% content_type_01_unique_id %]">1</mt:IfArchiveType></mt:ArchiveList></mt:CategorySets>
--- expected
111

=== mt:IfArchiveType with content_type="name"
--- template
<mt:ArchiveList type="ContentType" content_type="[% content_type_01_name %]"><mt:IfArchiveType type="ContentType" content_type="[% content_type_01_name %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

=== mt:IfArchiveType with content_type="id"
--- template
<mt:ArchiveList type="ContentType" content_type="[% content_type_01_id %]"><mt:IfArchiveType type="ContentType" content_type="[% content_type_01_id %]">1</mt:IfArchiveType></mt:ArchiveList>
--- expected
111

