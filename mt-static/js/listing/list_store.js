;(function () {
  window.ListStore = function ListStore(args) {
    ListData.call(this, args);

    riot.observable(this);

    this.listClient = args.listClient;

    this.initializeTriggers();
  };

  ListStore.prototype = Object.create(new ListData());

  ListStore.prototype.initializeTriggers = function () {
    this.on('add_filter_item', function (filterItem) {
      this.addFilterItem(filterItem);
      this.trigger('refresh_view');
    });

    this.on('apply_filter', function (filter, noFilterId) {
      this.setFilter(filter);
      var refreshCurrentFilter = true;
      this.loadList({
        refreshCurrentFilter: refreshCurrentFilter,
        noFilterId: noFilterId
      });
    });

    this.on('apply_filter_by_id', function (filterId) {
      this.setFilterById(filterId);
      var refreshCurrentFilter = true;
      this.loadList({
        refreshCurrentFilter: refreshCurrentFilter
      });
    });

    this.on('check_all_rows', function () {
      this.checkAllRows()
      this.trigger('refresh_view');
    });

    this.on('click_row', function (rowIndex) {
      this.clickRow(rowIndex);
      this.trigger('refresh_view');
    });

    this.on('create_new_filter', function () {
      this.createNewFilter();
      this.trigger('refresh_view');
    });

    this.on('load_list', function () {
      this.loadList();
    });

    this.on('move_page', function (page, moveToPagination) {
      var moved = this.movePage(page);
      if (moved) {
        this.loadList({
          moveToPagination: moveToPagination
        });
      } else {
        this.trigger('refresh_view');
      }
    });

    this.on('remove_filter_by_id', function (filterId) {
      this.deleteFilter(filterId)
    });

    this.on('rename_filter_by_id', function (filterId, filterLabel) {
      this.renameFilter(filterId, filterLabel);
    });

    this.on('reset_all_clicked_rows', function () {
      this.resetAllClickedRows();
      this.trigger('refresh_view');
    });

    this.on('reset_columns', function () {
      this.resetColumns();
      this.loadList();
    });

    this.on('reset_filter', function () {
      this.trigger('apply_filter', this.allpassFilter);
    });

    this.on('save_filter', function (filter) {
      this.setFilter(filter);
      this.saveFilter();
    });

    this.on('toggle_all_rows_on_page', function () {
      this.toggleAllRowsOnPage();
      this.trigger('refresh_view');
    });

    this.on('toggle_column', function (columnId) {
      this.toggleColumn(columnId);
      this.loadList();
    });

    this.on('toggle_row', function (rowIndex) {
      this.toggleRow(rowIndex);
      this.trigger('refresh_view');
    });

    this.on('toggle_sort_column', function (columnId) {
      this.toggleSortColumn(columnId);
      this.movePage(1);
      this.loadList();
    });

    this.on('toggle_sub_field', function (subFieldId) {
      this.toggleSubField(subFieldId);
      this.saveListPrefs();
    });

    this.on('update_limit', function (limit) {
      this.updateLimit(limit);
      this.movePage(1);
      this.loadList();
    });
  };

  ListStore.prototype.deleteFilter = function (filterId) {
    var self = this;
    if (this.currentFilter.id == filterId) {
      this.setFilter(this.allpassFilter);
      this.updateIsLoading(true);
      this.trigger('refresh_view');

      this.listClient.deleteFilter({
        changed: true,
        id: filterId,
        columns: self.getCheckedColumnIds(),
        filter: self.currentFilter,
        limit: self.limit,
        page: self.page,
        sortBy: self.sortBy,
        sortOrder: self.sortOrder,
        done: function (data, textStatus, jqXHR) {
          if (data && !data.error) {
            self.setResult(data.result);
          } else if (data.error) {
            alert(data.error);
          }
        },
        always: function () {
          self.updateIsLoading(false);
          self.trigger('refresh_current_filter')
          self.trigger('refresh_view');
        }
      });
    } else {
      this.listClient.deleteFilter({
        changed: false,
        id: filterId,
        done: function (data, textStatus, jqXHR) {
          if (data && !data.error) {
            self.setDeleteFilterResult(data.result);
          } else if (data.error) {
            alert(data.error);
          }
        },
        always: function () {
          self.trigger('refresh_view');
        }
      });
    }
  };

  ListStore.prototype.loadList = function (args) {
    if (!args) {
      args = {};
    }
    var refreshCurrentFilter = args.refreshCurrentFilter;
    var noFilterId           = args.noFilterId;
    var moveToPagination     = args.moveToPagination;

    if (!this.sortOrder) {
      this.toggleSortColumn(this.sortBy);
    }

    if (this.disableUserDispOption) {
      this.resetColumns();
    }

    this.updateIsLoading(true);
    this.trigger('refresh_view', { notCallListReady: true });

    var self = this;

    this.listClient.filteredList({
      columns: self.getCheckedColumnIds(),
      filter: self.currentFilter,
      limit: self.limit,
      noFilterId: noFilterId,
      page: self.page,
      sortBy: self.sortBy,
      sortOrder: self.sortOrder,
      done: function (data, textStatus, jqXHR) {
        if (data && !data.error) {
          self.setResult(data.result);
        } else if (data.error) {
          alert(data.error);
          self.objects = [];
        }
      },
      always: function () {
        self.updateIsLoading(false);
        if (refreshCurrentFilter) {
          self.trigger('refresh_current_filter')
        }
        self.trigger('refresh_view', { moveToPagination: moveToPagination });
      },
    });
  };

  ListStore.prototype.renameFilter = function (filterId, filterLabel) {
    var filter = this.getFilter(filterId);
    if (!filter) {
      return;
    }
    var orgLabel = filter.label;
    filter.label = filterLabel;

    var self = this;
    this.listClient.renameFilter({
      filter: filter,
      done: function (data, textStatus, jqXHR) {
        if (data && !data.error) {
          self.setSaveFilterResult(data.result);
        } else if (data.error) {
          alert(data.error);
          filter.label = orgLabel;
        }
      },
      always: function () {
        self.trigger('refresh_view');
      }
    });
  };

  ListStore.prototype.saveFilter = function () {
    var self = this;
    this.listClient.saveFilter({
      columns: self.getCheckedColumnIds(),
      filter: self.currentFilter,
      limit: self.limit,
      page: self.page,
      sortBy: self.sortBy,
      sortOrder: self.sortOrder,
      done: function (data, textStatus, jqXHR) {
        if (data && !data.error) {
          self.setResult(data.result);
        } else if (data.error) {
          alert(data.error);
        }
      },
      always: function () {
        self.trigger('refresh_current_filter')
        self.trigger('refresh_view')
      }
    });
  };

  ListStore.prototype.saveListPrefs = function () {
    var self = this;
    this.listClient.saveListPrefs({
      columns: self.getCheckedColumnIds(),
      limit: self.limit,
      done: function (data, textStatus, jqXHR) {},
      always: function () {
        self.trigger('refresh_view');
      }
    });
  };
})();
