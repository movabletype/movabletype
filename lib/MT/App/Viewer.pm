# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
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
    'individual' => \&_view_entry,
    'page'       => \&_view_entry,
    'category'   => \&_view_category,
    'author'     => \&_view_author,
    '*'          => \&_view_date_archive,
);

sub view {
    my $app = shift;

    my $R = MT::Request->instance;
    $R->stash( 'live_view', 1 );

    ## Process the path info.
    my $uri = $app->param('uri') || $ENV{REQUEST_URI};
    my $blog_id = $app->param('blog_id')
        or return $app->errtrans("Invalid request.");

    ## Check ExcludeBlogs and IncludeBlogs to see if this blog is
    ## private or not.
    my $cfg = $app->config;
    if ( my $inc_blogs = $cfg->IncludeBlogs ) {
        return $app->errtrans('Invalid request')
            unless grep { $_ == $blog_id } split ',', $inc_blogs;
    }
    if ( my $exc_blogs = $cfg->ExcludeBlogs ) {
        return $app->errtrans('Invalid request')
            if grep { $_ == $blog_id } split ',', $exc_blogs;
    }

    my $blog = $app->{__blog} = MT->model('blog')->load($blog_id)
        or
        return $app->errtrans( "Loading blog with ID [_1] failed", $blog_id );

    my $idx = $cfg->IndexBasename   || 'index';
    my $ext = $blog->file_extension || '';
    $idx .= '.' . $ext if $ext ne '';

    my @urls = ($uri);
    if ( $uri !~ m!\Q/$idx\E$! ) {
        $uri .= '/' unless $uri =~ m!/$!;
        push @urls, $uri . $idx;
    }

    # Load fileinfo by URL
    my $fi = MT->model('fileinfo')->load(
        {   blog_id => $blog_id,
            url     => \@urls
        }
    ) or return $app->errtrans("Invalid request.");

    if ($fi) {
        return $app->errtrans('Invalid request.')
            if $fi->blog_id != $blog_id;

        $app->{__blog_id} = $blog_id;

        if ( my $tmpl = MT::Template->load( $fi->template_id ) ) {
            my $type = lc $tmpl->type;
            if ( 'archive' eq $type ) {
                $type = lc $fi->archive_type;
            }
            my $handler = $view_handlers{$type};
            $handler ||= $view_handlers{'*'};
            return $handler->( $app, $fi, $tmpl );
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

    return $app->errtrans("File not found");
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
    $app->print_encode($out);
    $app->{no_print_body} = 1;
    1;
}

sub _view_date_archive {
    my $app = shift;
    my ( $fi, $tmpl ) = @_;

    my $archiver = MT->publisher->archiver( $fi->archive_type )
        or return $app->errtrans( 'Unknown archive type: [_1]',
        $fi->archive_type );
    my ( $start, $end ) = $archiver->date_range( $fi->startdate );
    my $at = $archiver->name;

    my $ctx = MT::Template::Context->new;
    $ctx->{current_archive_type}  = $at;
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

    if ( $archiver->category_based() ) {
        my $cat = MT->model('category')->load( $fi->category_id );
        $ctx->stash( 'archive_category', $cat );
    }
    elsif ( $archiver->author_based() ) {
        my $author = MT->model('author')->load( $fi->author_id );
        $ctx->stash( 'author', $author );
    }

    unless ($tmpl) {
        $tmpl = MT::Template->load( $fi->template_id )
            or return $app->errtrans( "Can't load template [_1]",
            $fi->template_id );
    }

    my $out = $tmpl->build($ctx)
        or return $app->errtrans( "Archive publishing failed: [_1]",
        $tmpl->errstr );

    $out;
}

sub _view_entry {
    my $app = shift;
    my ( $fi, $tmpl ) = @_;

    my $entry_id = $fi->entry_id;
    my $entry    = MT->model('entry')->load($entry_id)
        or return $app->errtrans( "Invalid entry ID [_1]", $entry_id );
    return $app->errtrans( "Entry [_1] is not published", $entry_id )
        unless $entry->status == MT::Entry::RELEASE();

    my $ctx = MT::Template::Context->new;
    $ctx->{current_archive_type} = $fi->archive_type;
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

    unless ($tmpl) {
        $tmpl = MT->model('template')->load( $fi->template_id )
            or return $app->errtrans( "Can't load template [_1]",
            $fi->template_id );
    }

    my $out = $tmpl->build( $ctx, \%cond )
        or return $app->errtrans( "Archive publishing failed: [_1]",
        $tmpl->errstr );

    $out;
}

sub _view_category {
    my $app = shift;
    my ( $fi, $tmpl ) = @_;

    my $cat_id = $fi->category_id;
    my $cat    = MT->model('category')->load($cat_id)
        or return $app->errtrans( "Invalid category ID '[_1]'", $cat_id );

    my $ctx = MT::Template::Context->new;
    $ctx->stash( 'archive_category', $cat );
    $ctx->{current_archive_type} = 'Category';

    require MT::Placement;
    my @entries = MT->model('entry')->load(
        {   blog_id => $app->{__blog_id},
            status  => MT::Entry::RELEASE()
        },
        {   'join' =>
                [ 'MT::Placement', 'entry_id', { category_id => $cat_id } ]
        }
    );
    $ctx->stash( 'entries', delay( sub { \@entries } ) );

    unless ($tmpl) {
        $tmpl = MT::Template->load( $fi->template_id )
            or return $app->errtrans( "Can't load template [_1]",
            $fi->template_id );
    }

    my $out = $tmpl->build($ctx)
        or return $app->errtrans( "Archive publishing failed: [_1]",
        $tmpl->errstr );

    $out;
}

sub _view_author {
    my $app = shift;
    my ( $fi, $tmpl ) = @_;

    my $author_id = $fi->author_id;
    my $author    = MT->model('author')->load($author_id)
        or return $app->errtrans( "Invalid author ID '[_1]'", $author_id );

    my $ctx = MT::Template::Context->new;
    $ctx->stash( 'author', $author );
    $ctx->{current_archive_type} = 'Author';

    my @entries = MT::Entry->load(
        {   blog_id   => $app->{__blog_id},
            author_id => $author_id,
            status    => MT::Entry::RELEASE()
        },
    );
    $ctx->stash( 'entries', delay( sub { \@entries } ) );

    unless ($tmpl) {
        $tmpl = MT::Template->load( $fi->template_id )
            or return $app->errtrans( "Can't load template [_1]",
            $fi->template_id );
    }

    my $out = $tmpl->build($ctx)
        or return $app->errtrans( "Archive publishing failed: [_1]",
        $tmpl->errstr );

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
