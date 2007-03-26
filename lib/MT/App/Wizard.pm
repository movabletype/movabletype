# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.movabletype.org.
#
# $Id$

package MT::App::Wizard;

use strict;
use MT::App;
use MT::ConfigMgr;
@MT::App::Wizard::ISA = qw( MT::App );

my @REQ = (
    [ 'HTML::Template', 2, 1, 'HTML::Template is required for all Movable Type application functionality.', 'HTML Template' ],
    [ 'Image::Size', 0, 1, 'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).', 'Image Size' ],
    [ 'File::Spec', 0.8, 1, 'File::Spec is required for path manipulation across operating systems.', 'File Spec' ],
    [ 'CGI::Cookie', 0, 1, 'CGI::Cookie is required for cookie authentication.', 'CGI Cookie' ],
);

my @DATA = (
    [ 'DB_File', 0, 0, 'DB_File is required if you want to use the Berkeley DB/DB_File backend.', 'BerkeleyDB Database' ],
    [ 'DBD::mysql', 0, 0, 'DBI and DBD::mysql are required if you want to use the MySQL database backend.', 'MySQL Database' ],
    [ 'DBD::Pg', 1.32, 0, 'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.', 'PostgreSQL Database' ],
    [ 'DBD::SQLite', 0, 0, 'DBI and DBD::SQLite are required if you want to use the SQLite database backend.', 'SQLite Database' ],
    [ 'DBD::SQLite2', 0, 0, 'DBI and DBD::SQLite2 are required if you want to use the SQLite2 database backend.', 'SQLite2 Database' ],
);

my @OPT = (
    [ 'HTML::Entities', 0, 0, 'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.', 'HTML Entities' ],
    [ 'LWP::UserAgent', 0, 0, 'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.', 'LWP UserAgent' ],
    [ 'SOAP::Lite', 0.50, 0, 'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.', 'SOAP Lite' ],
    [ 'File::Temp', 0, 0, 'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.', 'File Temp' ],
    [ 'Image::Magick', 0, 0, 'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.', 'ImageMagick' ],
    [ 'Storable', 0, 0, 'Storable is optional; it is required by certain MT plugins available from third parties.', 'Storable'],
    [ 'Crypt::DSA', 0, 0, 'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.', 'Crypt DSA'],
    [ 'MIME::Base64', 0, 0, 'MIME::Base64 is required in order to enable comment registration.', 'MIME Base64'],
    [ 'XML::Atom', 0, 0, 'XML::Atom is required in order to use the Atom API.', 'XML Atom'],
);

my %drivers = (
    'mysql' => 'DBI::mysql',
    'bdb' => 'DBM',
    'postgres' => 'DBI::postgres',
    'sqlite' => 'DBI::sqlite',
    'sqlite2' => 'DBI::sqlite'
);

sub init {
    my $app = shift;
    my %param = @_;
    $app->SUPER::init(@_);
    $app->{mt_dir} ||= $ENV{MT_HOME} || $param{Directory};
    $app->{is_admin} = 1;
    $app->add_methods(
        pre_start => \&pre_start,
        start => \&start,
        configure => \&configure,
        configure_save => \&configure,
        optional => \&optional,
        optional_save => \&optional,
        seed => \&seed,
        complete => \&complete,
        write_config => \&write_config,
    );
    $app->{template_dir} = 'wizard';
    $app->{cfg}->set('StaticWebPath', $app->static_path);
    $app;
}

sub read_config {
    my $app = shift;
    $app->{cfg} = MT::ConfigMgr->instance unless $app->{cfg};
    return 1;
}

# Plugins are effectively disabled during the Wizard since
# they may attempt to access the ObjectDriver, which isn't
# ready yet.
sub init_plugins {
    return 1;
}

sub init_request {
    my $app = shift;
    $app->{default_mode} = 'pre_start';
    # prevents init_request from trying to process the configuration file.
    $app->SUPER::init_request(@_);
    $app->{requires_login} = 0;
}

sub pre_start {
    my $app = shift;
    my %param;

    eval { use File::Spec; };
    my ($cfg, $cfg_exists);
    if (!$@) {
        $cfg = File::Spec->catfile($app->{mt_dir}, 'mt.cfg');
        $cfg_exists = 1 if -f $cfg;

        $cfg = File::Spec->catfile($app->{mt_dir}, 'mt-config.cgi');
        $cfg_exists |= 1 if -f $cfg;
    }

    $param{cfg_exists} = $cfg_exists;
    $param{valid_static_path} = 1 if $app->is_valid_static_path($app->static_path);
    $param{mt_static_exists} = $app->mt_static_exists; 

    return $app->build_page("start.tmpl", \%param);
}

sub config_keys {
    return {
        configure => [
            'dbname', 'dbpath', 'dbport', 'dbserver', 'dbsocket',
            'dbtype', 'dbuser', 'dbpass' ],
        optional => [
            'mail_transfer', 'sendmail_path', 'smtp_server',
            'test_mail_address' ],
        start => [ 'set_static_uri_to' ]
    };
}

sub start {
    my $app = shift;
    my $q = $app->param;

    # test for static_path
    my $static_path = $q->param('set_static_uri_to');
    unless ($q->param('set_static_uri_to')) {
        my %param = ('uri_invalid' => 1 );
        return $app->build_page("start.tmpl", \%param);
    }

    $static_path = $app->cgipath.$static_path unless $static_path =~ m#^(https?:/)?/#;
    $static_path =~ s#(^\s+|\s+$)##;
    $static_path .= '/' unless $static_path =~ m!/$!;

    unless ($app->is_valid_static_path($static_path)) {
        my %param = ('uri_invalid' => 1, set_static_uri_to => $q->param('set_static_uri_to') );
        return $app->build_page("start.tmpl", \%param);
    }

    $app->{cfg}->set('StaticWebPath', $static_path);

    # test for required packages...
    my ($needed) = $app->module_check(\@REQ);
    if (@$needed) {
        my %param = ( 'package_loop' => $needed );
        $param{required} = 1;
        return $app->build_page("packages.tmpl", \%param);
    }

    my ($db_missing) = $app->module_check(\@DATA);
    if ((scalar @$db_missing) == (scalar @DATA)) {
        my %param = ( 'package_loop' => $db_missing );
        $param{missing_db_or_optional} = 1;
        $param{missing_db} = 1;
        return $app->build_page("packages.tmpl", \%param);
    }

    my ($opt_missing) = $app->module_check(\@OPT);
    push @$opt_missing, @$db_missing;
    if (@$opt_missing) {
        my %param = ( 'package_loop' => $opt_missing );
        $param{missing_db_or_optional} = 1;
        $param{optional} = 1;
        return $app->build_page("packages.tmpl", \%param);
    }

    my %param = ( 'success' => 1 );
    return $app->build_page("packages.tmpl", \%param);
}

sub configure {
    my $app = shift;
    my %param = @_;

    my $q = $app->param;
    my $mode = $q->param('__mode');

    # input data unserialize to config
    %param = $app->unserialize_config;

    # get post data
    my $keys = $app->config_keys;
    my $cfg_mode = $mode;
    $cfg_mode =~ s/_save//;
    if (!$q->param('back')) {
        foreach (@{ $keys->{$cfg_mode} }) {
            $param{$_} = $q->param($_);
        }
    }
    
    $param{set_static_uri_to} = $q->param('set_static_uri_to');
    # set static web path
    $app->{cfg}->set('StaticWebPath', $param{set_static_uri_to});
    if (my $dbtype = $param{dbtype}) {
        $param{"dbtype_$dbtype"} = 1;
        if ($dbtype eq 'bdb') {
            $param{path_required} = 1;
        } elsif ($dbtype eq 'sqlite') {
            $param{path_required} = 1;
        } elsif ($dbtype eq 'sqlite2') {
            $param{path_required} = 1;
        } elsif ($dbtype eq 'mysql') {
            $param{login_required} = 1;
        } elsif ($dbtype eq 'postgres') {
            $param{login_required} = 1;
        }
    }

    my ($missing, $dbmod) = $app->module_check(\@DATA);
    if (scalar(@$dbmod) == 0) {
        $param{missing_db_or_optional} = 1;
        $param{missing_db} = 1;
        $param{package_loop} = $missing;
        return $app->build_page("packages.tmpl", \%param);
    }
    foreach (@$dbmod) {
        if ($_->{module} eq 'DBD::mysql') {
            $_->{id} = 'mysql';
        } elsif ($_->{module} eq 'DBD::Pg') {
            $_->{id} = 'postgres';
        } elsif ($_->{module} eq 'DBD::SQLite') {
            $_->{id} = 'sqlite';
        } elsif ($_->{module} eq 'DBD::SQLite2') {
            $_->{id} = 'sqlite2';
        } elsif ($_->{module} eq 'DB_File') {
            $_->{id} = 'bdb';
        }
        if ($param{dbtype} && ($param{dbtype} eq $_->{id})) {
            $_->{selected} = 1;
        }
    }
    $param{db_loop} = $dbmod;
    $param{config} = $app->serialize_config(%param);

    my $ok = 1;
    my $err_msg;
    if ($q->param('test')) {
        # if check successfully and push continue then goto next step
        $ok = 0;
        my $dbtype = $param{dbtype};
        my $driver = $drivers{$dbtype} if exists $drivers{$dbtype};
        if ($driver) {
            my $cfg = $app->{cfg};
            $cfg->ObjectDriver($driver);
            if ($driver ne 'DBM') {
                $cfg->Database($param{dbname}) if $param{dbname};
                $cfg->DBUser($param{dbuser}) if $param{dbuser};
                $cfg->DBPassword(defined $param{dbpass} ? $param{dbpass} : '');
                $cfg->DBPort($param{dbport}) if $param{dbport};
                $cfg->DBSocket($param{dbsocket}) if $param{dbsocket};
                $cfg->DBHost($param{dbserver}) if $param{dbserver};
            }
            if ($dbtype eq 'sqlite' || $dbtype eq 'sqlite2') {
                require File::Spec;
                my $db_file = $param{dbpath};
                if (!File::Spec->file_name_is_absolute($db_file)) {
                    $db_file = File::Spec->catfile($app->{mt_dir}, $db_file);
                }
                $cfg->Database($db_file) if  $db_file;
                $param{dbpath} = $db_file if  $db_file;
            } else {
                $cfg->DataSource($param{dbpath}) if $param{dbpath};
            }
            if ($dbtype eq 'sqlite2') {
                $cfg->UseSQLite2(1);
            }
            # test loading of object driver with these parameters...
            require MT::ObjectDriver;
            my $od = MT::ObjectDriver->new($driver);
            if (!$od) {
                $err_msg = MT::ObjectDriver->errstr;
            } else {
                $ok = 1;
            }
        }
        if ($ok) {
            $param{success} = 1;
            return $app->build_page("configure.tmpl", \%param);
        }
        $param{connect_error} = 1;
        $param{error} = $err_msg;
    } elsif ($mode eq 'configure_save') {
        return $app->optional(%param);
    }

    $app->build_page("configure.tmpl", \%param);
}

my @Sendmail = qw( /usr/lib/sendmail /usr/sbin/sendmail /usr/ucblib/sendmail );

sub optional {
    my $app = shift;
    my %param = @_;

    my $q = $app->param;
    my $mode = $q->param('__mode');

    # input data unserialize to config
    %param = $app->unserialize_config;
    # get post data
    my $opt_mode = $mode;
    $opt_mode =~ s/_save//;
    my $keys = $app->config_keys;
    if (!$q->param('back')) {
        foreach (@{ $keys->{$opt_mode} }) {
            $param{$_} = $q->param($_);
        }
    }
    $param{set_static_uri_to} = $q->param('set_static_uri_to');

    # set static web path
    $app->{cfg}->set('StaticWebPath', $param{set_static_uri_to});

    # discover sendmail
    use MT::ConfigMgr;
    my $mgr = MT::ConfigMgr->instance;
    my $sm_loc;
    for my $loc ($param{sendmail_path}, @Sendmail) {
        next unless $loc;
        $sm_loc = $loc, last if -x $loc && !-d $loc;
    }
    $param{sendmail_path} = $sm_loc || '';

    my $transfer;
    push @$transfer, {id => 'smtp', name => $app->translate('SMTP Server')};
    push @$transfer, {id => 'sendmail', name => $app->translate('Sendmail')};

    foreach(@$transfer){
        if ($_->{id} eq $param{mail_transfer}) {
            $_->{selected} = 1;
        }
    }

    $param{'use_'.$param{mail_transfer}} = 1;
    $param{mail_loop} = $transfer;
    $param{config} = $app->serialize_config(%param);

    my $ok = 1;
    my $err_msg;
    if ($q->param('test')) {
        $ok = 0;
        if ($param{test_mail_address}){
            my $cfg = $app->{cfg};
            $cfg->MailTransfer($param{mail_transfer}) if $param{mail_transfer};
            $cfg->SMTPServer($param{smtp_server}) if $param{smtp_server};
            $cfg->SendMailPath($param{sendmail_path}) if $param{sendmail_path};
            my %head = (To => $param{test_mail_address},
                        From => $cfg->EmailAddressMain || $param{test_mail_address},
                        Subject => $app->translate("Test email from Movable Type Configuration Wizard") );
            my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
            $head{'Content-Type'} = qq(text/plain; charset="$charset");

            my $body = $app->translate("This is the test email sent by your new installation of Movable Type.");

            require MT::Mail;
            $ok = MT::Mail->send(\%head, $body);

            if ($ok){
                $param{success} = 1;
                return $app->build_page("optional.tmpl", \%param);
            }else{
                $err_msg = MT::Mail->errstr;
            }
        }
        
        $param{send_error} = 1;
        $param{error} = $err_msg;
    }
    # if check successfully and push continue then goto next step
    if ($mode eq 'optional_save') {
        return $app->seed(%param);
    }

    $app->build_page("optional.tmpl", \%param);
}

sub seed {
    my $app = shift;
    my %param = @_;

    # input data unserialize to config
    unless (keys(%param)) {
        %param = $app->unserialize_config;
        $param{config} = $app->param('config');
    }else{
        $param{config} = $app->serialize_config(%param);
    }

    $param{static_web_path} = $app->param->param('set_static_uri_to');
    $param{static_uri} = $app->param->param('set_static_uri_to');
    $param{cgi_path} = $app->cgipath;

    my $uri = $ENV{REQUEST_URI} || $ENV{SCRIPT_NAME};
    if ($ENV{MOD_PERL} || (($uri =~ m/\/mt-wizard\.(\w+)(\?.*)?$/) && ($1 ne 'cgi'))) {
        my $new = '';
        if ($ENV{MOD_PERL}) {
            $param{mod_perl} = 1;
        } else {
            $new = '.' . $1;
        }
        my @scripts;
        my $cfg = $app->config;
        my @cfg_keys = grep { /Script$/ } keys %{ $cfg->{__settings} };
        $param{mt_script} = $app->config->AdminScript;
        foreach my $key (@cfg_keys) {
            my $path = $cfg->get($key);
            $path =~ s/\.cgi$/$new/;
            if (-e File::Spec->catfile($app->{mt_dir}, $path)) {
                $param{mt_script} = $path if $key eq 'AdminScript';
                push @scripts, { name => $key, path => $path };
            }
        }
        if (@scripts) {
            $param{script_loop} = \@scripts if @scripts;
            $param{non_cgi_suffix} = 1;
        }
    } else {
        $param{mt_script} = $app->config->AdminScript;
    }

    # unserialize database configuration
    if (my $dbtype = $param{dbtype}) {
        if ($dbtype eq 'bdb') {
            $param{use_bdb} = 1;
            $param{database_name} = $param{dbpath};
        } elsif ($dbtype eq 'sqlite') {
            $param{use_sqlite} = 1;
            $param{object_driver} = 'DBI::sqlite';
            $param{database_name} = $param{dbpath};
        } elsif ($dbtype eq 'sqlite2') {
            $param{use_sqlite} = 1;
            $param{use_sqlite2} = 1;
            $param{object_driver} = 'DBI::sqlite';
            $param{database_name} = $param{dbpath};
        } elsif ($dbtype eq 'mysql') {
            $param{use_dbms} = 1;
            $param{object_driver} = 'DBI::mysql';
            $param{database_name} = $param{dbname};
            $param{database_username} = $param{dbuser};
            $param{database_password} = $param{dbpass} if $param{dbpass};
            $param{database_host} = $param{dbserver} if $param{dbserver};
            $param{database_port} = $param{dbport} if $param{dbport};
            $param{database_socket} = $param{dbsocket} if $param{dbsocket};
            $param{use_setnames} =  $param{setnames} if $param{setnames};
        } elsif ($dbtype eq 'postgres') {
            $param{use_dbms} = 1;
            $param{object_driver} = 'DBI::postgres';
            $param{database_name} = $param{dbname};
            $param{database_username} = $param{dbuser};
            $param{database_password} = $param{dbpass} if $param{dbpass};
            $param{database_host} = $param{dbserver} if $param{dbserver};
            $param{database_port} = $param{dbport} if $param{dbport};
            $param{use_setnames} =  $param{setnames} if $param{setnames};
        }
    }

    my $data = $app->build_page("mt-config.tmpl", \%param);

    my $cfg_file = File::Spec->catfile($app->{mt_dir}, 'mt-config.cgi');
    if (!-f $cfg_file) {
        # write!
        if (open OUT, ">$cfg_file") {
            print OUT $data;
            close OUT;
        }
        $param{config_created} = 1 if -f $cfg_file;
        $param{config_file} = $cfg_file;
    }

    # back to the complete screen
    return $app->build_page("complete.tmpl", \%param);
}

sub serialize_config {
    my $app = shift;
    my %param = @_;
 
    require MT::Serialize;
    my $ser = MT::Serialize->new('MT');
    my $keys = $app->config_keys();
    my %set;
    foreach my $key (keys %$keys) {
        foreach my $p (@{$keys->{$key}}) {
            $set{$p} = $param{$p};
        }
    }
    my $set = \%set;
    unpack 'H*', $ser->serialize(\$set);
}

sub unserialize_config {
    my $app = shift;
    my $data = $app->param('config');
    my %config;
    if ($data) {
        $data = pack 'H*', $data;
        require MT::Serialize;
        my $ser = MT::Serialize->new('MT');
        my $thawed = $ser->unserialize($data);
        if ($thawed) {
            my $saved_cfg = $$thawed;
            if (keys %$saved_cfg) {
                foreach my $p (keys %$saved_cfg) {
                    $config{$p} = $saved_cfg->{$p};
                }
            }
        }
    }
    %config;
}

sub cgipath {
    my $app = shift;

    # these work for Apache... need to test for IIS...
    my $host = $ENV{SERVER_NAME} || $ENV{HTTP_HOST};
    $host =~ s/:\d+//; # eliminate any port that may be present
    my $port = $ENV{SERVER_PORT};
    # REQUEST_URI for CGI-compliant servers; SCRIPT_NAME for IIS.
    my $uri = $ENV{REQUEST_URI} || $ENV{SCRIPT_NAME};
    $uri =~ s!/mt-wizard(\.f?cgi|\.f?pl)(\?.*)?$!/!;

    my $cgipath = '';
    $cgipath = $port == 443 ? 'https' : 'http';
    $cgipath .= '://' . $host;
    $cgipath .= ($port == 443 || $port == 80) ? '' : ':' . $port;
    $cgipath .= $uri;

    $cgipath;
}

sub module_check {
    my $self = shift;
    my $modules = shift;
    my (@missing, @ok);
    foreach my $ref (@$modules) {
        my($mod, $ver, $req, $desc, $name) = @$ref;
        eval("use $mod" . ($ver ? " $ver;" : ";"));
        if ($@) {
            push @missing, { module => $mod,
                             version => $ver,
                             required => $req,
                             description => $self->translate($desc),
                             name => $name };
        } else {
            push @ok, { module => $mod,
                        version => $ver,
                        required => $req,
                        description => $self->translate($desc),
                        name => $name };
        }
    }
    (\@missing, \@ok);
}

sub static_path {
    my $app = shift;
    my $static_path = '';

    if ($app->{cfg}->StaticWebPath ne '') {
        $static_path = $app->{cfg}->StaticWebPath;
        $static_path .= '/' unless $static_path =~ m!/$!;
        return $static_path;
    }
    return $app->mt_static_exists ? $app->cgipath.'mt-static/' : '';
}

sub mt_static_exists {
    my $app = shift;
    return (-f File::Spec->catfile($app->{mt_dir}, "mt-static", "styles.css")) ? 1 : 0;
}

sub is_valid_static_path {
    my $app = shift;
    my ($static_uri) = @_;

    my $path;
    if ($static_uri =~ m/^http/i) {
        $path = $static_uri.'styles.css';
    } elsif($static_uri =~ m#^/#) {
        my $host = $ENV{HTTP_HOST};
        my $port = $ENV{SERVER_PORT};
        $path = $port == 443 ? 'https' : 'http';
        $path .= '://' . $host;
        $path .= ($port == 443 || $port == 80) ? '' : ':' . $port;
        $path .= $static_uri.'styles.css';
    }else{
        $path = $app->cgipath.$static_uri.'styles.css';
    }

    require LWP::UserAgent;
    my $ua = LWP::UserAgent->new;
    my $request = HTTP::Request->new(HEAD => $path);
    my $response = $ua->request($request);
    $response->is_success;
}
1;
