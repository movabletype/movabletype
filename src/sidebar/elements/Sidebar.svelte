<script lang="ts">
  import { onMount } from "svelte";
  import { portal } from "svelte-portal";

  export let buttonRef: HTMLButtonElement;
  export let collapsed = false;
  export let isStored = false;
  let mouseOver = false;
  let isMobile = false;

  const addContentWrapperClass = (
    className: string,
    addClass: boolean,
  ): void => {
    const contentWrapper = document.querySelector(
      '[data-is="content-wrapper"]',
    ) as HTMLElement;
    if (addClass) {
      contentWrapper.classList.add(className);
    } else {
      contentWrapper.classList.remove(className);
    }
  };

  const handleCollapse = (): void => {
    addContentWrapperClass("collapsed", collapsed);
  };

  const handleMouseEnterLeave = (): void => {
    addContentWrapperClass("mouseover", mouseOver);
  };

  $: {
    handleCollapse();
    mouseOver = false;
    handleMouseEnterLeave();

    if (buttonRef) {
      if (collapsed) {
        buttonRef.classList.remove("expanded");
        buttonRef.classList.add("collapsed");
      } else {
        buttonRef.classList.remove("collapsed");
        buttonRef.classList.add("expanded");
      }
    }
  }

  const handleMouseEnter = (): void => {
    if (collapsed) {
      mouseOver = true;
      handleMouseEnterLeave();
      document
        .querySelector('[data-is="primary-navigation"]')
        ?.addEventListener("mouseleave", handleMouseLeave, { once: true });
    }
  };

  const handleMouseLeave = (): void => {
    mouseOver = false;
    handleMouseEnterLeave();
  };

  onMount(() => {
    if (!isStored) {
      if (window.innerWidth < 1000) {
        collapsed = true;
      }
    }
    if(window.innerWidth < 800){
      // For smaller screens, always collapse the sidebar
      collapsed = true;
      isMobile = true;
    }
    handleCollapse();
  });
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<div
  class="mt-primaryNavigation-overlay"
  use:portal={"body"}
  on:mouseenter={handleMouseEnter}
  style={`display: ${collapsed ? "block" : "none"}`}
></div>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="mt-primaryNavigation-overlay-sp"
  use:portal={"body"}
  on:click={() => {
    collapsed = true;
    handleCollapse();
  }}
  style={`display: ${collapsed ? "none" : "block"}`}
></div>