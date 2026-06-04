#!/usr/bin/env node
/**
 * Apple Developer Documentation Fetcher (Concurrent)
 * Fetches official .md files with parallel requests.
 *
 * Usage: node fetch_docs.js [concurrency=10]
 * Output: docs/apple-music-api/*.md, docs/musickit/*.md
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const BASE_MD = 'https://docs.developer.apple.com/tutorials/data/documentation';
const OUTPUT_DIR = path.join(__dirname, '..', 'docs');
const CONCURRENCY = Math.min(parseInt(process.argv[2]) || 16, 32);

const TARGETS = [
  { name: 'apple-music-api', path: 'applemusicapi', title: 'Apple Music API' },
  { name: 'musickit', path: 'MusicKit', title: 'MusicKit' },
];

// ---------------------------------------------------------------------------
// Concurrent fetch with retry
// ---------------------------------------------------------------------------
async function fetchMD(url, retries = 2) {
  for (let i = 0; i < retries; i++) {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 15000);
      const res = await fetch(url, {
        signal: controller.signal,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
          'Accept': 'text/markdown, text/plain, */*',
        },
      });
      clearTimeout(timeout);
      if (res.ok) return { ok: true, text: await res.text() };
      if (res.status === 404) return { ok: false, text: null };
      if (i < retries - 1) await new Promise(r => setTimeout(r, 500 * (i + 1)));
    } catch (e) {
      if (i < retries - 1) await new Promise(r => setTimeout(r, 500 * (i + 1)));
    }
  }
  return { ok: false, text: null };
}

// ---------------------------------------------------------------------------
// Extract documentation links
// ---------------------------------------------------------------------------
function extractDocLinks(markdown, basePath) {
  if (!markdown) return [];
  const links = new Set();
  const pattern = new RegExp(`\\]\\(/documentation/${basePath}(/[^)\\s#]*)?\\)`, 'gi');
  for (const m of markdown.matchAll(pattern)) {
    const linkPath = m[0].match(/\(\/documentation\/([^)\s#]*)/)[1];
    links.add(linkPath);
  }
  return [...links];
}

// ---------------------------------------------------------------------------
// Concurrent crawl: discover + fetch all pages using worker pool
// ---------------------------------------------------------------------------
async function discoverAndFetch(basePath) {
  const visited = new Set();
  const results = [];
  const queue = [basePath];
  let active = 0;
  let done = 0;

  return new Promise((resolve) => {
    const tick = () => {
      // Start new workers while under concurrency limit and queue has items
      while (active < CONCURRENCY && queue.length > 0) {
        const current = queue.shift();
        if (visited.has(current)) continue;
        visited.add(current);
        active++;

        const url = `${BASE_MD}/${current}.md`;
        fetchMD(url).then(({ ok, text }) => {
          if (ok && text) {
            results.push({ docPath: current, content: text });
            const links = extractDocLinks(text, basePath);
            for (const link of links) {
              if (!visited.has(link)) queue.push(link);
            }
          }
          active--;
          done++;
          if (done % 50 === 0) process.stderr.write(`\r  📄 ${done} pages (${queue.length} queued)...`);
          tick(); // Try to spawn more workers
        });
      }

      // Check if done
      if (active === 0 && queue.length === 0) {
        process.stderr.write(`\r  ✅ ${results.length} pages discovered\n`);
        resolve(results);
      }
    };

    tick();
  });
}

// ---------------------------------------------------------------------------
// Save page
// ---------------------------------------------------------------------------
function savePage(targetDir, docPath, content) {
  const relativePath = docPath.toLowerCase();
  const filePath = path.join(targetDir, relativePath + '.md');
  fs.mkdirSync(path.dirname(filePath), { recursive: true });

  let md = content;
  if (md.startsWith('<!--')) {
    const endIdx = md.indexOf('-->');
    if (endIdx !== -1) md = md.slice(endIdx + 3).trim();
  }

  // doc:// links -> relative
  md = md.replace(/<doc:\/\/com\.apple\.documentation\/documentation\/([^>]+)>/g,
    (_, p) => `[\`${p.split('/').pop()}\`](../${p.toLowerCase()}.md)`);

  // /documentation/ links -> relative .md
  md = md.replace(/\]\(\/documentation\/([^)\s#]+)([^)]*)\)/g, (_, p, suffix) => {
    return `](../${p.toLowerCase()}.md${suffix})`;
  });

  // Remove copyright footer
  md = md.replace(/\n---\n\nCopyright.*$/s, '');

  const title = md.match(/^# (.+)$/m)?.[1] || docPath.split('/').pop();
  const frontmatter = [
    '---',
    `title: ${JSON.stringify(title)}`,
    `source: https://developer.apple.com/documentation/${docPath}`,
    `date: ${new Date().toISOString().split('T')[0]}`,
    '---',
    '',
  ].join('\n');

  fs.writeFileSync(filePath, frontmatter + md.trim() + '\n', 'utf-8');
  return filePath;
}

// ---------------------------------------------------------------------------
// Generate README
// ---------------------------------------------------------------------------
function generateReadme(targetDir, target, pages) {
  const indexPage = pages.find(p => p.docPath.toLowerCase() === target.path.toLowerCase());
  const indexMd = indexPage?.content || '';

  const lines = [
    `# ${target.title} Documentation`,
    '',
    `> Official markdown — source: [developer.apple.com](https://developer.apple.com/documentation/${target.path})`,
    `> Fetched: ${new Date().toISOString().split('T')[0]}`,
    '',
    `**${pages.length} pages**`,
    '',
    '## Table of Contents',
    '',
  ];

  const sections = indexMd.split(/^### /gm).slice(1);
  const indexedPaths = new Set();

  for (const section of sections) {
    const sectionTitle = section.split('\n')[0].trim();
    const links = [...section.matchAll(/\[([^\]]+)\]\(\/documentation\/([^)\s]+)\)/g)];
    if (links.length === 0) continue;

    lines.push(`### ${sectionTitle}`);
    lines.push('');

    for (const [, text, urlPath] of links) {
      const localFile = urlPath.toLowerCase() + '.md';
      const exists = pages.some(p => p.docPath.toLowerCase() === urlPath.toLowerCase());
      indexedPaths.add(urlPath.toLowerCase());
      lines.push(`- ${exists ? '📄' : '🔗'} [${text}](${localFile})`);
    }
    lines.push('');
  }

  const unlisted = pages.filter(p => !indexedPaths.has(p.docPath.toLowerCase()));
  if (unlisted.length > 0) {
    lines.push('### Additional Pages');
    lines.push('');
    for (const p of unlisted) {
      const title = p.content?.match(/^# (.+)$/m)?.[1] || p.docPath;
      lines.push(`- 📄 [${title}](${p.docPath.toLowerCase()}.md)`);
    }
    lines.push('');
  }

  fs.writeFileSync(path.join(targetDir, 'README.md'), lines.join('\n'), 'utf-8');
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------
async function main() {
  const start = Date.now();

  for (const target of TARGETS) {
    console.log(`\n📚 ${target.title} (concurrency: ${CONCURRENCY})`);
    console.log('═'.repeat(60));

    const targetDir = path.join(OUTPUT_DIR, target.name);
    fs.mkdirSync(targetDir, { recursive: true });

    // Phase 1: Discover + Fetch concurrently
    const t0 = Date.now();
    console.log('  Crawling + fetching...');
    const pages = await discoverAndFetch(target.path);
    console.log(`  ⏱️  Fetched in ${((Date.now() - t0) / 1000).toFixed(1)}s`);

    // Phase 2: Save (fast, sync I/O)
    const t1 = Date.now();
    console.log(`  Saving ${pages.length} pages...`);
    for (const page of pages) {
      savePage(targetDir, page.docPath, page.content);
    }
    console.log(`  ⏱️  Saved in ${((Date.now() - t1) / 1000).toFixed(1)}s`);

    // Phase 3: README
    generateReadme(targetDir, target, pages);

    // Stats
    const totalSize = pages.reduce((s, p) => s + p.content.length, 0);
    console.log(`  📊 ${pages.length} pages | ${Math.round(totalSize / 1024)} KB | ${((Date.now() - t0) / 1000).toFixed(1)}s total`);
  }

  console.log(`\n🎉 Done in ${((Date.now() - start) / 1000).toFixed(1)}s`);
}

main().catch(console.error);
