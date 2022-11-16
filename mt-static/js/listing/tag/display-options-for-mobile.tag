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
          <option value="10">{ trans('[_1] rows', 10) }</option>
          <option value="25">{ trans('[_1] rows', 25) }</option>
          <option value="50">{ trans('[_1] rows', 50) }</option>
          <option value="100">{ trans('[_1] rows', 100) }</option>
          <option value="200">{ trans('[_1] rows', 200) }</option>
        </select>
      </div>
    </div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('displayOptions')
  </script>
</display-options-for-mobile>