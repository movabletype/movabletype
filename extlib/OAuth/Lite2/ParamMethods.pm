package OAuth::Lite2::ParamMethods;

use strict;
use warnings;

use OAuth::Lite2::ParamMethod::AuthHeader;
use OAuth::Lite2::ParamMethod::FormEncodedBody;
use OAuth::Lite2::ParamMethod::URIQueryParameter;

use base 'Exporter';

our %EXPORT_TAGS = ( all => [qw/
    AUTH_HEADER FORM_BODY URI_QUERY
/] );

our @EXPORT_OK = map { @$_ } values %EXPORT_TAGS;

use constant AUTH_HEADER => 0;
use constant FORM_BODY   => 1;
use constant URI_QUERY   => 2;

my @METHODS = (
    OAuth::Lite2::ParamMethod::AuthHeader->new,
    OAuth::Lite2::ParamMethod::FormEncodedBody->new,
    OAuth::Lite2::ParamMethod::URIQueryParameter->new,
);

sub get_param_parser {
    my ($self, $req) = @_;
    for my $method ( @METHODS ) {
        return $method if $method->match($req)
    }
    return;
}

sub get_request_builder {
    my ($self, $type) = @_;
    return $METHODS[ $type ];
}

=head1 NAME

OAuth::Lite2::ParamMethods - store of builders/parsers for OAuth 2.0 parameters

=head1 SYNOPSIS

    use OAuth::Lite2::ParamMethods qw(AUTH_HEADER FORM_BODY URI_QUERY);

    # client side
    my $builder = OAuth::Lite2::ParamMethods->get_request_builder( AUTH_HEADER );
    my $req = $builder->build_request(...);

    # server side
    my $parser = OAuth::Lite2::ParamMethods->get_param_parser( $plack_request )
        or $app->error("This is not OAuth 2.0 request");
    my ($token, $params) = $parser->parse( $plack_request );

=head1 DESCRIPTION

Store of builders/parsers for OAuth 2.0 parameters

=head1 CONSTANTS

=over 4

=item AUTH_HEADER

=item FORM_BODY

=item URI_QUERY

=back

=head1 METHODS

=head2 get_param_parser( $plack_request )

Pass a L<Plack::Request> object and proper parser for the request.

    my $parser = OAuth::Lite2::ParamMethods->get_param_parser( $plack_request )
        or $app->error("This is not OAuth 2.0 request");
    my ($token, $params) = $parser->parse( $plack_request );

=head2 get_request_builder( $type )

Returns proper HTTP request builder for the passed $type.

    my $builder = OAuth::Lite2::ParamMethods->get_request_builder( AUTH_HEADER );
    my $req = $builder->build_request(...);

=head1 SEE ALSO

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
