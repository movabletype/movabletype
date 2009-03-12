/*
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
*/

/* for showing, hiding, and displaying asset details */

/* assign to an element when using a modal dialog, ie:
    isModal = getByID("list-assets-dialog")
*/
var isModal;

function toggleScrollBar(which) {
    var el = getByID("selector");
    if (which == 'left') {
        TC.addClassName(el, "condensed");
    } else {
        TC.removeClassName(el, "condensed");
    }
}

var opened = false;
var asset_id = '';
var detailRowClass = '';
var orgiRowClass = '';
function hasOpened(id) {
    opened = true;
    asset_id = id;
    detailRowClass = getByID("asset-" + asset_id);
    origRowClass = detailRowClass.className;
}

function notOpened(id) {
    opened = false;
    asset_id = '';
    detailRowClass = '';
    origRowClass = '';
}

function checkOpened() {
    if (opened) {
        hide('asset-' + asset_id + '-preview');
        detailRowClass.className = origRowClass;
        notOpened(asset_id);
        toggleScrollBar('right');
    }
}

function toggleAssetDetails(id) {
    var radio_val = false;
    var button_val = true;
    if (asset_id == id) {
        hide('asset-' + asset_id + '-preview');
        detailRowClass.className = origRowClass;
        notOpened(asset_id);
        if (isModal) {
            toggleScrollBar('right');
        }
    } else {
        displayAssetDetails(id);
        if (isModal) {
            toggleScrollBar('left');
        }
        radio_val = true;
        button_val = false;
    }        
    var radio = getByID("asset-radio-"+id);
    if (radio) {
        radio.checked = radio_val;
    }
    

    if (window.dlg) {
        var panel = window.dlg.panel;
        var button = panel.closeButton;
        if (button_val)
            TC.addClassName(button, "disabled-button");
        else
            TC.removeClassName(button, "disabled-button");
        button.disabled = button_val;
    }
}

var assets = {};
var guardian = 0;
var timer;
var thumb;

function displayAssetDetails(id) {
    /* display popup panel showing details of selected asset */
    checkOpened();
    hasOpened(id);
    var asset = assets[id];
    if (!asset) {
        var detail_json = getByID("asset-" + id + "-json");
        if (!detail_json) return false;
        asset = eval('(' + detail_json.value + ')');
        if (!asset) return false;
        assets[id] = asset;
    }

    if (asset.thumbnail_url) {
        guardian = 0;
        thumb = new Image;
        thumb.src = asset.thumbnail_url;

        clearInterval(timer);
        timer = setInterval("waitForLoad("+id+")", 500);
    } else {
        showPage(id);
    }
}

function waitForLoad(id) {
    guardian++;
    if (thumb.complete || (guardian > 5)) {
        clearInterval(timer);
        showPage(id);
    }
}

function showPage(id) {

    /* display popup panel showing details of selected asset */
    DOM.addClassName( detailRowClass, 'selected' );
    var detail = getByID("asset-" + id + "-preview");
    var detail_inner = getByID("asset-" + id + "-preview-inner");
    var asset = assets[id];
    if (!asset) {
        var detail_json = getByID("asset-" + id + "-json");
        if (!detail_json) return false;
        asset = eval('(' + detail_json.value + ')');
        if (!asset) return false;
        assets[id] = asset;
    }

    var close = trans('Close');
    var close_link = "<a href=\"javascript:void(0)\" onclick=\"toggleAssetDetails('" + id + "'); notOpened('" + id + "');\" class=\"close-preview-link\"><span>" + close + "</span>&nbsp;</a>";
    var preview;
    if (asset.preview_url) {
        preview = "<img src=\"" + asset.preview_url + "\" class=\"preview\" />";
    } else {
        ext = asset.ext;
        var icons = ("doc,eps,fla,gif,jpg,mp3,mpg,pdf,png,ppt,psd,txt,xls,zip");
        var icon_array = icons.split(",");
        for (var loop=0; loop < icon_array.length; loop++) {
            if (ext == icon_array[loop]){
                asset.ext = ext;
                break;
            } else {
                asset.ext = "default";
            }
        }
        var noPreview = trans('No Preview Available');
        var clickToSee = trans('View uploaded file');
        preview = ""
        + "<div class=\"asset-icon asset-icon-" + asset.ext + "\">"
        + "<strong>" + noPreview + "</strong>"
        + "<a href=\"" + asset.url + "\" target=\"view_uploaded\">" + clickToSee + "</a>"
        + "</div>";
    }
    var metadata;
    if (asset['image_dimensions']) {
        metadata = "<div class=\"asset-preview-meta\">" + asset['image_dimensions']
            + ( asset['file_size'] ? " - " + asset['file_size'] : "") + "</div>";
    } else if (asset['file_size']) {
        metadata = asset['file_size'];
    } else {
        metadata = ""
    };
    var label;
    if (asset['Name']) {
        label = asset['Name'];
    } else {
        label = asset['name'];
    };
    detail_inner.innerHTML = close_link
        + "<div class=\"asset-preview-image\">" + preview + "</div>"
        + "<div class=\"asset-preview-title\">" + label + "</div>"
        + metadata;
    show("asset-" + id + "-preview");
    return false;
}

