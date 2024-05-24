<script lang="ts">
  import { ListStore } from "types/listing";

  export let hasListActions: boolean;
  export let store: ListStore;
  export let toggleAllRowsOnPage: () => void;
  export let toggleSortColumn: (e: Event) => void;
</script>

<tr class="d-none d-md-table-row">
  {#if hasListActions}
    <th class="mt-table__control">
      <div class="form-check">
        <input
          type="checkbox"
          class="form-check-input"
          id="select-all"
          checked={store.checkedAllRowsOnPage}
          on:change={toggleAllRowsOnPage}
        />
        <label class="form-check-label form-label" for="select-all">
          <span class="visually-hidden">
            {window.trans("Select All")}
          </span>
        </label>
      </div>
    </th>
  {/if}
  {#each store.columns as column}
    {#if column.checked && column.id != "__mobile"}
      <th
        data-id={column.id}
        class:primary={column.primary}
        class:sortable={column.sortable}
        class:sorted={store.sortBy == column.id}
        class="text-truncate"
        scope="col"
      >
        {#if column.sortable}
          <!-- svelte-ignore a11y-invalid-attribute -->
          <a
            class:mt-table__ascend={column.sortable &&
              store.sortBy == column.id &&
              store.sortOrder == "ascend"}
            class:mt-table__descend={column.sortable &&
              store.sortBy == column.id &&
              store.sortOrder == "descend"}
            href="javascript:void(0)"
            on:click={toggleSortColumn}
          >
            {@html column.label}
          </a>
        {:else}
          {@html column.label}
        {/if}
      </th>
    {/if}
  {/each}
</tr>
