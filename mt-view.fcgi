#! perl

use strict;
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';
use MT::FCGI::IIS App => 'MT::App::Viewer';
