<script>
import DisplayOptionsColumns from "./DisplayOptionsColumns.svelte";
import DisplayOptionsLimit from "./DisplayOptionsLimit.svelte";
import { ListingOpts } from "../ListingStore.ts";

function resetColumns(e) {
  //this.store.trigger('reset_columns')
  console.log("Run reset_columns for " + e.currentTarget.id);
}
</script>

<div id="display-options-detail2" class="collapse">
  <div class="card card-block p-3">
    <fieldset class="form-group">
      <div data-is="display-options-limit" id="per_page-field">
        <DisplayOptionsLimit />
      </div>
    </fieldset>
    <fieldset class="form-group">
      <div data-is="display-options-columns" id="display_columns-field">
        <DisplayOptionsColumns />
      </div>
    </fieldset>
    <div if={ !$ListingOpts.disableUserDispOption }
      class="actions-bar actions-bar-bottom"
    >
      <a href="javascript:void(0);" id="reset-display-options" on:click={ resetColumns }>
        { trans('Reset defaults') }
      </a>
    </div>
  </div>
</div>
