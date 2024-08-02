import { createServer } from "http";
import type { Server } from "http";

const closeServerPath = "/quit-helper-http-server";

export async function createHttpServer(): Promise<Server> {
  return new Promise<Server>((resolve) => {
    const server = createServer((req, res) => {
      if (req.url === closeServerPath) {
        res.writeHead(200, { "Content-Type": "text/plain" });
        res.end("Server closed");
        server.close();
        return;
      }

      res.writeHead(404, { "Content-Type": "text/plain" });
      res.end("");
    }).listen(0, "0.0.0.0", () => {
      resolve(server);
    });
  });
}

export function teardown(): void {
  fetch(`http://localhost:${process.env.JSDOM_SERVER_PORT}${closeServerPath}`);
}
