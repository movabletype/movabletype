#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt      = MT->instance;
my $website = MT->model('website')->load(2);
my $blog    = MT->model('blog')->load(1);

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{blog}     = $website;
    $stock->{child}    = $blog;
    $stock->{child_id} = $blog->id;
};
local $MT::Test::Tags::PRERUN_PHP
    = '$stock["blog"] = $db->fetch_website(' . $website->id . ');'
    . '$stock["child"] = $db->fetch_blog(' . $blog->id . ');'
    . '$stock["child_id"] = ' . $blog->id . ';';


run_tests_by_data();
__DATA__
-
  name: WebsiteName prints the name of the website.
  template: "<mt:WebsiteName>"
  expected: Test site

-
  name: WebsiteDescription prints the description of the website.
  template: "<mt:WebsiteDescription>"
  expected: Narnia None Test Website

-
  name: WebsiteURL prints the URL of the website.
  template: "<mt:WebsiteURL>"
  expected: "http://narnia.na/"

-
  name: WebsitePath prints the root path URL of the website.
  template: "<mt:WebsitePath>"
  expected: t/

-
  name: WebsiteID prints the ID of the website.
  template: "<mt:WebsiteID>"
  expected: 2

-
  name: WebsiteTimezone prints the time zone of the website.
  template: "<mt:WebsiteTimezone>"
  expected: "-03:30"

-
  name: 'WebsiteTimezone with an attribute "no_colon" prints the time zone of the website without colons.'
  template: "<mt:WebsiteTimezone no_colon='1'>"
  expected: -0330

-
  name: WebsiteLanguage prints the language of the website.
  template: "<mt:WebsiteLanguage>"
  expected: en_us

-
  name: 'WebsiteLanguage with an attribute "locale" prints the language of the website with locale.'
  template: "<mt:WebsiteLanguage locale='1'>"
  expected: en_US

-
  name: IfWebsite prints the inner content if website context.
  template: "<mt:IfWebsite>1</mt:IfWebsite>"
  expected: 1

-
  name: 'WebsiteCCLicenseImage prints the corresponding CC license URL if "nc-sa" is selected.'
  template: "<MTWebsiteCCLicenseURL>"
  expected: "http://creativecommons.org/licenses/by-nc-sa/2.0/"

-
  name: 'WebsiteCCLicenseImage prints the corresponding CC license image URL if "nc-sa" is selected.'
  template: "<MTWebsiteCCLicenseImage>"
  expected: "http://creativecommons.org/images/public/somerights20.gif"

-
  name: WebsiteIfCCLicense prints the inner content if website licensed under the CC license.
  template: "<MTWebsiteIfCCLicense>1</MTWebsiteIfCCLicense>"
  expected: 1

-
  name: WebsiteFileExtension prints the file extension of the website.
  template: "<mt:WebsiteFileExtension>"
  expected: .html

-
  name: WebsiteHasBlog prints the inner content if the website has some blog.
  template: "<mt:WebsiteHasBlog>true</mt:WebsiteHasBlog>"
  expected: true

-
  name: BlogParentWebsite make a context of the website that is a parent of the current blog.
  template: |
    blog_id: <mt:BlogID />
    website_id: <mt:BlogParentWebsite><mt:WebsiteID></mt:BlogParentWebsite>
  expected: |
    blog_id: 1
    website_id: 2
  stash:
    blog: $child
    blog_id: $child_id

-
  name: "BlogParentWebsite don't change a context if current context is already for website."
  template: |
    blog_id: <mt:BlogID />
    website_id: <mt:BlogParentWebsite><mt:WebsiteID></mt:BlogParentWebsite>
  expected: |
    blog_id: 2
    website_id: 2

-
  name: WebsiteCommentCount prints the number of comments for the website.
  template: <MTWebsiteCommentCount>
  expected: 0

-
  name: WebsiteHost prints the host name of the website.
  template: <MTWebsiteHost>
  expected: narnia.na

-
  name: WebsiteIfCommentsOpen prints the inner content if the website is configured to accept comments.
  template: <MTWebsiteIfCommentsOpen>Opened</MTWebsiteIfCommentsOpen>
  expected: Opened

-
  name: WebsitePageCount prints the number of pages for the website.
  template: <MTWebsitePageCount>
  expected: 0

-
  name: WebsitePingCount prints the number of trackback ping for the website.
  template: <MTWebsitePingCount>
  expected: 0

-
  name: WebsiteRelativeURL prints the relative URL of the website.
  template: <MTWebsiteRelativeURL>
  expected: /

-
  name: WebsiteThemeID prints the theme ID of the website.
  template: <MTWebsiteThemeID>
  expected: classic-website


######## Websites
## site_ids

######## IfWebsite

######## WebsiteID

######## WebsiteName

######## WebsiteDescription

######## WebsiteLanguage
## locale (optional; default "0")
## ietf (optional; default "0")

######## WebsiteURL

######## WebsitePath

######## WebsiteTimezone
## no_colon (optional; default "0")

######## WebsiteIfCCLicense

######## WebsiteCCLicenseURL

######## WebsiteCCLicenseImage

######## WebsiteFileExtension

######## WebsiteHasBlog

######## WebsiteHost
## exclude_port (optional; default "0")
## signature (optional; default "0")

######## WebsiteRelativeURL

######## WebsiteThemeID

######## BlogParentWebsite

