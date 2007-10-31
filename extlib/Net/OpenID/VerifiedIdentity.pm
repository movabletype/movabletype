use strict;
use Carp ();

############################################################################
package Net::OpenID::VerifiedIdentity;
use fields (
            'identity',  # the verified identity URL
            'id_uri',  # the verified identity's URI object

            'foaf',      # discovered foaf URL
            'foafmaker', # discovered foaf maker
            'rss',       # discovered rss feed
            'atom',      # discovered atom feed

            'consumer',  # The Net::OpenID::Consumer module which created us

            );
use URI;

sub new {
    my Net::OpenID::VerifiedIdentity $self = shift;
    $self = fields::new( $self ) unless ref $self;
    my %opts = @_;

    $self->{'consumer'} = delete $opts{'consumer'};

    if ($self->{'identity'} = delete $opts{'identity'}) {
        unless ($self->{'id_uri'} = URI->new($self->{identity})) {
            return $self->{'consumer'}->_fail("invalid_uri");
        }
    }

    for my $par (qw(foaf foafmaker rss atom)) {
        $self->$par(delete $opts{$par});
    }

    Carp::croak("Unknown options: " . join(", ", keys %opts)) if %opts;
    return $self;
}

sub url {
    my Net::OpenID::VerifiedIdentity $self = shift;
    return $self->{'identity'};
}

sub display {
    my Net::OpenID::VerifiedIdentity $self = shift;
    return DisplayOfURL($self->{'identity'});
}

sub foafmaker { &_getset;        }

sub foaf      { &_getset_semurl; }
sub rss       { &_getset_semurl; }
sub atom      { &_getset_semurl; }

sub declared_foaf   { &_dec_semurl; }
sub declared_rss    { &_dec_semurl; }
sub declared_atom   { &_dec_semurl; }

sub _getset {
    my $self = shift;
    my $param = (caller(1))[3];
    $param =~ s/.+:://;

    if (@_) {
        my $val = shift;
        Carp::croak("Too many parameters") if @_;
        $self->{$param} = $val;
    }
    return $self->{$param};
}

sub _getset_semurl {
    my $self = shift;
    my $param = (caller(1))[3];
    $param =~ s/.+:://;

    if (my $surl = shift) {
        Carp::croak("Too many parameters") if @_;

        # TODO: make absolute URL from possibly relative one
        my $abs = URI->new_abs($surl, $self->{'id_uri'});
        $self->{$param} = $abs;
    }

    my $uri = $self->{$param};
    return $uri && _url_is_under($self->{'id_uri'}, $uri) ? $uri->as_string : undef;
}

sub _dec_semurl {
    my $self = shift;
    my $param = (caller(1))[3];
    $param =~ s/.+::declared_//;

    my $uri = $self->{$param};
    return $uri ? $uri->as_string : undef;
}

sub DisplayOfURL {
    my $url = shift;
    my $dev_mode = shift;

    return $url unless
        $url =~ m!^https?://([^/]+)(/.*)?$!;

    my ($host, $path) = ($1, $2);
    $host = lc($host);

    if ($dev_mode) {
        $host =~ s!^dev\.!!;
        $host =~ s!:\d+!!;
    }

    $host =~ s/:.+//;
    $host =~ s/^www\.//i;

    if (length($path) <= 1) {
        return $host;
    }

    # obvious username
    if ($path =~ m!^/~([^/]+)/?$! ||
        $path =~ m!^/(?:users?|members?)/([^/]+)/?$!) {
        return "$1 [$host]";
    }

    if ($host =~ m!^profile\.(.+)!i) {
        my $site = $1;
        if ($path =~ m!^/([^/]+)/?$!) {
            return "$1 [$site]";
        }
    }

    return $url;
}

# FIXME: duplicated in Net::OpenID::Server
sub _url_is_under {
    my ($root, $test, $err_ref) = @_;

    my $err = sub {
        $$err_ref = shift if $err_ref;
        return undef;
    };

    my $ru = ref $root ? $root : URI->new($root);
    return $err->("invalid root scheme") unless $ru->scheme =~ /^https?$/;
    my $tu = ref $test ? $test : URI->new($test);
    return $err->("invalid test scheme") unless $tu->scheme =~ /^https?$/;
    return $err->("schemes don't match") unless $ru->scheme eq $tu->scheme;
    return $err->("ports don't match") unless $ru->port == $tu->port;

    # check hostnames
    my $ru_host = $ru->host;
    my $tu_host = $tu->host;
    my $wildcard_host = 0;
    if ($ru_host =~ s!^\*\.!!) {
        $wildcard_host = 1;
    }
    unless ($ru_host eq $tu_host) {
        if ($wildcard_host) {
            return $err->("host names don't match") unless
                $tu_host =~ /\.\Q$ru_host\E$/;
        } else {
            return $err->("host names don't match");
        }
    }

    # check paths
    my $ru_path = $ru->path || "/";
    my $tu_path = $tu->path || "/";
    $ru_path .= "/" unless $ru_path =~ m!/$!;
    $tu_path .= "/" unless $tu_path =~ m!/$!;
    return $err->("path not a subpath") unless $tu_path =~ m!^\Q$ru_path\E!;

    return 1;
}

1;

__END__

=head1 NAME

Net::OpenID::VerifiedIdentity - object representing a verified OpenID identity

=head1 SYNOPSIS

  use Net::OpenID::Consumer;
  my $csr = Net::OpenID::Consumer->new;
  ....
  my $vident = $csr->verified_identity
    or die $csr->err;

  my $url = $vident->url;


=head1 DESCRIPTION

After L<Net::OpenID::Consumer> verifies a user's identity and does the
signature checks, it gives you this Net::OpenID::VerifiedIdentity
object, from which you can learn more about the user.

=head1 METHODS

=over 4

=item $vident->B<url>

Returns the URL (as a scalar) that was verified.  (Remember, an OpenID
is just a URL.)

=item $vident->B<display>

Returns the a short "display form" of the verified URL using a couple
brain-dead patterns.  For instance, the identity
"http://www.foo.com/~bob/" will map to "bob [foo.com]" The www. prefix
is removed, as well as http, and a username is looked for, in either
the tilde form, or "/users/USERNAME" or "/members/USERNAME".  If the
path component is empty or just "/", then the display form is just the
hostname, so "http://myblog.com/" is just "myblog.com".

Suggestions for improving this function are welcome!

=item $vident->B<rss>

=item $vident->B<atom>

=item $vident->B<foaf>

=item $vident->B<declared_rss>

=item $vident->B<declared_atom>

=item $vident->B<declared_foaf>

Returns the absolute URLs (as scalars) of the user's RSS, Atom, and
FOAF XML documents that were also found in their HTML's E<lt>headE<gt>
section.  The short versions will only return a URL if they're below
the root URL that was verified.  If you want to get at the user's
declared rss/atom/foaf, even if it's on a different host or parent
directory, use the delcared_* versions, which don't have the additional
checks.

2005-05-24:  A future module will take a Net::OpenID::VerifiedIdentity
object and create an OpenID profile object so you don't have to
manually parse all those documents to get profile information.

=item $vident->B<foafmaker>

Returns the value of the C<foaf:maker> meta tag, if declared.

=back

=head1 COPYRIGHT, WARRANTY, AUTHOR

See L<Net::OpenID::Consumer> for author, copyrignt and licensing information.

=head1 SEE ALSO

L<Net::OpenID::Consumer>

L<Net::OpenID::ClaimedIdentity>

L<Net::OpenID::Server>

Website:  L<http://www.danga.com/openid/>
