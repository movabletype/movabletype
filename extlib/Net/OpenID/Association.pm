use strict;
use Carp ();

############################################################################
package Net::OpenID::Association;
use fields (
            'server',    # author-identity identity server endpoint
            'secret',    # the secret for this association
            'handle',    # the 255-character-max ASCII printable handle (33-126)
            'expiry',    # unixtime, adjusted, of when this association expires
            'type',      # association type
            );

use Storable ();
use Digest::SHA1 qw(sha1);

sub new {
    my Net::OpenID::Association $self = shift;
    $self = fields::new( $self ) unless ref $self;
    my %opts = @_;
    for my $f (qw( server secret handle expiry type )) {
        $self->{$f} = delete $opts{$f};
    }
    Carp::croak("unknown options: " . join(", ", keys %opts)) if %opts;
    return $self;
}

sub handle {
    my $self = shift;
    die if @_;
    $self->{'handle'};
}

sub secret {
    my $self = shift;
    die if @_;
    $self->{'secret'};
}

sub type {
    my $self = shift;
    die if @_;
    $self->{'type'};
}

sub server {
    my Net::OpenID::Association $self = shift;
    Carp::croak("Too many parameters") if @_;
    return $self->{server};
}

sub expired {
    my Net::OpenID::Association $self = shift;
    return time() > $self->{'expiry'};
}

sub usable {
    my Net::OpenID::Association $self = shift;
    return 0 unless $self->{'handle'} =~ /^[\x21-\x7e]{1,255}$/;
    return 0 unless $self->{'expiry'} =~ /^\d+$/;
    return 0 unless $self->{'secret'};
    return 0 if $self->expired;
    return 1;
}


# return a handle for an identity server, or undef if
# no local storage/cache is available, in which case the caller
# goes into dumb consumer mode.  will do a POST and allocate
# a new assoc_handle if none is found, or has expired
sub server_assoc {
    my ($csr, $server, $force_reassociate, %opts) = @_;

    my $protocol_version = delete $opts{protocol_version} || 1;
    Carp::croak("unknown options: " . join(", ", keys %opts)) if %opts;

    # closure to return undef (dumb consumer mode) and log why
    my $dumb = sub {
        $csr->_debug("server_assoc: dumb mode: $_[0]");
        return undef;
    };

    my $cache = $csr->cache;
    return $dumb->("no_cache") unless $cache;

    unless ($force_reassociate) {
        # try first from cached association handle
        if (my $handle = $cache->get("shandle:$server")) {
            my $assoc = handle_assoc($csr, $server, $handle);

            if ($assoc && $assoc->usable) {
                $csr->_debug("Found association from cache (handle=$handle)");
                return $assoc;
            }
        }
    }

    # make a new association
    my $dh = _default_dh();

    my %post = (
                "openid.mode" => "associate",
                "openid.assoc_type" => "HMAC-SHA1",
                "openid.session_type" => "DH-SHA1",
                "openid.dh_consumer_public" => OpenID::util::bi2arg($dh->pub_key),
                );

    if ($protocol_version == 2) {
        $post{"openid.ns"} = OpenID::util::version_2_namespace();
    }

    my $req = HTTP::Request->new(POST => $server);
    $req->header("Content-Type" => "application/x-www-form-urlencoded");
    $req->content(join("&", map { "$_=" . OpenID::util::eurl($post{$_}) } keys %post));

    $csr->_debug("Associate mode request: " . $req->content);

    my $ua  = $csr->ua;
    my $res = $ua->request($req);

    # uh, some failure, let's go into dumb mode?
    return $dumb->("http_failure_no_associate") unless $res && $res->is_success;

    my $recv_time = time();
    my $content = $res->content;
    my %args = OpenID::util::parse_keyvalue($content);
    $csr->_debug("Response to associate mode: [$content] parsed = " . join(",", %args));

    return $dumb->("unknown_assoc_type") unless $args{'assoc_type'} eq "HMAC-SHA1";

    my $stype = $args{'session_type'};
    return $dumb->("unknown_session_type") if $stype && $stype ne "DH-SHA1";

    # protocol version 1.1
    my $expires_in = $args{'expires_in'};

    # protocol version 1.0 (DEPRECATED)
    if (! $expires_in) {
        if (my $issued = OpenID::util::w3c_to_time($args{'issued'})) {
            my $expiry = OpenID::util::w3c_to_time($args{'expiry'});
            my $replace_after = OpenID::util::w3c_to_time($args{'replace_after'});

            # seconds ahead (positive) or behind (negative) the server is
            $expires_in = ($replace_after || $expiry) - $issued;
        }
    }

    # between 1 second and 2 years
    return $dumb->("bogus_expires_in") unless $expires_in > 0 && $expires_in < 63072000;

    my $ahandle = $args{'assoc_handle'};

    my $secret;
    if ($stype ne "DH-SHA1") {
        $secret = OpenID::util::d64($args{'mac_key'});
    } else {
        my $server_pub = OpenID::util::arg2bi($args{'dh_server_public'});
        my $dh_sec = $dh->compute_secret($server_pub);
        $secret = OpenID::util::d64($args{'enc_mac_key'}) ^ sha1(OpenID::util::bi2bytes($dh_sec));
    }
    return $dumb->("secret_not_20_bytes") unless length($secret) == 20;

    my %assoc = (
                 handle => $ahandle,
                 server => $server,
                 secret => $secret,
                 type   => $args{'assoc_type'},
                 expiry => $recv_time + $expires_in,
                 );

    my $assoc = Net::OpenID::Association->new( %assoc );
    return $dumb->("assoc_undef") unless $assoc;

    $cache->set("hassoc:$server:$ahandle", Storable::freeze(\%assoc));
    $cache->set("shandle:$server", $ahandle);

    # now we test that the cache object given to us actually works.  if it
    # doesn't, it'll also fail later, making the verify fail, so let's
    # go into stateless (dumb mode) earlier if we can detect this.
    $cache->get("shandle:$server")
        or return $dumb->("cache_broken");

    return $assoc;
}

# returns association, or undef if it can't be found
sub handle_assoc {
    my ($csr, $server, $handle) = @_;

    # closure to return undef (dumb consumer mode) and log why
    my $dumb = sub {
        $csr->_debug("handle_assoc: dumb mode: $_[0]");
        return undef;
    };

    return $dumb->("no_handle") unless $handle;

    my $cache = $csr->cache;
    return $dumb->("no_cache") unless $cache;

    my $frozen = $cache->get("hassoc:$server:$handle");
    return $dumb->("not_in_cache") unless $frozen;

    my $param = eval { Storable::thaw($frozen) };
    return $dumb->("not_a_hashref") unless ref $param eq "HASH";

    return Net::OpenID::Association->new( %$param );
}

sub invalidate_handle {
    my ($csr, $server, $handle) = @_;
    my $cache = $csr->cache
        or return;
    $cache->set("hassoc:$server:$handle", "");
}

sub _default_dh {
    my $dh = Crypt::DH->new;
    $dh->p("155172898181473697471232257763715539915724801966915404479707795314057629378541917580651227423698188993727816152646631438561595825688188889951272158842675419950341258706556549803580104870537681476726513255747040765857479291291572334510643245094715007229621094194349783925984760375594985848253359305585439638443");
    $dh->g("2");
    $dh->generate_keys;
    return $dh;
}



1;

__END__

=head1 NAME

Net::OpenID::Association - a relationship with an identity server

=head1 DESCRIPTION

Internal class.

=head1 COPYRIGHT, WARRANTY, AUTHOR

See L<Net::OpenID::Consumer> for author, copyrignt and licensing information.

=head1 SEE ALSO

L<Net::OpenID::Consumer>

L<Net::OpenID::VerifiedIdentity>

L<Net::OpenID::Server>

Website:  L<http://www.danga.com/openid/>

