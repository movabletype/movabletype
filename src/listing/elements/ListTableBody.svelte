<script>
  import ListTableRow from "./ListTableRow.svelte";
  import { ListingStore, ListingOpts } from "../ListingStore.ts";

  function checkAllRows(e) {
    //this.store.trigger('check_all_rows')
  }

  const parent = {
    clickRow: (event) => {
      // Implement the clickRow function
    },
  };
</script>

{#if $ListingStore.objects.length == 0}
  <tr>
    <td colspan={$ListingStore.columns.length + 1}>
      {window.trans("No [_1] could be found.", $ListingOpts.zeroStateLabel)}
    </td>
  </tr>
{/if}

{#if $ListingStore.pageMax > 1 && $ListingStore.checkedAllRowsOnPage && !$ListingStore.checkedAllRows}
  <tr style="background-color: #ffffff;">
    <td colspan={$ListingStore.objects.length + 1}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a href="javascript:void(0);" on:click={checkAllRows}>
        {window.trans("Select all [_1] items", $ListingStore.count)}
      </a>
    </td>
  </tr>
{/if}

{#if $ListingStore.pageMax > 1 && $ListingStore.checkedAllRows}
  <tr class="success">
    <td colspan={$ListingStore.objects.length + 1}>
      {window.trans("All [_1] items are selected", $ListingStore.count)}
    </td>
  </tr>
{/if}

{#each $ListingStore.objects as obj, index}
  <tr
    on:click={parent.clickRow}
    class={obj.checked || obj.clicked ? "mt-table__highlight" : ""}
    data-index={index}
    checked={obj.checked}
    object={obj.object}
  >
    <ListTableRow />
  </tr>
{/each}
