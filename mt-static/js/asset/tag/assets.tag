<assets>
  <p class="alert alert-danger icon-left icon-error" if={ error }>
    <ss href="{ StaticURI }images/sprite.svg#ic_caution" class="mt-icon mt-icon--sm mt-icon--danger" title={ trans("Failed to load") }></ss>
    {error}
  </p>
  <div class={ showOption ? 'd-none' : 'd-block' }>
    <div class="row flex-nowrap">
      <div class="col form-group row">
        <div class="col-auto"><label for="asset_type">{ trans('Type') }</label></div>
        <div class="col">
          <select id="asset_type" name="asset_type" class="custom-select form-control asset_type">
            <option disabled={ opts.filter_val != ""} value="">{ trans('All Types') }</option>
            <option each={ opts.types } value={ type } selected={ opts.filter == 'class' && opts.filter_val == type }  disabled={ opts.filter_val != "" && opts.filter_val != type }>{ label }</option>
          </select>
        </div>
      </div>
      <div class="col form-group">
        <input type="text" id="asset_name" name="asset_name" class="form-control" value="">
      </div>
      <div class="col-auto form-group">
        <button type="button" class="btn btn-primary" onclick={ changeFilter }>{ trans('Search') }</button>
      </div>
      <div class="col form-group row" if={ opts.can_upload }>
        <div class="col-auto form-group" >
          <input type="file" id="file" name="file" style="display: none;" multiple={ opts.can_multi ? 'multiple' : '' } onchange={ selectFiled }>
          <a href="javascript:void(0)" id="open-file-dialog" class="btn btn-primary" onclick={ openFileDialog }>
            { trans('Upload') }
          </a>
        </div>
        <div class="col-auto form-group">
          <a onclick={ changeShowOption } class="btn upload_setting">
            <ss title="{ trans('Upload Settings') }" class="mt-icon" href="{ StaticURI }images/sprite.svg#ic_setting"></ss>
          </a>
        </div>
      </div>
    </div>
    <div class="row justify-content-center">
      <div class={opts.user_id || opts.content_field_id || opts.edit_field.startsWith('customfield_') ? 'col-12 row' : 'col-8 row'}>
        <div class="mt-asset col-3" each={ filterdAssets } data-is="asset"></div>
        <p if={ !filterdAssets.length }>{ trans( "No [_1] could be found.", (opts.user_id ? trans( "Userpic") : trans( "Assets")) ) }</p>
      </div>
      <div class="col-4 overflow-hidden" if={!opts.user_id && !opts.content_field_id && !opts.edit_field.startsWith('customfield_')}>
        <div class="row justify-content-center">
          <div class="col asset-preview" data-is="asset-preview"></div>
        </div>
      </div>
    </div>
    <div class="row justify-content-center mt-5">
      <nav aria-label="Page Navigation" if={ pages > 1 }>
        <ul class="pagination">
          <li class="page-item"><a class="page-link mt-pager-prev">{ trans('Previous') }</a></li>
          <virtual if={ pageIndex - 2 > 0 }>
            <li
              class="page-item first-last">
                <a class="page-link mt-pager-index" href="#">1</a>
            </li>
            <li class="page-item" aria-hidden="true">...</li>
          </virtual>
          <li
            each={ page in pageNumbers }
            class={ page == pageIndex ? "active page-item" : "page-item" }
          >
            <a class="page-link mt-pager-index" href="#">{ page+1 }<span class="sr-only" if={ page == pageIndex }>{ page }</span></a>
          </li>
          <virtual if={ pageIndex + 2 < pages }>
            <li class="page-item" aria-hidden="true">...</li>
            <li
              class="page-item first-last">
                <a class="page-link mt-pager-index" href="#">{ pages }</a>
            </li>
          </virtual>
          <li class="page-item"><a class="page-link mt-pager-next">{ trans('Next') }</a></li>
        </ul>
      </nav>
    </div>
  </div>
  <div class={ showOption ? 'asse-upload-options d-block' : 'd-none' }>
    <div class="asset-upload-option" data-is="asset-upload-option"></div>
  </div>

  <div class="upload-overlay-container">
    <div class="upload-overlay-background">
      <div class="upload-overlay-drop">
        <div class="upload-overlay-message">
          <img src="{ StaticURI }images/upload/nowuploading@2x.png" width="60" height="50">
          <p if={opts.can_upload}>{ trans("Drag and drop here") }</p>
          <p if={!opts.can_upload}>{ trans("You are not allowed to Upload File.") }</p>
        </div>
      </div>
    </div>
  </div>

  <form id="asset-detail-form" action={ ScriptURI } method="post">
    <input type="hidden" name="__mode" value="insert_asset">
    <input type="hidden" name="blog_id" value={opts.blog_id}>
    <input type="hidden" name="edit_field" value={opts.edit_field}>
    <input type="hidden" name="content_field_id" value={opts.content_field_id} if={opts.content_field_id}>
    <input type="hidden" name="no_insert" value="1" if={opts.no_insert}>
    <input type="hidden" name="magic_token" value={opts.magic_token}>
    <input type="hidden" name="prefs_json" value="">
  </form>
  <form id="select_asset_asset_userpic" action={ ScriptURI } method="post">
    <input type="hidden" name="__mode" value="asset_userpic">
    <input type="hidden" name="magic_token" value={opts.magic_token}>
    <input type="hidden" name="type" value="asset">
    <input type="hidden" name="dialog_view" value="1">
    <input type="hidden" name="no_insert" value="0">
    <input type="hidden" name="dialog" value="1">
    <input type="hidden" name="id" value="">
    <input type="hidden" name="edit_field" value="userpic_asset_id">
    <input type="hidden" name="user_id" value={opts.user_id}>
  </form>

  <script>
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
    this.showOption = false
    this.targetAsset = {}
    this.queue = [];
    this.uploadOoptions = {
      destination: opts.destination,
      extra_path: opts.extra_path,
      dir_separator: opts.dir_separator,
      auto_rename_non_ascii: opts.auto_rename_non_ascii,
      operation_if_exists: opts.operation_if_exists,
      normalize_orientation: opts.normalize_orientation,
    }
    this.pageNumbers = []
    this.error = ""
    this.currentFilterType = "";
    this.currentFilterName = "";

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
    loadAssets() {
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
    }
    insertAsset() {
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
    }
    changeFilter(e) {
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
      // filter change or search click
      if(this.currentFilterType != filter_type || this.currentFilterName != filter_name || (e && e.type == "click") ){
        this.pageIndex = 0
        this.currentFilterType = filter_type
        this.currentFilterName = filter_name
      }
      this.pages = filterAssets.length > 0 ? filterAssets.length % 12 == 0 ? (filterAssets.length / 12) : Math.floor(filterAssets.length / 12) + 1 : 0
      this.filterdAssets = filterAssets.slice(this.limit * this.pageIndex, this.limit * (this.pageIndex + 1))
      this.observer.trigger('changePager')
      this.targetAsset = {}
      this.observer.trigger('changeTargetAsset');
      this.update()
    }
    openFileDialog(e) {
      document.getElementById('file').click();
    }

    changeShowOption(e) {
      this.showOption = true
      jQuery('.asset-options-buttons').removeClass('d-none')
      jQuery('.panel-buttons').addClass('d-none')
      jQuery('.asset-options-buttons .action').on('click', () => {
        jQuery('.asset-options-buttons').addClass('d-none')
        jQuery('.panel-buttons').removeClass('d-none')
        this.showOption = false
        this.update()
      });
    }
    createFormData(file) {
      var fd = new FormData();

      // Set file object
      fd.append('file', file);

      // Set extended parameters
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
      Object.keys(this.uploadOoptions).map( (key) => {
        fd.append(key, this.uploadOoptions[key])
      })

      return fd;
    }

    uploadFiles(files) {
      if ( !opts.can_upload ) return
      if (!files || files.length === 0 ) {
          return
      }

      var num_files = files.length
      var max_upload_size = this.max_upload_size

      Array.prototype.map.call(files, (file) => {
        if( file.size === 0 ) {
          // Maybe directory
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
    }
    uploadFile(formData, targetAsset){
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
          // An eror occurs
          var error = (data && data.error) ? data.error : trans('Unknown error occurred.');
          targetAsset.error = error
        }
        else if ( data.result.cancel ) {
          // Cancelled by server
          targetAsset.cancel = data.result.cancel
        }
        else if ( !data.result.asset ) {
          // An eror occurs
          var error = trans('Unknown error occurred.');
          targetAsset.error = error
        }
        else {
          // Success
          targetAsset.upload_progress_rate = 100
          targetAsset.is_upload = false
          targetAsset.id = data.result.asset.id
          targetAsset.blog_id = data.result.asset.blog_id
          targetAsset.label = data.result.asset.label
          //targetAsset.url = data.result.asset.thumbnail
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
    }
    selectFiled (e) {
      this.uploadFiles(e.target.files)
    }
    jQuery(() => {
      window.parent.jQuery('.mt-modal .modal-content').css('padding-bottom', '800px')
      jQuery('.modal-body').css({'position': 'relative'})
      function resize_upload_overlay() {
        jQuery('.upload-overlay-container').width(jQuery(window).width())
        jQuery('.upload-overlay-container').height(jQuery(window).height())
      }
      jQuery(window)
        .on('dragover', (e) => {  // Show upload overlay.
          // Refresh upload overlay size.
          resize_upload_overlay();
          e.preventDefault()
          jQuery('.upload-overlay-container').show()
      })
      jQuery('.upload-overlay-drop')
        .on('dragleave', (e) => {  // Hide upload overlay.
          jQuery('.upload-overlay-container').hide();
        })
        .on('drop', (e) => {  // Upload files and hide overlay.
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

  </script>

  <style>
  .mt-asset {
    padding: 0;
  }
  .upload_setting {
    display: block;
    cursor: pointer;
  }
  .upload-overlay-container {
    display: none;
    position: absolute;
    width: 100vw;
    height: 100vh;
    top: 0;
    left: 0;
  }

  .upload-overlay-background {
    background-color: #BAE3FF;
    opacity: 0.6;
    height: 100%;
  }

  .upload-overlay-drop {
    position: fiexed;
    top: 0;
    height: 100%;
  }

  .upload-overlay-border {
    top: 0;
    border: 3px solid #0A93F3;
  }

  .upload-overlay-message {
    text-align: center;
    vertical-align: middle;
    font-size: 18px;
    color: #0D76BF;
  }
  


  </style>
</assets>