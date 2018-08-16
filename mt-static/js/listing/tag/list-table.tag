<list-table>
  <thead data-is="list-table-header"></thead>
  <tbody if={ store.isLoading }>
    <tr>
      <td colspan={ store.columns.length + 1 }>
        { trans('Loading...') }
      </td>
    </tr>
  </tbody>
  <tbody data-is="list-table-body" if={ !store.isLoading && store.objects }>
  </tbody>

  <script>
    this.mixin('listTop')
  </script>
</list-table>

<list-table-header>
  <virtual data-is="list-table-header-for-pc"></virtual>
  <virtual data-is="list-table-header-for-mobile"></virtual>

  <script>
    this.mixin('listTop')
    riot.mixin('listTableHeader', {
      toggleAllRowsOnPage: function (e) {
        this.store.trigger('toggle_all_rows_on_page')
      },
      toggleSortColumn: function (e) {
        var columnId = e.currentTarget.parentElement.dataset.id
        this.store.trigger('toggle_sort_column', columnId)
      }
    })
  </script>
</list-table-header>

<list-table-header-for-pc>
  <tr class="d-none d-md-table-row">
    <th if={ listTop.opts.hasListActions }
      class="mt-table__control"
    >
      <div class="custom-control custom-checkbox">
        <input type="checkbox"
          class="custom-control-input"
          id="select-all"
          checked={ store.checkedAllRowsOnPage }
          onchange={ toggleAllRowsOnPage } />
        <label class="custom-control-label" for="select-all"><span class="sr-only">{ trans('Select All') }</span></label>
      </div>
    </th>
    <th each={ store.columns }
      scope="col"
      if={ checked && id != '__mobile' }
      class={
        primary: primary,
        sortable: sortable,
        sorted: parent.store.sortBy == id
      }
    >
      <a href="javascript:void(0)"
        if={ sortable }
        onclick={ toggleSortColumn }
        class={
          mt-table__ascend: sortable && parent.store.sortBy == id && parent.store.sortOrder == 'ascend',
          mt-table__descend: sortable && parent.store.sortBy == id && parent.store.sortOrder == 'descend'
        }
      >
        <raw content={ label }></raw>
      </a>
      <raw if={ !sortable } content={ label }></raw>
    </th>
  </tr>

  <script>
    this.mixin('listTop')
    this.mixin('listTableHeader')
  </script>
</list-table-header-for-pc>

<list-table-header-for-mobile>
  <tr if={ store.count }
    class="d-md-none"
  >
    <th if={ listTop.opts.hasMobilePulldownActions }
      class="mt-table__control"
    >
      <div class="custom-control custom-checkbox">
        <input type="checkbox"
          class="custom-control-input"
          id="select-all"
          checked={ store.checkedAllRowsOnPage }
          onchange={ toggleAllRowsOnPage } />
        <label class="custom-control-label" for="select-all"><span class="sr-only">{ trans('Select All') }</span></label>
      </div>
    </th>
    <th scope="col">
      <span if={ listTop.opts.hasMobilePulldownActions }
        onclick={ toggleAllRowsOnPage }
      >
        { trans('All') }
      </span>
      <span class="float-right">
        { trans('[_1] &ndash; [_2] of [_3]', store.getListStart(), store.getListEnd(), store.count) }
      </span>
    </th>
  </tr>

  <script>
    this.mixin('listTop')
    this.mixin('listTableHeader')
  </script>
</list-table-header-for-mobile>

<list-table-body>
  <tr if={ store.objects.length == 0 }>
    <td colspan={ store.columns.length + 1 }>
      { trans('No [_1] could be found.', listTop.opts.zeroStateLabel) }
    </td>
  </tr>
  <tr style="background-color: #ffffff;"
    if={ store.pageMax > 1 && store.checkedAllRowsOnPage && !store.checkedAllRows }
  >
    <td colspan={ store.objects.length + 1 }>
      <a href="javascript:void(0);" onclick={ checkAllRows }>
        { trans('Select all [_1] items', store.count) }
      </a>
    </td>
  </tr>
  <tr class="success" if={ store.pageMax > 1 && store.checkedAllRows }>
    <td colspan={ store.objects.length + 1 }>
      { trans('All [_1] items are selected', store.count) }
    </td>
  </tr>
  <tr data-is="list-table-row"
    each={ obj, index in store.objects }
    onclick={ parent.toggleRow }
    class={ obj.checked ? 'mt-table__highlight' : '' }
    data-index={ index }
    checked={ obj.checked }
    object={ obj.object }
  >
  </tr>

  <script>
    this.mixin('listTop')

    toggleRow(e) {
      if (e.target.tagName == 'A' || e.target.tagName == 'IMG' || e.target.tagName == 'svg') {
        return false
      }
      if (this.listTop.isMobileView() && e.target.dataset.is) {
        return false
      }
      e.preventDefault()
      e.stopPropagation()
      this.store.trigger('toggle_row', e.currentTarget.dataset.index)
    }

    checkAllRows(e) {
      this.store.trigger('check_all_rows')
    }
  </script>
</list-table-body>

<list-table-row>
  <td if={ listTop.opts.hasListActions }
    class={
      d-none: !listTop.opts.hasMobilePulldownActions,
      d-md-table-cell: !listTop.opts.hasMobilePulldownActions
    }
  >
    <div class="custom-control custom-checkbox" if={ opts.object[0] }>
      <input type="checkbox"
        name="id"
        class="custom-control-input"
        id={ 'select_' + opts.object[0] }
        value={ opts.object[0] }
        checked={ opts.checked }>
      <span class="custom-control-indicator"></span>
      <label class="custom-control-label" for={ 'select_' + opts.object[0] }><span class="sr-only">{ trans('Select') }</span></label>
    </div>
  </td>
  <td data-is="list-table-column"
    each={ content, index in opts.object }
    if={ index > 0 }
    class={ classes(index) }
    content={ content }>
  </td>

  <script>
    this.mixin('listTop')

    classes(index) {
      var columnIndex = this.columnIndex(index)
      var nameClass = this.store.columns[columnIndex].id
      var classes
      if (this.store.hasMobileColumn()) {
        if (this.store.getMobileColumnIndex() == index) {
          classes = 'd-md-none'
        } else {
          classes = 'd-none d-md-table-cell'
        }
      } else {
        if (this.store.columns[columnIndex].primary) {
          classes = ''
        } else {
          classes = 'd-none d-md-table-cell'
        }
      }
      if (classes.length > 0) {
        return nameClass + ' ' + classes
      } else {
        return nameClass
      }
    }
    columnIndex(index) {
      if (this.store.columns[0].id == 'id' && !this.store.columns[0].checked) {
        return index + 1
      } else {
        return index
      }
    }
  </script>
</list-table-row>

<list-table-column>
  <virtual></virtual>

  <script>
    this.root.innerHTML = opts.content
  </script>
</list-table-column>
