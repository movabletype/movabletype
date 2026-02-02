<script lang="ts">
  import { getContext } from "svelte";
  import type * as Listing from "../../@types/listing";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    hasListActions: boolean;
    toggleAllRowsOnPage: () => void;
    toggleSortColumn: (e: Event) => void;
  };
  let { hasListActions, toggleAllRowsOnPage, toggleSortColumn }: Props =
    $props();
  const { reactiveStore } = getContext<ListStoreContext>("listStore");

  const classProps = (column: Listing.ListColumn): object => {
    if (column.sortable && $reactiveStore.sortBy === column.id) {
      if ($reactiveStore.sortOrder === "ascend") {
        return { class: "mt-table__ascend" };
      } else if ($reactiveStore.sortOrder === "descend") {
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
          checked={$reactiveStore.checkedAllRowsOnPage}
          onchange={toggleAllRowsOnPage}
        />
        <label class="form-check-label form-label" for="select-all">
          <span class="visually-hidden">
            {window.trans("Select All")}
          </span>
        </label>
      </div>
    </th>
  {/if}
  {#each $reactiveStore.columns as column}
    {#if column.checked && column.id !== "__mobile"}
      <th
        scope="col"
        data-id={column.id}
        class:primary={column.primary}
        class:sortable={column.sortable}
        class:sorted={$reactiveStore.sortBy === column.id}
        class="text-truncate"
      >
        {#if column.sortable}
          <!-- svelte-ignore a11y-invalid-attribute -->
          <a
            href="javascript:void(0)"
            onclick={toggleSortColumn}
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
