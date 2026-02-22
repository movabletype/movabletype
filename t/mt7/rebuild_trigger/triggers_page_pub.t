use strict;
use warnings;
use FindBin;
use File::Spec;

$ENV{MT_TEST_REBUILD_TRIGGER_EVENT_TYPE} = 2; # EVENT_PUBLISH;
push @INC, "." unless $INC[-1] eq ".";

my $file = File::Spec->canonpath("$FindBin::Bin/triggers_page_save.t");
do $file or die "$file: $! $@";
