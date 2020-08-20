use strict;
use warnings;
use File::Find;
use Test::More;
use Path::Tiny;

my @errors;
find(
    {   wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file;
            return if $file =~ m!/(?:extlib|node_modules|\.git)/!;
            my $body = path($file)->slurp;
            ok $body !~ /Six Apart, Ltd\./, $file
                or push @errors, $file;
        },
        no_chdir => 1,
    },
    "."
);

note explain \@errors if @errors;

done_testing;
