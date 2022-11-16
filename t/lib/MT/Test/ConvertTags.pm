package MT::Test::ConvertTags;

use strict;
use warnings;
use Exporter 5.57 qw/import/;

our @EXPORT_OK = qw/convert_tags/;

sub convert_tags {
    my $tmpl = shift;
    $tmpl =~ s!<(/?\$?(?:MT:?)(?:(?:<[^>]+?>|"(?:<[^>]+?>|.)*?"|'(?:<[^>]+?>|.)*?'|.)+?)(?:[-]?)[\$/]?)>!_convert($1)!gise;
    $tmpl =~ s!<(/?(?:_|MT)_TRANS(?:_SECTION)?(?:(?:\s+(?:\w+\s*=\s*["'](?:(?:<(?:[^"'>]|"[^"]*"|'[^']*')+)?>|[^"']+?)*?["']))+?\s*/?)?)>!_convert($1)!gise;
    return $tmpl;
}

sub _convert {
    my $tag = shift;
    $tag =~ s/^\$//;
    $tag =~ s/\$$//;
    $tag =~ s/["']/`/g;
    return "[% $tag %]";
}

1;
