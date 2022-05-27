# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package DataAPI::App;
use strict;
use warnings;

sub config_tmpl {
    my ($plugin, $param, $scope) = @_;
    my ($blog_id) = $scope =~ m/blog:(\d+)/;
    $plugin->load_tmpl('config.tmpl', { 'blog_id' => $blog_id });
}

1;

__END__
