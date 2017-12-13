#!/usr/bin/perl
# $Id: 00-compile.t 2573 2008-06-13 18:54:41Z bchoate $

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use File::Spec;
use MT::Test;

use_ok('MT::Bootstrap');
use_ok('MT::ErrorHandler');
use_ok('MT');

# Base App class
use_ok('MT::App');
use_ok('MT::Tool');

# Core module
use_ok('MT::Core');
use_ok('MT::Component');

# CMS modules
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
use_ok('MT::CMS::Website');
use_ok('MT::CMS::Theme');
use_ok('MT::CMS::Filter');

# Supporting applications
use_ok('MT::App::ActivityFeeds');
use_ok('MT::App::Comments');
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
use_ok('MT::Auth::WordPress');
use_ok('MT::Auth::Hatena');
use_ok('MT::Auth::AIM');
use_ok('MT::Auth::Yahoo');
use_ok('MT::Auth::GoogleOpenId');

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
use_ok('MT::Website');
use_ok('MT::Filter');
use_ok('MT::Page');
use_ok('MT::Folder');

# Utility modules
use_ok('MT::Builder');
use_ok('MT::Callback');
use_ok('MT::ConfigMgr');
use_ok('MT::DateTime');
use_ok('MT::DefaultTemplates');
use_ok('MT::FileMgr');
use_ok('MT::FileMgr::Local');
use_ok('MT::FileMgr::FTP');

# Debug
use_ok('MT::CMS::Debug');
use_ok('MT::Debug::GitInfo');

# MT7
use_ok('MT::ArchiveType::ContentType');
use_ok('MT::ArchiveType::ContentTypeAuthor');
use_ok('MT::ArchiveType::ContentTypeAuthorDaily');
use_ok('MT::ArchiveType::ContentTypeAuthorMonthly');
use_ok('MT::ArchiveType::ContentTypeAuthorWeekly');
use_ok('MT::ArchiveType::ContentTypeAuthorYearly');
use_ok('MT::ArchiveType::ContentTypeCategory');
use_ok('MT::ArchiveType::ContentTypeCategoryDaily');
use_ok('MT::ArchiveType::ContentTypeCategoryMonthly');
use_ok('MT::ArchiveType::ContentTypeCategoryWeekly');
use_ok('MT::ArchiveType::ContentTypeCategoryYearly');
use_ok('MT::ArchiveType::ContentTypeDaily');
use_ok('MT::ArchiveType::ContentTypeDate');
use_ok('MT::ArchiveType::ContentTypeMonthly');
use_ok('MT::ArchiveType::ContentTypeWeekly');
use_ok('MT::ArchiveType::ContentTypeYearly');
use_ok('MT::CMS::CategorySet');
use_ok('MT::CMS::ContentData');
use_ok('MT::CMS::ContentType');
use_ok('MT::CategorySet');
use_ok('MT::ContentData');
use_ok('MT::ContentField');
use_ok('MT::ContentFieldIndex');
use_ok('MT::ContentFieldType');
use_ok('MT::ContentFieldType::Asset');
use_ok('MT::ContentFieldType::Categories');
use_ok('MT::ContentFieldType::Checkboxes');
use_ok('MT::ContentFieldType::Common');
use_ok('MT::ContentFieldType::ContentType');
use_ok('MT::ContentFieldType::Date');
use_ok('MT::ContentFieldType::DateTime');
use_ok('MT::ContentFieldType::List');
use_ok('MT::ContentFieldType::MultiLineText');
use_ok('MT::ContentFieldType::Number');
use_ok('MT::ContentFieldType::RadioButton');
use_ok('MT::ContentFieldType::SelectBox');
use_ok('MT::ContentFieldType::SingleLineText');
use_ok('MT::ContentFieldType::Table');
use_ok('MT::ContentFieldType::Tags');
use_ok('MT::ContentFieldType::Time');
use_ok('MT::ContentFieldType::URL');
use_ok('MT::ContentPublisher');
use_ok('MT::ContentStatus');
use_ok('MT::ContentType');
use_ok('MT::ContentType::UniqueID');
use_ok('MT::EntryStatus');
use_ok('MT::ObjectCategory');
use_ok('MT::Template::Tags::ContentType');

SKIP: {

    if ( eval { require Net::FTPSSL } ) {
        use_ok('MT::FileMgr::FTPS');
    }
    else {
        skip( 'Net::FTPSSL is not installed', 1 );
    }
}
SKIP: {
    if ( eval { require Net::SFTP } ) {
        use_ok('MT::FileMgr::SFTP');
    }
    else {
        skip( 'Net::SFTP is not installed', 1 );
    }
}
SKIP: {
    if ( eval { require HTTP::DAV } ) {
        use_ok('MT::FileMgr::DAV');
    }
    else {
        skip( 'HTTP::DAV is not installed', 1 );
    }
}
use_ok('MT::Image');
use_ok('MT::Image::GD');
use_ok('MT::Image::NetPBM');
use_ok('MT::Image::Imager');
use_ok('MT::Image::ImageMagick');
use_ok('MT::ImportExport');
use_ok('MT::Import');
use_ok('MT::JunkFilter');
use_ok('MT::Mail');
use_ok('MT::Promise');
use_ok('MT::Request');
use_ok('MT::Sanitize');
use_ok('MT::Serialize');
use_ok('MT::Memcached');
use_ok('MT::Memcached::ExpirableProxy');
use_ok('MT::PublishOption');
use_ok('MT::Scorable');
use_ok('MT::Template::Node');
use_ok('MT::Template::Handler');
use_ok('MT::ListProperty');

use_ok('MT::Util');
use_ok('MT::Util::Archive');
SKIP: {
    if ( eval { require Archive::Tar } ) {
        use_ok('MT::Util::Archive::Tgz');
    }
    else {
        skip( 'Archive::Tar is not installed', 1 );
    }
}
SKIP: {
    if ( eval { require Archive::Zip } ) {
        use_ok('MT::Util::Archive::Zip');
    }
    else {
        skip( 'Archive::Zip is not installed', 1 );
    }
}
use_ok('MT::Util::Captcha');
SKIP: {
    my @modules = qw( Compress::Zlib Path::Class DateTime );
    my $eval_string = join( ';', map {"require $_"} @modules );
    if ( eval $eval_string ) {
        use_ok('MT::Util::LogProcessor');
    }
    else {
        my $last_module = pop @modules;
        skip( join( ', ', @modules ) . " or $last_module is not installed",
            1 );
    }
}
use_ok('MT::Util::PerformanceData');
use_ok('MT::Util::ReqTimer');
use_ok('MT::Util::YAML');
SKIP: {
    if ( eval { require YAML::Syck } ) {
        use_ok('MT::Util::YAML::Syck');
    }
    else {
        skip( 'YAML::Syck is not installed', 1 );
    }
}
use_ok('MT::Util::YAML::Tiny');
use_ok('MT::Util::Log');
SKIP: {
    if ( eval { require Log::Log4perl } ) {
        use_ok('MT::Util::Log::Log4perl');
    }
    else {
        skip( 'Log::Log4perl is not installed', 1 );
    }
}
SKIP: {
    if ( eval { require Log::Minimal } ) {
        use_ok('MT::Util::Log::Minimal');
    }
    else {
        skip( 'Log::Minimal is not installed', 1 );
    }
}

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
use_ok('MT::ObjectDriver::Driver::CacheWrapper');
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
use_ok('MT::Template::Context::Search');
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
if ( eval { require XML::Parser } ) {
    use_ok('MT::Atom');
    use_ok('MT::AtomServer');
}

# Backup/Restore
use_ok('MT::BackupRestore');
use_ok('MT::BackupRestore::BackupFileHandler');
use_ok('MT::BackupRestore::ManifestFileHandler');
use_ok('MT::BackupRestore::BackupFileScanner');

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
use_ok('MT::Worker::Summarize');
use_ok('MT::Worker::SummaryWatcher');

# Tag Handlers
use_ok('MT::Template::Tags::Archive');
use_ok('MT::Template::Tags::Asset');
use_ok('MT::Template::Tags::Author');
use_ok('MT::Template::Tags::Blog');
use_ok('MT::Template::Tags::Calendar');
use_ok('MT::Template::Tags::Category');
use_ok('MT::Template::Tags::CategorySet');
use_ok('MT::Template::Tags::Comment');
use_ok('MT::Template::Tags::Commenter');
use_ok('MT::Template::Tags::Entry');
use_ok('MT::Template::Tags::Filters');
use_ok('MT::Template::Tags::Folder');
use_ok('MT::Template::Tags::Misc');
use_ok('MT::Template::Tags::Page');
use_ok('MT::Template::Tags::Pager');
use_ok('MT::Template::Tags::Ping');
use_ok('MT::Template::Tags::Score');
use_ok('MT::Template::Tags::Search');
use_ok('MT::Template::Tags::Site');
use_ok('MT::Template::Tags::Tag');
use_ok('MT::Template::Tags::Userpic');
use_ok('MT::Template::Tags::Website');

# Upgrader
use_ok('MT::Upgrade');
use_ok('MT::Upgrade::Core');
use_ok('MT::Upgrade::v1');
use_ok('MT::Upgrade::v2');
use_ok('MT::Upgrade::v3');
use_ok('MT::Upgrade::v4');
use_ok('MT::Upgrade::v5');
use_ok('MT::Upgrade::v6');
use_ok('MT::Upgrade::v7');

# Revision Management Framework
use_ok('MT::Revisable');
use_ok('MT::Revisable::Local');

# Summary framework
use_ok('MT::Summary');
use_ok('MT::Summary::Author');
use_ok('MT::Summary::Entry');
use_ok('MT::Summary::Proxy');
use_ok('MT::Summary::Triggers');

# Themes
use_ok('MT::Theme');
use_ok('MT::Theme::Category');
use_ok('MT::Theme::CategorySet');
use_ok('MT::Theme::Common');
use_ok('MT::Theme::ContentData');
use_ok('MT::Theme::ContentType');
use_ok('MT::Theme::Element');
use_ok('MT::Theme::Entry');
use_ok('MT::Theme::Pref');
use_ok('MT::Theme::StaticFiles');
use_ok('MT::Theme::TemplateSet');

# Lockout
use_ok('MT::FailedLogin');
use_ok('MT::Lockout');

# DataAPI
use_ok('MT::App::DataAPI');
use_ok('MT::App::CMS::Common');
use_ok('MT::DataAPI::Callback::Comment');
use_ok('MT::DataAPI::Callback::Entry');
use_ok('MT::DataAPI::Callback::Permission');
use_ok('MT::DataAPI::Callback::Trackback');
use_ok('MT::DataAPI::Callback::User');
use_ok('MT::DataAPI::Endpoint::Asset');
use_ok('MT::DataAPI::Endpoint::Auth');
use_ok('MT::DataAPI::Endpoint::Blog');
use_ok('MT::DataAPI::Endpoint::Category');
use_ok('MT::DataAPI::Endpoint::Comment');
use_ok('MT::DataAPI::Endpoint::Common');
use_ok('MT::DataAPI::Endpoint::Entry');
use_ok('MT::DataAPI::Endpoint::Permission');
use_ok('MT::DataAPI::Endpoint::Publish');
use_ok('MT::DataAPI::Endpoint::Stats');
use_ok('MT::DataAPI::Endpoint::Trackback');
use_ok('MT::DataAPI::Endpoint::User');
use_ok('MT::DataAPI::Endpoint::Util');
use_ok('MT::DataAPI::Format');
use_ok('MT::DataAPI::Format::JSON');
use_ok('MT::DataAPI::Resource');
use_ok('MT::DataAPI::Resource::Asset');
use_ok('MT::DataAPI::Resource::Blog');
use_ok('MT::DataAPI::Resource::Category');
use_ok('MT::DataAPI::Resource::Comment');
use_ok('MT::DataAPI::Resource::Common');
use_ok('MT::DataAPI::Resource::Entry');
use_ok('MT::DataAPI::Resource::Permission');
use_ok('MT::DataAPI::Resource::Trackback');
use_ok('MT::DataAPI::Resource::User');
use_ok('MT::DataAPI::Resource::Website');
use_ok('MT::AccessToken');
use_ok('MT::Stats');
use_ok('MT::Stats::Provider');

# Data API v2.
use_ok('MT::DataAPI::Callback::Widget');
use_ok('MT::DataAPI::Callback::Asset');
use_ok('MT::DataAPI::Callback::Template');
use_ok('MT::DataAPI::Callback::Tag');
use_ok('MT::DataAPI::Callback::Page');
use_ok('MT::DataAPI::Callback::Category');
use_ok('MT::DataAPI::Callback::Folder');
use_ok('MT::DataAPI::Callback::TemplateMap');
use_ok('MT::DataAPI::Callback::Role');
use_ok('MT::DataAPI::Callback::WidgetSet');
use_ok('MT::DataAPI::Callback::Blog');
use_ok('MT::DataAPI::Callback::Log');
use_ok('MT::DataAPI::Callback::Website');
use_ok('MT::DataAPI::Callback::Plugin');

use_ok('MT::DataAPI::Resource::v2::Asset');
use_ok('MT::DataAPI::Resource::v2::Template');
use_ok('MT::DataAPI::Resource::v2::Permission');
use_ok('MT::DataAPI::Resource::v2::Comment');
use_ok('MT::DataAPI::Resource::v2::Tag');
use_ok('MT::DataAPI::Resource::v2::Page');
use_ok('MT::DataAPI::Resource::v2::Category');
use_ok('MT::DataAPI::Resource::v2::Folder');
use_ok('MT::DataAPI::Resource::v2::TemplateMap');
use_ok('MT::DataAPI::Resource::v2::Trackback');
use_ok('MT::DataAPI::Resource::v2::Role');
use_ok('MT::DataAPI::Resource::v2::Entry');
use_ok('MT::DataAPI::Resource::v2::Association');
use_ok('MT::DataAPI::Resource::v2::Blog');
use_ok('MT::DataAPI::Resource::v2::Log');
use_ok('MT::DataAPI::Resource::v2::Website');
use_ok('MT::DataAPI::Resource::v2::User');

use_ok('MT::DataAPI::Resource::Util');

use_ok('MT::DataAPI::Endpoint::v2::Widget');
use_ok('MT::DataAPI::Endpoint::v2::Asset');
use_ok('MT::DataAPI::Endpoint::v2::Template');
use_ok('MT::DataAPI::Endpoint::v2::Permission');
use_ok('MT::DataAPI::Endpoint::v2::Tag');
use_ok('MT::DataAPI::Endpoint::v2::Page');
use_ok('MT::DataAPI::Endpoint::v2::Category');
use_ok('MT::DataAPI::Endpoint::v2::Folder');
use_ok('MT::DataAPI::Endpoint::v2::TemplateMap');
use_ok('MT::DataAPI::Endpoint::v2::Role');
use_ok('MT::DataAPI::Endpoint::v2::Search');
use_ok('MT::DataAPI::Endpoint::v2::Entry');
use_ok('MT::DataAPI::Endpoint::v2::Theme');
use_ok('MT::DataAPI::Endpoint::v2::WidgetSet');
use_ok('MT::DataAPI::Endpoint::v2::Blog');
use_ok('MT::DataAPI::Endpoint::v2::Log');
use_ok('MT::DataAPI::Endpoint::v2::BackupRestore');
use_ok('MT::DataAPI::Endpoint::v2::Plugin');
use_ok('MT::DataAPI::Endpoint::v2::User');

use_ok('MT::DataAPI::Endpoint::v3::Auth');
use_ok('MT::DataAPI::Endpoint::v3::Asset');
use_ok('MT::DataAPI::Endpoint::v3::Entry');

use_ok('MT::DataAPI::Resource::v3::Blog');
use_ok('MT::DataAPI::Resource::v3::Website');
use_ok('MT::DataAPI::Resource::v3::User');

use_ok('MT::App::Search::Common');

SKIP: {
    my @modules
        = qw( parent Plack CGI::PSGI CGI::Parse::PSGI XMLRPC::Transport::HTTP::Plack );
    my $eval_string = join( ';', map {"require $_"} @modules );
    if ( eval $eval_string ) {
        use_ok('MT::PSGI');
    }
    else {
        my $last_module = pop @modules;
        skip( join( ', ', @modules ) . " or $last_module is not installed",
            1 );
    }
}

test_all_modules_are_checked();

done_testing();

# compares the list of modules that this test checks with
# the actual modules that are on the file system
sub test_all_modules_are_checked {
    my $in_test  = _read_compile_test();
    my $libpath  = File::Spec->catfile( $FindBin::Bin, "..", 'lib' );
    my @in_files = _collect_modules($libpath);

    my @not_in_test;
    foreach my $name (@in_files) {
        if ( not exists $in_test->{$name} ) {
            push @not_in_test, $name;
            next;
        }
        delete $in_test->{$name};
    }
    my $res = '';
    if (@not_in_test) {
        $res .= "Modules not tested: " . join( ", ", @not_in_test );
    }
    if ( keys %$in_test ) {
        $res .= " " if $res;
        $res .= "Modules not on HD: " . join( ", ", sort keys %$in_test );
    }
    if ($res) {
        ok( 0, $res );
    }
    else {
        ok( 1, "All modules are checked, " . scalar(@in_files) . " modules" );
    }
}

sub _collect_modules {
    my ($path) = @_;
    my @files = _internal_collect_modules( $path, "" );
    my @files2 = map { s/^:://; s/\.pm$//; $_ } grep {m/\.pm$/} @files;
    return @files2;
}

sub _internal_collect_modules {
    my ( $path, $prex ) = @_;
    my @files;
    opendir my $dh, $path or die "can not open dir $path";
    while ( my $filename = readdir $dh ) {
        next if $filename =~ /^\./;
        if ( -d File::Spec->catfile( $path, $filename ) ) {
            push @files,
                _internal_collect_modules(
                File::Spec->catfile( $path, $filename ),
                $prex . "::" . $filename );
            next;
        }
        push @files, $prex . "::" . $filename;
    }
    closedir $dh;
    return @files;
}

sub _read_compile_test {
    my %modules;
    open my $fh, "<" . File::Spec->catfile( $FindBin::Bin, "00-compile.t" )
        or die "can not open 00-compile.t file";
    while ( my $line = <$fh> ) {
        chomp $line;
        next unless $line =~ /use_ok\('([\w:]+)'\)/;
        my $module = $1;
        $module =~ s/\s+//g;
        warn "duplicate inside 00-compile.t: $module\n"
            if exists $modules{$module};
        $modules{$module} = 1;
    }
    close $fh;
    return \%modules;
}
