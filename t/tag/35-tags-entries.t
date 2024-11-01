#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

use MT;
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

my %categories = ();
for my $label (qw(hoge foo bar baz a b), 'a OR b') {
    $categories{$label} = MT::Test::Permission->make_category(
        blog_id => $blog_id,
        label   => $label,
    );
}

# Make test data
for my $param (
    {
        title => 'foo',
        tags  => ['foo', '@private', 'a'],
        categories => [map { $categories{$_ } } qw(foo hoge)],
    },
    {
        title => 'bar',
        tags  => ['bar', 'b'],
        categories => [map { $categories{$_ } } qw(bar)],
    },
    {
        title => 'baz',
        tags  => ['baz'],
        categories => [map { $categories{$_ } } qw(baz)],
    },
    {
        title => 'qux',
        tags  => [],
        categories => [],
    },
    {
        title => 'quux',
        tags  => [],
        categories => [map { $categories{$_ } } qw(foo)],
    },
    {
        title => 'a OR b',
        tags  => ['a OR b'],
        categories => [map { $categories{$_ } } 'a OR b'],
    },
) {
    my $e = MT::Test::Permission->make_entry(
        blog_id => $blog_id,
        title   => $param->{title},
    );
    $e->add_tags(@{$param->{tags}});
    $e->attach_categories(@{$param->{categories}});
    $e->save;
}

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

require MT::Placement;
{
    no warnings 'once';
    *MT::Placement::load = sub {
        fail "Should not be called MT::Placement::load. We should only use JOIN statement.";
    };
}

MT::Test::Tag->run_perl_tests($blog_id, sub {
    my ($ctx, $block) = @_;

    if (defined($block->should_not_be_called_object_tag_load)) {
        require MT::ObjectTag;
        *MT::ObjectTag::load = sub {
            fail "Should not be called MT::ObjectTag::load. We should only use JOIN statement.";
        };
    }
    else {
        undef *MT::ObjectTag::load;
    }
});
MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__END__

=== MTEntries[tag] : Single tag
--- template
<MTEntries tag="@private">
<$MTEntryTitle$></MTEntries>
--- expected
foo
--- should_not_be_called_object_tag_load

=== MTEntries[tag] : Contains "OR" in tag name
--- template
<MTEntries tag="a OR b">
<$MTEntryTitle$></MTEntries>
--- expected
a OR b
--- should_not_be_called_object_tag_load
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-28118

=== MTEntries[tag] : Multiple tags
--- template
<MTEntries tag="bar OR a" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
foo
bar
--- should_not_be_called_object_tag_load

=== MTEntries[tag] : Multiple tags (a public tag OR a private tag)
--- template
<MTEntries tag="bar OR @private" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
foo
bar
--- should_not_be_called_object_tag_load
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-28120

=== MTEntries[tag] : Multiple tags (comma separated)
--- template
<MTEntries tag="bar, @private" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
foo
bar
--- should_not_be_called_object_tag_load

=== MTEntries[tag] : Multiple tags of same asset
--- template
<MTEntries tag="foo OR @private">
<$MTEntryTitle$></MTEntries>
--- expected
foo
--- should_not_be_called_object_tag_load

=== MTEntries[category] : Single category
--- template
<MTEntries category="foo" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
foo
quux

=== MTEntries[category] : Contains "OR" in category name
--- template
<MTEntries category="a OR b" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
a OR b

=== MTEntries[category] : Multiple categories
--- template
<MTEntries category="foo OR bar" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
foo
bar
quux

=== MTEntries[category] : Multiple categories of same entry
--- template
<MTEntries category="foo OR hoge" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
foo
quux

=== MTEntriesWithSubCategories
--- template
<MTEntriesWithSubCategories category="foo" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntriesWithSubCategories>
--- expected
foo
quux
--- should_not_be_called_object_tag_load

=== MTEntriesWithSubCategories
--- template
<MTEntriesWithSubCategories category="foo" tag="foo">
<$MTEntryTitle$></MTEntriesWithSubCategories>
--- expected
foo
--- should_not_be_called_object_tag_load

=== MTEntriesWithSubCategories
--- template
<MTEntriesWithSubCategories category="foo" tag="bar">
<$MTEntryTitle$></MTEntriesWithSubCategories>
--- expected
--- should_not_be_called_object_tag_load

=== MTEntriesWithSubCategories
--- template
<MTEntriesWithSubCategories category="foo" tag="foo OR bar">
<$MTEntryTitle$></MTEntriesWithSubCategories>
--- expected
foo
--- should_not_be_called_object_tag_load

=== Category cache doesn't break following tags MTC-28906
--- template
<mt:Entries categories="bar" include_subcategories="1">[<mt:EntryTitle>]</mt:Entries>
<mt:Entries categories="baz" include_subcategories="1">[<mt:EntryTitle>]</mt:Entries>
--- expected
[bar]
[baz]
