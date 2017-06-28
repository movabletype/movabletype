<list-actions>
  <ul class="list-inline">
    <li each={ action, key in opts.buttonActions }>
      <button class="btn btn-default"
        data-action-id={ key }
        onclick={ doAction }
      >
        { action.label }
      </button>
    </li>
    <li if={ opts.hasListActions && opts.hasPulldownActions }>
      <div class="dropdown">
        <button class="btn btn-default" data-toggle="dropdown">
          { trans('More actions...') }
          <span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
          <li each={ action, key in opts.listActions }>
            <a href="javascript:void(0);"
              data-action-id={ key }
              onclick={ doAction }
            >
              { action.label }
            </a>
          </li>
          <li if={ Object.keys(opts.moreListActions).length > 0 } class="dropdown-header">
            { trans('Plugin Actions') }
          </li>
          <li each={ action, key in opts.moreListActions }>
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
        const requestData = opts.listActionClient.generateRequestData(requestArgs)
        requestData.dialog = 1
        const url = MT.App.ScriptURL + '?' + $.param(requestData, true);
        $.fn.mtModal.open(url, { large: true });
      } else {
        this.sendRequest(requestArgs)
      }
    }

    sendRequest(postArgs) {
      opts.listActionClient.post(postArgs)
    }

    generateRequestArguments(args) {
      return $.extend({
        action: this.selectedAction,
        actionName: this.selectedActionId,
        allSelected: opts.store.checkedAllRows,
        ids: opts.store.getCheckedRowIds()
      }, args)
    }

    getAction(actionId) {
      return opts.buttonActions[actionId]
        || opts.listActions[actionId]
        || opts.moreListActions[actionId]
        || null;
    }

    getCheckedRowCount() {
      return opts.store.getCheckedRowCount()
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
        opts.plural,
        this.selectedActionPhrase
      ))
    }

    alertMinimumError() {
      alert(trans(
        'You can only act upon a minimum of [_1] [_2].',
        this.selectedAction.min,
        opts.plural
      ))
    }

    alertMaximumError() {
      alert(trans(
        'You can only act upon a maximum of [_1] [_2].',
        this.selectedAction.max,
        opts.plural
      ))
    }

    getConfirmMessage() {
      const checkedRowCount = this.getCheckedRowCount()

      if (checkedRowCount == 1) {
        return trans(
          'Are you sure you want to [_2] this [_1]?',
          opts.singular,
          this.selectedActionPhrase
        )
      } else {
        return trans(
          'Are you sure you want to [_3] the [_1] selected [_2]?',
          checkedRowCount,
          opts.plural,
          this.selectedActionPhrase
        );
      }
    }
  </script>
</list-actions>
