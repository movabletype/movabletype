package MT::BackupRestore::BackupFileScanner;

use strict;
use XML::SAX::Base;
use MIME::Base64;

@MT::BackupRestore::BackupFileScanner::ISA = qw(XML::SAX::Base);

sub new {
    my $class = shift;
    local $@;
    eval { require Digest::SHA };
    if ($@) {
        return bless {}, $class;
    }
    else {
        return undef;
    }
}

sub start_element {
    my $self = shift;
    my $data = shift;

    my $name  = $data->{LocalName};
    my $attrs = $data->{Attributes};
    my $ns    = $data->{NamespaceURI};
    return unless MT::BackupRestore::NS_MOVABLETYPE() eq $ns;
    return unless $name eq 'author';
    my $pass = $attrs->{"{}password"}->{Value};
    if ($pass =~ m/^\$6\$/) {
        die MT->translate("Can not restore author with SHA512 on system without Digest::SHA");
    }
    1;
}

1;