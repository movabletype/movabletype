package Unicode::CaseFold;

use strict;
use warnings;
use 5.008001;

use Unicode::UCD ();

our $SIMPLE_FOLDING = $^V lt v5.10.0;

sub case_fold {
  my ($string) = @_;

  my $WHICH_MAPPING = ($SIMPLE_FOLDING ? 'mapping' : 'full');

  my $out = "";

  for my $codepoint (unpack "U*", $string) {
    my $mapping = Unicode::UCD::casefold($codepoint);
    my @cp;
    if (!defined $mapping) {
      @cp = ($codepoint);
    } else {
      @cp = map hex, split / /, $mapping->{$WHICH_MAPPING};
    }
    $out .= pack "U*", @cp;
  }

  return $out;
}

1;
