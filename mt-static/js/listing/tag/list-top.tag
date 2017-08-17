<list-top>
  <div data-is="display-options"></div>
  <div class="row">
    <div data-is="list-actions" if={ opts.useActions } class="col-md-12">
    </div>
  </div>
  <div class="row" hide={ opts.store.count == 0 }>
    <div data-is="list-pagination" class="col-md-12 text-center"></div>
  </div>
  <div class="row">
    <div class="col-md-12">
      <div class="card">
        <virtual data-is="list-filter"></virtual>
        <table data-is="list-table"
          id="{ opts.objectType }-table"
          class="table mt-table list-{ opts.objectType }"
        >
        </table>
      </div>
    </div>
  </div>

  <script>
    riot.mixin('listTop', {
      init: function () {
        if (this.__.tagName == 'list-top') {
          this.listTop = this
          this.store = opts.store
        } else {
          this.listTop = this.parent.listTop
          this.store = this.parent.store
        }
      }
    })
    this.mixin('listTop')

    const self = this

    opts.store.on('refresh_view', function () {
      self.update()
      self.updateSubFields()
    })

    this.on('mount', function () {
      this.opts.store.trigger('load_list')
    })

    updateSubFields() {
      opts.store.columns.forEach((column) => {
        column.sub_fields.forEach((subField) => {
          const selector = `td.${subField.parent_id} .${subField.class}`
          if (subField.checked) {
            jQuery(selector).show()
          } else {
            jQuery(selector).hide()
          }
        })
      })
    }
  </script>
</list-top>
