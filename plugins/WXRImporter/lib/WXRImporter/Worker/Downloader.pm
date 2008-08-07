package WXRImporter::Worker::Downloader;

use strict;
use base qw( TheSchwartz::Worker );

use TheSchwartz::Job;
use HTTP::Request;
use File::Basename;

sub work {
    my $class = shift;
    my TheSchwartz::Job $job = shift;

    # Build this
    my $mt = MT->instance;

    # We got triggered to build; lets find coalescing jobs
    # and process them in one pass.

    my @jobs;
    push @jobs, $job;
    if (my $key = $job->coalesce) {
        while (my $job = MT::TheSchwartz->instance->find_job_with_coalescing_value($class, $key)) {
            push @jobs, $job;
        }
    }

    my $throttles = $mt->{throttle} || {};

    my $ua = $mt->new_ua({ timeout => 20 });
    return unless $ua;
    $ua->max_size(undef) if $ua->can('max_size');

    foreach $job (@jobs) {
        my $asset_id = $job->uniqkey;
        my $asset = MT->model('asset')->load($asset_id);
        my $hash = $job->arg;
        my $url = $hash->{old_url};
        MT::TheSchwartz->debug("Downloading: $url...");

        if ($asset && $url) {
            my $req = HTTP::Request->new( GET => $url );
            my $res = $ua->request($req);
            if ($res->is_success) {
                my $content = $res->content;
                my $blog = MT->model('blog')->load($asset->blog_id);
                my $filemgr = $blog->file_mgr;
                my $asset_file = $asset->file_path;

                my $path = File::Basename::dirname($asset_file);
                $path =~ s!/$!!
                  unless $path eq '/';    ## OS X doesn't like / at the end in mkdir().
                unless ( $filemgr->exists($path) ) {
                    $filemgr->mkpath($path);
                }
                $filemgr->put_data( $content, $asset_file, 'upload' )
                  or $job->failed("Failed to save content of the file $asset_file via: $url");
                $job->completed();
            } else {
                $job->failed("Error downloading $url");
            }
        }
        else {
            $job->completed();
        }
    }
}

sub grab_for { 60 }
sub max_retries { 100000 }
sub retry_delay { 60 }

1;

