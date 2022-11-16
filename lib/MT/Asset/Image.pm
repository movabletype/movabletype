# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset::Image;

use strict;
use warnings;
use base qw( MT::Asset );
use MT;
use MT::Blog;
use MT::Website;
use POSIX qw( floor );

__PACKAGE__->install_properties(
    {   class_type  => 'image',
        column_defs => {
            'image_width'  => 'integer meta',
            'image_height' => 'integer meta',
        },
        child_of => [ 'MT::Blog', 'MT::Website', ],
    }
);

# List of supported file extensions (to aid the stock 'can_handle' method.)
sub extensions {
    my $pkg = shift;
    return $pkg->SUPER::extensions(
        [ qr/gif/i, qr/jpe?g/i, qr/png/i, qr/bmp/i, qr/tiff?/i, qr/ico/i ] );
}

sub image_metadata {
    my $self = shift;
    if ($self->exif) {
        my $info = $self->exif->GetInfo;
        delete $info->{ThumbnailImage};
        return $info;
    }
    return;
}

sub class_label {
    MT->translate('Image');
}

sub class_label_plural {
    MT->translate('Images');
}

sub metadata {
    my $obj  = shift;
    my $meta = $obj->SUPER::metadata(@_);

    my $width  = $obj->image_width;
    my $height = $obj->image_height;
    $meta->{image_width}  = $width  if defined $width;
    $meta->{image_height} = $height if defined $height;
    $meta->{image_dimensions} = $meta->{ MT->translate("Actual Dimensions") }
        = $meta->{'Actual Dimensions'}
        = MT->translate( "[_1] x [_2] pixels", $width, $height )
        if defined $width && defined $height;

    $meta;
}

sub image_height {
    my $asset = shift;
    my $height = $asset->meta( 'image_height', @_ );
    return $height if $height || @_;

    if ( !-e $asset->file_path || !-r $asset->file_path ) {
        return undef;
    }
    require MT::Image;
    my ( $w, $h, $id ) = MT::Image->get_image_info( Filename => $asset->file_path );
    $asset->meta( 'image_height', $h );
    if ( $asset->id ) {
        $asset->save;
    }
    return $h;
}

sub image_width {
    my $asset = shift;
    my $width = $asset->meta( 'image_width', @_ );
    return $width if $width || @_;

    if ( !-e $asset->file_path || !-r $asset->file_path ) {
        return undef;
    }
    require MT::Image;
    my ( $w, $h, $id ) = MT::Image->get_image_info( Filename => $asset->file_path );
    $asset->meta( 'image_width', $w );
    if ( $asset->id ) {
        $asset->save;
    }
    return $w;
}

sub has_thumbnail {
    my $asset = shift;

    return unless -f $asset->file_path;
    return 0 if $asset->file_ext =~ /tiff?$/;

    require MT::Image;
    my $image = MT::Image->new(
        ( ref $asset ? ( Type => $asset->file_ext ) : () ) );
    $image ? 1 : 0;
}

sub thumbnail_path {
    my $asset = shift;
    my (%param) = @_;

    $asset->_make_cache_path( $param{Path} );
}

sub maybe_dynamic_thumbnail_url {
    my ($asset, %param) = @_;
    my $mt_url = delete $param{BaseURL};
    my ($width, $height, $size_changed) = $asset->_get_size_from_param(\%param);
    if ($asset->thumbnail_file(%param, NoCreate => 1)) {
        return $asset->thumbnail_url(%param);
    } else {
        my %args = (
            id      => $asset->id,
            blog_id => $asset->blog_id,
            width   => $width,
            height  => $height,
        );
        $args{square} = 1 if $param{Square};
        $args{ts} = $asset->modified_on if $param{Ts} && $asset->modified_on;
        my $url = MT->app->mt_uri(
            mode => 'thumbnail_image',
            args => \%args,
        );
        return ($url, $width, $height);
    }
}

sub _get_size_from_param {
    my ($asset, $param) = @_;

    my ( $i_h, $i_w ) = ( $asset->image_height, $asset->image_width );
    return undef unless $i_h && $i_w;

    # Pretend the image is already square, for calculation purposes.
    my $auto_size = 1;
    if ( $param->{Square} ) {
        require MT::Image;
        my %square
            = MT::Image->inscribe_square( Width => $i_w, Height => $i_h );
        ( $i_h, $i_w ) = @square{qw( Size Size )};
        if ( $param->{Width} && !$param->{Height} ) {
            $param->{Height} = $param->{Width};
        }
        elsif ( !$param->{Width} && $param->{Height} ) {
            $param->{Width} = $param->{Height};
        }
        $auto_size = 0;
    }
    if ( my $scale = $param->{Scale} ) {
        $param->{Width}  = int( ( $i_w * $scale ) / 100 );
        $param->{Height} = int( ( $i_h * $scale ) / 100 );
        $auto_size     = 0;
    }
    if ( !exists $param->{Width} && !exists $param->{Height} ) {
        $param->{Width}  = $i_w;
        $param->{Height} = $i_h;
        $auto_size     = 0;
    }

    # find the longest dimension of the image:
    my ( $n_h, $n_w, $scaled )
        = _get_dimension( $i_h, $i_w, $param->{Height}, $param->{Width} );
    if ( $auto_size && $scaled eq 'h' ) {
        delete $param->{Width} if exists $param->{Width};
    }
    elsif ( $auto_size && $scaled eq 'w' ) {
        delete $param->{Height} if exists $param->{Height};
    }

    my $changed = (($n_w == $i_w) && ($n_h == $i_h)) ? 0 : 1;

    return ($n_w, $n_h, $changed);
}

sub thumbnail_file {
    my $asset = shift;
    my (%param) = @_;
    my $fmgr;
    my $blog = $param{Blog} || $asset->blog;

    require MT::FileMgr;
    $fmgr ||= $blog ? $blog->file_mgr : MT::FileMgr->new('Local');
    return undef unless $fmgr;

    my $file_path = $asset->file_path;
    return undef unless $fmgr->file_size($file_path);

    return undef if $asset->file_ext =~ /tiff?$/;

    require MT::Util;
    my $asset_cache_path = $asset->_make_cache_path( $param{Path} );

    my ($n_w, $n_h, $size_changed) = $asset->_get_size_from_param(\%param);

    my $file = $asset->thumbnail_filename(%param) or return;
    my $thumbnail = File::Spec->catfile( $asset_cache_path, $file );

    # thumbnail file exists and is dated on or later than source image
    if ($fmgr->exists($thumbnail)
        && ( $fmgr->file_mod_time($thumbnail)
            >= $fmgr->file_mod_time($file_path) )
        )
    {
        my $already_exists = 1;
        if ( $asset->image_width != $asset->image_height ) {
            require MT::Image;
            my ( $t_w, $t_h )
                = MT::Image->get_image_info( Filename => $thumbnail );
            if (   ( $param{Square} && $t_h != $t_w )
                || ( !$param{Square} && $t_h == $t_w ) )
            {
                $already_exists = 0;
            }
        }
        return ( $thumbnail, $n_w, $n_h ) if $already_exists;
    }
    return if $param{NoCreate};

    # stale or non-existent thumbnail. let's create one!
    return undef unless $fmgr->can_write($asset_cache_path);

    my $data;
    if (   !$size_changed
        && !$param{Square}
        && !$param{Type} )
    {
        $data = $fmgr->get_data( $file_path, 'upload' );
    }
    else {

        # create a thumbnail for this file
        require MT::Image;
        my $img = new MT::Image( Filename => $file_path )
            or return $asset->error( MT::Image->errstr );

        # Really make the image square, so our scale calculation works out.
        if ( $param{Square} ) {
            ($data) = $img->make_square()
                or return $asset->error(
                MT->translate( "Error cropping image: [_1]", $img->errstr ) );
        }

        ($data) = $img->scale( Height => $n_h, Width => $n_w )
            or return $asset->error(
            MT->translate( "Error scaling image: [_1]", $img->errstr ) );

        if ( my $type = $param{Type} ) {
            ($data) = $img->convert( Type => $type )
                or return $asset->error(
                MT->translate( "Error converting image: [_1]", $img->errstr )
                );
        }
    }
    $fmgr->put_data( $data, $thumbnail, 'upload' )
        or return $asset->error(
        MT->translate( "Error creating thumbnail file: [_1]", $fmgr->errstr )
        );

    # Remove metadata from thumbnail file.
    require MT::Image;
    MT::Image->remove_metadata($thumbnail)
        or return $asset->error( MT::Image->errstr );

    return ( $thumbnail, $n_w, $n_h );
}

sub _get_dimension {
    my ( $i_h, $i_w, $h, $w ) = @_;

    my ( $n_h, $n_w ) = ( $i_h, $i_w );
    my $scale = '';
    if ( $h && !$w ) {
        $scale = 'h';
    }
    elsif ( $w && !$h ) {
        $scale = 'w';
    }
    else {
        if ( $i_h > $i_w ) {

            # scale, if necessary, by height
            if ( $i_h > $h ) {
                $scale = 'h';
            }
            elsif ( $i_w > $w ) {
                $scale = 'w';
            }
        }
        else {

            # scale, if necessary, by width
            if ( $i_w > $w ) {
                $scale = 'w';
            }
            elsif ( $i_h > $h ) {
                $scale = 'h';
            }
        }
    }
    if ( $scale eq 'h' ) {

        # scale by height
        $n_h = $h;
        $n_w = floor( ( $i_w * $h / $i_h ) + 0.5 );
    }
    elsif ( $scale eq 'w' ) {

        # scale by width
        $n_w = $w;
        $n_h = floor( ( $i_h * $w / $i_w ) + 0.5 );
    }
    $n_h = 1 unless $n_h;
    $n_w = 1 unless $n_w;

    return ( $n_h, $n_w, $scale );
}

sub thumbnail_filename {
    my $asset   = shift;
    my (%param) = @_;
    my $file    = $asset->file_name or return;

    require MT::Util;
    my $format = $param{Format} || MT->translate('%f-thumb-%wx%h-%i%x');
    my $width  = $param{Width}  || 'auto';
    my $height = $param{Height} || 'auto';
    $file =~ s/\.\w+$//;
    my $base = File::Basename::basename($file);
    my $id   = $asset->id;
    my $ext  = lc( $param{Type} || '' ) || $asset->file_ext || '';
    $ext = '.' . $ext;
    $format =~ s/%w/$width/g;
    $format =~ s/%h/$height/g;
    $format =~ s/%f/$base/g;
    $format =~ s/%i/$id/g;
    $format =~ s/%x/$ext/g;
    return $format;
}

sub as_html {
    my $asset   = shift;
    my ($param) = @_;
    my $text    = '';

    my $app = MT->instance;
    $param->{enclose} = 0 unless exists $param->{enclose};

    if ( $param->{include} ) {
        my $fname = $asset->file_name;
        require MT::Util;

        my $thumb = undef;
        if ( $param->{thumb} ) {
            $thumb = MT::Asset->load( $param->{thumb_asset_id} )
                || return $asset->error(
                MT->translate(
                    "Cannot load image #[_1]",
                    $param->{thumb_asset_id}
                )
                );
        }

        my $dimensions = sprintf(
            'width="%s" height="%s"',
            (   $thumb
                ? ( $thumb->image_width, $thumb->image_height )
                : ( $asset->image_width, $asset->image_height )
            )
        );
        my $wrap_style = '';
        if ( $param->{wrap_text} && $param->{align} ) {
            $wrap_style = 'class="mt-image-' . $param->{align} . '" ';
            if ( $param->{align} eq 'none' ) {
                $wrap_style .= q{style=""};
            }
            elsif ( $param->{align} eq 'left' ) {
                $wrap_style .= q{style="float: left; margin: 0 20px 20px 0;"};
            }
            elsif ( $param->{align} eq 'right' ) {
                $wrap_style
                    .= q{style="float: right; margin: 0 0 20px 20px;"};
            }
            elsif ( $param->{align} eq 'center' ) {
                $wrap_style
                    .= q{style="text-align: center; display: block; margin: 0 auto 20px;"};
            }
        }

        if ( $param->{popup} && $param->{popup_asset_id} ) {
            my $popup = MT::Asset->load( $param->{popup_asset_id} )
                || return $asset->error(
                MT->translate(
                    "Cannot load image #[_1]",
                    $param->{popup_asset_id}
                )
                );
            my $link
                = $thumb
                ? sprintf(
                '<img src="%s" %s alt="%s" %s />',
                MT::Util::encode_html( $thumb->url ),   $dimensions,
                MT::Util::encode_html( $asset->label ), $wrap_style
                )
                : MT->translate('View image');

            if ($param->{image_default_link} == 1) {
                $text = sprintf(
                    q|<a href="%s" data-test="popup-now" onclick="window.open('%s','popup','width=%d,height=%d,scrollbars=yes,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'); return false">%s</a>|,
                    MT::Util::encode_html( $popup->url ),
                    MT::Util::encode_html( $popup->url ),
                    $asset->image_width,
                    $asset->image_height + 1,
                    $link,
                );
            } else {
                $text = sprintf(
                    q|<a href="%s">%s</a>|,
                    MT::Util::encode_html( $popup->url ),
                    $link,
                );
            }
        }
        else {
            if ( $param->{thumb} ) {
                $text = sprintf(
                    '<a href="%s"><img alt="%s" src="%s" %s %s /></a>',
                    MT::Util::encode_html( $asset->url ),
                    MT::Util::encode_html( $asset->label ),
                    MT::Util::encode_html( $thumb->url ),
                    $dimensions,
                    $wrap_style,
                );
            }
            else {
                $text = sprintf(
                    '<img alt="%s" src="%s" %s %s />',
                    MT::Util::encode_html( $asset->label ),
                    MT::Util::encode_html( $asset->url ),
                    $dimensions, $wrap_style,
                );
            }
        }
    }
    else {
        require MT::Util;
        $text = sprintf(
            '<a href="%s">%s</a>',
            MT::Util::encode_html( $asset->url ),
            MT::Util::encode_html( $asset->display_name )
        );
    }

    return $param->{enclose} ? $asset->enclose($text) : $text;
}

# Return a HTML snippet of form options for inserting this asset
# into a web page. Default behavior is no options.
sub insert_options {
    my $asset = shift;
    my ($param) = @_;

    my $app   = MT->instance;
    my $perms = $app->{perms};
    my $blog  = $asset->blog or return;

    $param->{do_thumb} = $asset->has_thumbnail && $asset->can_create_thumbnail ? 1 : 0;

    $param->{disabled_popup}  = MT->config('DisableImagePopup') ? 1 : 0;
    $param->{can_popup}       = $blog->can_popup_image();
    $param->{popup}           = $blog->image_default_popup                       ? 1                         : 0;
    $param->{wrap_text}       = $blog->image_default_wrap_text                   ? 1                         : 0;
    $param->{make_thumb}      = $blog->image_default_thumb                       ? 1                         : 0;
    $param->{popup_link}      = $param->{can_popup} && $blog->image_default_link ? $blog->image_default_link : 2;
    $param->{ 'align_' . $_ } = ($blog->image_default_align  || 'none') eq $_   ? 1 : 0 for qw(none left center right);
    $param->{ 'unit_w' . $_ } = ($blog->image_default_wunits || 'pixels') eq $_ ? 1 : 0 for qw(percent pixels);
    $param->{thumb_width} =
           $blog->image_default_width
        || $asset->image_width
        || 0;

    return $app->build_page('include/insert_options_image.tmpl', $param);
}

sub on_upload {
    my $asset = shift;
    my ($param) = @_;

    $asset->SUPER::on_upload(@_);

    return unless $param->{new_entry};

    my $app = MT->instance;
    require MT::Util;

    my $url    = $asset->url;
    my $width  = $asset->image_width;
    my $height = $asset->image_height;

    my ( $base_url, $fname ) = $url =~ m|(.*)/([^/]*)|;
    $url = $base_url . '/'
        . $fname;    # no need to re-encode filename; url is already encoded
    my $blog = $asset->blog or return;
    my $blog_id = $blog->id;

    my $thumb_width = $param->{thumb_width};
    my $thumb       = $param->{thumb};
    if ($thumb) {
        if ( $thumb_width && ( $thumb_width !~ m/^\d+$/ ) ) {
            undef $thumb_width;
        }

        # width > 1000 not really a thumbnail, so consider invalid
        if ( $thumb_width > 1000 ) {
            undef $thumb_width;
        }
    }
    if ( $thumb && !$thumb_width ) {
        undef $thumb;
    }
    if ( $param->{image_defaults} ) {

        # Save new defaults if requested.
        $blog->image_default_wrap_text( $param->{wrap_text} ? 1 : 0 );
        $blog->image_default_align( $param->{align} || MT::Blog::ALIGN() );
        if ($thumb) {
            $blog->image_default_thumb(1);
            $blog->image_default_width($thumb_width);
            $blog->image_default_wunits( $param->{thumb_width_type}
                    || MT::Blog::UNITS() );
        }
        else {
            $blog->image_default_thumb(0);
            $blog->image_default_width(0);
            $blog->image_default_wunits( MT::Blog::UNITS() );
        }

        #$blog->image_default_constrain($param->{constrain} ? 1 : 0);
        $blog->image_default_popup( $param->{popup} ? 1 : 0 );
        $blog->save or die $blog->errstr;
    }
    my $fmgr = $blog->file_mgr;
    require MT::Util;

    # Thumbnail creation
    if ( $thumb = $param->{thumb} ) {
        require MT::Image;
        my $image_type = scalar $param->{image_type};
        my ( $w, $h ) = map $param->{$_}, qw( thumb_width thumb_height );
        if ( !$h ) {
            my $pct = $w / $width;
            $h = floor( ( $pct * $height ) + 0.5 );
        }

        my ($pseudo_thumbnail_url)
            = $asset->thumbnail_url( Height => $h, Width => $w, Pseudo => 1 );
        my ($thumbnail)
            = File::Basename::basename(
            $asset->thumbnail_file( Height => $h, Width => $w ) );

        my $pseudo_thumbnail_path
            = File::Spec->catfile( $asset->_make_cache_path( undef, 1 ),
            $thumbnail );
        my ( $base, $path, $ext )
            = File::Basename::fileparse( $thumbnail, qr/[A-Za-z0-9]+$/ );
        my $img_pkg = MT::Asset->handler_for_file($thumbnail);
        my $original;
        my $asset_thumb = $img_pkg->load(
            {   file_name => "$base$ext",
                parent    => $asset->id,
            }
        );

        if ( !$asset_thumb ) {
            $asset_thumb = $img_pkg->new();
            $original    = $asset_thumb->clone;
            $asset_thumb->blog_id($blog_id);
            $asset_thumb->url($pseudo_thumbnail_url);
            $asset_thumb->file_path($pseudo_thumbnail_path);
            $asset_thumb->file_name("$base$ext");
            $asset_thumb->file_ext($ext);
            $asset_thumb->image_width($w);
            $asset_thumb->image_height($h);
            $asset_thumb->created_by( $app->user->id );
            $asset_thumb->label(
                $app->translate(
                    "Thumbnail image for [_1]",
                    $asset->label || $asset->file_name
                )
            );
            $asset_thumb->parent( $asset->id );
        }
        else {
            $original = $asset_thumb->clone;
        }

        # force these to calculate now, giving a full URL / file path
        # for callbacks
        $thumbnail = $asset_thumb->file_path;
        my $thumbnail_url   = $asset_thumb->url;
        my $thumb_file_size = $fmgr->file_size($thumbnail);

        $app->run_callbacks( 'cms_pre_save.asset', $app, $asset_thumb,
            $original )
            || return $app->errtrans( "Saving [_1] failed: [_2]",
            'asset', $app->errstr );

        $asset_thumb->save unless $asset_thumb->id;

        $app->run_callbacks( 'cms_post_save.asset', $app, $asset_thumb,
            $original );

        $param->{thumb_asset_id} = $asset_thumb->id;

        $app->run_callbacks(
            'cms_upload_file.' . $asset_thumb->class,
            File  => $thumbnail,
            file  => $thumbnail,
            Url   => $thumbnail_url,
            url   => $thumbnail_url,
            Size  => $thumb_file_size,
            size  => $thumb_file_size,
            Asset => $asset_thumb,
            asset => $asset_thumb,
            Type  => 'thumbnail',
            type  => 'thumbnail',
            Blog  => $blog,
            blog  => $blog
        );

        $app->run_callbacks(
            'cms_upload_image',
            File       => $thumbnail,
            file       => $thumbnail,
            Url        => $thumbnail_url,
            url        => $thumbnail_url,
            Asset      => $asset_thumb,
            asset      => $asset_thumb,
            Width      => $w,
            width      => $w,
            Height     => $h,
            height     => $h,
            ImageType  => $image_type,
            image_type => $image_type,
            Size       => $thumb_file_size,
            size       => $thumb_file_size,
            Type       => 'thumbnail',
            type       => 'thumbnail',
            Blog       => $blog,
            blog       => $blog
        );
    }
    if ( $param->{popup} ) {
        require MT::Template;
        if (my $tmpl = MT::Template->load(
                {   blog_id => $blog_id,
                    type    => 'popup_image'
                }
            )
            )
        {
            ( my $rel_path = $param->{fname} ) =~ s!\.[^.]*$!!;
            if ( $rel_path =~ m!\.\.|\0|\|! ) {
                return $app->error(
                    $app->translate( "Invalid basename '[_1]'", $rel_path ) );
            }
            $rel_path .= '-' . $asset->id;
            my $ext = $blog->file_extension || '';
            $ext = '.' . $ext if $ext ne '';
            require MT::Template::Context;
            my $ctx = MT::Template::Context->new;
            $ctx->stash( 'blog',         $blog );
            $ctx->stash( 'blog_id',      $blog->id );
            $ctx->stash( 'asset',        $asset );
            $ctx->stash( 'image_url',    $url );
            $ctx->stash( 'image_width',  $width );
            $ctx->stash( 'image_height', $height );
            my $popup = $tmpl->build($ctx);
            die $tmpl->errstr unless defined $popup;
            my $root_path = $asset->_make_cache_path;
            my $pseudo_path = $asset->_make_cache_path( undef, 1 );
            my $abs_file_path
                = File::Spec->catfile( $root_path, $rel_path . $ext );

            my ( $i, $rel_path_ext ) = ( 0, $rel_path . $ext );
            my $pseudo_url = File::Spec->catfile( $pseudo_path,
                MT::Util::encode_url($rel_path_ext) );
            $pseudo_path = File::Spec->catfile( $pseudo_path, $rel_path_ext );
            my ( $vol, $dirs, $basename )
                = File::Spec->splitpath($rel_path_ext);

            ## Untaint. We have checked for security holes above, so we
            ## should be safe.
            ($abs_file_path) = $abs_file_path =~ /(.+)/s;
            $fmgr->put_data( $popup, $abs_file_path, 'upload' )
                or return $app->error(
                $app->translate(
                    "Error writing to '[_1]': [_2]", $abs_file_path,
                    $fmgr->errstr
                )
                );

            my $html_pkg = MT::Asset->handler_for_file($abs_file_path);
            my $original;
            my $asset_html = $html_pkg->load(
                {   file_name => "$basename",
                    parent    => $asset->id
                }
            );
            if ( !$asset_html ) {
                $asset_html = new $html_pkg;
                $original   = $asset_html->clone;
                $asset_html->blog_id($blog_id);
                $pseudo_url =~ s!\\!/!g;
                $asset_html->url($pseudo_url);
                $asset_html->label(
                    $app->translate(
                        "Popup page for [_1]",
                        $asset->label || $asset->file_name
                    )
                );
                $asset_html->file_path($pseudo_path);
                $asset_html->file_name($basename);
                $asset_html->file_ext( $blog->file_extension );
                $asset_html->created_by( $app->user->id );
                $asset_html->parent( $asset->id );
            }
            else {
                $original = $asset_html->clone;
            }

            # Select back the real URL for callbacks
            $url = $asset_html->url;

            $app->run_callbacks( 'cms_pre_save.asset', $app, $asset_html,
                $original )
                || return $app->errtrans( "Saving [_1] failed: [_2]",
                'asset', $app->errstr );

            $asset_html->save unless $asset_html->id;

            $param->{popup_asset_id} = $asset_html->id;

            $app->run_callbacks( 'cms_post_save.asset', $app, $asset_html,
                $original );

            $app->run_callbacks(
                'cms_upload_file.' . $asset_html->class,
                File  => $abs_file_path,
                file  => $abs_file_path,
                Url   => $url,
                url   => $url,
                Asset => $asset_html,
                asset => $asset_html,
                Size  => length($popup),
                size  => length($popup),
                Type  => 'popup',
                type  => 'popup',
                Blog  => $blog,
                blog  => $blog
            );
        }
    }
    1;
}

sub edit_template_param {
    my $asset = shift;
    my ( $cb, $app, $param, $tmpl ) = @_;

    $param->{image_height} = $asset->image_height;
    $param->{image_width}  = $asset->image_width;
}

sub normalize_orientation {
    my $obj = shift;

    require Image::ExifTool;

    my $exif_tool = new Image::ExifTool;
    my $file_path = $obj->file_path;
    my $fmgr = $obj->blog ? $obj->blog->file_mgr : MT::FileMgr->new('Local');
    my $img_data = $fmgr->get_data( $file_path, 'upload' );

    $exif_tool->ExtractInfo( \$img_data );
    my $o = $exif_tool->GetInfo('Orientation')->{'Orientation'};
    if ( $o && ( $o ne 'Horizontal (normal)' && $o !~ /^Unknown/i ) ) {

        # Preserve metadata.
        my $new_exif;
        my $has_metadata = $obj->has_metadata;
        if ($has_metadata) {
            $new_exif = Image::ExifTool->new;
            $new_exif->SetNewValuesFromFile($file_path);
        }

        my $img = MT::Image->new( Data => $img_data, Type => $obj->file_ext );

        my ( $blob, $width, $height ) = do {
            if ( $o eq 'Mirror horizontal' ) {
                $img->flipVertical();
            }
            elsif ( $o eq 'Rotate 180' ) {
                $img->rotate( Degrees => 180 );
            }
            elsif ( $o eq 'Mirror vertical' ) {
                $img->flipHorizontal();
            }
            elsif ( $o eq 'Mirror horizontal and rotate 270 CW' ) {
                $img->flipVertical();
                $img->rotate( Degrees => 270 );
            }
            elsif ( $o eq 'Rotate 90 CW' ) {
                $img->rotate( Degrees => 90 );
            }
            elsif ( $o eq 'Mirror horizontal and rotate 90 CW' ) {
                $img->flipVertical();
                $img->rotate( Degrees => 90 );
            }
            elsif ( $o eq 'Rotate 270 CW' ) {
                $img->rotate( Degrees => 270 );
            }
        };
        $fmgr->put_data( $blob, $file_path, 'upload' );

        # Update and write metadata.
        if ($has_metadata) {
            $new_exif->SetNewValue('Orientation');
            $new_exif->SetNewValue('Thumbnail*');
            if (exists $exif_tool->GetInfo('ExifImageWidth')->{ExifImageWidth}
                )
            {
                $new_exif->SetNewValue( 'ExifImageWidth' => $width );
            }
            if (exists $exif_tool->GetInfo('ExifImageHeight')
                ->{ExifImageHeight} )
            {
                $new_exif->SetNewValue( 'ExifImageHeight' => $height );
            }

            $new_exif->WriteInfo($file_path);    # Do not check error.
        }

        $obj->image_width($width);
        $obj->image_height($height);
    }

    1;
}

sub scale {
    my ( $asset, $width, $height ) = @_;

    if ( !$width || !$height ) {
        return $asset->trans_error(
            'Scaling image failed: Invalid parameter.');
    }

    $asset->_transform(
        sub { $_[0]->scale( Width => $width, Height => $height ) } );
}

sub crop_rectangle {
    my ( $asset, $left, $top, $width, $height ) = @_;

    if ( !$width || !$height ) {
        return $asset->trans_error(
            'Cropping image failed: Invalid parameter.');
    }

    $top  = 0 unless defined $top;
    $left = 0 unless defined $left;

    $asset->_transform(
        sub {
            $_[0]->crop_rectangle(
                Width  => $width,
                Height => $height,
                X      => $left,
                Y      => $top
            );
        }
    );
}

sub rotate {
    my ( $asset, $angle ) = @_;

    if ( !$angle ) {
        return $asset->trans_error(
            'Rotating image failed: Invalid parameter.');
    }

    # Normalize angle,
    # because NetPBM driver cannot use negative angle.
    $angle %= 360;

    $asset->_transform( sub { $_[0]->rotate( Degrees => $angle ) } );
}

sub flip_horizontal {
    my ($asset) = @_;
    $asset->_transform( sub { $_[0]->flipHorizontal } );
}

sub flip_vertical {
    my ($asset) = @_;
    $asset->_transform( sub { $_[0]->flipVertical } );
}

sub _transform {
    my ( $asset, $process ) = @_;

    require Image::ExifTool;
    require MT::FileMgr;
    require MT::Image;

    my $file_path = $asset->file_path;
    my $fmgr
        = $asset->blog ? $asset->blog->file_mgr : MT::FileMgr->new('Local');
    my $img_data = $fmgr->get_data( $file_path, 'upload' );

    my $img = MT::Image->new( Data => $img_data, Type => $asset->file_ext );

    # Preserve metadata.
    my ( $exif, $next_exif );
    my $update_metadata
        = lc( $asset->file_ext ) =~ /^(jpe?g|tiff?)$/
        && $asset->has_metadata
        && !$asset->is_metadata_broken;
    if ($update_metadata) {
        $exif      = $asset->exif;
        $next_exif = Image::ExifTool->new;
        $next_exif->SetNewValuesFromFile($file_path);
        $next_exif->SetNewValue('Thumbnail*');
    }

    my ( $blob, $width, $height ) = $process->($img);

    $fmgr->put_data( $blob, $file_path, 'upload' )
        or return $asset->error( $fmgr->errstr );

    if ($update_metadata) {

        # Update Exif.
        if ( exists $exif->GetInfo('ExifImageWidth')->{ExifImageWidth} ) {
            $next_exif->SetNewValue( 'ExifImageWidth' => $width );
        }
        if ( exists $exif->GetInfo('ExifImageHeight')->{ExifImageHeight} ) {
            $next_exif->SetNewValue( 'ExifImageHeight' => $height );
        }

        # Restore metadata.
        $next_exif->WriteInfo($file_path)
            or return $asset->trans_error( 'Writing metadata failed: [_1]',
            $next_exif->GetValue('Error') );
    }

    $asset->image_width($width);
    $asset->image_height($height);

    # Update modified_on.
    my $app = MT->app;
    my $user
        = $app->can('user')
        && $app->user
        && $app->user->id ? $app->user : undef;
    $asset->modified_by( $user->id ) if $user;

    $asset->save or return;

    1;
}

sub change_quality {
    my ( $asset, $quality ) = @_;
    my $type = lc $asset->file_ext;

    if ( $type ne 'jpg' && $type ne 'jpeg' && $type ne 'png' ) {
        return 1;
    }

    # Preserve metadata. ImageDriver other than ImageMagick removes metadata.
    my $new_exif;
    my $update_metadata
        = lc( $asset->file_ext ) =~ /^jpe?g$/
        && $asset->has_metadata
        && !$asset->is_metadata_broken;
    if ($update_metadata) {
        require Image::ExifTool;
        $new_exif = Image::ExifTool->new;
        $new_exif->SetNewValuesFromFile( $asset->file_path );
    }

    require MT::Image;
    my $img = MT::Image->new( Filename => $asset->file_path )
        or return $asset->error( MT::Image->errstr );
    my $blob = $img->blob($quality) or return $asset->error( $img->errstr );

    my $fmgr;
    if ( $asset->blog ) {
        $fmgr = $asset->blog->file_mgr;
    }
    else {
        require MT::FileMgr;
        $fmgr = MT::FileMgr->new('Local');
    }

    $fmgr->put_data( $blob, $asset->file_path, 'upload' )
        or return $asset->trans_error( "Error writing to '[_1]': [_2]",
        $asset->file_path, $fmgr->errstr );

    # Restore metadata.
    if ($update_metadata) {
        $new_exif->WriteInfo( $asset->file_path )
            or return $asset->trans_error(
            "Error writing metadata to '[_1]': [_2]",
            $asset->file_path, $new_exif->GetValue('Error') );
    }

    1;
}

sub transform {
    my ( $asset, @actions ) = @_;

    for my $action (@actions) {
        if ( my $crop = $action->{crop} ) {
            $asset->crop_rectangle(
                $crop->{left},  $crop->{top},
                $crop->{width}, $crop->{height}
            ) or return;
        }
        elsif ( my $flip = $action->{flip} ) {
            if ( $flip eq 'horizontal' ) {
                $asset->flip_horizontal or return;
            }
            elsif ( $flip eq 'vertical' ) {
                $asset->flip_vertical or return;
            }
        }
        elsif ( my $resize = $action->{resize} ) {
            $asset->scale( $resize->{width}, $resize->{height} ) or return;
        }
        elsif ( my $rotate = $action->{rotate} ) {
            $asset->rotate($rotate) or return;
        }
    }

    1;
}

sub exif {
    my ($asset) = @_;
    require Image::ExifTool;
    my $exif = Image::ExifTool->new;
    $exif->ExtractInfo( $asset->file_path )
        or
        return $asset->trans_error( 'Extracting image metadata failed: [_1]',
        $exif->GetValue('Error') );
    return $exif;
}

sub has_gps_metadata {
    my ($asset) = @_;

    return 0 if lc( $asset->file_ext ) !~ /^(jpe?g|tiff?)$/;

    my $exif = $asset->exif or return;
    $exif->Options( Group1 => 'GPS' );
    return ( $exif->GetTagList || $asset->exif->GetValue('GPSDateTime') )
        ? 1
        : 0;
}

my @MandatoryExifTags;

sub has_metadata {
    my ($asset) = @_;

    my $file_ext = lc( $asset->file_ext || '' );
    return 0 if $file_ext !~ /^(jpe?g|tiff?)$/;

    require Image::ExifTool;
    my $exif    = $asset->exif or return;
    my $is_jpeg = $file_ext =~ /^jpe?g$/;
    my $is_tiff = $file_ext =~ /^tiff?$/;

    @MandatoryExifTags = _set_mandatory_exif_tags() unless @MandatoryExifTags;
    for my $g ( $exif->GetGroups ) {
        next
            if $g eq 'ExifTool'
            || $g eq 'File'
            || ( $is_jpeg && $g =~ /\A(?:JFIF|ICC_Profile)\z/ )
            || ( $is_tiff && $g eq 'EXIF' );
        my %writable_tags = map {$_ => 1} Image::ExifTool::GetWritableTags($g);
        delete $writable_tags{$_} for @MandatoryExifTags;
        delete $writable_tags{Orientation};  # special case
        next unless %writable_tags;
        $exif->Options( Group => $g );
        $exif->ExtractInfo( $asset->file_path );
        for my $t ( $exif->GetTagList ) {
            return 1 if $writable_tags{$t};
        }
    }
    return 0;
}

sub _set_mandatory_exif_tags {
    require Image::ExifTool::Exif;
    @MandatoryExifTags = ();
    for my $value (values %Image::ExifTool::Exif::Main) {
        if (ref $value eq 'HASH' && $value->{Mandatory}) {
            push @MandatoryExifTags, $value->{Name};
        }
    }
    @MandatoryExifTags;
}

sub remove_gps_metadata {
    my ($asset) = @_;

    return 1 if lc( $asset->file_ext ) !~ /^(jpe?g|tiff?)$/;
    return 1 if $asset->is_metadata_broken;

    require Image::ExifTool;
    my $exif = Image::ExifTool->new;

    $exif->SetNewValuesFromFile( $asset->file_path );
    $exif->SetNewValue('GPS:*');
    $exif->SetNewValue('GPSDateTime');
    $exif->WriteInfo( $asset->file_path )
        or return $asset->trans_error( 'Writing image metadata failed: [_1]',
        $exif->GetValue('Error') );

    1;
}

sub remove_all_metadata {
    my ($asset) = @_;

    return 1 if lc( $asset->file_ext ) !~ /^(jpe?g|tiff?)$/;
    return 1 if $asset->is_metadata_broken;

    my $exif = $asset->exif or return;

    my $orientation = $exif->GetValue('Orientation');

    $exif->SetNewValue('*');
    if (lc($asset->file_ext) =~ /^jpe?g$/) {
        $exif->SetNewValue( 'JFIF:*', undef, Replace => 2 );
        $exif->SetNewValue( 'ICC_Profile:*', undef, Replace => 2 );
        $exif->SetNewValue( 'EXIF:Orientation', $orientation ) if $orientation;
    }
    $exif->WriteInfo( $asset->file_path )
        or return $asset->trans_error( 'Writing image metadata failed: [_1]',
        $exif->GetValue('Error') );

    1;
}

sub is_metadata_broken {
    my ($asset) = @_;
    if ( my $exif = $asset->exif ) {
        return 1 if $exif->GetValue('Error');
    }
    return 0;
}

1;

__END__

=head1 NAME

MT::Asset::Image

=head1 SYNOPSIS

    use MT::Asset::Image;

    # Example

=head1 DESCRIPTION

=head1 METHODS

=head2 MT::Asset::Image->class

Returns 'image', the identifier for this particular class of asset.

=head2 MT::Asset::Image->class_label

Returns the localized descriptive name for this type of asset.

=head2 MT::Asset::Image->extensions

Returns an arrayref of file extensions that are supported by this
package.

=head2 $asset->metadata

Returns a hashref of metadata values for this asset.

=head2 $asset->thumbnail_file(%param)

Creates or retrieves the file path to a thumbnail image appropriate for
the asset. If a thumbnail cannot be created, this routine will return
undef.

=head2 $asset->as_html

Return the HTML I<IMG> element with the image asset attributes.

=head2 $asset->normalize_orientation

Normalize orientation if an image has a "Orientation" in Exif information.

=head2 $asset->scale($width, $height)

Resize an image to $width x $height size. Do nothing if $width or $height is
zero or undefined.
If you want to keep the ratio, you need to calculate yourself.
This method does not have ratio option.

=head2 $asset->crop_rectangle($left, $top, $width, $height)

Crop an image by arguments. Do nothing if $width or $height is zero or undefined.
$left and $top are set zero when they are undefined.

=head2 $asset->rotate($angle)

Rotate an image by $angle. Do nothing if $angle is zero or undefined.

=head2 $asset->flip_horizontal

Flip an image horizontally.

=head2 $asset->flip_vertical

Flip an image vertically.

=head2 $asset->transform(@actions)

Transform an image.

=head2 $asset->exif()

Return Image::ExifTool instance. Metadata is read from file each time exif method is called.

=head2 $asset->has_gps_metadata()

Return 1 when the image has GPS metadata.

=head2 $asset->has_metadata()

Return 1 when the image has metadata.

=head2 $asset->remove_gps_metadata()

Remove all GPS metadata from the image. Do nothing when $asset's metadata is broken.

=head2 $asset->remove_all_metadata()

Remove all metadata from the image. Do nothing when $asset's metadata is broken.

=head2 $asset->change_quality([$quality])

Change the quality of the file of $asset only when $asset is JPEG or PNG.
When $quality is not set, config directive "ImageQualityJpeg" or "ImageQualityPng" is used.

=head2 $asset->is_metadata_broken()

Return 1 when $asset's metadata seems to be broken.

=head1 AUTHOR & COPYRIGHT

Please see the L<MT/"AUTHOR & COPYRIGHT"> for author, copyright, and
license information.

=cut
