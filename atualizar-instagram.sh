#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob
mkdir -p img
for f in *.jpg; do mv -f "$f" "img/$f"; echo "movido: $f"; done
for n in ig-treino ig-tecnica ig-torneio ig-infantil ig-familias ig-bastidores; do test -f "img/$n.jpg" || { echo "ERRO: falta img/$n.jpg"; exit 1; }; done
N=$(grep -o '<div class="pimg bg-[a-z0-9]*">' index.html | wc -l)
if [ "$N" != "6" ]; then echo "ERRO: esperava 6 quadros, achei $N"; exit 1; fi
perl -0pi -e 'my @im=qw(ig-treino ig-tecnica ig-torneio ig-infantil ig-familias ig-bastidores); my $i=0; s{<div class="pimg bg-[a-z0-9]+">}{"<div class=\"pimg\" style=\"background-image:url(\x27img/".$im[$i++].".jpg\x27);background-size:cover;background-position:center;\">"}ge' index.html
R=$(grep -c 'ig-treino.jpg' index.html)
if [ "$R" = "0" ]; then echo "ERRO: troca nao aplicou"; exit 1; fi
git config user.name "instagram-fotos"
git config user.email "actions@github.com"
git add -A
git commit -m "Preenche a vitrine do Instagram com fotos reais"
git push
echo FIM
