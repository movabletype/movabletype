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
#plan tests => 2 * blocks;
plan tests => 1 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $blog = MT::Test::Permission->make_blog(
            parent_id => 0,
            name      => 'test blog',
        );

        my $category_set = MT::Test::Permission->make_category_set(
            blog_id => $blog->id,
            name    => 'test category set',
        );

        my @categories;
        for my $name (qw/Alice Bob Carol Dan/) {
            push @categories, MT::Test::Permission->make_category(
                blog_id         => $blog->id,
                category_set_id => $category_set->id,
                label           => $name,
            );
        }

        my $content_type_01 = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type 01',
        );

        my $content_type_02 = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type 02',
        );

        my $cf_category_01 = MT::Test::Permission->make_content_field(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            name            => 'Category Field 01',
            type            => 'categories',
        );

        my $cf_category_02 = MT::Test::Permission->make_content_field(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            name            => 'Category Field 02',
            type            => 'categories',
        );

        $cf_category_01->related_cat_set_id( $category_set->id );
        $cf_category_01->save;

        $cf_category_02->related_cat_set_id( $category_set->id );
        $cf_category_02->save;

        my $fields_01 = [
            {   id      => $cf_category_01->id,
                order   => 15,
                type    => $cf_category_01->type,
                options => {
                    label        => $cf_category_01->name,
                    category_set => $category_set->id,
                    multiple     => 0,
                },
            },
        ];

        my $fields_02 = [
            {   id      => $cf_category_02->id,
                order   => 15,
                type    => $cf_category_02->type,
                options => {
                    label        => $cf_category_02->name,
                    category_set => $category_set->id,
                    multiple     => 0,
                },
            },
        ];

        $content_type_01->fields($fields_01);
        $content_type_01->save or die $content_type_01->errstr;

        $content_type_02->fields($fields_02);
        $content_type_02->save or die $content_type_02->errstr;

        my $content_data_01 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20201010101010',
            identifier      => 'mtcontent_type-context-test-data-01',
            data            => { $cf_category_01->id => [ $categories[0]->id ], }
        );
        
        my $content_data_02 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20201010101010',
            identifier      => 'mtcontent_type-context-test-data-02',
            data            => { $cf_category_01->id => [ $categories[1]->id ], }
        );

        my $content_data_03 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20201010101010',
            identifier      => 'mtcontent_type-context-test-data-03',
            data            => { $cf_category_02->id => [ $categories[2]->id ], }
        );

        my $content_data_04 = MT::Test::Permission->make_content_data(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            status          => MT::ContentStatus::RELEASE(),
            authored_on     => '20201010101010',
            identifier      => 'mtcontent_type-context-test-data-04',
            data            => { $cf_category_02->id => [ $categories[3]->id ], }
        );

        my $template_01 = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_type_01->id,
            name            => 'ContentType Test 01',
            type            => 'ct_archive',
            text            => 'test 01',
        );

        my $template_02 = MT::Test::Permission->make_template(
            blog_id         => $blog->id,
            content_type_id => $content_type_02->id,
            name            => 'ContentType Test 02',
            type            => 'ct_archive',
            text            => 'test 02',
        );

        my $map_01 = MT::Test::Permission->make_templatemap(
            template_id   => $template_01->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Category',
            file_template => '%-c/%i',
            is_preferred  => 1,
            cat_field_id  => $cf_category_01->id,
        );

        my $map_02 = MT::Test::Permission->make_templatemap(
            template_id   => $template_02->id,
            blog_id       => $blog->id,
            archive_type  => 'ContentType-Category',
            file_template => '%-c/%i',
            is_preferred  => 1,
            cat_field_id  => $cf_category_02->id,
        );
    }
);

my $blog = MT::Blog->load( { name => 'test blog' } );

MT::Test::Tag->run_perl_tests($blog->id, sub {
    my ($ctx, $block) = @_;
    my $identifier = 'mtcontent_type-context-test-data-0' . $block->cd;
    my ($cd) = MT->model('cd')->load( { identifier => $identifier });
    my ($tmpl) = MT->model('template')->load( { content_type_id => $cd->content_type_id } );
    my ($map) = MT->model('templatemap')->load( { blog_id => $blog->id, archive_type => 'ContentType-Category', template_id => $tmpl->id });
    $ctx->stash(template_map => $map);
    $ctx->stash(content => $cd);
});
#MT::Test::Tag->run_php_tests($blog->id);

__END__

=== CategoryPrevious and CategoryNext
--- cd chomp
1
--- template
<mt:CategoryPrevious><mt:CategoryLabel></mt:CategoryPrevious><br>
<mt:CategoryNext><mt:CategoryLabel></mt:CategoryNext><br>
--- expected
<br>
Bob<br>

=== CategoryPrevious and CategoryNext
--- cd chomp
2
--- template
<mt:CategoryPrevious><mt:CategoryLabel></mt:CategoryPrevious><br>
<mt:CategoryNext><mt:CategoryLabel></mt:CategoryNext><br>
--- expected
Alice<br>
<br>

=== CategoryPrevious and CategoryNext
--- cd chomp
3
--- template
<mt:CategoryPrevious><mt:CategoryLabel></mt:CategoryPrevious><br>
<mt:CategoryNext><mt:CategoryLabel></mt:CategoryNext><br>
--- expected
<br>
Dan<br>

=== CategoryPrevious and CategoryNext
--- cd chomp
4
--- template
<mt:CategoryPrevious><mt:CategoryLabel></mt:CategoryPrevious><br>
<mt:CategoryNext><mt:CategoryLabel></mt:CategoryNext><br>
--- expected
Carol<br>
<br>

