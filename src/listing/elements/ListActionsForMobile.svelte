<script lang="ts">
  export let buttonActions: MT.Listing.ButtonActions;
  export let doAction: (e: Event) => boolean | undefined;
  export let listActions: MT.Listing.ListActions;
  export let moreListActions: MT.Listing.MoreListActions;

  const buttonActionsForMobile = (): MT.Listing.ButtonActions => {
    return _getActionsForMobile(buttonActions);
  };

  const listActionsForMobile = (): MT.Listing.ListActions => {
    return _getActionsForMobile(listActions);
  };

  const moreListActionsForMobile = (): MT.Listing.MoreListActions => {
    return _getActionsForMobile(moreListActions);
  };

  const _getActionsForMobile = (
    actions:
      | MT.Listing.ButtonActions
      | MT.Listing.ListActions
      | MT.Listing.MoreListActions,
  ):
    | MT.Listing.ButtonActions
    | MT.Listing.ListActions
    | MT.Listing.MoreListActions => {
    const mobileActions = {};
    Object.keys(actions).forEach((key) => {
      const action = actions[key];
      if (action.mobile) {
        mobileActions[key] = action;
      }
    });
    return mobileActions;
  };

  const hasActionForMobile = (): boolean => {
    const mobileActionCount =
      Object.keys(buttonActionsForMobile()).length +
      Object.keys(listActionsForMobile()).length +
      Object.keys(moreListActionsForMobile()).length;
    return mobileActionCount > 0;
  };
</script>

{#if hasActionForMobile()}
  <div class="btn-group">
    <button class="btn btn-default dropdown-toggle" data-bs-toggle="dropdown">
      {window.trans("Select action")}
    </button>
    <div class="dropdown-menu">
      {#each Object.entries(buttonActionsForMobile()) as [key, action]}
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          data-action-id={key}
          on:click={doAction}
        >
          {@html action.label}
        </a>
      {/each}

      {#each Object.entries(listActionsForMobile()) as [key, action]}
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          data-action-id={key}
          on:click={doAction}
        >
          {@html action.label}
        </a>
      {/each}

      {#if Object.keys(moreListActionsForMobile()).length > 0}
        <h6 class="dropdown-header">Plugin Actions</h6>
      {/if}

      {#each Object.entries(moreListActionsForMobile()) as [key, action]}
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          data-action-id={key}
          on:click={doAction}
        >
          {@html action.label}
        </a>
      {/each}
    </div>
  </div>
{/if}
