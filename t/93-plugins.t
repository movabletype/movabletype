#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 20;

BEGIN {
        $ENV{MT_APP} = 'MT::App::CMS';
}

use MT;
use MT::CMS::Entry;
use MT::Blog;
use MT::Test qw( :app :db :data );

# get the list of plugins and place them in a hash
my $plugins = ();
my $app = MT::App::CMS->instance();
my (%opt) = @_;
my $param = $opt{param};
my $scope = $opt{scope} || 'system';
my $cfg   = $app->config;
my $data  = [];
my %list;
my %folder_counts;

for my $sig ( keys %MT::Plugins ) {
	my $sub = $sig =~ m!/! ? 1 : 0;
	my $obj = $MT::Plugins{$sig}{object};

	# Prevents display of component objects
	next if $obj && !$obj->isa('MT::Plugin');

	my $err = $MT::Plugins{$sig}{error}   ? 0 : 1;
	my $on  = $MT::Plugins{$sig}{enabled} ? 0 : 1;
 	my ( $fld, $plg );
	( $fld, $plg ) = $sig =~ m!(.*)/(.*)!;
	$fld = '' unless $fld;
	$folder_counts{$fld}++ if $fld;
	$plg ||= $sig;
	$list{ $sub . sprintf( "%-100s", $fld ) . ( $obj ? '1' : '0' ) . $plg } = $sig;
}
    
my @keys = keys %list;
foreach my $key (@keys) {
	my $fld = substr( $key, 1, 100 );
	$fld =~ s/\s+$//;
	if ( !$fld || ( $folder_counts{$fld} == 1 ) ) {
		my $sig = $list{$key};
		delete $list{$key};
		my $plugin = $MT::Plugins{$sig};
		my $name = $plugin && $plugin->{object} ? $plugin->{object}->name : $sig;
		$list{ '0' . ( ' ' x 100 ) . sprintf( "%-102s", $name ) } = $sig;
	}
}
	
my $last_fld = '*';
my $next_is_first;
my $id = 0;
( my $cgi_path = $cfg->AdminCGIPath || $cfg->CGIPath ) =~ s|/$||;
for my $list_key ( sort keys %list ) {
	$id++;
	my $plugin_sig = $list{$list_key};
	next if $plugin_sig =~ m/^[^A-Za-z0-9]/;
	my $profile = $MT::Plugins{$plugin_sig};
	
	if ( my $plugin = $profile->{object} ) {
		$plugins->{$plugin->name}++;
	}
}

###########################################################
# Test for the existence of at least these plugins
###########################################################

# plguins that really exist with the build
ok (exists $plugins->{"SpamLookup - Keyword Filter"}, "SpamLookup - Keyword Filter exists");
ok (exists $plugins->{"MultiBlog"}, "MultiBlog exists");
ok (exists $plugins->{"SpamLookup - Link"}, "SpamLookup - Link exists");
ok (exists $plugins->{"SpamLookup - Lookups"}, "SpamLookup - Lookups exists");
ok (exists $plugins->{"mixiComment"}, "mixiComment exists");
ok (exists $plugins->{"Textile"}, "Textile exists");
ok (exists $plugins->{"Community Action Streams"}, "Community Action Streams exists");
ok (exists $plugins->{"Action Streams"}, "Action Streams exists");
ok (exists $plugins->{"Feeds.App Lite"}, "Feeds.App Lite exists");
ok (exists $plugins->{"Markdown"}, "Markdown exists");
ok (exists $plugins->{"Motion"}, "Motion exists");
ok (exists $plugins->{"SmartyPants"}, "SmartyPants exists");
ok (exists $plugins->{"TypePad AntiSpam"}, "TypePad AntiSpam exists");
ok (exists $plugins->{"WXR Importer"}, "WXR Importer exists");
ok (exists $plugins->{"StyleCatcher"}, "StyleCatcher exists");
ok (exists $plugins->{"Widget Manager Upgrade Assistant"}, "Widget Manager Upgrade Assistant exists");
ok (exists $plugins->{"Facebook Commenters"}, "Facebook Commenters exists");
ok (exists $plugins->{"Zemanta"}, "Zemanta exists");

# test plugins created by MT::Test
ok (exists $plugins->{"Awesome"}, "Awesome exists");
ok (exists $plugins->{"testplug.pl"}, "testplug.pl exists");
