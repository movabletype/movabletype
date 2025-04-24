<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import { onMount } from "svelte";

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

  onMount(() => {
    initializeDateOption();
    initializeOptionWithBlank();
  });

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
    initializeDateOption();
    initializeOptionWithBlank();
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

  const initializeDateOption = (): void => {
    const dateOption = ($node: JQuery<HTMLElement>): void => {
      const val = $node.val();
      let type: string;
      switch (val) {
        case "hours":
          type = "hours";
          break;
        case "days":
          type = "days";
          break;
        case "before":
        case "after":
          type = "date";
          break;
        case "future":
        case "past":
        case "blank":
        case "not_blank":
          type = "none";
          break;
        default:
          type = "range";
      }
      $node
        .parents(".item-content")
        .find(".date-options span.date-option")
        .hide();
      $node
        .parents(".item-content")
        .find(".date-option." + type)
        .show();
    };
    jQuery(root)
      .find(".filter-date")
      .each(function (index, element) {
        const $node = jQuery(element);
        dateOption($node);
        $node.on("change", function () {
          dateOption($node);
        });
      });
    jQuery(root)
      .find("input.date")
      .datepicker({
        dateFormat: "yy-mm-dd",
        dayNamesMin: localeCalendarHeader,
        monthNames: [
          "- 01",
          "- 02",
          "- 03",
          "- 04",
          "- 05",
          "- 06",
          "- 07",
          "- 08",
          "- 09",
          "- 10",
          "- 11",
          "- 12",
        ],
        showMonthAfterYear: true,
        prevText: "<",
        nextText: ">",
      });
  };

  const initializeOptionWithBlank = (): void => {
    const changeOption = ($node: JQuery<HTMLElement>): void => {
      if ($node.val() === "blank" || $node.val() === "not_blank") {
        $node.parent().find("input[type=text]").hide();
      } else {
        $node.parent().find("input[type=text]").show();
      }
    };
    jQuery(root)
      .find(".filter-blank")
      .each(function (index, element) {
        const $node = jQuery(element);
        changeOption($node);
        $node.on("change", function () {
          changeOption($node);
        });
      });
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
              {#key currentFilter}
                <ListFilterItemField
                  field={filterTypeHash[loopItem.type].field}
                  item={loopItem}
                  parentDiv={fieldParentDivs[index]}
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
        {#key currentFilter}
          <ListFilterItemField
            field={filterTypeHash[item.type].field}
            {item}
            parentDiv={fieldParentDivs[0]}
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
