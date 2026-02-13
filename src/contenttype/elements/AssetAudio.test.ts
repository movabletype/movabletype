import { render } from "@testing-library/svelte";
import { userEvent } from "@testing-library/user-event";
import { describe, it, expect } from "vitest";
import { tick } from "svelte";
import AssetAudio from "./AssetAudio.svelte";
import { createTestProps } from "../../tests/helpers/createTestProps.svelte";

const presetProps = {
  type: "asset-audio",
  typeLabel: "Asset Audio",
  options: {
    multiple: false,
    allow_upload: false,
    min: "",
    max: "",
  },
};

describe("AssetAudio Component", () => {
  it("should render the component", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetAudio, { props });

    expect(container).toBeTruthy();
  });

  it("should render multiple checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetAudio, { props });

    const checkbox = container.querySelector('input[name="multiple"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render allow_upload checkbox", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetAudio, { props });

    const checkbox = container.querySelector('input[name="allow_upload"]');
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render min and max inputs", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetAudio, { props });

    const minInput = container.querySelector('input[name="min"]');
    const maxInput = container.querySelector('input[name="max"]');

    expect(minInput).toBeInTheDocument();
    expect(maxInput).toBeInTheDocument();
  });

  it("should set default values when undefined", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {},
    });

    const { container } = render(AssetAudio, { props });
    await tick();

    const minInput = container.querySelector(
      'input[name="min"]',
    ) as HTMLInputElement;
    const maxInput = container.querySelector(
      'input[name="max"]',
    ) as HTMLInputElement;

    expect(minInput.value).toBe("");
    expect(maxInput.value).toBe("");
  });

  it("should render labels for audio asset options", () => {
    const props = createTestProps(presetProps);
    const { container } = render(AssetAudio, { props });

    const labels = container.querySelectorAll("label");
    const labelTexts = Array.from(labels).map((l) => l.textContent?.trim());

    expect(
      labelTexts.some((text) => text?.includes("select multiple assets")),
    ).toBe(true);
    expect(
      labelTexts.some((text) => text?.includes("upload a new audio asset")),
    ).toBe(true);
  });

  it("should show min/max fields when multiple checkbox is checked", async () => {
    const props = createTestProps({
      ...presetProps,
      options: {
        multiple: false,
        allow_upload: false,
        min: "",
        max: "",
      },
    });
    const { container } = render(AssetAudio, { props });

    const minField = container.querySelector("#asset_audio-min-field");
    const maxField = container.querySelector("#asset_audio-max-field");

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
