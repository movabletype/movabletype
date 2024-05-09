<script>
  import { onMount } from "svelte";
  import { ListingOpts, ListingStore } from "../ListingStore.ts";

  import DisplayOptions from "./DisplayOptions.svelte";
  import DisplayOptionsForMobile from "./DisplayOptionsForMobile.svelte";
  import ListCount from "./ListCount.svelte";
  import ListPagination from "./ListPagination.svelte";
  import ListTable from "./ListTable.svelte";
  import ListActions from "./ListActions.svelte";
  import ListFilter from "./ListFilter.svelte";

  export let opts = {
    buttonActions: [],
    listActions: [],
    moreListActions: [],
    buttonActionsForMobile: [],
    listActionsForMobile: [],
    moreListActionsForMobile: [],
  };
  export let store = {};

  ListingOpts.set(opts);
  ListingStore.set(store);

  onMount(() => {
    loadListEvent();
  });

  // listClient
  function sendRequest(args, data) {
    const formData = new URLSearchParams();
    for (const key in data) {
      formData.append(key, data[key]);
    }
    const url = $ListingStore.listClient.url;
    fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "X-Requested-With": "XMLHttpRequest",
      },
      body: formData,
    })
      .then(function (response) {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then(function (data) {
        args.done(data);
      })
      .catch(function (error) {
        console.error("Fetch Error:", error);
      });
  }

  function filteredList(args) {
    if (!args) {
      args = {};
    }
    let data = {
      __mode: "filtered_list",
      blog_id: $ListingStore.listClient.siteId,
      columns: serializeColumns(args.columns),
      datasource: $ListingStore.listClient.datasource,
      items: JSON.stringify(args.filter.items),
      limit: args.limit,
      magic_token: $ListingStore.listClient.magicToken,
      page: args.page,
      sort_by: args.sortBy,
      sort_order: args.sortOrder,
    };
    if (args.filter.id && !args.noFilterId) {
      data.fid = args.filter.id;
    }
    sendRequest(args, data);
  }

  function serializeColumns(columns) {
    if (Array.isArray(columns)) {
      return columns.join(",");
    } else {
      return columns;
    }
  }

  function loadListEvent(args) {
    if (!args) {
      args = {};
    }
    const refreshCurrentFilter = args.refreshCurrentFilter;
    const noFilterId = args.noFilterId;
    const moveToPagination = args.moveToPagination;

    if (!$ListingStore.sortOrder) {
      $ListingStore.toggleSortColumn($ListingStore.sortBy);
    }

    if ($ListingStore.disableUserDispOption) {
      $ListingStore.resetColumns();
    }

    updateIsLoading(true);
    refreshViewEvent({ notCallListReady: true });

    if (refreshCurrentFilter) {
      $ListingStore.page = 1;
    }
    filteredList({
      columns: getCheckedColumnIds(),
      filter: $ListingStore.currentFilter,
      limit: $ListingStore.limit,
      noFilterId: noFilterId,
      page: $ListingStore.page,
      sortBy: $ListingStore.sortBy,
      sortOrder: $ListingStore.sortOrder,
      done: function (data, textStatus, jqXHR) {
        if (data && !data.error) {
          setResult(data.result);
          updateIsLoading(false);
          refreshViewEvent({ moveToPagination: moveToPagination });
        } else if (data.error) {
          alert(data.error);
          $ListingStore.objects = [];
        }
      },
      always: function () {
        updateIsLoading(false);
        if (refreshCurrentFilter) {
          refreshCurrentFilterEvent();
        }
        refreshViewEvent({ moveToPagination: moveToPagination });
      },
    });
  }

  function refreshViewEvent(args) {
    if (!args) args = {};
    const moveToPagination = args.moveToPagination;
    const notCallListReady = args.notCallListReady;

    //self.update()
    updateSubFields();
    if (moveToPagination) {
      window.document.body.scrollTop = window.document.body.scrollHeight;
    }
    if (!notCallListReady) {
      listReadyEvent();
    }
  }

  function listReadyEvent() {
    let tag_names = {};
    const editTagElements = document.querySelectorAll(".edit-tag");
    editTagElements.forEach(function (element) {
      tag_names[element.textContent] = 1;
    });
  }

  function refreshCurrentFilterEvent() {
    $ListingStore.currentFilter = $ListingStore.currentFilter;
  }

  function updateSubFields() {
    $ListingStore.columns.forEach(function (column) {
      column.sub_fields.forEach(function (subField) {
        const selector = "td." + subField.parent_id + " ." + subField.class;
        const element = document.querySelector(selector);
        if (subField.checked) {
          element.style.display = "block";
        } else {
          element.style.display = "none";
        }
      });
    });
  }

  function tableClass() {
    const objectType = opts.objectTypeForTableClass || opts.objectType;
    return "list-" + objectType;
  }

  function addFilterItem(filterItem) {
    if ($ListingStore.currentFilter.id == $ListingStore.allpassFilter.id) {
      createNewFilter(trans("New Filter"));
    }
    $ListingStore.currentFilter.items.push({ type: filterItem });
  }

  function addFilterItemContent(itemIndex, contentIndex) {
    if ($ListingStore.currentFilter.items[itemIndex].type != "pack") {
      const items = [$ListingStore.currentFilter.items[itemIndex]];
      $ListingStore.currentFilter.items[itemIndex] = {
        type: "pack",
        args: { op: "and", items: items },
      };
    }
    const type =
      $ListingStore.currentFilter.items[itemIndex].args.items[0].type;
    $ListingStore.currentFilter.items[itemIndex].args.items.splice(
      contentIndex + 1,
      0,
      { type: type, args: {} }
    );
    $ListingStore.currentFilter.items[itemIndex] = JSON.parse(
      JSON.stringify($ListingStore.currentFilter.items[itemIndex])
    );
  }

  function checkAllRows() {
    const nextState = true;
    updateAllRowsOnPage(nextState);
    $ListingStore.checkedAllRows = nextState;
  }

  function clickRow(rowIndex) {
    const object = $ListingStore.objects[rowIndex];
    if (!object.object[0]) {
      return;
    }
    object.clicked = true;
  }

  function createNewFilter(filterLabel) {
    $ListingStore.currentFilter = {
      items: [],
      label: trans(filterLabel || "New Filter"),
    };
  }

  function getCheckedRowCount() {
    if ($ListingStore.checkedAllRows) {
      return $ListingStore.count;
    } else {
      return $ListingStore.objects.filter(function (object) {
        return object.checked;
      }).length;
    }
  }

  function getColumn(columnId) {
    return $ListingStore.columns.filter(function (column) {
      return column.id == columnId;
    })[0];
  }

  function getCheckedColumnIds() {
    const columnIds = [];
    $ListingStore.columns.forEach(function (column) {
      if (column.checked) {
        columnIds.push(column.id);
      }
      column.sub_fields.forEach(function (subField) {
        if (subField.checked) {
          columnIds.push(subField.id);
        }
      });
    });
    return columnIds;
  }

  function getCheckedRowIds() {
    return $ListingStore.objects
      .filter(function (object) {
        return object.checked;
      })
      .map(function (object) {
        return object.object[0];
      });
  }

  function getFilter(filterId) {
    if (!filterId || !$ListingStore.filters) {
      return;
    }
    const selectedFilters = $ListingStore.filters.filter(function (filter) {
      return filter.id == filterId;
    });
    if (selectedFilters.length > 0) {
      return selectedFilters[0];
    } else {
      return null;
    }
  }

  function getListEnd() {
    return (
      ($ListingStore.page - 1) * $ListingStore.limit +
      $ListingStore.objects.length
    );
  }

  function getListStart() {
    return ($ListingStore.page - 1) * $ListingStore.limit + 1;
  }

  function getMobileColumnIndex() {
    let mobileColumnIndex = -1;
    let hasMobileColumn = false;
    $ListingStore.columns.some(function (column) {
      if (!column.checked) {
        return false;
      }
      mobileColumnIndex++;
      if (column.id == "__mobile") {
        hasMobileColumn = true;
        return true;
      }
    });
    return hasMobileColumn ? mobileColumnIndex : -1;
  }

  function getNewFilterLabel(objectLabel) {
    let temp_base = 1;
    let temp = "";
    while (1) {
      temp = trans("[_1] - Filter [_2]", objectLabel, temp_base++);
      const hasSameLabel = $ListingStore.filters.some(function (f) {
        return f.label == temp;
      });
      if (!hasSameLabel) {
        break;
      }
    }
    return temp;
  }

  function getSubField(subFieldId) {
    let returnSubField = null;
    $ListingStore.columns.some(function (column) {
      return column.sub_fields.some(function (subField) {
        if (subField.id == subFieldId) {
          returnSubField = subField;
          return true;
        }
      });
    });
    return returnSubField;
  }

  function hasMobileColumn() {
    return $ListingStore.getMobileColumnIndex() > -1;
  }

  function hasSystemFilter() {
    return $ListingStore.filters.some(function (filter) {
      return filter.can_save == "0";
    });
  }

  function isCheckedAllRowsOnPage() {
    return $ListingStore.objects.every(function (object) {
      return object.checked;
    });
  }

  function isFilterItemSelected(type) {
    return $ListingStore.currentFilter.items.some(function (item) {
      return item.type == type;
    });
  }

  function movePage(page) {
    const moved = page != $ListingStore.page;
    if (page <= 1) {
      $ListingStore.page = 1;
    } else if (page >= $ListingStore.pageMax) {
      $ListingStore.page = $ListingStore.pageMax;
    } else {
      $ListingStore.page = page;
    }
    return moved;
  }

  function removeFilterItemByIndex(itemIndex) {
    $ListingStore.currentFilter.items.splice(itemIndex, 1);
  }

  function removeFilterItemContent(itemIndex, contentIndex) {
    $ListingStore.currentFilter.items[itemIndex].args.items.splice(
      contentIndex,
      1
    );
  }

  function resetAllClickedRows() {
    $ListingStore.objects.forEach(function (object) {
      object.clicked = false;
    });
  }

  function setFilter(filter) {
    if (!filter) {
      return false;
    }
    let changed = false;
    if (filter == $ListingStore.currentFilter) {
      changed = false;
    } else {
      $ListingStore.currentFilter = filter;
      changed = true;
    }
    return changed;
  }

  function setFilterById(filterId) {
    let filter = {};
    if (filterId == $ListingStore.allpassFilter.id) {
      filter = $ListingStore.allpassFilter;
    } else {
      filter = $ListingStore.getFilter(filterId);
    }
    if (!filter) {
      return false;
    }
    setFilter(filter);
  }

  function setDeleteFilterResult(result) {
    $ListingStore.setFilterById(result.id);
    $ListingStore.filters = result.filters;
  }

  function setResult(result) {
    const resultColumnIds = result.columns.split(",");
    const showColumns = [];
    $ListingStore.columns.forEach(function (column) {
      column.checked = resultColumnIds.indexOf(column.id) >= 0;
      column.sub_fields.forEach(function (subField) {
        subField.checked = resultColumnIds.indexOf(subField.id) >= 0;
      });
      if (column.checked) {
        showColumns.push(column);
      }
    });
    $ListingStore.showColumns = showColumns;
    $ListingStore.objects = result.objects.map(function (object) {
      return {
        checked: false,
        object: object,
      };
    });
    $ListingStore.count = result.count;
    $ListingStore.editableCount = result.editable_count;
    $ListingStore.pageMax = result.page_max;
    $ListingStore.filters = result.filters;
    setFilterById(result.id);

    $ListingStore.checkedAllRows = false;
    $ListingStore.checkedAllRowsOnPage = false;
  }

  function setSaveFilterResult(result) {
    $ListingStore.filters = result.filters;
    $ListingStore.setFilterById($ListingStore.currentFilter.id);
  }

  function toggleAllRowsOnPage() {
    const nextState = !$ListingStore.checkedAllRowsOnPage;
    $ListingStore.updateAllRowsOnPage(nextState);
  }

  function toggleColumn(columnId) {
    const column = $ListingStore.getColumn(columnId);
    if (column) {
      column.checked = !column.checked;
    }
  }

  function toggleRow(rowIndex) {
    const object = $ListingStore.objects[rowIndex];
    if (!object.object[0]) {
      return;
    }
    const currentState = object.checked;
    object.checked = !currentState;

    $ListingStore.checkedAllRowsOnPage = $ListingStore.isCheckedAllRowsOnPage();
    $ListingStore.checkedAllRows = false;
  }

  function toggleSortColumn(columnId) {
    if ($ListingStore.sortOrder && columnId == $ListingStore.sortBy) {
      if ($ListingStore.sortOrder == "ascend") {
        $ListingStore.sortOrder = "descend";
      } else {
        $ListingStore.sortOrder = "ascend";
      }
    } else {
      $ListingStore.sortBy = columnId;
      const column = $ListingStore.getColumn(columnId);
      if (column) {
        $ListingStore.sortOrder = column.default_sort_order || "ascend";
      } else {
        $ListingStore.sortOrder = "ascend";
      }
    }
  }

  function toggleSubField(subFieldId) {
    const subField = $ListingStore.getSubField(subFieldId);
    if (subField) {
      subField.checked = !subField.checked;
    }
  }

  function resetColumns() {
    $ListingStore.columns.forEach(function (column) {
      column.checked = column.is_default;
      column.sub_fields.forEach(function (subField) {
        subField.checked = subField.is_default;
      });
    });
  }

  function updateAllRowsOnPage(nextState) {
    $ListingStore.objects.forEach(function (object) {
      if (object.object[0]) {
        object.checked = nextState;
      }
    });
    $ListingStore.checkedAllRowsOnPage = nextState;
    $ListingStore.checkedAllRows = false;
  }

  function updateIsLoading(nextState) {
    $ListingStore.isLoading = nextState;
  }

  function updateLimit(limit) {
    $ListingStore.limit = limit;
  }
</script>

<div class="d-none d-md-block mb-3">
  <DisplayOptions />
</div>
<div id="actions-bar-top" class="row mb-5 mb-md-3">
  <div class="col">
    <ListActions />
  </div>
  <div class="col-auto align-self-end list-counter">
    <ListCount />
  </div>
</div>
<div class="row mb-5 mb-md-3">
  <div class="col-12">
    <div class="card">
      {#if opts.useFilters}
        <ListFilter />
      {/if}
      <div style="overflow-x: auto">
        <table
          id="{opts.objectType}-table"
          class="table mt-table {tableClass()}"
        >
          <ListTable />
        </table>
      </div>
    </div>
  </div>
</div>
{#if $ListingStore.count != 0}
  <div class="row">
    <ListPagination />
  </div>
{/if}
<DisplayOptionsForMobile />
