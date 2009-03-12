package MT::CMS::AddressBook;

use strict;
use MT::Util qw( is_valid_email is_url dirify );
use MT::I18N qw( wrap_text );

sub entry_notify {
    my $app   = shift;
    my $user  = $app->user;
    my $perms = $app->permissions;
    return $app->error( $app->translate("No permissions.") )
      unless $perms->can_send_notifications;

    my $q        = $app->param;
    my $entry_id = $q->param('entry_id')
      or return $app->error( $app->translate("No entry ID provided") );
    require MT::Entry;
    require MT::Blog;
    my $entry = MT::Entry->load($entry_id)
      or return $app->error(
        $app->translate( "No such entry '[_1]'", $entry_id ) );
    my $blog  = MT::Blog->load( $entry->blog_id );
    my $param = {};
    $param->{entry_id} = $entry_id;
    return $app->load_tmpl( "dialog/entry_notify.tmpl", $param );
}

sub send_notify {
    my $app = shift;
    $app->validate_magic() or return;
    my $q        = $app->param;
    my $entry_id = $q->param('entry_id')
      or return $app->error( $app->translate("No entry ID provided") );
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
      unless $perms->can_send_notifications;

    my $author = $entry->author;
    return $app->error(
        $app->translate( "No email address for user '[_1]'", $author->name ) )
      unless $author->email;

    my $cols = 72;
    my %params;
    $params{blog} = $blog;
    $params{entry} = $entry;
    $params{author} = $author;

    if ( $q->param('send_excerpt') ) {
        $params{send_excerpt} = 1;
    }
    $params{message} = wrap_text( $q->param('message'), $cols, '', '' );
    if ( $q->param('send_body') ) {
        $params{send_body} = 1;
    }

    my $entry_editurl = $app->uri(
        'mode' => 'view',
        args   => { 
            '_type' => 'entry',
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
    if ( $q->param('send_notify_list') ) {
        require MT::Notification;
        my $iter = MT::Notification->load_iter( { blog_id => $blog->id } );
        while ( my $note = $iter->() ) {
            next unless is_valid_email( $note->email );
            $addrs->{ $note->email } = 1;
        }
    }

    if ( $q->param('send_notify_emails') ) {
        my @addr = split /[\n\r,]+/, $q->param('send_notify_emails');
        for my $a (@addr) {
            next unless is_valid_email($a);
            $addrs->{$a} = 1;
        }
    }

    keys %$addrs
      or return $app->error(
        $app->translate(
            "No valid recipients found for the entry notification.")
      );

    my $body = $app->build_email( 'notify-entry.tmpl', \%params );

    my $subj =
      $app->translate( "[_1] Update: [_2]", $blog->name, $entry->title );
    if ( $app->current_language ne 'ja' ) {    # FIXME perhaps move to MT::I18N
        $subj =~ s![\x80-\xFF]!!g;
    }
    my $address =
      defined $author->nickname
      ? $author->nickname . ' <' . $author->email . '>'
      : $author->email;
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
    require MT::Mail;
    MT::Mail->send( \%head, $body )
      or return $app->error(
        $app->translate(
            "Error sending mail ([_1]); try another MailTransfer setting?",
            MT::Mail->errstr
        )
      );
    delete $head{To};

    foreach my $email ( keys %{$addrs} ) {
        next unless $email;
        if ( $app->config('EmailNotificationBcc') ) {
            push @{ $head{Bcc} }, $email;
            if ( $i++ % 20 == 0 ) {
                MT::Mail->send( \%head, $body )
                  or return $app->error(
                    $app->translate(
"Error sending mail ([_1]); try another MailTransfer setting?",
                        MT::Mail->errstr
                    )
                  );
                @{ $head{Bcc} } = ();
            }
        }
        else {
            $head{To} = $email;
            MT::Mail->send( \%head, $body )
              or return $app->error(
                $app->translate(
"Error sending mail ([_1]); try another MailTransfer setting?",
                    MT::Mail->errstr
                )
              );
            delete $head{To};
        }
    }
    if ( $head{Bcc} && @{ $head{Bcc} } ) {
        MT::Mail->send( \%head, $body )
          or return $app->error(
            $app->translate(
                "Error sending mail ([_1]); try another MailTransfer setting?",
                MT::Mail->errstr
            )
          );
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
    return $app->error( $app->translate("Permission denied.") )
      unless $user->is_superuser
      || ( $perms && $perms->can_edit_notifications );
    $app->validate_magic() or return;

    $| = 1;
    my $enc = $app->config('ExportEncoding');
    $enc = $app->config('LogExportEncoding') if ( !$enc );
    $enc = ( $app->charset || '' ) if ( !$enc );

    my $not_class = $app->model('notification');
    my $iter = $not_class->load_iter( { blog_id => $blog->id },
        { 'sort' => 'created_on', 'direction' => 'ascend' } );

    my $file = '';
    $file = dirify( $blog->name ) . '-' if $blog;
    $file = "Blog-" . $blog->id . '-' if $file eq '-';
    $file .= "notifications_list.csv";
    $app->{no_print_body} = 1;
    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $enc
        ? "text/csv; charset=$enc"
        : 'text/csv'
    );

    while ( my $note = $iter->() ) {
        $app->print( $note->email . "\n" );
    }
}

sub can_save {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms->can_edit_notifications;
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;
    my $email = lc $app->param('email');
    $email =~ s/(^\s+|\s+$)//gs;
    my $blog_id = $app->param('blog_id');
    if ( !is_valid_email($email) ) {
        return $eh->error(
            $app->translate(
                "The value you entered was not a valid email address")
        );
    }
    my $url = $app->param('url');
    if ( $url && ( !is_url($url) ) ) {
        return $eh->error(
            $app->translate(
                "The value you entered was not a valid URL")
        );
    }
    require MT::Notification;

    # duplicate check
    my $notification_iter =
      MT::Notification->load_iter( { blog_id => $blog_id } );
    while ( my $obj = $notification_iter->() ) {
        if (   ( lc( $obj->email ) eq $email )
            && ( $obj->id ne $app->param('id') ) )
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
        {
            message => $app->translate(
"Subscriber '[_1]' (ID:[_2]) deleted from address book by '[_3]'",
                $obj->email, $obj->id, $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'delete'
        }
    );
}

1;
