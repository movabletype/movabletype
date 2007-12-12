use strict;
use Carp ();

############################################################################
package Net::OpenID::ClaimedIdentity;
use fields (
            'identity',  # the canonical URL that was found, following redirects
            'server',    # author-identity identity server endpoint
            'consumer',  # ref up to the Net::OpenID::Consumer which generated us
            'delegate',  # the delegated URL actually asserted by the server
            );

sub new {
    my Net::OpenID::ClaimedIdentity $self = shift;
    $self = fields::new( $self ) unless ref $self;
    my %opts = @_;
    for my $f (qw( identity server consumer delegate )) {
        $self->{$f} = delete $opts{$f};
    }

    # lowercase the scheme and hostname
    $self->{'identity'} =~ s!^(https?://.+?)(/(?:.*))?$!lc($1) . $2!ie;

    Carp::croak("unknown options: " . join(", ", keys %opts)) if %opts;
    return $self;
}

sub claimed_url {
    my Net::OpenID::ClaimedIdentity $self = shift;
    Carp::croak("Too many parameters") if @_;
    return $self->{'identity'};
}

sub identity_server {
    my Net::OpenID::ClaimedIdentity $self = shift;
    Carp::croak("Too many parameters") if @_;
    return $self->{server};
}

sub check_url {
    my Net::OpenID::ClaimedIdentity $self = shift;
    my (%opts) = @_;

    my $return_to   = delete $opts{'return_to'};
    my $trust_root  = delete $opts{'trust_root'};
    my $delayed_ret = delete $opts{'delayed_return'};

    Carp::croak("Unknown options: " . join(", ", keys %opts)) if %opts;
    Carp::croak("Invalid/missing return_to") unless $return_to =~ m!^https?://!;

    my $csr = $self->{consumer};

    my $ident_server = $self->{server} or
        Carp::croak("No identity server");

    # get an assoc (or undef for dumb mode)
    my $assoc = Net::OpenID::Association::server_assoc($csr, $ident_server);

    my $identity_arg = $self->{'delegate'} || $self->{'identity'};

    # make a note back to ourselves that we're using a delegate
    if ($self->{'delegate'}) {
        OpenID::util::push_url_arg(\$return_to,
                                   "oic.identity",  $self->{identity});
    }

    # add a HMAC-signed time so we can verify the return_to URL wasn't spoofed
    my $sig_time = time();
    my $c_secret = $csr->_get_consumer_secret($sig_time);
    my $sig = substr(OpenID::util::hmac_sha1_hex($sig_time, $c_secret), 0, 20);
    OpenID::util::push_url_arg(\$return_to,
                               "oic.time", "${sig_time}-$sig");

    my $curl = $ident_server;
    OpenID::util::push_url_arg(\$curl,
                               "openid.mode",           ($delayed_ret ? "checkid_setup" : "checkid_immediate"),
                               "openid.identity",       $identity_arg,
                               "openid.return_to",      $return_to,

                               ($trust_root ?
                                ("openid.trust_root",   $trust_root) : ()),

                               ($assoc ?
                                ("openid.assoc_handle", $assoc->handle) : ()),
                               );

    $self->{consumer}->_debug("check_url for (del=$self->{delegate}, id=$self->{identity}) = $curl");
    return $curl;
}


1;

__END__

=head1 NAME

Net::OpenID::ClaimedIdentity - a not-yet-verified OpenID identity

=head1 SYNOPSIS

  use Net::OpenID::Consumer;
  my $csr = Net::OpenID::Consumer->new;
  ....
  my $cident = $csr->claimed_identity("bradfitz.com")
    or die $csr->err;

  if ($AJAX_mode) {
    my $url = $cident->claimed_url;
    my $openid_server = $cident->identity_server;
    # ... return JSON with those to user agent (whose request was
    # XMLHttpRequest, probably)
  }

  if ($CLASSIC_mode) {
    my $check_url = $cident->check_url(
      delayed_return => 1,
      return_to      => "http://example.com/get-identity.app",
      trust_root     => "http://*.example.com/",
    );
    WebApp::redirect($check_url);
  }

=head1 DESCRIPTION

After L<Net::OpenID::Consumer> crawls a user's declared identity URL
and finds openid.server link tags in the HTML head, you get this
object.  It represents an identity that can be verified with OpenID
(the link tags are present), but hasn't been actually verified yet.

=head1 METHODS

=over 4

=item $url = $cident->B<claimed_url>

The URL, now canonicalized, that the user claims to own.  You can't
know whether or not they do own it yet until you send them off to the
check_url, though.

=item $id_server = $cident->B<identity_server>

Returns the identity server that will assert whether or not this
claimed identity is valid, and sign a message saying so.

=item $url = $cident->B<check_url>( %opts )

Makes the URL that you have to somehow send the user to in order to
validate their identity.  The options to put in %opts are:

=over

=item C<return_to>

The URL that the identity server should redirect the user with either
a verified identity signature -or- a user_setup_url (if the assertion
couldn't be made).  This URL may contain query parameters, and the
identity server must preserve them.

=item C<trust_root>

The URL that you want the user to actually see and declare trust for.
Your C<return_to> URL must be at or below your trust_root.  Sending
the trust_root is optional, and defaults to your C<return_to> value,
but it's highly recommended (and prettier for users) to see a simple
trust_root.  Note that the trust root may contain a wildcard at the
beginning of the host, like C<http://*.example.com/>

=item C<delayed_return>

If set to a true value, the check_url returned will indicate to the
user's identity server that it has permission to control the user's
user-agent for awhile, giving them real pages (not just redirects) and
lets them bounce around the identity server site for awhile until
the requested assertion can be made, and they can finally be redirected
back to your return_to URL above.

The default value, false, means that the identity server will
immediately return to your return_to URL with either a "yes" or "no"
answer.  In the "no" case, you'll instead have control of what to do,
and you'll be sent the identity server's user_setup_url where you'll
have to somehow send the user (be it link, redirect, or pop-up
window).

When writing a dynamic "AJAX"-style application, you can't use
delayed_return because the remote site can't usefully take control of
a 1x1 pixel hidden IFRAME, so you'll need to get the user_setup_url
and present it to the user somehow.

=back

=back

=head1 COPYRIGHT, WARRANTY, AUTHOR

See L<Net::OpenID::Consumer> for author, copyrignt and licensing information.

=head1 SEE ALSO

L<Net::OpenID::Consumer>

L<Net::OpenID::VerifiedIdentity>

L<Net::OpenID::Server>

Website:  L<http://www.danga.com/openid/>

