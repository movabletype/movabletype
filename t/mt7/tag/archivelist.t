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
use MT::Test qw(:db);
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
    template       => [qw( var chomp )],
    expected       => [qw( var chomp )],
    expected_error => [qw( chomp )],
};

my $blog
    = MT::Test::Permission->make_blog( parent_id => 0, name => 'test blog' );
$blog->archive_type('ContentType-Author,ContentType-Category,ContentType-Category-Monthly');
$blog->save;

my $content_type_01 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'test content type 01',
);

my $content_type_02 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'test content type 02',
);

my $content_type_03 = MT::Test::Permission->make_content_type(
    blog_id => $blog->id,
    name    => 'test content type 03',
);

my $author_01 = MT::Test::Permission->make_author(
    name     => 'yishikawa',
    nickname => 'Yuki Ishikawa',
);

my $author_02 = MT::Test::Permission->make_author(
    name     => 'myanagida',
    nickname => 'Masahiro Yanagida',
);

my $category_set = MT::Test::Permission->make_category_set(
    blog_id => $content_type_01->blog_id,
    name    => 'test category set',
);
my $cf_category = MT::Test::Permission->make_content_field(
    blog_id            => $content_type_01->blog_id,
    content_type_id    => $content_type_01->id,
    name               => 'categories',
    type               => 'categories',
    related_cat_set_id => $category_set->id,
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

my $fields = [
    {   id      => $cf_category->id,
        order   => 15,
        type    => $cf_category->type,
        options => {
            label        => $cf_category->name,
            category_set => $category_set->id,
            multiple     => 1,
            max          => 5,
            min          => 1,
        },
    },
];
$content_type_01->fields($fields);
$content_type_01->save or die $content_type_01->errstr;


my $cf_category_03 = MT::Test::Permission->make_content_field(
    blog_id            => $content_type_03->blog_id,
    content_type_id    => $content_type_03->id,
    name               => 'categories',
    type               => 'categories',
    related_cat_set_id => $category_set->id,
);
my $fields_03 = [
    {   id      => $cf_category_03->id,
        order   => 15,
        type    => $cf_category_03->type,
        options => {
            label        => $cf_category_03->name,
            category_set => $category_set->id,
            multiple     => 1,
            max          => 5,
            min          => 1,
        },
    },
];
$content_type_03->fields($fields_03);
$content_type_03->save or die $content_type_03->errstr;

my $content_data_01 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type_01->id,
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
    identifier      => 'mtarchivelist-test-data 01',
    author_id       => $author_01->id,
    data            => {
        $cf_category->id => [ $category2->id ],
    },
);

my $content_data_02 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type_01->id,
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
    identifier      => 'mtarchivelist-test-data 02',
    author_id       => $author_02->id,
);

my $content_data_03 = MT::Test::Permission->make_content_data(
    blog_id         => $blog->id,
    content_type_id => $content_type_02->id,
    status          => MT::Entry::RELEASE(),
    authored_on     => '20170927112314',
    identifier      => 'mtarchivelist-test-data 02',
    author_id       => $author_02->id,
);

my $template = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $content_type_01->id,
    name            => 'ContentType Test 01',
    type            => 'ct_archive',
    text            => 'test 01',
);

my $map_01 = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType-Category',
    file_template => '%-c/%i',
    is_preferred  => 1,
    cat_field_id  => $cf_category->id,
    build_type    => 3,
);
my $map_02 = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType-Author',
    file_template => 'author/%-a/%f',
    is_preferred  => 1,
    build_type    => 3,
);
my $map_03 = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType-Category-Monthly',
    file_template => '%-c/%y/%m/%i',
    is_preferred  => 1,
    cat_field_id  => $cf_category->id,
    build_type    => 3,
);

my $template_03 = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    content_type_id => $content_type_03->id,
    name            => 'ContentType Test 03',
    type            => 'ct_archive',
    text            => 'test 03',
);

my $map_04 = MT::Test::Permission->make_templatemap(
    template_id   => $template_03->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType-Category',
    file_template => '%-c/%i',
    is_preferred  => 1,
    cat_field_id  => $cf_category_03->id,
    build_type    => 3,
);
$vars->{content_type_01_unique_id} = $content_type_01->unique_id;
$vars->{content_type_02_unique_id} = $content_type_02->unique_id;
$vars->{content_type_03_unique_id} = $content_type_03->unique_id;
$vars->{content_type_01_name}      = $content_type_01->unique_id;
$vars->{content_type_02_name}      = $content_type_02->unique_id;
$vars->{content_type_01_id}        = $content_type_01->id;
$vars->{content_type_02_id}        = $content_type_02->id;

MT::Test::Tag->run_perl_tests( $blog->id );

MT::Test::Tag->run_php_tests( $blog->id );

__END__

=== mt:ArchiveList label="No content_type"
--- template
<mt:ArchiveList type="ContentType-Author"><mt:ArchiveCount></mt:ArchiveList>
--- expected_error
No Content Type could be found.

=== mt:ArchiveList unique_id 01
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
11

=== mt:ArchiveList unique_id 02
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_02_unique_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
1

=== mt:ArchiveList name 01
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_name %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
11

=== mt:ArchiveList name 02
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_02_name %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
1

=== mt:ArchiveList id 01
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
11

=== mt:ArchiveList id 02
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_02_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
1

=== mt:ArchiveList type="ContentType-Category"
--- template
<mt:ArchiveList type="ContentType-Category" content_type="[% content_type_01_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
1

=== mt:ArchiveList type="ContentType-Category-Monthly"
--- template
<mt:ArchiveList type="ContentType-Category-Monthly" content_type="[% content_type_01_id %]"><mt:ArchiveCount></mt:ArchiveList>
--- expected
1

=== mt:ArchiveList type="ContentType-Category" with category_set
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category" content_type="[% content_type_01_id %]"><mt:ArchiveCount></mt:ArchiveList></mt:CategorySets>
--- expected
1

=== mt:ArchiveList type="ContentType-Category-Monthly" with category_set
--- template
<mt:CategorySets><mt:ArchiveList type="ContentType-Category-Monthly" content_type="[% content_type_01_id %]"><mt:ArchiveCount></mt:ArchiveList></mt:CategorySets>
--- expected
1

=== mt:ArchiveList type="ContentType-Category"
--- template
<mt:ArchiveList type="ContentType-Category" content_type="[% content_type_03_unique_id %]"><mt:CategoryLabel></mt:ArchiveList>
--- expected

