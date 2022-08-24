# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Template::Tags::Misc;

use strict;
use warnings;

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
use MT::I18N
    qw( first_n_text const uppercase lowercase substr_text length_text wrap_text );
use MT::Asset;

###########################################################################

=head2 IfImageSupport

A conditional tag that returns true when the Movable Type installation
has the Perl modules necessary for manipulating image files.

=cut

sub _hdlr_if_image_support {
    my ( $ctx, $args, $cond ) = @_;
    my $if_image_support = MT->request('if_image_support');
    if ( !defined $if_image_support ) {
        require MT::Image;
        $if_image_support = defined MT::Image->new ? 1 : 0;
        MT->request( 'if_image_support', $if_image_support );
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
    my ( $ctx, $args, $cond ) = @_;
    my $tmpl_name = delete $args->{name}
        or return $ctx->error( MT->translate("name is required.") );
    my $blog_id = $args->{blog_id} || $ctx->{__stash}{blog_id} || 0;
    if ( exists $args->{parent} && $args->{parent} ) {
        if ( my $_stash_blog = $ctx->stash('blog') ) {
            if ($_stash_blog->is_blog) {
                $blog_id = $_stash_blog->parent_id or return '';
            } else {
                $blog_id = $_stash_blog->id;
            }
        }
    }
    my $tmpl = MT->model('template')->load(
        {   name    => $tmpl_name,
            blog_id => $blog_id
            ? ( exists $args->{parent} && $args->{parent} )
                    ? $blog_id
                    : [ 0, $blog_id ]
            : 0,
            type => 'widgetset'
        },
            {
            sort      => 'blog_id',
            direction => 'descend'
            }
        )
        or return $ctx->error(
        MT->translate( "Specified WidgetSet '[_1]' not found.", $tmpl_name )
        );

    ## Load all widgets for make cache.
    my @widgets;
    if ( my $modulesets = $tmpl->modulesets ) {
        my @widget_ids = split ',', $modulesets;
        my $terms
            = ( scalar @widget_ids ) > 1
            ? { id => \@widget_ids }
            : $widget_ids[0];
        my @objs = MT->model('template')->load($terms);
        my %widgets = map { $_->id => $_ } @objs;
        push @widgets, $widgets{$_} for @widget_ids;
    }
    elsif ( my $text = $tmpl->text ) {
        my @widget_names = $text =~ /widget\=\"([^"]+)\"/g;
        my @objs         = MT->model('template')->load(
            {   name    => \@widget_names,
                blog_id => [ $blog_id, 0 ],
            }
        );
        @objs = sort { $a->blog_id <=> $b->blog_id } @objs;
        my %widgets;
        $widgets{ $_->name } = $_ for @objs;
        push @widgets, $widgets{$_} for @widget_names;
    }
    return '' unless scalar @widgets;

    my @res;
    {
        local $ctx->{__stash}{tag} = 'include';
        for my $widget (@widgets) {
            my $name     = $widget->name;
            my $stash_id = Encode::encode_utf8(
                join( '::', 'template_widget', $blog_id, $name ) );
            my $req = MT::Request->instance;
            my $tokens = $ctx->stash('builder')->compile( $ctx, $widget );
            $req->stash( $stash_id, [ $widget, $tokens ] );
            my $out = $ctx->invoke_handler( 'include',
                { %$args, widget => $name, }, $cond, );

            # if error is occurred, pass the include's errstr
            return unless defined $out;

            push @res, $out;
        }
    }
    return join( '', @res );
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
    my ( $ctx, $args, $cond ) = @_;
    my $blog_id = $ctx->stash('blog_id');
    my $blog    = MT->model('blog')->load($blog_id);
    return $ctx->error( MT->translate( 'Cannot load blog #[_1].', $blog_id ) )
        unless $blog;
    if ( my $provider
        = MT->effective_captcha_provider( $blog->captcha_provider ) )
    {
        my $fields = $provider->form_fields($blog_id);
        $fields =~ s/[\r\n]//g;
        $fields =~ s/'/\\'/g;
        return $fields;
    }
    return q();
}

###########################################################################

=head2 StatsSnippet

Returns the html code snippet of information gathering for stats of current blog/site.
If any stats provider was not found, this template tag will return blank string.

=cut

sub _hdlr_stats_snippet {
    my ($ctx, $args) = @_;
    my $blog_id      = $ctx->stash('blog_id');
    my $blog         = MT->model('blog')->load($blog_id);
    my $provider_arg = $args->{provider} || '';

    require MT::Stats;
    my $provider = MT::Stats::readied_provider(MT->instance, $blog, $provider_arg)
        or return q();

    $provider->snipet(@_);
}

###########################################################################

=head2 HasPlugin

A conditional tag that returns true when a specific plugin is enabled.

B<Attributes:>

=over 4

=item * name (required)

The name of the plugin. In case the name is not specified explicitly,
you can use the signature of the plugin, which is the last part of
the directory name in which the plugin exists, or the last part of
the directory name plus the name of .pl file.

=back

B<Example:>

    <$mt:HasPlugin name="Comments"$>...</$mt:HasPlugin>
    <$mt:HasPlugin name="Markdown/Markdown.pl"$>...</$mt:HasPlugin>
    <$mt:HasPlugin name="my_plugin.pl"$>...</$mt:HasPlugin>

=for tags plugin

=cut

sub _hdlr_has_plugin {
    my ( $ctx, $args, $cond ) = @_;
    my $name = delete $args->{name}
        or return $ctx->error( MT->translate("name is required.") );
    my $PluginAlias = MT->config->PluginAlias || {};
    if ( exists $PluginAlias->{$name} ) {
        $name = $PluginAlias->{$name};
    }
    return MT->has_plugin($name) ? 1 : 0;
}

1;
