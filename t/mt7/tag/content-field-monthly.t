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
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

$test_env->prepare_fixture('db');

my $ct = MT::Test::Permission->make_content_type(
    name    => 'test content type',
    blog_id => $blog_id,
);

my $cf_category = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'categories',
    type            => 'categories',
);

my $cf_datetime = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'datetime',
    type            => 'date_and_time',
);

my $category_set = MT::Test::Permission->make_category_set(
    blog_id => $blog_id,
    name    => 'test category set',
);
my $category1 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category1',
);
my $category2 = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category2',
);

$ct->fields(
    [   {   id        => $cf_category->id,
            label     => 1,
            name      => $cf_category->name,
            order     => 1,
            type      => $cf_category->type,
            unique_id => $cf_category->unique_id,
            options   => { category_set => $category_set->id },
        },
        {   id        => $cf_datetime->id,
            label     => 1,
            name      => $cf_datetime->name,
            order     => 1,
            type      => $cf_datetime->type,
            unique_id => $cf_datetime->unique_id,
        },
    ]
);
$ct->save or die $ct->error;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    data            => {
        $cf_category->id => [ $category1->id ],
        $cf_datetime->id => '20180831000000',
    },
);

my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    data            => {
        $cf_category->id => [ $category1->id ],
        $cf_datetime->id => '20180930000000',
    },
);

# Mapping
my $template = MT::Test::Permission->make_template(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'ContentType Test',
    type            => 'ct',
    text            => 'test',
);
my $template_map = MT::Test::Permission->make_templatemap(
    template_id   => $template->id,
    blog_id       => $blog_id,
    archive_type  => 'ContentType-Monthly',
    file_template => '%y/%m/%f',
    cat_field_id  => $cf_category->id,
    dt_field_id   => $cf_datetime->id,
    is_preferred  => 1,
);

my $blog = MT::Blog->load($blog_id);
$blog->archive_path( join "/", $test_env->root, "site/archive" );
$blog->save;

require MT::ContentPublisher;
my $publisher = MT::ContentPublisher->new;
$publisher->rebuild(
    BlogID      => $blog_id,
    ArchiveType => 'ContentType-Monthly',
    TemplateMap => $template_map,
);

MT::Test::Tag->run_perl_tests($blog_id, sub {
    my ($ctx, $block) = @_;
    $ctx->{current_timestamp}     = '20180801000000';
    $ctx->{current_timestamp_end} = '20180901000000';
    $ctx->stash(template_map => $template_map);
});

MT::Test::Tag->run_php_tests($blog_id, sub {
    my $block = shift;

    $template_map->build_type(3);
    $template_map->save;

    return <<'PHP';
$ctx->stash('current_timestamp', '20180801000000');
$ctx->stash('current_timestamp_end', '20180901000000');
$ctx->stash('current_archive_type', 'ContentType-Monthly');
PHP
});

__END__

=== content type monthly (content field)
--- template
<mt:Contents content_type="test content type"><mt:ContentField content_field="datetime">
<mt:ContentFieldValue></mt:ContentField></mt:Contents>
--- expected chomp
August 31, 2018 12:00 AM

=== content type monthly (content fields/content field)
--- template
<mt:Contents content_type="test content type"><mt:ContentFields><mt:ContentField>
<mt:ContentFieldValue></mt:ContentField></mt:ContentFields></mt:Contents>
--- expected chomp
1
August 31, 2018 12:00 AM
