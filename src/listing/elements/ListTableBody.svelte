<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import ListTableRow from "./ListTableRow.svelte";

  export let hasListActions: boolean;
  export let hasMobilePulldownActions: boolean;
  export let store: Listing.ListStore;
  export let zeroStateLabel: string;

  $: count = store.count || 0;
  $: objects = store.objects || [];

  const clickRow = (e: Event): boolean | undefined => {
    store.trigger("reset_all_clicked_rows");

    const target = e.target as HTMLElement;
    if (
      target.tagName === "A" ||
      target.tagName === "IMG" ||
      target.tagName === "svg"
    ) {
      return false;
    }

    const currentTarget = e.currentTarget as HTMLElement;
    /* @ts-expect-error : MT is not defined */
    if (MT.Util.isMobileView()) {
      let $mobileColumn: JQuery<HTMLElement>;
      if (target.dataset.is === "list-table-column") {
        $mobileColumn = jQuery(target);
      } else {
        $mobileColumn = jQuery(target).parents("[data-is=list-table-column]");
      }
      if ($mobileColumn.length > 0 && $mobileColumn.find("a").length > 0) {
        $mobileColumn.find("a")[0].click();
        store.trigger("click_row", currentTarget.dataset.index);
        return false;
      }
    }
    e.stopPropagation();
    store.trigger("toggle_row", currentTarget.dataset.index);
  };

  const checkAllRows = (): void => {
    store.trigger("check_all_rows");
  };

  const trProps = (obj: Listing.ListObject): object => {
    let props: { checked?: string; class?: string } = {};

    if (obj.checked || obj.clicked) {
      props.class = "mt-table__highlight";
    }
    if (obj.checked) {
      props.checked = "checked";
    }

    return props;
  };
</script>

{#if objects.length === 0}
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
        {window.trans("Select all [_1] items", count.toString())}
      </a>
    </td>
  </tr>
{/if}

{#if store.pageMax > 1 && store.checkedAllRows}
  <tr class="success">
    <td colspan={objects.length + 1}>
      {window.trans("All [_1] items are selected", count.toString())}
    </td>
  </tr>
{/if}

{#each objects as obj, index}
  <!-- remove "object" property because it is not output in Riot.js -->
  <tr
    data-is="list-table-row"
    on:click={clickRow}
    data-index={index}
    {...trProps(obj)}
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
