<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import DisplayOptionsColumns from "./DisplayOptionsColumns.svelte";
  import DisplayOptionsLimit from "./DisplayOptionsLimit.svelte";

  export let changeLimit: (e: Event) => void;
  export let disableUserDispOption: boolean;
  export let store: Listing.ListStore;

  const resetColumns = (): void => {
    store.trigger("reset_columns");
  };
</script>

<div id="display-options-detail" class="collapse">
  <div class="card card-block p-3">
    <fieldset class="form-group">
      <div data-is="display-options-limit" id="per_page-field">
        <DisplayOptionsLimit {changeLimit} {store} />
      </div>
    </fieldset>
    <fieldset class="form-group">
      <div data-is="display-options-columns" id="display_columns-field">
        <DisplayOptionsColumns {disableUserDispOption} {store} />
      </div>
    </fieldset>
    {#if !disableUserDispOption}
      <div class="actions-bar actions-bar-bottom">
        <!-- svelte-ignore a11y-invalid-attribute -->
        <a
          href="javascript:void(0);"
          id="reset-display-options"
          on:click={resetColumns}
        >
          {window.trans("Reset defaults")}
        </a>
      </div>
    {/if}
  </div>
</div>
