# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::App::Viewer;
use strict;

use MT::App;
@MT::App::Viewer::ISA = qw( MT::App );

use MT::Entry;
use MT::Template;
use MT::Template::Context;
use MT::Promise qw(delay);

use constant INDEX => 'Main Index';

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(main => \&view);
    $app->{default_mode} = 'main';
    $app;
}

sub view {
    my $app = shift;
    return $app->error($app->translate("This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it."))
        if $app->{cfg}->SafeMode;

    my $R = MT::Request->instance;
    $R->stash('live_view', 1);

    ## Process the path info.
    my $uri = $app->path_info;
    unless ($uri =~ s!^/(\d+)!!) {
        return $app->error($app->translate("No blog_id"));
    }
    my $blog_id = $1;

    ## Check ExcludeBlogs and IncludeBlogs to see if this blog is
    ## private or not.
    my $cfg = $app->{cfg};
    my %okay;
    for my $type (qw( IncludeBlogs ExcludeBlogs )) {
        if (my $list = $cfg->$type()) {
            $okay{$type} = { map { $_ => 1 } split /\s*,\s*/, $list };
        }
    }
    if (keys %{ $okay{IncludeBlogs} }) {
        return $app->error($app->translate("Not allowed to view blog [_1]", $blog_id))
            unless $okay{IncludeBlogs}{$blog_id};
    }
    if (keys %{ $okay{ExcludeBlogs} }) {
        return $app->error($app->translate("Not allowed to view blog [_1]", $blog_id))
            if $okay{ExcludeBlogs}{$blog_id};
    }
    $app->{__blog_id} = $blog_id;

    require MT::Blog;
    my $blog = $app->{__blog} = MT::Blog->load($blog_id)
        or return $app->error($app->translate("Loading blog with ID [_1] failed", $blog_id));

    if (!$uri || $uri eq '/') {
        return $app->_view_index;
    } elsif ($uri =~ m!^/archives/(.*)$!) {
        return $app->_view_date_archive($1);
    } elsif ($uri =~ m!^/entry/(\d+)(?:/([^/]+))?/?$!) {
        return $app->_view_entry($1, $2);
    } elsif ($uri =~ m!^/section/(\d+)/?$!) {
        return $app->_view_section($1);
    } else {
        return $app->_view_index($uri);
    }
}

my %MimeTypes = (
    css => 'text/css',
    txt => 'text/plain',
    rdf => 'text/xml',
    rss => 'text/xml',
    xml => 'text/xml',
);

sub _view_index {
    my $app = shift;
    my($uri) = @_;
    my $q = $app->{query};
    my $tmpl;
    if ($uri) {
        $uri =~ s!^/!!;
        my $iter = MT::Template->load_iter({ blog_id => $app->{__blog_id} });
        while (my $t = $iter->()) {
            $tmpl = $t, last
                if $t->type eq 'index' && $t->outfile eq $uri;
        }
    } else {
        $tmpl = MT::Template->load({ blog_id => $app->{__blog_id},
                                     name => INDEX });
    }
## xxx 404?
    return $app->error($app->translate("Can't load '[_1]' template.", $uri || INDEX))
        unless $tmpl;

    my($limit, $offset) = map $q->param($_), qw( limit offset );
    my $ctx = MT::Template::Context->new;
    if ($limit || $offset) {
        $limit ||= 20;
        my %arg = (
            'sort' => 'created_on',
            direction => 'descend',
            limit => $limit,
            ($offset ? (offset => $offset) : ()),
        );
        my @entries = MT::Entry->load({ blog_id => $app->{__blog_id},
            status => MT::Entry::RELEASE() }, \%arg);
        $ctx->stash('entries', delay(sub{\@entries}));
    }
    my $out = $tmpl->build($ctx)
        or return $app->error($app->translate("Building template failed: [_1]", $tmpl->errstr));
    (my $ext = $tmpl->outfile) =~ s/.*\.//;
    my $mime = $MimeTypes{$ext} || 'text/html';
    $app->send_http_header($mime);
    $app->print($out);
    $app->{no_print_body} = 1;
    1;
}

sub _view_date_archive {
    my $app = shift;
    my($spec) = @_;
    my($start, $end, $at);
    my $ctx = MT::Template::Context->new;
    if ($spec =~ m!^(\d{4})/(\d{2})/(\d{2})!) {
        my($y, $m, $d) = ($1, $2, $3);
        ($start, $end) = ($y . $m . $d . '000000', $y . $m . $d . '235959');
        $at = $ctx->{current_archive_type} = 'Daily';
    } elsif ($spec =~ m!^(\d{4})/(\d{2})!) {
        my($y, $m) = ($1, $2);
        my $days = MT::Util::days_in($m, $y);
        ($start, $end) = ($1 . $2 . '01000000', $1 . $2 . $days . '235959');
        $at = $ctx->{current_archive_type} = 'Monthly';
    } elsif ($spec =~ m!^week/(\d{4})/(\d{2})/(\d{2})!) {
        my($y, $m, $d) = ($1, $2, $3);
        ($start, $end) = MT::Util::start_end_week("$1$2${3}000000", $app->{__blog});
        $at = $ctx->{current_archive_type} = 'Weekly';
    } else {
        return $app->error($app->translate("Invalid date spec"));
    }
    $ctx->{current_timestamp} = $start;
    $ctx->{current_timestamp_end} = $end;
    my @entries = MT::Entry->load({ created_on => [ $start, $end ],
                                    blog_id => $app->{__blog_id},
                                    status => MT::Entry::RELEASE() },
                                  { range => { created_on => 1 } });
    $ctx->stash('entries', delay(sub{\@entries})) ;
    require MT::TemplateMap;
    my $map = MT::TemplateMap->load({ archive_type => $at,
                                      blog_id => $app->{__blog_id},
                                      is_preferred => 1 });
    my $tmpl = MT::Template->load($map->template_id)
        or return $app->error($app->translate("Can't load template [_1]", $map->template_id));
    my $out = $tmpl->build($ctx)
        or return $app->error($app->translate("Building archive failed: [_1]", $tmpl->errstr));
    $out;
}

sub _view_entry {
    my $app = shift;
    my($entry_id, $template) = @_;
    my $entry = MT::Entry->load($entry_id)
        or return $app->error($app->translate("Invalid entry ID [_1]", $entry_id));
    return $app->error($app->translate("Entry [_1] is not published", $entry_id))
        unless $entry->status == MT::Entry::RELEASE();
    my $ctx = MT::Template::Context->new;
    $ctx->{current_archive_type} = 'Individual';
    $ctx->{current_timestamp} = $entry->created_on;
    $ctx->stash('entry', $entry);
    my %cond = (
        EntryIfAllowComments => $entry->allow_comments,
        EntryIfCommentsOpen => $entry->allow_comments eq '1',
        EntryIfAllowPings => $entry->allow_pings,
        EntryIfExtended => $entry->text_more ? 1 : 0,
    );
    require MT::TemplateMap;
    my $tmpl;
    if($template) {
        $tmpl = MT::Template->load({ name => $template,
                                     blog_id => $app->{__blog_id} })
            or return $app->error($app->translate("Can't load template [_1]", $template));
    } else {
        my $map = MT::TemplateMap->load({ archive_type => 'Individual',
                                          blog_id => $app->{__blog_id},
                                          is_preferred => 1 });
        $tmpl = MT::Template->load($map->template_id)
            or return $app->error($app->translate("Can't load template [_1]", $map->template_id));
    }
    my $out = $tmpl->build($ctx, \%cond)
        or return $app->error($app->translate("Building archive failed: [_1]", $tmpl->errstr));
    $out;
}

sub _view_section {
    my $app = shift;
    my($cat_id) = @_;
    require MT::Category;
    my $cat = MT::Category->load($cat_id)
        or return $app->error($app->translate("Invalid category ID '[_1]'", $cat_id));
    my($start, $end, $at);
    my $ctx = MT::Template::Context->new;
    $ctx->stash('archive_category', $cat);
    $ctx->{current_archive_type} = 'Category';
    require MT::Placement;
    my @entries = MT::Entry->load({ blog_id => $app->{__blog_id},
                                    status => MT::Entry::RELEASE() },
                     { 'join' => [ 'MT::Placement', 'entry_id',
                                 { category_id => $cat_id } ] });
    $ctx->stash('entries', delay(sub{\@entries}));
    require MT::TemplateMap;
    my $map = MT::TemplateMap->load({ archive_type => 'Category',
                                      blog_id => $app->{__blog_id},
                                      is_preferred => 1 });
    my $tmpl = MT::Template->load($map->template_id)
        or return $app->error($app->translate("Can't load template [_1]", $map->template_id));
    my $out = $tmpl->build($ctx)
        or return $app->error($app->translate("Building archive failed: [_1]", $tmpl->errstr));
    $out;
}

1;
