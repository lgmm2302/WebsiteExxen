#!/usr/bin/env bash
set -euo pipefail
for f in *.html; do perl -0pi -e 's{\s*<a href="Blog\.html">Blog</a>}{}g' "$f"; done
perl -0pi -e 's{\s*<url>\s*<loc>https://exxentenis\.com\.br/Blog\.html</loc>[\s\S]*?</url>}{}' sitemap.xml
git rm -f Blog.html
if grep -l "Blog" *.html sitemap.xml; then echo "ERRO: restou referencia ao Blog"; exit 1; fi
git config user.name "remover-blog"
git config user.email "actions@github.com"
git add -A
git commit -m "Remove o Blog do site (menu, rodape e sitemap)"
git push
echo FIM
