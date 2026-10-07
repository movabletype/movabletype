import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import DisplayOptionsColumnsTestWrapper from "./DisplayOptionsColumnsTestWrapper.svelte";
import {
  createMockListStoreContext,
  createMockColumn,
} from "../../tests/helpers/createListingTestProps.svelte";

describe("DisplayOptionsColumns Component", () => {
  it("should render the component", () => {
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    expect(container).toBeTruthy();
  });

  it("should render Column label", () => {
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const label = container.querySelector(".field-header label");
    expect(label).toBeInTheDocument();
    expect(label).toHaveTextContent("Column");
  });

  it("should show warning when disableUserDispOption is true", () => {
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: true,
      },
    });

    const alert = container.querySelector(".alert-warning");
    expect(alert).toBeInTheDocument();
    expect(alert).toHaveTextContent("User Display Option is disabled now.");
  });

  it("should not show warning when disableUserDispOption is false", () => {
    const context = createMockListStoreContext();

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const alert = container.querySelector(".alert-warning");
    expect(alert).not.toBeInTheDocument();
  });

  it("should render column checkboxes when not disabled", () => {
    const column = createMockColumn({
      id: "title",
      label: "Title",
      checked: 1,
      force_display: 0,
    });
    const context = createMockListStoreContext({
      columns: [column],
    });

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const checkbox = container.querySelector("#title");
    expect(checkbox).toBeInTheDocument();
    expect(checkbox).toHaveAttribute("type", "checkbox");
  });

  it("should render column label", () => {
    const column = createMockColumn({
      id: "title",
      label: "Title",
      checked: 1,
      force_display: 0,
    });
    const context = createMockListStoreContext({
      columns: [column],
    });

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const label = container.querySelector('label[for="title"]');
    expect(label).toBeInTheDocument();
    expect(label).toHaveTextContent("Title");
  });

  it("should mark checkbox as checked when column is checked", () => {
    const column = createMockColumn({
      id: "title",
      label: "Title",
      checked: 1,
      force_display: 0,
    });
    const context = createMockListStoreContext({
      columns: [column],
    });

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const checkbox = container.querySelector("#title") as HTMLInputElement;
    expect(checkbox.checked).toBe(true);
  });

  it("should mark checkbox as unchecked when column is not checked", () => {
    const column = createMockColumn({
      id: "title",
      label: "Title",
      checked: 0,
      force_display: 0,
    });
    const context = createMockListStoreContext({
      columns: [column],
    });

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const checkbox = container.querySelector("#title") as HTMLInputElement;
    expect(checkbox.checked).toBe(false);
  });

  it("should hide column when force_display is 1", () => {
    const column = createMockColumn({
      id: "title",
      label: "Title",
      checked: 1,
      force_display: 1,
    });
    const context = createMockListStoreContext({
      columns: [column],
    });

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const listItem = container.querySelector(".list-inline-item");
    expect(listItem).toHaveAttribute("hidden");
    expect(listItem).toHaveStyle("display: none");
  });

  it("should disable checkbox when loading", () => {
    const column = createMockColumn({
      id: "title",
      label: "Title",
      checked: 1,
      force_display: 0,
    });
    const context = createMockListStoreContext({
      columns: [column],
      isLoading: true,
    });

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const checkbox = container.querySelector("#title") as HTMLInputElement;
    expect(checkbox.disabled).toBe(true);
  });

  it("should render multiple columns", () => {
    const columns = [
      createMockColumn({
        id: "title",
        label: "Title",
        checked: 1,
        force_display: 0,
      }),
      createMockColumn({
        id: "author",
        label: "Author",
        checked: 0,
        force_display: 0,
      }),
    ];
    const context = createMockListStoreContext({
      columns,
    });

    const { container } = render(DisplayOptionsColumnsTestWrapper, {
      props: {
        context,
        disableUserDispOption: false,
      },
    });

    const checkboxes = container.querySelectorAll(
      '.form-check-input[type="checkbox"]',
    );
    expect(checkboxes).toHaveLength(2);
  });
});
