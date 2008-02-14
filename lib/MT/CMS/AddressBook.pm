package MT::CMS::AddressBook;

use strict;

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
        $app->print( $note->email );
        $app->print(',');
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
