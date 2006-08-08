#!/usr/bin/perl
#
# $Id$
#
use strict;
use warnings;
use Archive::Tar;
use Cwd;
use Getopt::Long;
use File::Basename;
use File::Copy;
use File::Path;
use File::Spec;
use IO::File;
use LWP::UserAgent;
use Net::SMTP;
use Sys::Hostname;
use Data::Dumper;
$Data::Dumper::Indent = $Data::Dumper::Terse = $Data::Dumper::Sortkeys = 1;

# Flush the output buffer.
$|++;

# Show the usage if there are no command-line arguments provided.
usage() unless @ARGV;

# Set-up the command-line options with their default values.
my %o = get_options(
  'agent=s'         => '',  # Constructed at run-time.
  'arch=s'          => [qw( .tar.gz .zip )],
  'cleanup!'        => 1,  # Remove the exported directory after deployment.
  'debug'           => 0,  # Turn on/off the actual system calls.
  'deploy:s'        => '', #($ENV{USER}||$ENV{USERNAME}).'@rongo:/usr/local/cifs/intranet/mt-interest/',
  'deploy-uri=s'    => 'https://intranet.sixapart.com/mt-interest',
  'email-bcc:s'     => undef,
  'email-body=s'    => '',  # Constructed at run-time.
  'email-cc:s'      => undef,
  'email-from=s'    => ( $ENV{USER} || $ENV{USERNAME} ) .'@sixapart.com',
  'email-host=s'    => 'mail.sixapart.com',
  'email-subject=s' => '',  # Constructed at run-time.
  'export!'         => 1,  # To export or not to export. That is the question.
  'export-dir=s'    => '',  # Constructed at run-time.
  'footer=s'        => "<br/><b>SOFTWARE IS PROVIDED FOR TESTING ONLY - NOT FOR PRODUCTION USE.</b>\n",
  'footer-tmpl=s'   => 'tmpl/cms/footer.tmpl',
  'help|h'          => 0,  # Show the program usage.
  'http-user=s'     => undef,
  'http-pass=s'     => undef,
  'ldap'            => 0,  # Use LDAP (and don't initialize the database).
  'lang=s'          => $ENV{BUILD_LANGUAGE} || 'en_US',  # de,es,en_US,fr,ja,nl
  'local'           => 0,  # Command-line --option alias
  'notify:s'        => undef,  # Send email notification on completion.
  'pack=s'          => $ENV{BUILD_PACKAGE} || 'MT',  # Default package to build.
  'prod'            => 0,  # Command-line --option alias
  'qa'              => 0,  # Command-line --option alias
  'repo=s'          => 'trunk',  # Reset at runtime depending on branch,tag.
  'repo-uri=s'      => '',  #'https://intranet.sixapart.com/repos/eng',
  'stage'           => 0,  # Command-line --option alias
  'stage-dir=s'     => '/var/www/html/mt-stage',
  'stage-uri=s'     => 'http://mt.sixapart.com',
  'short-lang=s'    => '',  # Constructed at run-time.
  'stamp!'          => 1,  # Stamp the build? Default = Yes
  'stamp=s'         => $ENV{BUILD_VERSION_ID},
  'symlink!'        => 1,  # Make build symlinks when staging.
  'verbose!'        => 1,  # Express (the default) or suppress run output.
);

# Show the usage if requested.
usage() if $o{'help|h'};

# Set the BUILD_PACKAGE and BUILD_LANGUAGE variables.
$ENV{BUILD_PACKAGE}  ||= $o{'pack=s'};
$ENV{BUILD_LANGUAGE} ||= $o{'lang=s'};

# Grab our repository revision.
my $revision = repo_rev();
# Figure out what repository to use and make sure we can connect.
set_repo();

# Production builds are not dated or stamped (or symlinked if staged).
if( $o{'prod'} ) {
    $o{'stamp!'} = 0;
    $o{'symlink!'} = 0;
}
# Local builds don't deploy or cleanup after themselves.
if( $o{'local'} ) {
    $o{'cleanup!'} = 0;
}
# Staging deploys into the stage-dir.
if( $o{'stage'} ) {
    $o{'deploy:s'} = $o{'stage-dir=s'};
}

# Just make en_XX, en.
($o{'short-lang=s'} = $o{'lang=s'}) =~ s/en_[A-Z]+$/en/o;

# Create the build-stamp if one is not already defined.
unless( $o{'stamp=s'} ) {
    # Read-in the configuration variables for substitution.
    my $config = read_conf( "build/mt-dists/$o{'pack=s'}.mk" );
    my @stamp = ();
    push @stamp, $config->{PRODUCT_VERSION};
    push @stamp, $o{'short-lang=s'};
    # Add repo, date and ldap if a stamp is requested.
    if( $o{'stamp!'} ) {
        push @stamp, lc( fileparse $o{'repo=s'} );
        push @stamp, $revision;
        push @stamp, sprintf( '%04d%02d%02d', (localtime)[5]+1900, (localtime)[4]+1, (localtime)[3]);
        push @stamp, 'ldap' if $o{'ldap'};
    }
    $o{'stamp=s'} = join '-', @stamp;
    die( "ERROR: No stamp created. Cannot proceed.\n" )
        unless $o{'stamp=s'};
    # Set the BUILD_VERSION_ID, which has not been defined until now.
    $ENV{BUILD_VERSION_ID} = $o{'stamp=s'};
}

# Set the full name to use for the distribution (e.g. MT-3.3b1-fr-r12345-20061225).
$o{'export-dir=s'} = "$o{'pack=s'}-$o{'stamp=s'}";

# Summarize what we are about to do.
verbose( sprintf 'Debug is %s and system calls %s be made.',
    $o{'debug'} ? 'ON' : 'OFF', $o{'debug'} ? "WON'T" : 'WILL',
);
verbose( sprintf( 'Run options: %s', Dumper \%o ),
    "Svn uri: $o{'repo-uri=s'}",
    "Svn revision: $revision",
) if $o{'debug'};

# Get any existing distro. with the same path name, out of the way.
remove_copy() if -d $o{'export-dir=s'};
# Export the latest files.
export() if $o{'export!'};
# Add the non-production footer.
inject_footer() unless $o{'prod'};
# Call the legacy make commands from the export directory.
make();
# Create lists of the distributions.
my $distros = create_distro_list();
# Deploy the distributions.
deploy_distros( $distros ) if $o{'deploy:s'};
# Cleanup the exported files.
cleanup() if $o{'cleanup!'};
# Send email notification.
notify( $distros ) if $o{'notify:s'};

exit;

sub make {
    if( !$o{'debug'} && $o{'export!'} ) {
        chdir( $o{'export-dir=s'} ) or
            die( "ERROR: Can't cd to $o{'export-dir=s'}: $!" );
        verbose( "Change to the $o{'export-dir=s'} directory" );
    }
    verbose_command( sprintf(
        '%s build/mt-dists/make-dists --stamp=%s', $^X, $o{'export-dir=s'}
    ));
    if( !$o{'debug'} && $o{'export!'} ) {
        chdir( '..' ) or die( "ERROR: Can't cd ..: $!" );
        verbose( 'Change back to the parent directory' );
    }
}

sub cleanup {
    my $build = $o{'export-dir=s'};  # Less ugly.
    # Move the build archives up one level.
    unless( $o{'debug'} ) {
        for my $arch ( @{ $o{'arch=s'} } ) {
            move( "$build/$build$arch", "$build$arch" )
                or die( "ERROR: Can't move $build$arch: $!" );
        }
    }
    unless( $o{'debug'} ) {
        rmtree( $build ) or die( "ERROR: Can't rmtree clean-up $build: $!" );
    }
    verbose( "Cleanup: Removed $build" );
}

sub create_distro_list {
    my $distros = { path => [], url => [] };
    my %seen = ();
    for my $lang ( split( /\s*,\s*/, $o{'lang=s'} ) ) {
        for my $arch ( @{ $o{'arch=s'} } ) {
            # The filename is the distribution name plus the archive extension.
            my $filename = $o{'export-dir=s'} . $arch;
            # The distribution is the full export path and filename.
            my $dist = File::Spec->catdir( $o{'export-dir=s'}, $filename );
            # Create lists of the distribution paths.
            push @{ $distros->{path} }, $dist;
            # Add to the URL list depending on where we are deploying.
            if( $o{'stage'} ) {
                my $loc = sprintf "%s/%s/mt.cgi", $o{'stage-uri=s'}, $o{'export-dir=s'};
                push @{ $distros->{url} }, $loc unless $seen{$loc}++;
            }
            elsif( $o{'deploy:s'} =~ /:/ ) {
                my $loc = sprintf '%s/%s', $o{'deploy-uri=s'}, $filename;
                push @{ $distros->{url} }, $loc unless $seen{$loc}++;
            }
        }
    }

    return $distros;
}

sub deploy_distros {
    my $distros = shift;

    # If a colon is in the deployment string, use scp.
    if( $o{'deploy:s'} =~ /:/ ) {
        verbose_command( sprintf( '%s %s %s',
            '/usr/bin/scp', join(' ', @{ $distros->{path} }), $o{'deploy:s'}
        ) );
    }
    # Otherwise, copy the distribution file(s) to the destination.
    else {
        for my $dist ( @{ $distros->{path} } ) {
            my $dest = File::Spec->catdir(
                $o{'deploy:s'}, scalar fileparse( $dist )
            );
            copy( $dist, $dest ) or die( "ERROR: Can't copy $dist to $dest: $!" )
                unless $o{'debug'};
            verbose( "Copy $dist to $dest" );

            # Install if we are staging.
            stage_distro( $dest ) if $o{'stage'};

            # Update the staging html.
            update_html( $dest );

        }
    }

    # Make sure the deployed distros actually made it.
    unless( $o{'debug'} ) {
        for( @{ $distros->{url} } ) {
            die( "ERROR: $_ can't be resolved." )
                unless $o{'agent=s'}->head( $_ );
        }
    }
}

sub stage_distro {
    my $dest = shift;

    # We only stage tar.gz's.
    return if $dest !~ /\.gz$/o;

    die( "ERROR: Cannot stage '$dest': No such file or directory" )
        unless $o{'debug'} || -e $dest;

    my $cwd = cwd();

    chdir $o{'stage-dir=s'} or
        die( "ERROR: Can't chdir to $o{'stage-dir=s'}: $!" );
    verbose( "Change to staging root $o{'stage-dir=s'}" );

    # Do we have a current symlink?
    my $link = lc $o{'pack=s'};
    $link .= "-$o{'short-lang=s'}";
    $link .= '-ldap' if $o{'ldap'};
    my $current = '';
    $current = readlink( $link ) if $o{'symlink!'} and -e $link;
    # Remove any trailing slash.
    $current =~ s/\/$//;
    # Database named the same as the distribution (but with _'s).
    (my $current_db = $current) =~ s/[.-]/_/g;
    $current_db = 'stage_' . $current_db;

    # Grab the literal build directory name.
    my $stage_dir = fileparse( $dest, @{ $o{'arch=s'} } );

    # Remove any existing distro, with the same path name.
    if( -d $stage_dir ) {
        rmtree( $stage_dir ) or
            die( "ERROR: Can't rmtree the old $stage_dir $!" )
            unless $o{'debug'};
        verbose( "Removed: $stage_dir" );
    }

    # Drop previous.
    if( -d $current ) {
        rmtree( $current ) or
            warn( "WARNING: Can't rmtree previous '$current': $!" )
            unless $o{'debug'};
        for my $arch ( @{ $o{'arch=s'} } ) {
            unlink( "$current$arch" ) or
                warn( "WARNING: Can't unlink '$current$arch': $!\n" )
                unless $o{'debug'} or ("$current$arch" eq $dest);
        }
    }

    my $tar;
    unless( $o{'debug'} ) {
        verbose( "Extract: $dest..." );
        $tar = Archive::Tar->new( $dest );
        $tar->extract();
    }
    verbose( "Extract: $dest" );

    # Change to the distribution directory.
    chdir( $stage_dir ) or die( "ERROR: Can't chdir $stage_dir: $!" )
        unless $o{'debug'};
    verbose( "Change to $stage_dir" );

    # Our database is named the same as the distribution (but with _'s) except for LDAP.
    (my $db = $stage_dir) =~ s/[.-]/_/g;
    # Reset the db to have the same name, if we are LDAP.
    $db = 'ldap' if $o{'ldap'};
    # Append the handy staging build flag.
    $db = 'stage_' . $db;

    # Set the staging URL to a real location now.
    my $url = sprintf '%s/%s/',
        $o{'stage-uri=s'}, ($o{'symlink!'} ? $link : $stage_dir);

    # Give unto us a shiny, new config file.
    my $config = 'mt-config.cgi';
    unless( $o{'debug'} ) {
        my $fh = IO::File->new( ">$config" );
        print $fh <<CONFIG;
CGIPath $url
DefaultSiteURL http://mt.sixapart.com/blogs/
DefaultSiteRoot /var/www/html/mt-stage/blogs/
Database $db
ObjectDriver DBI::mysql
DBUser root
DebugMode 1
CONFIG
        if( $o{'ldap'} ) {
            print $fh <<CONFIG;
AuthenticationModule LDAP
AuthLDAPURL ldap://ldap.sixapart.com/dc=sixapart,dc=com
CONFIG
        }

        $fh->close();
    }
    verbose( "Write configuration to $config" );

    # Create and initialize a new database.
    unless( $o{'ldap'} ) {
        # Set up the database for this distribution.
        verbose( 'Initialize database.' );
        # XXX Use DBI ASAP.
        # Drop the previous database.
        verbose_command( "mysqladmin -f -u root drop $current_db" )
            if $current;
        # Drop a database of same name.
        if( $db ) {
            verbose_command( "mysqladmin -f -u root drop $db" );
            verbose_command( "mysqladmin -u root create $db" );
            # Run the upgrade tool.
            verbose_command( "$^X ./tools/upgrade --name Melody" );
        }
        else {
            die "ERROR: No database to stage - very odd.";
        }
    }

    # Change to the parent of the new stage directory.
    chdir( '..' ) or die( "ERROR: Can't chdir to .." )
        unless $o{'debug'};
    verbose( 'Change back to staging root' );

    # Now we re-link the stamped directory.
    if( $o{'symlink!'} ) {
        unless( $o{'debug'} ) {
            warn "Unlink $link\n";
            # Drop current symlink.
            unlink( $link ) or warn( "WARNING: Can't unlink '$link': $!" );
            # Relink the staged directory.
            symlink( "$stage_dir/", $link ) or
                warn( "WARNING: Can't symlink $stage_dir/ to $link: $!" );
        }
        verbose( "Symlink: $stage_dir/ to $link" );
    }

    unless( $o{'debug'} and $o{'symlink!'} ) {
        # Make sure we can get to our symlink.
        $url = sprintf "%s/%s/mt.cgi",
            $o{'stage-uri=s'}, $link;
        die( "ERROR: Staging $url can't be resolved." )
            unless $o{'agent=s'}->head( $url );
        # Make sure we can get to our archive file symlinks.
        for my $arch ( @{ $o{'arch=s'} } ) {
            $url = sprintf '%s/%s%s',
                $o{'stage-uri=s'}, $stage_dir, $arch;
            die( "ERROR: Staging $url can't be resolved." )
                unless $o{'agent=s'}->head( $url );
        }
    } 

    chdir( $cwd ) or die( "ERROR: Can't chdir back to $cwd: $!" );
}

sub update_html {
    my $dest = shift;

    if( !$o{'ldap'} && ( $o{'stage'} || $o{'deploy:s'} eq $o{'stage-dir=s'} )) {
         my( $stage_dir, $suffix );
        ($stage_dir, undef, $suffix) = fileparse( $dest, @{ $o{'arch=s'} } );
        my $old_html = File::Spec->catdir( $o{'stage-dir=s'}, 'build.html' );

        unless( -e $old_html ) {
            warn "WARNING: Staging HTML file, $old_html, does not exist.\n";
            return;
        }
        unless( -e $stage_dir ) {
            warn "WARNING: Distribution file, $dest, does not exist.\n";
            return;
        }
        verbose( "Update: $old_html for staging $dest" );

        unless( $o{'debug'} ) {
            warn "WARNING: $old_html does not exist" unless -e $old_html;
            my $new_html = "$old_html.new";
            my $old_fh = IO::File->new( '< ' . $old_html );
            my $new_fh = IO::File->new( '> ' . $new_html );

            while( <$old_fh> ) {
                my $line = $_;
                if( /id="($o{'pack=s'}-$o{'short-lang=s'}$suffix)"/ ) {
                    my $id = $1;
                    verbose( "Matched: id=$id" );
                    $line = sprintf qq|<a id="%s" href="%s/%s%s">%s%s<\/a>\n|,
                        $id,
                        $o{'stage-uri=s'},
                        $stage_dir, $suffix,
                        $stage_dir, $suffix;
                }
                print $new_fh $line;
            }

            $old_fh->close;
            $new_fh->close;
            move( $new_html, $old_html ) or
                die( "ERROR: Can't move $new_html, $old_html: $!" );
            verbose( "Moved: $new_html to $old_html" );
        }
    }
}

sub remove_copy {
    if( -d $o{'export-dir=s'} ) {
        verbose( "Remove existing export: $o{'export-dir=s'}" );
        rmtree( $o{'export-dir=s'} ) or
            die( "ERROR: Can't rmtree existing export $o{'export-dir=s'}: $!" )
            unless $o{'debug'};
    }
}

sub repo_rev {
    my $revision = qx{ /usr/bin/svn info | grep 'Revision' };
    chomp $revision;
    $revision =~ s/^Revision: (\d+)$/r$1/o;
    die( "ERROR: $revision" ) if $revision =~ /is not a working copy/;
    return $revision;
}

sub set_repo {
    # Grab our repository from the environment.
    $o{'repo-uri=s'} = qx{ /usr/bin/svn info | grep URL };
    chomp $o{'repo-uri=s'};
    $o{'repo-uri=s'} =~ s/^URL: (.+)$/$1/o;

    if( $o{'repo-uri=s'} =~ /http.+?(branches|tags)\/([0-9A-Za-z_.-]+)/ ) {
        # The repo is embedded in the repo uri.
        my( $key, $val ) = ( $1, $2 );
        $o{'repo=s'} = join '/', $key, $val;
    }

    # Make sure that the repository actually exists.
    $o{'agent=s'} = LWP::UserAgent->new;
    my $request = HTTP::Request->new( HEAD => $o{'repo-uri=s'} );
    $request->authorization_basic( $o{'http-user=s'}, $o{'http-pass=s'} )
        if $o{'http-user=s'} && $o{'http-pass=s'};
    my $response = $o{'agent=s'}->request( $request );
    die( "ERROR: The repoository '$o{'repo-uri=s'}' can't be resolved." )
        unless $response->is_success;
}

sub export {
    # Export the build (SVN auto-creates the directory).
    verbose_command( sprintf( '%s export --quiet %s %s',
        '/usr/bin/svn', $o{'repo-uri=s'}, $o{'export-dir=s'}
    ));
}

sub get_options {
    my %o = @_;
    # Map all literal string values to scalar references. 
    while( my( $key, $val ) = each %o ) {
       $o{$key} = \$val unless ref $val;
    }

    # Get the command-line options.
    GetOptions( %o );

    # "Un-map" the scalar references so we don't have to say, ${$o{'foo'}}.
    while( my( $key, $val ) = each %o ) {
        $o{$key} = $$val if ref $val eq 'SCALAR';
    }

    return %o;
}

sub verbose_command {
    my $command = shift;
    verbose( 'Execute:', "  $command" );
    system $command unless $o{'debug'};

    if( $? == -1 ) {
        die( "ERROR: Failed to execute: $!" );
    }
    elsif( $? & 127 ) {
        die sprintf( "ERROR: Child died with signal %d, with%s coredump\n",
            ( $? & 127 ), ( $? & 128 ? '' : 'out' )
        );
    }
    else {
#        printf "Child exited with value %d\n", $? >> 8 if $o{'verbose!'};
    }

    return $command;
}

sub notify {
    my $distros = shift;

    verbose( 'Entered: notify()' );
    return if $o{'debug'};

    $o{'email-subject=s'} = sprintf '%s build: %s',
        $o{'pack=s'}, $o{'stamp=s'};
    $o{'email-subject=s'} .=
        $o{'alpha=i'} ? ' - Alpha ' . $o{'alpha=i'} :
        $o{'beta=i'}  ? ' - Beta '  . $o{'beta=i'}  :
        $o{'prod'}    ? ' - Production'             :
        $o{'stage'}   ? ' - Staging'                :
        $o{'qa'}      ? ' - QA'                     : '';
    # If an email-cc exists, add a comma in front of the QA address.
    $o{'email-cc:s'} .= ($o{'email-cc:s'} ? ',' : '') . 'sixapart@qasource.com'
        if $o{'qa'};
    # Show the deployed URL's.
    $o{'email-body=s'} = sprintf "File URL(s):\n%s\n\n",
        join( "\n", @{ $distros->{url} } )
        if $o{'deploy:s'};
    $o{'email-body=s'} .= sprintf "Build file(s) located on %s\n%s",
        hostname(), join( "\n", @{ $distros->{path} } )
        if $o{'qa'} or !$o{'cleanup!'};

    my $smtp = Net::SMTP->new(
        $o{'email-host=s'},
        Debug => $o{'debug'},
    );

    $smtp->mail( $o{'email-from=s'} );
    $smtp->to( $o{'notify:s'} );
    $smtp->cc( $o{'email-cc:s'} ) if $o{'email-cc:s'};
    $smtp->bcc( $o{'email-bcc:s'} ) if $o{'email-bcc:s'};

    $smtp->data();
    $smtp->datasend( "To: $o{'notify:s'}\n" );
    $smtp->datasend( "Cc: $o{'email-cc:s'}\n" ) if $o{'email-cc:s'};
    $smtp->datasend( "Subject: $o{'email-subject=s'}\n" );
    $smtp->datasend( "\n" );
    $smtp->datasend( "$o{'email-body=s'}\n" );
    $smtp->dataend();

    $smtp->quit;

    verbose( "Email sent to $o{'notify:s'}" );
}

sub read_conf {
    my @files = @_;
    my $config = {};

    for my $file ( @files ) {
        next unless -e $file;
        warn "Parse: config $file file...\n";
        my $fh = IO::File->new( '< ' . $file );

        while( <$fh> ) {
            # Skip comment lines.
            next if /^\s*#/;
            # Skip blank lines.
            next if /^\s*$/;
            # Capture a configuration pair.
            /^\s*(.*?)\s*=\s*(.*)\s*$/ or next;
            my( $k, $v ) = ( $1, $2 );
            $config->{$k} = $v;
        }

        $fh->close;
    }

    return $config;
}

sub inject_footer {
    my $file = File::Spec->catdir( $o{'export-dir=s'},  $o{'footer-tmpl=s'} );
    verbose( "Entered: inject_footer with $file" );
    return 'DEBUG' if $o{'debug'};
    die( "ERROR: File $file does not exist: $!" ) unless -e $file;

    # Slurp-in the contents of the file.
    local $/;
    my $fh = IO::File->new( $file );
    my $contents = <$fh>;
    $fh->close();

    $contents =~ s/Reserved.\n/Reserved.\n$o{'footer=s'}/;

    # Rewrite the file with the injected footer.
    $fh = IO::File->new( "> $file" );
    print $fh $contents;
    $fh->close();
}

sub verbose {
    return unless $o{'verbose!'};
    print join( "\n", @_ ), "\n";
}

sub usage {
    # Emit the helpful usage message and then bail out.
    print <<USAGE;

 MT export build deployment notification automation.

 Examples:

 cd \$MT_DIR
 svn up
 export BUILD_PACKAGE=MT
 export BUILD_LANGAGE=ja
 export BUILD_VERSION_ID=3.3-ja
 perl $0 --help
 perl $0 --debug
 perl $0 --local
 perl $0 --qa
 perl $0 --alpha=1
 perl $0 --beta=41
 perl $0 --prod

Please see the full documentation with defaults and command overrides at:
https://intranet.sixapart.com/wiki/index.php/Movable_Type:MT_Export-Deploy

USAGE
    exit;
}

__END__

=head1 NAME

MovableType Export/Make/Deploy/Notify Automation

=head1 DESCRIPTION

Please see
https://intranet.sixapart.com/wiki/index.php/Movable_Type:MT_Export-Deploy
for full documentation.

=head1 REQUIRES

Currently, using this program requires 6A check-in rights to the
public subversion repository.

=cut
