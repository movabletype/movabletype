<script lang="ts">
  import { onMount } from "svelte";

  const sessionName = "collapsed";
  const sessionCollapsed = sessionStorage.getItem(sessionName);
  let collapsed = sessionCollapsed === "true" ? true : false;

  let collapseStart = false;

  const handleCollapse = (overwrite: boolean | null = null) => {
    const updateClassList = (addClass: boolean) => {
      const contentWrapper = document.querySelector(
        ".mt-contentWrapper"
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
    collapseStart = true;
    if (collapsed) {
      handleCollapse(false);
      setTimeout(() => {
        collapseStart = false;
      }, 1000);
    } else {
      collapseStart = false;
    }
  };

  const handleMouseLeave = () => {
    if (collapsed && !collapseStart) {
      handleCollapse(true);
    }
  };

  onMount(() => {
    if (window.innerWidth < 1000) {
      collapsed = true;
    }
    handleCollapse();

    document
      .querySelector(".mt-primaryNavigation")
      ?.addEventListener("mouseover", handleMouseEnter);
    document
      .querySelector(".mt-primaryNavigation")
      ?.addEventListener("mouseout", handleMouseLeave);
  });
</script>

<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<div
  class="mt-primaryNavigation__toggle_bar"
  on:click={handleClick}
  on:mouseover={handleMouseEnter}
  on:mouseout={handleMouseLeave}
></div>
