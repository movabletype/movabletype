import { render } from "@testing-library/svelte";
import { userEvent } from "@testing-library/user-event";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import AssetImage from "./AssetImage.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "asset-image",
  typeLabel: "Asset Image",
  options: {
    multiple: false,
    allow_upload: false,
    min: "",
    max: "",
    preview_width: 80,
    preview_height: 80,
  },
};

describe("AssetImage Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetImage, { props });

    expect(container).toBeTruthy();
  });

  it("should render multiple checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetImage, { props });

    const checkbox = container.querySelector('input[name="multiple"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render allow_upload checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetImage, { props });

    const checkbox = container.querySelector('input[name="allow_upload"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render min and max inputs", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetImage, { props });

    const minInput = container.querySelector('input[name="min"]');
    const maxInput = container.querySelector('input[name="max"]');

    expect(minInput).toBeInTheDocument();
    expect(maxInput).toBeInTheDocument();
  });

  it("should render preview_width input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetImage, { props });

    const input = container.querySelector('input[name="preview_width"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "number");
  });

  it("should render preview_height input", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetImage, { props });

    const input = container.querySelector('input[name="preview_height"]');
    expect(input).toBeInTheDocument();
    expect(input).toHaveAttribute("type", "number");
  });

  it("should display existing thumbnail dimensions", () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        ...presetProps.options,
        preview_width: 120,
        preview_height: 100,
      },
    });

    const { container } = render(AssetImage, { props });

    const widthInput = container.querySelector(
      'input[name="preview_width"]',
    ) as HTMLInputElement;
    const heightInput = container.querySelector(
      'input[name="preview_height"]',
    ) as HTMLInputElement;

    expect(widthInput.value).toBe("120");
    expect(heightInput.value).toBe("100");
  });

  it("should set default values when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(AssetImage, { props });
    await tick();

    const minInput = container.querySelector(
      'input[name="min"]',
    ) as HTMLInputElement;
    const maxInput = container.querySelector(
      'input[name="max"]',
    ) as HTMLInputElement;
    const previewWidthInput = container.querySelector(
      'input[name="preview_width"]',
    ) as HTMLInputElement;
    const previewHeightInput = container.querySelector(
      'input[name="preview_height"]',
    ) as HTMLInputElement;

    expect(minInput.value).toBe("");
    expect(maxInput.value).toBe("");
    expect(previewWidthInput.value).toBe("80");
    expect(previewHeightInput.value).toBe("80");
  });

  it("should render labels for image asset options", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetImage, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(
      labelTexts.some((text) => text?.includes("select multiple image assets")),
    ).toBe(true);
    expect(labelTexts).toContain("Thumbnail width");
    expect(labelTexts).toContain("Thumbnail height");
  });

  it("should show min/max fields when multiple checkbox is checked", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        multiple: false,
        allow_upload: false,
        min: "",
        max: "",
        preview_width: 80,
        preview_height: 80,
      },
    });
    const { container } = render(AssetImage, { props });

    const minField = container.querySelector("#asset_image-min-field");
    const maxField = container.querySelector("#asset_image-max-field");

    expect(minField).toHaveAttribute("hidden");
    expect(maxField).toHaveAttribute("hidden");

    const checkbox = container.querySelector(
      'input[name="multiple"]',
    ) as HTMLInputElement;
    const user = userEvent.setup();
    await user.click(checkbox);
    await tick();

    expect(minField).not.toHaveAttribute("hidden");
    expect(maxField).not.toHaveAttribute("hidden");
  });
});
