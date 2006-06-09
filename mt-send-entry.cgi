#!/usr/bin/perl -w

# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

use strict;
sub BEGIN {
    my $dir;
    require File::Spec;
    if (!($dir = $ENV{MT_HOME})) {
        if ($0 =~ m!(.*[/\\])!) {
            $dir = $1;
        } else {
            $dir = './';
        }
        $ENV{MT_HOME} = $dir;
    }
    unshift @INC, File::Spec->catdir($dir, 'lib');
    unshift @INC, File::Spec->catdir($dir, 'extlib');
}

eval {
    require CGI;
    require MT::Mail;
    require MT::Entry;
    require MT::Blog;
    require MT;
    require MT::Util;

    my $mt = MT->new() or die MT->errstr;
    my $q = CGI->new;

    my $to = $q->param('to');
    my $from = $q->param('from');
    my $entry_id = $q->param('entry_id');
    my $redirect = $q->param('_redirect');
    my $msg = $q->param('message') || '';

    unless ($entry_id && $redirect) {
        die "Missing required parameters\n";
    }

    unless ($to = MT::Util::is_valid_email($to)) {
        die "Invalid 'To' email address";
    }
    unless ($from = MT::Util::is_valid_email($from)) {
        die "Invalid 'From' email address";
    }

    for ($to, $from) {
        my $cnt = $_ =~ tr/@/@/;
        die "Invalid email address" if $cnt != 1;
        die "Invalid email address" if /[\r\n,]/;
    }
    die "Message is too long"
        if length($msg) > 250;

    my $entry = MT::Entry->load($entry_id)
        or die "Invalid entry ID '$entry_id'";
    my $blog = MT::Blog->load($entry->blog_id);

    my $link = $blog->archive_url;
    $link .= '/' unless $link =~ m!/$!;
    $link .= $entry->archive_file;

    my $body = <<BODY;
$from has sent you a link!

$msg

Title: @{[ $entry->title ]}
Link: $link
BODY
    my %head = ( To => $to, From => $from,
                 Subject => '[' . $blog->name . '] Recommendation: ' .
                            $entry->title );

    MT::Mail->send(\%head, $body)
        or die "Error sending mail: ", MT::Mail->errstr;

    print $q->redirect($redirect);
};
if ($@) {
    print "Content-Type: text/html\n\n";
    print "Got an error: $@";
}
