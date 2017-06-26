<list-table>
  <thead data-is="list-table-header"
    store={ opts.store }
  >
  </thead>
  <tbody if={ opts.store.isLoading }>
    <tr>
      <td colspan={ opts.store.columns.length + 1 }>
        { trans('Loading...') }
      </td>
    </tr>
  </tbody>
  <tbody data-is="list-table-body"
    if={ !opts.store.isLoading && opts.store.objects }
    store={ opts.store }
    zero-state-label={ opts.zeroStateLabel }
  >
  </tbody>
</list-table>

<list-table-header>
  <tr>
    <th>
      <input type="checkbox"
        checked={ opts.store.checkedAllRowsOnPage }
        onchange={ toggleAllRowsOnPage } />
    </th>
    <th each={ opts.store.columns }
      if={ checked }
      data-id={ id }
      class={
        primary: primary,
        sortable: sortable,
        sorted: parent.opts.store.sortBy == id
      }
    >
      <a href="javascript:void(0)"
        if={ sortable }
        onclick={ toggleSortColumn }
      >
        { label }
      </a>
      <virtual if={ !sortable }>{ label }</virtual>
      <span class="caret"
        style="transform: scaleY(-1);"
        if={ sortable && (
          parent.opts.store.sortBy != id
          || parent.opts.store.sortOrder == 'ascend'
        ) }>
      </span>
      <span class="caret"
        if={ sortable && (
          parent.opts.store.sortBy != id
          || parent.opts.store.sortOrder == 'descend'
        ) }>
      </span>
    </th>
  </tr>

  <script>
    toggleAllRowsOnPage(e) {
      opts.store.trigger('toggle_all_rows_on_page')
    }

    toggleSortColumn(e) {
      const columnId = e.currentTarget.parentElement.dataset.id
      opts.store.trigger('toggle_sort_column', columnId)
    }
  </script>
</list-table-header>

<list-table-body>
  <tr if={ opts.store.objects.length == 0 }>
    <td colspan={ opts.store.columns.length + 1 }>
      { trans('No [_1] could be found.', opts.zeroStateLabel) }
    </td>
  </tr>
  <tr style="background-color: #ffffff;"
    if={ opts.store.pageMax > 1 && opts.store.checkedAllRowsOnPage && !opts.store.checkedAllRows }
  >
    <td colspan={ opts.store.objects.length + 1 }>
      <a href="javascript:void(0);" onclick={ checkAllRows }>
        { trans('Select all [_1] items', opts.store.count) }
      </a>
    </td>
  </tr>
  <tr class="success" if={ opts.store.pageMax > 1 && opts.store.checkedAllRows }>
    <td colspan={ opts.store.objects.length + 1 }>
      { trans('All [_1] items are selected', opts.store.count) }
    </td>
  </tr>
  <tr data-is="list-table-row"
    each={ obj, index in opts.store.objects }
    onclick={ parent.toggleRow }
    class={ obj.checked ? 'warning' : '' }
    data-index={ index }
    checked={ obj.checked }
    object={ obj.object }
    store={ parent.opts.store }
  >
  </tr>

  <script>
    toggleRow(e) {
      if (e.target.tagName == 'A') {
        return false
      }
      opts.store.trigger('toggle_row', e.currentTarget.dataset.index)
    }

    checkAllRows(e) {
      opts.store.trigger('check_all_rows')
    }
  </script>
</list-table-body>

<list-table-row>
  <td>
    <input type="checkbox"
      name="id"
      value={ opts.object[0] }
      checked={ opts.checked }>
  </td>
  <td data-is="list-table-column"
    each={ content, index in opts.object }
    if={ index > 0 }
    class={ (parent.opts.store.columns[0].id == 'id' && !parent.opts.store.columns[0].checked)
      ? parent.opts.store.columns[index+1].id
      : parent.opts.store.columns[index].id
    }
    content={ content }>
  </td>
</list-table-row>

<list-table-column>
  <virtual></virtual>

  <script>
    this.root.innerHTML = opts.content
  </script>
</list-table-column>
