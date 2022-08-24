# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::AddressBook;

use strict;
use warnings;
use MT::Util qw( is_valid_email is_url dirify );
use MT::I18N qw( wrap_text );

sub entry_notify {
    my $app = shift;

    $app->validate_param({
        entry_id => [qw/ID/],
    }) or return;

    return $app->return_to_dashboard( permission => 1 )
        unless $app->can_do('open_entry_notification_screen');
    my $entry_id = $app->param('entry_id')
        or return $app->error( $app->translate("No entry ID was provided") );

    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or return $app->error(
        $app->translate( "No such entry '[_1]'", $entry_id ) );
    my $blog = $app->blog;
    return $app->errtrans("Invalid request")
        if $blog->id != $entry->blog_id;
    my $param = {};
    $param->{entry_id} = $entry_id;
    return $app->load_tmpl( "dialog/entry_notify.tmpl", $param );
}

sub send_notify {
    my $app = shift;
    $app->validate_magic() or return;

    $app->validate_param({
        entry_id           => [qw/ID/],
        message            => [qw/MAYBE_STRING/],
        send_body          => [qw/MAYBE_STRING/],
        send_excerpt       => [qw/MAYBE_STRING/],
        send_notify_emails => [qw/MAYBE_STRING/],
        send_notify_list   => [qw/MAYBE_STRING/],
    }) or return;

    my $entry_id = $app->param('entry_id')
        or return $app->error( $app->translate("No entry ID was provided") );
    require MT::Entry;
    require MT::Blog;
    my $entry = MT::Entry->load($entry_id)
        or return $app->error(
        $app->translate( "No such entry '[_1]'", $entry_id ) );
    my $blog = MT::Blog->load( $entry->blog_id );

    my $user = $app->user;
    $app->blog($blog);
    my $perms = $user->permissions($blog);
    return $app->error( $app->translate("No permissions.") )
        unless $perms->can_do('send_entry_notification');

    my $author = $entry->author;

    my %params;
    $params{blog}         = $blog;
    $params{entry}        = $entry;
    $params{entry_author} = $author ? 1 : 0;

    if ( $app->param('send_excerpt') ) {
        $params{send_excerpt} = 1;
    }
    $params{message} = $app->param('message');
    $params{message} = '' unless defined $params{message};

    if ( $app->param('send_body') ) {
        $params{send_body} = 1;
    }

    my $entry_editurl = $app->uri(
        'mode' => 'view',
        args   => {
            '_type' => $entry->class,
            blog_id => $entry->blog_id,
            id      => $entry->id,
        }
    );
    if ( $entry_editurl =~ m|^/| ) {
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $entry_editurl = $blog_domain . $entry_editurl;
    }
    $params{entry_editurl} = $entry_editurl;

    my $addrs;
    if ( $app->param('send_notify_list') ) {
        require MT::Notification;
        my $iter = MT::Notification->load_iter( { blog_id => $blog->id } );
        while ( my $note = $iter->() ) {
            next unless is_valid_email( $note->email );
            $addrs->{ $note->email } = 1;
        }
    }

    if ( my $send_notify_emails = $app->param('send_notify_emails') ) {
        my @addr = split /[\n\r,]+/, $send_notify_emails;
        for my $a (@addr) {
            next unless is_valid_email($a);
            $addrs->{$a} = 1;
        }
    }

    keys %$addrs
        or return $app->error(
        $app->translate(
            "No valid recipients were found for the entry notification.")
        );
    my $address;
    if ( $author and $author->email ) {
        $address
            = defined $author->nickname
            ? $author->nickname . ' <' . $author->email . '>'
            : $author->email;
    }
    else {
        $address = $app->config('EmailAddressMain');
        $params{from_address} = $address;
    }

    my $body = $app->build_email( 'notify-entry.tmpl', \%params )
        or return;

    my $subj
        = $app->translate( "[_1] Update: [_2]", $blog->name, $entry->title );
    if ( $app->current_language ne 'ja' ) {   # FIXME perhaps move to MT::I18N
        $subj =~ s![\x80-\xFF]!!g;
    }
    my %head = (
        id      => 'notify_entry',
        To      => $address,
        From    => $address,
        Subject => $subj,
    );
    my $charset = $app->config('MailEncoding')
        || $app->charset;
    $head{'Content-Type'} = qq(text/plain; charset="$charset");
    my $i = 1;
    require MT::Util::Mail;
    unless ( exists $params{from_address} ) {
        MT::Util::Mail->send_and_log(\%head, $body) or return $app->errtrans(
            "Error sending mail ([_1]): Try another MailTransfer setting?",
            MT::Util::Mail->errstr
        );
    }
    delete $head{To};

    my @email_to_send;
    my @addresses_to_send = grep $_, keys %$addrs;
    if ( $app->config('EmailNotificationBcc') ) {
        while (@addresses_to_send) {
            push @email_to_send,
                { %head, Bcc => [ splice( @addresses_to_send, 0, 20 ) ], };
        }
    }
    else {
        @email_to_send = map {
            { %head, To => $_ }
        } @addresses_to_send;
    }
    foreach my $info (@email_to_send) {
        MT::Util::Mail->send_and_log($info, $body) or return $app->error($app->translate(
            "Error sending mail ([_1]): Try another MailTransfer setting?",
            MT::Util::Mail->errstr
        ));
    }
    $app->redirect(
        $app->uri(
            'mode' => 'view',
            args   => {
                '_type'      => $entry->class,
                blog_id      => $entry->blog_id,
                id           => $entry->id,
                saved_notify => 1
            }
        )
    );
}

sub export {
    my $app   = shift;
    my $user  = $app->user;
    my $perms = $app->permissions;
    my $blog  = $app->blog
        or return $app->error( $app->translate("Please select a blog.") );
    return $app->permission_denied()
        unless $user->is_superuser
        || ( $perms && $perms->can_do('export_addressbook') );
    $app->validate_magic() or return;

    local $| = 1;
    my $enc = $app->config('ExportEncoding');
    $enc = $app->config('LogExportEncoding') if ( !$enc );
    $enc = ( $app->charset || '' ) if ( !$enc );

    my $not_class = $app->model('notification');
    my $iter = $not_class->load_iter( { blog_id => $blog->id },
        { 'sort' => 'created_on', 'direction' => 'descend' } );

    my $file = '';
    $file = dirify( $blog->name ) . '-' if $blog;
    $file = "Blog-" . $blog->id . '-'   if $file eq '-';
    $file .= "notifications_list.csv";
    $app->{no_print_body} = 1;
    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $enc
        ? "text/csv; charset=$enc"
        : 'text/csv'
    );

    while ( my $note = $iter->() ) {
        $app->print( Encode::encode( $enc, $note->email . "\n" ) );
    }
}

sub can_save {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('notification')->load($obj);
    }
    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );

    return $author->permissions($blog_id)->can_do('save_addressbook');
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();

    if ( $obj && !ref $obj ) {
        $obj = MT->model('notification')->load($obj);
    }
    my $blog_id = $obj ? $obj->blog_id : ( $app->blog ? $app->blog->id : 0 );

    return $author->permissions($blog_id)->can_do('delete_addressbook');
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;
    my $email = lc( $app->param('email') || '' );
    $email =~ s/(^\s+|\s+$)//gs;
    my $blog_id = $app->param('blog_id');
    if ( !is_valid_email($email) ) {
        return $eh->error(
            $app->translate(
                "The text you entered is not a valid email address.")
        );
    }
    my $url = $app->param('url');
    if ( $url && ( !is_url($url) ) ) {
        return $eh->error(
            $app->translate("The text you entered is not a valid URL.") );
    }
    require MT::Notification;

    # duplicate check
    my $notification_iter
        = MT::Notification->load_iter( { blog_id => $blog_id } );
    my $id = $app->param('id') || 0;
    while ( my $obj = $notification_iter->() ) {
        if (   ( lc( $obj->email ) eq $email )
            && ( $obj->id ne $id ) )
        {
            return $eh->error(
                $app->translate(
                    "The e-mail address you entered is already on the Notification List for this blog."
                )
            );
        }
    }
    return 1;
}

sub post_delete {
    my ( $eh, $app, $obj ) = @_;

    $app->log(
        {   message => $app->translate(
                "Subscriber '[_1]' (ID:[_2]) deleted from address book by '[_3]'",
                $obj->email, $obj->id, $app->user->name
            ),
            level    => MT::Log::NOTICE(),
            class    => 'system',
            category => 'delete'
        }
    );
}

sub cms_pre_load_filtered_list {
    my ( $cb, $app, $filter, $load_options ) = @_;

    my $user = $app->user;
    return if $user->is_superuser;

    require MT::Permission;
    my $options_blog_ids = $load_options->{blog_ids};
    my $iter             = MT::Permission->load_iter(
        {   author_id => $user->id,
            (   $options_blog_ids
                ? ( blog_id => $options_blog_ids )
                : ( blog_id => { not => 0 } )
            ),
        },
    );

    my $blog_ids;
    while ( my $perm = $iter->() ) {
        push @$blog_ids, $perm->blog_id
            if $perm->can_do('access_to_notification_list');
    }

    my $terms = $load_options->{terms};
    $terms->{blog_id} = $blog_ids
        if $blog_ids;
    $load_options->{terms} = $terms;
}

1;
