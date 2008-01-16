# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package __FILE__;

use strict;

use MT::Template::Context;
MT::Template::Context->add_tag(EzPlug => sub {1} );

# Calling convention for pre_save and post_load methods:
# pre_save(<callback>, <object>)

sub xfrm_entry {
    my ($cb, $objref) = @_;
#     print STDERR $objref . "\n";
#     die "Plugin passed unexpected object"
#  	unless UNIVERSAL::isa($objref, "MT::Entry");
    return $cb->error("Can't have an untitled entry")
	if ($objref->title() !~ /\w/);
# #     print STDERR "should have thrown an error (" . 
# # 	$cb->errstr() . ")\n" if ($objref->title() !~ /\w/);
    my $text = $objref->text();
    $text =~ tr/A-Za-z/N-ZA-Mn-za-m/;
    $objref->text($text);
    print STDERR "Saving: [", $objref->text() . "]\n" 
	if $objref->id == 36;
    return 1;
}

#MT-mccrashyerface;

use Data::Dumper;

sub unxfrm_entry {
    my ($cb, $args, $obj) = @_;
    return $cb->error("entry was not an entry object in ezplug")
	unless UNIVERSAL::isa($obj, "MT::Entry");
    return $cb->error("Can't have an untitled entry")
	if ($obj->title() !~ /\w/);
    my $text = $obj->text();
    $text =~ tr/A-Za-z/N-ZA-Mn-za-m/;
    $obj->text($text);
    print STDERR "Loading: [", $obj->text() . "]\n"
	if $$obj->id == 36;
    return 1;
}

require MT::Callback;
MT->add_callback("MT::Entry::pre_save" => 
		 new MT::Callback("ezplug", \&xfrm_entry));

# MT->add_callback('MT::Entry::post_save' => 
# 		 new MT::Callback(\&transform_entry));

MT->add_callback("MT::Entry::post_load" => 
		 new MT::Callback("ezplug", \&unxfrm_entry));
1;
