;(function (globalWindow, $) {
  globalWindow.AssetClient = function AssetClient(args) {
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

  AssetClient.prototype.sendRequest = function (args, data) {
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


})(window, jQuery);
