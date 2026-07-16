import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import { dirname, resolve } from "path";

const repoRoot = resolve(dirname(fileURLToPath(import.meta.url)), "../../..");

export const loadLegacyScript = (
  mtStaticRelativePath: string,
  jQuery: unknown,
  MT: unknown,
): void => {
  const filePath = resolve(repoRoot, "mt-static", mtStaticRelativePath);
  const code = readFileSync(filePath, "utf-8");
  new Function("jQuery", "MT", code)(jQuery, MT);
};
