# $Id: Util.pm 29346 2006-05-19 23:59:07Z bchoate $

package XML::Atom::Util;
use strict;

use XML::Atom;
use vars qw( @EXPORT_OK @ISA );
use Exporter;
@EXPORT_OK = qw( set_ns hack_unicode_entity first nodelist textValue iso2dt encode_xml remove_default_ns );
@ISA = qw( Exporter );

our %NS_MAP = (
    '0.3' => 'http://purl.org/atom/ns#',
    '1.0' => 'http://www.w3.org/2005/Atom',
);

our %NS_VERSION = reverse %NS_MAP;

sub set_ns {
    my $thing = shift;
    my($param) = @_;
    if (my $ns = delete $param->{Namespace}) {
        $thing->{ns}      = $ns;
        $thing->{version} = $NS_VERSION{$ns};
    } else  {
        my $version = delete $param->{Version} || '0.3';
        $version    = '1.0' if $version == 1;
        my $ns = $NS_MAP{$version} or $thing->error("Unknown version: $version");
        $thing->{ns} = $ns;
        $thing->{version} = $version;
    }
}

sub ns_to_version {
    my $ns = shift;
    $NS_VERSION{$ns};
}

sub hack_unicode_entity {
    my $data = shift;
    if ($] >= 5.008) {
        require Encode;
        Encode::_utf8_on($data);
    }
    $data =~ s/&#x(\w{4});/chr(hex($1))/eg;
    if ($] >= 5.008) {
        require Encode;
        Encode::_utf8_off($data);
    }
    $data;
}

sub first {
    my @nodes = nodelist(@_);
    return unless @nodes;
    return $nodes[0];
}

sub nodelist {
    if (LIBXML) {
        return  $_[1] ? $_[0]->getElementsByTagNameNS($_[1], $_[2]) :
                $_[0]->getElementsByTagName($_[2]);
    } else {
        my $set = $_[1] ?
            $_[0]->find("descendant::*[local-name()='$_[2]' and namespace-uri()='$_[1]']") :
            $_[0]->find("descendant::$_[2]");
        return unless $set && $set->isa('XML::XPath::NodeSet');
        return $set->get_nodelist;
    }
}

sub textValue {
    my $node = first(@_) or return;
    LIBXML ? $node->textContent : $node->string_value;
}

sub iso2dt {
    my($iso) = @_;
    return unless $iso =~ /^(\d{4})(?:-?(\d{2})(?:-?(\d\d?)(?:T(\d{2}):(\d{2}):(\d{2})(?:\.\d+)?(?:Z|([+-]\d{2}:\d{2}))?)?)?)?/;
    my($y, $mo, $d, $h, $m, $s, $zone) =
        ($1, $2 || 1, $3 || 1, $4 || 0, $5 || 0, $6 || 0, $7);
    require DateTime;
    my $dt = DateTime->new(
               year => $y,
               month => $mo,
               day => $d,
               hour => $h,
               minute => $m,
               second => $s,
               time_zone => 'UTC',
    );
    if ($zone && $zone ne 'Z') {
        my $seconds = DateTime::TimeZone::offset_as_seconds($zone);
        $dt->subtract(seconds => $seconds);
    }
    $dt;
}

my %Map = ('&' => '&amp;', '"' => '&quot;', '<' => '&lt;', '>' => '&gt;',
           '\'' => '&apos;');
my $RE = join '|', keys %Map;

sub encode_xml {
    my($str) = @_;
    $str =~ s!($RE)!$Map{$1}!g;
    $str;
}

sub remove_default_ns {
    my($node) = @_;
    $node->setNamespace('http://www.w3.org/1999/xhtml', '')
        if ($node->nodeName) =~ /^default:/ && ref($node) =~ /Element$/;
    for my $n ($node->childNodes) {
        remove_default_ns($n);
    }
}

1;
__END__

=head1 NAME

XML::Atom::Util - Utility functions

=head1 SYNOPSIS

    use XML::Atom::Util qw( iso2dt );
    my $dt = iso2dt($entry->issued);

=head1 USAGE

=head2 iso2dt($iso)

Transforms the ISO-8601 date I<$iso> into a I<DateTime> object and returns
the I<DateTime> object.

=head2 encode_xml($str)

Encodes characters with special meaning in XML into entities and returns
the encoded string.

=head1 AUTHOR & COPYRIGHT

Please see the I<XML::Atom> manpage for author, copyright, and license
information.

=cut
