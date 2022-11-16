use strict;
use warnings;
use File::Find;
use Test::More;
use Path::Tiny;

my @errors;
my @dirs = grep -d $_, split /\n/, `git ls-tree HEAD --name-only`;

plan skip_all => 'no directories' unless @dirs;

for my $dir (@dirs) {
    find({
            wanted => sub {
                my $file = $File::Find::name;
                return unless -f $file;
                return if $file =~ m!/(?:extlib|node_modules|nytprof|\.git)/!;
                my $body = path($file)->slurp;
                ok $body !~ /Six Apart, Ltd\./, $file
                    or push @errors, $file;
            },
            no_chdir => 1,
        },
        $dir
    );
}

note explain \@errors if @errors;

done_testing;
