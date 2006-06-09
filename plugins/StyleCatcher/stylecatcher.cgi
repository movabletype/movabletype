#!/usr/bin/perl -w

# Copyright 2005-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

use strict;
use lib "lib", ($ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : "../../lib"); 
use MT::Bootstrap App => 'StyleCatcher';
