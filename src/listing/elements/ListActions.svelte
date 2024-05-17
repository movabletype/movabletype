<script>
  import ListActionsForMobile from "./ListActionsForMobile.svelte";
  import ListActionsForPc from "./ListActionsForPc.svelte";

  export let buttonActions;
  export let hasPulldownActions;
  export let listActions;
  export let listActionClient;
  export let moreListActions;
  export let plural;
  export let singular;
  export let store;

  let selectedAction;
  let selectedActionId;
  let selectedActionPhrase;

  function doAction(actionId) {
    selectedActionId = actionId;
    selectedAction = getAction(selectedActionId);
    selectedActionPhrase =
      selectedAction.js_message || window.trans("act upon");

    const args = {};

    if (!checkCount()) {
      return false;
    }

    if (selectedAction.input) {
      const input = prompt(selectedAction.input);
      if (input) {
        args.itemsetActionInput = input;
      } else {
        return false;
      }
    }

    if (!selectedAction.no_prompt) {
      if (selectedAction.continue_prompt) {
        if (!confirm(selectedAction.continue_prompt)) {
          return false;
        }
      } else {
        if (!confirm(getConfirmMessage())) {
          return false;
        }
      }
    }

    const requestArgs = generateRequestArguments(args);

    if (!selectedAction.xhr) {
      if (selectedAction.dialog) {
        const requestData = listActionClient.generateRequestData(requestArgs);
        requestData.dialog = 1;
        const url = window.ScriptURI + "?" + jQuery.param(requestData, true);
        jQuery.fn.mtModal.open(url, { large: true });
      } else {
        sendRequest(requestArgs);
      }
    }
  }

  function sendRequest(postArgs) {
    listActionClient.post(postArgs);
  }

  function generateRequestArguments(args) {
    return {
      action: selectedAction,
      actionName: selectedActionId,
      allSelected: store.checkedAllRows,
      filter: store.currentFilter,
      ids: store.getCheckedRowIds(),
      ...args,
    };
  }

  function getAction(actionId) {
    return (
      buttonActions[actionId] ||
      listActions[actionId] ||
      moreListActions[actionId] ||
      null
    );
  }

  function getCheckedRowCount() {
    return store.getCheckedRowCount();
  }

  function checkCount() {
    const checkedRowCount = getCheckedRowCount();

    if (checkedRowCount == 0) {
      alertNoSelectedError();
      return false;
    }
    if (selectedAction.min && checkedRowCount < selectedAction.min) {
      alertMinimumError();
      return false;
    }
    if (selectedAction.max && checkedRowCount > selectedAction.max) {
      alertMaximumError();
      return false;
    }
    return true;
  }

  function alertNoSelectedError() {
    alert(
      trans(
        "You did not select any [_1] to [_2].",
        plural,
        selectedActionPhrase
      )
    );
  }

  function alertMinimumError() {
    alert(
      trans(
        "You can only act upon a minimum of [_1] [_2].",
        selectedAction.min,
        plural
      )
    );
  }

  function alertMaximumError() {
    alert(
      trans(
        "You can only act upon a maximum of [_1] [_2].",
        selectedAction.max,
        plural
      )
    );
  }

  function getConfirmMessage() {
    const checkedRowCount = getCheckedRowCount();

    if (checkedRowCount == 1) {
      return trans(
        "Are you sure you want to [_2] this [_1]?",
        singular,
        selectedActionPhrase
      );
    } else {
      return trans(
        "Are you sure you want to [_3] the [_1] selected [_2]?",
        checkedRowCount,
        plural,
        selectedActionPhrase
      );
    }
  }
</script>

<div class="d-none d-md-block">
  <ListActionsForPc
    {buttonActions}
    {doAction}
    {listActions}
    {hasPulldownActions}
    {moreListActions}
  />
</div>
<div class="d-md-none">
  <ListActionsForMobile
    {buttonActions}
    {doAction}
    {listActions}
    {moreListActions}
  />
</div>
