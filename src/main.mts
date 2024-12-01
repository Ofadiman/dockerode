import { randomUUID } from "crypto";
import Fastify from "fastify";

const fastify = Fastify({
  genReqId: () => randomUUID(),
  logger: true,
});

fastify.get("/health", async function health() {
  return { status: "ok" };
});

await fastify.listen({ port: 3000 });
