<content-fields>
  <form name="content-type-form" action={ CMSScriptURI } method="POST">
    <input type="hidden" name="__mode" value="save">
    <input type="hidden" name="blog_id" value={ opts.blog_id }>
    <input type="hidden" name="magic_token" value={ opts.magic_token }>
    <input type="hidden" name="return_args" value={ opts.return_args }>
    <input type="hidden" name="_type" value="content_type">
    <input type="hidden" name="id" value={ opts.id }>
    <input if={ data } type="hidden" name="data" value={ data }>

    <div class="row">
      <div class="col">
        <div id="name-field" class="form-group">
          <label for="name" class="form-control-label">{ trans('Content Type Name') } <span class="badge badge-danger">{ trans('Required') }</span></label>
          <input type="text" name="name" id="name" class="form-control html5-form" value={opts.name} onkeypress={ stopSubmitting } required>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div id="description-field" class="form-group">
          <label for="description" class="form-control-label">{ trans('Description') }</label>
          <textarea name="description" id="description" class="form-control">{ opts.description }</textarea>
        </div>
      </div>
    </div>
    <div if={ opts.id } class="row">
      <div class="col">
        <div id="unique_id-field" class="form-group">
          <label for="unique_id" class="form-control-label">{ trans('Unique ID') }</label>
            <input type="text" class="form-control-plaintext w-50" id="unieuq_id" value={ opts.unique_id } readonly>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div id="user_disp_option-field" class="form-group">
          <label for="user_disp_option">{ trans('Allow users to change the display and sort of fields by display option') }</label>
          <input type="checkbox" class="mt-switch form-control" id="user_disp_option" checked={ opts.user_disp_option } name="user_disp_option"><label for="user_disp_option" class="last-child">{ trans('Allow users to change the display and sort of fields by display option') }</label>
        </div>
      </div>
    </div>
  </form>

  <form>
    <fieldset id="content-fields" class="form-group">
      <legend class="h3">{ trans('Content Fields') }</legend>
      <div class="mb-3">
        <div class="row">
          <div class="col-2">
            <select onchange={ changeType } name="type" id="type" class="required form-control">
              <option each={ opts.types } value={ type }>{ label }</option>
            </select>
          </div>
          <div class="col">
            <button type="button" onclick={ addField } class="btn btn-default">{ trans('Add content field') }</button>
          </div>
        </div>
      </div>

      <div id="sortable" class="sortable">
        <div show={ isEmpty }>{ trans('Please add a piece of content field.') }</div>
        <div each={ fields } data-is="content-field"></div>
      </div>
    </fieldset>
  </form>
  <button type="button" class="btn btn-primary" disabled={ !canSubmit() } onclick={ submit }>{ trans("Save") }</button>

  <script>
    this.fields = opts.fields
    this.currentType = opts.types[0].type
    this.currentTypeLabel = opts.types[0].label
    this.isEmpty = this.fields.length > 0 ? false : true
    this.data = "";

    stopSubmitting(e) {
      if (e.which == 13) {
        e.preventDefault()
        return false
      }
      return true
    }

    changeType(e) {
      this.currentType = e.target.options[e.target.selectedIndex].value
      this.currentTypeLabel = e.target.options[e.target.selectedIndex].text
    }

    addField(e) {
      newId = Math.random().toString(36).slice(-8);
      field = {
        'type': this.currentType,
        'typeLabel' : this.currentTypeLabel,
        'id' : newId,
        'isNew': true,
        'isShow': 'show'
      }
      this.fields.push(field)
      setDirty(true)
      this.update({
        isEmpty: false
      })
      e.preventDefault()
    }

    _validateFields() {
      const simple = jQuery('.html5-form').mtValidate('simple')
      const valuesOptionTable = jQuery('.values-option-table')
                                  .mtValidate('selection-field-values-option')
      const contentFieldBlock = jQuery('.content-field-block')
                                  .mtValidate('content-field-block')
      return simple && valuesOptionTable && contentFieldBlock
    }

    canSubmit() {
      if (this.fields.length == 0) {
        return true
      }
      const invalidFields = this.fields.filter((field) => {
        return opts.invalid_types[field.type]
      })
      return invalidFields.length == 0 ? true : false
    }

    submit(e) {
      if (!this.canSubmit()) {
        return
      }

      if ( !this._validateFields() ) {
        return
      }

      setDirty(false)
      fieldOptions = [];
      if ( this.fields ) {
        child = this.tags['content-field']
        if ( child ) {
          if ( !Array.isArray(child) )
            child = [ child ]
          i = 0;
          child.forEach( function(c) {
            field = c.tags[c.type]
            options = field.gatheringData()
            data = {}
            data.type = c.type
            data.order = ++i
            data.options = options
            if ( !c.isNew )
              data.id = c.id
            fieldOptions.push(data)
          })
          this.data = JSON.stringify(fieldOptions)
        }
      }
      else {
        this.data = ""
      }
      this.update()
      document.forms['content-type-form'].submit()
    }

  </script>
</content-fields>
