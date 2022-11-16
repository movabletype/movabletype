<display-options>
  <div class="row">
    <div class="col-12">
      <button
        class="btn btn-default dropdown-toggle float-right"
        data-toggle="collapse"
        data-target="#display-options-detail"
        aria-expanded="false"
        aria-controls="display-options-detail"
      >
        { trans('Display Options') }
      </button>
    </div>
  </div>
  <div class="row">
    <div data-is="display-options-detail" class="col-12"></div>
  </div>

  <script>
    this.mixin('listTop')
  </script>
</display-options>

<display-options-detail>
  <div id="display-options-detail" class="collapse">
    <div class="card card-block p-3">
      <fieldset class="form-group">
        <div data-is="display-options-limit" id="per_page-field"></div>
      </fieldset>
      <fieldset class="form-group">
        <div data-is="display-options-columns" id="display_columns-field"></div>
      </fieldset>
      <div if={ !listTop.opts.disableUserDispOption }
        class="actions-bar actions-bar-bottom"
      >
        <a href="javascript:void(0);" id="reset-display-options" onclick={ resetColumns }>
          { trans('Reset defaults') }
        </a>
      </div>
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
      class="custom-select form-control"
      style="width: 100px;"
      ref="limit"
      value={ store.limit }
      onchange={ changeLimit }
    >
      <option value="10">{ trans('[_1] rows', 10) }</option>
      <option value="25">{ trans('[_1] rows', 25) }</option>
      <option value="50">{ trans('[_1] rows', 50) }</option>
      <option value="100">{ trans('[_1] rows', 100) }</option>
      <option value="200">{ trans('[_1] rows', 200) }</option>
    </select>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('displayOptions')
  </script>
</display-options-limit>

<display-options-columns>
  <div class="field-header">
    <label>{ trans('Column') }</label>
  </div>
  <div if={ listTop.opts.disableUserDispOption }
    class="alert alert-warning"
  >
    { trans('User Display Option is disabled now.') }
  </div>
  <div if={ !listTop.opts.disableUserDispOption }
    class="field-content"
  >
    <ul id="disp_cols" class="list-inline m-0">
      <virtual each={ column in store.columns }>
        <li hide={ column.force_display } class="list-inline-item">
          <div class="custom-control custom-checkbox">
            <input type="checkbox"
              class="custom-control-input"
              id={ column.id }
              checked={ column.checked }
              onchange={ toggleColumn }
              disabled={ store.isLoading }
            />
            <label class="custom-control-label" for={ column.id }>
              <raw content={ column.label }></raw>
            </label>
          </div>
        </li>
        <li
          each={ subField in column.sub_fields }
          hide={ subField.force_display }
          class="list-inline-item"
        >
          <div class="custom-control custom-checkbox">
            <input type="checkbox"
              id={ subField.id }
              pid={ subField.parent_id }
              class="custom-control-input { subField.class }"
              disabled={ disabled: !column.checked }
              checked={ subField.checked }
              onchange={ toggleSubField }
            />
            <label class="custom-control-label" for={ subField.id }>{ subField.label }</label>
          </div>
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
