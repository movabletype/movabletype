use Test;

use strict;
BEGIN { use lib 't/', 'extlib', 'lib' }

use vars qw($T_CFG);

require 'test-common.pl';

$T_CFG = -r 't/mysql.cfg' ? 't/mysql.cfg' : $ENV{HOME} .'/mysql-test.cfg';

require 'blog-common.pl';

my $blog_name_tmpl = MT::Template->load({name => "blog-name"});
die unless $blog_name_tmpl;

use MT;
use MT::Util qw(ts2epoch epoch2ts);

my $mt = new MT(ConfigOverride => {Monkey => "Jump"});

use MT::Template::Context;
MT::Template::Context->add_global_filter('rot13', sub {
    my ($s) = @_;
    $s =~ tr/a-zA-Z/n-za-mN-ZA-M/;
    $s;
});

use MT::Builder;

sub build {
    my($ctx, $markup) = @_;
    my $b = MT::Builder->new;
    my $tokens = $b->compile($ctx, $markup) or die $b->errstr;
    my $res = $b->build($ctx, $tokens);
    defined $res || print $b->errstr;
    $res;
}

my $ctx = MT::Template::Context->new;

my $blog = MT::Blog->load(1) or die "No blog ID 1";
$ctx->stash('blog', $blog);
$ctx->stash('blog_id', $blog->id);
my @entries = MT::Entry->load( 1 ) or die "No entries!";
my $entry = $entries[0];
#$ctx->stash('entry', $entry);

# entry we want to capture is dated: 19780131074500
my $tsdiff = time - ts2epoch($blog, '19780131074500');
my $daysdiff = int($tsdiff / (60 * 60 * 24));

$ctx->{current_timestamp} = '20040816135142';

die unless $ctx;

require JSON;
my $test_suite;
local $/ = undef;

my %const = (
    CFG_FILE => MT->instance->{cfg_file},
    VERSION_ID => MT->instance->version_id,
    CURRENT_WORKING_DIRECTORY => MT->instance->server_path,
    STATIC_CONSTANT => '1',
    DYNAMIC_CONSTANT => '',
    DAYS_CONSTANT1 => $daysdiff + 1,
    DAYS_CONSTANT2 => $daysdiff - 1,
);
open F, "<t/test-templates.dat";
my $test_json = <F>;
close F;

$test_json =~ s/^ *#.*$//mg;
$test_json =~ s/# *\d+ *(?:TBD.*)? *$//mg;

$test_json =~ s/\Q$_\E/$const{$_}/g for keys %const;
$test_suite = JSON::jsonToObj($test_json);

plan tests => scalar @$test_suite;

my $output_results = 0;
foreach my $test_item (@$test_suite) {
    local $ctx->{__stash}{entry} = $entry if $test_item->{t} =~ m/<MTEntry/;
    my $result = build($ctx, $test_item->{t});
    if ($output_results) {
        print STDERR "'", (defined $result ? $result : "**undefined**"), "'\n";
    }
    ok($result, $test_item->{e}) 
        or print STDERR "#--> Building ", $test_item->{t}, "\n";
}
