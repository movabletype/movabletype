# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::App::Trackback;
use strict;

use File::Spec;
use MT::TBPing;
use MT::Trackback;
use MT::Util qw( first_n_words encode_xml is_valid_url
    start_background_task );
use MT::JunkFilter qw(:constants);
use MT::App;
use MT::I18N qw( encode_text guess_encoding const length_text wrap_text substr_text first_n_text );
@MT::App::Trackback::ISA = qw( MT::App );

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        ping => \&ping,
        view => \&view,
        rss => \&rss,
    );
    $app->{default_mode} = 'ping';
    $app;
}

sub view {
    my $app = shift;
    my $q = $app->param;
    require MT::Template;
    require MT::Template::Context;
    require MT::Entry;
    my $entry_id = $q->param('entry_id');
    my $entry = MT::Entry->load({ id => $entry_id, status => MT::Entry::RELEASE() })
        or return $app->error($app->translate(
            "Invalid entry ID '[_1]'", $entry_id));
    my $ctx = MT::Template::Context->new;
    $ctx->stash('entry', $entry);
    $ctx->{current_timestamp} = $entry->created_on;
    my $tmpl = MT::Template->load({ type => 'pings',
                                    blog_id => $entry->blog_id })
        or return $app->error($app->translate(
            "You must define a Ping template in order to display pings."));
    defined(my $html = $tmpl->build($ctx))
        or return $app->error($tmpl->errstr);
    $html;
}

## The following subroutine strips the UTF8 flag from a string, thus
## forcing it into a series of bytes. "pack 'C0'" is a magic way of
## forcing the following string to be packed as bytes, not as UTF8.
sub no_utf8 {
    for (@_) {
        next if !defined $_;
        $_ = pack 'C0A*', $_;
    }
}

my %map = ('&' => '&amp;', '"' => '&quot;', '<' => '&lt;', '>' => '&gt;');
sub _response {
    my $app = shift;
    my %param = @_;
    $app->response_code($param{Code});
    $app->send_http_header('text/xml; charset=utf-8');
    $app->{no_print_body} = 1;

    if (my $err = $param{Error}) {
        my $re = join '|', keys %map;
        $err =~ s!($re)!$map{$1}!g;
        $err = encode_text($err, undef, 'utf-8');
        print <<XML;
<?xml version="1.0" encoding="utf-8"?>
<response>
<error>1</error>
<message>$err</message>
</response>
XML
    } else {
        print <<XML;
<?xml version="1.0" encoding="utf-8"?>
<response>
<error>0</error>
XML
        if (my $rss = $param{RSS}) {
            $rss = encode_text($rss, undef, 'utf-8');
            print $rss;
        }
        print <<XML;
</response>
XML
    }

    1;
}

sub _get_params {
    my $app = shift;
    my($tb_id, $pass);
    if ($tb_id = $app->param('tb_id')) {
        $pass = $app->param('pass');
    } else {
        if (my $pi = $app->path_info) {
            $pi =~ s!^/!!;
            my $tbscript = $app->config('TrackbackScript');
            $pi =~ s!.*\Q$tbscript\E/!!;
            ($tb_id, $pass) = split /\//, $pi;
        }
    }
    ($tb_id, $pass);
}

sub _builtin_throttle {
    my ($eh, $app, $tb) = @_;
    my $user_ip = $app->remote_ip;
    use MT::Util qw(offset_time_list);
    my @ts = offset_time_list(time - 3600, $tb->blog_id);
    my $from = sprintf("%04d%02d%02d%02d%02d%02d",
        $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0]);
    require MT::TBPing;
    if ($app->config('OneHourMaxPings')
          <= MT::TBPing->count({ blog_id => $tb->blog_id,
                                 created_on => [$from] },
                               {range => {created_on => 1} })) {
        return 0;
    }

    @ts = offset_time_list(time - $app->config('ThrottleSeconds')*4000 - 1,
                           $tb->blog_id);
    $from = sprintf("%04d%02d%02d%02d%02d%02d",
                    $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0]);
    my $terms = {
        blog_id => $tb->blog_id,
        created_on => [$from]
    };
    my $count = MT::TBPing->count($terms, {range => {created_on => 1} });
    if ($count >= $app->config('OneDayMaxPings')) {
        return 0;
    }
    return 1;
}

sub ping {
    my $app = shift;
    my $q = $app->param;

    return $app->_response(Error =>
        $app->translate("Trackback pings must use HTTP POST"))
        if $app->request_method() ne 'POST';

    my($tb_id, $pass) = $app->_get_params;
    return $app->_response(Error =>
        $app->translate("Need a TrackBack ID (tb_id)."))
        unless $tb_id;

    require MT::Trackback;
    my $tb = MT::Trackback->load($tb_id)
        or return $app->_response(Error =>
            $app->translate("Invalid TrackBack ID '[_1]'", $tb_id));

    my $user_ip = $app->remote_ip;

    ## Check if this user has been banned from sending TrackBack pings.
    require MT::IPBanList;
    my $iter = MT::IPBanList->load_iter({ blog_id => $tb->blog_id });
    while (my $ban = $iter->()) {
        my $banned_ip = $ban->ip;
        if ($user_ip =~ /$banned_ip/) {
            return $app->_response(Error =>
              $app->translate("You are not allowed to send TrackBack pings."));
        }
    }

    my($blog_id, $entry, $cat);
    if ($tb->entry_id) {
        require MT::Entry;
        $entry = MT::Entry->load({ id => $tb->entry_id, status => MT::Entry::RELEASE() });
        if (!$entry) {
            return $app->_response(Error =>
                $app->translate("Invalid TrackBack ID '[_1]'", $tb_id));
        }
    } elsif ($tb->category_id) {
        require MT::Category;
        $cat = MT::Category->load($tb->category_id);
    }
    $blog_id = $tb->blog_id;

    MT->add_callback('TBPingThrottleFilter', 1, undef,
        \&MT::App::Trackback::_builtin_throttle);

    my $passed_filter = MT->run_callbacks('TBPingThrottleFilter',
        $app, $tb);
    if (!$passed_filter) {
        return $app->_response(Error => $app->translate("You are pinging trackbacks too quickly. Please try again later."), Code => "403 Throttled");
    }

    my($title, $excerpt, $url, $blog_name, $enc) = map scalar $q->param($_),
                                             qw( title excerpt url blog_name charset);

    unless ($enc) {
        my $content_type = $q->content_type();
        if ($content_type =~ m/;[ ]+charset=(.+)/i) {
            $enc = lc $1;
            $enc =~ s/^\s+|\s+$//gs;
        }
    }

    no_utf8($tb_id, $title, $excerpt, $url, $blog_name);
    # guess encoding as possible
    $enc = MT::I18N::guess_encoding($excerpt.$title.$blog_name) unless $enc;
    ($title, $excerpt, $blog_name) = map { encode_text($_, $enc) } ($title, $excerpt, $blog_name);

    return $app->_response(Error=> $app->translate("Need a Source URL (url)."))
        unless $url;

    if (my $fixed = MT::Util::is_valid_url($url || "")) {
        $url = $fixed; 
    } else {
        return $app->_response(Error =>
                               $app->translate("Invalid URL '[_1]'", $url));
    }

    require MT::TBPing;
    require MT::Blog;
    my $blog = MT::Blog->load($tb->blog_id);
    my $cfg = $app->config;

    return $app->_response(Error =>
        $app->translate("This TrackBack item is disabled."))
        if $tb->is_disabled || !$cfg->AllowPings || !$blog->allow_pings;

    if ($tb->passphrase && (!$pass || $pass ne $tb->passphrase)) {
        return $app->_response(Error =>
          $app->translate("This TrackBack item is protected by a passphrase."));
    }

    my $ping;

    # Check for duplicates...
    my @pings = MT::TBPing->load({ tb_id => $tb->id });
    foreach (@pings) {
        if ($_->source_url eq $url) {
            return $app->_response() if $_->is_junk;
            if ($app->remote_ip eq $_->ip) {
                $ping = $_;
                last;
            } else {
                # return success to quiet this pinger
                return $app->_response();
            }
        }
    }

    if (!$ping) {
        $ping ||= MT::TBPing->new;
        $ping->blog_id($tb->blog_id);
        $ping->tb_id($tb_id);
        $ping->source_url($url);
        $ping->ip($app->remote_ip || '');
        $ping->junk_status(0);
        $ping->visible(1);
    }
    my $excerpt_max_len = const('LENGTH_ENTRY_PING_EXCERPT');
    if ($excerpt) {
        if (length_text($excerpt) > $excerpt_max_len) {
            $excerpt = substr_text($excerpt, 0, $excerpt_max_len - 3) . '...';
        }
        $title = first_n_text($excerpt, const('LENGTH_ENTRY_PING_TITLE_FROM_TEXT'))
            unless defined $title;
        $ping->excerpt($excerpt);
    }
    $ping->title(defined $title && $title ne '' ? $title : $url);
    $ping->blog_name($blog_name);

    # strip of any null characters (done after junk checks so they can
    # monitor for that kind of activity)
    for my $field (qw(title excerpt url blog_name)) {
        my $val = $ping->column($field);
        if ($val =~ m/\x00/) {
            $val =~ tr/\x00//d;
            $ping->column($field, $val);
        }
    }

    if (!MT->run_callbacks('TBPingFilter', $app, $ping)) {
        return $app->_response(Error => "", Code => 403);
    }

    if (!$ping->is_junk) {
        MT::JunkFilter->filter($ping);
    }

    if (!$ping->is_junk && $ping->visible && $blog->moderate_pings) {
        $ping->visible(0);
    }

    $ping->save or return $app->_response(Error => "An internal error occured");
    if ($ping->id && !$ping->is_junk) {
        my $msg = 'New TrackBack received.';
        if ($entry) {
            $msg = $app->translate('TrackBack on "[_1]" from "[_2]".', $entry->title, $ping->blog_name);
        } elsif ($cat) {
            $msg = $app->translate("TrackBack on category '[_1]' (ID:[_2]).", $cat->label, $cat->id);
        }
        require MT::Log;
        $app->log({
            message => $msg,
            class => 'ping',
            category => 'new',
            blog_id => $blog_id,
            metadata => $ping->id,
        });
    }

    if (!$ping->is_junk) {
        $blog->touch; $blog->save;

        if (!$ping->visible) {
            $app->_send_ping_notification($blog, $entry, $cat, $ping);
        } else {
            start_background_task(sub {
                ## If this is a trackback item for a particular entry, we need to
                ## rebuild the indexes in case the <$MTEntryTrackbackCount$> tag
                ## is being used. We also want to place the RSS files inside of the
                ## Local Site Path.
                $app->rebuild_indexes( Blog => $blog )
                    or return $app->_response(Error =>
                        $app->translate("Rebuild failed: [_1]", $app->errstr));

                if ($tb->entry_id) {
                    $app->rebuild_entry(Entry => $entry->id, Blog => $blog,
                                        BuildDependencies => 1);
                }
                if ($tb->category_id) { 
                    $app->publisher->_rebuild_entry_archive_type(
                            Entry => undef, Blog => $blog,
                            Category => $cat, ArchiveType => 'Category'
                    );
                }

                if ($app->config('GenerateTrackBackRSS')) {
                    ## Now generate RSS feed for this trackback item.
                    my $rss = _generate_rss($tb, 10);
                    my $base = $blog->archive_path;
                    my $feed = File::Spec->catfile($base, $tb->rss_file || $tb->id . '.xml');
                    my $fmgr = $blog->file_mgr;
                    $fmgr->put_data($rss, $feed)
                        or return $app->_response(Error =>
                            $app->translate("Can't create RSS feed '[_1]': ", $feed,
                            $fmgr->errstr));
                }
                $app->_send_ping_notification($blog, $entry, $cat, $ping);
            });
        }
    } else {
        $app->run_tasks('JunkExpiration');
    }

    return $app->_response;
}

# one of $entry or $cat must be passed.
sub _send_ping_notification {
    my $app = shift;
    my ($blog, $entry, $cat, $ping) = @_;
    
    return unless $blog->email_new_pings;

    my $attn_reqd = $ping->is_moderated();
    if ($blog->email_attn_reqd_pings && !$attn_reqd) {
        return;
    }

    require MT::Mail;

    my($author, $subj);
    if ($entry) {
        $author = $entry->author;
    } elsif ($cat) {
        require MT::Author;
        $author = MT::Author->load($cat->author_id) if $cat->author_id;
    }
    $app->set_language($author->preferred_language)
        if $author && $author->preferred_language;

    if ($author && $author->email) {
        if ($entry) {
            $subj = $app->translate('New TrackBack Ping to Entry [_1] ([_2])',
                                    $entry->id, $entry->title);
        } elsif ($cat) {
            $subj = $app->translate('New TrackBack Ping to Category [_1] ([_2])',
                                    $cat->id, $cat->label);
        }
        my %head = ( To => $author->email,
                     From => $app->config('EmailAddressMain') || $author->emai
l,
                     Subject => '[' . $blog->name . '] ' . $subj );
        my $base;
        { local $app->{is_admin} = 1;
          $base = $app->base . $app->mt_uri; }
        if ($base =~ m!^/!) {
            my ($blog_domain) = $blog->site_url =~ m|(.+://[^/]+)|;
            $base = $blog_domain . $base;
        }
        my %param = (
                  blog_name => $blog->name,
                  edit_url => $base . $app->uri_params('mode' => 'view', args => { blog_id => $blog->id, '_type' => 'ping', id => $ping->id}),
                  ban_url => $base . $app->uri_params('mode' => 'save', args => {'_type' => 'banlist', blog_id => $blog->id, ip => $ping->ip}),
                  ping_ip => $ping->ip,
                  ping_url => $ping->source_url,
                  ping_excerpt => wrap_text($ping->excerpt, 72),
                  ping_blog_name => $ping->blog_name,
                  ping_title => $ping->title,
                  unapproved => !$ping->visible(),
                 );
        my $author;
        if ($entry) {
            $param{entry_id} = $entry->id;
            $param{entry_title} = $entry->title;
            $param{view_url} = $entry->permalink;
        } elsif ($cat) {
            $param{category_id} = $cat->id;
            $param{category_label} = $cat->label;
        }
        my $charset = $app->config('MailEncoding') || $app->charset;
        $head{'Content-Type'} = qq(text/plain; charset="$charset");
        my $body = MT->build_email('new-ping.tmpl', \%param);
        MT::Mail->send(\%head, $body);
    }
}

sub rss {
    my $app = shift;
    my($tb_id, $pass) = $app->_get_params;
    my $tb = MT::Trackback->load($tb_id)
        or return $app->_response(Error =>
            $app->translate("Invalid TrackBack ID '[_1]'", $tb_id));
    my $rss = _generate_rss($tb);
    $app->_response(RSS => $rss);
}

sub _generate_rss {
    my($tb, $lastn) = @_;
    my $lang = MT::ConfigMgr->instance()->DefaultLanguage || 'en-us';
    my $rss = <<RSS;
<rss version="0.91"><channel>
<title>@{[ $tb->title ]}</title>
<link>@{[ $tb->url || '' ]}</link>
<description>@{[ $tb->description || '' ]}</description>
<language>$lang</language>
RSS
    my %arg;
    if ($lastn) {
        %arg = ('sort' => 'created_on', direction => 'descend',
                limit => $lastn);
    }
    my $iter = MT::TBPing->load_iter({ tb_id => $tb->id }, \%arg);
    while (my $ping = $iter->()) {
        $rss .= sprintf qq(<item>\n<title>%s</title>\n<link>%s</link>\n),
            encode_xml($ping->title), encode_xml($ping->source_url);
        if ($ping->excerpt) {
            $rss .= sprintf qq(<description>%s</description>\n),
                encode_xml($ping->excerpt);
        }
        $rss .= qq(</item>\n);
    }
    $rss .= qq(</channel>\n</rss>);
    my $enc = MT::ConfigMgr->instance()->PublishCharset || 'utf-8';
    $rss = MT::I18N::encode_text($rss, $enc, 'utf-8') if $enc ne 'utf-8';
    $rss;
}

sub blog {
    my $app = shift;
    return $app->{_blog} if $app->{_blog};
    if (my ($tb_id) = $app->_get_params()) {
        require MT::Trackback;
        my $tb = MT::Trackback->load($tb_id);
        return undef unless $tb;
        $app->{_blog} = MT::Blog->load($tb->blog_id) if $tb;
    }
    return $app->{_blog};
}

1;
__END__

=head1 NAME

MT::App::Trackback

=head1 METHODS

=head2 init

Call L<MT::App/init>, register the C<ping>, C<view> and C<rss>
callbacks and set the application default_mode to C<ping>.

=head2 view

Build the trackback page for viewing.

=head2 rss

Generate and return RSS text for the trackback.

=head2 blog

Return the blog of the trackback.

=head2 no_utf8

This function removes UTF-8 from scalars.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
