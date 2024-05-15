<script>
  export let doAction;
  export let opts;

  function buttonActionsForMobile() {
    return getActionsForMobile(opts.buttonActions);
  }

  function listActionsForMobile() {
    return getActionsForMobile(opts.listActions);
  }

  function moreListActionsForMobile() {
    return getActionsForMobile(opts.moreListActions);
  }

  function getActionsForMobile(actions) {
    const mobileActions = {};
    Object.keys(actions).forEach((key) => {
      const action = actions[key];
      if (action.mobile) {
        mobileActions[key] = action;
      }
    });
    return mobileActions;
  }

  function hasActionForMobile() {
    const mobileActionCount =
      Object.keys(buttonActionsForMobile()).length +
      Object.keys(listActionsForMobile()).length +
      Object.keys(moreListActionsForMobile()).length;
    return mobileActionCount > 0;
  }
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
