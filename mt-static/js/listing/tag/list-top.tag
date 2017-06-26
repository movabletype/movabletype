<list-top>
  <div data-is="display-options" store={ opts.store }></div>
  <div class="row">
    <div data-is="list-actions"
      class="col-md-12"
      if={ opts.useActions }
      button-actions={ opts.buttonActions }
      has-list-actions={ opts.hasListActions }
      has-pulldown-actions={ opts.hasPulldownActions }
      list-action-client={ opts.listActionClient }
      list-actions={ opts.listActions }
      more-list-actions={ opts.moreListActions }
      plural={ opts.plural }
      singular={ opts.singular }
      store={ opts.store }
    >
    </div>
  </div>
  <div class="row" hide={ opts.store.isLoading }>
    <div data-is="list-pagination"
      class="col-md-12 text-center"
      store={ opts.store }
    >
    </div>
  </div>
  <div class="row">
    <div class="col-md-12">
      <table data-is="list-table"
        id="listing"
        class="table table-striped table-hover"
        store={ opts.store }
        zero-state-label={ opts.zeroStateLabel }
      >
      </table>
    </div>
  </div>

  <script>
    const self = this

    opts.store.on('refresh_view', () => {
      self.update()
      self.updateSubFields()
    })

    this.on('mount', () => {
      this.opts.store.trigger('load_list')
    })

    updateSubFields() {
      opts.store.columns.forEach((column) => {
        column.sub_fields.forEach((subField) => {
          const selector = `td.${subField.parent_id} .${subField.class}`
          if (subField.checked) {
            $(selector).show()
          } else {
            $(selector).hide()
          }
        })
      })
    }
  </script>
</list-top>
