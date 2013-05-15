# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Template::Tags::Website;

use strict;

use MT;
use MT::Util qw( encode_xml );

###########################################################################

=head2 Websites

A container tag which iterates over a list of all of the websites in the
system. You can use any of the website tags (L<WebsiteName>, L<WebsiteURL>, etc -
anything starting with MTWebsite) inside of this tag set.

B<Attributes:>

=over 4

=item * site_ids

This attribute allows you to limit the set of websites iterated over by
L<Websites>. Multiple websites are specified in a comma-delimited fashion.
For example:

    <mt:Websites site_ids="1,12,19">

would iterate over only the websites with IDs 1, 12 and 19.

=back

=for tags multiblog, loop, websites

=cut

sub _hdlr_websites {
    my ( $ctx, $args, $cond ) = @_;
    my ( %terms, %args );

    $ctx->set_blog_load_context( $args, \%terms, \%args, 'id' )
        or return $ctx->error( $ctx->errstr );

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    local $ctx->{__stash}{entries} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp_end} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{archive_category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{inside_blogs} = 1;

    require MT::Website;
    $terms{class} = 'website' unless $terms{class};
    $args{'sort'} = 'name';
    $args{direction} = 'ascend';
    my @sites = MT::Website->load( \%terms, \%args );
    my $res   = '';
    my $count = 0;
    my $vars  = $ctx->{__stash}{vars} ||= {};
    MT::Meta::Proxy->bulk_load_meta_objects( \@sites );

    for my $site (@sites) {
        $count++;
        local $ctx->{__stash}{blog}    = $site;
        local $ctx->{__stash}{blog_id} = $site->id;
        local $vars->{__first__}       = $count == 1;
        local $vars->{__last__}        = $count == scalar(@sites);
        local $vars->{__odd__}         = ( $count % 2 ) == 1;
        local $vars->{__even__}        = ( $count % 2 ) == 0;
        local $vars->{__counter__}     = $count;
        defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
            or return $ctx->error( $builder->errstr );
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 IfWebsite

A conditional tag that produces its contents when there is a website in
context. This tag is useful for situations where a website may or may not
be in context, such as the search template, when a search is conducted
across all blogs.

B<Example:>

    <mt:IfWebsite>
        <h1>Search results for <$mt:WebsiteName$>:</h1>
    <mt:Else>
        <h1>Search results from all blogs:</h1>
    </mt:IfBlog>

=for tags websites

=cut

###########################################################################

=head2 WebsiteID

Outputs the numeric ID of the website currently in context.

=for tags websites

=cut

sub _hdlr_website_id {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return 0 unless $blog;
    return 0 if $blog->class ne 'website';
    $blog ? $blog->id : 0;
}

###########################################################################

=head2 WebsiteName

Outputs the name of the website currently in context.

=for tags websites

=cut

sub _hdlr_website_name {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $name = $blog->name;
    defined $name ? $name : '';
}

###########################################################################

=head2 WebsiteDescription

Outputs the description field of the website currently in context.

=for tags websites

=cut

sub _hdlr_website_description {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $d = $blog->description;
    defined $d ? $d : '';
}

###########################################################################

=head2 WebsiteLanguage

The website's specified language. This setting can be changed on the website's
general settings screen.

B<Attributes:>

=over 4

=item * locale (optional; default "0")

If assigned, will format the language in the style "language_LOCALE" (ie: "en_US", "de_DE", etc).

=item * ietf (optional; default "0")

If assigned, will change any '_' in the language code to a '-', conforming
it to the IETF RFC # 3066.

=back

=for tags websites

=cut

sub _hdlr_website_language {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $lang_tag
        = ( $blog ? $blog->language : $ctx->{config}->DefaultLanguage )
        || '';
    MT::Util::normalize_language( $lang_tag, $args->{'locale'},
        $args->{'ietf'} );
}

###########################################################################

=head2 WebsiteDateLanguage

The website's specified language for date display. This setting can be changed
on the website's Entry settings screen.

B<Attributes:>

=over 4

=item * locale (optional; default "0")

If assigned, will format the language in the style "language_LOCALE" (ie: "en_US", "de_DE", etc).

=item * ietf (optional; default "0")

If assigned, will change any '_' in the language code to a '-', conforming
it to the IETF RFC # 3066.

=back

=for tags websites

=cut

sub _hdlr_website_date_language {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $lang_tag
        = ( $blog ? $blog->date_language : $ctx->{config}->DefaultLanguage )
        || '';
    MT::Util::normalize_language( $lang_tag, $args->{'locale'},
        $args->{'ietf'} );
}

###########################################################################

=head2 WebsiteURL

Outputs the Site URL field of the website currently in context. An ending
'/' character is guaranteed.

=for tags websites

=cut

sub _hdlr_website_url {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $url = $blog->site_url;
    return '' unless defined $url;
    $url .= '/' unless $url =~ m!/$!;
    $url;
}

###########################################################################

=head2 WebsitePath

Outputs the Site Root field of the website currently in context. An ending
'/' character is guaranteed.

=for tags websites

=cut

sub _hdlr_website_path {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $path = $blog->site_path;
    return '' unless defined $path;
    $path .= '/' unless $path =~ m!/$!;
    $path;
}

###########################################################################

=head2 WebsiteTimezone

The timezone that has been specified for the website displayed as an offset
from UTC in +|-hh:mm format. This setting can be changed on the website's
General settings screen.

B<Attributes:>

=over 4

=item * no_colon (optional; default "0")

If specified, will produce the timezone without the ":" character
("+|-hhmm" only).

=back

=for tags websites

=cut

sub _hdlr_website_timezone {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $so                  = $blog->server_offset;
    my $no_colon            = $args->{no_colon};
    my $partial_hour_offset = 60 * abs( $so - int($so) );
    sprintf( "%s%02d%s%02d",
        $so < 0   ? '-' : '+', abs($so),
        $no_colon ? ''  : ':', $partial_hour_offset );
}

###########################################################################

=head2 WebsiteIfCCLicense

A conditional tag that is true when the current website in context has
been assigned a Creative Commons License.

=for tags websites, creativecommons

=cut

sub _hdlr_website_if_cc_license {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return 0 unless $blog;
    return 0 if $blog->class ne 'website';
    return $blog->cc_license ? 1 : 0;
}

###########################################################################

=head2 WebsiteCCLicenseURL

Publishes the license URL of the Creative Commons logo appropriate
to the license assigned to the website inc ontex.t If the website doesn't
have a Creative Commons license, this tag returns an empty string.

=for tags websites, creativecommons

=cut

sub _hdlr_website_cc_license_url {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    return $blog->cc_license_url;
}

###########################################################################

=head2 WebsiteCCLicenseImage

Publishes the license URL of the Creative Commons logo appropriate to
the license assigned to the website in context If the website doesn't have a
Creative Commons license, this tag returns an empty string.

B<Example:>

    <MTIf tag="WebsiteCCLicenseImage">
    <img src="<$MTWebsiteCCLicenseImage$>" alt="Creative Commons" />
    </MTIf>

=for tags website, creativecommons

=cut

sub _hdlr_website_cc_license_image {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $cc = $blog->cc_license or return '';
    my ( $code, $license, $image_url ) = $cc =~ /(\S+) (\S+) (\S+)/;
    return $image_url if $image_url;
    "http://creativecommons.org/images/public/"
        . ( $cc eq 'pd' ? 'norights' : 'somerights' );
}

###########################################################################

=head2 WebsiteFileExtension

Returns the configured website filename extension, including a leading
'.' character. If no extension is assigned, this returns an empty
string.

=for tags websites

=cut

sub _hdlr_website_file_extension {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    return $ctx->_no_website_error()
        if $blog->class ne 'website';
    my $ext = $blog->file_extension || '';
    $ext = '.' . $ext if $ext ne '';
    $ext;
}

###########################################################################

=head2 WebsiteHasBlog

A conditional tag that returns True when the current website
in the context has one or more blogs.

=for tags websites,

=cut

sub _hdlr_website_has_blog {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return 0 unless $blog;
    return 0 if $blog->class ne 'website';

    my $blog_class = MT->model('blog');
    my %terms;
    $terms{parent_id} = $blog->id;
    $terms{class}     = 'blog';
    return $blog_class->exist( \%terms ) ? 1 : 0;
}

###########################################################################

=head2 WebsiteHost

The host name part of the absolute URL of your website.

B<Attributes:>

=over 4

=item * exclude_port (optional; default "0")

Removes any specified port number if this attribute is set to true (1),
otherwise it will return the hostname and port number (e.g.
www.somedomain.com:8080).

=item * signature (optional; default "0")

If set to 1, then this template tag will instead return a unique signature
for the hostname, by replacing all occurrences of decimals (".") with
underscores ("_").

=back

=for tags websites

=cut

sub _hdlr_website_host {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return '' unless $blog;
    my $host = $blog->site_url;
    if ( $host =~ m!^https?://([^/:]+)(:\d+)?/?! ) {
        if ( $args->{signature} ) {

            # using '_' to replace '.' since '-' is a valid
            # letter for domains
            my $sig = $1;
            $sig =~ s/\./_/g;
            return $sig;
        }
        return $args->{exclude_port} ? $1 : $1 . ( $2 || '' );
    }
    else {
        return '';
    }
}

###########################################################################

=head2 WebsiteRelativeURL

Similar to the L<WebsiteURL> tag, but removes any domain name from the URL.

=for tags websites

=cut

sub _hdlr_website_relative_url {
    my ( $ctx, $args, $cond ) = @_;
    my $blog;
    if ( $args->{id} && ( $args->{id} =~ m/^\d+$/ ) ) {
        $blog = MT::Website->load( $args->{id} );
    }
    else {
        $blog = $ctx->stash('blog');
    }
    return '' unless $blog;
    my $host = $blog->site_url;
    return '' unless defined $host;
    if ( $host =~ m!^https?://[^/]+(/.*)$! ) {
        return $1;
    }
    else {
        return '';
    }
}

###########################################################################

=head2 WebsiteThemeID

Outputs applied theme's ID for the website currently in context.

=for tags websites

=cut

sub _hdlr_website_theme_id {
    shift->invoke_handler( 'blogThemeID', @_ );
}

###########################################################################

=head2 BlogParentWebsite

A container tag which loads parent website of blog in the current context.

=for tags websites blogs

=cut

sub _hdlr_blog_parent_website {
    my ( $ctx, $args, $cond ) = @_;

    my $blog = $ctx->stash('blog');
    return $ctx->_no_blog_error() unless $blog;

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    require MT::Website;
    my $website = $blog->website();

    my $res = '';
    local $ctx->{__stash}{blog}         = $website;
    local $ctx->{__stash}{blog_id}      = $website->id;
    local $ctx->{__stash}{inside_blogs} = 1;
    defined( my $out = $builder->build( $ctx, $tokens, $cond ) )
        or return $ctx->error( $builder->errstr );
    $res .= $out;
    $res;
}

1;
