package OAuth::Lite2::Signer;

use strict;
use warnings;

use MIME::Base64 qw(encode_base64);
use String::Random;
use URI;
use Carp ();
use Params::Validate;

use OAuth::Lite2::Signer::Algorithms;

=head1 NAME

OAuth::Lite2::Signer - OAuth 2.0 signature (DEPRECATED)

=head1 SYNOPSIS

    my $signed_params = OAuth::Lite2::Signer->sign(
        secret    => q{my_token_secret},
        algorithm => q{hmac-sha256},
        method    => q{GET},
        url       => q{http://example.org/protected/resource},
    );

=head1 DESCRIPTION

DEPRECATED. This is for old version of OAuth 2.0 draft specification.

This is for client to generate signed request,
or for server to verify received request.

=head1 METHODS

=head2 sign( %params )

Returns the hash reference that includes parameters for OAuth 2.0 signed request.

    my $signed_params = OAuth::Lite2::Signer->sign(
        secret    => q{my_token_secret},
        algorithm => q{hmac-sha256},
        method    => q{GET},
        url       => q{http://example.org/protected/resource},
    );

=over 4

=item secret

Access token secret.

=item algorithm

The algorithm what you make signature with.

=item method

HTTP method of the request.

=item url

URL of the request.

=item debug_nonce

Optional. If you omit this, nonce string is automatically generate random string.

=item debug_timestamp

Optional. If you omit this, current timestamp is set.

=back

=cut

sub sign {
    my $class = shift;

    my %args = Params::Validate::validate(@_, {
        secret          => 1,
        algorithm       => 1,
        method          => 1,
        url             => 1,
        debug_nonce     => { optional => 1 },
        debug_timestamp => { optional => 1 },
    });

    my $uri = URI->new($args{url});
    Carp::croak "invalid uri scheme: " . $args{url}
        unless ($uri->scheme eq 'http' || $uri->scheme eq 'https');

    my $params = {
        nonce     => $args{debug_nonce}     || $class->_gen_nonce(),
        timestamp => $args{debug_timestamp} || $class->_gen_timestamp(),
        algorithm => $args{algorithm},
    };

    my $string = $class->normalize_string(%$params,
        method => $args{method},
        host   => $uri->host,
        port   => $uri->port || 80,
        url    => $args{url},
    );

    my $algorithm =
        OAuth::Lite2::Signer::Algorithms->get_algorithm(lc $args{algorithm})
            or Carp::croak "Unsupported algorithm: " . $args{algorithm};

    my $signature = encode_base64($algorithm->hash($args{secret}, $string));
    chomp $signature;
    $params->{signature} = $signature;
    return $params;
}

=head2 normalize_string( %params )

Returns normalized string according to the specification.

=over 4

=item host

host part of the url.

=item port

If you omit this, 80 is set by default.

=item nonce

Random string.

=item timestamp

unix timestamp.

=item algorithm

name of hmac hash algorithm.

=item method

HTTP method of the request.

=item url

URL of the request.

=back

=cut

sub normalize_string {
    my ($class, %args) = @_;
    $args{port} ||= 80;
    return join(",",
        $args{timestamp},
        $args{nonce},
        $args{algorithm},
        uc($args{method}),
        sprintf(q{%s:%d}, $args{host}, $args{port}),
        $args{url},
    );
}

sub _gen_nonce {
    my ($class, $digit) = @_;
    $digit ||= 10;
    my $random = String::Random->new;
    return $random->randregex( sprintf '[a-zA-Z0-9]{%d}', $digit );
}

sub _gen_timestamp {
    my $class = shift;
    return time();
}

=head2 verify( %params )

Verify a signed request.

    unless ( OAuth::Lite2::Signer->verify( %params ) ) {
        $app->error("Invalid request");
    }

=over 4

=item signature

'signature' parameter of the received request.

=item secret

The access token secret.

=item algorithm

'algorithm' parameter of the received request.

=item method

HTTP method of the received request.

=item url

URL of the received request.

=item nonce

'nonce' parameter of the received request.

=item timestamp

'timestamp' parameter of the received request.

=back

=cut

sub verify {
    my $class = shift;

    my %args = Params::Validate::validate(@_, {
        secret          => 1,
        algorithm       => 1,
        method          => 1,
        url             => 1,
        nonce           => 1,
        timestamp       => 1,
        signature       => 1,
    });

    my $uri = URI->new($args{url});

    my $params = {
        nonce     => $args{nonce},
        timestamp => $args{timestamp},
        algorithm => $args{algorithm},
    };

    my $string = $class->normalize_string(%$params,
        method => $args{method},
        host   => $uri->host,
        port   => $uri->port || 80,
        url    => $args{url},
    );

    my $algorithm =
        OAuth::Lite2::Signer::Algorithms->get_algorithm($args{algorithm})
            or return 0;

    my $signature = encode_base64($algorithm->hash($args{secret}, $string));
    chomp $signature;

    return ($args{signature} eq $signature);
}


=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
