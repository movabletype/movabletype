# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::default_templates;

use strict;
require MT::DefaultTemplates;

delete $INC{'MT/default-templates.pl'};

MT::DefaultTemplates->templates;
