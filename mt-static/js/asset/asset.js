riot.tag2('asset-preview', '<div if="{Object.keys(targetAsset).length}"> <div class="row"> <div class="col"> <img if="{targetAsset.type == \'image\'}" riot-src="{targetAsset.url}" class="image img-fluid preview-image"> <virtual if="{targetAsset.type != \'image\'}"> <a href="{targetAsset.url}" target="_blank" class="preview-file"> <img if="{targetAsset.type != \'image\'}" riot-src="{StaticURI}images/images/file-{targetAsset.type == ⁗file⁗ ? \'default\' : targetAsset.type==⁗video⁗ ? \'movie\' : targetAsset.type}.svg" width="60" height="60"> <ss title="{trans(\'View\')}" class="mt-icon" href="{StaticURI}images/sprite.svg#ic_permalink"></ss> </a> </virtual> </div> <div class="col"> <div class="asset_name text-break">{targetAsset.label}</div> <div class="asset_size text-break" if="{targetAsset.type == ⁗image⁗}">{targetAsset.width} x {targetAsset.height}</div> </div> </div> <form class="form pt-5" if="{targetAsset.type == ⁗image⁗}"> <div class="form-group mb-3"> <div data-is="alt-input"></div> </div> <div class="form-group mb-3"> <div data-is="caption-input"></div> </div> <div class="form-group mb-3"> <div data-is="width-input"></div> </div> <div class="form-group mb-3"> <div data-is="link-input"></div> </div> <div class="form-group mb-3"> <div data-is="align-input"></div> </div> </form> </div>', 'asset-preview .preview-image,[data-is="asset-preview"] .preview-image{ height: 80px; } asset-preview .active,[data-is="asset-preview"] .active{ background : #E3F2F4; } asset-preview .preview-file,[data-is="asset-preview"] .preview-file{ position: relative; display: block; padding: 1em; background-color: #E3F2F4; } asset-preview .preview-file .mt-icon,[data-is="asset-preview"] .preview-file .mt-icon{ position: absolute; top: 0; right: 0; z-index: 1; }', '', function(opts) {
    this.observer = this.parent.opts.observer
    this.targetAsset = this.parent.targetAsset

    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length){
        this.parent.assets.reverse().map((asset) => {
          if(asset.selected)
            this.parent.targetAsset.insert_options = {
              alt: asset.label,
              caption: '',
              align: 'none'
            }
        })
      }
      this.targetAsset = this.parent.targetAsset
      this.parent.update()
    })

    this.changeInsertOption = function(name, value){
        this.parent.assets.map((asset) => {
          if(asset.id == this.targetAsset.id){
            asset.insert_options[name] = value
          }
        })
        this.parent.update()
    }.bind(this)

});

riot.tag2('alt-input', '<label class="form-control-label" for="alt"> {trans(\'Alt\')} </label> <input type="text" name="alt" id="alt" class="form-control" onkeyup="{changeText}" riot-value="{value}">', '', '', function(opts) {
    this.value = this.parent.targetAsset.insert_options.alt
    this.observer = this.parent.observer
    this.changeText = function(e){
      this.parent.changeInsertOption("alt", e.target.value)
      this.value = e.target.value
    }.bind(this)
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return
      this.value = this.parent.targetAsset.insert_options.alt
      this.update()
    })
});

riot.tag2('caption-input', '<label class="form-control-label" for="caption"> {trans(\'Caption\')} </label> <input type="text" name="caption" id="caption" class="form-control" onkeyup="{changeText}" riot-value="{value}">', '', '', function(opts) {
    this.value = this.parent.targetAsset.insert_options.caption
    this.observer = this.parent.observer
    this.changeText = function(e){
      this.value = e.target.value
      this.parent.changeInsertOption("caption", e.target.value)
    }.bind(this)
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return
      this.value = this.parent.targetAsset.insert_options.caption
      this.update()
    })
});
riot.tag2('width-input', '<label class="form-control-label" for="width"> {trans(\'Width\')} </label> <input type="text" name="width" id="width" class="form-control" onkeyup="{changeText}" riot-value="{value}">', '', '', function(opts) {
    this.value = this.parent.targetAsset.insert_options.width
    this.observer = this.parent.observer
    this.changeText = function(e){
      this.value = e.target.value
      this.parent.changeInsertOption("width", e.target.value)
    }.bind(this)
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return
      this.value = this.parent.targetAsset.insert_options.width
      this.update()
    })
});
riot.tag2('link-input', '<div class="custom-control custom-checkbox"> <input type="checkbox" name="popup" id="link_to_popup" class="custom-control-input" onchange="{changeChack}" checked="{value}"> <label class="custom-control-label" for="link_to_popup">{trans(\'Link to original image\')}</label> </div>', '', '', function(opts) {
    this.value = this.parent.targetAsset.insert_options.link
    this.observer = this.parent.observer
    this.changeChack = function(e){
      this.value = e.target.checked ? true : false
      this.parent.changeInsertOption("link", e.target.checked ? true : false)
    }.bind(this)
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return
      this.value = this.parent.targetAsset.insert_options.link
      this.update()
    })
});
riot.tag2('align-input', '<div class="form-group alignbutton"> <button type="button" class="btn btn-default p-1 alignleft {checked == \'left\' ? \'active\' : \'\'}" data-align="left" title="{trans(\'Align Left\')}" data-toggle="button" aria-pressed="false" onclick="{changeAlign}"> <ss title="{trans(\'Align Left\')}" class="mt-icon" href="{StaticURI}images/sprite.svg#ic_alignleft"></ss> </button> <button type="button" class="btn btn-default p-1 aligncenter {checked == \'center\' ? \'active\' : \'\'}" data-align="center" title="{trans(\'Align Center\')}" data-toggle="button" aria-pressed="false" onclick="{changeAlign}"> <ss title="{trans(\'Align Left\')}" class="mt-icon" href="{StaticURI}images/sprite.svg#ic_aligncenter"></ss> </button> <button type="button" class="btn btn-default p-1 alignright {checked == \'right\' ? \'active\' : \'\'}" data-align="right" title="{trans(\'Align Right\')}" data-toggle="button" aria-pressed="false" onclick="{changeAlign}"> <ss title="{trans(\'Align Left\')}" class="mt-icon" href="{StaticURI}images/sprite.svg#ic_alignright"></ss> </button> <button type="button" class="btn btn-default p-1 alignnone {checked == \'none\' ? \'active\' : \'\'}" data-align="none" title="{trans(\'None\')}" data-toggle="button" aria-pressed="false" onclick="{changeAlign}"> <ss title="{trans(\'Align Left\')}" class="mt-icon" href="{StaticURI}images/sprite.svg#ic_alignnone"></ss> </button> </div>', 'align-input .active,[data-is="align-input"] .active{ border-color: #5FBCEB; box-shadow: 0 0 0 2px #5FBCEB; }', '', function(opts) {
    this.checked = this.parent.targetAsset.insert_options.align ? this.parent.targetAsset.insert_options.align : "none"
    this.observer = this.parent.observer
    this.changeAlign = function(e){
      e.stopImmediatePropagation()
      this.checked = e.target.dataset["align"]
      this.parent.changeInsertOption("align", e.target.dataset["align"])
      this.update()
    }.bind(this)
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return
      this.checked = this.parent.targetAsset.insert_options.align ? this.parent.targetAsset.insert_options.align : "none"
      this.update()
    })
});
riot.tag2('asset-upload-option', '<div id="uploadSettings"> <fieldset class="form-group"> <legend class="h3">{trans(\'Upload Destination\')}</legend> <div if="{parent.opts.filter != \'userpic\'}"> <div class="row" if="{parent.opts.allow_to_change_at_upload}"> <div class="col row" if="{parent.opts.destination_loop}"> <div class="col"> <select name="destination" id="destination" class="custom-select form-control w-100" onchange="{changeDestinationSelect}" aria-describedby="uploadDestination"> <option each="{destination in parent.opts.destination_loop}" riot-value="{destination.path}" selected="{destination.selected}"> {destination.label} </option> </select> </div> <input type="text" id="upload_destination_custom" class="form-control text path required valid-custom-path upload-destination w-100 col-12" disabled="disabled" name="destination" riot-value="{parent.upload_options.destination}" style="display: none;" aria-describedby="uploadDestination" onchange="{changeDestinationText}"> <div class="col"> <div class="upload-extra-path row"> <div class="col-auto h5 mt-auto mb-auto">/</div> <div class="col w-100 ml-0 pl-0"><input type="text" name="extra_path" id="extra_path" class="form-control text path w-100 ml-0" riot-value="{parent.upload_options.extra_path}" onkeyup="{changeExtraPath}"></div> </div> </div> </div> </div> <div class="row"> <small id="uploadDestination" class="form-text text-muted">{trans(\'_USAGE_UPLOAD\')}</small> </div> <div if="{!parent.opts.allow_to_change_at_upload}"> <div id="site_path-field" class="field field-top-label"> <div class="field-content"> {parent.opts.upload_destination_label}/{parent.opts.extra_path} </div> </div> </div> </div> </fieldset> <fieldset class="form-group"> <legend class="h3">{trans(\'Upload Options\')}</legend> <div class="form-group"> <div class="custom-control custom-checkbox"> <input type="checkbox" name="auto_rename_non_ascii" id="auto_rename_non_ascii" value="1" checked="{parent.upload_options.auto_rename_non_ascii}" class="cb custom-control-input" onchange="{changeAutoRenameNonAscii}"> <label class="custom-control-label" for="auto_rename_non_ascii">{trans(\'Rename non-ascii filename automatically\')}</label> </div> </div> <select name="operation_if_exists" id="operation_if_exists" class="custom-select form-control text-truncate" onchange="{changeOperationIfExists}"> <option value="1" selected="{parent.upload_options.operation_if_exists == 1}"> {trans(\'Upload and rename\')} </option> <option value="2" selected="{parent.upload_options.operation_if_exists == 2}"> {trans(\'Overwrite existing file\')} </option> <option value="3" selected="{parent.upload_options.operation_if_exists == 3}"> {trans(\'Cancel upload\')} </option> </select> <div class="form-group"> <div class="custom-control custom-checkbox"> <input type="checkbox" name="normalize_orientation" id="normalize_orientation" value="1" checked="{parent.upload_options.normalize_orientation}" class="cb custom-control-input" onchange="{changeNormalizeOrientation}"> <label class="custom-control-label" for="normalize_orientation">{trans(\'Enable orientation normalization\')}</label> </div> </div> </fieldset> </div>', '', '', function(opts) {
  console.log(this.parent.opts.filter)
  this.changeDestinationText = function(e){
      this.parent.upload_options.destination = e.target.value
  }.bind(this)
  this.changeDestinationSelect = function(e) {
    if(e.target.value.indexOf("%") == -1){
      jQuery('#upload_destination_custom').show().removeAttr('disabled')
      this.parent.upload_options.destination = jQuery('#upload_destination_custom').val()
    } else {
      jQuery('#upload_destination_custom').hide().attr('disabled', 'disabled')
      this.parent.upload_options.destination = e.target.value
    }
  }.bind(this)

  this.changeExtraPath = function(e) {
    this.parent.upload_options.extra_path = e.target.value
  }.bind(this)

  this.changeAutoRenameNonAscii = function(e) {
    this.parent.upload_options.auto_rename_non_ascii = e.target.value
  }.bind(this)
  this.changeOperationIfExists = function(e) {
    this.parent.upload_options.operation_if_exists = e.target.value
  }.bind(this)
  this.changeNormalizeOrientation = function(e) {
    this.parent.upload_options.normalize_orientation = e.target.value
  }.bind(this)
});
riot.tag2('asset', '<div class="{⁗img-preview⁗ + (selected ? \' selected\' : \'\')}" onclick="{selectAsset}"> <img if="{type == \'image\'}" riot-src="{url}" class="image img-fluid"> <img if="{type != \'image\'}" riot-src="{StaticURI}images/file-{type == ⁗file⁗ ? \'default\' : type==⁗video⁗ ? \'movie\' : type}.svg" class="image img-fluid"> <div class="img-overlay" if="{selected}"> <input type="checkbox" id="asset-{id}" class="asset-checked" name="asset-img-id" riot-value="{id}" checked="{selected}" onclick="{unselectAsset}"> </div> <div class="upload_cancel" if="{is_upload}" onclick="{uploadCancel}"> <ss title="{trans(\'Cancel\')}" class="mt-icon" href="{StaticURI}images/sprite.svg#ic_caution"></ss> </div> <div class="img-progress" if="{is_upload}"> <progress riot-value="{upload_progress_rate}" max="100"></progress><span class="upload_rate">({upload_progress_rate}%)</span> </div> </div>', 'asset .img-preview,[data-is="asset"] .img-preview{ position: relative; box-shadow: inset 0 0 15px rgb(0 0 0 / 10%), inset 0 0 0 1px rgb(0 0 0 / 5%); background: #f0f0f1; cursor: pointer; border: 3px solid transparent; } asset .img-preview:before,[data-is="asset"] .img-preview:before{ content: ""; display: block; padding-top: 100%; } asset .img-preview.selected,[data-is="asset"] .img-preview.selected{ border: 3px solid #007bff; border-color: #007bff; border-width: 3px; } asset .img-preview .image,[data-is="asset"] .img-preview .image{ background-color: #FFFFFF; max-height: 100%; position: absolute; top: 50%; left: 50%; transform: translate(-50%,-50%); } asset .img-overlay,[data-is="asset"] .img-overlay{ position: absolute; top: 0; left: 0; padding:0; background-color: #ddd; width: 25px; height: 25px; text-align: center; box-sizing: border-box; } asset .upload_cancel,[data-is="asset"] .upload_cancel{ position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); } asset .img-progress,[data-is="asset"] .img-progress{ position: absolute; bottom: 0; width: 100%; text-align: center; box-sizing: border-box; } asset .img-progress progress,[data-is="asset"] .img-progress progress{ width: 98%; } asset .upload_rate,[data-is="asset"] .upload_rate{ color: #007bff; }', '', function(opts) {
    this.selectAsset = function(e) {
      this.parent.assets.map((asset) => {
        if(asset.id == this.id){
          asset.selected = true
          this.selected = true
        } else {
          this.parent.opts.can_multi ? '' : asset.selected = false
        }
      })
      this.parent.targetAsset = this
      this.parent.observer.trigger('changeTargetAsset')
      this.parent.update()
    }.bind(this)
    this.unselectAsset = function(e) {
        this.parent.assets.map((asset) => {
          if(asset.id == this.id){
            asset.selected = false
            this.selected = false
          }
        })
      this.parent.targetAsset = {}
      this.parent.observer.trigger('changeTargetAsset')
      e.stopPropagation()
    }.bind(this)
    this.uploadCancel = function(e) {
      this.abortUpload()
      e.stopPropagation()
    }.bind(this)
});
riot.tag2('assets', '<p class="alert alert-danger icon-left icon-error" if="{error}"> <ss href="{StaticURI}images/sprite.svg#ic_caution" class="mt-icon mt-icon--sm mt-icon--danger" title="{trans(⁗Failed to load⁗)}"></ss> {error} </p> <div class="{show_option ? \'d-none\' : \'d-block\'}"> <div class="row flex-nowrap"> <div class="col form-group row"> <div class="col-auto"><label for="asset_type">{trans(\'Type\')}</label></div> <div class="col"> <select id="asset_type" name="asset_type" class="custom-select form-control asset_type"> <option disabled="{opts.filter_val != ⁗⁗}">{trans(\'All Types\')}</option> <option each="{opts.types}" riot-value="{type}" selected="{opts.filter == \'class\' && opts.filter_val == type}" disabled="{opts.filter_val != ⁗⁗ && opts.filter_val != type}">{label}</option> </select> </div> </div> <div class="col form-group"> <input type="text" id="asset_name" name="asset_name" class="form-control" value=""> </div> <div class="col-auto form-group"> <button type="button" class="btn btn-primary" onclick="{changeFilter}">{trans(\'Search\')}</button> </div> <div class="col form-group row" if="{opts.can_upload}"> <div class="col-auto form-group"> <input type="file" id="file" name="file" style="display: none;" multiple="{opts.can_multi ? \'multiple\' : \'\'}" onchange="{selectFiled}"> <a href="javascript:void(0)" id="open-file-dialog" class="btn btn-primary" onclick="{openFileDialog}"> {trans(\'Upload\')} </a> </div> <div class="col-auto form-group"> <a onclick="{changeShowOption}" class="btn upload_setting"> <ss title="{trans(\'Upload Settings\')}" class="mt-icon" href="{StaticURI}images/sprite.svg#ic_setting"></ss> </a> </div> </div> </div> <div class="row justify-content-center"> <div class="{opts.user_id || opts.content_field_id || opts.edit_field.startsWith(\'customfield_\') ? \'col-12 row\' : \'col-8 row\'}"> <div class="mt-asset col-3" each="{filterdAssets}" data-is="asset"></div> <p if="{!filterdAssets.length}">{trans( ⁗No [_1] could be found.⁗, (opts.user_id ? trans( ⁗Userpic⁗) : trans( ⁗Assets⁗)) )}</p> </div> <div class="col-4 overflow-hidden" if="{!opts.user_id && !opts.content_field_id && !opts.edit_field.startsWith(\'customfield_\')}"> <div class="row justify-content-center"> <div class="col asset-preview" data-is="asset-preview"></div> </div> </div> </div> <div class="row justify-content-center mt-5"> <nav aria-label="Page Navigation" if="{pages > 1}"> <ul class="pagination"> <li class="page-item"><a class="page-link mt-pager-prev">{trans(\'Previous\')}</a></li> <virtual if="{pageIndex - 2 > 0}"> <li class="page-item first-last"> <a class="page-link mt-pager-index" href="#">1</a> </li> <li class="page-item" aria-hidden="true">...</li> </virtual> <li each="{page in pageNumbers}" class="{page == pageIndex ? ⁗active page-item⁗ : ⁗page-item⁗}"> <a class="page-link mt-pager-index" href="#">{page+1}<span class="sr-only" if="{page == pageIndex}">{page}</span></a> </li> <virtual if="{pageIndex + 2 < pages}"> <li class="page-item" aria-hidden="true">...</li> <li class="page-item first-last"> <a class="page-link mt-pager-index" href="#">{pages}</a> </li> </virtual> <li class="page-item"><a class="page-link mt-pager-next">{trans(\'Next\')}</a></li> </ul> </nav> </div> </div> <div class="{show_option ? \'asse-upload-options d-block\' : \'d-none\'}"> <div class="asset-upload-option" data-is="asset-upload-option"></div> </div> <div class="upload-overlay-container"> <div class="upload-overlay-background"> <div class="upload-overlay-drop"> <div class="upload-overlay-message"> <img riot-src="{StaticURI}images/upload/nowuploading@2x.png" width="60" height="50"> <p if="{opts.can_upload}">{trans(⁗Drag and drop here⁗)}</p> <p if="{!opts.can_upload}">{trans(⁗You are not allowed to Upload File.⁗)}</p> </div> </div> </div> </div> <form id="asset-detail-form" action="{ScriptURI}" method="post"> <input type="hidden" name="__mode" value="insert_asset"> <input type="hidden" name="blog_id" riot-value="{opts.blog_id}"> <input type="hidden" name="edit_field" riot-value="{opts.edit_field}"> <input type="hidden" name="content_field_id" riot-value="{opts.content_field_id}" if="{opts.content_field_id}"> <input type="hidden" name="no_insert" value="1" if="{opts.no_insert}"> <input type="hidden" name="magic_token" riot-value="{opts.magic_token}"> <input type="hidden" name="prefs_json" value=""> </form> <form id="select_asset_asset_userpic" action="{ScriptURI}" method="post"> <input type="hidden" name="__mode" value="asset_userpic"> <input type="hidden" name="magic_token" riot-value="{opts.magic_token}"> <input type="hidden" name="type" value="asset"> <input type="hidden" name="dialog_view" value="1"> <input type="hidden" name="no_insert" value="0"> <input type="hidden" name="dialog" value="1"> <input type="hidden" name="id" value=""> <input type="hidden" name="edit_field" value="userpic_asset_id"> <input type="hidden" name="user_id" riot-value="{opts.user_id}"> </form>', 'assets .mt-asset,[data-is="assets"] .mt-asset{ padding: 0; } assets .upload_setting,[data-is="assets"] .upload_setting{ display: block; cursor: pointer; } assets .upload-overlay-container,[data-is="assets"] .upload-overlay-container{ display: none; position: absolute; width: 100vw; height: 100vh; top: 0; left: 0; } assets .upload-overlay-background,[data-is="assets"] .upload-overlay-background{ background-color: #BAE3FF; opacity: 0.6; height: 100%; } assets .upload-overlay-drop,[data-is="assets"] .upload-overlay-drop{ position: fiexed; top: 0; height: 100%; } assets .upload-overlay-border,[data-is="assets"] .upload-overlay-border{ top: 0; border: 3px solid #0A93F3; } assets .upload-overlay-message,[data-is="assets"] .upload-overlay-message{ text-align: center; vertical-align: middle; font-size: 18px; color: #0D76BF; }', '', function(opts) {
    this.assets = opts.assets
    this.limit = opts.limit
    this.isEmpty = this.assets.length > 0 ? false : true
    this.pageIndex = opts.index
    if(opts.filter && opts.filter == 'class'){
        filterAssets = this.assets.filter(function(asset){
          if(asset.type == opts.filter_val) return true
          return false
        })
        this.pages = filterAssets.length > 0 ?  parseInt(filterAssets.length / this.limit) : 0
        this.filterdAssets = filterAssets.slice(this.limit * this.pageIndex, this.limit * (this.pageIndex + 1))
    } else {
      this.pages = this.assets.length > 0 ?  parseInt(this.assets.length / this.limit) : 0
      this.filterdAssets = this.assets.slice(this.pageIndex, this.pageIndex + this.limit)
    }
    this.observer = opts.observer
    this.show_option = false
    this.targetAsset = {}
    this.queue = [];
    this.upload_options = {
      destination: opts.destination,
      extra_path: opts.extra_path,
      dir_separator: opts.dir_separator,
      auto_rename_non_ascii: opts.auto_rename_non_ascii,
      operation_if_exists: opts.operation_if_exists,
      normalize_orientation: opts.normalize_orientation,
    }
    this.pageNumbers = []
    this.error = ""
    this.current_filter_type = "";
    this.current_filter_name = "";

    this.observer.on('onNextPage', () => {
      if((this.pageIndex+1) == this.pages) return
      this.pageIndex++
      this.changeFilter()
      this.observer.trigger('changePager');
      this.update()
    })
    this.observer.on('onPrevPage', () => {
      if(this.pageIndex == 0) return
      this.pageIndex--
      this.changeFilter()
      this.observer.trigger('changePager');
      this.update()
    })

    this.observer.on('onPageIndex', (pageIndex) => {
      this.pageIndex = (parseInt(pageIndex) -1)
      this.changeFilter()
      this.observer.trigger('changePager');
      this.update()
    })
    this.observer.on('onInsertAsset', () => {
      if(!opts.user_id && !opts.content_field_id && !opts.edit_field.match(/^customfield_.*$/)){
        return this.insertAsset()
      }
      selected_asset = this.assets.filter((asset) => {
        return asset.selected
      })

      if(opts.user_id){
        var $form = jQuery('#select_asset_asset_userpic')
        $form.find("[name=id]").val(selected_asset[0].id)
        $form.trigger('submit')
      } else {
        options = []
        errors = 0
        selected_asset.map((asset) => {
          opts = {}
          opts.id = asset.id
          if(asset.type == 'image'){
            Object.keys(asset.insert_options).map( (key) => {
              opts[key] = asset.insert_options[key]
            })
          }
          options.push(opts)
        })
        var json = JSON.stringify(options);
        var $form = jQuery('#asset-detail-form');
        $form.find('[name="prefs_json"]').val(json);
        $form.trigger('submit');
      }
    })
    this.observer.on('changePager', () => {
      if(this.pages > 7){
        var max = this.pages
        var min = 0
        if( (this.pageIndex - 2) > 0 ){
          min = this.pageIndex - 1
        }
        if( (this.pageIndex + 2) < this.pages ){
          max = this.pageIndex + 2
        }
        this.pageNumbers = [...Array(this.pages).keys()].slice( min, max )
      } else {
        this.pageNumbers = [...Array(this.pages).keys()]
      }
    })
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.targetAsset).length){
        jQuery('.panel-buttons .insert-assets').attr('disabled', 'disabled')
        jQuery('.panel-buttons .insert-assets').addClass('disabled')
      } else {
        jQuery('.panel-buttons .insert-assets').removeAttr('disabled')
        jQuery('.panel-buttons .insert-assets').removeClass('disabled')
      }
    })
    this.loadAssets = function() {
      jQuery.ajax({
        type: "GET",
        url: ScriptURI,
        dataType: "json",
        cache: false,
        data: {
          __mode: 'list_asset',
          _type: 'asset',
          blog_id: opts.blog_id,
          dialog_view: 1,
          json: 1,
          filter: opts.filter,
          filter_val: opts.filter_val,
          offset: this.assets.length,
        }
      }).then((data) => {
        this.assets = this.assets.concat(data)
        this.changeFilter()
        this.update()
      }).catch((error) => {
        console.log(error)
      })
    }.bind(this)
    this.insertAsset = function() {
      selected_asset = this.assets.filter((asset) => {
        return asset.selected
      })
      html = ''
      selected_asset.map((asset) => {
        elm = ''
        if(asset.type == 'image'){
          wrap_style =  'style=""'
          if(asset.insert_options.align == 'left') {
            wrap_style = 'style="float: left; margin: 0 20px 20px 0;"'
          } else if(asset.insert_options.align == 'right') {
            wrap_style = 'style="float: right; margin: 0 0 20px 20px;"'
          } else if(asset.insert_options.align == 'center') {
            wrap_style = 'style="text-align: center; display: block; margin: 0 auto 20px;"'
          }
          elm = `<img src=${asset.url} alt="${asset.insert_options.alt}" ${ asset.insert_options.width ? 'width="' + asset.insert_options.width + '"' : ''} class="mt-image-${ asset.insert_options.align}" ${wrap_style}>`
          if(asset.insert_options.caption != ""){
            elm = `<figure>${elm}<figcaption>${asset.insert_options.caption}</figcaption></figure>`
          }
          if(asset.insert_options.link){
            elm = `<div><a href="${asset.url}">${elm}</a></div>`
          }
        } else {
          elm = `<a href="${asset.url}">${asset.label}</a>`
        }
        html += elm
      })
      window.parent.app.insertHTML( html, opts.edit_field )
      jQuery('.mt-close-dialog').trigger('click')
    }.bind(this)
    this.changeFilter = function(e) {
      this.assets.map(asset => {
        asset.selected = false
      })
      const filter_type = document.getElementById("asset_type").value
      if(!filter_type) {
        filterAssets = this.assets
      } else {
        filterAssets = this.assets.filter(function(asset){
          if(asset.type == filter_type) return true
          return false
        })
      }
      const filter_name = document.getElementById("asset_name").value
      if(filter_name){
        filterAssets = filterAssets.filter(function(asset){
          if(
            asset.label.indexOf(filter_name) > -1 || asset.file_name.indexOf(filter_name) > -1
          ) return true
          return false
        })
      }

      if(this.current_filter_type != filter_type || this.current_filter_name != filter_name || (e && e.type == "click") ){
        this.pageIndex = 0
        this.current_filter_type = filter_type
        this.current_filter_name = filter_name
      }
      this.pages = filterAssets.length > 0 ? filterAssets.length % 12 == 0 ? (filterAssets.length / 12) : Math.floor(filterAssets.length / 12) + 1 : 0
      this.filterdAssets = filterAssets.slice(this.limit * this.pageIndex, this.limit * (this.pageIndex + 1))
      this.observer.trigger('changePager')
      this.targetAsset = {}
      this.observer.trigger('changeTargetAsset');
      this.update()
    }.bind(this)
    this.openFileDialog = function(e) {
      document.getElementById('file').click();
    }.bind(this)

    this.changeShowOption = function(e) {
      this.show_option = true
      jQuery('.asset-options-buttons').removeClass('d-none')
      jQuery('.panel-buttons').addClass('d-none')
      jQuery('.asset-options-buttons .action').on('click', () => {
        jQuery('.asset-options-buttons').addClass('d-none')
        jQuery('.panel-buttons').removeClass('d-none')
        this.show_option = false
        this.update()
      });
    }.bind(this)
    this.createFormData = function(file) {
      var fd = new FormData();

      fd.append('file', file);

      fd.append('__mode', 'js_upload_file')
      if(opts.upload_mode){
        fd.append('type', 'userpic')
      }
      fd.append('blog_id', opts.blog_id);
      fd.append('edit_field', opts.edit_field);
      fd.append('require_type', opts.require_type);
      fd.append('magic_token', opts.magic_token);
      fd.append('no_insert', 1);
      if(opts.user_id){
        fd.append('user_id', opts.user_id);
      }
      fd.append('dialog', 1);
      Object.keys(this.upload_options).map( (key) => {
        fd.append(key, this.upload_options[key])
      })

      return fd;
    }.bind(this)

    this.uploadFiles = function(files) {
      if ( !opts.can_upload ) return
      if (!files || files.length === 0 ) {
          return
      }

      var num_files = files.length
      var max_upload_size = this.max_upload_size

      Array.prototype.map.call(files, (file) => {
        if( file.size === 0 ) {

          return
        }

        var fd = this.createFormData( file )
        if ( file.size >= max_upload_size ) {
          this.error = trans("The file you tried to upload is too large: [_1]", file.name)
          console.error(this.error)
          return
        }
        if ( opts.require_type && opts.require_type !== 'file' ) {
          var regexp = new RegExp('^' + opts.require_type + '/.*')
          if(!file.type.match(regexp)) {
            this.error = trans("[_1] is not a valid [_2] file.", file.name, opts.require_type_label)
            console.error(this.error)
            return
          }
        }

        this.assets.unshift({
          id: `temp_${ Math.floor( Math.random() * 9999 ) }`,
          blog_id: opts.blog_id,
          label: file.name,
          url: URL.createObjectURL(file),
          description: "",
          file_name: file.name,
          type: file.type.replace(/(.*)\/.*/, '$1'),
          insert_options: {},
          is_upload: true,
          upload_progress_rate: 0,
          cancel: false,
        })
        this.pageIndex = 0
        this.filterdAssets = this.assets.slice(this.limit * this.pageIndex, this.limit * (this.pageIndex + 1))
        this.observer.trigger('changePager')
        var f = this.uploadFile(fd, this.filterdAssets[0])
        this.queue.push(f)
      })
      this.update()
    }.bind(this)
    this.uploadFile = function(formData, targetAsset){
      var d = new jQuery.Deferred();
      var xhr = jQuery.ajax({
        xhr: () => {
          var handler = jQuery.ajaxSettings.xhr();
          if (handler.upload) {
            handler.upload.addEventListener('progress', (event) => {
              var percent = 0;
              var position = event.loaded || event.position;
              var total = event.total;
              if (event.lengthComputable) {
                percent = Math.ceil(position / total * 100);
              }
              targetAsset.upload_progress_rate = percent
            }, false);
          }
          return handler;
        },
        url: ScriptURI,
        type: "POST",
        contentType:false,
        processData: false,
        cache: false,
        data: formData
      }).done( (data) => {
        if ( !data || data.error || !data.result ) {

          var error = (data && data.error) ? data.error : trans('Unknown error occurred.');
          targetAsset.error = error
        }
        else if ( data.result.cancel ) {

          targetAsset.cancel = data.result.cancel
        }
        else if ( !data.result.asset ) {

          var error = trans('Unknown error occurred.');
          targetAsset.error = error
        }
        else {

          targetAsset.upload_progress_rate = 100
          targetAsset.is_upload = false
          targetAsset.id = data.result.asset.id
          targetAsset.blog_id = data.result.asset.blog_id
          targetAsset.label = data.result.asset.label

          targetAsset.file_name = data.result.asset.filename
          targetAsset.type = data.result.asset.thumbnail_type
        }
        this.update()
      }).always(function() {
        d.resolve()
      })
      targetAsset.abortUpload = () => {
        targetAsset.is_upload = false
        xhr.abort()
        this.assets = this.assets.filter( ( asset ) => {
          if(asset.id == targetAsset.id){
            return false
          }
          return true
        })
        this.pageIndex = 0
        this.filterdAssets = this.assets.slice(this.limit * this.pageIndex, this.limit * (this.pageIndex + 1))
        this.observer.trigger('changePager')
        this.update()
      }
      return d.promise();
    }.bind(this)
    this.selectFiled = function (e) {
      this.uploadFiles(e.target.files)
    }.bind(this)
    jQuery(() => {
      window.parent.jQuery('.mt-modal .modal-content').css('padding-bottom', '800px')
      jQuery('.modal-body').css({'position': 'relative'})
      function resize_upload_overlay() {
        jQuery('.upload-overlay-container').width(jQuery(window).width())
        jQuery('.upload-overlay-container').height(jQuery(window).height())
      }
      jQuery(window)
        .on('dragover', (e) => {

          resize_upload_overlay();
          e.preventDefault()
          jQuery('.upload-overlay-container').show()
      })
      jQuery('.upload-overlay-drop')
        .on('dragleave', (e) => {
          jQuery('.upload-overlay-container').hide();
        })
        .on('drop', (e) => {
          e.preventDefault();
          e.stopPropagation();
          jQuery('.upload-overlay-container').hide()

          this.uploadFiles(e.originalEvent.dataTransfer.files)
        })
    })
    this.observer.trigger('changePager');
    if(this.assets.length != opts.assets_count){
      this.loadAssets()
    }

});