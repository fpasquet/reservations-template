import type { NextConfig } from 'next';

// Adresse de l'API, appelée directement par le navigateur : fixée au build.
const config: NextConfig = {
  env: { NEXT_PUBLIC_API_URL: process.env['API_URL'] ?? 'http://localhost:4030' },
  poweredByHeader: false,
};

export default config;
