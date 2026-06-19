var sb = supabase.createClient(window.SUPA.url, window.SUPA.anon);
var app = document.getElementById("app");
var S = { user:null, profile:null, mundo:null, mundos:[], mesas:[], view:{t:"home"}, msg:"", pubAtual:null, nomes:{}, tags:{},
          expl:{pubs:[],q:"",cat:null}, modo:(localStorage.getItem("mds_modo")||"cards") };

function esc(s){ s=(s==null?"":""+s); return s.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;"); }
function slug(s){ return (s||"").normalize("NFD").replace(/[̀-ͯ]/g,"").toLowerCase().replace(/[^\w\s-]/g,"").trim().replace(/[\s_-]+/g,"-")||("item-"+Date.now()); }
function visChip(v){ return '<span class="chip c-'+v+'">'+esc((v||"").replace("_","+"))+'</span>'; }
function val(id){ var e=document.getElementById(id); return e?e.value:""; }
var pendingArg;
function go(t,arg){ S.msg=""; var h;
  if(typeof arg==="object" && arg!==null){ pendingArg=arg; h="#/"+t; }
  else { pendingArg=undefined; h="#/"+t+(arg!=null&&arg!==""?"/"+encodeURIComponent(""+arg):""); }
  if(location.hash===h){ rota(); } else { location.hash=h; }
}
function rota(){ var raw=location.hash.replace(/^#\/?/,""); var parts=raw.split("/"); var t=parts[0]||"home"; var arg=(parts.length>1)?decodeURIComponent(parts.slice(1).join("/")):undefined; if(pendingArg!==undefined){ arg=pendingArg; pendingArg=undefined; } S.view={t:t,arg:arg}; window.scrollTo(0,0); render(); }
window.addEventListener("hashchange", rota);
function botaoCompartilhar(){ return '<button class="btn mini sec" onclick="compartilhar()">🔗 Compartilhar</button> <span id="compartilhar-fb" class="vis-leg" style="color:#2f5d2f"></span>'; }
function compartilhar(){ var url=location.href; var done=function(){ var el=document.getElementById("compartilhar-fb"); if(el){ el.textContent="✓ link copiado!"; setTimeout(function(){ if(el)el.textContent=""; },2500); } }; try{ if(navigator.clipboard&&navigator.clipboard.writeText){ navigator.clipboard.writeText(url).then(done, function(){ window.prompt("Copie o link:",url); }); } else { window.prompt("Copie o link:",url); } }catch(e){ window.prompt("Copie o link:",url); } }
function erro(e){ S.msg='<div class="aviso">'+esc(e&&e.message?e.message:e)+'</div>'; render(); }
function md(s){ s=s||""; s=s.replace(/\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/g, function(m,alvo,rot){ var t=(rot||alvo).trim(); return '<a class="wikilink" data-alvo="'+esc(alvo.trim()).replace(/"/g,"&quot;")+'">'+esc(t)+'</a>'; }); return (window.marked ? marked.parse(s) : esc(s).replace(/\n/g,"<br>")); }
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
    rota();
  }catch(e){ erro(e); }
}
async function carregarPublico(){
  try{ S.user=null; S.profile=null; S.mesas=[];
    var m=await sb.from("mundos").select("*").eq("publico",true).order("criado_em");
    S.mundos=m.data||[]; S.mundo=S.mundos[0]||null; if(S.mundo) await carregarMesas(); rota();
  }catch(e){ erro(e); }
}
async function selecionarMundo(id){ S.mundo=S.mundos.find(function(w){return w.id===id;})||S.mundo; await carregarMesas(); go("home"); }
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
function inserirNoTextarea(ta, texto){ var ss=(ta.selectionStart!=null)?ta.selectionStart:ta.value.length; ta.value=ta.value.slice(0,ss)+texto+ta.value.slice(ss); var pos=ss+texto.length; ta.selectionStart=ta.selectionEnd=pos; ta.focus(); }
async function subirEInserir(ta, fdata){ var marca="![enviando "+Date.now()+"…]()"; inserirNoTextarea(ta, "\n"+marca+"\n"); try{ var url=await uploadArquivo(fdata); ta.value=ta.value.replace(marca, "![]("+url+")"); }catch(e){ ta.value=ta.value.replace(marca, "[falha ao enviar imagem]"); } }
function colarImg(e, ta){ var items=(e.clipboardData||window.clipboardData||{}).items||[]; for(var i=0;i<items.length;i++){ if(items[i].type&&items[i].type.indexOf("image")===0){ var fd=items[i].getAsFile(); if(fd){ e.preventDefault(); subirEInserir(ta, fd); } } } }
function soltarImg(e, ta){ var fs=(e.dataTransfer||{}).files||[]; var pego=false; for(var i=0;i<fs.length;i++){ if(fs[i].type&&fs[i].type.indexOf("image")===0){ if(!pego){ e.preventDefault(); pego=true; } subirEInserir(ta, fs[i]); } } }
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
  if(S.mundo){
    nav+='<a'+on("busca")+' onclick="go(\'busca\',\'\')">🔎 Buscar</a>';
    nav+='<a'+on("lore")+' onclick="go(\'lore\')">📖 Enciclopédia</a>';
    nav+='<a'+on("mapas")+' onclick="go(\'mapas\')">🗺️ Mapas</a>';
    nav+='<a class="destaque'+(S.view.t==="jornais"?' on':'')+'" onclick="go(\'jornais\')">📰 Jornais</a>';
    nav+='<a'+on("linha")+' onclick="go(\'linha\')">🕰 Linha do tempo</a>';
    nav+='<a onclick="go(\'pers\',\'jog\')">👥 Personagens dos Jogadores</a>';
    nav+='<a onclick="go(\'pers\',\'mes\')">🎭 Personagens do Mestre</a>';
    if(S.mesas.length){ nav+='<h4>Mesas</h4>'+S.mesas.map(function(m){return '<a'+(S.view.t==="mesa"&&S.view.arg===m.id?' class="on"':'')+' onclick="go(\'mesa\',\''+m.id+'\')">⚔ '+esc(m.nome)+'</a>';}).join(""); }
    if(S.user){
      nav+='<h4>Criar</h4><a onclick="go(\'nova\',{mesa:null})">+ Conteúdo do mundo</a><a onclick="go(\'novoPersonagem\',{mesa:null})">+ Personagem</a><a onclick="go(\'novoJornal\')">+ Jornal</a><a onclick="go(\'novaMesa\')">+ Mesa</a>';
    } else { nav+='<a onclick="go(\'login\')">🔑 Entrar para participar</a>'; }
  }
  return nav;
}
function layout(conteudo){
  var pill = S.mundo ? '<div class="ws-wrap"><div class="world-switch" onclick="toggleWorldMenu(event)" title="Trocar de mundo"><span class="ws-ic">🌍</span><span class="ws-nm">'+esc(S.mundo.nome)+'</span><span class="ws-ar">▾</span></div><div class="world-menu" id="worldmenu">'+S.mundos.map(function(w){return '<a onclick="selecionarMundo(\''+w.id+'\')"'+(w.id===S.mundo.id?' class="atual"':'')+'>🌍 '+esc(w.nome)+'</a>';}).join("")+(S.user?'<div class="sep"></div><a onclick="go(\'novoMundo\')">+ Criar mundo</a>':'')+'</div></div>' : '';
  var ub;
  if(S.user){
    var nm=esc(S.profile?S.profile.nome:S.user.email);
    var av=(S.profile&&S.profile.avatar_url)?'<span class="avatar" style="background-image:url('+esc(S.profile.avatar_url)+')"></span>':'<span class="avatar">'+esc(((S.profile&&S.profile.nome?S.profile.nome:"?")[0]||"?").toUpperCase())+'</span>';
    ub='<button class="user-btn" onclick="toggleUserMenu(event)">'+av+'<span class="user-nm">'+nm+'</span><span class="ws-ar">▾</span></button>'
      +'<div class="user-menu" id="usermenu"><a onclick="go(\'autor\',\''+S.user.id+'\')">👤 Minha página</a><a onclick="go(\'perfil\')">✎ Editar perfil</a>'
      +'<div class="sep"></div><a onclick="go(\'mundos\')">🔄 Trocar de mundo</a><div class="sep"></div><a onclick="sair()">↩ Sair</a></div>';
  } else { ub='<button class="btn mini" onclick="go(\'login\')">Entrar</button>'; }
  app.innerHTML='<header class="topo"><button id="btn-menu" aria-label="Abrir menu" onclick="toggleMenu()">☰</button>'
    +'<div class="marca" onclick="go(\'home\')">⚜ Mares de Sangue</div>'+pill+(S.mundo?'<input class="topo-busca" placeholder="🔎 Buscar no mundo…" onkeydown="if(event.key===\'Enter\')go(\'busca\',this.value)">':'')
    +'<div class="userbox">'+ub+'</div></header>'
    +'<div class="layout"><aside class="lateral">'+sidebar()+'</aside><main class="conteudo">'+S.msg+conteudo+'</main></div>'+'<footer class="rodape">© '+(new Date().getFullYear())+' <b>Moisés Noah</b> · uma produção <b>TOGA</b> — The Older Gods Adventures · <a onclick="go(\'creditos\')">Créditos & atribuições</a></footer>';
}

// ---------- telas ----------
function botoesCriar(){
  if(!S.user) return '<a class="btn" onclick="go(\'login\')">Entrar para criar</a>';
  var b='<a class="btn" onclick="go(\'novoMundo\')">+ Criar Mundo</a>';
  if(S.mundo){ b+=' <a class="btn sec" onclick="go(\'novaMesa\')">+ Criar Mesa</a> <a class="btn sec" onclick="go(\'novoPersonagem\',{mesa:null})">+ Criar Personagem</a>'; }
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
  var heroDash=hero(S.mundo.nome, S.mundo.descricao||"Plataforma para Criação de Mundos — uma produção TOGA", S.mundo.fundo_url, botoesCriar()+(donoMundo()?' <a class="btn sec" onclick="go(\'editarMundo\')">✎ Editar mundo</a>':''));
  function dcard(ic,nm,ds,ac){ return '<div class="card clic dash" onclick="'+ac+'"><div class="dash-ic">'+ic+'</div><h3>'+nm+'</h3><p class="res">'+ds+'</p></div>'; }
  layout(heroDash
    +'<div class="stats"><div class="stat"><b>'+nLore+'</b><span>artigos</span></div><div class="stat"><b>'+nMesas+'</b><span>mesas</span></div><div class="stat"><b>'+nMapas+'</b><span>mapas</span></div></div>'
    +(S.user&&!donoMundo()?'<p><a class="btn sec" onclick="pedirAcesso(\'mundo\',\''+S.mundo.id+'\')">🔑 Pedir acesso para colaborar</a></p>':'')+'<h2>Explorar o mundo</h2><div class="cards">'
      +dcard("📖","Enciclopédia","Conhecimento público do mundo","go(\'lore\')")
      +dcard("🕰","Linha do tempo","A cronologia dos acontecimentos","go(\'linha\')")
      +dcard("👥","Personagens","Heróis, NPCs e histórias","go(\'pers\',\'jog\')")
      +dcard("📰","Jornais","Periódicos e notícias","go(\'jornais\')")
      +dcard("🗺️","Mapas","Cartografia do cenário","go(\'mapas\')")
      +dcard("🔎","Buscar","Procurar em tudo","go(\'busca\',\'\')")
    +'</div>'
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
async function telaPers(qual){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>');
  var todos=await personagensMundo(); var dono=S.mundo.dono_id;
  var lista=(qual==="mes")?todos.filter(function(c){return c.jogador_id===dono;}):todos.filter(function(c){return c.jogador_id!==dono;});
  var titulo=(qual==="mes")?"🎭 Personagens do Mestre (NPCs)":"👥 Personagens dos Jogadores";
  var criar=S.user?'<p><a class="btn" onclick="go(\'novoPersonagem\',{mesa:null})">+ Novo personagem</a></p>':'';
  var cards=lista.length?'<div class="cards">'+lista.map(cardPersonagem).join("")+'</div>':'<div class="empty">Nenhum personagem ainda.</div>';
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Personagens</div><h1>'+titulo+'</h1>'
    +'<p class="vis-leg">Clique num personagem para ver o perfil e todo o conteúdo ligado a ele.</p>'+criar+cards); }
async function telaMesa(id){ layout('<p>Carregando…</p>'); var mesa=S.mesas.find(function(m){return m.id===id;});
  if(!mesa){ layout('<div class="aviso">Mesa não encontrada (ou você não é membro).</div>'); return; }
  var pubs=await pubsDaMesa(id); abrirExplorador(pubs); var sess=await sessoesDaMesa(id);
  var acts=S.user?('<a class="btn" onclick="go(\'nova\',{mesa:\''+id+'\'})">+ Conteúdo</a> '
    +'<a class="btn sec" onclick="go(\'novoPersonagem\',{mesa:\''+id+'\'})">+ Personagem</a> '
    +'<a class="btn sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'mapa\'})">+ Mapa</a>'
    +(mestreDe(mesa)?' <a class="btn sec" onclick="go(\'areaMestre\',\''+id+'\')">🎭 Área do Mestre</a> <a class="btn sec" onclick="go(\'editarMesa\',\''+id+'\')">✎ Editar mesa</a>':'')):'';
  var secSess=sess.length?'<h2>🎲 Sessões</h2><div class="cards">'+sess.map(cardSessao).join("")+'</div>':'';
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mesa</div>'+hero("⚔ "+mesa.nome, mesa.descricao||"", mesa.fundo_url, acts)+(mesa.epoca||mesa.local?'<p class="vis-leg" style="margin-top:-12px">'+(mesa.epoca?'🕰 '+esc(mesa.epoca):'')+(mesa.epoca&&mesa.local?' · ':'')+(mesa.local?'📍 '+esc(mesa.local):'')+'</p>':'')+(S.user&&!mestreDe(mesa)?'<p><a class="btn sec" onclick="pedirAcesso(\'mesa\',\''+id+'\')">🔑 Pedir acesso a esta mesa</a></p>':'')+secSess+exploradorHTML()); renderExpl(); }
async function telaAutor(uid){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var pf=await perfilDe(uid); var nome=pf.nome||"Autor"; var pubs=await pubsDoAutor(uid); abrirExplorador(pubs);
  var ehEu=(S.user&&uid===S.user.id);
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › '+(ehEu?"Minha página":"Autor")+'</div>'
    +'<div class="autor-cap">'+(pf.avatar_url?'<div class="av" style="background-image:url('+esc(pf.avatar_url)+')"></div>':'<div class="av">'+esc((nome||"?")[0].toUpperCase())+'</div>')+'<div><h1 style="margin:0">'+esc(nome)+'</h1>'+(pf.epiteto?'<p class="vis-leg" style="font-style:italic;margin:.1em 0">'+esc(pf.epiteto)+'</p>':'')+'<p class="vis-leg">'+pubs.length+' publicações visíveis neste mundo'+(ehEu?" · sua página de trabalho (vê também rascunhos e privados)":" · página pública")+(ehEu?' · <a onclick="go(\'perfil\')">✎ editar perfil</a>':'')+'</p></div></div>'+(pf.bio?'<div class="corpo" style="max-width:760px;margin:6px 0 14px">'+md(pf.bio)+'</div>':'')
    +(ehEu?'<p><a class="btn" onclick="go(\'nova\',{mesa:null})">+ Novo conteúdo</a></p>':'')+exploradorHTML()); renderExpl(); }
async function telaPub(id){ layout('<p>Carregando…</p>'); var p=await umaPub(id); S.pubAtual=p;
  if(!p){ layout('<div class="aviso">Publicação não encontrada ou sem permissão.</div>'); return; }
  var nomeAutor=await nomeDe(p.autor_id);
  var pcLink=""; if(p.personagem_id){ var pcx=await umPersonagem(p.personagem_id); if(pcx) pcLink=' · <a onclick="go(\'personagem\',\''+p.personagem_id+'\')">🧝 '+esc(pcx.nome)+'</a>'; }
  var jorLink=""; if(p.jornal_id){ var jx=await umJornal(p.jornal_id); if(jx) jorLink=' · <a onclick="go(\'jornal\',\''+p.jornal_id+'\')">📰 '+esc(jx.nome)+'</a>'; }
  var vejaTb=""; if(p.tags&&p.tags.length){ var vt=await sb.from("publicacoes").select("*").eq("mundo_id",p.mundo_id).overlaps("tags",p.tags).neq("id",p.id).limit(8); if(vt.data&&vt.data.length){ vejaTb='<h2>Veja também</h2>'+listar(vt.data); } }
  var mid=await sb.from("midias").select("*").eq("publicacao_id",id); var media="";
  if(mid.data){ mid.data.forEach(function(m){ media += (m.tipo==="video")?'<p class="vis-leg">🎬 <a href="'+esc(m.url)+'" target="_blank">'+esc(m.legenda||m.url)+'</a></p>':'<img class="capa" src="'+esc(m.url)+'" alt="">'; }); }
  var voltar = p.mesa_id ? "go('mesa','"+p.mesa_id+"')" : (p.tipo==="mapa"?"go('mapas')":"go('lore')");
  var extra="";
  if(ehPersonagem(p.tipo)){ var outros=(await pubsDoAutor(p.autor_id)).filter(function(x){return x.id!==p.id;});
    if(outros.length){ abrirExplorador(outros); extra='<h2>Mais textos de '+esc(nomeAutor)+'</h2>'+exploradorHTML(); } }
  var acoes='<div class="acoes-pub"><button class="btn mini sec" onclick="baixarPdf()">⬇ PDF</button> <button class="btn mini sec" onclick="baixarDoc()">⬇ Word (.doc)</button> '+botaoCompartilhar()
    +(meu(p)?' <a class="btn mini sec" onclick="go(\'editar\',\''+p.id+'\')">✎ Editar</a> <button class="btn mini sec" style="border-color:#c08" onclick="excluirPub(\''+p.id+'\','+(p.mesa_id?"'"+p.mesa_id+"'":"null")+')">🗑 Excluir</button>':'')+'</div>';
  layout('<div class="bread"><a onclick="'+voltar+'">‹ voltar</a></div><h1>'+esc(p.titulo)+'</h1>'
    +'<p><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')
    +' &nbsp;<span class="vis-leg">por <a onclick="go(\'autor\',\''+p.autor_id+'\')">'+esc(nomeAutor)+'</a>'+pcLink+jorLink+'</span></p>'
    +(p.tags&&p.tags.length?'<p class="vis-leg">'+p.tags.map(esc).join(", ")+'</p>':'')
    +(p.capa_url?'<img class="capa" src="'+esc(p.capa_url)+'" alt="">':'')
    +media+'<div class="corpo">'+md(p.corpo)+'</div>'+vejaTb+acoes+extra);
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
function campoImagem(label, id, valor){ return '<label>'+label+'</label><div class="img-campo"><input id="'+id+'" value="'+esc(valor||"")+'" placeholder="cole o link direto de uma imagem (.jpg .png .webp .gif)">'+(S.user?'<label class="img-up" title="Enviar do computador"><input type="file" accept="image/*" style="display:none" onchange="subirImg(this,&#39;'+id+'&#39;)">📁 Enviar</label>':'')+'</div><span id="'+id+'_st" class="vis-leg"></span><p class="vis-leg" style="margin:2px 0 0;font-size:12px">Cole o <b>link direto</b> de uma imagem pública (URL terminando em .jpg/.png/.webp/.gif), <b>ou</b> envie um arquivo do computador.</p>'; }
async function subirImg(inp, id){ var fl=inp.files&&inp.files[0]; if(!fl)return; var st=document.getElementById(id+"_st"); if(st)st.textContent="enviando…"; try{ var u=await uploadArquivo(fl); var c=document.getElementById(id); if(c)c.value=u; if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }
function datalistTags(){ var ks=Object.keys(S.tags); return '<datalist id="taglist">'+ks.map(function(t){return '<option value="'+esc(t)+'">';}).join("")+'</datalist>'; }
function formPub(opts, p){
  var mesaId=opts.mesa||(p?p.mesa_id:null); var tipoSel=(p?p.tipo:opts.tipo)||"conto";
  var emMesa=!!opts.mesa; // veio de uma mesa específica
  var rot=ehPersonagem(tipoSel)?"personagem":(tipoSel==="mapa"?"mapa":"conteúdo");
  var visOpts=(mesaId)?[["mesa","mesa (todos da campanha)"],["publico","público (todos)"],["autor_mestre","autor + mestre"],["privado","privado (só eu)"],["mestre","só mestre"]]:[["publico","público (todos)"],["privado","privado (só eu)"]];
  var seletorMesa = (!emMesa && S.mesas.length) ? '<label>Mesa (opcional — relacione a uma campanha)</label><select id="f_mesa"><option value="">— sem mesa (adicionar depois) —</option>'+S.mesas.map(function(m){return '<option value="'+m.id+'"'+(p&&p.mesa_id===m.id?' selected':'')+'>'+esc(m.nome)+'</option>';}).join("")+'</select>' : '';
  var seletorPers = (S.meusPers&&S.meusPers.length) ? '<label>Personagem (opcional — ligar a um personagem)</label><select id="f_personagem"><option value="">— nenhum —</option>'+S.meusPers.map(function(pc){return '<option value="'+pc.id+'"'+(((p&&p.personagem_id===pc.id)||(opts.personagem===pc.id))?' selected':'')+'>'+esc(pc.nome)+'</option>';}).join("")+'</select>' : '';
  var seletorJornal = (S.meusJornais&&S.meusJornais.length) ? '<label>Jornal (opcional — publicar por um jornal)</label><select id="f_jornal"><option value="">— nenhum —</option>'+S.meusJornais.map(function(jj){return '<option value="'+jj.id+'"'+(((p&&p.jornal_id===jj.id)||(opts.jornal===jj.id))?' selected':'')+'>'+esc(jj.nome)+'</option>';}).join("")+'</select>' : '';
  var seletorSessao = (mesaId && S.sessoesForm && S.sessoesForm.length) ? '<label>Sessão (opcional)</label><select id="f_sessao"><option value="">— nenhuma / geral —</option>'+S.sessoesForm.map(function(se){return '<option value="'+se.id+'"'+(((p&&p.sessao_id===se.id)||(opts.sessao===se.id))?' selected':'')+'>'+esc(se.titulo)+'</option>';}).join("")+'</select>' : '';
  return '<div class="bread">'+(p?'Editar ':'Novo ')+esc(rot)+'</div><h1>'+(p?'Editar ':'Novo ')+esc(rot)+'</h1>'
    +'<div class="form"><label>Tipo</label><select id="f_tipo">'+opt(TIPOS,tipoSel)+'</select>'
    +seletorMesa
    +seletorPers
    +seletorJornal
    +seletorSessao
    +'<label>Título</label><input id="f_titulo" value="'+esc(p?p.titulo:"")+'">'
    +campoImagem('Imagem de capa (opcional)','f_capa',(p&&p.capa_url?p.capa_url:""))
    +'<label>Texto (Markdown) <span class="vis-leg" style="font-weight:400;text-transform:none">— arraste ou cole imagens aqui</span></label><textarea id="f_corpo" onpaste="colarImg(event,this)" ondrop="soltarImg(event,this)" ondragover="event.preventDefault()">'+esc(p?p.corpo:"")+'</textarea>'
    +'<div class="row"><div><label>Marcadores / tags (vírgula — digite para criar novos)</label><input id="f_tags" list="taglist" value="'+esc(p&&p.tags?p.tags.join(", "):"")+'">'+datalistTags()+'</div>'
    +'<div><label>Estado</label><select id="f_estado">'+opt([["publicado","publicado"],["rascunho","rascunho"]],p?p.estado:"publicado")+'</select></div>'
    +'<div><label>Visibilidade</label><select id="f_vis">'+opt(visOpts,p?p.visibilidade:(opts.vis||(mesaId?"mesa":"publico")))+'</select></div></div>'
    +'<p style="margin-top:16px"><button class="btn" onclick="salvarPub('+(mesaId?"'"+mesaId+"'":"null")+','+(p?"'"+p.id+"'":"null")+','+(emMesa?"true":"false")+')">'+(p?'Salvar':'Criar '+esc(rot))+'</button> '
    +'<button class="btn sec" onclick="'+(mesaId?"go('mesa','"+mesaId+"')":"go('lore')")+'">Cancelar</button></p></div>';
}
async function telaNova(opts){ opts=opts||{}; S.meusPers=await meusPersonagens(); S.meusJornais=await meusJornais(); if(opts.personagem&&!S.meusPers.some(function(x){return x.id===opts.personagem;})){ var pc=await umPersonagem(opts.personagem); if(pc) S.meusPers=S.meusPers.concat([{id:pc.id,nome:pc.nome}]); } if(opts.jornal&&!S.meusJornais.some(function(x){return x.id===opts.jornal;})){ var jj=await umJornal(opts.jornal); if(jj) S.meusJornais=S.meusJornais.concat([{id:jj.id,nome:jj.nome}]); } S.sessoesForm = opts.mesa? await sessoesDaMesa(opts.mesa) : []; layout(formPub(opts,null)); }
async function telaEditar(id){ layout('<p>Carregando…</p>'); S.meusPers=await meusPersonagens(); S.meusJornais=await meusJornais(); var p=await umaPub(id); if(!p){layout('<div class="aviso">Sem permissão.</div>');return;} S.sessoesForm = p.mesa_id? await sessoesDaMesa(p.mesa_id) : []; layout(formPub({mesa:p.mesa_id},p)); }
function telaNovoMundo(){ layout('<div class="bread">Novo mundo</div><h1>🌍 Criar Mundo</h1>'
  +'<div class="form"><label>Nome do mundo</label><input id="m_nome" placeholder="Ex.: Mares de Sangue"><label>Descrição</label><textarea id="m_desc"></textarea>'
  +campoImagem('Imagem de fundo (hero)','m_fundo','')
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMundo()">Criar mundo</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'); }
function telaNovaMesa(){ layout('<div class="bread">Nova mesa</div><h1>⚔ Criar Mesa</h1>'
  +'<div class="form"><label>Nome</label><input id="me_nome"><label>Descrição</label><textarea id="me_desc"></textarea><label>Época no mundo (opcional)</label><input id="me_epoca" placeholder="ex.: Ano 2068"><label>Local / região (opcional)</label><input id="me_local" placeholder="ex.: Cidade dos Corvos">'
  +campoImagem('Imagem de fundo (opcional)','me_fundo','')
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMesa()">Criar mesa</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'); }
async function telaEditarMundo(){ var w=S.mundo; layout('<div class="bread">Editar mundo</div><h1>Editar mundo</h1>'
  +'<div class="form"><label>Nome</label><input id="w_nome" value="'+esc(w.nome)+'"><label>Descrição</label><textarea id="w_desc">'+esc(w.descricao||"")+'</textarea>'
  +campoImagem('Imagem de fundo (hero)','w_fundo',(w.fundo_url||""))
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMundoEdit()">Salvar</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'
  +'<h2>Colaboradores do mundo</h2><p class="vis-leg">Quem pode criar conteúdo neste mundo. Você (dono) sempre pode.</p><div id="colabmundo">Carregando…</div><div id="pedidosmundo"></div>');
  renderColabMundo(w.id); renderPedidos("mundo",w.id,"pedidosmundo"); }
async function telaEditarMesa(id){ var m=S.mesas.find(function(x){return x.id===id;}); if(!m){layout('<div class="aviso">Mesa não encontrada.</div>');return;}
  layout('<div class="bread">Editar mesa</div><h1>Editar mesa</h1><div class="form"><label>Nome</label><input id="me_nome" value="'+esc(m.nome)+'">'
  +'<label>Descrição</label><textarea id="me_desc">'+esc(m.descricao||"")+'</textarea><label>Época no mundo (opcional)</label><input id="me_epoca" value="'+esc(m.epoca||"")+'" placeholder="ex.: Ano 2068, após a Guerra das Cinco Chaves"><label>Local / região (opcional)</label><input id="me_local" value="'+esc(m.local||"")+'" placeholder="ex.: Cidade dos Corvos, em Dranor">'+campoImagem('Imagem de fundo (opcional)','me_fundo',(m.fundo_url||""))
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMesaEdit(\''+id+'\')">Salvar</button> <button class="btn sec" onclick="go(\'mesa\',\''+id+'\')">Cancelar</button></p></div>'+'<h2>Jogadores da mesa</h2><p class="vis-leg">Adicione jogadores para que vejam o conteúdo de visibilidade “mesa” e possam contribuir com suas histórias.</p><div id="membros">Carregando…</div><div id="pedidosmesa"></div>'); await renderMembros(id); renderPedidos("mesa",id,"pedidosmesa"); }
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
  var reg={mundo_id:S.mundo.id,nome:n,slug:slug(n),descricao:val("me_desc"),mestre_id:S.user.id}; var f=val("me_fundo").trim(); if(f)reg.fundo_url=f; reg.epoca=val("me_epoca").trim()||null; reg.local=val("me_local").trim()||null;
  var r=await sb.from("mesas").insert(reg).select().single(); if(r.error)throw r.error; await carregarMesas(); go("mesa",r.data.id); }catch(e){erro(e);} }
async function salvarMesaEdit(id){ try{ var upd={nome:val("me_nome").trim(),descricao:val("me_desc"),fundo_url:val("me_fundo").trim()||null,epoca:val("me_epoca").trim()||null,local:val("me_local").trim()||null};
  var r=await sb.from("mesas").update(upd).eq("id",id).select().single(); if(r.error)throw r.error; await carregarMesas(); go("mesa",id); }catch(e){erro(e);} }
async function salvarPub(mesaId, editId, emMesa){ try{
  var titulo=val("f_titulo").trim(); if(!titulo)return erro("Dê um título.");
  if(!emMesa){ var sel=val("f_mesa"); if(sel) mesaId=sel; }
  var reg={ tipo:val("f_tipo"), titulo:titulo, slug:slug(titulo), corpo:val("f_corpo"),
    tags:val("f_tags").split(",").map(function(s){return s.trim();}).filter(Boolean),
    estado:val("f_estado"), visibilidade:val("f_vis"), capa_url:(val("f_capa").trim()||null), personagem_id:(val("f_personagem")||null), jornal_id:(val("f_jornal")||null), sessao_id:(val("f_sessao")||null) };
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
  +campoImagem('Foto de perfil','pf_avatar',(p.avatar_url||""))
  +'<label>Sobre você (Markdown)</label><textarea id="pf_bio">'+esc(p.bio||"")+'</textarea>'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarPerfil()">Salvar perfil</button> <button class="btn sec" onclick="go(\'autor\',\''+S.user.id+'\')">Ver minha página</button></p></div>'); }
async function subirAvatar(inp){ var f=inp.files&&inp.files[0]; if(!f)return; var st=document.getElementById("pf_avatar_st"); if(st)st.textContent="enviando…";
  try{ var u=await uploadArquivo(f); var c=document.getElementById("pf_avatar"); if(c)c.value=u; var pv=document.getElementById("av_prev"); if(pv){pv.style.backgroundImage="url("+u+")"; pv.textContent="";} if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }
async function salvarPerfil(){ try{ var nome=val("pf_nome").trim()||"Aventureiro"; var upd={nome:nome, epiteto:(val("pf_epiteto").trim()||null), avatar_url:(val("pf_avatar").trim()||null), bio:val("pf_bio")};
  var r=await sb.from("profiles").update(upd).eq("id",S.user.id).select().single(); if(r.error)throw r.error; S.profile=r.data; S.nomes[S.user.id]=r.data.nome; if(S.perfilCache)delete S.perfilCache[S.user.id]; go("autor",S.user.id); }catch(e){erro(e);} }
// ===== Personagens (entidade / hub) =====
async function umPersonagem(id){ var r=await sb.from("personagens").select("*").eq("id",id).maybeSingle(); return r.data; }
async function pubsDoPersonagem(id){ var r=await sb.from("publicacoes").select("*").eq("personagem_id",id).order("titulo"); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
async function personagensMundo(){ if(!S.mundo)return []; var r=await sb.from("personagens").select("*").eq("mundo_id",S.mundo.id).order("nome"); return r.error?[]:(r.data||[]); }
async function meusPersonagens(){ if(!S.user||!S.mundo)return []; var r=await sb.from("personagens").select("id,nome").eq("mundo_id",S.mundo.id).eq("jogador_id",S.user.id).order("nome"); return r.error?[]:(r.data||[]); }
function cardPersonagem(c){ return '<div class="card clic" onclick="go(\'personagem\',\''+c.id+'\')">'+(c.imagem_url?'<div class="thumb" style="background-image:url('+esc(c.imagem_url)+')"></div>':'<div class="thumb noimg">🧝</div>')+'<h3>'+esc(c.nome)+'</h3>'+(c.epiteto?'<p class="res" style="font-style:italic">'+esc(c.epiteto)+'</p>':'')+'<p style="margin:.2em 0">'+visChip(c.visibilidade)+(c.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')+'</p>'+(c.resumo?'<p class="res">'+esc(c.resumo)+'</p>':'')+'</div>'; }
async function telaPersonagem(id){ layout('<p>Carregando…</p>');
  var c=await umPersonagem(id); if(!c){ layout('<div class="aviso">Personagem não encontrado ou sem permissão.</div>'); return; }
  var nomeAutor=await nomeDe(c.jogador_id); var pubs=await pubsDoPersonagem(id);
  var podeEditar=(S.user&&(c.jogador_id===S.user.id||(S.profile&&S.profile.papel_global==="admin")));
  var contribs=await contribPersonagem(id); var souContrib=!!(S.user&&contribs.some(function(x){return x.user_id===S.user.id;}));
  var podeAdd=podeEditar||souContrib;
  var av=c.imagem_url?'<div class="av" style="width:120px;height:120px;background-image:url('+esc(c.imagem_url)+')"></div>':'<div class="av" style="width:120px;height:120px">'+esc((c.nome||"?")[0].toUpperCase())+'</div>';
  var mesaNome=c.mesa_id?((S.mesas.find(function(m){return m.id===c.mesa_id;})||{}).nome||null):null;
  var btnAdd=podeAdd?'<a class="btn" onclick="go(\'nova\',{personagem:\''+id+'\',mesa:'+(c.mesa_id?"'"+c.mesa_id+"'":"null")+'})">+ Adicionar texto</a> ':'';
  var btnEdit=podeEditar?'<a class="btn sec" onclick="go(\'editarPersonagem\',\''+id+'\')">✎ Editar</a> <button class="btn sec" style="border-color:#c08" onclick="excluirPersonagem(\''+id+'\')">🗑 Excluir</button>':'';
  var acoes='<p>'+btnAdd+btnEdit+(S.user&&!podeEditar&&!souContrib?'<a class="btn sec" onclick="pedirAcesso(\'personagem\',\''+id+'\')">🔑 Pedir p/ escrever</a> ':'')+((btnAdd||btnEdit)?' ':'')+botaoCompartilhar()+'</p>';
  var rel; if(pubs.length){ abrirExplorador(pubs); rel='<h2>Conteúdo relacionado</h2>'+exploradorHTML(); } else { rel='<h2>Conteúdo relacionado</h2><div class="empty">Nenhum conteúdo ligado a este personagem ainda.'+(podeAdd?' Use o botão “+ Adicionar texto”.':'')+'</div>'; }
  var painel=podeEditar?'<h2>Quem pode escrever histórias deste personagem</h2><p class="vis-leg">Autorize outros a adicionar textos na página deste personagem (além de você).</p><div id="contribpers">Carregando…</div><div id="pedidospers"></div>':'';
  layout('<div class="bread"><a onclick="go(\'pers\',\'jog\')">‹ Personagens</a></div>'
    +'<div class="autor-cap">'+av+'<div><h1 style="margin:0">'+esc(c.nome)+'</h1>'
    +(c.epiteto?'<p class="vis-leg" style="font-style:italic;margin:.1em 0">'+esc(c.epiteto)+'</p>':'')
    +'<p class="vis-leg">'+visChip(c.visibilidade)+(c.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')+' · por <a onclick="go(\'autor\',\''+c.jogador_id+'\')">'+esc(nomeAutor)+'</a>'+(mesaNome?' · <a onclick="go(\'mesa\',\''+c.mesa_id+'\')">⚔ '+esc(mesaNome)+'</a>':'')+'</p></div></div>'
    +(c.resumo?'<p>'+esc(c.resumo)+'</p>':'')
    +(c.corpo?'<div class="corpo">'+md(c.corpo)+'</div>':'')
    +acoes+rel+painel);
  if(pubs.length) renderExpl();
  if(podeEditar){ renderContribPers(id); renderPedidos("personagem",id,"pedidospers"); } }
function formPersonagem(opts, c){
  var mesaId=c?c.mesa_id:(opts.mesa||null); var emMesa=!!opts.mesa;
  var visOpts=mesaId?[["publico","público (todos)"],["mesa","mesa (todos da campanha)"],["autor_mestre","autor + mestre"],["privado","privado (só eu)"],["mestre","só mestre"]]:[["publico","público (todos)"],["privado","privado (só eu)"]];
  var seletorMesa=(!emMesa && S.mesas.length)?'<label>Mesa (opcional)</label><select id="pc_mesa"><option value="">— sem mesa —</option>'+S.mesas.map(function(m){return '<option value="'+m.id+'"'+(c&&c.mesa_id===m.id?' selected':'')+'>'+esc(m.nome)+'</option>';}).join("")+'</select>':'';
  return '<div class="bread">'+(c?'Editar personagem':'Novo personagem')+'</div><h1>🧝 '+(c?'Editar personagem':'Novo personagem')+'</h1>'
    +'<div class="form"><label>Nome</label><input id="pc_nome" value="'+esc(c?c.nome:"")+'">'
    +'<label>Epíteto / título (opcional)</label><input id="pc_epiteto" value="'+esc(c&&c.epiteto?c.epiteto:"")+'" placeholder="ex.: o Errante, a Branca">'
    +seletorMesa
    +campoImagem('Foto do personagem (opcional)','pc_img',(c&&c.imagem_url?c.imagem_url:""))
    +'<label>Resumo curto (opcional)</label><input id="pc_resumo" value="'+esc(c&&c.resumo?c.resumo:"")+'" placeholder="uma linha sobre o personagem">'
    +'<label>Perfil / história (Markdown) <span class="vis-leg" style="font-weight:400;text-transform:none">— arraste ou cole imagens aqui</span></label><textarea id="pc_corpo" onpaste="colarImg(event,this)" ondrop="soltarImg(event,this)" ondragover="event.preventDefault()">'+esc(c&&c.corpo?c.corpo:"")+'</textarea>'
    +'<div class="row"><div><label>Estado</label><select id="pc_estado">'+opt([["publicado","publicado"],["rascunho","rascunho"]],c?c.estado:"publicado")+'</select></div>'
    +'<div><label>Visibilidade</label><select id="pc_vis">'+opt(visOpts,c?c.visibilidade:(mesaId?"mesa":"publico"))+'</select></div></div>'
    +'<p style="margin-top:16px"><button class="btn" onclick="salvarPersonagem('+(c?"'"+c.id+"'":"null")+')">'+(c?'Salvar':'Criar personagem')+'</button> <button class="btn sec" onclick="'+(c?"go('personagem','"+c.id+"')":"go('pers','jog')")+'">Cancelar</button></p></div>';
}
function telaNovoPersonagem(opts){ layout(formPersonagem(opts||{},null)); }
async function telaEditarPersonagem(id){ layout('<p>Carregando…</p>'); var c=await umPersonagem(id); if(!c){layout('<div class="aviso">Sem permissão.</div>');return;} layout(formPersonagem({},c)); }
async function salvarPersonagem(editId){ try{
  var nome=val("pc_nome").trim(); if(!nome)return erro("Dê um nome ao personagem.");
  var mesaSel=document.getElementById("pc_mesa")?val("pc_mesa"):"";
  var reg={ nome:nome, slug:slug(nome), epiteto:(val("pc_epiteto").trim()||null), imagem_url:(val("pc_img").trim()||null), resumo:(val("pc_resumo").trim()||null), corpo:val("pc_corpo"), estado:val("pc_estado"), visibilidade:val("pc_vis") };
  if(editId){ if(document.getElementById("pc_mesa")) reg.mesa_id=mesaSel||null; var u=await sb.from("personagens").update(reg).eq("id",editId); if(u.error)throw u.error; go("personagem",editId); }
  else { reg.mundo_id=S.mundo?S.mundo.id:null; reg.mesa_id=mesaSel||null; reg.jogador_id=S.user.id; var r=await sb.from("personagens").insert(reg).select().single(); if(r.error)throw r.error; go("personagem",r.data.id); }
}catch(e){erro(e);} }
async function excluirPersonagem(id){ if(!confirm("Excluir este personagem? Não dá para desfazer.")) return; try{ var r=await sb.from("personagens").delete().eq("id",id); if(r.error)throw r.error; go("pers","jog"); }catch(e){erro(e);} }
async function subirImgPers(inp){ var f=inp.files&&inp.files[0]; if(!f)return; var st=document.getElementById("pc_img_st"); if(st)st.textContent="enviando…"; try{ var u=await uploadArquivo(f); var c=document.getElementById("pc_img"); if(c)c.value=u; if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }
// ===== Permissionamento: colaboradores do mundo =====
async function membrosMundo(id){ var r=await sb.from("mundo_membros").select("user_id,papel").eq("mundo_id",id); return r.error?[]:(r.data||[]); }
async function addColabMundo(id){ var uid=val("mw_add"); if(!uid)return; try{ var r=await sb.from("mundo_membros").insert({mundo_id:id,user_id:uid,papel:"colaborador"}); if(r.error)throw r.error; await renderColabMundo(id); }catch(e){erro(e);} }
async function removerColabMundo(id,uid){ if(!confirm("Remover este colaborador do mundo?"))return; try{ var r=await sb.from("mundo_membros").delete().eq("mundo_id",id).eq("user_id",uid); if(r.error)throw r.error; await renderColabMundo(id); }catch(e){erro(e);} }
async function renderColabMundo(id){ var box=document.getElementById("colabmundo"); if(!box)return;
  var ms=await membrosMundo(id); var perf=await perfis(); var donoId=S.mundo.dono_id;
  var nome=function(uid){ var p=perf.find(function(x){return x.id===uid;}); return p?p.nome:"(usuário)"; };
  var ja={}; ms.forEach(function(x){ja[x.user_id]=1;}); ja[donoId]=1;
  var linhaDono='<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(donoId))+'</span><span class="chip c-mestre">dono</span></li>';
  var linhas=ms.map(function(x){ return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(x.user_id))+'</span><span class="chip c-mesa">colaborador</span> <button class="btn mini sec" style="border-color:#c08" onclick="removerColabMundo(\''+id+'\',\''+x.user_id+'\')">remover</button></li>'; }).join("");
  var opc=perf.filter(function(p){return !ja[p.id];}).map(function(p){return '<option value="'+esc(p.id)+'">'+esc(p.nome)+'</option>';}).join("");
  var add=opc?'<div class="expbar" style="margin-top:10px"><select id="mw_add" style="max-width:260px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6">'+opc+'</select> <button class="btn mini" onclick="addColabMundo(\''+id+'\')">+ Adicionar colaborador</button></div>':'<p class="vis-leg">Todos os usuários já podem criar neste mundo.</p>';
  box.innerHTML='<ul class="lista2">'+linhaDono+linhas+'</ul>'+add; }
// ===== Permissionamento: contribuidores do personagem =====
async function contribPersonagem(id){ var r=await sb.from("personagem_contribuidores").select("user_id").eq("personagem_id",id); return r.error?[]:(r.data||[]); }
async function addContribPers(id){ var uid=val("cp_add"); if(!uid)return; try{ var r=await sb.from("personagem_contribuidores").insert({personagem_id:id,user_id:uid}); if(r.error)throw r.error; await renderContribPers(id); }catch(e){erro(e);} }
async function removerContribPers(id,uid){ if(!confirm("Remover esta autorização?"))return; try{ var r=await sb.from("personagem_contribuidores").delete().eq("personagem_id",id).eq("user_id",uid); if(r.error)throw r.error; await renderContribPers(id); }catch(e){erro(e);} }
async function renderContribPers(id){ var box=document.getElementById("contribpers"); if(!box)return;
  var ms=await contribPersonagem(id); var perf=await perfis();
  var nome=function(uid){ var p=perf.find(function(x){return x.id===uid;}); return p?p.nome:"(usuário)"; };
  var ja={}; ms.forEach(function(x){ja[x.user_id]=1;}); if(S.user)ja[S.user.id]=1;
  var linhas=ms.map(function(x){ return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(x.user_id))+'</span> <button class="btn mini sec" style="border-color:#c08" onclick="removerContribPers(\''+id+'\',\''+x.user_id+'\')">remover</button></li>'; }).join("");
  var opc=perf.filter(function(p){return !ja[p.id];}).map(function(p){return '<option value="'+esc(p.id)+'">'+esc(p.nome)+'</option>';}).join("");
  var add=opc?'<div class="expbar" style="margin-top:10px"><select id="cp_add" style="max-width:260px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6">'+opc+'</select> <button class="btn mini" onclick="addContribPers(\''+id+'\')">+ Autorizar</button></div>':'<p class="vis-leg">Todos os usuários já estão autorizados.</p>';
  box.innerHTML='<ul class="lista2">'+(linhas||'<li class="vis-leg" style="list-style:none">Só você, por enquanto.</li>')+'</ul>'+add; }
// ===== Jornais do mundo =====
async function jornaisMundo(){ if(!S.mundo)return []; var r=await sb.from("jornais").select("*").eq("mundo_id",S.mundo.id).order("nome"); return r.error?[]:(r.data||[]); }
async function umJornal(id){ var r=await sb.from("jornais").select("*").eq("id",id).maybeSingle(); return r.data; }
async function pubsDoJornal(id){ var r=await sb.from("publicacoes").select("*").eq("jornal_id",id).order("criado_em",{ascending:false}); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
async function meusJornais(){ if(!S.user||!S.mundo)return []; var r=await sb.from("jornais").select("id,nome").eq("mundo_id",S.mundo.id).eq("dono_id",S.user.id).order("nome"); return r.error?[]:(r.data||[]); }
function cardJornal(j){ return '<div class="card clic" onclick="go(\'jornal\',\''+j.id+'\')">'+(j.imagem_url?'<div class="thumb" style="background-image:url('+esc(j.imagem_url)+')"></div>':'<div class="thumb noimg">📰</div>')+'<h3>'+esc(j.nome)+'</h3>'+(j.descricao?'<p class="res">'+esc(j.descricao)+'</p>':'')+'</div>'; }
async function telaJornais(){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var js=await jornaisMundo();
  var criar=S.user?'<a class="btn" onclick="go(\'novoJornal\')">+ Criar jornal</a>':'';
  var cards=js.length?'<div class="cards">'+js.map(cardJornal).join("")+'</div>':'<div class="empty">Nenhum jornal ainda neste mundo.</div>';
  layout(hero("📰 Jornais de "+S.mundo.nome,"Periódicos do mundo — notícias, crônicas e boatos publicados pelos jornais", S.mundo.fundo_url, criar)+cards); }
async function telaJornal(id){ layout('<p>Carregando…</p>'); var j=await umJornal(id); if(!j){ layout('<div class="aviso">Jornal não encontrado ou sem permissão.</div>'); return; }
  var nomeDono=await nomeDe(j.dono_id); var noticias=await pubsDoJornal(id);
  var podeEditar=(S.user&&(j.dono_id===S.user.id||(S.profile&&S.profile.papel_global==="admin")));
  var escr=await escritoresJornal(id); var souEscr=!!(S.user&&escr.some(function(x){return x.user_id===S.user.id;}));
  var podePublicar=podeEditar||souEscr;
  var logo=j.imagem_url?'<div class="av" style="width:120px;height:120px;border-radius:12px;background-image:url('+esc(j.imagem_url)+')"></div>':'<div class="av" style="width:120px;height:120px;border-radius:12px">📰</div>';
  var btnPub=podePublicar?'<a class="btn" onclick="go(\'nova\',{jornal:\''+id+'\',tipo:\'jornal\'})">+ Publicar notícia</a> ':'';
  var btnEdit=podeEditar?'<a class="btn sec" onclick="go(\'editarJornal\',\''+id+'\')">✎ Editar</a> <button class="btn sec" style="border-color:#c08" onclick="excluirJornal(\''+id+'\')">🗑 Excluir</button>':'';
  var acoes='<p>'+btnPub+btnEdit+((btnPub||btnEdit)?' ':'')+botaoCompartilhar()+'</p>';
  var lista=noticias.length?listar(noticias):'<div class="empty">Nenhuma notícia publicada ainda.'+(podePublicar?' Use o botão “+ Publicar notícia”.':'')+'</div>';
  var painel=podeEditar?'<h2>Escritores do jornal</h2><p class="vis-leg">Autorize quem pode publicar notícias por este jornal (além de você).</p><div id="escritores">Carregando…</div>':'';
  layout('<div class="bread"><a onclick="go(\'jornais\')">‹ Jornais</a></div>'
    +'<div class="autor-cap">'+logo+'<div><h1 style="margin:0">'+esc(j.nome)+'</h1>'+(j.descricao?'<p class="vis-leg" style="font-style:italic">'+esc(j.descricao)+'</p>':'')+'<p class="vis-leg">'+visChip(j.visibilidade)+' · fundado por <a onclick="go(\'autor\',\''+j.dono_id+'\')">'+esc(nomeDono)+'</a></p></div></div>'
    +acoes+'<h2>Edições / Notícias</h2>'+lista+painel);
  if(podeEditar) renderEscritores(id); }
function formJornal(j){
  var visOpts=[["publico","público (todos)"],["privado","privado (só eu)"]];
  return '<div class="bread">'+(j?'Editar jornal':'Novo jornal')+'</div><h1>📰 '+(j?'Editar jornal':'Criar jornal')+'</h1>'
    +'<div class="form"><label>Nome do jornal</label><input id="j_nome" value="'+esc(j?j.nome:"")+'" placeholder="Ex.: A Trombeta de Dagor">'
    +'<label>Descrição / lema (opcional)</label><input id="j_desc" value="'+esc(j&&j.descricao?j.descricao:"")+'">'
    +campoImagem('Logo do jornal (opcional)','j_img',(j&&j.imagem_url?j.imagem_url:""))
    +'<label>Visibilidade</label><select id="j_vis">'+opt(visOpts,j?j.visibilidade:"publico")+'</select>'
    +'<p style="margin-top:16px"><button class="btn" onclick="salvarJornal('+(j?"'"+j.id+"'":"null")+')">'+(j?'Salvar':'Criar jornal')+'</button> <button class="btn sec" onclick="'+(j?"go('jornal','"+j.id+"')":"go('jornais')")+'">Cancelar</button></p></div>';
}
function telaNovoJornal(){ layout(formJornal(null)); }
async function telaEditarJornal(id){ layout('<p>Carregando…</p>'); var j=await umJornal(id); if(!j){layout('<div class="aviso">Sem permissão.</div>');return;} layout(formJornal(j)); }
async function salvarJornal(editId){ try{ var nome=val("j_nome").trim(); if(!nome)return erro("Dê um nome ao jornal.");
  var reg={ nome:nome, slug:slug(nome), descricao:(val("j_desc").trim()||null), imagem_url:(val("j_img").trim()||null), visibilidade:val("j_vis"), estado:"publicado" };
  if(editId){ var u=await sb.from("jornais").update(reg).eq("id",editId); if(u.error)throw u.error; go("jornal",editId); }
  else { reg.mundo_id=S.mundo.id; reg.dono_id=S.user.id; var r=await sb.from("jornais").insert(reg).select().single(); if(r.error)throw r.error; go("jornal",r.data.id); }
}catch(e){erro(e);} }
async function excluirJornal(id){ if(!confirm("Excluir este jornal? As notícias não são apagadas, só desvinculadas."))return; try{ var r=await sb.from("jornais").delete().eq("id",id); if(r.error)throw r.error; go("jornais"); }catch(e){erro(e);} }
async function subirLogoJornal(inp){ var fl=inp.files&&inp.files[0]; if(!fl)return; var st=document.getElementById("j_img_st"); if(st)st.textContent="enviando…"; try{ var u=await uploadArquivo(fl); var c=document.getElementById("j_img"); if(c)c.value=u; if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }
async function escritoresJornal(id){ var r=await sb.from("jornal_escritores").select("user_id").eq("jornal_id",id); return r.error?[]:(r.data||[]); }
async function addEscritor(id){ var uid=val("je_add"); if(!uid)return; try{ var r=await sb.from("jornal_escritores").insert({jornal_id:id,user_id:uid}); if(r.error)throw r.error; await renderEscritores(id); }catch(e){erro(e);} }
async function removerEscritor(id,uid){ if(!confirm("Remover este escritor?"))return; try{ var r=await sb.from("jornal_escritores").delete().eq("jornal_id",id).eq("user_id",uid); if(r.error)throw r.error; await renderEscritores(id); }catch(e){erro(e);} }
async function renderEscritores(id){ var box=document.getElementById("escritores"); if(!box)return;
  var ms=await escritoresJornal(id); var perf=await perfis();
  var nome=function(uid){ var p=perf.find(function(x){return x.id===uid;}); return p?p.nome:"(usuário)"; };
  var ja={}; ms.forEach(function(x){ja[x.user_id]=1;}); if(S.user)ja[S.user.id]=1;
  var linhas=ms.map(function(x){ return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(x.user_id))+'</span> <button class="btn mini sec" style="border-color:#c08" onclick="removerEscritor(\''+id+'\',\''+x.user_id+'\')">remover</button></li>'; }).join("");
  var opc=perf.filter(function(p){return !ja[p.id];}).map(function(p){return '<option value="'+esc(p.id)+'">'+esc(p.nome)+'</option>';}).join("");
  var add=opc?'<div class="expbar" style="margin-top:10px"><select id="je_add" style="max-width:260px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6">'+opc+'</select> <button class="btn mini" onclick="addEscritor(\''+id+'\')">+ Autorizar escritor</button></div>':'<p class="vis-leg">Todos os usuários já podem escrever.</p>';
  box.innerHTML='<ul class="lista2">'+(linhas||'<li class="vis-leg" style="list-style:none">Só você, por enquanto.</li>')+'</ul>'+add; }
function telaCreditos(){ layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Créditos</div><h1>Créditos & Atribuições</h1>'
  +'<div class="corpo" style="max-width:740px">'
  +'<p><b>Mares de Sangue</b> — plataforma idealizada, projetada e desenvolvida por <b>Moisés Noah</b>.</p>'
  +'<h2>O cenário</h2>'
  +'<p>O mundo de <b>Skard</b> e o cenário <b>Mar de Sangue</b> foram criados coletivamente por <b>TOGA — The Older Gods Adventures</b>, o grupo original de RPG de mesa que construiu junto, ao longo dos anos, toda a história original deste universo.</p>'
  +'<p><b>Membros fundadores do TOGA:</b> Thompson Moutinho (<b><i>O Primeiro Mestre</i></b>), Moisés Noah, Arnom Abner, Amós Gonzaga, Asafe Lucas, Cleudon Paulo e Matheus “Tharen”.</p>'
  +'<h2>Material original</h2>'
  +'<p>A história original permanece disponível no blog <a href="https://maresdesangue.blogspot.com/" target="_blank" rel="noopener">Mares de Sangue</a>.</p>'
  +'<hr>'
  +'<p class="vis-leg">© '+(new Date().getFullYear())+' Moisés Noah / TOGA — The Older Gods Adventures. Os direitos do cenário e das histórias originais pertencem aos seus criadores. Cada autor mantém os direitos sobre o conteúdo que publica nesta plataforma.</p>'
  +'</div>'); }
// ===== Sessões / Área do Mestre =====
async function sessoesDaMesa(id){ var r=await sb.from("sessoes").select("*").eq("mesa_id",id).order("ordem",{nullsFirst:false}).order("criado_em"); return r.error?[]:(r.data||[]); }
async function umaSessao(id){ var r=await sb.from("sessoes").select("*").eq("id",id).maybeSingle(); return r.data; }
async function pubsDaSessao(id){ var r=await sb.from("publicacoes").select("*").eq("sessao_id",id).order("criado_em"); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
function cardSessao(se){ return '<div class="card clic" onclick="go(\'sessao\',\''+se.id+'\')"><div class="thumb noimg">🎲</div><h3>'+esc(se.titulo)+'</h3>'+(se.data?'<p class="res">'+esc(se.data)+'</p>':'')+'</div>'; }
async function telaMestre(id){ layout('<p>Carregando…</p>'); var mesa=S.mesas.find(function(m){return m.id===id;});
  if(!mesa){ layout('<div class="aviso">Mesa não encontrada.</div>'); return; }
  if(!mestreDe(mesa)){ layout('<div class="aviso">Área restrita ao mestre desta mesa.</div>'); return; }
  var pubs=await pubsDaMesa(id); var sess=await sessoesDaMesa(id);
  var geral=pubs.filter(function(p){return !p.sessao_id;});
  var cardsSess=sess.length?'<div class="cards">'+sess.map(cardSessao).join("")+'</div>':'<div class="empty">Nenhuma sessão ainda — crie a primeira.</div>';
  layout('<div class="bread"><a onclick="go(\'mesa\',\''+id+'\')">‹ '+esc(mesa.nome)+'</a> › Área do Mestre</div>'
    +'<h1>🎭 Área do Mestre — '+esc(mesa.nome)+'</h1>'
    +'<p class="vis-leg">Atrás da tela. O que estiver com visibilidade “só mestre” aqui não aparece para os jogadores.</p>'
    +'<h2>Estrutura & preparação geral</h2><p class="vis-leg">Argumento da campanha e notas que não pertencem a uma sessão específica.</p><p><a class="btn" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'planejamento do mestre\',vis:\'mestre\'})">+ Planejamento geral</a></p>'
    +(geral.length?listar(geral):'<div class="empty">Nada na preparação geral ainda.</div>')
    +'<h2>Sessões</h2><p><a class="btn" onclick="go(\'novaSessao\',\''+id+'\')">+ Nova sessão</a></p>'+cardsSess); }
async function telaSessao(id){ layout('<p>Carregando…</p>'); var se=await umaSessao(id); if(!se){ layout('<div class="aviso">Sessão não encontrada.</div>'); return; }
  var mesa=S.mesas.find(function(m){return m.id===se.mesa_id;}); var ehMestre=!!(mesa&&mestreDe(mesa));
  var pubs=await pubsDaSessao(id);
  var plan=pubs.filter(function(p){return ['mestre','autor_mestre','privado'].indexOf(p.visibilidade)>=0;});
  var publi=pubs.filter(function(p){return ['publico','mesa'].indexOf(p.visibilidade)>=0;});
  var actsM=ehMestre?'<p><a class="btn" onclick="go(\'nova\',{mesa:\''+se.mesa_id+'\',sessao:\''+id+'\',tipo:\'planejamento do mestre\',vis:\'mestre\'})">+ Planejamento</a> <a class="btn sec" onclick="go(\'nova\',{mesa:\''+se.mesa_id+'\',sessao:\''+id+'\',tipo:\'resumo de sessão\',vis:\'mesa\'})">+ Resumo</a> <a class="btn sec" onclick="go(\'editarSessao\',\''+id+'\')">✎ Editar sessão</a> <button class="btn sec" style="border-color:#c08" onclick="excluirSessao(\''+id+'\',\''+se.mesa_id+'\')">🗑 Excluir</button></p>':'';
  layout('<div class="bread"><a onclick="go(\'mesa\',\''+se.mesa_id+'\')">‹ Mesa</a> › Sessão</div>'
    +'<h1>🎲 '+esc(se.titulo)+'</h1>'+(se.data?'<p class="vis-leg">'+esc(se.data)+'</p>':'')+actsM
    +(ehMestre?'<h2>🔒 Planejamento (só o mestre vê)</h2>'+(plan.length?listar(plan):'<div class="empty">Nenhum planejamento nesta sessão ainda.</div>'):'')
    +'<h2>Resumos & público</h2>'+(publi.length?listar(publi):'<div class="empty">Nenhum resumo publicado nesta sessão ainda.</div>')); }
function formSessao(mesaId, se){ return '<div class="bread">'+(se?'Editar sessão':'Nova sessão')+'</div><h1>🎲 '+(se?'Editar sessão':'Nova sessão')+'</h1>'
  +'<div class="form"><label>Título</label><input id="se_titulo" value="'+esc(se?se.titulo:"")+'" placeholder="Ex.: Sessão 1 — Ecos na Cidade dos Corvos">'
  +'<div class="row"><div><label>Ordem (número, opcional)</label><input id="se_ordem" type="number" value="'+esc(se&&se.ordem!=null?se.ordem:"")+'"></div>'
  +'<div><label>Data (opcional)</label><input id="se_data" type="date" value="'+esc(se&&se.data?se.data:"")+'"></div></div>'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarSessao(\''+mesaId+'\','+(se?"'"+se.id+"'":"null")+')">'+(se?'Salvar':'Criar sessão')+'</button> <button class="btn sec" onclick="'+(se?"go('sessao','"+se.id+"')":"go('areaMestre','"+mesaId+"')")+'">Cancelar</button></p></div>'; }
function telaNovaSessao(mesaId){ layout(formSessao(mesaId,null)); }
async function telaEditarSessao(id){ layout('<p>Carregando…</p>'); var se=await umaSessao(id); if(!se){layout('<div class="aviso">Sem permissão.</div>');return;} layout(formSessao(se.mesa_id,se)); }
async function salvarSessao(mesaId, editId){ try{ var t=val("se_titulo").trim(); if(!t)return erro("Dê um título à sessão."); var ord=val("se_ordem").trim(); var dt=val("se_data").trim();
  var reg={ titulo:t, ordem:(ord!==""?parseInt(ord,10):null), data:(dt||null) };
  if(editId){ var u=await sb.from("sessoes").update(reg).eq("id",editId); if(u.error)throw u.error; go("sessao",editId); }
  else { reg.mesa_id=mesaId; var r=await sb.from("sessoes").insert(reg).select().single(); if(r.error)throw r.error; go("sessao",r.data.id); }
}catch(e){erro(e);} }
async function excluirSessao(id,mesaId){ if(!confirm("Excluir esta sessão? O conteúdo dela não é apagado, só desvinculado."))return; try{ var r=await sb.from("sessoes").delete().eq("id",id); if(r.error)throw r.error; go("areaMestre",mesaId); }catch(e){erro(e);} }
// ===== Links wiki + busca global =====
async function irPorTitulo(t){ t=(t||"").trim(); if(!t||!S.mundo){ if(t) go("busca",t); return; }
  try{
    var p=await sb.from("publicacoes").select("id").eq("mundo_id",S.mundo.id).ilike("titulo",t).limit(1);
    if(p.data&&p.data.length){ go("pub",p.data[0].id); return; }
    var c=await sb.from("personagens").select("id").eq("mundo_id",S.mundo.id).ilike("nome",t).limit(1);
    if(c.data&&c.data.length){ go("personagem",c.data[0].id); return; }
    var j=await sb.from("jornais").select("id").eq("mundo_id",S.mundo.id).ilike("nome",t).limit(1);
    if(j.data&&j.data.length){ go("jornal",j.data[0].id); return; }
    go("busca",t);
  }catch(e){ go("busca",t); } }
async function telaBusca(q){ if(!S.mundo){go("mundos");return;} q=(q||"").trim();
  layout('<div class="bread">Busca</div><h1>🔎 Buscar em '+esc(S.mundo.nome)+'</h1><input class="expq" id="buscaq" value="'+esc(q)+'" placeholder="Digite e tecle Enter…" onkeydown="if(event.key===\'Enter\')go(\'busca\',this.value)"><div id="buscares"><p class="vis-leg">'+(q?'Buscando…':'Digite algo para buscar.')+'</p></div>');
  var inp=document.getElementById("buscaq"); if(inp){ inp.focus(); inp.setSelectionRange(inp.value.length,inp.value.length); }
  if(!q) return;
  var ql=q.replace(/[%,()*]/g," ").trim(); var like="%"+ql+"%";
  var pr=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).or("titulo.ilike."+like+",corpo.ilike."+like).limit(40);
  var cr=await sb.from("personagens").select("*").eq("mundo_id",S.mundo.id).ilike("nome",like).limit(24);
  var jr=await sb.from("jornais").select("*").eq("mundo_id",S.mundo.id).ilike("nome",like).limit(24);
  var pubs=(pr.data||[]), pers=(cr.data||[]), jors=(jr.data||[]); var html="";
  if(pubs.length) html+='<h2>Conteúdos <span class="vis-leg">('+pubs.length+')</span></h2><div class="cards">'+pubs.map(cardPub).join("")+'</div>';
  if(pers.length) html+='<h2>Personagens <span class="vis-leg">('+pers.length+')</span></h2><div class="cards">'+pers.map(cardPersonagem).join("")+'</div>';
  if(jors.length) html+='<h2>Jornais <span class="vis-leg">('+jors.length+')</span></h2><div class="cards">'+jors.map(cardJornal).join("")+'</div>';
  if(!html) html='<div class="empty">Nada encontrado para “'+esc(q)+'”.</div>';
  var box=document.getElementById("buscares"); if(box) box.innerHTML=html; }
// ===== Linha do tempo do mundo =====
async function eventosMundo(){ if(!S.mundo)return []; var r=await sb.from("eventos").select("*").eq("mundo_id",S.mundo.id).order("ordem",{nullsFirst:false}).order("criado_em"); return r.error?[]:(r.data||[]); }
async function umEvento(id){ var r=await sb.from("eventos").select("*").eq("id",id).maybeSingle(); return r.data; }
async function telaLinhaTempo(){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var evs=await eventosMundo();
  var criar=S.user?'<a class="btn" onclick="go(\'novoEvento\')">+ Novo evento</a>':'';
  var tl=evs.length?'<div class="tl">'+evs.map(function(e){ var podeE=S.user&&(donoMundo()||e.autor_id===S.user.id); return '<div class="tl-item"><span class="tl-dot" style="background:'+esc(e.cor||"#7c1c14")+'"></span><div class="tl-card">'+(e.quando?'<div class="tl-quando">'+esc(e.quando)+'</div>':'')+'<h3>'+esc(e.titulo)+'</h3>'+(e.descricao?'<div class="corpo" style="font-size:16px;max-width:none">'+md(e.descricao)+'</div>':'')+(podeE?'<p class="vis-leg" style="margin:6px 0 0"><a onclick="go(\'editarEvento\',\''+e.id+'\')">✎ editar</a> · <a onclick="excluirEvento(\''+e.id+'\')">🗑 excluir</a></p>':'')+'</div></div>'; }).join("")+'</div>':'<div class="empty">Nenhum acontecimento na linha do tempo ainda.'+(S.user?' Adicione o primeiro.':'')+'</div>';
  layout(hero("🕰 Linha do Tempo — "+S.mundo.nome,"A cronologia do mundo, dos primórdios aos dias atuais", S.mundo.fundo_url, criar)+'<p class="vis-leg">Dica: use o campo “Ordem” para encadear os acontecimentos na sequência certa.</p>'+tl); }
function formEvento(e){ return '<div class="bread"><a onclick="go(\'linha\')">‹ Linha do tempo</a></div><h1>🕰 '+(e?'Editar evento':'Novo evento')+'</h1>'
  +'<div class="form"><label>Título do acontecimento</label><input id="ev_titulo" value="'+esc(e?e.titulo:"")+'">'
  +'<div class="row"><div><label>Quando (texto livre: ano, era…)</label><input id="ev_quando" value="'+esc(e&&e.quando?e.quando:"")+'" placeholder="ex.: Ano 2068"></div>'
  +'<div><label>Ordem (número p/ a sequência)</label><input id="ev_ordem" type="number" value="'+esc(e&&e.ordem!=null?e.ordem:"")+'"></div></div>'
  +'<label>Descrição (Markdown — aceita [[links]] e imagens)</label><textarea id="ev_desc" onpaste="colarImg(event,this)" ondrop="soltarImg(event,this)" ondragover="event.preventDefault()">'+esc(e&&e.descricao?e.descricao:"")+'</textarea>'
  +'<label>Cor do marcador</label><input id="ev_cor" type="color" value="'+esc(e&&e.cor?e.cor:"#7c1c14")+'" style="width:64px;height:36px;padding:2px">'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarEvento('+(e?"'"+e.id+"'":"null")+')">'+(e?'Salvar':'Criar evento')+'</button> <button class="btn sec" onclick="go(\'linha\')">Cancelar</button></p></div>'; }
function telaNovoEvento(){ layout(formEvento(null)); }
async function telaEditarEvento(id){ layout('<p>Carregando…</p>'); var e=await umEvento(id); if(!e){layout('<div class="aviso">Sem permissão.</div>');return;} layout(formEvento(e)); }
async function salvarEvento(editId){ try{ var t=val("ev_titulo").trim(); if(!t)return erro("Dê um título ao evento."); var ord=val("ev_ordem").trim();
  var reg={ titulo:t, quando:(val("ev_quando").trim()||null), ordem:(ord!==""?parseInt(ord,10):null), descricao:val("ev_desc"), cor:(val("ev_cor")||null) };
  if(editId){ var u=await sb.from("eventos").update(reg).eq("id",editId); if(u.error)throw u.error; }
  else { reg.mundo_id=S.mundo.id; reg.autor_id=S.user.id; reg.visibilidade="publico"; reg.estado="publicado"; var r=await sb.from("eventos").insert(reg); if(r.error)throw r.error; }
  go("linha"); }catch(e){erro(e);} }
async function excluirEvento(id){ if(!confirm("Excluir este evento da linha do tempo?"))return; try{ var r=await sb.from("eventos").delete().eq("id",id); if(r.error)throw r.error; go("linha"); }catch(e){erro(e);} }
// ===== Pedidos de acesso (colaboração) =====
async function pedidosPendentes(tipo, alvoId){ var r=await sb.from("pedidos_acesso").select("*").eq("tipo",tipo).eq("alvo_id",alvoId).eq("estado","pendente").order("criado_em"); return r.error?[]:(r.data||[]); }
async function pedirAcesso(tipo, alvoId){ if(!S.user){go("login");return;} try{
  var ex=await sb.from("pedidos_acesso").select("id,estado").eq("tipo",tipo).eq("alvo_id",alvoId).eq("solicitante_id",S.user.id).limit(1);
  if(ex.data&&ex.data.length){ S.msg='<div class="ok">Você já tem um pedido ('+esc(ex.data[0].estado)+') para este item.</div>'; render(); return; }
  var r=await sb.from("pedidos_acesso").insert({tipo:tipo,alvo_id:alvoId,solicitante_id:S.user.id,estado:"pendente"}); if(r.error)throw r.error;
  S.msg='<div class="ok">Pedido de acesso enviado! O criador será avisado para aprovar.</div>'; render();
}catch(e){erro(e);} }
async function renderPedidos(tipo, alvoId, boxId){ var box=document.getElementById(boxId); if(!box)return;
  var ps=await pedidosPendentes(tipo, alvoId); if(!ps.length){ box.innerHTML=""; return; }
  var perf=await perfis(); var nome=function(uid){ var p=perf.find(function(x){return x.id===uid;}); return p?p.nome:"(usuário)"; };
  box.innerHTML='<h4 style="color:var(--sangue)">🔔 Pedidos de acesso ('+ps.length+')</h4><ul class="lista2">'+ps.map(function(p){ return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(p.solicitante_id))+'</span>'+(p.mensagem?'<span class="vis-leg"> — '+esc(p.mensagem)+'</span>':'')+' <button class="btn mini" onclick="aprovarPedido(\''+p.id+'\',\''+tipo+'\',\''+alvoId+'\',\''+p.solicitante_id+'\')">✓ Aprovar</button> <button class="btn mini sec" onclick="recusarPedido(\''+p.id+'\',\''+tipo+'\',\''+alvoId+'\')">recusar</button></li>'; }).join("")+'</ul>'; }
async function aprovarPedido(pid, tipo, alvoId, uid){ try{
  var ins;
  if(tipo==="mundo") ins=await sb.from("mundo_membros").insert({mundo_id:alvoId,user_id:uid,papel:"colaborador"});
  else if(tipo==="mesa") ins=await sb.from("mesa_membros").insert({mesa_id:alvoId,user_id:uid,papel:"jogador"});
  else ins=await sb.from("personagem_contribuidores").insert({personagem_id:alvoId,user_id:uid});
  if(ins.error && ins.error.code!=="23505") throw ins.error;
  var u=await sb.from("pedidos_acesso").update({estado:"aprovado"}).eq("id",pid); if(u.error)throw u.error;
  if(tipo==="mundo"){ renderColabMundo(alvoId); renderPedidos("mundo",alvoId,"pedidosmundo"); }
  else if(tipo==="mesa"){ renderMembros(alvoId); renderPedidos("mesa",alvoId,"pedidosmesa"); }
  else { renderContribPers(alvoId); renderPedidos("personagem",alvoId,"pedidospers"); }
}catch(e){erro(e);} }
async function recusarPedido(pid, tipo, alvoId){ try{ var u=await sb.from("pedidos_acesso").update({estado:"recusado"}).eq("id",pid); if(u.error)throw u.error; var box=tipo==="mundo"?"pedidosmundo":(tipo==="mesa"?"pedidosmesa":"pedidospers"); renderPedidos(tipo,alvoId,box); }catch(e){erro(e);} }
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
  else if(t==="personagem") telaPersonagem(S.view.arg);
  else if(t==="novoPersonagem") telaNovoPersonagem(S.view.arg);
  else if(t==="editarPersonagem") telaEditarPersonagem(S.view.arg);
  else if(t==="jornais") telaJornais();
  else if(t==="jornal") telaJornal(S.view.arg);
  else if(t==="novoJornal") telaNovoJornal();
  else if(t==="editarJornal") telaEditarJornal(S.view.arg);
  else if(t==="creditos") telaCreditos();
  else if(t==="busca") telaBusca(S.view.arg);
  else if(t==="linha") telaLinhaTempo();
  else if(t==="novoEvento") telaNovoEvento();
  else if(t==="editarEvento") telaEditarEvento(S.view.arg);
  else if(t==="areaMestre") telaMestre(S.view.arg);
  else if(t==="sessao") telaSessao(S.view.arg);
  else if(t==="novaSessao") telaNovaSessao(S.view.arg);
  else if(t==="editarSessao") telaEditarSessao(S.view.arg);
  else telaHome();
}
function toggleUserMenu(e){ if(e)e.stopPropagation(); var m=document.getElementById("usermenu"); if(m) m.classList.toggle("aberto"); }
function toggleWorldMenu(e){ if(e)e.stopPropagation(); var w=document.getElementById("worldmenu"); if(w) w.classList.toggle("aberto"); }
document.addEventListener("click", function(e){ var wl=(e.target&&e.target.closest)?e.target.closest(".wikilink"):null; if(wl){ e.preventDefault(); irPorTitulo(wl.getAttribute("data-alvo")); } var m=document.getElementById("usermenu"); if(m) m.classList.remove("aberto"); var w=document.getElementById("worldmenu"); if(w) w.classList.remove("aberto"); });
init();
