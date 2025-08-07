<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import SVG from "../../svg/elements/SVG.svelte";

  import ListFilterItemField from "./ListFilterItemField.svelte";

  export let currentFilter: Listing.Filter;
  export let filterTypes: Array<Listing.FilterType>;
  export let item: Listing.Item;
  export let listFilterTopAddFilterItemContent: (
    itemIndex: string,
    contentIndex: string,
  ) => void;
  export let listFilterTopRemoveFilterItem: (itemIndex: string) => void;
  export let listFilterTopRemoveFilterItemContent: (
    itemIndex: string,
    contentIndex: string,
  ) => void;
  export let localeCalendarHeader: Array<string>;

  let fieldParentDivs: Array<HTMLDivElement | undefined> = [];
  let root: HTMLDivElement;

  $: filterTypeHash = filterTypes.reduce((hash, filterType) => {
    hash[filterType.type] = filterType;
    return hash;
  }, {});

  const addFilterItemContent = (e: Event): void => {
    const target = e.target as HTMLElement;
    if (!target) {
      return;
    }

    const itemIndex = getListItemIndex(target);
    const contentIndex = getListItemContentIndex(target);
    let item = currentFilter.items[itemIndex];
    if (item.type === "pack") {
      item = item.args.items[contentIndex];
    }
    jQuery(target)
      .parent()
      .each(function () {
        jQuery(this)
          .find(":input")
          .each(function () {
            const re = new RegExp(item.type + "-(\\w+)");
            const key = (jQuery(this).attr("class")?.match(re) || [])[1];
            if (key && !Object.prototype.hasOwnProperty.call(item.args, key)) {
              item.args[key] = jQuery(this).val();
            }
          });
      });
    listFilterTopAddFilterItemContent(
      itemIndex.toString(),
      contentIndex.toString(),
    );
  };

  const getListItemIndex = (element: HTMLElement): number => {
    while (
      !Object.prototype.hasOwnProperty.call(element.dataset, "mtListItemIndex")
    ) {
      if (element.parentElement) {
        element = element.parentElement;
      } else {
        return -1;
      }
    }
    return Number(element.dataset.mtListItemIndex);
  };

  const getListItemContentIndex = (element: HTMLElement): number => {
    while (
      !Object.prototype.hasOwnProperty.call(
        element.dataset,
        "mtListItemContentIndex",
      )
    ) {
      if (element.parentElement) {
        element = element.parentElement;
      } else {
        return -1;
      }
    }
    return Number(element.dataset.mtListItemContentIndex);
  };

  const removeFilterItem = (e: Event): void => {
    const target = e.target as HTMLElement;
    if (!target) {
      return;
    }
    const itemIndex = getListItemIndex(target);
    listFilterTopRemoveFilterItem(itemIndex.toString());
  };

  const removeFilterItemContent = (e: Event): void => {
    const target = e.target as HTMLElement;
    if (!target) {
      return;
    }
    const itemIndex = getListItemIndex(target);
    const contentIndex = getListItemContentIndex(target);
    listFilterTopRemoveFilterItemContent(
      itemIndex.toString(),
      contentIndex.toString(),
    );
  };
</script>

<div class="filteritem" bind:this={root}>
  <button
    class="close btn-close"
    aria-label="Close"
    on:click={removeFilterItem}
  >
    <span aria-hidden="true">&times;</span>
  </button>
  {#if item.type === "pack"}
    <div>
      {#each item.args.items as loopItem, index}
        {#if filterTypeHash[loopItem.type]}
          <div
            data-mt-list-item-content-index={index}
            class={"filtertype type-" + loopItem.type}
          >
            <div
              class="item-content form-inline"
              bind:this={fieldParentDivs[index]}
            >
              {#key currentFilter || fieldParentDivs[index]}
                <ListFilterItemField
                  field={filterTypeHash[loopItem.type].field}
                  item={loopItem}
                  parentDiv={fieldParentDivs[index]}
                  {localeCalendarHeader}
                />
              {/key}
              {#if !filterTypeHash[loopItem.type].singleton}
                <!-- svelte-ignore a11y-invalid-attribute -->
                <a
                  href="javascript:void(0);"
                  class="d-inline-block"
                  on:click={addFilterItemContent}
                >
                  <SVG
                    title={window.trans("Add")}
                    class="mt-icon mt-icon--sm"
                    href={window.StaticURI + "images/sprite.svg#ic_add"}
                  />
                </a>
              {/if}
              {#if !filterTypeHash[loopItem.type].singleton && item.args.items.length > 1}
                <!-- svelte-ignore a11y-invalid-attribute -->
                <a
                  href="javascript:void(0);"
                  on:click={removeFilterItemContent}
                >
                  <SVG
                    title={window.trans("Remove")}
                    class="mt-icon mt-icon--sm"
                    href={window.StaticURI + "images/sprite.svg#ic_remove"}
                  />
                </a>
              {/if}
            </div>
          </div>
        {/if}
      {/each}
    </div>
  {/if}
  {#if item.type !== "type" && filterTypeHash[item.type]}
    <div
      data-mt-list-item-content-index="0"
      class={"filtertype type-" + item.type}
    >
      <div class="item-content form-inline" bind:this={fieldParentDivs[0]}>
        {#key currentFilter || fieldParentDivs[0]}
          <ListFilterItemField
            field={filterTypeHash[item.type].field}
            {item}
            parentDiv={fieldParentDivs[0]}
            {localeCalendarHeader}
          />
        {/key}
        {#if !filterTypeHash[item.type].singleton}
          <!-- svelte-ignore a11y-invalid-attribute -->
          <a
            href="javascript:void(0);"
            class="d-inline-block"
            on:click={addFilterItemContent}
          >
            <SVG
              title={window.trans("Add")}
              class="mt-icon mt-icon--sm"
              href={window.StaticURI + "images/sprite.svg#ic_add"}
            />
          </a>
        {/if}
      </div>
    </div>
  {/if}
</div>
