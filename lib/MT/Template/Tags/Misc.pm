# Movable Type (r) Open Source (C) 2001-2009 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Template::Tags::Misc;

use strict;

use MT;
use MT::Util qw( start_end_day start_end_week 
                 start_end_month week2ymd archive_file_for
                 format_ts offset_time_list first_n_words dirify get_entry
                 encode_html encode_js remove_html wday_from_ts days_in
                 spam_protect encode_php encode_url decode_html encode_xml
                 decode_xml relative_date asset_cleanup );
use MT::Request;
use Time::Local qw( timegm timelocal );
use MT::Promise qw( delay );
use MT::Category;
use MT::Entry;
use MT::I18N qw( first_n_text const uppercase lowercase substr_text length_text wrap_text );
use MT::Asset;

###########################################################################

=head2 IfImageSupport

A conditional tag that returns true when the Movable Type installation
has the Perl modules necessary for manipulating image files.

=cut

sub _hdlr_if_image_support {
    my ($ctx, $args, $cond) = @_;
    my $if_image_support = MT->request('if_image_support');
    if (!defined $if_image_support) {
        require MT::Image;
        $if_image_support = defined MT::Image->new ? 1 : 0;
        MT->request('if_image_support', $if_image_support);
    }
    return $if_image_support;
}

###########################################################################

=head2 FeedbackScore

Outputs the numeric junk score calculated for the current comment or
TrackBack ping in context. Outputs '0' if no score is present.
A negative number indicates spam.

=cut

sub _hdlr_feedback_score {
    my ($ctx) = @_;
    my $fb = $ctx->stash('comment') || $ctx->stash('ping');
    $fb ? $fb->junk_score || 0 : '';
}

###########################################################################

=head2 ImageURL

Outputs the uploaded image URL (used only for the system
template for uploaded images).

=cut

sub _hdlr_image_url {
    my ($ctx) = @_;
    return $ctx->stash('image_url');
}

###########################################################################

=head2 ImageWidth

Outputs the uploaded image width in pixels (used only for the system
template for uploaded images).

=cut

sub _hdlr_image_width {
    my ($ctx) = @_;
    return $ctx->stash('image_width');
}

###########################################################################

=head2 ImageHeight

Outputs the uploaded image height in pixels (used only for the system
template for uploaded images).

=cut

sub _hdlr_image_height {
    my ($ctx) = @_;
    return $ctx->stash('image_height');
}

###########################################################################

=head2 WidgetManager

An alias for the L<WidgetSet> tag, and considered deprecated.

=for tags deprecated

=cut

###########################################################################

=head2 WidgetSet

Publishes the widget set identified by the C<name> attribute.

B<Attributes:>

=over 4

=item * name (required)

The name of the widget set to publish.

=item * blog_id (optional)

The target blog to use as a context for loading the widget set. This only
affects the loading of the widget set: it does not set the blog context
for the widgets that are published. By default, the blog in context is
used. You may specify a value of "0" for blog_id to target a global
widget set.

=back

B<Example:>

    <$mt:WidgetSet name="Sidebar"$>

=for tags widgets

=cut

sub _hdlr_widget_manager {
    my ( $ctx, $args ) = @_;
    my $tmpl_name = $args->{name}
        or return $ctx->error(MT->translate("name is required."));
    my $blog_id = $args->{blog_id} || $ctx->{__stash}{blog_id} || 0;

    require MT::Template;
    my $tmpl = MT::Template->load({ name => $tmpl_name,
                                    blog_id => $blog_id ? [ 0, $blog_id ] : 0,
                                    type => 'widgetset' },
                                  { sort => 'blog_id',
                                    direction => 'descend' })
        or return $ctx->error(MT->translate( "Specified WidgetSet '[_1]' not found.", $tmpl_name ));
    my $text = $tmpl->text;
    return $ctx->build($text) if $text;

    my $modulesets = $tmpl->modulesets;
    return ''; # empty widgetset is not an error

    my $string_tmpl = '<mt:include widget="%s">';
    my @selected = split ','. $modulesets;
    foreach my $mid (@selected) {
        my $wtmpl = MT::Template->load($mid)
            or return $ctx->error(MT->translate(
                "Can't find included template widget '[_1]'", $mid ));
        $text .= sprintf( $string_tmpl, $wtmpl->name );
    }
    return '' unless $text;
    return $ctx->build($text);
}

###########################################################################

=head2 CaptchaFields

Returns the HTML markup necessary to display the CAPTCHA on the published
blog. The value returned is escaped for assignment to a JavaScript string,
since the CAPTCHA field is displayed through the MT JavaScript code.

B<Example:>

    var captcha = '<$mt:CaptchaFields$>';

=for tags comments

=cut

sub _hdlr_captcha_fields {
    my ($ctx, $args, $cond) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my $blog = MT->model('blog')->load($blog_id);
        return $ctx->error(MT->translate('Can\'t load blog #[_1].', $blog_id)) unless $blog;
    if (my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
        my $fields = $provider->form_fields($blog_id);
        $fields =~ s/[\r\n]//g;
        $fields =~ s/'/\\'/g;
        return $fields;
    }
    return q();
}

1;
