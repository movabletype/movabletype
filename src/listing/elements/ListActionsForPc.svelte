<script lang="ts">
  import type * as Listing from "../../@types/listing";

  export let buttonActions: Listing.ButtonActions;
  export let doAction: (e: Event) => boolean | undefined;
  export let listActions: Listing.ListActions;
  export let hasPulldownActions: boolean;
  export let moreListActions: Listing.MoreListActions;
</script>

{#each Object.entries(buttonActions) as [key, action]}
  <button class="btn btn-default mr-2" data-action-id={key} on:click={doAction}>
    {@html action.label}
  </button>
{/each}

{#if hasPulldownActions}
  <div class="btn-group">
    <button class="btn btn-default dropdown-toggle" data-bs-toggle="dropdown">
      {window.trans("More actions...")}
    </button>
    <div class="dropdown-menu">
      {#each Object.entries(listActions) as [key, action]}
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

      {#if Object.keys(moreListActions).length > 0}
        <h6 class="dropdown-header">
          {window.trans("Plugin Actions")}
        </h6>
      {/if}

      {#each Object.entries(moreListActions) as [key, action]}
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
