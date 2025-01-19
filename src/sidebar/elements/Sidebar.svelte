<script lang="ts">
  import { onMount } from "svelte";
  import { portal } from "svelte-portal";

  const sessionName = "collapsed";
  const sessionCollapsed = sessionStorage.getItem(sessionName);
  let collapsed = sessionCollapsed === "true" ? true : false;

  const handleCollapse = (overwrite: boolean | null = null) => {
    const updateClassList = (addClass: boolean) => {
      const contentWrapper = document.querySelector(
        '[data-is="content-wrapper"]'
      ) as HTMLElement;
      if (addClass) {
        contentWrapper.classList.add("collapsed");
      } else {
        contentWrapper.classList.remove("collapsed");
      }
    };
    if (overwrite !== null) {
      updateClassList(overwrite);
    } else {
      updateClassList(collapsed);
    }
  };

  const handleClick = () => {
    collapsed = !collapsed;
    sessionStorage.setItem(sessionName, collapsed.toString());
    handleCollapse(collapsed);
  };

  const handleMouseEnter = () => {
    if (collapsed) {
      handleCollapse(false);
      document
        .querySelector('[data-is="primary-navigation"]')
        ?.addEventListener("mouseleave", handleMouseLeave, { once: true });
    }
  };

  const handleMouseLeave = () => {
    if (collapsed) {
      handleCollapse(true);
    }
  };

  onMount(() => {
    if (window.innerWidth < 1000) {
      collapsed = true;
    }
    handleCollapse();
  });
</script>

<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<div
  class="mt-primaryNavigation__toggle_bar"
  class:open={!collapsed}
  class:close={collapsed}
  on:click={handleClick}
  title={collapsed ? window.trans("Collapse") : window.trans("Close")}
></div>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<div
  class="mt-primaryNavigation-overlay"
  use:portal={"body"}
  on:mouseenter={handleMouseEnter}
  style={`display: ${collapsed ? "block" : "none"}`}
></div>
