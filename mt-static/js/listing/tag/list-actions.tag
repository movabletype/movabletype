<list-actions>
  <ul class="list-inline">
    <li each={ action, key in listTop.opts.buttonActions }>
      <button class="btn btn-default"
        data-action-id={ key }
        onclick={ doAction }
      >
        { action.label }
      </button>
    </li>
    <li if={ listTop.opts.hasListActions && listTop.opts.hasPulldownActions }>
      <div class="dropdown">
        <button class="btn btn-default" data-toggle="dropdown">
          { trans('More actions...') }
          <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
          <li each={ action, key in listTop.opts.listActions }>
            <a href="javascript:void(0);"
              data-action-id={ key }
              onclick={ doAction }
            >
              { action.label }
            </a>
          </li>
          <li if={ Object.keys(listTop.opts.moreListActions).length > 0 }
            class="dropdown-header"
          >
            { trans('Plugin Actions') }
          </li>
          <li each={ action, key in listTop.opts.moreListActions }>
            <a href="javascript:void(0);"
              data-action-id={ key }
              onclick={ doAction }
            >
              { action.label }
            </a>
          </li>
        </ul>
      </div>
    </li>
  </ul>

  <script>
    this.mixin('listTop')

    this.selectedActionId = null
    this.selectedAction = null

    doAction(e) {
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
    }

    sendRequest(postArgs) {
      this.listTop.opts.listActionClient.post(postArgs)
    }

    generateRequestArguments(args) {
      return jQuery.extend({
        action: this.selectedAction,
        actionName: this.selectedActionId,
        allSelected: this.store.checkedAllRows,
        ids: this.store.getCheckedRowIds()
      }, args)
    }

    getAction(actionId) {
      return this.listTop.opts.buttonActions[actionId]
        || this.listTop.opts.listActions[actionId]
        || this.listTop.opts.moreListActions[actionId]
        || null;
    }

    getCheckedRowCount() {
      return this.store.getCheckedRowCount()
    }

    checkCount() {
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
    }

    alertNoSelectedError() {
      alert(trans(
        'You did not select any [_1] to [_2].',
        this.listTop.opts.plural,
        this.selectedActionPhrase
      ))
    }

    alertMinimumError() {
      alert(trans(
        'You can only act upon a minimum of [_1] [_2].',
        this.selectedAction.min,
        this.listTop.opts.plural
      ))
    }

    alertMaximumError() {
      alert(trans(
        'You can only act upon a maximum of [_1] [_2].',
        this.selectedAction.max,
        this.listTop.opts.plural
      ))
    }

    getConfirmMessage() {
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
    }
  </script>
</list-actions>
