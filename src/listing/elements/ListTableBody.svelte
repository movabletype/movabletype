<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import ListTableRow from "./ListTableRow.svelte";

  type Props = {
    hasListActions: boolean;
    hasMobilePulldownActions: boolean;
    store: Listing.ListStore;
    zeroStateLabel: string;
  };
  let {
    hasListActions,
    hasMobilePulldownActions,
    store,
    zeroStateLabel,
  }: Props = $props();

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
      let mobileColumn: JQuery<HTMLElement>;
      if (target.dataset.is === "list-table-column") {
        mobileColumn = jQuery(target);
      } else {
        mobileColumn = jQuery(target).parents("[data-is=list-table-column]");
      }
      if (mobileColumn.length > 0 && mobileColumn.find("a").length > 0) {
        mobileColumn.find("a")[0].click();
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

{#if !store.objects || store.objects.length === 0}
  <tr>
    <td colspan={store.columns.length + 1}>
      {window.trans("No [_1] could be found.", zeroStateLabel)}
    </td>
  </tr>
{/if}

{#if store.pageMax > 1 && store.checkedAllRowsOnPage && !store.checkedAllRows}
  <tr style="background-color: #ffffff;">
    <td colspan={store.columns.length + 1}>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a href="javascript:void(0);" onclick={checkAllRows}>
        {window.trans("Select all [_1] items", store.count.toString())}
      </a>
    </td>
  </tr>
{/if}

{#if store.pageMax > 1 && store.checkedAllRows}
  <tr class="success">
    <td colspan={store.columns.length + 1}>
      {window.trans("All [_1] items are selected", store.count.toString())}
    </td>
  </tr>
{/if}

{#each store.objects as obj, index}
  <!-- remove "object" property because it is not output in Riot.js -->
  <tr
    data-is="list-table-row"
    onclick={clickRow}
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
