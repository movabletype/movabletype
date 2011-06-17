#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt    = MT->instance;
my $entry = MT->model('entry')->load(1);

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{entry_authored_on} = $entry->authored_on;
};
local $MT::Test::Tags::PRERUN_PHP
    = q{$tmpl_vars['CURRENT_WORKING_DIRECTORY'] = $mt->config('mtdir');}
    . '$stock["entry_authored_on"] = ' . $entry->authored_on . ';';

local $MT::Test::Tags::SETUP = sub {
    my ( $test_item, $ctx, $stock, $tmpl_vars ) = @_;
    if ( exists( $test_item->{stash} )
        && $test_item->{stash}{current_timestamp} )
    {
        my $key = $test_item->{stash}{current_timestamp};
        $key =~ s/^\$//;
        $ctx->{current_timestamp} = $stock->{$key};
    }
};


run_tests_by_data();
__DATA__
-
  name: CGIPath prints the absolute URL of the base of the CGI script.
  template: <MTCGIPath>
  expected: "http://narnia.na/cgi-bin/"

-
  name: CGIRelativeURL prints the relative URL of the base of the CGI script.
  template: <MTCGIRelativeURL>
  expected: /cgi-bin/

-
  name: StaticWebPath prints the absolute URL of the base of the static files.
  template: <MTStaticWebPath>
  expected: "http://narnia.na/mt-static/"

-
  name: AdminScript prints the name of the admin CGI.
  template: <MTAdminScript>
  expected: mt.cgi

-
  name: CommentScript prints the name of the comment CGI.
  template: <MTCommentScript>
  expected: mt-comments.cgi

-
  name: TrackbackScript prints the name of the trackback CGI.
  template: <MTTrackbackScript>
  expected: mt-tb.cgi

-
  name: SearchScript prints the name of the search CGI.
  template: <MTSearchScript>
  expected: mt-search.cgi

-
  name: XMLRPCScript prints the name of the XMLRPC CGI.
  template: <MTXMLRPCScript>
  expected: mt-xmlrpc.cgi

-
  name: AtomScript prints the name of the Atom CGI.
  template: <MTAtomScript>
  expected: mt-atom.cgi

-
  name: NotifyScript prints the name of the notify CGI.
  template: <MTNotifyScript>
  expected: mt-add-notify.cgi

-
  name: PublishCharset prints the publish charset of this system.
  template: <MTPublishCharset lower_case='1'>
  expected: utf-8

-
  name: Include with an attribute "module" includes the content of specified module.
  template: <MTInclude module="blog-name">
  expected: none

-
  name: IncludeBlock with an attribute "module" includes the content of specified module as block.
  template: <MTIncludeBlock module='header-line'>Title</MTIncludeBlock>
  expected: <h1>Title</h1>

-
  name: Link with an attribute "template" prints the absolute URL of the specified template.
  template: <MTLink template="Main Index">
  expected: "http://narnia.na/nana/"

-
  name: Version prints version id of this system.
  template: <MTVersion>
  expected: VERSION_ID

-
  name: DefaultLanguage prints default language of this system.
  template: <MTDefaultLanguage>
  expected: en_US

-
  name: ErrorMessage prints error message. (Used in system templates.)
  template: <MTErrorMessage>
  expected: ''

-
  name: CGIServerPath prints the server path of this system.
  template: <MTCGIServerPath>
  expected: CURRENT_WORKING_DIRECTORY

-
  name: FileTemplate prints the output file path that is formatted by specified format.
  template: <MTFileTemplate format="%y/%m/%d/%b">
  expected: 1978/01/31/a_rainy_day
  stash:
    current_timestamp: $entry_authored_on
    entry: $entry

-
  name: AdminCGIPath prints the absolute URL of the base of the CGI script for administrator.
  template: <MTAdminCGIPath>
  expected: "http://narnia.na/cgi-bin/"

-
  name: ConfigFile prints the server path for "mt-config.cgi".
  template: <MTConfigFile> aaa
  expected: CFG_FILE

-
  name: CGIHost prints the hostname of this system.
  template: <MTCGIHost>
  expected: narnia.na

-
  name: ProductName prints the product name of this system.
  template: <MTProductName>
  expected: Movable Type

-
  name: Section prints the inner content.
  template: <MTSection>Content</MTSection>
  expected: Content

-
  name: StaticFilePath prints the server path of the directory for static files.
  template: <MTStaticFilePath>
  expected: STATIC_FILE_PATH

-
  name: SupportDirectoryURL prints the URL of the directory for support files.
  template: <MTSupportDirectoryURL>
  expected: /mt-static/support/

-
  name: HTTPContentType dose not print anything.
  template: <MTHTTPContentType type='application/xml'>
  expected: ''

-
  name: Date with an attribute "ts" prints the formatted date that is specified.
  template: <MTDate ts='20101010101010'>
  expected: "October 10, 2010 10:10 AM"



######## IncludeBlock
## var (optional)

######## Include
## module
## widget
## file
## identifier
## name
## blog_id (optional)
## local (optional)
## global (optional; default "0")
## parent (optional; default "0")
## ssi (optional; default "0")
## cache (optional; default "0")
## key or cache_key (optional)
## ttl (optional)

######## IfStatic

######## IfDynamic

######## Section
## cache_prefix (optional)
## period (optional)
## by_blog (optional)
## by_user (optional)
## html_tag (optional)
## id (optional)

######## Link
## template
## entry_id
## blog_id
## with_index (optional; default "0")

######## Date
## ts (optional)
## relative (optional)
## relative="1"
## relative="2"
## relative="3"
## relative="js"
## format (optional)
## %Y
## %m
## %d
## %H
## %M
## %S
## %w
## %j
## %y
## %b
## %B
## %a
## %A
## %e
## %I
## %k
## %l
## format_name (optional)
## rfc822
## iso8601
## utc (optional)
## offset_blog_id (optional)
## language (optional)

######## AdminScript

######## CommentScript

######## TrackbackScript

######## SearchScript

######## XMLRPCScript

######## AtomScript

######## NotifyScript

######## CGIHost
## exclude_port (optional; default "0")

######## CGIPath

######## AdminCGIPath

######## CGIRelativeURL

######## CGIServerPath

######## StaticFilePath

######## StaticWebPath

######## SupportDirectoryURL

######## Version

######## ProductName
## version (optional; default "0")

######## PublishCharset

######## DefaultLanguage

######## ConfigFile

######## IndexBasename
## extension (optional; default "0")

######## HTTPContentType
## type

######## FileTemplate
## format
## %a
## %-a
## %b
## %-b
## %c
## %-c
## %C
## %-C
## %d
## %D
## %e
## %E
## %f
## %F
## %h
## %H
## %i
## %I
## %j
## %m
## %M
## %n
## %s
## %x
## %y
## %Y

######## TemplateCreatedOn

######## BuildTemplateID

######## ErrorMessage

