#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt          = MT->instance;
my $page        = MT->model('page')->load(20);
my $page_folder = MT->model('page')->load(21);
my $page_tag2   = MT->model('page')->load(22);
my $page_tag3   = MT->model('page')->load(23);

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{page}        = $page;
    $stock->{page_folder} = $page_folder;
    $stock->{page_tag2}   = $page_tag2;
    $stock->{page_tag3}   = $page_tag3;
};
local $MT::Test::Tags::PRERUN_PHP
    = '$stock["page"] = $db->fetch_page(' . $page->id . ');'
    . '$stock["page_folder"] = $db->fetch_page(' . $page_folder->id . ');'
    . '$stock["page_tag2"] = $db->fetch_page(' . $page_tag2->id . ');'
    . '$stock["page_tag3"] = $db->fetch_page(' . $page_tag3->id . ');';


run_tests_by_data();
__DATA__
-
  name: PageID prints ID of the page.
  template: |
    <MTPageID>;
  expected: 20;
  stash:
    entry: $page

-
  name: PageTitle prints the title of the page.
  template: <MTPageTitle>
  expected: Watching the River Flow
  stash:
    entry: $page

-
  name: PageBody prints the body of the page.
  template: <MTPageBody>
  expected: <p>What the matter with me,</p>
  stash:
    entry: $page

-
  name: PageMore prints the more of the page.
  template: <$MTPageMore$>
  expected: <p>I don't have much to say,</p>
  stash:
    entry: $page

-
  name: PageDate prints the publish-date of the page.
  template: <MTPageDate format_name='rfc822'>
  expected: "Tue, 31 Jan 1978 07:45:00 -0330"
  stash:
    entry: $page

-
  name: PageModifiedDate prints the modified-date of the page.
  template: <MTPageModifiedDate format_name='rfc822'>
  expected: "Tue, 31 Jan 1978 07:46:00 -0330"
  stash:
    entry: $page

-
  name: PageAuthorDisplayName prints the display name of the author of the page.
  template: <MTPageAuthorDisplayName>
  expected: Chucky Dee
  stash:
    entry: $page

-
  name: PageKeywords prints the keywords of the page.
  template: <MTPageKeywords>
  expected: no folder
  stash:
    entry: $page

-
  name: PageBasename prints the basename of the page.
  template: <MTPageBasename>
  expected: watching_the_river_flow
  stash:
    entry: $page

-
  name: PagePermalink prints the permalink of the page.
  template: <MTPagePermalink>
  expected: "http://narnia.na/nana/watching-the-river-flow.html"
  stash:
    entry: $page

-
  name: PageAuthorEmail prints the email address of the author of the page.
  template: <MTPageAuthorEmail>
  expected: chuckd@example.com
  stash:
    entry: $page

-
  name: PageAuthorLink prints the link of the author of the page.
  template: <MTPageAuthorLink>
  expected: "<a href=\"http://chuckd.com/\">Chucky Dee</a>"
  stash:
    entry: $page

-
  name: PageAuthorLink prints the URL of the author of the page.
  template: <MTPageAuthorURL>
  expected: "http://chuckd.com/"
  stash:
    entry: $page

-
  name: PageExcerpt prints the excerpt of the page.
  template: <MTPageExcerpt>
  expected: excerpt
  stash:
    entry: $page

-
  name: Pages lists all pages of the blog.
  template: |
    <MTPages>
      <MTPageID>
    </MTPages>
  expected: |
    23
    22
    21
    20

-
  name: Pages with attributes "lastn" and "offset" lists all specified pages.
  template: |
    <MTPages lastn='1' offset='1'>
      <MTPageID>
    </MTPages>
  expected: 22

-
  name: Pages with an attribute "folder" lists all pages related to the specified folder.
  template: |
    <MTPages folder='info'>
      <MTPageID>
    </MTPages>
  expected: 21

-
  name: Pages with attributes "folder" and "include_subfolders" lists all pages related to the specified folders.
  template: |
    <MTPages folder='download' include_subfolders='1'>
      <MTPageID>
    </MTPages>
  expected: |
    23
    22

-
  name: Pages with an attribute "tag" lists all pages related to the specified tag.
  template: |
    <MTPages tag='river'>
      <MTPageID>;
    </MTPages>
  expected: 20;

-
  name: Pages with an attribute "id" lists all specified pages.
  template: |
    <MTPages id='20'>
      <MTPageID>
    </MTPages>
  expected: 20

-
  name: Pages with attributes "sort_by=created_on" and "sort_order=ascend" sorts and clists all pages of the blog.
  template: |
    <MTPages sort_by='created_on' sort_order='descend'>
      <MTPageID>
    </MTPages>
  expected: |
    23
    22
    21
    20

-
  name: PageFolder prepare the folder context for the folder that related to the page.
  template: |
    <MTPageFolder><MTFolderID></MTPageFolder>
  expected: 20
  stash:
    entry: $page_folder

-
  name: PageTags lists all tags related to the page.
  template: |
    <MTPageTags>
      <MTTagName>
    </MTPageTags>
  expected: |
    flow
    river
    watch
  stash:
    entry: $page

-
  name: BlogPageCount prints the number of pages of the blog.
  template: <MTBlogPageCount>
  expected: 4

-
  name: PageIfTagged prints inner content if the page has the specified tag.
  template: |
    <MTPageIfTagged tag='page3'>
      <MTPageTitle>
    </MTPageIfTagged>
  expected: 'Page #3'
  stash:
    entry: $page_tag3

-
  name: PageNext prepare the page content for the next page.
  template: |
    <MTPageNext><MTPageTitle></MTPageNext>
  expected: 'Page #3'
  stash:
    entry: $page_tag2

-
  name: PagePrevious prepare the page content for the previous page.
  template: |
    <MTPagePrevious><MTPageTitle></MTPagePrevious>
  expected: 'Page #2'
  stash:
    entry: $page_tag3

-
  name: PagesHeader and PagesFooter prints the header and the footer.
  template: |
    <MTPages lastn='3'>
      <MTPagesHeader><ul></MTPagesHeader>
        <li><MTPageTitle></li>
      <MTPagesFooter></ul></MTPagesFooter>
    </MTPages>
  expected: |
    <ul>
      <li>Page #3</li>
      <li>Page #2</li>
      <li>Page #1</li>
    </ul>


######## AuthorHasPage

######## Pages
## folder or folders (optional)
## no_folder (optional)
## include_subfolders (optional)

######## PagePrevious

######## PageNext

######## PagesHeader

######## PagesFooter

######## PageID

######## PageTitle

######## PageBody
## words
## convert_breaks

######## PageMore
## convert_breaks (optional)

######## PageDate
## format
## language
## utc

######## PageModifiedDate
## format
## language
## utc

######## PageKeywords

######## PageBasename
## separator (optional)

######## PagePermalink

######## PageAuthorDisplayName

######## PageAuthorEmail

######## PageAuthorLink
## show_email
## show_url
## new_window

######## PageAuthorURL

######## PageExcerpt
## convert_breaks (optional; default "0")

######## WebsitePageCount

######## BlogPageCount

