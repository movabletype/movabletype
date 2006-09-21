#!/usr/bin/perl
#
# $Id$
#
use strict;
use warnings;

use Data::Dumper;
$Data::Dumper::Indent = $Data::Dumper::Terse = $Data::Dumper::Sortkeys = 1;

use lib 'build';
use Build;

my $build = Build->new();

$build->usage() unless @ARGV;

# Get the command-line options.
$build->get_options();

# Show the usage if requested.
$build->usage() if $build->{'help|h'};

# Perform some preliminary contextual set-up.
$build->setup();

# Summarize what we are about to do.
$build->verbose( sprintf '* Debug mode is %s and system calls %s be made.',
    $build->{'debug'} ? 'ON' : 'OFF', $build->{'debug'} ? "WON'T" : 'WILL',
);
$build->verbose( sprintf('Run options: %s', Dumper $build) ) if $build->{'debug'};

# Get any existing distro with the same path name, out of the way.
$build->remove_copy();

# Export the latest files.
$build->export();

# Add the non-production footer.
$build->inject_footer();

# Make the all-important make calls.
$build->make();

# Create lists of the distributions.
my $distros = $build->create_distro_list();

# Deploy the distributions.
$build->deploy_distros( $distros );

# Cleanup the exported files.
$build->cleanup();

# Send email notification.
$build->notify( $distros );

exit;
