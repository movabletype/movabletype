<script>
  import ListActionsForPc from "./ListActionsForPc.svelte";
  import ListActionsForMobile from "./ListActionsForMobile.svelte";
  import { ListingStore, ListingOpts } from "../ListingStore.ts";

  function doAction(event) {
    console.log("do action");
    //    this.selectedActionId = e.target.dataset.actionId
    //        this.selectedAction = this.getAction(this.selectedActionId)
    //        this.selectedActionPhrase = this.selectedAction.js_message || trans('act upon')
    //
    //        var args = {}
    //
    //        if (!this.checkCount()) {
    //          return false
    //        }
    //
    //        if (this.selectedAction.input) {
    //          var input = prompt(this.selectedAction.input)
    //          if (input) {
    //            args.itemsetActionInput = input
    //          } else {
    //            return false
    //          }
    //        }
    //
    //        if (!this.selectedAction.no_prompt) {
    //          if (this.selectedAction.continue_prompt) {
    //            if (!confirm(this.selectedAction.continue_prompt)) {
    //              return false
    //            }
    //          } else {
    //            if (!confirm(this.getConfirmMessage())) {
    //              return false
    //            }
    //          }
    //        }
    //
    //        var requestArgs = this.generateRequestArguments(args)
    //
    //        if (this.selectedAction.xhr) {
    //        } else if (this.selectedAction.dialog) {
    //          var requestData = this.listTop.opts.listActionClient.generateRequestData(requestArgs)
    //          requestData.dialog = 1
    //          var url = ScriptURI + '?' + jQuery.param(requestData, true)
    //          jQuery.fn.mtModal.open(url, { large: true });
    //        } else {
    //          this.sendRequest(requestArgs)
    //        }
  }

  function sendRequest(postArgs) {
    this.listTop.opts.listActionClient.post(postArgs);
  }

  function generateRequestArguments(args) {
    return {
      action: this.selectedAction,
      actionName: this.selectedActionId,
      allSelected: this.checkedAllRows,
      filter: this.currentFilter,
      ids: this.checkedRowIds,
      ...args,
    };
  }

  function getAction(actionId) {
    return (
      this.listTop.opts.buttonActions[actionId] ||
      this.listTop.opts.listActions[actionId] ||
      this.listTop.opts.moreListActions[actionId] ||
      null
    );
  }

  function getCheckedRowCount() {
    return this.store.getCheckedRowCount();
  }

  function checkCount() {
    let checkedRowCount = this.getCheckedRowCount();

    if (checkedRowCount == 0) {
      this.alertNoSelectedError();
      return false;
    }
    if (this.selectedAction.min && checkedRowCount < this.selectedAction.min) {
      this.alertMinimumError();
      return false;
    }
    if (this.selectedAction.max && checkedRowCount > this.selectedAction.max) {
      this.alertMaximumError();
      return false;
    }
    return true;
  }

  function alertNoSelectedError() {
    alert(
      trans(
        "You did not select any [_1] to [_2].",
        this.listTop.opts.plural,
        this.selectedActionPhrase
      )
    );
  }

  function alertMinimumError() {
    alert(
      trans(
        "You can only act upon a minimum of [_1] [_2].",
        this.selectedAction.min,
        this.listTop.opts.plural
      )
    );
  }

  function alertMaximumError() {
    alert(
      trans(
        "You can only act upon a maximum of [_1] [_2].",
        this.selectedAction.max,
        this.listTop.opts.plural
      )
    );
  }

  function getConfirmMessage() {
    let checkedRowCount = this.getCheckedRowCount();

    if (checkedRowCount == 1) {
      return trans(
        "Are you sure you want to [_2] this [_1]?",
        this.listTop.opts.singular,
        this.selectedActionPhrase
      );
    } else {
      return trans(
        "Are you sure you want to [_3] the [_1] selected [_2]?",
        checkedRowCount,
        this.listTop.opts.plural,
        this.selectedActionPhrase
      );
    }
  }
</script>

<div class="d-none d-md-block">
  <ListActionsForPc {doAction} />
</div>
<div class="d-md-none">
  <ListActionsForMobile {doAction} />
</div>
