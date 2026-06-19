var sb = supabase.createClient(window.SUPA.url, window.SUPA.anon);
var app = document.getElementById("app");
var S = { user:null, profile:null, mundo:null, mundos:[], mesas:[], view:{t:"home"}, msg:"", pubAtual:null, nomes:{}, tags:{},
          expl:{pubs:[],q:"",cat:null}, modo:(localStorage.getItem("mds_modo")||"cards") };

function esc(s){ s=(s==null?"":""+s); return s.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;"); }
function slug(s){ return (s||"").normalize("NFD").replace(/[̀-ͯ]/g,"").toLowerCase().replace(/[^\w\s-]/g,"").trim().replace(/[\s_-]+/g,"-")||("item-"+Date.now()); }
function visChip(v){ return '<span class="chip c-'+v+'">'+esc((v||"").replace("_","+"))+'</span>'; }
function val(id){ var e=document.getElementById(id); return e?e.value:""; }
function go(t,arg){ S.view={t:t,arg:arg}; S.msg=""; window.scrollTo(0,0); render(); }
function erro(e){ S.msg='<div class="aviso">'+esc(e&&e.message?e.message:e)+'</div>'; render(); }
function md(s){ return (window.marked ? marked.parse(s||"") : esc(s||"").replace(/\n/g,"<br>")); }
function resumo(c){ var t=(c||"").replace(/[#*`>\[\]_]/g,"").replace(/\s+/g," ").trim(); return t.length>120?t.slice(0,120)+"…":t; }
function meu(p){ return !!S.user && p && (p.autor_id===S.user.id || (S.profile&&S.profile.papel_global==="admin")); }
function donoMundo(){ return !!S.user && S.mundo && (S.mundo.dono_id===S.user.id || (S.profile&&S.profile.papel_global==="admin")); }
function mestreDe(m){ return !!S.user && m && (m.mestre_id===S.user.id || (S.profile&&S.profile.papel_global==="admin")); }
function temMesaPropria(){ return !!S.user && S.mesas.some(function(m){return m.mestre_id===S.user.id;}); }
function regTags(pubs){ (pubs||[]).forEach(function(p){(p.tags||[]).forEach(function(t){S.tags[t]=1;});}); }
function ehPersonagem(t){ t=(t||"").toLowerCase(); return t==="personagem"||t==="background"||t.indexOf("personagem")>=0; }

function secaoDe(tipo){
  var t=(tipo||"").toLowerCase();
  if(t==="jornal") return [5,"Jornais"];
  if(t==="canone"||t==="cânone") return [1,"Cânone do Mundo"];
  if(t==="conto") return [6,"Contos e Narrativas"];
  if(t==="mapa") return [7,"Mapas"];
  if(ehPersonagem(t)) return [11,"Personagens & Histórias"];
  if(["cidade","região","regiao","reino","local"].indexOf(t)>=0) return [3,"Lugares"];
  if(["facção","faccao","organização","organizacao","família","familia","clã","cla","religião","religiao"].indexOf(t)>=0) return [4,"Facções, Organizações & Religiões"];
  if(t==="criatura") return [8,"Criaturas"];
  if(t==="item") return [9,"Itens"];
  if(["evento histórico","evento historico","era"].indexOf(t)>=0) return [2,"Eventos & Eras"];
  if(["lore","história do mundo","historia do mundo"].indexOf(t)>=0) return [2,"Textos Históricos & Lore"];
  if(["sessao","sessão","resumo de sessão","resumo de sessao","resumo","crônica","cronica"].indexOf(t)>=0) return [10,"Sessões & Crônicas"];
  if(t==="planejamento do mestre") return [20,"🔒 Planejamento do Mestre"];
  if(["anotação privada","anotacao privada"].indexOf(t)>=0) return [21,"Anotações privadas"];
  return [50,"Outros"];
}
var ICON_SEC={"Cânone do Mundo":"📜","Textos Históricos & Lore":"📚","Eventos & Eras":"⏳","Lugares":"🏰","Facções, Organizações & Religiões":"⚜","Jornais":"📰","Contos e Narrativas":"📖","Mapas":"🗺️","Criaturas":"🐉","Itens":"⚔","Personagens & Histórias":"🧝","Sessões & Crônicas":"🎲","🔒 Planejamento do Mestre":"🔒","Anotações privadas":"🔏","Outros":"📄"};
function iconeTipo(t){ t=(t||"").toLowerCase();
  if(t==="mapa")return "🗺️"; if(t==="jornal")return "📰"; if(ehPersonagem(t))return "🧝";
  if(t==="conto")return "📖"; if(t==="cidade"||t==="local")return "🏰"; if(t==="criatura")return "🐉"; if(t==="item")return "⚔"; return "📜"; }
function thumb(url, icone){ return url ? '<div class="thumb" style="background-image:url('+url+')"></div>' : '<div class="thumb noimg">'+(icone||"📜")+'</div>'; }
function cardPub(p){
  return '<div class="card clic" onclick="go(\'pub\',\''+p.id+'\')">'+thumb(p.capa_url, iconeTipo(p.tipo))
    +'<h3>'+esc(p.titulo)+'</h3>'
    +'<p style="margin:.2em 0"><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')+'</p>'
    +'<p class="res">'+esc(resumo(p.corpo))+'</p></div>';
}
function itemLista(p){
  return '<li class="li-clic" onclick="go(\'pub\',\''+p.id+'\')"><span class="li-ic">'+iconeTipo(p.tipo)+'</span>'
    +'<span class="li-tit">'+esc(p.titulo)+'</span><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+'</li>';
}
function listar(pubs){ return S.modo==="lista" ? '<ul class="lista2">'+pubs.map(itemLista).join("")+'</ul>' : '<div class="cards">'+pubs.map(cardPub).join("")+'</div>'; }
function hero(titulo, sub, fundo, acts){
  return '<div class="hero2">'+(fundo?'<div class="bg" style="background-image:url('+esc(fundo)+')"></div>':'')+'<div class="ov"></div>'
    +'<div class="in"><h1>'+esc(titulo)+'</h1>'+(sub?'<p>'+esc(sub)+'</p>':'')+(acts?'<div class="acts">'+acts+'</div>':'')+'</div></div>';
}
function toggleModo(){ S.modo=(S.modo==="cards"?"lista":"cards"); localStorage.setItem("mds_modo",S.modo); renderExpl(); }
function toggleMenu(){ var l=document.querySelector(".lateral"); if(l) l.classList.toggle("aberta"); }

// ===== Explorador =====
function abrirExplorador(pubs){ regTags(pubs); S.expl={pubs:pubs,q:"",cat:null}; }
function exploradorHTML(){
  return '<div class="expbar"><input class="expq" id="expq" placeholder="🔎 Filtrar por título, tag ou texto…" oninput="explBusca(this.value)">'
    +'<button class="btn mini sec" onclick="toggleModo()" id="btmodo">'+(S.modo==="lista"?"▦ Cards":"☰ Lista")+'</button></div>'
    +'<div class="cards-cat" id="expcats"></div><div id="expconteudo"></div>';
}
function gruposDe(pubs){ var g={}; pubs.forEach(function(p){var s=secaoDe(p.tipo);var k=s[0]+"|"+s[1];(g[k]=g[k]||[]).push(p);}); return g; }
function explCats(){
  var g=gruposDe(S.expl.pubs); var ks=Object.keys(g).sort(function(a,b){return parseInt(a)-parseInt(b);});
  if(!ks.length) return "";
  var todos='<div class="catcard'+(S.expl.cat==null?' active':'')+'" onclick="explCat(null)"><div class="ic">✦</div><div class="nm">Tudo</div><div class="ct">'+S.expl.pubs.length+'</div></div>';
  return todos+ks.map(function(k){ var ord=k.split("|")[0], label=k.split("|")[1];
    return '<div class="catcard'+(String(S.expl.cat)===ord?' active':'')+'" onclick="explCat(\''+ord+'\')"><div class="ic">'+(ICON_SEC[label]||"📄")+'</div><div class="nm">'+esc(label)+'</div><div class="ct">'+g[k].length+'</div></div>';
  }).join("");
}
function explConteudo(){
  var q=S.expl.q, cat=S.expl.cat;
  var lista=S.expl.pubs.filter(function(p){
    if(cat!=null && String(secaoDe(p.tipo)[0])!==String(cat)) return false;
    if(q){ var hay=(p.titulo+" "+(p.tags||[]).join(" ")+" "+(p.corpo||"")).toLowerCase(); if(hay.indexOf(q)<0) return false; }
    return true;
  });
  if(!lista.length) return '<div class="empty">Nada encontrado'+(q?' para "'+esc(q)+'"':'')+'.</div>';
  var g=gruposDe(lista); var ks=Object.keys(g).sort(function(a,b){return parseInt(a)-parseInt(b);});
  var aberto=(q||cat!=null);
  return ks.map(function(k){ var label=k.split("|")[1];
    return '<details class="bloco"'+(aberto?' open':'')+'><summary>'+(ICON_SEC[label]||"📄")+' '+esc(label)+' <span class="ct">'+g[k].length+'</span></summary>'+listar(g[k])+'</details>';
  }).join("");
}
function renderExpl(){ var b=document.getElementById("btmodo"); if(b)b.textContent=(S.modo==="lista"?"▦ Cards":"☰ Lista"); var c=document.getElementById("expcats"),o=document.getElementById("expconteudo"); if(c)c.innerHTML=explCats(); if(o)o.innerHTML=explConteudo(); }
function explBusca(v){ S.expl.q=(v||"").toLowerCase(); renderExpl(); }
function explCat(ord){ S.expl.cat=(ord==null?null:(String(S.expl.cat)===String(ord)?null:ord)); renderExpl(); }

// ---------- auth ----------
async function init(){
  var r = await sb.auth.getSession(); S.user = r.data.session ? r.data.session.user : null;
  sb.auth.onAuthStateChange(function(_e, sess){ var u=sess?sess.user:null;
    if((u&&!S.user)||(!u&&S.user)){ S.user=u; if(u){carregar();}else{carregarPublico();} } });
  if(S.user){ await carregar(); } else { await carregarPublico(); }
}
async function login(){ var r=await sb.auth.signInWithPassword({email:val("email"),password:val("senha")}); if(r.error)return erro(r.error); S.user=r.data.user; await carregar(); }
async function criarConta(){ var r=await sb.auth.signUp({email:val("email"),password:val("senha"),options:{data:{nome:val("nome")||"Aventureiro"}}});
  if(r.error)return erro(r.error);
  if(r.data.session){S.user=r.data.user; await carregar();} else { S.msg='<div class="ok">Conta criada! Confirme o e-mail (se exigido) e entre.</div>'; S.view={t:"login"}; render(); } }
async function sair(){ await sb.auth.signOut(); S.user=null; S.profile=null; await carregarPublico(); }

// ---------- dados ----------
async function carregar(){
  try{
    var p=await sb.from("profiles").select("*").eq("id",S.user.id).maybeSingle(); S.profile=p.data; if(p.data)S.nomes[S.user.id]=p.data.nome;
    var m=await sb.from("mundos").select("*").order("criado_em"); if(m.error)throw m.error;
    S.mundos=m.data||[]; S.mundo=S.mundos[0]||null;
    if(S.mundo) await carregarMesas();
    go("home");
  }catch(e){ erro(e); }
}
async function carregarPublico(){
  try{ S.user=null; S.profile=null; S.mesas=[];
    var m=await sb.from("mundos").select("*").eq("publico",true).order("criado_em");
    S.mundos=m.data||[]; S.mundo=S.mundos[0]||null; if(S.mundo) await carregarMesas(); go("home");
  }catch(e){ erro(e); }
}
async function selecionarMundo(id){ S.mundo=S.mundos.find(function(w){return w.id===id;})||S.mundo; if(S.user) await carregarMesas(); else S.mesas=[]; go("home"); }
async function carregarMesas(){ var r=await sb.from("mesas").select("*").eq("mundo_id",S.mundo.id).order("criado_em"); S.mesas=r.error?[]:(r.data||[]); }
async function pubsDaMesa(id){ var r=await sb.from("publicacoes").select("*").eq("mesa_id",id).order("titulo"); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
async function loreDoMundo(){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).or("mesa_id.is.null,visibilidade.eq.publico").order("titulo"); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
async function persDoMundo(){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).order("titulo"); var d=r.error?[]:(r.data||[]); return d.filter(function(p){return ehPersonagem(p.tipo);}); }
async function recentes(){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).order("criado_em",{ascending:false}).limit(6); return r.error?[]:(r.data||[]); }
async function pubsDoAutor(uid){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).eq("autor_id",uid).order("titulo"); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
async function umaPub(id){ var r=await sb.from("publicacoes").select("*").eq("id",id).maybeSingle(); return r.data; }
async function nomeDe(uid){ if(S.nomes[uid])return S.nomes[uid]; var r=await sb.from("profiles").select("nome").eq("id",uid).maybeSingle(); var n=r.data?r.data.nome:"Autor"; S.nomes[uid]=n; return n; }
async function perfilDe(uid){ S.perfilCache=S.perfilCache||{}; if(S.perfilCache[uid])return S.perfilCache[uid]; var r=await sb.from("profiles").select("id,nome,avatar_url,bio,epiteto").eq("id",uid).maybeSingle(); var p=r.data||{nome:"Autor"}; S.perfilCache[uid]=p; if(p&&p.nome)S.nomes[uid]=p.nome; return p; }

// ---------- storage ----------
async function uploadArquivo(f){ var path=(S.user?S.user.id:"anon")+"/"+Date.now()+"-"+slug(f.name)+"."+(f.name.split(".").pop()||"img");
  var r=await sb.storage.from("midias").upload(path,f,{upsert:false}); if(r.error)throw r.error;
  return sb.storage.from("midias").getPublicUrl(path).data.publicUrl; }
async function subirCapa(inp){ var f=inp.files&&inp.files[0]; if(!f)return; var st=document.getElementById("f_capa_st"); if(st)st.textContent="enviando…";
  try{ var url=await uploadArquivo(f); var c=document.getElementById("f_capa"); if(c)c.value=url; if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }

// ---------- layout ----------
function telaLogin(novo){
  app.innerHTML='<div class="login"><h1>Mares de Sangue</h1><p class="sub">Plataforma para Criação de Mundos<br><small>Uma produção <b>TOGA</b> — The Older Gods Adventures</small></p>'+S.msg
    +(novo?'<input id="nome" placeholder="Seu nome de aventureiro">':'')
    +'<input id="email" type="email" placeholder="E-mail"><input id="senha" type="password" placeholder="Senha">'
    +(novo?'<button class="btn" onclick="criarConta()">Criar conta</button><p style="text-align:center;margin-top:12px"><button class="linkbtn" onclick="go(\'login\')">Já tenho conta — entrar</button></p>'
          :'<button class="btn" onclick="login()">Entrar</button><p style="text-align:center;margin-top:12px"><button class="linkbtn" onclick="go(\'signup\')">Criar uma conta</button></p>')
    +'<p style="text-align:center;margin-top:10px"><button class="linkbtn" onclick="go(\'home\')">‹ explorar sem entrar</button></p></div>';
}
function sidebar(){
  var on=function(x){return S.view.t===x?' class="on"':'';};
  var nav='<a class="nav-home"'+on("home")+' onclick="go(\'home\')">⌂ Início</a>';
  nav+='<a'+on("mundos")+' onclick="go(\'mundos\')">🌍 Mundos</a>';
  if(S.mundo){
    nav+='<div class="mundo-atual" onclick="go(\'home\')" title="Mundo selecionado">'+(S.mundo.capa_url?'<div class="mi" style="background-image:url('+esc(S.mundo.capa_url)+')"></div>':'<div class="mi">🌍</div>')+'<div><div class="ms">Você está em</div><div class="mt">'+esc(S.mundo.nome)+'</div></div></div>';
    nav+='<a'+on("lore")+' onclick="go(\'lore\')">📖 Enciclopédia</a>';
    nav+='<a'+on("mapas")+' onclick="go(\'mapas\')">🗺️ Mapas</a>';
    nav+='<a onclick="go(\'pers\',\'jog\')">👥 Personagens dos Jogadores</a>';
    nav+='<a onclick="go(\'pers\',\'mes\')">🎭 Personagens do Mestre</a>';
    if(S.mesas.length){ nav+='<h4>Mesas</h4>'+S.mesas.map(function(m){return '<a'+(S.view.t==="mesa"&&S.view.arg===m.id?' class="on"':'')+' onclick="go(\'mesa\',\''+m.id+'\')">⚔ '+esc(m.nome)+'</a>';}).join(""); }
    if(S.user){
      nav+='<h4>Sua conta</h4>';
      nav+='<a onclick="go(\'autor\',\''+S.user.id+'\')">👤 Minha página</a>';
      nav+='<a'+on("perfil")+' onclick="go(\'perfil\')">✎ Editar perfil</a>';
      if(donoMundo()) nav+='<a onclick="go(\'editarMundo\')">✎ Editar mundo</a>';
      nav+='<h4>Criar</h4><a onclick="go(\'novaMesa\')">+ Mesa</a><a onclick="go(\'nova\',{mesa:null})">+ Conteúdo</a><a onclick="go(\'nova\',{mesa:null,tipo:\'personagem\'})">+ Personagem</a>';
    } else { nav+='<a onclick="go(\'login\')">🔑 Entrar para participar</a>'; }
  }
  return nav;
}
function layout(conteudo){
  var ub = S.user
    ? esc(S.profile?S.profile.nome:S.user.email)+(S.profile&&S.profile.papel_global==="admin"?" · admin":"")+' &nbsp;<button class="linkbtn" style="color:#cbb892" onclick="sair()">sair</button>'
    : '<button class="btn mini" onclick="go(\'login\')">Entrar</button>';
  app.innerHTML='<header class="topo"><button id="btn-menu" aria-label="Abrir menu" onclick="toggleMenu()">☰</button><div class="marca" onclick="go(\'home\')">Mares de Sangue<small>Plataforma · uma produção TOGA</small></div>'
    +'<div class="userbox">'+ub+'</div></header>'
    +'<div class="layout"><aside class="lateral">'+sidebar()+'</aside><main class="conteudo">'+S.msg+conteudo+'</main></div>';
}

// ---------- telas ----------
function botoesCriar(){
  if(!S.user) return '<a class="btn" onclick="go(\'login\')">Entrar para criar</a>';
  var b='<a class="btn" onclick="go(\'novoMundo\')">+ Criar Mundo</a>';
  if(S.mundo){ b+=' <a class="btn sec" onclick="go(\'novaMesa\')">+ Criar Mesa</a> <a class="btn sec" onclick="go(\'nova\',{mesa:null,tipo:\'personagem\'})">+ Criar Personagem</a>'; }
  return b;
}
async function telaHome(){
  layout('<p>Carregando…</p>');
  var mundoCards=S.mundos.map(function(w){return '<div class="card clic'+(S.mundo&&w.id===S.mundo.id?' sel':'')+'" onclick="selecionarMundo(\''+w.id+'\')">'+thumb(w.capa_url,"🌍")+'<h3>'+esc(w.nome)+'</h3><p class="res">'+esc(w.descricao||"")+'</p></div>';}).join("");
  var topo=hero("Mares de Sangue","Plataforma para Criação de Mundos — uma produção TOGA, The Older Gods Adventures", (S.mundo?S.mundo.fundo_url:null), botoesCriar());
  if(!S.mundo){
    layout(topo+'<h2>Mundos</h2>'+(mundoCards?'<div class="cards">'+mundoCards+'</div>':'<div class="empty">'+(S.user?'Nenhum mundo ainda — crie o primeiro acima.':'Nenhum mundo público disponível.')+'</div>')); return;
  }
  var lore=await loreDoMundo(); var recs=await recentes();
  var nMesas=S.mesas.length, nLore=lore.length, nMapas=lore.filter(function(p){return p.tipo==="mapa";}).length;
  layout(topo
    +'<h2>Mundos</h2><div class="cards">'+mundoCards+'</div>'
    +'<h2>'+esc(S.mundo.nome)+'</h2><p>'+esc(S.mundo.descricao||"")+'</p>'
    +'<div class="stats"><div class="stat"><b>'+nLore+'</b><span>artigos</span></div><div class="stat"><b>'+nMesas+'</b><span>mesas</span></div><div class="stat"><b>'+nMapas+'</b><span>mapas</span></div></div>'
    +'<p><a class="btn sec" onclick="go(\'lore\')">📖 Enciclopédia</a> <a class="btn sec" onclick="go(\'pers\',\'jog\')">👥 Personagens</a></p>'
    +(S.mesas.length?'<h2>'+(S.user?'Suas mesas':'Mesas e Campanhas')+'</h2><div class="cards">'+S.mesas.map(function(m){return '<div class="card clic" onclick="go(\'mesa\',\''+m.id+'\')">'+thumb(m.capa_url,"⚔")+'<h3>'+esc(m.nome)+'</h3><p class="res">'+esc(m.descricao||"")+'</p></div>';}).join("")+'</div>':'')
    +(recs.length?'<h2>Adições recentes</h2>'+listar(recs):''));
}
async function telaMundos(){
  var cards=S.mundos.map(function(w){return '<div class="card clic'+(S.mundo&&w.id===S.mundo.id?' sel':'')+'" onclick="selecionarMundo(\''+w.id+'\')">'+thumb(w.capa_url,"🌍")+'<h3>'+esc(w.nome)+'</h3><p class="res">'+esc(w.descricao||"")+'</p></div>';}).join("");
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mundos</div><h1>🌍 Mundos</h1>'
    +(S.user?'<p><a class="btn" onclick="go(\'novoMundo\')">+ Criar Mundo</a></p>':'')
    +'<div class="cards">'+(cards||'<div class="empty">Nenhum mundo.</div>')+'</div>');
}
async function telaLore(){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var lore=await loreDoMundo(); abrirExplorador(lore);
  layout(hero("Enciclopédia de "+S.mundo.nome,"Filtre por categoria, busque, alterne cards/lista", S.mundo.fundo_url, (S.user?'<a class="btn" onclick="go(\'nova\',{mesa:null})">+ Novo conteúdo</a>':''))+exploradorHTML()); renderExpl(); }
async function telaMapas(){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var lore=await loreDoMundo(); var mp=lore.filter(function(p){return p.tipo==="mapa";});
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mapas</div><h1>🗺️ Mapas</h1>'
    +(S.user?'<p><a class="btn" onclick="go(\'nova\',{mesa:null,tipo:\'mapa\'})">+ Novo mapa</a></p>':'')
    +(mp.length?listar(mp):'<div class="empty">Nenhum mapa visível ainda.</div>')); }
async function telaPers(qual){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var todos=await persDoMundo();
  var dono=S.mundo.dono_id;
  var lista = (qual==="mes") ? todos.filter(function(p){return p.autor_id===dono;}) : todos.filter(function(p){return p.autor_id!==dono;});
  var titulo = (qual==="mes") ? "🎭 Personagens do Mestre (NPCs)" : "👥 Personagens dos Jogadores";
  abrirExplorador(lista);
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Personagens</div><h1>'+titulo+'</h1>'
    +'<p class="vis-leg">Clique em um personagem para ver a página pública do jogador e seus textos.</p>'
    +'<div class="expbar"><input class="expq" id="expq" placeholder="🔎 Filtrar…" oninput="explBusca(this.value)"><button class="btn mini sec" onclick="toggleModo()" id="btmodo">'+(S.modo==="lista"?"▦ Cards":"☰ Lista")+'</button></div>'
    +'<div id="expconteudo"></div>');
  document.getElementById("expconteudo").innerHTML = lista.length? listar(lista) : '<div class="empty">Nenhum personagem ainda.</div>'; }
async function telaMesa(id){ layout('<p>Carregando…</p>'); var mesa=S.mesas.find(function(m){return m.id===id;});
  if(!mesa){ layout('<div class="aviso">Mesa não encontrada (ou você não é membro).</div>'); return; }
  var pubs=await pubsDaMesa(id); abrirExplorador(pubs);
  var acts=S.user?('<a class="btn" onclick="go(\'nova\',{mesa:\''+id+'\'})">+ Conteúdo</a> '
    +'<a class="btn sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'personagem\'})">+ Personagem</a> '
    +'<a class="btn sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'mapa\'})">+ Mapa</a>'
    +(mestreDe(mesa)?' <a class="btn sec" onclick="go(\'editarMesa\',\''+id+'\')">✎ Editar mesa</a>':'')):'';
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mesa</div>'+hero("⚔ "+mesa.nome, mesa.descricao||"", mesa.fundo_url, acts)+exploradorHTML()); renderExpl(); }
async function telaAutor(uid){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var pf=await perfilDe(uid); var nome=pf.nome||"Autor"; var pubs=await pubsDoAutor(uid); abrirExplorador(pubs);
  var ehEu=(S.user&&uid===S.user.id);
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › '+(ehEu?"Minha página":"Autor")+'</div>'
    +'<div class="autor-cap">'+(pf.avatar_url?'<div class="av" style="background-image:url('+esc(pf.avatar_url)+')"></div>':'<div class="av">'+esc((nome||"?")[0].toUpperCase())+'</div>')+'<div><h1 style="margin:0">'+esc(nome)+'</h1>'+(pf.epiteto?'<p class="vis-leg" style="font-style:italic;margin:.1em 0">'+esc(pf.epiteto)+'</p>':'')+'<p class="vis-leg">'+pubs.length+' publicações visíveis neste mundo'+(ehEu?" · sua página de trabalho (vê também rascunhos e privados)":" · página pública")+(ehEu?' · <a onclick="go(\'perfil\')">✎ editar perfil</a>':'')+'</p></div></div>'+(pf.bio?'<div class="corpo" style="max-width:760px;margin:6px 0 14px">'+md(pf.bio)+'</div>':'')
    +(ehEu?'<p><a class="btn" onclick="go(\'nova\',{mesa:null})">+ Novo conteúdo</a></p>':'')+exploradorHTML()); renderExpl(); }
async function telaPub(id){ layout('<p>Carregando…</p>'); var p=await umaPub(id); S.pubAtual=p;
  if(!p){ layout('<div class="aviso">Publicação não encontrada ou sem permissão.</div>'); return; }
  var nomeAutor=await nomeDe(p.autor_id);
  var mid=await sb.from("midias").select("*").eq("publicacao_id",id); var media="";
  if(mid.data){ mid.data.forEach(function(m){ media += (m.tipo==="video")?'<p class="vis-leg">🎬 <a href="'+esc(m.url)+'" target="_blank">'+esc(m.legenda||m.url)+'</a></p>':'<img class="capa" src="'+esc(m.url)+'" alt="">'; }); }
  var voltar = p.mesa_id ? "go('mesa','"+p.mesa_id+"')" : (p.tipo==="mapa"?"go('mapas')":"go('lore')");
  var extra="";
  if(ehPersonagem(p.tipo)){ var outros=(await pubsDoAutor(p.autor_id)).filter(function(x){return x.id!==p.id;});
    if(outros.length){ abrirExplorador(outros); extra='<h2>Mais textos de '+esc(nomeAutor)+'</h2>'+exploradorHTML(); } }
  var acoes='<div class="acoes-pub"><button class="btn mini sec" onclick="baixarPdf()">⬇ PDF</button> <button class="btn mini sec" onclick="baixarDoc()">⬇ Word (.doc)</button>'
    +(meu(p)?' <a class="btn mini sec" onclick="go(\'editar\',\''+p.id+'\')">✎ Editar</a> <button class="btn mini sec" style="border-color:#c08" onclick="excluirPub(\''+p.id+'\','+(p.mesa_id?"'"+p.mesa_id+"'":"null")+')">🗑 Excluir</button>':'')+'</div>';
  layout('<div class="bread"><a onclick="'+voltar+'">‹ voltar</a></div><h1>'+esc(p.titulo)+'</h1>'
    +'<p><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')
    +' &nbsp;<span class="vis-leg">por <a onclick="go(\'autor\',\''+p.autor_id+'\')">'+esc(nomeAutor)+'</a></span></p>'
    +(p.tags&&p.tags.length?'<p class="vis-leg">'+p.tags.map(esc).join(", ")+'</p>':'')
    +(p.capa_url?'<img class="capa" src="'+esc(p.capa_url)+'" alt="">':'')
    +media+'<div class="corpo">'+md(p.corpo)+'</div>'+acoes+extra);
  if(extra) renderExpl(); }

// ---------- export ----------
function baixarPdf(){ var p=S.pubAtual; if(!p)return; var w=window.open("","_blank");
  w.document.write('<html><head><meta charset="utf-8"><title>'+esc(p.titulo)+'</title><style>body{font-family:Georgia,serif;max-width:720px;margin:30px auto;padding:0 18px;line-height:1.6;color:#222}img{max-width:100%}blockquote{border-left:3px solid #aaa;margin:1em 0;padding:.3em 1em;color:#555}</style></head><body><h1>'+esc(p.titulo)+'</h1>'+md(p.corpo)+'</body></html>');
  w.document.close(); w.focus(); setTimeout(function(){ w.print(); },400); }
function baixarDoc(){ var p=S.pubAtual; if(!p)return;
  var html='<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40"><head><meta charset="utf-8"><title>'+esc(p.titulo)+'</title></head><body><h1>'+esc(p.titulo)+'</h1>'+md(p.corpo)+'</body></html>';
  var blob=new Blob(['﻿'+html],{type:"application/msword"});
  var a=document.createElement("a"); a.href=URL.createObjectURL(blob); a.download=slug(p.titulo)+".doc"; document.body.appendChild(a); a.click(); a.remove(); }

// ---------- formulários ----------
var TIPOS=['conto','background','diário de personagem','personagem','mapa','cidade','facção','região','reino','religião','criatura','item','evento histórico','história do mundo','resumo de sessão','crônica','planejamento do mestre','anotação privada'];
function opt(arr,sel){ return arr.map(function(o){var v,l; if(Array.isArray(o)){v=o[0];l=o[1];}else{v=o;l=o;} return '<option value="'+esc(v)+'"'+(sel===v?' selected':'')+'>'+esc(l)+'</option>';}).join(""); }
function uploadCampo(){ return S.user?'<label>… ou enviar arquivo de imagem</label><input type="file" accept="image/*" onchange="subirCapa(this)"><span id="f_capa_st" class="vis-leg"></span>':''; }
function datalistTags(){ var ks=Object.keys(S.tags); return '<datalist id="taglist">'+ks.map(function(t){return '<option value="'+esc(t)+'">';}).join("")+'</datalist>'; }
function formPub(opts, p){
  var mesaId=opts.mesa||(p?p.mesa_id:null); var tipoSel=(p?p.tipo:opts.tipo)||"conto";
  var emMesa=!!opts.mesa; // veio de uma mesa específica
  var rot=ehPersonagem(tipoSel)?"personagem":(tipoSel==="mapa"?"mapa":"conteúdo");
  var visOpts=(mesaId)?[["mesa","mesa (todos da campanha)"],["publico","público (todos)"],["autor_mestre","autor + mestre"],["privado","privado (só eu)"],["mestre","só mestre"]]:[["publico","público (todos)"],["privado","privado (só eu)"]];
  var seletorMesa = (!emMesa && S.mesas.length) ? '<label>Mesa (opcional — relacione a uma campanha)</label><select id="f_mesa"><option value="">— sem mesa (adicionar depois) —</option>'+S.mesas.map(function(m){return '<option value="'+m.id+'"'+(p&&p.mesa_id===m.id?' selected':'')+'>'+esc(m.nome)+'</option>';}).join("")+'</select>' : '';
  return '<div class="bread">'+(p?'Editar ':'Novo ')+esc(rot)+'</div><h1>'+(p?'Editar ':'Novo ')+esc(rot)+'</h1>'
    +'<div class="form"><label>Tipo</label><select id="f_tipo">'+opt(TIPOS,tipoSel)+'</select>'
    +seletorMesa
    +'<label>Título</label><input id="f_titulo" value="'+esc(p?p.titulo:"")+'">'
    +'<label>Imagem de capa — link (opcional)</label><input id="f_capa" value="'+esc(p&&p.capa_url?p.capa_url:"")+'" placeholder="https://…">'+uploadCampo()
    +'<label>Texto (Markdown)</label><textarea id="f_corpo">'+esc(p?p.corpo:"")+'</textarea>'
    +'<div class="row"><div><label>Marcadores / tags (vírgula — digite para criar novos)</label><input id="f_tags" list="taglist" value="'+esc(p&&p.tags?p.tags.join(", "):"")+'">'+datalistTags()+'</div>'
    +'<div><label>Estado</label><select id="f_estado">'+opt([["publicado","publicado"],["rascunho","rascunho"]],p?p.estado:"publicado")+'</select></div>'
    +'<div><label>Visibilidade</label><select id="f_vis">'+opt(visOpts,p?p.visibilidade:(mesaId?"mesa":"publico"))+'</select></div></div>'
    +'<p style="margin-top:16px"><button class="btn" onclick="salvarPub('+(mesaId?"'"+mesaId+"'":"null")+','+(p?"'"+p.id+"'":"null")+','+(emMesa?"true":"false")+')">'+(p?'Salvar':'Criar '+esc(rot))+'</button> '
    +'<button class="btn sec" onclick="'+(mesaId?"go('mesa','"+mesaId+"')":"go('lore')")+'">Cancelar</button></p></div>';
}
function telaNova(opts){ layout(formPub(opts||{},null)); }
async function telaEditar(id){ layout('<p>Carregando…</p>'); var p=await umaPub(id); if(!p){layout('<div class="aviso">Sem permissão.</div>');return;} layout(formPub({mesa:p.mesa_id},p)); }
function telaNovoMundo(){ layout('<div class="bread">Novo mundo</div><h1>🌍 Criar Mundo</h1>'
  +'<div class="form"><label>Nome do mundo</label><input id="m_nome" placeholder="Ex.: Mares de Sangue"><label>Descrição</label><textarea id="m_desc"></textarea>'
  +'<label>Imagem de fundo (hero) — link</label><input id="m_fundo" placeholder="https://…">'+ (S.user?'<label>… ou enviar arquivo</label><input type="file" accept="image/*" onchange="subirMundoFundo(this)"><span id="m_fundo_st" class="vis-leg"></span>':'')
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMundo()">Criar mundo</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'); }
function telaNovaMesa(){ layout('<div class="bread">Nova mesa</div><h1>⚔ Criar Mesa</h1>'
  +'<div class="form"><label>Nome</label><input id="me_nome"><label>Descrição</label><textarea id="me_desc"></textarea>'
  +'<label>Imagem de fundo — link</label><input id="me_fundo" placeholder="https://…">'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMesa()">Criar mesa</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'); }
function telaEditarMundo(){ var w=S.mundo; layout('<div class="bread">Editar mundo</div><h1>Editar mundo</h1>'
  +'<div class="form"><label>Nome</label><input id="w_nome" value="'+esc(w.nome)+'"><label>Descrição</label><textarea id="w_desc">'+esc(w.descricao||"")+'</textarea>'
  +'<label>Imagem de fundo (hero) — link</label><input id="w_fundo" value="'+esc(w.fundo_url||"")+'" placeholder="https://…">'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMundoEdit()">Salvar</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'); }
async function telaEditarMesa(id){ var m=S.mesas.find(function(x){return x.id===id;}); if(!m){layout('<div class="aviso">Mesa não encontrada.</div>');return;}
  layout('<div class="bread">Editar mesa</div><h1>Editar mesa</h1><div class="form"><label>Nome</label><input id="me_nome" value="'+esc(m.nome)+'">'
  +'<label>Descrição</label><textarea id="me_desc">'+esc(m.descricao||"")+'</textarea><label>Imagem de fundo — link</label><input id="me_fundo" value="'+esc(m.fundo_url||"")+'">'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMesaEdit(\''+id+'\')">Salvar</button> <button class="btn sec" onclick="go(\'mesa\',\''+id+'\')">Cancelar</button></p></div>'+'<h2>Jogadores da mesa</h2><p class="vis-leg">Adicione jogadores para que vejam o conteúdo de visibilidade “mesa” e possam contribuir com suas histórias.</p><div id="membros">Carregando…</div>'); await renderMembros(id); }
async function renderMembros(id){
  var c=document.getElementById("membros"); if(!c)return;
  var ms=await membrosMesa(id); var perf=await perfis();
  var nome=function(uid){ var p=perf.find(function(x){return x.id===uid;}); return p?p.nome:"(usuário)"; };
  var ja={}; ms.forEach(function(x){ja[x.user_id]=1;});
  var linhas=ms.map(function(x){
    var rem=(x.papel==="mestre")?"":' <button class="btn mini sec" style="border-color:#c08" onclick="removerMembro(\''+id+'\',\''+x.user_id+'\')">remover</button>';
    return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(x.user_id))+'</span><span class="chip c-'+(x.papel==="mestre"?"mestre":"mesa")+'">'+esc(x.papel)+'</span>'+rem+'</li>';
  }).join("");
  var opc=perf.filter(function(p){return !ja[p.id];}).map(function(p){return '<option value="'+esc(p.id)+'">'+esc(p.nome)+'</option>';}).join("");
  var add=opc?'<div class="expbar" style="margin-top:10px"><select id="me_addjog" style="max-width:260px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6">'+opc+'</select> <button class="btn mini" onclick="addJogador(\''+id+'\')">+ Adicionar jogador</button></div>':'<p class="vis-leg">Todos os usuários registrados já estão nesta mesa.</p>';
  c.innerHTML='<ul class="lista2">'+(linhas||'<li class="vis-leg" style="list-style:none">Sem jogadores ainda — só o mestre.</li>')+'</ul>'+add;
}
async function membrosMesa(id){ var r=await sb.from("mesa_membros").select("user_id,papel").eq("mesa_id",id); return r.error?[]:(r.data||[]); }
async function perfis(){ if(S.perfis)return S.perfis; var r=await sb.from("profiles").select("id,nome").order("nome"); S.perfis=r.error?[]:(r.data||[]); return S.perfis; }
async function addJogador(id){ var uid=val("me_addjog"); if(!uid)return; try{ var r=await sb.from("mesa_membros").insert({mesa_id:id,user_id:uid,papel:"jogador"}); if(r.error)throw r.error; await renderMembros(id); }catch(e){erro(e);} }
async function removerMembro(id,uid){ if(!confirm("Remover este jogador da mesa?"))return; try{ var r=await sb.from("mesa_membros").delete().eq("mesa_id",id).eq("user_id",uid); if(r.error)throw r.error; await renderMembros(id); }catch(e){erro(e);} }
async function subirMundoFundo(inp){ var f=inp.files&&inp.files[0]; if(!f)return; var st=document.getElementById("m_fundo_st"); if(st)st.textContent="enviando…";
  try{ var u=await uploadArquivo(f); document.getElementById("m_fundo").value=u; if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }

// ---------- gravações ----------
async function salvarMundo(){ try{ var n=val("m_nome").trim(); if(!n)return erro("Dê um nome ao mundo.");
  var r=await sb.from("mundos").insert({nome:n,slug:slug(n)+"-"+Date.now().toString(36),descricao:val("m_desc"),dono_id:S.user.id,publico:true,fundo_url:val("m_fundo").trim()||null}).select().single();
  if(r.error)throw r.error; S.mundos.push(r.data); S.mundo=r.data; await carregarMesas(); go("home"); }catch(e){erro(e);} }
async function salvarMundoEdit(){ try{ var upd={nome:val("w_nome").trim(),descricao:val("w_desc"),fundo_url:val("w_fundo").trim()||null};
  var r=await sb.from("mundos").update(upd).eq("id",S.mundo.id).select().single(); if(r.error)throw r.error; S.mundo=r.data; var i=S.mundos.findIndex(function(w){return w.id===r.data.id;}); if(i>=0)S.mundos[i]=r.data; go("home"); }catch(e){erro(e);} }
async function salvarMesa(){ try{ var n=val("me_nome").trim(); if(!n)return erro("Dê um nome à mesa.");
  var reg={mundo_id:S.mundo.id,nome:n,slug:slug(n),descricao:val("me_desc"),mestre_id:S.user.id}; var f=val("me_fundo").trim(); if(f)reg.fundo_url=f;
  var r=await sb.from("mesas").insert(reg).select().single(); if(r.error)throw r.error; await carregarMesas(); go("mesa",r.data.id); }catch(e){erro(e);} }
async function salvarMesaEdit(id){ try{ var upd={nome:val("me_nome").trim(),descricao:val("me_desc"),fundo_url:val("me_fundo").trim()||null};
  var r=await sb.from("mesas").update(upd).eq("id",id).select().single(); if(r.error)throw r.error; await carregarMesas(); go("mesa",id); }catch(e){erro(e);} }
async function salvarPub(mesaId, editId, emMesa){ try{
  var titulo=val("f_titulo").trim(); if(!titulo)return erro("Dê um título.");
  if(!emMesa){ var sel=val("f_mesa"); if(sel) mesaId=sel; }
  var reg={ tipo:val("f_tipo"), titulo:titulo, slug:slug(titulo), corpo:val("f_corpo"),
    tags:val("f_tags").split(",").map(function(s){return s.trim();}).filter(Boolean),
    estado:val("f_estado"), visibilidade:val("f_vis"), capa_url:(val("f_capa").trim()||null) };
  if(reg.tipo==="mapa") reg.categoria="mapa";
  if(editId){ var u=await sb.from("publicacoes").update(reg).eq("id",editId); if(u.error)throw u.error; go("pub",editId); }
  else { reg.mundo_id=S.mundo.id; reg.mesa_id=mesaId||null; reg.autor_id=S.user.id;
    var r=await sb.from("publicacoes").insert(reg).select().single(); if(r.error)throw r.error; go("pub",r.data.id); }
}catch(e){ erro(e); } }
async function excluirPub(id, mesaId){ if(!confirm("Excluir esta publicação? Não dá para desfazer.")) return;
  try{ var r=await sb.from("publicacoes").delete().eq("id",id); if(r.error)throw r.error; if(mesaId) go("mesa",mesaId); else go("lore"); }catch(e){erro(e);} }

function telaPerfil(){ if(!S.user){go("login");return;} var p=S.profile||{};
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Editar perfil</div><h1>👤 Editar perfil</h1>'
  +'<div class="autor-cap">'+(p.avatar_url?'<div class="av" id="av_prev" style="background-image:url('+esc(p.avatar_url)+')"></div>':'<div class="av" id="av_prev">'+esc(((p.nome||"?")[0]||"?").toUpperCase())+'</div>')+'<div><h2 style="margin:0">'+esc(p.nome||"Aventureiro")+'</h2><p class="vis-leg" style="font-style:italic">'+esc(p.epiteto||"")+'</p></div></div>'
  +'<div class="form"><label>Nome de aventureiro</label><input id="pf_nome" value="'+esc(p.nome||"")+'">'
  +'<label>Epíteto / título (ex.: o Errante, a Branca)</label><input id="pf_epiteto" value="'+esc(p.epiteto||"")+'" placeholder="opcional">'
  +'<label>Foto de perfil — link</label><input id="pf_avatar" value="'+esc(p.avatar_url||"")+'" placeholder="https://…"><label>… ou enviar arquivo de imagem</label><input type="file" accept="image/*" onchange="subirAvatar(this)"><span id="pf_avatar_st" class="vis-leg"></span>'
  +'<label>Sobre você (Markdown)</label><textarea id="pf_bio">'+esc(p.bio||"")+'</textarea>'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarPerfil()">Salvar perfil</button> <button class="btn sec" onclick="go(\'autor\',\''+S.user.id+'\')">Ver minha página</button></p></div>'); }
async function subirAvatar(inp){ var f=inp.files&&inp.files[0]; if(!f)return; var st=document.getElementById("pf_avatar_st"); if(st)st.textContent="enviando…";
  try{ var u=await uploadArquivo(f); var c=document.getElementById("pf_avatar"); if(c)c.value=u; var pv=document.getElementById("av_prev"); if(pv){pv.style.backgroundImage="url("+u+")"; pv.textContent="";} if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }
async function salvarPerfil(){ try{ var nome=val("pf_nome").trim()||"Aventureiro"; var upd={nome:nome, epiteto:(val("pf_epiteto").trim()||null), avatar_url:(val("pf_avatar").trim()||null), bio:val("pf_bio")};
  var r=await sb.from("profiles").update(upd).eq("id",S.user.id).select().single(); if(r.error)throw r.error; S.profile=r.data; S.nomes[S.user.id]=r.data.nome; if(S.perfilCache)delete S.perfilCache[S.user.id]; go("autor",S.user.id); }catch(e){erro(e);} }
function render(){
  if(!S.user && (S.view.t==="login"||S.view.t==="signup")){ telaLogin(S.view.t==="signup"); return; }
  var t=S.view.t;
  if(t==="mundos") telaMundos();
  else if(t==="lore") telaLore();
  else if(t==="mapas") telaMapas();
  else if(t==="pers") telaPers(S.view.arg);
  else if(t==="mesa") telaMesa(S.view.arg);
  else if(t==="autor") telaAutor(S.view.arg);
  else if(t==="pub") telaPub(S.view.arg);
  else if(t==="nova") telaNova(S.view.arg);
  else if(t==="editar") telaEditar(S.view.arg);
  else if(t==="novoMundo") telaNovoMundo();
  else if(t==="editarMundo") telaEditarMundo();
  else if(t==="editarMesa") telaEditarMesa(S.view.arg);
  else if(t==="novaMesa") telaNovaMesa();
  else if(t==="perfil") telaPerfil();
  else telaHome();
}
init();
