import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import ListActionsForPc from "./ListActionsForPc.svelte";
import type * as Listing from "../../@types/listing";

const createMockAction = (
  label: string,
  overrides: Partial<Listing.ListAction> = {},
): Listing.ListAction => ({
  type: "action",
  label,
  ...overrides,
});

describe("ListActionsForPc Component", () => {
  it("should render the component", () => {
    const doActionMock = vi.fn();

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        hasPulldownActions: false,
        moreListActions: {},
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render button actions", () => {
    const doActionMock = vi.fn();
    const buttonActions: Listing.ButtonActions = {
      delete: createMockAction("Delete"),
      publish: createMockAction("Publish"),
    };

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions,
        doAction: doActionMock,
        listActions: {},
        hasPulldownActions: false,
        moreListActions: {},
      },
    });

    const buttons = container.querySelectorAll("button.btn-default");
    expect(buttons.length).toBe(2);
    expect(buttons[0]).toHaveTextContent("Delete");
    expect(buttons[1]).toHaveTextContent("Publish");
  });

  it("should set data-action-id on button actions", () => {
    const doActionMock = vi.fn();
    const buttonActions: Listing.ButtonActions = {
      delete: createMockAction("Delete"),
    };

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions,
        doAction: doActionMock,
        listActions: {},
        hasPulldownActions: false,
        moreListActions: {},
      },
    });

    const button = container.querySelector("button.btn-default");
    expect(button).toHaveAttribute("data-action-id", "delete");
  });

  it("should render dropdown when hasPulldownActions is true", () => {
    const doActionMock = vi.fn();

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        hasPulldownActions: true,
        moreListActions: {},
      },
    });

    const dropdown = container.querySelector(".btn-group");
    expect(dropdown).toBeInTheDocument();

    const dropdownToggle = container.querySelector(".dropdown-toggle");
    expect(dropdownToggle).toBeInTheDocument();
    expect(dropdownToggle).toHaveTextContent("More actions...");
  });

  it("should not render dropdown when hasPulldownActions is false", () => {
    const doActionMock = vi.fn();

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        hasPulldownActions: false,
        moreListActions: {},
      },
    });

    const dropdown = container.querySelector(".btn-group");
    expect(dropdown).not.toBeInTheDocument();
  });

  it("should render list actions in dropdown menu", () => {
    const doActionMock = vi.fn();
    const listActions: Listing.ListActions = {
      edit: createMockAction("Edit"),
      view: createMockAction("View"),
    };

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions,
        hasPulldownActions: true,
        moreListActions: {},
      },
    });

    const dropdownItems = container.querySelectorAll(
      ".dropdown-menu .dropdown-item",
    );
    expect(dropdownItems.length).toBe(2);
    expect(dropdownItems[0]).toHaveTextContent("Edit");
    expect(dropdownItems[1]).toHaveTextContent("View");
  });

  it("should render Plugin Actions header when moreListActions exist", () => {
    const doActionMock = vi.fn();
    const moreListActions: Listing.MoreListActions = {
      customAction: createMockAction("Custom Action"),
    };

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        hasPulldownActions: true,
        moreListActions,
      },
    });

    const header = container.querySelector(".dropdown-header");
    expect(header).toBeInTheDocument();
    expect(header).toHaveTextContent("Plugin Actions");
  });

  it("should not render Plugin Actions header when moreListActions is empty", () => {
    const doActionMock = vi.fn();

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        hasPulldownActions: true,
        moreListActions: {},
      },
    });

    const header = container.querySelector(".dropdown-header");
    expect(header).not.toBeInTheDocument();
  });

  it("should render more list actions in dropdown", () => {
    const doActionMock = vi.fn();
    const moreListActions: Listing.MoreListActions = {
      plugin1: createMockAction("Plugin Action 1"),
      plugin2: createMockAction("Plugin Action 2"),
    };

    const { container } = render(ListActionsForPc, {
      props: {
        buttonActions: {},
        doAction: doActionMock,
        listActions: {},
        hasPulldownActions: true,
        moreListActions,
      },
    });

    const dropdownItems = container.querySelectorAll(
      ".dropdown-menu .dropdown-item",
    );
    expect(dropdownItems.length).toBe(2);
    expect(dropdownItems[0]).toHaveTextContent("Plugin Action 1");
    expect(dropdownItems[1]).toHaveTextContent("Plugin Action 2");
  });
});
