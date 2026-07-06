import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import DisplayOptionsLimitTestWrapper from "./DisplayOptionsLimitTestWrapper.svelte";
import { createDisplayOptionsLimitProps } from "../../tests/helpers/createListingTestProps.svelte";

describe("DisplayOptionsLimit Component", () => {
  it("should render the component", () => {
    const { container } = render(DisplayOptionsLimitTestWrapper, {
      props: createDisplayOptionsLimitProps(),
    });

    expect(container).toBeTruthy();
  });

  it("should render Show label", () => {
    const { container } = render(DisplayOptionsLimitTestWrapper, {
      props: createDisplayOptionsLimitProps(),
    });

    const label = container.querySelector(".field-header label");
    expect(label).toBeInTheDocument();
    expect(label).toHaveTextContent("Show");
  });

  it("should render select with correct id", () => {
    const { container } = render(DisplayOptionsLimitTestWrapper, {
      props: createDisplayOptionsLimitProps(),
    });

    const select = container.querySelector("select#row");
    expect(select).toBeInTheDocument();
  });

  it("should render all limit options", () => {
    const { container } = render(DisplayOptionsLimitTestWrapper, {
      props: createDisplayOptionsLimitProps(),
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
    const { container } = render(DisplayOptionsLimitTestWrapper, {
      props: createDisplayOptionsLimitProps({
        contextOverrides: { limit: 50 },
      }),
    });

    const select = container.querySelector("select") as HTMLSelectElement;
    expect(select.value).toBe("50");
  });

  it("should have ref attribute set to limit", () => {
    const { container } = render(DisplayOptionsLimitTestWrapper, {
      props: createDisplayOptionsLimitProps(),
    });

    const select = container.querySelector("select");
    expect(select).toHaveAttribute("ref", "limit");
  });
});
