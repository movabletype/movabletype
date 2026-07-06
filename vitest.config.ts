import { defineConfig, type ViteUserConfig } from "vitest/config";
import { createHttpServer } from "./src/tests/helpers/server";
import type { AddressInfo } from "net";
import { fileURLToPath } from "url";
import { resolve } from "path";

export default defineConfig(async (): Promise<ViteUserConfig> => {
  const server = await createHttpServer();
  const port = (server.address() as AddressInfo).port;
  process.env.JSDOM_SERVER_PORT = port.toString();

  const { svelte } = await import("@sveltejs/vite-plugin-svelte");
  const __dirname = fileURLToPath(new URL(".", import.meta.url));

  return {
    plugins: [
      svelte({
        hot: false,
      }),
    ],
    resolve: {
      conditions: ["browser"],
      alias: {
        src: resolve(__dirname, "src"),
      },
    },
    test: {
      watch: false,
      include: ["src/**/*.{test,spec}.{js,ts}"],
      globals: true,
      environment: "jsdom",
      environmentOptions: {
        jsdom: {
          url: `http://localhost:${port}`,
          resources: "usable",
        },
      },
      setupFiles: ["./src/tests/setup.ts"],
      globalSetup: ["./src/tests/helpers/server.ts"],
    },
  };
});
