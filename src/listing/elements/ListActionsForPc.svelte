<script>
  import { ListingStore, ListingOpts } from "../ListingStore.ts";
  export let doAction;
</script>

{#each $ListingOpts.buttonActions as action}
  <button class="btn btn-default mr-2" on:click={doAction(action.mode)}>
    {@html action.label}
  </button>
{/each}

{#if $ListingOpts.hasPulldownActions}
  <div class="btn-group">
    <button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
      {trans("More actions...")}
    </button>
    <div class="dropdown-menu">
      {#each $ListingOpts.listActions as action}
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          on:click={doAction(action.mode)}
        >
          {@html action.label}
        </a>
      {/each}

      {#if typeof $ListingOpts.moreListActions != "undefined"}
        {#if Object.keys($ListingOpts.moreListActions).length > 0}
          <h6 class="dropdown-header">
            {trans("Plugin Actions")}
          </h6>
        {/if}

        {#each $ListingOpts.moreListActions as action}
          <a
            class="dropdown-item"
            href="javascript:void(0);"
            on:click={doAction(action.mode)}
          >
            {@html action.label}
          </a>
        {/each}
      {/if}
    </div>
  </div>
{/if}
