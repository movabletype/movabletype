riot.tag2('display-options', '<div class="row"> <div class="col-12"> <button class="btn btn-default dropdown-toggle float-right" data-toggle="collapse" data-target="#display-options-detail" aria-expanded="false" aria-controls="display-options-detail"> {trans(\'Display Options\')} </button> </div> </div> <div class="row"> <div data-is="display-options-detail" class="col-12"></div> </div>', '', '', function(opts) {
    this.mixin('listTop')
});

riot.tag2('display-options-detail', '<div id="display-options-detail" class="collapse"> <div class="card card-block p-3"> <fieldset class="form-group"> <div data-is="display-options-limit" id="per_page-field"></div> </fieldset> <fieldset class="form-group"> <div data-is="display-options-columns" id="display_columns-field"></div> </fieldset> <div if="{!listTop.opts.disableUserDispOption}" class="actions-bar actions-bar-bottom"> <a href="javascript:void(0);" id="reset-display-options" onclick="{resetColumns}"> {trans(\'Reset defaults\')} </a> </div> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')

    this.resetColumns = function(e) {
      this.store.trigger('reset_columns')
    }.bind(this)
});

riot.tag2('display-options-limit', '<div class="field-header"> <label>{trans(\'Show\')}</label> </div> <div class="field-content"> <select id="row" class="custom-select form-control" style="width: 100px;" ref="limit" riot-value="{store.limit}" onchange="{changeLimit}"> <option value="25">{trans(\'25 rows\')}</option> <option value="50">{trans(\'50 rows\')}</option> <option value="100">{trans(\'100 rows\')}</option> <option value="200">{trans(\'200 rows\')}</option> </select> </div>', '', '', function(opts) {
    this.mixin('listTop')

    this.changeLimit = function(e) {
      this.store.trigger('update_limit', this.refs.limit.value)
    }.bind(this)
});

riot.tag2('display-options-columns', '<div class="field-header"> <label>{trans(\'Column\')}</label> </div> <div if="{listTop.opts.disableUserDispOption}" class="alert alert-warning"> {trans(\'User Display Option is disabled now.\')} </div> <div if="{!listTop.opts.disableUserDispOption}" class="field-content"> <ul id="disp_cols" class="list-inline m-0"> <virtual each="{column in store.columns}"> <li hide="{column.force_display}" class="list-inline-item"> <label class="custom-control custom-checkbox"> <input type="checkbox" class="custom-control-input" id="{column.id}" checked="{column.checked}" onchange="{toggleColumn}"> <span class="custom-control-indicator"></span> <span class="custom-control-description"> <raw content="{column.label}"></raw> </span> </label> </li> <li each="{subField in column.sub_fields}" hide="{subField.force_display}" class="list-inline-item"> <label class="custom-control custom-checkbox"> <input type="checkbox" id="{subField.id}" pid="{subField.parent_id}" class="custom-control-input {subField.class}" disabled="{disabled: !column.checked}" checked="{subField.checked}" onchange="{toggleSubField}"> <span class="custom-control-indicator"></span> <span class="custom-control-description">{subField.label}</span> </label> </li> </virtual> </ul> </div>', '', '', function(opts) {
    this.mixin('listTop')

    this.toggleColumn = function(e) {
      this.store.trigger('toggle_column', e.currentTarget.id)
    }.bind(this)

    this.toggleSubField = function(e) {
      this.store.trigger('toggle_sub_field', e.currentTarget.id)
    }.bind(this)
});

riot.tag2('list-actions', '<button each="{action, key in listTop.opts.buttonActions}" class="btn btn-default mr-2" data-action-id="{key}" onclick="{doAction}"> {action.label} </button> <div if="{listTop.opts.hasListActions && listTop.opts.hasPulldownActions}" class="btn-group"> <button class="btn btn-default dropdown-toggle" data-toggle="dropdown"> {trans(\'More actions...\')} </button> <div class="dropdown-menu"> <a each="{action, key in listTop.opts.listActions}" class="dropdown-item" href="javascript:void(0);" data-action-id="{key}" onclick="{doAction}"> {action.label} </a> <h6 if="{Object.keys(listTop.opts.moreListActions).length > 0}" class="dropdown-header"> {trans(\'Plugin Actions\')} </h6> <a each="{action, key in listTop.opts.moreListActions}" class="dropdown-item" href="javascript:void(0);" data-action-id="{key}" onclick="{doAction}"> {action.label} </a> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')

    this.selectedActionId = null
    this.selectedAction = null

    this.doAction = function(e) {
      this.selectedActionId = e.target.dataset.actionId
      this.selectedAction = this.getAction(this.selectedActionId)
      this.selectedActionPhrase = this.selectedAction.js_message || trans('act upon')

      const args = {}

      if (!this.checkCount()) {
        return false
      }

      if (this.selectedAction.input) {
        const input = prompt(this.selectedAction.input)
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

      const requestArgs = this.generateRequestArguments(args)

      if (this.selectedAction.xhr) {
      } else if (this.selectedAction.dialog) {
        const requestData = this.listTop.opts.listActionClient.generateRequestData(requestArgs)
        requestData.dialog = 1
        const url = ScriptURI + '?' + jQuery.param(requestData, true)
        jQuery.fn.mtModal.open(url, { large: true });
      } else {
        this.sendRequest(requestArgs)
      }
    }.bind(this)

    this.sendRequest = function(postArgs) {
      this.listTop.opts.listActionClient.post(postArgs)
    }.bind(this)

    this.generateRequestArguments = function(args) {
      return jQuery.extend({
        action: this.selectedAction,
        actionName: this.selectedActionId,
        allSelected: this.store.checkedAllRows,
        ids: this.store.getCheckedRowIds()
      }, args)
    }.bind(this)

    this.getAction = function(actionId) {
      return this.listTop.opts.buttonActions[actionId]
        || this.listTop.opts.listActions[actionId]
        || this.listTop.opts.moreListActions[actionId]
        || null;
    }.bind(this)

    this.getCheckedRowCount = function() {
      return this.store.getCheckedRowCount()
    }.bind(this)

    this.checkCount = function() {
      const checkedRowCount = this.getCheckedRowCount()

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
    }.bind(this)

    this.alertNoSelectedError = function() {
      alert(trans(
        'You did not select any [_1] to [_2].',
        this.listTop.opts.plural,
        this.selectedActionPhrase
      ))
    }.bind(this)

    this.alertMinimumError = function() {
      alert(trans(
        'You can only act upon a minimum of [_1] [_2].',
        this.selectedAction.min,
        this.listTop.opts.plural
      ))
    }.bind(this)

    this.alertMaximumError = function() {
      alert(trans(
        'You can only act upon a maximum of [_1] [_2].',
        this.selectedAction.max,
        this.listTop.opts.plural
      ))
    }.bind(this)

    this.getConfirmMessage = function() {
      const checkedRowCount = this.getCheckedRowCount()

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
    }.bind(this)
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

    const self = this

    this.validateFilterName = function (name) {
      return !this.store.filters.some((filter) => {
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

    this.store.on('open_filter_detail', () => {
      jQuery('#list-filter-collapse').collapse('show')
    })

    this.store.on('close_filter_detail', () => {
      jQuery('#list-filter-collapse').collapse('hide')
    })

    this.addFilterItem = function(filterType) {
      if (this.isAllpassFilter()) {
        this.createNewFilter('Unknown Filter')
      }
      this.currentFilter.items.push({ type: filterType })
      this.update()
    }.bind(this)

    this.addFilterItemContent = function(itemIndex, contentIndex) {
      if (this.currentFilter.items[itemIndex].type != 'pack') {
        const items = [ this.currentFilter.items[itemIndex] ]
        this.currentFilter.items[itemIndex] = {
          type: 'pack',
          args: { op: 'and', items: items }
        }
      }
      const type = this.currentFilter.items[itemIndex].args.items[0].type
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
        label: trans( filterLabel || 'New Filter' )
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
      return this.currentFilter.items.some((item) => {
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
      let error_block
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
      let errors = 0
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
        let errorMessage
        if ( errors > 1 ) {
          errorMessage = '[_1] Filter Items have field(s) not filled in properly'
        } else {
          errorMessage = '[_1] Filter Item has field(s) not filled in properly'
        }
        this.$validateErrorMessage = this.showMessage(
          trans(errorMessage, errors ),
          'error'
        )
      }
      return errors ? false : true
    }.bind(this)
});

riot.tag2('list-filter-header', '<div class="row"> <div class="col-11"> <ul class="list-inline"> <li class="list-inline-item"> {trans(\'Filter:\')} </li> <li class="list-inline-item"> <a href="#" id="opener" data-toggle="modal" data-target="#select-filter"> <u>{trans( listFilterTop.currentFilter.label )}</u> </a> <virtual data-is="list-filter-select-modal"></virtual> </li> <li class="list-inline-item"> <a href="#" id="allpass-filter" if="{listFilterTop.isAllpassFilter() == false}" onclick="{resetFilter}"> [ {trans( \'Reset Filter\' )} ] </a> </li> </ul> </div> <div class="col-1"> <button id="toggle-filter-detail" class="btn btn-default dropdown-toggle float-right" data-toggle="collapse" data-target="#list-filter-collapse" aria-expanded="false" aria-controls="list-filter-collapse"></button> </div> </div>', '', '', function(opts) {
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
      const filterType = e.currentTarget.dataset.mtFilterType
      this.listFilterTop.addFilterItem(filterType)
    }.bind(this)
});

riot.tag2('list-filter-item', '<div class="filteritem"> <button class="close" aria-label="Close" onclick="{removeFilterItem}"> <span aria-hidden="true">&times;</span> </button> <div if="{opts.item.type == \'pack\'}"> <div each="{item, index in opts.item.args.items}" if="{filterTypeHash[item.type]}" data-mt-list-item-content-index="{index}" class="{\'filtertype type-\' + item.type}"> <div class="item-content form-inline"> <virtual data-is="list-filter-item-field" field="{filterTypeHash[item.type].field}" item="{item}"> </virtual> <a href="javascript:void(0);" if="{!filterTypeHash[item.type].singleton}" onclick="{addFilterItemContent}"> <svg title="{trans(\'Add\')}" role="img" class="mt-icon mt-icon--sm"> <use xlink:href="{StaticURI + \'images/sprite.svg#ic_add\'}"></use> </svg> </a> <a href="javascript:void(0);" if="{!filterTypeHash[item.type].singleton               && parent.opts.item.args.items.length > 1}" onclick="{removeFilterItemContent}"> <svg title="{trans(\'Remove\')}" role="img" class="mt-icon mt-icon--sm"> <use xlink:href="{StaticURI + \'images/sprite.svg#ic_remove\'}"></use> </svg> </a> </div> </div> </div> <virtual if="{opts.item.type != \'pack\' && filterTypeHash[opts.item.type]}"> <div data-mt-list-item-content-index="0" class="{\'filtertype type-\' + opts.item.type}"> <div class="item-content form-inline"> <virtual data-is="list-filter-item-field" field="{filterTypeHash[opts.item.type].field}" item="{opts.item}"> </virtual> <a href="javascript:void(0);" if="{!filterTypeHash[opts.item.type].singleton}" onclick="{addFilterItemContent}"> <svg title="{trans(\'Add\')}" role="img" class="mt-icon mt-icon--sm"> <use xlink:href="{StaticURI + \'images/sprite.svg#ic_add\'}"></use> </svg> </a> </div> </div> </virtual> </div>', '', '', function(opts) {
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
      const itemIndex = this.getListItemIndex(e.target)
      const contentIndex = this.getListItemContentIndex(e.target)
      this.listFilterTop.addFilterItemContent(itemIndex, contentIndex)
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
      const dateOption = ($node) => {
        const val = $node.val()
        let type;
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
        $node.parents('.item-content').find('input').mtUnvalidate()
        $node.parents('.item-content').find('.date-options span.date-option').hide()
        $node.parents('.item-content').find('.date-option.'+type).show()
      }
      jQuery(this.root).find('.filter-date').each((index, element) => {
        const $node = jQuery(element)
        dateOption($node)
        $node.on('change', () => { dateOption($node) })
      })
      jQuery(this.root).find('input.date').datepicker({
        dateFormat: 'yy-mm-dd',
        dayNamesMin: this.listFilterTop.opts.localeCalendarHeader,
        monthNames: ['- 01','- 02','- 03','- 04','- 05','- 06','- 07','- 08','- 09','- 10','- 11','- 12'],
        showMonthAfterYear: true,
        prevText: '&lt;',
        nextText: '&gt;',
        onSelect: function( dateText, inst ) {
          inst.input.mtValid();
        }
      })
    }.bind(this)

    this.initializeOptionWithBlank = function() {
      const changeOption = ($node) => {
        if ($node.val() == 'blank' || $node.val() == 'not_blank') {
          $node.parent().find('input[type=text]').hide()
        } else {
          $node.parent().find('input[type=text]').show()
        }
      }
      jQuery(this.root).find('.filter-blank').each((index, element) => {
        const $node = jQuery(element)
        changeOption($node)
        $node.on('change', () => { changeOption($node) })
      })
    }.bind(this)

    this.removeFilterItem = function(e) {
      const itemIndex = this.getListItemIndex(e.target)
      this.listFilterTop.removeFilterItem(itemIndex)
    }.bind(this)

    this.removeFilterItemContent = function(e) {
      const itemIndex = this.getListItemIndex(e.target)
      const contentIndex = this.getListItemContentIndex(e.target)
      this.listFilterTop.removeFilterItemContent(itemIndex, contentIndex)
    }.bind(this)
});

riot.tag2('list-filter-item-field', '<virtual></virtual>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.setValues = function() {
      for (let key in opts.item.args) {
        if (typeof opts.item.args[key] != 'string'
          && typeof opts.item.args[key] != 'number')
        {
          continue
        }
        const selector = '.' + opts.item.type + '-' + key
        this.root.querySelectorAll(selector).forEach((element) => {
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

riot.tag2('list-filter-select-modal', '<div class="modal fade" id="select-filter" tabindex="-1"> <div class="modal-dialog modal-sm"> <div class="modal-content"> <div class="modal-header"> <h5 class="modal-title">{trans( \'Select Filter\' )}</h5> <button type="button" class="close" data-dismiss="modal"><span>×</span></button> </div> <div class="modal-body"> <div class="filter-list-block"> <h6 class="filter-list-label">{trans( \'My Filters\' )}</h6> <ul id="user-filters" class="list-unstyled editable"> <li class="filter line" each="{store.filters}" if="{can_save == ⁗1⁗}" data-mt-list-filter-id="{id}" data-mt-list-filter-label="{label}"> <virtual if="{!parent.isEditingFilter[id]}"> <a href="#" onclick="{applyFilter}"> {label} </a> <div class="float-right"> <a href="#" onclick="{startEditingFilter}">[{trans( \'rename\' )}]</a> <a href="#" onclick="{removeFilter}">[{trans( \'remove\' )}]</a> </div> </virtual> <div class="form-inline" if="{parent.isEditingFilter[id]}"> <div class="form-group form-group-sm"> <input type="text" class="form-control rename-filter-input" riot-value="{label}" ref="label"> <button class="btn btn-default form-control" onclick="{renameFilter}"> {trans(\'Save\')} </button> <button class="btn btn-default form-control" onclick="{stopEditingFilter}"> {trans(\'Cancel\')} </button> </div> </div> </li> <li class="filter line"> <a href="#" id="new_filter" class="icon-mini-left addnew create-new apply-link" onclick="{createNewFilter}"> <svg title="{trans( \'Add\' )}" role="img" class="mt-icon mt-icon--sm"> <use xlink:href="{StaticURI + \'images/sprite.svg#ic_add\'}"></use> </svg> {trans( \'Create New\' )} </a> </li> </ul> </div> <div class="filter-list-block" if="{store.hasSystemFilter()}"> <h6 class="filter-list-label">{trans( \'Built in Filters\' )}</h6> <ul id="built-in-filters" class="list-unstyled"> <li class="filter line" each="{store.filters}" if="{can_save == ⁗0⁗}" data-mt-list-filter-id="{id}" data-mt-list-filter-label="{label}"> <a href="#" onclick="{applyFilter}"> {label} </a> </li> </ul> </div> </div> </div> </div> </div>', '', '', function(opts) {
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.isEditingFilter = {}

    this.applyFilter = function(e) {
      this.closeModal()
      const filterId = e.target.parentElement.dataset.mtListFilterId
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
      const filterData = e.target.parentElement.parentElement.parentElement.dataset
      this.store.trigger(
        'rename_filter_by_id',
        filterData.mtListFilterId,
        this.refs.label.value
      )
      this.isEditingFilter[filterData.mtListFilterId] = false
    }.bind(this)

    this.removeFilter = function(e) {
      const filterData = e.target.parentElement.parentElement.dataset
      const message = trans(
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
      const filterData = e.target.parentElement.parentElement.dataset
      this.isEditingFilter[filterData.mtListFilterId] = true
    }.bind(this)

    this.stopEditingAllFilters = function() {
      this.isEditingFilter = {}
    }.bind(this)

    this.stopEditingFilter = function(e) {
      const filterData = e.target.parentElement.parentElement.parentElement.dataset
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
      const noFilterId = true
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
        const filterLabel = this.store.getNewFilterLabel(this.listTop.opts.objectLabel)
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

riot.tag2('list-pagination', '<nav aria-label="{store.listClient.objectType + \' list\'}"> <ul class="pagination"> <li class="page-item"> <a href="javascript:void(0);" class="page-link" disabled="{store.page <= 1}" data-page="{store.page - 1}" onclick="{movePage}"> {trans(\'Previous\')} </a> </li> <virtual if="{store.page - 2 >= 1}"> <li class="page-item first-last"> <a href="javascript:void(0);" class="page-link" data-page="{1}" onclick="{movePage}"> 1 </a> </li> <li class="page-item" aria-hidden="true"> ... </li> </virtual> <li if="{store.page - 1 >= 1}" class="{\'page-item\': true, \'first-last\': store.page - 1 == 1}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page - 1}" onclick="{movePage}"> {store.page - 1} </a> </li> <li class="page-item active"> <a class="page-link"> {store.page} <span class="sr-only">(current)</span> </a> </li> <li if="{store.page + 1 <= store.pageMax}" class="{\'page-item\': true, \'first-last\': store.page + 1 == store.pageMax}"> <a href="javascript:void(0);" class="page-link" data-page="{store.page + 1}" onclick="{movePage}"> {store.page + 1} </a> </li> <virtual if="{store.page + 2 <= store.pageMax}"> <li class="page-item" aria-hidden="true"> ... </li> <li class="page-item first-last"> <a href="javascript:void(0);" class="page-link" data-page="{store.pageMax}" onclick="{movePage}"> {store.pageMax} </a> </li> </virtual> <li class="page-item"> <a href="javascript:void(0);" class="page-link" disabled="{store.page >= store.pageMax}" data-page="{store.page + 1}" onclick="{movePage}"> {trans(\'Next\')} </a> </li> </ul> </nav>', '', '', function(opts) {
    this.mixin('listTop')

    this.movePage = function(e) {
      if (e.currentTarget.disabled) {
        return false
      }

      let nextPage
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
      const moveToPagination = true
      this.store.trigger('move_page', nextPage, moveToPagination)
      return false
    }.bind(this)
});

riot.tag2('list-table', '<thead data-is="list-table-header"></thead> <tbody if="{store.isLoading}"> <tr> <td colspan="{store.columns.length + 1}"> {trans(\'Loading...\')} </td> </tr> </tbody> <tbody data-is="list-table-body" if="{!store.isLoading && store.objects}"> </tbody>', '', '', function(opts) {
    this.mixin('listTop')
});

riot.tag2('list-table-header', '<tr> <th class="mt-table__control"> <label class="custom-control custom-checkbox"> <input type="checkbox" class="custom-control-input" checked="{store.checkedAllRowsOnPage}" onchange="{toggleAllRowsOnPage}"> <span class="custom-control-indicator"></span> </label> </th> <th each="{store.columns}" scope="col" if="{checked}" data-id="{id}" class="{primary: primary,         sortable: sortable,         sorted: parent.store.sortBy == id}"> <a href="javascript:void(0)" if="{sortable}" onclick="{toggleSortColumn}" class="{mt-table__ascend: sortable && parent.store.sortBy == id && parent.store.sortOrder == \'ascend\',           mt-table__descend: sortable && parent.store.sortBy == id && parent.store.sortOrder == \'descend\'}"> <raw content="{label}"></raw> </a> <raw if="{!sortable}" content="{label}"></raw> </th> </tr>', '', '', function(opts) {
    this.mixin('listTop')

    this.toggleAllRowsOnPage = function(e) {
      this.store.trigger('toggle_all_rows_on_page')
    }.bind(this)

    this.toggleSortColumn = function(e) {
      const columnId = e.currentTarget.parentElement.dataset.id
      this.store.trigger('toggle_sort_column', columnId)
    }.bind(this)
});

riot.tag2('list-table-body', '<tr if="{store.objects.length == 0}"> <td colspan="{store.columns.length + 1}"> {trans(\'No [_1] could be found.\', listTop.opts.zeroStateLabel)} </td> </tr> <tr style="background-color: #ffffff;" if="{store.pageMax > 1 && store.checkedAllRowsOnPage && !store.checkedAllRows}"> <td colspan="{store.objects.length + 1}"> <a href="javascript:void(0);" onclick="{checkAllRows}"> {trans(\'Select all [_1] items\', store.count)} </a> </td> </tr> <tr class="success" if="{store.pageMax > 1 && store.checkedAllRows}"> <td colspan="{store.objects.length + 1}"> {trans(\'All [_1] items are selected\', store.count)} </td> </tr> <tr data-is="list-table-row" each="{obj, index in store.objects}" onclick="{parent.toggleRow}" class="{obj.checked ? \'mt-table__highlight\' : \'\'}" data-index="{index}" checked="{obj.checked}" object="{obj.object}"> </tr>', '', '', function(opts) {
    this.mixin('listTop')

    this.toggleRow = function(e) {
      if (e.target.tagName == 'A' || e.target.tagName == 'IMG' || e.target.tagName == 'svg') {
        return false
      }
      e.preventDefault()
      e.stopPropagation()
      this.store.trigger('toggle_row', e.currentTarget.dataset.index)
    }.bind(this)

    this.checkAllRows = function(e) {
      this.store.trigger('check_all_rows')
    }.bind(this)
});

riot.tag2('list-table-row', '<td> <label class="custom-control custom-checkbox" if="{opts.object[0]}"> <input type="checkbox" name="id" class="custom-control-input" riot-value="{opts.object[0]}" checked="{opts.checked}"> <span class="custom-control-indicator"></span> </label> </td> <td data-is="list-table-column" each="{content, index in opts.object}" if="{index > 0}" class="{(parent.store.columns[0].id == \'id\' && !parent.store.columns[0].checked)       ? parent.store.columns[index+1].id       : parent.store.columns[index].id}" content="{content}"> </td>', '', '', function(opts) {
    this.mixin('listTop')
});

riot.tag2('list-table-column', '<virtual></virtual>', '', '', function(opts) {
    this.root.innerHTML = opts.content
});

riot.tag2('list-top', '<div class="mb-3" data-is="display-options"></div> <div class="row mb-3"> <div data-is="list-actions" if="{opts.useActions}" class="col-12"> </div> </div> <div class="row mb-3"> <div class="col-12"> <div class="card"> <virtual data-is="list-filter" if="{opts.useFilters}"> </virtual> <table data-is="list-table" id="{opts.objectType}-table" class="table mt-table list-{opts.objectType}"> </table> </div> </div> </div> <div class="row" hide="{opts.store.count == 0}"> <div data-is="list-pagination" class="col-12"></div> </div>', '', '', function(opts) {
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
    this.mixin('listTop')

    const self = this

    opts.store.on('refresh_view', function (moveToPagination) {
      self.update()
      self.updateSubFields()
      if (moveToPagination) {
        window.document.body.scrollTop = window.document.body.scrollHeight
      }
    })

    this.on('mount', function () {
      this.opts.store.trigger('load_list')
    })

    this.updateSubFields = function() {
      opts.store.columns.forEach((column) => {
        column.sub_fields.forEach((subField) => {
          const selector = `td.${subField.parent_id} .${subField.class}`
          if (subField.checked) {
            jQuery(selector).show()
          } else {
            jQuery(selector).hide()
          }
        })
      })
    }.bind(this)
});

riot.tag2('raw', '<span></span>', '', '', function(opts) {

  this.root.innerHTML = opts.content
});
