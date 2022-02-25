use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../t/lib";
use Cwd;
use MT::Test::ConvertTags qw/convert_tags/;
use File::Find;
use Path::Tiny;
use Test::More;

my $root = Cwd::realpath("$FindBin::Bin/../");

my @dirs = map { "$root/$_" } qw( default_templates tmpl search_templates themes mt-static lib );

for my $plugin_root (qw/ plugins addons /) {
    next unless -d "$root/$plugin_root";
    for my $plugin_dir (glob "$root/$plugin_root/*") {
        for my $dir (qw/ lib tmpl /) {
            push @dirs, "$plugin_dir/$dir" if -d "$plugin_dir/$dir";
        }
    }
}

for my $dir (@dirs) {
    find({
        wanted => sub {
            my $file = $File::Find::name;
            return unless -f $file;
            return if $file =~ /\.git/;
            return if $file =~ /\.(?:md|svg)$/;
            my $body = path($file)->slurp;
            return unless $body =~ /<use\b/;
            $body = convert_tags($body);
            my @uses = $body =~ m!(<use\b[^>]+>\s*(?:</use>)?)!gs;
            if (!@uses) {
                note "# SKIP: $file has no testable <use>s";
                return;
            }
            ok !grep(/\/>/s, @uses), "$file has no <use .../>";
            ok !grep(!/<\/use>/s, @uses), "$file has no <use> without </use>";
            note explain \@uses;
        },
        no_chdir => 1,
    }, $dir );
}

done_testing;
