#!/usr/bin/perl -w

# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: mt-testbg.cgi 3531 2009-03-12 09:11:52Z fumiakiy $

use strict;

local $| = 1;
print "Content-Type: text/html\n\n";
print "<html>\n<body>\n<pre>\n\n";

eval {
    local $SIG{__WARN__} = sub { print "**** WARNING: $_[0]\n" };

    my $pid = fork(); 
    if (defined $pid)
    {
        if ($pid) {
            print wait() > 0
                   ? "Background tasks are available\n" 
                   : "Background tasks are not available\n";
        } else { 
            sleep 1;
            exit(0);
        } 
    } else { print "Background tasks are not available\n"; }
};
print "Got an error: $@" if $@;

print "\n\n</pre>\n</body>\n</html>";

