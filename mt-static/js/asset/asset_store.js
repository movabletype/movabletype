;(function () {
  window.AssetStore = function AssetStore(args) {
    AssetData.call(this, args);

    riot.observable(this);

    this.AssetClient = args.AssetClient;

    this.initializeTriggers();
  };

  AssetStore.prototype = Object.create(new AssetData());

  AssetStore.prototype.initializeTriggers = function () {

  };

})();
