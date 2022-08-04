use strict;
use warnings;
use FindBin;
use File::Spec;
use MT::RebuildTrigger ':constants';

$ENV{MT_TEST_REBUILD_TRIGGER_EVENT_TYPE} = EVENT_UNPUBLISH;
push @INC, "." unless $INC[-1] eq ".";

my $file = File::Spec->canonpath("$FindBin::Bin/triggers_entry_save.t");
do $file or die "$file: $!";
