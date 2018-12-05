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

use Test::Base;
use MT::Test::ArchiveType;

use MT;
use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

filters {
    MT::Test::ArchiveType->filter_spec
};

my @maps = grep { $_->archive_type =~ /^ContentType-Category/ }
    MT::Test::ArchiveType->template_maps;

my $objs = MT::Test::Fixture::ArchiveType->load_objs;
MT::Test::ArchiveType->vars->{blog_id} = $objs->{blog_id};

for my $ct_name ( keys %{ $objs->{content_type} } ) {
    for my $cf_name (
        keys %{ $objs->{content_type}{$ct_name}{content_field} } )
    {
        my $cf = $objs->{content_type}{$ct_name}{content_field}{$cf_name};
        MT::Test::ArchiveType->vars->{"${cf_name}_unique_id"}
            = $cf->unique_id;
    }
}

MT::Test::ArchiveType->run_tests(@maps);

done_testing;

__END__

=== mt:Contents without a field modifier (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]"><mt:ContentLabel>
</mt:Contents>
--- expected_contenttype_category
cd_same_apple_orange
cd_same_apple_orange_peach
--- expected
cd_same_apple_orange_peach

=== mt:Contents with the same field modifier as the one set in the template map (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:cf_same_catset_fruit="cat_apple"><mt:ContentLabel>
</mt:Contents>
--- expected_contenttype_category
cd_same_apple_orange
cd_same_apple_orange_peach
--- expected
cd_same_apple_orange_peach

=== [unique_id] mt:Contents with the same field modifier as the one set in the template map (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:[% cf_same_catset_fruit_unique_id %]="cat_apple"><mt:ContentLabel>
</mt:Contents>
--- expected_contenttype_category
cd_same_apple_orange
cd_same_apple_orange_peach
--- expected
cd_same_apple_orange_peach

=== mt:Contents with a different modifier from the one set in the template map (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:cf_same_catset_other_fruit="cat_peach"><mt:ContentLabel>
</mt:Contents>
--- expected
cd_same_apple_orange_peach

=== [unique_id] mt:Contents with a different modifier from the one set in the template map (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:[% cf_same_catset_other_fruit_unique_id %]="cat_peach"><mt:ContentLabel>
</mt:Contents>
--- expected
cd_same_apple_orange_peach

=== mt:Contents with the same modifier with a different category (should override) (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:cf_same_catset_fruit="cat_peach"><mt:ContentLabel>
</mt:Contents>
--- expected_contenttype_category
cd_same_peach
--- expected

=== [unique_id] mt:Contents with the same modifier with a different category (should override) (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:[% cf_same_catset_fruit_unique_id %]="cat_peach"><mt:ContentLabel>
</mt:Contents>
--- expected_contenttype_category
cd_same_peach
--- expected

=== mt:Contents with two consistent modifiers (same as the related content data) (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:cf_same_catset_fruit="cat_apple" field:cf_same_catset_other_fruit="cat_peach"><mt:ContentLabel>
</mt:Contents>
--- expected
cd_same_apple_orange_peach

=== [unique_id] mt:Contents with two consistent modifiers (same as the related content data) (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:cf_same_catset_fruit="cat_apple" field:[% cf_same_catset_other_fruit_unique_id %]="cat_peach"><mt:ContentLabel>
</mt:Contents>
--- expected
cd_same_apple_orange_peach

=== mt:Contents with two consistent modifiers (different from the related content data) (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:cf_same_catset_fruit="cat_apple" field:cf_same_catset_other_fruit="cat_orange"><mt:ContentLabel>
</mt:Contents>
--- expected_contenttype_category
cd_same_apple_orange
--- expected

=== [unique_id] mt:Contents with two consistent modifiers (different from the related content data) (MTC-26097/26104)
--- stash
{
    cd => 'cd_same_apple_orange_peach',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
}
--- template
<mt:Contents content_type="ct_with_same_catset" blog_id="[% blog_id %]" field:cf_same_catset_fruit="cat_apple" field:[% cf_same_catset_other_fruit_unique_id %]="cat_orange"><mt:ContentLabel>
</mt:Contents>
--- expected_contenttype_category
cd_same_apple_orange
--- expected

