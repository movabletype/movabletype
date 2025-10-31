import Sidebar from "./elements/Sidebar.svelte";
import { getCollapsedState, setCollapsedState } from "./utils";

type SidebarProps = {
  collapsed: boolean;
  buttonRef: HTMLButtonElement;
};

export function svelteMountSidebar(target: Element, props: SidebarProps): void {
  const app = new Sidebar({
    target: target,
    props: {
      collapsed: props.collapsed,
      buttonRef: props.buttonRef,
      isStored: getCollapsedState() !== null,
    },
  });

  props.buttonRef.addEventListener("click", () => {
    if (props.buttonRef.classList.contains("collapsed")) {
      props.collapsed = false;
    } else {
      props.collapsed = true;
    }
    app.$set(props);
    setCollapsedState(props.collapsed);
  });
}
