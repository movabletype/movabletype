import { render } from "@testing-library/svelte";
import { describe, it, expect, vi, beforeEach } from "vitest";
import ListTableBodyTestWrapper from "./ListTableBodyTestWrapper.svelte";
import {
  createMockColumn,
  createMockObject,
  createListTableBodyProps,
} from "../../tests/helpers/createListingTestProps.svelte";

describe("ListTableBody Component", () => {
  beforeEach(() => {
    // @ts-expect-error: MT is not defined
    window.MT = {
      Util: {
        isMobileView: vi.fn().mockReturnValue(false),
      },
    };
  });

  it("should render the component", () => {
    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps(),
    });

    expect(container).toBeTruthy();
  });

  it("should render zero state message when no objects", () => {
    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({ contextOverrides: { objects: [] } }),
    });

    expect(container.textContent).toContain("No entries could be found.");
  });

  it("should render objects when they exist", () => {
    const columns = [
      createMockColumn({ id: "title", label: "Title", checked: 1 }),
    ];
    const objects = [
      createMockObject({ object: ["First Entry"] }),
      createMockObject({ object: ["Second Entry"] }),
    ];

    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({
        contextOverrides: { columns, objects },
      }),
    });

    const rows = container.querySelectorAll('tr[data-is="list-table-row"]');
    expect(rows).toHaveLength(2);
  });

  it("should set data-index on rows", () => {
    const objects = [
      createMockObject({ object: ["First"] }),
      createMockObject({ object: ["Second"] }),
    ];

    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({ contextOverrides: { objects } }),
    });

    const rows = container.querySelectorAll('tr[data-is="list-table-row"]');
    expect(rows[0]).toHaveAttribute("data-index", "0");
    expect(rows[1]).toHaveAttribute("data-index", "1");
  });

  it("should add highlight class to checked rows", () => {
    const objects = [createMockObject({ checked: true, object: [] })];

    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({ contextOverrides: { objects } }),
    });

    const row = container.querySelector('tr[data-is="list-table-row"]');
    expect(row).toHaveClass("mt-table__highlight");
  });

  it("should add highlight class to clicked rows", () => {
    const objects = [createMockObject({ clicked: true, object: [] })];

    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({ contextOverrides: { objects } }),
    });

    const row = container.querySelector('tr[data-is="list-table-row"]');
    expect(row).toHaveClass("mt-table__highlight");
  });

  it("should add checked attribute to checked rows", () => {
    const objects = [createMockObject({ checked: true, object: [] })];

    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({ contextOverrides: { objects } }),
    });

    const row = container.querySelector('tr[data-is="list-table-row"]');
    expect(row).toHaveAttribute("checked", "checked");
  });

  it("should render select all items link when all rows on page checked but not all rows", () => {
    const objects = [createMockObject({ object: [] })];

    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({
        contextOverrides: {
          objects,
          pageMax: 2,
          checkedAllRowsOnPage: true,
          checkedAllRows: false,
          count: 50,
        },
      }),
    });

    expect(container.textContent).toContain("Select all 50 items");
  });

  it("should render all items selected message when all rows checked", () => {
    const objects = [createMockObject({ object: [] })];

    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({
        contextOverrides: {
          objects,
          pageMax: 2,
          checkedAllRows: true,
          count: 50,
        },
      }),
    });

    expect(container.textContent).toContain("All 50 items are selected");
  });

  it("should not render select all link when only one page", () => {
    const objects = [createMockObject({ object: [] })];

    const { container } = render(ListTableBodyTestWrapper, {
      props: createListTableBodyProps({
        contextOverrides: {
          objects,
          pageMax: 1,
          checkedAllRowsOnPage: true,
          checkedAllRows: false,
          count: 10,
        },
      }),
    });

    expect(container.textContent).not.toContain("Select all");
  });
});
