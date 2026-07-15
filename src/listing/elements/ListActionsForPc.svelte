<script lang="ts">
  import type * as Listing from "../../@types/listing";

  type Props = {
    buttonActions: Listing.ButtonActions;
    doAction: (e: Event) => boolean | undefined;
    listActions: Listing.ListActions;
    hasPulldownActions: boolean;
    moreListActions: Listing.MoreListActions;
  };

  let {
    buttonActions,
    doAction,
    listActions,
    hasPulldownActions,
    moreListActions,
  }: Props = $props();
</script>

{#each Object.entries(buttonActions) as [key, action]}
  <button class="btn btn-default mr-2" data-action-id={key} onclick={doAction}>
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
        <!-- svelte-ignore a11y_invalid_attribute -->
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          data-action-id={key}
          onclick={doAction}
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
        <!-- svelte-ignore a11y_invalid_attribute -->
        <a
          class="dropdown-item"
          href="javascript:void(0);"
          data-action-id={key}
          onclick={doAction}
        >
          {@html action.label}
        </a>
      {/each}
    </div>
  </div>
{/if}
