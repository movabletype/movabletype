#!/usr/bin/perl
# $Id: 00-compile.t 2573 2008-06-13 18:54:41Z bchoate $

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use MT::Test;

use Test::More tests => 182;

use_ok('MT::Bootstrap');
use_ok('MT::ErrorHandler');
use_ok('MT');

# Base App class
use_ok('MT::App');
use_ok('MT::Tool');

# Core module
use_ok('MT::Core');
use_ok('MT::Component');

# All CMS modules
use_ok('MT::App::CMS');
use_ok('MT::CMS::AddressBook');
use_ok('MT::CMS::Dashboard');
use_ok('MT::CMS::Plugin');
use_ok('MT::CMS::Asset');
use_ok('MT::CMS::Entry');
use_ok('MT::CMS::Search');
use_ok('MT::CMS::BanList');
use_ok('MT::CMS::Export');
use_ok('MT::CMS::Tag');
use_ok('MT::CMS::Blog');
use_ok('MT::CMS::Folder');
use_ok('MT::CMS::Template');
use_ok('MT::CMS::Category');
use_ok('MT::CMS::Import');
use_ok('MT::CMS::Tools');
use_ok('MT::CMS::Comment');
use_ok('MT::CMS::Log');
use_ok('MT::CMS::TrackBack');
use_ok('MT::CMS::Common');
use_ok('MT::CMS::Page');
use_ok('MT::CMS::User');

# Supporting applications
use_ok('MT::App::ActivityFeeds');
use_ok('MT::App::Comments');
use_ok('MT::App::NotifyList');
use_ok('MT::App::Trackback');
use_ok('MT::App::Upgrader');
use_ok('MT::App::Wizard');

# Search apps
use_ok('MT::App::Search');
use_ok('MT::App::Search::FreeText');
use_ok('MT::App::Search::Legacy');
use_ok('MT::App::Search::TagSearch');

# Auth framework
use_ok('MT::Auth');
use_ok('MT::Auth::MT');
use_ok('MT::Auth::BasicAuth');
use_ok('MT::Auth::LiveJournal');
use_ok('MT::Auth::OpenID');
use_ok('MT::Auth::TypeKey');
use_ok('MT::Auth::Vox');

# MT::Objects
use_ok('MT::Object');
use_ok('MT::Author');
use_ok('MT::BasicAuthor');
use_ok('MT::BasicSession');
use_ok('MT::Blog');
use_ok('MT::ObjectScore');
use_ok('MT::ObjectTag');
use_ok('MT::Permission');
use_ok('MT::Role');
use_ok('MT::Association');
use_ok('MT::Placement');
use_ok('MT::Category');
use_ok('MT::Comment');
use_ok('MT::Entry');
use_ok('MT::IPBanList');
use_ok('MT::FileInfo');
use_ok('MT::Config');
use_ok('MT::Asset');
use_ok('MT::Asset::Image');
use_ok('MT::Asset::Video');
use_ok('MT::Asset::Audio');
use_ok('MT::ObjectAsset');
use_ok('MT::Log');
use_ok('MT::Notification');
use_ok('MT::PluginData');
use_ok('MT::Session');
use_ok('MT::Tag');
use_ok('MT::Template');
use_ok('MT::TemplateMap');
use_ok('MT::Trackback');
use_ok('MT::TBPing');
use_ok('MT::Blocklist');
use_ok('MT::Object::BaseCache');
use_ok('MT::Touch');
use_ok('MT::WebSite');

# Utility modules
use_ok('MT::Builder');
use_ok('MT::Callback');
use_ok('MT::ConfigMgr');
use_ok('MT::DateTime');
use_ok('MT::DefaultTemplates');
use_ok('MT::FileMgr');
use_ok('MT::FileMgr::Local');
use_ok('MT::Image');
use_ok('MT::ImportExport');
use_ok('MT::Import');
use_ok('MT::JunkFilter');
use_ok('MT::Mail');
use_ok('MT::Promise');
use_ok('MT::Request');
use_ok('MT::Sanitize');
use_ok('MT::Serialize');
use_ok('MT::Memcached');
use_ok('MT::PublishOption');
use_ok('MT::Scorable');

use_ok('MT::Util');
use_ok('MT::Util::Archive');
use_ok('MT::Util::Archive::Tgz');
use_ok('MT::Util::Archive::Zip');
use_ok('MT::Util::Captcha');
use_ok('MT::Util::LogProcessor');
use_ok('MT::Util::PerformanceData');
use_ok('MT::Util::ReqTimer');

# TheSchwartz support
use_ok('MT::TheSchwartz');
use_ok('MT::TheSchwartz::Error');
use_ok('MT::TheSchwartz::ExitStatus');
use_ok('MT::TheSchwartz::FuncMap');
use_ok('MT::TheSchwartz::Job');

# L10N modules
use_ok('MT::L10N');
use_ok('MT::L10N::de');
use_ok('MT::L10N::en_us');
use_ok('MT::L10N::es');
use_ok('MT::L10N::fr');
use_ok('MT::L10N::ja');
use_ok('MT::L10N::nl');

# I18N modules
use_ok('MT::I18N');
use_ok('MT::I18N::default');
use_ok('MT::I18N::en_us');
use_ok('MT::I18N::ja');

# Data::ObjectDriver classes
use_ok('MT::ObjectDriverFactory');
use_ok('MT::ObjectDriver::DDL');
use_ok('MT::ObjectDriver::DDL::Pg');
use_ok('MT::ObjectDriver::DDL::SQLite');
use_ok('MT::ObjectDriver::DDL::mysql');
use_ok('MT::ObjectDriver::Driver::DBI');
use_ok('MT::ObjectDriver::Driver::Cache::RAM');
use_ok('MT::ObjectDriver::Driver::DBD::Legacy');
use_ok('MT::ObjectDriver::Driver::DBD::mysql');
use_ok('MT::ObjectDriver::Driver::DBD::Pg');
use_ok('MT::ObjectDriver::Driver::DBD::SQLite');
use_ok('MT::ObjectDriver::SQL');
use_ok('MT::ObjectDriver::SQL::Pg');
use_ok('MT::ObjectDriver::SQL::SQLite');
use_ok('MT::ObjectDriver::SQL::mysql');

# Plugin API
use_ok('MT::Plugin');
use_ok('MT::Plugin::JunkFilter');
use_ok('MT::Plugin::L10N');
use_ok('MT::Task');
use_ok('MT::TaskMgr');
use_ok('MT::Template::Context');
use_ok('MT::Template::ContextHandlers');
use_ok('MT::Upgrade');
use_ok('MT::WeblogPublisher');

# Archive code
use_ok('MT::ArchiveType');
use_ok('MT::ArchiveType::Author');
use_ok('MT::ArchiveType::AuthorDaily');
use_ok('MT::ArchiveType::AuthorMonthly');
use_ok('MT::ArchiveType::AuthorWeekly');
use_ok('MT::ArchiveType::AuthorYearly');
use_ok('MT::ArchiveType::Category');
use_ok('MT::ArchiveType::CategoryDaily');
use_ok('MT::ArchiveType::CategoryMonthly');
use_ok('MT::ArchiveType::CategoryWeekly');
use_ok('MT::ArchiveType::CategoryYearly');
use_ok('MT::ArchiveType::Daily');
use_ok('MT::ArchiveType::Date');
use_ok('MT::ArchiveType::Individual');
use_ok('MT::ArchiveType::Monthly');
use_ok('MT::ArchiveType::Page');
use_ok('MT::ArchiveType::Weekly');
use_ok('MT::ArchiveType::Yearly');

# XMLRPC support
use_ok('MT::XMLRPC');
use_ok('MT::XMLRPCServer');

# Atom support
use_ok('MT::Atom');
use_ok('MT::AtomServer');

# Backup/Restore
use_ok('MT::BackupRestore');
use_ok('MT::BackupRestore::BackupFileHandler');
use_ok('MT::BackupRestore::ManifestFileHandler');

# Cache support
use_ok('MT::Cache::Negotiate');
use_ok('MT::Cache::Null');
use_ok('MT::Cache::Session');

# Compatible Support
use_ok('MT::Compat::v3');

# Meta support
use_ok('MT::Meta');
use_ok('MT::Meta::Proxy');

# Job worker
use_ok('MT::Worker::Publish');
use_ok('MT::Worker::Sync');
