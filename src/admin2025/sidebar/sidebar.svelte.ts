import Sidebar from "./elements/Sidebar.svelte";
import { getCollapsedState, setCollapsedState } from "./utils";
import { mount } from "svelte";

type SidebarProps = {
  collapsed: boolean;
  buttonRef: HTMLButtonElement;
};

export function svelteMountSidebar(target: Element, props: SidebarProps): void {
  const state = $state({
    collapsed: props.collapsed,
    buttonRef: props.buttonRef,
    isStored: getCollapsedState() !== null,
  });

  mount(Sidebar, {
    target: target,
    props: state,
  });

  props.buttonRef.addEventListener("click", () => {
    if (props.buttonRef.classList.contains("collapsed")) {
      state.collapsed = false;
    } else {
      state.collapsed = true;
    }
    setCollapsedState(state.collapsed);
  });
}
