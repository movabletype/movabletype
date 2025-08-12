<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import { afterUpdate } from "svelte";

  export let field: string;
  export let parentDiv: HTMLDivElement | undefined;
  export let item: Listing.Item;
  export let localeCalendarHeader: Array<string>;

  afterUpdate(() => {
    setValues();
    initializeDateOption();
    initializeOptionWithBlank();
  });

  const setValues = (): void => {
    if (!parentDiv) {
      return;
    }

    for (let key in item.args) {
      if (
        typeof item.args[key] !== "string" &&
        typeof item.args[key] !== "number"
      ) {
        continue;
      }
      const selector = "." + item.type + "-" + key;
      const elements = parentDiv.querySelectorAll(selector);
      Array.prototype.slice.call(elements).forEach(function (element) {
        if (element.tagName === "INPUT" || element.tagName === "SELECT") {
          element.value = item.args[key];
        } else {
          element.textContent = item.args[key];
        }
      });
    }
  };

  const initializeDateOption = (): void => {
    if (!parentDiv) {
      return;
    }

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
    jQuery(parentDiv)
      .find(".filter-date")
      .each(function (_index, element) {
        const $node = jQuery(element);
        dateOption($node);
        $node.on("change", function () {
          dateOption($node);
        });
      });
    jQuery(parentDiv)
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
    if (!parentDiv) {
      return;
    }

    const changeOption = ($node: JQuery<HTMLElement>): void => {
      if ($node.val() === "blank" || $node.val() === "not_blank") {
        $node.parent().find("input[type=text]").hide();
      } else {
        $node.parent().find("input[type=text]").show();
      }
    };
    jQuery(parentDiv)
      .find(".filter-blank")
      .each(function (_index, element) {
        const $node = jQuery(element);
        changeOption($node);
        $node.on("change", function () {
          changeOption($node);
        });
      });
  };
</script>

{@html field}
