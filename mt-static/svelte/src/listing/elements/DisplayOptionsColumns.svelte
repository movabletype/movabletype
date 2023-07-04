<script>
import { ListingStore, ListingOpts } from "../ListingStore.ts";

function toggleColumn(e) {
  //this.store.trigger('toggle_column', e.currentTarget.id)
  console.log("Run toggle_column for " + e.currentTarget.id);
}

function toggleSubField(e) {
  //this.store.trigger('toggle_sub_field', e.currentTarget.id)
  console.log("Run toggle_sub_field for " + e.currentTarget.id);
}  
</script>

<div class="field-header">
  <label class="form-label">{ trans('Column') }</label>
</div>
{#if $ListingOpts.disableUserDispOption}
<div class="alert alert-warning">
  { trans('User Display Option is disabled now.') }
</div>
{/if}
<div
  class="{$ListingOpts.disableUserDispOption ? '' : 'field-content'}"
>
  <ul id="disp_cols" class="list-inline m-0">
    {#each $ListingStore.columns as column}
    <li hide={ column.force_display } class="list-inline-item">
      <div class="form-check">
        <input type="checkbox"
          class="form-check-input"
          id={ column.id }
          checked={ column.checked }
          on:change={ toggleColumn }
          disabled={ $ListingStore.isLoading }
        />
        <label class="form-check-label form-label" for={ column.id }>
          {@html column.label }
        </label>
      </div>
    </li>
      {#each column.sub_fields as subField }
    <li
      hide={ subField.force_display }
      class="list-inline-item"
    >
      <div class="form-check">
        <input type="checkbox"
          id={ subField.id }
          pid={ subField.parent_id }
          class="form-check-input { subField.class }"
          disabled={ !column.checked }
          checked={ subField.checked }
          on:change={ toggleSubField }
        />
        <label class="form-check-label form-label" for={ subField.id }>{ subField.label }</label>
      </div>
    </li>
      {/each}
    {/each}
  </ul>
</div>
