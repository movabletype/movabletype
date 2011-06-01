#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 335
  template: |
    <MTFolders>
      <MTFolderID>;
    </MTFolders>
  expected: |
    21;
    20;
    22;

-
  name: test item 336
  template: |
    <MTFolders>
      <MTSubFolders><MTFolderID></MTSubFolders>
    </MTFolders>
  expected: 22

-
  name: test item 337
  template: |
    <MTFolders>
      <MTSubFolders>
        <MTParentFolders>
          <MTFolderID>;
        </MTParentFolders>
      </MTSubFolders>
    </MTFolders>
  expected: |
    21;
    22;

-
  name: test item 338
  template: |
    <MTTopLevelFolders>
      <MTFolderID>;
    </MTTopLevelFolders>
  expected: |
    21;
    20;

-
  name: test item 339
  template: |
    <MTFolders>
      <MTFolderBasename>;
    </MTFolders>
  expected: |
    download;
    info;
    nightly;

-
  name: test item 340
  template: |
    <MTFolders>
      <MTFolderCount>;
    </MTFolders>
  expected: |
    1;
    1;
    1;

-
  name: test item 341
  template: |
    <MTFolders>
      <MTFolderDescription>;
    </MTFolders>
  expected: |
    download top;
    information;
    nightly build;

-
  name: test item 342
  template: |
    <MTFolders>
      <MTFolderLabel>;
    </MTFolders>
  expected: |
    download;
    info;
    nightly;

-
  name: test item 343
  template: |
    <MTFolders>
      <MTFolderPath>;
    </MTFolders>
  expected: |
    download;
    info;
    download/nightly;

-
  name: test item 515
  template: |
    <MTFolders>
      <MTParentFolder>
        <MTFolderLabel>
      </MTParentFolder>
    </MTFolders>
  expected: |
    download

-
  name: test item 516
  template: |
    <MTFolders>
      <MTHasParentFolder>
        <MTFolderLabel>
      </MTHasParentFolder>
    </MTFolders>
  expected: nightly

-
  name: test item 529
  template: |
    <MTSubFolders>
      <MTIF tag='FolderID' eq='21'>
        <MTFolderLabel>;
        <MTSubfolderRecurse>
      </MTIF>
    </MTSubFolders>
  expected: ''

-
  name: test item 532
  template: |
    <MTFolders>
      <MTIF tag='FolderID' eq='22'>
        <MTToplevelFolder>
          <MTFolderLabel>
        </MTToplevelFolder>
      </MTIF>
    </MTFolders>
  expected: download

-
  name: test item 535
  template: |
    <MTFolders>
      <MTFolderHeader><ul></MTFolderHeader>
        <li><MTFolderLabel></li>
      <MTFolderFooter></ul></MTFolderFooter>
    </MTFolders>
  expected: |
    <ul>
      <li>download</li>
      <li>info</li>
      <li>nightly</li>
    </ul>

-
  name: test item 536
  template: |
    <MTFolders show_empty='1'>
      <MTFolderLabel>-<MTFolderNext show_empty='1'><MTFolderLabel></MTFolderNext>
    </MTFolders>
  expected: |
    download-info
    info-
    nightly-

-
  name: test item 537
  template: |
    <MTFolders show_empty='1'>
      <MTFolderLabel>-<MTFolderPrevious show_empty='1'><MTFolderLabel></MTFolderPrevious>
    </MTFolders>
  expected: |
    download-
    info-download
    nightly-

-
  name: test item 538
  template: |
    <MTFolders>
      <MTHasSubFolders>
        <MTSubFolders><MTFolderID></MTSubFolders>
      </MTHasSubFolders>
    </MTFolders>
  expected: 22

-
  name: test item 545
  template: |
    <MTPages id='22'>
      <MTIfFolder name='download'>download</MTIfFolder>
    </MTPages>
  expected: download

-
  name: test item 546
  template: |
    <MTPages id='23'>
      <MTIfFolder name='download'>download</MTIfFolder>
    </MTPages>
  expected: ''


######## IfFolder
## name (or label; optional)

######## FolderHeader

######## FolderFooter

######## HasSubFolders

######## HasParentFolder

######## PageFolder

######## Folders
## show_empty

######## FolderPrevious

######## FolderNext

######## SubFolders
## include_current
## sort_method
## sort_order
## top

######## ParentFolders
## glue
## exclude_current

######## ParentFolder

######## TopLevelFolders

######## TopLevelFolder

######## FolderBasename
## default
## separator

######## FolderDescription

######## FolderID

######## FolderLabel

######## FolderCount

######## FolderPath
## separator

######## SubFolderRecurse
## max_depth (optional)

