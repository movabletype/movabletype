#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 430
  template: "<mt:Websites><mt:WebsiteName></mt:Websites>"
  expected: Test site

-
  name: test item 431
  template: "<mt:Websites><mt:WebsiteDescription></mt:Websites>"
  expected: Narnia None Test Website

-
  name: test item 432
  template: "<mt:Websites><mt:WebsiteURL></mt:Websites>"
  expected: "http://narnia.na/"

-
  name: test item 433
  template: "<mt:Websites><mt:WebsitePath></mt:Websites>"
  expected: t/

-
  name: test item 434
  template: "<mt:Websites><mt:WebsiteID></mt:Websites>"
  expected: 2

-
  name: test item 435
  template: "<mt:Websites><mt:WebsiteTimezone></mt:Websites>"
  expected: "-03:30"

-
  name: test item 436
  template: "<mt:Websites><mt:WebsiteTimezone no_colon='1'></mt:Websites>"
  expected: -0330

-
  name: test item 437
  template: "<mt:Websites><mt:WebsiteLanguage></mt:Websites>"
  expected: en_us

-
  name: test item 438
  template: "<mt:Websites><mt:WebsiteLanguage locale='1'></mt:Websites>"
  expected: en_US

-
  name: test item 439
  template: "<mt:Websites><mt:IfWebsite>1</mt:IfWebsite></mt:Websites>"
  expected: 1

-
  name: test item 440
  template: "<mt:Websites><MTWebsiteCCLicenseURL></mt:Websites>"
  expected: "http://creativecommons.org/licenses/by-nc-sa/2.0/"

-
  name: test item 441
  template: "<mt:Websites><MTWebsiteCCLicenseImage></mt:Websites>"
  expected: "http://creativecommons.org/images/public/somerights20.gif"

-
  name: test item 442
  template: "<mt:Websites><MTWebsiteIfCCLicense>1</MTWebsiteIfCCLicense></mt:Websites>"
  expected: 1

-
  name: test item 443
  template: "<mt:Websites><mt:WebsiteFileExtension></mt:Websites>"
  expected: .html

-
  name: test item 448
  template: "<mt:Websites><mt:WebsiteHasBlog>true</mt:WebsiteHasBlog></mt:Websites>"
  expected: true

-
  name: test item 449
  template: "<mt:BlogParentWebsite><mt:WebsiteID></mt:BlogParentWebsite>"
  expected: 2

-
  name: test item 503
  template: <MTWebsiteCommentCount>
  expected: 9

-
  name: test item 504
  template: <MTWebsiteHost>
  expected: narnia.na

-
  name: test item 505
  template: <MTWebsiteIfCommentsOpen>Opened</MTWebsiteIfCommentsOpen>
  expected: Opened

-
  name: test item 506
  template: <MTWebsitePageCount>
  expected: 4

-
  name: test item 507
  template: <MTWebsitePingCount>
  expected: 2

-
  name: test item 508
  template: <MTWebsiteRelativeURL>
  expected: /nana/

-
  name: test item 509
  template: <MTWebsiteThemeID>
  expected: classic-blog

