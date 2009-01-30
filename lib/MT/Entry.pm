# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Entry;

use strict;

use MT::Tag; # Holds MT::Taggable
use base qw( MT::Object MT::Taggable MT::Scorable );

use MT::Blog;
use MT::Author;
use MT::Category;
use MT::Memcached;
use MT::Placement;
use MT::Comment;
use MT::TBPing;
use MT::Util qw( archive_file_for discover_tb start_end_period extract_domain
                 extract_domains weaken );

sub CATEGORY_CACHE_TIME () { 604800 } ## 7 * 24 * 60 * 60 == 1 week

__PACKAGE__->install_properties({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'blog_id' => 'integer not null',
        'status' => 'smallint not null',
        'author_id' => 'integer not null',
        'allow_comments' => 'boolean',
        'title' => 'string(255)',
        'excerpt' => 'text',
        'text' => 'text',
        'text_more' => 'text',
        'convert_breaks' => 'string(30)',
        'to_ping_urls' => 'text',
        'pinged_urls' => 'text',
        'allow_pings' => 'boolean',
        'keywords' => 'text',
        'tangent_cache' => 'text',
        'basename' => 'string(255)',
        'atom_id' => 'string(255)',
        'authored_on' => 'datetime',
        'week_number' => 'integer',
        'template_id' => 'integer',
        'comment_count' => 'integer',
        'ping_count' => 'integer',
        'junk_log' => 'string meta',
## Have to keep this around for use in mt-upgrade.cgi.
        'category_id' => 'integer',
    },
    indexes => {
        status => 1,
        author_id => 1,
        created_on => 1,
        modified_on => 1,
        authored_on => 1,
        # For lookups 
        blog_basename => {
            columns => [ 'blog_id', 'basename' ],
        },
        # Page listings are published in order by title
        title => 1,
        blog_author => {
            columns => [ 'blog_id', 'class', 'author_id', 'authored_on' ],
        },
        # For optimizing weekly archives, selected by blog, class,
        # status.
        blog_week => {
            columns => [ 'blog_id', 'class', 'status', 'week_number' ],
        },
        # For system-overview listings where we list all entries of
        # a particular class by authored on date
        class_authored => {
            columns => [ 'class', 'authored_on' ],
        },
        # For most blog-level listings, where we list all entries
        # in a blog with a particular class by authored on date.
        blog_authored => {
            columns => ['blog_id', 'class', 'authored_on'],
        },
        # For most publishing listings, where we list entries in a blog
        # with a particular class, publish status (2) and authored on date
        blog_stat_date => {
            columns => ['blog_id', 'class', 'status', 'authored_on', 'id'],
        },
        # for tag count
        tag_count => {
            columns => ['status', 'class', 'blog_id', 'id'],
        },
    },
    defaults => {
        comment_count => 0,
        ping_count => 0,
    },
    child_of => 'MT::Blog',
    child_classes => ['MT::Comment','MT::Placement','MT::Trackback','MT::FileInfo'],
    audit => 1,
    meta => 1,
    datasource => 'entry',
    primary_key => 'id',
    class_type => 'entry',
});

sub HOLD ()    { 1 }
sub RELEASE () { 2 }
sub REVIEW ()  { 3 }
sub FUTURE ()  { 4 }
sub JUNK ()    { 5 }

use Exporter;
*import = \&Exporter::import;
use vars qw( @EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK = qw( HOLD RELEASE FUTURE );
%EXPORT_TAGS = (constants => [ qw(HOLD RELEASE FUTURE) ]);

sub class_label {
    MT->translate("Entry");
}

sub class_label_plural {
    MT->translate("Entries");
}

sub container_type {
    return "category";
}

sub container_label {
    MT->translate("Category");
}

sub cache_key {
    my($entry_id, $key);
    if (@_ == 3) {
        ($entry_id, $key) = @_[1, 2];
    } else {
        ($entry_id, $key) = ($_[0]->id, $_[1]);
    }
    return sprintf "entry%s-%d", $key, $entry_id;
}

sub status_text {
    my $s = $_[0];
    $s == HOLD ? "Draft" :
        $s == RELEASE ? "Publish" :
            $s == REVIEW ? "Review" : 
                $s == FUTURE ? "Future" :
                    $s == JUNK ? "Spam" : '';
}

sub status_int {
    my $s = lc $_[0];   ## Lower-case it so that it's case-insensitive
    $s eq 'draft' ? HOLD :
        $s eq 'publish' ? RELEASE :
            $s eq 'review' ? REVIEW :
                $s eq 'future' ? FUTURE :
                    $s eq 'junk' ? JUNK : undef;
}

sub authored_on_obj {
    my $obj = shift;
    return $obj->column_as_datetime('authored_on');
}

sub next {
    my $entry = shift;
    my($opt) = @_;
    my $terms;
    if (ref $opt) {
        $terms = $opt;
    }
    else {
        $terms = $opt ? { status => RELEASE } : {};
    }
    $entry->_nextprev('next', $terms);
}

sub previous {
    my $entry = shift;
    my($opt) = @_;
    my $terms;
    if (ref $opt) {
        $terms = $opt;
    }
    else {
        $terms = $opt ? { status => RELEASE } : {};
    }
    $entry->_nextprev('previous', $terms);
}

sub _nextprev {
    my $obj = shift;
    my $class = ref($obj);
    my ($direction, $terms) = @_;
    return undef unless ($direction eq 'next' || $direction eq 'previous');
    my $next = $direction eq 'next';

    $terms->{author_id} = $obj->author_id if delete $terms->{by_author};
    if (delete $terms->{by_category}) {
        if (my $c = $obj->category) {
            $terms->{category_id} = $c->id;
        }
        else {
            return undef;
        }
    }

    my $label = '__' . $direction;
    $label .= ':author='. $terms->{author_id} if exists $terms->{author_id};
    $label .= ':category='. $terms->{category_id} if exists $terms->{category_id};
    return $obj->{$label} if $obj->{$label};

    my $args = {};
    if (my $cat_id = delete $terms->{category_id}) {
        my $join = MT::Placement->join_on('entry_id',
            { category_id => $cat_id }
        );
        $args->{join} = $join;
    }

    my $o = $obj->nextprev(
        direction => $direction,
        terms     => { blog_id => $obj->blog_id, class => $obj->class, %$terms },
        args      => $args,
        by        => 'authored_on',
    );
    weaken($obj->{$label} = $o) if $o;
    return $o;
}

sub trackback {
    my $entry = shift;
    $entry->cache_property('trackback', sub {
        require MT::Trackback;
        if ($entry->id) {
            return scalar MT::Trackback->load({ entry_id => $entry->id });
        }
    }, @_);
}

sub author {
    my $entry = shift;
    $entry->cache_property('author', sub {
        return undef unless $entry->author_id;
        my $req = MT::Request->instance();
        my $author_cache = $req->stash('author_cache');
        my $author = $author_cache->{$entry->author_id};
        unless ($author) {
            require MT::Author;
            $author = MT::Author->load($entry->author_id)
                or return undef;
            $author_cache->{$entry->author_id} = $author;
            $req->stash('author_cache', $author_cache);
        }
        $author;
    });
}

sub __load_category_data {
    my $entry = shift;
    my $t = MT->get_timer;
    $t->pause_partial if $t;
    my $cache = MT::Memcached->instance;
    my $memkey = $entry->cache_key('categories');
    my $rows;
    unless ($rows = $cache->get($memkey)) {
        require MT::Placement;
        my @maps = MT::Placement->search({ entry_id => $entry->id });
        $rows = [ map { [ $_->category_id, $_->is_primary ] } @maps ];
        $cache->set($memkey, $rows, CATEGORY_CACHE_TIME);
    }
    $t->mark('MT::Entry::__load_category_data') if $t;
    return $rows;
}

sub flush_category_cache {
    my($copy, $place) = @_;
    MT::Memcached->instance->delete(
        MT::Entry->cache_key($place->entry_id, 'categories')
    );
}

MT::Placement->add_trigger(
    post_save   => \&flush_category_cache,
    post_remove => \&flush_category_cache
);

sub category {
    my $entry = shift;
    $entry->cache_property('category', sub {
        my $rows = $entry->__load_category_data or return;
        my @rows = grep { $_->[1] } @$rows or return;
        require MT::Category;
        return MT::Category->lookup( $rows[0] );
    });
}

sub categories {
    my $entry = shift;
    $entry->cache_property('categories', sub {
        my $rows = $entry->__load_category_data or return;
        my $cats = MT::Category->lookup_multi([ map { $_->[0] } @$rows ]);
        my @cats = sort { $a->label cmp $b->label } @$cats;
        return \@cats;
    });
}

sub is_in_category {
    my $entry = shift;
    my($cat) = @_;
    my $cats = $entry->categories;
    for my $c (@$cats) {
        return 1 if $c->id == $cat->id;
    }
    0;
}

sub comments {
    my $entry = shift;
    my ($terms, $args) = @_;
    require MT::Comment;
    if ($terms || $args) {
        $terms ||= {};
        $terms->{entry_id} = $entry->id;
        return [ MT::Comment->load( $terms, $args ) ];
    } else {
        $entry->cache_property('comments', sub {
            [ MT::Comment->load({ entry_id => $entry->id }) ];
        });
    }
}

sub comment_latest {
    my $entry = shift;
    $entry->cache_property('comment_latest', sub {
        require MT::Comment;
        MT::Comment->load({
            entry_id => $entry->id,
            visible => 1
        }, {
            'sort' => 'created_on',
            direction => 'descend',
            limit => 1,
        });
    });
}

MT::Comment->add_trigger(
    post_save => sub {
        my $comment = shift;
        my $entry   = MT::Entry->load( $comment->entry_id )
            or return;
        my $count   = MT::Comment->count(
            {
                entry_id => $comment->entry_id,
                visible  => 1,
            }
        );
        $entry->comment_count($count);
        $entry->save;
    }
);

MT::Comment->add_trigger(
    post_remove => sub {
        my $comment = shift;
        my $entry   = MT::Entry->load( $comment->entry_id )
            or return;
        if ( $comment->visible ) {
            my $count = $entry->comment_count > 0 ? $entry->comment_count - 1 : 0;
            $entry->comment_count($count);
            $entry->save;
        }
    }
);

sub pings {
    my $entry = shift;
    my ($terms, $args) = @_;
    my $tb = $entry->trackback;
    return undef unless $tb;
    if ($terms || $args) {
        $terms ||= {};
        $terms->{tb_id} = $tb->id;
        return [ MT::TBPing->load( $terms, $args ) ];
    } else {
        $entry->cache_property('pings', sub {
            [ MT::TBPing->load({ tb_id => $tb->id }) ];
        });
    }
}

MT::TBPing->add_trigger(
    post_save => sub {
        my $ping = shift;
        require MT::Trackback;
        if ( my $tb = MT::Trackback->load( $ping->tb_id ) ) {
            if ( $tb->entry_id ) {
                my $entry = MT::Entry->load( $tb->entry_id )
                    or return;
                my $count = MT::TBPing->count(
                    {
                        tb_id   => $tb->id,
                        visible => 1,
                    }
                );
                $entry->ping_count($count);
                $entry->save;
            }
        }
    }
);

MT::TBPing->add_trigger(
    post_remove => sub {
        my $ping = shift;
        require MT::Trackback;
        if ( my $tb = MT::Trackback->load( $ping->tb_id ) ) {
            if ( $tb->entry_id && $ping->visible ) {
                my $entry = MT::Entry->load( $tb->entry_id )
                    or return;
                my $count = $entry->ping_count > 0 ? $entry->ping_count - 1 : 0;
                $entry->ping_count($count);
                $entry->save;
            }
        }
    }
);

sub archive_file {
    my $entry = shift;
    my($at) = @_;
    my $blog = $entry->blog() || return;
    unless ($at) {
        $at = $blog->archive_type_preferred || $blog->archive_type;
        return '' if !$at || $at eq 'None';
        return '' if $at eq 'Page';
        my %at = map { $_ => 1 } split /,/, $at;
        # FIXME: should draw from list of registered archive types
        for my $tat (qw( Individual Daily Weekly Author-Monthly Category-Monthly Monthly Category )) {
            $at = $tat if $at{$tat};
            last;
        }
    }
    archive_file_for($entry, $blog, $at);
}

sub archive_url {
    my $entry = shift;
    my $blog = $entry->blog() || return;
    my $url = $blog->archive_url || "";
    $url .= '/' unless $url =~ m!/$!;
    $url . $entry->archive_file(@_);
}

sub permalink {
    my $entry = shift;
    my $blog = $entry->blog() || return;
    my $url = $entry->archive_url($_[0]);
    my $effective_archive_type = ($_[0]
        || $blog->archive_type_preferred
        || $blog->archive_type);
    $url .= '#' . ($_[1]->{valid_html} ? 'a' : '') . 
        sprintf("%06d", $entry->id)
        unless ($effective_archive_type eq 'Individual' 
        || $_[1]->{no_anchor});
    $url;
}

sub all_permalinks {
    my $entry = shift;
    my $blog = $entry->blog || return;
    my @at = split /,/, $blog->archive_type;
    return unless @at;
    my @urls;
    for my $at (@at) {
        push @urls, $entry->permalink($at);
    }
    @urls;
}

sub text_filters {
    my $entry = shift;
    my $filters = $entry->convert_breaks;
    if (!defined $filters) {
        my $blog = $entry->blog() || return [];
        $filters = $blog->convert_paras;
    }
    return [] unless $filters;
    if ($filters eq '1') {
        return [ '__default__' ];
    } else {
        return [ split /\s*,\s*/, $filters ];
    }
}

sub get_excerpt {
    my $entry = shift;
    my($words) = @_;
    return $entry->excerpt if $entry->excerpt;
    my $excerpt = MT->apply_text_filters($entry->text, $entry->text_filters);
    my $blog = $entry->blog() || return;
    MT::I18N::first_n_text($excerpt, $words || $blog->words_in_excerpt || MT::I18N::const('DEFAULT_LENGTH_ENTRY_EXCERPT')) . '...';
}

sub pinged_url_list {
    my $entry = shift;
    my (%param) = @_;
    my $include_failures = $param{Failures} || $param{OnlyFailures};
    my $exclude_successes = $param{OnlyFailures};
    my $urls = $entry->pinged_urls;
    return [] unless $urls && $urls =~ /\S/;
    my %urls = map { $_ => 1 } split /\r?\n/, $urls;
    my %to_ping = map { $_ => 1 } @{ $entry->to_ping_url_list };
    foreach (keys %to_ping) {
        delete $urls{$_} if exists $urls{$_};
    }
    my @urls = keys %urls;
    foreach (@urls) {
        if (m/^([^ ]+) /) {
            delete $urls{$_}; # remove ones with error messages
            $urls{$1} = 1 if $include_failures;
        } else {
            delete $urls{$_} if $exclude_successes;
        }
    }
    [ keys %urls ];
}

sub to_ping_url_list {
    my $entry = shift;
    my $urls = $entry->to_ping_urls;
    return [] unless $urls && $urls =~ /\S/;
    [ split /\r?\n/, $urls ];
}

# TBD: Write a test for this routine
sub make_atom_id {
    my $entry = shift;

    my $blog = $entry->blog;
    my ($host, $year, $path, $blog_id, $entry_id);
    $blog_id = $blog->id;
    $entry_id = $entry->id;
    my $url = $blog->site_url || '';
    return unless $url;
    $url .= '/' unless $url =~ m!/$!;
    if ($url && ($url =~ m!^https?://([^/:]+)(?::\d+)?(/.*)$!)) {
        $host = $1;
        $path = $2;
    }
    if ($entry->authored_on && ($entry->authored_on =~ m/^(\d{4})/)) {
        $year = $1;
    }
    return unless $host && $year && $path && $blog_id && $entry_id;
    qq{tag:$host,$year:$path/$blog_id.$entry_id};
}

sub discover_tb_from_entry {
    my $entry = shift;
    ## If we need to auto-discover TrackBack ping URLs, do that here.
    my $cfg = MT->config;
    my $blog = $entry->blog();
    my $send_tb = $cfg->OutboundTrackbackLimit;
    if ($send_tb ne 'off' && 
        $blog && ($blog->autodiscover_links
                  || $blog->internal_autodiscovery)) {
        my @tb_domains;
        if ($send_tb eq 'selected') {
            @tb_domains = $cfg->OutboundTrackbackDomains;
        } elsif ($send_tb eq 'local') {
            my $iter = MT::Blog->load_iter(undef, { fetchonly => ['site_url'], no_triggers => 1 });
            while (my $b = $iter->()) {
                next if $b->id == $blog->id;
                push @tb_domains, extract_domain($b->site_url);
            }
        }
        my $tb_domains;
        if (@tb_domains) {
            $tb_domains = '';
            my %seen;
            foreach (@tb_domains) {
                next unless $_;
                $_ = lc($_);
                next if $seen{$_};
                $tb_domains .= '|' if $tb_domains ne '';
                $tb_domains .= quotemeta($_);
                $seen{$_} = 1;
            }
            $tb_domains = '(' . $tb_domains . ')' if $tb_domains;
        }
        my $archive_domain;
        ($archive_domain) = extract_domains($blog->archive_url);
        my %to_ping = map { $_ => 1 } @{ $entry->to_ping_url_list };
        my %pinged = map { $_ => 1 } @{ $entry->pinged_url_list(IncludeFailures => 1) };
        my $body = $entry->text . ($entry->text_more || "");
        $body = MT->apply_text_filters($body, $entry->text_filters);
        while ($body =~ m!<a\s.*?\bhref\s*=\s*(["']?)([^'">]+)\1!gsi) {
            my $url = $2;
            my $url_domain;
            ($url_domain) = extract_domains($url);
            if ($url_domain =~ m/\Q$archive_domain\E$/i) {
                next if !$blog->internal_autodiscovery;
            } else {
                next if !$blog->autodiscover_links;
            }
            next if $tb_domains && lc($url_domain) !~ m/$tb_domains$/;
            if (my $item = discover_tb($url)) {
                $to_ping{ $item->{ping_url} } = 1
                    unless $pinged{$item->{ping_url}};
            }
        }
        $entry->to_ping_urls(join "\n", keys %to_ping);
    }
}

sub sync_assets {
    my $entry = shift;
    my $text = ($entry->text || '') . "\n" . ($entry->text_more || '');

    require MT::ObjectAsset;
    my @assets = MT::ObjectAsset->load({
        object_id => $entry->id,
        blog_id => $entry->blog_id,
        object_ds => $entry->datasource,
        embedded => 1,
    });
    my %assets = map { $_->asset_id => $_->id } @assets;
    while ($text =~ m!<form[^>]*?\smt:asset-id=["'](\d+)["'][^>]*?>(.+?)</form>!gis) {
        my $id = $1;
        my $innards = $2;

        # reference to an existing asset...
        if (exists $assets{$id}) {
            $assets{$id} = 0;
        } else {
            # is asset exists?
            my $asset = MT->model('asset')->load({ id => $id }) or next;

            my $map = new MT::ObjectAsset;
            $map->blog_id($entry->blog_id);
            $map->asset_id($id);
            $map->object_ds($entry->datasource);
            $map->object_id($entry->id);
            $map->embedded(1);
            $map->save;
            $assets{$id} = 0;
        }
    }
    if (my @old_maps = grep { $assets{$_->asset_id} } @assets) {
        my @old_ids = map { $_->id } grep { $_->embedded } @old_maps;
        MT::ObjectAsset->remove( { id => \@old_ids })
            if @old_ids;
    }
    return 1;
}

sub save {
    my $entry = shift;
    my $is_new = $entry->id ? 0 : 1;

    ## If there's no basename specified, create a unique basename.
    if (!defined($entry->basename) || ($entry->basename eq '')) {
        my $name = MT::Util::make_unique_basename($entry);
        $entry->basename($name);
    }
    if (!$entry->id && !$entry->authored_on) {
        my @ts = MT::Util::offset_time_list(time, $entry->blog_id);
        my $ts = sprintf '%04d%02d%02d%02d%02d%02d',
            $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
        $entry->authored_on($ts);
    }
    if (my $dt = $entry->authored_on_obj) {
        my ($yr, $w) = $dt->week;
        $entry->week_number($yr * 100 + $w);
    }

    my $sync_assets = $entry->is_changed('text')
        || $entry->is_changed('text_more');

    unless ($entry->SUPER::save(@_)) {
        print STDERR "error during save: " . $entry->errstr . "\n";
        die $entry->errstr;
    }

    $entry->sync_assets() if $sync_assets;

    if (!$entry->atom_id && (($entry->status || 0) != HOLD)) {
        $entry->atom_id($entry->make_atom_id());
        $entry->SUPER::save(@_) if $entry->atom_id;
    }

    ## If pings are allowed on this entry, create or update
    ## the corresponding TrackBack object for this entry.
    require MT::Trackback;
    if ($entry->allow_pings) {
        my $tb;
        unless ($tb = $entry->trackback) {
            $tb = MT::Trackback->new;
            $tb->blog_id($entry->blog_id);
            $tb->entry_id($entry->id);
            $tb->category_id(0);   ## category_id can't be NULL
        }
        $tb->title($entry->title);
        $tb->description($entry->get_excerpt);
        $tb->url($entry->permalink);
        $tb->is_disabled(0);
        $tb->save
            or return $entry->error($tb->errstr);
        $entry->trackback($tb);
    } else {
        ## If there is a TrackBack item for this entry, but
        ## pings are now disabled, make sure that we mark the
        ## object as disabled.
        if (my $tb = $entry->trackback) {
            $tb->is_disabled(1);
            $tb->save
                or return $entry->error($tb->errstr);
        }
    }

    $entry->clear_cache() if $is_new;

    1;
}

sub remove {
    my $entry = shift;
    if (ref $entry) {
        $entry->remove_children({ key => 'entry_id' }) or return;

        # Remove MT::ObjectAsset records
        my $class = MT->model('objectasset');
        $class->remove({ object_id => $entry->id, object_ds => $entry->class_type });
    }

    $entry->SUPER::remove(@_);
}

sub blog {
    my ($entry) = @_;
    $entry->cache_property('blog', sub {
        my $blog_id = $entry->blog_id;
        require MT::Blog;
        MT::Blog->load($blog_id) or
            $entry->error(MT->translate(
            "Load of blog '[_1]' failed: [_2]", $blog_id, MT::Blog->errstr
                || MT->translate("record does not exist.")));
    });
}

sub to_hash {
    my $entry = shift;
    my $hash = $entry->SUPER::to_hash(@_);

    $hash->{'entry.text_html'} = sub { MT->apply_text_filters($entry->text, $entry->text_filters) };
    $hash->{'entry.text_more_html'} = sub { MT->apply_text_filters($entry->text_more, $entry->text_filters) };
    $hash->{'entry.permalink'} = $entry->permalink;
    $hash->{'entry.status_text'} = $entry->status_text;
    $hash->{'entry.status_is_' . $entry->status} = 1;
    $hash->{'entry.created_on_iso'} = sub { MT::Util::ts2iso($entry->blog_id, $entry->created_on) };
    $hash->{'entry.modified_on_iso'} = sub { MT::Util::ts2iso($entry->blog_id, $entry->modified_on) };
    $hash->{'entry.authored_on_iso'} = sub { MT::Util::ts2iso($entry->blog_id, $entry->authored_on) };

    # Populate author info
    my $auth = $entry->author or return $hash;
    my $auth_hash = $auth->to_hash;
    $hash->{"entry.$_"} = $auth_hash->{$_} foreach keys %$auth_hash;

    $hash;
}

#trans('Draft')
#trans('Review')
#trans('Future')
#trans('Spam')

1;
__END__

=head1 NAME

MT::Entry - Movable Type entry record

=head1 SYNOPSIS

    use MT::Entry;
    my $entry = MT::Entry->new;
    $entry->blog_id($blog->id);
    $entry->status(MT::Entry::RELEASE());
    $entry->author_id($author->id);
    $entry->title('My title');
    $entry->text('Some text');
    $entry->save
        or die $entry->errstr;

=head1 DESCRIPTION

An I<MT::Entry> object represents an entry in the Movable Type system. It
contains all of the metadata about the entry (author, status, category, etc.),
as well as the actual body (and extended body) of the entry.

=head1 USAGE

As a subclass of I<MT::Object>, I<MT::Entry> inherits all of the
data-management and -storage methods from that class; thus you should look
at the I<MT::Object> documentation for details about creating a new object,
loading an existing object, saving an object, etc.

The following methods are unique to the I<MT::Entry> interface:

=head2 $entry->next

Loads and returns the next entry, where "next" is defined as the next record
in ascending chronological order (the entry posted after the current entry).
entry I<$entry>).

Returns an I<MT::Entry> object representing this next entry; if there is not
a next entry, returns C<undef>.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->previous

Loads and returns the previous entry, where "previous" is defined as the
previous record in ascending chronological order (the entry posted before the
current entry I<$entry>).

Returns an I<MT::Entry> object representing this previous entry; if there is
not a next entry, returns C<undef>.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->author

Returns an I<MT::Author> object representing the author of the entry
I<$entry>. If the author record has been removed, returns C<undef>.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->category

Returns an I<MT::Category> object representing the primary category of the
entry I<$entry>. If a primary category has not been assigned, returns
C<undef>.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->categories

Returns a reference to an array of I<MT::Category> objects representing the
categories to which the entry I<$entry> has been assigned (both primary and
secondary categories). If the entry has not been assigned to any categories,
returns a reference to an empty array.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->is_in_category($cat)

Returns true if the entry I<$entry> has been assigned to entry I<$cat>, false
otherwise.

=head2 $entry->comments

Returns a reference to an array of I<MT::Comment> objects representing the
comments made on the entry I<$entry>. If no comments have been made on the
entry, returns a reference to an empty array.

Caches the return value internally so that subsequent calls will not have to
re-query the database.

=head2 $entry->archive_file([ $archive_type ])

Returns the name of/path to the archive file for the entry I<$entry>. If
I<$archive_type> is not specified, and you are using multiple archive types
for your blog, the path is created from the preferred archive type that you
have selected. If I<$archive_type> is specified, it should be one of the
following values: C<Individual>, C<Daily>, C<Weekly>, C<Monthly>, and
C<Category>.

=head2 $entry->archive_url([ $archive_type ])

Returns the absolute URL to the archive page for the entry I<$entry>. This
calls I<archive_file> internally, so if I<$archive_type> is specified, it
is merely passed through to that method. In other words, this is the
blog Archive URL plus the results of I<archive_file>.

=head2 $entry->permalink([ $archive_type ])

Returns the (smart) permalink for the entry I<$entry>. Internally this calls
I<archive_url>, which calls I<archive_file>, so I<$archive_type> (if
specified) is merely passed through to that method. The result of this
method is the same as I<archive_url> plus the URI fragment
(C<#entry_id>), unless the preferred archive type is Individual, in which
case the two methods give exactly the same results.

=head2 $entry->text_filters

Returns a reference to an array of text filter keynames (the short names
that are the first argument to I<MT::add_text_filter>. This list can be
passed directly in as the second argument to I<MT::apply_text_filters>.

=head1 DATA ACCESS METHODS

The I<MT::Entry> object holds the following pieces of data. These fields can
be accessed and set using the standard data access methods described in the
I<MT::Object> documentation.

=over 4

=item * id

The numeric ID of the entry.

=item * blog_id

The numeric ID of the blog in which this entry has been posted.

=item * author_id

The numeric ID of the author who posted this entry.

=item * status

The status of the entry, either Publish (C<2>) or Draft (C<1>).

=item * allow_comments

An integer flag specifying whether comments are allowed on this entry. This
setting determines whether C<E<lt>MTEntryIfAllowCommentsE<gt>> containers are
displayed for this entry. Possible values are 0 for not allowing any additional 
comments and 1 for allowing new comments to be made on the entry.

=item * convert_breaks

A boolean flag specifying whether line and paragraph breaks should be converted
when rebuilding this entry.

=item * title

The title of the entry.

=item * excerpt

The excerpt of the entry.

=item * text

The main body text of the entry.

=item * text_more

The extended body text of the entry.

=item * created_on

The timestamp denoting when the entry record was created, in the format
C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted for the
selected timezone.

=item * modified_on

The timestamp denoting when the entry record was last modified, in the
format C<YYYYMMDDHHMMSS>. Note that the timestamp has already been adjusted
for the selected timezone.

=back

=head1 DATA LOOKUP

In addition to numeric ID lookup, you can look up or sort records by any
combination of the following fields. See the I<load> documentation in
I<MT::Object> for more information.

=over 4

=item * blog_id

=item * status

=item * author_id

=item * created_on

=item * modified_on

=back

=head1 NOTES

=over 4

=item *

When you remove an entry using I<MT::Entry::remove>, in addition to removing
the entry record, all of the comments and placements (I<MT::Comment> and
I<MT::Placement> records, respectively) for this entry will also be removed.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
