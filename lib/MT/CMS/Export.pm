package MT::CMS::Export;

use strict;
use MT::Util qw( dirify );

sub start_export {
    my $app = shift;
    my %param;
    my $blog_id = $app->param('blog_id');

    my $perms = $app->permissions;
    return $app->return_to_dashboard( permission => 1 )
      if ( $perms && !$perms->can_administer_blog );

    $param{blog_id} = $blog_id;
    $app->load_tmpl( 'export.tmpl', \%param );
}

sub export {
    my $app = shift;
    my $charset = $app->charset;
    require MT::Blog;
    my $blog_id = $app->param('blog_id')
      or return $app->error( $app->translate("Please select a blog.") );
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(
        $app->translate(
            "Load of blog '[_1]' failed: [_2]",
            $blog_id, MT::Blog->errstr
        )
      );
    my $perms = $app->permissions;
    return $app->error( $app->translate("You do not have export permissions") )
      unless $perms && $perms->can_edit_config;
    $app->validate_magic() or return;
    my $file = dirify( $blog->name ) . ".txt";

    if ( $file eq ".txt" ) {
        my @ts = localtime(time);
        $file = sprintf "export-%06d-%04d%02d%02d%02d%02d%02d.txt",
          $app->param('blog_id'), $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
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
    MT::ImportExport->export( $blog, sub { $app->print(@_) } )
      or return $app->error( MT::ImportExport->errstr );
    1;
}

1;
