<list-top>
  <div data-is="display-options" columns={ columns } limit={ limit }></div>
  <yield/>
  <div class="row">
    <div class="col-md-12">
      <table data-is="list-table"
        id="listing"
        class="table table-striped table-hover"
        checked-all-object-on-page={ checkedAllObjectOnPage }
        checked-all-object={ checkedAllObject }
        columns={ columns }
        count={ count }
        objects={ objects }
        sort-by={ sortBy }
        sort-order={ sortOrder }
        zero-state-label={ zeroStateLabel }
        >
      </table>
    </div>
  </div>

  <script>
    window.ListTop = this

    this.listClient = opts.listClient
    this.zeroStateLabel = opts.zeroStateLabel

    this.columns = opts.columns
    this.limit = opts.limit || 50
    this.page = opts.page || 1
    this.sortBy = opts.sortBy
    this.sortOrder = opts.sortOrder
    this.fid = opts.fid || '_allpass'

    this.objects = []
    this.count = 0
    this.editableCount = 0
    this.pageMax = 0
    this.filters = []

    this.checkedAllObjectOnPage = false
    this.checkedAllObject = false

    this.on('mount', () => {
      this.render()
    })

    render() {
      if (!this.sortOrder) {
        this.changeSort(this.sortBy)
      }

      const self = this
      this.listClient.sendRequest({
        columns: this.getCheckedColumnIds(),
        limit: this.limit,
        page: this.page,
        sortBy: this.sortBy,
        sortOrder: this.sortOrder,
        fid: this.fid,
        success: (data, textStatus, jqXHR) => {
          if (data && !data.error) {
            self.setData(data.result)
          }
        },
        fail: (jsXHR, textStatus) => {
        },
        always: () => {
          self.update()
          self.updateSubFields()
        }
      })
    }

    saveListPrefs() {
      const self = this
      this.listClient.saveListPrefs({
        columns: this.getCheckedColumnIds(),
        limit: this.limit,
        succuss: () => {
        },
        fail: () => {
        },
        always: () => {
          self.update()
          self.updateSubFields()
        },
      })
    }

    updateSubFields() {
      this.columns.forEach((column) => {
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

    toggleObjectChecked(index) {
      const before = this.objects[index].checked
      this.objects[index].checked = !before

      this.checkedAllObjectOnPage = this.isCheckedAllObjectOnPage()
      this.checkedAllObject = false

      this.update()
    }

    isCheckedAllObjectOnPage() {
      let allChecked = true
      this.objects.forEach((object) => {
        if (!object.checked) {
          allChecked = false
          return false
        }
      })
      return allChecked
    }

    updateAllObjectChecked(checked) {
      this.checkedAllObject = false
      this.objects.forEach((object) => {
        object.checked = checked
      })
      this.checkedAllObjectOnPage = checked
      this.update()
    }

    checkAllObject() {
      this.updateAllObjectChecked(true)
      this.checkedAllObject = true
      this.update()
    }

    changeSort(id) {
      if (this.sortOrder && id == this.sortBy) {
        if (this.sortOrder == 'ascend') {
          this.sortOrder = 'descend'
        } else {
          this.sortOrder = 'ascend'
        }
      } else {
        this.sortBy = id
        const column = this.getColumn(id)
        if (column) {
          this.sortOrder = column.default_sort_order || 'ascend'
        } else {
          this.sortOrder = 'ascend'
        }
      }
    }

    getColumn(id) {
      let column = null
      this.columns.forEach((col) => {
        if (col.id == id) {
          column = col
          return false
        }
      })
      return column
    }

    getCheckedColumnIds() {
      var ids = []
      this.columns.forEach((column) => {
        if (column.checked) {
          ids.push(column.id)
        }
        column.sub_fields.forEach((subField) => {
          if (subField.checked) {
            ids.push(subField.id)
          }
        })
      })
      return ids
    }

    updateColumn(id, checked) {
      this.columns.forEach((column) => {
        if (column.id == id) {
          column.checked = checked
        }
        column.sub_fields.forEach((subField) => {
          if (subField.id == id) {
            subField.checked = checked
          }
        })
      })
    }

    resetColumns() {
      this.columns.forEach((column) => {
        column.checked = column.is_default
        column.sub_fields.forEach((subField) => {
          subField.checked = subField.is_default
        })
      })
    }

    setData(result) {
      const resultColumnIds = result.columns.split(',')
      this.columns.forEach((column) => {
        column.checked = resultColumnIds.indexOf(column.id) >= 0
        column.sub_fields.forEach((subField) => {
          subField.checked = resultColumnIds.indexOf(subField.id) >= 0
        })
      })

      this.objects = []
      result.objects.forEach((object) => {
        this.objects.push({
          checked: false,
          object: object
        })
      })
      this.count = result.count
      this.editableCount = result.editable_count
      this.pageMax = result.page_max
      this.filters = result.filters
    }
  </script>
</list-top>

