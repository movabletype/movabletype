<asset-upload-option>

<div id="uploadSettings">

  <fieldset class="form-group">
    <legend class="h3">{ trans('Upload Destination') }</legend>
    <div if={parent.opts.filter != 'userpic'}>
      <div class="row" if={ parent.opts.allow_to_change_at_upload }>
        <div class="col row" if={ parent.opts.destination_loop }>
          <div class="col">
            <select name="destination" id="destination" class="custom-select form-control w-100" onchange={ changeDestinationSelect } aria-describedby="uploadDestination">
              <option each={ destination in parent.opts.destination_loop } value={ destination.path } selected={ destination.selected }>
                { destination.label }
              </option>
            </select>
          </div>
          <input type="text" id="upload_destination_custom" class="form-control text path required valid-custom-path upload-destination w-100 col-12" disabled="disabled" name="destination" value={ parent.uploadOoptions.destination } style="display: none;" aria-describedby="uploadDestination" onchange={ changeDestinationText }>
          <div class="col">
            <div class="upload-extra-path row">
              <div class="col-auto h5 mt-auto mb-auto">/</div>
              <div class="col w-100 ml-0 pl-0"><input type="text" name="extra_path" id="extra_path" class="form-control text path w-100 ml-0" value={ parent.uploadOoptions.extra_path } onkeyup={ changeExtraPath } ></div>
            </div>
          </div>
        </div>
      </div>
      <div class="row">
        <small id="uploadDestination" class="form-text text-muted">{ trans('_USAGE_UPLOAD') }</small>
      </div>
      <div if={ !parent.opts.allow_to_change_at_upload }>
        <div id="site_path-field" class="field field-top-label">
          <div class="field-content">
            { parent.opts.upload_destination_label }/{ parent.opts.extra_path }
          </div>
        </div>
      </div>
    </div>
  </fieldset>

  <fieldset class="form-group">
    <legend class="h3">{ trans('Upload Options') }</legend>
    <div class="form-group">
      <div class="custom-control custom-checkbox">
        <input type="checkbox" name="auto_rename_non_ascii" id="auto_rename_non_ascii" value="1" checked={ parent.uploadOoptions.auto_rename_non_ascii } class="cb custom-control-input" onchange={ changeAutoRenameNonAscii }>
        <label class="custom-control-label" for="auto_rename_non_ascii">{ trans('Rename non-ascii filename automatically') }</label>
      </div>
    </div>
    <select name="operation_if_exists" id="operation_if_exists" class="custom-select form-control text-truncate" onchange={ changeOperationIfExists }>
      <option value="1" selected={ parent.uploadOoptions.operation_if_exists == 1 }>
        { trans('Upload and rename') }
      </option>
      <option value="2" selected={ parent.uploadOoptions.operation_if_exists == 2 }>
        { trans('Overwrite existing file') }
      </option>
      <option value="3" selected={ parent.uploadOoptions.operation_if_exists == 3 }>
        { trans('Cancel upload') }
      </option>
    </select>
    <div class="form-group">
      <div class="custom-control custom-checkbox">
        <input type="checkbox" name="normalize_orientation" id="normalize_orientation" value="1" checked={ parent.uploadOoptions.normalize_orientation } class="cb custom-control-input" onchange={ changeNormalizeOrientation }>
        <label class="custom-control-label" for="normalize_orientation">{ trans('Enable orientation normalization') }</label>
      </div>
    </div>
  </fieldset>

</div>

<script>
  changeDestinationText(e){
      this.parent.uploadOoptions.destination = e.target.value
  }
  changeDestinationSelect(e) {
    if(e.target.value.indexOf("%") == -1){
      jQuery('#upload_destination_custom').show().removeAttr('disabled')
      this.parent.uploadOoptions.destination = jQuery('#upload_destination_custom').val()
    } else {
      jQuery('#upload_destination_custom').hide().attr('disabled', 'disabled')
      this.parent.uploadOoptions.destination = e.target.value
    }
  }

  changeExtraPath(e) {
    this.parent.uploadOoptions.extra_path = e.target.value
  }

  changeAutoRenameNonAscii(e) {
    this.parent.uploadOoptions.auto_rename_non_ascii = e.target.value
  }
  changeOperationIfExists(e) {
    this.parent.uploadOoptions.operation_if_exists = e.target.value
  }
  changeNormalizeOrientation(e) {
    this.parent.uploadOoptions.normalize_orientation = e.target.value
  }
</script>
</asset-upload-option>