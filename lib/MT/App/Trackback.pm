# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::Trackback;

use strict;
use utf8;
use base qw( MT::App );

use File::Spec;
use MT::TBPing;
use MT::Trackback;
use MT::Util qw( first_n_words encode_xml is_valid_url
    start_background_task );
use MT::JunkFilter qw(:constants);
use MT::I18N qw( const );

sub id {'tb'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        ping => \&ping,
        view => \&view,
        rss  => \&rss,
    );
    $app->{default_mode} = 'ping';
    $app;
}

sub init_callbacks {
    my $app = shift;
    MT->add_callback( 'TBPingThrottleFilter', 1, undef,
        \&MT::App::Trackback::_builtin_throttle );
}

sub validate_request_params {
    my $app = shift;

    my $q = $app->param;

    # attempt to determine character set encoding based on
    # 'charset' parameter:
    my $enc = $q->param('charset');
    local $app->{charset} = $enc if $enc;
    return $app->SUPER::validate_request_params(@_);
}

sub view {
    my $app = shift;
    my $q   = $app->param;
    require MT::Template;
    require MT::Template::Context;
    require MT::Entry;
    my $entry_id = $q->param('entry_id');
    my $entry
        = MT::Entry->load(
        { id => $entry_id, status => MT::Entry::RELEASE() } )
        or return $app->error(
        $app->translate( "Invalid entry ID '[_1]'", $entry_id ) );
    my $ctx = MT::Template::Context->new;
    $ctx->stash( 'entry', $entry );
    $ctx->{current_timestamp} = $entry->authored_on;
    my $tmpl = MT::Template->load(
        {   type    => 'pings',
            blog_id => $entry->blog_id
        }
        )
        or return $app->error(
        $app->translate(
            "You must define a Ping template in order to display pings.")
        );
    defined( my $html = $tmpl->build($ctx) )
        or return $app->error( $tmpl->errstr );
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

my %map = ( '&' => '&amp;', '"' => '&quot;', '<' => '&lt;', '>' => '&gt;' );

sub _response {
    my $app   = shift;
    my %param = @_;
    $app->response_code( $param{Code} );
    $app->send_http_header('text/xml; charset=utf-8');
    $app->{no_print_body} = 1;

    my $res;
    if ( my $err = $param{Error} ) {
        my $re = join '|', keys %map;
        $err =~ s!($re)!$map{$1}!g;
        $res = <<XML;
<?xml version="1.0" encoding="utf-8"?>
<response>
<error>1</error>
<message>$err</message>
</response>
XML
    }
    else {
        $res = <<XML;
<?xml version="1.0" encoding="utf-8"?>
<response>
<error>0</error>
XML
        if ( my $rss = $param{RSS} ) {
            $res .= $rss;
        }
        $res .= <<XML;
</response>
XML
    }
    $app->print( Encode::encode_utf8($res) );
    1;
}

sub _get_params {
    my $app = shift;
    my ( $tb_id, $pass );
    if ( $tb_id = $app->param('tb_id') ) {
        $pass = $app->param('pass');
    }
    else {
        if ( my $pi = $app->path_info ) {
            $pi =~ s!^/!!;
            my $tbscript = $app->config('TrackbackScript');
            $pi =~ s!.*\Q$tbscript\E/!!;
            ( $tb_id, $pass ) = split /\//, $pi;
        }
    }
    ( $tb_id, $pass );
}

sub _builtin_throttle {
    my ( $eh, $app, $tb ) = @_;
    my $user_ip = $app->remote_ip;
    use MT::Util qw(offset_time_list);
    my @ts = offset_time_list( time - 3600, $tb->blog_id );
    my $from = sprintf(
        "%04d%02d%02d%02d%02d%02d",
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ]
    );
    require MT::TBPing;
    if ($app->config('OneHourMaxPings') <= MT::TBPing->count(
            {   blog_id    => $tb->blog_id,
                created_on => [$from]
            },
            { range => { created_on => 1 } }
        )
        )
    {
        return 0;
    }

    @ts = offset_time_list( time - $app->config('ThrottleSeconds') * 4000 - 1,
        $tb->blog_id );
    $from = sprintf(
        "%04d%02d%02d%02d%02d%02d",
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ]
    );
    my $terms = {
        blog_id    => $tb->blog_id,
        created_on => [$from]
    };
    my $count = MT::TBPing->count( $terms, { range => { created_on => 1 } } );
    if ( $count >= $app->config('OneDayMaxPings') ) {
        return 0;
    }
    return 1;
}

sub ping {
    my $app = shift;
    my $q   = $app->param;

    return $app->_response(
        Error => $app->translate("Trackback pings must use HTTP POST") )
        if $app->request_method() ne 'POST';

    my ( $tb_id, $pass ) = $app->_get_params;
    return $app->_response(
        Error => $app->translate("TrackBack ID (tb_id) is required.") )
        unless $tb_id;

    require MT::Trackback;
    my $tb = MT::Trackback->load($tb_id)
        or return $app->_response(
        Error => $app->translate( "Invalid TrackBack ID '[_1]'", $tb_id ) );

    my $user_ip = $app->remote_ip;

    ## Check if this user has been banned from sending TrackBack pings.
    require MT::IPBanList;
    my $iter = MT::IPBanList->load_iter( { blog_id => $tb->blog_id } );
    while ( my $ban = $iter->() ) {
        my $banned_ip = $ban->ip;
        if ( $user_ip =~ /$banned_ip/ ) {
            return $app->_response(
                Error => $app->translate(
                    "You are not allowed to send TrackBack pings.")
            );
        }
    }

    my ( $blog_id, $entry, $cat );
    if ( $tb->entry_id ) {
        require MT::Entry;
        $entry = MT::Entry->load(
            { id => $tb->entry_id, status => MT::Entry::RELEASE() } );
        if ( !$entry ) {
            return $app->_response( Error =>
                    $app->translate( "Invalid TrackBack ID '[_1]'", $tb_id )
            );
        }
    }
    elsif ( $tb->category_id ) {
        require MT::Category;
        $cat = MT::Category->load( $tb->category_id );
    }
    $blog_id = $tb->blog_id;

    my $passed_filter
        = MT->run_callbacks( 'TBPingThrottleFilter', $app, $tb );
    if ( !$passed_filter ) {
        return $app->_response(
            Error => $app->translate(
                "You are sending TrackBack pings too quickly. Please try again later."
            ),
            Code => "403 Throttled"
        );
    }

    my ( $title, $excerpt, $url, $blog_name )
        = map scalar $q->param($_),
        qw( title excerpt url blog_name);

    #no_utf8( $tb_id, $title, $excerpt, $url, $blog_name );

    return $app->_response(
        Error => $app->translate("You need to provide a Source URL (url).") )
        unless $url;

    if ( my $fixed = MT::Util::is_valid_url( $url || "" ) ) {
        $url = $fixed;
    }
    else {
        return $app->_response(
            Error => $app->translate( "Invalid URL '[_1]'", $url ) );
    }

    require MT::TBPing;
    require MT::Blog;
    my $blog = MT::Blog->load( $tb->blog_id );
    my $cfg  = $app->config;

    return $app->_response(
        Error => $app->translate("This TrackBack item is disabled.") )
        if $tb->is_disabled
        || !$cfg->AllowPings
        || !$blog
        || !$blog->allow_pings;

    if ( $tb->passphrase && ( !$pass || $pass ne $tb->passphrase ) ) {
        return $app->_response(
            Error => $app->translate(
                "This TrackBack item is protected by a passphrase.")
        );
    }

    my $ping;

    # Check for duplicates...
    if ( 0 < MT::TBPing->count( { tb_id => $tb->id, source_url => $url } ) ) {
        return $app->_response();
    }

    if ( !$ping ) {
        $ping ||= MT::TBPing->new;
        $ping->blog_id( $tb->blog_id );
        $ping->tb_id($tb_id);
        $ping->source_url($url);
        $ping->ip( $app->remote_ip || '' );
        $ping->visible(1);
    }
    my $excerpt_max_len = const('LENGTH_ENTRY_PING_EXCERPT');
    if ($excerpt) {
        if ( length($excerpt) > $excerpt_max_len ) {
            $excerpt = substr( $excerpt, 0, $excerpt_max_len - 3 ) . '...';
        }
        $title
            = first_n_words( $excerpt,
            const('LENGTH_ENTRY_PING_TITLE_FROM_TEXT') )
            unless defined $title;
        $ping->excerpt($excerpt);
    }
    $ping->title( defined $title && $title ne '' ? $title : $url );
    $ping->blog_name($blog_name);

    # strip of any null characters (done after junk checks so they can
    # monitor for that kind of activity)
    for my $field (qw(title excerpt source_url blog_name)) {
        my $val = $ping->column($field);
        if ( $val =~ m/\x00/ ) {
            $val =~ tr/\x00//d;
            $ping->column( $field, $val );
        }
    }

    if ( !MT->run_callbacks( 'TBPingFilter', $app, $ping ) ) {
        return $app->_response( Error => "", Code => 403 );
    }

    if ( !$ping->is_junk ) {
        MT::JunkFilter->filter($ping);
    }

    if ( !$ping->is_junk && $ping->visible && $blog->moderate_pings ) {
        $ping->visible(0);
    }

    $ping->save
        or return $app->_response( Error => "An internal error occured" );
    if ( $ping->id && !$ping->is_junk ) {
        my $msg = 'New TrackBack received.';
        if ($entry) {
            $msg = $app->translate( 'TrackBack on "[_1]" from "[_2]".',
                $entry->title, $ping->blog_name );
        }
        elsif ($cat) {
            $msg = $app->translate( "TrackBack on category '[_1]' (ID:[_2]).",
                $cat->label, $cat->id );
        }
        require MT::Log;
        $app->log(
            {   message  => $msg,
                class    => 'ping',
                category => 'new',
                blog_id  => $blog_id,
                metadata => $ping->id,
            }
        );
    }

    if ( !$ping->is_junk ) {
        if ( !$ping->visible ) {
            $app->_send_ping_notification( $blog, $entry, $cat, $ping );
        }
        else {
            start_background_task(
                sub {
                    ## If this is a trackback item for a particular entry, we need to
                    ## rebuild the indexes in case the <$MTEntryTrackbackCount$> tag
                    ## is being used. We also want to place the RSS files inside of the
                    ## Local Site Path.
                    $app->rebuild_indexes( Blog => $blog )
                        or return $app->_response(
                        Error => $app->translate(
                            "Publishing failed: [_1]",
                            $app->errstr
                        )
                        );

                    if ( $tb->entry_id ) {
                        $app->rebuild_entry(
                            Entry             => $entry->id,
                            Blog              => $blog,
                            BuildDependencies => 1
                        );
                    }
                    if ( $tb->category_id ) {
                        $app->publisher->_rebuild_entry_archive_type(
                            Entry       => undef,
                            Blog        => $blog,
                            Category    => $cat,
                            ArchiveType => 'Category'
                        );
                    }

                    if ( $app->config('GenerateTrackBackRSS') ) {
                        ## Now generate RSS feed for this trackback item.
                        my $rss  = _generate_rss( $tb, 10 );
                        my $base = $blog->archive_path;
                        my $feed = File::Spec->catfile( $base,
                            $tb->rss_file || $tb->id . '.xml' );
                        my $fmgr = $blog->file_mgr;
                        $fmgr->put_data( $rss, $feed )
                            or return $app->_response(
                            Error => $app->translate(
                                "Cannot create RSS feed '[_1]': ", $feed,
                                $fmgr->errstr
                            )
                            );
                    }
                    $app->_send_ping_notification( $blog, $entry, $cat,
                        $ping );
                }
            );
        }
    }
    else {
        $app->run_tasks('JunkExpiration');
    }

    return $app->_response;
}

# one of $entry or $cat must be passed.
sub _send_ping_notification {
    my $app = shift;
    my ( $blog, $entry, $cat, $ping ) = @_;

    return unless $blog->email_new_pings;

    my $attn_reqd = $ping->is_moderated();
    if ( $blog->email_attn_reqd_pings && !$attn_reqd ) {
        return;
    }

    require MT::Mail;

    my ( $author, $subj );
    if ($entry) {
        $author = $entry->author;
    }
    elsif ($cat) {
        require MT::Author;
        $author = MT::Author->load( $cat->author_id ) if $cat->author_id;
    }
    $app->set_language( $author->preferred_language )
        if $author && $author->preferred_language;

    if ( $author && $author->email ) {
        if ($entry) {
            $subj = $app->translate( 'New TrackBack ping to \'[_1]\'',
                $entry->title );
        }
        elsif ($cat) {
            $subj
                = $app->translate( 'New TrackBack ping to category \'[_1]\'',
                $cat->label );
        }
        my %head = (
            id   => 'new_ping',
            To   => $author->email,
            From => $app->config('EmailAddressMain')
                || (
                  $author->nickname
                ? $author->nickname . ' <' . $author->email . '>'
                : $author->email
                ),
            Subject => '[' . $blog->name . '] ' . $subj
        );
        my $base;
        {
            local $app->{is_admin} = 1;
            $base = $app->base . $app->mt_uri;
        }
        if ( $base =~ m!^/! ) {
            my ($blog_domain) = $blog->site_url =~ m|(.+://[^/]+)|;
            $base = $blog_domain . $base;
        }
        my $nonce
            = MT::Util::perl_sha1_digest_hex( $ping->id
                . $ping->created_on
                . $blog->id
                . $app->config->SecretToken );
        my $approve_link = $base
            . $app->uri_params(
            'mode' => 'approve_item',
            args   => {
                blog_id => $blog->id,
                '_type' => 'ping',
                id      => $ping->id,
                nonce   => $nonce
            }
            );
        my $spam_link = $base
            . $app->uri_params(
            'mode' => 'handle_junk',
            args   => {
                blog_id => $blog->id,
                '_type' => 'ping',
                id      => $ping->id,
                nonce   => $nonce
            }
            );
        my $edit_link = $base
            . $app->uri_params(
            'mode' => 'view',
            args =>
                { blog_id => $blog->id, '_type' => 'ping', id => $ping->id }
            );
        my $ban_link = $base
            . $app->uri_params(
            'mode' => 'save',
            args   => {
                '_type' => 'banlist',
                blog_id => $blog->id,
                ip      => $ping->ip
            }
            );
        my %param = (
            blog           => $blog,
            approve_url    => $approve_link,
            spam_url       => $spam_link,
            edit_url       => $edit_link,
            ban_url        => $ban_link,
            ping           => $ping,
            entry_id       => $entry ? $entry->id : undef,
            category_id    => $cat ? $cat->id : undef,
            unapproved     => !$ping->visible(),
            state_editable => (
                       $author->is_superuser()
                    || $author->permissions( $blog->id )
                    ->can_do('edit_trackback_status_via_notify_mail')
            ) ? 1 : 0,
        );
        $param{entry}    = $entry if $entry;
        $param{category} = $cat   if $cat;

        my $charset = $app->config('MailEncoding') || $app->charset;
        $head{'Content-Type'} = qq(text/plain; charset="$charset");
        my $body = MT->build_email( 'new-ping.tmpl', \%param );
        MT::Mail->send( \%head, $body );
    }
}

sub rss {
    my $app = shift;
    my ( $tb_id, $pass ) = $app->_get_params;
    my $tb = MT::Trackback->load($tb_id)
        or return $app->_response(
        Error => $app->translate( "Invalid TrackBack ID '[_1]'", $tb_id ) );
    if ( my $eid = $tb->entry_id ) {
        my $entry = $app->model('entry')->load($eid);
        return $app->_response(
            Error => $app->translate( "Invalid TrackBack ID '[_1]'", $tb_id )
        ) unless $entry && ( MT::Entry::RELEASE() == $entry->status );
    }
    elsif ( my $cid = $tb->category_id ) {
        my $exist = $app->model('entry')->exist(
            { status => MT::Entry::RELEASE() },
            {   join => MT::Placement->join_on(
                    'entry_id', { category_id => $cid }
                )
            }
        );
        return $app->_response(
            Error => $app->translate( "Invalid TrackBack ID '[_1]'", $tb_id )
        ) unless $exist;
    }
    my $rss = _generate_rss($tb);
    $app->_response( RSS => $rss );
}

sub _generate_rss {
    my ( $tb, $lastn ) = @_;
    my $lang = MT->config->DefaultLanguage || 'en-us';
    my $rss = <<RSS;
<rss version="0.91"><channel>
<title>@{[ $tb->title ]}</title>
<link>@{[ $tb->url || '' ]}</link>
<description>@{[ $tb->description || '' ]}</description>
<language>$lang</language>
RSS
    my %arg;
    if ($lastn) {
        %arg = (
            'sort'    => 'created_on',
            direction => 'descend',
            limit     => $lastn
        );
    }
    my $iter = MT::TBPing->load_iter(
        {   tb_id       => $tb->id,
            junk_status => MT::TBPing::NOT_JUNK(),
            visible     => 1
        },
        \%arg
    );
    while ( my $ping = $iter->() ) {
        $rss .= sprintf qq(<item>\n<title>%s</title>\n<link>%s</link>\n),
            encode_xml( $ping->title ), encode_xml( $ping->source_url );
        if ( $ping->excerpt ) {
            $rss .= sprintf qq(<description>%s</description>\n),
                encode_xml( $ping->excerpt );
        }
        $rss .= qq(</item>\n);
    }
    $rss .= qq(</channel>\n</rss>);
    $rss;
}

sub blog {
    my $app = shift;
    return $app->{_blog} if $app->{_blog};
    if ( my ($tb_id) = $app->_get_params() ) {
        require MT::Trackback;
        my $tb = MT::Trackback->load($tb_id);
        return undef unless $tb;
        $app->{_blog} = MT::Blog->load( $tb->blog_id ) if $tb;
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
