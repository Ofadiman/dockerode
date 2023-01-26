import esbuild from 'esbuild';

esbuild.buildSync({
  external: [
    'cache-manager',
    '@nestjs/microservices',
    '@nestjs/websockets',
    'class-transformer',
    'class-validator',
  ],
  platform: 'node',
  bundle: true,
  minify: false,
  format: 'cjs',
  entryPoints: ['./src/main.ts'],
  outfile: './dist/main.js',
});
