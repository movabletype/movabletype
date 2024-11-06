import type { TinyMCE } from "tinymce6";

declare global {
  interface Window {
    CMSScriptURI: string;
    ScriptURI: string;
    StaticURI: string;
    setDirty: (isDirty?: boolean) => void;
    trans: (str: string, ...args: string[]) => string;
    tinymce: TinyMCE;
  }

  const tinymce: TinyMCE;
}
