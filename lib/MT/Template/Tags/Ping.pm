# Movable Type (r) Open Source (C) 2001-2010 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Template::Tags::Ping;

use strict;
use MT::Util qw( encode_xml );

###########################################################################

=head2 Pings

A context-sensitive container tag that lists all of the pings sent
to a particular entry, category or blog. If used in an entry context
the tagset will list all pings for the entry. Likewise for a
TrackBack-enabled category in context. If not in an entry or category
context, a blog context is assumed and all associated pings are listed.

B<Attributes:>

=over 4

=item * category

This attribute creates a specific category context regardless of
its placement.

=item * lastn

Display the last N pings in context. N is a positive integer.

=item * sort_order

Specifies the sort order. Recognized values are "ascend" (default) and
"descend."

=back

=for tags pings, multiblog

=cut

sub _hdlr_pings {
    my($ctx, $args, $cond) = @_;
    require MT::Trackback;
    require MT::TBPing;
    my($tb, $cat);
    my $blog = $ctx->stash('blog');
    $ctx->nofollowfy_on($args) if ($blog->nofollow_urls);

    if (my $e = $ctx->stash('entry')) {
        $tb = $e->trackback;
        return '' unless $tb;
    } elsif ($cat = $ctx->stash('archive_category')) {
        $tb = MT::Trackback->load({ category_id => $cat->id });
        return '' unless $tb;
    } elsif (my $cat_name = $args->{category}) {
        $cat = MT::Category->load({ label => $cat_name,
                                    blog_id => $ctx->stash('blog_id') })
            or return $ctx->error(MT->translate("No such category '[_1]'", $cat_name));
        $tb = MT::Trackback->load({ category_id => $cat->id });
        return '' unless $tb;
    }
    my $res = '';
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{tb_id} = $tb->id if $tb;
    $terms{visible} = 1;
    $args{'sort'} = 'created_on';
    $args{'direction'} = $args->{sort_order} || 'ascend';
    if (my $limit = $args->{lastn}) {
        $args{direction} = $args->{sort_order} || 'descend';
        $args{limit} = $limit;
    }
    my @pings = MT::TBPing->load(\%terms, \%args);
    my $count = 0;
    my $max = scalar @pings;
    my $vars = $ctx->{__stash}{vars} ||= {};
    for my $ping (@pings) {
        $count++;
        local $ctx->{__stash}{ping} = $ping;
        local $ctx->{__stash}{blog} = $ping->blog;
        local $ctx->{__stash}{blog_id} = $ping->blog_id;
        local $ctx->{current_timestamp} = $ping->created_on;
        local $vars->{__first__} = $count == 1;
        local $vars->{__last__} = ($count == ($max));
        local $vars->{__odd__} = ($count % 2) == 1;
        local $vars->{__even__} = ($count % 2) == 0;
        local $vars->{__counter__} = $count;
        my $out = $builder->build($ctx, $tokens, { %$cond,
            PingsHeader => $count == 1, PingsFooter => ($count == $max) });
        return $ctx->error( $builder->errstr ) unless defined $out;
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 PingsHeader

The contents of this container tag will be displayed when the first
ping listed by a L<Pings> tag is reached.

=for tags pings

=cut

###########################################################################

=head2 PingsFooter

The contents of this container tag will be displayed when the last
ping listed by a L<Pings> tag is reached.

=for tags pings

=cut

###########################################################################

=head2 PingsSent

A container tag representing a list of TrackBack pings sent from an
entry. Use the L<PingsSentURL> tag to display the URL pinged.

B<Example:>

    <h4>Ping'd</h4>
    <ul>
    <mt:PingsSent>
        <li><$mt:PingsSentURL$></li>
    </mt:PingsSent>
    </ul>

=for tags pings, entries

=cut

sub _hdlr_pings_sent {
    my($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $res = '';
    my $pings = $e->pinged_url_list;
    for my $url (@$pings) {
        $ctx->stash('ping_sent_url', $url);
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($builder->errstr);
        $res .= $out;
    }
    $res;
}

###########################################################################

=head2 PingEntry

Provides an entry context for the parent entry of the TrackBack ping
in context.

B<Example:>

    Last TrackBack received was for the entry
    titled:
    <mt:Pings lastn="1">
        <mt:PingEntry>
            <$mt:EntryTitle$>
        </mt:PingEntry>
    </mt:Pings>

=for tags pings, entries

=cut

sub _hdlr_ping_entry {
    my ($ctx, $args, $cond) = @_;
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    require MT::Trackback;
    my $tb = MT::Trackback->load($ping->tb_id);
    return '' unless $tb;
    return '' unless $tb->entry_id;
    my $entry = MT::Entry->load($tb->entry_id)
        or return '';
    local $ctx->{__stash}{entry} = $entry;
    local $ctx->{current_timestamp} = $entry->authored_on;
    $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond);
}

###########################################################################

=head2 IfPingsAllowed

Conditional tag that is positive when pings are allowed by the blog
and the MT installation (does not test for an entry context).

=cut

sub _hdlr_if_pings_allowed {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    if ($blog->allow_pings && $cfg->AllowPings) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfPingsAccepted

Conditional tag that is positive when pings are allowed for the blog
and the entry (if one is in context) and the MT installation.

=cut

sub _hdlr_if_pings_accepted {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $accepted;
    my $entry = $ctx->stash('entry');
    $accepted = 1 if $blog->allow_pings && $cfg->AllowPings;
    $accepted = 0 if $entry && !$entry->allow_pings;
    if ($accepted) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfPingsActive

Conditional tag that displays its contents if TrackBack pings are
enabled or pings exist for the entry in context.

=for tags entries, pings

=cut

sub _hdlr_if_pings_active {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $entry = $ctx->stash('entry');
    my $active;
    $active = 1 if $cfg->AllowPings && $blog->allow_pings;
    $active = 0 if $entry && !$entry->allow_pings;
    $active = 1 if !$active && $entry && $entry->ping_count;
    if ($active) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfPingsModerated

Conditional tag that is positive when the blog has a policy to moderate
all incoming pings by default.

=cut

sub _hdlr_if_pings_moderated {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    if ($blog->moderate_pings) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 EntryIfAllowPings

Deprecated in favor of L<IfPingsAccepted>.

=for tags deprecated

=cut

sub _hdlr_entry_if_allow_pings {
    my ($ctx, $args, $cond) = @_;
    my $entry = $ctx->stash('entry');
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    my $blog_pings_accepted = 1 if $cfg->AllowPings && $blog->allow_pings;
    if ($blog_pings_accepted && $entry->allow_pings) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 CategoryIfAllowPings

A conditional tag that displays its contents if pings are enabled for
the category in context.

=for tags categories, pings

=cut

sub _hdlr_category_allow_pings {
    my ($ctx) = @_;
    my $cat = $ctx->stash('category') || $ctx->stash('archive_category');
    return $cat->allow_pings ? 1 : 0;
}

###########################################################################

=head2 PingsSentURL

The URL of the TrackBack ping was sent to. This is the TrackBack Ping URL
and not a permalink.

B<Example:>

    <$mt:PingsSentURL$>

=for tags pings

=cut

sub _hdlr_pings_sent_url {
    my ($ctx) = @_;
    return $ctx->stash('ping_sent_url');
}

###########################################################################

=head2 PingTitle

The title of the remote resource that the TrackBack ping sent.

B<Example:>

    <$mt:PingTitle$>

=for tags pings

=cut

sub _hdlr_ping_title {
    my ($ctx, $args) = @_;
    $ctx->sanitize_on($args);
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->title ? $ping->title : '';
}

###########################################################################

=head2 PingID

A numeric system ID of the TrackBack ping in context.

B<Example:>

    <$mt:PingID$>

=for tags pings

=cut

sub _hdlr_ping_id {
    my ($ctx) = @_;
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return $ping->id;
}

###########################################################################

=head2 PingURL

The URL of the remote resource that the TrackBack ping sent.

B<Example:>

    <$mt:PingURL$>

=for tags pings

=cut

sub _hdlr_ping_url {
    my ($ctx, $args) = @_;
    $ctx->sanitize_on($args);
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->source_url ? $ping->source_url : '';
}

###########################################################################

=head2 PingExcerpt

An excerpt describing the URL of the ping sent.

B<Example:>

    <$mt:PingExcerpt$>

=for tags pings

=cut

sub _hdlr_ping_excerpt {
    my ($ctx, $args) = @_;
    $ctx->sanitize_on($args);
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->excerpt ? $ping->excerpt : '';
}

###########################################################################

=head2 PingBlogName

The site name that sent the TrackBack ping.

B<Example:>

    <$mt:BlogName$>

=for tags pings

=cut

sub _hdlr_ping_blog_name {
    my ($ctx, $args) = @_;
    $ctx->sanitize_on($args);
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->blog_name ? $ping->blog_name : '';
}

###########################################################################

=head2 PingIP

The IP (Internet Protocol) network address the TrackBack ping was sent
from.

B<Example:>

    <$mt:PingIP$>

=for tags pings

=cut

sub _hdlr_ping_ip {
    my ($ctx) = @_;
    my $ping = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    return defined $ping->ip ? $ping->ip : '';
}

###########################################################################

=head2 PingDate

The timestamp of when the ping was submitted. Date format tags may be
applied with the format attribute along with the language attribute.

B<Attributes:>

=over 4

=item * format (optional)

A string that provides the format in which to publish the date. If
unspecified, the default that is appropriate for the language of the blog
is used (for English, this is "%B %e, %Y %l:%M %p"). See the L<Date>
tag for the supported formats.

=item * language (optional; defaults to blog language)

Forces the date to the format associated with the specified language.

=item * utc (optional; default "0")

Forces the date to UTC time zone.

=item * relative (optional; default "0")

Produces a relative date (relative to current date and time). Suitable for
dynamic publishing (for instance, from PHP or search result templates). If
a relative date cannot be produced (the archive date is sufficiently old),
the 'format' attribute will govern the output of the date.

=back

B<Example:>

    <$mt:PingDate$>

=for tags pings, date

=cut

sub _hdlr_ping_date {
    my ($ctx, $args) = @_;
    my $p = $ctx->stash('ping')
        or return $ctx->_no_ping_error();
    $args->{ts} = $p->created_on;
    return $ctx->build_date($args);
}

###########################################################################

=head2 WebsitePingCount

Returns a count of published TrackBack pings associated with the website
currently in context.

=for tags multiblog, count, blogs, pings

=cut

###########################################################################

=head2 BlogPingCount

Returns a count of published TrackBack pings associated with the blog
currently in context.

=for tags multiblog, count, blogs, pings

=cut

sub _hdlr_blog_ping_count {
    my ($ctx, $args, $cond) = @_;
    my (%terms, %args);
    $ctx->set_blog_load_context($args, \%terms, \%args)
        or return $ctx->error($ctx->errstr);
    $terms{visible} = 1;
    require MT::Trackback;
    require MT::TBPing;
    my $count = MT::Trackback->count(undef,
        { 'join' => MT::TBPing->join_on('tb_id', \%terms, \%args) });
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 EntryTrackbackCount

Outputs the number of published TrackBack pings for the current entry in
context.

=cut

sub _hdlr_entry_ping_count {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $count = $e->ping_count;
    return $ctx->count_format($count, $args);
}

###########################################################################

=head2 EntryTrackbackLink

Outputs the TrackBack endpoint for the current entry in context.
If TrackBack is not enabled for the entry, this will output
an empty string.

=cut

sub _hdlr_entry_tb_link {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $tb = $e->trackback
        or return '';
    my $cfg = $ctx->{config};
    my $path = $ctx->cgi_path;
    $path . $cfg->TrackbackScript . '/' . $tb->id;
}

###########################################################################

=head2 EntryTrackbackData

Outputs the TrackBack RDF block that allows for TrackBack
autodiscovery to take place. If TrackBack is not enabled
for the entry, this will output an empty string.

B<Attributes:>

=over 4

=item * comment_wrap (optional; default "1")

If enabled, will enclose the RDF markup inside an HTML
comment tag.

=item * with_index (optional; default "0")

If specified, will leave any "index.html" (or appropriate index
page filename) in the permalink of the entry in context. By default
this portion of the permalink is removed, since it is usually
unnecessary.

=back

=cut

sub _hdlr_entry_tb_data {
    my ($ctx, $args, $cond) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    return '' unless $e->allow_pings;
    my $blog = $ctx->stash('blog');
    my $cfg = $ctx->{config};
    return '' unless $blog->allow_pings && $cfg->AllowPings;
    my $tb = $e->trackback or return '';
    return '' if $tb->is_disabled;
    my $path = $ctx->cgi_path;
    $path .= $cfg->TrackbackScript . '/' . $tb->id;
    my $url;
    if (my $at = $ctx->{current_archive_type} || $ctx->{archive_type}) {
        $url = $e->archive_url($at);
        $url .= '#entry-' . sprintf("%06d", $e->id)
            unless $at eq 'Individual';
    } else {
        $url = $e->permalink;
        $url = MT::Util::strip_index($url, $ctx->stash('blog')) unless $args->{with_index};
    }
    my $rdf = '';
    my $comment_wrap = defined $args->{comment_wrap} ?
        $args->{comment_wrap} : 1;
    $rdf .= "<!--\n" if $comment_wrap;
    ## SGML comments cannot contain double hyphens, so we convert
    ## any double hyphens to single hyphens.
    my $strip_hyphen = sub {
        return unless defined $_[0];
        (my $s = $_[0]) =~ tr/\-//s;
        $s;
    };
    $rdf .= <<RDF;
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:trackback="http://madskills.com/public/xml/rss/module/trackback/"
         xmlns:dc="http://purl.org/dc/elements/1.1/">
<rdf:Description
    rdf:about="$url"
    trackback:ping="$path"
    dc:title="@{[ encode_xml($strip_hyphen->($e->title), 1) ]}"
    dc:identifier="$url"
    dc:subject="@{[ encode_xml($e->category ? $e->category->label : '', 1) ]}"
    dc:description="@{[ encode_xml($strip_hyphen->($ctx->invoke_handler( 'entryexcerpt', $args, $cond )), 1) ]}"
    dc:creator="@{[ encode_xml($ctx->invoke_handler( 'entryauthordisplayname', $args, $cond ), 1) ]}"
    dc:date="@{[ $ctx->build_date({ 'ts' => $e->authored_on, 'format' => "%Y-%m-%dT%H:%M:%S" }) .
                 $ctx->invoke_handler( 'blogtimezone', $args, $cond ) ]}" />
</rdf:RDF>
RDF
    $rdf .= "-->\n" if $comment_wrap;
    $rdf;
}

###########################################################################

=head2 EntryTrackbackID

Outputs the numeric ID of the TrackBack for the current entry in context.
If not TrackBack is not enabled for the entry, this outputs an empty string.

=cut

sub _hdlr_entry_tb_id {
    my($ctx, $args) = @_;
    my $e = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $tb = $e->trackback
        or return '';
    $tb->id;
}

###########################################################################

=head2 CategoryTrackbackLink

The URL that TrackBack pings can be sent for the category in context.

B<Example:>

    <$mt:CategoryTrackbackLink$>

=cut

sub _hdlr_category_tb_link {
    my($ctx, $args) = @_;
    my $cat = $ctx->stash('category') || $ctx->stash('archive_category');
    if (!$cat) {
        my $cat_name = $args->{category}
            or return $ctx->error(MT->translate("<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the 'category' attribute to the tag."));
        $cat = MT::Category->load({ label => $cat_name,
                                    blog_id => $ctx->stash('blog_id') })
            or return $ctx->error("No such category '$cat_name'");
    }
    require MT::Trackback;
    my $tb = MT::Trackback->load({ category_id => $cat->id })
        or return '';
    my $cfg = $ctx->{config};
    my $path = $ctx->cgi_path;
    return $path . $cfg->TrackbackScript . '/' . $tb->id;
}

###########################################################################

=head2 CategoryTrackbackCount

The number of published TrackBack pings for the category in context.

B<Example:>

    <$mt:CategoryTrackbackCount$>

=for tags categories, pings, count

=cut

sub _hdlr_category_tb_count {
    my($ctx, $args) = @_;
    my $cat = $ctx->stash('category') || $ctx->stash('archive_category');
    return 0 unless $cat;
    require MT::Trackback;
    my $tb = MT::Trackback->load( { category_id => $cat->id } );
    return 0 unless $tb;
    require MT::TBPing;
    my $count = MT::TBPing->count( { tb_id => $tb->id, visible => 1 } );
    return $ctx->count_format($count || 0, $args);
}

1;
