riot.tag2('content-field', '<div class="content-field-block mt-collapse mb-2" draggable="true" aria-grabbed="false" id="content-field-block-{id}"> <div class="mt-collapse__container"> <div class="col"> <svg title="{trans(\'ContentField\')}" role="img" class="mt-icon--secondary"><use xlink:href="{StaticURI}images/sprite.svg#ic_contentstype"></use></svg>{label} ({typeLabel}) </div> <div class="col-auto"> <a data-toggle="collapse" href="#field-options-{id}" aria-expanded="false" aria-controls="field-options-{id}"><svg title="{trans(\'Edit\')}" role="img" class="mt-icon"><use xlink:href="{StaticURI}images/sprite.svg#ic_edit"></use></svg> {trans(\'Setting\')}</a> </div> <div class="col-auto"> <a href="javascript:void(0)" onclick="{deleteField}"> <svg title="{trans(\'Delete\')}" role="img" class="mt-icon"><use xlink:href="{StaticURI}images/sprite.svg#ic_trash"></use></svg> {trans(\'Delete\')} </a> </div> <div class="col-auto"> <svg title="{trans(\'Move\')}" role="img" class="mt-icon"><use xlink:href="{StaticURI}/images/sprite.svg#ic_move"></use></svg> </div> </div> <div data-is="{type}" class="collapse mt-collapse__content {isShow}" id="{\'field-options-\' + id}" fieldid="{id}" options="{this.options}" isnew="{isNew}"></div> </div>', '', '', function(opts) {
    this.deleteField = function(e) {
      item = e.item
      index = this.parent.fields.indexOf(item)
      this.parent.fields.splice(index, 1)
      this.parent.update({
        isEmpty: this.parent.fields.length > 0 ? false : true
      })
    }.bind(this)
});

riot.tag2('content-fields', '<form name="content-type-form" action="{CMSScriptURI}" method="POST"> <input type="hidden" name="__mode" value="save"> <input type="hidden" name="blog_id" riot-value="{opts.blog_id}"> <input type="hidden" name="magic_token" riot-value="{opts.magic_token}"> <input type="hidden" name="return_args" riot-value="{opts.return_args}"> <input type="hidden" name="_type" value="content_type"> <input type="hidden" name="id" riot-value="{opts.id}"> <input if="{data}" type="hidden" name="data" riot-value="{data}"> <div class="row"> <div class="col"> <div id="name-field" class="form-group"> <label for="name" class="form-control-label">{trans(\'Content Type Name\')} <span class="badge badge-danger">{trans(\'Required\')}</span></label> <input type="text" name="name" id="name" class="form-control html5-form" riot-value="{opts.name}" onkeypress="{stopSubmitting}" required> </div> </div> </div> <div class="row"> <div class="col"> <div id="description-field" class="form-group"> <label for="description" class="form-control-label">{trans(\'Description\')}</label> <textarea name="description" id="description" class="form-control">{opts.description}</textarea> </div> </div> </div> <div if="{opts.id}" class="row"> <div class="col"> <div id="unique_id-field" class="form-group"> <label for="unique_id" class="form-control-label">{trans(\'Unique ID\')}</label> <input type="text" class="form-control-plaintext w-50" id="unieuq_id" riot-value="{opts.unique_id}" readonly> </div> </div> </div> <div class="row"> <div class="col"> <div id="user_disp_option-field" class="form-group"> <label for="user_disp_option">{trans(\'Allow users to change the display and sort of fields by display option\')}</label> <input type="checkbox" class="mt-switch form-control" id="user_disp_option" checked="{opts.user_disp_option}" name="user_disp_option"><label for="user_disp_option" class="last-child">{trans(\'Allow users to change the display and sort of fields by display option\')}</label> </div> </div> </div> </form> <form> <fieldset id="content-fields" class="form-group"> <legend class="h3">{trans(\'Content Fields\')}</legend> <div class="mb-3"> <div class="row"> <div class="col-2"> <select onchange="{changeType}" name="type" id="type" class="required form-control"> <option each="{opts.types}" riot-value="{type}">{label}</option> </select> </div> <div class="col"> <button type="button" onclick="{addField}" class="btn btn-default">{trans(\'Add content field\')}</button> </div> </div> </div> <div id="sortable" class="sortable"> <div show="{isEmpty}">{trans(\'Please add a piece of content field.\')}</div> <div each="{fields}" data-is="content-field"></div> </div> </fieldset> </form> <button type="button" class="btn btn-primary" disabled="{!canSubmit()}" onclick="{submit}">{trans(⁗Save⁗)}</button>', '', '', function(opts) {
    this.fields = opts.fields
    this.currentType = opts.types[0].type
    this.currentTypeLabel = opts.types[0].label
    this.isEmpty = this.fields.length > 0 ? false : true
    this.data = "";

    this.stopSubmitting = function(e) {
      if (e.which == 13) {
        e.preventDefault()
        return false
      }
      return true
    }.bind(this)

    this.changeType = function(e) {
      this.currentType = e.target.options[e.target.selectedIndex].value
      this.currentTypeLabel = e.target.options[e.target.selectedIndex].text
    }.bind(this)

    this.addField = function(e) {
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
    }.bind(this)

    this._validateFields = function() {
      const requiredFieldsAreValid    = jQuery('.html5-form')
                                          .mtValidate('simple')
      const textFieldsInTableAreValid = jQuery('.values-option-table input[type=text]')
                                          .mtValidate('simple');
      const tableIsValid              = jQuery('.values-option-table')
                                          .mtValidate('selection-field-values-option')
      const contentFieldBlockIsValid  = jQuery('.content-field-block')
                                          .mtValidate('content-field-block')

      return requiredFieldsAreValid && textFieldsInTableAreValid
          && tableIsValid && contentFieldBlockIsValid
    }.bind(this)

    this.canSubmit = function() {
      if (this.fields.length == 0) {
        return true
      }
      const invalidFields = this.fields.filter((field) => {
        return opts.invalid_types[field.type]
      })
      return invalidFields.length == 0 ? true : false
    }.bind(this)

    this.submit = function(e) {
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
    }.bind(this)

});
