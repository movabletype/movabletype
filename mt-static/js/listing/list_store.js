;(function () {
  window.ListStore = function ListStore(args) {
    ListData.call(this, args);

    riot.observable(this);

    this.listClient = args.listClient;

    this.initializeTriggers();
  };

  ListStore.prototype = Object.create(new ListData());

  ListStore.prototype.initializeTriggers = function () {
    this.on('check_all_rows', function () {
      this.checkAllRows()
      this.trigger('refresh_view');
    })

    this.on('load_list', function () {
      this.loadList();
    });

    this.on('move_page', function (page) {
      var moved = this.movePage(page);
      if (moved) {
        this.loadList();
      } else {
        this.trigger('refresh_view');
      }
    });

    this.on('toggle_all_rows_on_page', function () {
      this.toggleAllRowsOnPage();
      this.trigger('refresh_view');
    });

    this.on('toggle_column', function (columnId) {
      this.toggleColumn(columnId);
      this.loadList();
    });

    this.on('reset_columns', function () {
      this.resetColumns();
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

  ListStore.prototype.loadList = function () {
    if (!this.sortOrder) {
      this.toggleSortColumn(this.sortBy);
    }

    this.updateIsLoading(true);
    this.trigger('refresh_view');

    var self = this;

    this.listClient.filteredList({
      columns: self.getCheckedColumnIds(),
      fid: self.fid,
      limit: self.limit,
      page: self.page,
      sortBy: self.sortBy,
      sortOrder: self.sortOrder,
      success: function (data, textStatus, jqXHR) {
        if (data && !data.error) {
          self.setResult(data.result);
        }
      },
      fail: function (jqXHR, textStatus) {},
      always: function () {
        self.updateIsLoading(false);
        self.trigger('refresh_view');
      },
    });
  };

  ListStore.prototype.saveListPrefs = function () {
    var self = this;
    this.listClient.saveListPrefs({
      columns: self.getCheckedColumnIds(),
      limit: self.limit,
      success: function (data, textStatus, jqXHR) {},
      fail: function (jqXHR, textStatus) {},
      always: function () {
        self.trigger('refresh_view');
      }
    });
  };
})();
