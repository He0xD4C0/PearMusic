#!/usr/bin/env node
/**
 * Apple Developer Documentation Fetcher
 * Fetches official .md files from docs.developer.apple.com/tutorials/data/documentation/
 *
 * Usage: node scripts/fetch_docs.js
 * Output: docs/apple-music-api/*.md, docs/musickit/*.md
 */

const fs = require('fs');
const path = require('path');

const BASE_MD = 'https://docs.developer.apple.com/tutorials/data/documentation';
const OUTPUT_DIR = path.join(__dirname, '..', 'docs');
const TARGETS = [
  { name: 'apple-music-api', path: 'applemusicapi', title: 'Apple Music API' },
  { name: 'musickit', path: 'MusicKit', title: 'MusicKit' },
];

// ---------------------------------------------------------------------------
// Fetch with retry
// ---------------------------------------------------------------------------
async function fetchMD(url, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const controller = new AbortController();
      const timeout = setTimeout(() => controller.abort(), 30000);
      const res = await fetch(url, {
        signal: controller.signal,
        headers: {
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
          'Accept': 'text/markdown, text/plain, */*',
        },
      });
      clearTimeout(timeout);
      if (res.ok) return await res.text();
      if (res.status === 404) return null; // Page doesn't exist
      console.log(`  ⚠️ HTTP ${res.status} for ${url}, retry ${i + 1}/${retries}`);
    } catch (e) {
      console.log(`  ⚠️ ${e.message}, retry ${i + 1}/${retries}`);
    }
    await new Promise(r => setTimeout(r, 1000 * (i + 1)));
  }
  return null;
}

// ---------------------------------------------------------------------------
// Extract relative documentation links from markdown
// ---------------------------------------------------------------------------
function extractDocLinks(markdown, basePath) {
  if (!markdown) return [];
  const links = new Set();
  // Match: [text](/documentation/BasePath/...) or [text](/documentation/BasePath)
  const pattern = new RegExp(`\\]\\(/documentation/${basePath}(/[^)\\s#]*)?\\)`, 'gi');
  const matches = markdown.matchAll(pattern);
  for (const m of matches) {
    const linkPath = m[0].match(/\(\/documentation\/([^)\s#]*)/)[1];
    links.add(linkPath);
  }
  return [...links];
}

// ---------------------------------------------------------------------------
// Convert Apple doc:// links and internal /documentation/ links to relative .md
// ---------------------------------------------------------------------------
function normalizeLinks(markdown, currentPath) {
  if (!markdown) return '';
  let md = markdown;

  // Convert doc:// links
  md = md.replace(/<doc:\/\/com\.apple\.documentation\/documentation\/([^>]+)>/g,
    (_, p) => `[${p}](../${p.toLowerCase()}.md)`);

  // Keep /documentation/ links as-is (they'll work in browser context)
  // but also add local .md references for offline browsing
  md = md.replace(/\]\(\/documentation\/([^)\s]+)\)/g, (match, p) => {
    const localFile = '../' + p.toLowerCase() + '.md';
    return `](/documentation/${p}) ([local](${localFile}))`;
  });

  return md;
}

// ---------------------------------------------------------------------------
// Discover all pages by crawling
// ---------------------------------------------------------------------------
async function discoverPages(basePath, visited = new Set(), queue = [basePath]) {
  const allPages = [];

  while (queue.length > 0) {
    const current = queue.shift();
    if (visited.has(current)) continue;
    visited.add(current);

    const url = `${BASE_MD}/${current}.md`;
    console.log(`  🔍 Discovering: ${current}`);

    const content = await fetchMD(url);
    if (!content) continue;

    allPages.push({ docPath: current, content });

    // Find more links to crawl (only direct children/related within same base)
    const links = extractDocLinks(content, basePath);
    for (const link of links) {
      if (!visited.has(link)) {
        queue.push(link);
      }
    }
  }

  return allPages;
}

// ---------------------------------------------------------------------------
// Save page
// ---------------------------------------------------------------------------
function savePage(targetDir, docPath, content, basePath) {
  // Build file path from doc path
  const relativePath = docPath.toLowerCase();
  const filePath = path.join(targetDir, relativePath + '.md');
  const dir = path.dirname(filePath);
  fs.mkdirSync(dir, { recursive: true });

  // Strip JSON metadata comment
  let md = content;
  if (md.startsWith('<!--')) {
    const endIdx = md.indexOf('-->');
    if (endIdx !== -1) md = md.slice(endIdx + 3).trim();
  }

  // Convert doc:// links
  md = md.replace(/<doc:\/\/com\.apple\.documentation\/documentation\/([^>]+)>/g,
    (_, p) => `[\`${p.split('/').pop()}\`](/${p.toLowerCase()}.md)`);

  // Remove copyright footer
  md = md.replace(/\n---\n\nCopyright.*$/s, '');

  // Add frontmatter
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
  const indexPage = pages.find(p => p.docPath === target.path);
  const indexMd = indexPage?.content || '';

  const lines = [
    `# ${target.title} Documentation`,
    '',
    `> Official markdown from [developer.apple.com](https://developer.apple.com/documentation/${target.path})`,
    `> Fetched: ${new Date().toISOString().split('T')[0]}`,
    '',
    `**${pages.length} pages**`,
    '',
    '## Pages',
    '',
  ];

  // Group by section using the index page structure
  const sections = indexMd.split(/^### /gm).slice(1);
  for (const section of sections) {
    const sectionTitle = section.split('\n')[0].trim();
    const links = [...section.matchAll(/\[([^\]]+)\]\(\/documentation\/([^)\s]+)\)/g)];

    if (links.length === 0) continue;

    lines.push(`### ${sectionTitle}`);
    lines.push('');

    for (const link of links) {
      const [, text, urlPath] = link;
      const localFile = urlPath.toLowerCase() + '.md';
      const exists = pages.some(p => p.docPath.toLowerCase() === urlPath.toLowerCase());
      const icon = exists ? '📄' : '🔗';
      lines.push(`- ${icon} [${text}](${localFile})`);
    }
    lines.push('');
  }

  // Also list all pages not covered by the index
  const indexedPaths = new Set();
  for (const section of sections) {
    const links = [...section.matchAll(/\]\(\/documentation\/([^)\s]+)\)/g)];
    links.forEach(l => indexedPaths.add(l[1].toLowerCase()));
  }

  const unlisted = pages.filter(p => !indexedPaths.has(p.docPath.toLowerCase()));
  if (unlisted.length > 0) {
    lines.push('### Additional Pages');
    lines.push('');
    for (const p of unlisted) {
      const localFile = p.docPath.toLowerCase() + '.md';
      const title = p.content?.match(/^# (.+)$/m)?.[1] || p.docPath;
      lines.push(`- 📄 [${title}](${localFile})`);
    }
    lines.push('');
  }

  fs.writeFileSync(path.join(targetDir, 'README.md'), lines.join('\n'), 'utf-8');
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------
async function main() {
  for (const target of TARGETS) {
    console.log(`\n📚 Processing: ${target.title} (${target.path})`);
    console.log('═'.repeat(60));

    const targetDir = path.join(OUTPUT_DIR, target.name);
    fs.mkdirSync(targetDir, { recursive: true });

    // Discover all pages
    console.log('  Discovering pages...');
    const pages = await discoverPages(target.path);

    // Save all pages
    console.log(`\n  Saving ${pages.length} pages...`);
    for (const page of pages) {
      const filePath = savePage(targetDir, page.docPath, page.content, target.path);
      console.log(`    ✅ ${path.relative(OUTPUT_DIR, filePath)}`);
    }

    // Generate README
    generateReadme(targetDir, target, pages);
    console.log(`    ✅ README.md`);

    // Stats
    const totalSize = pages.reduce((s, p) => s + p.content.length, 0);
    console.log(`\n  📊 ${pages.length} pages | ${Math.round(totalSize / 1024)} KB`);
  }

  console.log('\n🎉 Done!');
}

main().catch(console.error);
