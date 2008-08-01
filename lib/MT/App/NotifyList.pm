# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::NotifyList;

use strict;
use MT::App;
use MT::Util qw( encode_url );

use base 'MT::App';

sub id {'notify'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        'subscribe'   => \&subscribe,
        'confirm'     => \&confirm,
        'unsubscribe' => \&unsubscribe
    );
    $app->{default_mode} = 'subscribe';
}

sub subscribe {
    my $app         = shift;
    my $q           = $app->{query};
    my $subscr_addr = lc $q->param('email');
    $subscr_addr =~ s/(^\s+|\s+$)//gs;
    return $app->errtrans("Please enter a valid email address.")
        unless ( $subscr_addr && MT::Util::is_valid_email($subscr_addr) );
    unless ( $q->param('blog_id') ) {
        return $app->errtrans(
            "Missing required parameter: blog_id. Please consult the user manual to configure notifications."
        );
    }

    my $secret           = $app->config->SecretToken;
    my $admin_email_addr = $app->config->EmailAddressMain
        || die "You need to set the EmailAddressMain configuration value "
        . "to your own email address in order to use notifications";
    my $blog = MT::Blog->load( $q->param('blog_id') )
        || die "No blog found with the given blog_id.";
    my $entry_id = $q->param('entry_id');
    my $entry;
    if ($entry_id) {
        require MT::Entry;
        $entry = MT::Entry->load(
            {   id      => $entry_id,
                blog_id => $blog->id,
                status  => MT::Entry::RELEASE()
            }
        ) || die "No entry found with the given entry_id.";
    }

    my $redirect_url = $q->param('_redirect');
    my $site_url     = $blog->site_url;
    if ( $redirect_url !~ m!\Q$site_url\E! ) {
        return $app->errtrans(
            "An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog."
        );
    }

    if ( $app->lookup( $blog->id, $subscr_addr ) ) {
        return $app->error(
            $app->translate(
                "The email address '[_1]' is already in the notification list for this weblog.",
                $subscr_addr
            )
        );
    }

    my %head = (
        id      => 'verify_subscribe',
        From    => $admin_email_addr,
        To      => $subscr_addr,
        Subject => $app->translate("Please verify your email to subscribe")
    );
    my $charset = $app->config('MailEncoding')
        || $app->config('PublishCharset');
    $head{'Content-Type'} = qq(text/plain; charset="$charset");

    my @pool = ( 'A' .. 'Z', 'a' .. 'z', '0' .. '9' );
    my $salt = join '', ( map { $pool[ rand @pool ] } 1 .. 2 );
    my $magic = crypt( $secret . $subscr_addr, $salt );
    my $cgipath = $app->config->CGIPath;
    if ( $cgipath =~ m!^/! ) {

        # relative cgipath, prepend blog domain
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $cgipath = $blog_domain . $cgipath;
    }
    $cgipath .= '/' unless $cgipath =~ m!/$!;
    my $body = MT->build_email(
        'verify-subscribe.tmpl',
        {   script_path  => $cgipath . 'mt-add-notify.cgi',
            blog         => $blog,
            entry        => $entry,
            redirect_url => $redirect_url,
            magic        => $magic,
            email        => $subscr_addr
        }
    );
    use MT::Mail;
    MT::Mail->send( \%head, $body );
    my $message
        = $app->translate( '_NOTIFY_REQUIRE_CONFIRMATION', $subscr_addr );
    $charset = $app->charset;
    <<HTML;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=$charset" />
<title>Subscribe Notification</title>
</head>

<body>
$message
</body>
</html>
HTML
}

sub lookup {
    my $app = shift;
    my ( $blog_id, $email ) = @_;

    require MT::Notification;
    my $niter = MT::Notification->load_iter( { blog_id => $blog_id } );
    while ( my $n = $niter->() ) {
        return $n if $n->email eq $email;
    }
    undef;
}

sub confirm {
    my $app = shift;
    my $q   = $app->{query};

    # email confirmed

    my $blog_id = $q->param('blog_id');
    unless ( $blog_id
        && $q->param('email')
        && $q->param('magic') )
    {
        print $q->header;
        print "Missing required parameters\n";
        exit;
    }

    my $magic = $q->param('magic');
    my $email = lc $q->param('email');
    $email =~ s/(^\s+|\s+$)//gs;
    my $secret = $app->config->SecretToken;
    my $salt   = substr( $magic, 0, 2 );
    my $failed = 0;
    if ( crypt( $secret . $email, $salt ) ne $magic ) {
        $failed = 1;
    }

    my $entry_id = $q->param('entry_id');
    require MT::Blog;
    my $blog = MT::Blog->load($blog_id);
    my $url;
    if ($blog) {
        $url = $blog->site_url();
        if ( my $redirect = $q->param('redirect') ) {
            if ( $redirect !~ m!^\Q$url\E! ) {
                $failed = 1;
            }
            else {
                $url = $redirect;
            }
        }
        else {
            if ($entry_id) {
                require MT::Entry;
                my $entry = MT::Entry->load(
                    {   id      => $entry_id,
                        blog_id => $blog_id,
                        status  => MT::Entry::RELEASE()
                    }
                );
                if ($entry) {
                    $url = $entry->permalink;
                }
                else {
                    $failed = 1;
                }
            }
        }
    }
    else {
        $failed = 1;
    }

    if ($failed) {
        print $q->header;
        print "Subscription confirmation failed.\n";
        exit;
    }

    if ( !$app->lookup( $blog->id, $email ) ) {
        require MT::Notification;
        my $note = MT::Notification->new;
        $note->blog_id($blog_id);
        $note->email($email);
        $note->save;
    }
    print $q->redirect($url);
}

sub unsubscribe {
    my $app = shift;

    my $q = $app->{query};

    my $email = $q->param('email');
    require MT::Notification;
    my $notification = MT::Notification->load( { email => $email } );
    return $app->translate( "The address [_1] was not subscribed.", $email )
        . "\n\n"
        if !$notification;
    $notification->remove();
    return $app->translate( "The address [_1] has been unsubscribed.",
        $email )
        . "\n\n";
}

1;
__END__

=head1 NAME

MT::App::NotifyList - Provide Movable Type email notification support

=head1 SYNOPSIS

  use MT::App::NotifyList;
  $app->init(@args)
  $app->subscribe()
  $notification = $app->lookup($blog_id, $email);
  $app->confirm()
  $app->unsubscribe()

=head1 DESCRIPTION

An C<MT::App::NotifyList> object represents... TODO

=head1 METHODS

=head2 init

  $app->init(@args)

This method is used to construct an C<MT::App::NotifyList> object.
It passes any given arguments onto the C<SUPER::init> method and
registers the methods defined in this package.

=head2 subscribe

  $app->subscribe()

This method verifies and adds an email address to the list of
notifications.

=head2 lookup

  $notification = $app->lookup($blog_id, $email);

This method returns the notification object of the given blog that
contains the given email.  If no email is found in the blod, I<undef>
is returned.

=head2 confirm

  $app->confirm()

This method confirms that an email address was added to the
blog notification list and then redirects to that blog.

=head2 unsubscribe

  $app->unsubscribe()

This method removes an email address from the notification.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.
