# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::default_templates;

use strict;
require MT::DefaultTemplates;

delete $INC{'MT/default-templates.pl'};

MT::DefaultTemplates->templates;
