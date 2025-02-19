import Sidebar from "./elements/Sidebar.svelte";

type SidebarProps = {
  collapsed: boolean;
  buttonRef: HTMLButtonElement;
  sessionName: string;
};

export function svelteMountSidebar(target: Element, props: SidebarProps): void {
  const app = new Sidebar({
    target: target,
    props: {
      collapsed: props.collapsed,
      buttonRef: props.buttonRef,
    },
  });

  props.buttonRef.addEventListener("click", () => {
    props.collapsed = !props.collapsed;
    app.$set(props);
    sessionStorage.setItem(props.sessionName, props.collapsed.toString());
  });
}
