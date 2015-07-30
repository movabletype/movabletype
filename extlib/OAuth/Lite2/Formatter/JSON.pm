package OAuth::Lite2::Formatter::JSON;

use strict;
use warnings;

use parent 'OAuth::Lite2::Formatter';

use JSON::XS;
use Try::Tiny;

sub name { "json" }
sub type { "application/json" };

sub format {
    my ($self, $hash) = @_;
    return JSON::XS->new->encode($hash);
}

sub parse {
    my ($self, $json) = @_;
    return JSON::XS->new->decode($json);
}

=head1 NAME

OAuth::Lite2::Formatter::JSON - OAuth 2.0 JSON formatters store

=head1 SYNOPSIS

    my $formatter = OAuth::Lite2::Formatter::JSON->new;
    my $obj = $formatter->parse( $string );
    $string = $formatter->format( $obj );

=head1 DESCRIPTION

OAuth 2.0 JSON formatter

=head1 METHODS

=head2 name

Accessor for name of this format, "json".

=head2 type

Accessor for content-type of this format, "application/json".

=head2 format( $json_object )

    my $json_string = $formatter->format( $obj );

=head2 parse( $json_string )

    my $obj = $formatter->parse( $json_string );

=head1 SEE ALSO

L<OAuth::Lite2::Formatter>
L<OAuth::Lite2::Formatters>
L<OAuth::Lite2::Formatter::XML>
L<OAuth::Lite2::Formatter::FormURLEncoded>

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
