# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: Category.pm 108799 2009-08-11 11:13:24Z asawada $
package MT::Theme::StaticFiles;
use strict;
use MT;

sub _default_allowed_extensions {
    return [ qw(
        jpg jpeg gif png js css ico flv swf
    )];
}

sub import {
    my ( $element, $theme, $blog ) = @_;
    my $dirs = $element->{data} or return 1;
    my $exts = MT->config->ThemeStaticFileExtensions || _default_allowed_extensions();
    $exts = [ split /[\s,]+/, $exts ] if !ref $exts;
    for my $dir ( @$dirs ) {
        next if $dir =~ /[^\w\-\.]/;
        my $src = File::Spec->catdir( $theme->path, 'blog_static', $dir );
        my $dst = File::Spec->catdir( $blog->site_path, $dir );
        my $result = $theme->install_static_files(
            $src,
            $dst,
            allow => $exts,
        );
    }
    return 1;
}

sub export_template {
    my $app = shift;
    my ( $blog, $saved ) = @_;
    my $default =
        '# ' . MT->translate(
            'List the name of one directory to be included in your theme on each line.'
        );
    my $dirs = defined $saved ? $saved->{static_directories}
             :                  $default
             ;
    my $exts = MT->config->ThemeStaticFileExtensions || _default_allowed_extensions();
    $exts = [ split /[\s,]+/, $exts ] if !ref $exts;
    my $extlist = join( ', ', @$exts );
    return $app->load_tmpl(
        'include/theme_exporters/static_files.tmpl',
        {
            static_directories => $dirs,
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
    my $exts = MT->config->ThemeStaticFileExtensions || _default_allowed_extensions();
    $exts = [ split /[\s,]+/, $exts ] if !ref $exts;
    my $dirs = $sf_hash->{data};
    for my $dir ( @$dirs ) {
        next if $dir =~ /[^\w\-\.]/;
        my $src = File::Spec->catdir( $blog->site_path, $dir );
        my $dst = File::Spec->catdir( $tmpdir, 'blog_static', $dir );
        require MT::Theme;
        my $result = MT::Theme->install_static_files(
            $src,
            $dst,
            allow => $exts,
        );
    }
    return 1;
}

1;

