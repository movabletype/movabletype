<list-table>
  <thead data-is="list-table-header"
    checked-all-object-on-page={ opts.checkedAllObjectOnPage }
    checked-all-object={ opts.checkedAllObject }
    columns={ opts.columns }
    sort-by={ opts.sortBy }
    sort-order={ opts.sortOrder }
  >
  </thead>
  <tbody data-is="list-table-body"
    checked-all-object-on-page={ opts.checkedAllObjectOnPage }
    checked-all-object={ opts.checkedAllObject }
    columns={ opts.columns }
    count={ opts.count }
    objects={ opts.objects }
    zero-state-label={ opts.zeroStateLabel }
  >
  </tbody>
</list-table>

<list-table-header>
  <tr>
    <th>
      <input type="checkbox"
        checked={ opts.checkedAllObjectOnPage }
        onchange={ toggleCheckboxes } />
    </th>
    <th each={ opts.columns }
      if={ checked }
      data-id={ id }
      class={
        primary: primary,
        sortable: sortable,
        sorted: parent.opts.sortBy == id
      }
    >
      <a href="javascript:void(0)"
        if={ sortable }
        onclick={ changeSort }
      >
        { label }
      </a>
      <virtual if={ !sortable }>{ label }</virtual>
      <span class="caret"
        style="transform: scaleY(-1);"
        if={ sortable && ( parent.opts.sortBy != id || parent.opts.sortOrder == 'ascend') }>
      </span>
      <span class="caret"
        if={ sortable && ( parent.opts.sortBy != id || parent.opts.sortOrder == 'descend') }>
      </span>
    </th>
  </tr>

  <script>
    changeSort(e) {
      ListTop.changeSort(e.target.parentElement.dataset.id)
      ListTop.render()
    }

    toggleCheckboxes(e) {
      ListTop.updateAllObjectChecked(e.target.checked)
    }
  </script>
</list-table-header>

<list-table-body>
  <tr if={ opts.objects.length == 0 }>
    <td colspan={ opts.columns.length + 1 }>
      { trans('No [_1] could be found.', opts.zeroStateLabel) }
    </td>
  </tr>
  <tr style="background-color: #ffffff;"
    if={ opts.checkedAllObjectOnPage && !opts.checkedAllObject }
  >
    <td colspan={ opts.objects.length + 1 }>
      <a href="#" onclick={ checkAllObject }>
        { trans('Select all [_1] items', opts.count) }
      </a>
    </td>
  </tr>
  <tr class="success" if={ opts.checkedAllObject }>
    <td colspan={ opts.objects.length + 1 }>
      { trans('All [_1] items are selected', opts.count) }
    </td>
  </tr>
  <tr data-is="list-table-row"
    each={ obj, index in opts.objects }
    class={ obj.checked ? 'warning' : '' }
    data-index={ index }
    columns={ parent.opts.columns }
    checked={ obj.checked }
    object={ obj.object }
    onclick={ parent.toggleCheckbox }>
  </tr>

  <script>
    toggleCheckbox(e) {
      if (e.target.tagName == 'A') {
        return
      }
      const index = $(e.target).parents('tr').data('index')
      ListTop.toggleObjectChecked(index)
    }

    checkAllObject(e) {
      ListTop.checkAllObject()
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
    class={ parent.opts.columns[0].id == 'id' ? parent.opts.columns[index+1].id : parent.opts.columns[index].id }
    content={ content }>
  </td>
</list-table-row>

<list-table-column>
  <virtual></virtual>

  <script>
    this.root.innerHTML = opts.content
  </script>
</list-table-column>

