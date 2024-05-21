<script lang="ts">
  import { ListStore } from "types/listing";

  export let disableUserDispOption: boolean;
  export let store: ListStore;

  const toggleColumn = (columnId: string): void => {
    store.trigger("toggle_column", columnId);
  };

  const toggleSubField = (subFieldId: string): void => {
    store.trigger("toggle_sub_field", subFieldId);
  };
</script>

<div class="field-header">
  <!-- svelte-ignore a11y-label-has-associated-control -->
  <label class="form-label">{window.trans("Column")}</label>
</div>
{#if disableUserDispOption}
  <div class="alert alert-warning">
    {window.trans("User Display Option is disabled now.")}
  </div>
{:else}
  <div class="field-content">
    <ul id="disp_cols" class="list-inline m-0">
      {#each store.columns as column}
        <li class="list-inline-item" hidden={column.force_display != 0}>
          <div class="form-check">
            <input
              type="checkbox"
              class="form-check-input"
              id={column.id}
              checked={column.checked != 0}
              on:change={() => toggleColumn(column.id)}
              disabled={store.isLoading}
            />
            <label class="form-check-label form-label" for={column.id}>
              {@html column.label}
            </label>
          </div>
        </li>
        {#each column.sub_fields as subField}
          <li class="list-inline-item">
            <div class="form-check">
              <input
                type="checkbox"
                id={subField.id}
                class="form-check-input {subField.class}"
                disabled={!column.checked}
                checked={subField.checked != 0}
                on:change={() => toggleSubField(subField.id)}
              />
              <label class="form-check-label form-label" for={subField.id}>
                {subField.label}
              </label>
            </div>
          </li>
        {/each}
      {/each}
    </ul>
  </div>
{/if}
