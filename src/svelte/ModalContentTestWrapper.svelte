<script lang="ts">
  import { setModalContext } from "./context";
  import ModalContent from "./ModalContent.svelte";

  let {
    close,
    hasTitle = true,
    hasBody = true,
    hasFooter = true,
    titleText = "Test Title",
    bodyText = "Test Body",
    footerText = "Test Footer",
    onCloseModal,
  }: {
    close?: () => void;
    hasTitle?: boolean;
    hasBody?: boolean;
    hasFooter?: boolean;
    titleText?: string;
    bodyText?: string;
    footerText?: string;
    onCloseModal?: () => void;
  } = $props();

  setModalContext({
    closeModal: () => onCloseModal?.(),
  });
</script>

{#if hasTitle && hasBody && hasFooter}
  <ModalContent {close}>
    {#snippet title()}
      {titleText}
    {/snippet}
    {#snippet body()}
      {bodyText}
    {/snippet}
    {#snippet footer()}
      {footerText}
    {/snippet}
  </ModalContent>
{:else if hasTitle && hasBody}
  <ModalContent {close}>
    {#snippet title()}
      {titleText}
    {/snippet}
    {#snippet body()}
      {bodyText}
    {/snippet}
  </ModalContent>
{:else if hasBody && hasFooter}
  <ModalContent {close}>
    {#snippet body()}
      {bodyText}
    {/snippet}
    {#snippet footer()}
      {footerText}
    {/snippet}
  </ModalContent>
{:else if hasBody}
  <ModalContent {close}>
    {#snippet body()}
      {bodyText}
    {/snippet}
  </ModalContent>
{:else}
  <ModalContent {close} />
{/if}
