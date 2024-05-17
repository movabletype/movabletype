<script>
  import ListTableRow from "./ListTableRow.svelte";

  export let hasListActions;
  export let hasMobilePulldownActions;
  export let store;
  export let zeroStateLabel;

  // FIXME
  $: objects = store.objects || [];

  function checkAllRows(e) {
    store.trigger("check_all_rows");
  }

  function clickRow(e) {
    store.trigger("reset_all_clicked_rows");

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
        store.trigger("click_row", e.currentTarget.dataset.index);
        return false;
      }
    }
    e.stopPropagation();
    store.trigger("toggle_row", e.currentTarget.dataset.index);
  }
</script>

{#if objects.length == 0}
  <tr>
    <td colspan={store.columns.length + 1}>
      {window.trans("No [_1] could be found.", zeroStateLabel)}
    </td>
  </tr>
{/if}

{#if store.pageMax > 1 && store.checkedAllRowsOnPage && !store.checkedAllRows}
  <tr style="background-color: #ffffff;">
    <td colspan={objects.length + 1}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a href="javascript:void(0);" on:click={checkAllRows}>
        {window.trans("Select all [_1] items", store.count)}
      </a>
    </td>
  </tr>
{/if}

{#if store.pageMax > 1 && store.checkedAllRows}
  <tr class="success">
    <td colspan={objects.length + 1}>
      {window.trans("All [_1] items are selected", store.count)}
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
      {hasListActions}
      {hasMobilePulldownActions}
      object={obj.object}
      {store}
    />
  </tr>
{/each}
