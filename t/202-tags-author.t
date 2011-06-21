#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt = MT->instance;

my %authors         = ();
my %authors_to_load = qw(
    no_entry_author 1
    author 2
    previous_author 3
);
while ( my ( $key, $id ) = each(%authors_to_load) ) {
    $authors{$key} = MT->model('author')->load($id);
}

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{$_} = $authors{$_}   for keys(%authors);
};
local $MT::Test::Tags::PRERUN_PHP
    = join('', map({
        '$stock["' . $_ . '"] = $db->fetch_author(' . $authors{$_}->id . ');'
    } keys(%authors)));


run_tests_by_data();
__DATA__
-
  name: AuthorID prints the ID of the author.
  template: |
    <MTAuthorID>
  expected: |
    2
  stash:
    author: $author

-
  name: AuthorName prints the name of the author.
  template: |
    <MTAuthorName>
  expected: |
    Chuck D
  stash:
    author: $author

-
  name: AuthorDisplayName prints the name of the author.
  template: |
    <MTAuthorDisplayName>
  expected: |
    Chucky Dee
  stash:
    author: $author

-
  name: AuthorEmail prints the name of the author.
  template: |
    <MTAuthorEmail>
  expected: |
    chuckd@example.com
  stash:
    author: $author

-
  name: AuthorURL the name of the author.
  template: |
    <MTAuthorURL>
  expected: |
    http://chuckd.com/
  stash:
    author: $author

-
  name: Authors lists all authors who has been posted entry to the blog.
  template: |
    <MTAuthors>
      <MTAuthorName>
    </MTAuthors>
  expected: |
    Chuck D
    Bob D

-
  name: Authors with an attribute "sort_by=name" sorts by name and lists authors.
  template: |
    <MTAuthors sort_by='name'>
      <MTAuthorName>
    </MTAuthors>
  expected: |
    Bob D
    Chuck D

-
  name: Authors with an attribute "sort_by=nickname" sorts by nickname and lists authors.
  template: |
    <MTAuthors sort_by='nickname'>
      <MTAuthorDisplayName>
    </MTAuthors>
  expected: |
    Chucky Dee
    Dylan

-
  name: Authors with attributes "sort_by=nickname" and "sort_order" sorts by nickname with specified order and lists authors.
  template: |
    <MTAuthors sort_by='display_name' sort_order='descend'>
      <MTAuthorDisplayName>
    </MTAuthors>
  expected: |
    Dylan
    Chucky Dee

-
  name: Authors with an attribute "sort_by=email" sorts by email and lists authors.
  template: |
    <MTAuthors sort_by='email'>
      <MTAuthorEmail>
    </MTAuthors>
  expected: |
    bobd@example.com
    chuckd@example.com

-
  name: Authors with an attribute "sort_by=url" sorts by URL and lists authors.
  template: |
    <MTAuthors sort_by='url'>
      url: <MTAuthorURL>
    </MTAuthors>
  expected: |
    url: 
    url: http://chuckd.com/

-
  name: Authors with an attribute "username" create context for the specified author.
  template: |
    <MTAuthors username='Chuck D'>
      name: <MTAuthorName>
      nick: <MTAuthorDisplayName>
      mail: <MTAuthorEmail>
      url:  <MTAuthorURL>
    </MTAuthors>
  expected: |
    name: Chuck D
    nick: Chucky Dee
    mail: chuckd@example.com
    url:  http://chuckd.com/

-
  name: Authors with attributes "username" and "id" create context for the specified author by "id".
  template: |
    <mt:authors id='2' username='Bob D'>
      name: <MTAuthorName>;
      nick: <MTAuthorDisplayName>;
      mail: <MTAuthorEmail>;
      url:  <MTAuthorURL>;
    </mt:authors>
  expected: |
    name: Chuck D;
    nick: Chucky Dee;
    mail: chuckd@example.com;
    url:  http://chuckd.com/;

-
  name: Authors with an attribute "id" create context for the specified author.
  template: |
    <mt:authors id='2'>
      name: <MTAuthorName>;
      nick: <MTAuthorDisplayName>;
      mail: <MTAuthorEmail>;
      url:  <MTAuthorURL>;
    </mt:authors>
  expected: |
    name: Chuck D;
    nick: Chucky Dee;
    mail: chuckd@example.com;
    url:  http://chuckd.com/;

-
  name: AuthorAuthType prints authentication type
  template: |
    <$MTAuthorAuthType$>
  expected: |
    MT
  stash:
    author: $author

-
  name: AuthorAuthIconURL prints the URL of authentication icon.
  template: |
    <$MTAuthorAuthIconURL$>;
  expected: |
    http://narnia.na/mt-static/images/comment/mt_logo.png;
  stash:
    author: $author

-
  name: Authros with an attribute "need_entry=0" lists all enabled authors.
  template: |
    <MTAuthors need_entry='0' >
      <MTAuthorName>
    </MTAuthors>
  expected: |
    Chuck D
    Bob D
    Melody

-
  name: Authros with attributes "need_entry=0" and "status=disabled" lists disabled authors.
  template: |
    <MTAuthors need_entry='0' status='disabled'>
      <MTAuthorName>
    </MTAuthors>
  expected: Hiro Nakamura

-
  name: Authros with attributes "need_entry=0" and "status=disabled or disabled" lists all authors in the system.
  template: |
    <MTAuthors need_entry='0' status='enabled or disabled'>
      <MTAuthorName>
    </MTAuthors>
  expected: |
    Chuck D
    Bob D
    Hiro Nakamura
    Melody

-
  name: Authros with attributes "need_entry=0" and "role=Author" lists authors who has a role "Author".
  template: |
    <MTAuthors need_entry='0' role='Author'>
      <MTAuthorName>
    </MTAuthors>
  expected: |
    Bob D

-
  name: Authros with attributes "need_entry=0" and "role=Author or Designer" lists authors who has a role "Author" or "Designer".
  template: |
    <MTAuthors need_entry='0' role='Author or Designer'>
      <MTAuthorName>
    </MTAuthors>
  expected: |
    Bob D

-
  name: Authros with attributes "sort_by=score" and "offset=1" sorts by score with specified offset and lists authors.
  template: |
    <mt:Authors need_entry='0' namespace='unit test' sort_by='score' offset='1'>
      <mt:AuthorName>,
    </mt:Authors>
  expected: |
    Chuck D,
    Melody,

-
  name: Authros with attributes "sort_by=score" and "offset=2" sorts by score with specified offset and lists authors.
  template: |
    <mt:Authors need_entry='0' namespace='unit test' sort_by='score' offset='2'>
      <mt:AuthorName>,
    </mt:Authors>
  expected: |
    Melody,

-
  name: AuthorEntryCount prints the number of the author's published entries in the blog.
  template: <MTAuthorEntryCount>
  expected: 5
  stash:
    author: $author

-
  name: AuthorHasEntry prints inner content if an author has a entry in the blog.
  template: |
    <MTAuthorHasEntry>has</MTAuthorHasEntry>
  expected: has
  stash:
    author: $author

-
  name: AuthorHasEntry doesn't print inner content if an author doesn't have a entry in the blog.
  template: |
    <MTAuthorHasEntry>has</MTAuthorHasEntry>
  expected: ''
  stash:
    author: $no_entry_author

-
  name: AuthorHasPage prints inner content if an author has a page in the blog.
  template: |
    <MTAuthorHasPage>has</MTAuthorHasPage>
  expected: has
  stash:
    author: $author

-
  name: AuthorHasPage doesn't print inner content if an author doesn't have a page in the blog.
  template: |
    <MTAuthorHasPage>has</MTAuthorHasPage>
  expected: ''
  stash:
    author: $no_entry_author

-
  name: AuthorNext creates the author context for the next author.
  template: |
    <MTAuthorNext><MTAuthorName></MTAuthorNext>
  expected: Chuck D
  stash:
    author: $previous_author

-
  name: AuthorPrevious creates the author context for the previous author.
  template: |
    <MTAuthorPrevious><MTAuthorName></MTAuthorPrevious>
  expected: Bob D
  stash:
    author: $author

-
  name: AuthorUserpic prints the img tag to display the userpic of the author.
  template: <MTAuthorUserpic>
  expected: <img src="/mt-static/support/assets_c/userpics/userpic-2-100x100.png?3" width="100" height="100" alt="" />
  stash:
    author: $author

-
  name: AuthorUserpicAsset creates the asset context for the userpic of the author.
  template: |
    <MTAuthorUserpicAsset><MTAssetFileName></MTAuthorUserpicAsset>
  expected: test.jpg
  stash:
    author: $author

-
  name: AuthorUserpic prints the URL of the userpic of the author.
  template: <MTAuthorUserpicURL>
  expected: /mt-static/support/assets_c/userpics/userpic-2-100x100.png
  stash:
    author: $author

-
  name: AuthorBasename prints the basename of the author.
  template: <MTAuthorBasename>
  expected: chucky_dee
  stash:
    author: $author

-
  name: IfAuthor prints inner content if current context has a author.
  template: |
    <MTIfAuthor>HasAuthor:Inside</MTIfAuthor>
  expected: "HasAuthor:Inside"
  stash:
    author: $author

-
  name: IfAuthor doesn't print inner content if current context doesn't have a author.
  template: |
    <MTIfAuthor>HasAuthor:Inside</MTIfAuthor>
  expected: ""


######## Authors
## display_name
## lastn
## sort_by (optional)
## sort_order (optional; default "ascend")
## any_type (optional; default "0")
## roles
## need_entry (optional; default "1")
## need_association (optional; default "0")
## status (optional; default "enabled")
## namespace
## scoring_to
## min_score
## max_score
## min_rate
## max_rate
## min_count
## max_count

######## AuthorNext

######## AuthorPrevious

######## IfAuthor

######## AuthorID

######## AuthorName

######## AuthorDisplayName

######## AuthorEmail

######## AuthorURL

######## AuthorAuthType

######## AuthorAuthIconURL
## size (optional; default "logo_small")

######## AuthorBasename
## separator (optional)

