<script lang="ts">
  import type * as Listing from "../../@types/listing";

  import ListFilterDetail from "./ListFilterDetail.svelte";
  import ListFilterHeader from "./ListFilterHeader.svelte";

  export let filterTypes: Array<Listing.FilterType>;
  export let listActionClient: Listing.ListActionClient;
  export let localeCalendarHeader: Array<string>;
  export let objectLabel: string;
  export let store: Listing.ListStore;

  let currentFilter = store.currentFilter;
  let validateErrorMessage: JQuery<HTMLElement>;

  const validateFilterName = (name: string): boolean => {
    return !store.filters.some(function (filter) {
      return filter.label === name;
    });
  };

  /* @ts-expect-error : mtValidateRules is not defined */
  jQuery.mtValidateRules["[name=filter_name], .rename-filter-input"] =
    function ($e: JQuery<HTMLElement>) {
      const val = $e.val();
      if (typeof val !== "string") {
        return this.raise(window.trans("Invalid type: [_1]", typeof val));
      }

      if (validateFilterName(val)) {
        return true;
      } else {
        return this.raise(window.trans('Label "[_1]" is already in use.', val));
      }
    };

  store.on("refresh_current_filter", () => {
    currentFilter = store.currentFilter;
  });

  store.on("open_filter_detail", () => {
    /* @ts-expect-error : collapse is not defined */
    jQuery("#list-filter-collapse").collapse("show");
  });

  store.on("close_filter_detail", () => {
    /* @ts-expect-error : collapse is not defined */
    jQuery("#list-filter-collapse").collapse("hide");
  });

  const addFilterItem = (filterType: string): void => {
    if (isAllpassFilter) {
      createNewFilter(window.trans("New Filter"));
    }
    currentFilter.items.push({ type: filterType, args: { items: [] } });
    update();
  };

  const addFilterItemContent = (
    itemIndex: string,
    contentIndex: string,
  ): void => {
    if (currentFilter.items[itemIndex].type !== "pack") {
      const items = [currentFilter.items[itemIndex]];
      currentFilter.items[itemIndex] = {
        type: "pack",
        args: { op: "and", items: items },
      };
    }
    const type = currentFilter.items[itemIndex].args.items[0].type;
    currentFilter.items[itemIndex].args.items.splice(contentIndex + 1, 0, {
      type: type,
      args: {},
    });
    update();
  };

  const createNewFilter = (filterLabel?: string): void => {
    currentFilter = {
      can_delete: 0,
      can_save: 1,
      can_edit: 0,
      id: "",
      items: [],
      label: filterLabel || window.trans("New Filter"),
    };
  };

  const getItemValues = (): void => {
    const $items = jQuery("#filter-detail .filteritem:not(.error)");
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    let vals: Array<any> = [];
    $items.each(function () {
      let data: { type?: string; args?: object } | undefined = {};
      const fields: Array<{ type: string; args: object }> = [];
      const $types = jQuery(this).find(".filtertype");
      $types.each(function () {
        const type = (jQuery(this)
          .attr("class")
          ?.match(/type-(\w+)/) || [])[1];
        jQuery(this)
          .find(".item-content")
          .each(function () {
            const args = {};
            jQuery(this)
              .find(":input")
              .each(function () {
                const re = new RegExp(type + "-(\\w+)");
                const key = (jQuery(this).attr("class")?.match(re) || [])[1];
                if (key && !Object.prototype.hasOwnProperty.call(args, key)) {
                  args[key] = jQuery(this).val();
                }
              });
            fields.push({ type: type, args: args });
          });
      });
      if (fields.length > 1) {
        data["type"] = "pack";
        data["args"] = {
          op: "and",
          items: fields,
        };
      } else {
        data = fields.pop();
      }
      vals.push(data);
    });
    currentFilter.items = vals;
  };

  $: isAllpassFilter = currentFilter.id === store.allpassFilter.id;

  /* add "filter" argument for updating this output after changing "filter" */
  const isFilterItemSelected = (
    filter: Listing.Filter,
    type: string,
  ): boolean => {
    return filter.items.some(function (item) {
      return item.type === type;
    });
  };

  const isUserFilter = (): boolean => {
    return currentFilter.id && currentFilter.id.match(/^[1-9][0-9]*$/)
      ? true
      : false;
  };

  const removeFilterItem = (itemIndex: string): void => {
    currentFilter.items.splice(Number(itemIndex), 1);
    update();
  };

  const removeFilterItemContent = (
    itemIndex: string,
    contentIndex: string,
  ): void => {
    currentFilter.items[itemIndex].args.items.splice(contentIndex, 1);
  };

  const showMessage = (content: string, cls: string): JQuery<HTMLElement> => {
    const error_block = jQuery("<div />")
      .attr("class", "msg msg-" + cls)
      .append(
        jQuery("<p />")
          .attr("class", "msg-text alert alert-danger alert-dismissible")
          .append(
            '<button type="button" class="close btn-close" data-bs-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>',
          )
          .append(content),
      );
    jQuery("#msg-block").append(error_block);
    return error_block;
  };

  const validateFilterDetails = (): boolean => {
    if (validateErrorMessage) {
      validateErrorMessage.remove();
    }
    let errors = 0;
    jQuery("div#filter-detail div.filteritem").each(function () {
      /* @ts-expect-error : mtValidate is not defined */
      if (!jQuery(this).find("input:visible").mtValidate()) {
        errors++;
        jQuery(this).addClass("highlight error bg-warning");
      } else {
        jQuery(this).removeClass("highlight error bg-warning");
      }
    });
    if (errors) {
      validateErrorMessage = showMessage(
        window.trans(
          "One or more fields in the filter item are not filled in properly.",
        ),
        "error",
      );
    }
    return errors ? false : true;
  };

  const update = (): void => {
    // eslint-disable-next-line no-self-assign
    currentFilter = currentFilter;
  };
</script>

<div data-is="list-filter-header" class="card-header">
  <ListFilterHeader
    {currentFilter}
    {isAllpassFilter}
    listFilterTopCreateNewFilter={createNewFilter}
    listFilterTopUpdate={update}
    {listActionClient}
    {store}
  />
</div>
<div id="list-filter-collapse" class="collapse">
  <div data-is="list-filter-detail" id="filter-detail" class="card-block p-3">
    <ListFilterDetail
      {currentFilter}
      {filterTypes}
      {isFilterItemSelected}
      listFilterTopAddFilterItem={addFilterItem}
      listFilterTopAddFilterItemContent={addFilterItemContent}
      listFilterTopGetItemValues={getItemValues}
      listFilterTopIsUserFilter={isUserFilter}
      listFilterTopRemoveFilterItem={removeFilterItem}
      listFilterTopRemoveFilterItemContent={removeFilterItemContent}
      listFilterTopValidateFilterDetails={validateFilterDetails}
      {localeCalendarHeader}
      {objectLabel}
      {store}
    />
  </div>
</div>
