;(function (globalWindow, $) {
  globalWindow.ListClient = function ListClient(args) {
    if (!args) {
      args = {};
    }
    this.url = args.url || '';
    this.siteId = args.siteId || 0;
    this.datasource = args.datasource || '';
    this.magicToken = args.magicToken || '';
  };

  ListClient.prototype = Object.create(ListClient, {
    generatePostData: { value: generatePostData },
    saveListPrefs: { value: saveListPrefs },
    sendRequest: { value: sendRequest }
  });

  function sendRequest(args) {
    if (!args) {
      args = {};
    }
    $.ajax(this.url, {
      type: 'POST',
      contentType: 'application/x-www-form-urlencoded; charset=utf-8',
      data: this.generatePostData(args),
      dataType: 'json'
    }).done(args.success)
    .fail(args.success)
    .always(args.always);
  }

  function filteredList() {
  }

  function saveListPrefs(args) {
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
  }

  function generatePostData(args) {
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
  }

  function serializeColumns(columns) {
    return Array.isArray(columns) ? columns.join(',') : columns;
  }
})(window, jQuery);

