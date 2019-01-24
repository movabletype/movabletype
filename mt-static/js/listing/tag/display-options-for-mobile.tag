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
          <option value="25">{ trans('25 rows') }</option>
          <option value="50">{ trans('50 rows') }</option>
          <option value="100">{ trans('100 rows') }</option>
          <option value="200">{ trans('200 rows') }</option>
        </select>
      </div>
    </div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('displayOptions')
  </script>
</display-options-for-mobile>