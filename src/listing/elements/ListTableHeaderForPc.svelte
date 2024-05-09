<script>
  import { ListingStore, ListingOpts } from "../ListingStore.ts";
  export let toggleAllRowsOnPage;
  export let toggleSortColumn;
</script>

<tr class="d-none d-md-table-row">
  {#if $ListingOpts.hasListActions}
    <th class="mt-table__control">
      <div class="form-check">
        <input
          type="checkbox"
          class="form-check-input"
          id="select-all"
          checked={$ListingStore.checkedAllRowsOnPage}
          on:change={toggleAllRowsOnPage}
        />
        <label class="form-check-label form-label" for="select-all">
          <span class="visually-hidden">
            {trans("Select All")}
          </span>
        </label>
      </div>
    </th>
  {/if}
  {#each $ListingStore.columns as column}
    {#if column.checked && column.id != "__mobile"}
      <th>
        {#if column.sortable}
          <a href="javascript:void(0)" on:click={toggleSortColumn}>
            {@html column.label}
          </a>
        {:else}
          {@html column.label}
        {/if}
      </th>
    {/if}
  {/each}
</tr>
