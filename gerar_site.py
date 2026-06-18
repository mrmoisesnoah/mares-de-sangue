#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Mares de Sangue - Gerador de site estatico (wiki de fantasia).
Le os .md (com front-matter) do cenario e gera um site HTML estatico,
sem banco de dados. Respeita status (publico/privado) e audiencia.

Uso:
    python gerar_site.py                 # site PUBLICO  -> ./site
    python gerar_site.py --mestre        # site do MESTRE (inclui tudo) -> ./site-mestre
    python gerar_site.py --conteudo CAMINHO --saida CAMINHO

Requisitos: pip install markdown pyyaml
"""
import os, re, sys, json, html, unicodedata, shutil

import markdown as md_lib
import yaml

AQUI = os.path.dirname(os.path.abspath(__file__))
ARGS = sys.argv[1:]
MESTRE = "--mestre" in ARGS

def arg(flag, default):
    if flag in ARGS:
        return ARGS[ARGS.index(flag) + 1]
    return default

CONTEUDO = arg("--conteudo", os.path.join(AQUI, "conteudo"))
SAIDA = arg("--saida", os.path.join(AQUI, "site-mestre" if MESTRE else "site"))

SITE_NOME = "Mares de Sangue"
SITE_SUB = "O Mundo de Skard - enciclopedia do cenario"

IGNORAR_DIRS = {"_DOCX (Word)", "_Arquivo (superado)", "Fontes para Projetos IA"}
IGNORAR_ARQS = {"_FASE0_RELATORIO.md", "_AUDITORIA_MIGRACAO.md"}

SECOES = {
    ".": ("Geral", 0),
    "01 - Canone Atual": ("Canone Atual", 1),
    "02 - Lore Original (Textos Historicos)": ("Lore Original", 2),
    "03 - Mestragem - Ecos na Cidade dos Corvos": ("Ecos na Cidade dos Corvos", 3),
    "04 - Contos e Narrativas": ("Contos e Narrativas", 4),
    "05 - Blog Mar de Sangue (recuperado)": ("Blog (recuperado)", 5),
    "06 - Panimalia (Alianca dos Suicidas)": ("Panimalia", 6),
    "07 - Campanha Anterior (Sombras Vindas do Tempo)": ("Sombras Vindas do Tempo", 7),
}
TIPO_LABEL = {
    "canone": "Canone", "lore": "Lore", "campanha": "Campanha",
    "sessao": "Sessao", "conto": "Conto", "jornal": "Jornal", "indice": "Indice",
}

def slugify(s):
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode()
    s = re.sub(r"[^\w\s-]", "", s).strip().lower()
    s = re.sub(r"[\s_-]+", "-", s)
    return s or "artigo"

def secao_de(rel):
    top = rel.split(os.sep)[0] if rel != "." else "."
    return SECOES.get(top, (top, 99))

def parse_front_matter(texto):
    if not texto.lstrip().startswith("---"):
        return {}, texto
    t = texto.lstrip()
    fim = t.find("\n---", 3)
    if fim == -1:
        return {}, texto
    bloco = t[3:fim].strip("\n")
    corpo = t[fim + 4:].lstrip("\n")
    try:
        meta = yaml.safe_load(bloco) or {}
    except Exception:
        meta = {}
    return meta, corpo

def primeiro_paragrafo(corpo):
    for linha in corpo.splitlines():
        s = linha.strip()
        if not s or s.startswith("#") or s.startswith(">") or s.startswith("```") \
           or s.startswith("|") or s.startswith("!") or s.startswith("-"):
            continue
        s = re.sub(r"[*_`#>\[\]]", "", s)
        return (s[:200] + "...") if len(s) > 200 else s
    return ""

class Artigo:
    pass

def coletar():
    arts = []
    for dp, dirs, files in os.walk(CONTEUDO):
        dirs[:] = [d for d in dirs if d not in IGNORAR_DIRS]
        for fn in sorted(files):
            if not fn.endswith(".md") or fn in IGNORAR_ARQS:
                continue
            full = os.path.join(dp, fn)
            with open(full, encoding="utf-8") as f:
                texto = f.read()
            meta, corpo = parse_front_matter(texto)
            if not meta:
                continue
            rel = os.path.relpath(dp, CONTEUDO)
            a = Artigo()
            a.meta = meta
            a.corpo = corpo
            a.rel = rel
            a.fn = fn
            a.titulo = meta.get("titulo") or fn[:-3]
            a.tipo = meta.get("tipo", "lore")
            a.status = meta.get("status", "publico")
            a.audiencia = meta.get("audiencia", "jogadores")
            a.data = str(meta.get("data", "")) or ""
            a.campanha = meta.get("campanha", "")
            tags = meta.get("tags", []) or []
            a.tags = tags if isinstance(tags, list) else [tags]
            a.secao, a.ordem = secao_de(rel)
            a.resumo = primeiro_paragrafo(corpo)
            arts.append(a)
    usados = {}
    for a in arts:
        base = slugify(a.titulo)
        s = base
        i = 2
        while s in usados:
            s = "%s-%d" % (base, i); i += 1
        usados[s] = True
        a.slug = s
        a.url = "artigos/%s.html" % s
    return arts

def remover_h1_inicial(corpo):
    linhas = corpo.lstrip().splitlines()
    for i, ln in enumerate(linhas):
        if ln.strip() == "":
            continue
        if ln.lstrip().startswith("# "):
            return "\n".join(linhas[i + 1:]).lstrip("\n")
        break
    return corpo

def render_corpo(corpo, por_titulo):
    corpo = remover_h1_inicial(corpo)
    def wl(m):
        alvo = m.group(1).strip()
        rotulo = m.group(2).strip() if m.group(2) else alvo
        a = por_titulo.get(alvo.lower())
        if a:
            return "[%s](../%s)" % (rotulo, a.url)
        return rotulo
    corpo = re.sub(r"\[\[([^\]|]+)(?:\|([^\]]+))?\]\]", wl, corpo)
    return md_lib.markdown(corpo, extensions=["extra", "toc", "sane_lists", "nl2br"])

def chip(txt, cls="chip"):
    return '<span class="%s">%s</span>' % (cls, html.escape(txt))

def pagina(titulo, conteudo, depth=0):
    base = "../" * depth
    rodape_ed = "<strong>EDICAO DO MESTRE</strong> - contem segredos" if MESTRE else "edicao publica (jogadores)"
    return (
'<!DOCTYPE html>\n<html lang="pt-BR">\n<head>\n'
'<meta charset="utf-8">\n'
'<meta name="viewport" content="width=device-width, initial-scale=1">\n'
'<title>' + html.escape(titulo) + ' &middot; ' + SITE_NOME + '</title>\n'
'<link rel="preconnect" href="https://fonts.googleapis.com">\n'
'<link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@500;700&family=EB+Garamond:ital@0;1&display=swap" rel="stylesheet">\n'
'<link rel="stylesheet" href="' + base + 'assets/estilo.css">\n'
'</head>\n<body>\n'
'<a class="pular" href="#conteudo">Pular para o conteudo</a>\n'
'<header class="topo">\n'
'  <button id="btn-menu" aria-label="Menu">&#9776;</button>\n'
'  <a class="marca" href="' + base + 'index.html"><span class="marca-t">' + SITE_NOME + '</span><span class="marca-s">' + html.escape(SITE_SUB) + '</span></a>\n'
'  <form class="busca-mini" action="' + base + 'busca.html" method="get">\n'
'    <input type="search" name="q" placeholder="Buscar no mundo..." aria-label="Buscar">\n'
'  </form>\n'
'</header>\n'
'<div class="layout">\n'
'  <aside class="lateral" id="lateral">{NAV}</aside>\n'
'  <main id="conteudo" class="conteudo">' + conteudo + '</main>\n'
'</div>\n'
'<footer class="rodape"><p>' + SITE_NOME + ' &middot; gerado a partir do acervo do cenario &middot; ' + rodape_ed + '</p></footer>\n'
'<script src="' + base + 'assets/app.js"></script>\n'
'</body>\n</html>')

def montar_nav(arts, depth, ativo_slug=""):
    base = "../" * depth
    secs = {}
    for a in arts:
        secs.setdefault((a.ordem, a.secao), []).append(a)
    out = ['<nav><a class="nav-home" href="' + base + 'index.html">&#8962; Inicio</a>']
    out.append('<a class="nav-home" href="' + base + 'tags.html">&#127991; Tags</a>')
    for key in sorted(secs):
        ordem, secao = key
        itens = secs[key]
        itens.sort(key=lambda x: (x.data or "0000", x.fn))
        out.append('<details open><summary>' + html.escape(secao) + ' <em>' + str(len(itens)) + '</em></summary><ul>')
        for a in itens:
            cls = "atual" if a.slug == ativo_slug else ""
            lock = "&#128274; " if a.status != "publico" else ""
            out.append('<li class="' + cls + '"><a href="' + base + a.url + '">' + lock + html.escape(a.titulo) + '</a></li>')
        out.append("</ul></details>")
    out.append("</nav>")
    return "\n".join(out)

def limpar_saida(d):
    # Remove conteudo antigo. Em ambientes onde apagar nao e permitido,
    # ignora erros e apenas sobrescreve (na maquina do dev limpa tudo).
    if not os.path.exists(d):
        return
    for root, dirs, files in os.walk(d, topdown=False):
        for fnm in files:
            try: os.remove(os.path.join(root, fnm))
            except OSError: pass
        for dnm in dirs:
            try: os.rmdir(os.path.join(root, dnm))
            except OSError: pass

PUBLICO_MAPA = {
    "01 - Canone Atual": (1, "Canone do Mundo"),
    "02 - Lore Original (Textos Historicos)": (2, "Lore do Universo"),
    "03 - Mestragem - Ecos na Cidade dos Corvos": (3, "Ecos na Cidade dos Corvos"),
    "04 - Contos e Narrativas": (4, "Contos e Narrativas"),
    "06 - Panimalia (Alianca dos Suicidas)": (6, "Panimalia"),
}

def secao_publica(a):
    if a.tipo == "jornal":
        return (5, "Jornais")
    top = a.rel.split(os.sep)[0] if a.rel != "." else "."
    return PUBLICO_MAPA.get(top)

def construir():
    arts = coletar()
    if not MESTRE:
        pub = []
        for a in arts:
            if a.status != "publico" or a.audiencia == "mestre":
                continue
            sp = secao_publica(a)
            if not sp:
                continue
            a.ordem, a.secao = sp
            pub.append(a)
        arts = pub
    arts.sort(key=lambda a: (a.ordem, a.data or "0000", a.fn))
    por_titulo = {a.titulo.lower(): a for a in arts}

    limpar_saida(SAIDA)
    os.makedirs(os.path.join(SAIDA, "artigos"), exist_ok=True)
    os.makedirs(os.path.join(SAIDA, "assets"), exist_ok=True)

    with open(os.path.join(SAIDA, "assets", "estilo.css"), "w", encoding="utf-8") as f:
        f.write(CSS)
    with open(os.path.join(SAIDA, "assets", "app.js"), "w", encoding="utf-8") as f:
        f.write(JS)

    busca_idx = []
    for a in arts:
        nav = montar_nav(arts, 1, a.slug)
        corpo_html = render_corpo(a.corpo, por_titulo)
        rel = [x for x in arts if x is not a and set(x.tags) & set(a.tags)][:6]
        meta_chips = [chip(TIPO_LABEL.get(a.tipo, a.tipo), "chip tipo-" + a.tipo)]
        if a.data:
            meta_chips.append(chip("\U0001F4C5 " + a.data))
        if a.campanha:
            meta_chips.append(chip("⚔ " + a.campanha))
        if a.status != "publico":
            meta_chips.append(chip("\U0001F512 " + a.status, "chip lock"))
        tag_links = " ".join('<a class="tag" href="../tags.html#%s">%s</a>' % (slugify(t), html.escape(t)) for t in a.tags)
        rel_html = ""
        if rel:
            li = "".join('<li><a href="../%s">%s</a> <span class="mini">%s</span></li>' % (x.url, html.escape(x.titulo), TIPO_LABEL.get(x.tipo, x.tipo)) for x in rel)
            rel_html = '<section class="relacionados"><h2>Veja tambem</h2><ul>' + li + '</ul></section>'
        artigo = (
'<article class="artigo">\n'
'  <nav class="trilha"><a href="../index.html">Inicio</a> &rsaquo; <span>' + html.escape(a.secao) + '</span></nav>\n'
'  <h1 class="titulo-art">' + html.escape(a.titulo) + '</h1>\n'
'  <div class="meta">' + " ".join(meta_chips) + '</div>\n'
'  <div class="corpo">' + corpo_html + '</div>\n'
'  <div class="tags-art">' + tag_links + '</div>\n'
'  ' + rel_html + '\n'
'</article>')
        out = pagina(a.titulo, artigo, 1).replace("{NAV}", nav)
        with open(os.path.join(SAIDA, "artigos", a.slug + ".html"), "w", encoding="utf-8") as f:
            f.write(out)
        busca_idx.append({
            "titulo": a.titulo, "url": a.url, "tipo": a.tipo, "secao": a.secao,
            "tags": a.tags, "data": a.data, "resumo": a.resumo,
            "texto": re.sub(r"\s+", " ", re.sub(r"[#*`>\[\]]", "", a.corpo))[:1500].lower(),
        })

    with open(os.path.join(SAIDA, "busca.json"), "w", encoding="utf-8") as f:
        json.dump(busca_idx, f, ensure_ascii=False)

    # index
    secs = {}
    for a in arts:
        secs.setdefault((a.ordem, a.secao), []).append(a)
    cards = []
    for key in sorted(secs):
        itens = secs[key]
        amostra = ", ".join(html.escape(x.titulo) for x in itens[:3])
        cards.append('<a class="card" href="%s"><h3>%s</h3><p class="card-n">%d artigos</p><p class="card-ex">%s...</p></a>'
                     % (itens[0].url, html.escape(key[1]), len(itens), amostra))
    recentes = sorted([a for a in arts if a.data], key=lambda x: x.data, reverse=True)[:6]
    dest = ""
    if recentes:
        li = "".join('<li><a href="%s">%s</a><span class="mini">%s &middot; %s</span></li>'
                     % (x.url, html.escape(x.titulo), x.data, TIPO_LABEL.get(x.tipo, x.tipo)) for x in recentes)
        dest = '<section class="bloco"><h2>Adicoes recentes</h2><ul class="lista-rec">' + li + '</ul></section>'
    home = (
'<section class="hero">\n'
'  <h1>' + SITE_NOME + '</h1>\n'
'  <p class="lede">' + html.escape(SITE_SUB) + '. Uma enciclopedia viva do continente de Dagorcain e do antigo mundo de Skard - historia, cidades, faccoes, contos e cronicas de mesa.</p>\n'
'  <form class="busca-grande" action="busca.html" method="get">\n'
'    <input type="search" name="q" placeholder="Buscar personagens, cidades, eventos..." aria-label="Buscar">\n'
'    <button>Buscar</button>\n'
'  </form>\n'
'  <p class="contagem">' + str(len(arts)) + (' artigos (edicao do mestre)' if MESTRE else ' artigos publicos') + '</p>\n'
'</section>\n'
'<section class="bloco"><h2>Secoes</h2><div class="cards">' + "".join(cards) + '</div></section>\n'
+ dest)
    out = pagina("Inicio", home, 0).replace("{NAV}", montar_nav(arts, 0))
    with open(os.path.join(SAIDA, "index.html"), "w", encoding="utf-8") as f:
        f.write(out)

    # tags
    tagmap = {}
    for a in arts:
        for t in a.tags:
            tagmap.setdefault(t, []).append(a)
    blocos = []
    for t in sorted(tagmap, key=lambda x: (-len(tagmap[x]), x)):
        li = "".join('<li><a href="%s">%s</a> <span class="mini">%s</span></li>'
                     % (x.url, html.escape(x.titulo), TIPO_LABEL.get(x.tipo, x.tipo))
                     for x in sorted(tagmap[t], key=lambda x: x.titulo))
        blocos.append('<section class="tagbloco" id="%s"><h2>%s <em>%d</em></h2><ul>%s</ul></section>'
                      % (slugify(t), html.escape(t), len(tagmap[t]), li))
    nuvem = " ".join('<a class="tag" href="#%s">%s <em>%d</em></a>' % (slugify(t), html.escape(t), len(tagmap[t])) for t in sorted(tagmap))
    tags_html = '<h1>Tags</h1><div class="nuvem">' + nuvem + '</div>' + "".join(blocos)
    out = pagina("Tags", tags_html, 0).replace("{NAV}", montar_nav(arts, 0))
    with open(os.path.join(SAIDA, "tags.html"), "w", encoding="utf-8") as f:
        f.write(out)

    # busca
    busca_html = (
'<h1>Busca</h1>\n'
'<form class="busca-grande" onsubmit="return false;">\n'
'  <input id="q" type="search" placeholder="Digite para buscar..." autofocus aria-label="Buscar">\n'
'</form>\n'
'<p id="busca-info" class="mini"></p>\n'
'<div id="resultados" class="resultados"></div>')
    out = pagina("Busca", busca_html, 0).replace("{NAV}", montar_nav(arts, 0))
    with open(os.path.join(SAIDA, "busca.html"), "w", encoding="utf-8") as f:
        f.write(out)

    print("[%s] %d artigos -> %s" % ("MESTRE" if MESTRE else "PUBLICO", len(arts), SAIDA))
    print("  tags: %d" % len(tagmap))
    return len(arts)

CSS = r"""
:root{
  --tinta:#2b2117; --tinta2:#5b4a36; --perg:#f3e9d2; --perg2:#ece0c4;
  --papel:#fbf5e6; --sangue:#7c1c14; --sangue2:#9c2a1e; --ouro:#9a7b3f;
  --borda:#d8c7a0; --sombra:rgba(60,40,20,.18);
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
body{margin:0;background:var(--papel);color:var(--tinta);
  font-family:'EB Garamond',Georgia,'Times New Roman',serif;font-size:19px;line-height:1.7}
a{color:var(--sangue);text-decoration:none}
a:hover{text-decoration:underline}
.pular{position:absolute;left:-999px}
.pular:focus{left:8px;top:8px;background:#fff;padding:8px;z-index:99}
.topo{position:sticky;top:0;z-index:30;display:flex;align-items:center;gap:14px;
  padding:10px 18px;background:linear-gradient(180deg,#23170f,#3a2616);
  color:var(--perg);box-shadow:0 2px 10px var(--sombra);border-bottom:3px solid var(--ouro)}
#btn-menu{display:none;background:none;border:0;color:var(--perg);font-size:24px;cursor:pointer}
.marca{display:flex;flex-direction:column;line-height:1.1;color:var(--perg)!important}
.marca:hover{text-decoration:none}
.marca-t{font-family:'Cinzel',serif;font-weight:700;font-size:22px;letter-spacing:.5px}
.marca-s{font-size:13px;color:#cbb892;font-style:italic}
.busca-mini{margin-left:auto}
.busca-mini input{padding:7px 12px;border-radius:20px;border:1px solid var(--ouro);
  background:#fffdf6;min-width:180px;font-family:inherit}
.layout{display:flex;max-width:1240px;margin:0 auto}
.lateral{flex:0 0 290px;padding:18px 14px;border-right:1px solid var(--borda);
  height:calc(100vh - 64px);position:sticky;top:64px;overflow:auto;background:var(--perg)}
.conteudo{flex:1;min-width:0;padding:26px 38px 80px}
.lateral nav a{color:var(--tinta2)}
.nav-home{display:inline-block;font-family:'Cinzel',serif;font-size:15px;margin:0 10px 10px 0}
.lateral details{margin:4px 0;border-bottom:1px dotted var(--borda)}
.lateral summary{cursor:pointer;font-family:'Cinzel',serif;font-size:14.5px;color:var(--tinta);
  padding:6px 2px;list-style:none}
.lateral summary em{color:var(--ouro);font-style:normal;font-size:12px}
.lateral ul{list-style:none;margin:2px 0 10px;padding:0 0 0 6px}
.lateral li{margin:3px 0;font-size:16px;line-height:1.35}
.lateral li.atual>a{color:var(--sangue);font-weight:700}
.hero{text-align:center;padding:46px 16px 30px;border-bottom:2px solid var(--borda);margin-bottom:24px}
.hero h1{font-family:'Cinzel',serif;font-size:46px;margin:.1em 0;color:var(--sangue);
  text-shadow:1px 1px 0 #e8d8b3}
.lede{max-width:680px;margin:10px auto;font-size:20px;color:var(--tinta2)}
.contagem{color:var(--ouro);font-style:italic}
.busca-grande{display:flex;gap:8px;justify-content:center;max-width:560px;margin:18px auto 6px}
.busca-grande input{flex:1;padding:12px 16px;border:1px solid var(--ouro);border-radius:24px;
  font-family:inherit;font-size:17px;background:#fffdf6}
.busca-grande button{padding:12px 22px;border:0;border-radius:24px;background:var(--sangue);
  color:#fff;font-family:'Cinzel',serif;cursor:pointer}
.bloco{margin:30px 0}
.bloco h2{font-family:'Cinzel',serif;color:var(--tinta);border-bottom:2px solid var(--borda);padding-bottom:6px}
.cards{display:grid;grid-template-columns:repeat(auto-fill,minmax(230px,1fr));gap:16px}
.card{display:block;background:var(--papel);border:1px solid var(--borda);border-radius:10px;
  padding:16px;box-shadow:0 1px 4px var(--sombra);transition:.15s}
.card:hover{transform:translateY(-3px);text-decoration:none;border-color:var(--ouro);box-shadow:0 6px 16px var(--sombra)}
.card h3{font-family:'Cinzel',serif;margin:.1em 0;color:var(--sangue)}
.card-n{color:var(--ouro);font-size:14px;margin:.2em 0}
.card-ex{color:var(--tinta2);font-size:15px;margin:.2em 0}
.lista-rec{list-style:none;padding:0}
.lista-rec li{padding:7px 0;border-bottom:1px dotted var(--borda);display:flex;justify-content:space-between;gap:12px;flex-wrap:wrap}
.mini{color:var(--ouro);font-size:13px;font-style:italic}
.artigo{max-width:760px}
.trilha{font-size:14px;color:var(--tinta2);margin-bottom:8px}
.titulo-art{font-family:'Cinzel',serif;font-size:36px;color:var(--sangue);margin:.1em 0 .2em;line-height:1.15}
.meta{margin:8px 0 18px;display:flex;flex-wrap:wrap;gap:6px}
.chip{display:inline-block;background:var(--perg2);border:1px solid var(--borda);border-radius:14px;
  padding:2px 12px;font-size:13.5px;color:var(--tinta2)}
.chip.lock{background:#f3d9d4;border-color:#d6a99f;color:var(--sangue)}
.tipo-canone{background:#efe2bf}.tipo-jornal{background:#e7ddc6}.tipo-sessao{background:#e3ecd8}
.tipo-conto{background:#e8dce9}.tipo-campanha{background:#e0e6ee}
.corpo{font-size:19.5px}
.corpo h1,.corpo h2,.corpo h3{font-family:'Cinzel',serif;color:var(--tinta);line-height:1.25;margin-top:1.4em}
.corpo h2{border-bottom:1px solid var(--borda);padding-bottom:4px}
.corpo img{max-width:100%;height:auto;border-radius:8px;border:1px solid var(--borda)}
.corpo blockquote{border-left:4px solid var(--ouro);margin:1em 0;padding:.4em 1.1em;
  background:var(--perg);color:var(--tinta2);font-style:italic;border-radius:0 8px 8px 0}
.corpo table{border-collapse:collapse;width:100%;margin:1em 0;font-size:17px}
.corpo th,.corpo td{border:1px solid var(--borda);padding:7px 10px;text-align:left}
.corpo th{background:var(--perg2);font-family:'Cinzel',serif}
.corpo code{background:var(--perg2);padding:1px 5px;border-radius:4px;font-size:.85em}
.corpo hr{border:0;border-top:1px solid var(--borda);margin:1.6em 0}
.corpo a{border-bottom:1px dotted var(--sangue)}
.tags-art{margin:26px 0 6px;display:flex;flex-wrap:wrap;gap:7px}
.tag{display:inline-block;background:var(--perg);border:1px solid var(--ouro);border-radius:14px;padding:2px 12px;font-size:14px}
.tag em{font-style:normal;color:var(--ouro)}
.relacionados{margin-top:32px;border-top:2px solid var(--borda);padding-top:10px}
.relacionados h2{font-family:'Cinzel',serif;font-size:20px}
.relacionados ul{list-style:none;padding:0}
.relacionados li{padding:5px 0;border-bottom:1px dotted var(--borda)}
.nuvem{display:flex;flex-wrap:wrap;gap:8px;margin:16px 0 26px}
.tagbloco{margin:22px 0}
.tagbloco h2{font-family:'Cinzel',serif;border-bottom:1px solid var(--borda)}
.tagbloco em{color:var(--ouro);font-style:normal;font-size:14px}
.tagbloco ul{columns:2;list-style:none;padding:0}
@media(max-width:600px){.tagbloco ul{columns:1}}
.resultados{margin-top:10px}
.res{padding:12px 0;border-bottom:1px dotted var(--borda)}
.res h3{margin:.1em 0;font-family:'Cinzel',serif}
.res p{margin:.2em 0;color:var(--tinta2);font-size:16px}
.rodape{text-align:center;padding:22px;color:var(--tinta2);font-size:14px;border-top:3px solid var(--ouro);background:var(--perg)}
@media(max-width:880px){
  #btn-menu{display:block}
  .lateral{position:fixed;left:0;top:64px;z-index:25;transform:translateX(-100%);
    transition:.2s;box-shadow:4px 0 18px var(--sombra);width:300px}
  .lateral.aberta{transform:none}
  .conteudo{padding:20px 18px 60px}
  .busca-mini{display:none}
  .hero h1{font-size:34px}
  .titulo-art{font-size:28px}
}
"""

JS = r"""
var b=document.getElementById('btn-menu'),l=document.getElementById('lateral');
if(b&&l){b.addEventListener('click',function(){l.classList.toggle('aberta');});}
function param(n){return new URLSearchParams(location.search).get(n)||'';}
var entrada=document.getElementById('q');
if(entrada){
  var dados=[];
  fetch('busca.json').then(function(r){return r.json();}).then(function(j){
    dados=j; var q=param('q'); if(q){entrada.value=q; rodar();}
  });
  var info=document.getElementById('busca-info'),box=document.getElementById('resultados');
  function rodar(){
    var q=entrada.value.trim().toLowerCase();
    if(q.length<2){box.innerHTML='';info.textContent='Digite ao menos 2 letras.';return;}
    var termos=q.split(/\s+/);
    var res=dados.map(function(a){
      var alvo=(a.titulo+' '+(a.tags||[]).join(' ')+' '+a.texto+' '+a.secao).toLowerCase();
      var sc=0; termos.forEach(function(t){
        if(a.titulo.toLowerCase().indexOf(t)>=0)sc+=5;
        if((a.tags||[]).join(' ').toLowerCase().indexOf(t)>=0)sc+=3;
        if(alvo.indexOf(t)>=0)sc+=1;
      });
      return {a:a,sc:sc};
    }).filter(function(x){return x.sc>0;}).sort(function(x,y){return y.sc-x.sc;});
    info.textContent=res.length+' resultado(s) para "'+q+'".';
    box.innerHTML=res.slice(0,60).map(function(x){
      var a=x.a;
      return '<div class="res"><h3><a href="'+a.url+'">'+a.titulo+'</a></h3>'+
        '<p class="mini">'+a.secao+' &middot; '+a.tipo+(a.data?(' &middot; '+a.data):'')+'</p>'+
        '<p>'+(a.resumo||'')+'</p></div>';
    }).join('')||'<p>Nada encontrado.</p>';
  }
  entrada.addEventListener('input',rodar);
}
"""

if __name__ == "__main__":
    construir()
