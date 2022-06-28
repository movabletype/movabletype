<display-options-for-mobile>
  <div class="row d-md-none">
    <div class="col-auto mx-auto">
      <div class="form-inline">
        <label for="row-for-mobile">{ trans('Show') + ':' }</label>
        <select id="row-for-mobile"
          class="custom-select form-control"
          ref="limit"
          value={ store.limit }
          onchange={ changeLimit }
        >
          <option each={ val in store.rowsOptions } value="{ val }" selected={store.limit==val}>{ trans('[_1] rows', val) }</option>
        </select>
      </div>
    </div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('displayOptions')
  </script>
</display-options-for-mobile>