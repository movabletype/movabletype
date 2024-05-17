<script>
  import ListFilterDetail from "./ListFilterDetail.svelte";
  import ListFilterHeader from "./ListFilterHeader.svelte";

  export let filterTypes;
  export let listActionClient;
  export let localeCalendarHeader;
  export let objectLabel;
  export let store;

  $: currentFilter = store.currentFilter;

  let validateErrorMessage;

  // TODO
  function addFilterItem(filterType) {
    if (isAllpassFilter()) {
      createNewFilter(trans("New Filter"));
    }
    currentFilter.items.push({ type: filterType, args: {} });
  }

  function addFilterItemContent(itemIndex, contentIndex) {
    if (currentFilter.items[itemIndex].type != "pack") {
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
  }

  function createNewFilter(filterLabel) {
    currentFilter = {
      items: [],
      label: filterLabel || window.trans("New Filter"),
    };
  }

  function getItemValues() {
    var $items = jQuery("#filter-detail .filteritem:not(.error)");
    vals = [];
    $items.each(function () {
      var data = {};
      var fields = [];
      var $types = jQuery(this).find(".filtertype");
      $types.each(function () {
        const type = (jQuery(this)
          .attr("class")
          .match(/type-(\w+)/) || [])[1];
        jQuery(this)
          .find(".item-content")
          .each(function () {
            var args = {};
            jQuery(this)
              .find(":input")
              .each(function () {
                var re = new RegExp(type + "-(\\w+)");
                const key = (jQuery(this).attr("class").match(re) || [])[1];
                if (key && !args.hasOwnProperty(key)) {
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
  }

  function isAllpassFilter() {
    return currentFilter.id == store.allpassFilter.id;
  }

  function isFilterItemSelected(type) {
    return currentFilter.items.some(function (item) {
      return item.type == type;
    });
  }

  function isUserFilter() {
    return currentFilter.id && currentFilter.id.match(/^[1-9][0-9]*$/);
  }

  function removeFilterItem(itemIndex) {
    currentFilter.items.splice(itemIndex, 1);
  }

  function removeFilterItemContent(itemIndex, contentIndex) {
    currentFilter.items[itemIndex].args.items.splice(contentIndex, 1);
  }

  function showMessage(content, cls) {
    var error_block;
    if (typeof content == "object") {
      jQuery("#msg-block").append(
        (error_block = jQuery("<div>")
          .attr("class", "msg msg-" + cls)
          .append(
            jQuery("<p />")
              .attr("class", "msg-text alert alert-danger alert-dismissible")
              .append(
                '<button type="button" class="close btn-close" data-bs-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
              )
              .append(content)
          ))
      );
    } else {
      jQuery("#msg-block").append(
        (error_block = jQuery("<div />")
          .attr("class", "msg msg-" + cls)
          .append(
            jQuery("<p />")
              .attr("class", "msg-text alert alert-danger alert-dismissible")
              .append(
                '<button type="button" class="close btn-close" data-bs-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'
              )
              .append(content)
          ))
      );
    }
    return error_block;
  }

  function validateFilterName(name) {
    return !store.filters.some(function (filter) {
      return filter.label == name;
    });
  }

  function validateFilterDetails() {
    if (validateErrorMessage) {
      validateErrorMessage.remove();
    }
    var errors = 0;
    jQuery("div#filter-detail div.filteritem").each(function () {
      if (!jQuery(this).find("input:visible").mtValidate()) {
        errors++;
        jQuery(this).addClass("highlight error bg-warning");
      } else {
        jQuery(this).removeClass("highlight error bg-warning");
      }
    });
    if (errors) {
      validateErrorMessage = showMessage(
        trans(
          "One or more fields in the filter item are not filled in properly."
        ),
        "error"
      );
    }
    return errors ? false : true;
  }

  jQuery.mtValidateRules["[name=filter_name], .rename-filter-input"] =
    function ($e) {
      if (validateFilterName($e.val())) {
        return true;
      } else {
        return this.raise(trans('Label "[_1]" is already in use.', $e.val()));
      }
    };
</script>

<div class="card-header">
  <ListFilterHeader
    {currentFilter}
    {isAllpassFilter}
    listFilterTopCreateNewFilter={createNewFilter}
    {listActionClient}
    {store}
  />
</div>
<div id="list-filter-collapse" class="collapse">
  <div id="filter-detail" class="card-block p-3">
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
