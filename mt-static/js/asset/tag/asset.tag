<asset>
  <div class={ "img-preview" + (selected ? ' selected' : '') } onclick={ selectAsset }>
    <img if={ type == 'image' } src={ url } class="image img-fluid">
    <img if={ type != 'image' } src="{ StaticURI }images/file-{ type == "file" ? 'default' : type=="video" ? 'movie' : type }.svg" class="image img-fluid">
    <div class="img-overlay" if={ selected }>
      <input type="checkbox" id="asset-{ id }" class="asset-checked" name="asset-img-id" value={ id } checked={ selected } onclick={ unselectAsset }>
    </div>
    <div class="upload_cancel" if={ is_upload } onclick={ uploadCancel }>
      <ss title="{ trans('Cancel') }" class="mt-icon" href="{ StaticURI }images/sprite.svg#ic_caution"></ss>
    </div>
    <div class="img-progress" if={ is_upload }>
      <progress value={ upload_progress_rate } max="100"></progress><span class="upload_rate">({ upload_progress_rate }%)</span>
    </div>
  </div>

  <script>
    selectAsset(e) {
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
    }
    unselectAsset(e) {
        this.parent.assets.map((asset) => {
          if(asset.id == this.id){
            asset.selected = false
            this.selected = false
          }
        })
      this.parent.targetAsset = {}
      this.parent.observer.trigger('changeTargetAsset')
      e.stopPropagation()
    }
    uploadCancel(e) {
      this.abortUpload()
      e.stopPropagation()
    }
  </script>
  <style>
  .img-preview {
    position: relative;
    box-shadow: inset 0 0 15px rgb(0 0 0 / 10%), inset 0 0 0 1px rgb(0 0 0 / 5%);
    background: #f0f0f1;
    cursor: pointer;
    border: 3px solid transparent;
  }
  .img-preview:before {
    content: "";
    display: block;
    padding-top: 100%;
  }
  .img-preview.selected {
    border: 3px solid #007bff;
    border-color: #007bff;
    border-width: 3px;
  }
  .img-preview .image {
    background-color: #FFFFFF;
    max-height: 100%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
  }
  .img-overlay {
    position: absolute;
    top: 0;
    left: 0;
    padding:0;
    background-color: #ddd;
    width: 25px;
    height: 25px;
    text-align: center;
    box-sizing: border-box;
  }
  .upload_cancel {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }
  .img-progress {
    position: absolute;
    bottom: 0;
    width: 100%;
    text-align: center;
    box-sizing: border-box;
  }
  .img-progress progress {
    width: 98%;
  }
  .upload_rate {
    color: #007bff;
  }
  </style>
</asset>