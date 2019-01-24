;(function (globalWindow, $) {
  globalWindow.ListClient = function ListClient(args) {
    if (!args) {
      args = {};
    }
    this.url = args.url;
    this.siteId = args.siteId || 0;
    this.datasource = args.datasource;
    this.objectType = args.objectType;
    this.magicToken = args.magicToken;
    this.returnArgs = args.returnArgs;
  };

  ListClient.prototype.sendRequest = function (args, data) {
    var url = this.url;
    var settings = {
      type: 'POST',
      contentType: 'application/x-www-form-urlencoded; charset=utf-8',
      data: data,
      dataType: 'json'
    };
    $.ajax(url, settings)
      .done(args.done)
      .fail(function (xhr, status, error) {
        if (xhr.status == 401) {
          loginAgain(function () {
            $.ajax(url, settings);
          });
        }
      })
      .always(args.always);
  };

  ListClient.prototype.deleteFilter = function (args) {
    if (!args) {
      args = {};
    }
    var data = {
      __mode: 'delete_filter',
      blog_id: this.siteId,
      datasource: this.datasource,
      id: args.id,
      magic_token: this.magicToken,
      not_encode_result: 1
    };
    if (args.changed) {
      data = $.extend(data, {
        columns: serializeColumns(args.columns),
        limit: args.limit,
        page: args.page,
        sort_by: args.sortBy,
        sort_order: args.sortOrder
      });
      if (args.filter.id) {
        data.fid = args.filter.id;
      }
    } else {
      data.list = 0;
    }
    this.sendRequest(args, data);
  };

  ListClient.prototype.filteredList = function (args) {
    if (!args) {
      args = {};
    }
    var data = {
      __mode: 'filtered_list',
      blog_id: this.siteId,
      columns: serializeColumns(args.columns),
      datasource: this.datasource,
      items: JSON.stringify(args.filter.items),
      limit: args.limit,
      magic_token: this.magicToken,
      page: args.page,
      sort_by: args.sortBy,
      sort_order: args.sortOrder
    };
    if (args.filter.id && !args.noFilterId) {
      data.fid = args.filter.id;
    }
    this.sendRequest(args, data);
  };

  ListClient.prototype.renameFilter = function (args) {
    if (!args) {
      args = {};
    }
    var data = {
      __mode: 'save_filter',
      blog_id: this.siteId,
      datasource: this.datasource,
      items: JSON.stringify(args.filter.items),
      label: args.filter.label,
      list: 0,
      magic_token: this.magicToken,
      not_encode_result: 1
    };
    if (args.filter.id) {
      data.fid = args.filter.id;
    }
    this.sendRequest(args, data);
  };

  ListClient.prototype.saveFilter = function (args) {
    if (!args) {
      args = {};
    }
    var data = {
      __mode: 'save_filter',
      blog_id: this.siteId,
      columns: serializeColumns(args.columns),
      datasource: this.datasource,
      label: args.filter.label,
      items: JSON.stringify(args.filter.items),
      limit: args.limit,
      magic_token: this.magicToken,
      not_encode_result: 1,
      page: args.page,
      sort_by: args.sortBy,
      sort_order: args.sortOrder
    };
    if (args.filter.id) {
      data.fid = args.filter.id;
    }
    this.sendRequest(args, data);
  };

  ListClient.prototype.saveListPrefs = function (args) {
    if (!args) {
      args = {};
    }
    var data = {
      __mode: 'save_list_prefs',
      blog_id: this.siteId,
      columns: serializeColumns(args.columns),
      datasource: this.datasource,
      limit: args.limit
    };
    this.sendRequest(args, data);
  };

  function serializeColumns(columns) {
    if (Array.isArray(columns)) {
      return columns.join(',');
    } else {
      return columns;
    }
  }
})(window, jQuery);
