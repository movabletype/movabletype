package CommonMark;

use strict;
use warnings;
use Markdown::Perl;

our $VERSION = 1;

sub common_mark {
    my ($text, $ctx) = @_;
    my $md = Markdown::Perl->new(
        mode => 'cmark',
        warn_for_unused_input => 0,
    );
    $md->convert($text);
}

sub gfm {
    my ($text, $ctx) = @_;
    my $md = Markdown::Perl->new(
        mode => 'github',
        warn_for_unused_input => 0,
    );
    $md->convert($text);
}

1;
