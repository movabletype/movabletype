# LICENSE: You're free to distribute this under the same terms as Perl itself.

use strict;
use Carp ();
use LWP::UserAgent;
use Storable;

############################################################################
package Net::OpenID::Consumer;

use vars qw($VERSION);
$VERSION = "1.03";

use fields (
    'cache',           # a Cache object to store HTTP responses and associations
    'ua',              # LWP::UserAgent instance to use
    'args',            # how to get at your args
    'message',         # args interpreted as an IndirectMessage, if possible
    'consumer_secret', # scalar/subref
    'required_root',   # the default required_root value, or undef
    'last_errcode',    # last error code we got
    'last_errtext',    # last error code we got
    'debug',           # debug flag or codeblock
    'minimum_version', # The minimum protocol version to support
);

use Net::OpenID::ClaimedIdentity;
use Net::OpenID::VerifiedIdentity;
use Net::OpenID::Association;
use Net::OpenID::Yadis;
use Net::OpenID::IndirectMessage;
use Net::OpenID::URIFetch;

use MIME::Base64 ();
use Digest::SHA1 ();
use Crypt::DH 0.05;
use Time::Local;
use HTTP::Request;

sub new {
    my Net::OpenID::Consumer $self = shift;
    $self = fields::new( $self ) unless ref $self;
    my %opts = @_;

    $opts{minimum_version} ||= 1;

    $self->{ua}            = delete $opts{ua};
    $self->args            ( delete $opts{args}            );
    $self->cache           ( delete $opts{cache}           );
    $self->consumer_secret ( delete $opts{consumer_secret} );
    $self->required_root   ( delete $opts{required_root}   );
    $self->minimum_version ( delete $opts{minimum_version} );

    $self->{debug} = delete $opts{debug};

    Carp::croak("Unknown options: " . join(", ", keys %opts)) if %opts;
    return $self;
}

# NOTE: This method is here only to support the openid-test library.
# Don't call it from anywhere else, or you'll break when it gets 
# removed. Instead, set the minimum_version property.
# FIXME: Can we just make openid-test set minimum_version and get
# rid of this?
sub disable_version_1 {
    my $self = shift;
    $self->{minimum_version} = 2.0;
}

sub cache           { &_getset; }
sub consumer_secret { &_getset; }
sub required_root   { &_getset; }
sub minimum_version { &_getset; }

sub _getset {
    my Net::OpenID::Consumer $self = shift;
    my $param = (caller(1))[3];
    $param =~ s/.+:://;

    if (@_) {
        my $val = shift;
        Carp::croak("Too many parameters") if @_;
        $self->{$param} = $val;
    }
    return $self->{$param};
}

sub _debug {
    my Net::OpenID::Consumer $self = shift;
    return unless $self->{debug};

    if (ref $self->{debug} eq "CODE") {
        $self->{debug}->($_[0]);
    } else {
        print STDERR "[DEBUG Net::OpenID::Consumer] $_[0]\n";
    }
}

# given something that can have GET arguments, returns a subref to get them:
#   Apache
#   Apache::Request
#   CGI
#   HASH of get args
#   CODE returning get arg, given key

#   ...

sub args {
    my Net::OpenID::Consumer $self = shift;

    if (my $what = shift) {
        unless (ref $what) {
            return $self->{args} ? $self->{args}->($what) : Carp::croak("No args defined");
        }
        else {
            Carp::croak("Too many parameters") if @_;
            my $message = Net::OpenID::IndirectMessage->new($what, (
                minimum_version => $self->minimum_version,
            ));
            $self->{message} = $message;
            $self->{args} = $message ? $message->getter : sub { undef };
        }
    }
    $self->{args};
}

sub message {
    my Net::OpenID::Consumer $self = shift;
    if (my $key = shift) {
        return $self->{message} ? $self->{message}->get($key) : undef;
    }
    else {
        return $self->{message};
    }
}

sub _message_mode {
    my $message = $_[0]->message;
    return $message ? $message->mode : undef;
}

sub _message_version {
    my $message = $_[0]->message;
    return $message ? $message->protocol_version : undef;
}

sub ua {
    my Net::OpenID::Consumer $self = shift;
    $self->{ua} = shift if @_;
    Carp::croak("Too many parameters") if @_;

    # make default one on first access
    unless ($self->{ua}) {
        my $ua = $self->{ua} = LWP::UserAgent->new;
        $ua->timeout(10);
    }

    $self->{ua};
}

sub _fail {
    my Net::OpenID::Consumer $self = shift;
    my ($code, $text) = @_;

    $text ||= {
        'no_identity_server' => "The provided URL doesn't declare its OpenID identity server.",
        'empty_url' => "No URL entered.",
        'bogus_url' => "Invalid URL.",
        'no_head_tag' => "URL provided doesn't seem to have a head tag.",
        'url_fetch_err' => "Error fetching the provided URL.",
        'bad_mode' => "The openid.mode argument is not correct",
        'protocol_version_incorrect' => "The provided URL uses the wrong protocol version",
        'naive_verify_failed_return' => "Provider says signature is invalid",
        'naive_verify_failed_network' => "Could not contact provider to verify signature",
    }->{$code};

    $self->{last_errcode} = $code;
    $self->{last_errtext} = $text;

    $self->_debug("fail($code) $text");
    wantarray ? () : undef;
}

sub json_err {
    my Net::OpenID::Consumer $self = shift;
    return OpenID::util::js_dumper({
        err_code => $self->{last_errcode},
        err_text => $self->{last_errtext},
    });
}

sub err {
    my Net::OpenID::Consumer $self = shift;
    $self->{last_errcode} . ": " . $self->{last_errtext};
}

sub errcode {
    my Net::OpenID::Consumer $self = shift;
    $self->{last_errcode};
}

sub errtext {
    my Net::OpenID::Consumer $self = shift;
    $self->{last_errtext};
}

sub _get_url_contents {
    my Net::OpenID::Consumer $self = shift;
    my ($url, $final_url_ref, $hook) = @_;
    $final_url_ref ||= do { my $dummy; \$dummy; };

    my $res = Net::OpenID::URIFetch->fetch($url, $self, $hook);

    $$final_url_ref = $res->final_uri;

    return $res ? $res->content : undef;
}

sub _find_semantic_info {
    my Net::OpenID::Consumer $self = shift;
    my $url = shift;
    my $final_url_ref = shift;

    my $trim_hook = sub {
        my $htmlref = shift;
        # trim everything past the body.  this is in case the user doesn't
        # have a head document and somebody was able to inject their own
        # head.  -- brad choate
        $$htmlref =~ s/<body\b.*//is;
    };

    my $doc = $self->_get_url_contents($url, $final_url_ref, $trim_hook) || '';

    # find <head> content of document (notably: the first head, if an attacker
    # has added others somehow)
    return $self->_fail("no_head_tag", "Couldn't find OpenID servers due to no head tag")
        unless $doc =~ m!<head[^>]*>(.*?)</head>!is;
    my $head = $1;

    my $ret = {
        'openid.server' => undef,
        'openid.delegate' => undef,
        'foaf' => undef,
        'foaf.maker' => undef,
        'rss' => undef,
        'atom' => undef,
    };

    # analyze link/meta tags
    while ($head =~ m!<(link|meta)\b([^>]+)>!g) {
        my ($type, $val) = ($1, $2);
        my $temp;

        # OpenID servers / delegated identities
        # <link rel="openid.server" href="http://www.livejournal.com/misc/openid.bml" />
        if ($type eq "link" &&
            $val =~ /\brel=.openid\.(server|delegate)./i && ($temp = $1) &&
            $val =~ m!\bhref=[\"\']([^\"\']+)[\"\']!i) {
            $ret->{"openid.$temp"} = $1;
            next;
        }

        # OpenID2 providers / local identifiers
        # <link rel="openid2.provider" href="http://www.livejournal.com/misc/openid.bml" />
        if ($type eq "link" &&
            $val =~ /\brel=.openid2\.(provider|local_id)./i && ($temp = $1) &&
            $val =~ m!\bhref=[\"\']([^\"\']+)[\"\']!i) {
            $ret->{"openid2.$temp"} = $1;
            next;
        }

        # FOAF documents
        #<link rel="meta" type="application/rdf+xml" title="FOAF" href="http://brad.livejournal.com/data/foaf" />
        if ($type eq "link" &&
            $val =~ m!title=.foaf.!i &&
            $val =~ m!rel=.meta.!i &&
            $val =~ m!type=.application/rdf\+xml.!i &&
            $val =~ m!href=[\"\']([^\"\']+)[\"\']!i) {
            $ret->{"foaf"} = $1;
            next;
        }

        # FOAF maker info
        # <meta name="foaf:maker" content="foaf:mbox_sha1sum '4caa1d6f6203d21705a00a7aca86203e82a9cf7a'" />
        if ($type eq "meta" &&
            $val =~ m!name=.foaf:maker.!i &&
            $val =~ m!content=([\'\"])(.*?)\1!i) {
            $ret->{"foaf.maker"} = $2;
            next;
        }

        if ($type eq "meta" &&
            $val =~ m!name=.foaf:maker.!i &&
            $val =~ m!content=([\'\"])(.*?)\1!i) {
            $ret->{"foaf.maker"} = $2;
            next;
        }

        # RSS
        # <link rel="alternate" type="application/rss+xml" title="RSS" href="http://www.livejournal.com/~brad/data/rss" />
        if ($type eq "link" &&
            $val =~ m!rel=.alternate.!i &&
            $val =~ m!type=.application/rss\+xml.!i &&
            $val =~ m!href=[\"\']([^\"\']+)[\"\']!i) {
            $ret->{"rss"} = $1;
            next;
        }

        # Atom
        # <link rel="alternate" type="application/atom+xml" title="Atom" href="http://www.livejournal.com/~brad/data/rss" />
        if ($type eq "link" &&
            $val =~ m!rel=.alternate.!i &&
            $val =~ m!type=.application/atom\+xml.!i &&
            $val =~ m!href=[\"\']([^\"\']+)[\"\']!i) {
            $ret->{"atom"} = $1;
            next;
        }
    }

    # map the 4 entities that the spec asks for
    my $emap = {
        'lt' => '<',
        'gt' => '>',
        'quot' => '"',
        'amp' => '&',
    };
    foreach my $k (keys %$ret) {
        next unless $ret->{$k};
        $ret->{$k} =~ s/&(\w+);/$emap->{$1} || ""/eg;
    }

    $self->_debug("semantic info ($url) = " . join(", ", map { $_.' => '.$ret->{$_} } keys %$ret)) if $self->{debug};

    return $ret;
}

sub _find_openid_server {
    my Net::OpenID::Consumer $self = shift;
    my $url = shift;
    my $final_url_ref = shift;

    my $sem_info = $self->_find_semantic_info($url, $final_url_ref) or
        return;

    return $self->_fail("no_identity_server") unless $sem_info->{"openid.server"};
    $sem_info->{"openid.server"};
}

sub is_server_response {
    my Net::OpenID::Consumer $self = shift;
    return $self->_message_mode ? 1 : 0;
}

sub handle_server_response {
    my Net::OpenID::Consumer $self = shift;
    my %callbacks_in = @_;
    my %callbacks = ();

    foreach my $cb (qw(not_openid setup_required cancelled verified error)) {
        $callbacks{$cb} = delete($callbacks_in{$cb}) || sub { Carp::croak("No ".$cb." callback") };
    }
    Carp::croak("Unknown callbacks ".join(',', keys %callbacks)) if %callbacks_in;

    unless ($self->is_server_response) {
        return $callbacks{not_openid}->();
    }

    if (my $setup_url = $self->user_setup_url) {
        return $callbacks{setup_required}->($setup_url);
    }
    elsif ($self->user_cancel) {
        return $callbacks{cancelled}->();
    }
    elsif (my $vident = $self->verified_identity) {
        return $callbacks{verified}->($vident);
    }
    else {
        return $callbacks{error}->($self->errcode, $self->errtext);
    }

}

sub _discover_acceptable_endpoints {
    my Net::OpenID::Consumer $self = shift;
    my $url = shift;
    my %opts = @_;

    # if return_early is set, we'll return as soon as we have enough
    # information to determine the "primary" endpoint, and return
    # that as the first (and possibly only) item in our response.
    my $primary_only = delete $opts{primary_only} ? 1 : 0;

    my $force_version = delete $opts{force_version};

    Carp::croak("Unknown option(s) ".join(', ', keys(%opts))) if %opts;

    # trim whitespace
    $url =~ s/^\s+//;
    $url =~ s/\s+$//;
    return $self->_fail("empty_url", "Empty URL") unless $url;

    # do basic canonicalization
    $url = "http://$url" if $url && $url !~ m!^\w+://!;
    return $self->_fail("bogus_url", "Invalid URL") unless $url =~ m!^https?://!i;
    # add a slash, if none exists
    $url .= "/" unless $url =~ m!^https?://.+/!i;

    my @discovered_endpoints = ();
    my $result = sub {
        # We always prefer 2.0 endpoints to 1.1 ones, regardless of
        # the priority chosen by the identifier.
        return [
            (grep { $_->{version} == 2 } @discovered_endpoints),
            (grep { $_->{version} == 1 } @discovered_endpoints),
        ];
    };

    # TODO: Support XRI too?

    # First we Yadis service discovery
    my $yadis = Net::OpenID::Yadis->new(consumer => $self);
    if ($yadis->discover($url)) {
        # FIXME: Currently we don't ever do _find_semantic_info in the Yadis
        # code path, so an extra redundant HTTP request is done later
        # when the semantic info is accessed.

        my $final_url = $yadis->identity_url;
        my @services = $yadis->services(
            OpenID::util::version_2_xrds_service_url(),
            OpenID::util::version_2_xrds_directed_service_url(),
            OpenID::util::version_1_xrds_service_url(),
        );
        my $version2 = OpenID::util::version_2_xrds_service_url();
        my $version1 = OpenID::util::version_1_xrds_service_url();
        my $version2_directed = OpenID::util::version_2_xrds_directed_service_url();

        foreach my $service (@services) {
            my $service_uris = $service->URI;

            # Service->URI seems to return all sorts of bizarre things, so let's
            # normalize it to always be an arrayref.
            if (ref($service_uris) eq 'ARRAY') {
                my @sorted_id_servers = sort {
                    my $pa = $a->{priority};
                    my $pb = $b->{priority};
                    return 0 unless defined($pa) || defined($pb);
                    return -1 unless defined ($pb);
                    return 1 unless defined ($pa);
                    return $a->{priority} <=> $b->{priority}
                } @$service_uris;
                $service_uris = \@sorted_id_servers;
            }
            if (ref($service_uris) eq 'HASH') {
                $service_uris = [ $service_uris->{content} ];
            }
            unless (ref($service_uris)) {
                $service_uris = [ $service_uris ];
            }

            my $delegate = undef;
            my @versions = ();

            if (grep(/^${version2}$/, $service->Type)) {
                # We have an OpenID 2.0 end-user identifier
                $delegate = $service->extra_field("LocalID");
                push @versions, 2;
            }
            if (grep(/^${version1}$/, $service->Type)) {
                # We have an OpenID 1.1 end-user identifier
                $delegate = $service->extra_field("Delegate", "http://openid.net/xmlns/1.0");
                push @versions, 1;
            }

            if (@versions) {
                foreach my $version (@versions) {
                    next if defined($force_version) && $force_version != $version;
                    foreach my $uri (@$service_uris) {
                        push @discovered_endpoints, {
                            uri => $uri,
                            version => $version,
                            final_url => $final_url,
                            delegate => $delegate,
                            sem_info => undef,
                            mechanism => "Yadis",
                        };
                    }
                }
            }

            if (grep(/^${version2_directed}$/, $service->Type)) {
                # We have an OpenID 2.0 OP identifier (i.e. we're doing directed identity)
                my $version = 2;
                # In this case, the user's claimed identifier is a magic value
                # and the actual identifier will be determined by the provider.
                my $final_url = OpenID::util::version_2_identifier_select_url();
                my $delegate = OpenID::util::version_2_identifier_select_url();

                foreach my $uri (@$service_uris) {
                    push @discovered_endpoints, {
                        uri => $uri,
                        version => $version,
                        final_url => $final_url,
                        delegate => $delegate,
                        sem_info => undef,
                        mechanism => "Yadis",
                    };
                }
            }

            if ($primary_only && scalar(@discovered_endpoints)) {
                # We've got at least one endpoint now, so return early
                return $result->();
            }
        }
    }

    # Now HTML-based discovery, both 2.0- and 1.1-style.
    {
        my $final_url = undef;
        my $sem_info = $self->_find_semantic_info($url, \$final_url);

        if ($sem_info) {
            if ($sem_info->{"openid2.provider"}) {
                unless (defined($force_version) && $force_version != 2) {
                    push @discovered_endpoints, {
                        uri => $sem_info->{"openid2.provider"},
                        version => 2,
                        final_url => $final_url,
                        delegate => $sem_info->{"openid2.local_id"},
                        sem_info => $sem_info,
                        mechanism => "HTML",
                    };
                }
            }
            if ($sem_info->{"openid.server"}) {
                unless (defined($force_version) && $force_version != 1) {
                    push @discovered_endpoints, {
                        uri => $sem_info->{"openid.server"},
                        version => 1,
                        final_url => $final_url,
                        delegate => $sem_info->{"openid.delegate"},
                        sem_info => $sem_info,
                        mechanism => "HTML",
                    };
                }
            }
        }
    }

    return $result->();

}

# returns Net::OpenID::ClaimedIdentity
sub claimed_identity {
    my Net::OpenID::Consumer $self = shift;
    my $url = shift;
    Carp::croak("Too many parameters") if @_;

    # trim whitespace
    $url =~ s/^\s+//;
    $url =~ s/\s+$//;
    return $self->_fail("empty_url", "Empty URL") unless $url;

    # do basic canonicalization
    $url = "http://$url" if $url && $url !~ m!^\w+://!;
    return $self->_fail("bogus_url", "Invalid URL") unless $url =~ m!^https?://!i;
    # add a slash, if none exists
    $url .= "/" unless $url =~ m!^https?://.+/!i;

    my $endpoints = $self->_discover_acceptable_endpoints($url, primary_only => 1);

    if (ref($endpoints) && @$endpoints) {
        foreach my $endpoint (@$endpoints) {

            next unless $endpoint->{version} >= $self->minimum_version;

            $self->_debug("Discovered version $endpoint->{version} endpoint at $endpoint->{uri} via $endpoint->{mechanism}");
            $self->_debug("Delegate is $endpoint->{delegate}") if $endpoint->{delegate};

            return Net::OpenID::ClaimedIdentity->new(
                identity         => $endpoint->{final_url},
                server           => $endpoint->{uri},
                consumer         => $self,
                delegate         => $endpoint->{delegate},
                protocol_version => $endpoint->{version},
                semantic_info    => $endpoint->{sem_info},
            );

        }

        # If we've fallen out here, then none of the available services are of the required version.
        return $self->_fail("protocol_version_incorrect");

    }
    else {
        return $self->_fail("no_identity_server");
    }

}

sub user_cancel {
    my Net::OpenID::Consumer $self = shift;
    return $self->_message_mode eq "cancel";
}

sub user_setup_url {
    my Net::OpenID::Consumer $self = shift;
    my %opts = @_;
    my $post_grant = delete $opts{'post_grant'};
    Carp::croak("Unknown options: " . join(", ", keys %opts)) if %opts;

    if ($self->_message_version == 1) {
        return $self->_fail("bad_mode") unless $self->_message_mode eq "id_res";
    }
    else {
        return undef unless $self->_message_mode eq 'setup_needed';
    }

    my $setup_url = $self->message("user_setup_url");

    OpenID::util::push_url_arg(\$setup_url, "openid.post_grant", $post_grant)
        if $setup_url && $post_grant;

    return $setup_url;
}

sub verified_identity {
    my Net::OpenID::Consumer $self = shift;
    my %opts = @_;

    my $rr = delete $opts{'required_root'} || $self->{required_root};
    Carp::croak("Unknown options: " . join(", ", keys %opts)) if %opts;

    return $self->_fail("bad_mode") unless $self->_message_mode eq "id_res";

    # the asserted identity (the delegated one, if there is one, since the protocol
    # knows nothing of the original URL)
    my $a_ident  = $self->message("identity")     or return $self->_fail("no_identity");

    my $sig64    = $self->message("sig")          or return $self->_fail("no_sig");

    # fix sig if the OpenID auth server failed to properly escape pluses (+) in the sig
    $sig64 =~ s/ /+/g;

    my $returnto = $self->message("return_to")    or return $self->_fail("no_return_to");
    my $signed   = $self->message("signed");

    my $possible_endpoints;
    my $server;
    my $claimed_identity;

    my $real_ident;
    if ($self->_message_version == 1) {
        $real_ident = $self->args("oic.identity") || $a_ident;

        # In version 1, we have to assume that the primary server
        # found during discovery is the one sending us this message.
        $possible_endpoints = $self->_discover_acceptable_endpoints($real_ident, force_version => 1);

        if ($possible_endpoints && @$possible_endpoints) {
            $possible_endpoints = [ $possible_endpoints->[0] ];
            $server = $possible_endpoints->[0]{uri};
        }
        else {
            # We just fall out of here and bail out below for having no endpoints.
        }
    }
    else {
        $real_ident = $self->message("claimed_id") || $a_ident;

        # In version 2, the OP tells us its URL.
        $server = $self->message("op_endpoint");
        $possible_endpoints = $self->_discover_acceptable_endpoints($real_ident, force_version => 2);

        # FIXME: It kinda sucks that the above will always do both Yadis and HTML discovery, even though
        # in most cases only one will be in use.
    }

    $self->_debug("Server is $server");

    unless ($possible_endpoints && @$possible_endpoints) {
        return $self->_fail("no_identity_server");
    }

    # check that returnto is for the right host
    return $self->_fail("bogus_return_to") if $rr && $returnto !~ /^\Q$rr\E/;

    # check age/signature of return_to
    my $now = time();
    {
        my ($sig_time, $sig) = split(/\-/, $self->args("oic.time") || "");
        # complain if more than an hour since we sent them off
        return $self->_fail("time_expired")   if $sig_time < $now - 3600;
        # also complain if the signature is from the future by more than 30 seconds,
        # which compensates for potential clock drift between nodes in a web farm.
        return $self->_fail("time_in_future") if $sig_time - 30 > $now;
        # and check that the time isn't faked
        my $c_secret = $self->_get_consumer_secret($sig_time);
        my $good_sig = substr(OpenID::util::hmac_sha1_hex($sig_time, $c_secret), 0, 20);
        return $self->_fail("time_bad_sig") unless $sig eq $good_sig;
    }

    my $last_error = undef;

    foreach my $endpoint (@$possible_endpoints) {
        my $final_url = $endpoint->{final_url};
        my $endpoint_uri = $endpoint->{uri};
        my $delegate = $endpoint->{delegate};

        my $error = sub {
            $self->_debug("$endpoint_uri not acceptable: ".$_[0]);
            $last_error = $_[0];
        };

        # The endpoint_uri must match our $server
        if ($endpoint_uri ne $server) {
            $error->("server_not_allowed");
            next;
        }

        # OpenID 2.0 wants us to exclude the fragment part of the URL when doing equality checks
        my $a_ident_nofragment = $a_ident;
        my $real_ident_nofragment = $real_ident;
        my $final_url_nofragment = $final_url;
        if ($self->_message_version >= 2) {
            $a_ident_nofragment =~ s/\#.*$//x;
            $real_ident_nofragment =~ s/\#.*$//x;
            $final_url_nofragment =~ s/\#.*$//x;
        }
        unless ($final_url_nofragment eq $real_ident_nofragment) {
            $error->("unexpected_url_redirect");
            next;
        }

        # Protocol version must match
        unless ($endpoint->{version} == $self->_message_version) {
            $error->("protocol_version_incorrect");
            next;
        }

        # if openid.delegate was used, check that it was done correctly
        if ($a_ident_nofragment ne $real_ident_nofragment) {
            unless ($delegate eq $a_ident_nofragment) {
                $error->("bogus_delegation");
                next;
            }
        }

        # If we've got this far then we've found the right endpoint.

        $claimed_identity =  Net::OpenID::ClaimedIdentity->new(
            identity         => $endpoint->{final_url},
            server           => $endpoint->{uri},
            consumer         => $self,
            delegate         => $endpoint->{delegate},
            protocol_version => $endpoint->{version},
            semantic_info    => $endpoint->{sem_info},
        );
        last;

    }

    unless ($claimed_identity) {
        # We failed to find a good endpoint in the above loop, so
        # lets bail out.
        return $self->_fail($last_error);
    }

    my $assoc_handle = $self->message("assoc_handle");

    $self->_debug("verified_identity: assoc_handle: $assoc_handle");
    my $assoc = Net::OpenID::Association::handle_assoc($self, $server, $assoc_handle);

    my %signed_fields;   # key (without openid.) -> value

    # Auth 2.0 requires certain keys to be signed.
    if ($self->_message_version >= 2) {
        my %signed_fields = map {$_ => 1} split /,/, $signed;
        my %unsigned_fields;
        # these fields must be signed unconditionally
        foreach my $f (qw/op_endpoint return_to response_nonce assoc_handle/) {
            $unsigned_fields{$f}++ if !$signed_fields{$f};
        }
        # these fields must be signed if present
        foreach my $f (qw/claimed_id identity/) {
            next unless $self->args("openid.$f");
            $unsigned_fields{$f}++ if !$signed_fields{$f};
        }
        if (%unsigned_fields) {
            return $self->_fail(
                "unsigned_field",
                "Field(s) must be signed: " . join(", ", keys %unsigned_fields)
            );
        }
    }

    if ($assoc) {
        $self->_debug("verified_identity: verifying with found association");

        return $self->_fail("expired_association")
            if $assoc->expired;

        # verify the token
        my $token = "";
        foreach my $param (split(/,/, $signed)) {
            my $val = $self->args("openid.$param");
            $token .= "$param:$val\n";
            $signed_fields{$param} = $val;
        }

        my $good_sig = OpenID::util::b64(OpenID::util::hmac_sha1($token, $assoc->secret));
        return $self->_fail("signature_mismatch") unless $sig64 eq $good_sig;

    } else {
        $self->_debug("verified_identity: verifying using HTTP (dumb mode)");
        # didn't find an association.  have to do dumb consumer mode
        # and check it with a POST
        my %post = (
                    "openid.mode"         => "check_authentication",
                    "openid.assoc_handle" => $assoc_handle,
                    "openid.signed"       => $signed,
                    "openid.sig"          => $sig64,
                    );

        # and copy in all signed parameters that we don't already have into %post
        foreach my $param (split(/,/, $signed)) {
            next unless $param =~ /^[\w\.]+$/;
            my $val = $self->args('openid.'.$param);
            $signed_fields{$param} = $val;
            next if $post{"openid.$param"};
            $post{"openid.$param"} = $val;
        }

        # if the server told us our handle as bogus, let's ask in our
        # check_authentication mode whether that's true
        if (my $ih = $self->message("invalidate_handle")) {
            $post{"openid.invalidate_handle"} = $ih;
        }

        my $req = HTTP::Request->new(POST => $server);
        $req->header("Content-Type" => "application/x-www-form-urlencoded");
        $req->content(join("&", map { "$_=" . OpenID::util::eurl($post{$_}) } keys %post));

        my $ua  = $self->ua;
        my $res = $ua->request($req);

        # uh, some failure, let's go into dumb mode?
        return $self->_fail("naive_verify_failed_network") unless $res && $res->is_success;

        my $content = $res->content;
        my %args = OpenID::util::parse_keyvalue($content);

        # delete the handle from our cache
        if (my $ih = $args{'invalidate_handle'}) {
            Net::OpenID::Association::invalidate_handle($self, $server, $ih);
        }

        return $self->_fail("naive_verify_failed_return") unless
            $args{'is_valid'} eq "true" ||  # protocol 1.1
            $args{'lifetime'} > 0;          # DEPRECATED protocol 1.0
    }

    $self->_debug("verified identity! = $real_ident");

    # verified!
    return Net::OpenID::VerifiedIdentity->new(
        claimed_identity => $claimed_identity,
        consumer  => $self,
        signed_fields => \%signed_fields,
    );
}

sub supports_consumer_secret { 1; }

sub _get_consumer_secret {
    my Net::OpenID::Consumer $self = shift;
    my $time = shift;

    my $ss;
    if (ref $self->{consumer_secret} eq "CODE") {
        $ss = $self->{consumer_secret};
    } elsif ($self->{consumer_secret}) {
        $ss = sub { return $self->{consumer_secret}; };
    } else {
        Carp::croak("You haven't defined a consumer_secret value or subref.\n");
    }

    my $sec = $ss->($time);
    Carp::croak("Consumer secret too long") if length($sec) > 255;
    return $sec;
}

package OpenID::util;

use constant VERSION_1_NAMESPACE => "http://openid.net/signon/1.1";
use constant VERSION_2_NAMESPACE => "http://specs.openid.net/auth/2.0";

# I guess this is a bit daft since constants are subs anyway,
# but whatever.
sub version_1_namespace {
    return VERSION_1_NAMESPACE;
}
sub version_2_namespace {
    return VERSION_2_NAMESPACE;
}
sub version_1_xrds_service_url {
    return VERSION_1_NAMESPACE;
}
sub version_2_xrds_service_url {
    return "http://specs.openid.net/auth/2.0/signon";
}
sub version_2_xrds_directed_service_url {
    return "http://specs.openid.net/auth/2.0/server";
}
sub version_2_identifier_select_url {
    return "http://specs.openid.net/auth/2.0/identifier_select";
}

# From Digest::HMAC
sub hmac_sha1_hex {
    unpack("H*", &hmac_sha1);
}
sub hmac_sha1 {
    hmac($_[0], $_[1], \&Digest::SHA1::sha1, 64);
}
sub hmac {
    my($data, $key, $hash_func, $block_size) = @_;
    $block_size ||= 64;
    $key = &$hash_func($key) if length($key) > $block_size;

    my $k_ipad = $key ^ (chr(0x36) x $block_size);
    my $k_opad = $key ^ (chr(0x5c) x $block_size);

    &$hash_func($k_opad, &$hash_func($k_ipad, $data));
}

sub parse_keyvalue {
    my $reply = shift;
    my %ret;
    $reply =~ s/\r//g;
    foreach (split /\n/, $reply) {
        next unless /^(\S+?):(.*)/;
        $ret{$1} = $2;
    }
    return %ret;
}

sub ejs
{
    my $a = $_[0];
    $a =~ s/[\"\'\\]/\\$&/g;
    $a =~ s/\r?\n/\\n/gs;
    $a =~ s/\r//;
    return $a;
}

# Data::Dumper for JavaScript
sub js_dumper {
    my $obj = shift;
    if (ref $obj eq "HASH") {
        my $ret = "{";
        foreach my $k (keys %$obj) {
            $ret .= "$k: " . js_dumper($obj->{$k}) . ",";
        }
        chop $ret;
        $ret .= "}";
        return $ret;
    } elsif (ref $obj eq "ARRAY") {
        my $ret = "[" . join(", ", map { js_dumper($_) } @$obj) . "]";
        return $ret;
    } else {
        return $obj if $obj =~ /^\d+$/;
        return "\"" . ejs($obj) . "\"";
    }
}

sub eurl
{
    my $a = $_[0];
    $a =~ s/([^a-zA-Z0-9_\,\-.\/\\\: ])/uc sprintf("%%%02x",ord($1))/eg;
    $a =~ tr/ /+/;
    return $a;
}

sub push_url_arg {
    my $uref = shift;
    $$uref =~ s/[&?]$//;
    my $got_qmark = ($$uref =~ /\?/);

    while (@_) {
        my $key = shift;
        my $value = shift;
        $$uref .= $got_qmark ? "&" : ($got_qmark = 1, "?");
        $$uref .= eurl($key) . "=" . eurl($value);
    }
}

sub push_openid2_url_arg {
    my $uref = shift;
    my %args = @_;
    push_url_arg($uref,
        'openid.ns' => VERSION_2_NAMESPACE,
        map {
            'openid.'.$_ => $args{$_}
        } keys %args,
    );
}

sub time_to_w3c {
    my $time = shift || time();
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($time);
    $mon++;
    $year += 1900;

    return sprintf("%04d-%02d-%02dT%02d:%02d:%02dZ",
                   $year, $mon, $mday,
                   $hour, $min, $sec);
}

sub w3c_to_time {
    my $hms = shift;
    return 0 unless
        $hms =~ /^(\d{4,4})-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)Z$/;

    my $time;
    eval {
        $time = Time::Local::timegm($6, $5, $4, $3, $2 - 1, $1);
    };
    return 0 if $@;
    return $time;
}

sub bi2bytes {
    my $bigint = shift;
    die "Can't deal with negative numbers" if $bigint->is_negative;

    my $bits = $bigint->as_bin;
    die unless $bits =~ s/^0b//;

    # prepend zeros to round to byte boundary, or to unset high bit
    my $prepend = (8 - length($bits) % 8) || ($bits =~ /^1/ ? 8 : 0);
    $bits = ("0" x $prepend) . $bits if $prepend;

    return pack("B*", $bits);
}

sub bi2arg {
    return b64(bi2bytes($_[0]));
}

sub b64 {
    my $val = MIME::Base64::encode_base64($_[0]);
    $val =~ s/\s+//g;
    return $val;
}

sub d64 {
    return MIME::Base64::decode_base64($_[0]);
}

sub bytes2bi {
    return Math::BigInt->new("0b" . unpack("B*", $_[0]));
}

sub arg2bi {
    return undef unless defined $_[0] and $_[0] ne "";
    # don't acccept base-64 encoded numbers over 700 bytes.  which means
    # those over 4200 bits.
    return Math::BigInt->new("0") if length($_[0]) > 700;
    return bytes2bi(MIME::Base64::decode_base64($_[0]));
}


__END__

=head1 NAME

Net::OpenID::Consumer - library for consumers of OpenID identities

=head1 SYNOPSIS

  use Net::OpenID::Consumer;

  my $csr = Net::OpenID::Consumer->new(
    ua    => LWPx::ParanoidAgent->new,
    cache => Some::Cache->new,
    args  => $cgi,
    consumer_secret => ...,
    required_root => "http://site.example.com/",
  );

  # a user entered, say, "bradfitz.com" as their identity.  The first
  # step is to fetch that page, parse it, and get a
  # Net::OpenID::ClaimedIdentity object:

  my $claimed_identity = $csr->claimed_identity("bradfitz.com");

  # now your app has to send them at their identity server's endpoint
  # to get redirected to either a positive assertion that they own
  # that identity, or where they need to go to login/setup trust/etc.

  my $check_url = $claimed_identity->check_url(
    return_to  => "http://example.com/openid-check.app?yourarg=val",
    trust_root => "http://example.com/",
  );

  # so you send the user off there, and then they come back to
  # openid-check.app, then you see what the identity server said.

  # Either use callback-based API (recommended)...
  $csr->handle_server_response(
      not_openid => sub {
          die "Not an OpenID message";
      },
      setup_required => sub {
          my $setup_url = shift;
          # Redirect the user to $setup_url
      },
      cancelled => sub {
          # Do something appropriate when the user hits "cancel" at the OP
      },
      verified => sub {
          my $vident = shift;
          # Do something with the VerifiedIdentity object $vident
      },
      error => sub {
          my $err = shift;
          die($err);
      },
  );

  # ... or handle the various cases yourself
  if (my $setup_url = $csr->user_setup_url) {
       # redirect/link/popup user to $setup_url
  } elsif ($csr->user_cancel) {
       # restore web app state to prior to check_url
  } elsif (my $vident = $csr->verified_identity) {
       my $verified_url = $vident->url;
       print "You are $verified_url !";
  } else {
       die "Error validating identity: " . $csr->err;
  }


=head1 DESCRIPTION

This is the Perl API for (the consumer half of) OpenID, a distributed
identity system based on proving you own a URL, which is then your
identity.  More information is available at:

  http://openid.net/

=head1 CONSTRUCTOR

=over 4

=item C<new>

my $csr = Net::OpenID::Consumer->new([ %opts ]);

You can set the C<ua>, C<cache>, C<consumer_secret>, C<required_root>,
C<minimum_version> and C<args> in the constructor.  See the corresponding
method descriptions below.

=back

=head1 METHODS

=over 4

=item $csr->B<ua>($user_agent)

=item $csr->B<ua>

Getter/setter for the LWP::UserAgent (or subclass) instance which will
be used when web donwloads are needed.  It's highly recommended that
you use LWPx::ParanoidAgent, or at least read its documentation so
you're aware of why you should care.

=item $csr->B<cache>($cache)

=item $csr->B<cache>

Getter/setter for the optional (but recommended!) cache instance you
want to use for storing fetched parts of pages.  (identity server
public keys, and the E<lt>headE<gt> section of user's HTML pages)

The $cache object can be anything that has a -E<gt>get($key) and
-E<gt>set($key,$value) methods.  See L<URI::Fetch> for more
information.  This cache object is just passed to L<URI::Fetch>
directly.

=item $nos->B<consumer_secret>($scalar)

=item $nos->B<consumer_secret>($code)

=item $code = $nos->B<consumer_secret>; ($secret) = $code->($time);

The consumer secret is used to generate self-signed nonces for the
return_to URL, to prevent spoofing.

In the simplest (and least secure) form, you configure a static secret
value with a scalar.  If you use this method and change the scalar
value, any outstanding requests from the last 30 seconds or so will fail.

The more robust (but more complicated) form is to supply a subref that
returns a secret based on the provided I<$time>, a unix timestamp.
And if one doesn't exist for that time, create, store and return it
(with appropriate locking so you never return different secrets for
the same time.)

Your secret may not exceed 255 characters.

=item $csr->B<minimum_version>(2)

=item $csr->B<minimum_version>

Get or set the minimum OpenID protocol version supported. Currently
the only useful value you can set here is 2, which will cause
1.1 identifiers to fail discovery with the error C<protocol_version_incorrect>.

In most cases you'll want to allow both 1.1 and 2.0 identifiers,
which is the default. If you want, you can set this property to 1
to make this behavior explicit.

=item $csr->B<message>($key)

Obtain a value from the message contained in the request arguments
with the given key. This can only be used to obtain core arguments,
not extension arguments.

Call this method without a C<$key> argument to get a L<Net::OpenID::IndirectMessage>
object representing the message.

=item $csr->B<args>($ref)

=item $csr->B<args>($param)

=item $csr->B<args>

Can be used in 1 of 3 ways:

1. Setting the way which the Consumer instances obtains GET parameters:

$csr->args( $reference )

Where $reference is either a HASH ref, CODE ref, Apache $r,
Apache::Request $apreq, or CGI.pm $cgi.  If a CODE ref, the subref
must return the value given one argument (the parameter to retrieve)

If you pass in an Apache $r object, you must not have already called
$r->content as the consumer module will want to get the request
arguments out of here in the case of a POST request.

2. Get a paramater:

my $foo = $csr->args("foo");

When given an unblessed scalar, it retrieves the value.  It croaks if
you haven't defined a way to get at the parameters.

Most callers should instead use the C<message> method above, which
abstracts away the need to understand OpenID's message serialization.

3. Get the getter:

my $code = $csr->args;

Without arguments, returns a subref that returns the value given a
parameter name.

Most callers should instead use the C<message> method above with no
arguments, which returns an object from which extension attributes
can be obtained by their documented namespace URI.

=item $nos->B<required_root>($url_prefix)

=item $url_prefix = $nos->B<required_root>

If provided, this is the required string that all return_to URLs must
start with.  If it doesn't match, it'll be considered invalid (spoofed
from another site)

=item $csr->B<claimed_identity>($url)

Given a user-entered $url (which could be missing http://, or have
extra whitespace, etc), returns either a Net::OpenID::ClaimedIdentity
object, or undef on failure.

Note that this identity is NOT verified yet.  It's only who the user
claims they are, but they could be lying.

If this method returns undef, you can rely on the following errors
codes (from $csr->B<errcode>) to decide what to present to the user:

=over 8

=item no_identity_server

=item empty_url

=item bogus_url

=item no_head_tag

=item url_fetch_err

=back

=item $csr->B<handle_server_response>( %callbacks );

When a request comes in that contains a response from an OpenID provider,
figure out what it means and dispatch to an appropriate callback to handle
the request. This is the callback-based alternative to explicitly calling
the methods below in the correct sequence, and is recommended unless you
need to do something strange.

Anything you return from the selected callback function will be returned
by this method verbatim. This is useful if the caller needs to return
something different in each case.

The available callbacks are:

=over 8

=item B<not_openid> - the request isn't an OpenID response after all.

=item B<setup_required>($setup_url) - the provider needs to present some UI to the user before it can respond. Send the user to the given URL by some means.

=item B<cancelled> - the user cancelled the authentication request from the provider's UI

=item B<verified>($verified_identity) - the user's identity has been successfully verified. A L<Net::OpenID::VerifiedIdentity> object is passed in.

=item B<error>($errcode, $errmsg) - an error has occured. An error code and message are provided.

=back

=item $csr->B<user_setup_url>( [ %opts ] )

Returns the URL the user must return to in order to login, setup trust,
or do whatever the identity server needs them to do in order to make
the identity assertion which they previously initiated by entering
their claimed identity URL.  Returns undef if this setup URL isn't
required, in which case you should ask for the verified_identity.

The base URL this this function returns can be modified by using the
following options in %opts:

=over

=item C<post_grant>

What you're asking the identity server to do with the user after they
setup trust.  Can be either C<return> or C<close> to return the user
back to the return_to URL, or close the browser window with
JavaScript.  If you don't specify, the behavior is undefined (probably
the user gets a dead-end page with a link back to the return_to URL).
In any case, the identity server can do whatever it wants, so don't
depend on this.

=back

=item $csr->B<user_cancel>

Returns true if the user declined to share their identity, false
otherwise.  (This function is literally one line: returns true if
"openid.mode" eq "cancel")

It's then your job to restore your app to where it was prior to
redirecting them off to the user_setup_url, using the other query
parameters that you'd sent along in your return_to URL.

=item $csr->B<verified_identity>( [ %opts ] )

Returns a Net::OpenID::VerifiedIdentity object, or undef.
Verification includes double-checking the reported identity URL
declares the identity server, verifying the signature, etc.

The options in %opts may contain:

=over

=item C<required_root>

Sets the required_root just for this request.  Values returns to its
previous value afterwards.

=back

=item $csr->B<err>

Returns the last error, in form "errcode: errtext"

=item $csr->B<errcode>

Returns the last error code.

=item $csr->B<errtext>

Returns the last error text.

=item $csr->B<json_err>

Returns the last error code/text in JSON format.

=back

=head1 COPYRIGHT

This module is Copyright (c) 2005 Brad Fitzpatrick.
All rights reserved.

You may distribute under the terms of either the GNU General Public
License or the Artistic License, as specified in the Perl README file.
If you need more liberal licensing terms, please contact the
maintainer.

=head1 WARRANTY

This is free software. IT COMES WITHOUT WARRANTY OF ANY KIND.

=head1 MAILING LIST

The Net::OpenID family of modules has a mailing list powered
by Google Groups. For more information, see
http://groups.google.com/group/openid-perl .

=head1 SEE ALSO

OpenID website: http://openid.net/

L<Net::OpenID::ClaimedIdentity> -- part of this module

L<Net::OpenID::VerifiedIdentity> -- part of this module

L<Net::OpenID::Server> -- another module, for acting like an OpenID server

=head1 AUTHORS

Brad Fitzpatrick <brad@danga.com>

Tatsuhiko Miyagawa <miyagawa@sixapart.com>

Martin Atkins <mart@degeneration.co.uk>

