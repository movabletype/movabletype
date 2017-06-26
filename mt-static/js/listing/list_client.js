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

  ListClient.prototype.filteredList = function (args) {
    if (!args) {
      args = {};
    }
    $.ajax(this.url, {
      type: 'POST',
      contentType: 'application/x-www-form-urlencoded; charset=utf-8',
      data: this.generatePostData(args),
      dataType: 'json'
    }).done(args.success)
      .fail(args.fail)
      .always(args.always);
  };

  ListClient.prototype.saveListPrefs = function (args) {
    if (!args) {
      args = {};
    }
    var data = {
      __mode: 'save_list_prefs',
      datasource: this.datasource,
      blog_id: this.siteId,
      columns: serializeColumns(args.columns),
      limit: args.limit
    };
    $.ajax(this.url, {
      type: 'POST',
      data: data,
      dataType: 'json'
    }).done(args.success)
      .fail(args.fail)
      .always(args.always);
  };

  ListClient.prototype.generatePostData = function (args) {
    if (!args) {
      args = {};
    }
    var data = {
      __mode: 'filtered_list',
      blog_id: this.siteId,
      datasource: this.datasource,
      magic_token: this.magicToken,
      columns: serializeColumns(args.columns),
      limit: args.limit,
      page: args.page,
      sort_by: args.sortBy,
      sort_order: args.sortOrder,
      fid: args.fid
    };
    return data;
  };

  function serializeColumns(columns) {
    return Array.isArray(columns) ? columns.join(',') : columns;
  }
})(window, jQuery);
