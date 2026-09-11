import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import ListFilterItem from "./ListFilterItem.svelte";
import { createMockFilter } from "../../tests/helpers/createListingTestProps.svelte";
import type * as Listing from "../../@types/listing";

const createMockFilterType = (
  overrides: Partial<Listing.FilterType> = {},
): Listing.FilterType => ({
  baseType: "string",
  field: "test_field",
  type: "test_type",
  label: "Test Type",
  ...overrides,
});

const createMockItem = (
  overrides: Partial<Listing.Item> = {},
): Listing.Item => ({
  type: "test_type",
  args: { items: [] },
  ...overrides,
});

describe("ListFilterItem Component", () => {
  it("should render the component", () => {
    const { container } = render(ListFilterItem, {
      props: {
        currentFilter: createMockFilter(),
        filterTypes: [],
        item: createMockItem(),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        localeCalendarHeader: [],
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render a type filter item", () => {
    const { container } = render(ListFilterItem, {
      props: {
        currentFilter: createMockFilter(),
        filterTypes: [createMockFilterType({ type: "type", field: "" })],
        item: createMockItem({ type: "type" }),
        listFilterTopAddFilterItemContent: vi.fn(),
        listFilterTopRemoveFilterItem: vi.fn(),
        listFilterTopRemoveFilterItemContent: vi.fn(),
        localeCalendarHeader: [],
      },
    });

    expect(
      container.querySelector(".filtertype.type-type"),
    ).toBeInTheDocument();
  });
});
