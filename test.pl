use strict;
use warnings;

# if ( eval { require IO::Socket::INET6; 1 } && $IO::Socket::INET6::VERSION <= 2.57 ) {
#     print "if\n";
# } else {
#     print "else\n";
# }

use Carp::Always;

use lib qw( lib extlib );
use MT;
MT->instance;

use MT::ContentData;

my $cd = MT::ContentData->load(5) or die;

MT->instance->rebuild_content_data(
    ContentData       => $cd,
    BuildDependencies => 1,
);

