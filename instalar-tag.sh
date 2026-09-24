#!/usr/bin/env bash
set -euo pipefail
export SNIP='<script async src="https://www.googletagmanager.com/gtag/js?id=AW-16738051768"></script><script>window.dataLayer=window.dataLayer||[];function gtag(){dataLayer.push(arguments);}gtag("js",new Date());gtag("config","AW-16738051768");</script>'
N=0
for f in *.html; do if grep -q "AW-16738051768" "$f"; then echo "ja tem: $f"; else perl -0pi -e 's{</head>}{$ENV{SNIP}\n</head>}' "$f"; echo "tag inserida: $f"; fi; N=$((N+1)); done
T=$(grep -l "AW-16738051768" *.html | wc -l)
if [ "$T" != "$N" ]; then echo "ERRO: tag em $T de $N paginas"; exit 1; fi
echo "VERIFICADO: tag em $T de $N paginas"
git config user.name "tag-google"
git config user.email "actions@github.com"
git add -A
git diff --cached --quiet || { git commit -m "Instala a tag do Google (AW-16738051768) em todas as paginas"; git push; }
echo FIM
