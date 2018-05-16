#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => 1 * blocks;

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

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $blog
        = MT::Test::Permission->make_blog( parent_id => 0, name => 'test blog' );
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
        {   id      => $cf_category_01->id,
            order   => 1,
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
        {   id      => $cf_category_02->id,
            order   => 1,
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
        identifier      => 'mtarchivelist-test-data 01',
        author_id       => $author_01->id,
        data            => { $cf_category_01->id => [ $category_01->id ], },
    );

    my $content_data_02 = MT::Test::Permission->make_content_data(
        blog_id         => $blog->id,
        content_type_id => $content_type_01->id,
        status          => MT::ContentStatus::RELEASE(),
        authored_on     => '20180927112314',
        identifier      => 'mtarchivelist-test-data 02',
        author_id       => $author_01->id,
        data            => { $cf_category_01->id => [ $category_01->id ], },
    );

    my $content_data_03 = MT::Test::Permission->make_content_data(
        blog_id         => $blog->id,
        content_type_id => $content_type_01->id,
        status          => MT::ContentStatus::RELEASE(),
        authored_on     => '20190927112314',
        identifier      => 'mtarchivelist-test-data 02',
        author_id       => $author_02->id,
        data            => { $cf_category_01->id => [ $category_01->id ], },
    );

    my $content_data_04 = MT::Test::Permission->make_content_data(
        blog_id         => $blog->id,
        content_type_id => $content_type_02->id,
        status          => MT::ContentStatus::RELEASE(),
        authored_on     => '20170927112314',
        identifier      => 'mtarchivelist-test-data 02',
        author_id       => $author_01->id,
        data            => { $cf_category_02->id => [ $category_01->id ], },
    );
});

my $blog = MT::Blog->load( { name => 'test blog' } );

my $content_type_01 = MT::ContentType->load( { name => 'test content type 01' } );

$vars->{content_type_01_unique_id} = $content_type_01->unique_id;

MT::Test::Tag->run_perl_tests( $blog->id );

__END__


=== mt:ArchiveList label="ContentType"
--- template
<mt:ArchiveList type="ContentType" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Daily"
--- template
<mt:ArchiveList type="ContentType-Daily" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Weekly"
--- template
<mt:ArchiveList type="ContentType-Weekly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Monthly"
--- template
<mt:ArchiveList type="ContentType-Monthly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Yearly"
--- template
<mt:ArchiveList type="ContentType-Yearly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Author"
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
12

=== mt:ArchiveList label="ContentType-Author-Daily"
--- template
<mt:ArchiveList type="ContentType-Author-Daily" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Author-Weekly"
--- template
<mt:ArchiveList type="ContentType-Author-Weekly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Author-Monthly"
--- template
<mt:ArchiveList type="ContentType-Author-Monthly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Author-Yearly"
--- template
<mt:ArchiveList type="ContentType-Author-Yearly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
111

=== mt:ArchiveList label="ContentType-Category"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList></mt:CategorySets>
--- expected
3

=== mt:ArchiveList label="ContentType-Category-Daily"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Daily" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList></mt:CategorySets>
--- expected
111

=== mt:ArchiveList label="ContentType-Category-Weekly"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Weekly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList></mt:CategorySets>
--- expected
111

=== mt:ArchiveList label="ContentType-Category-Monthly"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Monthly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList></mt:CategorySets>
--- expected
111

=== mt:ArchiveList label="ContentType-Category-Yearly"
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Yearly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList></mt:CategorySets>
--- expected
111

