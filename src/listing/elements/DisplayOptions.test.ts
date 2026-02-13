import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import DisplayOptions from "./DisplayOptions.svelte";
import { createMockListStoreContext } from "../../tests/helpers/createListingTestProps.svelte";

describe("DisplayOptions Component", () => {
  it("should render the component", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptions, {
      props: {
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
      context: new Map([["listStore", context]]),
    });

    expect(container).toBeTruthy();
  });

  it("should render Display Options button", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptions, {
      props: {
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
      context: new Map([["listStore", context]]),
    });

    const button = container.querySelector(".dropdown-toggle");
    expect(button).toBeInTheDocument();
    expect(button).toHaveTextContent("Display Options");
  });

  it("should have correct data-bs-toggle attribute", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptions, {
      props: {
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
      context: new Map([["listStore", context]]),
    });

    const button = container.querySelector(".dropdown-toggle");
    expect(button).toHaveAttribute("data-bs-toggle", "collapse");
    expect(button).toHaveAttribute("data-bs-target", "#display-options-detail");
  });

  it("should have correct aria attributes", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptions, {
      props: {
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
      context: new Map([["listStore", context]]),
    });

    const button = container.querySelector(".dropdown-toggle");
    expect(button).toHaveAttribute("aria-expanded", "false");
    expect(button).toHaveAttribute("aria-controls", "display-options-detail");
  });

  it("should render display-options-detail container", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptions, {
      props: {
        changeLimit: changeLimitMock,
        disableUserDispOption: false,
      },
      context: new Map([["listStore", context]]),
    });

    const detailContainer = container.querySelector(
      '[data-is="display-options-detail"]',
    );
    expect(detailContainer).toBeInTheDocument();
  });
});
