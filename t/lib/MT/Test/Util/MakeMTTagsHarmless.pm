package MT::Test::Util::MakeMTTagsHarmless;

use strict;
use warnings;
use Exporter qw(import);

our @EXPORT = qw(make_harmless strip_mt_tags);

sub make_harmless {
    my $body = shift;
    $body =~ s!<(/?\$?(?:MT:?)(?:(?:<[^>]+?>|"(?:<[^>]+?>|.)*?"|'(?:<[^>]+?>|.)*?'|.)+?)(?:[-]?)[\$/]?)>!_make_harmless($1)!gise;
    $body =~ s!<(/?(?:_|MT)_TRANS(?:_SECTION)?(?:(?:\s+(?:\w+\s*=\s*["'](?:(?:<(?:[^"'>]|"[^"]*"|'[^']*')+)?>|[^"']+?)*?["']))+?\s*/?)?)>!_make_harmless($1)!gise;
    return $body;
}

sub _make_harmless {
    my $tag = shift;
    $tag =~ s/^\$//;
    $tag =~ s/\$$//;
    $tag =~ s/["']/`/g;
    return "[% $tag %]";
}

sub strip_mt_tags {
    my $tag = shift;
    $tag =~ s/\[%.+?%\]//g;
    $tag =~ s/`/"/g;
    return $tag;
}

1;
