import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import ListActionsForMobile from "./ListActionsForMobile.svelte";
import type * as Listing from "../../@types/listing";

const createMockAction = (
  label: string,
  overrides: Partial<Listing.ListAction> = {},
): Listing.ListAction => ({
  type: "action",
  label,
  ...overrides,
});

const createMockMobileAction = (
  label: string,
  overrides: Partial<Listing.ListAction> = {},
): Listing.ListAction => ({
  type: "action",
  label,
  mobile: true,
  ...overrides,
});

describe("ListActionsForMobile Component", () => {
  it("should render the component", () => {
    const doActionMock = vi.fn();

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        moreListActions: {},
      },
    });

    expect(container).toBeTruthy();
  });

  it("should not render dropdown when no mobile actions", () => {
    const doActionMock = vi.fn();
    const buttonActions: Listing.ButtonActions = {
      delete: createMockAction("Delete"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions,
        doAction: doActionMock,
        listActions: {},
        moreListActions: {},
      },
    });

    const dropdown = container.querySelector(".btn-group");
    expect(dropdown).not.toBeInTheDocument();
  });

  it("should render dropdown when mobile button actions exist", () => {
    const doActionMock = vi.fn();
    const buttonActions: Listing.ButtonActions = {
      delete: createMockMobileAction("Delete"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions,
        doAction: doActionMock,
        listActions: {},
        moreListActions: {},
      },
    });

    const dropdown = container.querySelector(".btn-group");
    expect(dropdown).toBeInTheDocument();
  });

  it("should render Select action button", () => {
    const doActionMock = vi.fn();
    const buttonActions: Listing.ButtonActions = {
      delete: createMockMobileAction("Delete"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions,
        doAction: doActionMock,
        listActions: {},
        moreListActions: {},
      },
    });

    const button = container.querySelector(".dropdown-toggle");
    expect(button).toBeInTheDocument();
    expect(button).toHaveTextContent("Select action");
  });

  it("should render mobile button actions in dropdown", () => {
    const doActionMock = vi.fn();
    const buttonActions: Listing.ButtonActions = {
      delete: createMockMobileAction("Delete"),
      publish: createMockMobileAction("Publish"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions,
        doAction: doActionMock,
        listActions: {},
        moreListActions: {},
      },
    });

    const items = container.querySelectorAll(".dropdown-item");
    expect(items).toHaveLength(2);
    expect(items[0]).toHaveTextContent("Delete");
    expect(items[1]).toHaveTextContent("Publish");
  });

  it("should render mobile list actions in dropdown", () => {
    const doActionMock = vi.fn();
    const listActions: Listing.ListActions = {
      edit: createMockMobileAction("Edit"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions,
        moreListActions: {},
      },
    });

    const items = container.querySelectorAll(".dropdown-item");
    expect(items).toHaveLength(1);
    expect(items[0]).toHaveTextContent("Edit");
  });

  it("should render Plugin Actions header for mobile more list actions", () => {
    const doActionMock = vi.fn();
    const moreListActions: Listing.MoreListActions = {
      custom: createMockMobileAction("Custom Action"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        moreListActions,
      },
    });

    const header = container.querySelector(".dropdown-header");
    expect(header).toBeInTheDocument();
    expect(header).toHaveTextContent("Plugin Actions");
  });

  it("should not render Plugin Actions header when no mobile more list actions", () => {
    const doActionMock = vi.fn();
    const moreListActions: Listing.MoreListActions = {
      custom: createMockAction("Custom Action"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        moreListActions,
      },
    });

    const header = container.querySelector(".dropdown-header");
    expect(header).not.toBeInTheDocument();
  });

  it("should set data-action-id on dropdown items", () => {
    const doActionMock = vi.fn();
    const buttonActions: Listing.ButtonActions = {
      delete: createMockMobileAction("Delete"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions,
        doAction: doActionMock,
        listActions: {},
        moreListActions: {},
      },
    });

    const item = container.querySelector(".dropdown-item");
    expect(item).toHaveAttribute("data-action-id", "delete");
  });

  it("should filter out non-mobile actions", () => {
    const doActionMock = vi.fn();
    const buttonActions: Listing.ButtonActions = {
      delete: createMockMobileAction("Delete"),
      publish: createMockAction("Publish"),
    };

    const { container } = render(ListActionsForMobile, {
      props: {
        buttonActions,
        doAction: doActionMock,
        listActions: {},
        moreListActions: {},
      },
    });

    const items = container.querySelectorAll(".dropdown-item");
    expect(items).toHaveLength(1);
    expect(items[0]).toHaveTextContent("Delete");
  });
});
