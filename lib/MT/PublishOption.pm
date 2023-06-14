# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::PublishOption;

use strict;
use warnings;

# build type
sub DISABLED ()  {0}
sub ONDEMAND ()  {1}
sub MANUALLY ()  {2}
sub DYNAMIC ()   {3}
sub ASYNC ()     {4}
sub SCHEDULED () {5}

sub get_throttle {
    my $finfo = shift;
    require MT::Template;
    require MT::TemplateMap;
    my $throttle = { type => DISABLED, interval => 0, };
    my $obj;
    if ( my $map_id = $finfo->templatemap_id ) {
        $obj = MT->request->{__stash}{__obj}{"templatemap:$map_id"} ||= MT::TemplateMap->load($map_id);
    }
    else {
        my $tmpl_id = $finfo->template_id;
        $obj = MT->request->{__stash}{__obj}{"template:$tmpl_id"} ||= MT::Template->load($tmpl_id);
    }
    return $throttle unless $obj;
    $throttle->{type}     = $obj->build_type;
    $throttle->{interval} = $obj->build_interval;
    $throttle;
}

sub archive_build_is_enable {
    my ( $blog_id, $at ) = @_;
    require MT::TemplateMap;
    my $map = MT::TemplateMap->load(
        {   blog_id      => $blog_id,
            archive_type => $at,
            build_type   => { 'not' => DISABLED() },
        }
    );
    $map ? 1 : 0;
}

1;
