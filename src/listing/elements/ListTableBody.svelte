<script lang="ts">
  import { getContext } from "svelte";
  import type * as Listing from "../../@types/listing";

  import ListTableRow from "./ListTableRow.svelte";
  import type { ListStoreContext } from "../listStoreContext";

  type Props = {
    hasListActions: boolean;
    hasMobilePulldownActions: boolean;
    zeroStateLabel: string;
  };
  let { hasListActions, hasMobilePulldownActions, zeroStateLabel }: Props =
    $props();
  const { store, reactiveStore } = getContext<ListStoreContext>("listStore");

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

{#if !$reactiveStore.objects || $reactiveStore.objects.length === 0}
  <tr>
    <td colspan={$reactiveStore.columns.length + 1}>
      {window.trans("No [_1] could be found.", zeroStateLabel)}
    </td>
  </tr>
{/if}

{#if $reactiveStore.pageMax > 1 && $reactiveStore.checkedAllRowsOnPage && !$reactiveStore.checkedAllRows}
  <tr style="background-color: #ffffff;">
    <td colspan={$reactiveStore.columns.length + 1}>
      <!-- svelte-ignore a11y_invalid_attribute -->
      <a href="javascript:void(0);" onclick={checkAllRows}>
        {window.trans(
          "Select all [_1] items",
          ($reactiveStore.count ?? 0).toString(),
        )}
      </a>
    </td>
  </tr>
{/if}

{#if $reactiveStore.pageMax > 1 && $reactiveStore.checkedAllRows}
  <tr class="success">
    <td colspan={$reactiveStore.columns.length + 1}>
      {window.trans(
        "All [_1] items are selected",
        ($reactiveStore.count ?? 0).toString(),
      )}
    </td>
  </tr>
{/if}

{#each $reactiveStore.objects as obj, index}
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
    />
  </tr>
{/each}
