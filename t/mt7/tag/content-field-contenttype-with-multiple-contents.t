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
my $ct2 = MT::Test::Permission->make_content_type(
    name    => 'test content type2',
    blog_id => $blog_id,
);
my $ct3 = MT::Test::Permission->make_content_type(
    name    => 'test content type3',
    blog_id => $blog_id,
);

my $cf_single_line = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'single line text',
    type            => 'single_line_text',
);

my $cf_content_type = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    name            => 'content type',
    type            => 'content_type',
);

my $cf_content_type2 = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct3->id,
    name            => 'content type2',
    type            => 'content_type',
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

my $cf_tag = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct3->id,
    name            => 'tags',
    type            => 'tags',
);
my $tag1 = MT::Test::Permission->make_tag( name => 'tag1' );
my $tag2 = MT::Test::Permission->make_tag( name => 'tag2' );

$ct->fields(
    [   {   id        => $cf_category->id,
            label     => 1,
            name      => $cf_category->name,
            order     => 1,
            type      => $cf_category->type,
            unique_id => $cf_category->unique_id,
            options   => { category_set => $category_set->id, label => 'category' },
        },
        {   id        => $cf_datetime->id,
            label     => 1,
            name      => $cf_datetime->name,
            order     => 2,
            type      => $cf_datetime->type,
            unique_id => $cf_datetime->unique_id,
            options   => { label => 'date time' },
        },
        {   id        => $cf_content_type->id,
            label     => 1,
            name      => $cf_content_type->name,
            order     => 3,
            type      => $cf_content_type->type,
            unique_id => $cf_content_type->unique_id,
            options   => { source => $ct2->id, label => 'single text label' },
        },
    ]
);
$ct->save or die $ct->error;

$ct2->fields(
    [
        {   id        => $cf_single_line->id,
            label     => 1,
            name      => $cf_single_line->name,
            order     => 1,
            type      => $cf_single_line->type,
            unique_id => $cf_single_line->unique_id,
            options   => { label => 'my label' },
        },
    ]
);
$ct2->save or die $ct2->error;

$ct3->fields(
    [   {   id        => $cf_tag->id,
            label     => 1,
            name      => $cf_tag->name,
            order     => 1,
            type      => $cf_tag->type,
            unique_id => $cf_tag->unique_id,
            options   => { label => 'tag', multiple => 1, max => 3, min => 1 },
        },
        {   id        => $cf_content_type2->id,
            label     => 1,
            name      => $cf_content_type2->name,
            order     => 2,
            type      => $cf_content_type2->type,
            unique_id => $cf_content_type2->unique_id,
            options   => { source => $ct->id, label => 'yet yet another content type label' },
        },
    ]
);
$ct3->save or die $ct3->error;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    label           => 'cd label',
    data            => {
        $cf_single_line->id => 'single line text',
    },
);

my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    label           => 'cd2 label',
    data            => {
        $cf_single_line->id => 'single line text2',
    },
);

my $cd3 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct->id,
    data            => {
        $cf_category->id     => [ $category1->id ],
        $cf_datetime->id     => '20180831000000',
        $cf_content_type->id => [ $cd->id, $cd2->id ],
    },
);

my $cd4 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct3->id,
    data            => {
        $cf_tag->id           => [ $tag1->id, $tag2->id ],
        $cf_content_type2->id => [ $cd3->id ],
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
    archive_type  => 'ContentType',
    file_template => '%f',
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
    ArchiveType => 'ContentType',
    TemplateMap => $template_map,
);

MT::Test::Tag->run_perl_tests($blog_id, sub {
    my ($ctx, $block) = @_;
    $ctx->{current_timestamp}     = '20180801000000';
    $ctx->stash(template_map => $template_map);
    if ($block->cd eq 'cd3') {
        $ctx->stash(content => $cd3);
        $ctx->stash(content_type => $ct);
    }
    if ($block->cd eq 'cd4') {
        $ctx->stash(content => $cd4);
        $ctx->stash(content_type => $ct3);
    }
});

MT::Test::Tag->run_php_tests($blog_id, sub {
    my $block = shift;

    $template_map->build_type(3);
    $template_map->save;

    my ($cd_id, $ct_id);
    if ($block->cd eq 'cd3') {
        $cd_id = $cd3->id;
        $ct_id = $ct->id;
    }
    if ($block->cd eq 'cd4') {
        $cd_id = $cd4->id;
        $ct_id = $ct3->id;
    }

    return <<"PHP";
\$cd = \$ctx->mt->db()->fetch_content($cd_id);
\$ct = \$ctx->mt->db()->fetch_content_type($ct_id);
\$ctx->stash('current_timestamp', '20180801000000');
\$ctx->stash('current_archive_type', 'ContentType');
\$ctx->stash('content', \$cd);
\$ctx->stash('content_type', \$ct);
PHP
});

__END__

=== content type: just a label and value
--- cd chomp
cd3
--- template
<mt:ContentFields><mt:ContentField>
<mt:ContentFieldLabel>: <mt:ContentFieldValue></mt:ContentField></mt:ContentFields>
--- expected chomp
category: 1
date time: August 31, 2018 12:00 AM
single text label: cd label
single text label: cd2 label

=== content type: contents in contents
--- cd chomp
cd3
--- template
<mt:ContentFields><mt:ContentField><mt:If tag="ContentTypeName" eq="test content type2"><mt:ContentFields><mt:ContentField><mt:ContentFieldLabel>: <mt:ContentFieldValue></mt:ContentField></mt:ContentFields><mt:Else><mt:ContentFieldLabel>: <mt:ContentFieldValue></mt:If>
</mt:ContentField></mt:ContentFields>
--- expected chomp
category: 1
date time: August 31, 2018 12:00 AM
my label: single line text
my label: single line text2

=== content type: just a label and value
--- cd chomp
cd4
--- template
<mt:ContentFields><mt:ContentField>
<mt:ContentFieldLabel>: <mt:ContentFieldValue></mt:ContentField></mt:ContentFields>
--- expected chomp
tag: 1
tag: 2
yet yet another content type label: No Label (ID:3)

=== content type: contents in contents in contents
--- cd chomp
cd4
--- template
<mt:ContentFields><mt:ContentField><mt:If tag="ContentTypeName" eq="test content type"><mt:ContentFields><mt:ContentField><mt:ContentFieldLabel>: <mt:ContentFieldValue>
</mt:ContentField></mt:ContentFields><mt:Else><mt:ContentFieldLabel>: <mt:ContentFieldValue></mt:If>
</mt:ContentField></mt:ContentFields>
--- expected chomp
tag: 1
tag: 2
category: 1
date time: August 31, 2018 12:00 AM
single text label: cd label
single text label: cd2 label
