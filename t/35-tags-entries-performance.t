#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

use MT;
use MT::Util qw( epoch2ts );
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

require MT::ObjectTag;
{
    no warnings 'once';
    *MT::ObjectTag::load = sub {
        fail "Should not be called MT::ObjectTag::load. We should only use JOIN statement.";
    };
}

require MT::Placement;
{
    no warnings 'once';
    *MT::Placement::load = sub {
        fail "Should not be called MT::Placement::load. We should only use JOIN statement.";
    };
}

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

done_testing;

__END__

=== MTEntries[tag] : Single tag
--- template
<MTEntries tag="@private">
<$MTEntryTitle$></MTEntries>
--- expected
foo

=== MTEntries[tag] : Contains "OR" in tag name
--- SKIP_PHP
--- template
<MTEntries tag="a OR b">
<$MTEntryTitle$></MTEntries>
--- expected
a OR b

=== MTEntries[tag] : Unknown tag
--- SKIP_PHP
--- template
<MTEntries tag="thud">
<$MTEntryTitle$><MTElse>not found</MTEntries>
--- expected
not found

=== MTEntries[tag] : Multiple tags
--- SKIP_PHP
--- template
<MTEntries tag="bar OR @private" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
foo
bar

=== MTEntries[tag] : Multiple tags (comma separated)
--- SKIP_PHP
--- template
<MTEntries tag="bar, @private" sort_by="id" sort_order="ascend">
<$MTEntryTitle$></MTEntries>
--- expected
foo
bar

=== MTEntries[tag] : Multiple tags of same asset
--- SKIP_PHP
--- template
<MTEntries tag="foo OR @private">
<$MTEntryTitle$></MTEntries>
--- expected
foo

=== MTEntries[category] : Single category
--- template
<MTEntries category="foo">
<$MTEntryTitle$></MTEntries>
--- expected
foo

=== MTEntries[category] : Contains "OR" in category name
--- template
<MTEntries category="a OR b">
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

=== MTEntries[tag] : Multiple categories of same entry
--- template
<MTEntries category="foo OR hoge">
<$MTEntryTitle$></MTEntries>
--- expected
foo
