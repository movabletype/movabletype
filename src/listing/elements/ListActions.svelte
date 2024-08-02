<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import ListActionsForMobile from "./ListActionsForMobile.svelte";
  import ListActionsForPc from "./ListActionsForPc.svelte";

  export let buttonActions: Listing.ButtonActions;
  export let hasPulldownActions: boolean;
  export let listActions: Listing.ListActions;
  export let listActionClient: Listing.ListActionClient;
  export let moreListActions: Listing.MoreListActions;
  export let plural: string;
  export let singular: string;
  export let store: Listing.ListStore;

  let selectedAction:
    | Listing.ButtonAction
    | Listing.ListAction
    | Listing.MoreListAction
    | null;
  let selectedActionId: string;
  let selectedActionPhrase: string;

  const doAction = (e: Event): boolean | undefined => {
    selectedActionId = (e.target as HTMLElement)?.dataset.actionId || "";
    selectedAction = getAction(selectedActionId);
    if (!selectedAction) {
      return false;
    }
    selectedActionPhrase =
      selectedAction.js_message || window.trans("act upon");

    const args: { itemsetActionInput?: string } = {};

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
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const requestData: any =
          listActionClient.generateRequestData(requestArgs);
        requestData.dialog = 1;
        const url = window.ScriptURI + "?" + jQuery.param(requestData, true);
        /* @ts-expect-error : mtModal is not defined */
        jQuery.fn.mtModal.open(url, { large: true });
      } else {
        sendRequest(requestArgs);
      }
    }
  };

  const sendRequest = (postArgs: object): void => {
    listActionClient.post(postArgs);
  };

  const generateRequestArguments = (args: object): object => {
    return {
      action: selectedAction,
      actionName: selectedActionId,
      allSelected: store.checkedAllRows,
      filter: store.currentFilter,
      ids: store.getCheckedRowIds(),
      ...args,
    };
  };

  const getAction = (
    actionId: string,
  ):
    | Listing.ButtonAction
    | Listing.ListAction
    | Listing.MoreListAction
    | null => {
    return (
      buttonActions[actionId] ||
      listActions[actionId] ||
      moreListActions[actionId] ||
      null
    );
  };

  const getCheckedRowCount = (): number => {
    return store.getCheckedRowCount();
  };

  const checkCount = (): boolean => {
    const checkedRowCount = getCheckedRowCount();

    if (!checkedRowCount) {
      alertNoSelectedError();
      return false;
    }
    if (
      selectedAction &&
      selectedAction.min &&
      checkedRowCount < Number(selectedAction.min)
    ) {
      alertMinimumError();
      return false;
    }
    if (
      selectedAction &&
      selectedAction.max &&
      checkedRowCount > Number(selectedAction.max)
    ) {
      alertMaximumError();
      return false;
    }
    return true;
  };

  const alertNoSelectedError = (): void => {
    alert(
      window.trans(
        "You did not select any [_1] to [_2].",
        plural,
        selectedActionPhrase,
      ),
    );
  };

  const alertMinimumError = (): void => {
    alert(
      window.trans(
        "You can only act upon a minimum of [_1] [_2].",
        (selectedAction && selectedAction.min) || "",
        plural,
      ),
    );
  };

  const alertMaximumError = (): void => {
    alert(
      window.trans(
        "You can only act upon a maximum of [_1] [_2].",
        (selectedAction && selectedAction.max) || "",
        plural,
      ),
    );
  };

  const getConfirmMessage = (): string => {
    const checkedRowCount = getCheckedRowCount();

    if (checkedRowCount === 1) {
      return window.trans(
        "Are you sure you want to [_2] this [_1]?",
        singular,
        selectedActionPhrase,
      );
    } else {
      return window.trans(
        "Are you sure you want to [_3] the [_1] selected [_2]?",
        checkedRowCount.toString(),
        plural,
        selectedActionPhrase,
      );
    }
  };
</script>

<div data-is="list-actions-for-pc" class="d-none d-md-block">
  <ListActionsForPc
    {buttonActions}
    {doAction}
    {listActions}
    {hasPulldownActions}
    {moreListActions}
  />
</div>
<div data-is="list-actions-for-mobile" class="d-md-none">
  <ListActionsForMobile
    {buttonActions}
    {doAction}
    {listActions}
    {moreListActions}
  />
</div>
