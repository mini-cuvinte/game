import { mkdir, copyFile, writeFile, access } from 'node:fs/promises';
import { join } from 'node:path';

const output = 'dist';
await mkdir(output, { recursive: true });
for (const file of ['index.html', 'manifest.webmanifest', 'sw.js', 'icon.svg']) { try { await access(file); await copyFile(file, join(output, file)); } catch (error) { if (error.code !== 'ENOENT') throw error; } }
const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_PUBLISHABLE_KEY;
if (!url || !key) throw new Error('Set SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY');
if (!/^https:\/\//.test(url) && !/^http:\/\/(localhost|127\\.0\\.0\\.1)(:|\/)/.test(url)) throw new Error('SUPABASE_URL must use HTTPS or localhost');
if (key.startsWith('sb_secret_') || key.startsWith('eyJ') && process.env.ALLOW_LEGACY_ANON_KEY !== 'true') throw new Error('Use a publishable key; never use service role keys');
await writeFile(join(output,'config.js'), 'window.MINI_CUVINTE_CONFIG = '+JSON.stringify({supabaseUrl:url,supabasePublishableKey:key})+';\n');
console.log('Static build generated in dist/');
