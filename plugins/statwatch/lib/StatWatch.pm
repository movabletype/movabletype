# StatWatch - lib/StatWatch.pm
# Release 1.2
# Nick O'Neill (http://www.raquo.net/statwatch/)

package StatWatch;
use strict;

use MT::App;
@StatWatch::ISA = qw( MT::App );

use Stats;
use StatWatch::Visit;

### DEVELOPMENT ONLY ###
#use Data::Dumper;
#use Time::Elapse;
#Time::Elapse->lapse(my $now);
#my $DEBUG = 1;

### PRODUCTION ONLY ###
my $now;
my $DEBUG = 0;

my $VERSION = '1.2';


sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        list => \&list,
        view => \&view,
    );
    $app->{default_mode} = 'list';
    $app->{user_class} = 'MT::Author';

    $app->{requires_login} = 1;
    $app->{charset} = $app->{cfg}->PublishCharset;
    my $q = $app->{query};

    $app;
}

sub list {
   my $app = shift;
   my %param;
   my $q = $app->{query};
   $param{debug} = ($DEBUG || $q->param('debug'));
   $param{setup} = $q->param('setup');

   ($param{script_url},$param{statwatch_base_url},$param{statwatch_url},my $static_uri) = parse_cfg();

   require MT::PluginData;
   unless (MT::PluginData->load({ plugin => 'statwatch', key => 'setup_'.$VERSION })) {
      &setup;
      $app->redirect($param{statwatch_url}."?setup=1");
   }

   require MT::Blog;
   my @blogs = MT::Blog->load;
   my $data = [];

   ### Listing the blogs on the main page ###
   for my $blog (@blogs) {
      if (Stats->count({ blog_id => $blog->id })) {
         
         # Today's hits, uniques
         my ($date_start) = usableDate("day",$blog->server_offset);
         my ($date_end) = usableDate("now",$blog->server_offset);
         my @day_stats = getStats($blog->id,$date_start,$date_end);
         
         # Feed Stats automagically
         my ($feed_subscribers, $has_feed) = getFeedStats($blog->site_url);
         
         # Top referrer and page for the week
         my ($date_start) = usableDate("168",$blog->server_offset);
         my ($date_end) = usableDate("now",$blog->server_offset);
         my @week_stats = getStats($blog->id,$date_start,$date_end);

         # hits,uniques,refer,page
         
         # Row it
         my $row = { blog_id => $blog->id,
                     blog_name => MT::Util::encode_html($blog->name),
                     blog_hits_today => $day_stats[0],
                     blog_uniques_today => $day_stats[1],
                     blog_feed_subscribers => $feed_subscribers,
                     blog_has_feed => $has_feed,
                     blog_top_refer_display => trunc($week_stats[2],38),
                     blog_top_refer => $week_stats[2],
                     blog_top_page_display => trunc($week_stats[3],38),
                     blog_top_page => $week_stats[3],
                     };
         push @$data, $row;
      }
   }
   $param{blog_loop} = $data;
   ##########################################
   
   $param{gen_time} = " | ".$now." seconds";

   $param{version} = $VERSION;
   $app->build_page('tmpl/list.tmpl', \%param);
}

sub view {
   my $app = shift;
   my %param;
   my $q = $app->{query};
   $param{debug} = ($DEBUG || $q->param('debug'));
   my $blog_id = $q->param('blog_id');

   ($param{script_url},$param{statwatch_base_url},$param{statwatch_url},my $static_uri) = parse_cfg();
   
   #<# Organization of the main stats data ###
   if ($blog_id) {

      require MT::PluginData;
      unless (MT::PluginData->load({ plugin => 'statwatch', key => 'config_'.$blog_id })) { &StatWatch::Visit::statconfig($blog_id) }

      # Pick up all our blog information
      require MT::Blog;
      $param{blog_id} = $blog_id;
      my $blog = MT::Blog->load({ id => $blog_id});
      $param{blog_name} = $blog->name;
      my $offset = $blog->server_offset;
      $param{title} = " | ".$blog->name;
      my $site_url = $blog->site_url;
      my $app_url = makebaseurl($param{script_url});
      my $has_indiv = 1 if (index($blog->archive_type, "Individual") || $blog->archive_type == "Individual");
      
      # Load up all the stats
      my @stats = Stats->load({ blog_id => $blog->id} );
      
      # We'll need these in a moment...
      my @stats_last_6_full_days;
      my @stats_last_24;
      my @stats_today;
      my ($date_now) = usableDate("now");
      my ($date_week) = usableDate("week");
      my ($date_day) = usableDate("day");
      my ($date_24) = usableDate("24");
      
      # Organize in to last 6 days, last 24 hours and last day lists
      for my $stat (@stats) {
         push @stats_last_6_full_days, $stat if ($stat->created_on < $date_day);
         next unless ($stat->created_on > $date_24);
         push @stats_last_24, $stat;
         next unless ($stat->created_on > $date_day);
         push @stats_today, $stat;
      }

      my $stat_count = scalar(@stats_today);
      
      # Generating our averages for hits, uniques and hours
      # (values in %hours_last_6_full_days are used in the hour loop below)
      my %uniques_last_6_full_days;
      my %hours_last_6_full_days;
      for my $stat (@stats_last_6_full_days) {
          $uniques_last_6_full_days{substr($stat->created_on,6,2)}{$stat->ip} = 1;
          $hours_last_6_full_days{substr($stat->created_on,8,2)} += 1;
      }
      my $uniques_last_6_full_days = 0;
      for my $key (keys %uniques_last_6_full_days) {
          $uniques_last_6_full_days += scalar(keys %{$uniques_last_6_full_days{$key}});
      }
      
      # Stuff those averages for uniques and hits in to the param
      $param{hit_average} = int(scalar(@stats_last_6_full_days)/6);
      $param{unique_average} = int($uniques_last_6_full_days/6);
      
      # Figure our tallies for the day for uniques, hits
      my %today_unique;
      $today_unique{$_->ip} = 1 foreach @stats_today;
      $param{uniques_today} = keys %today_unique;
      $param{uniques_today_bg} = &generate_bg($param{unique_average},$param{uniques_today});
      
      $param{hits_today} = $stat_count;
      $param{hits_today_bg} = &generate_bg($param{hit_average},$stat_count);      
      
      # Feed autodetection for circulation, averages
      ($param{feed_subscribers},$param{feed_subscribers_bg},$param{has_feed},
       $param{feed_average},$param{feed_permit},
      ) = getFeedStats($blog->site_url);
      
      # Getting our hour stuff ready
      my %hit_track;
      my %hit_count = ("00"=>"0","01"=>"0","02"=>"0","03"=>"0","04"=>"0","05"=>"0","06"=>"0","07"=>"0",
                       "08"=>"0","09"=>"0","10"=>"0","11"=>"0","12"=>"0","13"=>"0","14"=>"0","15"=>"0",
                       "16"=>"0","17"=>"0","18"=>"0","19"=>"0","20"=>"0","21"=>"0","22"=>"0","23"=>"0");
      my %hour_map = ("00"=>"12am","01"=>"1","02"=>"2","03"=>"3","04"=>"4","05"=>"5","06"=>"6","07"=>"7",
                      "08"=>"8","09"=>"9","10"=>"10","11"=>"11","12"=>"12pm","13"=>"1","14"=>"2",
                      "15"=>"3","16"=>"4","17"=>"5","18"=>"6","19"=>"7","20"=>"8","21"=>"9","22"=>"10",
                      "23"=>"11");
      
      # Tally the hour stats
      for my $stat (@stats_last_24) {
         my $hour = substr($stat->created_on,8,2);
         push @{$hit_track{"$hour"}}, $stat->ip;
         $hit_count{"$hour"} = scalar @{$hit_track{"$hour"}};
      }
      
      # Stuff the rows with hour data
      my @hits_by_hour;
      my $hour_average = int(scalar(@stats_last_6_full_days)/(24*6));
      $param{hour_average} = $hour_average;
      for my $hour (keys %hit_count) {
         my $css = "background:#".&generate_bg($hour_average,$hit_count{$hour}).";";
         $css .= "border-top: 2px solid red;" if ($hour == substr($date_24,8,2) && $hour != 23);
         $css .= "background:#fff;color:#999;" if $hour > substr($date_24,8,2)+1;
         my $row = { css => $css, hour => $hour, hits => $hit_count{$hour} };
         push @hits_by_hour, $row;
      }
      my @sorted_hits_by_hour = sort {$b->{hour} <=> $a->{hour}} @hits_by_hour;
      for (0..(scalar @sorted_hits_by_hour)-1) {
         $sorted_hits_by_hour[$_]->{hour} = $hour_map{$sorted_hits_by_hour[$_]->{hour}};
      }
      
      # Hour data complete - param it.
      $param{hit_hour} = \@sorted_hits_by_hour;

      # Start breaking out the referrers
      my %referrers;
      foreach (@stats) {
          $referrers{$_->referrer}{"count"} = $referrers{$_->referrer}{"count"}+1;
          $referrers{$_->referrer}{"created_on"} = $_->created_on;
          $referrers{$_->referrer}{"url"} = $_->referrer;
          $referrers{$_->referrer}{"page"} = $_->url;
      } 
      
      my %blockedReferrer = (
         '-no referrer-'   => 1,
         ''                => 1,
         'http://Hidden-Referrer' => 1,
         'http://blockedReferrer' => 1,
      );

      my @search_engines = (
         { name   => 'Google',
           domain => qr{ \A www\.google\. [\w\.]{2,6} /search \z }xms,
           param  => 'q', },
         { name   => 'Google Images',
           domain => qr{ \A images\.google\. [\w\.]{2,6} /images \z }xms,
           param  => 'q', },
         { name   => 'Google Image Result',
           domain => qr{ \A images\.google\. [\w\.]{2,6} /imgres \z }xms,
           param  => 'imgurl', },
         { name   => 'Yahoo',
           domain => qr{ \A (?:\w{2}\.)? search\.yahoo\.com/ (?:bin/)? search \z }xms,
           param  => 'p', },
         { name   => 'MSN',
           domain => qr{ \A search\.msn\.com/results\.aspx \z }xms,
           param  => 'q', },
         { name   => 'Blingo',
           domain => qr{ \A www.blingo.com/search \z }xms,
           param  => 'q', },
         { name   => 'MyWay',
           domain => qr{ \A search\. \w{2} \.myway\.com/jsp/GGmain\.jsp \z }xms,
           param  => 'searchfor', },
         { name   => 'Comcast',
           domain => qr{ \A www\.comcast\.net/qry/websearch \z }xms,
           param  => 'query', },
      );
      
      ### Transformations and deletions occur here ###
      REFERRER:
      for my $referrer (keys %referrers) {
         ### Removal
         delete $referrers{$referrer} if $blockedReferrer{$referrer};
         ### self-referrers
         delete $referrers{$referrer} if ($referrer =~ m/^(?:\Q$site_url\E|\Q$app_url\E)/);

         ### Transformations
         
         $referrer =~ m{ \A https?:// ([^?]+) }xms;
         my $domain = $1;
         ENGINE:
         for my $engine (@search_engines) {
            next ENGINE unless $domain =~ $engine->{domain};

            $referrer =~ m{ [?&] $engine->{param} = ([^&]*) }xms;
            my $query = $1;
            $query =~ s{ %(..) }{ pack 'C', hex($1) }xmsge;

            my $new_ref = join(': ', $engine->{name}, $query);
            $referrers{$new_ref}{count} += $referrers{$referrer}{count};
            ## TODO: combine URLs somehow?
            $referrers{$new_ref}{url} = $referrer;
            delete $referrers{$referrer};
            next REFERRER;
         }
      }
      
      # Sort by count and then by most recent
      my $top_referrers = [];
      my @referrers = sort { $referrers{$b}{"count"} <=> $referrers{$a}{"count"} 
                             || $referrers{$b}{"created_on"} <=> $referrers{$a}{"created_on"} 
                             } keys %referrers;

      # Don't fill the referrer table with 14 entries if we only have 3
      my $referrers_to_display = 14;
      $referrers_to_display = scalar(@referrers) if scalar(@referrers) < $referrers_to_display;
      
      # Load pings from the last week
      require MT::TBPing;
      my @trackbacks_week = MT::TBPing->load({ blog_id => $blog_id, created_on => [$date_week, $date_now] }, { range => { created_on => 1 }});      
      
      my $i = 0;
      for (0..($referrers_to_display-1)) {
         my %referrer_results;
         $referrer_results{referrer_display} = trunc($referrers[$_], 70);
         $referrer_results{referrer_url} = $referrers{ $referrers[$_] }{url} || $referrers[$_];
                  
         # If we share a URL with a trackback in the last week then we append the trackback icon
         for my $trackback (@trackbacks_week) {
             if ($referrers[$_] eq $trackback->source_url) {
                 $referrer_results{referrer_tb_url}   = $trackback->source_url;
                 $referrer_results{referrer_tb_title} = $trackback->title;
                 $referrer_results{referrer_tb_blog}  = $trackback->blog_name;
             }
         }
         $referrer_results{referrer_class} = ++$i % 2 ? "odd" : "even";
         $referrer_results{referrer_count} = $referrers{$referrers[$_]}{"count"};
         push @$top_referrers, \%referrer_results;
      }
      
      $param{referrer_loop} = $top_referrers;

      # Sort our top pages for the week
      my $top_pages = [];   
      my %pages;
      foreach (@stats) {
         next if $_->url eq "";
         $pages{$_->url}{"count"} = $pages{$_->url}{"count"}+1;
         $pages{$_->url}{"referrer"} = $_->referrer unless $_->referrer eq "";
      }
      my @pages = sort { $pages{$b}{"count"} <=> $pages{$a}{"count"} } keys %pages;
      
      # Don't fill the pages table with 10 if we only have 2
      my $pages_to_display = 10;
      $pages_to_display = scalar(@pages) if scalar(@pages) < $pages_to_display;
      
      require MT::Entry;

      my $j = 0;      
      for (0..($pages_to_display-1)) {
         my %page_results;
         my $page_title;
         
         $page_results{page_title} = trunc($pages[$_], 70);
         
         # Label our blog entries with their entry title rather than URL
         if($blog->needs_fileinfo) {
            require MT::FileInfo;
            my $path = $pages[$_];
            $path =~ s{ \A \w+:// [^/]+ }{}xms;
            $path =~ s{ / \z }{ '/index' . ($blog->file_extension ? '.' . $blog->file_extension : '') }xmse;

            if(my $finfo = MT::FileInfo->load({ url => $path })) {
               if($finfo->entry_id) {
                  my $entry = MT::Entry->load($finfo->entry_id);
                  $page_results{page_is_entry} = 1;
                  $page_results{page_title} = $entry->title;
               } elsif($finfo->templatemap_id) {
                  require MT::TemplateMap;
                  require MT::Template::ContextHandlers;
                  require MT::Template::Context;
                  my $tmap = MT::TemplateMap->load($finfo->templatemap_id);

                  my $ctx = MT::Template::Context->new;
                  my $hdlrs = $ctx->type_handlers;
                  $ctx->stash('blog', $blog);
                  if(my $hdlr = $hdlrs->{$tmap->archive_type}) {
                     my $title = $hdlr->{section_title}->($ctx, {}, $finfo->startdate);

                     $page_results{page_is_entry} = 1;
                     $page_results{page_title} = $title;
                  }
               } elsif($finfo->template_id) {
                  require MT::Template;
                  my $template = MT::Template->load($finfo->template_id);
                  $page_results{page_is_entry} = 1;
                  $page_results{page_title} = $template->name;
               }
            }
         } else {
            my ($basename, $extension) = split(/\./, makefileurl($pages[$_]));
            if ($has_indiv && $basename) {
               if (my $entry = MT::Entry->load({ basename => $basename })) {
                  $page_results{page_is_entry} = 1;
                  $page_results{page_title} = $entry->title;
               }
            }
         }
         $page_results{class} = ++$j % 2 ? "odd" : "even";
         $page_results{page_url} = $pages[$_];
         $page_results{page_count} = $pages{$pages[$_]}{"count"};
         push @$top_pages, \%page_results;
      }
      $param{page_loop} = $top_pages;
      
   } else { $app->redirect($param{statwatch_url}) }
   #>####################################################

   $param{version} = $VERSION;
   $param{gen_time} = " | ".$now." seconds";

   $app->build_page('tmpl/view.tmpl', \%param);
}

sub usableDate {
    my ($type, $offset) = @_;
    $offset = $offset || -8;
    use DateTime;
    
    # ADDING NEGATIVE HOURS IS GOOD FOR YOU
    
    my $date;
    if ($type eq "now") {
        if ($offset < 0) {
            $date = DateTime->now()->add(hours => $offset);
        } else {
            $date = DateTime->now()->subtract(hours => $offset);
        }
        $date = $date->ymd('').$date->hms('');
    } elsif ($type eq "day") {    
        if ($offset < 0) {
            $date = DateTime->now()->add(hours => $offset);
        } else {
            $date = DateTime->now()->subtract(hours => $offset);
        }
        $date = $date->ymd('')."000000";
    } elsif ($type eq "24") {
        if ($offset < 0) {
            $date = DateTime->now()->add(hours => $offset)->subtract(days => 1);
        } else {
            $date = DateTime->now()->subtract(hours => $offset,days => 1);
        }
        $date = $date->ymd('').$date->hms('');
    } elsif ($type eq "168") {
        if ($offset < 0) {
            $date = DateTime->now()->add(hours => $offset)->subtract(days => 7);
        } else {
            $date = DateTime->now()->subtract(hours => $offset,days => 7);
        }
        $date = $date->ymd('').$date->hms('');
    } elsif ($type eq "feedburner") {
        if ($offset < 0) {
            $date = DateTime->now()->add(hours => $offset)->subtract(days => 7);
        } else {
            $date = DateTime->now()->subtract(hours => $offset,days => 7);
        }
        my $date_end = $date->clone->add(days => 6)->ymd('-');
        $date = $date->ymd('-');
        $date = $date.",".$date_end;
    }
    
    return ($date);
}

sub getStats {
    my ($blog_id, $date_start, $date_end) = @_;
    
    # Set the range to all week if no dates are passed in
    if (!$date_start || !$date_end) {
        use MT::Blog;
        my $blog = MT::Blog->load({ id => $blog_id }) or die "Can't load blog_id $blog_id ";
        
        if (!$date_start) {
            my ($date_week) = usableDate("168",$blog->server_offset);
            $date_start = $date_week;
        }
        if (!$date_end) {
            my ($date_now) = usableDate("now",$blog->server_offset);
            $date_end = $date_now;
        }
    }
    
    # Load our specified range or all week
    my @stats;
    @stats = Stats->load({ blog_id => $blog_id, 
                           created_on => [$date_start, $date_end] 
                          }, 
                         { range => {created_on => 1} 
                          });
    
    # Hits, uniques, referrers and pages
    my $hits = scalar(@stats);
    my (%uniques,%referrers,%pages);
    foreach (@stats) {
        $uniques{$_->ip} = 1;
        $referrers{$_->referrer} = $referrers{$_->referrer}+1;
        $pages{$_->url} = $pages{$_->url}+1;
    }
    my @referrers = sort { $referrers{$b} <=> $referrers{$a} } keys %referrers;
    my @pages = sort { $pages{$b} <=> $pages{$a} } keys %pages;

    return ($hits,scalar(keys%uniques),($referrers[0] || $referrers[1]),$pages[0]);
}

sub getFeedStats {
    my ($blog_url, $date_start, $date_end) = @_;
    use LWP::UserAgent;
    
    my $user_agent = LWP::UserAgent->new;
    $user_agent->agent("StatWatch/$VERSION ");

    my $blog_request = HTTP::Request->new(GET => $blog_url);
    my $blog_response = $user_agent->request($blog_request);
    
    my $feed_url;
    #die Dumper( @{ $blog_response->headers->{link} } );
    for my $link (@{ $blog_response->headers->{link} }) {
        my @link_bits = split(/;/,$link);
        chop(my $url = substr($link_bits[0],1));
        if (substr($url,0,28) eq "http://feeds.feedburner.com/") {
            $feed_url = $url;
            last;
        }
    }

    my ($feed_subscribers,$feed_subscribers_bg,$has_feed,$feed_average,$feed_permit);
    if ($feed_url) {        
        my $feed_dates = usableDate("feedburner");
        my $feed_average_request = HTTP::Request->new(GET => "http://api.feedburner.com/awareness/1.0/GetFeedData?uri=$feed_url&dates=$feed_dates");
        my $feed_average_response = $user_agent->request($feed_average_request);

        use XML::Simple;
        my $averages_xml = XMLin($feed_average_response->content);

        unless ($averages_xml->{stat} eq "fail") {
            my $i;
            for my $entry ( @{ $averages_xml->{feed}->{entry} } ) {
                $feed_average += $entry->{circulation};
                $i++;
            }
            $feed_average = int($feed_average/$i);
            $feed_subscribers_bg = generate_bg($feed_average, @{ $averages_xml->{feed}->{entry} }[-1]->{circulation});
            $feed_subscribers = @{ $averages_xml->{feed}->{entry} }[-1]->{circulation};
            $has_feed = 1;
        } else {
            $feed_permit = 1 if $averages_xml->{err}->{code} == 2;
        }
    }
    return ($feed_subscribers, $feed_subscribers_bg, $has_feed, $feed_average, $feed_permit);
}

sub setup {
   # I got this from Jay. Databases scare me.
   my $cfg = MT::ConfigMgr->instance;
   my $path = $ENV{SCRIPT_FILENAME};
   substr($path, -13) = "";

   require MT::Object;
   require File::Spec;
   if ($cfg->ObjectDriver =~ /^DBI::(.*)$/) {
      my $db_type = $1;
      my $dbh = MT::Object->driver->{dbh};
      my $schema = File::Spec->catfile($path.'/schemas', $db_type . '.dump') or die "Can't find schema file";
      open FH, $schema or die "Can't open schema file '$schema': $!";
      my $ddl;
      { local $/; $ddl = <FH> }
      close FH;
      my @stmts = split /;/, $ddl;
      for my $stmt (@stmts) {
         $stmt =~ s!^\s*!!;
         $stmt =~ s!\s*$!!;
         next unless $stmt =~ /\S/;
         $dbh->do($stmt) or next;#die $dbh->errstr;
      }
   }
   
   my $data = MT::PluginData->new;
   $data->plugin('statwatch');
   $data->key('setup_'.$VERSION);
   $data->data('1');
   $data->save or die "Unable to save setup confirmation", $data->errstr;
   
   foreach ('','_0.5','_0.99','_1','_1.1') {
      my $old_data;
      if ($old_data = MT::PluginData->load({ key => 'setup'.$_ })) {
         $old_data->remove;
      }
   }
}

sub parse_cfg {
   require MT::ConfigMgr;
   my $cfg = MT::ConfigMgr->instance;
   
   my $cgipath = $cfg->CGIPath;
   $cgipath .= "/" if (substr($cgipath,-1,1) ne "/");
   
   my $script_url = $cgipath . 'mt.cgi';
   my $static_uri;
   if ($cfg->StaticWebPath) {$static_uri = $cfg->StaticWebPath}
   else {$static_uri =  $cgipath."mt-static/";}
   
   return ($script_url, $cgipath."plugins/statwatch/", $cgipath."plugins/statwatch/statwatch.cgi", $static_uri);   
}

###
# Supporting methods
###

sub generate_bg {
   # gets two numbers, an average and then an actual number
   # returns a hex color in a specific range of blue based on the actual number being above or below the average
   my $partial_colors = ($_[1] / ($_[0] || 1))*51;
   if ($partial_colors > 102) {$partial_colors = 102}
   my $bg = (sprintf "%lx", 255-($partial_colors)) . (sprintf "%lx", 255-($partial_colors/2));
   
   $bg .= 'ff';
   return $bg;
}

sub makefileurl {
   # http://www.someurl.com/folder/thisdocument.html
   # to
   # thisdocument.html
   my ($url) = @_;
   return undef if (substr($url, -1) eq "/");
   my @url_bits = split(/\//, $url);
   $url_bits[-1];
}

sub makebaseurl {
   # http://www.someurl.com/folder/thisdocument.html
   # to
   # http://www.someurl.com/folder/
   my ($url) = @_;
   return $url if (substr($url, -1) eq "/");
   my @url_bits = split(/\//, $url);
   my $new_url;
   for (0..(scalar(@url_bits)-2)) {
      $new_url .= $url_bits[$_].'/';
   }
   $new_url;
}

sub trunc {
    # Truncate a string to a certain number of characters.
    # Appends ... to the end of any truncated string.
    # Returns the same string it was fed if not over the limit.
    my ($str, $lim) = @_;
    if ($lim < $str =~ tr/.//c) {
        $str = substr($str,0,$lim)."...";
    }
    $str;
}

1;
