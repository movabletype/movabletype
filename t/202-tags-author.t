#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 347
  template: |
    <MTAuthors lastn="2">
      <MTAuthorID>;
    </MTAuthors>
  expected: |
    2;
    3;

-
  name: test item 348
  template: |
    <MTAuthors sort_by='name'>
      <MTAuthorName>;
    </MTAuthors>
  expected: |
    Bob D;
    Chuck D;

-
  name: test item 349
  template: |
    <MTAuthors sort_by='nickname'>
      <MTAuthorDisplayName>;
    </MTAuthors>
  expected: |
    Chucky Dee;
    Dylan;

-
  name: test item 350
  template: |
    <MTAuthors sort_by='email'>
      <MTAuthorEmail>;
    </MTAuthors>
  expected: |
    bobd@example.com;
    chuckd@example.com;

-
  name: test item 351
  template: |
    <MTAuthors sort_by='url'>
      <MTAuthorURL>;
    </MTAuthors>
  expected: |
    ;
    http://chuckd.com/;

-
  name: test item 352
  template: |
    <MTAuthors username='Chuck D'>
      name: <MTAuthorName>;
      nick: <MTAuthorDisplayName>;
      mail: <MTAuthorEmail>;
      url:  <MTAuthorURL>;
    </MTAuthors>
  expected: |
    name: Chuck D;
    nick: Chucky Dee;
    mail: chuckd@example.com;
    url:  http://chuckd.com/;

-
  name: test item 354
  template: |
    <MTAuthors sort_by='display_name' sort_order='descend'>
      <MTAuthorID>;
    </MTAuthors>
  expected: |
    3;
    2;

-
  name: test item 361
  template: |
    <MTAuthors>
      <$MTAuthorAuthType$>:<$MTAuthorAuthIconURL$>;
    </MTAuthors>
  expected: |
    MT:http://narnia.na/mt-static/images/comment/mt_logo.png;
    MT:http://narnia.na/mt-static/images/comment/mt_logo.png;

-
  name: test item 363
  template: |
    <MTAuthors need_entry='0' >
      <MTAuthorName>;
    </MTAuthors>
  expected: |
    Chuck D;
    Bob D;
    Melody;

-
  name: test item 364
  template: |
    <MTAuthors need_entry='0' status='disabled'>
      <MTAuthorName>;
    </MTAuthors>
  expected: Hiro Nakamura;

-
  name: test item 365
  template: |
    <MTAuthors need_entry='0' status='enabled or disabled'>
      <MTAuthorName>;
    </MTAuthors>
  expected: |
    Chuck D;
    Bob D;
    Hiro Nakamura;
    Melody;

-
  name: test item 366
  template: |
    <MTAuthors need_entry='0' role='Author'>
      <MTAuthorName>;
    </MTAuthors>
  expected: |
    Bob D;

-
  name: test item 367
  template: <MTAuthors need_entry='0' role='Author or Designer'><MTAuthorName>;</MTAuthors>
  expected: Bob D;

-
  name: test item 427
  template: |
    <mt:authors username='Chuck D'>
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
  name: test item 428
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
  name: test item 429
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
  name: test item 480
  template: <MTAuthors lastn="1"><MTAuthorEntryCount></MTAuthors>
  expected: 5

-
  name: test item 481
  template: |
    <MTAuthors lastn="1">
      <MTAuthorHasEntry>
        <MTAuthorName setvar="author_name">
        <MTEntries author="$author_name" lastn="1">has</MTEntries>
      </MTAuthorHasEntry>
    </MTAuthors>
  expected: has

-
  name: test item 482
  template: |
    <MTAuthors lastn="1">
      <MTAuthorHasPage>
        <MTAuthorName setvar="author_name">
        <MTPages author="$author_name" lastn="1">has</MTPages>
      </MTAuthorHasPage>
    </MTAuthors>
  expected: has

-
  name: test item 483
  template: |
    <MTAuthors lastn="1">
      <MTAuthorNext><MTAuthorName></MTAuthorNext>
    </MTAuthors>
  expected: ''

-
  name: test item 484
  template: |
    <MTAuthors lastn="1">
      <MTAuthorPrevious><MTAuthorName></MTAuthorPrevious>
    </MTAuthors>
  expected: Bob D

-
  name: test item 491
  template: <MTAuthors lastn="1"><MTAuthorUserpic></MTAuthors>
  expected: <img src="/mt-static/support/assets_c/userpics/userpic-2-100x100.png?3" width="100" height="100" alt="" />

-
  name: test item 492
  template: |
    <MTAuthors lastn="1">
      <MTAuthorUserpicAsset><MTAssetFileName></MTAuthorUserpicAsset>
    </MTAuthors>
  expected: test.jpg

-
  name: test item 493
  template: <MTAuthors lastn="1"><MTAuthorUserpicURL></MTAuthors>
  expected: /mt-static/support/assets_c/userpics/userpic-2-100x100.png

-
  name: test item 494
  template: <MTAuthors lastn="1"><MTAuthorBasename></MTAuthors>
  expected: chucky_dee

-
  name: test item 540
  template: |
    <MTIfAuthor>HasAuthor:Outside</MTIfAuthor>
    <MTAuthors lastn='1'>
      <MTIfAuthor>HasAuthor:Inside</MTIfAuthor>
    </MTAuthors>
  expected: "HasAuthor:Inside"

-
  name: test item 609
  template: |
    <mt:Authors need_entry='0' namespace='unit test' sort_by='score' offset='1'>
      <mt:AuthorName>,
    </mt:Authors>
  expected: |
    Chuck D,
    Melody,

-
  name: test item 610
  template: |
    <mt:Authors need_entry='0' namespace='unit test' sort_by='score' offset='2'>
      <mt:AuthorName>,
    </mt:Authors>
  expected: |
    Melody,

