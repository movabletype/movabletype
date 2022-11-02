riot.tag2('display-options-for-mobile', '<div class="row d-md-none"> <div class="col-auto mx-auto"> <div class="form-inline"> <label for="row-for-mobile">{trans(\'Show\') + \':\'}</label> <select id="row-for-mobile" class="custom-select form-control" ref="limit" riot-value="{store.limit}" onchange="{changeLimit}"> <option value="10">{trans(\'[_1] rows\', 10)}</option> <option value="25">{trans(\'[_1] rows\', 25)}</option> <option value="50">{trans(\'[_1] rows\', 50)}</option> <option value="100">{trans(\'[_1] rows\', 100)}</option> <option value="200">{trans(\'[_1] rows\', 200)}</option> </select> </div> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('displayOptions')
});
riot.tag2('display-options', '<div class="row"> <div class="col-12"> <button class="btn btn-default dropdown-toggle float-right" data-toggle="collapse" data-target="#display-options-detail" aria-expanded="false" aria-controls="display-options-detail"> {trans(\'Display Options\')} </button> </div> </div> <div class="row"> <div data-is="display-options-detail" class="col-12"></div> </div>', '', '', function(opts) {
    this.mixin('listTop')
});

riot.tag2('display-options-detail', '<div id="display-options-detail" class="collapse"> <div class="card card-block p-3"> <fieldset class="form-group"> <div data-is="display-options-limit" id="per_page-field"></div> </fieldset> <fieldset class="form-group"> <div data-is="display-options-columns" id="display_columns-field"></div> </fieldset> <div if="{!listTop.opts.disableUserDispOption}" class="actions-bar actions-bar-bottom"> <a href="javascript:void(0);" id="reset-display-options" onclick="{resetColumns}"> {trans(\'Reset defaults\')} </a> </div> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')

    this.resetColumns = function(e) {
      this.store.trigger('reset_columns')
    }.bind(this)
});

riot.tag2('display-options-limit', '<div class="field-header"> <label>{trans(\'Show\')}</label> </div> <div class="field-content"> <select id="row" class="custom-select form-control" style="width: 100px;" ref="limit" riot-value="{store.limit}" onchange="{changeLimit}"> <option value="10">{trans(\'[_1] rows\', 10)}</option> <option value="25">{trans(\'[_1] rows\', 25)}</option> <option value="50">{trans(\'[_1] rows\', 50)}</option> <option value="100">{trans(\'[_1] rows\', 100)}</option> <option value="200">{trans(\'[_1] rows\', 200)}</option> </select> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('displayOptions')
});

riot.tag2('display-options-columns', '<div class="field-header"> <label>{trans(\'Column\')}</label> </div> <div if="{listTop.opts.disableUserDispOption}" class="alert alert-warning"> {trans(\'User Display Option is disabled now.\')} </div> <div if="{!listTop.opts.disableUserDispOption}" class="field-content"> <ul id="disp_cols" class="list-inline m-0"> <virtual each="{column in store.columns}"> <li hide="{column.force_display}" class="list-inline-item"> <div class="custom-control custom-checkbox"> <input type="checkbox" class="custom-control-input" id="{column.id}" checked="{column.checked}" onchange="{toggleColumn}" disabled="{store.isLoading}"> <label class="custom-control-label" for="{column.id}"> <raw content="{column.label}"></raw> </label> </div> </li> <li each="{subField in column.sub_fields}" hide="{subField.force_display}" class="list-inline-item"> <div class="custom-control custom-checkbox"> <input type="checkbox" id="{subField.id}" pid="{subField.parent_id}" class="custom-control-input {subField.class}" disabled="{disabled: !column.checked}" checked="{subField.checked}" onchange="{toggleSubField}"> <label class="custom-control-label" for="{subField.id}">{subField.label}</label> </div> </li> </virtual> </ul> </div>', '', '', function(opts) {
    this.mixin('listTop')

    this.toggleColumn = function(e) {
      this.store.trigger('toggle_column', e.currentTarget.id)
    }.bind(this)

    this.toggleSubField = function(e) {
      this.store.trigger('toggle_sub_field', e.currentTarget.id)
    }.bind(this)
});

riot.tag2('list-actions-for-mobile', '<div if="{hasActionForMobile()}" class="btn-group"> <button class="btn btn-default dropdown-toggle" data-toggle="dropdown"> {trans(\'Select action\')} </button> <div class="dropdown-menu"> <a each="{action, key in buttonActionsForMobile()}" class="dropdown-item" href="javascript:void(0);" data-action-id="{key}" onclick="{doAction}"> {action.label} </a> <a each="{action, key in listActionsForMobile()}" class="dropdown-item" href="javascript:void(0);" data-action-id="{key}" onclick="{doAction}"> {action.label} </a> <h6 if="{moreListActionsForMobile() > 0}" class="dropdown-header"> {trans(\'Plugin Actions\')} </h6> <a each="{action, key in moreListActionsForMobile()}" class="dropdown-item" href="javascript:void(0);" data-action-id="{key}" onclick="{doAction}"> {action.label} </a> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listActions')

    this.buttonActionsForMobile = function() {
      return this._getActionsForMobile(this.listTop.opts.buttonActions)
    }.bind(this)

    this.listActionsForMobile = function() {
      return this._getActionsForMobile(this.listTop.opts.listActions)
    }.bind(this)

    this.moreListActionsForMobile = function() {
      return this._getActionsForMobile(this.listTop.opts.moreListActions)
    }.bind(this)

    this._getActionsForMobile = function(actions) {
      var mobileActions = {}
      Object.keys(actions).forEach(function (key) {
        var action = actions[key]
        if (action.mobile) {
          mobileActions[key] = action
        }
      })
      return mobileActions
    }.bind(this)

    this.hasActionForMobile = function() {
      var mobileActionCount = Object.keys(this.buttonActionsForMobile()).length
        + Object.keys(this.listActionsForMobile()).length
        + Object.keys(this.moreListActionsForMobile()).length
      return mobileActionCount > 0
    }.bind(this)
});


riot.tag2('list-actions-for-pc', '<button each="{action, key in listTop.opts.buttonActions}" class="btn btn-default mr-2" data-action-id="{key}" onclick="{doAction}"> {action.label} </button> <div if="{listTop.opts.hasPulldownActions}" class="btn-group"> <button class="btn btn-default dropdown-toggle" data-toggle="dropdown"> {trans(\'More actions...\')} </button> <div class="dropdown-menu"> <a each="{action, key in listTop.opts.listActions}" class="dropdown-item" href="javascript:void(0);" data-action-id="{key}" onclick="{doAction}"> {action.label} </a> <h6 if="{Object.keys(listTop.opts.moreListActions).length > 0}" class="dropdown-header"> {trans(\'Plugin Actions\')} </h6> <a each="{action, key in listTop.opts.moreListActions}" class="dropdown-item" href="javascript:void(0);" data-action-id="{key}" onclick="{doAction}"> {action.label} </a> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listActions')
});

riot.tag2('list-actions', '<div data-is="list-actions-for-pc" class="d-none d-md-block"></div> <div data-is="list-actions-for-mobile" class="d-md-none"></div>', '', '', function(opts) {
    this.mixin('listTop')

    riot.mixin('listActions', {
      init: function () {
        this.selectedActionId = null
        this.selectedAction = null
      },

      doAction: function (e) {
        this.selectedActionId = e.target.dataset.actionId
        this.selectedAction = this.getAction(this.selectedActionId)
        this.selectedActionPhrase = this.selectedAction.js_message || trans('act upon')

        var args = {}

        if (!this.checkCount()) {
          return false
        }

        if (this.selectedAction.input) {
          var input = prompt(this.selectedAction.input)
          if (input) {
            args.itemsetActionInput = input
          } else {
            return false
          }
        }

        if (!this.selectedAction.no_prompt) {
          if (this.selectedAction.continue_prompt) {
            if (!confirm(this.selectedAction.continue_prompt)) {
              return false
            }
          } else {
            if (!confirm(this.getConfirmMessage())) {
              return false
            }
          }
        }

        var requestArgs = this.generateRequestArguments(args)

        if (this.selectedAction.xhr) {
        } else if (this.selectedAction.dialog) {
          var requestData = this.listTop.opts.listActionClient.generateRequestData(requestArgs)
          requestData.dialog = 1
          var url = ScriptURI + '?' + jQuery.param(requestData, true)
          jQuery.fn.mtModal.open(url, { large: true });
        } else {
          this.sendRequest(requestArgs)
        }
      },

      sendRequest: function (postArgs) {
        this.listTop.opts.listActionClient.post(postArgs)
      },

      generateRequestArguments: function (args) {
        return jQuery.extend({
          action: this.selectedAction,
          actionName: this.selectedActionId,
          allSelected: this.store.checkedAllRows,
          filter: this.store.currentFilter,
          ids: this.store.getCheckedRowIds()
        }, args)
      },

      getAction: function (actionId) {
        return this.listTop.opts.buttonActions[actionId]
          || this.listTop.opts.listActions[actionId]
          || this.listTop.opts.moreListActions[actionId]
          || null;
      },

      getCheckedRowCount: function () {
        return this.store.getCheckedRowCount()
      },

      checkCount: function () {
        var checkedRowCount = this.getCheckedRowCount()

        if (checkedRowCount == 0) {
          this.alertNoSelectedError()
          return false
        }
        if (this.selectedAction.min && checkedRowCount < this.selectedAction.min) {
          this.alertMinimumError()
          return false
        }
        if (this.selectedAction.max && checkedRowCount > this.selectedAction.max) {
          this.alertMaximumError()
          return false
        }
        return true
      },

      alertNoSelectedError: function () {
        alert(trans(
          'You did not select any [_1] to [_2].',
          this.listTop.opts.plural,
          this.selectedActionPhrase
        ))
      },

      alertMinimumError: function () {
        alert(trans(
          'You can only act upon a minimum of [_1] [_2].',
          this.selectedAction.min,
          this.listTop.opts.plural
        ))
      },

      alertMaximumError: function () {
        alert(trans(
          'You can only act upon a maximum of [_1] [_2].',
          this.selectedAction.max,
          this.listTop.opts.plural
        ))
      },

      getConfirmMessage: function () {
        var checkedRowCount = this.getCheckedRowCount()

        if (checkedRowCount == 1) {
          return trans(
            'Are you sure you want to [_2] this [_1]?',
            this.listTop.opts.singular,
            this.selectedActionPhrase
          )
        } else {
          return trans(
            'Are you sure you want to [_3] the [_1] selected [_2]?',
            checkedRowCount,
            this.listTop.opts.plural,
            this.selectedActionPhrase
          );
        }
      }
    })
});


riot.tag2('list-count', '<div> {store.count == 0 ? 0 : (store.limit * (store.page-1) + 1)} - {(store.limit * store.page) > store.count ? store.count : (store.limit * store.page)} / {store.count} </div>', '', '', function(opts) {
    this.mixin('listTop')
});


riot.tag2('list-filter', '<div data-is="list-filter-header" class="card-header"></div> <div id="list-filter-collapse" class="collapse"> <div data-is="list-filter-detail" id="filter-detail" class="card-block p-3"> </div> </div>', '', '', function(opts) {
    riot.mixin('listFilterTop', {
      init: function () {
        if (this.__.tagName == 'list-filter') {
          this.listFilterTop = this
        } else {
          this.listFilterTop = this.parent.listFilterTop
        }
      }
    })
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.currentFilter = this.store.currentFilter

    var self = this

    this.validateFilterName = function (name) {
      return !this.store.filters.some(function (filter) {
        return filter.label == name
      })
    }.bind(this)

    jQuery.mtValidateRules['[name=filter_name], .rename-filter-input'] = function ($e) {
      if (self.validateFilterName($e.val())) {
        return true
      } else {
        return this.raise(trans('Label "[_1]" is already in use.', $e.val() ))
      }
    };

    this.store.on('refresh_current_filter', function () {
      self.currentFilter = self.store.currentFilter
    })

    this.store.on('open_filter_detail', function () {
      jQuery('#list-filter-collapse').collapse('show')
    })

    this.store.on('close_filter_detail', function () {
      jQuery('#list-filter-collapse').collapse('hide')
    })

    this.addFilterItem = function(filterType) {
      if (this.isAllpassFilter()) {
        this.createNewFilter(trans('New Filter'))
      }
      this.currentFilter.items.push({ type: filterType, args: {} })
      this.update()
    }.bind(this)

    this.addFilterItemContent = function(itemIndex, contentIndex) {
      if (this.currentFilter.items[itemIndex].type != 'pack') {
        var items = [ this.currentFilter.items[itemIndex] ]
        this.currentFilter.items[itemIndex] = {
          type: 'pack',
          args: { op: 'and', items: items }
        }
      }
      var type = this.currentFilter.items[itemIndex].args.items[0].type
      this.currentFilter.items[itemIndex].args.items.splice(
        contentIndex + 1,
        0,
        { type: type, args: {} }
      )
      this.update()
    }.bind(this)

    this.createNewFilter = function(filterLabel) {
      this.currentFilter = {
        items: [],
        label: filterLabel || trans('New Filter')
      }
    }.bind(this)

    this.getItemValues = function() {
      var $items = jQuery('#filter-detail .filteritem:not(.error)');
      vals = [];
      $items.each(function() {
        var data = {};
        var fields = [];
        var $types = jQuery(this).find('.filtertype');
        $types.each(function() {
          jQuery(this).attr('class').match(/type-(\w+)/);
          var type = RegExp.$1;
          jQuery(this).find('.item-content').each(function() {
            var args = {};
            jQuery(this).find(':input').each(function() {
              var re = new RegExp(type+'-(\\w+)');
              jQuery(this).attr('class').match(re);
              var key = RegExp.$1;
              if (key && !args.hasOwnProperty(key)) {
                args[key] = jQuery(this).val();
              }
            });
            fields.push({'type': type, 'args': args});
          });
        });
        if (fields.length > 1 ) {
          data['type'] = 'pack';
          data['args'] = {
            "op":"and",
            "items":fields
          };
        } else {
          data = fields.pop();
        }
        vals.push(data);
      });
      this.currentFilter.items = vals
    }.bind(this)

    this.isAllpassFilter = function() {
      return this.currentFilter.id == this.store.allpassFilter.id
    }.bind(this)

    this.isFilterItemSelected = function(type) {
      return this.currentFilter.items.some(function (item) {
        return item.type == type
      })
    }.bind(this)

    this.isUserFilter = function() {
      return this.currentFilter.id && this.currentFilter.id.match(/^[1-9][0-9]*$/)
    }.bind(this)

    this.removeFilterItem = function(itemIndex) {
      this.currentFilter.items.splice(itemIndex, 1)
      this.update()
    }.bind(this)

    this.removeFilterItemContent = function(itemIndex, contentIndex) {
      this.currentFilter.items[itemIndex].args.items.splice(contentIndex, 1)
    }.bind(this)

    this.showMessage = function( content, cls ){
      var error_block
      if ( typeof content == 'object' ) {
        jQuery('#msg-block').append(
          error_block = jQuery('<div>')
          .attr('class', 'msg msg-' + cls )
          .append(
            jQuery('<p />')
              .attr('class', 'msg-text alert alert-danger alert-dismissable')
              .append('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>')
              .append(content)
          )
        )
      }
      else {
        jQuery('#msg-block').append(
          error_block = jQuery('<div />')
          .attr('class', 'msg msg-' + cls )
          .append(
            jQuery('<p />')
              .attr('class', 'msg-text alert alert-danger alert-dismissable')
              .append('<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>')
              .append(content)
          )
        )
      }
      return error_block
    }.bind(this)

    this.validateFilterDetails = function () {
      if ( this.$validateErrorMessage ) {
        this.$validateErrorMessage.remove()
      }
      var errors = 0
      jQuery('div#filter-detail div.filteritem').each( function () {
        if ( !jQuery(this).find('input:visible').mtValidate() ) {
          errors++
          jQuery(this).addClass('highlight error bg-warning')
        }
        else {
          jQuery(this).removeClass('highlight error bg-warning')
        }
      })
      if ( errors ) {
        this.$validateErrorMessage = this.showMessage(
          trans('One or more fields in the filter item are not filled in properly.'),
          'error'
        )
      }
      return errors ? false : true
    }.bind(this)
});

riot.tag2('list-filter-header', '<div class="row"> <div class="col-12 col-md-11"> <ul class="list-inline mb-0"> <li class="list-inline-item"> {trans(\'Filter:\')} </li> <li class="list-inline-item"> <a href="#" id="opener" data-toggle="modal" data-target="#select-filter"> <u>{trans( listFilterTop.currentFilter.label )}</u> </a> <virtual data-is="list-filter-select-modal"></virtual> </li> <li class="list-inline-item"> <a href="#" id="allpass-filter" if="{listFilterTop.isAllpassFilter() == false}" onclick="{resetFilter}"> [ {trans( \'Reset Filter\' )} ] </a> </li> </ul> </div> <div class="d-none d-md-block col-md-1"> <button id="toggle-filter-detail" class="btn btn-default dropdown-toggle float-right" data-toggle="collapse" data-target="#list-filter-collapse" aria-expanded="false" aria-controls="list-filter-collapse"></button> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.resetFilter = function(e) {
      this.listTop.opts.listActionClient.removeFilterKeyFromReturnArgs()
      this.listTop.opts.listActionClient.removeFilterItemFromReturnArgs()
      this.store.trigger('close_filter_detail')
      this.store.trigger('reset_filter')
    }.bind(this)
});

riot.tag2('list-filter-detail', '<div class="row"> <div class="col-12"> <ul class="list-inline"> <li class="list-inline-item"> <div class="dropdown"> <button class="btn btn-default dropdown-toggle" data-toggle="dropdown"> {trans(\'Select Filter Item...\')} </button> <div class="dropdown-menu"> <a each="{listTop.opts.filterTypes}" if="{editable}" class="{disabled: parent.listFilterTop.isFilterItemSelected(type), dropdown-item: true}" href="#" data-mt-filter-type="{type}" onclick="{addFilterItem}"> <raw content="{label}"></raw> </a> </div> </div> </li> </ul> </div> </div> <div class="row mb-3"> <div class="col-12"> <ul class="list-group"> <li data-is="list-filter-item" each="{item, index in listFilterTop.currentFilter.items}" data-mt-list-item-index="{index}" item="{item}" class="list-group-item"> </li> </ul> </div> </div> <div class="row"> <div data-is="list-filter-buttons" class="col-12"></div> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.addFilterItem = function(e) {
      if (e.currentTarget.classList.contains('disabled')) {
        e.preventDefault()
        e.stopPropagation()
        return
      }
      var filterType = e.currentTarget.dataset.mtFilterType
      this.listFilterTop.addFilterItem(filterType)
    }.bind(this)
});

riot.tag2('list-filter-item', '<div class="filteritem"> <button class="close" aria-label="Close" onclick="{removeFilterItem}"> <span aria-hidden="true">&times;</span> </button> <div if="{opts.item.type == \'pack\'}"> <div each="{item, index in opts.item.args.items}" if="{filterTypeHash[item.type]}" data-mt-list-item-content-index="{index}" class="{\'filtertype type-\' + item.type}"> <div class="item-content form-inline"> <virtual data-is="list-filter-item-field" field="{filterTypeHash[item.type].field}" item="{item}"> </virtual> <a href="javascript:void(0);" class="d-inline-block" if="{!filterTypeHash[item.type].singleton}" onclick="{addFilterItemContent}"> <ss title="{trans(\'Add\')}" class="mt-icon mt-icon--sm" href="{StaticURI + \'images/sprite.svg#ic_add\'}"> </ss> </a> <a href="javascript:void(0);" if="{!filterTypeHash[item.type].singleton               && parent.opts.item.args.items.length > 1}" onclick="{removeFilterItemContent}"> <ss title="{trans(\'Remove\')}" class="mt-icon mt-icon--sm" href="{StaticURI + \'images/sprite.svg#ic_remove\'}"> </ss> </a> </div> </div> </div> <virtual if="{opts.item.type != \'pack\' && filterTypeHash[opts.item.type]}"> <div data-mt-list-item-content-index="0" class="{\'filtertype type-\' + opts.item.type}"> <div class="item-content form-inline"> <virtual data-is="list-filter-item-field" field="{filterTypeHash[opts.item.type].field}" item="{opts.item}"> </virtual> <a href="javascript:void(0);" class="d-inline-block" if="{!filterTypeHash[opts.item.type].singleton}" onclick="{addFilterItemContent}"> <ss title="{trans(\'Add\')}" class="mt-icon mt-icon--sm" href="{StaticURI + \'images/sprite.svg#ic_add\'}"> </ss> </a> </div> </div> </virtual> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.filterTypeHash = this.listTop.opts.filterTypes.reduce(
      function (hash, filterType) {
        hash[filterType.type] = filterType;
        return hash;
      },
      {}
    )

    this.on('mount', function () {
      this.initializeDateOption()
      this.initializeOptionWithBlank()
    })

    this.addFilterItemContent = function(e) {
      var itemIndex = this.getListItemIndex(e.target)
      var contentIndex = this.getListItemContentIndex(e.target)
      var item = this.listFilterTop.currentFilter.items[itemIndex]
      if (item.type == 'pack') {
        item = item.args.items[contentIndex]
      }
      jQuery(e.target).parent().each(function() {
        jQuery(this).find(':input').each(function() {
          var re = new RegExp(item.type+'-(\\w+)');
          jQuery(this).attr('class').match(re);
            var key = RegExp.$1;
            if (key && !item.args.hasOwnProperty(key)) {
            item.args[key] = jQuery(this).val();
          }
        });
      });
      this.listFilterTop.addFilterItemContent(itemIndex, contentIndex)
      this.initializeDateOption()
      this.initializeOptionWithBlank()
    }.bind(this)

    this.getListItemIndex = function(element) {
      while (!element.dataset.hasOwnProperty('mtListItemIndex')) {
        element = element.parentElement
      }
      return Number(element.dataset.mtListItemIndex)
    }.bind(this)

    this.getListItemContentIndex = function(element) {
      while (!element.dataset.hasOwnProperty('mtListItemContentIndex')) {
        element = element.parentElement
      }
      return Number(element.dataset.mtListItemContentIndex)
    }.bind(this)

    this.initializeDateOption = function() {
      var dateOption = function ($node) {
        var val = $node.val()
        var type;
        switch (val) {
        case 'hours':
          type = 'hours'
          break
        case 'days':
          type = 'days'
          break
        case 'before':
        case 'after':
          type = 'date'
          break
        case 'future':
        case 'past':
        case 'blank':
        case 'not_blank':
          type = 'none';
          break
        default:
          type = 'range'
        }
        $node.parents('.item-content').find('.date-options span.date-option').hide()
        $node.parents('.item-content').find('.date-option.'+type).show()
      }
      jQuery(this.root).find('.filter-date').each(function (index, element) {
        var $node = jQuery(element)
        dateOption($node)
        $node.on('change', function () {
          dateOption($node)
        })
      })
      jQuery(this.root).find('input.date').datepicker({
        dateFormat: 'yy-mm-dd',
        dayNamesMin: this.listFilterTop.opts.localeCalendarHeader,
        monthNames: ['- 01','- 02','- 03','- 04','- 05','- 06','- 07','- 08','- 09','- 10','- 11','- 12'],
        showMonthAfterYear: true,
        prevText: '<',
        nextText: '>',
      })
    }.bind(this)

    this.initializeOptionWithBlank = function() {
      var changeOption = function ($node) {
        if ($node.val() == 'blank' || $node.val() == 'not_blank') {
          $node.parent().find('input[type=text]').hide()
        } else {
          $node.parent().find('input[type=text]').show()
        }
      }
      jQuery(this.root).find('.filter-blank').each(function (index, element) {
        var $node = jQuery(element)
        changeOption($node)
        $node.on('change', function () {
          changeOption($node)
        })
      })
    }.bind(this)

    this.removeFilterItem = function(e) {
      var itemIndex = this.getListItemIndex(e.target)
      this.listFilterTop.removeFilterItem(itemIndex)
    }.bind(this)

    this.removeFilterItemContent = function(e) {
      var itemIndex = this.getListItemIndex(e.target)
      var contentIndex = this.getListItemContentIndex(e.target)
      this.listFilterTop.removeFilterItemContent(itemIndex, contentIndex)
    }.bind(this)
});

riot.tag2('list-filter-item-field', '<virtual></virtual>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.setValues = function() {
      for (var key in opts.item.args) {
        if (typeof opts.item.args[key] != 'string'
          && typeof opts.item.args[key] != 'number')
        {
          continue
        }
        var selector = '.' + opts.item.type + '-' + key
        var elements = this.root.querySelectorAll(selector)
        Array.prototype.slice.call(elements).forEach(function (element) {
          if (element.tagName == 'INPUT' || element.tagName == 'SELECT') {
            element.value = opts.item.args[key]
          } else {
            element.textContent = opts.item.args[key]
          }
        })
      }
    }.bind(this)

    this.root.innerHTML = opts.field
    this.setValues()
});

riot.tag2('list-filter-select-modal', '<div class="modal fade" id="select-filter" tabindex="-1"> <div class="modal-dialog"> <div class="modal-content"> <div class="modal-header"> <h5 class="modal-title">{trans( \'Select Filter\' )}</h5> <button type="button" class="close" data-dismiss="modal"><span>×</span></button> </div> <div class="modal-body"> <div class="filter-list-block"> <h6 class="filter-list-label">{trans( \'My Filters\' )}</h6> <ul id="user-filters" class="list-unstyled editable"> <li class="filter line" each="{store.filters}" if="{can_save == ⁗1⁗}" data-mt-list-filter-id="{id}" data-mt-list-filter-label="{label}"> <virtual if="{!parent.isEditingFilter[id]}"> <a href="#" onclick="{applyFilter}"> {label} </a> <div class="float-right d-none d-md-block"> <a href="#" onclick="{startEditingFilter}">[{trans( \'rename\' )}]</a> <a href="#" class="d-inline-block" onclick="{removeFilter}"> <ss title="{trans(\'Remove\')}" class="mt-icon mt-icon--sm" href="{StaticURI + \'images/sprite.svg#ic_trash\'}"> </ss> </a> </div> </virtual> <div class="form-inline" if="{parent.isEditingFilter[id]}"> <div class="form-group form-group-sm"> <input type="text" class="form-control rename-filter-input" riot-value="{label}" ref="label"> <button class="btn btn-default form-control" onclick="{renameFilter}"> {trans(\'Save\')} </button> <button class="btn btn-default form-control" onclick="{stopEditingFilter}"> {trans(\'Cancel\')} </button> </div> </div> </li> <li class="filter line d-none d-md-block"> <a href="#" id="new_filter" class="icon-mini-left addnew create-new apply-link d-md-inline-block" onclick="{createNewFilter}"> <ss title="{trans(\'Add\')}" class="mt-icon mt-icon--sm" href="{StaticURI + \'images/sprite.svg#ic_add\'}"> </ss> {trans( \'Create New\' )} </a> </li> </ul> </div> <div class="filter-list-block" if="{store.hasSystemFilter()}"> <h6 class="filter-list-label">{trans( \'Built in Filters\' )}</h6> <ul id="built-in-filters" class="list-unstyled"> <li class="filter line" each="{store.filters}" if="{can_save == ⁗0⁗}" data-mt-list-filter-id="{id}" data-mt-list-filter-label="{label}"> <a href="#" onclick="{applyFilter}"> {label} </a> </li> </ul> </div> </div> </div> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.isEditingFilter = {}

    this.applyFilter = function(e) {
      this.closeModal()
      var filterId = e.target.parentElement.dataset.mtListFilterId
      this.store.trigger('apply_filter_by_id', filterId)
    }.bind(this)

    this.closeModal = function() {
      jQuery('#select-filter').modal('hide')
    }.bind(this)

    this.createNewFilter = function(e) {
      this.closeModal();
      this.store.trigger('open_filter_detail')
      this.listFilterTop.createNewFilter()
      this.listFilterTop.update()
    }.bind(this)

    this.renameFilter = function(e) {
      var filterData = e.target.parentElement.parentElement.parentElement.dataset
      this.store.trigger(
        'rename_filter_by_id',
        filterData.mtListFilterId,
        this.refs.label.value
      )
      this.isEditingFilter[filterData.mtListFilterId] = false
    }.bind(this)

    this.removeFilter = function(e) {
      var filterData = e.target.closest('[data-mt-list-filter-label]').dataset
      var message = trans(
        "Are you sure you want to remove filter '[_1]'?",
        filterData.mtListFilterLabel
      )
      if (confirm(message) == false) {
        return false
      }
      this.store.trigger('remove_filter_by_id', filterData.mtListFilterId)
    }.bind(this)

    this.startEditingFilter = function(e) {
      this.stopEditingAllFilters()
      var filterData = e.target.parentElement.parentElement.dataset
      this.isEditingFilter[filterData.mtListFilterId] = true
    }.bind(this)

    this.stopEditingAllFilters = function() {
      this.isEditingFilter = {}
    }.bind(this)

    this.stopEditingFilter = function(e) {
      var filterData = e.target.parentElement.parentElement.parentElement.dataset
      this.isEditingFilter[filterData.mtListFilterId] = false
    }.bind(this)
});

riot.tag2('list-filter-buttons', '<button class="btn btn-primary" disabled="{listFilterTop.currentFilter.items.length == 0}" onclick="{applyFilter}"> {trans(\'Apply\')} </button> <button class="btn btn-default" disabled="{listFilterTop.currentFilter.items.length == 0       || listFilterTop.currentFilter.can_save == \'0\'}" onclick="{saveFilter}"> {trans(\'Save\')} </button> <button if="{listFilterTop.currentFilter.id && listFilterTop.currentFilter.items.length > 0}" class="btn btn-default" onclick="{saveAsFilter}"> {trans(\'Save As\')} </button> <list-filter-save-modal></list-filter-save-modal>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.applyFilter = function(e) {
      if (!this.listFilterTop.validateFilterDetails()) {
        return false
      }
      this.listFilterTop.getItemValues()
      var noFilterId = true
      this.store.trigger('apply_filter', this.listFilterTop.currentFilter, noFilterId)
    }.bind(this)

    this.saveFilter = function(e) {
      if (!this.listFilterTop.validateFilterDetails()) {
        return false
      }
      if (this.listFilterTop.isUserFilter()) {
        this.listFilterTop.getItemValues()
        this.store.trigger('save_filter', this.listFilterTop.currentFilter)
      } else {
        var filterLabel = this.store.getNewFilterLabel(this.listTop.opts.objectLabel)
        this.tags['list-filter-save-modal'].openModal({ filterLabel: filterLabel })
      }
    }.bind(this)

    this.saveAsFilter = function(e) {
      if (!this.listFilterTop.validateFilterDetails()) {
        return false
      }
      this.tags['list-filter-save-modal'].openModal({
        filterLabel: this.listFilterTop.currentFilter.label,
        saveAs: true
      })
    }.bind(this)
});

riot.tag2('list-filter-save-modal', '<div id="save-filter" class="modal fade" tabindex="-1" ref="modal"> <div class="modal-dialog modal-sm"> <div class="modal-content"> <div class="modal-header"> <h5 class="modal-title">{trans( saveAs ? \'Save As Filter\' : \'Save Filter\' )}</h5> <button type="button" class="close" data-dismiss="modal" aria-label="Close" data-mt-modal-close> <span aria-hidden="true">&times;</span> </button> </div> <div class="modal-body"> <div style="padding-bottom: 30px;"> <h6>{trans(\'Filter Label\')}</h6> <input type="text" class="text full required form-control" name="filter_name" ref="filterName"> </div> </div> <div class="modal-footer"> <button class="btn btn-primary" onclick="{saveFilter}"> {trans(\'Save\')} </button> <button class="btn btn-default" onclick="{closeModal}"> {trans(\'Cancel\')} </button> </div> </div> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.closeModal = function(e) {
      jQuery(this.refs.modal).modal('hide')
    }.bind(this)

    this.openModal = function(args) {
      if (!args) {
        args = {}
      }
      jQuery(this.refs.filterName).mtUnvalidate()
      if (args.filterLabel) {
        this.refs.filterName.value = args.filterLabel
      }
      this.saveAs = args.saveAs
      jQuery(this.refs.modal).modal()
    }.bind(this)

    this.saveFilter = function(e) {
      if (!jQuery(this.refs.filterName).mtValidate('simple')) {
        return false
      }
      this.listFilterTop.getItemValues()
      this.listFilterTop.currentFilter.label = this.refs.filterName.value
      if (this.saveAs) {
        this.listFilterTop.currentFilter.id = null
      }
      this.store.trigger('save_filter', this.listFilterTop.currentFilter)
      this.closeModal()
    }.bind(this)
});


riot.tag2('list-pagination-for-mobile', '<ul class="pagination__mobile d-md-none"> <li class="{page-item: true,       mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" disabled="{store.page <= 1}" data-page="{store.page - 1}" onclick="{movePage}"> <ss title="{trans(\'Previous\')}" class="mt-icon--inverse mt-icon--sm" href="{StaticURI + \'images/sprite.svg#ic_tri-left\'}"> </ss> </a> </li> <li if="{store.page - 4 >= 1 && store.pageMax - store.page < 1}" class="{page-item: true,         mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page - 4}" onclick="{movePage}"> {store.page - 4} </a> </li> <li if="{store.page - 3 >= 1 && store.pageMax - store.page < 2}" class="{page-item: true,         mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page - 3}" onclick="{movePage}"> {store.page - 3} </a> </li> <li if="{store.page - 2 >= 1}" class="{page-item: true,         mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page - 2}" onclick="{movePage}"> {store.page - 2} </a> </li> <li if="{store.page - 1 >= 1}" class="{page-item: true,         mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page - 1}" onclick="{movePage}"> {store.page - 1} </a> </li> <li class="{page-item: true,       active: true,       mr-auto: isTooNarrowWidth()}"> <a class="page-link"> {store.page} <span class="sr-only">(current)</span> </a> </li> <li if="{store.page + 1 <= store.pageMax}" class="{page-item: true,         mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page + 1}" onclick="{movePage}"> {store.page + 1} </a> </li> <li if="{store.page + 2 <= store.pageMax}" class="{page-item: true,         mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page + 2}" onclick="{movePage}"> {store.page + 2} </a> </li> <li if="{store.page + 3 <= store.pageMax && store.page <= 2}" class="{page-item: true,         mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page + 3}" onclick="{movePage}"> {store.page + 3} </a> </li> <li if="{store.page + 4 <= store.pageMax && store.page <= 1}" class="{page-item: true,         mr-auto: isTooNarrowWidth()}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page + 4}" onclick="{movePage}"> {store.page + 4} </a> </li> <li class="page-item"> <a href="javascript:void(0);" class="page-link" disabled="{store.page >= store.pageMax}" data-page="{store.page + 1}" onclick="{movePage}"> <ss title="{trans(\'Next\')}" class="mt-icon--inverse mt-icon--sm" href="{StaticURI + \'images/sprite.svg#ic_tri-right\'}"> </ss> </a> </li> </ul>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listPagination')
});

riot.tag2('list-pagination-for-pc', '<ul class="pagination d-none d-md-flex"> <li class="page-item"> <a href="javascript:void(0);" class="page-link" disabled="{store.page <= 1}" data-page="{store.page - 1}" onclick="{movePage}"> {trans(\'Previous\')} </a> </li> <virtual if="{store.page - 2 >= 1}"> <li class="page-item first-last"> <a href="javascript:void(0);" class="page-link" data-page="{1}" onclick="{movePage}"> 1 </a> </li> </virtual> <virtual if="{store.page - 3 >= 1}"> <li class="page-item" aria-hidden="true"> ... </li> </virtual> <li if="{store.page - 1 >= 1}" class="{\'page-item\': true, \'first-last\': store.page - 1 == 1}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page - 1}" onclick="{movePage}"> {store.page - 1} </a> </li> <li class="page-item active"> <a class="page-link"> {store.page} <span class="sr-only">(current)</span> </a> </li> <li if="{store.page + 1 <= store.pageMax}" class="{\'page-item\': true, \'first-last\': store.page + 1 == store.pageMax}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page + 1}" onclick="{movePage}"> {store.page + 1} </a> </li> <virtual if="{store.page + 3 <= store.pageMax}"> <li class="page-item" aria-hidden="true"> ... </li> </virtual> <virtual if="{store.page + 2 <= store.pageMax}"> <li class="page-item first-last"> <a href="javascript:void(0);" class="page-link" data-page="{store.pageMax}" onclick="{movePage}"> {store.pageMax} </a> </li> </virtual> <li class="page-item"> <a href="javascript:void(0);" class="page-link" disabled="{store.page >= store.pageMax}" data-page="{store.page + 1}" onclick="{movePage}"> {trans(\'Next\')} </a> </li> </ul>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listPagination')
});

riot.tag2('list-pagination', '<div class="{col-auto: true,     mx-auto: true,     w-100: isTooNarrowWidth()}"> <nav aria-label="{store.listClient.objectType + \' list\'}"> <virtual data-is="list-pagination-for-pc"></virtual> <virtual data-is="list-pagination-for-mobile"></virtual> </nav> </div>', '', '', function(opts) {
    riot.mixin('listPagination', {
      isTooNarrowWidth: function () {
        return this.store.pageMax >= 5 && jQuery(window.top).width() < 400;
      },
      movePage: function (e) {
        if (e.currentTarget.disabled) {
            return false
        }

        var nextPage
        if (e.target.tagName == "INPUT") {
            if (e.which != 13) {
            return false
            }
            nextPage = Number(e.target.value)
        } else {
            nextPage = Number(e.currentTarget.dataset.page)
        }
        if (!nextPage) {
            return false
        }
        var moveToPagination = true
        this.store.trigger('move_page', nextPage, moveToPagination)
        return false
      }
    })

    this.mixin('listTop')
    this.mixin('listPagination')

    var self = this

    jQuery(window.top).on('resize orientationchange', function () {
      self.update()
    })
});

riot.tag2('list-table', '<thead data-is="list-table-header"></thead> <tbody if="{store.isLoading}"> <tr> <td colspan="{store.columns.length + 1}"> {trans(\'Loading...\')} </td> </tr> </tbody> <tbody data-is="list-table-body" if="{!store.isLoading && store.objects}"> </tbody>', '', '', function(opts) {
    this.mixin('listTop')
});

riot.tag2('list-table-header', '<virtual data-is="list-table-header-for-pc"></virtual> <virtual data-is="list-table-header-for-mobile"></virtual>', '', '', function(opts) {
    this.mixin('listTop')
    riot.mixin('listTableHeader', {
      toggleAllRowsOnPage: function (e) {
        this.store.trigger('toggle_all_rows_on_page')
      },
      toggleSortColumn: function (e) {
        var columnId = e.currentTarget.parentElement.dataset.id
        this.store.trigger('toggle_sort_column', columnId)
      }
    })
});

riot.tag2('list-table-header-for-pc', '<tr class="d-none d-md-table-row"> <th if="{listTop.opts.hasListActions}" class="mt-table__control"> <div class="custom-control custom-checkbox"> <input type="checkbox" class="custom-control-input" id="select-all" checked="{store.checkedAllRowsOnPage}" onchange="{toggleAllRowsOnPage}"> <label class="custom-control-label" for="select-all"><span class="sr-only">{trans(\'Select All\')}</span></label> </div> </th> <th each="{store.columns}" scope="col" if="{checked && id != \'__mobile\'}" data-id="{id}" class="{primary: primary,         sortable: sortable,         sorted: parent.store.sortBy == id,         text-truncate: true}"> <a href="javascript:void(0)" if="{sortable}" onclick="{toggleSortColumn}" class="{mt-table__ascend: sortable && parent.store.sortBy == id && parent.store.sortOrder == \'ascend\',           mt-table__descend: sortable && parent.store.sortBy == id && parent.store.sortOrder == \'descend\'}"> <raw content="{label}"></raw> </a> <raw if="{!sortable}" content="{label}"></raw> </th> </tr>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listTableHeader')
});

riot.tag2('list-table-header-for-mobile', '<tr if="{store.count}" class="d-md-none"> <th if="{listTop.opts.hasMobilePulldownActions}" class="mt-table__control"> <div class="custom-control custom-checkbox"> <input type="checkbox" class="custom-control-input" id="select-all" checked="{store.checkedAllRowsOnPage}" onchange="{toggleAllRowsOnPage}"> <label class="custom-control-label" for="select-all"><span class="sr-only">{trans(\'Select All\')}</span></label> </div> </th> <th scope="col"> <span if="{listTop.opts.hasMobilePulldownActions}" onclick="{toggleAllRowsOnPage}"> {trans(\'All\')} </span> <span class="float-right"> {trans(\'[_1] &ndash; [_2] of [_3]\', store.getListStart(), store.getListEnd(), store.count)} </span> </th> </tr>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listTableHeader')
});

riot.tag2('list-table-body', '<tr if="{store.objects.length == 0}"> <td colspan="{store.columns.length + 1}"> {trans(\'No [_1] could be found.\', listTop.opts.zeroStateLabel)} </td> </tr> <tr style="background-color: #ffffff;" if="{store.pageMax > 1 && store.checkedAllRowsOnPage && !store.checkedAllRows}"> <td colspan="{store.objects.length + 1}"> <a href="javascript:void(0);" onclick="{checkAllRows}"> {trans(\'Select all [_1] items\', store.count)} </a> </td> </tr> <tr class="success" if="{store.pageMax > 1 && store.checkedAllRows}"> <td colspan="{store.objects.length + 1}"> {trans(\'All [_1] items are selected\', store.count)} </td> </tr> <tr data-is="list-table-row" each="{obj, index in store.objects}" onclick="{parent.clickRow}" class="{(obj.checked || obj.clicked) ? \'mt-table__highlight\' : \'\'}" data-index="{index}" checked="{obj.checked}" object="{obj.object}"> </tr>', '', '', function(opts) {
    this.mixin('listTop')

    this.clickRow = function(e) {
      this.store.trigger('reset_all_clicked_rows');

      if (e.target.tagName == 'A' || e.target.tagName == 'IMG' || e.target.tagName == 'svg') {
        return false
      }
      if (MT.Util.isMobileView()) {
        var $mobileColumn
        if (e.target.dataset.is == 'list-table-column') {
          $mobileColumn = jQuery(e.target)
        } else {
          $mobileColumn = jQuery(e.target).parents('[data-is=list-table-column]');
        }
        if ($mobileColumn.length > 0 && $mobileColumn.find('a').length > 0) {
          $mobileColumn.find('a')[0].click()
          this.store.trigger('click_row', e.currentTarget.dataset.index)
          return false
        }
      }
      e.preventDefault()
      e.stopPropagation()
      this.store.trigger('toggle_row', e.currentTarget.dataset.index)
    }.bind(this)

    this.checkAllRows = function(e) {
      this.store.trigger('check_all_rows')
    }.bind(this)
});

riot.tag2('list-table-row', '<td if="{listTop.opts.hasListActions}" class="{d-none: !listTop.opts.hasMobilePulldownActions,       d-md-table-cell: !listTop.opts.hasMobilePulldownActions}"> <div class="custom-control custom-checkbox" if="{opts.object[0]}"> <input type="checkbox" name="id" class="custom-control-input" id="{\'select_\' + opts.object[0]}" riot-value="{opts.object[0]}" checked="{opts.checked}"> <span class="custom-control-indicator"></span> <label class="custom-control-label" for="{\'select_\' + opts.object[0]}"><span class="sr-only">{trans(\'Select\')}</span></label> </div> </td> <td data-is="list-table-column" each="{content, index in opts.object}" if="{index > 0}" class="{classes(index)}" content="{content}"> </td>', '', '', function(opts) {
    this.mixin('listTop')

    this.classes = function(index) {
      var nameClass = this.store.showColumns[index].id
      var classes
      if (this.store.hasMobileColumn()) {
        if (this.store.getMobileColumnIndex() == index) {
          classes = 'd-md-none'
        } else {
          classes = 'd-none d-md-table-cell'
        }
      } else {
        if (this.store.showColumns[index].primary) {
          classes = ''
        } else {
          classes = 'd-none d-md-table-cell'
        }
      }
      if (classes.length > 0) {
        return nameClass + ' ' + classes
      } else {
        return nameClass
      }
    }.bind(this)
});

riot.tag2('list-table-column', '<virtual></virtual>', '', '', function(opts) {
    this.root.innerHTML = opts.content
});

riot.tag2('list-top', '<div class="d-none d-md-block mb-3" data-is="display-options"></div> <div id="actions-bar-top" class="row mb-5 mb-md-3"> <div class="col"> <virtual data-is="list-actions" if="{opts.useActions}"></virtual> </div> <div class="col-auto align-self-end list-counter"> <virtual data-is="list-count"></virtual> </div> </div> <div class="row mb-5 mb-md-3"> <div class="col-12"> <div class="card"> <virtual data-is="list-filter" if="{opts.useFilters}"> </virtual> <div style="overflow-x: auto"> <table data-is="list-table" id="{opts.objectType}-table" class="table mt-table {tableClass()}"> </table> </div> </div> </div> </div> <div class="row" hide="{opts.store.count == 0}"> <virtual data-is="list-pagination"></virtual> </div> <virtual data-is="display-options-for-mobile"> </virtual>', '', '', function(opts) {
    riot.mixin('listTop', {
      init: function () {
        if (this.__.tagName == 'list-top') {
          this.listTop = this
          this.store = opts.store
        } else {
          this.listTop = this.parent.listTop
          this.store = this.parent.store
        }
      }
    })
    riot.mixin('displayOptions', {
      changeLimit: function(e) {
        this.store.trigger('update_limit', this.refs.limit.value)
      }
    })

    this.mixin('listTop')

    var self = this

    opts.store.on('refresh_view', function (args) {
      if (!args) args = {}
      var moveToPagination = args.moveToPagination
      var notCallListReady = args.notCallListReady

      self.update()
      self.updateSubFields()
      if (moveToPagination) {
        window.document.body.scrollTop = window.document.body.scrollHeight
      }
      if (!notCallListReady) {
        jQuery(window).trigger('listReady')
      }
    })

    this.on('mount', function () {
      this.opts.store.trigger('load_list')
    })

    this.updateSubFields = function() {
      opts.store.columns.forEach(function (column) {
        column.sub_fields.forEach(function (subField) {
          var selector = 'td.' + subField.parent_id + ' .' + subField.class
          if (subField.checked) {
            jQuery(selector).show()
          } else {
            jQuery(selector).hide()
          }
        })
      })
    }.bind(this)

    this.tableClass = function() {
      var objectType = opts.objectTypeForTableClass || opts.objectType
      return 'list-' + objectType
    }.bind(this)
});

riot.tag2('raw', '<span></span>', '', '', function(opts) {

  this.root.innerHTML = opts.content
});
