<list-filter>
  <div data-is="list-filter-header" class="card-header"></div>
  <div id="list-filter-collapse" class="collapse">
    <div data-is="list-filter-detail" id="filter-detail" class="card-block p-3">
    </div>
  </div>

  <script>
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

    validateFilterName (name) {
      return !this.store.filters.some(function (filter) {
        return filter.label == name
      })
    }

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

    addFilterItem(filterType) {
      if (this.isAllpassFilter()) {
        this.createNewFilter(trans('New Filter'))
      }
      this.currentFilter.items.push({ type: filterType, args: {} })
      this.update()
    }

    addFilterItemContent(itemIndex, contentIndex) {
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
    }

    createNewFilter(filterLabel) {
      this.currentFilter = {
        items: [],
        label: filterLabel || trans('New Filter')
      }
    }

    getItemValues() {
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
    }

    isAllpassFilter() {
      return this.currentFilter.id == this.store.allpassFilter.id
    }

    isFilterItemSelected(type) {
      return this.currentFilter.items.some(function (item) {
        return item.type == type
      })
    }

    isUserFilter() {
      return this.currentFilter.id && this.currentFilter.id.match(/^[1-9][0-9]*$/)
    }

    removeFilterItem(itemIndex) {
      this.currentFilter.items.splice(itemIndex, 1)
      this.update()
    }

    removeFilterItemContent(itemIndex, contentIndex) {
      this.currentFilter.items[itemIndex].args.items.splice(contentIndex, 1)
    }

    showMessage( content, cls ){
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
    }

    validateFilterDetails () {
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
    }
  </script>
</list-filter>

<list-filter-header>
  <div class="row">
    <div class="col-12 col-md-11">
      <ul class="list-inline mb-0">
        <li class="list-inline-item">
          { trans('Filter:') }
        </li>
        <li class="list-inline-item">
          <a href="#"
            id="opener"
            data-toggle="modal"
            data-target="#select-filter"
          >
            <u>{ trans( listFilterTop.currentFilter.label ) }</u>
          </a>
          <virtual data-is="list-filter-select-modal"></virtual>
        </li>
        <li class="list-inline-item">
          <a href="#"
            id="allpass-filter"
            if={ listFilterTop.isAllpassFilter() == false }
            onclick={ resetFilter }
          >
            [ { trans( 'Reset Filter' ) } ]
          </a>
        </li>
      </ul>
    </div>
    <div class="d-none d-md-block col-md-1">
      <button id="toggle-filter-detail"
        class="btn btn-default dropdown-toggle float-right"
        data-toggle="collapse"
        data-target="#list-filter-collapse"
        aria-expanded="false"
        aria-controls="list-filter-collapse"
      ></button>
    </div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('listFilterTop')

    resetFilter(e) {
      this.listTop.opts.listActionClient.removeFilterKeyFromReturnArgs()
      this.listTop.opts.listActionClient.removeFilterItemFromReturnArgs()
      this.store.trigger('close_filter_detail')
      this.store.trigger('reset_filter')
    }
  </script>
</list-filter-header>

<list-filter-detail>
  <div class="row">
    <div class="col-12">
      <ul class="list-inline">
        <li class="list-inline-item">
          <div class="dropdown">
            <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
              { trans('Select Filter Item...') }
            </button>
            <div class="dropdown-menu">
              <a each={ listTop.opts.filterTypes }
                if={ editable }
                class={ disabled: parent.listFilterTop.isFilterItemSelected(type), dropdown-item: true }
                href="#"
                data-mt-filter-type={ type }
                onclick={ addFilterItem }
              >
                <raw content={ label }></raw>
              </a>
            </div>
          </div>
        </li>
      </ul>
    </div>
  </div>
  <div class="row mb-3">
    <div class="col-12">
      <ul class="list-group">
        <li data-is="list-filter-item"
          each={ item, index in listFilterTop.currentFilter.items }
          data-mt-list-item-index={ index }
          item={ item }
          class="list-group-item">
        </li>
      </ul>
    </div>
  </div>
  <div class="row">
    <div data-is="list-filter-buttons" class="col-12"></div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('listFilterTop')

    addFilterItem(e) {
      if (e.currentTarget.classList.contains('disabled')) {
        e.preventDefault()
        e.stopPropagation()
        return
      }
      var filterType = e.currentTarget.dataset.mtFilterType
      this.listFilterTop.addFilterItem(filterType)
    }
  </script>
</list-filter-detail>

<list-filter-item>
  <div class="filteritem">
    <button class="close" aria-label="Close" onclick={ removeFilterItem }>
      <span aria-hidden="true">&times;</span>
    </button>
    <div if={ opts.item.type == 'pack' }>
      <div each={ item, index in opts.item.args.items }
        if={ filterTypeHash[item.type] }
        data-mt-list-item-content-index={ index }
        class={ 'filtertype type-' + item.type }
      >
        <div class="item-content form-inline">
          <virtual data-is="list-filter-item-field"
            field={ filterTypeHash[item.type].field }
            item={ item }
          >
          </virtual>
          <a href="javascript:void(0);"
            class="d-inline-block"
            if={ !filterTypeHash[item.type].singleton }
            onclick={ addFilterItemContent }
          >
            <ss title={ trans('Add') }
              class="mt-icon mt-icon--sm"
              href={ StaticURI + 'images/sprite.svg#ic_add' }
            >
            </ss>
          </a>
          <a href="javascript:void(0);"
            if={ !filterTypeHash[item.type].singleton
              && parent.opts.item.args.items.length > 1 }
            onclick={ removeFilterItemContent }
          >
            <ss title={ trans('Remove') }
              class="mt-icon mt-icon--sm"
              href={ StaticURI + 'images/sprite.svg#ic_remove' }
            >
            </ss>
          </a>
        </div>
      </div>
    </div>
    <virtual if={ opts.item.type != 'pack' && filterTypeHash[opts.item.type] }>
      <div data-mt-list-item-content-index="0"
        class={ 'filtertype type-' + opts.item.type }
      >
        <div class="item-content form-inline">
          <virtual data-is="list-filter-item-field"
            field={ filterTypeHash[opts.item.type].field }
            item={ opts.item }
          >
          </virtual>
          <a href="javascript:void(0);"
            class="d-inline-block"
            if={ !filterTypeHash[opts.item.type].singleton }
            onclick={ addFilterItemContent }
          >
            <ss title={ trans('Add') }
              class="mt-icon mt-icon--sm"
              href={ StaticURI + 'images/sprite.svg#ic_add' }
            >
            </ss>
          </a>
        </div>
      </div>
    </virtual>
  </div>

  <script>
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

    addFilterItemContent(e) {
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
    }

    getListItemIndex(element) {
      while (!element.dataset.hasOwnProperty('mtListItemIndex')) {
        element = element.parentElement
      }
      return Number(element.dataset.mtListItemIndex)
    }

    getListItemContentIndex(element) {
      while (!element.dataset.hasOwnProperty('mtListItemContentIndex')) {
        element = element.parentElement
      }
      return Number(element.dataset.mtListItemContentIndex)
    }

    initializeDateOption() {
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
    }

    initializeOptionWithBlank() {
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
    }

    removeFilterItem(e) {
      var itemIndex = this.getListItemIndex(e.target)
      this.listFilterTop.removeFilterItem(itemIndex)
    }

    removeFilterItemContent(e) {
      var itemIndex = this.getListItemIndex(e.target)
      var contentIndex = this.getListItemContentIndex(e.target)
      this.listFilterTop.removeFilterItemContent(itemIndex, contentIndex)
    }
  </script>
</list-filter-item>

<list-filter-item-field>
  <virtual></virtual>

  <script>
    this.mixin('listTop')
    this.mixin('listFilterTop')

    setValues() {
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
    }

    this.root.innerHTML = opts.field
    this.setValues()
  </script>
</list-filter-item-field>

<list-filter-select-modal>
  <div class="modal fade" id="select-filter" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{ trans( 'Select Filter' ) }</h5>
          <button type="button" class="close" data-dismiss="modal"><span>×</span></button>
        </div>
        <div class="modal-body">
          <div class="filter-list-block">
            <h6 class="filter-list-label">{ trans( 'My Filters' ) }</h6>
            <ul id="user-filters" class="list-unstyled editable">
              <li class="filter line"
                each={ store.filters }
                if={ can_save == "1" }
                data-mt-list-filter-id={ id }
                data-mt-list-filter-label={ label }
              >
                <virtual if={ !parent.isEditingFilter[id] }>
                  <a href="#" onclick={ applyFilter }>
                    { label }
                  </a>
                  <div class="float-right d-none d-md-block">
                    <a href="#" onclick={ startEditingFilter }>[{ trans( 'rename' ) }]</a>
                    <a href="#" class="d-inline-block" onclick={ removeFilter }>
                      <ss title={ trans('Remove') }
                        class="mt-icon mt-icon--sm"
                        href={ StaticURI + 'images/sprite.svg#ic_trash' }
                      >
                      </ss>
                    </a>
                  </div>
                </virtual>
                <div class="form-inline" if={ parent.isEditingFilter[id] }>
                  <div class="form-group form-group-sm">
                    <input type="text" class="form-control rename-filter-input" value={ label } ref="label" />
                    <button class="btn btn-default form-control" onclick={ renameFilter }>
                      { trans('Save') }
                    </button>
                    <button class="btn btn-default form-control" onclick={ stopEditingFilter }>
                      { trans('Cancel') }
                    </button>
                  </div>
                </div>
              </li>
              <li class="filter line d-none d-md-block">
                <a href="#"
                  id="new_filter"
                  class="icon-mini-left addnew create-new apply-link d-md-inline-block"
                  onclick={ createNewFilter }
                >
                  <ss title={ trans('Add') }
                    class="mt-icon mt-icon--sm"
                    href={ StaticURI + 'images/sprite.svg#ic_add' }
                  >
                  </ss>
                  { trans( 'Create New' ) }
                </a>
              </li>
            </ul>
          </div>
          <div class="filter-list-block" if={ store.hasSystemFilter() }>
            <h6 class="filter-list-label">{ trans( 'Built in Filters' ) }</h6>
            <ul id="built-in-filters" class="list-unstyled">
              <li class="filter line"
                each={ store.filters }
                if={ can_save == "0" }
                data-mt-list-filter-id={ id }
                data-mt-list-filter-label={ label }
              >
                <a href="#" onclick={ applyFilter }>
                  { label }
                </a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('listFilterTop')

    this.isEditingFilter = {}

    applyFilter(e) {
      this.closeModal()
      var filterId = e.target.parentElement.dataset.mtListFilterId
      this.store.trigger('apply_filter_by_id', filterId)
    }

    closeModal() {
      jQuery('#select-filter').modal('hide')
    }

    createNewFilter(e) {
      this.closeModal();
      this.store.trigger('open_filter_detail')
      this.listFilterTop.createNewFilter()
      this.listFilterTop.update()
    }

    renameFilter(e) {
      var filterData = e.target.parentElement.parentElement.parentElement.dataset
      this.store.trigger(
        'rename_filter_by_id',
        filterData.mtListFilterId,
        this.refs.label.value
      )
      this.isEditingFilter[filterData.mtListFilterId] = false
    }

    removeFilter(e) {
      var filterData = e.target.closest('[data-mt-list-filter-label]').dataset
      var message = trans(
        "Are you sure you want to remove filter '[_1]'?",
        filterData.mtListFilterLabel
      )
      if (confirm(message) == false) {
        return false
      }
      this.store.trigger('remove_filter_by_id', filterData.mtListFilterId)
    }

    startEditingFilter(e) {
      this.stopEditingAllFilters()
      var filterData = e.target.parentElement.parentElement.dataset
      this.isEditingFilter[filterData.mtListFilterId] = true
    }

    stopEditingAllFilters() {
      this.isEditingFilter = {}
    }

    stopEditingFilter(e) {
      var filterData = e.target.parentElement.parentElement.parentElement.dataset
      this.isEditingFilter[filterData.mtListFilterId] = false
    }
  </script>
</list-filter-select-modal>

<list-filter-buttons>
  <button class="btn btn-primary"
    disabled={ listFilterTop.currentFilter.items.length == 0 }
    onclick={ applyFilter }
  >
    { trans('Apply') }
  </button>
  <button class="btn btn-default"
    disabled={ listFilterTop.currentFilter.items.length == 0
      || listFilterTop.currentFilter.can_save == '0'
    }
    onclick={ saveFilter }
  >
    { trans('Save') }
  </button>
  <button if={ listFilterTop.currentFilter.id && listFilterTop.currentFilter.items.length > 0 }
    class="btn btn-default"
    onclick={ saveAsFilter }
  >
    { trans('Save As') }
  </button>
  <list-filter-save-modal></list-filter-save-modal>

  <script>
    this.mixin('listTop')
    this.mixin('listFilterTop')

    applyFilter(e) {
      if (!this.listFilterTop.validateFilterDetails()) {
        return false
      }
      this.listFilterTop.getItemValues()
      var noFilterId = true
      this.store.trigger('apply_filter', this.listFilterTop.currentFilter, noFilterId)
    }

    saveFilter(e) {
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
    }

    saveAsFilter(e) {
      if (!this.listFilterTop.validateFilterDetails()) {
        return false
      }
      this.tags['list-filter-save-modal'].openModal({
        filterLabel: this.listFilterTop.currentFilter.label,
        saveAs: true
      })
    }
  </script>
</list-filter-buttons>

<list-filter-save-modal>
  <div id="save-filter" class="modal fade" tabindex="-1" ref="modal">
    <div class="modal-dialog modal-sm">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{ trans( saveAs ? 'Save As Filter' : 'Save Filter' ) }</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" data-mt-modal-close>
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div style="padding-bottom: 30px;">
            <h6>{ trans('Filter Label') }</h6>
            <input type="text"
              class="text full required form-control"
              name="filter_name"
              ref="filterName"
            />
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-primary" onclick={ saveFilter }>
            { trans('Save') }
          </button>
          <button class="btn btn-default" onclick={ closeModal }>
            { trans('Cancel') }
          </button>
        </div>
      </div>
    </div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('listFilterTop')

    closeModal(e) {
      jQuery(this.refs.modal).modal('hide')
    }

    openModal(args) {
      if (!args) {
        args = {}
      }
      jQuery(this.refs.filterName).mtUnvalidate()
      if (args.filterLabel) {
        this.refs.filterName.value = args.filterLabel
      }
      this.saveAs = args.saveAs
      jQuery(this.refs.modal).modal()
    }

    saveFilter(e) {
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
    }
  </script>
</list-filter-save-modal>

