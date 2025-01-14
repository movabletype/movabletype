import Sidebar from "./elements/Sidebar.svelte";

export function svelteMountSidebar(target: Element): void {
    new Sidebar({
        target: target,
    });
}
