package MT::App::ActivityFeeds;

use strict;

use MT::App;

use vars qw(@ISA);
@ISA = qw(MT::App);

use MT::Author qw(AUTHOR);
use MT::Util qw(perl_sha1_digest_hex ts2iso iso2ts);

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{template_dir} = 'feeds';
    $app->{requires_login} = 1;
    $app->{is_admin} = 1;
    $app->init_core_callbacks();
}

# Defines the basic MT activity feeds.
sub init_core_callbacks {
    my $app = shift;

    MT->_register_core_callbacks({
        'ActivityFeed.system' => \&_feed_system,
        'ActivityFeed.comment' => \&_feed_comment,
        'ActivityFeed.blog' => \&_feed_blog,
        'ActivityFeed.ping' => \&_feed_ping,
        'ActivityFeed.debug' => \&_feed_debug,
        'ActivityFeed.entry' => \&_feed_entry
    });
}

# authenticate with user package using the web services password instead 
# of the normal user password. also note that we're not messing with user 
# session records, since we aren't setting a login cookie for feeds.
sub login {
    my $app = shift;
    my $username = $app->param('username');
    my $token = $app->param('token');

    my $user_class = $app->{user_class};
    eval "use $user_class;";
    return $app->error($app->translate("Error loading [_1]: [_2]", $user_class, $@)) if $@;
    my $author = $user_class->load({ name => $username, type => AUTHOR });
    if ($author && (($author->api_password || '') ne '')) {
        my $auth_token = perl_sha1_digest_hex('feed:' . $author->api_password);
        if ($token eq $auth_token) {
            $app->{author} = $app->{$app->user_cookie} = $author;
            return ($author);
        }
    }
    (undef)
}

# A place to store session data for activity feeds.
sub session {
    my $app = shift;
    return $app->{session} if exists $app->{session};

    my $user = $app->user;
    return undef unless $user;

    my $part1 = $user->id;
    my $part2 = $app->query_string;

    # creates an 80-character id that uniquely identifies an individual
    # feed in the session table.
    my $id = perl_sha1_digest_hex($part1) . perl_sha1_digest_hex($part2);

    require MT::Session;
    my $sess = MT::Session->load({ id => $id, kind => 'AF' });
    if (!$sess) {
        $sess = new MT::Session;
        $sess->id($id);
        $sess->start(time);
        $sess->kind('AF');
    }

    $app->{session} = $sess;
}

# Default mode of MT::App::ActivityFeeds; uses the 'view' parameter to
# differentiate between the different types of feeds available. Feed
# data is populated by callback, so plugins can intercept the feed
# elements if so desired, or can append things to a feed as well.
sub mode_default {
    my $app = shift;
    my $view = $app->param('view') || 'system';

    # clean up view parameter; simple ascii only
    $view =~ s/[^A-Za-z_0-9-]//g;

    require XML::Atom::Feed;
    require XML::Atom::Entry;
    require XML::Atom::Link;

    # Give the Task Manager layer a chance to run.
    MT->run_tasks() if $app->config->ActivityFeedsRunTasks;

    my $feed = new XML::Atom::Feed(Version => 1.0);

    MT->run_callbacks("ActivityFeed.$view", $app, $view, $feed);

    my $mod_since = $app->get_header('If-Modified-Since');
    if ($mod_since) {
        # TBD: conditional get support
        # If-Modified-Since, to check for date-based selection of records
        # If-None-Match, to check for a hashcode, compared against a code
        # that was generated with the last response, through the Etag header.
        # return a 304 response if condition is not met
    }

    $app->send_http_header("application/atom+xml");
    $app->{no_print_body} = 1;
    my $feed_result = $feed->as_xml;
    if ($feed_result !~ m/<\?xml\b/) {
        my $charset = $app->config('PublishCharset');
        my $xml_decl = qq{<?xml version="1.0" encoding="$charset"?>\n};
        $feed_result = $xml_decl . $feed_result;
    }
    $app->print($feed_result);
}

# The purpose of feed_properties, feed_person, feed_link, feed_entry
# is to keep the interface with XML::Atom from the as much as possible,
# since we plan to supplant it with a new package at some point.

# Used to supply the Atom Feed element properties.
sub feed_properties {
    my $app = shift;
    my ($feed, $param) = @_;

    if ($param->{link}) {
        my $link = $app->feed_link({
            type => $param->{link_type},
            rel => $param->{link_rel},
            href => $param->{link},
            title => $param->{link_title}
        });
        $feed->add_link($link);
    }
    $feed->title($param->{title}) if exists $param->{title} && defined $param->{title};
}

# Returns a new Atom person element, populated with the parameters given.
sub feed_person {
    my $app = shift;
    my ($param) = @_;

    my $person = new XML::Atom::Person(Version => 1.0);
    $person->name($param->{name});
    $person->uri($param->{uri}) if exists $param->{uri};
    $person->email($param->{email}) if exists $param->{email};
    $person;
}

# Returns a new Atom link, populated with the parameters given.
sub feed_link {
    my $app = shift;
    my ($param) = @_;

    my $link = XML::Atom::Link->new(Version => 1.0);
    $link->type($param->{type} || 'text/html');
    $link->rel($param->{rel} || 'alternate');
    $link->href($param->{href} || $param->{link});
    $link->title($param->{title}) if exists $param->{title} && defined $param->{title};
    $link;
}

# Returns a new Atom entry, populated with the parameters given.
sub feed_entry {
    my $app = shift;
    my ($param) = @_;

    my $entry = XML::Atom::Entry->new(Version => 1.0);
    $entry->title($param->{title}) if exists $param->{title};
    $entry->published(ts2iso(undef, $param->{published})) if exists $param->{published};
    $entry->updated(ts2iso(undef, $param->{updated})) if exists $param->{updated};
    $entry->id($param->{id}) if exists $param->{id};
    $entry->content($param->{content}) if exists $param->{content};
    if ($param->{link}) {
        my $link = $app->feed_link({
            href => $param->{link},
            title => $param->{link_title},
            rel => $param->{link_rel},
            type => $param->{link_type}
        });
        $entry->add_link($link);
    }
    $entry;
}

# Generic log to feed; limit using $terms and populate $feed.
sub process_log_feed {
    my $app = shift;
    my ($terms, $feed) = @_;

    my %templates;
    my $max_items = $app->config('ActivityFeedItemLimit') || 50;

    my $last_mod = $app->get_header('If-Modified-Since');
    if ($last_mod) {
        $last_mod = iso2ts(undef, $last_mod);
    }

    require MT::Log;
    my $cfg = $app->config;
    my $iter = MT::Log->load_iter($terms,
        { ($cfg->ObjectDriver ne 'DBM' ?  # work around a flaw in DBM driver
          ('sort' => 'id') :
          ('sort' => 'created_on')),
           'direction' => 'descend'});
    my $count = 0;
    while (my $log = $iter->()) {
        my $ts = $log->created_on;
        my $entry = $app->feed_entry({
            title => $log->message,
            published => $ts,
            updated => $ts,
            id => $app->base . $app->mt_uri . ':log-' . $log->id,
        });
        my $content = $log->format('atom', $entry);
        if ($log->class) {
            my $tmpl = $templates{$log->class} ||= $app->load_tmpl("feed_" . $log->class . ".tmpl");
            $tmpl ||= $templates{'system'} ||= $app->load_tmpl("feed_system.tmpl");
            if ($tmpl) {
                my %param = (
                    log_message => $log->message,
                    log_id => $log->id,
                    log_metadata => $log->metadata,
                    log_ip => $log->ip,
                    content => $content,
                    blog_id => $log->blog_id,
                    log_class => $log->class,
                    log_category => $log->category,
                    log_level => $log->level,
                );
                $param{"log_level_" . $log->level} = 1
                    if $log->level;
                $param{"log_class_" . $log->class} = 1
                    if $log->class;
                $param{"log_category_" . $log->category} = 1
                    if $log->category;
                $entry->content($app->build_page($tmpl, \%param));
            }
        }
        $feed->add_entry($entry);
        $count++;
        last if $last_mod && ($ts < $last_mod);
        last if $count == $max_items;
    }
}

# Takes the parameters given and translates them into MT::Log-compatible
# terms used to filter the dataset.
sub apply_log_filter {
    my $app = shift;
    my ($param) = @_;
    my %arg;
    if ($param) {
        my $filter_col = $param->{filter};
        my $val = $param->{filter_val};
        if ($filter_col && $val) {
            if ($filter_col eq 'level') {
                my @types;
                for (1,2,4,8,16) {
                    push @types, $_ if $val & $_;
                }
                if (@types) {
                    $arg{'level'} = \@types;
                }
            } elsif ($filter_col eq 'class') {
                $arg{class} = [ split /,/, $val ];
            }
        }
        $arg{blog_id} = [ split /,/, $param->{blog_id} ]
            if $param->{blog_id};
    }
    \%arg;
}

sub _feed_ping {
    my ($cb, $app, $view, $feed) = @_;

    my $user = $app->user;

    require MT::Blog;
    my $blog;

    # verify user has permission to view entries for given weblog
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        if (!$user->is_superuser) {
            require MT::Permission;
            my $perm = MT::Permission->load({ author_id => $user->id, blog_id => $blog_id });
            return unless $perm;
        }
        $blog = MT::Blog->load($blog_id) or return;
    } else {
        if (!$user->is_superuser) {
            # limit activity log view to only weblogs this user has permissions for
            my @perms = MT::Permission->load({ author_id => $user->id });
            return unless @perms;
            my @blog_list;
            push @blog_list, $_->blog_id foreach @perms;
            $blog_id = join ',', @blog_list;
        }
    }

    my $link;
    $link = $app->base . $app->mt_uri( mode => 'list_pings',
        args => { $blog ? (blog_id => $blog_id) : () } );
    $app->feed_properties($feed, {
        link => $link,
        link_title => $blog ?
            $app->translate("TrackBacks for [_1]", $blog->name) :
            $app->translate("All TrackBacks"),
        title => $blog ?
            $app->translate('[_1] Weblog TrackBacks', $blog->name) :
            $app->translate("All Weblog TrackBacks")
    });

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter({
        filter => 'class',
        filter_val => 'ping',
        $blog_id ? ( blog_id => $blog_id ) : (),
    });
    $app->process_log_feed($terms, $feed);
}

sub _feed_comment {
    my ($cb, $app, $view, $feed) = @_;

    my $user = $app->user;

    require MT::Blog;
    my $blog;

    # verify user has permission to view entries for given weblog
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        if (!$user->is_superuser) {
            require MT::Permission;
            my $perm = MT::Permission->load({ author_id => $user->id, blog_id => $blog_id });
            return unless $perm;
        }

        $blog = MT::Blog->load($blog_id) or return;
    } else {
        # limit activity log view to only weblogs this user has permissions for
        if (!$user->is_superuser) {
            my @perms = MT::Permission->load({ author_id => $user->id });
            return unless @perms;
            my @blog_list;
            push @blog_list, $_->blog_id foreach @perms;
            $blog_id = join ',', @blog_list;
        }
    }

    my $link;
    $link = $app->base . $app->mt_uri( mode => 'list_comments',
        args => { $blog ? (blog_id => $blog_id) : () } );
    $app->feed_properties($feed, {
        link => $link,
        link_title => $blog ?
            $app->translate("Comments for [_1]", $blog->name) :
            $app->translate("All Comments"),
        title => $blog ?
            $app->translate('[_1] Weblog Comments', $blog->name) :
            $app->translate("All Weblog Comments")
    });

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter({
        filter => 'class',
        filter_val => 'comment',
        $blog_id ? ( blog_id => $blog_id ) : (),
    });
    $app->process_log_feed($terms, $feed);
}

sub _feed_entry {
    my ($cb, $app, $view, $feed) = @_;

    my $user = $app->user;

    require MT::Blog;
    my $blog;

    # verify user has permission to view entries for given weblog
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        if (!$user->is_superuser) {
            require MT::Permission;
            my $perm = MT::Permission->load({ author_id => $user->id, blog_id => $blog_id });
            return unless $perm;
        }

        $blog = MT::Blog->load($blog_id) or return;
    } else {
        if (!$user->is_superuser) {
            # limit activity log view to only weblogs this user has permissions for
            my @perms = MT::Permission->load({ author_id => $user->id });
            return unless @perms;
            my @blog_list;
            push @blog_list, $_->blog_id foreach @perms;
            $blog_id = join ',', @blog_list;
        }
    }

    my $link;
    $link = $app->base . $app->mt_uri( mode => 'list_entries',
        args => { $blog ? (blog_id => $blog_id) : () } );
    $app->feed_properties($feed, {
        link => $link,
        link_title => $blog ?
            $app->translate("Entries for [_1]", $blog->name) :
            $app->translate("All Entries"),
        title => $blog ?
            $app->translate('[_1] Weblog Entries', $blog->name) :
            $app->translate("All Weblog Entries")
    });

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter({
        filter => 'class',
        filter_val => 'entry',
        $blog_id ? ( blog_id => $blog_id ) : (),
    });
    $app->process_log_feed($terms, $feed);
}

sub _feed_blog {
    my ($cb, $app, $view, $feed) = @_;

    my $user = $app->user;

    # verify user has permission to view entries for given weblog
    my $blog_id = $app->param('blog_id');

    require MT::Blog;
    my $blog;

    if ($blog_id) {
        if (!$user->is_superuser) {
            require MT::Permission;
            my $perm = MT::Permission->load({ author_id => $user->id, blog_id => $blog_id });
            return unless $perm;
        }

        $blog = MT::Blog->load($blog_id) or return;
    } else {
        if (!$user->is_superuser) {
            # limit activity log view to only weblogs this user has permissions for
            my @perms = MT::Permission->load({ author_id => $user->id });
            return unless @perms;
            my @blog_list;
            push @blog_list, $_->blog_id foreach @perms;
            $blog_id = join ',', @blog_list;
        }
    }

    my $link;
    if ($blog) {
        $link = $app->base . $app->mt_uri( mode => 'show_menu', args => { blog_id => $blog_id } );
    } else {
        $link = $app->base . $app->mt_uri( mode => 'system_list_blogs' );
    }
    $app->feed_properties($feed, {
        link => $link,
        link_title => $blog ?
            $app->translate("[_1] Weblog", $blog->name) :
            $app->translate("All Weblogs"),
        title => $blog ?
            $app->translate('[_1] Weblog Activity', $blog->name) :
            $app->translate("All Weblog Activity")
    });

    # user has permissions to view this type of feed... continue
    my $terms = $app->apply_log_filter({
        filter => 'class',
        filter_val => 'entry,comment,ping',
        $blog_id ? ( blog_id => $blog_id ) : ()
    });
    $app->process_log_feed($terms, $feed);
}

sub _feed_system {
    my ($cb, $app, $view, $feed) = @_;

    my $user = $app->user;
    my $blog_id = $app->param('blog_id');
    my $filter = $app->param('filter');
    my $filter_val = $app->param('filter_val');

    # verify user has permission to view entries for given weblog
    if (!$user->is_superuser) {
        if ($blog_id) {
            require MT::Permission;
            my $perm = MT::Permission->load({ author_id => $user->id, blog_id => $blog_id });
            return unless $perm && ($perm->can_administer_blog || $perm->can_view_blog_log);
        }
    }

    my $args;
    $args->{filter} = $filter if $filter;
    $args->{filter_val} = $filter_val if $filter_val;
    $args->{blog_id} = $blog_id if $blog_id;
    my $link = $app->base . $app->mt_uri( mode => 'view_log', args => $args );

    $app->feed_properties($feed, {
        link => $link,
        link_title => $app->translate("Movable Type Activity Log"),
        title => $app->translate('Movable Type System Activity')
    });

    my $terms = $app->apply_log_filter({
        $blog_id ? ( blog_id => $blog_id ) : (),
        $filter ? ( filter => $filter, filter_val => $filter_val ) : ()
    });
    $app->process_log_feed($terms, $feed);
}

sub _feed_debug {
    my ($cb, $app, $view, $feed) = @_;

    my $user = $app->user;
    return unless $user->is_superuser;
    my $terms = $app->apply_log_filter({
        'filter' => 'class',
        'filter_val' => 'debug'
    });
    $app->process_log_feed($terms, $feed);
}

1;
__END__

=head1 NAME

MT::App::ActivityFeeds

=head1 DESCRIPTION

Movable Type application for producing activity feeds. Activity feeds
are typically produced from the user's log table, but the application
relies heavily on the MT callback architecture for generating the
feed content.

Plugins can hook into these callbacks to either alter or supplement feed
content.

=head1 CALLBACKS

=over 4

=item ActivityFeed

=item ActivityFeed <view>

    callback($eh, $app, $view, $feed)

The ActivityFeed callback drives the generation of the feed.  The default
handler for this callback executes with a callback priority of 5.  Plugins
can register with a priority lower than 5 to prepend content to the feed
or a priority higher than 5 to append content to the feed (and also
manage elements that have already been added to the feed).

=back

=head1 METHODS

=head2 $app->feed_entry(\%param)

=over 4

=item title

=item published

=item updated

=item id

=item content

=item link

=item link_title

=item link_rel

=item link_type

=back

=head2 $app->feed_link(\%param)

This method creates a new "link" feed element that is used to assign
to a particular feed entry. The parameters you can supply in the param hashref
are:

=over 4

=item type - The MIME type of the link (defaults to "text/html").

=item rel - The link relationship (defaults to "alternate").

=item href (or 'link') - The URL of the link (required).

=item title - The title to use for the link (required).

=back

=head2 $app->feed_person(\%param)

This method creates a new "person" feed element that is used to assign
to a particular feed entry. The parameters you can supply in the param hashref
are:

=over 4

=item name - The name for the person (required).

=item uri - The URI of the person.

=item email - The email address of the person.

=back


=head2 $app->feed_properties($feed, \%param)

This method is used to assign the various properties of the feed. This
method is provided to abstract the interface to the underlying feed
implementation. The parameters you can supply in the param hashref are:

=over 4

=item link - The URL to use for the feed link.

=item link_type - The 'type' to assign to the feed link.

=item link_rel - The link relationship of the feed link.

=item link_title - The title to assign to the feed link.

=item title - The title to assign for the feed itself.

=back

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
