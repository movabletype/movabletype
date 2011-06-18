#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt = MT->instance;

my %folders         = ();
my %folders_to_load = qw(
    folder 21
    nextfolder 20
    subfolder 22
);
while ( my ( $key, $id ) = each(%folders_to_load) ) {
    $folders{$key} = MT->model('folder')->load($id);
}
$folders{subsubfolder} = MT->model('folder')->new;
$folders{subsubfolder}->set_values(
    {   blog_id => 1,
        label   => 'subsubfolder',
        parent  => $folders{subfolder}->id,
    }
);
$folders{subsubfolder}->save or die $folders{subsubfolder}->errstr;

my %pages         = ();
my %pages_to_load = qw(
    download_page 22
    not_download_page 23
);
while ( my ( $key, $id ) = each(%pages_to_load) ) {
    $pages{$key} = MT->model('page')->load($id);
}

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{$_} = $folders{$_} for keys(%folders);
    $stock->{$_} = $pages{$_}   for keys(%pages);
};
local $MT::Test::Tags::PRERUN_PHP =
    join('', map({
        '$stock["' . $_ . '"] = $db->fetch_folder(' . $folders{$_}->id . ');'
    } keys(%folders)))
    . join('', map({
        '$stock["' . $_ . '"] = $db->fetch_page(' . $pages{$_}->id . ');'
    } keys(%pages)));


run_tests_by_data();
__DATA__
-
  name: FolderID prints ID of the folder.
  template: |
    <MTFolderID>
  expected: |
    21
  stash:
    category: $folder

-
  name: FolderBasename prints the basename of the folder.
  template: |
    <MTFolderBasename>
  expected: |
    download
  stash:
    category: $folder

-
  name: FolderLabel prints the label of the folder.
  template: |
    <MTFolderLabel>
  expected: |
    download
  stash:
    category: $folder

-
  name: FolderPath prints the path of the folder.
  template: |
    <MTFolderPath>
  expected: |
    download
  stash:
    category: $folder

-
  name: FolderDescription prints the description of the folder.
  template: |
    <MTFolderDescription>
  expected: |
    download top
  stash:
    category: $folder

-
  name: Folders lists all folders of the blog.
  template: |
    <MTFolders>
      <MTFolderID>
    </MTFolders>
  expected: |
    21
    20
    22

-
  name: SubFolders lists all sub folders of the folder.
  template: |
    <MTSubFolders><MTFolderID></MTSubFolders>
  expected: 22
  stash:
    category: $folder

-
  name: ParentFolders lists all parent folders of the folder.
  template: |
    <MTParentFolders>
      <MTFolderID>
    </MTParentFolders>
  expected: |
    21
    22
  stash:
    category: $subfolder

-
  name: TopLevelFolders lists all top-level folders of the blog.
  template: |
    <MTTopLevelFolders>
      <MTFolderID>
    </MTTopLevelFolders>
  expected: |
    21
    20

-
  name: FolderCount prints the number of published pages related to the folder.
  template: |
    <MTFolderCount>
  expected: |
    1
  stash:
    category: $folder

-
  name: ParentFolder creates the folder context for the parent folder.
  template: |
    <MTParentFolder>
      <MTFolderLabel>
    </MTParentFolder>
  expected: |
    download
  stash:
    category: $subfolder

-
  name: HasParentFolder prints inner content if the folder has a parent.
  template: |
    <MTHasParentFolder>
      <MTFolderLabel>
    </MTHasParentFolder>
  expected: nightly
  stash:
    category: $subfolder

-
  name: HasParentFolder doesn't print inner content if the folder doesn't have a parent.
  template: |
    <MTHasParentFolder>
      <MTFolderLabel>
    </MTHasParentFolder>
  expected: ''
  stash:
    category: $folder

-
  name: SubFolderRecurse recursively prints the content including oneself.
  template: |
    <MTSubFolders>
        <MTFolderLabel>
        <MTSubfolderRecurse>
    </MTSubFolders>
  expected: |
    nightly
    subsubfolder
  stash:
    category: $folder

-
  name: TopLevelFolder creates the folder context for the top-level folder.
  template: |
    <MTToplevelFolder>
      <MTFolderLabel>
    </MTToplevelFolder>
  expected: download
  stash:
    category: $subsubfolder

-
  name: FolderHeader and FolderFooter prints the header and the footer.
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
  name: FolderNext creates the folder context for the next folder.
  template: |
    <MTFolderNext show_empty='1'><MTFolderLabel></MTFolderNext>
  expected: |
    info
  stash:
    category: $folder

-
  name: FolderNext doesn't create the folder context if the next folder doesn't exist.
  template: |
    <MTFolderNext show_empty='1'><MTFolderLabel></MTFolderNext>
  expected: ''
  stash:
    category: $subfolder

-
  name: FolderPrevious creates the folder context for the previous folder.
  template: |
    <MTFolderPrevious show_empty='1'><MTFolderLabel></MTFolderPrevious>
  expected: |
    download
  stash:
    category: $nextfolder

-
  name: FolderPrevious doesn't create the folder context if the previous folder doesn't exist.
  template: |
    <MTFolderPrevious show_empty='1'><MTFolderLabel></MTFolderPrevious>
  expected: ''
  stash:
    category: $folder

-
  name: HasSubFolders prints inner content if the folder has a sub folder.
  template: |
    <MTHasSubFolders>
      current folder: <MTFolderID>
      <MTSubFolders>sub folder: <MTFolderID></MTSubFolders>
    </MTHasSubFolders>
  expected: |
    current folder: 21
    sub folder: 22
  stash:
    category: $folder

-
  name: IfFolder with an attribute "name" prints inner content if current page is related to specified folder.
  template: |
    <MTIfFolder name='download'>download</MTIfFolder>
  expected: download
  stash:
    entry: $download_page

-
  name: IfFolder with an attribute "name" doesn't print inner content if current page isn't related to specified folder.
  template: |
    <MTIfFolder name='download'>download</MTIfFolder>
  expected: ''
  stash:
    entry: $not_download_page


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

