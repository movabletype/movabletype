package OAuth::Lite2::Formatter::Text;

use strict;
use warnings;

use parent 'OAuth::Lite2::Formatter';

use OAuth::Lite2::Util qw(
    build_content
    parse_content);

sub name { "text" }
sub type { "text/plain" }

sub format {
    my ($self, $hash) = @_;
    return build_content($hash);
}

sub parse {
    my ($self, $content) = @_;
    return parse_content($content)->as_hashref_mixed;
}


=head1 NAME

OAuth::Lite2::Formatter::Text - OAuth 2.0 text/plain formatters store

=head1 SYNOPSIS

    my $formatter = OAuth::Lite2::Formatter::Text->new;
    my $obj = $formatter->parse( $string );
    $string = $formatter->format( $obj );

=head1 DESCRIPTION

DEPRECATED.
OAuth 2.0 text/plain formatter

=head1 METHODS

=head2 name

Accessor for name of this format, "text".

=head2 type

Accessor for content-type of this format, "text/plain".

=head2 format( $object )

    my $formatted_string = $formatter->format( $obj );

=head2 parse( $formatted_string )

    my $obj = $formatter->parse( $formatted_string );


=head1 SEE ALSO

L<OAuth::Lite2::Formatter>
L<OAuth::Lite2::Formatters>
L<OAuth::Lite2::Formatter::FormURLEncoded.pm>
L<OAuth::Lite2::Formatter::JSON>
L<OAuth::Lite2::Formatter::XML>

=head1 AUTHOR

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
