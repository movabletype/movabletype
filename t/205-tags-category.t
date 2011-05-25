#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 102
  template: <MTCategories><MTCategoryLabel></MTCategories>
  expected: foosubfoo

-
  name: test item 103
  template: <MTCategories><MTCategoryID></MTCategories>
  expected: 13

-
  name: test item 104
  template: <MTCategories><MTCategoryDescription></MTCategories>
  expected: barsubcat

-
  name: test item 127
  template: "<MTCategories><MTCategoryLabel>: <MTCategoryCount>; </MTCategories>"
  expected: "foo: 1; subfoo: 1; "

-
  name: test item 128
  template: <MTCategories><MTCategoryArchiveLink>; </MTCategories>
  expected: "http://narnia.na/nana/archives/foo/; http://narnia.na/nana/archives/foo/subfoo/; "

-
  name: test item 129
  template: "<MTCategories show_empty=\"1\"><MTCategoryLabel>: <MTCategoryTrackbackLink> </MTCategories>"
  expected: "bar: http://narnia.na/cgi-bin/mt-tb.cgi/2 foo:  subfoo:  "

-
  name: test item 130
  template: <MTSubCategories show_empty="1" top="1"><MTCategoryLabel></MTSubCategories>
  expected: barfoo

-
  name: test item 131
  template: "<MTSubCategories show_empty=\"1\" top=\"1\"><MTSubCatIsFirst>First: <MTCategoryLabel></MTSubCatIsFirst></MTSubCategories>"
  expected: "First: bar"

-
  name: test item 132
  template: <MTSubCategories show_empty="1" top="1">[[<MTCategoryLabel><MTSubCatsRecurse>]]</MTSubCategories>
  expected: '[[bar]][[foo[[subfoo]]]]'

-
  name: test item 133
  template: "<MTSubCategories show_empty=\"1\" top=\"1\"><MTSubCatIsLast>Last: <MTCategoryLabel></MTSubCatIsLast></MTSubCategories>"
  expected: "Last: foo"

-
  name: test item 134
  template: <MTTopLevelCategories><MTCategoryLabel></MTTopLevelCategories>
  expected: barfoo

-
  name: test item 135
  template: <MTSubCategories show_empty="1" top="1"><MTHasParentCategory>Parent of <MTCategoryLabel> is <MTParentCategory><MTCategoryLabel></MTParentCategory></MTHasParentCategory><MTHasNoParentCategory><MTCategoryLabel> has no parent</MTHasNoParentCategory>; <MTSubCatsRecurse></MTSubCategories>
  expected: "bar has no parent; foo has no parent; Parent of subfoo is foo; "

-
  name: test item 136
  template: <MTTopLevelCategories show_empty="1"><MTCategoryLabel><MTHasSubCategories> (has subcategories)</MTHasSubCategories><MTHasNoSubCategories> (has no subcategories)</MTHasNoSubCategories></MTTopLevelCategories>
  expected: bar (has no subcategories)foo (has subcategories)

-
  name: test item 137
  template: <MTCategories show_empty="1"><MTSubCategoryPath>;</MTCategories>
  expected: bar;foo;foo/subfoo;

-
  name: test item 138
  template: <MTEntriesWithSubCategories category="foo"><MTEntryTitle>;</MTEntriesWithSubCategories>
  expected: Verse 4;Verse 3;

-
  name: test item 139
  template: <MTEntriesWithSubCategories category="foo/subfoo"><MTEntryTitle>;</MTEntriesWithSubCategories>
  expected: Verse 4;

-
  name: test item 143
  template: <MTCategories show_empty="1"><MTIfIsAncestor child="subfoo"><MTCategoryLabel> is an ancestor to subfoo</MTIfIsAncestor></MTCategories>
  expected: foo is an ancestor to subfoosubfoo is an ancestor to subfoo

-
  name: test item 144
  template: <MTCategories show_empty="1"><MTIfIsDescendant parent="foo"><MTCategoryLabel> is a descendant of foo</MTIfIsDescendant></MTCategories>
  expected: foo is a descendant of foosubfoo is a descendant of foo

-
  name: test item 145
  template: "<MTCategories show_empty=\"1\"><MTCategoryLabel>'s top parent is: <MTTopLevelParent><MTCategoryLabel></MTTopLevelParent>; </MTCategories>"
  expected: "bar's top parent is: bar; foo's top parent is: foo; subfoo's top parent is: foo; "

-
  name: test item 199
  template: <MTCategories show_empty="1" glue=","><MTCategoryLabel>-<MTCategoryNext show_empty="1"><MTCategoryLabel></MTCategoryNext></MTCategories>
  expected: bar-foo,foo-,subfoo-

-
  name: test item 200
  template: <MTCategories show_empty="1" glue=","><MTCategoryLabel>-<MTCategoryPrevious show_empty="1"><MTCategoryLabel></MTCategoryPrevious></MTCategories>
  expected: bar-,foo-bar,subfoo-

-
  name: test item 201
  template: <MTEntries lastn="1" offset="3"><MTIfCategory name="foo">in category</MTIfCategory></MTEntries>
  expected: in category

-
  name: test item 404
  template: <MTSubCategories category='foo'><MTCategoryLabel></MTSubCategories>
  expected: subfoo

-
  name: test item 405
  template: <MTCategories sort_by='label' sort_order='ascend' show_empty='1'><MTCategoryLabel>'<MTSubCategories><MTCategoryLabel></MTSubCategories>'</MTCategories>
  expected: bar''foo'subfoo'subfoo''

-
  name: test item 463
  template: <MTCategories><MTCategoryBasename></MTCategories>
  expected: foosubfoo

-
  name: test item 464
  template: <MTCategories><MTCategoryCommentCount></MTCategories>
  expected: 30

-
  name: test item 465
  template: <MTCategories><MTCategoryIfAllowPings>Allow<MTElse>NotAllow</MTCategoryIfAllowPings></MTCategories>
  expected: NotAllowNotAllow

-
  name: test item 466
  template: <MTCategories><MTCategoryTrackbackCount></MTCategories>
  expected: 00

-
  name: test item 467
  template: <MTSubCategories category='subfoo' include_current='1'><MTParentCategories glue='-' exclude_current='1'><MTCategoryLabel></MTParentCategories></MTSubCategories>
  expected: foo

-
  name: test item 468
  template: <MTSubCategories category='subfoo' include_current='1'><MTParentCategories glue='-'><MTCategoryLabel></MTParentCategories></MTSubCategories>
  expected: foo-subfoo

