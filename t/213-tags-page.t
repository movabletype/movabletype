#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 312
  template: <MTPages><MTPageID>;</MTPages>
  expected: 23;22;21;20;

-
  name: test item 313
  template: <MTPages lastn='1'><MTPageID>;</MTPages>
  expected: 23;

-
  name: test item 314
  template: <MTPages lastn='1' offset='1'><MTPageID>;</MTPages>
  expected: 22;

-
  name: test item 315
  template: <MTPages folder='info'><MTPageID>;</MTPages>
  expected: 21;

-
  name: test item 316
  template: <MTPages folder='download' include_subfolders='1'><MTPageID>;</MTPages>
  expected: 23;22;

-
  name: test item 317
  template: <MTPages tag='river'><MTPageID>;</MTPages>
  expected: 20;

-
  name: test item 318
  template: <MTPages id='20'><MTPageID>;</MTPages>
  expected: 20;

-
  name: test item 319
  template: <MTPages sort_by='created_on' sort_order='scend'><MTPageID>;</MTPages>
  expected: 23;22;21;20;

-
  name: test item 320
  template: <MTPages id='21'><MTPageFolder><MTFolderID></MTPageFolder></MTPages>
  expected: 20

-
  name: test item 321
  template: <MTPages id='20'><MTPageTags><MTTagName>;</MTPageTags></MTPages>
  expected: flow;river;watch;

-
  name: test item 322
  template: <MTPages id='20'><MTPageTitle></MTPages>
  expected: Watching the River Flow

-
  name: test item 323
  template: <MTPages id='20'><MTPageBody></MTPages>
  expected: <p>What the matter with me,</p>

-
  name: test item 324
  template: <MTPages id='20'><MTPageDate format_name='rfc822'></MTPages>
  expected: "Tue, 31 Jan 1978 07:45:00 -0330"

-
  name: test item 325
  template: <MTPages id='20'><MTPageModifiedDate format_name='rfc822'></MTPages>
  expected: "Tue, 31 Jan 1978 07:46:00 -0330"

-
  name: test item 326
  template: <MTPages id='20'><MTPageAuthorDisplayName></MTPages>
  expected: Chucky Dee

-
  name: test item 327
  template: <MTPages id='20'><MTPageKeywords></MTPages>
  expected: no folder

-
  name: test item 328
  template: <MTPages id='20'><MTPageBasename></MTPages>
  expected: watching_the_river_flow

-
  name: test item 329
  template: <MTPages id='20'><MTPagePermalink></MTPages>
  expected: "http://narnia.na/nana/watching-the-river-flow.html"

-
  name: test item 330
  template: <MTPages id='20'><MTPageAuthorEmail></MTPages>
  expected: chuckd@example.com

-
  name: test item 331
  template: <MTPages id='20'><MTPageAuthorLink></MTPages>
  expected: "<a href=\"http://chuckd.com/\">Chucky Dee</a>"

-
  name: test item 332
  template: <MTPages id='20'><MTPageAuthorURL></MTPages>
  expected: "http://chuckd.com/"

-
  name: test item 333
  template: <MTPages id='20'><MTPageExcerpt></MTPages>
  expected: excerpt

-
  name: test item 334
  template: <MTBlogPageCount>
  expected: 4

-
  name: test item 353
  run: 0
  template: <MTArchiveList type='Monthly'><MTPages><MTPageTitle></MTPages></MTArchiveList>
  expected: Watching the River Flow

-
  name: test item 357
  template: <MTPages id='20'><$MTPageMore$></MTPages>
  expected: <p>I don't have much to say,</p>

-
  name: test item 511
  template: <MTPages lastn='1'><MTPageIfTagged tag='page3'><MTPageTitle></MTPageIfTagged></MTPages>
  expected: 'Page #3'

-
  name: test item 512
  template: <MTPages lastn='1' offset='1'><MTPageNext><MTPageTitle></MTPageNext></MTPages>
  expected: 'Page #3'

-
  name: test item 513
  template: <MTPages lastn='1'><MTPagePrevious><MTPageTitle></MTPagePrevious></MTPages>
  expected: 'Page #2'

-
  name: test item 514
  template: <MTPages lastn='3'><MTPagesHeader><ul></MTPagesHeader><li><MTPageTitle></li><MTPagesFooter></ul></MTPagesFooter></MTPages>
  expected: '<ul><li>Page #3</li><li>Page #2</li><li>Page #1</li></ul>'

