package MT::Test::Fixture::ArchiveTypeDistinct;

use strict;
use warnings;
use base 'MT::Test::Fixture::ArchiveType';

sub _file_template {
    my ( $class, $archiver, $uid ) = @_;
    my $prefix = $archiver->name =~ /^ContentType/ ? "ct/" : "";
    $prefix .= "$uid/" if $uid;
    for my $archive_template ( @{ $archiver->default_archive_templates } ) {
        next unless $archive_template->{default};
        return $prefix . $archive_template->{template};
    }
}

1;
