use MT::Tag;

use strict;
use Data::Dumper;

test("this is a test", ' ');
test("this is, a test", ',');
test("this 'is,' a test", ',');
test("'this is' a, test", ' ');
test(q{"this is", "a, test"}, ',');
test(q{"this is a cool" test say hey?}, ' ');
test(q{textile}, ',');

sub test {
    my ($str, $delim) = @_;
    my @tags = MT::Tag->split($delim, $str);
    print $str . ' [' . $delim . ']' . "\n" . Dumper(\@tags);
}

