# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::Viewer;

use strict;
use base qw( MT::App );

use MT::Entry;
use MT::Template;
use MT::Template::Context;
use MT::Promise qw(delay);

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{default_mode} = 'main';
    $app->add_methods( 'main' => \&view, );
    return $app;
}

my %view_handlers = (
    'index'      => \&_view_index,
    'Individual' => \&_view_entry,
    'Page'       => \&_view_entry,
    'Category'   => \&_view_category,
    'Author'     => \&_view_author,
    '*'          => \&_view_archive,
);

sub view {
    my $app = shift;

    my $R = MT::Request->instance;
    $R->stash( 'live_view', 1 );

    ## Process the path info.
    my $uri = $app->param('uri') || $app->path_info;
    my $blog_id = $app->param('blog_id');

    ## Check ExcludeBlogs and IncludeBlogs to see if this blog is
    ## private or not.
    my $cfg = $app->config;
    $app->{__blog_id} = $blog_id;

    require MT::Blog;
    my $blog = $app->{__blog} = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate( "Loading blog with ID [_1] failed", $blog_id ) );

    my $idx = $cfg->IndexBasename   || 'index';
    my $ext = $blog->file_extension || '';
    $idx .= '.' . $ext if $ext ne '';

    my @urls = ($uri);
    if ( $uri !~ m!\Q/$idx\E$! ) {
        push @urls, $uri . '/' . $idx;
    }

    require MT::FileInfo;
    my @fi = MT::FileInfo->load(
        {   blog_id => $blog_id,
            url     => \@urls
        }
    );
    if (@fi) {
        if ( my $tmpl = MT::Template->load( $fi[0]->template_id ) ) {
            my $handler = $view_handlers{ $tmpl->type };
            $handler ||= $view_handlers{'*'};
            return $handler->( $app, $fi[0], $tmpl );
        }
    }
    if (my $tmpl = MT::Template->load(
            {   blog_id => $blog_id,
                type    => 'dynamic_error'
            }
        )
        )
    {
        my $ctx = $tmpl->context;
        $ctx->stash( 'blog',    $blog );
        $ctx->stash( 'blog_id', $blog_id );
        return $tmpl->output();
    }
    return $app->error("File not found");
}

my %MimeTypes = (
    css  => 'text/css',
    txt  => 'text/plain',
    rdf  => 'text/xml',
    rss  => 'text/xml',
    xml  => 'text/xml',
    js   => 'text/javascript',
    json => 'text/javascript+json',
);

sub _view_index {
    my $app = shift;
    my ( $fi, $tmpl ) = @_;
    my $q = $app->param;

    my $ctx = $tmpl->context;
    if ( $tmpl->text =~ m/<MT:?Entries/i ) {
        my $limit  = $q->param('limit');
        my $offset = $q->param('offset');
        if ( $limit || $offset ) {
            $limit ||= 20;
            my %arg = (
                'sort'    => 'authored_on',
                direction => 'descend',
                limit     => $limit,
                ( $offset ? ( offset => $offset ) : () ),
            );
            my @entries = MT::Entry->load(
                {   blog_id => $app->{__blog_id},
                    status  => MT::Entry::RELEASE()
                },
                \%arg
            );
            $ctx->stash( 'entries', delay( sub { \@entries } ) );
        }
    }
    my $out = $tmpl->build($ctx)
        or return $app->error(
        $app->translate( "Template publishing failed: [_1]", $tmpl->errstr )
        );
    ( my $ext = $tmpl->outfile ) =~ s/.*\.//;
    my $mime = $MimeTypes{$ext} || 'text/html';
    $app->send_http_header($mime);
    $app->print_encode( $out );
    $app->{no_print_body} = 1;
    1;
}

sub _view_date_archive {
    my $app = shift;
    my ($spec) = @_;
    my ( $start, $end, $at );
    my $ctx = MT::Template::Context->new;
    if ( $spec =~ m!^(\d{4})/(\d{2})/(\d{2})! ) {
        my ( $y, $m, $d ) = ( $1, $2, $3 );
        ( $start, $end )
            = ( $y . $m . $d . '000000', $y . $m . $d . '235959' );
        $at = $ctx->{current_archive_type} = 'Daily';
    }
    elsif ( $spec =~ m!^(\d{4})/(\d{2})! ) {
        my ( $y, $m ) = ( $1, $2 );
        my $days = MT::Util::days_in( $m, $y );
        ( $start, $end )
            = ( $1 . $2 . '01000000', $1 . $2 . $days . '235959' );
        $at = $ctx->{current_archive_type} = 'Monthly';
    }
    elsif ( $spec =~ m!^week/(\d{4})/(\d{2})/(\d{2})! ) {
        my ( $y, $m, $d ) = ( $1, $2, $3 );
        ( $start, $end )
            = MT::Util::start_end_week( "$1$2${3}000000", $app->{__blog} );
        $at = $ctx->{current_archive_type} = 'Weekly';
    }
    else {
        return $app->error( $app->translate("Invalid date spec") );
    }
    $ctx->{current_timestamp}     = $start;
    $ctx->{current_timestamp_end} = $end;
    my @entries = MT::Entry->load(
        {   authored_on => [ $start, $end ],
            blog_id     => $app->{__blog_id},
            status      => MT::Entry::RELEASE()
        },
        { range => { authored_on => 1 } }
    );
    $ctx->stash( 'entries', delay( sub { \@entries } ) );
    require MT::TemplateMap;
    my $map = MT::TemplateMap->load(
        {   archive_type => $at,
            blog_id      => $app->{__blog_id},
            is_preferred => 1
        }
    ) or return $app->error( $app->translate("Can't load templatemap") );
    my $tmpl = MT::Template->load( $map->template_id )
        or return $app->error(
        $app->translate( "Can't load template [_1]", $map->template_id ) );
    my $out = $tmpl->build($ctx)
        or return $app->error(
        $app->translate( "Archive publishing failed: [_1]", $tmpl->errstr ) );
    $out;
}

sub _view_entry {
    my $app = shift;
    my ( $entry_id, $template ) = @_;
    my $entry = MT::Entry->load($entry_id)
        or return $app->error(
        $app->translate( "Invalid entry ID [_1]", $entry_id ) );
    return $app->error(
        $app->translate( "Entry [_1] is not published", $entry_id ) )
        unless $entry->status == MT::Entry::RELEASE();
    my $ctx = MT::Template::Context->new;
    $ctx->{current_archive_type} = 'Individual';
    $ctx->{current_timestamp}    = $entry->authored_on;
    $ctx->stash( 'entry', $entry );
    my %cond = (
        EntryIfAllowComments => $entry->allow_comments,
        EntryIfCommentsOpen  => $entry->allow_comments eq '1',
        EntryIfAllowPings    => $entry->allow_pings,
        EntryIfExtended      => $entry->text_more ? 1 : 0,
    );
    require MT::TemplateMap;
    my $tmpl;

    if ($template) {
        $tmpl = MT::Template->load(
            {   name    => $template,
                blog_id => $app->{__blog_id}
            }
            )
            or return $app->error(
            $app->translate( "Can't load template [_1]", $template ) );
    }
    else {
        my $map = MT::TemplateMap->load(
            {   archive_type => 'Individual',
                blog_id      => $app->{__blog_id},
                is_preferred => 1
            }
            )
            or
            return $app->error( $app->translate("Can't load templatemap") );
        $tmpl = MT::Template->load( $map->template_id )
            or return $app->error(
            $app->translate( "Can't load template [_1]", $map->template_id )
            );
    }
    my $out = $tmpl->build( $ctx, \%cond )
        or return $app->error(
        $app->translate( "Archive publishing failed: [_1]", $tmpl->errstr ) );
    $out;
}

sub _view_category {
    my $app = shift;
    my ($cat_id) = @_;
    require MT::Category;
    my $cat = MT::Category->load($cat_id)
        or return $app->error(
        $app->translate( "Invalid category ID '[_1]'", $cat_id ) );
    my ( $start, $end, $at );
    my $ctx = MT::Template::Context->new;
    $ctx->stash( 'archive_category', $cat );
    $ctx->{current_archive_type} = 'Category';
    require MT::Placement;
    my @entries = MT::Entry->load(
        {   blog_id => $app->{__blog_id},
            status  => MT::Entry::RELEASE()
        },
        {   'join' =>
                [ 'MT::Placement', 'entry_id', { category_id => $cat_id } ]
        }
    );
    $ctx->stash( 'entries', delay( sub { \@entries } ) );
    require MT::TemplateMap;
    my $map = MT::TemplateMap->load(
        {   archive_type => 'Category',
            blog_id      => $app->{__blog_id},
            is_preferred => 1
        }
    );
    my $tmpl = MT::Template->load( $map->template_id )
        or return $app->error(
        $app->translate( "Can't load template [_1]", $map->template_id ) );
    my $out = $tmpl->build($ctx)
        or return $app->error(
        $app->translate( "Archive publishing failed: [_1]", $tmpl->errstr ) );
    $out;
}

1;
__END__

=head1 NAME

MT::App::Viewer

=head1 METHODS

=head2 $app->init()

This method is called automatically during construction. It calls
L<MT::App/init>, regsters the C<view> method and sets the object's
I<default_mode>.

=head2 $app->view()

This generic method views a template interpolated in the appropriate context.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
