# Copyright 2002-2006 Appnel Internet Solutions, LLC
# This code is distributed with permission by Six Apart
package MT::Feeds::Find; # Large parts sampled from Feed::Find.
use strict;

use base qw( MT::ErrorHandler );
use LWP::UserAgent;
use URI;

eval { require HTML::Parser };
our $html_parser = !$@;

use vars qw( $VERSION );
$VERSION = '1.0';

use constant FEED_MIME_TYPES => [
                                 'application/x.atom+xml',
                                 'application/atom+xml',
                                 'application/xml',
                                 'text/xml',
                                 'application/rss+xml',
                                 'application/rdf+xml',
];

our $FEED_EXT = qr/\.(?:atom|rss|xml|rdf)$/;
our %IsFeed   = map { $_ => 1 } @{FEED_MIME_TYPES()};

sub find {
    my $class = shift;
    my ($uri) = @_;
    my $ua    = LWP::UserAgent->new;
    $ua->agent(join '/', $class, $class->VERSION);
    $ua->parse_head(0);    ## We're already basically doing this ourselves.
    my $req = HTTP::Request->new(GET => $uri);
    my $p =
      $html_parser
      ? HTML::Parser->new(api_version => 3,
                          start_h     => [\&_find_links, 'self,tagname,attr'])
      : MT::Feeds::Find::Parser->new(\&_find_links);
    $p->{base_uri} = $uri;
    $p->{feeds}    = [];
    my $res = $ua->request(
        $req,
        sub {
            my ($chunk, $res, $proto) = @_;
            if ($IsFeed{$res->content_type}) {
                my $data = {uri => $uri};
                push @{$p->{feeds}}, $data;
                die "Done parsing";
            }
            $p->parse($chunk) or die "Done parsing";
        }
    );
    return $class->error($res->status_line) unless $res->is_success;
    @{$p->{feeds}};
}

sub _find_links {
    my ($p, $tag, $attr) = @_;
    my $base_uri = $p->{base_uri};
    if ($tag eq 'link') {
        return unless $attr->{rel};
        my %rel = map { $_ => 1 } split /\s+/, lc($attr->{rel});
        (my $type = lc $attr->{type}) =~ s/^\s*//;
        $type =~ s/\s*$//;
        my $data = {
            uri => URI->new_abs($attr->{href}, $base_uri)->as_string,
            title => $attr->{title} || $attr->{href}
        };
        push @{$p->{feeds}}, $data
          if $IsFeed{$type}
          && ($rel{alternate} || $rel{'service.feed'});
    } elsif ($tag eq 'base') {
        $p->{base_uri} = $attr->{href} if $attr->{href};
    } elsif ($tag =~ /^(?:meta|isindex|title|script|style|head|html)$/) {
        ## Ignore other valid tags inside of <head>.
    } elsif ($tag eq 'a') {
        my $href = $attr->{href} or return;
        my $uri = URI->new($href);
        my $data = {
            uri => URI->new_abs($href, $base_uri)->as_string,
            title => $attr->{title} || $href
        };
        push @{$p->{feeds}}, $data
          if $uri->path =~ /$FEED_EXT/io;
    } else {
        ## Anything else indicates the start of the <body>,
        ## so we stop parsing.
        $p->eof if $html_parser && @{$p->{feeds}};
    }
}

# a simple and crude fallback for HTML::Parser
package MT::Feeds::Find::Parser;
use strict;

sub new { bless {find_links => $_[1]}, $_[0] }

sub parse {    # hack through the mess with a greased up machete...
    my ($p, $chunk) = @_;
    my @links = ($chunk =~ /<link\s+([^>]*)\/?>/sgi);
    foreach my $link (@links) {
        my $attr = {};
        while ($link =~ /\s*([^=]+?)\s*=\s*["']?([^\s"']*)["']?/gs) {
            $attr->{$1} = $2 if $1;
        }
        $p->{find_links}->($p, 'link', $attr);
    }
}

1;
