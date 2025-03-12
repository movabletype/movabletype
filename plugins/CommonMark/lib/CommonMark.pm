package CommonMark;

use strict;
use warnings;
use Markdown::Perl;

use base 'Exporter';
our $VERSION = 1;

sub common_mark {
    my ($text, $ctx) = @_;
    my $md = Markdown::Perl->new(
        mode => 'cmark',
    );
    $md->convert($text);
}

1;
