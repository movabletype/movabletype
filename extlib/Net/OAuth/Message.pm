package Net::OAuth::Message;
use warnings;
use strict;
use base qw/Class::Data::Inheritable Class::Accessor/;
use URI::Escape;
use UNIVERSAL::require;
use Net::OAuth;
use URI;
use URI::QueryParam;

use constant OAUTH_PREFIX => 'oauth_';

our $OAUTH_PREFIX_RE = do {my $p = OAUTH_PREFIX; qr/^$p/};

__PACKAGE__->mk_classdata(extension_param_patterns => []);

sub add_required_message_params {
    my $class = shift;
    $class->required_message_params([@{$class->required_message_params}, @_]);
    $class->all_message_params([@{$class->all_message_params}, @_]);
    $class->all_params([@{$class->all_params}, @_]);
    $class->mk_accessors(@_);
}

sub add_optional_message_params {
    my $class = shift;
    $class->optional_message_params([@{$class->optional_message_params}, @_]);
    $class->all_message_params([@{$class->all_message_params}, @_]);
    $class->all_params([@{$class->all_params}, @_]);
    $class->mk_accessors(@_);
}

sub add_required_api_params {
    my $class = shift;
    $class->required_api_params([@{$class->required_api_params}, @_]);
    $class->all_api_params([@{$class->all_api_params}, @_]);
    $class->all_params([@{$class->all_params}, @_]);
    $class->mk_accessors(@_);
}

sub add_extension_param_pattern {
    my $class = shift;
    $class->extension_param_patterns([@{$class->extension_param_patterns}, @_]);
}

sub add_to_signature {
    my $class = shift;
    $class->signature_elements([@{$class->signature_elements}, @_]);
}

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my %params = @_;
    $class = get_versioned_class($class, \%params);
    my $self = bless \%params, $class;
    $self->set_defaults;
    $self->check;
    return $self;
}

sub get_versioned_class {
    my $class = shift;
    my $params = shift;
    my $protocol_version = $params->{protocol_version} || $Net::OAuth::PROTOCOL_VERSION;
    if (defined $protocol_version and $protocol_version == Net::OAuth::PROTOCOL_VERSION_1_0A and $class !~ /\::V1_0A\::/) {
        (my $versioned_class = $class) =~ s/::(\w+)$/::V1_0A::$1/;
        if ($versioned_class->require) {
            return $versioned_class;
        }
    }
    return $class;
}

sub set_defaults {
    my $self = shift;
    $self->{extra_params} ||= {};
    $self->{version} ||= Net::OAuth::OAUTH_VERSION unless $self->{from_hash};
}

sub is_extension_param {
    my $self = shift;
    my $param = shift;
    return grep ($param =~ $_, @{$self->extension_param_patterns});
}

sub check {
    my $self = shift;
    foreach my $k (@{$self->required_message_params}, @{$self->required_api_params}) {
        if (not defined $self->{$k}) {
            die "Missing required parameter '$k'";
        }
    }
    if ($self->{extra_params} and $self->allow_extra_params) {
        foreach my $k (keys %{$self->{extra_params}}) {
            if ($k =~ $OAUTH_PREFIX_RE) {
                die "Parameter '$k' not allowed in arbitrary params"
            }
        }
    }
}

sub encode {
    my $str = shift;
    $str = "" unless defined $str;
    unless($Net::OAuth::SKIP_UTF8_DOUBLE_ENCODE_CHECK) {
        if ($str =~ /[\x80-\xFF]/) {
            Encode->require;
            no strict 'subs';
            eval {
                Encode::decode_utf8($str, 1);
            };
            unless ($@) {
                warn "Warning: It looks like you are attempting to encode bytes that are already UTF-8 encoded.  You should probably use decode_utf8() first.  See the Net::OAuth manpage, I18N section";
            }
        }
    }
    return URI::Escape::uri_escape_utf8($str,'^\w.~-');
}

sub decode {
    my $str = shift;
    return uri_unescape($str);
}

sub allow_extra_params {1}

sub sign_message {0}

sub gather_message_parameters {
    my $self = shift;
    my %opts = @_;
    $opts{quote} = "" unless defined $opts{quote};
    $opts{params} ||= [];
    my %params;
    foreach my $k (@{$self->required_message_params}, @{$self->optional_message_params}, @{$opts{add}}) {
        next if $k eq 'signature' and (!$self->sign_message or !grep ($_ eq 'signature', @{$opts{add}}));
        my $message_key = $self->is_extension_param($k) ? $k : OAUTH_PREFIX . $k;
        my $v = $self->$k;
        $params{$message_key} = $v if defined $v;
    }
    if ($self->{extra_params} and !$opts{no_extra} and $self->allow_extra_params) {
        foreach my $k (keys %{$self->{extra_params}}) {
            $params{$k} = $self->{extra_params}{$k};
        }
        if ($self->can('request_url')) {
            my $url = $self->request_url;
            _ensure_uri_object($url);         
            foreach my $k ($url->query_param) {
                $params{$k} = $url->query_param($k);
            }
        }
    }
    if ($opts{hash}) {
        return \%params;
    }
    my @pairs;
    while (my ($k,$v) = each %params) {
        push @pairs, join('=', encode($k), $opts{quote} . encode($v) . $opts{quote});
    }
    return sort(@pairs);
}

sub normalized_message_parameters {
    my $self = shift;
    return join('&',  $self->gather_message_parameters);
}

sub signature_base_string {
    my $self = shift;
    return join('&', map(encode($self->$_), @{$self->signature_elements}));
}

sub sign {
    my $self = shift;
    my $class = $self->_signature_method_class;
    $self->signature($class->sign($self, @_));
}

sub verify {
    my $self = shift;
    my $class = $self->_signature_method_class;
    return $class->verify($self, @_);
}

sub _signature_method_class {
    my $self = shift;
    (my $signature_method = $self->signature_method) =~ s/\W+/_/g;
    my $klass = 'Net::OAuth::SignatureMethod::' . $signature_method;
    $klass->require or die "Unable to load $signature_method plugin";
    return $klass;
}

sub to_authorization_header {
    my $self = shift;
    my $realm = shift;
    my $sep = shift || ",";
    if (defined $realm) {
        $realm = "realm=\"$realm\"$sep";
    }
    else {
        $realm = "";
    }
    return "OAuth $realm" .
        join($sep, $self->gather_message_parameters(quote => '"', add => [qw/signature/], no_extra => 1));
}

sub from_authorization_header {
    my $proto = shift;
    my $header = shift;
    my $class = ref $proto || $proto;
    die "Header must start with \"OAuth \"" unless $header =~ s/OAuth //;
    my @header = split /[\s]*,[\s]*/, $header;
    shift @header if $header[0] =~ /^realm=/i;
    return $class->_from_pairs(\@header, @_)
}

sub _from_pairs() {
	my $class = shift;
	my $pairs = shift;
	if (ref $pairs ne 'ARRAY') {
		die 'Expected an array!';
	}
	my %params;
	foreach my $pair (@$pairs) {
        my ($k,$v) = split /=/, $pair;
        if (defined $k and defined $v) {
            $v =~ s/(^"|"$)//g;
            ($k,$v) = map decode($_), $k, $v;
            $params{$k} = $v;
        }
    }
    return $class->from_hash(\%params, @_);
}

sub from_hash {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $hash = shift;
	if (ref $hash ne 'HASH') {
		die 'Expected a hash!';
	}
    my %api_params = @_;
    # need to do this earlier than Message->new because
    # the below validation step needs the correct class.
    # https://rt.cpan.org/Public/Bug/Display.html?id=47293
    $class = get_versioned_class($class, \%api_params);
    my %msg_params;
    foreach my $k (keys %$hash) {
        if ($k =~ s/$OAUTH_PREFIX_RE//) {
            if (!grep ($_ eq $k, @{$class->all_message_params})) {
               die "Parameter ". OAUTH_PREFIX ."$k not valid for a message of type $class\n";
            }
            else {
                $msg_params{$k} = $hash->{OAUTH_PREFIX . $k};
            }
        }
        elsif ($class->is_extension_param($k)) {
            if (!grep ($_ eq $k, @{$class->all_message_params})) {
                die "Parameter $k not valid for a message of type $class\n";
            }
            else {
                $msg_params{$k} = $hash->{$k};
            }
        }
        else {
            $msg_params{extra_params}->{$k} = $hash->{$k};
        }
    }
    $api_params{from_hash} = 1;
    return $class->new(%msg_params, %api_params);
}

sub _ensure_uri_object {
    $_[0] = UNIVERSAL::isa($_[0], 'URI') ? $_[0] : URI->new($_[0]);
}

sub from_url {
	my $proto = shift;
    my $class = ref $proto || $proto;
    my $url = shift;
	_ensure_uri_object($url);
	return $class->from_hash($url->query_form_hash, @_);
}

sub to_post_body {
    my $self = shift;
    return join('&', $self->gather_message_parameters(add => [qw/signature/]));
}

sub from_post_body {
	my $proto = shift;
    my $class = ref $proto || $proto;
    my @pairs = split '&', shift;
	return $class->_from_pairs(\@pairs, @_);
}

sub to_hash {
    my $self = shift;
    return $self->gather_message_parameters(hash => 1, add => [qw/signature/]);
}

sub to_url {
	my $self = shift;
	my $url = shift;
	if (!defined $url and $self->can('request_url') and defined $self->request_url) {
		$url = $self->request_url;
	}
	if (defined $url) {
        _ensure_uri_object($url);
        $url = $url->clone; # don't modify the URL that was passed in
        $url->query(undef); # remove any existing query params, as these may cause the signature to break	
		my $params = $self->to_hash;
		my $sep = '?';
		foreach my $k (sort keys %$params) {
		    $url .= $sep . encode($k) . '=' . encode( $params->{$k} );
            $sep = '&' if $sep eq '?';
		}
		return $url;
	}
	else {
		return $self->to_post_body;
	}
}

=head1 NAME

Net::OAuth::Message - base class for OAuth messages

=head1 SEE ALSO

L<Net::OAuth>, L<http://oauth.net>

=head1 AUTHOR

Keith Grennan, C<< <kgrennan at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Keith Grennan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
