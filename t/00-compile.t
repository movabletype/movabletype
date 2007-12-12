#!/usr/bin/perl
# $Id$
use strict;
use warnings;
use lib 'lib';
use lib 'extlib';
use Test::More tests => 100;
use_ok 'MT::Bootstrap';
use_ok 'MT';
use_ok 'MT::App';
use_ok 'MT::App::ActivityFeeds';
use_ok 'MT::App::CMS';
use_ok 'MT::App::Comments';
use_ok 'MT::App::NotifyList';
use_ok 'MT::App::Search';
use_ok 'MT::App::Trackback';
use_ok 'MT::App::Upgrader';
use_ok 'MT::App::Viewer';
use_ok 'MT::App::Wizard';
use_ok 'MT::Atom';
use_ok 'MT::AtomServer';
use_ok 'MT::Auth';
SKIP: {
    skip 'Enable Enterprise Pack', 1;
    use_ok 'MT::Auth::LDAP';
}
use_ok 'MT::Auth::MT';
use_ok 'MT::Author';
use_ok 'MT::BasicAuthor';
use_ok 'MT::BasicSession';
use_ok 'MT::Blog';
use_ok 'MT::Builder';
SKIP: {
    skip 'Enable Enterprise Pack', 1;
    use_ok 'MT::BulkCreation';
}
use_ok 'MT::Callback';
use_ok 'MT::Category';
use_ok 'MT::Comment';
use_ok 'MT::Config';
use_ok 'MT::ConfigMgr';
use_ok 'MT::DateTime';
use_ok 'MT::DefaultTemplates';
use_ok 'MT::Entry';
use_ok 'MT::ErrorHandler';
use_ok 'MT::FileInfo';
use_ok 'MT::FileMgr';
use_ok 'MT::FileMgr::Local';
use_ok 'MT::Image';
use_ok 'MT::ImportExport';
use_ok 'MT::IPBanList';
use_ok 'MT::JunkFilter';
use_ok 'MT::L10N';
use_ok 'MT::L10N::de';
use_ok 'MT::L10N::en_us';
use_ok 'MT::L10N::es';
use_ok 'MT::L10N::fr';
use_ok 'MT::L10N::ja';
use_ok 'MT::L10N::nl';
use_ok 'MT::I18N';
use_ok 'MT::I18N::default';
use_ok 'MT::I18N::en_us';
use_ok 'MT::I18N::ja';
SKIP: {
    skip 'Enable Enterprise Pack', 1;
    use_ok 'MT::LDAP';
}
use_ok 'MT::Log';
use_ok 'MT::Mail';
use_ok 'MT::Notification';
use_ok 'MT::Object';
use_ok 'MT::ObjectDriverFactory';
use_ok 'MT::ObjectDriver::Driver::DBI';
use_ok 'MT::ObjectDriver::Driver::DBD::Legacy';
use_ok 'MT::ObjectDriver::Driver::DBD::mysql';
SKIP: {
    eval { require DBD::Oracle };
    skip 'DBD::Oracle not installed', 1 if $@;
    use_ok 'MT::ObjectDriver::Driver::DBD::Oracle';
    eval { require DBD::odbc };
    skip 'DBD::odbc not installed', 1 if $@;
    use_ok 'MT::ObjectDriver::Driver::DBD::MSSQLServer';
    use_ok 'MT::ObjectDriver::Driver::DBD::UMSSQLServer';
}
use_ok 'MT::ObjectDriver::Driver::DBD::Pg';
use_ok 'MT::ObjectDriver::Driver::DBD::SQLite';
use_ok 'MT::ObjectAsset';
use_ok 'MT::ObjectScore';
use_ok 'MT::ObjectTag';
use_ok 'MT::Permission';
SKIP: {
    skip 'Enable Enterprise Pack', 1;
    use_ok 'MT::Group';
}
use_ok 'MT::Role';
use_ok 'MT::Association';
use_ok 'MT::Placement';
use_ok 'MT::Plugin';
use_ok 'MT::Plugin::JunkFilter';
use_ok 'MT::Plugin::L10N';
use_ok 'MT::PluginData';
use_ok 'MT::Promise';
use_ok 'MT::Request';
use_ok 'MT::Sanitize';
use_ok 'MT::Serialize';
use_ok 'MT::Session';
use_ok 'MT::Tag';
use_ok 'MT::Task';
use_ok 'MT::TaskMgr';
use_ok 'MT::TBPing';
use_ok 'MT::Template';
use_ok 'MT::Template::Context';
use_ok 'MT::Template::ContextHandlers';
use_ok 'MT::TemplateMap';
use_ok 'MT::Trackback';
use_ok 'MT::Upgrade';
use_ok 'MT::Util';
use_ok 'MT::WeblogPublisher';
use_ok 'MT::XMLRPC';
use_ok 'MT::XMLRPCServer';
use_ok 'MT::Asset';
use_ok 'MT::Asset::Image';
use_ok 'MT::Asset::Video';
use_ok 'MT::Asset::Audio';
use_ok 'MT::BackupRestore';
use_ok 'MT::BackupRestore::BackupFileHandler';
use_ok 'MT::BackupRestore::ManifestFileHandler';
