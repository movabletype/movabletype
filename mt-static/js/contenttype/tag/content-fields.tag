<content-fields>
  <fieldset id="content-fields" class="form-group">
    <legend class="h3">{ trans('Content Fields') }</legend>
    <div>
      <select onchange={ changeType } name="type" id="type" class="required">
        <option each={ opts.types } value={ type }>{ label }</option>
      </select>
      <span class="item-add"><button type="button" onclick={ addField } class="btn btn-default">{ trans('Add content field') } </a></span>
    </div>

    <div id="sortable" class="sortable">
      <div each={ fields } data-is="content-field"></div>
    </div>
  </fieldset>

  <script>
    this.fields = opts.fields;
    this.currentType = opts.types[0].type;
    this.currentTypeLabel = opts.types[0].label;
    changeType(e) {
      this.currentType = e.target.options[e.target.selectedIndex].value;
      this.currentTypeLabel = e.target.options[e.target.selectedIndex].text;
    }

    addField(e) {
      var newId = Math.floor(10000*Math.random()).toString(16);
      var field = {
        'type': this.currentType,
        'typeLabel' : this.currentTypeLabel,
        'id' : newId,
        'isShow': 'show'
      };
      this.fields.push(field);
      e.preventDefault()
    }
  </script>
</content-fields>
