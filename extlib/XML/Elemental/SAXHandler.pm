package XML::Elemental::SAXHandler;
use strict;
use warnings;

use vars qw($VERSION);
$VERSION = '0.11';

use base qw( XML::SAX::Base );

use Scalar::Util qw(weaken);

my %defaults = (
                Document   => 'XML::Elemental::Document',
                Element    => 'XML::Elemental::Element',
                Characters => 'XML::Elemental::Characters'
);

# We work with direct references to the underlying HASH data
# rather then the methods for better parsing performance.
# Dangerous? Perhaps.

sub new {
    my $self = shift->SUPER::new(@_);
    for (keys %defaults) {
        $self->{$_} ||= $defaults{$_};
        eval "require " . $self->{$_} or die $@;
    }
    $self;
}

sub start_document {
    my ($self, $doc) = @_;
    $self->{__doc} = $self->{Document}->new;
    push(@{$self->{__stack}}, $self->{__doc});
}

sub start_element {
    my ($self, $e) = @_;
    my $ns = $e->{NamespaceURI} || '';
    my $node = $self->{Element}->new;
    $node->{name}   = "{$ns}" . $e->{LocalName};
    $node->{parent} = $self->{__stack}->[-1];
    if ($e->{Attributes}) {
        my %attr;
        map { $attr{$_} = $e->{Attributes}->{$_}->{Value} }
          keys %{$e->{Attributes}};
        $node->{attributes} = \%attr;
    }
    push(@{$node->{parent}->{contents}}, $node);
    push(@{$self->{__stack}}, $node);
}

sub characters {
    my ($self, $data) = @_;
    my $parent   = $self->{__stack}->[-1];
    my $contents = $parent->{contents};
    my $class    = $self->{Characters};
    unless ($contents && ref($contents->[-1]) eq $class) {
        my $node = $class->new;
        $node->{parent} = $parent;
        $node->{data}   = $data->{Data};
        push(@{$contents}, $node);
    } else {
        my $d = $contents->[-1]->data || '';
        $contents->[-1]->data($d . $data->{Data});
    }
}

sub end_element { pop(@{$_[0]->{__stack}}) }

sub end_document {
    delete $_[0]->{__stack};
    $_[0]->{__doc}->{contents} = $_[0]->{__doc}->{contents}->[0];
    weaken($_[0]->{__doc}->{contents}->{parent} = $_[0]->{__doc});
    $_[0]->{__doc};
}

1;

__END__

=begin

=head1 NAME

XML::Elemental::SAXHandler - the SAX2 handler that drives
XML::Elemental.

=head1 DESCRIPTION

XML::Elemental::SAXHandler is a subclass of
L<XML::SAX::Base> that is passed into the parser factory to
create the Elemental parser.

This handler implements SAX handlers for C<start_document>,
C<start_element>, C<characters>, C<end_element> and C<end_document>. It
also handles mixing the document, element and characters
into the processing of XML data through its overwritten construvtor.

You typically do not need to work with this module directly.
Instead work with the C<parser> method in L<XML::Elemental>.

=head1 AUTHOR & COPYRIGHT

Please see the XML::Elemental manpage for author, copyright,
and license information.

=cut

=end
