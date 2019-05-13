use strict;
use warnings;

use File::Find;
use Getopt::Long;

GetOptions( "dryrun" => \my $dryrun );

if ( my @files = @ARGV ) {
    perltidy($_) for @files;
}
else {
    perltidy_all_files();
}

sub perltidy_all_files {
    chdir '../' if -e './perltidy.pl';
    perltidy($_) for get_cgi_files();
    find( { wanted => \&wanted, follow => 1, no_chdir => 1 },
        get_perl_dirs() );
}

sub wanted {
    if ( is_perl_file($File::Find::name) ) {
        perltidy($File::Find::name);
    }
}

sub get_cgi_files {
    grep { $_ !~ /mt-config\.cgi\z/ } glob '*.cgi';
}

sub get_perl_dirs {
    my @perl_dirs = ( 'lib', 'tools', 'plugins', 't' );
    push @perl_dirs, 'addons' if -e 'addons';
    @perl_dirs;
}

sub is_perl_file {
    my ($file) = @_;
    return 0 if $file =~ m|/L10N/|;
    return 1
        if $file =~ /\.(?:cgi|pl|pm|t)\z/
        || $file =~ m|/cpanfile\z|
        || $file =~ m|tools/|;
    0;
}

sub perltidy {
    my ($file) = @_;
    print "perltidy $file\n";
    `perltidy -pbp -nst -b -bext='/' $file` unless $dryrun;
}

