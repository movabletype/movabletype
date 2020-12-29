/*
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
            TC.addClassName(button, "disabled");
        else
            TC.removeClassName(button, "disabled");
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
    var asset = assets[id];
    if (!asset) {
        var detail_json = getByID("asset-" + id + "-json");
        if (!detail_json) return false;
        asset = eval('(' + detail_json.value + ')');
        if (!asset) return false;
        assets[id] = asset;
    }

    var preview;
    if (asset.preview_url) {
        preview = "<div class=\"asset-preview-image picture small\"><img src=\"" + asset.preview_url + "\" class=\"preview\" /></div>";
    } else {
        var noPreview = trans('No Preview Available.');
        preview = ""
        + "<div class=\"msg msg-error\">"
        + "<p class=\"msg-text\">" + noPreview + "</p>"
        + "</div>";
    }
    var labelDims = trans('Dimensions');
    var metadata;
    if (asset['image_dimensions']) {
        metadata = "<li class=\"asset-preview-meta\"><strong>" + labelDims + "</strong>: "
            + asset['image_dimensions']
            + "</li>";
    } else {
        metadata = ""
    };
    var labelFileName = trans('File Name');
    detail.innerHTML = preview
        + "<ul class=\"list-unstyled\">"
        + "<li class=\"asset-preview-title\"><strong>" + labelFileName + "</strong>: " + asset['file_name'] + "</li>"
        + metadata
        + "<ul>";
    show("asset-" + id + "-preview");
    return false;
}
