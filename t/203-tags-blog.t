#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt           = MT->instance;
my $entry        = MT->model('entry')->load(1);
my $website      = MT->model('website')->load(2);
my $another_blog = $mt->model('blog')->new();
$another_blog->set_values(
    {   name         => 'Blog: Another',
        site_url     => '/::/another',
        archive_url  => '/::/another/archives/',
        site_path    => 'site/',
        archive_path => 'site/archives/',
        archive_type => 'Individual,Monthly,Weekly,Daily,Category,Page',
        archive_type_preferred   => 'Individual',
        description              => 'Blog: Another',
        custom_dynamic_templates => 'custom',
        convert_paras            => 1,
        allow_reg_comments       => 1,
        allow_unreg_comments     => 0,
        allow_pings              => 1,
        sort_order_posts         => 'descend',
        sort_order_comments      => 'ascend',
        remote_auth_token        => 'token',
        convert_paras_comments   => 1,
        google_api_key           => 'r9Vj5K8PsjEu+OMsNZ/EEKjWmbCeQAv1',
        cc_license =>
            'by-nc-sa http://creativecommons.org/licenses/by-nc-sa/2.0/ http://creativecommons.org/images/public/somerights20.gif',
        server_offset        => '-3.5',
        children_modified_on => '20000101000000',
        language             => 'en_us',
        file_extension       => 'html',
        theme_id             => 'classic_blog',
    }
);
$another_blog->id(3);
$another_blog->class('blog');
$another_blog->parent_id($website->id);
$another_blog->commenter_authenticators('enabled_TypeKey');
$another_blog->save()
    or die "Couldn't save blog: Another" . $another_blog->errstr;

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{website}      = $website;
    $stock->{another_blog} = $another_blog;
    $stock->{entry_authored_on}  = $entry->authored_on;
};
local $MT::Test::Tags::PRERUN_PHP
    = '$stock["website"]      = $db->fetch_website(' . $website->id . ');'
    . '$stock["another_blog"] = $db->fetch_blog(' . $another_blog->id . ');'
    . '$stock["entry_authored_on"] = "' . $entry->authored_on . '";';


run_tests_by_data();
__DATA__
-
  name: BlogID prints the ID of the blog.
  template: <MTBlogID>
  expected: 1

-
  name: BlogName prints the name of the blog.
  template: <MTBlogName>
  expected: none

-
  name: BlogDescription prints the description of the blog.
  template: <MTBlogDescription>
  expected: Narnia None Test Blog

-
  name: BlogURL prints the URL of the blog.
  template: <MTBlogURL>
  expected: "http://narnia.na/nana/"

-
  name: BlogArchiveURL prints the archive URL of the blog.
  template: <MTBlogArchiveURL>
  expected: "http://narnia.na/nana/archives/"

-
  name: BlogRelativeURL prints the relative URL from server root of the blog.
  template: <MTBlogRelativeURL>
  expected: /nana/

-
  name: BlogSitePath prints the site directory path of the blog.
  template: <MTBlogSitePath>
  expected: t/site/

-
  name: BlogHost prints the host name of the blog.
  template: <MTBlogHost>
  expected: narnia.na

-
  name: BlogHost prints the host name of the blog without port.
  template: <MTBlogHost exclude_port="1">
  expected: narnia.na

-
  name: BlogTimezone prints the timezone of the blog.
  template: <MTBlogTimezone>
  expected: "-03:30"

-
  name: BlogTimezone with an attribute "no_colon" prints the timezone of the blog without colon.
  template: <MTBlogTimezone no_colon="1">
  expected: -0330

-
  name: BlogEntryCount prints the number of entries in the blog.
  template: <MTBlogEntryCount>
  expected: 6

-
  name: BlogCommentCount prints the number of comments in the blog.
  template: <MTBlogCommentCount>
  expected: 9

-
  name: CCLicenseRDF prints CC license of blog if current context doesn't have entry.
  template: <MTCCLicenseRDF>
  expected: |
    <!--
    <rdf:RDF xmlns="http://web.resource.org/cc/"
             xmlns:dc="http://purl.org/dc/elements/1.1/"
             xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <Work rdf:about="http://narnia.na/nana/">
    <dc:title>none</dc:title>
    <dc:description>Narnia None Test Blog</dc:description>
    <license rdf:resource="http://creativecommons.org/licenses/by-nc-sa/2.0/" />
    </Work>
    <License rdf:about="http://creativecommons.org/licenses/by-nc-sa/2.0/">
    </License>
    </rdf:RDF>
    -->

-
  name: test item 49
  template: <MTCCLicenseRDF>
  expected: |
    <!--
    <rdf:RDF xmlns="http://web.resource.org/cc/"
             xmlns:dc="http://purl.org/dc/elements/1.1/"
             xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
    <Work rdf:about="http://narnia.na/nana/archives/1978/01/a-rainy-day.html">
    <dc:title>A Rainy Day</dc:title>
    <dc:description>A story of a stroll.</dc:description>
    <dc:creator>Chucky Dee</dc:creator>
    <dc:date>1978-01-31T07:45:00-03:30</dc:date>
    <license rdf:resource="http://creativecommons.org/licenses/by-nc-sa/2.0/" />
    </Work>
    <License rdf:about="http://creativecommons.org/licenses/by-nc-sa/2.0/">
    </License>
    </rdf:RDF>
    -->
  stash:
    entry: $entry
    current_timestamp: $entry_authored_on

-
  name: BlogLanguage prints the language of the blog.
  template: <MTBlogLanguage>
  expected: en_us

-
  name: BlogLanguage with an attribute "locale" prints the language of the website with locale.
  template: <MTBlogLanguage locale="1">
  expected: en_US

-
  name: BlogCCLicenseURL prints the corresponding CC license URL if "nc-sa" is selected.
  template: <MTBlogCCLicenseURL>
  expected: "http://creativecommons.org/licenses/by-nc-sa/2.0/"

-
  name: BlogCCLicenseImage prints the corresponding CC license URL if "nc-sa" is selected.
  template: <MTBlogCCLicenseImage>
  expected: "http://creativecommons.org/images/public/somerights20.gif"

-
  name: BlogIfCCLicense prints the inner content if website licensed under the CC license.
  template: <MTBlogIfCCLicense>1</MTBlogIfCCLicense>
  expected: 1

-
  name: BlogFileExtension prints the file extension of the blog.
  template: <MTBlogFileExtension>
  expected: .html

-
  name: BlogURL with an attribute "id" prints the URL of the specified blog.
  template: <MTBlogURL id='1'>
  expected: "http://narnia.na/nana/"
  stash:
    blog: $another_blog

-
  name: BlogRelativeURL with an attribute "id" prints the relative URL from server root of the specified blog.
  template: <MTBlogRelativeURL id="1">
  expected: /nana/
  stash:
    blog: $another_blog

-
  name: BlogSitePath with an attribute "id" prints the site directory path of the specified blog.
  template: <MTBlogSitePath is='1'>
  expected: t/site/
  stash:
    blog: $another_blog

-
  name: BlogArchiveURL with an attribute "id" prints the archive URL of the specified blog.
  template: <MTBlogArchiveURL id='1'>
  expected: "http://narnia.na/nana/archives/"
  stash:
    blog: $another_blog

-
  name: BlogCategoryCount prints the number of the categories of the blog.
  template: <MTBlogCategoryCount>
  expected: 3

-
  name: BlogPingCount prints the number of the pings of the blog.
  template: <MTBlogPingCount>
  expected: 2

-
  name: BlogTemplateSetID prints the template-set id of the blog.
  template: <MTBlogTemplatesetID>
  expected: classic-blog

-
  name: BlogThemeID prints the theme id of the blog.
  template: <MTBlogThemeID>
  expected: classic-blog

-
  name: IfBlog prints the inner content if the current context is blog.
  template: <MTIfBlog>HasBlog</MTIfBlog>
  expected: HasBlog

-
  name: IfBlog doesn't prints the inner content if the current context is website.
  template: <MTIfBlog>HasBlog</MTIfBlog>
  expected: ''
  stash:
    blog: $website


######## Blogs
## blog_ids

######## BlogIfCCLicense

######## IfBlog

######## BlogID

######## BlogName

######## BlogDescription

######## BlogLanguage
## locale (optional; default "0")
## ietf (optional; default "0")

######## BlogURL

######## BlogArchiveURL

######## BlogRelativeURL

######## BlogSitePath

######## BlogHost
## exclude_port (optional; default "0")
## signature (optional; default "0")

######## BlogTimezone
## no_colon (optional; default "0")

######## BlogCCLicenseURL

######## BlogCCLicenseImage

######## CCLicenseRDF
## with_index (optional; default "0")

######## BlogFileExtension

######## BlogTemplateSetID

######## BlogThemeID

