package CommonMark;

use strict;
use warnings;
use Markdown::Perl;

our $VERSION = 1;

sub common_mark {
    my ($text, $ctx) = @_;
    my $md = Markdown::Perl->new(
        mode => 'cmark',
        use_setext_headings => 1,
    );
    $md->convert($text);
}

1;
