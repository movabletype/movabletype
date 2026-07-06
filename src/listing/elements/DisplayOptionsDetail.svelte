<script lang="ts">
  import { getContext } from "svelte";
  import DisplayOptionsColumns from "./DisplayOptionsColumns.svelte";
  import DisplayOptionsLimit from "./DisplayOptionsLimit.svelte";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    changeLimit: (e: Event) => void;
    disableUserDispOption: boolean;
  };
  let { changeLimit, disableUserDispOption }: Props = $props();

  const { store } = getContext<ListStoreContext>("listStore");

  const resetColumns = (): void => {
    store.trigger("reset_columns");
  };
</script>

<div id="display-options-detail" class="collapse">
  <div class="card card-block p-3">
    <fieldset class="form-group">
      <div data-is="display-options-limit" id="per_page-field">
        <DisplayOptionsLimit {changeLimit} />
      </div>
    </fieldset>
    <fieldset class="form-group">
      <div data-is="display-options-columns" id="display_columns-field">
        <DisplayOptionsColumns {disableUserDispOption} />
      </div>
    </fieldset>
    {#if !disableUserDispOption}
      <div class="actions-bar actions-bar-bottom">
        <!-- svelte-ignore a11y_invalid_attribute -->
        <a
          href="javascript:void(0);"
          id="reset-display-options"
          onclick={resetColumns}
        >
          {window.trans("Reset defaults")}
        </a>
      </div>
    {/if}
  </div>
</div>
