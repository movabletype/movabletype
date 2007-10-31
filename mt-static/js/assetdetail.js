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
        hide('asset-' + asset_id + '-detail');
        detailRowClass.className = origRowClass;
        notOpened(asset_id);
        toggleScrollBar('right');
    }
}

function toggleAssetDetails(id) {
    var radio_val = false;
    var button_val = true;
    if (asset_id == id) {
        hide('asset-' + asset_id + '-detail');
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
    detailRowClass.className = 'selected';
    var detail = getByID("asset-" + id + "-detail");
    if (isModal) {
        var detail_inner = getByID("asset-" + id + "-detail-inner-modal");
    } else {
        var detail_inner = getByID("asset-" + id + "-detail-inner");
    }
    var asset = assets[id];
    if (!asset) {
        var detail_json = getByID("asset-" + id + "-json");
        if (!detail_json) return false;
        asset = eval('(' + detail_json.value + ')');
        if (!asset) return false;
        assets[id] = asset;
    }

    var close = trans('Close');
    var close_link = "<a href=\"javascript:void(0)\" onclick=\"toggleAssetDetails('" + id + "'); notOpened('" + id + "');\">" + close + "</a>";
    var close_icon = "<a href=\"javascript:void(0)\" onclick=\"toggleAssetDetails('" + id + "'); notOpened('" + id + "');\"><img class=\"close_asset_icon\" align=\"bottom\" src=\"" + StaticURI + "images/spacer.gif\" width=\"9\" height=\"9\"></a>";
    var preview;
    if (asset.thumbnail_url) {
        preview = "<img src=\"" + asset.thumbnail_url + "\" class=\"preview\" /><br />";
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
        var clickToSee = trans('Click to see uploaded file.');
        preview = "<div class=\"asset-icon-area\"><div class=\"asset-icon-layout\"><div class=\"asset-icon-" + asset.ext + "\"><img src=\"" + StaticURI + "images/spacer.gif\" width=\"90\" height=\"96\"></div></div></div><b>" + noPreview + "</b><br /><a href=\"" + asset.url + "\" target=\"view_uploaded\">" + clickToSee + "</a>";
    }
    var metadata = '';
    var meta_names = [];
    var meta_name;
    for (meta_name in asset) {
        if (meta_name.match(/^[a-z_]/)) continue;
        if (!asset[meta_name]) continue;
        meta_names[meta_names.length] = meta_name;
    }
    meta_names.sort();
    var i;
    for (i = 0; i < meta_names.length; i++) {
        meta_name = meta_names[i];
        metadata += '<dt>' + meta_name + ":</dt> <dd>" + asset[meta_name] + "</dd>";
    }
    iam = asset.name;
    var metadataClass = 'metadata';
    if (isModal) {
        metadataClass = 'metadata_dialog';
    }
    detail_inner.innerHTML = "<div class=\"close_asset_detail\">" + close_link + " " + close_icon + "</div>"
        + "<div class=\"asset-detail-title\">" + iam + "</div>"
        + "<div class=\"asset_detail_left\">" + preview + "</div>"
        + "<div class=\"asset_detail_right\">"
        + "<div class=\"" + metadataClass + "\"><dl>" + metadata + "</dl></div>"
        + "</div>";
    show("asset-" + id + "-detail");
    return false;
}

