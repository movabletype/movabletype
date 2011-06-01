#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: ArchiveList outputs proper list of archives
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
  name: ArchiveLink prints URL of the archive
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
  name: ArchivePrevious set previous archive's context
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
  name: ArchiveNext set next archive's context
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
  name: ArchiveCount prints the number of entries in that archive
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
  name: IfArchiveTypeEnabled judges specified archive type is enabled or not
  template: <MTIfArchiveTypeEnabled type="Category">enabled</MTIfArchiveTypeEnabled>
  expected: enabled

-
  name: Can use IndexList, IndexName, IndexLink and IndexBasename for create list of index templates
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
  name: ArchiveCategory prints category label of current archive
  template: |
    <MTArchiveList archive_type='Category'>
      <MTArchiveCategory>
    </MTArchiveList>
  expected: |
    foo
    subfoo

-
  name: ArchiveFile prints filename of current archive
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
  name: Archives prints the labels of enabled archive types in current blog
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
  name: ArchiveDateEnd prints the date that the end of current archive
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
  name: ArchiveDateEnd prints the date that the end of current archive, if archive type is Daily, too.
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
  name: ArchiveDateEnd prints the date that the end of current archive, if archive type is Weekly, too.
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
  name: ArchiveDate can use format attribute.
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
  name: Archives prints the labels of enabled archive types in current blog
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
  name: ArchiveTypeLabel prints descriptive label of the current archive type.
  template: |
    <MTArchiveList type='Individual'>
      <MTArchiveListHeader>
        <MTArchiveTypeLabel>
      </MTArchiveListHeader>
    </MTArchiveList>
  expected: Entry


######## Archives
## type or archive_type (optional)

######## ArchiveList
## type or archive_type
## lastn (optional)
## sort_order (optional; default "descend")

######## ArchiveListHeader

######## ArchiveListFooter

######## ArchivePrevious
## type or archive_type (optional)

######## ArchiveNext
## type or archive_type (optional)

######## IfArchiveType
## type
## archive_type

######## IfArchiveTypeEnabled
## type or archive_type

######## IndexList

######## ArchiveLink
## type (optional)
## archive_type (optional)
## with_index (optional; default "0")

######## ArchiveTitle
## Category
## Daily
## Weekly
## Monthly
## Individual

######## ArchiveType

######## ArchiveLabel

######## ArchiveTypeLabel

######## ArchiveCount

######## ArchiveDate

######## ArchiveDateEnd
## format (optional)
## language (optional; defaults to blog language)
## utc (optional; default "0")
## relative (optional; default "0")

######## ArchiveFile
## extension
## separator

######## IndexLink
## with_index (optional; default "0")

######## IndexName

