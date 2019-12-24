use strict;
use warnings;
use File::Find;
use Test::More;
use Path::Tiny;

find(
    {   wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file;
            return if $file =~ m!/(?:extlib|node_modules|\.git)/!;
            my $body = path($file)->slurp;
            unlike $body => qr/Six Apart, Ltd\./, $file;
        },
        no_chdir => 1,
    },
    "."
);

done_testing;
