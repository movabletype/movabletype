package FormattedTextForTinyMCE::App;

use strict;
use warnings;

use FormattedText::App;

sub view_text {
    my $app  = shift;
    my $user = $app->user;

    my $formatted_text
        = MT->model('formatted_text')->load( $app->param('id') )
        or
        return $app->error( $app->translate('Cannot load formatted text.') );

    return $app->permission_denied()
        if ( !$user->is_superuser )
        && (
        !FormattedText::App::can_view_formatted_text(
            $app->permissions, $formatted_text, $app->user
        )
        );

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print_encode( $formatted_text->text );
}

1;
