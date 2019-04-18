# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package Build;
our $VERSION = '0.09';

=head1 NAME

Build - Movable Type build functionality

=head1 SYNOPSIS

 cd $MT_DIR
 git pull
 perl build/exportmt.pl --help
 perl build/exportmt.pl --debug
    # --alpha=1
    # --beta=42
    # --local
    # --make
    # --plugin=Foo --plugin=Bar
    # --prod
    # --qa
    # --stage

=head1 DESCRIPTION

A C<Build> object contains the internal routines needed to build
Movable Type distributions in multiple languages.

=cut

use strict;
use warnings;
use Cwd;
use File::Basename;
use File::Copy;
use File::Path;
use File::Spec;
use Getopt::Long;
use IO::File;
use Sys::Hostname;

sub new {
    my $class = shift;
    my $self  = {};
    bless $self, $class;
    return $self;
}

sub get_options {
    my $self = shift;
    my %o    = (
        'agent=s'  => '',    # Constructed at run-time.
        'alpha=s'  => 0,     # Alpha build number.
        'arch=s@'  => undef, # Constructed below.
        'beta=s'   => 0,     # Beta build number.
        'rc=s'     => 0,     # Release candidate build number.
        'cleanup!' => 1,     # Remove the exported directory after deployment.
        'date!'    => 1,     # Toggle date stamping.
        'datetime!'    => 0,       # Toggle datetime stamping.
        'debug'        => 0,       # Turn on/off the actual system calls.
        'deploy:s'     => '',
        'deploy-uri=s' => '',
        'build!'       => 1,       # Build distribution files?
        'email-bcc:s'  => undef,
        'email-body=s' => '',      # Constructed at run-time.
        'email-cc:s'   => undef,
        'email-from=s' => ( $ENV{USER} || $ENV{USERNAME} ),
        'email-host=s' => 'localhost',
        'email-subject=s' => '',       # Constructed at run-time.
        'export!'         => 0,        # Toggle export package
        'export-dir=s'    => undef,    # Export directory
        'footer=s' =>
            "<br/><b>SOFTWARE IS PROVIDED FOR TESTING ONLY - NOT FOR PRODUCTION USE.</b>\n",
        'footer-tmpl=s' => 'tmpl/cms/include/copyright.tmpl',
        'help|h'      => 0,    # Show the program usage.
        'license=s'   => undef,
        'http-user=s' => undef,
        'http-pass=s' => undef,
        'ldap'        => 0,    # Use LDAP (and don't initialize the database).
        'lang=s' => $ENV{BUILD_LANGUAGE} || 'en_US',    # de,es,en_US,fr,ja,nl
        'language=s@' => undef,    # Constructed below.
        'lang-stamp!' => 1,        # Toggle language stampimg
        'local'       => 0,        # Command-line --option alias
        'make' => 0,    # Command-line --option alias for simple legacy `make`
        'notify:s'  => undef,    # Send email notification on completion.
        'pack=s'    => undef,    # Constructed at run-time.
        'plugin=s@' => undef,    # Plugin list
        'plugin-uri=s' => 'http://github.com/movabletyp',
        'prod'       => 0,                     # Command-line --option alias
        'prod-dir=s' => 'Production_Builds',
        'qa'         => 0,                     # Command-line --option alias
        'rel_num=s'  => undef,                 # Release number
        'repo=s'     => 'trunk',   # Reset at runtime depending on branch,tag.
        'repo-uri=s' => '',
        'rev!'       => 1,         # Toggle revision stamping.
        'revision=s' => undef,     # Constructed at run-time.
        'revision_hash=s' => undef,    # Constructed at run-time.
        'rpm!'            => 0,        # Make rpm package
        'stage'           => 0,        # Command-line --option alias
        'stage-dir=s'     => '',
        'stage-uri=s'     => '',
        'short-lang=s'    => '',       # Constructed at run-time.
        'stamp=s' => $ENV{BUILD_VERSION_ID},
        'symlink!'   => 1, # Make build symlinks when staging.
        'verbose!'   => 1, # Express (the default) or suppress run output.
        'workspace!' => 1, # To export or not to export. That is the question.
        'workspace-dir=s'    => '',    # Constructed at run-time.
        'versions-trailer=s' => '',
        @_,
    );

    # Map all literal string values to scalar references because
    # Getopt::Long wants it that way.
    while ( my ( $key, $val ) = each %o ) {
        $o{$key} = \$val unless ref $val;
    }

    GetOptions(%o);    # Get the command-line options.

    # "Un-map" the references so we don't have to say, ${$self->{'foo'}}.
    while ( my ( $key, $val ) = each %o ) {
        $self->{$key} = $$val
            if ref($val) eq 'SCALAR' || ref($val) eq 'REF';
    }

    # Make sure we have an archive file type list.
    $self->{'arch=s@'} ||= [qw( .tar.gz .zip )];

    # Make the plugins an empty list unless defined.
    $self->{'plugin=s@'} ||= [];

    # Construct the list of languages to build.
    $self->{'lang=s'} = 'de,en_US,es,fr,ja,nl'
        if lc( $self->{'lang=s'} ) eq 'all';
    push @{ $self->{'language=s@'} }, split /,/, $self->{'lang=s'};
}

sub setup {
    my $self = shift;
    my %args = @_;

    my $prereq = 'ExtUtils::Install 1.37_02';
    eval "use $prereq";
    die("ERROR: Can't handle @{ $self->{'plugin=s@'} } plugin installation: $prereq needed."
    ) if $@ && @{ $self->{'plugin=s@'} };

    # Do we have SSL support?
    $prereq = 'Crypt::SSLeay';
    eval "require $prereq;";
    warn("WARNING: $prereq not found. Can't use SSL.\n") if $@;

    # Replace the current language if given one as an argument.
    $self->{'lang=s'} = $args{language} if $args{language};

    # Strip the dialect portion of the language code (ab_CD into ab).
    ( $self->{'short-lang=s'} = $self->{'lang=s'} )
        =~ s/([a-z]{2})_[A-Z]{2}$/$1/o;

    $self->{'pack=s'} ||= 'MTOS';
    $ENV{BUILD_PACKAGE}  = $self->{'pack=s'};
    $ENV{BUILD_LANGUAGE} = $self->{'lang=s'};

    # Handle option aliases.
    if (   $self->{'prod'}
        or $self->{'alpha=s'}
        or $self->{'beta=s'}
        or $self->{'rc=s'} )
    {
        $self->{'symlink!'} = 0;
    }
    if ( $self->{'make'} ) {
        $self->{'build!'}     = 0;
        $self->{'workspace!'} = 0;
    }
    if ( $self->{'local'} ) {
        $self->{'workspace!'} = 0;
    }
    if ( $self->{'stage'} ) {
        $self->{'deploy:s'} = $self->{'stage-dir=s'};
    }

    # Grab our repository revision.
    $self->{'revision=s'}      = repo_rev('r');
    $self->{'revision_hash=s'} = repo_rev_hash();

    # Set revision number as release number
    $self->{'rel_num=s'} = repo_rev()
        unless defined $self->{'rel_num=s'};

    # Figure out what repository to use.
    $self->set_repo();

    # Create the build-stamp if one is not already defined.
    if ( !$self->{'stamp=s'} || $args{language} ) {

        # Read-in the configuration variables for substitution.
        my $config = $self->read_conf( "build/mt-dists/default.mk",
            "build/mt-dists/$self->{'pack=s'}.mk" );
        $self->{'license=s'} ||= $config->{LICENSE};
        my @stamp = ();
        if ( $self->{'stamp=s'} ) {
            push @stamp, $self->{'stamp=s'};
        }
        else {
            my $v = $config->{PRODUCT_VERSION};
            if ( exists $self->{'rel_num=s'} ) {
                $v .= ".$self->{'rel_num=s'}"
                    if $self->{'rel_num=s'}
                    || ( $self->{'export!'} && $self->{'export-dir=s'} );
            }
            if ( $self->{'alpha=s'} || $self->{'beta=s'} || $self->{'rc=s'} )
            {
                $v .= (
                      $self->{'alpha=s'} ? "a$self->{'alpha=s'}"
                    : $self->{'beta=s'}  ? "b$self->{'beta=s'}"
                    : $self->{'rc=s'}    ? "rc$self->{'rc=s'}"
                    :                      ''
                );
            }
            push @stamp, $v;
        }
        push @stamp, $self->{'short-lang=s'}
            if $self->{'lang-stamp!'};

        # Add repo, date and ldap to the stamp if we are not production.
        unless ( $self->{'prod'} ) {
            if ( $self->{'rev!'} ) {
                push @stamp, lc( fileparse $self->{'repo=s'} );
                push @stamp, $self->{'revision=s'};
                push @stamp, $self->{'revision_hash=s'};
            }

            my ($sec,  $min,  $hour, $mday, $mon,
                $year, $wday, $yday, $isdst
            ) = localtime();
            if ( $self->{'date!'} ) {
                push @stamp,
                    sprintf( '%04d%02d%02d',
                    ( $year + 1900, $mon + 1, $mday ) );
            }
            elsif ( $self->{'datetime!'} ) {
                push @stamp,
                    sprintf( '%04d%02d%02d%02d%02d%02d',
                    ( $year + 1900, $mon + 1, $mday, $hour, $min, $sec ) );
            }

            # Add -ldap to distingush them from Melody Nelson builds.
            push @stamp, 'ldap' if $self->{'ldap'};
        }
        $self->{'stamp=s'} = join '-', @stamp;
        die("ERROR: No stamp created. Cannot proceed.\n")
            unless $self->{'stamp=s'};
    }

    # Set the BUILD_VERSION_ID, which has not been defined until now.
    $ENV{BUILD_VERSION_ID}       ||= $self->{'stamp=s'};
    $ENV{BUILD_RELEASE_NUMBER}   ||= $self->{'rel_num=s'};
    $ENV{BUILD_VERSIONS_TRAILER} ||= $self->{'versions-trailer=s'};

# Set the full name to use for the distribution (e.g. MT-3.3b1-fr-r12345-20061225).
    $self->{'workspace-dir=s'} = "$self->{'pack=s'}-$self->{'stamp=s'}"
        unless $self->{'workspace-dir=s'};
}

sub make {
    my $self = shift;
    $self->verbose('Entered make()');
    return if $self->{'debug'};

    if ( !$self->{'debug'} && $self->{'workspace!'} ) {
        chdir( $self->{'workspace-dir=s'} )
            or die("ERROR: Can't cd to $self->{'workspace-dir=s'}: $!");
        $self->verbose("Change to the $self->{'workspace-dir=s'} directory");
    }

    if ( $self->{'build!'} ) {
        $self->verbose_command(
            sprintf(
                '%s build/mt-dists/make-dists --package=%s --language=%s --stamp=%s %s %s %s --license=%s',
                $^X,
                $self->{'pack=s'},
                $self->{'lang=s'},
                $self->{'workspace-dir=s'},
                ( $self->{'verbose!'} ? '' : '--silent' ),
                ( $self->{'rpm!'}     ? '' : '--rpm' ),
                (   $self->{'export!'} && $self->{'export-dir=s'}
                    ? '--export-dir='
                        . $self->{'export-dir=s'}
                        . ' --export-prefix='
                        . $self->{'versions-trailer=s'}
                    : ''
                ),
                $self->{'license=s'} || '',
            )
        );
    }
    else {
        $self->verbose_command('make');
    }

    if ( !$self->{'debug'} && $self->{'workspace!'} ) {
        chdir('..') or die("ERROR: Can't cd ..: $!");
        $self->verbose('Change back to the parent directory');
    }
}

sub cleanup {
    my $self = shift;
    $self->verbose('Entered cleanup()');
    return unless $self->{'cleanup!'};

    my $build = $self->{'workspace-dir=s'};    # Less ugly.
    if ( !$self->{'debug'} && $self->{'workspace!'} ) {

      # Move the build archives out of the soon-to-be-removed build directory.
        for my $arch ( @{ $self->{'arch=s@'} } ) {
            move( "$build/$build$arch", "$build$arch" )
                or die("ERROR: Can't move $build/$build$arch: $!");
        }

        rmtree($build) or die("ERROR: Can't rmtree clean-up $build: $!");
    }
    $self->verbose("Cleanup: Remove $build");
}

sub create_distro_list {
    my $self = shift;

    my $distros = { path => [], url => [] };

    my %seen = ();

    for my $lang ( split( /\s*,\s*/, $self->{'lang=s'} ) ) {
        for my $arch ( @{ $self->{'arch=s@'} } ) {

           # The filename is the distribution name plus the archive extension.
            my $filename = $self->{'workspace-dir=s'} . $arch;

            # The distribution is the full export path and filename.
            my $dist
                = File::Spec->catdir( $self->{'workspace-dir=s'}, $filename );

            # Create lists of the distribution paths.
            push @{ $distros->{path} }, $dist;

            # Add to the URL list depending on where we are deploying.
            if ( $self->{'stage'} ) {

                # Magically use the internal production folder if it exists.
                my $loc
                    = $self->{'prod'}
                    && $self->{'prod-dir=s'}
                    && $dist =~ /$self->{'prod-dir=s'}/
                    ? sprintf( "%s/%s/%s/mt.cgi",
                    $self->{'stage-uri=s'},
                    $self->{'prod-dir=s'}, $self->{'workspace-dir=s'} )
                    : sprintf( "%s/%s/mt.cgi",
                    $self->{'stage-uri=s'},
                    $self->{'workspace-dir=s'} );
                push @{ $distros->{url} }, $loc unless $seen{$loc}++;
            }
            elsif ( $self->{'deploy:s'} =~ /:/ ) {
                my $loc = sprintf '%s/%s', $self->{'deploy-uri=s'}, $filename;
                push @{ $distros->{url} }, $loc unless $seen{$loc}++;
            }
        }
    }

    return $distros;
}

sub deploy_distros {
    my $self    = shift;
    my $distros = shift;

    return unless $self->{'deploy:s'};

    # If a colon is in the deployment string, use scp.
    if ( $self->{'deploy:s'} =~ /:/ ) {
        $self->verbose_command(
            sprintf( '%s %s %s',
                'scp', join( ' ', @{ $distros->{path} } ),
                $self->{'deploy:s'} )
        );
    }

    # Otherwise, copy the distribution file(s) to the destination.
    else {
        for my $dist ( @{ $distros->{path} } ) {
            my $dest = '';

            # Magically use the internal production folder if it exists.
            if (   $self->{'prod'}
                && $self->{'stage'}
                && $self->{'prod-dir=s'}
                && -e File::Spec->catdir(
                    $self->{'stage-dir=s'},
                    $self->{'prod-dir=s'}
                )
                )
            {
                $dest
                    = File::Spec->catdir( $self->{'deploy:s'},
                    $self->{'prod-dir=s'}, scalar fileparse($dist),
                    );
            }
            else {
                $dest
                    = File::Spec->catdir( $self->{'deploy:s'},
                    scalar fileparse($dist),
                    );
            }

            copy( $dist, $dest )
                or die("ERROR: Can't copy $dist to $dest: $!")
                unless $self->{'debug'};
            $self->verbose("Copy $dist to $dest");

            # Install the build if we are staging.
            $self->stage_distro($dest) if $self->{'stage'};

            # Update the build summary page.
            $self->update_html($dest);

        }
    }

    # Make sure the deployed distros actually made it.
    unless ( $self->{'debug'} ) {
        for ( @{ $distros->{url} } ) {
            die("ERROR: $_ can't be resolved.")
                unless $self->{'agent=s'}->head($_);
        }
    }
}

sub stage_distro {
    my $self = shift;
    my $dest = shift;

    # We only stage tar.gz's.
    return if $dest !~ /\.gz$/o;

    die("ERROR: Cannot stage '$dest': No such file or directory")
        unless $self->{'debug'} || -e $dest;

    my $cwd = cwd();

    my $prod
        = $self->{'prod'}
        && $self->{'stage'}
        && $self->{'prod-dir=s'}
        && -e File::Spec->catdir( $self->{'stage-dir=s'},
        $self->{'prod-dir=s'} );

    # Add the prod-dir to the staged directory if appropriate.
    my $stage_root = $self->{'stage-dir=s'};
    $stage_root
        = File::Spec->catdir( $self->{'stage-dir=s'}, $self->{'prod-dir=s'} )
        if $prod;

    chdir $stage_root
        or die("ERROR: Can't chdir to $stage_root $!");
    $self->verbose("Change to staging root $stage_root");

    # Do we have a current symlink?
    my $link = lc( fileparse $self->{'repo=s'} );
    $link .= "-$self->{'short-lang=s'}";
    $link .= '-ldap' if $self->{'ldap'};
    my $current = '';
    $current = readlink($link) if $self->{'symlink!'} and -e $link;

    # Remove any trailing slash.
    $current =~ s/\/$//;

    # Database named the same as the distribution (but with _'s).
    ( my $current_db = $current ) =~ s/[.-]/_/g;
    $current_db = 'stage_' . $current_db;

    # Set the stage_dir to the literal build directory name.
    my $stage_dir = fileparse( $dest, @{ $self->{'arch=s@'} } );

    # Reset the staging root directory.
    $stage_root = File::Spec->catdir( $stage_root, $stage_dir );

    # Remove any existing distro, with the same path name.
    if ( -d $stage_root ) {
        rmtree($stage_root)
            or die("ERROR: Can't rmtree the old $stage_root $!")
            unless $self->{'debug'};
        $self->verbose("Remove: $stage_root");
    }

    # Drop previous.
    if ( -d $current ) {
        rmtree($current)
            or warn("WARNING: Can't rmtree previous '$current': $!")
            unless $self->{'debug'};
        for my $arch ( @{ $self->{'arch=s@'} } ) {
            unlink("$current$arch")
                or warn("WARNING: Can't unlink '$current$arch': $!\n")
                unless $self->{'debug'}
                or ( "$current$arch" eq $dest );
        }
    }

    # Un-tar the distribution.
    unless ( $self->{'debug'} ) {
        $self->verbose("Extract: $dest...");

        # Temporarily switching to using tar utility for this
        # since Archive::Tar is croaking on one of our files.
        `tar xf $dest`;

        # my $tar = Archive::Tar->new( $dest );
        # $tar->extract();
    }
    $self->verbose("Extract: $dest");

    # Change to the distribution directory.
    chdir($stage_root)
        or die("ERROR: Can't chdir $stage_root $!")
        unless $self->{'debug'};
    $self->verbose("Change to $stage_root");

# Make sure there is a user-style so we don't barf unneccessarily into the error_log.
    open STYLE, "> user_styles.css"
        or die("ERROR: Can't touch user_styles.css $@");
    close STYLE;

# Our database is named the same as the distribution (but with _'s) except for LDAP.
    ( my $db = $stage_dir ) =~ s/[.-]/_/g;

    # Reset the db to have the same name, if we are LDAP.
    $db = 'ldap' if $self->{'ldap'};

    # Append the handy staging build flag.
    $db = 'stage_' . $db;

    # Set the staging URL to a real location now.
    my $url = sprintf '%s/%s/', $self->{'stage-uri=s'},
        (
          $prod ? File::Spec->catdir( $self->{'prod-dir=s'}, $stage_dir )
        : $self->{'symlink!'} ? $link
        :                       $stage_dir
        );

    # Give unto us a shiny, new config file.
    my $config = 'mt-config.cgi';
    unless ( $self->{'debug'} ) {
        my $fh = IO::File->new(">$config");
        print $fh <<CONFIG;
CGIPath $url
# DefaultSiteURL http://example.com/blogs/
# DefaultSiteRoot /var/www/html/blogs/
Database $db
ObjectDriver DBI::mysql
DBUser root
DebugMode 2
CONFIG
        if ( $self->{'ldap'} ) {
            print $fh <<CONFIG;
AuthenticationModule LDAP
# AuthLDAPURL ldap://ldap.example.com/dc=example,dc=com
CONFIG
        }

        $fh->close();
    }
    $self->verbose("Write configuration to $config");

    # Create and initialize a new database.
    unless ( $self->{'ldap'} ) {

        # Set up the database for this distribution.
        $self->verbose('Initialize database.');

        # XXX Use DBI ASAP.
        # Drop the previous database.
        $self->verbose_command("mysqladmin -f -u root drop $current_db")
            if $current;

        # Drop a database of same name.
        if ($db) {
            $self->verbose_command("mysqladmin -f -u root drop $db");
            $self->verbose_command("mysqladmin -u root create $db");

            # Run the upgrade tool.
            $self->verbose_command("$^X ./tools/upgrade --name Melody");
        }
        else {
            die "ERROR: No database to stage - very odd.";
        }
    }

    # Change to the parent of the new stage directory.
    chdir('..') or die("ERROR: Can't chdir to ..")
        unless $self->{'debug'};
    $self->verbose('Change back to staging root');

    # Now we re-link the stamped directory.
    if ( $self->{'symlink!'} ) {
        unless ( $self->{'debug'} ) {
            print "Unlink $link\n";

            # Drop current symlink.
            unlink($link) or warn("WARNING: Can't unlink '$link': $!");

            # Relink the staged directory.
            symlink( "$stage_dir/", $link )
                or warn("WARNING: Can't symlink $stage_dir/ to $link: $!");
        }
        $self->verbose("Symlink: $stage_dir/ to $link");
    }

    unless ( $self->{'debug'} or $self->{'symlink!'} ) {

        # Make sure we can get to our symlink.
        $url = sprintf "%s/%s/mt.cgi", $self->{'stage-uri=s'}, $link;
        die("ERROR: Staging $url can't be resolved.")
            unless $self->{'agent=s'}->head($url);

        # Make sure we can get to our archive file symlinks.
        for my $arch ( @{ $self->{'arch=s@'} } ) {
            $url = sprintf '%s/%s%s',
                $self->{'stage-uri=s'}, $stage_dir, $arch;
            die("ERROR: Staging $url can't be resolved.")
                unless $self->{'agent=s'}->head($url);
        }
    }

    chdir($cwd) or die("ERROR: Can't chdir back to $cwd: $!");
}

sub update_html {
    my $self = shift;
    $self->verbose('Entered update_html()');
    my $dest = shift;

    if (   $self->{'symlink!'}
        && !$self->{'prod'}
        && !$self->{'ldap'}
        && ( $self->{'stage'}
            || ( $self->{'deploy:s'} eq $self->{'stage-dir=s'} ) )
        )
    {
        my ( $stage_dir, $suffix );
        ( $stage_dir, undef, $suffix )
            = fileparse( $dest, @{ $self->{'arch=s@'} } );
        my $lang   = $self->{'short-lang=s'};
        my $branch = $self->{'repo=s'};
        $branch =~ s!^(branches|tags)/!!;
        my $revision = $self->{'revision=s'};

        my $old_html
            = File::Spec->catdir( $self->{'stage-dir=s'}, 'build.html' );

        unless ( -e $old_html ) {
            warn "WARNING: Staging HTML file, $old_html, does not exist.\n";
            return;
        }
        unless ( -e $stage_dir ) {
            warn "WARNING: Distribution file, $dest, does not exist.\n";
            return;
        }

        my $id = lc( fileparse $self->{'repo=s'} ) . "-$lang$suffix";
        $self->verbose("Update: $old_html with $id for $dest");

        my %set;
        unless ( $self->{'debug'} ) {
            warn "WARNING: $old_html does not exist" unless -e $old_html;
            my $new_html = "$old_html.new";
            my $old_fh   = IO::File->new( '< ' . $old_html );
            my $new_fh   = IO::File->new( '> ' . $new_html );

            while ( my $line = <$old_fh> ) {

                # build replacement
                if ( $line
                    =~ m!^(\s*).*?/\*\s*(build|branch):\s*(\S+?)\s*\*/! )
                {
                    my $spacer = $1;
                    my $type   = $2;
                    my $val    = $3;
                    if ( $type eq 'build' ) {
                        if ( $val eq $id ) {
                            $self->verbose("Matched $type: id=$id");
                            $set{$type} = 1;
                            $line
                                = sprintf
                                qq|$spacer'$id': '%s/%s%s', /* build: $id */\n|,
                                $self->{'stage-uri=s'},
                                $stage_dir, $suffix;
                        }
                    }
                    elsif ( $branch && ( $type eq 'branch' ) ) {
                        if ( $val eq $branch ) {
                            $self->verbose("Matched $type: branch=$branch");
                            $set{$type} = 1;
                            $line = sprintf
                                qq|$spacer'$branch': '$revision', /* branch: $branch */\n|;
                        }
                    }
                }
                if ( $line =~ m!^(\s*)/\*\s*new-(build|branch)\s*\*/! ) {

                    # create a new release
                    my $spacer = $1;
                    my $type   = $2;
                    unless ( $set{$type} ) {
                        if ( $type eq 'build' ) {
                            $set{$type} = 1;
                            $self->verbose("Writing new build: id=$id");
                            my $new_line
                                = sprintf
                                qq|$spacer'$id': '%s/%s%s', /* build: $id */\n|,
                                $self->{'stage-uri=s'},
                                $stage_dir, $suffix;
                            $line = $new_line . $line;
                        }
                        elsif ( $branch && ( $type eq 'branch' ) ) {
                            $set{$type} = 1;
                            $self->verbose(
                                "Writing new branch: branch=$branch");
                            my $new_line = sprintf
                                qq|$spacer'$branch': '$revision', /* branch: $branch */\n|;
                            $line = $new_line . $line;
                        }
                    }
                }

                print $new_fh $line;
            }

            $old_fh->close;
            $new_fh->close;
            move( $new_html, $old_html )
                or die("ERROR: Can't move $new_html, $old_html: $!");
            $self->verbose("Move: $new_html to $old_html");
        }
    }
}

sub remove_copy {
    my $self = shift;
    if ( -d $self->{'workspace-dir=s'} ) {
        $self->verbose("Remove existing export: $self->{'workspace-dir=s'}");
        rmtree( $self->{'workspace-dir=s'} )
            or die(
            "ERROR: Can't rmtree existing export $self->{'workspace-dir=s'}: $!"
            ) unless $self->{'debug'};
    }
}

sub repo_rev {
    my ($prefix) = @_;
    $prefix ||= '';
    my $revision = qx{ git log --pretty=format:'' | wc -l };
    chomp $revision;
    $revision =~ s/\s*(.*)/$prefix$1/;
    die("ERROR: $revision") if $revision =~ /is not a working copy/;
    return $revision;
}

sub repo_rev_hash {
    my $revision = qx{ git log -1 | grep commit };
    chomp $revision;
    $revision =~ s/commit (.*)/$1/;
    die("ERROR: $revision") if $revision =~ /is not a working copy/;
    return substr( $revision, 0, 8 );
}

sub set_repo {
    my $self = shift;

    # Grab our repository from the environment.
    $self->{'repo-uri=s'} = qx{ git config remote.origin.url };
    chomp $self->{'repo-uri=s'};

    my $repo = qx{ git branch | grep '* ' };
    chomp $repo;
    $repo =~ s/^\*\s(.*)$/$1/;
    $self->{'repo=s'} = $repo;
}

sub export {
    my $self = shift;
    return unless $self->{'workspace!'};

    # NOTE Subversion auto-creates the export directory.
    $self->verbose_command(
        sprintf(
            'git clone --quiet %s %s',
            $self->{'repo-uri=s'}, $self->{'workspace-dir=s'}
        )
    );
}

sub plugin_export {
    my $self = shift;
    return unless $self->{'plugin=s@'};

    # Change to the export directory, if we are exporting.
    chdir( $self->{'workspace-dir=s'} )
        or die("ERROR: Can't cd to $self->{'workspace-dir=s'}: $!")
        if !$self->{debug} && $self->{'workspace!'};

    # Export the plugins.
    for my $plugin ( @{ $self->{'plugin=s@'} } ) {
        my $uri  = "$self->{'plugin-uri=s'}/$plugin";
        my $path = "plugins/$plugin";
        $self->verbose_command(
            sprintf( 'git clone --quiet %s %s', $uri, $path ) );
        die "ERROR: Plugin not exported: $uri"
            unless $self->{debug} || -d $path;

        # Handle the plugin subdirectory.
        $path = 'plugins';
        my $subdir = "plugins/$plugin/$path";
        if ( -d $subdir && !$self->{debug} ) {
            $self->dirmove( $subdir, $path )
                or die("Can't move $subdir to $path: $!");
            $self->verbose("Moved $subdir to $path");
        }

        # Handle the mt-static subdirectory.
        $path   = "mt-static/plugins";
        $subdir = "plugins/$plugin/$path";
        if ( -d $subdir && !$self->{debug} ) {
            $self->dirmove( $subdir, $path )
                or die("Can't move directory $subdir to $path $!");
            $self->verbose("Moved $subdir to $path");
        }

        $path = "plugins/$plugin";
        rmtree($path)
            or die("Can't rmtree() $path: $!")
            unless $self->{debug};
        $self->verbose("Removed $path");
    }

    chdir('..')
        or die("ERROR: Can't cd ..: $!")
        if !$self->{debug} && $self->{'workspace!'};
}

sub dirmove {
    my $self  = shift;
    my @paths = @_;
    my $dest  = pop @paths;
    for my $path (@paths) {

        #        $self->verbose( "Moving $path to $dest..." );
        eval { install( { $path => $dest } ) };
    }
    return 1;
}

sub verbose_command {
    my $self    = shift;
    my $command = shift;
    $self->verbose("Execute: $command");
    system $command unless $self->{'debug'};

    if ( $? == -1 ) {
        die("ERROR: Failed to execute: $!");
    }
    elsif ( $? & 127 ) {
        die sprintf(
            "ERROR: Child died with signal %d, with%s coredump\n",
            ( $? & 127 ),
            ( $? & 128 ? '' : 'out' )
        );
    }
    else {

#        printf "Child exited with value %d\n", $? >> 8 if $self->{'verbose!'};
    }

    return $command;
}

sub notify {
    my $self    = shift;
    my $distros = shift;

    return unless $self->{'notify:s'};
    $self->verbose('Entered notify()');
    return if $self->{'debug'};

    $self->{'email-subject=s'} = sprintf '%s build: %s',
        $self->{'pack=s'}, $self->{'stamp=s'};
    $self->{'email-subject=s'} .=
          $self->{'alpha=i'} ? ' - Alpha ' . $self->{'alpha=i'}
        : $self->{'beta=i'}  ? ' - Beta ' . $self->{'beta=i'}
        : $self->{'prod'}    ? ' - Production'
        : $self->{'stage'}   ? ' - Staging'
        : $self->{'qa'}      ? ' - QA'
        :                      '';

    # If an email-cc exists, add a comma in front of the QA address.
    # $self->{'email-cc:s'} .= ($self->{'email-cc:s'} ? ',' : '')
    #     if $self->{'qa'};
    # Show the deployed URL's.
    $self->{'email-body=s'} = sprintf "File URL(s):\n%s\n\n",
        join( "\n", @{ $distros->{url} } )
        if $self->{'deploy:s'};
    $self->{'email-body=s'} .= sprintf "Build file(s) located on %s\n%s",
        hostname(), join( "\n", @{ $distros->{path} } )
        if $self->{'qa'}
        or !$self->{'cleanup!'};

    require Net::SMTP;
    my $smtp
        = Net::SMTP->new( $self->{'email-host=s'}, Debug => $self->{'debug'},
        );

    $smtp->mail( $self->{'email-from=s'} );
    $smtp->to( $self->{'notify:s'} );
    $smtp->cc( $self->{'email-cc:s'} )   if $self->{'email-cc:s'};
    $smtp->bcc( $self->{'email-bcc:s'} ) if $self->{'email-bcc:s'};

    $smtp->data();
    $smtp->datasend("To: $self->{'notify:s'}\n");
    $smtp->datasend("Cc: $self->{'email-cc:s'}\n") if $self->{'email-cc:s'};
    $smtp->datasend("Subject: $self->{'email-subject=s'}\n");
    $smtp->datasend("\n");
    $smtp->datasend("$self->{'email-body=s'}\n");
    $smtp->dataend();

    $smtp->quit;

    $self->verbose("Email sent to $self->{'notify:s'}");
}

sub read_conf {
    my $self   = shift;
    my @files  = @_;
    my $config = {};

    for my $file (@files) {
        next unless -e $file;
        print "Parse: config $file file...\n";
        my $fh = IO::File->new( '< ' . $file );

        while (<$fh>) {

            # Skip comment lines.
            next if /^\s*#/;

            # Skip blank lines.
            next if /^\s*$/;

            # Capture a configuration pair.
            /^\s*(.*?)\s*=\s*(.*)\s*$/ or next;
            my ( $k, $v ) = ( $1, $2 );
            $config->{$k} = $v;
        }

        $fh->close;
    }

    return $config;
}

sub inject_footer {
    my $self = shift;

    # Do not inject the non-production footer if we are running in
    # debug mode, doing a (local) make or are building an alpha/beta
    # version.
    return
           if $self->{'debug'}
        || $self->{'make'}
        || ( $self->{'prod'}
        && !( $self->{'beta=s'} || $self->{'alpha=s'} || $self->{'rc=s'} ) );
    $self->verbose('Entered inject_footer()');
    return if $self->{'prod'} || $self->{'debug'} || $self->{'make'};

    my $file
        = $self->{'workspace!'}
        ? File::Spec->catdir( $self->{'workspace-dir=s'},
        $self->{'footer-tmpl=s'} )
        : $self->{'footer-tmpl=s'};
    die("ERROR: File $file does not exist: $!") unless -e $file;

    # Slurp-in the contents of the file.
    local $/;
    my $fh       = IO::File->new($file);
    my $contents = <$fh>;
    $fh->close();

    return if $contents =~ m/\Q$self->{'footer=s'}\E/;

    $contents =~ s/Reserved.\n/Reserved.\n$self->{'footer=s'}/;

    # Rewrite the file with the injected footer.
    $fh = IO::File->new("> $file");
    print $fh $contents;
    $fh->close();
}

sub verbose {
    my $self = shift;
    return unless $self->{'verbose!'};
    print join( "\n", @_ ), "\n\n";
}

sub languages { return @{ shift->{'language=s@'} } }

sub debug { return shift->{'debug'} }

sub help { return shift->{'help|h'} }

sub usage {
    my $self = shift;
    print <<'USAGE';

 MT export build deployment notification automation.
 Examples:

 cd $MT_DIR
 git pull
 perl build/exportmt.pl --help
 perl build/exportmt.pl --debug
    # --alpha=1
    # --beta=42
    # --local
    # --make
    # --plugin=Foo --plugin=Foo
    # --prod
    # --qa
    # --stage

USAGE
    exit;
}

1;
__END__
