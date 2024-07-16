interface Window {
  CMSScriptURI: string;
  ScriptURI: string;
  StaticURI: string;
  setDirty: (isDirty?: boolean) => void;
  trans: (str: string, ...args: string[]) => string;
}
