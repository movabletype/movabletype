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
      <div id="installed-fields" class="sortable" ondrop={ onDrop } ondragover={ onDragOver }>
        <div show={ isEmpty }>{ trans('Please add a piece of content field.') }</div>
        <div each={ fields } data-is="content-field"></div>
      </div>
    </fieldset>
  </form>
  <button type="button" class="btn btn-primary" disabled={ !canSubmit() } onclick={ submit }>{ trans("Save") }</button>

  <script>
    self = this
    self.fields = opts.fields
    self.isEmpty = self.fields.length > 0 ? false : true
    self.data = ""
    self.droppable = false
    self.observer = opts.observer

    self.observer.on('mtDragStart', function() {
      self.droppable = true
    })

    self.observer.on('mtDragEnd', function() {
      self.droppable = false
    })

    stopSubmitting(e) {
      if (e.which == 13) {
        e.preventDefault()
        return false
      }
      return true
    }

    onDragOver(e) {
      if ( self.droppable )
        e.preventDefault()
    }

    onDrop(e) {
      let fieldType = e.dataTransfer.getData('text')
      let field = jQuery("[data-field-type='" + fieldType + "']")
      let fieldTypeLabel = field.data('field-label')

      newId = Math.random().toString(36).slice(-8)
      field = {
        'type': fieldType,
        'typeLabel' : fieldTypeLabel,
        'id' : newId,
        'isNew': true,
        'isShow': 'show'
      }
      self.fields.push(field)
      setDirty(true)
      self.update({
        isEmpty: false
      })
      e.preventDefault()
    }

    _validateFields() {
      var requiredFieldsAreValid    = jQuery('.html5-form')
                                        .mtValidate('simple')
      var textFieldsInTableAreValid = jQuery('.values-option-table input[type=text]')
                                        .mtValidate('simple');
      var tableIsValid              = jQuery('.values-option-table')
                                        .mtValidate('selection-field-values-option')
      var contentFieldBlockIsValid  = jQuery('.content-field-block')
                                        .mtValidate('content-field-block')

      return requiredFieldsAreValid && textFieldsInTableAreValid
          && tableIsValid && contentFieldBlockIsValid
    }

    canSubmit() {
      if (self.fields.length == 0) {
        return true
      }
      var invalidFields = self.fields.filter(function (field) {
        return opts.invalid_types[field.type]
      })
      return invalidFields.length == 0 ? true : false
    }

    submit(e) {
      if (!self.canSubmit()) {
        return
      }

      if ( !self._validateFields() ) {
        return
      }

      setDirty(false)
      fieldOptions = [];
      if ( self.fields ) {
        child = self.tags['content-field']
        if ( child ) {
          if ( !Array.isArray(child) )
            child = [ child ]
          child.forEach( function (c, i) {
            field = c.tags[c.type]
            options = field.gatheringData()
            data = {}
            data.type = c.type
            data.order = i + 1
            data.options = options
            if ( !c.isNew )
              data.id = c.id
            fieldOptions.push(data)
          })
          self.data = JSON.stringify(fieldOptions)
        }
      }
      else {
        self.data = ""
      }
      self.update()
      document.forms['content-type-form'].submit()
    }

  </script>
</content-fields>
