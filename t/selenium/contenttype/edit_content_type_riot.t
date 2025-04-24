use strict;
use warnings;
use FindBin;
use File::Spec;

push @INC, "." unless $INC[-1] eq ".";

$ENV{MT_TEST_EDIT_CONTENT_TYPE_RIOT} = 1;

my $file = File::Spec->canonpath("$FindBin::Bin/edit_content_type.t");
do $file or die "$file: $!";
