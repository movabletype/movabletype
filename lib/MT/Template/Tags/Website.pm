# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Website;

use strict;
use warnings;

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

=head2 Sites

A container tag which iterates over a list of all of the sites in the
system. You can use any of the site tags (L<SiteName>, L<SiteURL>, etc -
anything starting with MTSite) inside of this tag set.

B<Attributes:>

=over 4

=item * site_ids

This attribute allows you to limit the set of sites iterated over by
L<Sites>. Multiple sites are specified in a comma-delimited fashion.
For example:

    <mt:Sites site_ids="1,12,19">

would iterate over only the sites with IDs 1, 12 and 19.

=back

=over 4

=item * mode (default: "loop")

"loop": Information on multiple blogs is displayed in blog units.

"context": Information on whole of multiple blogs is sorted and displayed.

=back

=for tags multiblog, loop, sites

=cut

=head2 MultiBlog

This tag is an alias for the Sites tag

=cut

=head2 OtherBlog

This tag is an alias for the Sites tag

=cut

sub _hdlr_websites {
    my ( $ctx, $args, $cond ) = @_;

    # Set default mode for backwards compatibility
    $args->{mode} ||= 'loop';

    if ( $args->{site_id} ) {
        $args->{site_ids} = $args->{site_id};
        delete $args->{site_id};
        delete $args->{blog_id} if $args->{blog_id};
    }
    elsif ( $args->{blog_id} ) {
        $args->{blog_ids} = $args->{blog_id};
        delete $args->{blog_id};
    }

    # If MTMultiBlog was called with no arguments, we check the
    # blog-level settings for the default includes/excludes.
    unless ( $args->{blog_ids}
        || $args->{include_sites}
        || $args->{exclude_sites}
        || $args->{include_blogs}
        || $args->{exclude_blogs}
        || $args->{include_websites}
        || $args->{exclude_websites}
        || $args->{site_ids} )
    {
        my $blog = $ctx->stash('blog');
        my $is_include
            = $blog && defined $blog->default_mt_sites_action
            ? $blog->default_mt_sites_action
            : 1;
        my $blogs = $blog && $blog->default_mt_sites_sites || '';

        my $tag_name = $ctx->stash('tag');

        if ( $blogs && defined($is_include) ) {
            $args->{ $is_include ? 'include_blogs' : 'exclude_blogs' }
                = $blogs;
        }

        # No blog-level config set
        # Set mode to context as this will mimic no MTMultiBlog tag
        elsif ( $tag_name eq 'mtmultiblog' ) {
            $args->{'mode'} = 'context';    # Override 'loop' mode
        }
    }

    # Filter mt:Sites args through access controls
    require MT::RebuildTrigger;

    # Load mt:Sites access control list
    my %acl = MT::RebuildTrigger->load_sites_acl($ctx);
    $args->{ $acl{mode} } = $acl{acl};

    # Run mt:Sites in specified mode
    my $res;
    if ( $args->{mode} eq 'loop' ) {
        $res = _loop(@_);
    }
    elsif ( $args->{mode} eq 'context' ) {
        $res = _context(@_);
    }
    else {

        # Throw error if mode is unknown
        $res = $ctx->error(
            MT->translate(
                'Unknown "mode" attribute value: [_1]. '
                    . 'Valid values are "loop" and "context".',
                $args->{mode}
            )
        );
    }

    # Remove sites_context and blog_ids
    $ctx->stash( 'sites_context',          '' );
    $ctx->stash( 'sites_include_blog_ids', '' );
    $ctx->stash( 'sites_exclude_blog_ids', '' );
    return defined($res) ? $res : $ctx->error( $ctx->errstr );
}

## Supporting functions for 'mt:Sites' tag:

# mt:Sites's "context" mode:
# The container's contents are evaluated once with a multi-site context
sub _context {
    my ( $ctx, $args, $cond ) = @_;

    my $include_blogs
        = $args->{include_sites}
        || $args->{include_blogs}
        || $args->{blog_ids};
    my $exclude_blogs = $args->{exclude_sites} || $args->{exclude_blogs};

    # Assuming multiblog context, set it.
    if ( $include_blogs || $exclude_blogs ) {
        $ctx->stash( 'sites_context', 1 );
        $ctx->stash( 'sites_include_blog_ids', join( ',', $include_blogs ) )
            if $include_blogs;
        $ctx->stash( 'sites_exclude_blog_ids', join( ',', $exclude_blogs ) )
            if $exclude_blogs;
    }

    # Evaluate container contents and return output
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $out     = $builder->build( $ctx, $tokens, $cond );
    return
        defined($out) ? $out : $ctx->error( $ctx->stash('builder')->errstr );

}

# mt:Sites's "loop" mode:
# The container's contents are evaluated once per specified blog
sub _loop {
    my ( $ctx, $args, $cond ) = @_;
    my ( %terms, %args );

    # Set the context for blog loading
    $ctx->set_blog_load_context( $args, \%terms, \%args, 'id' )
        or return $ctx->error( $ctx->errstr );

    my $incl
        = $args->{include_sites}
        || $args->{include_blogs}
        || $args->{include_website}
        || $args->{blog_ids}
        || $args->{site_ids};
    my $tag_name = lc $ctx->stash('tag');
    $args{'no_class'} = 1
        if ( $tag_name ne 'websites' )
        && $incl
        && (
        ( lc $incl eq 'all' )
        || (( $incl eq 'children' || $incl eq 'siblings' )
            && (   $args->{include_parent_site}
                || $args->{include_with_website} )
        )
        );

    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');

    local $ctx->{__stash}{contents} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{entries} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp_end} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp_end} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{archive_category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{inside_blogs} = 1;

    if (  !$terms{class}
        && $tag_name ne 'multiblog'
        && $tag_name ne 'otherblog' )
    {
        $terms{class} = 'website';
    }
    elsif ( $terms{class} ) {
        delete $terms{class};
    }
    $args{'sort'} = 'name';
    $args{direction} = 'ascend';

    my @sites = MT->model('website')->load( \%terms, \%args );
    my $res   = '';
    my $count = 0;
    my $vars  = $ctx->{__stash}{vars} ||= {};
    for my $site (@sites) {
        $count++;
        local $ctx->{__stash}{blog}    = $site;
        local $ctx->{__stash}{blog_id} = $site->id;
        local $vars->{__first__}       = $count == 1;
        local $vars->{__last__}        = $count == scalar(@sites);
        local $vars->{__odd__}         = ( $count % 2 ) == 1;
        local $vars->{__even__}        = ( $count % 2 ) == 0;
        local $vars->{__counter__}     = $count;
        $ctx->stash( 'sites_context',  'include_blogs' );
        $ctx->stash( 'sites_blog_ids', $site->id );
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

sub _hdlr_if_website {
    my ($ctx) = @_;
    my $blog = $ctx->stash('blog');
    return 0 unless $blog;
    return !$blog->is_blog;
}

###########################################################################

=head2 WebsiteID

Outputs the numeric ID of the website currently in context.

=for tags websites

=cut

sub _hdlr_website_id {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return 0 unless $blog;
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    $website->id;
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
    my $website = $blog->website
        or die $ctx->_no_parent_website_error();
    my $name = $website->name;
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
    my $website = $blog->website
        or die $ctx->_no_parent_website_error();
    my $d = $website->description;
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
    my $website;
    if ($blog) {
        $website = $blog->website
            or die $ctx->_no_parent_website_error();
    }
    my $lang_tag
        = ( $website ? $website->language : $ctx->{config}->DefaultLanguage )
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
    my $website;
    if ($blog) {
        $website = $blog->website
            or return $ctx->_no_parent_website_error();
    }
    my $lang_tag
        = (
        $website ? $website->date_language : $ctx->{config}->DefaultLanguage )
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
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    my $url = $website->site_url;
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
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    my $path = $website->site_path;
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
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    my $so                  = $website->server_offset;
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
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    return $website->cc_license ? 1 : 0;
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
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    return $website->cc_license_url;
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
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    my $cc = $website->cc_license or return '';
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
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    my $ext = $website->file_extension || '';
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

    if ( $blog->is_blog ) {
        return 1 if $blog->website;
        return $ctx->_no_parent_website_error;
    }

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
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    my $host = $website->site_url;
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
    my $website;
    if ( $args->{id} && ( $args->{id} =~ m/^\d+$/ ) ) {
        $website = MT::Website->load( $args->{id} );
    }
    else {
        my $blog = $ctx->stash('blog');
        $website = $blog->website
            or return $ctx->_no_parent_website_error();
    }
    return '' unless $website;
    my $host = $website->site_url;
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

Outputs applied theme's ID for the website currently in context. The 
identifier is modified such that underscores are changed to dashes.

B<Attributes:>

=over 4

=item * raw (optional; default "0")

If specified, the raw theme ID is returned.

=back

=for tags websites

=cut

sub _hdlr_website_theme_id {
    my ( $ctx, $args, $cond ) = @_;
    my $blog = $ctx->stash('blog');
    return $ctx->_no_website_error() unless $blog;
    my $website = $blog->website
        or return $ctx->_no_parent_website_error();
    my $id = $website->theme_id
        or return '';
    $id =~ s/_/-/g unless $args->{raw};
    return $id;
}

###########################################################################

=head2 BlogParentWebsite

A container tag which loads parent website of blog in the current context.

=for tags websites blogs

=cut

=head2 SiteParentSite

A container tag which loads parent site of child site in the current context.

=for tags sites

=cut

=head2 ParentSite

A container tag which loads parent site of child site in the current context.

=for tags sites

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
