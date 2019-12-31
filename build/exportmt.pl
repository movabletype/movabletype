#!/usr/bin/perl

# Movable Type (r) (C) 2001-2020 Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use warnings;
use lib 'build';
use Build;
use Data::Dumper;
$Data::Dumper::Indent = $Data::Dumper::Terse = $Data::Dumper::Sortkeys = 1;

my $build = Build->new();

$build->usage() unless @ARGV;

# Get the command-line options.
$build->get_options();
my $orig_stamp = $build->{'stamp=s'};
my $orig_verid = $ENV{BUILD_VERSION_ID} || '';

# Show the usage if requested.
$build->usage() if $build->help();

foreach my $lang ( $build->languages() ) {
    local $build->{'stamp=s'} = $orig_stamp;
    local $ENV{BUILD_VERSION_ID} = $orig_verid;
    $build->setup( language => $lang );

    # Summarize what we are about to do.
    $build->verbose(
        sprintf '* Debug mode is %s and system calls %s be made.',
        $build->debug() ? 'ON'    : 'OFF',
        $build->debug() ? "WON'T" : 'WILL'
    );
    $build->verbose( sprintf 'Run options: %s', Dumper $build )
        if $build->debug();

    # Get any existing distro with the same path name, out of the way.
    $build->remove_copy();

    # Export the latest files.
    $build->export();

    # Export any plugins that are requested.
    ## $build->plugin_export();

    # Export any addons that are requested.
    ## $build->addons_export();

    # Add a non-production footer.
    $build->inject_footer();

    # Actually build the distribution files.
    $build->make();

    # Create lists of the distribution paths and uris.
    my $distros = $build->create_distro_list();

    # Deploy the distributions.
    $build->deploy_distros($distros);

    # Cleanup the exported files.
    $build->cleanup();

    # TODO Factor out the (rarely used) email notification.
    $build->notify($distros);
}

__END__

=head1 NAME

exportmt - Movable Type Export Build Deployment and Notification

=head1 SEE ALSO

https://intranet.sixapart.com/wiki/index.php/Movable_Type:MT_Export-Deploy

The L<Build> (F<build/Build.pm>) module.

=cut
