<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('class.exception.php');

class Thumbnail {

    private $src_file;
    private $src_w;
    private $src_h;
    private $src_type;
    private $src_img;
    private $src_attr;

    private $dest_img;
    private $dest_w;
    private $dest_h;
    private $dest_scale;
    private $dest_square;
    private $dest_id;
    private $dest_format;
    private $dest_type;
    private $dest_file;

    # construct
    public function __construct ($src = null) {
        if (!$this->is_available())
            throw new MTExtensionNotFoundException('GD');

        $this->src_file    = null;
        $this->src_w       = 0;
        $this->src_h       = 0;
        $this->src_type    = null;
        $this->src_img     = null;
        $this->src_attr    = null;
        $this->dest_w      = 0;
        $this->dest_h      = 0;
        $this->dest_scale  = 0;
        $this->dest_square = false;
        $this->dest_id     = null;
        $this->dest_format = '%f-thumb-%wx%h-%i%x';
        $this->dest_type   = 'auto';
        $this->dest_img    = null;
        $this->dest_file   = '';

        if (!is_null($src))
            $this->src_file = $src;
    }

    # destruct
    public function __destruct () {
        if (is_resource($this->src_img))
            @imagedestroy($this->src_img);
        if (is_resource($this->dest_img))
            @imagedestroy($this->dest_img);
    }

    # property accessor
    public function src_file($src = null) {
        if (!is_null($src))
            $this->src_file = $src;

        $src_file = $this->src_file;
        if (strtoupper(substr(PHP_OS, 0,3) == 'WIN') && extension_loaded('mbstring')) {
            // Changes character-set of filename to SJIS on Windows.
            $src_file = mb_convert_encoding($src_file, "SJIS", "auto");
        }
        return $src_file;
    }

    public function dest_file($dest = null) {
        if (!is_null($dest))
            $this->dest_file = $dest;

        $dest_file = $this->dest_file;
        if (strtoupper(substr(PHP_OS, 0,3) == 'WIN') && extension_loaded('mbstring')) {
            // Changes character-set of filename to SJIS on Windows.
            $src_file = mb_convert_encoding($dest_file, "SJIS", "auto");
        }
        return $dest_file;
    }

    public function width($w = null) {
        if (!is_null($w))
            $this->dest_w = $w;
        return $this->dest_w;
    }

    public function height($h = null) {
        if (!is_null($h))
            $this->dest_h = $h;
        return $this->dest_h;
    }

    public function scale($scale = null) {
        if (!is_null($scale))
            $this->dest_scale = $scale;
        return $this->dest_scale;
    }

    public function square($square = null) {
        if (!is_null($square))
            $this->dest_square = $square;
        return $this->dest_square;
    }

    public function id($id = null) {
        if (!is_null($id))
            $this->dest_id = $id;
        return $this->dest_id;
    }

    public function format($fmt = null) {
        if (!is_null($fmt))
            $this->dest_format = $fmt;
        return $this->dest_format;
    }

    public function type($type = null) {
        if (!is_null($type))
            $this->dest_type = $type;
        return $this->dest_type;
    }

    public function dest() {
        $dest_file = $this->dest_file();
        if ( strtoupper(substr(PHP_OS, 0,3) == 'WIN') && extension_loaded('mbstring') ) {
            // Changes character-set of filename to 'UTF-8' on Windows.
            $dest_file = mb_convert_encoding($dest_file, mb_internal_encoding(), "auto");
        }
        return $dest_file;
    }

    private function load_image () {
        $src_file = $this->src_file();
        if (empty($src_file)) return false;
        if (!file_exists($src_file)) return false;

        # Get source image information
        list($this->src_w, $this->src_h, $this->src_type, $this->src_attr) = getimagesize($src_file);

        switch($this->src_type) {
        case 1: #GIF
            $this->src_img = @imagecreatefromgif($src_file);
            break;
        case 2: #JPEG
            $this->src_img = @imagecreatefromjpeg($src_file);
            break;
        case 3: #PNG
            $this->src_img = @imagecreatefrompng($src_file);
            break;
        default: #Unsupported format
            throw new MTUnsupportedImageTypeException($src_file);
        }
        if (empty($this->src_img)) return false;

        return true;
    }

    # Can we use function of GD?
    public function is_available () {
        return extension_loaded('gd');
    }

    # Calculate image size
    # This function returns array object.
    #   [0] thumbnail width
    #   [1] thumbnail height
    #   [2] thumbnail width for file name
    #   [3] thumbnail width for file name
    private function _calculate_size () {
        # Calculate thumbnail size
        $thumb_w = $this->src_w;
        $thumb_h = $this->src_h;
        $thumb_w_name = $this->src_w;
        $thumb_h_name = $this->src_h;

        if ($this->dest_scale > 0) {
            $thumb_w = intval($this->src_w * $this->dest_scale / 100);
            $thumb_h = intval($this->src_h * $this->dest_scale / 100);
            $thumb_w_name = $thumb_w;
            $thumb_h_name = $thumb_h;
        } elseif ($this->dest_square) {
            if ($this->dest_w > 0) {
                $thumb_w = $this->dest_w;
                $thumb_h = $this->dest_w;
                $thumb_w_name = $this->dest_w;
                $thumb_h_name = $this->dest_w;
            } elseif($this->dest_h > 0) {
                $thumb_w = $this->dest_h;
                $thumb_h = $this->dest_h;
                $thumb_w_name = $this->dest_h;
                $thumb_h_name = $this->dest_h;
            } else {
                // dest_w and dest_h is unset;
                if($this->src_w > $this->src_h){
                    $thumb_w = $this->src_h;
                    $thumb_h = $this->src_h;
                    $thumb_w_name = $this->src_h;
                    $thumb_h_name = $this->src_h;
                } else {
                    $thumb_w = $this->src_w;
                    $thumb_h = $this->src_w;
                    $thumb_w_name = $this->src_w;
                    $thumb_h_name = $this->src_w;
                }
            }
        } elseif ($this->dest_w > 0 || $this->dest_h > 0) {
            $thumb_w_name = 'auto';
            $thumb_h_name = 'auto';
            $x = $this->dest_w;
            $y = $this->dest_h;
            $pct = $this->dest_w > 0 ? ($x / $thumb_w) : ($y / $thumb_h);
            $thumb_w = (int)($thumb_w * $pct);
            $thumb_h = (int)($thumb_h * $pct);
            if ($this->dest_w > 0 && $thumb_w == $this->dest_w ) $thumb_w_name = $this->dest_w;
            if ($this->dest_h > 0 && $thumb_h == $this->dest_h ) $thumb_h_name = $this->dest_h;
        }

        return array($thumb_w, $thumb_h, $thumb_w_name, $thumb_h_name);
    }

    private function _make_dest_name ($w, $h) {
        if ($this->dest_type == 'auto') {
            $output = $this->src_type;
        } elseif (strtolower($this->dest_type) == 'gif') {
            $output = 1;
        } elseif (strtolower($this->dest_type) == 'jpeg') {
            $output = 2;
        } elseif (strtolower($this->dest_type) == 'png') {
            $output = 3;
        } else {
            $output = $this->src_type;
        }
        switch($output) {
        case 1:
            $ext = '.gif';
            break;
        case 2:
            $ext = '.jpg';
            break;
        case 3:
            $ext = '.png';
            break;
        default:
            $ext = image_type_to_extension($output);
        }

        $pathinfo = pathinfo($this->src_file());
        $basename = basename($pathinfo['basename'], '.'.$pathinfo['extension']);

        $patterns[0] = '/%w/';
        $patterns[1] = '/%h/';
        $patterns[2] = '/%f/';
        $patterns[3] = '/%i/';
        $patterns[4] = '/%x/';
        $replacement[0] = $w;
        $replacement[1] = $h;
        $replacement[2] = $basename;
        $replacement[3] = $this->dest_id;
        $replacement[4] = $ext;

        return preg_replace($patterns, $replacement, $this->dest_format);
    }

    # Load or generate a thumbnail.
    public function get_thumbnail ($args = null) {
        # Parse args
        if (!empty($args)) {
            if (!empty($args['dest']))
                $this->dest_file = $args['dest'];
            if (!empty($args['width']))
                $this->dest_w = $args['width'];
            if (!empty($args['height']))
                $this->dest_h = $args['height'];
            if (!empty($args['id']))
                $this->dest_id = $args['id'];
            if (!empty($args['scale']))
                $this->dest_scale = $args['scale'];
            if (!empty($args['format']))
                $this->dest_format = $args['format'];
            if (!empty($args['dest_type']))
                $this->dest_type = $args['dest_type'];
            if (!empty($args['square']))
                $this->dest_square = $args['square'];
        }

        # Load source image
        if (!$this->load_image()) return false;

        # Calculate thumbnail size
        list ($thumb_w, $thumb_h, $thumb_w_name, $thumb_h_name) = $this->_calculate_size();
        $this->dest_w = $thumb_w;
        $this->dest_h = $thumb_h;

        # Decide a destination file name
        if (empty($this->dest_file)) {
            $this->dest_file($this->_make_dest_name($thumb_w_name, $thumb_h_name));
        }

        # Generate
        $dest_file = $this->dest_file();
        if (file_exists($dest_file)) {
            if ($this->src_w == $this->src_h) {
                $compulsive_resize = 0;
            }
            else {
                list ($tmp_w, $tmp_h) = getimagesize($dest_file);
                $ds = $this->dest_square;
                $compulsive_resize =
                    (($ds && $tmp_w != $tmp_h) || (!$ds && $tmp_w == $tmp_h))
                    ? 1 : 0 ;
            }
        }
        else {
            $compulsive_resize = 1;
        }
        if ($compulsive_resize) {
            $dir_name = dirname($dest_file);
            if (!file_exists($dir_name))
                mkpath($dir_name, 0777);
            if (!is_writable($dir_name)) {
                return false;
            }

            # if square modifier is enable, crop & resize
            $src_x = 0;
            $src_y = 0;
            $target_w = $this->src_w;
            $target_h = $this->src_h;
            if ($this->dest_square) {
                if ($this->src_w > $this->src_h) {
                    $src_x = (int)($this->src_w - $this->src_h) / 2;
                    $src_y = 0;
                    $target_w = $this->src_h;
                } else {
                    $src_x = 0;
                    $src_y = (int)($this->src_h - $this->src_w) / 2;
                    $target_h = $this->src_w;
                }
            }

            # Create dest image
            $this->dest_img = imagecreatetruecolor ( $thumb_w, $thumb_h );

            # Check transparent color support
            # Code from https://github.com/maxim/smart_resize_image/blob/master/smart_resize_image.function.php
            if ( ( $this->src_type == 1) || ( $this->src_type == 3 ) ) {
                $trnprt_indx = imagecolortransparent( $this->src_img );

                // If we have a specific transparent color
                if ($trnprt_indx >= 0) {

                    // Get the original image's transparent color's RGB values
                    $trnprt_color = imagecolorsforindex( $this->src_img, $trnprt_indx );

                    // Allocate the same color in the new image resource
                    $trnprt_indx = imagecolorallocate( $this->dest_img, $trnprt_color['red'], $trnprt_color['green'], $trnprt_color['blue']);

                    // Completely fill the background of the new image with allocated color.
                    imagefill( $this->dest_img, 0, 0, $trnprt_indx );

                    // Set the background color for new image to transparent
                    imagecolortransparent( $this->dest_img, $trnprt_indx );
                } elseif ( $this->src_type == 3 ) {
                    // Always make a transparent background color for PNGs that don't have one allocated already

                    // Turn off transparency blending (temporarily)
                    imagealphablending( $this->dest_img, false );

                    // Create a new transparent color for image
                    $color = imagecolorallocatealpha( $this->dest_img, 0, 0, 0, 127 );

                    // Completely fill the background of the new image with allocated color.
                    imagefill( $this->dest_img, 0, 0, $color );

                    // Restore transparency blending
                    imagesavealpha( $this->dest_img, true );
                }
            }

            # Create thumbnail
            $result = imagecopyresampled ( $this->dest_img, $this->src_img, 0, 0, $src_x, $src_y,
                    $thumb_w, $thumb_h, $target_w, $target_h);

            $output = $this->src_type;
            if ($this->dest_type != 'auto') {
                if ( strtolower($this->dest_type) == 'gif' )
                    $output = 1;
                elseif ( strtolower($this->dest_type) == 'jpeg' )
                    $output = 2;
                elseif ( strtolower($this->dest_type) == 'png' )
                    $output = 3;
                else
                    $output = $this->src_type;
            }
            switch($output) {
            case 1: #GIF
                imagegif($this->dest_img, $dest_file);
                break;
            case 2: #JPEG
                imagejpeg($this->dest_img, $dest_file);
                break;
            case 3: #PNG
                imagepng($this->dest_img, $dest_file);
                break;
            }
            @imagedestroy($this->dest_img);
        }
        @imagedestroy($this->src_img);

        return true;
    }
}
?>
