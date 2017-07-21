<display-options>
  <div class="row">
    <div class="col-md-12">
      <button
        class="btn btn-default dropdown-toggle float-right"
        data-toggle="collapse"
        data-target="#display-options-detail"
      >
        { trans('Display Options') }
      </button>
    </div>
  </div>
  <div class="row">
    <div data-is="display-options-detail" class="col-md-12"></div>
  </div>

  <script>
    this.mixin('listTop')
  </script>
</display-options>

<display-options-detail>
  <div id="display-options-detail" class="collapse">
    <div class="card card-block">
      <div data-is="display-options-limit" id="per_page-field"></div>
      <virtual if={ !listTop.opts.disableUserDispOption }>
        <div data-is="display-options-columns" id="display_columns-field"></div>
        <div class="actions-bar actions-bar-bottom">
          <a href="javascript:void(0);" id="reset-display-options" onclick={ resetColumns }>
            { trans('Reset defaults') }
          </a>
        </div>
      </virtual>
    </div>
  </div>

  <script>
    this.mixin('listTop')

    resetColumns(e) {
      this.store.trigger('reset_columns')
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
      value={ store.limit }
      onchange={ changeLimit }
    >
      <option value="25">{ trans('25 rows') }</option>
      <option value="50">{ trans('50 rows') }</option>
      <option value="100">{ trans('100 rows') }</option>
      <option value="200">{ trans('200 rows') }</option>
    </select>
  </div>

  <script>
    this.mixin('listTop')

    changeLimit(e) {
      this.store.trigger('update_limit', this.refs.limit.value)
    }
  </script>
</display-options-limit>

<display-options-columns>
  <div class="field-header">
    <label>{ trans('Column') }</label>
  </div>
  <div class="field-content">
    <ul id="disp_cols" class="list-inline">
      <virtual each={ column in store.columns }>
        <li hide={ column.force_display } class="list-inline-item">
          <label>
            <input type="checkbox"
              id={ column.id }
              checked={ column.checked }
              onchange={ toggleColumn }
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
              onchange={ toggleSubField }
            />
            { subField.label }
          </label>
        </li>
      </virtual>
    </ul>
  </div>

  <script>
    this.mixin('listTop')

    toggleColumn(e) {
      this.store.trigger('toggle_column', e.currentTarget.id)
    }

    toggleSubField(e) {
      this.store.trigger('toggle_sub_field', e.currentTarget.id)
    }
  </script>
</display-options-columns>
