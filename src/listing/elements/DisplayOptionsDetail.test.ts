import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import DisplayOptionsDetailTestWrapper from "./DisplayOptionsDetailTestWrapper.svelte";
import { createMockListStoreContext } from "../../tests/helpers/createListingTestProps.svelte";

describe("DisplayOptionsDetail Component", () => {
  it("should render the component", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsDetailTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render the collapse container", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsDetailTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
    });

    const collapseContainer = container.querySelector(
      "#display-options-detail",
    );
    expect(collapseContainer).toBeInTheDocument();
    expect(collapseContainer).toHaveClass("collapse");
  });

  it("should render display-options-limit container", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsDetailTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
    });

    const limitContainer = container.querySelector(
      '[data-is="display-options-limit"]',
    );
    expect(limitContainer).toBeInTheDocument();
    expect(limitContainer).toHaveAttribute("id", "per_page-field");
  });

  it("should render display-options-columns container", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsDetailTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
    });

    const columnsContainer = container.querySelector(
      '[data-is="display-options-columns"]',
    );
    expect(columnsContainer).toBeInTheDocument();
    expect(columnsContainer).toHaveAttribute("id", "display_columns-field");
  });

  it("should render Reset defaults link when disableUserDispOption is false", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsDetailTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
    });

    const resetLink = container.querySelector("#reset-display-options");
    expect(resetLink).toBeInTheDocument();
    expect(resetLink).toHaveTextContent("Reset defaults");
  });

  it("should not render Reset defaults link when disableUserDispOption is true", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsDetailTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
        disableUserDispOption: true,
      },
    });

    const resetLink = container.querySelector("#reset-display-options");
    expect(resetLink).not.toBeInTheDocument();
  });

  it("should have actions-bar container when disableUserDispOption is false", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsDetailTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
    });

    const actionsBar = container.querySelector(".actions-bar-bottom");
    expect(actionsBar).toBeInTheDocument();
  });

  it("should not have actions-bar container when disableUserDispOption is true", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsDetailTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
        disableUserDispOption: true,
      },
    });

    const actionsBar = container.querySelector(".actions-bar-bottom");
    expect(actionsBar).not.toBeInTheDocument();
  });
});
