# Movable Type (r) Open Source (C) 2005-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

use strict;

my $PLUGIN_NAME = "Mirror";

sub replicate {
    my ($cb, $entry) = @_;
    
    if (!$entry->id) {               # If it's a new post, 
	if ($entry->blog_id == 3) {  #    on my blog
	    use XML::Atom;
	    use XML::Atom::Entry;
	    use XML::Atom::Client;
	    my $atom_entry = new XML::Atom::Entry;
	    $atom_entry->title($entry->title);
	    $atom_entry->content($entry->text);
	    
	    my $atom_client = new XML::Atom::Client;
	    $atom_client->username('Melody');
	    $atom_client->password('waSiIiKV27v..');
	    my $post_endpt = 'http://koro:4141/cgi-bin/mt/mt-atom.cgi/weblog/blog_id=6';
	    $atom_client->createEntry($post_endpt, $atom_entry);
	    if ($atom_client->errstr()) {
		return $cb->error($atom_client->errstr());
	    } else {
		return 1;
	    }
	} else {
	    return 1;
	}
    }
}

require MT::Plugin;

my $plugin = new MT::Plugin(name => $PLUGIN_NAME, 
			    dir_name => 'mirror',
			    description => "Replicates each post you make to another weblog using Atom.",
			    config_link => "mt-mirror.cgi");

MT->model('entry')->add_callback("pre_save", 9, $plugin, \&replicate);

MT->add_plugin($plugin);

# Return the return value of MT->add_plugin so that we'll be disabled
# if add_plugin chooses to disable us.
