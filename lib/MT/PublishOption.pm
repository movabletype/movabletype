# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::PublishOption;

use strict;

# build type
use constant DISABLED  => 0;
use constant ONDEMAND  => 1;
use constant MANUALLY  => 2;
use constant DYNAMIC   => 3;
use constant ASYNC     => 4;
use constant SCHEDULED => 5;

sub get_throttle {
    my $finfo = shift;
    require MT::Template;
    require MT::TemplateMap;
    my $throttle = { type => DISABLED, interval => 0, };
    my $obj;
    if ( $finfo->templatemap_id ) {
        $obj = MT::TemplateMap->load( $finfo->templatemap_id );
    }
    else {
        $obj = MT::Template->load( $finfo->template_id );
    }
    $throttle->{type}     = $obj->build_type;
    $throttle->{interval} = $obj->build_interval;
    $throttle;
}

sub archive_build_type {
    my $at = shift;
    require MT::TemplateMap;
    my $map = MT::TemplateMap->load( { archive_type => $at } );
    $map && $map->build_type;
}

1;
