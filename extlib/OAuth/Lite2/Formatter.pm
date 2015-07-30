package OAuth::Lite2::Formatter;

use strict;
use warnings;


sub new { bless {}, $_[0] }

sub name { die "abstract method" }
sub type { die "abstract method" }

sub format {
    my ($self, $hash) = @_;
    die "abstract method";
}

sub parse {
    my ($self, $content) = @_;
    die "abstract method";
}

=head1 NAME

OAuth::Lite2::Formatter - OAuth 2.0 formatter base class

=head1 SYNOPSIS

    package OAuth::Lite2::Formatter::Foo;
    use parent 'OAuth::Lite2::Formatter';
    ...

    my $formatter = OAuth::Lite2::Formatter::Foo->new;
    my $obj = $formatter->parse( $string );
    $string = $formatter->format( $obj );

=head1 DESCRIPTION

OAuth 2.0 formatter base class

=head1 METHODS

=head2 name

Accessor for name of this format.

=head2 type

Accessor for content-type of this format.

=head2 format( $object )

    my $formatted_string = $formatter->format( $obj );

=head2 parse( $formatted_string )

    my $obj = $formatter->parse( $formatted_string );

=head1 SEE ALSO

L<OAuth::Lite2::Formatters>
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
