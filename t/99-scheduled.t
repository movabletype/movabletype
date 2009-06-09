#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 3;

use MT;
use MT::Blog;
use MT::Entry;
use MT::Log;
use MT::PublishOption;
use MT::Template;
use MT::TemplateMap;
use MT::Test qw( :db :data );
use MT::TheSchwartz::Error;

my @blogs = MT::Blog->load();
foreach my $blog (@blogs) {

        my $mt = MT->new or die MT->errstr;

        my $entry = MT::Entry->new;
        $entry->set_values({
                blog_id => $blog->id,
                title => 'It\'s dark',
                text => 'You may be eaten by a grue.',
                keywords => 'keywords',
                created_on => '19780131074500',
                authored_on => '19780131074500',
                modified_on => '19780131074600',
                authored_on => '19780131074500',
                author_id => 1,
                allow_comments => 1,
                allow_pings => 1,
                status => MT::Entry::FUTURE(),
        });
        $entry->save;

        ok ($entry->id, "Future post saves correctly" );
        is ($entry->status, MT::Entry::FUTURE(), "Future post has status FUTURE");

        _run_rpt();

        is ($entry->status, MT::Entry::RELEASE(), "Running publish_future_post publishes future post; status is now RELEASE");
}
