#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use MT::Test;

use Test::More tests => 60;

# core MT stuff
use_ok('MT::Bootstrap');
use_ok('MT::ErrorHandler');
use_ok('MT');
use_ok('MT::App');
use_ok('MT::Tool');
use_ok('MT::Core');
use_ok('MT::Component');

# all Community modules
use_ok('MT::App::Community');
use_ok('MT::Community::Blog');
use_ok('MT::Community::CMS');
use_ok('MT::Community::Friending');
use_ok('MT::Community::L10N');
use_ok('MT::Community::Tags');
use_ok('MT::Community::Util');
use_ok('MT::Community::L10N::de');
use_ok('MT::Community::L10N::en_us');
use_ok('MT::Community::L10N::es');
use_ok('MT::Community::L10N::fr');
use_ok('MT::Community::L10N::ja');
use_ok('MT::Community::L10N::nl');

# all Commercial modules
use_ok('MT::Commercial::Util');
use_ok('MT::Commercial::L10N');
use_ok('MT::Commercial::L10N::de');
use_ok('MT::Commercial::L10N::en_us');
use_ok('MT::Commercial::L10N::es');
use_ok('MT::Commercial::L10N::fr');
use_ok('MT::Commercial::L10N::ja');
use_ok('MT::Commercial::L10N::nl');
use_ok('CustomFields::BackupRestore');
use_ok('CustomFields::Field');
use_ok('CustomFields::Upgrade');
use_ok('CustomFields::Util');
use_ok('CustomFields::XMLRPCServer');
use_ok('CustomFields::App::CMS');
use_ok('CustomFields::App::Comments');
use_ok('CustomFields::App::Search');
use_ok('CustomFields::Template::ContextHandlers');

# all Enterprise modules
use_ok('MT::LDAP');
use_ok('MT::Group');
use_ok('MT::Auth::LDAP');
use_ok('MT::Enterprise::Author');
use_ok('MT::Enterprise::BulkCreation');
use_ok('MT::Enterprise::CMS');
use_ok('MT::Enterprise::L10N');
use_ok('MT::Enterprise::Upgrade');
use_ok('MT::Enterprise::Wizard');
use_ok('MT::Enterprise::L10N::de');
use_ok('MT::Enterprise::L10N::en_us');
use_ok('MT::Enterprise::L10N::es');
use_ok('MT::Enterprise::L10N::fr');
use_ok('MT::Enterprise::L10N::ja');
use_ok('MT::Enterprise::L10N::nl');
use_ok('MT::ObjectDriver::DDL::MSSQLServer');
use_ok('MT::ObjectDriver::DDL::Oracle');
use_ok('MT::ObjectDriver::DDL::UMSSQLServer');
use_ok('MT::ObjectDriver::Driver::DBD::MSSQLServer');
use_ok('MT::ObjectDriver::Driver::DBD::Oracle');
use_ok('MT::ObjectDriver::Driver::DBD::UMSSQLServer');
use_ok('MT::ObjectDriver::SQL::MSSQLServer');
use_ok('MT::ObjectDriver::SQL::Oracle');

