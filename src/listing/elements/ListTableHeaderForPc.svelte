<script lang="ts">
  import type * as Listing from "../../@types/listing";

  export let hasListActions: boolean;
  export let store: Listing.ListStore;
  export let toggleAllRowsOnPage: () => void;
  export let toggleSortColumn: (e: Event) => void;

  const classProps = (column: Listing.ListColumn): object => {
    if (column.sortable && store.sortBy === column.id) {
      if (store.sortOrder === "ascend") {
        return { class: "mt-table__ascend" };
      } else if (store.sortOrder === "descend") {
        return { class: "mt-table__descend" };
      } else {
        return {};
      }
    } else {
      return {};
    }
  };
</script>

<tr class="d-none d-md-table-row">
  {#if hasListActions}
    <th class="mt-table__control">
      <div class="form-check">
        <!-- checked="checked" is not added to input tag after click checkbox,
          but check parameter of input element returns true. So, do not fix this. -->
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
    {#if column.checked && column.id !== "__mobile"}
      <th
        scope="col"
        data-id={column.id}
        class:primary={column.primary}
        class:sortable={column.sortable}
        class:sorted={store.sortBy === column.id}
        class="text-truncate"
      >
        {#if column.sortable}
          <!-- svelte-ignore a11y-invalid-attribute -->
          <a
            href="javascript:void(0)"
            on:click={toggleSortColumn}
            {...classProps(column)}
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
