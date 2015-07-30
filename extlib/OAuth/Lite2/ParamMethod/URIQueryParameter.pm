package OAuth::Lite2::ParamMethod::URIQueryParameter;

use strict;
use warnings;

use parent 'OAuth::Lite2::ParamMethod';
use HTTP::Request;
use HTTP::Headers;
use bytes ();
use Params::Validate;
use OAuth::Lite2::Util qw(build_content);

=head1 NAME

OAuth::Lite2::ParamMethod::URIQueryParameter - builder/parser for OAuth 2.0 uri-query type of parameter

=head1 SYNOPSIS

    my $meth = OAuth::Lite2::ParamMethod::URIQueryParameter->new;

    # server side
    if ($meth->match( $plack_request )) {
        my ($token, $params) = $meth->parse( $plack_request );
    }

    # client side
    my $http_req = $meth->request_builder(...);

=head1 DESCRIPTION

builder/parser for OAuth 2.0 uri-query type of parameter

=head1 METHODS

=head2 new

Constructor

=head2 match( $plack_request )

Returns true if passed L<Plack::Request> object is matched for the type of this method.

    if ( $meth->match( $plack_request ) ) {
        ...
    }

=cut

sub match {
    my ($self, $req) = @_;
    return (exists $req->query_parameters->{oauth_token} 
            || exists $req->query_parameters->{access_token});
}

=head2 parse( $plack_request )

Parse the L<Plack::Request>, and returns access token and oauth parameters.

    my ($token, $params) = $meth->parse( $plack_request );

=cut

sub parse {
    my ($self, $req) = @_;
    my $params = $req->query_parameters;
    my $token = $params->{access_token};
    $params->remove('access_token');
    if($params->{oauth_token}){
        $token = $params->{oauth_token};
        $params->remove('oauth_token');
    }
    return ($token, $params);
}

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

=cut

sub build_request {
    my $self = shift;
    my %args = Params::Validate::validate(@_, {
        url          => 1,
        method       => 1,
        token        => 1,
        oauth_params => 1,
        params       => { optional => 1 },
        content      => { optional => 1 },
        headers      => { optional => 1 },
    });

    my $oauth_params = $args{oauth_params} || {};
    $oauth_params->{access_token} = $args{token};

    my $params  = $args{params} || {};
    my $method  = uc $args{method};
    my $headers = $args{headers};
    if (defined $headers) {
        if (ref($headers) eq 'ARRAY') {
            $headers = HTTP::Headers->new(@$headers);
        } else {
            $headers = $headers->clone;
        }
    } else {
        $headers = HTTP::Headers->new;
    }

    if ($method eq 'GET' || $method eq 'DELETE') {
        my $query = build_content({%$params, %$oauth_params});
        my $url = sprintf q{%s?%s}, $args{url}, $query;
        my $req = HTTP::Request->new($method, $url, $headers);
        return $req;
    } else {
        my $query = build_content($oauth_params);
        my $url = sprintf q{%s?%s}, $args{url}, $query;
        unless ($headers->header("Content-Type")) {
            $headers->header("Content-Type",
                "application/x-www-form-urlencoded");
        }
        my $content_type = $headers->header("Content-Type");
        my $content = ($content_type eq "application/x-www-form-urlencoded")
            ? build_content($params)
            : $args{content} || build_content($params);
        $headers->header("Content-Length", bytes::length($content));
        my $req = HTTP::Request->new($method, $url, $headers, $content);
        return $req;
    }
}

=head2 is_legacy( $plack_request )

Returns true if passed L<Plack::Request> object is based draft version 10.

    if ( $meth->is_legacy( $plack_request ) ) {
        ...
    }

=cut

sub is_legacy {
    my ($self, $req) = @_;
    return (exists $req->query_parameters->{oauth_token});
}

=head1 SEE ALSO

L<OAuth::Lite2::ParamMethods>
L<OAuth::Lite2::ParamMethod>
L<OAuth::Lite2::ParamMethod::AuthHeader>
L<OAuth::Lite2::ParamMethod::FormEncodedBody>

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
