import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import StatusMsgTmpl from "./StatusMsgTmpl.svelte";

describe("StatusMsgTmpl Component", () => {
  it("should render the component", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "info",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    expect(container).toBeTruthy();
    const alert = container.querySelector(".alert");
    expect(alert).toBeInTheDocument();
  });

  it("should render with alert-info class", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "info",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveClass("alert-info");
  });

  it("should render with alert-warning class", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "warning",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveClass("alert-warning");
  });

  it("should render with alert-danger class", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "danger",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveClass("alert-danger");
  });

  it("should render with id when provided", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "info",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "test-msg",
        noLink: "",
        rebuild: "",
      },
    });

    const alert = container.querySelector("#test-msg");
    expect(alert).toBeInTheDocument();
  });

  it("should render close button when canClose is set", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canClose: 1,
        canRebuild: 0,
        class: "info",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    const closeButton = container.querySelector(".btn-close");
    expect(closeButton).toBeInTheDocument();
    expect(closeButton).toHaveAttribute("data-bs-dismiss", "alert");
  });

  it("should not render close button when canClose is undefined", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "info",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    const closeButton = container.querySelector(".btn-close");
    expect(closeButton).not.toBeInTheDocument();
  });

  it("should hide when hidden prop is set", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "info",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "true",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveStyle("display: none");
  });

  it("should set role=alert for warning class", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "warning",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveAttribute("role", "alert");
  });

  it("should set role=alert for danger class", () => {
    const { container } = render(StatusMsgTmpl, {
      props: {
        canRebuild: 0,
        class: "danger",
        didReplace: 0,
        dynamicAll: 0,
        hidden: "",
        id: "",
        noLink: "",
        rebuild: "",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveAttribute("role", "alert");
  });
});
