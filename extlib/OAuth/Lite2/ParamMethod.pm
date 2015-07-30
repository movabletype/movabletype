package OAuth::Lite2::ParamMethod;

use strict;
use warnings;

sub new {
    bless {}, $_[0];
}

sub match {
    my ($self, $req) = @_;
    die "abstract method";
}

sub parse {
    my ($self, $req) = @_;
    die "abstract method";
}

sub build_request {
    my ($self, %params) = @_;
    die "abstract method";
}

=head1 NAME

OAuth::Lite2::ParamMethod - base class of builder/parser for OAuth 2.0 parameters

=head1 SYNOPSIS

    my $meth = OAuth::Lite2::ParamMethod::Foo->new;
    
    # server side
    if ($meth->match( $plack_request )) {
        my ($token, $params) = $meth->parse( $plack_request );
    }

    # client side
    my $http_req = $meth->request_builder(...);

=head1 DESCRIPTION

base class of builder/parser for OAuth 2.0 parameters

=head1 METHODS

=head2 new

Constructor

=head2 match( $plack_request )

Returns true if passed L<Plack::Request> object is matched for the type of this method.

    if ( $meth->match( $plack_request ) ) {
        ...
    }

=head2 parse( $plack_request )

Parse the L<Plack::Request>, and returns access token and oauth parameters.

    my ($token, $params) = $meth->parse( $plack_request );

=head2 build_request( %params )

Build L<HTTP::Request> object.

    my $req = $meth->build_request(
        url          => $url,
        method       => $http_method,
        token        => $access_token,
        oauth_params => $oauth_params,
        params       => $params,
        content      => $content,
        headers      => $headers,
    );

=head1 SEE ALSO

L<OAuth::Lite2::ParamMethods>
L<OAuth::Lite2::ParamMethod::AuthHeader>
L<OAuth::Lite2::ParamMethod::FormEncodedBody>
L<OAuth::Lite2::ParamMethod::URIQueryParameter>

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;

