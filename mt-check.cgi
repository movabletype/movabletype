#!/usr/bin/env perl

# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

use strict;
use warnings;
use Encode;

sub BEGIN {
    my $dir;
    if ( eval { require File::Spec; 1; } ) {
        if ( !( $dir = $ENV{MT_HOME} ) ) {
            if ( $0 =~ m!(.*[/\\])! ) {
                $dir = $1;
            }
            else {
                $dir = './';
            }
            $ENV{MT_HOME} = $dir;
        }
        unshift @INC, File::Spec->catdir( $dir, 'lib' );
        unshift @INC, File::Spec->catdir( $dir, 'extlib' );
    }
}

# bugid: 111237
# Net::SSLeay::RAND_poll() takes much time on Windows environment.
# So, make this subroutine does nothing in mt-check.cgi.
if ( $^O eq 'MSWin32' ) {
    eval {
        require Net::SSLeay;
        no warnings;
        *Net::SSLeay::RAND_poll = sub () {1};
    };
}

my $cfg_exist;
my $mt_static_path = q();
my $mt_cgi_path;
my @cfg_candidates = (
    File::Spec->catfile( $ENV{MT_HOME}, 'mt-config.cgi' ),
    File::Spec->catfile( $ENV{MT_HOME}, 'mt.cfg' ),
);
unshift @cfg_candidates, $ENV{MT_CONFIG} if $ENV{MT_CONFIG};

my $cfg_path;
for my $cfg_candidate (@cfg_candidates) {
    if ( -f $cfg_candidate ) {
        $cfg_path = $cfg_candidate;
        last;
    }
}

if ($cfg_path) {
    $cfg_exist = 1;
    my $file_handle = open( my $CFG, "<", $cfg_path );
    my $line;
    while ( $line = <$CFG> ) {
        next if $line !~ /\S/ || $line =~ /^#/;
        if ( $line =~ s/StaticWebPath[\s]*([^\n]*)/$1/ ) {
            $mt_static_path = $line;
            chomp($mt_static_path);
        }
        elsif ( $line =~ s/CGIPath[\s]*([^\n]*)/$1/ ) {
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
my $unsafe = ( $script_name =~ /^mt-check-unsafe.*$/ ) ? 1 : 0;
if ($unsafe) {
    my @stats = stat($0);
    $unsafe = 0 if 60 * 10 < time() - $stats[10];    # ctime
}

local $| = 1;

## Recent CGI (4.0+) uses HTML::Entities
if ( !eval { require HTML::Entities; 1 } ) {
    _use_embedded_html_entities();
}

require CGI;

my $cgi;
my $is_cgi;
$is_cgi ||= exists $ENV{$_}
    for qw( HTTP_HOST GATEWAY_INTERFACE SCRIPT_FILENAME SCRIPT_URL );
if ( $is_cgi || $ENV{PLACK_ENV} ) {
    $cgi = CGI->new;
}
else {
    require FCGI;
    $CGI::Fast::Ext_Request
        = FCGI::Request( \*STDIN, \*STDOUT, \*STDERR, \%ENV, 0,
        FCGI::FAIL_ACCEPT_ON_INTR() );
    require CGI::Fast;
    $cgi = CGI::Fast->new;
}

my $view    = $cgi->param("view");
my $version = $cgi->param("version");
my $sess_id = $cgi->param('session_id');
$version ||= '__PRODUCT_VERSION_ID__';
if ( $version eq '__PRODUCT_VERSION' . '_ID__' ) {
    $version = '8.6.0';
}
my ( $mt, $LH );
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
    if ($mt) {
        $LH = $mt->language_handle;
        $mt->set_language($lang);
    }
    else {
        MT::L10N->get_handle($lang);
    }
};
$lang ||= 'en_US';

sub trans_templ {
    my ($text) = @_;
    return $mt->translate_templatized($text) if $mt;
    $text
        =~ s!(<__trans(?:\s+((?:\w+)\s*=\s*(["'])(?:<[^>]+?>|[^\3]+?)+?\3))+?\s*/?>)!
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
        :       merge_params(@_)
    );
}

sub decode_html {
    my ($html) = @_;
    if ( $cfg_exist && ( eval 'use MT::Util; 1' ) ) {
        return MT::Util::decode_html($html);
    }
    else {
        $html =~ s#&quot;#"#g;
        $html =~ s#&lt;#<#g;
        $html =~ s#&gt;#>#g;
        $html =~ s#&amp;#&#g;
    }
    $html;
}

sub merge_params {
    my ( $msg, @param ) = @_;
    my $cnt = 1;
    foreach my $p (@param) {
        $msg =~ s/\[_$cnt\]/$p/g;
        $cnt++;
    }
    $msg;
}

sub print_encode {
    my ($text) = @_;
    print Encode::encode_utf8($text);
}

sub print_http_header {
    if ( exists( $ENV{PERLXS} ) && ( $ENV{PERLXS} eq 'PerlIS' ) ) {
        print_encode("HTTP/1.0 200 OK\n");
        print_encode("Connection: close\n");
    }
    print_encode("Content-Type: text/html; charset=utf-8\r\n\r\n");
}

sub dedupe_and_sort {
    my @list = @_;
    my %seen;
    grep {!$seen{$_->[0]}++} sort {$a->[0] cmp $b->[0] or $b->[1] <=> $a->[1]} @list;
}

my $invalid = 0;

sub invalid_request {
    $invalid = 1;
    $view    = 0;
}

if ($view) {
    require MT::Author;
    require MT::Session;
    require MT::Serialize;
    my $mt = MT->new;
    $mt->set_language($lang);
PERMCHECK: {
        my $sess = MT->model('session')->load( { id => $sess_id } )
            or invalid_request(), last PERMCHECK;
        my $data_ref = MT::Serialize->unserialize( $sess->data )
            or invalid_request(), last PERMCHECK;
        my $data = $$data_ref
            or invalid_request(), last PERMCHECK;
        my $author = MT->model('author')->load( { id => $data->{author_id} } )
            or invalid_request(), last PERMCHECK;
        $author->can_do('open_system_check_screen')
            or invalid_request(), last PERMCHECK;
    }
}

print_http_header();
if ( !$view ) {
    $lang = $cgi->escapeHTML($lang);
    print_encode( trans_templ(<<HTML) );

<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="content-language" content="$lang" />
    <meta name='robots' content='noindex,nofollow' />
    <title><__trans phrase="Movable Type System Check"> [mt-check.cgi]</title>
    <style type=\"text/css\">
        <!--
            body {
                position: relative;
                min-height: 100%;
                line-height: 1.2;
                margin: 0;
                padding: 0;
                color: #2b2b2b;
                background-color: #fffffc;
                font-size: 13px;
                font-family: Helvetica, "Helvetica Neue", Arial, sans-serif;
            }

            a { 
                color: #507ea4;
                outline: 0;
            }
            a:hover, 
            a:active { 
                color: #839b5c;
                text-decoration: none;
            }
            .toggle-link { 
                display: inline-block;
                margin-left: 5px;
                background: transparent;
                color: #7b7c7d;
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
                background-size: 150px;
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
                padding: 0.5em 0.75em;
                background-repeat: no-repeat;
                background-position: 8px center;
            }
            .msg-warning {
                background-color: #fef263;
            }
            .msg-info {
                background-color: #e6eae3;
            }
            .msg-success {
                margin-top: 50px;
                padding-left: 20px;
                background-color: #cee4ae;
                background-position: 12px 0.75em;
            }
            .msg-success h2 {
                margin-top: 5px;
                font-size: 24px;
            }
            .msg-success p {
                font-size: 13px;
            }
            .msg-text { 
                margin: 0;
            }
            .msg span.exception {
                display: none;
                width: 100%;
                max-width: 100%;
                height: 100px;
                padding: 0.2em 0.25em;
                margin: 10px 0 0;
                border: 1px solid #c0c6c9;
                overflow: auto;
                font-family: monospace;
                font-size: 95%;
                background-color: #f3f3f3;
                color: #7b7c7d;
                box-sizing: border-box;
                -webkit-box-sizing: border-box;
                -moz-box-sizing: border-box;
            }

            .installed {
                color: #9ea1a3;
                padding-top: 0px;
                margin-top: 0px;
            }

            ul.version {
                margin-bottom: 0;
            }
        //-->
    </style>
    <script type="text/javascript">
        function showException(i) {
            var exception = document.getElementById("exception-" + i);
            exception.setAttribute("style", "display: block;");
            var toggler = document.getElementById("exception-toggle-" + i);
            toggler.setAttribute("style", "display: none;");
        }
    </script>
</head>

HTML
    if ($mt_static_path) {
        print_encode("<body class=\"has-static\">\n");
    }
    else {
        print_encode("<body>\n");
    }

    if ($invalid) {
        print_encode( trans_templ(<<HTML) );
<div id="header"><h1 id="brand"><span><__trans phrase="Movable Type System Check"> [mt-check.cgi]</span></h1></div>
<div id="content">
<div class="bg-info msg msg-info">
<p class="msg-text"><__trans phrase="You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator."></p>
</div>
</div>
</body></html>
HTML
        exit;
    }

    if ( $cfg_path && !$unsafe ) {
        print_encode( trans_templ(<<HTML) );
<div id="header"><h1 id="brand"><span><__trans phrase="Movable Type System Check"> [mt-check.cgi]</span></h1></div>
<div id="content">
<div class="bg-info msg msg-info">
<p class="meg-text"><__trans phrase="The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)"></p>
</div>
</div>
</body></html>
HTML
        exit;
    }

    print_encode( trans_templ(<<HTML) );
<div id="header"><h1 id="brand"><span><__trans phrase="Movable Type System Check"> [mt-check.cgi]</span></h1></div>

<div id="content">
<div class="bg-info msg msg-info">
<p class="msg-text"><__trans phrase="The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type."></p>
</div>
HTML
}

my $is_good = 1;
my (@REQ, @DATA, @OPT);

use Cwd;
my $cwd = '';
{
    my ($bad);
    local $SIG{__WARN__} = sub { $bad++ };
    eval { $cwd = Cwd::getcwd() };
    if ( $bad || $@ ) {
        eval { $cwd = Cwd::cwd() };
        my $permitted_error = 'Insecure ' . $ENV{PATH};
        if ( $@ && $@ !~ /$permitted_error/ ) {
            die $@;
        }
    }
}

my $ver = sprintf('%vd', $^V);
my $perl_ver_check = '';
if ( $] < 5.016003 ) {    # our minimal requirement for support
    $perl_ver_check = <<"EOT";
<div class="alert alert-warning msg msg-warning"><p class="msg-text"><__trans phrase="The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2]." params="$ver%%5.16.3"></p></div>
EOT
}

require MT::Util::Dependencies;
my $perl_lacks_core_modules = '';
if (MT::Util::Dependencies->lacks_core_modules) {
    $perl_lacks_core_modules = <<EOT;
<div class="alert alert-warning msg msg-warning"><p class="msg-text"><__trans phrase="Movable Type does not work because your Perl does not have some of the core modules. Please ask your system administrator to install perl (or perl-core) properly."></p></div>
EOT
}

my $server = $ENV{SERVER_SOFTWARE};
my $inc_path = join "<br />\n", @INC;
print_encode( trans_templ(<<INFO) );
<h2 id="system-info"><__trans phrase="System Information"></h2>
$perl_ver_check
$perl_lacks_core_modules
INFO
if ($version) {

    print_encode( trans_templ(<<INFO) );
<ul class="list-unstyled version">
    <li><strong><__trans phrase="Movable Type version:"></strong> <code>$version</code></li>
</ul>
INFO
}
eval {
    require MT::Cloud::App::CMS;
};
if ( $@ ) {
    require MT::Util::SystemCheck;
    my $os = MT::Util::SystemCheck->check_os_version(\my %param);
print_encode( trans_templ(<<INFO) );
<ul id="path-info" class="list-unstyled">
	<li><strong><__trans phrase="Current working directory:"></strong> <code>$cwd</code></li>
	<li><strong><__trans phrase="MT home directory:"></strong> <code>$ENV{MT_HOME}</code></li>
	<li><strong><__trans phrase="Operating system:"></strong> $os</li>
	<li><strong><__trans phrase="Perl version:"></strong> <code>$ver</code></li>
	<li><strong><__trans phrase="Perl include path:"></strong><br /> <code>$inc_path</code></li>
INFO
}
if ($server) {
    print_encode( trans_templ(<<INFO) );
    <li><strong><__trans phrase="Web server:"></strong> <code>$server</code></li>
INFO
}

if ( $server !~ m/psgi/i ) {
## Try to create a new file in the current working directory. This
## isn't a perfect test for running under cgiwrap/suexec, but it
## is a pretty good test.
    my $TMP = "test$$.tmp";
    if ( open( my $FH, ">", $TMP ) ) {
        close $FH;
        unlink($TMP);
        print_encode(
            trans_templ(
                '    <li><__trans phrase="(Probably) running under cgiwrap or suexec"></li>'
                    . "\n"
            )
        );
    }
}

print_encode("\n\n</ul>\n");

exit if $ENV{QUERY_STRING} && $ENV{QUERY_STRING} eq 'sys-check';

if ($mt) {
    my $req = $mt->registry("required_packages");
    foreach my $key ( keys %$req ) {
        next if $key eq 'DBI';
        my $pkg = $req->{$key};
        push @REQ,
            [
            $key, $pkg->{version} || 0, 1, $pkg->{label},
            $key, $pkg->{link}
            ];
    }
    my $drivers = $mt->object_drivers;
    foreach my $key ( keys %$drivers ) {
        my $driver = $drivers->{$key};
        my $label  = $driver->{label};
        my $link   = 'https://metacpan.org/pod/' . $driver->{dbd_package};
        push @DATA,
            [
            $driver->{dbd_package},
            $driver->{dbd_version},
            0,
            $mt->translate(
                "The [_1] database driver is required to use [_2].",
                $driver->{dbd_package}, $label
            ),
            $label, $link
            ];
    }
    unshift @DATA,
        [
        'DBI', 1.21, 0,
        translate('DBI is required to store data in database.')
        ]
        if @DATA;
    my $opt = $mt->registry("optional_packages");
    foreach my $key ( keys %$opt ) {
        my $pkg = $opt->{$key};
        push @OPT,
            [
            $key, $pkg->{version} || 0, 0, $pkg->{label},
            $key, $pkg->{link}
            ];
    }
}

my ($CORE_REQ, $CORE_DATA, $CORE_OPT) = MT::Util::Dependencies->requirements_for_check($mt);

@REQ  = @$CORE_REQ  unless @REQ;
@DATA = @$CORE_DATA unless @DATA;
@OPT  = @$CORE_OPT  unless @OPT;

@REQ  = dedupe_and_sort(@REQ);
@DATA = dedupe_and_sort(@DATA);
@OPT  = dedupe_and_sort(@OPT);

my @new_data;
for (@DATA) {
    if ($_->[0] eq 'DBI') {
        unshift @new_data, $_;
    } else {
        push @new_data, $_;
    }
}
@DATA = @new_data;

my %imglib = MT::Util::Dependencies->check_imglib();
my %extra = (
    'Image::Magick' => sub {
        require Image::Magick;
        my $formats = join ", ", map {$imglib{$_} ? "<strong>$_</strong>" : $_} sort Image::Magick->QueryFormat;
        qq{<__trans phrase="Supported format: [_1]" params="$formats">};
    },
    'Graphics::Magick' => sub {
        require Graphics::Magick;
        my $formats = join ", ", map {$imglib{$_} ? "<strong>$_</strong>" : $_} sort Graphics::Magick->QueryFormat;
        qq{<__trans phrase="Supported format: [_1]" params="$formats">};
    },
    'Imager' => sub {
        require Imager;
        my $formats = join ", ", map {$imglib{$_} ? "<strong>$_</strong>" : $_} sort Imager->read_types;
        qq{<__trans phrase="Supported format: [_1]" params="$formats">};
    },
);

my $i = 0;
for my $list ( \@REQ, \@DATA, \@OPT ) {
    my $data = ( $list == \@DATA );
    my $req  = ( $list == \@REQ );
    my $type;
    my $phrase;

    if ( !$view ) {
        $phrase = translate("Checking for");
    }
    else {
        $phrase = translate("Installed");
    }

    if ($data) {
        $type = translate("Data Storage");
    }
    elsif ($req) {
        $type = translate("Required");
    }
    else {
        $type = translate("Optional");
    }
    print_encode(
        trans_templ(
            qq{<h2><__trans phrase="[_1] [_2] Modules" params="$phrase%%$type"></h2>\n\t<div>\n}
        )
    );
    if ( !$req && !$data ) {
        if ( !$view ) {
            print_encode( trans_templ(<<MSG) );
    <p class="bg-info msg msg-info"><__trans phrase="The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide."></p>

MSG
        }
    }
    if ($data) {
        if ( !$view ) {
            print_encode( trans_templ(<<MSG) );
        <p class="bg-info msg msg-info"><__trans phrase="The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly."></p>

MSG
        }
    }
    my $got_one_data = 0;
    my $dbi_is_okay  = 0;
    for my $ref (@$list) {
        my ( $mod, $ver, $req, $desc ) = @$ref;
        if ( 'CODE' eq ref($desc) ) {
            $desc = $desc->();
        }
        else {
            $desc = translate($desc);
        }
        print_encode("<div class=\"dependence-module\">\n")
            if $mod =~ m/^DBD::/;
        print_encode( "    <h3>$mod"
                . ( $ver ? " (version &gt;= $ver)" : "" )
                . "</h3>" );
        eval( "use $mod" . ( $ver ? " $ver ();" : "();" ) );
        if ($@) {
            my $exception = $@;
            $is_good = 0 if $req;
            my $msg
                = $ver
                ? trans_templ(
                qq{<div class="alert alert-warning msg msg-warning"><p class="msg-text"><__trans phrase="Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed." params="$mod"> }
                )
                : trans_templ(
                qq{<div class="alert alert-warning msg msg-warning"><p class="msg-text"><__trans phrase="Your server does not have [_1] installed, or [_1] requires another module that is not installed." params="$mod"> }
                );
            print_encode($desc);
            print_encode($msg);
            print_encode(
                trans_templ(
                    qq{ <__trans phrase="Please consult the installation instructions for help in installing [_1]." params="$mod">}
                )
            );
            if ($exception) {
                print_encode(
                    qq{ <span class="toggle-link detail-link"><a id="exception-toggle-$i" href="#" onclick="showException($i); return false;">}
                );
                print_encode( translate('Details') );
                print_encode(qq{</a></span>});
            }
            print_encode(qq{</p>});
            print_encode(
                qq{<span id="exception-$i" class="exception">$exception</span>}
            ) if $exception;
            print_encode(qq{</div>});
        }
        else {
            if ($data) {
                $dbi_is_okay = 1 if $mod eq 'DBI';
                if ( $mod eq 'DBD::mysql' ) {
                    if ( $DBD::mysql::VERSION == 3.0000 ) {
                        print_encode(
                            trans_templ(
                                qq{<div class="alert alert-warning msg msg-warning"><p class="msg-text"><__trans phrase="The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available."></p></div>}
                            )
                        );
                    }
                }
                if ( !$dbi_is_okay ) {
                    print_encode(
                        trans_templ(
                            qq{<div class="alert alert-warning msg msg-warning"><p class="msg-text"><__trans phrase="The [_1] is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements." params="$mod"></p></div>}
                        )
                    );
                }
                else {
                    $got_one_data = 1 if $mod ne 'DBI';
                }
            }
            print_encode(
                trans_templ(
                    qq{<p class="installed"><__trans phrase="Your server has [_1] installed (version [_2])." params="$mod%%}
                        . ( $mod->VERSION || translate('unknown') )
                        . qq{"></p>\n\n}
                )
            );
            if ($extra{$mod} && ref $extra{$mod} eq 'CODE') {
                if (my $extra_desc = eval { $extra{$mod}->() }) {
                    print_encode(
                        trans_templ(qq{<p class="extra">$extra_desc</p>\n\n})
                    );
                }
            }
        }
        print_encode("</div>\n") if $mod =~ m/^DBD::/;
        $i++;
    }
    $is_good &= $got_one_data if $data;
    print_encode("\n\t</div>\n\n");
}

if ($is_good && !$perl_ver_check && !$perl_lacks_core_modules) {
    if ( !$view ) {
        print_encode( trans_templ(<<HTML) );
    <div class="bg-success msg msg-success">
        <h2><__trans phrase="Movable Type System Check Successful"></h2>
        <p><strong><__trans phrase="You're ready to go!"></strong> <__trans phrase="Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions."></p>
    </div>

</div>

HTML
    }
}

print_encode("</body>\n\n</html>\n");

if ( ref $cgi eq 'CGI::Fast' ) {
    $CGI::Fast::Ext_Request->LastCall();

    # closing FastCGI's listening socket, so the server won't
    # open new connections to us
    require POSIX;
    POSIX::close(0);
    $CGI::Fast::Ext_Request->Finish();
    exit(1);
}

sub _use_embedded_html_entities {
    $INC{'HTML/Entities.pm'} = 1;

    ## The following code (between HTML_ENTITIES) is excerpted from
    ## HTML::Entities 3.69 (not entirely but only a needed part for
    ## encode_entities is taken without modification)
    ## Copyright 1995-2006 Gisle Aas. All rights reserved.
    eval <<'HTML_ENTITIES';
package HTML::Entities;

use strict;
use vars qw(%entity2char %char2entity);

%entity2char = (
 # Some normal chars that have special meaning in SGML context
 amp    => '&',  # ampersand 
'gt'    => '>',  # greater than
'lt'    => '<',  # less than
 quot   => '"',  # double quote
 apos   => "'",  # single quote

 # PUBLIC ISO 8879-1986//ENTITIES Added Latin 1//EN//HTML
 AElig  => chr(198),  # capital AE diphthong (ligature)
 Aacute => chr(193),  # capital A, acute accent
 Acirc  => chr(194),  # capital A, circumflex accent
 Agrave => chr(192),  # capital A, grave accent
 Aring  => chr(197),  # capital A, ring
 Atilde => chr(195),  # capital A, tilde
 Auml   => chr(196),  # capital A, dieresis or umlaut mark
 Ccedil => chr(199),  # capital C, cedilla
 ETH    => chr(208),  # capital Eth, Icelandic
 Eacute => chr(201),  # capital E, acute accent
 Ecirc  => chr(202),  # capital E, circumflex accent
 Egrave => chr(200),  # capital E, grave accent
 Euml   => chr(203),  # capital E, dieresis or umlaut mark
 Iacute => chr(205),  # capital I, acute accent
 Icirc  => chr(206),  # capital I, circumflex accent
 Igrave => chr(204),  # capital I, grave accent
 Iuml   => chr(207),  # capital I, dieresis or umlaut mark
 Ntilde => chr(209),  # capital N, tilde
 Oacute => chr(211),  # capital O, acute accent
 Ocirc  => chr(212),  # capital O, circumflex accent
 Ograve => chr(210),  # capital O, grave accent
 Oslash => chr(216),  # capital O, slash
 Otilde => chr(213),  # capital O, tilde
 Ouml   => chr(214),  # capital O, dieresis or umlaut mark
 THORN  => chr(222),  # capital THORN, Icelandic
 Uacute => chr(218),  # capital U, acute accent
 Ucirc  => chr(219),  # capital U, circumflex accent
 Ugrave => chr(217),  # capital U, grave accent
 Uuml   => chr(220),  # capital U, dieresis or umlaut mark
 Yacute => chr(221),  # capital Y, acute accent
 aacute => chr(225),  # small a, acute accent
 acirc  => chr(226),  # small a, circumflex accent
 aelig  => chr(230),  # small ae diphthong (ligature)
 agrave => chr(224),  # small a, grave accent
 aring  => chr(229),  # small a, ring
 atilde => chr(227),  # small a, tilde
 auml   => chr(228),  # small a, dieresis or umlaut mark
 ccedil => chr(231),  # small c, cedilla
 eacute => chr(233),  # small e, acute accent
 ecirc  => chr(234),  # small e, circumflex accent
 egrave => chr(232),  # small e, grave accent
 eth    => chr(240),  # small eth, Icelandic
 euml   => chr(235),  # small e, dieresis or umlaut mark
 iacute => chr(237),  # small i, acute accent
 icirc  => chr(238),  # small i, circumflex accent
 igrave => chr(236),  # small i, grave accent
 iuml   => chr(239),  # small i, dieresis or umlaut mark
 ntilde => chr(241),  # small n, tilde
 oacute => chr(243),  # small o, acute accent
 ocirc  => chr(244),  # small o, circumflex accent
 ograve => chr(242),  # small o, grave accent
 oslash => chr(248),  # small o, slash
 otilde => chr(245),  # small o, tilde
 ouml   => chr(246),  # small o, dieresis or umlaut mark
 szlig  => chr(223),  # small sharp s, German (sz ligature)
 thorn  => chr(254),  # small thorn, Icelandic
 uacute => chr(250),  # small u, acute accent
 ucirc  => chr(251),  # small u, circumflex accent
 ugrave => chr(249),  # small u, grave accent
 uuml   => chr(252),  # small u, dieresis or umlaut mark
 yacute => chr(253),  # small y, acute accent
 yuml   => chr(255),  # small y, dieresis or umlaut mark

 # Some extra Latin 1 chars that are listed in the HTML3.2 draft (21-May-96)
 copy   => chr(169),  # copyright sign
 reg    => chr(174),  # registered sign
 nbsp   => chr(160),  # non breaking space

 # Additional ISO-8859/1 entities listed in rfc1866 (section 14)
 iexcl  => chr(161),
 cent   => chr(162),
 pound  => chr(163),
 curren => chr(164),
 yen    => chr(165),
 brvbar => chr(166),
 sect   => chr(167),
 uml    => chr(168),
 ordf   => chr(170),
 laquo  => chr(171),
'not'   => chr(172),    # not is a keyword in perl
 shy    => chr(173),
 macr   => chr(175),
 deg    => chr(176),
 plusmn => chr(177),
 sup1   => chr(185),
 sup2   => chr(178),
 sup3   => chr(179),
 acute  => chr(180),
 micro  => chr(181),
 para   => chr(182),
 middot => chr(183),
 cedil  => chr(184),
 ordm   => chr(186),
 raquo  => chr(187),
 frac14 => chr(188),
 frac12 => chr(189),
 frac34 => chr(190),
 iquest => chr(191),
'times' => chr(215),    # times is a keyword in perl
 divide => chr(247),

 ( $] > 5.007 ? (
  'OElig;'    => chr(338),
  'oelig;'    => chr(339),
  'Scaron;'   => chr(352),
  'scaron;'   => chr(353),
  'Yuml;'     => chr(376),
  'fnof;'     => chr(402),
  'circ;'     => chr(710),
  'tilde;'    => chr(732),
  'Alpha;'    => chr(913),
  'Beta;'     => chr(914),
  'Gamma;'    => chr(915),
  'Delta;'    => chr(916),
  'Epsilon;'  => chr(917),
  'Zeta;'     => chr(918),
  'Eta;'      => chr(919),
  'Theta;'    => chr(920),
  'Iota;'     => chr(921),
  'Kappa;'    => chr(922),
  'Lambda;'   => chr(923),
  'Mu;'       => chr(924),
  'Nu;'       => chr(925),
  'Xi;'       => chr(926),
  'Omicron;'  => chr(927),
  'Pi;'       => chr(928),
  'Rho;'      => chr(929),
  'Sigma;'    => chr(931),
  'Tau;'      => chr(932),
  'Upsilon;'  => chr(933),
  'Phi;'      => chr(934),
  'Chi;'      => chr(935),
  'Psi;'      => chr(936),
  'Omega;'    => chr(937),
  'alpha;'    => chr(945),
  'beta;'     => chr(946),
  'gamma;'    => chr(947),
  'delta;'    => chr(948),
  'epsilon;'  => chr(949),
  'zeta;'     => chr(950),
  'eta;'      => chr(951),
  'theta;'    => chr(952),
  'iota;'     => chr(953),
  'kappa;'    => chr(954),
  'lambda;'   => chr(955),
  'mu;'       => chr(956),
  'nu;'       => chr(957),
  'xi;'       => chr(958),
  'omicron;'  => chr(959),
  'pi;'       => chr(960),
  'rho;'      => chr(961),
  'sigmaf;'   => chr(962),
  'sigma;'    => chr(963),
  'tau;'      => chr(964),
  'upsilon;'  => chr(965),
  'phi;'      => chr(966),
  'chi;'      => chr(967),
  'psi;'      => chr(968),
  'omega;'    => chr(969),
  'thetasym;' => chr(977),
  'upsih;'    => chr(978),
  'piv;'      => chr(982),
  'ensp;'     => chr(8194),
  'emsp;'     => chr(8195),
  'thinsp;'   => chr(8201),
  'zwnj;'     => chr(8204),
  'zwj;'      => chr(8205),
  'lrm;'      => chr(8206),
  'rlm;'      => chr(8207),
  'ndash;'    => chr(8211),
  'mdash;'    => chr(8212),
  'lsquo;'    => chr(8216),
  'rsquo;'    => chr(8217),
  'sbquo;'    => chr(8218),
  'ldquo;'    => chr(8220),
  'rdquo;'    => chr(8221),
  'bdquo;'    => chr(8222),
  'dagger;'   => chr(8224),
  'Dagger;'   => chr(8225),
  'bull;'     => chr(8226),
  'hellip;'   => chr(8230),
  'permil;'   => chr(8240),
  'prime;'    => chr(8242),
  'Prime;'    => chr(8243),
  'lsaquo;'   => chr(8249),
  'rsaquo;'   => chr(8250),
  'oline;'    => chr(8254),
  'frasl;'    => chr(8260),
  'euro;'     => chr(8364),
  'image;'    => chr(8465),
  'weierp;'   => chr(8472),
  'real;'     => chr(8476),
  'trade;'    => chr(8482),
  'alefsym;'  => chr(8501),
  'larr;'     => chr(8592),
  'uarr;'     => chr(8593),
  'rarr;'     => chr(8594),
  'darr;'     => chr(8595),
  'harr;'     => chr(8596),
  'crarr;'    => chr(8629),
  'lArr;'     => chr(8656),
  'uArr;'     => chr(8657),
  'rArr;'     => chr(8658),
  'dArr;'     => chr(8659),
  'hArr;'     => chr(8660),
  'forall;'   => chr(8704),
  'part;'     => chr(8706),
  'exist;'    => chr(8707),
  'empty;'    => chr(8709),
  'nabla;'    => chr(8711),
  'isin;'     => chr(8712),
  'notin;'    => chr(8713),
  'ni;'       => chr(8715),
  'prod;'     => chr(8719),
  'sum;'      => chr(8721),
  'minus;'    => chr(8722),
  'lowast;'   => chr(8727),
  'radic;'    => chr(8730),
  'prop;'     => chr(8733),
  'infin;'    => chr(8734),
  'ang;'      => chr(8736),
  'and;'      => chr(8743),
  'or;'       => chr(8744),
  'cap;'      => chr(8745),
  'cup;'      => chr(8746),
  'int;'      => chr(8747),
  'there4;'   => chr(8756),
  'sim;'      => chr(8764),
  'cong;'     => chr(8773),
  'asymp;'    => chr(8776),
  'ne;'       => chr(8800),
  'equiv;'    => chr(8801),
  'le;'       => chr(8804),
  'ge;'       => chr(8805),
  'sub;'      => chr(8834),
  'sup;'      => chr(8835),
  'nsub;'     => chr(8836),
  'sube;'     => chr(8838),
  'supe;'     => chr(8839),
  'oplus;'    => chr(8853),
  'otimes;'   => chr(8855),
  'perp;'     => chr(8869),
  'sdot;'     => chr(8901),
  'lceil;'    => chr(8968),
  'rceil;'    => chr(8969),
  'lfloor;'   => chr(8970),
  'rfloor;'   => chr(8971),
  'lang;'     => chr(9001),
  'rang;'     => chr(9002),
  'loz;'      => chr(9674),
  'spades;'   => chr(9824),
  'clubs;'    => chr(9827),
  'hearts;'   => chr(9829),
  'diams;'    => chr(9830),
 ) : ())
);


# Make the opposite mapping
while (my($entity, $char) = each(%entity2char)) {
    $entity =~ s/;\z//;
    $char2entity{$char} = "&$entity;";
}
delete $char2entity{"'"};  # only one-way decoding

# Fill in missing entities
for (0 .. 255) {
    next if exists $char2entity{chr($_)};
    $char2entity{chr($_)} = "&#$_;";
}

my %subst;  # compiled encoding regexps

sub encode_entities
{
    return undef unless defined $_[0];
    my $ref;
    if (defined wantarray) {
    my $x = $_[0];
    $ref = \$x;     # copy
    } else {
    $ref = \$_[0];  # modify in-place
    }
    if (defined $_[1] and length $_[1]) {
    unless (exists $subst{$_[1]}) {
        # Because we can't compile regex we fake it with a cached sub
        my $chars = $_[1];
        $chars =~ s,(?<!\\)([]/]),\\$1,g;
        $chars =~ s,(?<!\\)\\\z,\\\\,;
        my $code = "sub {\$_[0] =~ s/([$chars])/\$char2entity{\$1} || num_entity(\$1)/ge; }";
        $subst{$_[1]} = eval $code;
        die( $@ . " while trying to turn range: \"$_[1]\"\n "
          . "into code: $code\n "
        ) if $@;
    }
    &{$subst{$_[1]}}($$ref);
    } else {
    # Encode control chars, high bit chars and '<', '&', '>', ''' and '"'
    $$ref =~ s/([^\n\r\t !\#\$%\(-;=?-~])/$char2entity{$1} || num_entity($1)/ge;
    }
    $$ref;
}

sub num_entity {
    sprintf "&#x%X;", ord($_[0]);
}
HTML_ENTITIES
}
