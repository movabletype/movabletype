<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

class Thumbnail {

    var $src_file;
    var $src_w;
    var $src_h;
    var $src_type;

    # construct
    function Thumbnail ($src) {
        $this->src_file = $src;
    }

    # Can we use function of GD?
    function is_available () {
        return extension_loaded('gd');
    }

    # Calculate image size
    # This function returns array object.
    #   [0] thumbnail width
    #   [1] thumbnail height
    #   [2] thumbnail width for file name
    #   [3] thumbnail width for file name
    function _calculate_size ($width, $height, $scale) {
        # Calculate thumbnail size
        $thumb_w = $this->src_w;
        $thumb_h = $this->src_h;
        $thumb_w_name = $this->src_w;
        $thumb_h_name = $this->src_h;

        if ($scale > 0) {
            $thumb_w = $this->src_w * $scale / 100;
            $thumb_h = $this->src_h * $scale / 100;
            $thumb_w_name = $thumb_w;
            $thumb_h_name = $thumb_h;
        } elseif ($width > 0 || $height > 0) {
            $thumb_w_name = 'auto';
            $thumb_h_name = 'auto';
            $x = $width; if ($width > 0) $thumb_w;
            $y = $height; if ($height > 0) $thumb_h;
            $pct = $width > 0 ? ($x / $thumb_w) : ($y / $thumb_h);
            $thumb_w = (int)($thumb_w * $pct);
            $thumb_h = (int)($thumb_h * $pct);
            if ($width > 0) $thumb_w_name = $width;
            if ($height > 0) $thumb_h_name = $height;
        }

        return array($thumb_w, $thumb_h, $thumb_w_name, $thumb_h_name);
    }

    function _make_dest_name ($w, $h, $format, $dest_type) {
        $output = $this->src_type;
        if ($dest_type != 'auto') {
            $output = strtolower($dest_type) == 'gif' ? 1
              : strtolower($dest_type) == 'jpeg' ? 2
              : strtolower($dest_type) == 'png' ? 3
              : $src_type;
        }
        switch($output) {
        case 1: #GIF
            $ext = '.gif';
            break;
        case 2: #JPEG
            $ext = '.jpg';
            break;
        case 3: #PNG
            $ext = '.png';
            break;
        }

        $pathinfo = pathinfo($this->src_file);
        $basename = basename($pathinfo['basename'], '.'.$pathinfo['extension']);

        $patterns[0] = '/%w/';
        $patterns[1] = '/%h/';
        $patterns[2] = '/%f/';
        $patterns[3] = '/%x/';
        $replacement[0] = $w;
        $replacement[1] = $h;
        $replacement[2] = $basename;
        $replacement[3] = $ext;

        return preg_replace($patterns, $replacement, $format);
    }

    # Load or generate a thumbnail.
    function get_thumbnail (&$dest, &$width, &$height, $scale = 0, $format = '%f-thumb-%wx%h%x', $dest_type = 'auto') {
        if (empty($this->src_file)) return false;
        if (!file_exists($this->src_file)) return false;
        if (!$this->is_available()) {
            global $mt;
            $mt->warning_log($mt->translate('GD support has not been available. Please install GD support.'));
            return false;
        }

        # Get source image information
        list($this->src_w, $this->src_h, $this->src_type, $src_attr) = getimagesize($this->src_file);

        # Load source image
        $src_img;
        switch($this->src_type) {
        case 1: #GIF
            $src_img = @imagecreatefromgif($this->src_file);
            break;
        case 2: #JPEG
            $src_img = @imagecreatefromjpeg($this->src_file);
            break;
        case 3: #PNG
            $src_img = @imagecreatefrompng($this->src_file);
            break;
        default: #Unsupported format
            return false;
        }
        if (empty($src_img)) {
            return false;
        }

        # Calculate thumbnail size
        list ($thumb_w, $thumb_h, $thumb_w_name, $thumb_h_name) = $this->_calculate_size($width, $height, $scale);
        $width = $thumb_w;
        $height = $thumb_h;

        # Decide a destination file name
        if (empty($dest)) {
            $dest = $this->_make_dest_name($thumb_w_name, $thumb_h_name, $format, $dest_type);
        }

        # Generate
        if(!file_exists($dest)) {
            $dir_name = dirname($dest);
            if (!file_exists($dir_name))
                mkpath($dir_name, 0777);
            if (!is_writable($dir_name)) {
                imagedestroy($src_img);
                return false;
            }

            # Create thumbnail
            $dst_img = imagecreatetruecolor ( $thumb_w, $thumb_h );
            $result = imagecopyresampled ( $dst_img, $src_img, 0, 0, 0, 0,
                    $thumb_w, $thumb_h, $this->src_w, $this->src_h);

            $output = $this->src_type;
            if ($dest_type != 'auto') {
                $output = strtolower($dest_type) == 'gif' ? 1
                  : strtolower($dest_type) == 'jpeg' ? 2
                  : strtolower($dest_type) == 'png' ? 3
                  : $src_type;
            }
            switch($output) {
            case 1: #GIF
                imagegif($dst_img, $dest);
                break;
            case 2: #JPEG
                imagejpeg($dst_img, $dest);
                break;
            case 3: #PNG
                imagepng($dst_img, $dest);
                break;
            }
            imagedestroy($dst_img);
        }
        imagedestroy($src_img);

        return true;
    }
}
?>
