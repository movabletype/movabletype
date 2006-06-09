# StatWatch - lib/StatWatch/Visit.pm
# Nick O'Neill (http://www.raquo.net/statwatch/)

package StatWatch::Visit;
use strict;

use MT::App;
@StatWatch::Visit::ISA = qw( MT::App );

use Stats;
my $VERSION = '1.2';
my $DEBUG = 0;

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        visit => \&visit,
    );
    $app->{default_mode} = 'visit';
    $app->{user_class} = 'MT::Author';

    $app->{charset} = $app->{cfg}->PublishCharset;
    my $q = $app->{query};

    $app;
}

sub visit {
   my $app = shift;
   my $q = $app->{query};
   my $blog_id;
	my $force_compile = $q->param('force_compile') || 0;
   
   if ($blog_id = $q->param('blog_id')) {
      require MT::Blog;
      my $blog = MT::Blog->load({ id => $blog_id }) or die "Error loading blog from blog_id $blog_id";

      my $stats = Stats->new;

      ### We gotta be clean
	   my $referrer = MT::Util::is_valid_url($q->param('refer'));
	   my $url = MT::Util::is_valid_url($q->param('url'));

      $stats->ip($app->remote_ip);
      $stats->referrer($referrer);
      $stats->blog_id($blog_id);
      $stats->url($url);
   
      &compileStats($blog_id,$app->remote_ip);

      $stats->save or die "Saving stats failed: ", $stats->errstr;
   } else {
      die "No blog id";
   }
}

sub compileStats {
   my ($blog_id, $ip) = @_;

   require MT::PluginData;
   require StatWatchConfig;
   require MT::Blog;
   BEGIN { $ENV{PERL_DATETIME_PP} = 1; }
   require DateTime;
   
   unless (MT::PluginData->load({ plugin => 'statwatch', key => 'config_'.$blog_id })) { &statconfig($blog_id) }
   
   my $config;
   $config = StatWatchConfig->load( {blog_id => $blog_id} ) or die "Can't load statwatch config for $blog_id ";
   my $last_compile = parseDate($config->last_compile);
   
   my $blog = MT::Blog->load( {id => $blog_id} ) or die "Cannot load MT::Blog";
   my $offset = $blog->server_offset;
   my $now;
   if ($offset <= 0) { $now = DateTime->now()->subtract(hours => substr($offset, 1, 1))
                      ->set(hour => 0, minute => 0, second => 0) }
   else { $now = DateTime->now()->add(hours => $offset)->set(hour => 0, minute => 0, second => 0) }
   my $last_week = $now->clone()->subtract(days => 7);

   while ($last_compile->ymd('') < $now->ymd('')) {
      
      ### Gotta load the stats from our current uncompiled day
      my @daily_stats = Stats->load( {blog_id => $config->blog_id,
                                    created_on => [ 
                                                   $last_compile->ymd('').'000000', 
                                                   $last_compile->ymd('').'235959'
                                                   ]}, 
                                   {sort => 'created_on', range_incl => { created_on => 1 }});      

      ### Set up all our data for easy calculations
      my $hits = scalar @daily_stats;
      my %hit_track;
      my %hit_count = ("00"=>"0","01"=>"0","02"=>"0","03"=>"0","04"=>"0","05"=>"0","06"=>"0","07"=>"0",
                       "08"=>"0","09"=>"0","10"=>"0","11"=>"0","12"=>"0","13"=>"0","14"=>"0","15"=>"0",
                       "16"=>"0","17"=>"0","18"=>"0","19"=>"0","20"=>"0","21"=>"0","22"=>"0","23"=>"0");
      for my $stat (@daily_stats) {
         my $hour = substr($stat->created_on,8,2);
         push @{$hit_track{"$hour"}}, $stat->ip;
         $hit_count{"$hour"} = scalar @{$hit_track{"$hour"}};
      }

      ### New hits ###
      $config->average_hits((($config->average_hits*$config->average_hits_count)+$hits)/($config->average_hits_count+1));
      $config->average_hits_count($config->average_hits_count+1);
      ################

      ### New uniques ###
      my %uniques;
      $uniques{$_->ip} = 1 foreach @daily_stats;
      $config->average_uniques((($config->average_uniques*$config->average_uniques_count)+keys %uniques)/($config->average_uniques_count+1));
      $config->average_uniques_count($config->average_uniques_count+1);
      ###################

      ### New hourly data ###
      $config->average_hour((($config->average_hour*$config->average_hour_count)+scalar @daily_stats)/($config->average_hour_count+24));
      $config->average_hour_count($config->average_hour_count+24);
      #######################
      
      #<# Pick up our feed stats ##############
      if ($config->feed_url) {
         use LWP::UserAgent;
         my $user_agent = LWP::UserAgent->new;
         $user_agent->agent("StatWatch/$VERSION ");

         my $feed_url = $config->feed_url;
         my $feed_date = $last_compile->ymd('-');
         my $request = HTTP::Request->new(GET => "http://api.feedburner.com/awareness/1.0/GetFeedData?uri=$feed_url&amp;dates=$feed_date");
         my $response = $user_agent->request($request);

         use XML::Simple;      
         my $xml = XMLin($response->content);

         my $feed_hits = $xml->{feed}->{entry}->{hits};
         my $feed_subscribers = $xml->{feed}->{entry}->{circulation};
      
         ### New Feed data ###
         $config->average_feed((($config->average_feed*$config->average_feed_count)+$feed_hits)/($config->average_feed_count+1));
         $config->average_feed_count($config->average_feed_count+1);
         #####################
      }
      #########################################
      
      $last_compile->add( days => 1) or die "Failed adding a day to last compile time.";
      $config->last_compile($last_compile) or die "Failed assigning day to last_compile.";

      $config->save or die "Failed saving config values in compilation loop. ".$config->errstr;
      
      ### Remove stats more than a week old ###
      my @old_stats;
      if (@old_stats = Stats->load( {blog_id => $blog_id,
                                     created_on => [ 
                                                    '00000000000000', 
                                                    $last_week->ymd('').'235959'
                                                   ]}, 
                                    {sort => 'created_on', range_incl => { created_on => 1 }})){
         for my $stat (@old_stats) {
            $stat->remove or die "Old stat removal failed: ", $stat->errstr;
         }
      }
      #########################################
   }
}

sub statconfig {
   my ($blog_id) = @_;
   require StatWatchConfig;
   BEGIN { $ENV{PERL_DATETIME_PP} = 1;}
   require DateTime;


   ### Make me a config!
   my $config = StatWatchConfig->new;
   $config->blog_id($blog_id);
   $config->last_compile(DateTime->now());
   $config->average_hits(0);
   $config->average_hits_count(0);
   $config->average_uniques(0);
   $config->average_uniques_count(0);
   $config->average_hour(0);
   $config->average_hour_count(0);
   $config->average_feed(0);
   $config->average_feed_count(0);
   $config->feed_url();
   $config->save or die $config->errstr;

   require MT::PluginData;

   ### Dear Configuration,
   ###   I had a good time tonight but I don't think we should do this again
   ###   It's not your fault, it's me - really.
   ### -Your Blog
   my $data = MT::PluginData->new;
   $data->plugin('statwatch');
   $data->key('config_'.$blog_id);
   $data->data('1');
   $data->save or die "Unable to save config confirmation", $data->errstr;   
}

sub parseDate {
   my ($string_date) = @_;

   ### I'll stop assuming we're using mysql when I start testing on something else
   my $datetime_obj = DateTime->new( year    => substr($string_date,0,4),
                                     month   => substr($string_date,5,2),
                                     day     => substr($string_date,8,2),
                                     #hour    => substr($string_date,11,2),
                                     #minute  => substr($string_date,14,2),
                                     #second  => substr($string_date,17,2),
                                    );
   return $datetime_obj;
}

1;
