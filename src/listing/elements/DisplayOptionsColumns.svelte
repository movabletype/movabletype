<script lang="ts">
  import type * as Listing from "../../@types/listing";

  export let disableUserDispOption: boolean;
  export let store: Listing.ListStore;

  const toggleColumn = (e: Event): void => {
    const columnId = (e.currentTarget as HTMLInputElement)?.id;
    store.trigger("toggle_column", columnId);
  };

  const toggleSubField = (e: Event): void => {
    const subFieldId = (e.currentTarget as HTMLInputElement)?.id;
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
        {@const hiddenColumn = Boolean(column.force_display)}
        <li
          class="list-inline-item"
          hidden={hiddenColumn}
          style:display={hiddenColumn ? "none" : ""}
        >
          <div class="form-check">
            <!-- checked="checked" is not added to input tag after click checkbox,
              but check parameter of input element returns true. So, do not fix this. -->
            <input
              type="checkbox"
              class="form-check-input"
              id={column.id}
              checked={Boolean(column.checked)}
              on:change={toggleColumn}
              disabled={store.isLoading}
            />
            <label class="form-check-label form-label" for={column.id}>
              {@html column.label}
            </label>
          </div>
        </li>
        {#each column.sub_fields as subField}
          {@const hiddenSubField = Boolean(subField.force_display)}
          <li
            class="list-inline-item"
            hidden={hiddenSubField}
            style:display={hiddenSubField ? "none" : ""}
          >
            <div class="form-check">
              <!-- checked="checked" is not added to input tag after click checkbox,
                but check parameter of input element returns true. So, do not fix this. -->
              <input
                type="checkbox"
                id={subField.id}
                {...{ pid: subField.parent_id }}
                class="form-check-input {subField.class}"
                disabled={!column.checked}
                checked={Boolean(subField.checked)}
                on:change={toggleSubField}
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
