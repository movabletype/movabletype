# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
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
    my $tmpl = MT->model('template')->load(
        {   name    => $tmpl_name,
            blog_id => $blog_id ? [ 0, $blog_id ] : 0,
            type    => 'widgetset'
        },
        {   sort      => 'blog_id',
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
        my @objs = MT->model('template')->load(
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

            # if error is occured, pass the include's errstr
            return unless defined $out;

            push @res, $out;
        }
    }
    return join( '', @res );
}

#####Widgetset Loop tags

###########################################################################

=head2 WidgetCount

Function tag that returns the number of widgets in a widget set.

B<Attributes:>

=over 4

=item * name (required)
Name of the widget set.

=back

=for tags widgets

=cut


sub _hdlr_widget_count {
    my ( $ctx, $args, $cond ) = @_;

    my $ws = $args->{name} || $args->{identifier}
      or return $ctx->error( MT->translate('WidgetSet name required.') );
    my $blog_id = $args->{blog_id} || $ctx->stash('blog_id') || 0;

    my $widgetset = MT->model('template')->load( {
                                   identifier => $ws,
                                   blog_id => $blog_id ? [ 0, $blog_id ] : 0,
                                   type    => 'widgetset'
                                 },
                                 { sort => 'blog_id', direction => 'descend' }
      )
      || MT->model('template')->load( {
                                   name    => $ws,
                                   blog_id => $blog_id ? [ 0, $blog_id ] : 0,
                                   type    => 'widgetset'
                                 },
                                 { sort => 'blog_id', direction => 'descend' }
      )
      || return $ctx->error(
              MT->translate( "Specified WidgetSet '[_1]' not found.", $ws ) );

    my @modulesets = split( ',', $widgetset->modulesets || '' );
    return scalar @modulesets;
} ## end sub _hdlr_widget_count

###########################################################################

=head2 WidgetSetLoop

Block loop tag that lets you loop over the contents of a widget set instead of loading the
widgets all at once.

B<Attributes:>

=over 4

=item * name (required) 
Name of the widget set.

=item * blog_id (optional)
Load widgetset from another blog. This will not load them with the context of the other blog.
Rather, it is intended to let blogs mix and match each other's widget sets or to let one blog
host widgets for several others without having to make them into system widgets.

=back

It provides the following meta variables:

=over 4

=item * __size__ The size of the widget set.
=item * __first__ Boolean variable set when the current iteration is the first widget in the set.
=item * __last__ Boolean variable set when the current iteration is the last widget in the set.
=item * __index__ An integer variable that is the current position in the widget loop.
=item * __odd__ Boolean variable set when the current iteration is even numbered in the loop.
=item * __even__ Boolean variable set when the current iteration is odd numbered in the loop.

=back

=for tags widgets

=cut

sub _hdlr_widget_loop {
    my ( $ctx, $args, $cond ) = @_;
    my $tmpl_name 
      = $args->{name}
      || $args->{identifier}
      || return $ctx->error( MT->translate("Template name is required.") );
    my $blog_id = $args->{blog_id} || $ctx->stash('blog_id') || 0;

    my $tmpl = MT->model('template')->load( {
                                   identifier => $tmpl_name,
                                   blog_id => $blog_id ? [ 0, $blog_id ] : 0,
                                   type    => 'widgetset'
                                 },
                                 { sort => 'blog_id', direction => 'descend' }
      )
      || MT->model('template')->load( {
                                   name    => $tmpl_name,
                                   blog_id => $blog_id ? [ 0, $blog_id ] : 0,
                                   type    => 'widgetset'
                                 },
                                 { sort => 'blog_id', direction => 'descend' }
      )
      || return $ctx->error(
          MT->translate( "Specified WidgetSet '[_1]' not found.", $tmpl_name )
      );

    my $modulesets = $tmpl->modulesets;
    my @selected   = split ',', $modulesets;
    my $vars       = $ctx->{__stash}{vars} ||= {};
    my $out        = '';
    my $builder    = $ctx->stash('builder');
    my $tokens     = $ctx->stash('tokens');
    $ctx->stash( 'widgetset', $tmpl );
    my $size = scalar(@selected);
    local $vars->{__size__}      = $size;
    local $vars->{ws_name}       = $tmpl->name;
    local $vars->{ws_identifier} = $tmpl->identifier;
    my $glue = $args->{glue} || '';

    for ( my $index = 0; $index < $size; $index++ ) {
        my $widget
          = MT->model('template')->load( { id => $selected[$index] } );
        local $vars->{__first__} = ( $index == 0 );
        local $vars->{__last__}  = ( $index == ( $size - 1 ) );
        local $vars->{__index__} = $index;
        local $vars->{__odd__}   = $index % 2 == 1;
        local $vars->{__even__}  = $index % 2 == 0;
        $ctx->stash( 'widget', $widget );
        my $res = $builder->build( $ctx, $tokens, $cond );
        return $ctx->error( $builder->errstr ) unless defined $res;
        $res .= $glue if ( $glue && $index < $size - 1 );
        $out .= $res;
    }
    $ctx->stash( 'widgeset', undef );
    return $out;
} ## end sub _hdlr_widget_loop

###########################################################################

=head2 WidgetSetName

Used within a WidgetSetLoop context. This returns the name of the widget set.

=for tags widgets

=cut

sub _hdlr_widget_set_name {
    my ($ctx, $args) =  @_;
    my $ws = $ctx->stash('widgetset') 
        or return $ctx->error('You called a WidgetSetName outside of a WidgetLoop context');
    return $ws->name;
}

###########################################################################

=head2 WidgetSetId
    
Used within a WidgetSetLoop context. This returns the ID number of the widget set.

=for tags widgets

=cut


sub _hdlr_widget_set_id {
    my ($ctx, $args) = @_;
    my $ws = $ctx->stash('widgetset') 
        or return $ctx->error('You called a WidgetSetID outside of a WidgetLoop context');
    return $ws->id;
}

###########################################################################

=head2 WidgetContent
    
Used within a WidgetSetLoop context. This returns the content of the widget. It supports the
caching options that <mt:Include> provides. Briefly, these are:

=over 4

=item * cache
=item * cache_key
=item * ttl

=back

=for tags widgets

=cut


sub _hdlr_widget_content {
    my ($ctx, $args, $cond) = @_;
    my $widget = $ctx->stash('widget')
        or return $ctx->error('No widget could be loaded.'); ###TODO more robust error handling!
    return '' unless $widget->text;

    local $args->{widget} = $widget->name;   
 
    return MT::Template::Tags::System::_include_module(@_);
}

sub _hdlr_widget_return_property
{
    my ($ctx, $args, $method) = @_;
    my $widget = $ctx->stash('widget')
        or return $ctx->error('No widget could be loaded.');
    return '' unless $widget->$method;

    return $widget->$method;
}

###########################################################################

=head2 WidgetName
    
Used within a WidgetSetLoop context. This returns the name of the widget currently in context.

=for tags widgets

=cut


sub _hdlr_widget_name {
    my ($ctx, $args) = @_;
    return _hdlr_widget_return_property($ctx, $args, 'name');
}

###########################################################################

=head2 WidgetID
    
Used within a WidgetSetLoop context. This returns the id of the widget currenlty in context.

=for tags widgets

=cut


sub _hdlr_widget_id {
    my ($ctx, $args) = @_;
    return _hdlr_widget_return_property($ctx, $args, 'id');
}

###########################################################################

=head2 WidgetIdentifier
    
Used within a WidgetSetLoop context. This returns the identifier of the widget currently in context.

=for tags widgets

=cut


sub _hdlr_widget_identifier {
    my ($ctx, $args) = @_;
    return _hdlr_widget_return_property($ctx, $args, 'identifier');
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
    return $ctx->error( MT->translate( 'Can\'t load blog #[_1].', $blog_id ) )
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

1;
