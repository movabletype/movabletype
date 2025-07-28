use strict;
use warnings;
use Test::More;
use File::Find;
use File::Basename;

my @dirs = ('extlib', glob("plugins/*/extlib"), glob("addons/*/extlib"));

my %known_files = map {$_ => 1} qw(
    .gitignore
    .exists
    Makefile
    libnet.cfg
    media.types
    types.db
    Geolocation.dat
    ParserDetails.ini
);

for my $dir (@dirs) {
    next unless -d $dir;
    my $fail;
    find({
        wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file;
            return if $file =~ /\.(pm|pl)$/;
            my $name = basename($file);
            return if $known_files{$name};
            fail $file and $fail = 1;
        },
        no_chdir => 1,
    }, $dir);
    ok !$fail, "$dir has no non-perl files";
}

done_testing;

