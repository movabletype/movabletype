<list-actions-for-mobile>
  <div if={ hasActionForMobile() }
    class="btn-group"
  >
    <button class="btn btn-default dropdown-toggle"
      data-toggle="dropdown">
      { trans('Select action') }
    </button>
    <div class="dropdown-menu">
      <a each={ action, key in buttonActionsForMobile() }
        class="dropdown-item"
        href="javascript:void(0);"
        data-action-id={ key }
        onclick={ doAction }
      >
        { action.label }
      </a>
      <a each={ action, key in listActionsForMobile() }
        class="dropdown-item"
        href="javascript:void(0);"
        data-action-id={ key }
        onclick={ doAction }
      >
        { action.label }
      </a>
      <h6 if={ moreListActionsForMobile() > 0 }
        class="dropdown-header"
      >
        { trans('Plugin Actions') }
      </h6>
      <a each={ action, key in moreListActionsForMobile() }
        class="dropdown-item"
        href="javascript:void(0);"
        data-action-id={ key }
        onclick={ doAction }
      >
        { action.label }
      </a>
    </div>
  </div>

  <script>
    this.mixin('listTop')
    this.mixin('listActions')

    buttonActionsForMobile() {
      return this._getActionsForMobile(this.listTop.opts.buttonActions)
    }

    listActionsForMobile() {
      return this._getActionsForMobile(this.listTop.opts.listActions)
    }

    moreListActionsForMobile() {
      return this._getActionsForMobile(this.listTop.opts.moreListActions)
    }

    _getActionsForMobile(actions) {
      var mobileActions = {}
      Object.keys(actions).forEach(function (key) {
        var action = actions[key]
        if (action.mobile) {
          mobileActions[key] = action
        }
      })
      return mobileActions
    }

    hasActionForMobile() {
      var mobileActionCount = Object.keys(this.buttonActionsForMobile()).length
        + Object.keys(this.listActionsForMobile()).length
        + Object.keys(this.moreListActionsForMobile()).length
      return mobileActionCount > 0
    }
  </script>
</list-actions-for-mobile>

