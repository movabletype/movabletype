package JSON::WebToken;

use strict;
use warnings;
use 5.008_001;

our $VERSION = '0.10';

use parent 'Exporter';

use Carp qw(croak carp);
use JSON qw(encode_json decode_json);
use MIME::Base64 qw(encode_base64 decode_base64);
use Module::Runtime qw(use_module);

use JSON::WebToken::Constants;
use JSON::WebToken::Exception;

our @EXPORT = qw(encode_jwt decode_jwt);

our $ALGORITHM_MAP = {
    # for JWS
    HS256  => 'HMAC',
    HS384  => 'HMAC',
    HS512  => 'HMAC',
    RS256  => 'RSA',
    RS384  => 'RSA',
    RS512  => 'RSA',
#    ES256  => 'EC',
#    ES384  => 'EC',
#    ES512  => 'EC',
    none   => 'NONE',

    # for JWE
    RSA1_5           => 'RSA',
#    'RSA-OAEP'       => 'OAEP',
#    A128KW           => '',
#    A256KW           => '',
    dir              => 'NONE',
#    'ECDH-ES'        => '',
#    'ECDH-ES+A128KW' => '',
#    'ECDH-ES+A256KW' => '',

    # for JWK
#    EC  => 'EC',
    RSA => 'RSA',
};

#our $ENCRIPTION_ALGORITHM_MAP = {
#    'A128CBC+HS256' => 'AES_CBC',
#    'A256CBC+HS512' => 'AES_CBC',
#    A128GCM         => '',
#    A256GCM         => '',
#};

our $DEFAULT_ALLOWED_ALGORITHMS = [ grep { $_ ne "none" } (keys %$ALGORITHM_MAP) ];

sub encode {
    my ($class, $claims, $secret, $algorithm, $extra_headers) = @_;
    unless (ref $claims eq 'HASH') {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_INVALID_PARAMETER,
            message => 'Usage: JSON::WebToken->encode(\%claims [, $secret, $algorithm, \%$extra_headers ])',
        );
    }

    $algorithm     ||= 'HS256';
    $extra_headers ||= {};

    my $header = {
#        typ parameter is OPTIONAL ("JWT" or "urn:ietf:params:oauth:token-type:jwt")
#        typ => 'JWT',
        alg => $algorithm,
        %$extra_headers,
    };

    $algorithm = $header->{alg};
    if ($algorithm ne 'none' && !defined $secret) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_MISSING_SECRET,
            message => 'secret must be specified',
        );
    }

    my $header_segment  = encode_base64url(encode_json $header);
    my $claims_segment  = encode_base64url(encode_json $claims);
    my $signature_input = join '.', $header_segment, $claims_segment;

    my $signature = $class->_sign($algorithm, $signature_input, $secret);

    return join '.', $signature_input, encode_base64url($signature);
}

sub encode_jwt {
    local $Carp::CarpLevel = $Carp::CarpLevel + 1;
    __PACKAGE__->encode(@_);
}

sub decode {
    my ($class, $jwt, $secret, $verify_signature, $accepted_algorithms) = @_;

    if (ref $accepted_algorithms eq 'ARRAY') {
        # do nothing
    }
    elsif (defined $accepted_algorithms) {
        if ($accepted_algorithms =~/^[01]$/) {
            carp "accept_algorithm none is deprecated";
            $accepted_algorithms = !!$accepted_algorithms ?
                [@$DEFAULT_ALLOWED_ALGORITHMS, "none"] :  $DEFAULT_ALLOWED_ALGORITHMS;
        }
        else {
            $accepted_algorithms = [ $accepted_algorithms ];
        }
    }
    else {
        $accepted_algorithms = $DEFAULT_ALLOWED_ALGORITHMS;
    }

    unless (defined $jwt) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_INVALID_PARAMETER,
            message => 'Usage: JSON::WebToken->decode($jwt [, $secret, $verify_signature, $accepted_algorithms ])',
        );
    }

    $verify_signature = 1 unless defined $verify_signature;
    if ($verify_signature && !defined $secret) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_MISSING_SECRET,
            message => 'secret must be specified',
        );
    }

    my $segments = [ split '\.', $jwt ];
    unless (@$segments >= 2 && @$segments <= 4) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_INVALID_SEGMENT_COUNT,
            message => "Not enough or too many segments by $jwt",
        );
    }

    my ($header_segment, $claims_segment, $crypto_segment) = @$segments;
    my $signature_input = join '.', $header_segment, $claims_segment;

    my ($header, $claims, $signature);
    eval {
        $header    = decode_json decode_base64url($header_segment);
        $claims    = decode_json decode_base64url($claims_segment);
        $signature = decode_base64url($crypto_segment) if $header->{alg} ne 'none' && $verify_signature;
    };
    if (my $e = $@) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_INVALID_SEGMENT_ENCODING,
            message => 'Invalid segment encoding',
        );
    }

    return $claims unless $verify_signature;

    my $algorithm = $header->{alg};
    # https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-37#section-3.6
    unless ( grep { $_ eq $algorithm } (@$accepted_algorithms) ) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_UNACCEPTABLE_ALGORITHM,
            message => "Algorithm \"$algorithm\" is not acceptable. Followings are accepted:" . join(",", @$accepted_algorithms) ,
        );
    }

    if (ref $secret eq 'CODE') {
        $secret = $secret->($header, $claims);
    }

    if ($algorithm eq 'none' and $crypto_segment) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_UNWANTED_SIGNATURE,
            message => 'Signature must be the empty string when alg is none',
        );
    }

    unless ($class->_verify($algorithm, $signature_input, $secret, $signature)) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_INVALID_SIGNATURE,
            message => "Invalid signature by $signature",
        );
    }

    return $claims;
}

sub decode_jwt {
    local $Carp::CarpLevel = $Carp::CarpLevel + 1;
    __PACKAGE__->decode(@_);
}

sub add_signing_algorithm {
    my ($class, $algorithm, $signing_class) = @_;
    unless ($algorithm && $signing_class) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_INVALID_PARAMETER,
            message => 'Usage: JSON::WebToken->add_signing_algorithm($algorithm, $signing_class)',
        );
    }
    push(@$DEFAULT_ALLOWED_ALGORITHMS, $algorithm);
    $ALGORITHM_MAP->{$algorithm} = $signing_class;
}

sub _sign {
    my ($class, $algorithm, $message, $secret) = @_;
    return '' if $algorithm eq 'none';

    local $Carp::CarpLevel = $Carp::CarpLevel + 1;
    $class->_ensure_class_loaded($algorithm)->sign($algorithm, $message, $secret);
}

sub _verify {
    my ($class, $algorithm, $message, $secret, $signature) = @_;
    return 1 if $algorithm eq 'none';

    local $Carp::CarpLevel = $Carp::CarpLevel + 1;
    $class->_ensure_class_loaded($algorithm)->verify($algorithm, $message, $secret, $signature);
}

my (%class_loaded, %alg_to_class);
sub _ensure_class_loaded {
    my ($class, $algorithm) = @_;
    return $alg_to_class{$algorithm} if $alg_to_class{$algorithm};

    my $klass = $ALGORITHM_MAP->{$algorithm};
    unless ($klass) {
        JSON::WebToken::Exception->throw(
            code    => ERROR_JWT_NOT_SUPPORTED_SIGNING_ALGORITHM,
            message => "`$algorithm` is Not supported siging algorithm",
        );
    }

    my $signing_class = $klass =~ s/^\+// ? $klass : "JSON::WebToken::Crypt::$klass";
    return $signing_class if $class_loaded{$signing_class};

    use_module $signing_class unless $class->_is_inner_package($signing_class);

    $class_loaded{$signing_class} = 1;
    $alg_to_class{$algorithm}     = $signing_class;

    return $signing_class;
}

sub _is_inner_package {
    my ($class, $klass) = @_;
    no strict 'refs';
    %{ "$klass\::" } ? 1 : 0;
}

####################################################
# Taken from newer MIME::Base64
# In order to support older version of MIME::Base64
####################################################
sub encode_base64url {
    my $e = encode_base64(shift, "");
    $e =~ s/=+\z//;
    $e =~ tr[+/][-_];
    return $e;
}

sub decode_base64url {
    my $s = shift;
    $s =~ tr[-_][+/];
    $s .= '=' while length($s) % 4;
    return decode_base64($s);
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

JSON::WebToken - JSON Web Token (JWT) implementation

=head1 SYNOPSIS

  use Test::More;
  use JSON;
  use JSON::WebToken;

  my $claims = {
      iss => 'joe',
      exp => 1300819380,
      'http://example.com/is_root' => JSON::true,
  };
  my $secret = 'secret';

  my $jwt = encode_jwt $claims, $secret;
  my $got = decode_jwt $jwt, $secret;
  is_deeply $got, $claims;

  done_testing;

=head1 DESCRIPTION

JSON::WebToken is JSON Web Token (JWT) implementation for Perl

B<< THIS MODULE IS ALPHA LEVEL INTERFACE. >>

=head1 METHODS

=head2 encode($claims [, $secret, $algorithm, $extra_headers ]) : String

This method is encoding JWT from hash reference.

  my $jwt = JSON::WebToken->encode({
      iss => 'joe',
      exp => 1300819380,
      'http://example.com/is_root' => JSON::true,
  }, 'secret');
  # $jwt = join '.',
  #     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
  #     'eyJleHAiOjEzMDA4MTkzODAsImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlLCJpc3MiOiJqb2UifQ'
  #     '4ldFxjibgJGz_uaIRCIq89b5ipR-sbI2Uq7B2WNEDs0'

Default encryption algorithm is C<< HS256 >>. You can change algorithm as following:

  my $pricate_key_string = '...';
  my $public_key_string  = '...';

  my $jwt = JSON::WebToken->encode({
      iss => 'joe',
      exp => 1300819380,
      'http://example.com/is_root' => JSON::true,
  }, $pricate_key_string, 'RS256');

  my $claims = JSON::WebToken->decode($jwt, $public_key_string);

When you use RS256, RS384 or RS512 algorithm then, We need L<< Crypt::OpenSSL::RSA >>.

If you want to create a C<< Plaintext JWT >>, should be specify C<< none >> for the algorithm.

  my $jwt = JSON::WebToken->encode({
      iss => 'joe',
      exp => 1300819380,
      'http://example.com/is_root' => JSON::true,
  }, '', 'none');
  # $jwt = join '.',
  #     'eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0',
  #     'eyJleHAiOjEzMDA4MTkzODAsImh0dHA6Ly9leGFtcGxlLmNvbS9pc19yb290Ijp0cnVlLCJpc3MiOiJqb2UifQ',
  #     ''

=head2 decode($jwt [, $secret, $verify_signature, $accepted_algorithms ]) : HASH

This method is decoding hash reference from JWT string.

  my $claims = JSON::WebToken->decode($jwt, $secret, 1, ["RS256"]);

Any signing algorithm (except "none") is acceptable by default,
so you should check it with $accepted_algorithms parameter.

=head2 add_signing_algorithm($algorithm, $class)

This method is adding signing algorithm.

  # resolve JSON::WebToken::Crypt::MYALG
  JSON::WebToken->add_signing_algorithm('MYALGXXX'   => 'MYALG');

  # resolve Some::Class::Algorithm
  JSON::WebToken->add_signing_algorithm('SOMEALGXXX' => '+Some::Class::Algorithm');

SEE ALSO L<< JSON::WebToken::Crypt::HMAC >> or L<< JSON::WebToken::Crypt::RAS >>.

=head1 FUNCTIONS

=head2 encode_jwt($claims [, $secret, $algorithm, $extra_headers ]) : String

Same as C<< encode() >> method.

=head2 decode_jwt($jwt [, $secret, $verify_signature, $accepted_algorithms ]) : Hash

Same as C<< decode() >> method.

=head1 ERROR CODES

JSON::WebToken::Exception will be thrown with following code.

=head2 ERROR_JWT_INVALID_PARAMETER

When some method arguments are not valid.

=head2 ERROR_JWT_MISSING_SECRET

When secret is required. (C<< alg != "none" >>)

=head2 ERROR_JWT_INVALID_SEGMENT_COUNT

When JWT segment count is not between 2 and 4.

=head2 ERROR_JWT_INVALID_SEGMENT_ENCODING

When each JWT segment is not encoded by base64url.

=head2 ERROR_JWT_UNWANTED_SIGNATURE

When C<< alg == "none" >> but signature segment found.

=head2 ERROR_JWT_INVALID_SIGNATURE

When JWT signature is invalid.

=head2 ERROR_JWT_NOT_SUPPORTED_SIGNING_ALGORITHM

When given signing algorithm is not supported.

=head2 ERROR_JWT_UNACCEPTABLE_ALGORITHM

When given signing algorithm is not included in acceptable_algorithms.

=head1 AUTHOR

xaicron E<lt>xaicron@cpan.orgE<gt>

zentooo

=head1 COPYRIGHT

Copyright 2012 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<< http://tools.ietf.org/html/draft-ietf-oauth-json-web-token >>

=cut
