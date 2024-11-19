use strict;
use warnings;
use Test::More;
use File::Find;
use Path::Tiny;
use Text::Balanced 'gen_delimited_pat';

my @dirs = ( "php", glob("plugins/*/php") );

my $quote_re = gen_delimited_pat(q{'"});

for my $dir (@dirs) {
    find({
        wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file && $file =~ /\.php$/;
            return if $file =~ /php\/vendor/;
            my $code = path($file)->slurp;
            chomp $code;
            $code =~ s/$quote_re/""/gs;
            $code =~ s/<\?php.+?(?<!\\)\?>//gs or $code =~ s/<\?php.+$//s;
            ok $code eq "", "$file has no extra spaces";
            note $code if $code;
        },
        no_chdir => 1,
    }, $dir);
}

done_testing;
