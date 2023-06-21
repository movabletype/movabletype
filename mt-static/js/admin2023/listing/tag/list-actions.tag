<list-actions>
  <div data-is="list-actions-for-pc"
    class="d-none d-md-block"
  ></div>
  <div data-is="list-actions-for-mobile"
    class="d-md-none"
  ></div>

  <script>
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
  </script>
</list-actions>

