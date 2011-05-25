#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 18
  template: <MTCommenterNameThunk>
  expected: <script type='text/javascript'>var commenter_name = getCookie('commenter_name')</script>

-
  name: test item 19
  run: 0
  template: <MTCommenterName>
  expected: ''

-
  name: test item 20
  run: 0
  template: <MTCommenterEmail>
  expected: ''

-
  name: test item 224
  template: "<MTComments lastn='3' glue=','><MTIfNonEmpty tag='CommenterName'><MTCommenterName>: <MTCommenterIfTrusted>trusted<MTElse>untrusted</MTElse></MTCommenterIfTrusted><MTElse><MTCommentAuthor></MTIfNonEmpty></MTComments>"
  expected: "Chucky Dee: trusted,Comment 3: untrusted,John Doe: trusted"

-
  name: test item 356
  template: "<MTEntries><$MTEntryID$>:<MTComments><MTIfCommenterIsAuthor><MTIfCommenterIsEntryAuthor>2<MTElse>1</MTIfCommenterIsEntryAuthor><MTElse>0</MTIfCommenterIsAuthor>;</MTComments></MTEntries>"
  expected: "1:0;0;0;8:0;7:6:2;1;0;5:0;4:"

-
  name: test item 362
  template: "<MTComments><$MTCommenterAuthType$>:<$MTCommenterAuthIconURL$>;</MTComments>"
  expected: ":;:;:;:;:;MT:http://narnia.na/mt-static/images/comment/mt_logo.png;MT:http://narnia.na/mt-static/images/comment/mt_logo.png;:;TypeKey:http://narnia.na/mt-static/images/comment/typepad_logo.png;"

-
  name: test item 499
  template: <MTUserSessionCookieDomain>
  expected: .narnia.na

-
  name: test item 500
  template: <MTUserSessionCookieName>
  expected: mt_blog_user

-
  name: test item 501
  template: <MTUserSessionCookiePath>
  expected: /

-
  name: test item 502
  template: <MTUserSessionCookieTimeout>
  expected: 14400

-
  name: test item 542
  template: <MTIfCommenterRegistrationAllowed>Allowed</MTIfCommenterRegistrationAllowed>
  expected: Allowed

-
  name: test item 543
  template: "<MTComments lastn='3' glue=','><MTIfNonEmpty tag='CommenterName'><MTCommenterName>: <MTIfCommenterTrusted>trusted<MTElse>untrusted</MTElse></MTIfCommenterTrusted><MTElse><MTCommentAuthor></MTIfNonEmpty></MTComments>"
  expected: "Chucky Dee: trusted,Comment 3: untrusted,John Doe: trusted"

-
  name: test item 544
  template: <MTIfExternalUserManagement>External</MTIfExternalUserManagement>
  expected: ''

