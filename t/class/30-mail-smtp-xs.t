use strict;
use warnings;
use FindBin;
use File::Spec;

push @INC, "." unless $INC[-1] eq ".";

$ENV{MT_TEST_AUTHEN_SASL_XS} = 1;

my $file = File::Spec->canonpath("$FindBin::Bin/30-mail-smtp.t");
do $file or die "$file: $!";
