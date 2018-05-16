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

plan tests => 6;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

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

        my $author1 = MT->model('author')->load(1);
        $author1->nickname('test1');
        $author1->save;

        my $author2 = MT::Test::Permission->make_author(
            name     => 'test user2',
            nickname => 'test2'
        );

        my $blog = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog 01',
        );
        $blog->archive_type(
            'ContentType-Category,ContentType-Author,ContentType-Monthly');
        $blog->save;

        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $blog->id,
            name    => 'test category set',
        );

        my $category1 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category1',
        );
        my $category2 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category2',
        );
        my $category3 = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category3',
        );
        my $ct = MT::Test::Permission->make_content_type(
            name    => 'test content type',
            blog_id => $blog->id,
        );
        my $cat_cf = MT::Test::Permission->make_content_field(
            blog_id            => $ct->blog->id,
            content_type_id    => $ct->id,
            name               => 'categories',
            type               => 'categories',
            related_cat_set_id => $category_set->id,
        );
        my $date_cf = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog->id,
            content_type_id => $ct->id,
            name            => 'date and time',
            type            => 'date_and_time',
        );
        my $fields = [
            {   id      => $cat_cf->id,
                order   => 1,
                type    => $cat_cf->type,
                options => {
                    label        => 1,
                    category_set => $cat_cf->related_cat_set_id,
                },
                unique_id => $cat_cf->unique_id,
            },
            {   id        => $date_cf->id,
                order     => 2,
                type      => $date_cf->type,
                options   => { label => $date_cf->name },
                unique_id => $date_cf->unique_id,
            },
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $cd1 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $ct->id,
            data            => {
                $cat_cf->id  => [ $category1->id ],
                $date_cf->id => '20180308180500',
            },
        );
        my $cd2 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $ct->id,
            data            => {
                $cat_cf->id  => [ $category2->id ],
                $date_cf->id => '20180407180500',
            },
        );
        my $cd3 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $ct->id,
            author_id       => $author2->id,
            data            => {
                $cat_cf->id  => [ $category3->id ],
                $date_cf->id => '20180506180500',
            },
        );

        my $template = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $ct->id,
            name            => 'ContentType Test 01',
            type            => 'ct',
            text            => 'test 01',
        );

        my $map_01 = MT::Test::Permission->make_templatemap(
            template_id   => $template->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Category',
            file_template => '%-c/%i',
            is_preferred  => 1,
            cat_field_id  => $cat_cf->id,
        );
        my $map_02 = MT::Test::Permission->make_templatemap(
            template_id   => $template->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Author',
            file_template => 'author/%-a/%f',
            is_preferred  => 1,
        );
        my $map_03 = MT::Test::Permission->make_templatemap(
            template_id   => $template->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Monthly',
            file_template => '%y/%m/%i',
            is_preferred  => 1,
            dt_field_id   => $date_cf->id,
        );
    }
);

my $blog = MT::Blog->load( { name => 'test blog 01' } );

my $content_type = MT::ContentType->load( { name => 'test content type' } );

$vars->{content_type_unique_id} = $content_type->unique_id;

MT::Test::Tag->run_perl_tests( $blog->id );

# MT::Test::Tag->run_php_tests($blog->id);

__END__

=== MT:ArchiveNext with Date Field
--- template
<mt:Contents content_type="[% content_type_unique_id %]" glue=","><mt:Archives><mt:if name="template_params" key="datebased_archive"><mt:ArchiveList><mt:ArchiveNext><mt:ArchiveTitle></mt:ArchiveNext></mt:ArchiveList></mt:If></mt:Archives></mt:Contents>
--- expected
May 2018,April 2018

=== MT:ArchivePrevious with Date Field
--- template
<mt:Contents content_type="[% content_type_unique_id %]" glue=","><mt:Archives><mt:if name="template_params" key="datebased_archive"><mt:ArchiveList><mt:ArchivePrevious><mt:ArchiveTitle></mt:ArchivePrevious></mt:ArchiveList></mt:If></mt:Archives></mt:Contents>
--- expected
April 2018,March 2018

=== MT:ArchiveNext with Author
--- template
<mt:Archives><mt:if name="template_params" key="author_based_archive"><mt:ArchiveList glue=","><mt:ArchiveNext content_type="[% content_type_unique_id %]"><mt:ArchiveTitle></mt:ArchiveNext></mt:ArchiveList></mt:if></mt:Archives>
--- expected
test2

=== MT:ArchivePrevious with Author
--- template
<mt:Archives><mt:if name="template_params" key="author_based_archive"><mt:ArchiveList glue=","><mt:ArchivePrevious content_type="[% content_type_unique_id %]"><mt:ArchiveTitle></mt:ArchivePrevious></mt:ArchiveList></mt:if></mt:Archives>
--- expected
test1

=== MT:ArchiveNext with Category
--- template
<mt:Archives><mt:if name="template_params" key="category_set_based_archive"><mt:CategorySets><mt:ArchiveList glue=","><mt:ArchiveNext content_type="[% content_type_unique_id %]"><mt:ArchiveTitle></mt:ArchiveNext></mt:ArchiveList></mt:CategorySets></mt:if></mt:Archives>
--- expected
category2,category3

=== MT:ArchivePrevious with Category
--- template
<mt:Archives><mt:if name="template_params" key="category_set_based_archive"><mt:CategorySets><mt:ArchiveList glue=","><mt:ArchivePrevious content_type="[% content_type_unique_id %]"><mt:ArchiveTitle></mt:ArchivePrevious></mt:ArchiveList></mt:CategorySets></mt:if></mt:Archives>
--- expected
category1,category2

