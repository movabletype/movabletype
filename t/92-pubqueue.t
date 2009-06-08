#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 67;

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
	
	my $job_count = 0;
	my @tmpls = MT::Template->load({ blog_id => $blog->id });
	ok (@tmpls, "Templates exist for this blog");

	for (my $i = 0; $i < scalar(@tmpls); $i++) {
		my $tmpl = $tmpls[$i];
		ok ($tmpl, "Template i : $i id: " . $tmpl->id . " name: " . $tmpl->name); 
		$tmpl->build_type(MT::PublishOption::ASYNC);
		
		if ($tmpl->name eq "Main Index") {
			my $text = $tmpl->text;
			$tmpl->text($text . '<mt:SomeDummyTag>');
		}

		$tmpl->save;
	}

	my $mt = MT->new or die MT->errstr;
	$mt->rebuild(
		BlogID => $blog->id,
		Force  => 1
	) || print "Rebuild error: ", $mt->errstr;

	my @jobs = MT::TheSchwartz::Job->load();
	ok (@jobs, "Jobs were found");
	$job_count = scalar(@jobs);
	ok ($job_count > 1, "There are new jobs");

	for my $job (@jobs) {

		my $fi = MT::FileInfo->load({ id => $job->uniqkey });
	    my $at = $fi->archive_type || '';
		my $priority = $job->priority;
	
		if (($at eq 'Individual') || ($at eq 'Page')) {
			my $map = MT::TemplateMap->load($fi->templatemap_id);
			if ($map && $map->is_preferred) {
				is ($priority, 10, "Priority is correct");
			} 
			else {
				is ($priority, 10, "Priority is correct");
			}
		} 
		elsif ($at eq 'index') {
			if ($fi->file_path =~ m!/(index|default|atom|feed)!i) {
				is ($priority, 9, "Priority is correct");
			} 
			else {
				is ($priority, 8, "Priority is correct");
			}
		} 
		elsif ($at =~ m/Category|Author/) {
			is ($priority, 1, "Priority is correct");
		} 
		elsif ($at =~ m/Yearly/) {
			is ($priority, 1, "Priority is correct");
		} 
		elsif ($at =~ m/Monthly/) {
			is ($priority, 2, "Priority is correct");
		} 
		elsif ($at =~ m/Weekly/) {
			is ($priority, 3, "Priority is correct");
		} 
		elsif ($at =~ m/Daily/) {
			is ($priority, 4, "Priority is correct");
		}
	}
	
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

	my @errors = MT::TheSchwartz::Error->load();
	ok (@errors, "Error should have been found");
	@jobs = MT::TheSchwartz::Job->load();
	ok (! @jobs, "Jobs were not found, everything went through");
	is ($entry->status, MT::Entry::RELEASE(), "Running publish_future_post publishes future post; status is now RELEASE");

	for (my $i = 0; $i < scalar(@tmpls); $i++) {
		my $tmpl = $tmpls[$i];
		$tmpl->build_type(MT::PublishOption::ONDEMAND);
		$tmpl->save;
		if ($tmpl->name eq "Main Index") {
			my $text = $tmpl->text;
			$text =~ s/<mt:SomeDummyTag>//g;
			$tmpl->text($text);
			$tmpl->save;
                }		
	}

	my $rebuild = $mt->rebuild(
		BlogID => $blog->id,
		Force  => 1
	) || 0;
	
	ok ($rebuild, "Rebuilt all without the publish queue");
	@jobs = MT::TheSchwartz::Job->load();
	$job_count = scalar(@jobs);
	ok ($job_count == 0, "There are no new jobs");
}
