;(function () {
  window.ListData = function ListData(args) {
    if (!args) {
      args = {};
    }

    this.columns = args.columns;
    this.showColumns = [];
    this.limit = args.limit;
    this.page = args.page || this.DefaultPage;
    this.sortBy = args.sortBy;
    this.sortOrder = args.sortOrder;

    this.filters = args.filters;
    this.currentFilter = args.currentFilter;
    this.allpassFilter = args.allpassFilter;

    this.objects = null;
    this.count = null;
    this.editableCount = null;
    this.pageMax = null;

    this.checkedAllRowsOnPage = false;
    this.checkedAllRows = false;

    this.isLoading = false;

    this.disableUserDispOption = args.disableUserDispOption;
  };

  ListData.prototype.DefaultPage = 1;

  ListData.prototype.addFilterItem = function (filterItem) {
    if (this.currentFilter.id == this.allpassFilter.id) {
      this.createNewFilter(trans('New Filter'));
    }
    this.currentFilter.items.push({ type: filterItem });
  };

  ListData.prototype.addFilterItemContent = function (itemIndex, contentIndex) {
    if (this.currentFilter.items[itemIndex].type != 'pack') {
      var items = [ this.currentFilter.items[itemIndex] ];
      this.currentFilter.items[itemIndex] = {
        type: 'pack',
        args: { op: 'and', items: items }
      };
    }
    var type = this.currentFilter.items[itemIndex].args.items[0].type;
    this.currentFilter.items[itemIndex].args.items.splice(
      contentIndex + 1,
      0,
      { type: type, args: {} }
    );
    this.currentFilter.items[itemIndex] = JSON.parse(
      JSON.stringify(this.currentFilter.items[itemIndex])
    );
  };

  ListData.prototype.checkAllRows = function () {
    var nextState = true;
    this.updateAllRowsOnPage(nextState);
    this.checkedAllRows = nextState;
  };

  ListData.prototype.clickRow = function (rowIndex) {
    var object = this.objects[rowIndex];
    if (!object.object[0]) {
      return;
    }
    object.clicked = true;
  };

  ListData.prototype.createNewFilter = function (filterLabel) {
    this.currentFilter = {
      items: [],
      label: trans( filterLabel || 'New Filter' )
    };
  };

  ListData.prototype.getCheckedRowCount = function () {
    if (this.checkedAllRows) {
      return this.count;
    } else {
      return this.objects.filter(function (object) {
        return object.checked;
      }).length;
    }
  };

  ListData.prototype.getColumn = function (columnId) {
    return this.columns.filter(function (column) {
      return column.id == columnId;
    })[0];
  };

  ListData.prototype.getCheckedColumnIds = function () {
    var columnIds = [];
    this.columns.forEach(function (column) {
      if (column.checked) {
        columnIds.push(column.id);
      }
      column.sub_fields.forEach(function (subField) {
        if (subField.checked) {
          columnIds.push(subField.id);
        }
      });
    });
    return columnIds;
  };

  ListData.prototype.getCheckedRowIds = function () {
    return this.objects.filter(function (object) {
      return object.checked;
    }).map(function (object) {
      return object.object[0];
    });
  };

  ListData.prototype.getFilter = function (filterId) {
    if (!filterId || !this.filters) {
      return;
    }
    var selectedFilters = this.filters.filter(function (filter) {
      return filter.id == filterId;
    });
    if (selectedFilters.length > 0) {
      return selectedFilters[0];
    } else {
      return null;
    }
  };

  ListData.prototype.getListEnd = function () {
    return (this.page - 1) * this.limit + this.objects.length;
  };

  ListData.prototype.getListStart = function () {
    return (this.page - 1) * this.limit + 1;
  };

  ListData.prototype.getMobileColumnIndex = function () {
    var mobileColumnIndex = -1;
    var hasMobileColumn = false;
    this.columns.some(function (column) {
      if (!column.checked) {
        return false;
      }
      mobileColumnIndex++;
      if (column.id == '__mobile') {
        hasMobileColumn = true;
        return true;
      }
    });
    return hasMobileColumn ? mobileColumnIndex : -1;
  };

  ListData.prototype.getNewFilterLabel = function (objectLabel) {
    var temp_base = 1;
    var temp;
    while ( 1 ) {
      temp = trans('[_1] - Filter [_2]', objectLabel, temp_base++);
      var hasSameLabel = this.filters.some(function (f) { return f.label == temp });
      if (!hasSameLabel) {
        break;
      }
    }
    return temp;
  };

  ListData.prototype.getSubField = function (subFieldId) {
    var returnSubField = null;
    this.columns.some(function (column) {
      return column.sub_fields.some(function (subField) {
        if (subField.id == subFieldId) {
          returnSubField = subField;
          return true;
        }
      });
    });
    return returnSubField;
  };

  ListData.prototype.hasMobileColumn = function () {
    return this.getMobileColumnIndex() > -1;
  };

  ListData.prototype.hasSystemFilter = function () {
    return this.filters.some(function (filter) {
      return filter.can_save == '0';
    });
  };

  ListData.prototype.isCheckedAllRowsOnPage = function () {
    return this.objects.every(function (object) {
      return object.checked;
    });
  };

  ListData.prototype.isFilterItemSelected = function (type) {
    return this.currentFilter.items.some(function (item) {
      return item.type == type;
    });
  };

  ListData.prototype.movePage = function (page) {
    var moved = page != this.page;
    if (page <= 1) {
      this.page = 1;
    } else if (page >= this.pageMax) {
      this.page = this.pageMax;
    } else {
      this.page = page;
    }
    return moved;
  };

  ListData.prototype.removeFilterItemByIndex = function (itemIndex) {
    this.currentFilter.items.splice(itemIndex, 1);
  };

  ListData.prototype.removeFilterItemContent = function (itemIndex, contentIndex) {
    this.currentFilter.items[itemIndex].args.items.splice(contentIndex, 1);
  };

  ListData.prototype.resetAllClickedRows = function () {
    this.objects.forEach(function (object) {
      object.clicked = false;
    });
  };

  ListData.prototype.setFilter = function (filter) {
    if (!filter) {
      return false;
    }
    var changed;
    if (filter == this.currentFilter) {
      changed = false;
    } else {
      this.currentFilter = filter;
      changed = true;
    }
    return changed;
  };

  ListData.prototype.setFilterById = function (filterId) {
    var filter;
    if (filterId == this.allpassFilter.id) {
      filter = this.allpassFilter;
    } else {
      filter = this.getFilter(filterId);
    }
    if (!filter) {
      return false;
    }
    this.setFilter(filter);
  };

  ListData.prototype.setDeleteFilterResult = function (result) {
    this.setFilterById(result.id);
    this.filters = result.filters;
  };

  ListData.prototype.setResult = function (result) {
    var resultColumnIds = result.columns.split(',');
    var showColumns = []
    this.columns.forEach(function (column) {
      column.checked = resultColumnIds.indexOf(column.id) >= 0;
      column.sub_fields.forEach(function (subField) {
        subField.checked = resultColumnIds.indexOf(subField.id) >= 0;
      });
      if(column.checked){
        showColumns.push(column);
      }
    });
    this.showColumns = showColumns;
    this.objects = result.objects.map(function (object) {
      return {
        checked: false,
        object: object
      };
    });
    this.count = result.count;
    this.editableCount = result.editable_count;
    this.pageMax = result.page_max;
    this.filters = result.filters;
    this.setFilterById(result.id);

    this.checkedAllRows = false;
    this.checkedAllRowsOnPage = false;
  };

  ListData.prototype.setSaveFilterResult = function (result) {
    this.filters = result.filters;
    this.setFilterById(this.currentFilter.id);
  };

  ListData.prototype.toggleAllRowsOnPage = function () {
    var nextState = !this.checkedAllRowsOnPage;
    this.updateAllRowsOnPage(nextState);
  };

  ListData.prototype.toggleColumn = function (columnId) {
    var column = this.getColumn(columnId);
    if (column) {
      column.checked = !column.checked;
    }
  };

  ListData.prototype.toggleRow = function (rowIndex) {
    var object = this.objects[rowIndex];
    if (!object.object[0]) {
      return;
    }
    var currentState = object.checked;
    object.checked = !currentState;

    this.checkedAllRowsOnPage = this.isCheckedAllRowsOnPage();
    this.checkedAllRows = false;
  };

  ListData.prototype.toggleSortColumn = function (columnId) {
    if (this.sortOrder && columnId == this.sortBy) {
      if (this.sortOrder == 'ascend') {
        this.sortOrder = 'descend';
      } else {
        this.sortOrder = 'ascend';
      }
    } else {
      this.sortBy = columnId;
      var column = this.getColumn(columnId);
      if (column) {
        this.sortOrder = column.default_sort_order || 'ascend';
      } else {
        this.sortOrder = 'ascend';
      }
    }
  };

  ListData.prototype.toggleSubField = function (subFieldId) {
    var subField = this.getSubField(subFieldId);
    if (subField) {
      subField.checked = !subField.checked;
    }
  };

  ListData.prototype.resetColumns = function () {
    this.columns.forEach(function (column) {
      column.checked = column.is_default;
      column.sub_fields.forEach(function (subField) {
        subField.checked = subField.is_default;
      });
    });
  };

  ListData.prototype.updateAllRowsOnPage = function (nextState) {
    this.objects.forEach(function (object) {
      if (object.object[0]) {
        object.checked = nextState;
      }
    });
    this.checkedAllRowsOnPage = nextState;
    this.checkedAllRows = false;
  };

  ListData.prototype.updateIsLoading = function (nextState) {
    this.isLoading = nextState;
  };

  ListData.prototype.updateLimit = function (limit) {
    this.limit = limit;
  }
})();
