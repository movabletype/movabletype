package EntryTemplateForTinyMCE::App;

use strict;
use warnings;

use EntryTemplate::App;

sub view_text {
    my $app  = shift;
    my $user = $app->user;

    my $entry_template
        = MT->model('entry_template')->load( $app->param('id') )
        or
        return $app->error( $app->translate('Cannot load entry template.') );

    return $app->permission_denied()
        if ( !$user->is_superuser )
        && (
        !EntryTemplate::App::can_view_entry_template(
            $app->permissions, $entry_template, $app->user
        )
        );

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print_encode( $entry_template->text );
}

1;
