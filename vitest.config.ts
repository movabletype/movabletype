import { defineConfig } from "vitest/config";
import { createHttpServer } from "./src/tests/helpers/server";
import type { AddressInfo } from "net";

export default defineConfig(async () => {
  const server = await createHttpServer();
  const port = (server.address() as AddressInfo).port;
  process.env.JSDOM_SERVER_PORT = port.toString();

  return {
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
      setupFiles: ["./src/tests/helpers/window.ts"],
      globalSetup: ["./src/tests/helpers/server.ts"],
    },
  };
});
