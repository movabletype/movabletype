use strict;
use warnings;
use FindBin;
use File::Spec;

$ENV{MT_TEST_REBUILD_TRIGGER_EVENT_TYPE} = 3; # EVENT_UNPUBLISH;
push @INC, "." unless $INC[-1] eq ".";

my $file = File::Spec->canonpath("$FindBin::Bin/triggers_content_save.t");
do $file or die "$file: $! $@";
