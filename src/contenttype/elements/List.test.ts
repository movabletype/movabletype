import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import List from "./List.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "list",
  typeLabel: "List",
  options: {},
};

describe("List Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(List, { props });

    expect(container).toBeTruthy();
  });

  it("should render ContentFieldOptionGroup", () => {
    const props = createTestProps(presetProps);
    const { container } = render(List, { props });

    const labelInput = container.querySelector('input[name="label"]');
    expect(labelInput).toBeInTheDocument();
  });

  it("should render hidden id input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(List, { props });

    const idInput = container.querySelector('input[name="id"]');
    expect(idInput).toBeInTheDocument();
    expect(idInput).toHaveAttribute("type", "hidden");
  });
});
