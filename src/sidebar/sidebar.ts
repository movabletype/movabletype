import Sidebar from "./elements/Sidebar.svelte";

type SidebarProps = {
  collapsed: boolean;
  buttonRef: HTMLButtonElement;
  sessionName: string;
  isStored: boolean;
};

export function svelteMountSidebar(target: Element, props: SidebarProps): void {
  const app = new Sidebar({
    target: target,
    props: {
      collapsed: props.collapsed,
      buttonRef: props.buttonRef,
      isStored: props.isStored,
    },
  });

  props.buttonRef.addEventListener("click", () => {
    if (props.buttonRef.classList.contains("collapsed")) {
      props.collapsed = false;
    } else {
      props.collapsed = true;
    }
    app.$set(props);
    sessionStorage.setItem(props.sessionName, props.collapsed.toString());
  });
}
