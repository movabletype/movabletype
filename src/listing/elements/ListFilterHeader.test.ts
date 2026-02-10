import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import ListFilterHeaderTestWrapper from "./ListFilterHeaderTestWrapper.svelte";
import {
  createMockListStoreContext,
  createMockListActionClient,
  createMockFilter,
} from "../../tests/helpers/createListingTestProps.svelte";

describe("ListFilterHeader Component", () => {
  it("should render the component", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ label: "Test Filter" });
    const listActionClient = createMockListActionClient();

    const { container } = render(ListFilterHeaderTestWrapper, {
      props: {
        context,
        currentFilter,
        isAllpassFilter: false,
        listActionClient,
        listFilterTopCreateNewFilter: vi.fn(),
        listFilterTopUpdate: vi.fn(),
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render Filter label", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ label: "Test Filter" });
    const listActionClient = createMockListActionClient();

    const { container } = render(ListFilterHeaderTestWrapper, {
      props: {
        context,
        currentFilter,
        isAllpassFilter: false,
        listActionClient,
        listFilterTopCreateNewFilter: vi.fn(),
        listFilterTopUpdate: vi.fn(),
      },
    });

    expect(container.textContent).toContain("Filter:");
  });

  it("should render current filter label", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ label: "My Custom Filter" });
    const listActionClient = createMockListActionClient();

    const { container } = render(ListFilterHeaderTestWrapper, {
      props: {
        context,
        currentFilter,
        isAllpassFilter: false,
        listActionClient,
        listFilterTopCreateNewFilter: vi.fn(),
        listFilterTopUpdate: vi.fn(),
      },
    });

    expect(container.textContent).toContain("My Custom Filter");
  });

  it("should render Reset Filter link when not allpass filter", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ label: "Test Filter" });
    const listActionClient = createMockListActionClient();

    const { container } = render(ListFilterHeaderTestWrapper, {
      props: {
        context,
        currentFilter,
        isAllpassFilter: false,
        listActionClient,
        listFilterTopCreateNewFilter: vi.fn(),
        listFilterTopUpdate: vi.fn(),
      },
    });

    const resetLink = container.querySelector("#allpass-filter");
    expect(resetLink).toBeInTheDocument();
    expect(resetLink).toHaveTextContent("Reset Filter");
  });

  it("should not render Reset Filter link when is allpass filter", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ label: "All" });
    const listActionClient = createMockListActionClient();

    const { container } = render(ListFilterHeaderTestWrapper, {
      props: {
        context,
        currentFilter,
        isAllpassFilter: true,
        listActionClient,
        listFilterTopCreateNewFilter: vi.fn(),
        listFilterTopUpdate: vi.fn(),
      },
    });

    const resetLink = container.querySelector("#allpass-filter");
    expect(resetLink).not.toBeInTheDocument();
  });

  it("should render filter toggle button", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ label: "Test Filter" });
    const listActionClient = createMockListActionClient();

    const { container } = render(ListFilterHeaderTestWrapper, {
      props: {
        context,
        currentFilter,
        isAllpassFilter: false,
        listActionClient,
        listFilterTopCreateNewFilter: vi.fn(),
        listFilterTopUpdate: vi.fn(),
      },
    });

    const toggleButton = container.querySelector("#toggle-filter-detail");
    expect(toggleButton).toBeInTheDocument();
    expect(toggleButton).toHaveAttribute("data-bs-toggle", "collapse");
    expect(toggleButton).toHaveAttribute(
      "data-bs-target",
      "#list-filter-collapse",
    );
  });

  it("should render filter select modal opener link", () => {
    const context = createMockListStoreContext();
    const currentFilter = createMockFilter({ label: "Test Filter" });
    const listActionClient = createMockListActionClient();

    const { container } = render(ListFilterHeaderTestWrapper, {
      props: {
        context,
        currentFilter,
        isAllpassFilter: false,
        listActionClient,
        listFilterTopCreateNewFilter: vi.fn(),
        listFilterTopUpdate: vi.fn(),
      },
    });

    const opener = container.querySelector("#opener");
    expect(opener).toBeInTheDocument();
    expect(opener).toHaveAttribute("data-bs-toggle", "modal");
    expect(opener).toHaveAttribute("data-bs-target", "#select-filter");
  });
});
