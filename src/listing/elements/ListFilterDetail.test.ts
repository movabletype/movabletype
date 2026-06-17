import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import ListFilterDetailTestWrapper from "./ListFilterDetailTestWrapper.svelte";
import {
  createMockFilter,
  createMockListStoreContext,
} from "../../tests/helpers/createListingTestProps.svelte";
import type * as Listing from "../../@types/listing";

const createMockFilterType = (
  overrides: Partial<Listing.FilterType> = {},
): Listing.FilterType => ({
  baseType: "string",
  field: "test_field",
  type: "test_type",
  label: "Test Type",
  editable: true,
  ...overrides,
});

describe("ListFilterDetail Component", () => {
  it("should render the component", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ items: [] });
    const filterTypes: Listing.FilterType[] = [];

    const { container } = render(ListFilterDetailTestWrapper, {
      props: {
        context,
        currentFilter,
        filterTypes,
        isFilterItemSelected: vi.fn().mockReturnValue(false),
        listFilterTopAddFilterItem: vi.fn(),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopGetItemValues: vi.fn(),
        listFilterTopIsUserFilter: vi.fn().mockReturnValue(false),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        listFilterTopValidateFilterDetails: vi.fn().mockReturnValue(true),
        localeCalendarHeader: [],
        objectLabel: "entries",
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render Select Filter Item button", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ items: [] });
    const filterTypes: Listing.FilterType[] = [];

    const { container } = render(ListFilterDetailTestWrapper, {
      props: {
        context,
        currentFilter,
        filterTypes,
        isFilterItemSelected: vi.fn().mockReturnValue(false),
        listFilterTopAddFilterItem: vi.fn(),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopGetItemValues: vi.fn(),
        listFilterTopIsUserFilter: vi.fn().mockReturnValue(false),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        listFilterTopValidateFilterDetails: vi.fn().mockReturnValue(true),
        localeCalendarHeader: [],
        objectLabel: "entries",
      },
    });

    const button = container.querySelector(".dropdown-toggle");
    expect(button).toBeInTheDocument();
    expect(button).toHaveTextContent("Select Filter Item...");
  });

  it("should render filter type options in dropdown", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ items: [] });
    const filterTypes = [
      createMockFilterType({ type: "author", label: "Author", editable: true }),
      createMockFilterType({ type: "status", label: "Status", editable: true }),
    ];

    const { container } = render(ListFilterDetailTestWrapper, {
      props: {
        context,
        currentFilter,
        filterTypes,
        isFilterItemSelected: vi.fn().mockReturnValue(false),
        listFilterTopAddFilterItem: vi.fn(),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopGetItemValues: vi.fn(),
        listFilterTopIsUserFilter: vi.fn().mockReturnValue(false),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        listFilterTopValidateFilterDetails: vi.fn().mockReturnValue(true),
        localeCalendarHeader: [],
        objectLabel: "entries",
      },
    });

    const dropdownItems = container.querySelectorAll(".dropdown-item");
    expect(dropdownItems).toHaveLength(2);
    expect(dropdownItems[0]).toHaveTextContent("Author");
    expect(dropdownItems[1]).toHaveTextContent("Status");
  });

  it("should not render non-editable filter types", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ items: [] });
    const filterTypes = [
      createMockFilterType({ type: "author", label: "Author", editable: true }),
      createMockFilterType({
        type: "system",
        label: "System",
        editable: false,
      }),
    ];

    const { container } = render(ListFilterDetailTestWrapper, {
      props: {
        context,
        currentFilter,
        filterTypes,
        isFilterItemSelected: vi.fn().mockReturnValue(false),
        listFilterTopAddFilterItem: vi.fn(),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopGetItemValues: vi.fn(),
        listFilterTopIsUserFilter: vi.fn().mockReturnValue(false),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        listFilterTopValidateFilterDetails: vi.fn().mockReturnValue(true),
        localeCalendarHeader: [],
        objectLabel: "entries",
      },
    });

    const dropdownItems = container.querySelectorAll(".dropdown-item");
    expect(dropdownItems).toHaveLength(1);
    expect(dropdownItems[0]).toHaveTextContent("Author");
  });

  it("should add disabled class to selected filter items", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ items: [] });
    const filterTypes = [
      createMockFilterType({ type: "author", label: "Author", editable: true }),
    ];

    const { container } = render(ListFilterDetailTestWrapper, {
      props: {
        context,
        currentFilter,
        filterTypes,
        isFilterItemSelected: vi.fn().mockReturnValue(true),
        listFilterTopAddFilterItem: vi.fn(),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopGetItemValues: vi.fn(),
        listFilterTopIsUserFilter: vi.fn().mockReturnValue(false),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        listFilterTopValidateFilterDetails: vi.fn().mockReturnValue(true),
        localeCalendarHeader: [],
        objectLabel: "entries",
      },
    });

    const dropdownItem = container.querySelector(".dropdown-item");
    expect(dropdownItem).toHaveClass("disabled");
  });

  it("should set data-mt-filter-type attribute on filter items", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ items: [] });
    const filterTypes = [
      createMockFilterType({ type: "author", label: "Author", editable: true }),
    ];

    const { container } = render(ListFilterDetailTestWrapper, {
      props: {
        context,
        currentFilter,
        filterTypes,
        isFilterItemSelected: vi.fn().mockReturnValue(false),
        listFilterTopAddFilterItem: vi.fn(),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopGetItemValues: vi.fn(),
        listFilterTopIsUserFilter: vi.fn().mockReturnValue(false),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        listFilterTopValidateFilterDetails: vi.fn().mockReturnValue(true),
        localeCalendarHeader: [],
        objectLabel: "entries",
      },
    });

    const dropdownItem = container.querySelector(".dropdown-item");
    expect(dropdownItem).toHaveAttribute("data-mt-filter-type", "author");
  });

  it("should render list-filter-buttons container", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ items: [] });

    const { container } = render(ListFilterDetailTestWrapper, {
      props: {
        context,
        currentFilter,
        filterTypes: [],
        isFilterItemSelected: vi.fn().mockReturnValue(false),
        listFilterTopAddFilterItem: vi.fn(),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopGetItemValues: vi.fn(),
        listFilterTopIsUserFilter: vi.fn().mockReturnValue(false),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        listFilterTopValidateFilterDetails: vi.fn().mockReturnValue(true),
        localeCalendarHeader: [],
        objectLabel: "entries",
      },
    });

    const buttonsContainer = container.querySelector(
      '[data-is="list-filter-buttons"]',
    );
    expect(buttonsContainer).toBeInTheDocument();
  });
});
