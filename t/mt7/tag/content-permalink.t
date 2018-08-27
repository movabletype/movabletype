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
use MT::ContentPublisher;

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
my $publisher = MT::ContentPublisher->new( start_time => time() + 10 );

my @archive_types = (
    'ContentType',                 'ContentType-Daily',
    'ContentType-Weekly',          'ContentType-Monthly',
    'ContentType-Yearly',          'ContentType-Author',
    'ContentType-Author-Daily',    'ContentType-Author-Weekly',
    'ContentType-Author-Monthly',  'ContentType-Author-Yearly',
    'ContentType-Category',        'ContentType-Category-Daily',
    'ContentType-Category-Weekly', 'ContentType-Category-Monthly',
    'ContentType-Category-Yearly',
);

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $blog = MT::Test::Permission->make_blog( name => 'my blog', );
        $blog->archive_url('/::/test/archives/');
        my $archive_types = join ',', @archive_types;
        $blog->archive_type($archive_types);
        $blog->save;

        my $content_type_01 = MT::Test::Permission->make_content_type(
            name    => 'test content type 01',
            blog_id => $blog->id,
        );

        my $content_type_02 = MT::Test::Permission->make_content_type(
            name    => 'test content type 02',
            blog_id => $blog->id,
        );

        my $content_type_03 = MT::Test::Permission->make_content_type(
            name    => 'test content type 03',
            blog_id => $blog->id,
        );

        my $cf_category = MT::Test::Permission->make_content_field(
            blog_id         => $blog->id,
            content_type_id => $content_type_03->id,
            name            => 'category field 03',
            type            => 'categories',
        );

        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $blog->id,
            name    => 'test category set',
        );

        my $category = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => 'category',
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
        $content_type_03->fields($fields);
        $content_type_03->save or die $content_type_03->errstr;

        my $content_data_01 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20170927112314',
            identifier      => 'mtcontentpermalink-test-data-01',
        );

        my $content_data_02 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20170927112314',
            identifier      => 'mtcontentpermalink-test-data-02',
        );

        my $content_data_03 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_03->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20170927112314',
            identifier      => 'mtcontentpermalink-test-data-03',
            data            => { $cf_category->id => [ $category->id ], },
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

        my $template_03 = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_type_03->id,
            name            => 'ContentType Test 03',
            type            => 'ct',
            text            => 'test 03',
        );

        my $map_01 = MT::Test::Permission->make_templatemap(
            template_id   => $template_01->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType',
            file_template => '%y/%m/%-f',
            is_preferred  => 1,
        );

        my $map_02 = MT::Test::Permission->make_templatemap(
            template_id   => $template_02->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType',
            file_template => '%y/%m/%-b/%i',
            is_preferred  => 1,
        );

        my $map_03 = MT::Test::Permission->make_templatemap(
            template_id   => $template_03->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType',
            file_template => '%-c/%-f',
            is_preferred  => 1,
            cat_field_id  => $cf_category->id,
        );

        my $website = MT::Test::Permission->make_website( name => 'content permalink website', );
        $website->site_url('https://localhost/');
        $website->archive_url('');
        $website->archive_type($archive_types);
        $website->save or die $website->errstr;

        my $content_type_04 = MT::Test::Permission->make_content_type(
            name    => 'test content type 04',
            blog_id => $website->id,
        );

        my $cf_category2 = MT::Test::Permission->make_content_field(
            blog_id         => $website->id,
            content_type_id => $content_type_04->id,
            name            => 'category field 04',
            type            => 'categories',
        );

        my $category_set2 = MT::Test::Permission->make_category_set(
            blog_id => $website->id,
            name    => 'test category set2',
        );

        my $category2 = MT::Test::Permission->make_category(
            blog_id         => $category_set2->blog_id,
            category_set_id => $category_set2->id,
            label           => 'category',
        );

        my $fields2 = [
            {   id      => $cf_category2->id,
                order   => 15,
                type    => $cf_category2->type,
                options => {
                    label        => $cf_category2->name,
                    category_set => $category_set2->id,
                    multiple     => 1,
                    max          => 5,
                    min          => 1,
                },
            },
        ];
        $content_type_04->fields($fields2);
        $content_type_04->save or die $content_type_04->errstr;

        my $content_data_04 = MT::Test::Permission->make_content_data(
            blog_id         => $website->id,
            content_type_id => $content_type_04->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20170927112314',
            identifier      => 'mtcontentpermalink-test-data-04',
            data            => { $cf_category2->id => [ $category2->id ], },
        );


        my $template_04 = MT::Test::Permission->make_template(
            blog_id         => $website->id,
            content_type_id => $content_type_04->id,
            name            => 'ContentType Test 04',
            type            => 'ct',
            text            => 'test 04',
        );

        my $map_04 = MT::Test::Permission->make_templatemap(
            template_id   => $template_04->id,
            blog_id       => $website->id,
            archive_type  => 'ContentType',
            file_template => '%y/%m/%-f',
            is_preferred  => 1,
            cat_field_id  => $cf_category2->id,
        );

        my $mt = MT->new or die MT->errstr;
        for my $map (
            ( $map_01, $map_02, $map_03, $map_04 ) )
        {
            $mt->rebuild(
                BlogID => $map->blog_id,
                Force  => 1,
                ArchiveType => $map->archive_type,
                TemplateMap => ($map),
            ) || diag "Rebuild error: ", $mt->errstr;
        }

        for my $content_type (
            ( $content_type_01, $content_type_02, $content_type_03, $content_type_04 ) )
        {
            my $tmpl_archive = MT::Test::Permission->make_template(
                blog_id         => $content_type->blog_id,
                content_type_id => $content_type->id,
                name            => $content_type->name . ' archive_tmpl',
                type            => 'ct_archive',
                text            => 'test ct_archive ' . $content_type->name,
            );
            foreach my $type (@archive_types) {
                next if($type =~ /^ContentType$/);
                next if ( $type =~ /Category/ && ($content_type != $content_type_03 && $content_type != $content_type_04) );
                my $archiver = $publisher->archiver($type);
                my $tmpls    = $archiver->default_archive_templates;
                my ($default) = grep { $_->{default} } @$tmpls;

                my $tmpl_map = MT::Test::Permission->make_templatemap(
                    blog_id       => $content_type->blog_id,
                    archive_type  => $type,
                    build_type    => MT::PublishOption::DYNAMIC(),
                    is_preferred  => 1,
                    template_id   => $tmpl_archive->id,
                    file_template => $default->{template},
                    dt_field_id   => 0,
                );

                if ( $type =~ /Category/ ) {
                    if($content_type == $content_type_03){
                        $tmpl_map->cat_field_id( $cf_category->id );
                    } elsif($content_type == $content_type_04){
                        $tmpl_map->cat_field_id( $cf_category2->id );
                    }
                    $tmpl_map->save;
                }
                $mt->rebuild(
                    BlogID => $content_type->blog_id,
                    Force  => 1,
                    ArchiveType => $type,
                    TemplateMap => ($tmpl_map),
                ) || diag "Rebuild error: ", $mt->errstr;

            }
        }
    }
);

my $blog = MT::Blog->load( { name => 'my blog' } );

my $content_type_01
    = MT::ContentType->load( { name => 'test content type 01' } );
my $content_type_02
    = MT::ContentType->load( { name => 'test content type 02' } );
my $content_type_03
    = MT::ContentType->load( { name => 'test content type 03' } );
my $content_type_04
    = MT::ContentType->load( { name => 'test content type 04' } );

my $website = MT::Website->load( { name => 'content permalink website' } );

$vars->{content_type_01_unique_id} = $content_type_01->unique_id;
$vars->{content_type_02_unique_id} = $content_type_02->unique_id;
$vars->{content_type_03_unique_id} = $content_type_03->unique_id;
$vars->{content_type_04_unique_id} = $content_type_04->unique_id;

$vars->{website_id} = $website->id;

MT::Test::Tag->run_perl_tests( $blog->id );

MT::Test::Tag->run_php_tests( $blog->id );

__END__

=== MT::ContentPermalink
--- template
<mt:Contents><mt:ContentPermalink>
</mt:Contents>
--- expected
/test/archives/category/mtcontentpermalink-test-data-03.html
/test/archives/2017/09/mtcontentpermalink-test-data-02/
/test/archives/2017/09/mtcontentpermalink-test-data-01.html

=== MT::ContentPermalink ContentType 01
--- template
<mt:Contents content_type="[% content_type_01_unique_id %]"><mt:ContentPermalink></mt:Contents>
--- expected
/test/archives/2017/09/mtcontentpermalink-test-data-01.html

=== MT::ContentPermalink ContentType 02
--- template
<mt:Contents content_type="[% content_type_02_unique_id %]"><mt:ContentPermalink></mt:Contents>
--- expected
/test/archives/2017/09/mtcontentpermalink-test-data-02/

=== MT::ContentPermalink ContentType 02 with index
--- template
<mt:Contents content_type="[% content_type_02_unique_id %]"><mt:ContentPermalink with_index="1"></mt:Contents>
--- expected
/test/archives/2017/09/mtcontentpermalink-test-data-02/index.html

=== MT::ContentPermalink ContentType 03
--- template
<mt:Contents content_type="[% content_type_03_unique_id %]"><mt:ContentPermalink></mt:Contents>
--- expected
/test/archives/category/mtcontentpermalink-test-data-03.html

=== MT::ContentPermalink archive_type="ContentType"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType">
</mt:Contents>
--- expected
/test/archives/category/mtcontentpermalink-test-data-03.html
/test/archives/2017/09/mtcontentpermalink-test-data-02/
/test/archives/2017/09/mtcontentpermalink-test-data-01.html

=== MT::ContentPermalink archive_type="ContentType-Daily"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Daily">
</mt:Contents>
--- expected
/test/archives/2017/09/27/#000003
/test/archives/2017/09/27/#000002
/test/archives/2017/09/27/#000001

=== MT::ContentPermalink archive_type="ContentType-Weekly"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Weekly">
</mt:Contents>
--- expected
/test/archives/2017/09/24-week/#000003
/test/archives/2017/09/24-week/#000002
/test/archives/2017/09/24-week/#000001

=== MT::ContentPermalink archive_type="ContentType-Monthly"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Monthly">
</mt:Contents>
--- expected
/test/archives/2017/09/#000003
/test/archives/2017/09/#000002
/test/archives/2017/09/#000001

=== MT::ContentPermalink archive_type="ContentType-Yearly"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Yearly">
</mt:Contents>
--- expected
/test/archives/2017/#000003
/test/archives/2017/#000002
/test/archives/2017/#000001

=== MT::ContentPermalink archive_type="ContentType-Author"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Author">
</mt:Contents>
--- expected
/test/archives/author/authorce2f3/#000003
/test/archives/author/authorce2f3/#000002
/test/archives/author/authorce2f3/#000001

=== MT::ContentPermalink archive_type="ContentType-Author-Daily"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Author-Daily">
</mt:Contents>
--- expected
/test/archives/author/authorce2f3/2017/09/27/#000003
/test/archives/author/authorce2f3/2017/09/27/#000002
/test/archives/author/authorce2f3/2017/09/27/#000001

=== MT::ContentPermalink archive_type="ContentType-Author-Weekly"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Author-Weekly">
</mt:Contents>
--- expected
/test/archives/author/authorce2f3/2017/09/24-week/#000003
/test/archives/author/authorce2f3/2017/09/24-week/#000002
/test/archives/author/authorce2f3/2017/09/24-week/#000001

=== MT::ContentPermalink archive_type="ContentType-Author-Monthly"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Author-Monthly">
</mt:Contents>
--- expected
/test/archives/author/authorce2f3/2017/09/#000003
/test/archives/author/authorce2f3/2017/09/#000002
/test/archives/author/authorce2f3/2017/09/#000001

=== MT::ContentPermalink archive_type="ContentType-Author-Yearly"
--- template
<mt:Contents><mt:ContentPermalink archive_type="ContentType-Author-Yearly">
</mt:Contents>
--- expected
/test/archives/author/authorce2f3/2017/#000003
/test/archives/author/authorce2f3/2017/#000002
/test/archives/author/authorce2f3/2017/#000001

=== MT::ContentPermalink archive_type="ContentType-Category"
--- template
<mt:Contents content_type="[% content_type_03_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category">
</mt:Contents>
--- expected
/test/archives/category/#000003

=== MT::ContentPermalink archive_type="ContentType-Category-Daily"
--- template
<mt:Contents content_type="[% content_type_03_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category-Daily">
</mt:Contents>
--- expected
/test/archives/category/2017/09/27/#000003

=== MT::ContentPermalink archive_type="ContentType-Category-Weekly"
--- template
<mt:Contents content_type="[% content_type_03_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category-Weekly">
</mt:Contents>
--- expected
/test/archives/category/2017/09/24-week/#000003

=== MT::ContentPermalink archive_type="ContentType-Category-Monthly"
--- template
<mt:Contents content_type="[% content_type_03_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category-Monthly">
</mt:Contents>
--- expected
/test/archives/category/2017/09/#000003

=== MT::ContentPermalink archive_type="ContentType-Category-Yearly"
--- template
<mt:Contents content_type="[% content_type_03_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category-Yearly">
</mt:Contents>
--- expected
/test/archives/category/2017/#000003

=== MT::ContentPermalink archive_type="ContentType" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType">
</mt:Contents></mt:Sites>
--- expected
https://localhost/2017/09/mtcontentpermalink-test-data-04.html

=== MT::ContentPermalink archive_type="ContentType-Daily" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Daily">
</mt:Contents></mt:Sites>
--- expected
https://localhost/2017/09/27/#000004

=== MT::ContentPermalink archive_type="ContentType-Weekly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Weekly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/2017/09/24-week/#000004

=== MT::ContentPermalink archive_type="ContentType-Monthly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Monthly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/2017/09/#000004

=== MT::ContentPermalink archive_type="ContentType-Yearly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Yearly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/2017/#000004

=== MT::ContentPermalink archive_type="ContentType-Author" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Author">
</mt:Contents></mt:Sites>
--- expected
https://localhost/author/authorce2f3/#000004

=== MT::ContentPermalink archive_type="ContentType-Author-Daily" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Author-Daily">
</mt:Contents></mt:Sites>
--- expected
https://localhost/author/authorce2f3/2017/09/27/#000004

=== MT::ContentPermalink archive_type="ContentType-Author-Weekly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Author-Weekly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/author/authorce2f3/2017/09/24-week/#000004

=== MT::ContentPermalink archive_type="ContentType-Author-Monthly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Author-Monthly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/author/authorce2f3/2017/09/#000004

=== MT::ContentPermalink archive_type="ContentType-Author-Yearly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Author-Yearly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/author/authorce2f3/2017/#000004

=== MT::ContentPermalink archive_type="ContentType-Category" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category">
</mt:Contents></mt:Sites>
--- expected
https://localhost/category/#000004

=== MT::ContentPermalink archive_type="ContentType-Category-Daily" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category-Daily">
</mt:Contents></mt:Sites>
--- expected
https://localhost/category/2017/09/27/#000004

=== MT::ContentPermalink archive_type="ContentType-Category-Weekly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category-Weekly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/category/2017/09/24-week/#000004

=== MT::ContentPermalink archive_type="ContentType-Category-Monthly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category-Monthly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/category/2017/09/#000004

=== MT::ContentPermalink archive_type="ContentType-Category-Yearly" ContentType 04
--- template
<mt:Sites include_sites="[% website_id %]"><mt:Contents content_type="[% content_type_04_unique_id %]"><mt:ContentPermalink archive_type="ContentType-Category-Yearly">
</mt:Contents></mt:Sites>
--- expected
https://localhost/category/2017/#000004
