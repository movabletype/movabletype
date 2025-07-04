use strict;
use warnings;
use FindBin;
use LWP::UserAgent;
use version;
use JSON;
use Path::Tiny;
use Encode;
use Getopt::Long;

GetOptions(
    force => \my $force,
);

my $version = shift;

my $base = 'https://spec.commonmark.org/';

my $ua = LWP::UserAgent->new;

if (!$version) {
    my $res = $ua->get($base);
    my $html = $res->decoded_content;
    my @versions = $html =~ m!href="([0-9.]+)/spec.json"!g;

    my $latest = $version = (sort {$b->[0] <=> $a->[0]} map {[version->parse('v'.$_), $_]} @versions)[0][1];

    if (-e "$FindBin::Bin/spec.version") {
        my $stored = path("$FindBin::Bin/spec.version")->slurp;
        chomp $stored;
        if ($stored eq $latest) {
            print STDERR "spec.version is already the latest ($latest).\n";
            exit unless $force;
        }
    }
    path("$FindBin::Bin/spec.version")->spew($latest);
    $version = $latest;
} else {
    path("$FindBin::Bin/spec.version")->remove;
}

my $res = $ua->get("$base/$version/spec.json");
my $spec_json = $res->decoded_content;

path("$FindBin::Bin/spec.json")->spew($spec_json);

print STDERR "Updated spec.json ($version)\n";

my $spec = decode_json($spec_json);

my %todo = (
    qq{foo <?php echo \$a; ?>\n} => 'PHP',
);

my $test = path("$FindBin::Bin/../01_spec_test.t")->slurp;
$test =~ s/(?:# spec version: [0-9.]+\n\n)?__END__\n.+//s;
$test .= "# spec version: $version\n\n__END__\n\n";

for my $i (@$spec) {
    my $is_todo = $todo{$i->{markdown}} || '';
    $test .= "@@@ Test $i->{example}\n";
    $test .= "!!! text\n";
    $test .= encode_utf8($i->{markdown});
    chomp $test;
    $test .= "\n";
    if ($is_todo eq 'both') {
        $test .= "!!! expected_todo\n";
    } elsif ($is_todo eq 'Perl') {
        $test .= "!!! expected_todo\n";
        $test .= encode_utf8($i->{html});
        chomp $test;
        $test .= "\n";
        $test .= "!!! expected_php\n";
    } elsif ($is_todo eq 'PHP') {
        $test .= "!!! expected_php_todo\n";
        $test .= encode_utf8($i->{html});
        chomp $test;
        $test .= "\n";
        $test .= "!!! expected\n";
    } else {
        $test .= "!!! expected\n";
    }
    $test .= encode_utf8($i->{html});
    chomp $test;
    $test .= "\n\n";
}

path("$FindBin::Bin/../01_spec_test.t")->spew($test);

print STDERR "Updated 01_spec_test.t\n";

