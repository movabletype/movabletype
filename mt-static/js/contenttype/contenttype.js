riot.tag2('content-field', '<div class="mt-collapse__container"> <div class="col-auto"><ss title="{trans(\'Move\')}" class="mt-icon" href="{StaticURI}/images/sprite.svg#ic_move"></ss></div> <div class="col text-wrap"><ss title="{trans(\'ContentField\')}" class="mt-icon--secondary" href="{StaticURI}images/sprite.svg#ic_contentstype"></ss>{label} ({typeLabel}) <span if="{realId}">(ID: {realId})</span></div> <div class="col-auto"> <a href="javascript:void(0)" onclick="{duplicateField}" class="d-inline-block duplicate-content-field"><ss title="{trans(\'Duplicate\')}" class="mt-icon--secondary" href="{StaticURI}images/sprite.svg#ic_duplicate"></ss></a> <a href="javascript:void(0)" onclick="{deleteField}" class="d-inline-block delete-content-field"><ss title="{trans(\'Delete\')}" class="mt-icon--secondary" href="{StaticURI}images/sprite.svg#ic_trash"></ss></a> <a data-toggle="collapse" href="#field-options-{id}" aria-expanded="{isShow == \'show\' ? \'true\' : \'false\'}" aria-controls="field-options-{id}" class="d-inline-block"><ss title="{trans(\'Edit\')}" class="mt-icon--secondary" href="{StaticURI}images/sprite.svg#ic_collapse"></ss></a> </div> </div> <div data-is="{type}" class="collapse mt-collapse__content {isShow}" id="{\'field-options-\' + id}" fieldid="{id}" options="{this.options}" isnew="{isNew}"></div>', '', 'id="content-field-block-{id}"', function(opts) {
    this.deleteField = function(e) {
      item = e.item
      var label = item.label ? item.label : trans('No Name');
      if( !confirm( trans('Do you want to delete [_1]([_2])?', label, item.typeLabel) ) ){
        return;
      }
      index = this.parent.fields.indexOf(item)
      this.parent.fields.splice(index, 1)
      this.parent.update({
        isEmpty: this.parent.fields.length > 0 ? false : true
      })
      var target = document.getElementsByClassName('mt-draggable__area')[0]
      this.parent.recalcHeight(target)
    }.bind(this)
    this.duplicateField = function(e) {
      var index = this.parent.fields.indexOf(e.item)
      var newItem = jQuery.extend({},this.parent.fields[index])
      var field = this.parent.tags['content-field'][index].tags[newItem.type]
      var options = field.gatheringData()
      newItem.options = options
      newItem.id = Math.random().toString(36).slice(-8)
      var label = e.item.label
      if ( !label ) {
        label = jQuery('#content-field-block-' + e.item.id).find('[name="label"]').val()
        if (label == '') {
          label = trans('No Name')
        }
      }
      newItem.label = trans('Duplicate') + '-' + label
      newItem.options.label = newItem.label
      newItem.order = this.parent.fields.length+1
      newItem.isNew = true
      newItem.isShow = 'show'
      this.parent.fields.push(newItem)
      var target = document.getElementsByClassName('mt-draggable__area')[0]
      this.parent.recalcHeight(target)
      this.parent.update()
    }.bind(this)
});

riot.tag2('content-fields', '<form name="content-type-form" action="{CMSScriptURI}" method="POST"> <input type="hidden" name="__mode" value="save"> <input type="hidden" name="blog_id" riot-value="{opts.blog_id}"> <input type="hidden" name="magic_token" riot-value="{opts.magic_token}"> <input type="hidden" name="return_args" riot-value="{opts.return_args}"> <input type="hidden" name="_type" value="content_type"> <input type="hidden" name="id" riot-value="{opts.id}"> <input if="{data}" type="hidden" name="data" riot-value="{data}"> <div class="row"> <div class="col"> <div if="{opts.id}" id="name-field" class="form-group"> <h3>{opts.name} <button type="button" class="btn btn-link" data-toggle="modal" data-target="#editDetail">{trans(\'Edit\')}</button></h3> <div id="editDetail" class="modal" data-role="dialog" aria-labelledby="editDetail" aria-hidden="true"> <div class="modal-dialog modal-lg" data-role="document"> <div class="modal-content"> <div class="modal-header"> <h4 class="modal-title">{trans(\'Content Type\')}</h4> <button type="button" class="close" data-dismiss="modal" aria-label="Close"> <span aria-hidden="true">&times;</span> </button> </div> <div class="modal-body"> <div class="col"> <div id="name-field" class="form-group"> <label for="name" class="form-control-label">{trans(\'Content Type Name\')} <span class="badge badge-danger">{trans(\'Required\')}</span></label> <input type="text" name="name" id="name" class="form-control html5-form" riot-value="{opts.name}" onkeypress="{stopSubmitting}" required> </div> </div> <div class="col"> <div id="description-field" class="form-group"> <label for="description" class="form-control-label">{trans(\'Description\')}</label> <textarea name="description" id="description" class="form-control">{opts.description}</textarea> </div> </div> <div class="col"> <div id="label-field" class="form-group"> <label for="label_field" class="form-control-label">{trans(\'Data Label Field\')}</label> <select id="label_field" name="label_field" class="custom-select form-control html5-form" onchange="{changeLabelField}"> <option value="" selected="{labelField == ⁗⁗}">{trans(\'Show input field to enter data label\')} <option each="{labelFields}" riot-value="{value}" selected="{value == parent.labelField}">{label}</option> </select> </div> </div> <div class="col"> <div id="unique_id-field" class="form-group"> <label for="unique_id" class="form-control-label">{trans(\'Unique ID\')}</label> <input type="text" class="form-control-plaintext w-50" id="unieuq_id" riot-value="{opts.unique_id}" readonly> </div> </div> <div class="col"> <div id="user_disp_option-field" class="form-group"> <label for="user_disp_option">{trans(\'Allow users to change the display and sort of fields by display option\')}</label> <input type="checkbox" class="mt-switch form-control" id="user_disp_option" checked="{opts.user_disp_option}" name="user_disp_option"><label for="user_disp_option" class="last-child">{trans(\'Allow users to change the display and sort of fields by display option\')}</label> </div> </div> </div> <div class="modal-footer"> <button type="button" class="btn btn-default" data-dismiss="modal">{trans(\'close\')}</button> </div> </div> </div> </div> </div> <div if="{!opts.id}" id="name-field" class="form-group"> <label for="name" class="form-control-label">{trans(\'Name\')} <span class="badge badge-danger">{trans(\'Required\')}</span></label> <input type="text" name="name" id="name" class="form-control html5-form" riot-value="{opts.name}" onkeypress="{stopSubmitting}" required> </div> </div> </div> </form> <form> <fieldset id="content-fields" class="form-group"> <legend class="h3">{trans(\'Content Fields\')}</legend> <div class="mt-draggable__area" style="height:400px;" ondrop="{onDrop}" ondragover="{onDragOver}" ondragleave="{onDragLeave}"> <div show="{isEmpty}" class="mt-draggable__empty"> <img riot-src="{StaticURI}images/dragdrop.gif" alt="{trans(\'Drag and drop area\')}" width="240" height="120"> <p>{trans(\'Please add a content field.\')}</p> </div> <div class="mt-contentfield" draggable="true" aria-grabbed="false" each="{fields}" data-is="content-field" ondragstart="{onDragStart}" ondragend="{onDragEnd}" style="width: 100%;"></div> </div> </fieldset> </form> <button type="button" class="btn btn-primary" disabled="{!canSubmit()}" onclick="{submit}">{trans(⁗Save⁗)}</button>', 'content-fields .placeholder,[data-is="content-fields"] .placeholder{ height:26px; margin:4px; margin-left:10px; border-width:2px; border-style:dashed; border-radius:4px; border-color:#aaa; }', '', function(opts) {
    self = this
    self.fields = opts.fields
    self.isEmpty = self.fields.length > 0 ? false : true
    self.data = ""
    self.droppable = false
    self.observer = opts.observer
    self.dragged = null
    self.draggedItem = null
    self.placeholder = document.createElement("div")
    self.placeholder.className = 'placeholder'
    self.dragoverState = false
    self.labelFields = null
    self.labelField = opts.labelField

    self.on('updated', function () {
      var select = self.root.querySelector('#label_field')
      jQuery(select).find('option').each(function (index, option) {
        if (option.attributes.selected) {
          select.selectedIndex = index
          return false
        }
      })
    })

    self.observer.on('mtDragStart', function() {
      self.droppable = true
    })

    self.observer.on('mtDragEnd', function() {
      self.droppable = false
      self.onDragEnd()
    })

    jQuery(document).on('show.bs.modal', '#editDetail', function(e){
      self.rebuildLabelFields()
      self.update()
    })

    jQuery(document).on('hide.bs.modal', '#editDetail', function(e){
      if ( jQuery('#name-field > input').mtValidate('simple') ) {
        self.opts.name = jQuery('#name-field > input').val()
        setDirty(true)
        self.update()
      }
      else {
        return false
      }
    })

    jQuery(document).on('shown.bs.collapse', '.mt-collapse__content', function(e) {
      var target = document.getElementsByClassName('mt-draggable__area')[0]
      self.recalcHeight(target);
    })

    jQuery(document).on('hidden.bs.collapse', '.mt-collapse__content', function(e) {
      var target = document.getElementsByClassName('mt-draggable__area')[0]
      self.recalcHeight(target);
    })

    jQuery(document).on('focus', '.mt-draggable__area input, .mt-draggable__area textarea', function(e) {
      jQuery(this).closest('.mt-contentfield').attr('draggable', false);
    })

    jQuery(document).on('blur', '.mt-draggable__area input, .mt-draggable__area textarea', function(e) {
      jQuery(this).closest('.mt-contentfield').attr('draggable', true);
    })

    this.onDragOver = function(e) {

      if (self.droppable ) {

        if (e.target.className != 'mt-draggable__area' &&
            e.target.className != 'mt-draggable' &&
            e.target.className != 'mt-contentfield') {
          e.preventDefault()
          return
        }

        if (!self.dragoverState) {
          if (e.target.classList.contains('mt-draggable__area'))
            e.target.classList.add('mt-draggable__area--dragover')
          else if (e.target.classList.contains('mt-contentfield'))
            e.target.parentNode.classList.add('mt-draggable__area--dragover')
          self.dragoverState = true
        }

        if (self.dragged) {
          if (e.target.className == 'mt-contentfield') {

            self.over = e.target
            var targetRect = e.target.getBoundingClientRect()
            var parent = e.target.parentNode
            if ((e.clientY - targetRect.top) / targetRect.height > 0.5) {
              parent.insertBefore(self.placeholder, e.target.nextElementSibling)
            }
            else {
              parent.insertBefore(self.placeholder, e.target)
            }
          }
          if (e.target.className == 'mt-draggable__area') {
            var fields = e.target.getElementsByClassName('mt-contentfield')
            if (fields.length == 0 || ( fields.length == 1 && fields[0] == self.dragged)){
              e.target.appendChild(self.placeholder);
            }
          }

        }
        else {

          if (e.target.classList.contains('mt-draggable__area'))
            e.target.appendChild(self.placeholder)
          else if (e.target.classList.contains('mt-contentfield'))
            e.target.parentNode.appendChild(self.placeholder)
        }

        e.preventDefault()
      }
    }.bind(this)

    this.onDrop = function(e) {
      if (self.dragged) {
        var pos = 0
        var children
        if (self.placeholder.parentNode) {
          children = self.placeholder.parentNode.children
        }
        if(!children) {
          e.target.classList.remove('mt-draggable__area--dragover')
          e.preventDefault()
          return;
        }
        for(var i = 0; i < children.length; i++){
          if(children[i] == self.placeholder) break;
          if(children[i] != self.dragged && children[i].classList.contains("mt-contentfield")) {
            pos++;
          }
        }
        self._moveField(self.draggedItem, pos)
        setDirty(true)
        self.update()
      }
      else {

        var fieldType = e.dataTransfer.getData('text')
        var field = jQuery("[data-field-type='" + fieldType + "']")
        var fieldTypeLabel = field.data('field-label')
        var canDataLabel = field.data('can-data-label')

        newId = Math.random().toString(36).slice(-8)
        field = {
          'type': fieldType,
          'typeLabel' : fieldTypeLabel,
          'id' : newId,
          'isNew': true,
          'isShow': 'show',
          'canDataLabel' : canDataLabel
        }
        self.fields.push(field)
        setDirty(true)
        self.update({
          isEmpty: false
        })

        self.recalcHeight(document.getElementsByClassName('mt-draggable__area')[0])
      }
      self.rebuildLabelFields()

      e.target.classList.remove('mt-draggable__area--dragover')
      e.preventDefault()
    }.bind(this)

    this.onDragLeave = function(e) {
      if (self.dragoverState) {
        if (e.target.classList.contains('mt-draggable__area'))
          e.target.classList.remove('mt-draggable__area--dragover')
        else if (e.target.classList.contains('mt-contentfield'))
          e.target.parentNode.classList.remove('mt-draggable__area--dragover')
        self.dragoverState = false
      }
    }.bind(this)

    this.onDragStart = function(e) {
      self.dragged = e.target
      self.draggedItem = e.item
      e.dataTransfer.setData('text', e.item.id)
      self.droppable = true
    }.bind(this)

    this.onDragEnd = function(e) {
      if (self.placeholder.parentNode) {
        self.placeholder.parentNode.removeChild(self.placeholder)
      }
      self.droppable = false
      self.dragged = null
      self.draggedItem = null
      self.dragoverState = false
      self.update()
    }.bind(this)

    this.stopSubmitting = function(e) {
      if (e.which == 13) {
        e.preventDefault()
        return false
      }
      return true
    }.bind(this)

    this.canSubmit = function() {
      if (self.fields.length == 0) {
        return true
      }
      var invalidFields = self.fields.filter(function (field) {
        return opts.invalid_types[field.type]
      })
      return invalidFields.length == 0 ? true : false
    }.bind(this)

    this.submit = function(e) {
      if (!self.canSubmit()) {
        return
      }

      if ( !self._validateFields() ) {
        return
      }

      self.rebuildLabelFields()
      setDirty(false)
      fieldOptions = [];
      if (self.fields) {
        var child = self.tags['content-field']
        if (child) {
          if (!Array.isArray(child)) {
            child = [ child ]
          }

          child.forEach(function (c, i) {
            var field = c.tags[c.type]
            var options = field.gatheringData()
            var data = {}
            data.type = c.type
            data.options = options
            if ( c.isNew ) {
              data.order = i + 1
            }
            else {
              data.id = c.id
              var innerField = self.fields.filter( function (v) {
                return v.id == c.id
              })
              if (innerField.length) {
                data.order = innerField[0].order
              }
              else {
                data.order = i + 1
              }
            }
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
    }.bind(this)

    this.recalcHeight = function(droppableArea) {

      var contentFields = droppableArea.getElementsByClassName('mt-contentfield')
      var clientHeight = 0;
      for (var i = 0; i < contentFields.length; i++){
        clientHeight += contentFields[i].offsetHeight
      }
      if ( clientHeight >= droppableArea.clientHeight ) {
        jQuery(droppableArea).height(clientHeight + 100)
      }
      else {
        if ( clientHeight >= 400 )
          jQuery(droppableArea).height(clientHeight + 100)
        else
          jQuery(droppableArea).height(400 - 8)
      }
    }.bind(this)

    this.rebuildLabelFields = function() {
      var fields = [];
      for(var i = 0; i < self.fields.length; i++) {
        var required = jQuery('#content-field-block-' + self.fields[i].id).find('[name="required"]').prop('checked')
        if ( required && self.fields[i].canDataLabel == 1 ) {
          var label = self.fields[i].label
          var id = self.fields[i].unique_id
          if ( !label ) {
            label = jQuery('#content-field-block-' + self.fields[i].id).find('[name="label"]').val()
            if (label == '') {
              label = trans('No Name')
            }
            id =  'id:' + self.fields[i].id
          }
          fields.push({
            'value' : id,
            'label' : label
          })
        }
      }
      self.labelFields = fields
      self.update()
    }.bind(this)

    this.changeLabelField = function(e) {
        self.labelField = e.target.value
    }.bind(this)

    this._moveField = function(item, pos) {
      for (var i = 0; i < self.fields.length; i++) {
        var field = self.fields[i];
        if (field.id == item.id) {
          self.fields.splice(i, 1)
          break
        }
      }
      self.fields.splice(pos, 0, field)
      for (var i = 0; i < self.fields.length; i++) {
        self.fields[i].order = i + 1
      }
    }.bind(this)

    this._validateFields = function() {
      var requiredFieldsAreValid    = jQuery('.html5-form')
                                         .mtValidate('simple')
      var textFieldsInTableAreValid = jQuery('.values-option-table input[type=text]')
                                         .mtValidate('simple');
      var tableIsValid              = jQuery('.values-option-table')
                                         .mtValidate('selection-field-values-option')
      var contentFieldBlockIsValid  = jQuery('.content-field-block')
                                         .mtValidate('content-field-block')
      var uniqueFieldsAreValid      = jQuery('input[data-mt-content-field-unique]')
                                         .mtValidate('simple')

      var res = requiredFieldsAreValid
                && textFieldsInTableAreValid
                && tableIsValid
                && contentFieldBlockIsValid
                && uniqueFieldsAreValid

      if ( !res ) {
        jQuery('.mt-contentfield').each(function(i, fld) {
          var $fld = jQuery(fld)
          if ($fld.find('.form-control.is-invalid').length > 0) {
            $fld.find('.collapse').collapse('show')
          }
        })
      }

      return res
    }.bind(this)

});
