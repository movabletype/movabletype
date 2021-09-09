;(function () {
  window.AssetData = function AssetData(args) {
    if (!args) {
      args = {};
    }

    this.limit = args.limit || this.DefautlLimit;
    this.page = args.page || this.DefaultPage;

    this.objects = null;
    this.count = null;
    this.editableCount = null;
    this.pageMax = null;

    this.isLoading = false;

  };

  AssetData.prototype.DefaultLimit = 12;
  AssetData.prototype.DefaultPage = 1;

})();
