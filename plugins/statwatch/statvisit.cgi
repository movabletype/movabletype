#!/usr/bin/perl -w

# StatWatch - statvisit.cgi
# This script is based on code from Brad Choate (http://www.bradchoate.com)

# Nick O'Neill (http://www.raquo.net/statwatch/)

use strict;
BEGIN { unshift @INC, ($0 =~ m!(.*[/\\])! ? ( $1 . './lib', $1 . '../../lib', $1 . '../../extlib' ) : ( './lib', '../../lib', '../../extlib')) };
use MT::Bootstrap App => 'StatWatch::Visit';
