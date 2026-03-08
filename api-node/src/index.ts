import Fastify from 'fastify';
import { z } from 'zod';

const server = Fastify({ logger: true });

// Schéma de validation pour l'agent Rust
const MetricSchema = z.object({
  node_name: z.string(),
  cpu_usage: z.number(),
  ram_usage: z.number(),
});

server.post('/ingest', async (request, reply) => {
  const data = MetricSchema.parse(request.body);
  console.log(`[LOG] Rapport reçu de ${data.node_name}: CPU ${data.cpu_usage}%`);
  return { status: 'success', received: data.node_name };
});

server.listen({ port: 3000, host: '0.0.0.0' }, (err) => {
  if (err) throw err;
  console.log('🚀 Tour de contrôle Aether prête sur le port 3000');
});
