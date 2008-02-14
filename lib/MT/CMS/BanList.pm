package MT::CMS::BanList;

use strict;

sub can_save {
    my ( $eh, $app, $id ) = @_;
    my $perms = $app->permissions;
    return $perms
      && ( $perms->can_edit_config || $perms->can_manage_feedback );
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;
    my $ip    = $app->param('ip');
    $ip =~ s/(^\s+|\s+$)//g;
    return $eh->error(
        MT->translate("You did not enter an IP address to ban.") )
      if ( '' eq $ip );
    my $blog_id = $app->param('blog_id');
    require MT::IPBanList;
    my $existing =
      MT::IPBanList->load( { 'ip' => $ip, 'blog_id' => $blog_id } );
    my $id = $app->param('id');

    if ( $existing && ( !$id || $existing->id != $id ) ) {
        return $eh->error(
            $app->translate(
                "The IP you entered is already banned for this blog.")
        );
    }
    return 1;
}

1;
