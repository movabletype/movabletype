<asset-preview>
  <div if={ Object.keys(targetAsset).length }>
    <div class="row">
      <div class="col">
        <img if={ targetAsset.type == 'image' } src={ targetAsset.url } class="image img-fluid preview-image">
        <virtual if={ targetAsset.type != 'image' }>
          <a href={ targetAsset.url } target="_blank" class="preview-file">
            <img if={ targetAsset.type != 'image' } src="{ StaticURI }images/images/file-{ targetAsset.type == "file" ? 'default' : targetAsset.type=="video" ? 'movie' : targetAsset.type }.svg" width="60" height="60">
            <ss title="{ trans('View') }" class="mt-icon" href="{ StaticURI }images/sprite.svg#ic_permalink"></ss>
          </a>
        </virtual>
      </div>
      <div class="col">
        <div class="asset_name text-break">{ targetAsset.label }</div>
        <div class="asset_size text-break" if={ targetAsset.type == "image"}>{ targetAsset.width } x { targetAsset.height }</div>
      </div>
    </div>
    <form class="form pt-5" if={ targetAsset.type == "image"}>
      <div class="form-group mb-3">
        <div data-is="alt-input"></div>
      </div>
      <div class="form-group mb-3">
        <div data-is="caption-input"></div>
      </div>
      <div class="form-group mb-3">
        <div data-is="width-input"></div>
      </div>
      <div class="form-group mb-3">
        <div data-is="link-input"></div>
      </div>
      <div class="form-group mb-3">
        <div data-is="align-input"></div>
      </div>
    </form>
  </div>

  <script>
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

    changeInsertOption(name, value){
        this.parent.assets.map((asset) => {
          if(asset.id == this.targetAsset.id){
            asset.insert_options[name] = value
          }
        })
        this.parent.update()
    }

  </script>

  <style>
  .preview-image {
    height: 80px;
  }
  .active {
    background : #E3F2F4;
  }
  .preview-file {
    position: relative;
    display: block;
    padding: 1em;
    background-color: #E3F2F4;
  }
  .preview-file .mt-icon {
    position: absolute;
    top: 0;
    right: 0;
    z-index: 1;
  }
  </style>

</asset-preview>

<alt-input>
  <label class="form-control-label" for="alt">
    { trans('Alt') }
  </label>
  <input type="text" name="alt" id="alt" class="form-control" onkeyup={ changeText } value={ value }>
  <script>
    this.value = this.parent.targetAsset.insert_options.alt
    this.observer = this.parent.observer
    changeText(e){
      this.parent.changeInsertOption("alt", e.target.value)
      this.value = e.target.value
    }
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return 
      this.value = this.parent.targetAsset.insert_options.alt
      this.update()
    })
  </script>
</alt-input>

<caption-input>
  <label class="form-control-label" for="caption">
    { trans('Caption') }
  </label>
  <input type="text" name="caption" id="caption" class="form-control" onkeyup={ changeText } value={ value }>
  <script>
    this.value = this.parent.targetAsset.insert_options.caption
    this.observer = this.parent.observer
    changeText(e){
      this.value = e.target.value
      this.parent.changeInsertOption("caption", e.target.value)
    }
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return 
      this.value = this.parent.targetAsset.insert_options.caption
      this.update()
    })
  </script>
</caption-input>
<width-input>
  <label class="form-control-label" for="width">
    { trans('Width') }
  </label>
  <input type="text" name="width" id="width" class="form-control" onkeyup={ changeText } value={ value }>
  <script>
    this.value = this.parent.targetAsset.insert_options.width
    this.observer = this.parent.observer
    changeText(e){
      this.value = e.target.value
      this.parent.changeInsertOption("width", e.target.value)
    }
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return 
      this.value = this.parent.targetAsset.insert_options.width
      this.update()
    })
  </script>
</width-input>
<link-input>
  <div class="custom-control custom-checkbox">
    <input type="checkbox" name="popup" id="link_to_popup" class="custom-control-input" onchange={ changeChack } checked={ value }>
    <label class="custom-control-label" for="link_to_popup">{ trans('Link to original image') }</label>
  </div>
  <script>
    this.value = this.parent.targetAsset.insert_options.link
    this.observer = this.parent.observer
    changeChack(e){
      this.value = e.target.checked ? true : false
      this.parent.changeInsertOption("link", e.target.checked ? true : false)
    }
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return 
      this.value = this.parent.targetAsset.insert_options.link
      this.update()
    })
  </script>
</link-input>
<align-input>
  <div class="form-group alignbutton">
    <button type="button" class="btn btn-default p-1 alignleft { checked == 'left' ? 'active' : '' }" data-align="left" title="{ trans('Align Left') }" data-toggle="button" aria-pressed="false" onclick={ changeAlign }>
      <ss title="{ trans('Align Left') }" class="mt-icon" href="{ StaticURI }images/sprite.svg#ic_alignleft"></ss>
    </button>
    <button type="button" class="btn btn-default p-1 aligncenter { checked == 'center' ? 'active' : '' }" data-align="center" title="{ trans('Align Center') }" data-toggle="button" aria-pressed="false" onclick={ changeAlign }>
      <ss title="{ trans('Align Left') }" class="mt-icon" href="{ StaticURI }images/sprite.svg#ic_aligncenter"></ss>
    </button>
    <button type="button" class="btn btn-default p-1 alignright { checked == 'right' ? 'active' : '' }" data-align="right" title="{ trans('Align Right') }" data-toggle="button" aria-pressed="false" onclick={ changeAlign }>
      <ss title="{ trans('Align Left') }" class="mt-icon" href="{ StaticURI }images/sprite.svg#ic_alignright"></ss>
    </button>
    <button type="button" class="btn btn-default p-1 alignnone { checked == 'none' ? 'active' : '' }" data-align="none" title="{ trans('None') }" data-toggle="button" aria-pressed="false" onclick={ changeAlign }>
      <ss title="{ trans('Align Left') }" class="mt-icon" href="{ StaticURI }images/sprite.svg#ic_alignnone"></ss>
    </button>
  </div>
  <script>
    this.checked = this.parent.targetAsset.insert_options.align ? this.parent.targetAsset.insert_options.align : "none"
    this.observer = this.parent.observer
    changeAlign(e){
      e.stopImmediatePropagation()
      this.checked = e.target.dataset["align"]
      this.parent.changeInsertOption("align", e.target.dataset["align"])
      this.update()
    }
    this.observer.on('changeTargetAsset', () => {
      if(!Object.keys(this.parent.targetAsset).length) return 
      this.checked = this.parent.targetAsset.insert_options.align ? this.parent.targetAsset.insert_options.align : "none"
      this.update()
    })
  </script>
  <style>
  .active {
    border-color: #5FBCEB;
    box-shadow: 0 0 0 2px #5FBCEB;
  }
  </style>
</align-input>