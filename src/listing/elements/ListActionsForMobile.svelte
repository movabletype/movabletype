<script lang="ts">
  import { ButtonActions, ListActions, MoreListActions } from "types/listing";

  export let buttonActions: ButtonActions;
  export let doAction: (actionId: string) => boolean | undefined;
  export let listActions: ListActions;
  export let moreListActions: MoreListActions;

  const buttonActionsForMobile = (): ButtonActions => {
    return getActionsForMobile(buttonActions);
  };

  const listActionsForMobile = (): ListActions => {
    return getActionsForMobile(listActions);
  };

  const moreListActionsForMobile = (): MoreListActions => {
    return getActionsForMobile(moreListActions);
  };

  const getActionsForMobile = (
    actions: ButtonActions | ListActions | MoreListActions
  ): ButtonActions | ListActions | MoreListActions => {
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
          on:click={() => doAction(key)}
        >
          {@html action.label}
        </a>
      {/each}

      {#each Object.entries(listActionsForMobile()) as [key, action]}
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          on:click={() => doAction(key)}
        >
          {@html action.label}
        </a>
      {/each}

      {#if Object.keys(moreListActionsForMobile()).length > 0}
        <h6 class="dropdown-header">Plugin Actions</h6>
        {#each Object.entries(moreListActionsForMobile()) as [key, action]}
          <!-- svelte-ignore a11y-invalid-attribute -->
          <a
            class="dropdown-item"
            href="javascript:void(0);"
            on:click={() => doAction(key)}
          >
            {@html action.label}
          </a>
        {/each}
      {/if}
    </div>
  </div>
{/if}
