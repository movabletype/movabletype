#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 43
  template: <MTSignOnURL>
  expected: "https://www.typekey.com/t/typekey/login?"

-
  name: test item 74
  run: 0
  template: <MTTypeKeyToken>
  expected: token

-
  name: test item 75
  template: <MTEntries lastn="1"><MTRemoteSignInLink></MTEntries>
  expected: "https://www.typekey.com/t/typekey/login?&amp;lang=en_US&amp;t=token&amp;v=1.1&amp;_return=http://narnia.na/cgi-bin/mt-comments.cgi%3f__mode=handle_sign_in%26key=TypeKey%26static=0%26entry_id=1"

-
  name: test item 76
  template: <MTEntries lastn="1"><MTRemoteSignOutLink></MTEntries>
  expected: "http://narnia.na/cgi-bin/mt-comments.cgi?__mode=handle_sign_in&amp;static=0&amp;logout=1&amp;entry_id=1"

-
  name: test item 78
  template: <MTComments lastn="1"><MTCommentAuthor></MTComments>
  expected: John Doe

-
  name: test item 109
  template: <MTComments lastn="1"><MTCommentBody></MTComments>
  expected: <p>Comment for entry 5, visible</p>

-
  name: test item 110
  template: <MTComments lastn="1"><MTCommentDate></MTComments>
  expected: "September 12, 2004  6:28 PM"

-
  name: test item 111
  template: <MTComments lastn="1"><MTCommentID></MTComments>
  expected: 2

-
  name: test item 112
  template: <MTComments lastn="1"><MTCommentEntryID></MTComments>
  expected: 5

-
  name: test item 113
  template: <MTComments lastn="1"><MTCommentIP></MTComments>
  expected: 127.0.0.1

-
  name: test item 114
  template: <MTComments lastn="3"><MTCommentAuthorLink>,</MTComments>
  expected: "<a title=\"http://chuckd.com/\" href=\"http://chuckd.com/\">Chucky Dee</a>,Comment 3,John Doe,"

-
  name: test item 115
  template: <MTComments lastn="1"><MTCommentEmail></MTComments>
  expected: johnd@doe.com

-
  name: test item 116
  template: <MTComments lastn="1"><MTCommentAuthorIdentity></MTComments>
  expected: "<img alt=\"\" src=\"http://narnia.na/mt-static/images/comment/typepad_logo.png\" width=\"16\" height=\"16\" />"

-
  name: test item 117
  template: <MTComments lastn="1"><MTCommentURL></MTComments>
  expected: "http://john.doe.com/"

-
  name: test item 118
  template: <MTComments lastn="1"><MTCommentOrderNumber></MTComments>
  expected: 1

-
  name: test item 119
  template: <MTComments lastn="1"><MTCommentEntry><MTEntryTitle></MTCommentEntry></MTComments>
  expected: Verse 2

-
  name: test item 151
  template: <MTEntries lastn="1"><MTEntryCommentCount></MTEntries>
  expected: 3

-
  name: test item 152
  template: <MTComments lastn="1"><MTCommentBody sanitize=" "></MTComments>
  expected: Comment for entry 5, visible

-
  name: test item 153
  template: <MTComments lastn="1"><MTCommentID></MTComments>
  expected: 2

-
  name: test item 155
  template: <MTEntries lastn="1"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 156
  template: <MTEntries lastn="1"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: accepted

-
  name: test item 157
  template: <MTEntries lastn="1" offset="1"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 158
  template: <MTEntries lastn="1" offset="1"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: accepted

-
  name: test item 159
  template: <MTEntries lastn="1" offset="2"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 160
  template: <MTEntries lastn="1" offset="2"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: accepted

-
  name: test item 161
  template: <MTEntries lastn="1" offset="3"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 162
  template: <MTEntries lastn="1" offset="3"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: accepted

-
  name: test item 163
  template: <MTEntries lastn="1" offset="4"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: active

-
  name: test item 164
  template: <MTEntries lastn="1" offset="4"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: ''

-
  name: test item 165
  template: <MTEntries lastn="1" offset="5"><MTIfCommentsActive>active</MTIfCommentsActive></MTEntries>
  expected: ''

-
  name: test item 166
  template: <MTEntries lastn="1" offset="5"><MTIfCommentsAccepted>accepted</MTIfCommentsAccepted></MTEntries>
  expected: ''

-
  name: test item 167
  template: <MTEntries lastn="10"><MTEntryID> <MTEntryCommentCount>; </MTEntries>
  expected: "1 3; 8 1; 7 0; 6 3; 5 1; 4 0; "

-
  name: test item 168
  template: <MTIfRegistrationNotRequired>yes<MTElse>no</MTElse></MTIfRegistrationNotRequired>
  expected: no

-
  name: test item 169
  template: <MTIfRegistrationRequired>yes<MTElse>no</MTElse></MTIfRegistrationRequired>
  expected: yes

-
  name: test item 170
  template: <MTBlogIfCommentsOpen>yes<MTElse>no</MTElse></MTBlogIfCommentsOpen>
  expected: yes

-
  name: test item 184
  template: <MTIfTypeKeyToken>tokened</MTIfTypeKeyToken>
  expected: tokened

-
  name: test item 185
  template: <MTIfCommentsModerated>moderated</MTIfCommentsModerated>
  expected: moderated

-
  name: test item 186
  template: <MTIfRegistrationAllowed>allowed</MTIfRegistrationAllowed>
  expected: allowed

-
  name: test item 204
  template: <MTIfNeedEmail>email needed</MTIfNeedEmail>
  expected: ''

-
  name: test item 205
  template: <MTIfAllowCommentHTML>comment html allowed</MTIfAllowCommentHTML>
  expected: comment html allowed

-
  name: test item 206
  template: <MTIfCommentsAllowed>comments allowed</MTIfCommentsAllowed>
  expected: comments allowed

-
  name: test item 210
  run: 0
  template: <MTIfDynamicComments>dynamic comments<MTElse>static comments</MTElse></MTIfDynamicComments>
  expected: static comments

-
  name: test item 211
  template: <MTEntries lastn='1'><MTEntryIfAllowComments>entry allows comments</MTEntryIfAllowComments></MTEntries>
  expected: entry allows comments

-
  name: test item 212
  template: <MTEntries lastn='1'><MTEntryIfCommentsOpen>entry comments open</MTEntryIfCommentsOpen></MTEntries>
  expected: entry comments open

-
  name: test item 309
  template: <MTComments><MTIfCommentParent><p><MTCommentParent><MTCommentAuthor></MTCommentParent></p></MTIfCommentParent></MTComments>
  expected: <p>Comment 11</p><p>v14GrUH 4 cheep</p>

-
  name: test item 310
  template: <MTComments sort_by='id' sort_order='ascend'><MTIfCommentReplies>,<MTCommentReplies><MTCommentsHeader><ul></MTCommentsHeader><li><MTCommentID></li><MTCommentsFooter></ul></MTCommentsFooter></MTCommentReplies></MTIfCommentReplies></MTComments>
  expected: ,<ul><li>11</li></ul>,<ul><li>12</li></ul>

-
  name: test item 311
  template: <MTComments sort_by='id' sort_order='ascend'><MTIfCommentReplies>,<MTCommentReplies><MTCommentsHeader><ul></MTCommentsHeader><li><MTCommentID><MTCommentRepliesRecurse></li><MTCommentsFooter></ul></MTCommentsFooter></MTCommentReplies></MTIfCommentReplies></MTComments>
  expected: ,<ul><li>11<ul><li>12</li></ul></li></ul>,<ul><li>12</li></ul>

-
  name: test item 344
  template: <MTComments><MTCommentEntry><MTEntryClass>;</MTCommentEntry></MTComments>
  expected: page;entry;entry;entry;entry;entry;entry;entry;entry;

-
  name: test item 452
  template: <MTComments lastn="1"><MTCommentIfModerated>Moderated<MTElse>NotModerated</MTCommentIfModerated></MTComments>
  expected: Moderated

-
  name: test item 453
  template: <MTComments lastn="1"><MTCommentLink></MTComments>
  expected: "http://narnia.na/nana/archives/1962/01/verse-2.html#comment-2"

-
  name: test item 454
  template: <MTComments lastn="1"><MTCommentName></MTComments>
  expected: John Doe

-
  name: test item 455
  template: <MTComments lastn="1"><MTCommentParentID></MTComments>
  expected: ''

-
  name: test item 456
  template: <MTComments lastn="1"><MTCommentRank></MTComments>
  expected: ''

-
  name: test item 457
  template: <MTComments lastn="1"><MTCommentReplyToLink></MTComments>
  expected: "<a title=\"Reply\" href=\"javascript:void(0);\" onclick=\"mtReplyCommentOnClick(2, 'John Doe')\">Reply</a>"

-
  name: test item 469
  template: <MTComments lastn="1"><MTCommentBlogID></MTComments>
  expected: 1

-
  name: test item 470
  template: <MTComments lastn="1"><MTCommenterID></MTComments>
  expected: 4

-
  name: test item 471
  template: <MTComments lastn="1"><MTCommenterURL></MTComments>
  expected: ''

-
  name: test item 472
  template: <MTComments lastn="1"><MTCommenterUsername></MTComments>
  expected: John Doe

-
  name: test item 473
  template: <MTComments lastn="1"><MTCommenterUserpic></MTComments>
  expected: ''

-
  name: test item 474
  template: <MTComments lastn="1"><MTCommenterUserpicAsset></MTCommenterUserpicAsset></MTComments>
  expected: ''

-
  name: test item 475
  template: <MTComments lastn="1"><MTCommenterUserpicURL></MTComments>
  expected: ''

-
  name: test item 549
  template: <MTIfRequireCommentEmails>Requied</MTIfRequireCommentEmails>
  expected: ''

