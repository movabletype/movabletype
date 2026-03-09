package MT::Test::Emoji;

use strict;
use warnings;
use Exporter 'import';
use Test::Requires '5.014'; ## no critic(Modules::ProhibitUseQuotedVersion)  ## Unicode 6.0 aka SUSHI/BEER
use Acme::RandomEmoji qw/random_emoji/;
use charnames ();

our @EXPORT = qw/random_emoji_string emoji/;

## SUSHI (U+1F363), BEER (U+1F37A), etc
sub emoji { charnames::string_vianame(uc shift) // '' }

sub random_emoji_string {
    my $size = shift || 30;
    join '', map { random_emoji() } 1 .. $size;
}

1;
