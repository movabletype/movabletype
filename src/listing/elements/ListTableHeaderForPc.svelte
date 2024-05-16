<script>
  export let listStore;
  export let opts;
  export let toggleAllRowsOnPage;
  export let toggleSortColumn;
</script>

<tr class="d-none d-md-table-row">
  {#if opts.hasListActions}
    <th class="mt-table__control">
      <div class="form-check">
        <input
          type="checkbox"
          class="form-check-input"
          id="select-all"
          checked={listStore.checkedAllRowsOnPage}
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
  {#each listStore.columns as column}
    {#if column.checked && column.id != "__mobile"}
      <th
        data-id={column.id}
        class:primary={column.primary}
        class:sortable={column.sortable}
        class:sorted={listStore.sortBy == column.id}
        class="text-truncate"
        scope="col"
      >
        {#if column.sortable}
          <!-- svelte-ignore a11y-invalid-attribute -->
          <a
            class:mt-table__ascend={column.sortable &&
              listStore.sortBy == column.id &&
              listStore.sortOrder == "ascend"}
            class:mt-table__descend={column.sortable &&
              listStore.sortBy == column.id &&
              listStore.sortOrder == "descend"}
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
