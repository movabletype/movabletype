package MT::CMS::Tools;

use strict;
use Symbol;

use MT::I18N qw( encode_text wrap_text );
use MT::Util qw( encode_url encode_html decode_html encode_js );

sub system_check {
    my $app = shift;

    if ( my $blog_id = $app->param('blog_id') ) {
        return $app->redirect(
            $app->uri(
                'mode' => 'view_log',
                args => { blog_id => $blog_id }
            )
        );
    }

    my %param;
    # licensed user count: someone who has logged in within 90 days  
    my $sess_class = $app->model('session');  
    my $from = time - ( 60 * 60 * 24 * 90 + 60 * 60 * 24 );  
    $sess_class->remove(
        { kind => 'UA', start => [ undef, $from ] },  
        { range => { start => 1 } }
    );  
    $param{licensed_user_count} = $sess_class->count( { kind => 'UA' } );

    my $author_class = $app->model('author');
    $param{user_count} = $author_class->count(
        { type => MT::Author::AUTHOR() } );

    # commeters: users with only comment permission and MT::Author::COMMENTER
    my $cmntrs = $author_class->count(
        { type => MT::Author::COMMENTER() } );

    my @perms = $app->model('permission')->load(
      {
        permissions => "%'comment'%", 
        blog_id     => '0',
      },
      {
        'like' => { 'permissions' => 1 },
        'not'  => { 'blog_id'     => 1 },
      }
    );
    @perms = grep { $_->permissions =~ m/'comment'/ } @perms;
    $param{commenter_count} = scalar(@perms) + $cmntrs;
    $param{screen_id} = "system-check";
    $param{syscheck_html} = get_syscheck_content($app) || '';
    
    $app->load_tmpl( 'system_check.tmpl', \%param );
}

sub get_syscheck_content {
    my $app = shift;

    my $syscheck_url = $app->base . $app->mt_path . $app->config('CheckScript') .
        '?view=tools&version=' . MT->version_id;
    if ( $syscheck_url && $syscheck_url ne 'disable' ) {
        my $SYSCHECKCACHE_TIMEOUT = 60 * 60 * 24;
        my $sess_class        = $app->model('session');
        my ($syscheck_object)     = ("");
        my $retries           = 0;
        $syscheck_object = $sess_class->load( { id => 'SC' } );
        if ( $syscheck_object
            && ( $syscheck_object->start() < ( time - $SYSCHECKCACHE_TIMEOUT ) ) )
        {
            $syscheck_object->remove;
            $syscheck_object = undef;
        }
        return encode_text( $syscheck_object->data(), 'utf-8', undef )
          if ($syscheck_object);

        my $ua = $app->new_ua({ timeout => 20 });
        return unless $ua;
        $ua->max_size(undef) if $ua->can('max_size');

        my $req = new HTTP::Request( GET => $syscheck_url );
        my $resp = $ua->request($req);
        return unless $resp->is_success();
        my $result = $resp->content();
        if ($result) {
            require MT::Sanitize;

            # allowed html
            my $spec = '* style class id,ul,li,div,span,br,h2,h3,strong,code,blockquote,p';
            $result = MT::Sanitize->sanitize( $result, $spec );
            $syscheck_object = MT::Session->new();
            $syscheck_object->set_values(
                {
                    id    => 'SC',
                    kind  => 'SC',
                    start => time(),
                    data  => $result
                }
            );
            $syscheck_object->save();
            $result = encode_text( $result, 'utf-8', undef );
        }
        return $result;
    }
}

sub start_recover {
    my $app = shift;
    $app->add_breadcrumb( $app->translate('Password Recovery') );
    $app->load_tmpl('dialog/recover.tmpl');
}

sub recover_password {
    my $app   = shift;
    my $q     = $app->param;
    my $name  = $q->param('name');
    my $class = ref $app eq 'MT::App::Upgrader' ? 'MT::BasicAuthor' : $app->model('author');
    eval "use $class;";
    my @author = $class->load( { name => $name } );
    my $author;
    foreach (@author) {
        next unless $_->password && ( $_->password ne '(none)' );
        $author = $_;
    }

    my ( $rc, $res ) =
      reset_password( $app, $author, $q->param('hint'), $name );

    if ($rc) {
        $app->add_breadcrumb( $app->translate('Password Recovery') );
        $app->load_tmpl(
            'dialog/recover.tmpl',
            {
                recovered => 1,
                email     => $author->email
            }
        );
    }
    else {
        $app->error($res);
    }
}

sub do_list_action {
    my $app = shift;
    $app->validate_magic or return;

    # plugin_action_selector should always (?) be in the query; use it?
    my $action_name = $app->param('action_name');
    my $type        = $app->param('_type');
    my ($the_action) =
      ( grep { $_->{key} eq $action_name } @{ $app->list_actions($type) } );
    return $app->errtrans( "That action ([_1]) is apparently not implemented!",
        $action_name )
      unless $the_action;

    unless ( ref( $the_action->{code} ) ) {
        if ( my $plugin = $the_action->{plugin} ) {
            $the_action->{code} =
              $app->handler_to_coderef( $the_action->{handler}
                  || $the_action->{code} );
        }
    }
    $the_action->{code}->($app);
}

sub do_page_action {
    my $app = shift;

    # plugin_action_selector should always (?) be in the query; use it?
    my $action_name = $app->param('action_name');
    my $type        = $app->param('_type');
    my ($the_action) =
      ( grep { $_->{key} eq $action_name } @{ $app->page_actions($type) } );
    return $app->errtrans( "That action ([_1]) is apparently not implemented!",
        $action_name )
      unless $the_action;

    unless ( ref( $the_action->{code} ) ) {
        if ( my $plugin = $the_action->{plugin} ) {
            $the_action->{code} =
              $app->handler_to_coderef( $the_action->{handler}
                  || $the_action->{code} );
        }
    }
    $the_action->{code}->($app);
}

sub cfg_system_general {
    my $app = shift;
    my %param;
    if ( $app->param('blog_id') ) {
        return $app->return_to_dashboard( redirect => 1 );
    }

    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();
    my $cfg = $app->config;
    $app->add_breadcrumb( $app->translate('General Settings') );
    $param{nav_config}   = 1;
    $param{nav_settings} = 1;
    $param{languages} =
      $app->languages_list( $app->config('DefaultUserLanguage') );
    my $tag_delim = $app->config('DefaultUserTagDelimiter') || 'comma';
    $param{"tag_delim_$tag_delim"} = 1;

    ( my $tz = $app->config('DefaultTimezone') ) =~ s![-\.]!_!g;
    $tz =~ s!_00$!!;
    $param{ 'server_offset_' . $tz } = 1;

    $param{default_site_root} = $app->config('DefaultSiteRoot');
    $param{default_site_url}  = $app->config('DefaultSiteURL');
    $param{personal_weblog_readonly} =
      $app->config->is_readonly('NewUserAutoProvisioning');
    $param{personal_weblog} = $app->config->NewUserAutoProvisioning ? 1 : 0;
    if ( my $id = $param{new_user_template_blog_id} =
        $app->config('NewUserTemplateBlogId') || '' )
    {
        my $blog = MT::Blog->load($id);
        if ($blog) {
            $param{new_user_template_blog_name} = $blog->name;
        }
        else {
            $app->config( 'NewUserTemplateBlogId', undef, 1 );
            $cfg->save_config();
            delete $param{new_user_template_blog_id};
        }
    }
    $param{system_email_address} = $cfg->EmailAddressMain;
    $param{saved}                = $app->param('saved');
    $param{error}                = $app->param('error');
    $param{screen_class}         = "settings-screen system-general-settings";
    $app->load_tmpl( 'cfg_system_general.tmpl', \%param );
}

sub save_cfg_system_general {
    my $app = shift;
    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $cfg = $app->config;
    $app->config( 'EmailAddressMain',
        $app->param('system_email_address') || undef, 1 );

    $cfg->save_config();

    my $args = ();
    $args->{saved} = 1;
    $app->redirect(
        $app->uri(
            'mode' => 'cfg_system',
            args   => $args
        )
    );
}

sub upgrade {
    my $app = shift;

    # check for an empty database... no author table would do it...
    my $driver         = MT::Object->driver;
    my $upgrade_script = $app->config('UpgradeScript');
    my $user_class     = MT->model('author');
    if ( !$driver || !$driver->table_exists($user_class) ) {
        return $app->redirect( $app->path
              . $upgrade_script
              . $app->uri_params( mode => 'install' ) );
    }

    return $app->redirect( $app->path . $upgrade_script );
}

sub recover_profile_password {
    my $app = shift;
    $app->validate_magic or return;
    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $q = $app->param;

    require MT::Auth;
    require MT::Log;
    if ( !MT::Auth->can_recover_password ) {
        $app->log(
            {
                message => $app->translate(
"Invalid password recovery attempt; can't recover password in this configuration"
                ),
                level    => MT::Log::SECURITY(),
                class    => 'system',
                category => 'recover_profile_password',
            }
        );
        return $app->error("Can't recover password in this configuration");
    }

    my $author_id = $q->param('author_id');
    my $author    = MT::Author->load($author_id);

    return $app->error( $app->translate("Invalid author_id") )
      if !$author || $author->type != MT::Author::AUTHOR() || !$author_id;

    my ( $rc, $res ) =
      reset_password( $app, $author, $author->hint, $author->name );

    if ($rc) {
        my $url = $app->uri(
            'mode' => 'view',
            args   => { _type => 'author', recovered => 1, id => $author_id }
        );
        $app->redirect($url);
    }
    else {
        $app->error($res);
    }
}

sub start_backup {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;

    unless ( $user->is_superuser ) {
        return $app->errtrans("Permission denied.")
          unless defined($blog_id) && $perms->can_administer_blog;
    }

    my %param = ();
    if ( defined($blog_id) ) {
        $param{blog_id} = $blog_id;
        $app->add_breadcrumb( $app->translate('Backup') );
    }
    else {
        $app->add_breadcrumb( $app->translate('Backup & Restore') );
    }
    $param{system_overview_nav} = 1 unless $blog_id;
    $param{nav_backup} = 1;
    require MT::Util::Archive;
    my @formats = MT::Util::Archive->available_formats();
    $param{archive_formats} = \@formats;

    my $limit = $app->config('CGIMaxUpload') || 2048;
    $param{over_300}  = 1 if $limit >= 300 * 1024;
    $param{over_500}  = 1 if $limit >= 500 * 1024;
    $param{over_1024} = 1 if $limit >= 1024 * 1024;
    $param{over_2048} = 1 if $limit >= 2048 * 1024;

    my $tmp = $app->config('TempDir');
    unless ( ( -d $tmp ) && ( -w $tmp ) ) {
        $param{error} =
          $app->translate(
'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.'
          );
    }
    $app->load_tmpl( 'backup.tmpl', \%param );
}

sub start_restore {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    my $perms   = $app->permissions;

    unless ( $user->is_superuser ) {
        return $app->errtrans("Permission denied.")
          unless defined($blog_id) && $perms->can_administer_blog;
    }

    my %param = ();
    if ( defined($blog_id) ) {
        $param{blog_id} = $blog_id;
        $app->add_breadcrumb( $app->translate('Backup') );
    }
    else {
        $app->add_breadcrumb( $app->translate('Backup & Restore') );
    }
    $param{system_overview_nav} = 1 unless $blog_id;
    $param{nav_backup} = 1;

    eval "require XML::SAX";
    $param{missing_sax} = 1 if $@;

    my $tmp = $app->config('TempDir');
    unless ( ( -d $tmp ) && ( -w $tmp ) ) {
        $param{error} =
          $app->translate(
'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.'
          );
    }
    $app->load_tmpl( 'restore.tmpl', \%param );
}

sub backup {
    my $app     = shift;
    my $user    = $app->user;
    my $q       = $app->param;
    my $blog_id = $q->param('blog_id');
    my $perms   = $app->permissions;
    unless ( $user->is_superuser ) {
        return $app->errtrans("Permission denied.")
          unless defined($blog_id) && $perms->can_administer_blog;
    }
    $app->validate_magic() or return;

    my $blog_ids = $q->param('backup_what');

    my $size = $q->param('size_limit') || 0;
    return $app->errtrans( '[_1] is not a number.',
        encode_html($size) )
      if $size !~ /^\d+$/;

    my @blog_ids = split ',', $blog_ids;

    my $archive = $q->param('backup_archive_format');
    my $enc     = $app->charset || 'utf-8';
    my @ts      = gmtime(time);
    my $ts = sprintf "%04d-%02d-%02d-%02d-%02d-%02d", $ts[5] + 1900, $ts[4] + 1,
      @ts[ 3, 2, 1, 0 ];
    my $file = "Movable_Type-$ts" . '-Backup';

    my $param = { return_args => '__mode=start_backup' };
    $app->{no_print_body} = 1;
    $app->add_breadcrumb(
        $app->translate('Backup & Restore'),
        $app->uri( mode => 'start_backup' )
    );
    $app->add_breadcrumb( $app->translate('Backup') );
    $param->{system_overview_nav} = 1 if defined($blog_ids) && $blog_ids;
    $param->{blog_id} = $blog_id if $blog_id;
    $param->{blog_ids} = $blog_ids if $blog_ids;
    $param->{nav_backup} = 1;

    local $| = 1;
    $app->send_http_header('text/html');
    $app->print( $app->build_page( 'include/backup_start.tmpl', $param ) );
    require File::Temp;
    require File::Spec;
    use File::Copy;
    my $temp_dir = $app->config('TempDir');

    require MT::BackupRestore;
    my $count_term =
      $blog_id
      ? { class => '*', blog_id => $blog_id }
      : { class => '*' };
    my $num_assets = $app->model('asset')->count($count_term);
    my $printer;
    my $splitter;
    my $finisher;
    my $progress = sub { _progress($app, @_); };
    my $fh;
    my $fname;
    my $arc_buf;

    if ( !( $size || $num_assets ) ) {
        $splitter = sub { };

        if ( '0' eq $archive ) {
            ( $fh, my $filepath ) =
              File::Temp::tempfile( 'xml.XXXXXXXX', DIR => $temp_dir );
            ( my $vol, my $dir, $fname ) = File::Spec->splitpath($filepath);
            $printer =
              sub { my ($data) = @_; print $fh $data; return length($data); };
            $finisher = sub {
                my ($asset_files) = @_;
                close $fh;
                _backup_finisher( $app, $fname, $param );
            };
        }
        else {  # archive/compress files
            $printer =
              sub { my ($data) = @_; $arc_buf .= $data; return length($data); };
            $finisher = sub {
                require MT::Util::Archive;
                my ($asset_files) = @_;
                ( my $fh, my $filepath ) =
                  File::Temp::tempfile( $archive . '.XXXXXXXX', DIR => $temp_dir );
                ( my $vol, my $dir, $fname ) = File::Spec->splitpath($filepath);
                close $fh;
                unlink $filepath;
                my $arc = MT::Util::Archive->new($archive, $filepath);
                $arc->add_string( $arc_buf, "$file.xml" );
                $arc->add_string(
                        "<manifest xmlns='"
                      . MT::BackupRestore::NS_MOVABLETYPE()
                      . "'><file type='backup' name='$file.xml' /></manifest>",
                      "$file.manifest");
                $arc->close;
                _backup_finisher( $app, $fname, $param );
            };
        }
    }
    else {
        my @files;
        my $filename = File::Spec->catfile( $temp_dir, $file . "-1.xml" );
        $fh = gensym();
        open $fh, ">$filename";
        my $url =
            $app->uri
          . "?__mode=backup_download&name=$file-1.xml&magic_token="
          . $app->current_magic;
        $url .= "&blog_id=$blog_id" if defined($blog_id);
        push @files,
          {
            url      => $url,
            filename => $file . "-1.xml"
          };
        $printer =
          sub { my ($data) = @_; print $fh $data; return length($data); };
        $splitter = sub {
            my ($findex) = @_;
            print $fh '</movabletype>';
            close $fh;
            my $filename =
              File::Spec->catfile( $temp_dir, $file . "-$findex.xml" );
            $fh = gensym();
            open $fh, ">$filename";
            my $url =
                $app->uri
              . "?__mode=backup_download&name=$file-$findex.xml&magic_token="
              . $app->current_magic;
            $url .= "&blog_id=$blog_id" if defined($blog_id);
            push @files,
              {
                url      => $url,
                filename => $file . "-$findex.xml"
              };
            my $header .=
              "<movabletype xmlns='"
              . MT::BackupRestore::NS_MOVABLETYPE() . "'>\n";
            $header = "<?xml version='1.0' encoding='$enc'?>\n$header"
              if $enc !~ m/utf-?8/i;
            print $fh $header;
        };
        $finisher = sub {
            my ($asset_files) = @_;
            close $fh;
            my $filename = File::Spec->catfile( $temp_dir, "$file.manifest" );
            $fh = gensym();
            open $fh, ">$filename";
            print $fh "<manifest xmlns='"
              . MT::BackupRestore::NS_MOVABLETYPE() . "'>\n";
            for my $file (@files) {
                my $name = $file->{filename};
                print $fh "<file type='backup' name='$name' />\n";
            }
            for my $id ( keys %$asset_files ) {
                my $name = $id . '-' . $asset_files->{$id}->[2];
                my $tmp = File::Spec->catfile( $temp_dir, $name );
                unless ( copy( $asset_files->{$id}->[1], $tmp ) ) {
                    $app->log(
                        {
                            message => $app->translate(
                                'Copying file [_1] to [_2] failed: [_3]',
                                $asset_files->{$id}->[1],
                                $tmp, $!
                            ),
                            level    => MT::Log::INFO(),
                            class    => 'system',
                            category => 'backup'
                        }
                    );
                    next;
                }
                print $fh "<file type='asset' name='"
                  . $asset_files->{$id}->[2]
                  . "' asset_id='"
                  . $id
                  . "' />\n";
                my $url =
                    $app->uri
                  . "?__mode=backup_download&assetname=$name&magic_token="
                  . $app->current_magic;
                $url .= "&blog_id=$blog_id" if defined($blog_id);
                push @files,
                  {
                    url      => $url,
                    filename => $name,
                  };
            }
            print $fh "</manifest>\n";
            close $fh;
            my $url =
                $app->uri
              . "?__mode=backup_download&name=$file.manifest&magic_token="
              . $app->current_magic;
            $url .= "&blog_id=$blog_id" if defined($blog_id);
            push @files,
              {
                url      => $url,
                filename => "$file.manifest"
              };
            if ( '0' eq $archive ) {
                $param->{files_loop} = \@files;
                $param->{tempdir}    = $temp_dir;
                my @fnames = map { $_->{filename} } @files;
                _backup_finisher( $app, \@fnames, $param );
            }
            else {
                my ( $fh_arc, $filepath ) =
                  File::Temp::tempfile( $archive . '.XXXXXXXX', DIR => $temp_dir );
                ( my $vol, my $dir, $fname ) = File::Spec->splitpath($filepath);
                require MT::Util::Archive;
                close $fh_arc;
                unlink $filepath;
                my $arc = MT::Util::Archive->new($archive, $filepath);
                for my $f (@files) {
                    $arc->add_file( $temp_dir, $f->{filename} );
                }
                $arc->close;
                # for safery, don't unlink before closing $arc here.
                for my $f (@files) {
                    unlink File::Spec->catfile( $temp_dir, $f->{filename} );
                }
                _backup_finisher( $app, $fname, $param );
            }
        };
    }

    my @tsnow    = gmtime(time);
    my $metadata = {
        backup_by => $app->user->name . '(ID: ' . $app->user->id . ')',
        backup_on => sprintf(
            "%04d-%02d-%02dT%02d:%02d:%02d",
            $tsnow[5] + 1900,
            $tsnow[4] + 1,
            @tsnow[ 3, 2, 1, 0 ]
        ),
        backup_what    => join( ',', @blog_ids ),
        schema_version => $app->config('SchemaVersion'),
    };
    MT::BackupRestore->backup( \@blog_ids, $printer, $splitter, $finisher,
        $progress, $size * 1024,
        $enc, $metadata );
}

sub backup_download {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    unless ( $user->is_superuser ) {
        my $perms = $app->permissions;
        return $app->errtrans("Permission denied.")
          unless defined($blog_id) && $perms->can_administer_blog;
    }
    $app->validate_magic() or return;
    my $filename  = $app->param('filename');
    my $assetname = $app->param('assetname');
    my $temp_dir  = $app->config('TempDir');
    my $newfilename;
    if ( defined($assetname) ) {
        my $sess = MT::Session->load( { kind => 'BU', name => $assetname } );
        if ( !defined($sess) || !$sess ) {
            return $app->errtrans("Specified file was not found.");
        }
        $newfilename = $filename = $assetname;
        $sess->remove;
    }
    elsif ( defined($filename) ) {
        my $sess = MT::Session->load( { kind => 'BU', name => $filename } );
        if ( !defined($sess) || !$sess ) {
            return $app->errtrans("Specified file was not found.");
        }
        my @ts = gmtime( $sess->start );
        my $ts = sprintf "%04d-%02d-%02d-%02d-%02d-%02d", $ts[5] + 1900,
          $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
        $newfilename = "Movable_Type-$ts" . '-Backup';
        $sess->remove;
    }
    else {
        $newfilename = $app->param('name');
        return
          if $newfilename !~
/Movable_Type-\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}-Backup(?:-\d+)?\.\w+/;
        $filename = $newfilename;
    }

    require File::Spec;
    my $fname = File::Spec->catfile( $temp_dir, $filename );

    my $contenttype;
    if ( !defined($assetname) && ( $filename =~ m/^xml\..+$/i ) ) {
        my $enc = $app->charset || 'utf-8';
        $contenttype = "text/xml; charset=$enc";
        $newfilename .= '.xml';
    }
    elsif ( $filename =~ m/^tgz\..+$/i ) {
        $contenttype = 'application/x-tar-gz';
        $newfilename .= '.tar.gz';
    }
    elsif ( $filename =~ m/^zip\..+$/i ) {
        $contenttype = 'application/zip';
        $newfilename .= '.zip';
    }
    else {
        $contenttype = 'application/octet-stream';
    }

    if ( open( my $fh, "<", $fname ) ) {
        binmode $fh;
        $app->{no_print_body} = 1;
        $app->set_header(
            "Content-Disposition" => "attachment; filename=$newfilename" );
        $app->send_http_header($contenttype);
        my $data;
        while ( read $fh, my ($chunk), 8192 ) {
            $data .= $chunk;
        }
        close $fh;
        $app->print($data);
        $app->log(
            {
                message => $app->translate(
                    '[_1] successfully downloaded backup file ([_2])',
                    $app->user->name, $fname
                ),
                level    => MT::Log::INFO(),
                class    => 'system',
                category => 'restore'
            }
        );
        unlink $fname;
    }
    else {
        $app->errtrans('Specified file was not found.');
    }
}

sub restore {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    my $q = $app->param;

    my ($fh) = $app->upload_info('file');
    my $uploaded = $q->param('file');
    my ( $volume, $directories, $uploaded_filename ) =
      File::Spec->splitpath($uploaded)
      if defined($uploaded);
    if ( defined($uploaded_filename)
        && ( $uploaded_filename =~ /^.+\.manifest$/i ) )
    {
        return restore_upload_manifest( $app, $fh );
    }

    my $param = { return_args => '__mode=dashboard' };

    $app->add_breadcrumb(
        $app->translate('Backup & Restore'),
        $app->uri( mode => 'start_restore' )
    );
    $app->add_breadcrumb( $app->translate('Restore') );
    $param->{system_overview_nav} = 1;
    $param->{nav_backup}          = 1;

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print( $app->build_page( 'restore_start.tmpl', $param ) );

    require File::Path;

    my $error = '';
    my $result;
    if (!$fh) {
        $param->{restore_upload} = 0;
        my $dir = $app->config('ImportPath');
        my ( $blog_ids, $asset_ids ) = restore_directory( $app, $dir, \$error );
        if ( defined $blog_ids ) {
            $param->{open_dialog} = 1;
            $param->{blog_ids}    = join( ',', @$blog_ids );
            $param->{asset_ids}   = join( ',', @$asset_ids )
              if defined $asset_ids;
            $param->{tmp_dir} = $dir;
        }
        elsif ( defined $asset_ids ) {
            my %asset_ids = @$asset_ids;
            my %error_assets;
            _restore_non_blog_asset( $app, $dir, $asset_ids, \%error_assets );
            if (%error_assets) {
                my $data;
                while ( my ( $key, $value ) = each %error_assets ) {
                    $data .=
                      $app->translate( 'MT::Asset#[_1]: ', $key ) . $value . "\n";
                }
                my $message = $app->translate(
                    'Some of the actual files for assets could not be restored.');
                $app->log(
                    {
                        message  => $message,
                        level    => MT::Log::WARNING(),
                        class    => 'system',
                        category => 'restore',
                        metadata => $data,
                    }
                );
                $error .= $message;
            }
        }
    }
    else {
        $param->{restore_upload} = 1;
        if ( $uploaded_filename =~ /^.+\.xml$/i ) {
            my $blog_ids = restore_file( $app, $fh, \$error );
            if ( defined $blog_ids ) {
                $param->{open_dialog} = 1;
                $param->{blog_ids} = join( ',', @$blog_ids );
            }
        }
        else {
            require MT::Util::Archive;
            my $arc;
            if ( $uploaded_filename =~ /^.+\.tar(\.gz)?$/i ) {
                $arc = MT::Util::Archive->new('tgz', $fh);
            }
            elsif ( $uploaded_filename =~ /^.+\.zip$/i ) {
                $arc = MT::Util::Archive->new('zip', $fh);
            }
            else {
                $error =
                  $app->translate(
                    'Please use xml, tar.gz, zip, or manifest as a file extension.'
                  );
            }
            unless ($arc) {
                $result = 0;
                $param->{restore_success} = 0;
                if ($error) {
                    $param->{error}           = $error;
                }
                else {
                    $error = MT->translate('Unknown file format');
                    $app->log(
                        {
                            message  => $error . ":$uploaded_filename",
                            level    => MT::Log::WARNING(),
                            class    => 'system',
                            category => 'restore',
                            metadata => MT::Util::Archive->errstr,
                        }
                    );
                }
                $app->print( $error );
                $app->print(
                    $app->build_page( "restore_end.tmpl", $param ) );
                close $fh if $fh;
                return 1;
            }
            my $temp_dir = $app->config('TempDir');
            require File::Temp;
            my $tmp = File::Temp::tempdir( $uploaded_filename . 'XXXX',
                DIR => $temp_dir );
            $arc->extract($tmp);
            $arc->close;
            my ( $blog_ids, $asset_ids ) =
              restore_directory( $app, $tmp, \$error );
            if (defined $blog_ids) {
                $param->{open_dialog} = 1;
                $param->{blog_ids} = join( ',', @$blog_ids )
                  if defined $blog_ids;
                $param->{asset_ids} = join( ',', @$asset_ids )
                  if defined $asset_ids;
                $param->{tmp_dir} = $tmp;
            }
            elsif ( defined $asset_ids ) {
                my %asset_ids = @$asset_ids;
                my %error_assets;
                _restore_non_blog_asset( $app, $tmp, \%asset_ids, \%error_assets );
                if (%error_assets) {
                    my $data;
                    while ( my ( $key, $value ) = each %error_assets ) {
                        $data .=
                          $app->translate( 'MT::Asset#[_1]: ', $key ) . $value . "\n";
                    }
                    my $message = $app->translate(
                        'Some of the actual files for assets could not be restored.');
                    $app->log(
                        {
                            message  => $message,
                            level    => MT::Log::WARNING(),
                            class    => 'system',
                            category => 'restore',
                            metadata => $data,
                        }
                    );
                    $error .= $message;
                }
            }
        }
    }
    $param->{restore_success} = !$error;
    $param->{error} = $error if $error;
    if ( ( exists $param->{open_dialog} ) && ( $param->{open_dialog} ) ) {
        $param->{dialog_mode} = 'dialog_adjust_sitepath';
        $param->{dialog_params} =
            'magic_token='
          . $app->current_magic
          . '&amp;blog_ids='
          . $param->{blog_ids}
          . '&amp;asset_ids='
          . $param->{asset_ids}
          . '&amp;tmp_dir='
          . encode_url( $param->{tmp_dir} );
        if ( ( $param->{restore_upload} ) && ( $param->{restore_upload} ) ) {
            $param->{dialog_params} .= '&amp;restore_upload=1';
        }
        if ( ( $param->{error} ) && ( $param->{error} ) ) {
            $param->{dialog_params} .=
              '&amp;error=' . encode_url( $param->{error} );
        }
    }

    $app->print( $app->build_page( "restore_end.tmpl", $param ) );
    close $fh if $fh;
    1;
}

sub restore_premature_cancel {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    require JSON;
    my $deferred = JSON::jsonToObj( $app->param('deferred_json') )
      if $app->param('deferred_json');
    my $param = { restore_success => 1 };
    if ( defined $deferred && ( scalar( keys %$deferred ) ) ) {
        _log_dirty_restore( $app, $deferred );
        my $log_url = $app->uri( mode => 'view_log', args => {} );
        $param->{restore_success} = 0;
        my $message =
          $app->translate(
'Some objects were not restored because their parent objects were not restored.'
          );
        $param->{error} = $message . '  '
          . $app->translate(
"Detailed information is in the <a href='javascript:void(0)' onclick='closeDialog(\"[_1]\")'>activity log</a>.",
            $log_url
          );
    }
    else {
        $app->log(
            {
                message => $app->translate(
'[_1] has canceled the multiple files restore operation prematurely.',
                    $app->user->name
                ),
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
            }
        );
    }
    $app->redirect( $app->uri( mode => 'view_log', args => {} ) );
}

sub _restore_non_blog_asset {
    my ( $app, $tmp_dir, $asset_ids, $error_assets ) = @_;
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    foreach my $new_id ( keys %$asset_ids ) {
        my $asset = $app->model('asset')->load($new_id);
        next unless $asset;
        my $old_id = $asset_ids->{$new_id};
        my $filename = $old_id . '-' . $asset->file_name;
        my $file    = File::Spec->catfile( $tmp_dir, $filename );
        MT::BackupRestore->restore_asset( $file, $asset, $old_id, $fmgr,
            $error_assets, sub { $app->print(@_); } );
    }
}

sub adjust_sitepath {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    require MT::BackupRestore;

    my $q         = $app->param;
    my $tmp_dir   = $q->param('tmp_dir');
    my $error     = $q->param('error') || q();
    my %asset_ids = split ',', $q->param('asset_ids');

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print( $app->build_page( 'dialog/restore_start.tmpl', {} ) );

    my $asset_class = $app->model('asset');
    my %error_assets;
    my %blogs_meta;
    my @p = $q->param;
    foreach my $p (@p) {
        next unless $p =~ /^site_path_(\d+)/;
        my $id            = $1;
        my $blog          = $app->model('blog')->load($id)
            or return $app->error($app->translate('Can\'t load blog #[_1].', $id));
        my $old_site_path = scalar $q->param("old_site_path_$id");
        my $old_site_url  = scalar $q->param("old_site_url_$id");
        my $site_path     = scalar $q->param("site_path_$id") || q();
        my $site_url      = scalar $q->param("site_url_$id") || q();
        $blog->site_path($site_path);
        $blog->site_url($site_url);

        if ( $site_url || $site_path ) {
            $app->print(
                $app->translate(
                    "Changing Site Path for the blog '[_1]' (ID:[_2])...",
                    encode_html( $blog->name ), $blog->id
                )
            );
        }
        else {
            $app->print(
                $app->translate(
                    "Removing Site Path for the blog '[_1]' (ID:[_2])...",
                    encode_html( $blog->name ), $blog->id
                )
            );
        }
        my $old_archive_path = scalar $q->param("old_archive_path_$id");
        my $old_archive_url  = scalar $q->param("old_archive_url_$id");
        my $archive_path     = scalar $q->param("archive_path_$id") || q();
        my $archive_url      = scalar $q->param("archive_url_$id") || q();
        $blog->archive_path($archive_path);
        $blog->archive_url($archive_url);
        if (   ( $old_archive_url && $archive_url )
            || ( $old_archive_path && $archive_path ) )
        {
            $app->print(
                "\n"
                  . $app->translate(
                    "Changing Archive Path for the blog '[_1]' (ID:[_2])...",
                    encode_html( $blog->name ), $blog->id
                  )
            );
        }
        elsif ( $old_archive_url || $old_archive_path ) {
            $app->print(
                "\n"
                  . $app->translate(
                    "Removing Archive Path for the blog '[_1]' (ID:[_2])...",
                    encode_html( $blog->name ), $blog->id
                  )
            );
        }
        $blog->save or $app->print( $app->translate("failed") . "\n" ), next;
        $app->print( $app->translate("ok") . "\n" );

        $blogs_meta{$id} = {
            'old_archive_path' => $old_archive_path,
            'old_archive_url'  => $old_archive_url,
            'archive_path'     => $archive_path,
            'archive_url'      => $archive_url,
            'old_site_path'    => $old_site_path,
            'old_site_url'     => $old_site_url,
            'site_path'        => $site_path,
            'site_url'         => $site_url,
        };
        next unless %asset_ids;

        my $fmgr = ( $site_path || $archive_path ) ? $blog->file_mgr : undef;
        next unless defined $fmgr;

        my @assets =
          $asset_class->load( { blog_id => $id, class => '*' } );
        foreach my $asset (@assets) {
            my $path = $asset->column('file_path');
            my $url  = $asset->column('url');
            if ($archive_path) {
                $path =~ s/^\Q$old_archive_path\E/$archive_path/i;
                $asset->file_path($path);
            }
            if ($archive_url) {
                $url =~ s/^\Q$old_archive_url\E/$archive_url/i;
                $asset->url($url);
            }
            if ($site_path) {
                $path =~ s/^\Q$old_site_path\E/$site_path/i;
                $asset->file_path($path);
            }
            if ($site_url) {
                $url =~ s/^\Q$old_site_url\E/$site_url/i;
                $asset->url($url);
            }
            $app->print(
                $app->translate(
                    "Changing file path for the asset '[_1]' (ID:[_2])...",
                    encode_html( $asset->label ), $asset->id
                )
            );
            $asset->save
              or $app->print( $app->translate("failed") . "\n" ), next;
            $app->print( $app->translate("ok") . "\n" );
            unless ( $q->param('redirect') ) {
                my $old_id   = delete $asset_ids{ $asset->id };
                my $filename = "$old_id-" . $asset->file_name;
                my $file     = File::Spec->catfile( $tmp_dir, $filename );
                MT::BackupRestore->restore_asset( $file, $asset, $old_id, $fmgr,
                    \%error_assets, sub { $app->print(@_); } );
            }
        }
    }
    unless ( $q->param('redirect') ) {
        _restore_non_blog_asset( $app, $tmp_dir, \%asset_ids, \%error_assets );
    }
    if (%error_assets) {
        my $data;
        while ( my ( $key, $value ) = each %error_assets ) {
            $data .=
              $app->translate( 'MT::Asset#[_1]: ', $key ) . $value . "\n";
        }
        my $message = $app->translate(
            'Some of the actual files for assets could not be restored.');
        $app->log(
            {
                message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => $data,
            }
        );
        $error .= $message;
    }

    if ($tmp_dir) {
        require File::Path;
        File::Path::rmtree($tmp_dir);
    }

    my $param = {};
    if ( scalar $q->param('redirect') ) {
        $param->{restore_end} = 0;  # redirect=1 means we are from multi-uploads
        require JSON;
        $param->{blogs_meta} = JSON::objToJson( \%blogs_meta );
        $param->{next_mode}  = 'dialog_restore_upload';
    }
    else {
        $param->{restore_end} = 1;
    }
    if ($error) {
        $param->{error}     = $error;
        $param->{error_url} = $app->uri( mode => 'view_log', args => {} );
    }
    for my $key (
        qw(files last redirect is_dirty is_asset objects_json deferred_json))
    {
        $param->{$key} = scalar $q->param($key);
    }
    $param->{name}   = $q->param('current_file');
    $param->{assets} = encode_html( $q->param('assets') );
    $app->print( $app->build_page( 'dialog/restore_end.tmpl', $param ) );
}

sub dialog_restore_upload {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    my $q = $app->param;

    my $current        = $q->param('current_file');
    my $last           = $q->param('last');
    my $files          = $q->param('files');
    my $assets_json    = $q->param('assets');
    my $is_asset       = $q->param('is_asset') || 0;
    my $schema_version = $q->param('schema_version')
      || $app->config('SchemaVersion');
    my $overwrite_template = $q->param('overwrite_templates') ? 1 : 0;

    my $objects  = {};
    my $deferred = {};
    require JSON;
    my $objects_json = $q->param('objects_json') if $q->param('objects_json');
    $deferred = JSON::jsonToObj( $q->param('deferred_json') )
      if $q->param('deferred_json');

    my ($fh) = $app->upload_info('file');

    my $param = {};
    $param->{start}          = $q->param('start') || 0;
    $param->{is_asset}       = $is_asset;
    $param->{name}           = $current;
    $param->{files}          = $files;
    $param->{assets}         = $assets_json;
    $param->{last}           = $last;
    $param->{redirect}       = 1;
    $param->{is_dirty}       = $q->param('is_dirty');
    $param->{objects_json}   = $objects_json if defined($objects_json);
    $param->{deferred_json}  = JSON::objToJson($deferred) if defined($deferred);
    $param->{blogs_meta}     = $q->param('blogs_meta');
    $param->{schema_version} = $schema_version;
    $param->{overwrite_templates} = $overwrite_template;

    my $uploaded = $q->param('file');
    if ( defined($uploaded) ) {
        $uploaded =~ s!\\!/!g;    ## Change backslashes to forward slashes
        my ( $volume, $directories, $uploaded_filename ) =
          File::Spec->splitpath($uploaded);
        if ( $current ne $uploaded_filename ) {
            close $fh if $uploaded_filename;
            $param->{error} =
              $app->translate( 'Please upload [_1] in this page.', $current );
            return $app->load_tmpl( 'dialog/restore_upload.tmpl', $param );
        }
    }

    if (!$fh) {
        $param->{error} = $app->translate('File was not uploaded.')
          if !( $q->param('redirect') );
        return $app->load_tmpl( 'dialog/restore_upload.tmpl', $param );
    }

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print( $app->build_page( 'dialog/restore_start.tmpl', $param ) );

    if ( defined $objects_json ) {
        my $objects_tmp = JSON::jsonToObj($objects_json);
        my %class2ids;

        # { MT::CLASS#OLD_ID => NEW_ID }
        for my $key ( keys %$objects_tmp ) {
            my ( $class, $old_id ) = split '#', $key;
            if ( exists $class2ids{$class} ) {
                my $newids = $class2ids{$class}->{newids};
                push @$newids, $objects_tmp->{$key};
                my $keymaps = $class2ids{$class}->{keymaps};
                push @$keymaps,
                  { newid => $objects_tmp->{$key}, oldid => $old_id };
            }
            else {
                $class2ids{$class} = {
                    newids => [ $objects_tmp->{$key} ],
                    keymaps =>
                      [ { newid => $objects_tmp->{$key}, oldid => $old_id } ]
                };
            }
        }
        for my $class ( keys %class2ids ) {
            eval "require $class;";
            next if $@;
            my $newids  = $class2ids{$class}->{newids};
            my $keymaps = $class2ids{$class}->{keymaps};
            my @objs    = $class->load( { id => $newids } );
            for my $obj (@objs) {
                my @old_ids = grep { $_->{newid} eq $obj->id } @$keymaps;
                my $old_id = $old_ids[0]->{oldid};
                $objects->{"$class#$old_id"} = $obj;
            }
        }
    }

    my $assets = JSON::jsonToObj( decode_html($assets_json) )
      if ( defined($assets_json) && $assets_json );
    $assets = [] if !defined($assets);
    my $asset;
    my @errors;
    my $error_assets = {};
    require MT::BackupRestore;
    my $blog_ids;
    my $asset_ids;

    if ($is_asset) {
        $asset = shift @$assets;
        $asset->{fh} = $fh;
        my $blogs_meta = JSON::jsonToObj( $q->param('blogs_meta') || '{}' );
        MT::BackupRestore->_restore_asset_multi( $asset, $objects,
            $error_assets, sub { $app->print(@_); }, $blogs_meta );
        if ( defined( $error_assets->{ $asset->{asset_id} } ) ) {
            $app->log(
                {
                    message => $app->translate('Restoring a file failed: ')
                      . $error_assets->{ $asset->{asset_id} },
                    level    => MT::Log::WARNING(),
                    class    => 'system',
                    category => 'restore',
                }
            );
        }
    }
    else {
        ( $blog_ids, $asset_ids ) = eval {
            MT::BackupRestore->restore_process_single_file( $fh, $objects,
                $deferred, \@errors, $schema_version, $overwrite_template,
                sub { _progress($app, @_) } );
        };
        if ($@) {
            $last = 1;
        }
    }

    my @files = split( ',', $files );
    my $file_next = shift @files if scalar(@files);
    if ( !defined($file_next) ) {
        if ( scalar(@$assets) ) {
            $asset             = $assets->[0];
            $file_next         = $asset->{asset_id} . '-' . $asset->{name};
            $param->{is_asset} = 1;
        }
    }
    $param->{files}  = join( ',', @files );
    $param->{assets} = encode_html( JSON::objToJson($assets) );
    $param->{name}   = $file_next;
    if ( 0 < scalar(@files) ) {
        $param->{last} = 0;
    }
    elsif ( 0 >= scalar(@$assets) - 1 ) {
        $param->{last} = 1;
    }
    else {
        $param->{last} = 0;
    }
    $param->{is_dirty} = scalar( keys %$deferred );
    if ($last) {
        $param->{restore_end} = 1;
        if ( $param->{is_dirty} ) {
            _log_dirty_restore( $app, $deferred );
            my $log_url = $app->uri( mode => 'view_log', args => {} );
            $param->{error} =
              $app->translate(
'Some objects were not restored because their parent objects were not restored.'
              );
            $param->{error_url} = $log_url;
        }
        elsif ( scalar( keys %$error_assets ) ) {
            $param->{error} =
              $app->translate('Some of the files were not restored correctly.');
            my $log_url = $app->uri( mode => 'view_log', args => {} );
            $param->{error_url} = $log_url;
        }
        elsif ( scalar @errors ) {
            $param->{error} = join '; ', @errors;
            my $log_url = $app->uri( mode => 'view_log', args => {} );
            $param->{error_url} = $log_url;
        }
        else {
            $app->log(
                {
                    message => $app->translate(
"Successfully restored objects to Movable Type system by user '[_1]'",
                        $app->user->name
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'system',
                    category => 'restore'
                }
            );
            $param->{ok_url} = $app->uri( mode => 'start_restore', args => {} );
        }
    }
    else {
        my %objects_json;
        %objects_json = map { $_ => $objects->{$_}->id } keys %$objects;
        $param->{objects_json}  = JSON::objToJson( \%objects_json );
        $param->{deferred_json} = JSON::objToJson($deferred);

        $param->{error} = join( '; ', @errors );
        if ( defined($blog_ids) && scalar(@$blog_ids) ) {
            $param->{next_mode} = 'dialog_adjust_sitepath';
            $param->{blog_ids}  = join( ',', @$blog_ids );
            $param->{asset_ids} = join( ',', @$asset_ids )
              if defined($asset_ids);
        }
        else {
            $param->{next_mode} = 'dialog_restore_upload';
        }
    }
    MT->run_callbacks('restore', $objects, $deferred, \@errors, sub { _progress( $app, @_ ) });

    $app->print( $app->build_page( 'dialog/restore_end.tmpl', $param ) );
    close $fh if $fh;
}

sub dialog_adjust_sitepath {
    my $app  = shift;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    my $q         = $app->param;
    my $tmp_dir   = $q->param('tmp_dir');
    my $error     = $q->param('error') || q();
    my $uploaded  = $q->param('restore_upload') || 0;
    my @blog_ids  = split ',', $q->param('blog_ids');
    my $asset_ids = $q->param('asset_ids');
    my @blogs     = $app->model('blog')->load( { id => \@blog_ids } );
    my @blogs_loop;

    foreach my $blog (@blogs) {
        push @blogs_loop,
          {
            name          => $blog->name,
            id            => $blog->id,
            old_site_path => $blog->site_path,
            old_site_url  => $blog->site_url,
            $blog->column('archive_path')
            ? ( old_archive_path => $blog->archive_path )
            : (),
            $blog->column('archive_url')
            ? ( old_archive_url => $blog->archive_url )
            : (),
          };
    }
    my $param = { blogs_loop => \@blogs_loop, tmp_dir => $tmp_dir };
    $param->{error}          = $error     if $error;
    $param->{restore_upload} = $uploaded  if $uploaded;
    $param->{asset_ids}      = $asset_ids if $asset_ids;
    for my $key (
        qw(files assets last redirect is_dirty is_asset objects_json deferred_json)
      )
    {
        $param->{$key} = $q->param($key) if $q->param($key);
    }
    $param->{name} = $q->param('current_file');
    $param->{screen_id} = "adjust-sitepath";
    $app->load_tmpl( 'dialog/adjust_sitepath.tmpl', $param );
}

sub convert_to_html {
    my $app    = shift;
    my $format = $app->param('format');
    my $text   = $app->param('text') || '';
    my $text_more = $app->param('text_more') || '';
    my $result = {
        text      => $app->apply_text_filters( $text,      [$format] ),
        text_more => $app->apply_text_filters( $text_more, [$format] ),
        format    => $format,
    };
    return $app->json_result($result);
}

sub update_list_prefs {
    my $app   = shift;
    my $prefs = $app->list_pref( $app->param('_type') );
    $app->call_return;
}

sub recover_passwords {
    my $app = shift;
    my @id  = $app->param('id');

    return $app->errtrans("Permission denied.")
      unless $app->user->is_superuser();

    my $class = ref $app eq 'MT::App::Upgrader' ? 'MT::BasicAuthor' : $app->model('author');
    eval "use $class;";

    my @msg_loop;
    foreach (@id) {
        my $author = $class->load($_)
            or next;
        my ( $rc, $res ) = reset_password( $app, $author, $author->hint );
        push @msg_loop, { message => $res };
    }

    $app->load_tmpl( 'recover_password_result.tmpl',
        { message_loop => \@msg_loop, return_url => $app->return_uri } );
}

sub reset_password {
    my $app      = shift;
    my ($author) = $_[0];
    my $hint     = $_[1];
    my $name     = $_[2];

    require MT::Auth;
    require MT::Log;
    if ( !MT::Auth->can_recover_password ) {
        $app->log(
            {
                message => $app->translate(
"Invalid password recovery attempt; can't recover password in this configuration"
                ),
                level    => MT::Log::SECURITY(),
                class    => 'system',
                category => 'recover_password',
            }
        );
        return ( 0,
            $app->translate("Can't recover password in this configuration") );
    }

    $app->log(
        {
            message => $app->translate(
                "Invalid user name '[_1]' in password recovery attempt", $name
            ),
            level    => MT::Log::SECURITY(),
            class    => 'system',
            category => 'recover_password',
        }
      ),
      return ( 0, $app->translate("User name or password hint is incorrect.") )
      unless $author;
    return ( 0,
        $app->translate("User has not set pasword hint; cannot recover password")
    ) if ( $hint && !$author->hint );

    $app->log(
        {
            message => $app->translate(
                "Invalid attempt to recover password (used hint '[_1]')",
                $hint
            ),
            level    => MT::Log::SECURITY(),
            class    => 'system',
            category => 'recover_password'
        }
      ),
      return ( 0, $app->translate("User name or password hint is incorrect.") )
      unless $author->hint eq $hint;

    return ( 0, $app->translate("User does not have email address") )
      unless $author->email;

    my @pool = ( 'a' .. 'z', 0 .. 9 );
    my $pass = '';
    for ( 1 .. 8 ) { $pass .= $pool[ rand @pool ] }
    $author->set_password($pass);
    $author->save;
    my $message =
      $app->translate(
"Password was reset for user '[_1]' (user #[_2]). Password was sent to the following address: [_3]",
        $author->name, $author->id, $author->email );
    $app->log(
        {
            message  => $message,
            level    => MT::Log::SECURITY(),
            class    => 'system',
            category => 'recover_password'
        }
    );

    my $address =
      defined $author->nickname
      ? $author->nickname . ' <' . $author->email . '>'
      : $author->email;
    my %head = (
        id      => 'recover_password',
        To      => $address,
        From    => $app->config('EmailAddressMain') || $address,
        Subject => $app->translate("Password Recovery")
    );
    my $charset = $app->charset;
    my $mail_enc = uc( $app->config('MailEncoding') || $charset );
    $head{'Content-Type'} = qq(text/plain; charset="$mail_enc");

    my $body = $app->build_email( 'recover-password.tmpl',
        { user_password => $pass, link_to_login => $app->base . $app->mt_uri } 
    );
    $body = wrap_text( $body, 72 );
    require MT::Mail;
    MT::Mail->send( \%head, $body )
      or return (
        0,
        $app->translate(
            "Error sending mail ([_1]); please fix the problem, then "
              . "try again to recover your password.",
            MT::Mail->errstr
        )
      );
    ( 1, $message );
}

sub restore_file {
    my $app = shift;
    my ( $fh, $errormsg ) = @_;
    my $q = $app->param;
    my $schema_version = $app->config->SchemaVersion;
    #my $schema_version =
    #  $q->param('ignore_schema_conflict')
    #  ? 'ignore'
    #  : $app->config('SchemaVersion');
    my $overwrite_template = $q->param('overwrite_global_templates') ? 1 : 0;

    require MT::BackupRestore;
    my ( $deferred, $blogs ) =
      MT::BackupRestore->restore_file( $fh, $errormsg, $schema_version, $overwrite_template,
        sub { _progress( $app, @_ ); } );

    if ( !defined($deferred) || scalar( keys %$deferred ) ) {
        _log_dirty_restore( $app, $deferred );
        my $log_url = $app->uri( mode => 'view_log', args => {} );
        $$errormsg .= '; ' if $$errormsg;
        $$errormsg .= $app->translate(
'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.',
            $log_url
        );
        return $blogs;
    }
    if ($$errormsg) {
        $app->log(
            {
                message  => $$errormsg,
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'restore',
            }
        );
        return $blogs;
    }

    $app->log(
        {
            message => $app->translate(
"Successfully restored objects to Movable Type system by user '[_1]'",
                $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );

    $blogs;
}

sub restore_directory {
    my $app = shift;
    my ( $dir, $error ) = @_;

    if ( !-d $dir ) {
        $$error = $app->translate( '[_1] is not a directory.', $dir );
        return ( undef, undef );
    }

    my $q = $app->param;
    my $schema_version = $app->config->SchemaVersion;
    #my $schema_version =
    #  $q->param('ignore_schema_conflict')
    #  ? 'ignore'
    #  : $app->config('SchemaVersion');

    my $overwrite_template = $q->param('overwrite_global_templates') ? 1 : 0;

    my @errors;
    my %error_assets;
    require MT::BackupRestore;
    my ( $deferred, $blogs, $assets ) =
      MT::BackupRestore->restore_directory( $dir, \@errors, \%error_assets,
        $schema_version, $overwrite_template, sub { _progress( $app, @_ ); } );

    if ( scalar @errors ) {
        $$error = $app->translate('Error occured during restore process.');
        $app->log(
            {
                message  => $$error,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => join( '; ', @errors ),
            }
        );
    }
    return ( $blogs, $assets ) unless ( defined($deferred) && %$deferred );

    if ( scalar( keys %error_assets ) ) {
        my $data;
        while ( my ( $key, $value ) = each %error_assets ) {
            $data .=
              $app->translate( 'MT::Asset#[_1]: ', $key ) . $value . "\n";
        }
        my $message = $app->translate('Some of files could not be restored.');
        $app->log(
            {
                message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => $data,
            }
        );
        $$error .= $message;
    }

    if ( scalar( keys %$deferred ) ) {
        _log_dirty_restore( $app, $deferred );
        my $log_url = $app->uri( mode => 'view_log', args => {} );
        $$error = $app->translate(
'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.',
            $log_url
        );
        return ( $blogs, $assets );
    }

    return ( $blogs, $assets ) if $$error;

    $app->log(
        {
            message => $app->translate(
"Successfully restored objects to Movable Type system by user '[_1]'",
                $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );
    return ( $blogs, $assets );
}

sub restore_upload_manifest {
    my $app  = shift;
    my ($fh) = @_;
    my $user = $app->user;
    return $app->errtrans("Permission denied.") if !$user->is_superuser;
    $app->validate_magic() or return;

    my $q = $app->param;

    require MT::BackupRestore;
    my $backups = MT::BackupRestore->process_manifest($fh);
    return $app->errtrans(
        "Uploaded file was not a valid Movable Type backup manifest file.")
      if !defined($backups);

    my $files     = $backups->{files};
    my $assets    = $backups->{assets};
    my $file_next = shift @$files if defined($files) && scalar(@$files);
    my $assets_json;
    my $param = {};

    if ( !defined($file_next) ) {
        if ( scalar(@$assets) > 0 ) {
            my $asset = shift @$assets;
            $file_next = $asset->{name};
            $param->{is_asset} = 1;
        }
    }
    require JSON;
    $assets_json = encode_url( JSON::objToJson($assets) )
      if scalar(@$assets) > 0;
    $param->{files}       = join( ',', @$files );
    $param->{assets}      = $assets_json;
    $param->{filename}    = $file_next;
    $param->{last}        = scalar(@$files) ? 0 : ( scalar(@$assets) ? 0 : 1 );
    $param->{open_dialog} = 1;
    $param->{schema_version} = $app->config->SchemaVersion;
    #$param->{schema_version} =
    #  $q->param('ignore_schema_conflict')
    #  ? 'ignore'
    #  : $app->config('SchemaVersion');
    $param->{overwrite_templates} = $q->param('overwrite_global_templates') ? 1 : 0;

    $param->{dialog_mode} = 'dialog_restore_upload';
    $param->{dialog_params} =
        'start=1'
      . '&amp;magic_token='
      . $app->current_magic
      . '&amp;files='
      . $param->{files}
      . '&amp;assets='
      . $param->{assets}
      . '&amp;current_file='
      . $param->{filename}
      . '&amp;last='
      . $param->{'last'}
      . '&amp;schema_version='
      . $param->{schema_version}
      . '&amp;overwrite_templates='
      . $param->{overwrite_templates}
      . '&amp;redirect=1';
    $app->load_tmpl( 'restore.tmpl', $param );

    #close $fh if $fh;
}

sub _backup_finisher {
    my $app = shift;
    my ( $fnames, $param ) = @_;
    unless ( ref $fnames ) {
        $fnames = [$fnames];
    }
    $param->{filename}       = $fnames->[0];
    $param->{backup_success} = 1;
    require MT::Session;
    MT::Session->remove( { kind => 'BU' } );
    foreach my $fname (@$fnames) {
        my $sess = MT::Session->new;
        $sess->id( $app->make_magic_token() );
        $sess->kind('BU');    # BU == Backup
        $sess->name($fname);
        $sess->start(time);
        $sess->save;
    }
    my $message;
    if ( my $blog_id = $param->{blog_id} || $param->{blog_ids} ) {
        $message = $app->translate(
            "Blog(s) (ID:[_1]) was/were successfully backed up by user '[_2]'",
            $blog_id, $app->user->name
        );
    }
    else {
        $message =
          $app->translate(
            "Movable Type system was successfully backed up by user '[_1]'",
            $app->user->name );
    }
    $app->log(
        {
            message  => $message,
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );
    $app->print( $app->build_page( 'include/backup_end.tmpl', $param ) );
}

sub _progress {
    my $app = shift;
    my $ids = $app->request('progress_ids') || {};

    my ( $str, $id ) = @_;
    if ( $id && $ids->{$id} ) {
        my $str_js = encode_js($str);
        $app->print(
qq{<script type="text/javascript">progress('$str_js', '$id');</script>}
        );
    }
    elsif ($id) {
        $ids->{$id} = 1;
        $app->print(qq{\n<span id="$id">$str</span>});
    }
    else {
        $app->print("<span>$str</span>");
    }

    $app->request( 'progress_ids', $ids );
}

sub _log_dirty_restore {
    my $app = shift;
    my ($deferred) = @_;
    my %deferred_by_class;
    for my $key ( keys %$deferred ) {
        my ( $class, $id ) = split( '#', $key );
        if ( exists $deferred_by_class{$class} ) {
            push @{ $deferred_by_class{$class} }, $id;
        }
        else {
            $deferred_by_class{$class} = [$id];

        }
    }
    while ( my ( $class_name, $ids ) = each %deferred_by_class ) {
        my $message = $app->translate(
'Some [_1] were not restored because their parent objects were not restored.',
            $class_name
        );
        $app->log(
            {
                message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => join( ', ', @$ids ),
            }
        );
    }
    1;
}

1;
