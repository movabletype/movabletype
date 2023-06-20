;(function (globalWindow, $) {
  globalWindow.ListActionClient = function ListActionClient(args) {
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

  ListActionClient.prototype.post = function (args) {
    var $form = this.createPostForm(args);
    $(document.body).append($form);
    $form.trigger('submit');
  };

  ListActionClient.prototype.createPostForm = function (args) {
    var $form = $('<form>').attr({
      action: this.url,
      method: 'POST'
    });
    var data = this.generateRequestData(args);
    Object.keys(data).forEach(function (name) {
      var values = [].concat(data[name]);
      values.forEach(function (value) {
        var $input = $('<input>').attr({
          type: 'hidden',
          name: name,
          value: value
        });
        $form.append($input);
      });
    });
    return $form;
  };

  ListActionClient.prototype.generateRequestData = function (args) {
    var data = {
      __mode: args.action.mode || 'itemset_action',
      _type: this.objectType,
      action_name: args.actionName,
      blog_id: this.siteId,
      magic_token: args.xhr ? 1 : this.magicToken,
      return_args: this.returnArgs + '&does_act=1'
    };
    if ( this.subType ) {
      data.type = this.subType;
    }
    if (args.itemsetActionInput) {
      data.itemset_action_input = args.itemsetActionInput;
    }
    if (args.allSelected) {
      data.all_selected = 1;
      data.items = JSON.stringify(args.filter.items);
    } else {
      data.id = args.ids;
    }
    return data;
  };

  ListActionClient.prototype.removeFilterKeyFromReturnArgs = function () {
    this.returnArgs.replace(/[&?]filter_key=[^&]*/, '');
  };

  ListActionClient.prototype.removeFilterItemFromReturnArgs = function () {
    this.returnArgs.replace(/[&?]filter(_val)?=[^&]*/g, '');
  };
})(window, jQuery);
