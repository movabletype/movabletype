import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import Url from "./Url.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "url",
  typeLabel: "URL",
  options: {
    initial_value: "",
  },
};

describe("Url Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Url, { props });

    expect(container).toBeTruthy();
  });

  it("should render initial_value input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Url, { props });

    const input = container.querySelector('input[name="initial_value"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "text");
  });

  it("should display existing initial_value", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        initial_value: "https://example.com",
      },
    });

    const { container } = render(Url, { props });

    const input = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;
    expect(input.value).toBe("https://example.com");
  });

  it("should set default initial_value when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(Url, { props });
    await tick();

    const input = container.querySelector(
      'input[name="initial_value"]',
    ) as HTMLInputElement;
    expect(input.value).toBe("");
  });

  it("should render Initial Value label", () => {
    const props = createTestProps(presetProps);
    const { container } = render(Url, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(labelTexts).toContain("Initial Value");
  });
});
