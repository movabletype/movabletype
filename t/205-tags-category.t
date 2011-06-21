#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt = MT->instance;

my %categories         = ();
my %categories_to_load = qw(
    category 1
    category_has_previous 1
    category_tb_allowed 2
    category_has_next 2
    subcategory 3
);

while ( my ( $key, $id ) = each(%categories_to_load) ) {
    $categories{$key} = MT->model('category')->load($id);
}
$categories{subsubcategory} = MT->model('category')->new;
$categories{subsubcategory}->set_values(
    {   blog_id     => 1,
        label       => 'subsubfoo',
        parent      => $categories{subcategory}->id,
        allow_pings => 1,
    }
);
$categories{subsubcategory}->save or die $categories{subsubcategory}->errstr;

my %entries         = ();
my %entries_to_load = qw(
    foo_entry 6
    not_foo_entry 1
);
while ( my ( $key, $id ) = each(%entries_to_load) ) {
    $entries{$key} = MT->model('entry')->load($id);
}

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{$_} = $categories{$_} for keys(%categories);
    $stock->{$_} = $entries{$_} for keys(%entries);
};
local $MT::Test::Tags::PRERUN_PHP
    = join('', map({
        '$stock["' . $_ . '"] = $db->fetch_category(' . $categories{$_}->id . ');'
    } keys(%categories)))
    . join('', map({
        '$stock["' . $_ . '"] = $db->fetch_entry(' . $entries{$_}->id . ');'
    } keys(%entries)));


run_tests_by_data();
__DATA__
-
  name: CategoryLabel prints the label of the category.
  template: |
    <MTCategoryLabel>
  expected: |
    foo
  stash:
    category: $category

-
  name: CategoryID prints ID of the category.
  template: |
    <MTCategoryID>
  expected: |
    1
  stash:
    category: $category

-
  name: CategoryDescription prints the description of the category.
  template: |
    <MTCategoryDescription>
  expected: |
    bar
  stash:
    category: $category

-
  name: CategoryCount prints the number of published entries related to the category.
  template: |
    <MTCategoryCount>
  expected: |
    1
  stash:
    category: $category

-
  name: CategoryBasename prints the basename of the category.
  template: |
    <MTCategoryBasename>
  expected: |
    foo
  stash:
    category: $category

-
  name: CategoryCommentCount prints the number of comments of the category.
  template: |
    <MTCategoryCommentCount>
  expected: |
    3
  stash:
    category: $category

-
  name: CategoryTrackbackCount prints the number of pings of the category.
  template: |
    <MTCategoryTrackbackCount>
  expected: |
    0
  stash:
    category: $category

-
  name: CategoryArchiveLink prints URL of the archive of the category.
  template: |
    <MTCategoryArchiveLink>
  expected: |
    http://narnia.na/nana/archives/foo/
  stash:
    category: $category

-
  name: CategoryTrackbackLink prints trackback URL if trackback is allowed.
  template: |
    <MTCategoryTrackbackLink>
  expected: |
    http://narnia.na/cgi-bin/mt-tb.cgi/2
  stash:
    category: $category_tb_allowed

-
  name: CategoryTrackbackLink doesn't print trackback URL if trackback isn't allowed.
  template: |
    <MTCategoryTrackbackLink>
  expected: ''
  stash:
    category: $category

-
  name: SubCategories with an attribute "category" lists all sub categories of specified one.
  template: |
    <MTSubCategories category='foo'>
      <MTCategoryLabel>
    </MTSubCategories>
  expected: subfoo

-
  name: SubCategories with attributes "category" and "include_current" lists all sub categories of specified one with oneself.
  template: |
    <MTSubCategories category='subfoo' include_current="1">
      <MTCategoryLabel>
    </MTSubCategories>
  expected: subfoo

-
  name: ParentCategories with an attribute "exclude_current=1" lists parent categories of the category.
  template: |
    <MTParentCategories glue='-' exclude_current='1'><MTCategoryLabel></MTParentCategories>
  expected: foo-subfoo
  stash:
    category: $subsubcategory

-
  name: ParentCategories with an attribute "include_current=1" lists parent categories of the category with oneslf.
  template: |
    <MTParentCategories glue='-' include_current='1'><MTCategoryLabel></MTParentCategories>
  expected: foo-subfoo-subsubfoo
  stash:
    category: $subsubcategory

-
  name: SubCategories with an attribute "top" lists top-level categories of the blog.
  template: |
    <MTSubCategories top="1">
      <MTCategoryLabel>
    </MTSubCategories>
  expected: |
    bar
    foo

-
  name: SubCatIsFirst and SubCatIsLast prints the header and the footer.
  template: |
    <MTSubCategories top="1">
      <MTSubCatIsFirst>
      <ul>
      </MTSubCatIsFirst>
        <li><MTCategoryLabel></li>
      <MTSubCatIsLast>
      </ul>
      </MTSubCatIsLast>
    </MTSubCategories>
  expected: |
    <ul>
      <li>bar</li>
      <li>foo</li>
    </ul>

-
  name: SubCatsRecurse recursively prints the content including oneself.
  template: |
    <MTSubCategories top="1">
      <MTCategoryLabel>
      <MTSubCatsRecurse>
    </MTSubCategories>
  expected: |
    bar
    foo
    subfoo
    subsubfoo

-
  name: TopLevelCategories lists top-level categories of the blog.
  template: |
    <MTTopLevelCategories>
      <MTCategoryLabel>
    </MTTopLevelCategories>
  expected: |
    bar
    foo

-
  name: HasParentCategory prints inner content if the category has a parent.
  template: |
    <MTHasParentCategory>has parent category</MTHasParentCategory>
  expected: |
    has parent category
  stash:
    category: $subcategory

-
  name: HasParentCategory doesn't print inner content if the category doesn't have a parent.
  template: |
    <MTHasParentCategory>has parent category</MTHasParentCategory>
  expected: ''
  stash:
    category: $category

-
  name: HasNoParentCategory prints inner content if the category doesn't have a parent.
  template: |
    <MTHasNoParentCategory>has no parent category</MTHasNoParentCategory>
  expected: |
    has no parent category
  stash:
    category: $category

-
  name: HasNoParentCategory doesn't print inner content if the category has a parent.
  template: |
    <MTHasNoParentCategory>has no parent category</MTHasNoParentCategory>
  expected: ''
  stash:
    category: $subcategory

-
  name: HasSubCategories prints inner content if the category has some sub categories.
  template: |
    <MTHasSubCategories>has subcategories</MTHasSubCategories>
  expected: |
    has subcategories
  stash:
    category: $category

-
  name: HasSubCategories doesn't print inner content if the category doesn't have some sub categories.
  template: |
    <MTHasSubCategories>has subcategories</MTHasSubCategories>
  expected: ''
  stash:
    category: $subsubcategory

-
  name: HasNoSubCategories prints inner content if the category doesn't have some sub categories.
  template: |
    <MTHasNoSubCategories>has no subcategories</MTHasNoSubCategories>
  expected: |
    has no subcategories
  stash:
    category: $subsubcategory

-
  name: HasNoSubCategories doesn't print inner content if the category has some sub categories.
  template: |
    <MTHasNoSubCategories>has no subcategories</MTHasNoSubCategories>
  expected: ''
  stash:
    category: $category

-
  name: SubCategoryPath prints the path of the category.
  template: |
    <MTSubCategoryPath>
  expected: |
    foo/subfoo/subsubfoo
  stash:
    category: $subsubcategory

-
  name: EntriesWithSubCategories lists all entries related to the specified category (or these sub categories).
  template: |
    <MTEntriesWithSubCategories category="foo">
      <MTEntryTitle>
    </MTEntriesWithSubCategories>
  expected: |
    Verse 4
    Verse 3

-
  name: EntriesWithSubCategories lists all entries related to the specified sub category (or these sub categories).
  template: |
    <MTEntriesWithSubCategories category="foo/subfoo">
      <MTEntryTitle>
    </MTEntriesWithSubCategories>
  expected: |
    Verse 4

-
  name: Categories lists all categories that has some entry of the blog.
  template: |
    <MTCategories>
      <MTCategoryLabel>
    </MTCategories>
  expected: |
    foo
    subfoo

-
  name: Categories with an attribute "show_empty" lists all categories of the blog.
  template: |
    <MTCategories show_empty="1">
      <MTCategoryLabel>
    </MTCategories>
  expected: |
    bar
    foo
    subfoo
    subsubfoo

-
  name: Categories with attributes "sort_by=label" and "sort_order=ascend" lists categories that are sorted by label.
  template: |
    <MTCategories sort_by='label' sort_order='ascend' show_empty='1'>
      <MTCategoryLabel>
    </MTCategories>
  expected: |
    bar
    foo
    subfoo
    subsubfoo

-
  name: IfIsAncestor prints inner content if the category is ancestor of specified category.
  template: |
    <MTIfIsAncestor child="subfoo">ancestor</MTIfIsAncestor>
  expected: |
    ancestor
  stash:
    category: $category

-
  name: IfIsAncestor doesn't print inner content if the category isn't ancestor of specified category.
  template: |
    <MTIfIsAncestor child="subfoo">ancestor</MTIfIsAncestor>
  expected: ''
  stash:
    category: $subsubcategory

-
  name: IfIsDescendant prints inner content if the category is descendant of specified category.
  template: |
    <MTIfIsDescendant parent="foo">descendant</MTIfIsDescendant>
  expected: |
    descendant
  stash:
    category: $subsubcategory

-
  name: IfIsDescendant doesn't print inner content if the category isn't descendant of specified category.
  template: |
    <MTIfIsDescendant parent="foo">descendant</MTIfIsDescendant>
  expected: ''
  stash:
    category: $category_tb_allowed

-
  name: TopLevelParent creates the category context for the top-level ancestor of the category. (sub category)
  template: |
    <MTTopLevelParent><MTCategoryLabel></MTTopLevelParent>
  expected: |
    foo
  stash:
    category: $subcategory

-
  name: TopLevelParent creates the category context for the top-level ancestor of the category. (sub sub category)
  template: |
    <MTTopLevelParent><MTCategoryLabel></MTTopLevelParent>
  expected: |
    foo
  stash:
    category: $subsubcategory

-
  name: CategoryNext creates the category context for the next category.
  template: |
    <MTCategoryNext><MTCategoryLabel></MTCategoryNext>
  expected: |
    foo
  stash:
    category: $category_has_next

-
  name: CategoryPrevious creates the category context for the previous category.
  template: |
    <MTCategoryPrevious show_empty="1"><MTCategoryLabel></MTCategoryPrevious>
  expected: |
    bar
  stash:
    category: $category_has_previous

-
  name: IfCategory prints inner content if the entry is related to the specified category.
  template: |
    <MTIfCategory name="foo">in category</MTIfCategory>
  expected: in category
  stash:
    entry: $foo_entry

-
  name: IfCategory doesn't prints inner content if the entry isn't related to the specified category.
  template: |
    <MTIfCategory name="foo">in category</MTIfCategory>
  expected: ''
  stash:
    entry: $not_foo_entry

-
  name: CategoryIfAllowPings prints inner content if allowed.
  template: |
    <MTCategoryIfAllowPings>allowed</MTCategoryIfAllowPings>
  expected: |
    allowed
  stash:
    category: $subsubcategory

-
  name: CategoryIfAllowPings doesn't prints inner content if not allowed.
  template: |
    <MTCategoryIfAllowPings>allowed</MTCategoryIfAllowPings>
  expected: ''
  stash:
    category: $category


######## Categories
## `show_empty`
## `glue`

######## CategoryPrevious
## show_empty

######## CategoryNext
## show_empty

######## SubCategories
## include_current
## sort_method
## sort_order
## top
## category
## glue

######## TopLevelCategories

######## ParentCategory

######## ParentCategories
## glue
## exclude_current

######## TopLevelParent

######## EntriesWithSubCategories
## category

######## IfCategory
## name (or label; optional)
## type (optional)

######## EntryIfCategory

######## SubCatIsFirst

######## SubCatIsLast

######## HasSubCategories

######## HasNoSubCategories

######## HasParentCategory

######## HasNoParentCategory

######## IfIsAncestor
## child (required)

######## IfIsDescendant
## parent (required)

######## EntryCategories
## glue (optional)

######## EntryPrimaryCategory

######## EntryAdditionalCategories

######## CategoryID

######## CategoryLabel

######## CategoryBasename
## default
## separator

######## CategoryDescription

######## CategoryArchiveLink

######## CategoryCount

######## SubCatsRecurse
## max_depth (optional)

######## SubCategoryPath
## separator

######## BlogCategoryCount

######## ArchiveCategory

######## EntryCategory

