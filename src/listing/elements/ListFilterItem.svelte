<script>
  import { onMount } from "svelte";

  import SS from "../../ss/elements/SS.svelte";

  import ListFilterItemField from "./ListFilterItemField.svelte";

  export let currentFilter;
  export let filterTypes;
  export let item;
  export let listFilterTopAddFilterItemContent;
  export let listFilterTopRemoveFilterItem;
  export let listFilterTopRemoveFilterItemContent;
  export let localeCalendarHeader;

  $: filterTypeHash = filterTypes.reduce((hash, filterType) => {
    hash[filterType.type] = filterType;
    return hash;
  }, {});

  onMount(() => {
    initializeDateOption();
    initializeOptionWithBlank();
  });

  function addFilterItemContent(e) {
    const itemIndex = getListItemIndex(e.target);
    const contentIndex = getListItemContentIndex(e.target);
    let item = currentFilter.items[itemIndex];
    if (item.type == "pack") {
      item = item.args.items[contentIndex];
    }
    jQuery(e.target)
      .parent()
      .each(function () {
        jQuery(this)
          .find(":input")
          .each(function () {
            var re = new RegExp(item.type + "-(\\w+)");
            jQuery(this).attr("class").match(re);
            var key = RegExp.$1;
            if (key && !item.args.hasOwnProperty(key)) {
              item.args[key] = jQuery(this).val();
            }
          });
      });
    listFilterTopAddFilterItemContent(itemIndex, contentIndex);
    initializeDateOption();
    initializeOptionWithBlank();
  }

  function getListItemIndex(element) {
    while (!element.dataset.hasOwnProperty("mtListItemIndex")) {
      element = element.parentElement;
    }
    return Number(element.dataset.mtListItemIndex);
  }

  function getListItemContentIndex(element) {
    while (!element.dataset.hasOwnProperty("mtListItemContentIndex")) {
      element = element.parentElement;
    }
    return Number(element.dataset.mtListItemContentIndex);
  }

  function initializeDateOption() {
    const dateOption = function ($node) {
      const val = $node.val();
      let type;
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
    // FIXME
    // jQuery(this.root)
    //   .find(".filter-date")
    //   .each(function (index, element) {
    //     var $node = jQuery(element);
    //     dateOption($node);
    //     $node.on("change", function () {
    //       dateOption($node);
    //     });
    //   });
    // jQuery(this.root)
    //   .find("input.date")
    //   .datepicker({
    //     dateFormat: "yy-mm-dd",
    //     dayNamesMin: localeCalendarHeader,
    //     monthNames: [
    //       "- 01",
    //       "- 02",
    //       "- 03",
    //       "- 04",
    //       "- 05",
    //       "- 06",
    //       "- 07",
    //       "- 08",
    //       "- 09",
    //       "- 10",
    //       "- 11",
    //       "- 12",
    //     ],
    //     showMonthAfterYear: true,
    //     prevText: "<",
    //     nextText: ">",
    //   });
  }

  function initializeOptionWithBlank() {
    const changeOption = function ($node) {
      if ($node.val() == "blank" || $node.val() == "not_blank") {
        $node.parent().find("input[type=text]").hide();
      } else {
        $node.parent().find("input[type=text]").show();
      }
    };
    // FIXME
    // jQuery(this.root)
    //   .find(".filter-blank")
    //   .each(function (index, element) {
    //     var $node = jQuery(element);
    //     changeOption($node);
    //     $node.on("change", function () {
    //       changeOption($node);
    //     });
    //   });
  }

  function removeFilterItem(e) {
    const itemIndex = getListItemIndex(e.target);
    listFilterTopRemoveFilterItem(itemIndex);
  }

  function removeFilterItemContent(e) {
    const itemIndex = getListItemIndex(e.target);
    const contentIndex = getListItemContentIndex(e.target);
    listFilterTopRemoveFilterItemContent(itemIndex, contentIndex);
  }
</script>

<div class="filteritem">
  <button
    class="close btn-close"
    aria-label="Close"
    on:click={removeFilterItem}
  >
    <span aria-hidden="true">&times;</span>
  </button>
  {#if item.type == "pack"}
    <div>
      {#each item.args.items as i, index}
        {#if filterTypeHash[i.type]}
          <div
            data-mt-list-item-content-index={index}
            class={"filtertype type-" + i.type}
          >
            <div class="item-content form-inline">
              <ListFilterItemField
                field={filterTypeHash[i.type].field}
                item={i}
              />
              <!-- svelte-ignore a11y-invalid-attribute -->
              {#if !filterTypeHash[i.type].singleton}
                <a
                  href="javascript:void(0);"
                  class="d-inline-block"
                  on:click={addFilterItemContent}
                >
                  <SS
                    title={window.trans("Add")}
                    class="mt-icon mt-icon--sm"
                    href={window.StaticURI + "images/sprite.svg#ic_add"}
                  />
                </a>
              {/if}
              {#if !filterTypeHash[i.type].singleton && item.args.items.length > 1}
                <!-- svelte-ignore a11y-invalid-attribute -->
                <a
                  href="javascript:void(0);"
                  on:click={removeFilterItemContent}
                >
                  <SS
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
  {#if item.type != "pack" && filterTypeHash[item.type]}
    <div
      data-mt-list-item-content-index="0"
      class={"filtertype type-" + item.type}
    >
      <div class="item-content form-inline">
        <virtual
          data-is="list-filter-item-field"
          field={filterTypeHash[item.type].field}
          {item}
        />
        <ListFilterItemField field={filterTypeHash[item.type].field} {item} />
        <!-- svelte-ignore a11y-invalid-attribute -->
        {#if !filterTypeHash[item.type].singleton}
          <a
            href="javascript:void(0);"
            class="d-inline-block"
            on:click={addFilterItemContent}
          >
            <SS
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
