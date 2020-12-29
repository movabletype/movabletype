# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Export;

use strict;
use warnings;
use MT::Util qw( dirify );

sub start_export {
    my $app = shift;
    my %param;
    my $blog_id = $app->param('blog_id');

    return $app->permission_denied()
        if !$app->can_do('open_blog_export_screen');

    my $blog = $app->model('blog')->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
        if !$blog;

    $param{blog_id} = $blog_id;
    $app->add_breadcrumb( $app->translate('Export Site Entries') );
    $app->load_tmpl( 'export.tmpl', \%param );
}

sub export {
    my $app     = shift;
    my $charset = $app->charset;
    require MT::Blog;
    my $blog_id = $app->param('blog_id')
        or
        return $app->error( $app->translate("Please select a site."), 400 );
    my $blog = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate(
            "Loading site '[_1]' failed: [_2]", $blog_id,
            MT::Blog->errstr
        ),
        404
        );
    my $perms = $app->permissions;
    return $app->error( $app->translate("You do not have export permissions"),
        403 )
        unless $perms && $perms->can_do('export_blog');
    $app->validate_magic() or return;
    my $file = dirify( $blog->name ) . ".txt";

    if ( $file eq ".txt" ) {
        my @ts = localtime(time);
        $file = sprintf "export-%06d-%04d%02d%02d%02d%02d%02d.txt",
            $blog_id, $ts[5] + 1900, $ts[4] + 1,
            @ts[ 3, 2, 1, 0 ];
    }

    $app->{no_print_body} = 1;
    local $| = 1;

    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $charset
        ? "text/plain; charset=$charset"
        : 'text/plain'
    );
    require MT::ImportExport;
    MT::ImportExport->export( $blog, sub { $app->print_encode(@_) } )
        or return $app->error( MT::ImportExport->errstr, 500 );
    1;
}

1;
