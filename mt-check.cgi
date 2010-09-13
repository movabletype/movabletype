#!/usr/bin/perl -w

# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

use strict;
use Encode;
sub BEGIN {
    my $dir;
    if (eval { require File::Spec; 1; }) {
        if (!($dir = $ENV{MT_HOME})) {
            if ($0 =~ m!(.*[/\\])!) {
                $dir = $1;
            } else {
                $dir = './';
            }
            $ENV{MT_HOME} = $dir;
        }
        unshift @INC, File::Spec->catdir($dir, 'lib');
        unshift @INC, File::Spec->catdir($dir, 'extlib');
    }
}

my $cfg_exist;
my $mt_static_path = q();
my $mt_cgi_path;
my @cfg_candidates = (
    File::Spec->catfile($ENV{MT_HOME}, 'mt-config.cgi'),
    File::Spec->catfile($ENV{MT_HOME}, 'mt.cfg'),
);
unshift( @cfg_candidates, File::Spec->catfile($ENV{MT_HOME}, $ENV{MT_CONFIG} ) )
    if $ENV{MT_CONFIG};

my $cfg_path;
for my $cfg_candidate ( @cfg_candidates ) {
    if ( -f $cfg_candidate ) {
        $cfg_path = $cfg_candidate;
        last;
    }
}

if ( $cfg_path ) {
    $cfg_exist = 1;
    my $file_handle = open(CFG, $cfg_path );
    my $line;
    while ($line = <CFG>) {
        next if $line !~ /\S/ || $line =~ /^#/;
        if ($line =~ s/StaticWebPath[\s]*([^\n]*)/$1/) {
            $mt_static_path = $line;
            chomp($mt_static_path);
        }
        elsif ($line =~ s/CGIPath[\s]*([^\n]*)/$1/) {
            $mt_cgi_path = $line;
            chomp($mt_cgi_path);
        }
    }
    if ( !$mt_static_path && $mt_cgi_path ) {
        $mt_cgi_path .= '/' if $mt_cgi_path !~ m|/$|;
        $mt_static_path = $mt_cgi_path . 'mt-static/';
    }
}

use File::Basename;
my $script_name = basename($0);
my $unsafe = ( $script_name =~ /^mt-check-unsafe.*$/) ? 1 : 0;
if ( $unsafe ) {
    my @stats = stat($0);
    $unsafe = 0 if 60 * 10 < time() - $stats[10]; # ctime
}

local $| = 1;

use CGI;
my $cgi = new CGI;
my $view = $cgi->param("view");
my $version = $cgi->param("version");
my $sess_id = $cgi->param('session_id');
$version ||= '5.03';

my ($mt, $LH);
my $lang = $cgi->param("language") || $cgi->param("__lang");

eval {
    require MT::App::Wizard;
    $mt = MT::App::Wizard->new();

    require MT::Util;
    $lang ||= MT::Util::browser_language();
    my $cfg = $mt->config;
    $cfg->PublishCharset('utf-8');
    $cfg->DefaultLanguage($lang);
    require MT::L10N;
    if ( $mt ) {
        $LH = $mt->language_handle;
        $mt->set_language($lang);
    }
    else {
        MT::L10N->get_handle($lang);
    }
};
$lang ||= 'en_US';

sub trans_templ {
    my($text) = @_;
    return $mt->translate_templatized($text) if $mt;
    $text =~ s!(<__trans(?:\s+((?:\w+)\s*=\s*(["'])(?:<[^>]+?>|[^\3]+?)+?\3))+?\s*/?>)!
        my($msg, %args) = ($1);
        #print $msg;
        while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<[^>]+?>|[^\2])*?)\2/g) {  #"
            $args{$1} = $3;
        }
        $args{params} = '' unless defined $args{params};
        my @p = map decode_html($_),
                split /\s*%%\s*/, $args{params};
        @p = ('') unless @p;
        my $translation = translate($args{phrase}, @p);
        $translation =~ s/([\\'])/\\$1/sg if $args{escape};
        $translation;
    !ge;
    return $text;
}

sub translate {
    return (
        $mt ? $mt->translate(@_)
            : $LH ? $LH->maketext(@_)
                  : merge_params(@_)
    );
}

sub decode_html {
    my($html) = @_;
    if ($cfg_exist && (eval 'use MT::Util; 1')) {
        return MT::Util::decode_html($html);
    } else {
        $html =~ s#&quot;#"#g;
        $html =~ s#&lt;#<#g;
        $html =~ s#&gt;#>#g;
        $html =~ s#&amp;#&#g;
    }
    $html;
}

sub merge_params {
    my ($msg, @param) = @_;
    my $cnt = 1;
    foreach my $p (@param) {
        $msg =~ s/\[_$cnt\]/$p/g;
        $cnt++;
    }
    $msg;
}

sub print_encode {
    my ( $text ) = @_;
    if ( $mt ) {
        print Encode::encode( $mt->config->PublishCharset, $text );
    }
    else {
        print Encode::encode_utf8( $text );
    }
}

sub print_http_header {
    if ( exists( $ENV{PERLXS} ) && ( $ENV{PERLXS} eq 'PerlIS' ) ) {
        print_encode( "HTTP/1.0 200 OK\n" );
        print_encode( "Connection: close\n" );
    }
    print_encode( "Content-Type: text/html; charset=utf-8\r\n\r\n" );
}

my $invalid = 0;
sub invalid_request {
    $invalid = 1;
    $view = 0;
}

if ( $view ) {
    require MT::Author;
    require MT::Session;
    require MT::Serialize;
    my $mt = MT->new;
 PERMCHECK: {
        my $sess = MT->model('session')->load({ id => $sess_id })
            or invalid_request(), last PERMCHECK;
        my $data_ref = MT::Serialize->unserialize($sess->data)
            or invalid_request(), last PERMCHECK;
        my $data = $$data_ref
            or invalid_request(), last PERMCHECK;
        my $author = MT->model('author')->load({ id => $data->{author_id} })
            or invalid_request(), last PERMCHECK;
        $author->can_do('open_system_check_screen')
            or invalid_request(), last PERMCHECK;
    }
}

print_http_header();
if (!$view) {
    $lang = $cgi->escapeHTML($lang);
    print_encode( trans_templ(<<HTML) );

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="content-language" content="$lang" />
    <title><__trans phrase="Movable Type System Check"> [mt-check.cgi]</title>
    <style type=\"text/css\">
        <!--
            body {
                position: relative;
                min-height: 100%;
                line-height: 1.3;
                margin: 0;
                padding: 0;
                color: #2b2b2b;
                background-color: #f8fbf8;
                font-size: 12px;
                font-family: Helvetica, "Helvetica Neue", Arial, sans-serif;
            }

            #header {
                position: relative;
                height: 45px;
                padding: 1px;
                background-color: #2b2b2b;
            }
            body.has-static #header h1 span {
                display: none;
            }

            body.has-static h1#brand {
                display: block;
                position: absolute;
                top: 5px;
                left: 15px;
                width: 180px;
                height: 35px;
                margin: 0;
                text-decoration: none;
                background: #2b2b2b url($mt_static_path/images/logo/movable-type-brand-logo.png) center 3px no-repeat;
                outline: 0;
            }

            h1 {
                margin: 8px 0 0 10px;
                color: #F8FBF8;

            }

            h2 {
                margin-top: 2em;
                margin-bottom: .5em;
                font-size: 24px;
                font-weight: normal;
            }
            h2#system-info {
                margin-top: 1em;
            }

            h3 {
                font-size: 16px;
                margin-bottom: 0px;
            }

            #content {
                margin: 20px 20px 100px;
            }

            .dependence-module {
                margin-left: 45px;
            }

            .msg {
                position: relative;
                margin: 10px 0;
                padding: 0.8em;
                background-repeat: no-repeat;
                background-position: 8px center;
            }
            .msg-error, 
            .msg-alert, 
            .warning {
                background-color: #fef263;
            }
            .msg-info {
                background-color: #e6eae3;
            }
            .msg-success {
                margin-top: 50px;
                padding-left: 20px;
                background-color: #cee4ae;
                background-position: 12px .75em;
            }
            .msg-success h2 {
                margin-top: 5px;
                font-size: 24px;
            }
            .msg-success p {
                font-size: 13px;
            }

            .installed {
                color: #9EA1A3;
                padding-top: 0px;
                margin-top: 0px;
            }

            ul.version {
                margin-bottom: 0;
            }
        //-->
    </style>

</head>

HTML
    if ($mt_static_path) {
        print_encode( "<body class=\"has-static\">\n" );
    } else {
        print_encode( "<body>\n" );
    }

    if ( $invalid ) {
        print_encode( trans_templ(<<HTML) );
<div id="header"><h1 id="brand"><span><__trans phrase="Movable Type System Check"> [mt-check.cgi]</span></h1></div>
<div id="content">
<p class="msg msg-info"><__trans phrase="You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator."></p>
</div>
</body></html>
HTML
        exit;
    }

    if ( $cfg_path && !$unsafe ) {
        print_encode( trans_templ(<<HTML) );
<div id="header"><h1 id="brand"><span><__trans phrase="Movable Type System Check"> [mt-check.cgi]</span></h1></div>
<div id="content">
<p class="msg msg-info"><__trans phrase="The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)"></p>
</div>
</body></html>
HTML
        exit;
    }

    print_encode( trans_templ(<<HTML) );
<div id="header"><h1 id="brand"><span><__trans phrase="Movable Type System Check"> [mt-check.cgi]</span></h1></div>

<div id="content">
<p class="msg msg-info"><__trans phrase="The mt-check.cgi script provides you with information on your system's configuration and determines whether you have all of the components you need to run Movable Type."></p>
HTML
}

my $is_good = 1;
my (@REQ, @DATA, @OPT);

my @CORE_REQ = (
    [ 'CGI', 0, 1, translate('CGI is required for all Movable Type application functionality.') ],

    [ 'Image::Size', 0, 1, translate('Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).') ],

    [ 'File::Spec', 0.8, 1, translate('File::Spec is required for path manipulation across operating systems.') ],

    [ 'CGI::Cookie', 0, 1, translate('CGI::Cookie is required for cookie authentication.') ],
);

my @CORE_DATA = (
    [ 'DBI', 1.21, 0, translate('DBI is required to store data in database.') ],

    [ 'DBD::mysql', 0, 0, translate('DBI and DBD::mysql are required if you want to use the MySQL database backend.') ],

    [ 'DBD::Pg', 1.32, 0, translate('DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.') ],

    [ 'DBD::SQLite', 0, 0, translate('DBI and DBD::SQLite are required if you want to use the SQLite database backend.') ],

    [ 'DBD::SQLite2', 0, 0, translate('DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.') ],

);

my @CORE_OPT = (
    [ 'HTML::Entities', 0, 0, translate('HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.') ],

    [ 'LWP::UserAgent', 0, 0, translate('LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.') ],

    [ 'HTML::Parser', 0, 0, translate('HTML::Parser is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.') ],

    [ 'SOAP::Lite', 0.50, 0, translate('SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.') ],

    [ 'File::Temp', 0, 0, translate('File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.') ],

    [ 'Scalar::Util', 0, 1, translate('Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.')],

    [ 'List::Util', 0, 1, translate('List::Util is optional; It is needed if you want to use the Publish Queue feature.')],

    [ 'Image::Magick', 0, 0, translate('Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.') ],

    [ 'GD', 0, 0, translate('This module is needed if you would like to be able to create thumbnails of uploaded images.')],

    [ 'IPC::Run', 0, 0, translate('This module is needed if you would like to be able to use NetPBM as the image driver for MT.')],

    [ 'Storable', 0, 0, translate('Storable is optional; it is required by certain MT plugins available from third parties.')],

    [ 'Crypt::DSA', 0, 0, translate('Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.')],

    [ 'Crypt::SSLeay', 0, 0, translate('This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers such as AOL and Yahoo! which require SSL support.')],

    [ 'Cache::File', 0, 0, translate('Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan as OpenID.')],

    [ 'MIME::Base64', 0, 0, translate('MIME::Base64 is required in order to enable comment registration.')],

    [ 'XML::Atom', 0, 0, translate('XML::Atom is required in order to use the Atom API.')],

    [ 'Cache::Memcached', 0, 0, translate('Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.')],

    [ 'Archive::Tar', 0, 0, translate('Archive::Tar is required in order to archive files in backup/restore operation.')],

    [ 'IO::Compress::Gzip', 0, 0, translate('IO::Compress::Gzip is required in order to compress files in backup/restore operation.')],
        
    [ 'IO::Uncompress::Gunzip', 0, 0, translate('IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.')],
    
    [ 'Archive::Zip', 0, 0, translate('Archive::Zip is required in order to archive files in backup/restore operation.')],

    [ 'XML::SAX', 0, 0, translate('XML::SAX and/or its dependencies is required in order to restore.')],

    [ 'Digest::SHA1', 0, 0, translate('Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.')],
    [ 'Mail::Sendmail', 0, 0, translate('Mail::Sendmail is required for sending mail via SMTP Server.')],
    [ 'Safe', 0, 0, translate('This module is used in test attribute of MTIf conditional tag.')],
    [ 'Digest::MD5', 0, 0, translate('This module is used by the Markdown text filter.')],
    [ 'Text::Balanced', 0, 0, translate('This module is required in mt-search.cgi if you are running Movable Type on Perl older than Perl 5.8.') ],
    [ 'XML::Parser', 0, 0, translate('This module required for action streams.')],

);

use Cwd;
my $cwd = '';
{
    my($bad);
    local $SIG{__WARN__} = sub { $bad++ };
    eval { $cwd = Cwd::getcwd() };
    if ($bad || $@) {
        eval { $cwd = Cwd::cwd() };
        if ($@ && $@ !~ /Insecure \$ENV{PATH}/) {
            die $@;
        }
    }
}

my $ver = ref($^V) eq 'version' ? $^V->normal : ( $^V ? join('.', unpack 'C*', $^V) : $] );
my $perl_ver_check = '';
if ($] < 5.008001) {  # our minimal requirement for support
    $perl_ver_check = <<EOT;
<p class="msg warning"><__trans phrase="The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2]." params="$ver%%5.8.1"></p>
EOT
}

my $server = $ENV{SERVER_SOFTWARE};
my $inc_path = join "<br />\n", @INC;
print_encode( trans_templ(<<INFO) );
<h2 id="system-info"><__trans phrase="System Information"></h2>
$perl_ver_check
INFO
if ($version) {
    # sanitize down to letters numbers dashes and period
    $version =~ s/[^a-zA-Z0-9\-\.]//g;
    $version = $cgi->escapeHTML($version);
print_encode( trans_templ(<<INFO) );
<ul class="version">
    <li><strong><__trans phrase="Movable Type version:"></strong> <code>$version</code></li>
</ul>
INFO
}
print_encode( trans_templ(<<INFO) );
<ul>
	<li><strong><__trans phrase="Current working directory:"></strong> <code>$cwd</code></li>
	<li><strong><__trans phrase="MT home directory:"></strong> <code>$ENV{MT_HOME}</code></li>
	<li><strong><__trans phrase="Operating system:"></strong> $^O</li>
	<li><strong><__trans phrase="Perl version:"></strong> <code>$ver</code></li>
	<li><strong><__trans phrase="Perl include path:"></strong><br /> <code>$inc_path</code></li>
INFO
if ($server) {
print_encode( trans_templ(<<INFO) );
    <li><strong><__trans phrase="Web server:"></strong> <code>$server</code></li>
INFO
}

## Try to create a new file in the current working directory. This
## isn't a perfect test for running under cgiwrap/suexec, but it
## is a pretty good test.
my $TMP = "test$$.tmp";
local *FH;
if (open(FH, ">$TMP")) {
    close FH;
    unlink($TMP);
    print_encode( trans_templ('    <li><__trans phrase="(Probably) Running under cgiwrap or suexec"></li>' . "\n") );
}

print_encode( "\n\n</ul>\n" );

exit if $ENV{QUERY_STRING} && $ENV{QUERY_STRING} eq 'sys-check';

if ($mt) {
    my $req = $mt->registry("required_packages");
    foreach my $key (keys %$req) {
        next if $key eq 'DBI';
        my $pkg = $req->{$key};
        push @REQ, [ $key, $pkg->{version} || 0, 1, $pkg->{label}, $key, $pkg->{link} ];
    }
    my $drivers = $mt->object_drivers;
    foreach my $key (keys %$drivers) {
        my $driver = $drivers->{$key};
        my $label = $driver->{label};
        my $link = 'http://search.cpan.org/dist/' . $driver->{dbd_package};
        $link =~ s/::/-/g;
        push @DATA, [ $driver->{dbd_package}, $driver->{dbd_version}, 0,
            $mt->translate("The [_1] database driver is required to use [_2].", $driver->{dbd_package}, $label),
            $label, $link ];
    }
    unshift @DATA, [ 'DBI', 1.21, 0, translate('DBI is required to store data in database.') ]
        if @DATA;
    my $opt = $mt->registry("optional_packages");
    foreach my $key (keys %$opt) {
        my $pkg = $opt->{$key};
        push @OPT, [ $key, $pkg->{version} || 0, 0, $pkg->{label}, $key, $pkg->{link} ];
    }
}
@REQ  = @CORE_REQ  unless @REQ;
@DATA = @CORE_DATA unless @DATA;
@OPT  = @CORE_OPT  unless @OPT;

for my $list (\@REQ, \@DATA, \@OPT) {
    my $data = ($list == \@DATA);
    my $req = ($list == \@REQ);
    my $type;
    my $phrase;

    if (!$view) {
        $phrase = translate("Checking for");
    } else {
        $phrase = translate("Installed");
    }

    if ($data) {
        $type = translate("Data Storage");
    } elsif ($req) {
        $type = translate("Required");
    } else {
        $type = translate("Optional");
    }
    print_encode( trans_templ(qq{<h2><__trans phrase="[_1] [_2] Modules" params="$phrase%%$type"></h2>\n\t<div>\n}) );
    if (!$req && !$data) {
        if (!$view) {
        print_encode( trans_templ(<<MSG) );
    <p class="msg msg-info"><__trans phrase="The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides."></p>

MSG
       }
    }
    if ($data) {
        if (!$view) {
        print_encode( trans_templ(<<MSG) );
        <p class="msg msg-info"><__trans phrase="Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed."></p>

MSG
        }
    }
    my $got_one_data = 0;
    my $dbi_is_okay = 0;
    for my $ref (@$list) {
        my($mod, $ver, $req, $desc) = @$ref;
        if ( 'CODE' eq ref($desc) ) {
            $desc = $desc->();
        }
        else {
            $desc = translate($desc);
        }
        print_encode( "<div class=\"dependence-module\">\n" ) if $mod =~ m/^DBD::/;
        print_encode(  "    <h3>$mod" .
            ($ver ? " (version &gt;= $ver)" : "") . "</h3>" );
        eval("use $mod" . ($ver ? " $ver;" : ";"));
        if ($@) {
            $is_good = 0 if $req;
            my $msg = $ver ?
                      trans_templ(qq{<p class="msg warning"><__trans phrase="Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed." params="$mod"> }) :
                      trans_templ(qq{<p class="msg warning"><__trans phrase="Your server does not have [_1] installed, or [_1] requires another module that is not installed." params="$mod"> });
            print_encode( $desc );
            print_encode(  trans_templ(qq{ <__trans phrase="Please consult the installation instructions for help in installing [_1]." params="$mod"></p>\n\n}) );
            print_encode(  $msg );
            print_encode(  "\n\n" );
        } else {
            if ($data) {
                $dbi_is_okay = 1 if $mod eq 'DBI';
                if ($mod eq 'DBD::mysql') {
                    if ($DBD::mysql::VERSION == 3.0000) {
                        print_encode(  trans_templ(qq{<p class="msg warning"><__trans phrase="The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN."></p>}) );
                    }
                }
                if (!$dbi_is_okay) {
                    print_encode(  trans_templ(qq{<p class="msg warning"><__trans phrase="The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements."></p>}) );
                } else {
                    $got_one_data = 1 if $mod ne 'DBI';
                }
            }
            print_encode(  trans_templ(qq{<p class="installed"><__trans phrase="Your server has [_1] installed (version [_2])." params="$mod%%} . $mod->VERSION . qq{"></p>\n\n}) );
        }
        print_encode(  "</div>\n" ) if $mod =~ m/^DBD::/;
    }
    $is_good &= $got_one_data if $data;
    print_encode( "\n\t</div>\n\n" );
}

if ($is_good) {
    if (!$view) {
    print_encode( trans_templ(<<HTML) );
    <div class="msg msg-success">
        <h2><__trans phrase="Movable Type System Check Successful"></h2>
        <p><strong><__trans phrase="You're ready to go!"></strong> <__trans phrase="Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions."></p>
    </div>

</div>

HTML
    }
}

print_encode( "</body>\n\n</html>\n" );
