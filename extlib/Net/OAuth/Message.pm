package Net::OAuth::Message;
use warnings;
use strict;
use base qw/Class::Data::Inheritable Class::Accessor/;
use URI::Escape;
use UNIVERSAL::require;

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

sub add_to_signature {
    my $class = shift;
    $class->signature_elements([@{$class->signature_elements}, @_]);
}

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;
	my %params = @_;
	my $self = bless \%params, $class;
	$self->{extra_params} ||= {};
	$self->{version} ||= '1.0';
    $self->check;
    return $self;
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
            if ($k =~ /^oauth_/) {
                die "Parameter '$k' not allowed in arbitrary params"
            }
        }
    }
}

sub encode {
    my $str = shift;
    $str = "" unless defined $str;
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
        $params{"oauth_$k"} = $self->$k;
    }
    if ($self->{extra_params} and !$opts{no_extra} and $self->allow_extra_params) {
        foreach my $k (keys %{$self->{extra_params}}) {
            $params{$k} = $self->{extra_params}{$k};
        }
    }
    if ($opts{hash}) {
        return \%params;
    }
    my @pairs;
    while (my ($k,$v) = each %params) {
        push @pairs, join('=', encode($k), $opts{quote} . encode($v) . $opts{quote});
    }
    return sort(@pairs); # sort not required here but makes module more testable
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
    return join($sep, "OAuth realm=\"$realm\"",
        $self->gather_message_parameters(quote => '"', add => [qw/signature/], no_extra => 1));
}

sub from_authorization_header {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my @header = split /[\s]*,[\s]*/, shift;
    shift @header;
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
    my %msg_params;
	foreach my $k (keys %$hash) {
		if ($k =~ s/^oauth_//) {
			if (!grep ($_ eq $k, @{$class->all_message_params})) {
				die "Parameter oauth_$k not valid for a message of type $class\n";
			}
			else {
				$msg_params{$k} = $hash->{"oauth_$k"};
			}
		}
		else {
			$msg_params{extra_params}->{$k} = $hash->{$k};
		}
	}
    return $class->new(%msg_params, %api_params);
}

sub from_url {
	my $proto = shift;
    my $class = ref $proto || $proto;
    my $url = shift;
	require URI;
	require URI::QueryParam;
    if (!UNIVERSAL::isa($url, 'URI')) {
		$url = URI->new($url);
	}
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
	my $uri = shift;
	if (!defined $uri and $self->can('request_url') and defined $self->request_url) {
		$uri = $self->request_url;
	}
	if (defined $uri) {
		require URI;
		require URI::QueryParam;
		$uri = URI->new("$uri");
		my $params = $self->to_hash;
		foreach my $k (sort keys %$params) {
			$uri->query_param($k, $params->{$k});
		}
		return $uri;
	}
	else {
		return $self->to_post_body;
	}
}

=head1 NAME

Net::OAuth::Message - base class for OAuth messages

=head1 SEE ALSO

L<http://oauth.net>

=head1 AUTHOR

Keith Grennan, C<< <kgrennan at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Keith Grennan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
