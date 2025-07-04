use strict;
use warnings;
use FindBin;
use LWP::UserAgent;
use Path::Tiny;
use Encode;
use Web::Scraper;
use utf8;

my $base = 'https://github.github.com/gfm/';

my $source;
if (-e "$FindBin::Bin/gfm.spec") {
    $source = path("$FindBin::Bin/gfm.spec")->slurp_utf8;
} else {
    my $ua   = LWP::UserAgent->new;
    my $res  = $ua->get($base);
    $source = $res->decoded_content;

    path("$FindBin::Bin/gfm.spec")->spew_utf8($source);
    print STDERR "Updated gfm.spec\n";
}

my $scraper = scraper {
    process 'div.version', version => 'TEXT';
    process 'div.example', 'examples[]' => scraper {
        process 'div.examplenum', num => 'TEXT';
        process 'code.language-markdown', markdown => 'TEXT';
        process 'code.language-html', html => 'TEXT';
    };
};

my $res = $scraper->scrape(\$source);

my $version = $res->{version};
my $spec = $res->{examples};

my %todo = (
    qq{<script type="text/javascript">\n// JavaScript example\n\ndocument.getElementById("demo").innerHTML = "Hello JavaScript!";\n</script>\nokay\n} => 'both', # 140
    qq[<style\n  type="text/css">\nh1 {color:red;}\n\np {color:blue;}\n</style>\nokay\n] => 'both', # 141
    qq{<style\n  type="text/css">\n\nfoo\n} => 'Perl', # 142
    qq[<style>p{color:red;}</style>\n*foo*\n] => 'both', # 145
    qq{<script>\nfoo\n</script>1. *bar*\n} => 'both', # 147
    qq{< http://foo.bar >\n} => 'both', # 617
    qq{http://example.com\n} => 'both', # 620
    qq{foo\@bar.example.com\n} => 'both', # 621
    qq{mailto:foo\@bar.baz\n\nmailto:a.b-c_d\@a.b\n\nmailto:a.b-c_d\@a.b.\n\nmailto:a.b-c_d\@a.b/\n\nmailto:a.b-c_d\@a.b-\n\nmailto:a.b-c_d\@a.b_\n\nxmpp:foo\@bar.baz\n\nxmpp:foo\@bar.baz.\n} => 'both', # 633
    qq{xmpp:foo\@bar.baz/txt\n\nxmpp:foo\@bar.baz/txt\@bin\n\nxmpp:foo\@bar.baz/txt\@bin.com\n} => 'both', # 634
    qq{xmpp:foo\@bar.baz/txt/bin\n} => 'both', # 635
    qq{foo <!-- not a comment -- two hyphens -->\n} => 'both', # 649
    qq{foo <!--> foo -->\n\nfoo <!-- foo--->\n} => 'both', # 650
    qq{foo <?php echo \$a; ?>\n} => 'PHP', # 651
);

my $test = path("$FindBin::Bin/../02_gfm_spec_test.t")->slurp;
$test =~ s/(?:# Version [^\n]+\n\n)?__END__\n.+//s;
$test .= "# $version\n\n__END__\n\n";

for my $i (@$spec) {
    (my $num = $i->{num}) =~ s/^Example //;
    my $markdown = $i->{markdown};
    $markdown =~ s/→/\t/g;
    my $html = $i->{html};
    $html =~ s/→/\t/g;
    my $is_todo = $todo{$markdown} || '';
    $test .= "@@@ Test $num\n";
    $test .= "!!! text\n";
    $test .= encode_utf8($markdown);
    chomp $test;
    $test .= "\n";
    if ($is_todo eq 'both') {
        $test .= "!!! expected_todo\n";
    } elsif ($is_todo eq 'Perl') {
        $test .= "!!! expected_todo\n";
        $test .= encode_utf8($html);
        chomp $test;
        $test .= "\n";
        $test .= "!!! expected_php\n";
    } elsif ($is_todo eq 'PHP') {
        $test .= "!!! expected_php_todo\n";
        $test .= encode_utf8($html);
        chomp $test;
        $test .= "\n";
        $test .= "!!! expected\n";
    } else {
        $test .= "!!! expected\n";
    }
    $test .= encode_utf8($html);
    chomp $test;
    $test .= "\n\n";
}

path("$FindBin::Bin/../02_gfm_spec_test.t")->spew($test);

print STDERR "Updated 02_gfm_spec_test.t\n";


