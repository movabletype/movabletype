#!/usr/bin/perl -w

use strict;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use Test::More tests => 4;
use LWP::UserAgent::Local;
use URI;
use MT::Test qw(:db :data);

my $username = "Chuck D"; # Melody
my $password = "bass"; # Nelson

unlink "t/cookie.jar";
use HTTP::Cookies;
my $cgipath = MT->config->CGIPath;
$cgipath =~ s/\/*$//;
my $cookie_jar = HTTP::Cookies->new(file => "t/cookie.jar");
my $ua = new LWP::UserAgent::Local({ ScriptAlias => "$cgipath/",
                                     AddHandler => 'cgi-script .cgi',
                                     cookie_jar => $cookie_jar,
                                 });
my $start_link = "http://localhost" . $cgipath . "/mt.cgi?username=$username&password=$password";
my $start_url = new URI($start_link);

my %link_queue;
my %links_checked;
my $count = 0;
my $link_count = 0;

my @failures;
my @notgoods;
my @notgood_pages;
my @fetched;
my @warnings;
my %modes_seen;

my $skip_pattern = qr{logout|export|magic_token};
my $must_match = qr{(/cgi-bin/|^\?).*mt\.cgi};
my $warning_pattern = qr{Uninitialized};
my $good_pattern = qr{Copyright .* 2001-\d+ Six Apart\. All Rights Reserved\.};
my $bad_pattern = qr{<input\s+type="submit"\s+value="Log In" />|time\s+to\s+upgrade!}i;

my $verbose = 0;
my $debug = 1;
my $test_mode = 1;

$link_queue{$start_link} = $start_link;
while (keys %link_queue && $count < 500) {
    my ($curr_link, $its_parent) = %link_queue;
    $link_count++;
    delete $link_queue{$curr_link};

    next unless $curr_link =~ m/$must_match/;
    next if $skip_pattern && $curr_link =~ m/$skip_pattern/;

    $curr_link = URI->new_abs($curr_link, $its_parent);
    next if $curr_link->scheme ne 'http' && $curr_link->scheme ne 'https';
    next if $curr_link->host ne $start_url->host();

    unless ($links_checked{$curr_link}) {
        print "REQUESTING $curr_link\n" if $verbose;
        my $req = new HTTP::Request(GET => $curr_link)
                          or die "a thousand deaths";
        my $resp = $ua->request($req) or next;

        #print STDERR "Response: [" . $resp->content() . "]\n" if $verbose;
        use Data::Dumper;
        print STDERR $resp->content() unless $resp->content() =~ m/$good_pattern/;

        push @failures, $curr_link unless $resp->is_success;
        my ($mode) = ($curr_link =~ m/__mode=([^&]*)/);
        if ($mode) {
            if (exists $modes_seen{$mode}) {
                $modes_seen{$mode}++;
            } else {
                $modes_seen{$mode} = 1;
            }
        }
        $count++;
        my $content = $resp->content();
        push @notgoods, $curr_link unless $content =~ m/$good_pattern/;
        push @notgoods, $curr_link if $content =~ m/$bad_pattern/;
        push @warnings, $curr_link if $content =~ m/$warning_pattern/;
        push @fetched, $curr_link;
        my @form_actions = $content =~ m|<form[^>]* action="([^"]*)">|gi; #"
        my @links = $content =~ m|<[^>]*href="([^"]*)">|gi;   #"
        @links = grep {$_ =~ /\S/} @links;
        @links = map { s/\&amp\;/&/g; $_ } @links;
        @links = map { s/\&offset=\d+//; $_ } @links;
        @links = map { URI->new_abs($_, $curr_link) } @links;
        $link_queue{$_} = $curr_link foreach (@links);
        $links_checked{$curr_link}++;
#         print join "\n", (keys %link_queue);
#         print "\n";
    }
}

# There should be at least a handful of pages!
ok($count > 50);

print "\nCrawled $count pages (saw $link_count links). ", 
    "\n", scalar @failures, " pages failed to load.\n";
print "$_\n" foreach @failures;

if ($verbose) {
#     print "modes: ", join ", ", (keys %modes_seen), "\n";
#     print "Fetched:\n";
#     print "$_\n" foreach @fetched;
    if ($debug) {
        print "Faulty pages:";
        print "$_\n" foreach @notgood_pages;
    }
    print "\n", scalar @notgoods, " pages appeared faulty:\n";
    print "$_\n" foreach @notgoods;
    print "\n", scalar @warnings, " pages produced warnings:\n";
    print "$_\n" foreach @warnings;
}

if ($test_mode) {
    print "# Checking that there were no failures.\n";
    ok(!@failures);
    print "# Checking that there were no warnings.\n";
    ok(!@warnings);
    print "# Checking that all pages were good.\n";
    ok(!@notgoods);
}
