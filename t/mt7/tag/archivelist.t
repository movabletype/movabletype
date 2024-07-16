#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

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
$blog->archive_type(join(',', 'ContentType-Author', 'ContentType-Category', 'ContentType-Category-Monthly',
                        'ContentType-Category-Weekly', 'ContentType-Category-Yearly', 'ContentType-Category-Daily'));
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

my $map_05 = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType-Category-Weekly',
    file_template => '%-c/%y/%m/%d-week/%i',
    is_preferred  => 1,
    cat_field_id  => $cf_category->id,
    build_type    => 3,
);

my $map_06 = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType-Category-Yearly',
    file_template => '%-c/%y/%i',
    is_preferred  => 1,
    cat_field_id  => $cf_category->id,
    build_type    => 3,
);

my $map_07 = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType-Category-Daily',
    file_template => '%-c/%y/%i',
    is_preferred  => 1,
    cat_field_id  => $cf_category->id,
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

=== mt:ArchiveList nested ContentType-Daily
--- template
<mt:ArchiveList type="ContentType-Yearly" content_type="[% content_type_01_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Daily" content_type="[% content_type_01_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[2017]September 27, 2017;

=== mt:ArchiveList nested ContentType-Weekly
--- template
<mt:ArchiveList type="ContentType-Yearly" content_type="[% content_type_01_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Weekly" content_type="[% content_type_01_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[2017]September 24, 2017 - September 30, 2017;

=== mt:ArchiveList nested ContentType-Monthly
--- template
<mt:ArchiveList type="ContentType-Yearly" content_type="[% content_type_01_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Monthly" content_type="[% content_type_01_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[2017]September 2017;

=== mt:ArchiveList nested ContentType-Yearly
--- template
<mt:ArchiveList type="ContentType-Yearly" content_type="[% content_type_01_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Yearly" content_type="[% content_type_01_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[2017]2017;

=== mt:ArchiveList mt:ArchiveTitle for author (TODO Fix php MTC-29633)
--- skip_php
--- template
<mt:ArchiveList type="ContentType-Author" content_type="[% content_type_01_unique_id %]">[<mt:ArchiveTitle>]</mt:ArchiveList>
--- expected
[Masahiro Yanagida][Yuki Ishikawa]

=== mt:ArchiveList nested ContentType-Author-Daily (TODO Fix php MTC-29633)
--- skip_php
--- template
<mt:ArchiveList type="ContentType-Author-Yearly" content_type="[% content_type_01_unique_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Author-Daily" content_type="[% content_type_01_unique_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[Masahiro Yanagida: 2017]Masahiro Yanagida: September 27, 2017;[Yuki Ishikawa: 2017]Yuki Ishikawa: September 27, 2017;

=== mt:ArchiveList nested ContentType-Author-Weekly (TODO Fix php MTC-29633)
--- skip_php
--- template
<mt:ArchiveList type="ContentType-Author-Yearly" content_type="[% content_type_01_unique_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Author-Weekly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[Masahiro Yanagida: 2017]Masahiro Yanagida: September 24, 2017 - September 30, 2017;[Yuki Ishikawa: 2017]Yuki Ishikawa: September 24, 2017 - September 30, 2017;

=== mt:ArchiveList nested ContentType-Author-Monthly (TODO Fix php MTC-29633)
--- skip_php
--- template
<mt:ArchiveList type="ContentType-Author-Yearly" content_type="[% content_type_01_unique_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Author-Monthly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[Masahiro Yanagida: 2017]Masahiro Yanagida: September 2017;[Yuki Ishikawa: 2017]Yuki Ishikawa: September 2017;

=== mt:ArchiveList nested ContentType-Author-Yearly (TODO Fix php MTC-29633)
--- skip_php
--- template
<mt:ArchiveList type="ContentType-Author-Yearly" content_type="[% content_type_01_unique_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Author-Yearly" content_type="[% content_type_01_unique_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[Masahiro Yanagida: 2017]Masahiro Yanagida: 2017;[Yuki Ishikawa: 2017]Yuki Ishikawa: 2017;

=== mt:ArchiveList nested ContentType-Category-Daily
--- template
<mt:ArchiveList type="ContentType-Category-Yearly" content_type="[% content_type_01_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Category-Daily" content_type="[% content_type_01_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[category2: 2017]category2: September 27, 2017;

=== mt:ArchiveList nested ContentType-Category-Weekly
--- template
<mt:ArchiveList type="ContentType-Category-Yearly" content_type="[% content_type_01_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Category-Weekly" content_type="[% content_type_01_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[category2: 2017]category2: September 24, 2017 - September 30, 2017;

=== mt:ArchiveList nested ContentType-Category-Monthly
--- template
<mt:ArchiveList type="ContentType-Category-Yearly" content_type="[% content_type_01_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Category-Monthly" content_type="[% content_type_01_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[category2: 2017]category2: September 2017;

=== mt:ArchiveList nested ContentType-Category-Yearly
--- template
<mt:ArchiveList type="ContentType-Category-Yearly" content_type="[% content_type_01_id %]">[<mt:ArchiveTitle>]<mt:ArchiveList type="ContentType-Category-Yearly" content_type="[% content_type_01_id %]"><mt:ArchiveTitle>;</mt:ArchiveList></mt:ArchiveList>
--- expected
[category2: 2017]category2: 2017;
