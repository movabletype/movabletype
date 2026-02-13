import Sidebar from "./elements/Sidebar.svelte";
import { getCollapsedState, setCollapsedState } from "./utils";
import { mount } from "svelte";

type SidebarProps = {
  collapsed: boolean;
  buttonRef: HTMLButtonElement;
};

export function svelteMountSidebar(target: Element, props: SidebarProps): void {
  const app = mount(Sidebar, {
    target: target,
    props: {
      collapsed: props.collapsed,
      buttonRef: props.buttonRef,
      isStored: getCollapsedState() !== null,
    },
  });

  props.buttonRef.addEventListener("click", () => {
    if (props.buttonRef.classList.contains("collapsed")) {
      app.collapsed = false;
    } else {
      app.collapsed = true;
    }
    setCollapsedState(app.collapsed);
  });
}
