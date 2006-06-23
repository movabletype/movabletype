# $Id$

=head1 NAME

Build - Movable Type build functionality via Module::Build

=head1 SYNOPSIS

  # Build.PL
  use lib 'build';
  use Build;
  my $build = Build->new( %args );
  $build->preprocess();
  $build->create_build_script();

  # build/mt-build.PL
  use lib 'build';
  use Build;
  my $build = Build->current;
  for my $file ( @ARGV ) {
    # Process the PL_files given as arguments.
  }

=head1 DESCRIPTION

A C<Build> object contains all the internal routines needed to build
Movable Type distributions.

=cut

package Build;
our $VERSION = '0.04';
use base qw( Module::Build );
use strict;
use warnings;
use Archive::Tar;
use Archive::Zip;
use Carp;
use IO::File;
use File::Basename;
use File::Copy 'copy';
use File::Path;
use File::Slurp;
use Text::Iconv;

=head2 METHODS

=cut

sub languages { return qw( de es fr ja nl en_US ) }

=head2 languages()

  my @languages = $build->languages();

Accessor routine to get the list of supported languages.

=cut

sub preprocess {
    my $self = shift;

    # Retrieve the build arguments or set to defaults.
    my $language = $self->args( 'language' ) || 'en_US';
    my $package  = $self->args( 'package' )  || 'MT';

    # Read-in the configuration variables for substitution.
    my $config = read_conf(
        'build/mt-dists/default.mk',
        "build/mt-dists/$language.mk",
        "build/mt-dists/$package.mk",
    );
    # Add the build arguments to the config.
    $config->{BUILD_LANGUAGE} = $language;
    $config->{BUILD_PACKAGE}  = $package;

    # Add the configuration items to the build notes.
    $self->notes( config   => $config );
    $self->notes( language => $language );
    $self->notes( package  => $package );

    # Add the locale files to the list of files to generate.
    my $files = $self->PL_files();
    for my $lang ( $self->languages() ) {
        # Add language specific files but skip the default: English.
        if( $lang !~ /^en_?/ ) {
            push @{ $files->{'build/mt-build.PL'} }, "lib/MT/L10N/$lang-iso-8859-1.pm"
                unless $lang eq 'ja';
            push @{ $files->{'build/mt-build.PL'} }, "mt-static/mt_$lang.js";
        }
    }
    $self->PL_files( $files );
}

=head2 preprocess()

  $build->preprocess();

This routine is called by the C<Build.PL> script and collects the
substitution configuration variables and adds the locale files to the
build object's C<PL_files> list.

=cut

sub substitute {
    my $self = shift;
    my $config = shift || croak 'No configuration given to substitute';
    my $file = shift || croak 'No file given to substitute()';
    warn "Substituting in $file...\n";

    # Copy the pre-file and then substitute the config variables.
    my $source = $file . '.pre';
    copy( $source, $file ) ||
        croak "Can't copy $source to $file: $!";

    my $text = read_file( $file );  # File::Slurp

    my $success = 0;
    while( my( $key, $val ) = each %$config ) {
        if( $text =~ /__$key\__/s ) {
            $success++;
            warn "Found $key. Replacing with $val\n";
            $text =~ s/__$key\__/$val/gs;
        }
    }

    write_file( $file, $text ) if $success;  # File::Slurp

    return $success;
}

=head2 substitute()

  my $n = $build->substitute( \%config, $file )

Replace the strings (given by the hash reference keys) in the given
file with the corresponding values of the hash-ref and return the
number of successful matches.

=cut

sub make_js {
    my $self = shift;
    my $lang = shift || croak 'No locale language given for make_js()';
    my $file = shift || croak 'No locale file given for make_js()';

    my $class = 'MT::Util';
    eval "require $class" or croak "ERROR: Can't require $class: $!";

    # Import the language L10N lexicon.
    eval 'require MT::L10N::'. $lang or
        croak "ERROR: Can't require MT::L10N::$lang";
    my $lex = eval '\%{ %MT::L10N::'. $lang .'::Lexicon }';
    warn "Imported %MT::L10N::$lang\::Lexicon\n";

    # Read-in the MT javascript.
    my $source = 'mt-static/mt.js';
    my $js = read_file( $source );  # File::Slurp
    warn "Read-in $source contents.\n";

    # Open the given locale js file.
    my $fh = IO::File->new( '> '. $file );

    print $fh "/* Movable Type language lexicon for $lang localization. */\n\n";

    # Encode any matching lines.
    while( $js =~ m/trans\('([^']+?)'/g ) {
        my $str = $1;
        my $local = $lex->{$str} || $str;
        $str = MT::Util::encode_js( $str );
        $local = MT::Util::encode_js( $local );
        next if $str eq $local;
        print $fh "Lexicon['$str'] = '$local';\n";
    }

    # Bail out!
    $fh->close;
    warn "make_js: $file updated.\n";
}

=head2 make_js()

  $build->make_js( $language, $file );

Create a JavaScript file for the given lnaguage.

=cut

sub make_latin1 {
    my $self = shift;
    my $lang = shift ||
        croak "No locale language given for make_latin1()";
    my $file = shift ||
        croak "No file to convert given for make_latin1()";

    # XXX en_us is used all over the code, instead of en_US.
    $lang = lc $lang;

    my $source = "lib/MT/L10N/$lang.pm";

    # Read-in the file.
    my $text = read_file( $source );  # File::Slurp
    warn "Read $source contents.\n";

    # Convert the file text.
    my $conv = Text::Iconv->new( 'utf-8', 'iso-8859-1' );
    $text = $conv->convert( $text );
    warn "Converted $source contents.\n";

    # Write out the converted file.
    write_file( $file, $text );  # File::Slurp
    warn "Wrote the converted contents to $file.\n";
}

=head2 make_latin1()

  $build->make_latin1( $language, $file );

Convert file contents from utf-8 to iso-8859-1 and rename according to
the given language.

=cut

sub make_tarball {
     my $self = shift;
    $self->SUPER::make_tarball( @_ );
    my $dist_dir = $self->dist_dir();
    my $tar = Archive::Tar->new( "$dist_dir.tar.gz" ) or
        croak "Can't read $dist_dir: $!";
    $tar->extract() or
        croak "Can't extract $dist_dir: $!";
    my $zip = Archive::Zip->new();
    $zip->addDirectory( $dist_dir ) or
        croak "Can't read $dist_dir: $!";
    $zip->writeToFileNamed( "$dist_dir.zip" ) or
        croak "Can't create $dist_dir.zip: $!";
    $self->delete_filetree( $dist_dir );
}

sub read_conf {
    my @files = @_;
    my $config = {};

#    warn "Files: @files\n";
    for my $file ( @files ) {
        next unless -e $file;
        warn "Parsing config $file file...\n";
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

=head2 read_conf()

  $config = $build->read_config( @files );

Read-in the given configuration files with B<key = value> pairs per
line and return a single hash reference of B<key => "value"> pairs.

=cut

1;
