<script>
  export let listStore;
  export let opts;
  export let toggleAllRowsOnPage;
</script>

{#if listStore.count}
  <tr class="d-md-none">
    {#if opts.hasMobilePulldownActions}
      <th class="mt-table__control">
        <div class="form-check">
          <input
            type="checkbox"
            class="form-check-input"
            id="select-all"
            checked={opts.checkedAllRowsOnPage}
            on:change={toggleAllRowsOnPage}
          />
          <label class="form-check-label" for="select-all"
            ><span class="visually-hidden">{window.trans("Select All")}</span
            ></label
          >
        </div>
      </th>
    {/if}
    <th scope="col">
      {#if opts.hasMobilePulldownActions}
        <!-- svelte-ignore a11y-click-events-have-key-events a11y-no-static-element-interactions -->
        <span on:click={toggleAllRowsOnPage}>
          {window.trans("All")}
        </span>
      {/if}
      <span class="float-end">
        {window.trans(
          "[_1] - [_2] of [_3]",
          listStore.getListStart(),
          listStore.getListEnd(),
          listStore.count
        )}
      </span>
    </th>
  </tr>
{/if}
