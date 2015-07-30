package OAuth::Lite2::Formatters;

use strict;
use warnings;

use OAuth::Lite2::Formatter::JSON;
use OAuth::Lite2::Formatter::XML;
use OAuth::Lite2::Formatter::FormURLEncoded;
use OAuth::Lite2::Formatter::Text;

my %FORMATTERS_BY_TYPE;
my %FORMATTERS_BY_NAME;

sub add_formatter {
    my ($class, $formatter) = @_;
    $FORMATTERS_BY_NAME{$formatter->name} = $formatter;
    $FORMATTERS_BY_TYPE{$formatter->type} = $formatter;
}

__PACKAGE__->add_formatter( OAuth::Lite2::Formatter::JSON->new );
__PACKAGE__->add_formatter( OAuth::Lite2::Formatter::XML->new );
__PACKAGE__->add_formatter( OAuth::Lite2::Formatter::FormURLEncoded->new );
__PACKAGE__->add_formatter( OAuth::Lite2::Formatter::Text->new );

sub get_formatter_by_name {
    my ($class, $name) = @_;
    return unless $name;
    return $FORMATTERS_BY_NAME{$name};
}

sub get_formatter_by_type {
    my ($class, $type) = @_;
    return unless $type;

    # If content-type includes subtype, top-level media type is only used.
    if ($type =~ /;/){
        $type = $`;
    }

    return $FORMATTERS_BY_TYPE{$type};
}

=head1 NAME

OAuth::Lite2::Formatters - OAuth 2.0 formatters store

=head1 SYNOPSIS

    my $formatter = OAuth::Lite2::Formatter->get_formatter_by_name("json");
    my $formatter = OAuth::Lite2::Formatter->get_formatter_by_type("application/json");

    my $obj = $formatter->parse( $string );
    $string = $formatter->format( $obj );

=head1 DESCRIPTION

OAuth 2.0 formatters store.
from draft-v8, specification requires only JSON format.
This library leaves the other formatters for interop.

=head1 METHODS

=head2 get_formatter_by_name( $name )

return formatter by name

=head2 get_formatter_by_type( $content_type )

return formatter by content type

=head1 SEE ALSO

L<OAuth::Lite2::Formatter>
L<OAuth::Lite2::Formatter::JSON>
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
