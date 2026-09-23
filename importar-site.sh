#!/usr/bin/env bash
set -euo pipefail
BASE="https://exxentenis.com.br"
mkdir -p img assets
shopt -s nullglob
for f in *.jpg; do mv -f "$f" "img/$f"; echo "movido: $f"; done
rm -f workflow-importar-site.yml
baixar() { if [ -f "$1" ]; then echo "mantido: $1"; return 0; fi; mkdir -p "$(dirname "$1")"; if curl -fsSL --retry 3 -o "$1" "$BASE/$1"; then echo "baixado: $1"; else rm -f "$1"; if [ "$2" = "obrigatorio" ]; then echo "ERRO: $1"; exit 1; else echo "opcional ausente: $1"; fi; fi; }
if [ ! -f index.html ]; then curl -fsSL --retry 3 -o index.html "$BASE/"; echo "baixado: index.html"; fi
for p in A-EXXEN Programas Estrutura Eventos Blog Contato Nossa-Historia Metodologia Professores Infantil Juvenil Adulto Alta-Performance EXXEN-FLEX Loja Politica-Privacidade LGPD; do baixar "$p.html" obrigatorio; done
baixar exxen.css obrigatorio
baixar support.js obrigatorio
baixar favicon.png obrigatorio
baixar apple-touch-icon.png obrigatorio
baixar robots.txt opcional
baixar sitemap.xml opcional
baixar assets/exxen-logo.png obrigatorio
baixar assets/exxen-logo-white.png obrigatorio
baixar assets/exxen-isotipo-white.png obrigatorio
baixar img/hero-drone.mp4 obrigatorio
for i in aerial-courts aerial-complex hero-serve professores ludgero-arte infantil-girl juvenil-air adult-ready perf-backhand escola-entardecer saibro-ball bar-restaurante saibro-movimento group prog-adulto prog-crianca prog-jovem aerial-courts-rot quadras-fim-tarde loja-raquete descanso-sombra estrutura-aerial comunidade-night premiacao handshake comunidade-group2 kid-toss clinica-group joao-menezes equipe saibro-ball-shadow metodo-hero ludgero-braga professor-gesto alunos-treinador turma-professor equipe-reunida infantil-group-crop disciplina-ludica disciplina-ludica-2 amizades infantil-treino adulto-treino perf-forehand; do baixar "img/$i.jpg" obrigatorio; done
grep -q "loja-especializada.jpg" index.html || perl -0pi -e 's{<div class="shot warm"><div class="cap">Loja especializada</div></div>}{<div class="shot warm" style="background-image:url(\x27img/loja-especializada.jpg\x27);background-size:cover;background-position:center;"><div class="cap">Loja especializada</div></div>}' index.html
grep -q "comunidade-familia.jpg" index.html || perl -0pi -e 's{<div class="shot saibro"><div class="cap">Comunidade</div></div>}{<div class="shot saibro" style="background-image:url(\x27img/comunidade-familia.jpg\x27);background-size:cover;background-position:center 40%;"><div class="cap">Comunidade</div></div>}' index.html
grep -q "loja-especializada.jpg" index.html || { echo "ERRO: patch Loja"; exit 1; }
grep -q "comunidade-familia.jpg" index.html || { echo "ERRO: patch Comunidade"; exit 1; }
git config user.name "importar-site"
git config user.email "actions@github.com"
git add -A
git diff --cached --quiet || { git commit -m "Importa o site do ar e preenche os quadros vazios"; git push; }
echo FIM
