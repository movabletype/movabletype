use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";
use File::Spec;
use MT::RebuildTrigger ':constants';

$ENV{MT_TEST_REBUILD_TRIGGER_EVENT_TYPE} = EVENT_PUBLISH;
push @INC, "." unless $INC[-1] eq ".";

my $file = File::Spec->canonpath("$FindBin::Bin/triggers_page_save.t");
do $file or die "$file: $!";
