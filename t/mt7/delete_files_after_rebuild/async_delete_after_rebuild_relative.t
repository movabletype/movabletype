use strict;
use warnings;
use FindBin;
use File::Spec;

$ENV{MT_TEST_USE_RELATIVE_FILE_PATH} = 1;
$ENV{MT_TEST_DELETE_FILES_AFTER_REBUILD} = 1;
$ENV{MT_TEST_PUBLISH_ASYNC} = 1;

my $file = File::Spec->canonpath("$FindBin::Bin/async_delete_after_rebuild.t");
do $file or die "$file: $!";
