<content-fields>
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
      <div show={ isEmpty }>{ trans('Please add a content field.') }</div>
      <div each={ fields } data-is="content-field"></div>
    </div>
  </fieldset>

  <script>
    this.fields = opts.fields
    this.currentType = opts.types[0].type
    this.currentTypeLabel = opts.types[0].label
    this.isEmpty = this.fields.length > 0 ? false : true
    console.log(this.isEmpty)

    changeType(e) {
      this.currentType = e.target.options[e.target.selectedIndex].value
      this.currentTypeLabel = e.target.options[e.target.selectedIndex].text
    }

    addField(e) {
      newId = Math.floor(10000*Math.random()).toString(16)
      field = {
        'type': this.currentType,
        'typeLabel' : this.currentTypeLabel,
        'id' : newId,
        'isShow': 'show'
      }
      this.fields.push(field)
      setDirty(true)
      this.update({
        isEmpty: false
      })
      e.preventDefault()
    }
  </script>
</content-fields>
