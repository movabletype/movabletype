<script>
  export let doAction;
  export let opts;
</script>

{#each Object.entries(opts.buttonActions) as [key, action]}
  <button
    class="btn btn-default mr-2"
    data-action-id={key}
    on:click={doAction(action.mode)}
  >
    {@html action.label}
  </button>
{/each}

{#if opts.hasPulldownActions}
  <div class="btn-group">
    <button class="btn btn-default dropdown-toggle" data-bs-toggle="dropdown">
      {" " + window.trans("More actions...") + " "}
    </button>
    <div class="dropdown-menu">
      {#each Object.entries(opts.listActions) as [key, action]}
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          data-action-id={key}
          on:click={doAction(action.mode)}
        >
          {@html action.label}
        </a>
      {/each}

      {#if Object.keys(opts.moreListActions).length > 0}
        <h6 class="dropdown-header">
          {window.trans("Plugin Actions")}
        </h6>
      {/if}

      {#each Object.entries(opts.moreListActions) as [key, action]}
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          data-action-id={key}
          on:click={doAction(action.mode)}
        >
          {@html action.label}
        </a>
      {/each}
    </div>
  </div>
{/if}
