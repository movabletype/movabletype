import jQuery from "@types/jquery";

declare global {
  interface Window {
    jQuery: typeof jQuery;
  }

  interface JQuery {
    modal(action: string): void;
    mtModal: {
      open(
        uri: string,
        opts: {
          loadingimage?: string;
          esckeyclose?: boolean;
          large?: boolean;
        },
      ): void;
      close(): void;
    };
  }
}
