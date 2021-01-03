# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Theme::StaticFiles;
use strict;
use warnings;
use MT;

sub apply {
    my ( $element, $theme, $blog ) = @_;
    my $dirs = $element->{data} or return 1;
    for my $dir (@$dirs) {
        next if $dir =~ /[^\w\-\.]/;
        my $src = File::Spec->catdir( $theme->path, 'blog_static', $dir );
        my $dst = File::Spec->catdir( $blog->site_path, $dir );
        my $result = $theme->install_static_files( $src, $dst );
    }
    return 1;
}

sub export_template {
    my $app = shift;
    my ( $blog, $saved ) = @_;
    my $default = '';
    my $dirs
        = defined $saved
        ? $saved->{static_directories}
        : $default;
    my $extlist = MT->config->ThemeStaticFileExtensions;
    $extlist =~ s/[\s,]+/, /g;
    return $app->load_tmpl(
        'include/theme_exporters/static_files.tmpl',
        {   static_directories => $dirs,
            allowed_extensions => $extlist,
        },
    );
}

sub export {
    my ( $app, $blog, $settings ) = @_;
    if ( defined $settings ) {
        my $dirs = $settings->{static_directories};
        $dirs = $dirs->[0] if ref $dirs eq 'ARRAY';
        $dirs =~ s/\#.*$//g; ## skip from hashmark to linefeed. it is comment.
        my @dirs = split( /\s*\n\s*/, $dirs );
        @dirs = grep { $_ =~ /^\w[\w\-\.]*$/ } @dirs;
        return \@dirs;
    }
    return;
}

sub finalize {
    my $app = shift;
    my ( $blog, $theme_hash, $tmpdir, $setting ) = @_;
    my $sf_hash = $theme_hash->{elements}{blog_static_files}
        or return 1;
    my $dirs = $sf_hash->{data};
    for my $dir (@$dirs) {
        next if $dir =~ /[^\w\-\.]/;
        my $src = File::Spec->catdir( $blog->site_path, $dir );
        my $dst = File::Spec->catdir( $tmpdir, 'blog_static', $dir );
        require MT::Theme;
        my $result = MT::Theme->install_static_files( $src, $dst );
    }
    return 1;
}

1;
