#!/usr/bin/perl

# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

use strict;
use warnings;

use FindBin qw( $Bin );
use lib "$Bin/../../cpan-lib";

use Pod::Usage;
use Template;
use YAML;
use File::Spec::Functions qw/catfile file_name_is_absolute abs2rel splitdir/;
use File::Basename;
use Getopt::Long;
Getopt::Long::Configure('no_ignore_case');
use Data::Dumper;
use File::Find;

use Template::Constants ':chomp';


my ($version, $help, $man, $VERBOSE, $app);

GetOptions (
             'h|help'          => \$help,
             'm|man'           => \$man,
             'v|verbose'       => \$VERBOSE,
             'app=s'           => \$app,
           );
$man and pod2usage(-verbose => 2);
$help and pod2usage;

$app ||= 'archetype';

my $themedir = "$Bin/../mt-static/themes";
my $templatedir = "$Bin/theme_templates/auto";
my $modulesdir = "$Bin/theme_templates/modules";

foreach ($themedir, $templatedir) {
    s|archetype/tools/../../$app|$app|;
}

## Set up a global TT object. (Global so that it maintains a cache.)
our $Template = Template->new({
    INCLUDE_PATH => $modulesdir, 
    ABSOLUTE => 1,
    PRE_CHOMP  => CHOMP_COLLAPSE,
    POST_CHOMP => CHOMP_NONE,
    TRIM => 1,
});

# find all the templates we're going to work from
my @templates = &find_templates;

# set up all the themes we need to put out
my @themes_todo = @ARGV;
if (! @themes_todo) {
    my $max_tmpl_module_age = &find_max_tmpl_module_age;
    @themes_todo = &find_themes_needing_regeneration($max_tmpl_module_age, @templates);
}
@themes_todo = &names2paths(@themes_todo);    


# do the work
foreach my $theme (@themes_todo) {

    &regenerate($theme);
}

sub regenerate {
    my $theme = shift;

    logg("regenerating ".abs2rel($theme));

    my $yaml = load_yamls($theme);
    
    foreach my $tt (@templates) {

        debug("making ".abs2rel($tt));
    
        my ($name,$path) = fileparse($theme);
        my $outfile = catfile($path, basename($tt));
        $outfile =~ s/\.tt$//;

        debug("writing to ".abs2rel($outfile));

#        if (-e $outfile && ! $nobackup) {
#            my  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
#                                                               localtime(time);
#            my $today = sprintf("%4.4d%2.2d%2.2d-%2.2d%2.2d%2.2d", $year+1900, $mon+1, $mday, $hour, $min, $sec);
#            debug ("saving $outfile as $outfile.$today.bak");
#            rename $outfile, "$outfile.$today.bak";
#        }

        my $files_present = find_files_present(dirname($theme));

        $yaml->{find_file} = sub { return $files_present->{$_[0]}};

        $Template->process($tt, {theme => $yaml}, $outfile) || die $Template->error;
    }

}

sub find_files_present {
    my ($basedir, $yaml) = @_;

    my $files_present = {};

    opendir (DIR, $basedir) || die "can't opendir $basedir $!";
    while (my $file = readdir(DIR)) {
        next unless -f "$basedir/$file";
        next if $file =~ /\.bak$/;

        $files_present->{$file} = $file;

        my ($shortname, $path, $suffix) = fileparse($file, qw/.gif .png .jpg/);

        #both bg-header.gif and bg-header.jpg exist, save the first one alphabetically

        if ($files_present->{$shortname}) {
            if ($file lt $files_present->{$shortname}) {
                $files_present->{$shortname} = $file;
            }
        }else{
            $files_present->{$shortname} = $file;        
        }

        
    }
    closedir DIR;

    return $files_present;
}

sub load_yamls {
    my $theme_yaml = shift;
    $theme_yaml = YAML::LoadFile($theme_yaml);
    return $theme_yaml;
}


sub logg {
    my $msg = shift;
    print "$msg\n";
}

sub debug {
    my $msg = shift;
    print "$msg\n" if $VERBOSE;
}

sub find_templates {
    my @templates;
    opendir (DIR, $templatedir) || die "can't opendir $templatedir $!";
    while (my $file = readdir(DIR)) {
        next if -d $file;
        next if $file =~ /^\./;
        next unless $file =~ /\.tt$/;
        push @templates, catfile($templatedir, $file);
    }
    closedir DIR;
    return @templates;
}

sub find_themes_needing_regeneration {
    my ($max_tmpl_module_age, @templates) = @_;
# first look at the data files
    my (@yamls, %yamlage, %themes_todo, @themes_todo);
    opendir(DIR, "$themedir") || die "can't open $themedir $!";
    while (my $theme = readdir(DIR)) {
        
        next unless -d catfile($themedir, $theme);
        next if $theme =~ /^\./;
        next unless -f catfile($themedir, $theme, 'theme.yaml');

        push @yamls, $theme;
        $yamlage{$theme} = (stat(catfile($themedir, $theme, 'theme.yaml')))[9];
        debug("theme.yaml found for $theme, will check age");
    }
    closedir DIR;

    # now look each of the templates
    foreach my $templatefile (@templates) {
        (my $css_file = basename($templatefile)) =~ s/\.tt$//;
        my $templateage = (stat($templatefile))[9];

        # the templates lead back to an output file for each 
        # data file that we loaded
        foreach my $theme (@yamls) {

            # if either the template or the data is newer than
            # the output, then regenerate the output
            my $css_age = (stat(catfile($themedir, $theme, $css_file)))[9] || 0;
            if (   $templateage     > $css_age #template has changed
                || $yamlage{$theme} > $css_age #data has changed
                || $max_tmpl_module_age > $css_age #a .tt module has changed
                ) {  
                $themes_todo{$theme} = 1;
                debug("$theme needs to be regenerated");
                next;
            }
        }
    }
    @themes_todo = map{$_} sort keys %themes_todo;

    return @themes_todo;
}

# heavily DWIM
sub names2paths {
    my @themes_todo = @_;

    foreach (@themes_todo) {

        # they gave us the full path, so just run with it
        if (/\theme.yaml$/) {
            next if -e;

        # they gave us the path to the directory, but not 'theme.yaml' 
        # at the end, fix it up
        }elsif (-d){
            $_ = catfile($_, 'theme.yaml');
            next if -e;

        # they just gave us the theme name
        }elsif (-e catfile($themedir, $_, 'theme.yaml')){
            $_ = catfile($themedir, $_, 'theme.yaml');
            next if -e;
        }

        # whatever we tried to figure out isn't there

        die "I can't find $_, sorry\n";
    }    
    return @themes_todo;
}

sub find_max_tmpl_module_age {
    $BT::max_age = 0;

    find( sub {
            my $mtime;
            /\.tt$/ &&
               (($mtime) = (lstat($_))[9]) &&
               $mtime > $BT::max_age &&
                ($BT::max_age = $mtime)
        },
        "$templatedir/.." #back up one .. to get out of auto/
        );
    return $BT::max_age;
}

__END__
==head1 NAME

build-themes.pl - generates themes from a theme.yaml file

=head1 SYNOPSIS

 build-themes.pl [options] [theme1 theme2 ...]

 Options:

   --app <app>   specify the application to use ('vox', 'archetype', etc)

   -v|--verbose  more chatty output

   -h|--help     brief help message
   -m|--man      full man page
   -V|--version


=head1 EXAMPLES

=over 4

=item build any themes that need to be rebuilt

    build-themes.pl

=item just rebuild a couple specific ones

    build-themes.pl piximix-orange pixipets-cat

=item rebuild one in some funky location

    build-themes.pl /home/kgoess/temp/funkymusic/
or
    build-themes.pl ../experiments/funkymusic/theme.yaml

=head1 DESCRIPTION

Builds themes from a theme.yaml file and any .tt template files in 
archetype/templates/themes/auto/*.tt.  

The output files, one for each .tt file, will go into the 
same directory as the theme.yaml.

It tries to be pretty generous about allowing you to specify the 
theme names in different ways.

=head1 Template Toolkit

The data in the yaml file is available to the templates under C<theme>, e.g. 
C<theme.somevalue>.  

Existence of a file in the theme directory can be checked via

    theme.find_file('bg-header.gif')

or without the extension

    theme.find_file('bg-header')

The latter case also returns the alphabetically first file that matches, 
so if bg-header.gif and bg-header.jpg both exist:

    what = theme.find_file('bg-header')  #what is now bg-header.gif

=cut

