<script>
  import ListTableRow from "./ListTableRow.svelte";

  export let listStore;
  export let opts;

  // FIXME
  $: objects = listStore.objects || [];

  function checkAllRows(e) {
    listStore.trigger("check_all_rows");
  }

  function clickRow(e) {
    listStore.trigger("reset_all_clicked_rows");

    if (
      e.target.tagName == "A" ||
      e.target.tagName == "IMG" ||
      e.target.tagName == "svg"
    ) {
      return false;
    }
    if (MT.Util.isMobileView()) {
      let $mobileColumn;
      if (e.target.dataset.is == "list-table-column") {
        $mobileColumn = jQuery(e.target);
      } else {
        $mobileColumn = jQuery(e.target).parents("[data-is=list-table-column]");
      }
      if ($mobileColumn.length > 0 && $mobileColumn.find("a").length > 0) {
        $mobileColumn.find("a")[0].click();
        listStore.trigger("click_row", e.currentTarget.dataset.index);
        return false;
      }
    }
    e.stopPropagation();
    listStore.trigger("toggle_row", e.currentTarget.dataset.index);
  }
</script>

{#if objects.length == 0}
  <tr>
    <td colspan={listStore.columns.length + 1}>
      {window.trans("No [_1] could be found.", opts.zeroStateLabel)}
    </td>
  </tr>
{/if}

{#if listStore.pageMax > 1 && listStore.checkedAllRowsOnPage && !listStore.checkedAllRows}
  <tr style="background-color: #ffffff;">
    <td colspan={objects.length + 1}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a href="javascript:void(0);" on:click={checkAllRows}>
        {window.trans("Select all [_1] items", listStore.count)}
      </a>
    </td>
  </tr>
{/if}

{#if listStore.pageMax > 1 && listStore.checkedAllRows}
  <tr class="success">
    <td colspan={objects.length + 1}>
      {window.trans("All [_1] items are selected", listStore.count)}
    </td>
  </tr>
{/if}

{#each objects as obj, index}
  <tr
    class:mt-table__highlight={obj.checked || obj.clicked}
    data-index={index}
    on:click={clickRow}
  >
    <ListTableRow
      checked={obj.checked}
      {listStore}
      object={obj.object}
      {opts}
    />
  </tr>
{/each}
