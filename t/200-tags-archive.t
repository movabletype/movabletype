#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 35
  template: |
    <MTArchiveList archive_type="Monthly">
      <MTArchiveListHeader>(Header)</MTArchiveListHeader>
      <MTArchiveListFooter>(Footer)</MTArchiveListFooter><MTArchiveTitle>|
    </MTArchiveList>
  expected: |
    (Header)
      January 1978|
      January 1965|
      January 1964|
      January 1963|
      January 1962|
      (Footer)January 1961|

-
  name: test item 147
  template: |
    <MTArchiveList archive_type="Monthly">
      <MTArchiveTitle>-<MTArchiveLink>;
    </MTArchiveList>
  expected: |
    January 1978-http://narnia.na/nana/archives/1978/01/;
    January 1965-http://narnia.na/nana/archives/1965/01/;
    January 1964-http://narnia.na/nana/archives/1964/01/;
    January 1963-http://narnia.na/nana/archives/1963/01/;
    January 1962-http://narnia.na/nana/archives/1962/01/;
    January 1961-http://narnia.na/nana/archives/1961/01/;

-
  name: test item 148
  template: |
    <MTArchiveList archive_type="Monthly">
      <MTArchivePrevious>
        <MTArchiveTitle>-<MTArchiveLink>;
      </MTArchivePrevious>
    </MTArchiveList>
  expected: |
    January 1965-http://narnia.na/nana/archives/1965/01/;
    January 1964-http://narnia.na/nana/archives/1964/01/;
    January 1963-http://narnia.na/nana/archives/1963/01/;
    January 1962-http://narnia.na/nana/archives/1962/01/;
    January 1961-http://narnia.na/nana/archives/1961/01/;

-
  name: test item 149
  template: |
    <MTArchiveList archive_type="Monthly">
      <MTArchiveNext>
        <MTArchiveTitle>-<MTArchiveLink>;
      </MTArchiveNext>
    </MTArchiveList>
  expected: |
    January 1978-http://narnia.na/nana/archives/1978/01/;
    January 1965-http://narnia.na/nana/archives/1965/01/;
    January 1964-http://narnia.na/nana/archives/1964/01/;
    January 1963-http://narnia.na/nana/archives/1963/01/;
    January 1962-http://narnia.na/nana/archives/1962/01/;

-
  name: test item 150
  template: |
    <MTArchiveList archive_type="Monthly">
      <MTArchiveTitle>-<MTArchiveCount>;
    </MTArchiveList>
  expected: |
    January 1978-1;
    January 1965-1;
    January 1964-1;
    January 1963-1;
    January 1962-1;
    January 1961-1;

-
  name: test item 187
  template: <MTIfArchiveTypeEnabled type="Category">enabled</MTIfArchiveTypeEnabled>
  expected: enabled

-
  name: test item 203
  template: |
    <MTIndexList>
      <MTIndexName>-<MTIndexLink>-<MTIndexBasename>;
    </MTIndexList>
  expected: |
    Archive Index-http://narnia.na/nana/archives.html-index;
    Feed - Recent Entries-http://narnia.na/nana/atom.xml-index;
    JavaScript-http://narnia.na/nana/mt.js-index;
    Main Index-http://narnia.na/nana/-index;
    RSD-http://narnia.na/nana/rsd.xml-index;
    Stylesheet-http://narnia.na/nana/styles.css-index;

-
  name: test item 217
  template: |
    <MTArchiveList archive_type='Category'>
      <MTArchiveCategory>
    </MTArchiveList>
  expected: |
    foo
    subfoo

-
  name: test item 218
  template: |
    <MTArchiveList>
      <MTArchiveFile>
    </MTArchiveList>
  expected: |
    a_rainy_day.html
    verse_5.html
    verse_4.html
    verse_3.html
    verse_2.html
    verse_1.html

-
  name: test item 219
  template: |
    <MTArchives>
      <MTArchiveType>
    </MTArchives>
  expected: |
    Individual
    Monthly
    Weekly
    Daily
    Category
    Page

-
  name: test item 220
  template: |
    <MTArchiveList archive_type='Monthly'>
      <MTArchiveDateEnd>
    </MTArchiveList>
  expected: |
    January 31, 1978 11:59 PM
    January 31, 1965 11:59 PM
    January 31, 1964 11:59 PM
    January 31, 1963 11:59 PM
    January 31, 1962 11:59 PM
    January 31, 1961 11:59 PM

-
  name: test item 221
  template: |
    <MTArchiveList archive_type='Daily'>
      <MTArchiveDateEnd>
    </MTArchiveList>
  expected: |
    January 31, 1978 11:59 PM
    January 31, 1965 11:59 PM
    January 31, 1964 11:59 PM
    January 31, 1963 11:59 PM
    January 31, 1962 11:59 PM
    January 31, 1961 11:59 PM

-
  name: test item 222
  template: |
    <MTArchiveList archive_type='Weekly'>
      <MTArchiveDateEnd>
    </MTArchiveList>
  expected: |
    February  4, 1978 11:59 PM
    February  6, 1965 11:59 PM
    February  1, 1964 11:59 PM
    February  2, 1963 11:59 PM
    February  3, 1962 11:59 PM
    February  4, 1961 11:59 PM

-
  name: test item 346
  template: |
    <MTArchiveList archive_type='Individual' sort_order='ascend'>
      <$MTArchiveDate format='%Y.%m.%d.%H.%M.%S'$>;
    </MTArchiveList>
  expected: |
    1961.01.31.07.45.01;
    1962.01.31.07.45.01;
    1963.01.31.07.45.01;
    1964.01.31.07.45.01;
    1965.01.31.07.45.01;
    1978.01.31.07.45.00;

-
  name: test item 355
  template: |
    <MTArchives>
      <MTArchiveLabel>
    </MTArchives>
  expected: |
    Entry
    Monthly
    Weekly
    Daily
    Category
    Page

-
  name: test item 498
  template: |
    <MTArchiveList type='Individual'>
      <MTArchiveListHeader>
        <MTArchiveTypeLabel>
      </MTArchiveListHeader>
    </MTArchiveList>
  expected: Entry

