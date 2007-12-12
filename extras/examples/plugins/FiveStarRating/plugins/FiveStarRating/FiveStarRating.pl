# Movable Type (r) Open Source (C) 2005-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# FiveStarRating plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package MT::Plugin::FiveStarRating;

use strict;
use MT;
use MT::Plugin;
use base qw(MT::Plugin);

my $plugin = new MT::Plugin::FiveStarRating({
    name => "Five Star Rating sample",
    version => '0.1',
    description => "<MT_TRANS phrase=\"Allow readers to rate entries, assets, comments and trackbacks.\">",
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    #l10n_class => 'FiveStarRating::L10N',
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        'tags' => {
            'function' => {
                'FiveStarRatingThunk' => \&_hdlr_rating_thunk,
            },
        },
    });
}

sub _hdlr_rating_thunk {
    my($ctx, $args) = @_;
    my $blog = $ctx->stash('blog')
        or return $ctx->error($plugin->translate(
           "You used an [_1] tag outside of the proper context.",
           '<$MTFiveStarRatingThunk$>' ));
    my $type;
    my $obj;
    if ( exists $args->{'for'} ) {
        $obj = $ctx->stash($args->{'for'});
    }
    if ($obj) {
        $type = $args->{'for'};
    }
    else {
        foreach ( qw( entry asset comment ping ) ) {
            $type = $_;
            $obj = $ctx->stash($_);
            last if $obj;
        }
    }
    return $ctx->error($plugin->translate(
        "You used an [_1] tag outside of the proper context.",
        '<$MTFiveStarRatingThunk$>' ))
            unless $obj;
    
    my $scorer_url = MT->config->CGIPath . 'plugins/FiveStarRating/rate.cgi';
    my $image_url = MT->config->StaticWebPath . 'plugins/FiveStarRating';
    my $id = $obj->id;
    my $rating = $obj->score_avg('FiveStarRating');

    my ($src1, $src2, $src3, $src4, $src5);
    if ($rating < 1) {
        $src1 = $src2 = $src3 = $src4 = $src5 = 'bullet'; 
    } elsif ($rating < 2) {
        $src1 = 'star';
        $src2 = $src3 = $src4 = $src5 = 'bullet'; 
    } elsif ($rating < 3) {
        $src1 = $src2 = 'star';
        $src3 = $src4 = $src5 = 'bullet'; 
    } elsif ($rating < 4) {
        $src1 = $src2 = $src3 = 'star';
        $src4 = $src5 = 'bullet'; 
    } elsif ($rating < 5) {
        $src1 = $src2 = $src3 = $src4 = 'star';
        $src5 = 'bullet'; 
    } else {
        $src1 = $src2 = $src3 = $src4 = $src5 = 'star'; 
    }

    my $html = <<HTML;
<form method="POST" action="$scorer_url">
<img id="$type-$id-rc-0" onmouseover="rcOver('$type', '$id', 0)" onmouseout="rcOut('$type', '$id')" onclick="rcClick('$type', '$id', 0)" src="$image_url/no_rating.gif" />
<img id="$type-$id-rc-1" onmouseover="rcOver('$type', '$id', 1)" onmouseout="rcOut('$type', '$id')" onclick="rcClick('$type', '$id', 1)" src="$image_url/$src1.gif" />
<img id="$type-$id-rc-2" onmouseover="rcOver('$type', '$id', 2)" onmouseout="rcOut('$type', '$id')" onclick="rcClick('$type', '$id', 2)" src="$image_url/$src2.gif" />
<img id="$type-$id-rc-3" onmouseover="rcOver('$type', '$id', 3)" onmouseout="rcOut('$type', '$id')" onclick="rcClick('$type', '$id', 3)" src="$image_url/$src3.gif" />
<img id="$type-$id-rc-4" onmouseover="rcOver('$type', '$id', 4)" onmouseout="rcOut('$type', '$id')" onclick="rcClick('$type', '$id', 4)" src="$image_url/$src4.gif" />
<img id="$type-$id-rc-5" onmouseover="rcOver('$type', '$id', 5)" onmouseout="rcOut('$type', '$id')" onclick="rcClick('$type', '$id', 5)" src="$image_url/$src5.gif" />
<input type="hidden" id="$type-$id-rating" name="rating" value="$rating" />
</form>
HTML

    unless ($ctx->stash('rating_script_generated')) {
        my $script = <<SCRIPT;
<script type="text/javascript"> 
<!-- 
function rcUpdate(type, id, rating, hover) 
{ 
    var i, image, image_file; 
    for( i = 0; i <= 5; i++ ) 
    { 
        image = document.getElementById(type + '-' + id + '-rc-' + i); 
        if( !image ) 
            return false; 
        if( i > 0 ) 
            if( i <= rating ) 
                image_file = 'star'; 
            else 
                image_file = 'bullet'; 
        else 
            image_file = 'no_rating'; 
        if( hover ) 
            if( ( image_file == 'star' ) || ( ( image_file == 'no_rating' ) && ( rating == 0 ) ) ) 
                image_file = image_file + '-hover'; 
        if( image_file != '' ) 
            image.src = '$image_url/' + image_file + '.gif'; 
    } 
    return true; 
} 
 
function rcOver(type, id, rating) 
{ 
    return rcUpdate(type, id, rating, 1); 
} 
 
function rcOut(type, id) 
{ 
    var obj = document.getElementById(type + '-' + id + '-rating'); 
    if( !obj ) 
        return false; 
    var rating = obj.value; 
    return rcUpdate(type, id, rating, 0); 
} 
 
function getXmlHttp()
{
    var xmlhttp = false;
    if (window.XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        try {
            xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
        }
    }
    return xmlhttp;
}

function rcClick(type, id, rating) 
{ 
    var xmlhttp = getXmlHttp();
    if (!xmlhttp) {
        return false;
    }
    xmlhttp.open("POST", "$scorer_url", false);
    xmlhttp.send("type=" + type + "&id=" + id + "&score=" + rating);
    if (xmlhttp.readyState != 4) {
        return false;
    }
    var obj = document.getElementById(type + '-' + id + '-rating'); 
    if( !obj ) 
        return false; 
    obj.value = xmlhttp.responseText; 
    return rcUpdate(type, id, obj.value, 0); 
} 
//-->
</script>
SCRIPT
        $html = "$script\n$html";
        $ctx->stash('rating_script_generated', 1);
    }
    return $html;
}

1;
__END__

=head1 NAME

FiveStarRating -- Example plugin to use MT4's rating API.

=head1 SYNOPSIS

    <MTEntries>
      <$MTFiveStarRatingThunk$>: <$MTEntryTitle$>
      <MTComments>
        <$MTFiveStarRatingThunk for="comment"$>
        <MTCommentBody>
      </MTComments>
    </MTEntries>

