package MT::Feeds::Lite;
use strict;

use base qw( MT::ErrorHandler );

use URI;
use URI::Fetch;
use MT::Feeds::Lite::CacheMgr;
use MT::Util qw( encode_xml );

use vars qw( $VERSION );
$VERSION = '0.86';

my %Types = (
             'http://purl.org/rss/1.0/'               => 'rss',
             'http://my.netscape.com/rdf/simple/0.9/' => 'rss',
             'http://www.w3.org/2005/Atom'            => 'atom',
             'http://purl.org/atom/ns#'               => 'atom'
);

sub fetch {
    my ($class, $uri) = @_;
    $class->error('A URI is required.') unless $uri;
    $uri = URI->new($uri)->canonical;    # normalize
    my $rcache = get_request_cache();
    return $rcache->{$uri} if $rcache->{$uri};
    my $agent    = MT::Feeds::Lite::Agent->new;
    my $protcols = [qw(http https file)];
    $agent->protocols_allowed($protcols);
    my $proxy = MT->instance->config->PingProxy;
    $agent->proxy($protcols, $proxy) if $proxy;
    my $no_proxy = MT->instance->config->PingNoProxy;
    $agent->no_proxy(split(/,\s*/, $no_proxy)) if $no_proxy;
    my $timeout = MT->instance->config->PingTimeout;
    $agent->timeout($timeout) if $timeout;
    my $cache = MT::Feeds::Lite::CacheMgr->new;
    my %cfg = (
        Cache          => $cache,
        UserAgent      => $agent,
        CacheEntryGrep => \&process_fetch,
        Freeze => sub { $_[0] },    # pass-thru. PDO will handle this magic.
        Thaw => sub { $_[0] }       # ditto.
    );
    my $res = URI::Fetch->fetch($uri, %cfg)
      or return $class->error(URI::Fetch->errstr);
    $rcache->{$uri} = process_fetch($res)
      if $res->status eq URI::Fetch::URI_NOT_MODIFIED
      ;    # CacheEntryGrep doesn't run on not modified so we force it.
    unless ($rcache->{$uri}) {    # fetch was unsuccessful. revert to cache.
        if (my $cached = $cache->get($uri)) {
            $rcache->{$uri} = $class->new($cached->{Content})
              or warn "Cached $uri " . $class->errstr
              if $MT::DebugMode;
        }
        if ($rcache->{$uri}) {    # provide some feedback since we had issues.
            MT::log(
                    MT->translate(
                               'An error occurred processing [_1]. '
                                 . 'The previous version of the feed was used. '
                                 . 'A HTTP status of [_2] was returned.',
                               $uri,
                               $res->http_status
                    )
            );
        } else {
            MT::log(
                    MT->translate(
                         'An error occurred processing [_1]. '
                           . 'A previous version of the feed was not available.'
                           . 'A HTTP status of [_2] was returned.',
                         $uri,
                         $res->http_status
                    )
            );
        }
    }
    $rcache->{$uri};
}

#--- object methods

sub new {
    my ($class, $xml) = @_;
    my $self = bless {}, $class;
    MT::Util::init_sax(); # Make sure XML::SAX knows about available parsers
    require XML::Elemental;
    require XML::Elemental::Util;
    my $p = XML::Elemental->parser;
    my $tree;
    eval { $tree = $p->parse_string($xml) };
    return $class->error($@) if $@;
    my ($root) =
      grep { ref $_ eq 'XML::Elemental::Element' } @{$tree->contents};
    $self->{root} = $root;
    my ($name, $ns) = XML::Elemental::Util::process_name($root->name);
    $ns = 'http://purl.org/rss/1.0/'
      if $ns eq 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';    # rss 1.0
    $self->{type} = $Types{$ns} || 'rss';
    if ($self->{type} eq 'rss') {
        my ($feed) = nodelist($root, $ns, 'channel');
        if (!$feed && $ns eq 'http://purl.org/rss/1.0/') {        # rss 0.9
            $ns = 'http://my.netscape.com/rdf/simple/0.9/';
            ($feed) = nodelist($root, $ns, 'channel');
        }
        return $class->error('channel not found.') unless $feed;
        $self->{feed} = $feed;
    } else {    # atom, ah.
        $self->{feed} = $root;
    }
    $self->{ns} = $ns;
    $self;
}

sub ns   { $_[0]->{ns} }
sub type { $_[0]->{type} }
sub feed { $_[0]->{feed} }
sub root { $_[0]->{root} }

sub entries {
    my $self = shift;
    return $self->{entries} if $self->{entries};
    my $e = $self->{type} eq 'atom' ? 'entry' : 'item';
    my $from =
         $self->{ns} eq 'http://purl.org/rss/1.0/'
      || $self->{ns} eq 'http://my.netscape.com/rdf/simple/0.9/'
      ? $self->{root}
      : $self->{feed};
    my @entries = nodelist($from, $self->{ns}, $e);
    $self->{entries} = \@entries;
}

sub find_title {
    my ($self, $node) = @_;
    my ($title) = nodelist($node, $self->{ns}, 'title');
    if (   $title
        && $self->{type} eq 'atom'
        && defined $title->attributes->{'{}type'}
        && $title->attributes->{'{}type'} eq 'xhtml')
    {    # atom inline markup handler
        my ($div) =
          grep { ref $_ eq 'XML::Elemental::Element' } @{$title->contents};
        return join '',
          map { ref $_ eq 'XML::Elemental::Element' ? as_xhtml($_) : $_->data }
          @{$div->contents};   # generate markup while removing div from output.
    }
    unless ($title) {
        ($title) = nodelist($node, 'http://purl.org/dc/elements/1.1/', 'title');
    }
    $title ? $title->text_content : '';
}

sub find_link {
    my ($self, $node) = @_;
    if ($self->{type} eq 'atom') {
        my ($link) = grep {
            !defined $_->attributes->{'{}rel'}
              || $_->attributes->{'{}rel'} eq 'alternate'
        } nodelist($node, $self->{ns}, 'link');
        return $link ? $link->attributes->{'{}href'} : '';
    } else {
        my ($link) = nodelist($node, $self->{ns}, 'link');
        unless ($link) {
            if (   $self->{ns} eq 'http://purl.org/rss/1.0/'
                || $self->{ns} eq 'http://my.netscape.com/rdf/simple/0.9/')
            {    # rss 1.0 or 0.9 so check for @rdf:about
                $link =
                  $node->attributes->{
                    '{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about'};
            } elsif ($self->{ns} eq '') {    # rss 2.0 so check for guid
                my ($guid) = nodelist($node, '', 'guid');
                $link = $guid->text_content
                  if (!defined $guid->attributes->{isPermalink}
                      || $guid->attributes->{isPermalink} eq 'true');
            }
        } else {
            $link = $link->text_content;
        }
        return $link || '';
    }
}

#--- utility

sub get_request_cache {
    my $rcache;
    unless ($rcache = MT->request->stash('MT::Feeds::Lite')) {
        $rcache = {};
        MT->request->stash('MT::Feeds::Lite', $rcache);
    }
    $rcache;
}

# Used as the cache entry filter (CacheEntryGrep),
# this routine makes sure the content can be parsed and stops
# it from being cached if it cannot. This allows us to
# fallback on what is in the cache and presumably parsable.
# Not straight-forward, but it works.
sub process_fetch {
    my $res   = shift;
    my $class = __PACKAGE__;
    my $feed  = $class->new($res->content);
    MT::log($res->uri . " " . $class->errstr) if !$feed && $MT::DebugMode;
    return unless $feed;
    my $rcache = get_request_cache();
    $rcache->{$res->uri} = $feed;
}

sub nodelist {
    my ($node, $ns, $name) = @_;
    my @nodes =
      grep { ref($_) eq 'XML::Elemental::Element' && $_->name eq "{$ns}$name" }
      @{$node->contents};
    @nodes;
}

# This has its limitations, but should suffice
sub as_xhtml {
    my ($node) = @_;
    my $dumper;
    my $out = '';
    $dumper = sub {
        my $node = shift;
        return encode_xml($node->data)
          if (ref($node) eq 'XML::Elemental::Characters');

        # it must be an element then.
        my ($name, $ns) = XML::Elemental::Util::process_name($node->name);
        my $xml      = "<$name";
        my $a        = $node->attributes;
        my $children = $node->contents;
        foreach (keys %$a) {
            my ($aname, $ans) = XML::Elemental::Util::process_name($_);
            $xml .= " $aname=\"" . encode_xml($a->{$_}, 1) . "\"";
        }
        if ($children) {
            $xml .= '>';
            map { $xml .= $dumper->($_) } @$children;
            $xml .= "</$name>";
        } else {
            $xml .= '/>';
        }
        $xml;
    };
    $out .= $dumper->($node);
    $out;
}

package MT::Feeds::Lite::Agent;

use base qw( LWP::UserAgent );

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->SUPER::agent(join '/', $class, $MT::Feeds::Lite::VERSION);
    $self;
}

sub agent { $_[0]->{agent} }

1;
