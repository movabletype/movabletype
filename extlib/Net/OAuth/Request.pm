package Net::OAuth::Request;
use warnings;
use strict;
use base qw/Class::Data::Inheritable Class::Accessor/;
use URI::Escape;
use UNIVERSAL::require;

our $VERSION = '0.06';

__PACKAGE__->mk_classdata(required_request_params => [qw/
    consumer_key
    signature_method
    timestamp
    nonce
    /]);

__PACKAGE__->mk_classdata(optional_request_params => [qw/
    version
    /]);

__PACKAGE__->mk_classdata(required_api_params => [qw/
    request_method
    request_url
    consumer_secret
    /]);

__PACKAGE__->mk_classdata(signature_elements => [qw/
    request_method
    request_url
    normalized_request_parameters
    /]);
    
__PACKAGE__->mk_accessors(
    @{__PACKAGE__->required_request_params}, 
    @{__PACKAGE__->optional_request_params},
    @{__PACKAGE__->required_api_params},
    qw/extra_params signature signature_key token_secret/
    );

sub add_required_request_params {
    my $class = shift;
    $class->required_request_params([@{$class->required_request_params}, @_]);
    $class->mk_accessors(@_);
}

sub add_optional_request_params {
    my $class = shift;
    $class->optional_request_params([@{$class->optional_request_params}, @_]);
    $class->mk_accessors(@_);
}

sub add_required_api_params {
    my $class = shift;
    $class->required_api_params([@{$class->required_api_params}, @_]);
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
    $params{version} = '1.0' unless defined $params{version};
    my $req = bless \%params, $class;
    $req->check;
    return $req;
}

sub check {
    my $self = shift;
    foreach my $k (@{$self->required_request_params}, @{$self->required_api_params}) {
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

sub gather_request_parameters {
    my $self = shift;
    my %opts = @_;
    $opts{quote} = "" unless defined $opts{quote};
    $opts{params} ||= [];
    my %params;
    foreach my $k (@{$self->required_request_params}, @{$self->optional_request_params}, @{$opts{add}}) {
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

sub normalized_request_parameters {
    my $self = shift;
    return join('&',  $self->gather_request_parameters);
}

sub signature_base_string {
    my $self = shift;
    return join('&', map(encode($self->$_), @{$self->signature_elements}));
}

sub signature_key {
    my $self = shift;
    # For some sig methods (I.e. RSA), users will pass in their own key
    my $key = $self->get('signature_key'); 
    unless (defined $key) {
        $key = encode($self->consumer_secret) . '&';
        $key .= encode($self->token_secret) if $self->can('token_secret');
    }
    return $key;
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
        $self->gather_request_parameters(quote => '"', add => [qw/signature/], no_extra => 1));
}

sub from_authorization_header {
    my $proto = shift;
    my $class = ref $proto || $proto;
    my $header = shift;
    my %extra_params = @_;
    my @header = split /[\s]*,[\s]*/, $header;
    shift @header;
    my %params;
    foreach my $pair (@header) {
        my ($k,$v) = split /=/, $pair;
        if (defined $k and defined $v) {
            $v =~ s/(^"|"$)//g;
            ($k,$v) = map decode($_), $k, $v;
            $k =~ s/^oauth_//;
            $params{$k} = $v;
        }
    }
    return $class->new(%params, %extra_params);
}

sub to_post_body {
    my $self = shift;
    return join('&', $self->gather_request_parameters(add => [qw/signature/]));
}

sub to_hash {
    my $self = shift;
    return $self->gather_request_parameters(hash => 1, add => [qw/signature/]);
}

=head1 NAME

Net::OAuth::Request - base class for OAuth requests

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
