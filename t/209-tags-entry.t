#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt = MT->instance;

my %entries         = ();
my %entries_to_load = qw(
    entry 1
    previous_entry 8
    foo_entry 6
);
while ( my ( $key, $id ) = each(%entries_to_load) ) {
    $entries{$key} = MT->model('entry')->load($id);
}

my %categories = ();
$categories{bar} = MT->model('category')->load( { label => 'bar' } );
my $placement = $mt->model('placement')->new;
$placement->entry_id( $entries{foo_entry}->id );
$placement->blog_id( $entries{foo_entry}->blog_id );
$placement->category_id( $categories{bar}->id );
$placement->is_primary(0);
$placement->save
    or die "Couldn't save placement record: " . $placement->errstr;

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{$_} = $entries{$_}   for keys(%entries);
    $stock->{entry_authored_on} = $entries{entry}->authored_on;
};
local $MT::Test::Tags::PRERUN_PHP =
    '$stock["entry_authored_on"] = "' . $entries{entry}->authored_on . '";'
    . join('', map({
        '$stock["' . $_ . '"] = $db->fetch_entry(' . $entries{$_}->id . ');'
    } keys(%entries)));


run_tests_by_data();
__DATA__
-
  name: EntryID prints the ID of the entry.
  template: <MTEntryID>
  expected: 1

-
  name: EntryTitle prints the title of the entry.
  template: <MTEntryTitle>
  expected: A Rainy Day

-
  name: EntryBody prints the body of the entry.
  template: <MTEntryBody>
  expected: <p>On a drizzly day last weekend,</p>

-
  name: EntryMore prints the more of the entry.
  template: <MTEntryMore>
  expected: <p>I took my grandpa for a walk.</p>

-
  name: EntryExcerpt prints the excerpt of the entry.
  template: <MTEntryExcerpt>
  expected: A story of a stroll.

-
  name: EntryKeywords prints the keywords of the entry.
  template: <MTEntryKeywords>
  expected: keywords

-
  name: EntryStatus prints the status of the entry.
  template: <MTEntryStatus>
  expected: Publish

-
  name: EntryFlag prints the status of the specified flag of the entry.
  template: <MTEntryFlag flag="allow_pings">
  expected: 1

-
  name: EntryAuthorID prints the ID of the author of the entry.
  template: |
    <MTEntryAuthorID>
  expected: 2

-
  name: EntryAuthor prints the login-name of the author of the entry.
  template: <MTEntryAuthor>
  expected: Chuck D

-
  name: EntryAuthorUsername prints the login-name of the author of the entry.
  template: <MTEntryAuthorUsername>
  expected: Chuck D

-
  name: EntryAuthorNickname prints the display-name of the author of the entry.
  template: <MTEntryAuthorNickname>
  expected: Chucky Dee

-
  name: EntryAuthorEmail prints the email address of the author of the entry.
  template: <MTEntryAuthorEmail>
  expected: chuckd@example.com

-
  name: EntryAuthorURL prints the URL the author of the entry.
  template: <MTEntryAuthorURL>
  expected: "http://chuckd.com/"

-
  name: EntryAuthorLink prints the anchor tag of the author of the entry.
  template: <MTEntryAuthorLink>
  expected: "<a href=\"http://chuckd.com/\">Chucky Dee</a>"

-
  name: EntryTrackbackLink prints the trackback URL of the entry.
  template: <MTEntryTrackbackLink>
  expected: "http://narnia.na/cgi-bin/mt-tb.cgi/1"

-
  name: EntryTrackbackData prints the trackback data of the entry.
  template: |
    <MTEntryTrackbackData>
  expected: |
    <!--
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
             xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/"
             xmlns:dc="http://purl.org/dc/elements/1.1/">
    <rdf:Description
        rdf:about="http://narnia.na/nana/archives/1978/01/a-rainy-day.html"
        trackback:ping="http://narnia.na/cgi-bin/mt-tb.cgi/1"
        dc:title="A Rainy Day"
        dc:identifier="http://narnia.na/nana/archives/1978/01/a-rainy-day.html"
        dc:subject=""
        dc:description="A story of a stroll."
        dc:creator="Chucky Dee"
        dc:date="1978-01-31T07:45:00-03:30" />
    </rdf:RDF>
    -->
  stash:
    current_timestamp: $entry_authored_on

-
  name: EntryTrackbackID prints the trackback ID of the entry.
  template: <MTEntryTrackbackID>
  expected: 1

-
  name: EntryBasename prints the basename of the entry.
  template: <MTEntryBasename>
  expected: a_rainy_day

-
  name: EntryAtomID prints the atom ID of the entry.
  template: <MTEntryAtomID>
  expected: "tag:narnia.na,1978:/nana//1.1"

-
  name: Link with an attribute "entry_id" prints the published URL of the entry.
  template: <MTLink entry_id="1">
  expected: "http://narnia.na/nana/archives/1978/01/a-rainy-day.html"

-
  name: EntryLink prints the published URL of the entry.
  template: |
    <MTEntryLink>
  expected: |
    http://narnia.na/nana/archives/1978/01/a-rainy-day.html

-
  name: EntryLink with an attribute "archive_type=Daily" prints the published URL of the specified archive of the entry.
  template: |
    <MTEntryLink archive_type="Daily">
  expected: |
    http://narnia.na/nana/archives/1978/01/31/

-
  name: EntryLink with an attribute "archive_type=Monthly" prints the published URL of the specified archive of the entry.
  template: |
    <MTEntryLink archive_type="Monthly">
  expected: |
    http://narnia.na/nana/archives/1978/01/

-
  name: EntryPermalink prints the published URL of the entry.
  template: |
    <MTEntryPermalink archive_type="Individual">
  expected: |
    http://narnia.na/nana/archives/1978/01/a-rainy-day.html

-
  name: EntryPermalink with an attribute "archive_type=Daily" prints the published URL of the specified archive of the entry.
  template: |
    <MTEntryPermalink archive_type="Daily">
  expected: |
    http://narnia.na/nana/archives/1978/01/31/#000001

-
  name: EntryPermalink with an attribute "archive_type=Monthly" prints the published URL of the specified archive of the entry.
  template: |
    <MTEntryPermalink archive_type="Monthly">
  expected: |
    http://narnia.na/nana/archives/1978/01/#000001

-
  name: EntryCategory prints the label of the category related to the current entry.
  template: |
    <MTEntryCategory>
  expected: foo
  stash:
    entry: $foo_entry

-
  name: EntryDate prints the authored date of the entry.
  template: <MTEntryDate>
  expected: "January 31, 1978  7:45 AM"

-
  name: EntryCreatedDate prints the created-time of the entry.
  template: <MTEntryCreatedDate>
  expected: "January 31, 1978  7:45 AM"

-
  name: EntryModifiedDate prints the modified-time of the entry.
  template: <MTEntryModifiedDate>
  expected: "January 31, 1978  7:46 AM"

-
  name: EntryDate with an attribute "utc" prints the authored date of the entry in in UTC time.
  template: <MTEntryDate utc="1">
  expected: "January 31, 1978 11:15 AM"

-
  name: EntryDate with an attribute "format_name=iso8601" formats and prints the authored date of the entry.
  template: <MTEntryDate format_name="iso8601">
  expected: "1978-01-31T07:45:00-03:30"

-
  name: EntryDate with an attribute "format_name=rfc822" formats and prints the authored date of the entry.
  template: <MTEntryDate format_name="rfc822">
  expected: "Tue, 31 Jan 1978 07:45:00 -0330"

-
  name: EntryDate with an attribute "format" formats and prints the authored date of the entry.
  template: "<MTEntryDate format=\"%Y-%m-%dT%H:%M:%S\">"
  expected: "1978-01-31T07:45:00"

-
  name: EntryDate with an attribute "language" prints the authored date of the entry in specified language.
  template: <MTEntryDate language="pl">
  expected: "31 stycznia 1978  7:45"

-
  name: Entries with an attribute "lastn=10" lists the latest ten entries.
  template: |
    <MTEntries lastn="10">
      * <MTEntryTitle>
    </MTEntries>
  expected: |
    * A Rainy Day
    * Verse 5
    * Verse 4
    * Verse 3
    * Verse 2
    * Verse 1

-
  name: Entries with an attribute "glue=," prints content that was joined with ",".
  template: |
    <MTEntries lastn="10" glue=","><MTEntryTitle></MTEntries>
  expected: |
    A Rainy Day,Verse 5,Verse 4,Verse 3,Verse 2,Verse 1

-
  name: Entries with an attribute "category" lists entries related to the specified category.
  template: <MTEntries category="foo"><MTEntryTitle></MTEntries>
  expected: Verse 3

-
  name: Entries with an attribute "author" lists entries written by the specified author.
  template: <MTEntries author="Bob D"><MTEntryTitle></MTEntries>
  expected: Verse 3

-
  name: Entries with an attribute "days" lists entries posted within DAYS_CONSTANT1 days.
  template: <MTEntries days="DAYS_CONSTANT1"><MTEntryTitle></MTEntries>
  expected: A Rainy Day

-
  name: Entries with an attribute "days" lists entries posted within DAYS_CONSTANT2 days.
  template: <MTEntries days="DAYS_CONSTANT2"><MTEntryTitle></MTEntries>
  expected: ''

-
  name: Entries with attributes "offset=2" and "lastn=2" lists specified entries.
  template: |
    <MTEntries offset="2" lastn="2">
      * <MTEntryTitle>
    </MTEntries>
  expected: |
    * Verse 4
    * Verse 3

-
  name: Entries with an attribute "offset=2" lists specified entries.
  template: |
    <MTEntries offset="2">
      * <MTEntryTitle>
    </MTEntries>
  expected: |
    * Verse 4
    * Verse 3
    * Verse 2
    * Verse 1

-
  name: Entries with attributes "category=subfoo" and "lastn=1" lists specified entries.
  template: |
    <MTEntries category='subfoo' lastn='1'>
      <MTEntryTitle>
    </MTEntries>
  expected: Verse 4

-
  name: Entries with attributes "tags=verse", "category=foo" and "lastn=1" lists specified entries.
  template: |
    <MTEntries tags='verse' category='foo' lastn='1'><MTEntryTitle></MTEntries>
  expected: Verse 3

-
  name: Entries with attributes "author=Bob D" and "category=foo" lists specified entries.
  template: <MTEntries author='Bob D' category='foo'><MTEntryTitle></MTEntries>
  expected: Verse 3

-
  name: Entries with attributes "author=Chuck D" and "tags=strolling" lists specified entries.
  template: <MTEntries author='Chuck D' tags='strolling'><MTEntryTitle></MTEntries>
  expected: A Rainy Day

-
  name: Entries with an attribute "recently_commented_on=3" lists specified entries.
  template: |
    <MTEntries recently_commented_on='3'>
      <MTEntryTitle>
    </MTEntries>
  expected: |
    Verse 2
    Verse 3
    A Rainy Day

-
  name: Entries with an attribute "limit=1" lists specified entries.
  template: |
    <mt:entries limit='1'><mt:EntryTitle></mt:Entries>
  expected: A Rainy Day

-
  name: Entries with an attribute "category=NOT foo" lists specified entries.
  template: |
    <mt:entries category='NOT foo'>
      <mt:EntryTitle>;
    </mt:Entries>
  expected: |
    A Rainy Day;
    Verse 5;
    Verse 4;
    Verse 2;
    Verse 1;

-
  name: Entries with attributes "lastn=1" and "tags=verse" lists specified entries.
  template: "<mt:entries lastn='1' tags='verse'><mt:EntryTitle></mt:Entries>"
  expected: Verse 5

-
  name: Entries with an attribute "tag" doesn't list entries if specified tag doesn't exist.
  template: <MTEntries tags='@grandparent'><MTEntryTitle></MTEntries>
  expected: ''

-
  name: EntryCategories lists all categories related to the entry.
  template: |
    <MTEntryCategories>
      <MTCategoryLabel>
    </MTEntryCategories>
  expected: |
    bar
    foo
  stash:
    entry: $foo_entry

-
  name: EntryTrackbackCount prints the number of the pings of the entry.
  template: <MTEntryTrackbackCount>
  expected: 1

-
  name: EntryNext create the page content for the next page.
  template: |
    <MTEntryNext><MTEntryTitle></MTEntryNext>
  expected: A Rainy Day
  stash:
    entry: $previous_entry

-
  name: EntryPrevious create the page content for the previous page.
  template: |
    <MTEntryPrevious><MTEntryTitle></MTEntryPrevious>
  expected: Verse 5
  stash:
    entry: $entry

-
  name: EntryIfExtended prints inner content if the entry has a extended content.
  template: <MTEntryIfExtended>entry is extended</MTEntryIfExtended>
  expected: entry is extended

-
  name: EntriesCount prints the number of the entries of the blog.
  template: <MTEntriesCount>
  expected: 6

-
  name: DateHeader and DateFooter prints inner content if the entry is the first one of the day.
  template: |
    <MTEntries lastn='3'>
      <MTDateHeader>
        Header:<MTEntryDate>,
      </MTDateHeader>
      <MTDateFooter>
        Footer:<MTEntryDate>,
      </MTDateFooter>
    </MTEntries>
  expected: |
    Header:January 31, 1978  7:45 AM,
    Footer:January 31, 1978  7:45 AM,
    Header:January 31, 1965  7:45 AM,
    Footer:January 31, 1965  7:45 AM,
    Header:January 31, 1964  7:45 AM,
    Footer:January 31, 1964  7:45 AM,

-
  name: EntriesHeader and EntriesFooter prints the header and the footer.
  template: |
    <MTEntries lastn='3'>
      <MTEntriesHeader>
        <ul>
      </MTEntriesHeader>
      <li><MTEntryTitle></li>
      <MTEntriesFooter>
        </ul>
      </MTEntriesFooter>
    </MTEntries>
  expected: |
    <ul>
      <li>A Rainy Day</li>
      <li>Verse 5</li>
      <li>Verse 4</li>
    </ul>

-
  name: EntryAdditionalCategories prints categories (except for the primary one) related to the entry.
  template: |
    <MTEntryAdditionalCategories>
      <MTCategoryLabel>
    </MTEntryAdditionalCategories>
  expected: |
    bar
  stash:
    entry: $foo_entry

-
  name: EntryAuthorUserpic prints the img tag that display the userpic of the author of the entry.
  template: <MTEntryAuthorUserpic>
  expected: <img src="/mt-static/support/assets_c/userpics/userpic-2-100x100.png?3" width="100" height="100" alt="" />

-
  name: EntryAuthorUserpicURL prints the URL of the userpic of the author of the entry.
  template: <MTEntryAuthorUserpicURL>
  expected: /mt-static/support/assets_c/userpics/userpic-2-100x100.png

-
  name: EntryAuthorUserpicAsset creates the asset context for the userpic of the author of the entry.
  template: <MTEntryAuthorUserpicAsset><MTAssetFilename></MTEntryAuthorUserpicAsset>
  expected: test.jpg

-
  name: EntryBlogDescription prints the description of the blog of the entry.
  template: <MTEntryBlogDescription>
  expected: Narnia None Test Blog

-
  name: EntryBlogId prints the ID of the blog of the entry.
  template: <MTEntryBlogID>
  expected: 1

-
  name: EntryBlogName prints the name of the blog of the entry.
  template: <MTEntryBlogName>
  expected: none

-
  name: EntryBlogURL prints the URL of the blog of the entry.
  template: <MTEntryBlogURL>
  expected: "http://narnia.na/nana/"

-
  name: EntryClassLabel prints the class name of the entry.
  template: <MTEntryClassLabel lower_case='1'>
  expected: entry

-
  name: EntryIfCategory prints inner content if the entry is related to the specified category.
  template: |
    <MTEntryIfCategory category='foo'>
      <MTCategoryLabel>
    </MTEntryIfCategory>
  expected: foo
  stash:
    entry: $foo_entry

-
  name: EntryPrimaryCategory creates the category context for the primary category of the entry.
  template: |
    <MTEntryPrimaryCategory><MTCategoryLabel></MTEntryPrimaryCategory>
  expected: foo
  stash:
    entry: $foo_entry

-
  name: EntryCategories with an attribute "type=primary" creates the category context for the primary category of the entry.
  template: |
    <MTEntryCategories type="primary"><MTCategoryLabel></MTEntryCategories>
  expected: foo
  stash:
    entry: $foo_entry


######## Entries
## lastn (optional)
## limit (optional)
## sort_by (optional; default "authored_on")
## sort_order (optional)
## field:I<basename>
## namespace (optional)
## class_type (optional; default entry)
## offset (optional)
## category or categories (optional)
## include_subcategories (optional)
## tag or tags (optional)
## author (optional)
## id (optional)
## min_score (optional)
## max_score (optional)
## min_rate (optional)
## max_rate (optional)
## min_count (optional)
## max_count (optional)
## scored_by (optional)
## days (optional)
## recently_commented_on (optional)
## unique
## glue (optional)

######## EntriesHeader

######## EntriesFooter

######## EntryPrevious

######## EntryNext

######## DateHeader

######## DateFooter

######## EntryIfExtended

######## AuthorHasEntry

######## EntriesCount

######## EntryID
## pad (optional; default "0")

######## EntryTitle
## generate (optional)

######## EntryStatus

######## EntryFlag
## flag (required)

######## EntryBody
## convert_breaks (optional; default "1")
## words (optional)

######## EntryMore

######## EntryExcerpt
## no_generate (optional)
## words (optional; default "40")
## convert_breaks (optional; default "0")

######## EntryKeywords

######## EntryLink
## archive_type (optional)
## type (optional, alias of archive_type)
## Category
## Monthly
## Weekly
## Daily
## Individual
## Author
## Yearly
## Author-Daily
## Author-Weekly
## Author-Monthly
## Author-Yearly
## Category-Daily
## Category-Weekly
## Category-Monthly
## Category-Yearly
## L<EntryPermalink>

######## EntryBasename
## separator (optional)

######## EntryAtomID

######## EntryPermalink
## type or archive_type (optional)
## valid_html (optional; default "0")
## with_index (optional; default "0")

######## EntryClass

######## EntryClassLabel

######## EntryAuthor

######## EntryAuthorDisplayName

######## EntryAuthorNickname

######## EntryAuthorUsername

######## EntryAuthorEmail
## spam_protect (optional; default "0")

######## EntryAuthorURL

######## EntryAuthorLink
## new_window
## show_email (optional; default "0")
## spam_protect (optional)
## type (optional)
## show_hcard (optional; default "0")

######## EntryAuthorID

######## AuthorEntryCount

######## EntryDate

######## EntryCreatedDate

######## EntryModifiedDate

######## EntryBlogID

######## EntryBlogName

######## EntryBlogDescription

######## EntryBlogURL

######## EntryEditLink
## text (optional; default "Edit")

######## BlogEntryCount

