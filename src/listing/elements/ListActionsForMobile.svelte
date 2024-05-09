<script>
  import { ListingStore, ListingOpts } from "../ListingStore.ts";
  export let doAction;

  function buttonActionsForMobile() {
    return getActionsForMobile($ListingOpts.buttonActions);
  }

  function listActionsForMobile() {
    return getActionsForMobile($ListingOpts.listActions);
  }

  function moreListActionsForMobile() {
    return getActionsForMobile($ListingOpts.moreListActions);
  }

  function getActionsForMobile(actions) {
    const mobileActions = [];
    if (typeof actions != "undefined") {
      const actionsToArray = Object.entries(actions);
      actionsToArray.forEach((action) => {
        if (action.mobile) {
          mobileActions.push(action);
        }
      });
    }
    return mobileActions;
  }

  function hasActionForMobile() {
    let mobileActionCount =
      Object.keys(buttonActionsForMobile()).length +
      Object.keys(listActionsForMobile()).length +
      Object.keys(moreListActionsForMobile()).length;
    return mobileActionCount > 0;
  }
</script>

{#if hasActionForMobile()}
  <div class="btn-group">
    <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
      {window.trans("Select action")}
    </button>
    <div class="dropdown-menu">
      {#each buttonActionsForMobile as action, key}
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          on:click={() => doAction(key)}
        >
          {@html action.label}
        </a>
      {/each}

      {#each listActionsForMobile as action, key}
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          on:click={() => doAction(key)}
        >
          {@html action.label}
        </a>
      {/each}

      {#if typeof moreListActionsForMobile != "undefined"}
        {#if Object.keys(moreListActionsForMobile).length > 0}
          <h6 class="dropdown-header">Plugin Actions</h6>
          {#each moreListActionsForMobile as action, key}
            <a
              class="dropdown-item"
              href="javascript:void(0);"
              on:click={() => doAction(key)}
            >
              {@html action.label}
            </a>
          {/each}
        {/if}
      {/if}
    </div>
  </div>
{/if}
