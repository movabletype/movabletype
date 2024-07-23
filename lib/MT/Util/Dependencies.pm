# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
package MT::Util::Dependencies;

use strict;
use warnings;
no warnings 'once';

my %CustomURL = (
    'Image::Magick'    => 'http://www.imagemagick.org/script/perl-magick.php',
    'Graphics::Magick' => 'http://www.graphicsmagick.org/perl.html',
);

our %Requirements = (
    "Archive::Tar" => {
        dropped_in => ["amazonlinux2023", "centos7"],
        label      => "This module is optional. It is used to manipulate files during import/export operations.",
        perl_core  => 1.82,
        tags       => ["Archive"],
        url        => "https://metacpan.org/pod/Archive::Tar",
    },
    "Archive::Zip" => {
        label => "This module is optional. It is used to manipulate files during import/export operations.",
        note  => "1.66+ has a stray symlink issue",
        tags  => ["Archive"],
        url   => "https://metacpan.org/pod/Archive::Zip",
    },
    "Authen::SASL" => {
        label => "This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.",
        tags  => ["Mail"],
        url   => "https://metacpan.org/pod/Authen::SASL",
    },
    "Authen::SASL::XS" => {
        label => "This module is optional. It enhances performance of Authen::SASL.",
        tags  => ["Mail", "Performance"],
        url   => "https://metacpan.org/pod/Authen::SASL::XS",
    },
    "Cache::Memcached" => {
        label => "Cache::Memcached and a memcached server are optional. They are used to cache in-memory objects.",
        tags  => ["Cache"],
        url   => "https://metacpan.org/pod/Cache::Memcached",
    },
    "CGI" => {
        extlib   => 4.61,
        label    => "CGI is required for all Movable Type application functionality.",
        required => 1,
        tags     => ["Base"],
        url      => "https://metacpan.org/pod/CGI",
        version  => 4.11,
    },
    "CGI::Cookie" => {
        extlib   => 4.59,
        label    => "CGI::Cookie is required for cookie authentication.",
        required => 1,
        tags     => ["Base"],
        url      => "https://metacpan.org/pod/CGI::Cookie",
    },
    "CGI::Parse::PSGI" => {
        label => "This module and its dependencies are required to run Movable Type under psgi.",
        tags  => ["Backend", "PSGI"],
        url   => "https://metacpan.org/pod/CGI::Parse::PSGI",
    },
    "CGI::PSGI" => {
        label => "This module and its dependencies are required to run Movable Type under psgi.",
        tags  => ["Backend", "PSGI"],
        url   => "https://metacpan.org/pod/CGI::PSGI",
    },
    "DateTime" => {
        label => "This module is optional. It is used to parse date in log files.",
        tags  => ["Tool", "DateTime"],
        url   => "https://metacpan.org/pod/DateTime",
    },
    "DBD::mysql" => {
        label => "DBI and DBD::mysql are required if you want to use the MySQL database backend.",
        tags  => ["Database"],
        url   => "https://metacpan.org/pod/DBD::mysql",
    },
    "DBD::Pg" => {
        label   => "DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.",
        tags    => ["Database"],
        url     => "https://metacpan.org/pod/DBD::Pg",
        version => 1.32,
    },
    "DBD::SQLite" => {
        label   => "DBI and DBD::SQLite are required if you want to use the SQLite database backend.",
        tags    => ["Database"],
        url     => "https://metacpan.org/pod/DBD::SQLite",
        version => "1.20",
    },
    "DBI" => {
        label    => "DBI is required to work with most supported databases.",
        required => 1,
        tags     => ["Database"],
        url      => "https://metacpan.org/pod/DBI",
        version  => 1.21,
    },
    "Digest::MD5" => {
        dropped_in => ["centos7"],
        label      => "This module is used to make checksums.",
        perl_core  => 2.51,
        tags       => ["Digest"],
        url        => "https://metacpan.org/pod/Digest::MD5",
    },
    "Digest::SHA" => {
        dropped_in => ["amazonlinux2023", "centos7"],
        label      => "Digest::SHA is required in order to provide enhanced protection of user passwords.",
        perl_core  => 5.71,
        tags       => ["Digest"],
        url        => "https://metacpan.org/pod/Digest::SHA",
    },
    "Email::MIME" => {
        label => "This module and its dependencies are optional. It is an alternative module to create mail.",
        tags  => ["Mail"],
        url   => "https://metacpan.org/pod/Email::MIME",
    },
    "Encode" => {
        label     => "Encode is required to handle multibyte characters correctly.",
        perl_core => 2.44,
        required  => 1,
        tags      => ["Base"],
        url       => "https://metacpan.org/pod/Encode",
    },
    "FCGI" => {
        label => "This module and its dependencies are required to run Movable Type under FastCGI.",
        tags  => ["Backend", "FastCGI"],
        url   => "https://metacpan.org/pod/FCGI",
    },
    "File::Spec" => {
        label     => "File::Spec is required to work with file system path information on all supported operating systems.",
        perl_core => "3.39_02",
        required  => 1,
        tags      => ["Base", "Filesys"],
        url       => "https://metacpan.org/pod/File::Spec",
        version   => 0.8,
    },
    "File::Temp" => {
        extlib    => 0.2311,
        label     => "File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.",
        perl_core => 0.22,
        tags      => ["Base", "Filesys"],
        url       => "https://metacpan.org/pod/File::Temp",
    },
    "Filesys::DfPortable" => {
        label => "This module is optional. It is used to see if the disk is full while backing up.",
        tags  => ["Filesys"],
        url   => "https://metacpan.org/pod/Filesys::DfPortable",
    },
    "Fluent::Logger" => {
        label => "This module is optional. It is used to customize the logging behavior.",
        tags  => ["Log"],
        url   => "https://metacpan.org/pod/Fluent::Logger",
    },
    "GD" => {
        label => "This module is one of the image processors that you can use to create thumbnails of uploaded images.",
        tags  => ["ImageDriver"],
        url   => "https://metacpan.org/pod/GD",
    },
    "Graphics::Magick" => {
        label => "This module is one of the image processors that you can use to create thumbnails of uploaded images.",
        tags  => ["ImageDriver"],
        url   => "http://www.graphicsmagick.org/perl.html",
    },
    "HTML::Entities" => {
        label    => "HTML::Entities is required by CGI.pm",
        required => 1,
        tags     => ["Base"],
        url      => "https://metacpan.org/pod/HTML::Entities",
        version  => 3.69,
    },
    "HTTP::DAV" => {
        label => "This module is optional. It is used to manipulate files via WebDAV.",
        tags  => ["Filesys"],
        url   => "https://metacpan.org/pod/HTTP::DAV",
    },
    "HTTP::Request" => {
        extlib => 6.43,
        label  => "This module is optional. It is used to download assets from a website.",
        tags   => ["HTTP"],
        url    => "https://metacpan.org/pod/HTTP::Request",
    },
    "Image::ExifTool" => {
        extlib => 12.76,
        label  => "Image::ExifTool is used to manipulate image metadata.",
        tags   => ["Image"],
        url    => "https://metacpan.org/pod/Image::ExifTool",
    },
    "Image::Magick" => {
        label => "This module is one of the image processors that you can use to create thumbnails of uploaded images.",
        tags  => ["ImageDriver"],
        url   => "http://www.imagemagick.org/script/perl-magick.php",
    },
    "Image::Size" => {
        extlib => "3.300",
        label  => "Image::Size is sometimes required to determine the size of images in different formats.",
        tags   => ["Image"],
        url    => "https://metacpan.org/pod/Image::Size",
    },
    "Imager" => {
        label => "This module is one of the image processors that you can use to create thumbnails of uploaded images.",
        tags  => ["ImageDriver"],
        url   => "https://metacpan.org/pod/Imager",
    },
    "IO::Compress::Gzip" => {
        dropped_in => ["amazonlinux2023", "centos7"],
        label      => "IO::Compress::Gzip is required in order to compress files during an export operation.",
        perl_core  => 2.048,
        tags       => ["Archive"],
        url        => "https://metacpan.org/pod/IO::Compress::Gzip",
    },
    "IO::Socket::SSL" => {
        label => "This module is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.",
        tags  => ["Security"],
        url   => "https://metacpan.org/pod/IO::Socket::SSL",
    },
    "IO::Uncompress::Gunzip" => {
        dropped_in => ["amazonlinux2023", "centos7"],
        label      => "IO::Uncompress::Gunzip is required in order to decompress files during an import operation.",
        perl_core  => 2.048,
        tags       => ["Archive"],
        url        => "https://metacpan.org/pod/IO::Uncompress::Gunzip",
    },
    "IPC::Run" => {
        label => "IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.",
        tags  => ["System", "Image"],
        url   => "https://metacpan.org/pod/IPC::Run",
    },
    "JSON" => {
        extlib   => "4.10",
        label    => "JSON is required to use DataAPI, Content Type, and listing framework.",
        required => 1,
        tags     => ["JSON"],
        url      => "https://metacpan.org/pod/JSON",
    },
    "JSON::PP" => {
        dropped_in => ["amazonlinux2023", "centos7"],
        extlib     => 4.16,
        label      => "JSON::PP is used internally to process JSON by default.",
        perl_core  => "2.27200",
        tags       => ["JSON"],
        url        => "https://metacpan.org/pod/JSON::PP",
    },
    "JSON::XS" => {
        label => "JSON::XS accelerates JSON processing.",
        tags  => ["JSON", "Performance"],
        url   => "https://metacpan.org/pod/JSON::XS",
    },
    "List::Util" => {
        label     => "List::Util is required to manipulate a list of numbers.",
        perl_core => 1.23,
        required  => 1,
        tags      => ["Base"],
        url       => "https://metacpan.org/pod/List::Util",
    },
    "local::lib" => {
        label => "local::lib is optional. It is used to load modules from different locations.",
        tags  => ["System"],
        url   => "https://metacpan.org/pod/local::lib",
    },
    "Log::Dispatch::Config" => {
        label => "This module is optional. It is used to customize the logging behavior.",
        tags  => ["Log"],
        url   => "https://metacpan.org/pod/Log::Dispatch::Config",
    },
    "Log::Dispatch::Configurator::Perl" => {
        label => "This module is optional. It is used to customize the logging behavior.",
        tags  => ["Log"],
        url   => "https://metacpan.org/pod/Log::Dispatch::Configurator::Perl",
    },
    "Log::Dispatch::Configurator::YAML" => {
        label => "This module is optional. It is used to customize the logging behavior.",
        tags  => ["Log"],
        url   => "https://metacpan.org/pod/Log::Dispatch::Configurator::YAML",
    },
    "Log::Log4perl" => {
        label => "This module is optional. It is used to customize the logging behavior.",
        tags  => ["Log"],
        url   => "https://metacpan.org/pod/Log::Log4perl",
    },
    "Log::Minimal" => {
        label => "This module is optional. It is used to customize the logging behavior.",
        tags  => ["Log"],
        url   => "https://metacpan.org/pod/Log::Minimal",
    },
    "LWP::Protocol::https" => {
        extlib => 6.12,
        label  => "LWP::Protocol::https is optional. It provides https support for LWP::UserAgent.",
        tags   => ["HTTP"],
        url    => "https://metacpan.org/pod/LWP::Protocol::https",
    },
    "LWP::UserAgent" => {
        extlib => 6.76,
        label  => "LWP::UserAgent is optional. It is used to fetch information from local and external servers.",
        tags   => ["HTTP"],
        url    => "https://metacpan.org/pod/LWP::UserAgent",
    },
    "MIME::Base64" => {
        label     => "MIME::Base64 is required to send mail and handle blobs during import/export operations.",
        perl_core => 3.13,
        tags      => ["Mail", "Encoding"],
        url       => "https://metacpan.org/pod/MIME::Base64",
    },
    "MIME::Lite" => {
        extlib => 3.033,
        label  => "MIME::Lite is an alternative module to create mail.",
        tags   => ["Mail"],
        url    => "https://metacpan.org/pod/MIME::Lite",
    },
    "Mozilla::CA" => {
        label => "This module is required for Google Analytics site statistics and for verification of SSL certificates.",
        tags  => ["Security"],
        url   => "https://metacpan.org/pod/Mozilla::CA",
    },
    "Net::FTP" => {
        label     => "This module is optional. It is used to manipulate files via FTP(S).",
        perl_core => 2.77,
        tags      => ["FTP", "Filesys"],
        url       => "https://metacpan.org/pod/Net::FTP",
    },
    "Net::FTPSSL" => {
        extlib => 0.42,
        label  => "This module is optional. It is used to manipulate files via FTPS.",
        tags   => ["FTP", "Filesys"],
        url    => "https://metacpan.org/pod/Net::FTPSSL",
    },
    "Net::SFTP" => {
        label => "This module is optional. It is used to manipulate files via SFTP.",
        tags  => ["FTP", "Filesys"],
        url   => "https://metacpan.org/pod/Net::SFTP",
    },
    "Net::SMTP" => {
        label     => "Net::SMTP is required in order to send mail via an SMTP server.",
        perl_core => 2.31,
        tags      => ["Mail", "SMTP"],
        url       => "https://metacpan.org/pod/Net::SMTP",
    },
    "Net::SSLeay" => {
        label => "This module is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.",
        tags  => ["Security"],
        url   => "https://metacpan.org/pod/Net::SSLeay",
    },
    "Path::Class" => {
        label => "This module is optional. It is used to manipulate log files.",
        tags  => ["Tool", "Filesys"],
        url   => "https://metacpan.org/pod/Path::Class",
    },
    "Plack" => {
        label => "This module and its dependencies are required to run Movable Type under psgi.",
        tags  => ["Backend", "PSGI"],
        url   => "https://metacpan.org/pod/Plack",
    },
    "Safe" => {
        dropped_in => ["amazonlinux2023"],
        label      => "This module is used in a test attribute for the MTIf conditional tag.",
        perl_core  => "2.31_01",
        tags       => ["System"],
        url        => "https://metacpan.org/pod/Safe",
    },
    "Scalar::Util" => {
        label     => "Scalar::Util is required to avoid memory leaks.",
        perl_core => 1.23,
        tags      => ["Base"],
        url       => "https://metacpan.org/pod/Scalar::Util",
        version   => "1.10",
    },
    "Storable" => {
        label     => "Storable is required to make deep-copy of complicated data structures.",
        perl_core => 2.34,
        required  => 1,
        tags      => ["Base"],
        url       => "https://metacpan.org/pod/Storable",
    },
    "Sys::MemInfo" => {
        label => "This module is optional. It is used to see if swap memory is enough while processing background jobs.",
        tags  => ["System"],
        url   => "https://metacpan.org/pod/Sys::MemInfo",
    },
    "Term::Encoding" => {
        label => "This module is optional. It is used to know the encoding of the terminal to log.",
        tags  => ["System", "Encoding"],
        url   => "https://metacpan.org/pod/Term::Encoding",
    },
    "TheSchwartz" => {
        extlib => 1.17,
        label  => "This module is required to run background jobs.",
        tags   => ["System"],
        url    => "https://metacpan.org/pod/TheSchwartz",
    },
    "Time::HiRes" => {
        dropped_in => ["amazonlinux2023"],
        label      => "This module is required for profiling.",
        perl_core  => 1.9725,
        tags       => ["System", "DateTime"],
        url        => "https://metacpan.org/pod/Time::HiRes",
    },
    "URI" => {
        extlib => 5.25,
        label  => "This module is sometimes used to parse URI.",
        tags   => ["HTTP", "URI"],
        url    => "https://metacpan.org/pod/URI",
    },
    "XML::LibXML::SAX" => {
        label   => "This module is optional; It is one of the modules required to import an exported site and such.",
        tags    => ["XML", "Backup"],
        url     => "https://metacpan.org/pod/XML::LibXML::SAX",
        version => "1.70",
    },
    "XML::Parser" => {
        label => "This module is required to parse XML.",
        tags  => ["XML"],
        url   => "https://metacpan.org/pod/XML::Parser",
    },
    "XML::SAX" => {
        extlib => 1.02,
        label  => "XML::SAX and its dependencies are required to import an exported site and such.",
        tags   => ["XML", "Backup"],
        url    => "https://metacpan.org/pod/XML::SAX",
    },
    "XML::SAX::Expat" => {
        label   => "This module is optional; It is one of the modules required to import an exported site and such.",
        tags    => ["XML", "Backup"],
        url     => "https://metacpan.org/pod/XML::SAX::Expat",
        version => 0.37,
    },
    "XML::SAX::ExpatXS" => {
        label   => "This module is optional; It is one of the modules required to import an exported site and such.",
        tags    => ["XML", "Backup"],
        url     => "https://metacpan.org/pod/XML::SAX::ExpatXS",
        version => "1.30",
    },
    "XML::Simple" => {
        extlib => 2.25,
        label  => "XML::Simple is optional. It is used to parse configuration file of the IIS.",
        tags   => ["Win32", "XML"],
        url    => "https://metacpan.org/pod/XML::Simple",
    },
    "YAML::Syck" => {
        label => "YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.",
        tags  => ["YAML", "Performance"],
        url   => "https://metacpan.org/pod/YAML::Syck",
    },
    "YAML::Tiny" => {
        extlib => 1.74,
        label  => "YAML::Tiny is the default YAML parser.",
        tags   => ["YAML"],
        url    => "https://metacpan.org/pod/YAML::Tiny",
    },
);

our %ExtLibOnly = (
    "Algorithm::Diff" => {
        extlib  => 1.201,
        url     => "https://metacpan.org/pod/Algorithm::Diff",
        used_in => ["HTML::Diff"],
    },
    "AutoLoader" => {
        extlib    => 5.74,
        not_used  => 1,
        note      => "used inexplicitly in many modules including MT::ConfigMgr",
        perl_core => 5.72,
        url       => "https://metacpan.org/pod/AutoLoader",
    },
    "boolean" => {
        extlib  => 0.46,
        url     => "https://metacpan.org/pod/boolean",
        used_in => ["MT::Theme"],
    },
    "CGI::Fast" => {
        extlib  => 2.17,
        url     => "https://metacpan.org/pod/CGI::Fast",
        used_in => ["MT::Util"],
    },
    "Class::Accessor" => {
        extlib  => 0.51,
        url     => "https://metacpan.org/pod/Class::Accessor",
        used_in => ["Data::ObjectDriver"],
    },
    "Class::Data::Inheritable" => {
        extlib  => 0.09,
        url     => "https://metacpan.org/pod/Class::Data::Inheritable",
        used_in => ["Data::ObjectDriver::Driver::BaseCache"],
    },
    "Class::ErrorHandler" => {
        extlib  => 0.04,
        url     => "https://metacpan.org/pod/Class::ErrorHandler",
        used_in => ["URI::Fetch"],
    },
    "Class::Inspector" => {
        extlib   => 1.36,
        not_used => 1,
        url      => "https://metacpan.org/pod/Class::Inspector",
    },
    "Class::Method::Modifiers" => {
        extlib  => 2.15,
        url     => "https://metacpan.org/pod/Class::Method::Modifiers",
        used_in => ["MT::Image::GD"],
    },
    "Class::Trigger" => {
        extlib  => 0.15,
        url     => "https://metacpan.org/pod/Class::Trigger",
        used_in => ["Data::ObjectDriver::BaseObject"],
    },
    "Clone::PP" => {
        extlib  => 1.08,
        url     => "https://metacpan.org/pod/Clone::PP",
        used_in => ["MT::CMS::Template"],
    },
    "constant::override" => {
        extlib  => 0.01,
        url     => "https://metacpan.org/pod/constant::override",
        used_in => ["MT"],
    },
    "Crypt::URandom" => {
        extlib  => 0.39,
        url     => "https://metacpan.org/pod/Crypt::URandom",
        used_in => ["MT::Util::UniqueID"],
    },
    "Data::ObjectDriver" => {
        extlib  => 0.22,
        url     => "https://metacpan.org/pod/Data::ObjectDriver",
        used_in => ["MT::Object"],
    },
    "Date::Parse" => {
        extlib  => 2.33,
        rev_dep => ["MailTools"],
        url     => "https://metacpan.org/pod/Date::Parse",
        used_in => ["Mail::Field::Date"],
    },
    "Digest::base" => {
        dropped_in => ["centos7"],
        extlib     => "1.20",
        perl_core  => 1.16,
        url        => "https://metacpan.org/pod/Digest::base",
        used_in    => ["Digest::SHA::PurePerl"],
    },
    "Digest::Perl::MD5" => {
        extlib  => 1.9,
        url     => "https://metacpan.org/pod/Digest::Perl::MD5",
        used_in => ["MT::Util::Digest::MD5"],
    },
    "Digest::SHA::PurePerl" => {
        extlib  => 6.04,
        url     => "https://metacpan.org/pod/Digest::SHA::PurePerl",
        used_in => ["MT::Util::Digest::SHA"],
    },
    "Email::Date::Format" => {
        extlib  => 1.005,
        url     => "https://metacpan.org/pod/Email::Date::Format",
        used_in => ["MIME::Lite"],
    },
    "Encode::Locale" => {
        extlib  => 1.05,
        url     => "https://metacpan.org/pod/Encode::Locale",
        used_in => ["LWP::UserAgent"],
    },
    "File::Copy::Recursive" => {
        extlib  => 0.45,
        url     => "https://metacpan.org/pod/File::Copy::Recursive",
        used_in => ["MT::CMS::Theme"],
    },
    "File::Listing" => {
        extlib  => 6.16,
        url     => "https://metacpan.org/pod/File::Listing",
        used_in => ["LWP::Protocol::ftp"],
    },
    "Hash::Merge::Simple" => {
        extlib  => 0.051,
        url     => "https://metacpan.org/pod/Hash::Merge::Simple",
        used_in => ["MT::DataAPI::Callback::ContentField"],
    },
    "Heap::Fibonacci" => {
        extlib  => "0.80",
        url     => "https://metacpan.org/pod/Heap::Fibonacci",
        used_in => ["Cache::Memory"],
    },
    "HTML::Diff" => {
        extlib  => "0.60",
        url     => "https://metacpan.org/pod/HTML::Diff",
        used_in => ["MT::Revisable"],
    },
    "HTML::Template" => {
        extlib   => 2.97,
        not_used => 1,
        url      => "https://metacpan.org/pod/HTML::Template",
    },
    "HTTP::Cookies" => {
        extlib   => 6.11,
        internal => 1,
        url      => "https://metacpan.org/pod/HTTP::Cookies",
    },
    "HTTP::Daemon" => {
        extlib   => 6.16,
        not_used => 1,
        url      => "https://metacpan.org/pod/HTTP::Daemon",
    },
    "HTTP::Date" => {
        extlib  => 6.06,
        url     => "https://metacpan.org/pod/HTTP::Date",
        used_in => ["LWP::UserAgent"],
    },
    "HTTP::Negotiate" => {
        extlib  => 6.01,
        url     => "https://metacpan.org/pod/HTTP::Negotiate",
        used_in => ["LWP::Protocol::ftp"],
    },
    "IO::HTML" => {
        extlib  => 1.004,
        url     => "https://metacpan.org/pod/IO::HTML",
        used_in => ["HTTP::Message"],
    },
    "IO::Socket::IP" => {
        extlib  => 0.41,
        url     => "https://metacpan.org/pod/IO::Socket::IP",
        used_in => ["Net::SMTPS"],
    },
    "IO::String" => {
        extlib  => 1.08,
        url     => "https://metacpan.org/pod/IO::String",
        used_in => ["MT::Import"],
    },
    "IPC::Run3" => {
        extlib  => 0.049,
        url     => "https://metacpan.org/pod/IPC::Run3",
        used_in => ["MT::Util::Archive::BinZip"],
    },
    "Locale::Maketext" => {
        dropped_in => ["amazonlinux2023", "centos7"],
        extlib     => 1.33,
        perl_core  => 1.22,
        url        => "https://metacpan.org/pod/Locale::Maketext",
        used_in    => ["MT::L10N"],
    },
    "Lucene::QueryParser" => {
        extlib  => 1.04,
        url     => "https://metacpan.org/pod/Lucene::QueryParser",
        used_in => ["MT::App::Search"],
    },
    "LWP::MediaTypes" => {
        extlib  => 6.04,
        url     => "https://metacpan.org/pod/LWP::MediaTypes",
        used_in => ["HTTP::Request::Common"],
    },
    "Mail::Address" => {
        extlib  => 2.21,
        url     => "https://metacpan.org/pod/Mail::Address",
        used_in => ["MIME::Lite"],
    },
    "Math::BigInt" => {
        dropped_in => ["amazonlinux2023"],
        extlib     => 2.003002,
        perl_core  => 1.998,
        url        => "https://metacpan.org/pod/Math::BigInt",
        used_in    => ["JSON::PP"],
    },
    "Math::Random::MT::Perl" => {
        extlib  => 1.15,
        url     => "https://metacpan.org/pod/Math::Random::MT::Perl",
        used_in => ["MT::Util::UniqueID"],
    },
    "MIME::Charset" => {
        extlib  => 1.013001,
        url     => "https://metacpan.org/pod/MIME::Charset",
        used_in => ["MIME::EncWords"],
    },
    "MIME::EncWords" => {
        extlib  => 1.014003,
        url     => "https://metacpan.org/pod/MIME::EncWords",
        used_in => ["MT::Mail"],
    },
    "MIME::Types" => {
        extlib  => 2.24,
        url     => "https://metacpan.org/pod/MIME::Types",
        used_in => ["MT::Mail::MIME"],
    },
    "Net::HTTPS" => {
        extlib  => 6.23,
        url     => "https://metacpan.org/pod/Net::HTTPS",
        used_in => ["MT"],
    },
    "Net::OAuth" => {
        extlib   => 0.28,
        not_used => 1,
        url      => "https://metacpan.org/pod/Net::OAuth",
    },
    "Net::SMTPS" => {
        extlib  => "0.10",
        url     => "https://metacpan.org/pod/Net::SMTPS",
        used_in => ["MT::Mail::MIME"],
    },
    "parent" => {
        extlib    => 0.241,
        note      => "used in many extlib modules",
        perl_core => 0.225,
        url       => "https://metacpan.org/pod/parent",
        used_in   => ["MT::PSGI"],
    },
    "Sub::Uplevel" => {
        extlib  => "0.2800",
        url     => "https://metacpan.org/pod/Sub::Uplevel",
        used_in => ["constant::override"],
    },
    "Time::Local" => {
        extlib    => 1.35,
        perl_core => "1.2000",
        url       => "https://metacpan.org/pod/Time::Local",
        used_in   => ["MT::Util"],
    },
    "Try::Tiny" => {
        extlib  => 0.31,
        url     => "https://metacpan.org/pod/Try::Tiny",
        used_in => ["LWP::UserAgent"],
    },
    "UNIVERSAL::require" => {
        extlib   => 0.19,
        not_used => 1,
        url      => "https://metacpan.org/pod/UNIVERSAL::require",
    },
    "URI::Fetch" => {
        extlib   => 0.15,
        not_used => 1,
        url      => "https://metacpan.org/pod/URI::Fetch",
    },
    "UUID::URandom" => {
        extlib  => 0.001,
        url     => "https://metacpan.org/pod/UUID::URandom",
        used_in => ["MT::Util::UniqueID"],
    },
    "version" => {
        dropped_in => ["amazonlinux2023", "centos7"],
        extlib     => "0.9930",
        perl_core  => 0.99,
        url        => "https://metacpan.org/pod/version",
        used_in    => ["MT::version"],
    },
    "WWW::RobotRules" => {
        extlib  => 6.02,
        url     => "https://metacpan.org/pod/WWW::RobotRules",
        used_in => ["LWP::RobotUA"],
    },
    "XML::NamespaceSupport" => {
        extlib  => 1.12,
        url     => "https://metacpan.org/pod/XML::NamespaceSupport",
        used_in => ["XML::SAX::PurePerl"],
    },
    "XML::SAX::Base" => {
        extlib  => 1.09,
        url     => "https://metacpan.org/pod/XML::SAX::Base",
        used_in => ["MT::BackupRestore::BackupFileScanner"],
    },
);

our %HiddenCoreDeps = (
    "Carp"         => { perl_core => 1.26, url => "https://metacpan.org/pod/Carp" },
    "Data::Dumper" => {
        dropped_in => ["centos7"],
        perl_core  => "2.135_06",
        url        => "https://metacpan.org/pod/Data::Dumper",
    },
    "DirHandle" => {
        dropped_in => ["amazonlinux2023"],
        perl_core  => 1.04,
        perl_only  => 1,
        url        => "https://metacpan.org/pod/DirHandle",
    },
    "English" => {
        dropped_in => ["amazonlinux2023"],
        perl_core  => 1.05,
        perl_only  => 1,
        url        => "https://metacpan.org/pod/English",
    },
    "Exporter"           => { perl_core => 5.66, url => "https://metacpan.org/pod/Exporter" },
    "ExtUtils::Manifest" => {
        dropped_in => ["amazonlinux2023", "centos7"],
        perl_core  => 1.61,
        url        => "https://metacpan.org/pod/ExtUtils::Manifest",
    },
    "Fcntl" => {
        perl_core => 1.11,
        perl_only => 1,
        url       => "https://metacpan.org/pod/Fcntl",
    },
    "File::Basename" => {
        perl_core => 2.84,
        perl_only => 1,
        url       => "https://metacpan.org/pod/File::Basename",
    },
    "File::Copy" => {
        dropped_in => ["amazonlinux2023"],
        perl_core  => 2.23,
        perl_only  => 1,
        url        => "https://metacpan.org/pod/File::Copy",
    },
    "File::Find" => {
        dropped_in => ["amazonlinux2023"],
        perl_core  => "1.20",
        perl_only  => 1,
        url        => "https://metacpan.org/pod/File::Find",
    },
    "File::Path" => {
        perl_core => "2.08_01",
        url       => "https://metacpan.org/pod/File::Path",
    },
    "FindBin" => {
        dropped_in => ["amazonlinux2023"],
        perl_core  => 1.51,
        url        => "https://metacpan.org/pod/FindBin",
    },
    "Getopt::Long"         => { perl_core => 2.38, url => "https://metacpan.org/pod/Getopt::Long" },
    "I18N::LangTags::List" => {
        dropped_in => ["amazonlinux2023"],
        perl_core  => "0.35_01",
        perl_only  => 1,
        url        => "https://metacpan.org/pod/I18N::LangTags::List",
    },
    "IO::File"         => { perl_core => 1.16, url => "https://metacpan.org/pod/IO::File" },
    "IO::Select"       => { perl_core => 1.21, url => "https://metacpan.org/pod/IO::Select" },
    "IO::Socket::INET" => {
        perl_core => 1.33,
        url       => "https://metacpan.org/pod/IO::Socket::INET",
    },
    "IPC::Open3" => {
        perl_core => 1.12,
        perl_only => 1,
        url       => "https://metacpan.org/pod/IPC::Open3",
    },
    "POSIX" => {
        perl_core => "1.30",
        perl_only => 1,
        url       => "https://metacpan.org/pod/POSIX",
    },
    "Symbol" => {
        perl_core => 1.07,
        perl_only => 1,
        url       => "https://metacpan.org/pod/Symbol",
    },
    "Sys::Hostname" => {
        dropped_in => ["amazonlinux2023"],
        perl_core  => 1.16,
        perl_only  => 1,
        url        => "https://metacpan.org/pod/Sys::Hostname",
    },
    "Text::Wrap" => {
        perl_core => 2009.0305,
        url       => "https://metacpan.org/pod/Text::Wrap",
    },
);

sub required_modules {
    my $self = shift;
    my %res;
    for my $module (keys %Requirements) {
        my $hash = $Requirements{$module};
        next unless $hash->{required};
        $res{$module} = $hash->{version};
    }
    \%res;
}

sub optional_packages_for_wizard {
    my ($class) = @_;
    my %packages;
    for my $module (keys %Requirements) {
        my $hash = $Requirements{$module};
        next if $hash->{required};
        next if $hash->{tags} && $hash->{tags}[0] eq 'Database';
        $packages{$module}{link}    = $hash->{url};
        $packages{$module}{label}   = $hash->{label};
        $packages{$module}{version} = $hash->{version} if $hash->{version};
    }
    \%packages;
}

sub required_packages_for_wizard {
    my ($class) = @_;
    my %packages;
    for my $module (keys %Requirements) {
        my $hash = $Requirements{$module};
        next unless $hash->{required};
        $packages{$module}{link}    = $hash->{url};
        $packages{$module}{label}   = $hash->{label};
        $packages{$module}{version} = $hash->{version} if $hash->{version};
    }
    \%packages;
}

sub requirements_for_check {
    my ($class, $app) = @_;
    my (@core, @data, @opts);
    for my $module (sort keys %Requirements) {
        my $hash     = $Requirements{$module};
        my $label    = $app ? $app->translate($hash->{label}) : $hash->{label};
        my $version  = $hash->{version}  || 0;
        my $required = $hash->{required} || 0;
        if ($hash->{tags} && $hash->{tags}[0] eq 'Database') {
            push @data, [$module, $version, $required, $label];
        } elsif ($required) {
            push @core, [$module, $version, $required, $label];
        } else {
            push @opts, [$module, $version, $required, $label];
        }
    }
    return (\@core, \@data, \@opts);
}

my %found_imglib;
sub check_imglib {
    my $class = shift;
    return %found_imglib if %found_imglib;
    require Config;
    my %lib = (
        avif => 'libavif',
        gif  => 'libgif',
        jpeg => 'libjpeg',
        png  => 'libpng',
        tiff => 'libtiff',
        webp => 'libwebp',
    );
    my @libpaths = split / /, $Config::Config{libpth};
    my $re = join '|', keys %lib;

FORMAT:
    for my $libpath (@libpaths) {
        opendir my $dh, $libpath or next;
        while(my $file = readdir $dh) {
            next unless $file =~ /^lib($re)\.(?:so|dll|a)(?:(?:\.[0-9]+)*)$/;
            $found_imglib{$1} = delete $lib{$1};
            last FORMAT unless %lib;
            $re = join '|', keys %lib;
        }
    }
    %found_imglib;
}

sub lacks_core_modules {
    my $class = shift;

    for my $module (keys %HiddenCoreDeps) {
        next unless $HiddenCoreDeps{$module}{dropped_in};
        eval "require $module; 1" or return 1;
    }
    return;
}

#----------------------------------------------------------------------------

sub update_me {
    my $class = shift;
    _require_module('Data::Dump')       or return;
    _require_module('Module::CoreList') or return;
    _require_module('Perl::Tidy')       or return;
    _require_module('Parse::PMFile')    or return;
    my $file = __FILE__;
    open my $fh, '<', $file or die $!;
    my $step;
    my ($head, $req, $mid, $extlib, $mid2, $core, $tail) = ('', '', '', '', '', '', '');

    while (<$fh>) {
        if (!$step) {
            $head .= $_;
            if (/^our \%Requirements/) {
                $step = 1;
                $req  = '(';
            }
        } elsif ($step == 1) {
            $req .= $_;
            if (/^\)/) {
                $step = 2;
                $mid .= $_;
            }
        } elsif ($step == 2) {
            $mid .= $_;
            if (/^our \%ExtLibOnly/) {
                $step   = 3;
                $extlib = '(';
            }
        } elsif ($step == 3) {
            $extlib .= $_;
            if (/^\)/) {
                $step = 4;
                $mid2 .= $_;
            }
        } elsif ($step == 4) {
            $mid2 .= $_;
            if (/^our \%HiddenCoreDeps/) {
                $step = 5;
                $core = '(';
            }
        } elsif ($step == 5) {
            $core .= $_;
            if (/^\)/) {
                $step = 6;
                $tail .= $_;
            }
        } elsif ($step == 6) {
            $tail .= $_;
        }
    }
    close $fh;
    my $used = _find_usage();
    $req    = _modify_hash($req);
    $extlib = _modify_hash($extlib, $used);
    $core   = _modify_hash($core);

    my $index       = _make_index();
    my %req_hash    = eval $req;
    my %extlib_hash = eval $extlib;
    my %core_hash   = eval $core;
USED:
    for my $module (sort keys %$used) {
        next if $module =~ /^(MT|Apache)\b/;
        my $dist = $index->{package}{$module} or next;
        next if exists $req_hash{$module};
        next if exists $extlib_hash{$module};
        next if exists $core_hash{$module};
        if ($dist !~ /\bperl\b/) {
            for my $dist_package (keys %{ $index->{dist}{$dist} }) {
                next USED if exists $req_hash{$dist_package};
                next USED if exists $extlib_hash{$dist_package};
                next USED if exists $core_hash{$dist_package};
            }
        }
        # ignore core pragma modules
        next if $module =~ /^[a-z0-9:]+$/ && Module::CoreList::is_core($module, undef, '5.016003');
        my $used_in_mt;
        for my $where (keys %{ $used->{$module} }) {
            next unless $where =~ /^MT\b/;
            next if $used->{$module}{$where} eq 'suggests';
            next if $where =~ /^MT::Plugin::\b/;
            $used_in_mt = 1;
        }
        next unless $used_in_mt;
        if (Module::CoreList::is_core($module, undef, '5.016003')) {
            $core_hash{$module} //= {};
            next;
        }
        print STDERR "$module is missing? " . Data::Dump::dump($used->{$module}), "\n";
    }

    $core = Data::Dump::dump(\%core_hash);
    $core =~ s/\A\{\n//s;
    $core =~ s/\}\z//s;
    $core = _modify_hash($core);

    my $body = "$head$req$mid$extlib$mid2$core$tail";
    Perl::Tidy::perltidy(
        source      => \$body,
        destination => $file,
    );
}

sub _require_module {
    my $module = shift;
    eval "require $module; 1" or do {
        print STDERR "self-updating requires $module\n";
        return;
    };
}

sub _modify_hash {
    my ($str, $used) = @_;
    my %hash  = eval $str or die $@;
    my $index = _make_index();
    for my $module (keys %hash) {
        my $url = "https://metacpan.org/pod/$module";
        $hash{$module}{url} = $CustomURL{$module} || $url;

        my $version = $hash{$module}{version};
        if (Module::CoreList::is_core($module, $version, '5.016003') && Module::CoreList::is_core($module, $version)) {
            $hash{$module}{perl_core} = $Module::CoreList::version{'5.016003'}{$module};
            if ($index->{package}{$module} =~ /\bperl\b/) {
                $hash{$module}{perl_only} = 1;
            }
        } else {
            delete $hash{$module}{perl_core};
            delete $hash{$module}{perl_only};
        }
        (my $file = "./extlib/$module.pm") =~ s!::!/!g;
        if (-e $file) {
            my $info = Parse::PMFile->new->parse($file);
            $hash{$module}{extlib} = $info->{$module}{version};
        } else {
            delete $hash{$module}{extlib};
            if ($used) {
                delete $hash{$module};
                next;
            }
        }
        if ($used && !$hash{$module}{internal}) {
            if (my $dist = $index->{package}{$module}) {
                for my $package (keys %{ $index->{dist}{$dist} || {} }) {
                    if ($used->{$package}) {
                        $used->{$module}{$_} = 1 for keys %{ $used->{$package} };
                    }
                }
                for my $package (keys %{ $index->{dist}{$dist} || {} }) {
                    delete $used->{$module}{$package};
                }
            }
            if ($used->{$module}) {
                delete $hash{$module}{not_used};
                my @new_used_in;
                for my $used_in (@{ $hash{$module}{used_in} || [] }) {
                    if ($used->{$module}{$used_in}) {
                        push @new_used_in, $used_in;
                        next;
                    }
                }
                if (!@new_used_in) {
                    @new_used_in = sort keys %{ $used->{$module} || {} };
                    if (grep /^MT/, @new_used_in) {
                        @new_used_in = grep /^MT/, @new_used_in;
                    }
                }
                if (@new_used_in) {
                    $hash{$module}{used_in} = \@new_used_in;
                } else {
                    $hash{$module}{not_used} = 1;
                    delete $hash{$module}{used_in};
                }
            } else {
                $hash{$module}{not_used} = 1;
                delete $hash{$module}{used_in};
            }
        } else {
            delete $hash{$module}{not_used};
            delete $hash{$module}{used_in};
        }
    }
    my $res = Data::Dump::dump(\%hash);
    $res =~ s/\A\{\n//s;
    $res =~ s/\}\z//s;
    $res;
}

sub _find_usage {
    _require_module('Perl::PrereqScanner::NotQuiteLite') or return;
    _require_module('File::Find')                        or return;
    my %usage;
    my @dirs = ('lib', 'extlib', glob('plugins/*/lib'), glob('plugins/*/extlib'));
    for my $dir (@dirs) {
        File::Find::find({
                wanted => sub {
                    my $file = $File::Find::name;
                    return unless $file  =~ /\.p[ml]$/;
                    (my $module = $file) =~ s!^.*?lib/!!;
                    $module              =~ s!/!::!g;
                    $module              =~ s!\.p[ml]$!!;
                    print STDERR "$file => $module\n";
                    my $scanner = Perl::PrereqScanner::NotQuiteLite->new(
                        parsers    => [qw/:bundled/],
                        suggests   => 1,
                        recommends => 1,
                    );
                    my $ctx = $scanner->scan_file($file);
                    for my $type (qw(requires recommends suggests noes)) {
                        my $prereqs = $ctx->$type or next;
                        my $hash    = $prereqs->as_string_hash;
                        for my $key (keys %$hash) {
                            $usage{$key}{$module} = $type;
                        }
                    }
                },
                no_chdir => 1,
            },
            $dir
        );
    }
    return \%usage;
}

sub _make_index {
    _require_module('CPAN::Common::Index::Mirror') or return;
    my $index = CPAN::Common::Index::Mirror->new;
    open my $fh, '<', $index->cached_package;
    my (%dists, %packages, $seen);
    while (<$fh>) {
        chomp;
        if ($_ eq '') {
            $seen = 1;
            next;
        }
        next unless $seen;
        my ($package, $version, $dist) = split /\s+/;
        $packages{$package} = $dist;
        $dists{$dist}{$package} = 1;
    }
    return +{ dist => \%dists, package => \%packages };
}

1;
