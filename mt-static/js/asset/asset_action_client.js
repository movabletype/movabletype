;(function (globalWindow, $) {
  globalWindow.AssetActionClient = function AssetActionClient(args) {
    if (!args) {
      args = {};
    }
    this.url = args.url;
    this.siteId = args.siteId || 0;
    this.datasource = args.datasource;
    this.objectType = args.objectType;
    this.subType    = args.subType;
    this.magicToken = args.magicToken;
    this.returnArgs = args.returnArgs;
  };

})(window, jQuery);
