import { render } from "@testing-library/svelte";
import { describe, it, expect } from "vitest";
import StatusMsg from "./StatusMsg.svelte";

describe("StatusMsg Component", () => {
  it("should render the component", () => {
    const { container } = render(StatusMsg, {
      props: {},
    });

    expect(container).toBeTruthy();
    const alert = container.querySelector(".alert");
    expect(alert).toBeInTheDocument();
  });

  it("should render with info class by default", () => {
    const { container } = render(StatusMsg, {
      props: {},
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveClass("alert-info");
  });

  it("should render with warning class", () => {
    const { container } = render(StatusMsg, {
      props: {
        class: "warning",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveClass("alert-warning");
  });

  it("should convert alert to warning class", () => {
    const { container } = render(StatusMsg, {
      props: {
        class: "alert",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveClass("alert-warning");
  });

  it("should convert error to danger class", () => {
    const { container } = render(StatusMsg, {
      props: {
        class: "error",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveClass("alert-danger");
  });

  it("should render with id when provided", () => {
    const { container } = render(StatusMsg, {
      props: {
        id: "test-status-msg",
      },
    });

    const alert = container.querySelector("#test-status-msg");
    expect(alert).toBeInTheDocument();
  });

  it("should render close button when canClose is 1", () => {
    const { container } = render(StatusMsg, {
      props: {
        id: "test-status-msg",
        canClose: 1,
      },
    });

    const closeButton = container.querySelector(".btn-close");
    expect(closeButton).toBeInTheDocument();
  });

  it("should not render close button when canClose is 0", () => {
    const { container } = render(StatusMsg, {
      props: {
        canClose: 0,
      },
    });

    const closeButton = container.querySelector(".btn-close");
    expect(closeButton).not.toBeInTheDocument();
  });

  it("should hide element when hidden prop is set", () => {
    const { container } = render(StatusMsg, {
      props: {
        hidden: "true",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveStyle("display: none");
  });

  it("should set role=alert for warning class", () => {
    const { container } = render(StatusMsg, {
      props: {
        class: "warning",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveAttribute("role", "alert");
  });

  it("should set role=alert for danger class", () => {
    const { container } = render(StatusMsg, {
      props: {
        class: "danger",
      },
    });

    const alert = container.querySelector(".alert");
    expect(alert).toHaveAttribute("role", "alert");
  });

  it("should set canClose to 1 when id is provided and canClose is null", () => {
    const { container } = render(StatusMsg, {
      props: {
        id: "test-status-msg",
        canClose: null as unknown as number,
      },
    });

    const closeButton = container.querySelector(".btn-close");
    expect(closeButton).toBeInTheDocument();
  });

  it("should not set canClose to 1 when id is empty and canClose is null", () => {
    const { container } = render(StatusMsg, {
      props: {
        id: "",
        canClose: null as unknown as number,
      },
    });

    const closeButton = container.querySelector(".btn-close");
    expect(closeButton).not.toBeInTheDocument();
  });

  it("should not set canClose to 1 when id is provided and canClose is undefined", () => {
    const { container } = render(StatusMsg, {
      props: {
        id: "test-status-msg",
      },
    });

    const closeButton = container.querySelector(".btn-close");
    expect(closeButton).not.toBeInTheDocument();
  });

  it("should keep canClose as 1 when id is provided and canClose is truthy", () => {
    const { container } = render(StatusMsg, {
      props: {
        id: "test-status-msg",
        canClose: 1,
      },
    });

    const closeButton = container.querySelector(".btn-close");
    expect(closeButton).toBeInTheDocument();
  });
});
