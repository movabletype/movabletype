import { render } from "@testing-library/svelte";
import { describe, it, expect, vi } from "vitest";
import DisplayOptionsForMobileTestWrapper from "./DisplayOptionsForMobileTestWrapper.svelte";
import { createMockListStoreContext } from "../../tests/helpers/createListingTestProps.svelte";

describe("DisplayOptionsForMobile Component", () => {
  it("should render the component", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext({ limit: 25 });

    const { container } = render(DisplayOptionsForMobileTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render Show label", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext({ limit: 25 });

    const { container } = render(DisplayOptionsForMobileTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
      },
    });

    const label = container.querySelector("label");
    expect(label).toBeInTheDocument();
    expect(label).toHaveTextContent("Show:");
  });

  it("should have d-md-none class for mobile-only display", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext({ limit: 25 });

    const { container } = render(DisplayOptionsForMobileTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
      },
    });

    const row = container.querySelector(".d-md-none");
    expect(row).toBeInTheDocument();
  });

  it("should render select with correct id", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext({ limit: 25 });

    const { container } = render(DisplayOptionsForMobileTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
      },
    });

    const select = container.querySelector("select#row-for-mobile");
    expect(select).toBeInTheDocument();
  });

  it("should render all limit options", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext({ limit: 25 });

    const { container } = render(DisplayOptionsForMobileTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
      },
    });

    const options = container.querySelectorAll("select option");
    expect(options).toHaveLength(5);
    expect(options[0]).toHaveValue("10");
    expect(options[1]).toHaveValue("25");
    expect(options[2]).toHaveValue("50");
    expect(options[3]).toHaveValue("100");
    expect(options[4]).toHaveValue("200");
  });

  it("should have correct selected value based on store limit", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext({ limit: 100 });

    const { container } = render(DisplayOptionsForMobileTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
      },
    });

    const select = container.querySelector("select") as HTMLSelectElement;
    expect(select.value).toBe("100");
  });

  it("should have ref attribute set to limit", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext({ limit: 25 });

    const { container } = render(DisplayOptionsForMobileTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
      },
    });

    const select = container.querySelector("select");
    expect(select).toHaveAttribute("ref", "limit");
  });

  it("should have form-inline class", () => {
    const changeLimitMock = vi.fn();
    const context = createMockListStoreContext({ limit: 25 });

    const { container } = render(DisplayOptionsForMobileTestWrapper, {
      props: {
        context,
        changeLimit: changeLimitMock,
      },
    });

    const formInline = container.querySelector(".form-inline");
    expect(formInline).toBeInTheDocument();
  });
});
