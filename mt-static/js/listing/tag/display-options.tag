<display-options>
  <div class="row">
    <div class="col-md-12">
      <a href="#"
        class="btn btn-default pull-right"
        data-toggle="collapse"
        data-target="#display-options-detail"
      >
        { trans('Display Options') }
        <span class="caret"></span>
      </a>
    </div>
  </div>
  <div class="row">
    <div data-is="display-options-detail"
      class="col-md-12"
      columns={ opts.columns }
      limit={ opts.limit }>
    </div>
  </div>
</display-options>

<display-options-detail>
  <div id="display-options-detail" class="collapse panel panel-default">
    <div class="panel-body">
      <div data-is="display-options-limit"
        id="per_page-field"
        limit={ opts.limit }>
      </div>

      <div id="display_columns-field"
        data-is="display-options-columns"
        columns={ opts.columns }>
      </div>

      <div class="actions-bar actions-bar-bottom">
        <a href="#" id="reset-display-options" onclick={ resetColumns }>
          { trans('Reset defaults') }
        </a>
      </div>
    </div>
  </div>

  <script>
    resetColumns(e) {
      ListTop.resetColumns()
      ListTop.render()
    }
  </script>
</display-options-detail>

<display-options-limit>
  <div class="field-header">
    <label>{ trans('Show') }</label>
  </div>
  <div class="field-content">
    <select id="row"
      class="form-control"
      style="width: 100px;"
      ref="limit"
      value={ opts.limit }
      onchange={ changeLimit }
    >
      <option value="25">{ trans('25 rows') }</option>
      <option value="50">{ trans('50 rows') }</option>
      <option value="100">{ trans('100 rows') }</option>
      <option value="200">{ trans('200 rows') }</option>
    </select>
  </div>

  <script>
    changeLimit(e) {
      ListTop.limit = this.refs.limit.value
      ListTop.render()
    }
  </script>
</display-options-limit>

<display-options-columns>
  <div class="field-header">
    <label>{ trans('Column') }</label>
  </div>
  <div class="field-content">
    <ul id="disp_cols" class="list-inline">
      <virtual each={ column in opts.columns }>
        <li hide={ column.force_display }>
          <label>
            <input type="checkbox"
              id={ column.id }
              checked={ column.checked }
              onchange={ changeColumn }
            />
            { column.label }
          </label>
        </li>
        <li
          each={ subField in column.sub_fields }
          hide={ subField.force_display }
        >
          <label>
            <input type="checkbox"
              id={ subField.id }
              pid={ subField.parent_id }
              class={ subField.class }
              checked={ subField.checked }
              onchange={ changeSubField }
            />
            { subField.label }
          </label>
        </li>
      </virtual>
    </ul>
  </div>

  <script>
    changeColumn(e) {
      ListTop.updateColumn(e.target.id, e.target.checked)
      ListTop.render()
    }

    changeSubField(e) {
      ListTop.updateColumn(e.target.id, e.target.checked)
      ListTop.saveListPrefs()
    }
  </script>
</display-options-columns>

