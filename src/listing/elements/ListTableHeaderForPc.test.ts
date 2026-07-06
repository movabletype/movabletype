import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import ListTableHeaderForPcTestWrapper from "./ListTableHeaderForPcTestWrapper.svelte";
import {
  createMockListStoreContext,
  createMockColumn,
} from "../../tests/helpers/createListingTestProps.svelte";

describe("ListTableHeaderForPc Component", () => {
  it("should render the component", () => {
    const context = createMockListStoreContext();

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: true,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render select-all checkbox when hasListActions is true", () => {
    const context = createMockListStoreContext();

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: true,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const checkbox = container.querySelector("#select-all");
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should not render select-all checkbox when hasListActions is false", () => {
    const context = createMockListStoreContext();

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const checkbox = container.querySelector("#select-all");
    expect(checkbox).not.toBeInTheDocument();
  });

  it("should render column headers for checked columns", () => {
    const columns = [
      createMockColumn({ id: "title", label: "Title", checked: 1 }),
      createMockColumn({ id: "author", label: "Author", checked: 1 }),
    ];
    const context = createMockListStoreContext({ columns });

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const headers = container.querySelectorAll("th[scope='col']");
    expect(headers).toHaveLength(2);
    expect(headers[0]).toHaveTextContent("Title");
    expect(headers[1]).toHaveTextContent("Author");
  });

  it("should not render unchecked columns", () => {
    const columns = [
      createMockColumn({ id: "title", label: "Title", checked: 1 }),
      createMockColumn({ id: "hidden", label: "Hidden", checked: 0 }),
    ];
    const context = createMockListStoreContext({ columns });

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const headers = container.querySelectorAll("th[scope='col']");
    expect(headers).toHaveLength(1);
    expect(headers[0]).toHaveTextContent("Title");
  });

  it("should not render __mobile column", () => {
    const columns = [
      createMockColumn({ id: "title", label: "Title", checked: 1 }),
      createMockColumn({ id: "__mobile", label: "Mobile", checked: 1 }),
    ];
    const context = createMockListStoreContext({ columns });

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const headers = container.querySelectorAll("th[scope='col']");
    expect(headers).toHaveLength(1);
    expect(headers[0]).toHaveTextContent("Title");
  });

  it("should add sortable class to sortable columns", () => {
    const columns = [
      createMockColumn({
        id: "title",
        label: "Title",
        checked: 1,
        sortable: 1,
      }),
    ];
    const context = createMockListStoreContext({ columns });

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const header = container.querySelector("th[scope='col']");
    expect(header).toHaveClass("sortable");
  });

  it("should render link for sortable columns", () => {
    const columns = [
      createMockColumn({
        id: "title",
        label: "Title",
        checked: 1,
        sortable: 1,
      }),
    ];
    const context = createMockListStoreContext({ columns });

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const link = container.querySelector("th[scope='col'] a");
    expect(link).toBeInTheDocument();
    expect(link).toHaveTextContent("Title");
  });

  it("should add sorted class when column is sorted", () => {
    const columns = [
      createMockColumn({
        id: "title",
        label: "Title",
        checked: 1,
        sortable: 1,
      }),
    ];
    const context = createMockListStoreContext({
      columns,
      sortBy: "title",
      sortOrder: "ascend",
    });

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const header = container.querySelector("th[scope='col']");
    expect(header).toHaveClass("sorted");
  });

  it("should add ascend class to link when sorted ascending", () => {
    const columns = [
      createMockColumn({
        id: "title",
        label: "Title",
        checked: 1,
        sortable: 1,
      }),
    ];
    const context = createMockListStoreContext({
      columns,
      sortBy: "title",
      sortOrder: "ascend",
    });

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const link = container.querySelector("th[scope='col'] a");
    expect(link).toHaveClass("mt-table__ascend");
  });

  it("should add descend class to link when sorted descending", () => {
    const columns = [
      createMockColumn({
        id: "title",
        label: "Title",
        checked: 1,
        sortable: 1,
      }),
    ];
    const context = createMockListStoreContext({
      columns,
      sortBy: "title",
      sortOrder: "descend",
    });

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const link = container.querySelector("th[scope='col'] a");
    expect(link).toHaveClass("mt-table__descend");
  });

  it("should have d-none d-md-table-row classes for desktop display", () => {
    const context = createMockListStoreContext();

    const { container } = render(ListTableHeaderForPcTestWrapper, {
      props: {
        context,
        hasListActions: false,
        toggleAllRowsOnPage: vi.fn(),
        toggleSortColumn: vi.fn(),
      },
    });

    const row = container.querySelector("tr");
    expect(row).toHaveClass("d-none");
    expect(row).toHaveClass("d-md-table-row");
  });
});
