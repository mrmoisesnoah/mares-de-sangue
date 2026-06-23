var sb = supabase.createClient(window.SUPA.url, window.SUPA.anon);
var app = document.getElementById("app");
var S = { user:null, profile:null, mundo:null, mundos:[], mesas:[], view:{t:"home"}, msg:"", pubAtual:null, nomes:{}, tags:{},
          expl:{pubs:[],q:"",cat:null}, modo:(localStorage.getItem("mds_modo")||"cards") };

function esc(s){ s=(s==null?"":""+s); return s.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;"); }
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
function toast(msg,tipo){ var c=document.getElementById("toasts"); if(!c){ c=document.createElement("div"); c.id="toasts"; document.body.appendChild(c); } var t=document.createElement("div"); t.className="toast"+(tipo==="erro"?" toast-erro":(tipo==="ok"?" toast-ok":"")); t.textContent=msg; c.appendChild(t); setTimeout(function(){ t.classList.add("saindo"); setTimeout(function(){ if(t.parentNode)t.remove(); },360); },3500); }
function erro(e){ toast(e&&e.message?e.message:(""+e),"erro"); }
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
var ICON_SEC={"Cânone do Mundo":icon("scroll-unfurled"),"Textos Históricos & Lore":icon("book-cover"),"Eventos & Eras":icon("sands-of-time"),"Lugares":icon("castle"),"Facções, Organizações & Religiões":icon("crossed-swords"),"Jornais":icon("scroll-unfurled"),"Contos e Narrativas":icon("open-book"),"Mapas":icon("treasure-map"),"Criaturas":icon("hooded-figure"),"Itens":icon("crossed-swords"),"Personagens & Histórias":icon("person"),"Sessões & Crônicas":icon("dice-twenty-faces-twenty"),"🔒 Planejamento do Mestre":icon("drama-masks"),"Anotações privadas":icon("tied-scroll"),"Outros":icon("book-cover")};
function iconeTipo(t){ t=(t||"").toLowerCase();
  if(t==="mapa")return icon("treasure-map"); if(t==="jornal")return icon("scroll-unfurled"); if(ehPersonagem(t))return icon("hooded-figure");
  if(t==="conto")return icon("open-book"); if(t==="cidade"||t==="local"||t==="reino"||t==="região")return icon("castle"); if(t==="criatura")return icon("hooded-figure"); if(t==="item")return icon("crossed-swords"); if(t==="evento histórico"||t==="facção")return icon("crossed-swords"); if(t==="história do mundo")return icon("book-cover"); return icon("scroll-unfurled"); }
function thumb(url, icone, alt){ return url ? '<div class="thumb"><img loading="lazy" decoding="async" src="'+esc(url)+'" alt="'+esc(alt||"")+'"></div>' : '<div class="thumb noimg" role="img" aria-label="'+esc(alt||"sem imagem")+'">'+(icone||"📜")+'</div>'; }
function cardPub(p){
  return '<div class="card clic" onclick="go(\'pub\',\''+p.id+'\')">'+thumb(p.capa_url, iconeTipo(p.tipo), p.titulo)
    +'<h3>'+esc(p.titulo)+'</h3>'
    +'<p style="margin:.2em 0"><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="chip-rascunho">'+icon("quill-ink")+' rascunho</span>':'')+'</p>'
    +'<p class="res">'+esc(resumo(p.corpo))+'</p></div>';
}
function itemLista(p){
  return '<li class="li-clic" onclick="go(\'pub\',\''+p.id+'\')"><span class="li-ic">'+iconeTipo(p.tipo)+'</span>'
    +'<span class="li-tit">'+esc(p.titulo)+'</span><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+'</li>';
}
function listar(pubs){ return S.modo==="lista" ? '<ul class="lista2">'+pubs.map(itemLista).join("")+'</ul>' : '<div class="cards">'+pubs.map(cardPub).join("")+'</div>'; }
function hero(titulo, sub, fundo, acts, ico){
  return '<div class="hero2">'+(fundo?'<div class="bg" style="background-image:url('+esc(fundo)+')"></div>':'')+'<div class="ov"></div>'
    +'<div class="in"><h1>'+(ico?ico+' ':'')+esc(titulo)+'</h1>'+(sub?'<p>'+esc(sub)+'</p>':'')+(acts?'<div class="acts">'+acts+'</div>':'')+'</div></div>';
}
function secHead(ic, titulo, n, acao){ return '<div class="sec-head"><h2>'+ic+' '+esc(titulo)+(n!=null?' <span class="sec-ct">'+n+'</span>':'')+'</h2>'+(acao?'<div class="sec-acts">'+acao+'</div>':'')+'</div>'; }
function toggleModo(){ S.modo=(S.modo==="cards"?"lista":"cards"); localStorage.setItem("mds_modo",S.modo); renderExpl(); }
function toggleMenu(){ var l=document.querySelector(".lateral"); if(l) l.classList.toggle("aberta"); }

// ===== Explorador =====
function abrirExplorador(pubs){ regTags(pubs); S.expl={pubs:pubs,q:"",cat:null}; }
function exploradorHTML(){
  return '<div class="expbar"><input class="expq" id="expq" placeholder="🔎 Filtrar por título, tag ou texto…" oninput="explBusca(this.value)">'
    +'</div>'
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
    S.mundos=m.data||[]; S.mundo=mundoSalvo()||S.mundos[0]||null;
    if(S.mundo) await carregarMesas();
    await carregarFavs(); await carregarNotifs();
    rota();
  }catch(e){ erro(e); }
}
async function carregarPublico(){
  try{ S.user=null; S.profile=null; S.mesas=[]; S.favs={}; S.notifs=[];
    var m=await sb.from("mundos").select("*").eq("publico",true).order("criado_em");
    S.mundos=m.data||[]; S.mundo=mundoSalvo()||S.mundos[0]||null; if(S.mundo) await carregarMesas(); rota();
  }catch(e){ erro(e); }
}
function mundoSalvo(){ try{ var id=localStorage.getItem("mds_mundo"); return id?S.mundos.find(function(w){return w.id===id;}):null; }catch(e){ return null; } }
async function selecionarMundo(id){ S.mundo=S.mundos.find(function(w){return w.id===id;})||S.mundo; try{localStorage.setItem("mds_mundo",id);}catch(e){} await carregarMesas(); await carregarFavs(); go("mundoHome"); }
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
  if(S.view.t==="home"){ var ng='<a class="nav-home on" onclick="go(\'home\')">⌂ Início</a>'; if(S.mundos.length){ ng+='<h4>Mundos</h4>'+S.mundos.map(function(w){return '<a onclick="selecionarMundo(\''+w.id+'\')">'+icon("castle")+' '+esc(w.nome)+'</a>';}).join(""); } if(S.user){ ng+='<a onclick="go(\'favoritos\')">★ Favoritos</a><h4>Criar</h4><a onclick="go(\'novoMundo\')">+ Criar mundo</a>'; } return ng; }
  var nav='<a class="nav-home"'+on("home")+' onclick="go(\'home\')">'+ic("inicio")+' Início</a>';
  if(S.mundo){
    nav+='<a'+(S.view.t==="mundoHome"?' class="on"':'')+' onclick="go(\'mundoHome\')">'+ic("mundo")+' Home do mundo</a>';
    nav+='<a'+on("busca")+' onclick="go(\'busca\',\'\')">'+ic("buscar")+' Buscar</a>';
    nav+='<a'+on("lore")+' onclick="go(\'lore\')">'+ic("enc")+' Enciclopédia</a>';
    nav+='<a'+on("mapas")+' onclick="go(\'mapas\')">'+ic("mapas")+' Mapas</a>';
    nav+='<a class="destaque'+(S.view.t==="jornais"?' on':'')+'" onclick="go(\'jornais\')">'+ic("jornais")+' Jornais</a>';
    nav+='<a'+(S.view.t==="linha"&&!S.view.arg?' class="on"':'')+' onclick="go(\'linha\')">'+ic("linha")+' Linha do tempo</a>';
    nav+='<a onclick="go(\'pers\',\'jog\')">'+ic("persJog")+' Personagens dos Jogadores</a>';
    nav+='<a onclick="go(\'pers\',\'mes\')">'+ic("persMes")+' Personagens do Mestre</a>';
    if(S.mesas.length){ nav+='<h4>Mesas</h4>'+S.mesas.map(function(m){return '<a'+(S.view.arg===m.id&&(S.view.t==="mesa"||S.view.t==="linha")?' class="on"':'')+' onclick="go(\'mesa\',\''+m.id+'\')">'+ic("mesa")+' '+esc(m.nome)+'</a>';}).join(""); }
    var mestreMesas=S.mesas.filter(mestreDe);
    if(mestreMesas.length){ nav+='<h4>'+ic("mestre")+' Área do Mestre</h4>'+mestreMesas.map(function(m){return '<a'+(S.view.t==="areaMestre"&&S.view.arg===m.id?' class="on"':'')+' onclick="go(\'areaMestre\',\''+m.id+'\')">'+ic("mestre")+' '+esc(m.nome)+'</a>';}).join(""); }
    if(S.user){
      nav+='<a'+(S.view.t==="favoritos"?' class="on"':'')+' onclick="go(\'favoritos\')">'+ic("fav")+' Favoritos</a><h4>Criar</h4><a onclick="go(\'nova\',{mesa:null})">+ Conteúdo do mundo</a><a onclick="go(\'novoPersonagem\',{mesa:null})">+ Personagem</a><a onclick="go(\'novoJornal\')">+ Jornal</a><a onclick="go(\'novaMesa\')">+ Mesa</a>';
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
      +'<div class="user-menu" id="usermenu"><a onclick="go(\'autor\',\''+S.user.id+'\')">👤 Minha página</a><a onclick="go(\'perfil\')">'+icon("quill-ink")+' Editar perfil</a>'
      +'<div class="sep"></div><a onclick="go(\'mundos\')">🔄 Trocar de mundo</a><div class="sep"></div><a onclick="sair()">↩ Sair</a></div>';
  } else { ub='<button class="btn mini" onclick="go(\'login\')">Entrar</button>'; }
  app.innerHTML='<header class="topo"><button id="btn-menu" aria-label="Abrir menu" onclick="toggleMenu()">☰</button>'
    +'<div class="marca" onclick="go(\'home\')">'+temaIcone(S.mundo&&S.mundo.tema)+' <span class="marca-tx">Mares de Sangue</span></div>'+pill+(S.mundo?'<input class="topo-busca" placeholder="🔎 Buscar no mundo…" onkeydown="if(event.key===\'Enter\')go(\'busca\',this.value)">':'')
    +'<div class="userbox">'+modoBtnHTML()+(S.user?bellHTML():'')+ub+'</div></header>'
    +'<div class="layout"><aside class="lateral">'+sidebar()+'</aside><main class="conteudo">'+S.msg+conteudo+'</main></div>'+'<footer class="rodape">© '+(new Date().getFullYear())+' <b>Moisés Noah</b> · uma produção <b>TOGA</b> — The Older Gods Adventures · <a onclick="go(\'guia\')">📖 Guia de uso</a> · <a onclick="go(\'creditos\')">Créditos & atribuições</a></footer>';
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
  var topo=hero("Mares de Sangue","Plataforma para Criação de Mundos — uma produção TOGA, The Older Gods Adventures", "https://niepiaiwusptmwepgmlq.supabase.co/storage/v1/object/public/midias/c3ed4547-f032-47f6-8650-360684451acc/1781893414276-gemini-25-flash-image-agora-faca-uma-ultima-versao-no-estilo-alan-lee-e-nao-deixe-um-brazao-no-bar-0jpg.jpg", (S.user?botoesCriar():'<a class="btn" onclick="go(\'login\')">Entrar</a>'));
  var mundoCards=S.mundos.map(function(w){return '<div class="card clic" onclick="selecionarMundo(\''+w.id+'\')">'+thumb(w.capa_url||w.fundo_url,icon("castle"),w.nome)+'<h3>'+esc(w.nome)+'</h3><p class="res">'+esc(w.descricao||"")+'</p></div>';}).join("");
  var mundosHtml='<h2>'+icon("castle")+' Escolha um mundo</h2><p class="vis-leg" style="margin-top:-6px">Clique em um mundo para entrar nele.</p>'+(mundoCards?'<div class="cards">'+mundoCards+'</div>':'<div class="empty">'+(S.user?'Nenhum mundo ainda — crie o primeiro acima.':'Nenhum mundo público disponível.')+'</div>');
  var rec=visitasRecentes();
  var contHtml=(S.user&&rec.length)?'<h2>↩ Continuar de onde parou</h2><div class="cards">'+rec.map(function(v){var rta={publicacao:"pub",personagem:"personagem",jornal:"jornal",mesa:"mesa"}[v.tipo]||"pub"; var ica={publicacao:"📄",personagem:"🧝",jornal:"📰",mesa:"⚔"}[v.tipo]||"📄"; return '<div class="card clic" onclick="go(\''+rta+'\',\''+v.id+'\')"><div class="dash-ic">'+ica+'</div><h3>'+esc(v.titulo||"(sem título)")+'</h3><p class="res">'+(v.mundoNome?esc(v.mundoNome)+' · ':'')+esc(v.tipo)+'</p></div>';}).join("")+'</div>':'';
  var favHtml=S.user?'<p style="margin-top:12px"><a class="btn sec" onclick="go(\'favoritos\')">★ Meus favoritos</a></p>':'';
  var nov=await novidadesGlobais();
  var novHtml=nov.length?'<h2>'+icon("ringing-bell")+' Novidades na plataforma</h2><p class="vis-leg" style="margin-top:-6px">As publicações mais recentes que você tem permissão para ver.</p>'+listar(nov):'';
  layout(topo+mundosHtml+favHtml+contHtml+novHtml);
}
async function novidadesGlobais(){ var r=await sb.from("publicacoes").select("*").order("criado_em",{ascending:false}).limit(8); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
function botoesCriarMundo(){ if(!S.user) return '<a class="btn" onclick="go(\'login\')">Entrar para criar</a>'; return '<a class="btn" onclick="go(\'novaMesa\')">+ Criar Mesa</a> <a class="btn sec" onclick="go(\'novoPersonagem\',{mesa:null})">+ Criar Personagem</a>'; }
async function telaMundoHome(){ if(!S.mundo){ go("home"); return; } layout('<p>Carregando…</p>');
  var lore=await loreDoMundo(); var recs=await recentes();
  var nMesas=S.mesas.length, nLore=lore.length, nMapas=lore.filter(function(p){return p.tipo==="mapa";}).length;
  var heroDash=hero(S.mundo.nome, S.mundo.descricao||"Plataforma para Criação de Mundos — uma produção TOGA", S.mundo.fundo_url, botoesCriarMundo()+(donoMundo()?' <a class="btn sec" onclick="go(\'editarMundo\')">'+icon("quill-ink")+' Editar mundo</a>':''));
  function dcard(ic,nm,ds,ac){ return '<div class="card clic dash" onclick="'+ac+'"><div class="dash-ic">'+ic+'</div><h3>'+nm+'</h3><p class="res">'+ds+'</p></div>'; }
  var rec=visitasRecentes(S.mundo.id);
  var contHtml=rec.length?'<h2>↩ Continuar de onde parou</h2><div class="cards">'+rec.map(function(v){var rta={publicacao:"pub",personagem:"personagem",jornal:"jornal",mesa:"mesa"}[v.tipo]||"pub"; var ica={publicacao:"📄",personagem:"🧝",jornal:"📰",mesa:"⚔"}[v.tipo]||"📄"; return '<div class="card clic" onclick="go(\''+rta+'\',\''+v.id+'\')"><div class="dash-ic">'+ica+'</div><h3>'+esc(v.titulo||"(sem título)")+'</h3><p class="res">'+esc(v.tipo)+'</p></div>';}).join("")+'</div>':'';
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › '+esc(S.mundo.nome)+'</div>'+heroDash
    +'<div class="stats"><div class="stat"><b>'+nLore+'</b><span>artigos</span></div><div class="stat"><b>'+nMesas+'</b><span>mesas</span></div><div class="stat"><b>'+nMapas+'</b><span>mapas</span></div></div>'+contHtml
    +(S.user&&!donoMundo()?'<p><a class="btn sec" onclick="pedirAcesso(\'mundo\',\''+S.mundo.id+'\')">🔑 Pedir acesso para colaborar</a></p>':'')+'<h2>Explorar o mundo</h2><div class="cards">'
      +dcard(ic("enc"),"Enciclopédia","Conhecimento público do mundo","go(\'lore\')")
      +dcard(ic("linha"),"Linha do tempo","A cronologia dos acontecimentos","go(\'linha\')")
      +dcard(ic("persJog"),"Personagens","Heróis, NPCs e histórias","go(\'pers\',\'jog\')")
      +dcard(ic("jornais"),"Jornais","Periódicos e notícias","go(\'jornais\')")
      +dcard(ic("mapas"),"Mapas","Cartografia do cenário","go(\'mapas\')")
      +dcard(ic("buscar"),"Buscar","Procurar em tudo","go(\'busca\',\'\')")
      +(S.user?dcard(ic("fav"),"Favoritos","Seus conteúdos marcados","go(\'favoritos\')"):'')
    +'</div>'
    +(S.mesas.length?'<h2>'+(S.user?'Suas mesas':'Mesas e Campanhas')+'</h2><div class="cards">'+S.mesas.map(function(m){return '<div class="card clic" onclick="go(\'mesa\',\''+m.id+'\')">'+thumb(m.capa_url||m.fundo_url,icon("crossed-swords"),m.nome)+'<h3>'+esc(m.nome)+'</h3><p class="res">'+esc(m.descricao||"")+'</p></div>';}).join("")+'</div>':'')
    +(recs.length?'<h2>Novidades — adições recentes</h2>'+listar(recs):''));
}
async function telaMundos(){
  var cards=S.mundos.map(function(w){return '<div class="card clic'+(S.mundo&&w.id===S.mundo.id?' sel':'')+'" onclick="selecionarMundo(\''+w.id+'\')">'+thumb(w.capa_url||w.fundo_url,icon("castle"),w.nome)+'<h3>'+esc(w.nome)+'</h3><p class="res">'+esc(w.descricao||"")+'</p></div>';}).join("");
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mundos</div><h1>'+icon("castle")+' Mundos</h1>'
    +(S.user?'<p><a class="btn" onclick="go(\'novoMundo\')">+ Criar Mundo</a></p>':'')
    +'<div class="cards">'+(cards||'<div class="empty">Nenhum mundo.</div>')+'</div>');
}
async function telaLore(){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var lore=await loreDoMundo(); abrirExplorador(lore);
  layout(hero("Enciclopédia de "+S.mundo.nome,"Filtre por categoria, busque, alterne cards/lista", S.mundo.fundo_url, (S.user?'<a class="btn" onclick="go(\'nova\',{mesa:null})">+ Novo conteúdo</a>':''))+exploradorHTML()); renderExpl(); }
async function telaMapas(){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var lore=await loreDoMundo(); var mp=lore.filter(function(p){return p.tipo==="mapa";});
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mapas</div><h1>'+icon("treasure-map")+' Mapas</h1>'
    +(S.user?'<p><a class="btn" onclick="go(\'nova\',{mesa:null,tipo:\'mapa\'})">+ Novo mapa</a></p>':'')
    +(mp.length?listar(mp):'<div class="empty">Nenhum mapa visível ainda.</div>')); }
async function telaPers(qual){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>');
  var todos=await personagensMundo(); var dono=S.mundo.dono_id;
  var lista=(qual==="mes")?todos.filter(function(c){return c.tipo==="npc";}):todos.filter(function(c){return c.tipo!=="npc";});
  var titulo=(qual==="mes")?icon("drama-masks")+" Personagens do Mestre (NPCs)":icon("person")+" Personagens dos Jogadores";
  var criar=S.user?'<p><a class="btn" onclick="go(\'novoPersonagem\',{mesa:null,tp:\''+(qual==="mes"?"npc":"jogador")+'\'})">+ Novo '+(qual==="mes"?"NPC":"personagem")+'</a></p>':'';
  var cards=lista.length?gridPersRound(lista):'<div class="empty">Nenhum personagem ainda.</div>';
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Personagens</div><h1>'+titulo+'</h1>'
    +'<p class="vis-leg">Clique num personagem para ver o perfil e todo o conteúdo ligado a ele.</p>'+criar+cards); }
async function telaMesa(id){ layout('<p>Carregando…</p>'); var mesa=S.mesas.find(function(m){return m.id===id;});
  if(!mesa){ layout('<div class="aviso">Mesa não encontrada (ou você não é membro).</div>'); return; } registrarVisita("mesa",id,mesa.nome);
  var pubs=await pubsDaMesa(id); var sess=await sessoesDaMesa(id); var pers=await personagensDaMesa(id);
  var mapas=pubs.filter(function(p){return p.tipo==="mapa";}); var semMapa=pubs.filter(function(p){return p.tipo!=="mapa";}); var autoMural=semMapa.filter(function(p){return !p.sessao_id && (p.visibilidade==="publico"||p.visibilidade==="mesa");}); var outros=semMapa.filter(function(p){return !p.sessao_id && !(p.visibilidade==="publico"||p.visibilidade==="mesa");}); abrirExplorador(outros); var _pins=await sb.from("mural_pins").select("alvo_id").eq("mesa_id",id).eq("tipo","publicacao"); var pinIds=(_pins.data||[]).map(function(x){return x.alvo_id;}); var pinnedPubs=[]; if(pinIds.length){ var _pp=await sb.from("publicacoes").select("*").in("id",pinIds); pinnedPubs=_pp.error?[]:(_pp.data||[]); } var _mm={}; autoMural.concat(pinnedPubs).forEach(function(p){_mm[p.id]=p;}); var mural=Object.keys(_mm).map(function(k){return _mm[k];});
  var ehM=mestreDe(mesa);
  var acts=S.user?('<a class="btn" onclick="go(\'nova\',{mesa:\''+id+'\'})">+ Conteúdo</a> '
    +'<a class="btn sec" onclick="go(\'linha\',\''+id+'\')">'+ic("linha")+' Linha do tempo</a>'
    +(ehM?' <a class="btn sec" onclick="go(\'areaMestre\',\''+id+'\')">'+icon("drama-masks")+' Área do Mestre</a> <a class="btn sec" onclick="go(\'editarMesa\',\''+id+'\')">'+icon("quill-ink")+' Editar mesa</a>':'')+(S.user?' '+botaoFav("mesa",id,mesa.nome):'')):'';
  var metaHtml=(mesa.epoca||mesa.local)?'<p class="meta-mesa">'+(mesa.epoca?'🕰 '+esc(mesa.epoca):'')+(mesa.epoca&&mesa.local?' · ':'')+(mesa.local?'📍 '+esc(mesa.local):'')+'</p>':'';
  var pedir=(S.user&&!ehM)?'<p><a class="btn sec" onclick="pedirAcesso(\'mesa\',\''+id+'\')">🔑 Pedir acesso a esta mesa</a></p>':'';
  var secPers='<div class="secao">'+secHead(icon("hooded-figure"),"Personagens da mesa",pers.length,(S.user?'<a class="btn mini sec" onclick="go(\'novoPersonagem\',{mesa:\''+id+'\'})">+ Personagem</a>':''))+(pers.length?'<div class="pers-circ-grid">'+pers.map(cardPersonagemRound).join("")+'</div>':'<div class="empty">Nenhum personagem nesta mesa ainda.</div>')+'</div>';
  var secMural=(S.user||mural.length)?'<div class="secao mural-sec">'+secHead(icon("position-marker"),"Mural da Campanha",mural.length,(S.user?'<a class="btn mini" onclick="go(\'nova\',{mesa:\''+id+'\',vis:\'mesa\'})">+ Postar para os jogadores</a>':''))+'<p class="vis-leg" style="margin-top:-6px">Avisos, resumos e materiais que o mestre disponibiliza para os jogadores.</p>'+(mural.length?'<div class="mural">'+mural.map(function(mp){return muralItem(mp,id,ehM&&pinIds.indexOf(mp.id)>=0);}).join("")+'</div>':'<div class="empty">Nada no mural ainda.</div>')+'</div>':'';
  var secMapas='<div class="secao">'+secHead(icon("treasure-map"),"Mapas da mesa",mapas.length,(S.user?'<a class="btn mini sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'mapa\'})">+ Mapa</a>':''))+(mapas.length?'<div class="cards">'+mapas.map(cardPub).join("")+'</div>':'<div class="empty">Nenhum mapa nesta mesa ainda.</div>')+'</div>';
  var secSess='<div class="secao">'+secHead(icon("dice-twenty-faces-twenty"),"Sessões",sess.length,(ehM?'<a class="btn mini sec" onclick="go(\'areaMestre\',\''+id+'\')">'+icon("drama-masks")+' Gerir sessões</a>':''))+(sess.length?'<div class="cards">'+sess.map(cardSessao).join("")+'</div>':'<div class="empty">Nenhuma sessão registrada ainda.</div>')+'</div>';
  var secOutros=outros.length?'<div class="secao">'+secHead(icon("book-cover"),"Outros conteúdos",outros.length,"")+exploradorHTML()+'</div>':'';
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mesa</div>'+hero(mesa.nome, mesa.descricao||"", mesa.fundo_url, acts, icon("crossed-swords"))+metaHtml+pedir+secPers+secMural+secMapas+secSess+secOutros); renderExpl(); }
async function telaAutor(uid){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var pf=await perfilDe(uid); var nome=pf.nome||"Autor"; var pubs=await pubsDoAutor(uid); abrirExplorador(pubs);
  var ehEu=(S.user&&uid===S.user.id);
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › '+(ehEu?"Minha página":"Autor")+'</div>'
    +'<div class="autor-cap">'+(pf.avatar_url?'<div class="av" style="background-image:url('+esc(pf.avatar_url)+')"></div>':'<div class="av">'+esc((nome||"?")[0].toUpperCase())+'</div>')+'<div><h1 style="margin:0">'+esc(nome)+'</h1>'+(pf.epiteto?'<p class="vis-leg" style="font-style:italic;margin:.1em 0">'+esc(pf.epiteto)+'</p>':'')+'<p class="vis-leg">'+pubs.length+' publicações visíveis neste mundo'+(ehEu?" · sua página de trabalho (vê também rascunhos e privados)":" · página pública")+(ehEu?' · <a onclick="go(\'perfil\')">'+icon("quill-ink")+' editar perfil</a>':'')+'</p></div></div>'+(pf.bio?'<div class="corpo" style="max-width:760px;margin:6px 0 14px">'+md(pf.bio)+'</div>':'')
    +(ehEu?'<p><a class="btn" onclick="go(\'nova\',{mesa:null})">+ Novo conteúdo</a></p>':'')+exploradorHTML()); renderExpl(); }
async function telaPub(id){ layout('<p>Carregando…</p>'); var p=await umaPub(id); S.pubAtual=p; if(p)registrarVisita("publicacao",p.id,p.titulo);
  if(!p){ layout('<div class="aviso">Publicação não encontrada ou sem permissão.</div>'); return; }
  var nomeAutor=await nomeDe(p.autor_id); var podeBaixar=meu(p)||donoMundo(); var anexo=p.arquivo_url?'<p class="anexo-bloco">📎 Arquivo anexado: <a class="btn mini" href="'+esc(p.arquivo_url)+'" target="_blank" rel="noopener">↗ Abrir / baixar</a>'+(p.arquivo_nome?' <span class="vis-leg">('+esc(p.arquivo_nome)+')</span>':'')+'</p>':'';
  var pcLink=""; if(p.personagem_id){ var pcx=await umPersonagem(p.personagem_id); if(pcx) pcLink=' · <a onclick="go(\'personagem\',\''+p.personagem_id+'\')">🧝 '+esc(pcx.nome)+'</a>'; }
  var jorLink=""; if(p.jornal_id){ var jx=await umJornal(p.jornal_id); if(jx) jorLink=' · <a onclick="go(\'jornal\',\''+p.jornal_id+'\')">📰 '+esc(jx.nome)+'</a>'; }
  var vejaTb=""; if(p.tags&&p.tags.length){ var vt=await sb.from("publicacoes").select("*").eq("mundo_id",p.mundo_id).overlaps("tags",p.tags).neq("id",p.id).limit(8); if(vt.data&&vt.data.length){ vejaTb='<h2>Veja também</h2>'+listar(vt.data); } }
  var mid=await sb.from("midias").select("*").eq("publicacao_id",id); var media="";
  if(mid.data){ mid.data.forEach(function(m){ media += (m.tipo==="video")?'<p class="vis-leg">🎬 <a href="'+esc(m.url)+'" target="_blank">'+esc(m.legenda||m.url)+'</a></p>':imagemComAcoes(m.url,(m.legenda||""),podeBaixar); }); }
  var voltar = p.mesa_id ? "go('mesa','"+p.mesa_id+"')" : (p.tipo==="mapa"?"go('mapas')":"go('lore')");
  var extra="";
  if(ehPersonagem(p.tipo)){ var outros=(await pubsDoAutor(p.autor_id)).filter(function(x){return x.id!==p.id;});
    if(outros.length){ abrirExplorador(outros); extra='<h2>Mais textos de '+esc(nomeAutor)+'</h2>'+exploradorHTML(); } }
  var acoes='<div class="acoes-pub">'+(podeBaixar?'<button class="btn mini sec" onclick="baixarPdf()">🖨 Imprimir / PDF</button> <button class="btn mini sec" onclick="baixarDoc()">⬇ Word (.doc)</button> ':'')+botaoCompartilhar()+' '+botaoFav("publicacao",p.id,p.titulo)+((S.mesas&&S.mesas.some(mestreDe))?' <button class="btn mini sec" onclick="pinarMural(\''+p.id+'\')">'+icon("position-marker")+' Fixar no Mural</button>':'')
    +(meu(p)?' <a class="btn mini sec" onclick="go(\'editar\',\''+p.id+'\')">'+icon("quill-ink")+' Editar</a> <button class="btn mini sec" style="border-color:#b23b3b" onclick="excluirPub(\''+p.id+'\','+(p.mesa_id?"'"+p.mesa_id+"'":"null")+')">🗑 Excluir</button>':'')+'</div>';
  layout('<div class="bread"><a onclick="'+voltar+'">‹ voltar</a></div><h1>'+esc(p.titulo)+'</h1>'
    +'<p><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="chip-rascunho">'+icon("quill-ink")+' rascunho</span>':'')
    +' &nbsp;<span class="vis-leg">por <a onclick="go(\'autor\',\''+p.autor_id+'\')">'+esc(nomeAutor)+'</a>'+pcLink+jorLink+'</span></p>'
    +tagChips(p.tags)
    +(p.capa_url?imagemComAcoes(p.capa_url,p.titulo,podeBaixar):'')
    +media+anexo+'<div class="corpo">'+md(p.corpo)+'</div>'+vejaTb+acoes+extra+secaoComentarios("publicacao",p.id,p.autor_id));
  if(extra) renderExpl(); renderComentarios("publicacao",p.id); }

// ---------- export ----------
function baixarPdf(){ window.print(); }
function imagemComAcoes(url, alt, podeBaixar){ return '<figure class="img-bloco"><img class="capa" src="'+esc(url)+'" alt="'+esc(alt||"")+'" loading="lazy"><figcaption class="img-acoes"><a class="btn mini sec" href="'+esc(url)+'" target="_blank" rel="noopener">🔍 Abrir original</a>'+(podeBaixar?' <button class="btn mini sec" onclick="baixarImagem(\''+esc(url)+'\')">⬇ Baixar imagem</button>':'')+'</figcaption></figure>'; }
async function baixarImagem(url){ try{ var r=await fetch(url); var b=await r.blob(); var a=document.createElement("a"); a.href=URL.createObjectURL(b); a.download=decodeURIComponent((url.split("/").pop()||"imagem").split("?")[0]); document.body.appendChild(a); a.click(); a.remove(); setTimeout(function(){URL.revokeObjectURL(a.href);},4000); }catch(e){ window.open(url,"_blank"); } }
function baixarDoc(){ var p=S.pubAtual; if(!p)return;
  var html='<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40"><head><meta charset="utf-8"><title>'+esc(p.titulo)+'</title></head><body><h1>'+esc(p.titulo)+'</h1>'+md(p.corpo)+'</body></html>';
  var blob=new Blob(['﻿'+html],{type:"application/msword"});
  var a=document.createElement("a"); a.href=URL.createObjectURL(blob); a.download=slug(p.titulo)+".doc"; document.body.appendChild(a); a.click(); a.remove(); }

// ---------- formulários ----------
var TIPOS=['conto','background','diário de personagem','ficha','personagem','mapa','cidade','facção','região','reino','religião','criatura','item','evento histórico','história do mundo','resumo de sessão','crônica','planejamento do mestre','anotação privada'];
function opt(arr,sel){ return arr.map(function(o){var v,l; if(Array.isArray(o)){v=o[0];l=o[1];}else{v=o;l=o;} return '<option value="'+esc(v)+'"'+(sel===v?' selected':'')+'>'+esc(l)+'</option>';}).join(""); }
function uploadCampo(){ return S.user?'<label>… ou enviar arquivo de imagem</label><input type="file" accept="image/*" onchange="subirCapa(this)"><span id="f_capa_st" class="vis-leg"></span>':''; }
function campoImagem(label, id, valor){ return '<label>'+label+'</label><div class="img-campo"><input id="'+id+'" value="'+esc(valor||"")+'" placeholder="cole o link direto de uma imagem (.jpg .png .webp .gif)">'+(S.user?'<label class="img-up" title="Enviar do computador"><input type="file" accept="image/*" style="display:none" onchange="subirImg(this,&#39;'+id+'&#39;)">📁 Enviar</label>':'')+(S.user?'<button type="button" class="img-up" onclick="abrirCropper(&#39;'+id+'&#39;)" title="Ajustar/recortar enquadramento">✂ Ajustar</button>':'')+'</div><span id="'+id+'_st" class="vis-leg"></span><p class="vis-leg" style="margin:2px 0 0;font-size:12px">Cole o <b>link direto</b> de uma imagem pública (URL terminando em .jpg/.png/.webp/.gif), <b>ou</b> envie um arquivo do computador.</p>'; }
async function subirImg(inp, id){ var fl=inp.files&&inp.files[0]; if(!fl)return; var st=document.getElementById(id+"_st"); if(st)st.textContent="enviando…"; try{ var u=await uploadArquivo(fl); var c=document.getElementById(id); if(c)c.value=u; if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }
function campoArquivo(valorUrl, valorNome){ var nm=esc(valorNome||"").replace(/"/g,"&quot;"); return '<input type="hidden" id="f_arquivo_url" value="'+esc(valorUrl||"")+'"><input type="hidden" id="f_arquivo_nome" value="'+nm+'">'
  +'<div class="arq-campo"><span id="f_arquivo_st" class="arq-nome">'+(valorUrl?('📎 '+esc(valorNome||"arquivo anexado")+' <a href="'+esc(valorUrl)+'" target="_blank" rel="noopener">↗ abrir</a>'):'Nenhum arquivo anexado.')+'</span>'
  +(S.user?'<label class="img-up"><input type="file" accept=".pdf,.doc,.docx,.odt,.rtf,.txt,image/*" style="display:none" onchange="subirArquivoFicha(this)">📎 Anexar arquivo</label>':'')
  +(valorUrl?' <button type="button" class="btn mini sec" onclick="removerArquivoFicha()">remover</button>':'')+'</div>'
  +'<p class="campo-help">Anexe a ficha pronta em PDF/Word (ou imagem). Fica disponível conforme a visibilidade desta publicação.</p>'; }
async function subirArquivoFicha(inp){ var f=inp.files&&inp.files[0]; if(!f)return; var st=document.getElementById("f_arquivo_st"); if(st)st.textContent="enviando…"; try{ var u=await uploadArquivo(f); document.getElementById("f_arquivo_url").value=u; document.getElementById("f_arquivo_nome").value=f.name; if(st)st.innerHTML='📎 '+esc(f.name)+' <a href="'+esc(u)+'" target="_blank" rel="noopener">↗ abrir</a>'; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }
function removerArquivoFicha(){ var u=document.getElementById("f_arquivo_url"); if(u)u.value=""; var n=document.getElementById("f_arquivo_nome"); if(n)n.value=""; var st=document.getElementById("f_arquivo_st"); if(st)st.textContent="Arquivo removido."; }
function datalistTags(){ var ks=Object.keys(S.tags); return '<datalist id="taglist">'+ks.map(function(t){return '<option value="'+esc(t)+'">';}).join("")+'</datalist>'; }
// ===== Toolkit de formulários =====
function fHead(ic,titulo,sub){ return '<div class="form-head"><h1>'+ic+' '+esc(titulo)+'</h1>'+(sub?'<p class="form-sub">'+esc(sub)+'</p>':'')+'</div>'; }
function fGrupo(titulo,html,dica){ return '<fieldset class="form-grupo"><legend>'+esc(titulo)+'</legend>'+(dica?'<p class="grupo-dica">'+esc(dica)+'</p>':'')+html+'</fieldset>'; }
function fCampo(label,html,help){ return '<div class="campo">'+(label?'<label>'+label+'</label>':'')+html+(help?'<p class="campo-help">'+help+'</p>':'')+'</div>'; }
function fAcoes(prim,onPrim,onCancel){ return '<div class="form-acoes"><button class="btn" onclick="'+onPrim+'">'+esc(prim)+'</button> <button class="btn sec" onclick="'+onCancel+'">Cancelar</button></div>'; }
function mdEditor(id,valor){ return '<div class="mded">'
  +'<div class="mded-bar">'
    +'<button type="button" class="mded-b" onmousedown="return false" onclick="mdIns(\''+id+'\',\'**\',\'**\',\'negrito\')" title="Negrito"><b>B</b></button>'
    +'<button type="button" class="mded-b" onmousedown="return false" onclick="mdIns(\''+id+'\',\'*\',\'*\',\'itálico\')" title="Itálico"><i>I</i></button>'
    +'<button type="button" class="mded-b" onmousedown="return false" onclick="mdIns(\''+id+'\',\'## \',\'\',\'Título\')" title="Subtítulo">H</button>'
    +'<button type="button" class="mded-b" onmousedown="return false" onclick="mdIns(\''+id+'\',\'[\',\'](https://)\',\'texto do link\')" title="Link">🔗</button>'
    +'<button type="button" class="mded-b" onmousedown="return false" onclick="mdIns(\''+id+'\',\'- \',\'\',\'item\')" title="Lista">≣</button>'
    +'<button type="button" class="mded-b" onmousedown="return false" onclick="mdIns(\''+id+'\',\'> \',\'\',\'citação\')" title="Citação">❝</button>'
    +'<span class="mded-sp"></span>'
    +'<button type="button" class="mded-b mded-pv" onclick="mdPrev(\''+id+'\')">👁 Pré-visualizar</button>'
  +'</div>'
  +'<textarea id="'+id+'" onpaste="colarImg(event,this)" ondrop="soltarImg(event,this)" ondragover="event.preventDefault()" oninput="mdSync(\''+id+'\')">'+esc(valor||"")+'</textarea>'
  +'<div class="mded-prev corpo" id="'+id+'_prev" style="display:none"></div>'
  +'<p class="campo-help">Markdown: **negrito**, *itálico*, ## subtítulo, [link](url), [[Outro Artigo]]. Arraste ou cole imagens direto no texto.</p>'
  +'</div>'; }
function mdSync(id){ var pv=document.getElementById(id+"_prev"); if(pv&&pv.style.display!=="none"){ var ta=document.getElementById(id); pv.innerHTML=md(ta.value); } }
function mdPrev(id){ var ta=document.getElementById(id),pv=document.getElementById(id+"_prev"); if(!ta||!pv)return; if(pv.style.display==="none"){ pv.innerHTML=md(ta.value); pv.style.display="block"; }else{ pv.style.display="none"; } }
function mdIns(id,pre,suf,ph){ var ta=document.getElementById(id); if(!ta)return; var sst=ta.selectionStart,sen=ta.selectionEnd; var sel=ta.value.slice(sst,sen)||ph; ta.value=ta.value.slice(0,sst)+pre+sel+suf+ta.value.slice(sen); ta.focus(); ta.selectionStart=sst+pre.length; ta.selectionEnd=sst+pre.length+sel.length; mdSync(id); }
function formPub(opts, p){
  var mesaId=opts.mesa||(p?p.mesa_id:null); var tipoSel=(p?p.tipo:opts.tipo)||"conto";
  var emMesa=!!opts.mesa; // veio de uma mesa específica
  var rot=ehPersonagem(tipoSel)?"personagem":(tipoSel==="mapa"?"mapa":(tipoSel==="ficha"?"ficha":"conteúdo"));
  var visOpts=(mesaId)?[["mesa","mesa (todos da campanha)"],["publico","público (todos)"],["autor_mestre","autor + mestre"],["privado","privado (só eu)"],["mestre","só mestre"]]:[["publico","público (todos)"],["privado","privado (só eu)"]];
  var seletorMesa = (!emMesa && S.mesas.length) ? '<label>Mesa (opcional — relacione a uma campanha)</label><select id="f_mesa"><option value="">— sem mesa (adicionar depois) —</option>'+S.mesas.map(function(m){return '<option value="'+m.id+'"'+(p&&p.mesa_id===m.id?' selected':'')+'>'+esc(m.nome)+'</option>';}).join("")+'</select>' : '';
  var seletorPers = (S.meusPers&&S.meusPers.length) ? '<label>Personagem (opcional — ligar a um personagem)</label><select id="f_personagem"><option value="">— nenhum —</option>'+S.meusPers.map(function(pc){return '<option value="'+pc.id+'"'+(((p&&p.personagem_id===pc.id)||(opts.personagem===pc.id))?' selected':'')+'>'+esc(pc.nome)+'</option>';}).join("")+'</select>' : '';
  var seletorJornal = (S.meusJornais&&S.meusJornais.length) ? '<label>Jornal (opcional — publicar por um jornal)</label><select id="f_jornal"><option value="">— nenhum —</option>'+S.meusJornais.map(function(jj){return '<option value="'+jj.id+'"'+(((p&&p.jornal_id===jj.id)||(opts.jornal===jj.id))?' selected':'')+'>'+esc(jj.nome)+'</option>';}).join("")+'</select>' : '';
  var seletorSessao = (mesaId && S.sessoesForm && S.sessoesForm.length) ? '<label>Sessão (opcional)</label><select id="f_sessao"><option value="">— nenhuma / geral —</option>'+S.sessoesForm.map(function(se){return '<option value="'+se.id+'"'+(((p&&p.sessao_id===se.id)||(opts.sessao===se.id))?' selected':'')+'>'+esc(se.titulo)+'</option>';}).join("")+'</select>' : '';
  var head=fHead(icon("quill-ink"),(p?'Editar ':'Novo ')+rot, p?'Atualize os campos abaixo.':'Preencha os campos — só o título é obrigatório.');
  var gClass=fGrupo('Classificação','<label>Tipo de conteúdo</label><select id="f_tipo">'+opt(TIPOS,tipoSel)+'</select>'+seletorMesa+seletorPers+seletorJornal+seletorSessao,'O que é e a que se relaciona (mesa, personagem, jornal, sessão).');
  var gCont=fGrupo('Conteúdo','<label>Título</label><input id="f_titulo" value="'+esc(p?p.titulo:"")+'" placeholder="Nome do '+esc(rot)+'">'+campoImagem('Imagem de capa (opcional)','f_capa',(p&&p.capa_url?p.capa_url:""))+'<label>Texto</label>'+mdEditor('f_corpo',p?p.corpo:"")+'<label>Anexar arquivo (PDF/documento — ideal para fichas)</label>'+campoArquivo(p?p.arquivo_url:"",p?p.arquivo_nome:""));
  var gPub=fGrupo('Publicação','<div class="row"><div><label>Marcadores / tags</label><input id="f_tags" list="taglist" value="'+esc(p&&p.tags?p.tags.join(", "):"")+'" placeholder="vírgula entre as tags">'+datalistTags()+'</div><div><label>Estado</label><select id="f_estado">'+opt([["publicado","publicado"],["rascunho","rascunho"]],p?p.estado:"publicado")+'</select></div><div><label>Visibilidade</label><select id="f_vis">'+opt(visOpts,p?p.visibilidade:(opts.vis||(mesaId?"mesa":"publico")))+'</select></div></div>','Como e para quem aparece. “Rascunho” fica só para você até publicar.');
  var acoes=fAcoes(p?'Salvar':'Criar '+rot,'salvarPub('+(mesaId?"'"+mesaId+"'":"null")+','+(p?"'"+p.id+"'":"null")+','+(emMesa?"true":"false")+')',(mesaId?"go('mesa','"+mesaId+"')":"go('lore')"));
  return '<div class="bread">'+(p?'Editar ':'Novo ')+esc(rot)+'</div><div class="form">'+head+gClass+gCont+gPub+acoes+'</div>';
}
async function telaNova(opts){ opts=opts||{}; S.meusPers=await meusPersonagens(); S.meusJornais=await meusJornais(); if(opts.personagem&&!S.meusPers.some(function(x){return x.id===opts.personagem;})){ var pc=await umPersonagem(opts.personagem); if(pc) S.meusPers=S.meusPers.concat([{id:pc.id,nome:pc.nome}]); } if(opts.jornal&&!S.meusJornais.some(function(x){return x.id===opts.jornal;})){ var jj=await umJornal(opts.jornal); if(jj) S.meusJornais=S.meusJornais.concat([{id:jj.id,nome:jj.nome}]); } S.sessoesForm = opts.mesa? await sessoesDaMesa(opts.mesa) : []; layout(formPub(opts,null)); }
async function telaEditar(id){ layout('<p>Carregando…</p>'); S.meusPers=await meusPersonagens(); S.meusJornais=await meusJornais(); var p=await umaPub(id); if(!p){layout('<div class="aviso">Sem permissão.</div>');return;} S.sessoesForm = p.mesa_id? await sessoesDaMesa(p.mesa_id) : []; layout(formPub({mesa:p.mesa_id},p)); }
function telaNovoMundo(){ layout('<div class="bread">Novo mundo</div><div class="form">'
  +fHead(icon("castle"),'Criar Mundo','Um mundo agrupa toda a sua ambientação, mesas e personagens.')
  +fGrupo('Identidade do mundo','<label>Nome do mundo</label><input id="m_nome" placeholder="Ex.: O Mundo de Skard"><label>Descrição</label>'+mdEditor('m_desc',''))
  +fGrupo('Aparência',campoImagem('Imagem de fundo (hero)','m_fundo',''))
  +fGrupo('Tema visual',seletorTema('m_tema','medieval'),'As cores do mundo. Inspirado no gênero — pode mudar depois.')+fAcoes('Criar mundo','salvarMundo()',"go('home')")+'</div>'); }
function telaNovaMesa(){ layout('<div class="bread">Nova mesa</div><div class="form">'
  +fHead(icon("crossed-swords"),'Criar Mesa','Uma mesa é uma campanha dentro do mundo, com seu próprio tempo e lugar.')
  +fGrupo('Identidade','<label>Nome</label><input id="me_nome" placeholder="Ex.: Ecos na Cidade dos Corvos"><label>Descrição</label>'+mdEditor('me_desc',''))
  +fGrupo('Contexto no mundo','<div class="row"><div><label>Época (opcional)</label><input id="me_epoca" placeholder="ex.: Ano 2068"></div><div><label>Local / região (opcional)</label><input id="me_local" placeholder="ex.: Cidade dos Corvos"></div></div>','Quando e onde esta campanha acontece.')
  +fGrupo('Aparência',campoImagem('Imagem de fundo (opcional)','me_fundo',''))
  +fAcoes('Criar mesa','salvarMesa()',"go('home')")+'</div>'); }
async function telaEditarMundo(){ var w=S.mundo; layout('<div class="bread">Editar mundo</div><div class="form">'
  +fHead(icon("castle"),'Editar mundo','')
  +fGrupo('Identidade do mundo','<label>Nome</label><input id="w_nome" value="'+esc(w.nome)+'"><label>Descrição</label>'+mdEditor('w_desc',w.descricao||""))
  +fGrupo('Aparência',campoImagem('Imagem de fundo (hero)','w_fundo',(w.fundo_url||"")))
  +fGrupo('Tema visual',seletorTema('w_tema',w.tema||'medieval'),'As cores do mundo.')+fAcoes('Salvar','salvarMundoEdit()',"go('mundoHome')")+'</div>'+(ehAdmin()?'<div class="secao zona-perigo"><div class="sec-head"><h2>⚠ Zona de perigo</h2></div><p class="vis-leg" style="margin-top:-6px">Exclusão permanente do mundo e de TODO o conteúdo dentro dele. Só admin.</p><button class="btn btn-perigo" onclick="excluirMundo(\''+w.id+'\')">🗑 Excluir este mundo</button></div>':'')
  +'<h2>Colaboradores do mundo</h2><p class="vis-leg">Quem pode criar conteúdo neste mundo. Você (dono) sempre pode.</p><div id="colabmundo">Carregando…</div><div id="pedidosmundo"></div>');
  renderColabMundo(w.id); renderPedidos("mundo",w.id,"pedidosmundo"); }
async function telaEditarMesa(id){ var m=S.mesas.find(function(x){return x.id===id;}); if(!m){layout('<div class="aviso">Mesa não encontrada.</div>');return;}
  layout('<div class="bread">Editar mesa</div><div class="form">'
  +fHead(icon("crossed-swords"),'Editar mesa','')
  +fGrupo('Identidade','<label>Nome</label><input id="me_nome" value="'+esc(m.nome)+'"><label>Descrição</label>'+mdEditor('me_desc',m.descricao||""))
  +fGrupo('Contexto no mundo','<div class="row"><div><label>Época (opcional)</label><input id="me_epoca" value="'+esc(m.epoca||"")+'" placeholder="ex.: Ano 2068"></div><div><label>Local / região (opcional)</label><input id="me_local" value="'+esc(m.local||"")+'" placeholder="ex.: Cidade dos Corvos"></div></div>')
  +fGrupo('Aparência',campoImagem('Imagem de fundo (opcional)','me_fundo',(m.fundo_url||"")))
  +fAcoes('Salvar',"salvarMesaEdit('"+id+"')","go('mesa','"+id+"')")+'</div>'+(ehAdmin()?'<div class="secao zona-perigo"><div class="sec-head"><h2>⚠ Zona de perigo</h2></div><p class="vis-leg" style="margin-top:-6px">Exclusão permanente da mesa e seu conteúdo. Só admin.</p><button class="btn btn-perigo" onclick="excluirMesa(\''+id+'\')">🗑 Excluir esta mesa</button></div>':'')+'<h2>Jogadores da mesa</h2><p class="vis-leg">Adicione jogadores para que vejam o conteúdo de visibilidade “mesa” e possam contribuir com suas histórias.</p><div id="membros">Carregando…</div><div id="pedidosmesa"></div>'); await renderMembros(id); renderPedidos("mesa",id,"pedidosmesa"); }
async function renderMembros(id){
  var c=document.getElementById("membros"); if(!c)return;
  var ms=await membrosMesa(id); var perf=await perfis();
  var nome=function(uid){ var p=perf.find(function(x){return x.id===uid;}); return p?p.nome:"(usuário)"; };
  var ja={}; ms.forEach(function(x){ja[x.user_id]=1;});
  var linhas=ms.map(function(x){
    var rem=(x.papel==="mestre")?"":' <button class="btn mini sec" style="border-color:#b23b3b" onclick="removerMembro(\''+id+'\',\''+x.user_id+'\')">remover</button>';
    return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(x.user_id))+'</span><span class="chip c-'+(x.papel==="mestre"?"mestre":"mesa")+'">'+esc(x.papel)+'</span>'+rem+'</li>';
  }).join("");
  var opc=perf.filter(function(p){return !ja[p.id];}).map(function(p){return '<option value="'+esc(p.id)+'">'+esc(p.nome)+'</option>';}).join("");
  var add=opc?'<div class="expbar" style="margin-top:10px"><select id="me_addjog" style="max-width:260px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6">'+opc+'</select> <button class="btn mini" onclick="addJogador(\''+id+'\')">+ Adicionar jogador</button></div>':'<p class="vis-leg">Todos os usuários registrados já estão nesta mesa.</p>';
  c.innerHTML='<ul class="lista2">'+(linhas||'<li class="vis-leg" style="list-style:none">Sem jogadores ainda — só o mestre.</li>')+'</ul>'+add;
}
async function membrosMesa(id){ var r=await sb.from("mesa_membros").select("user_id,papel").eq("mesa_id",id); return r.error?[]:(r.data||[]); }
async function perfis(){ if(S.perfis)return S.perfis; var r=await sb.from("profiles").select("id,nome,avatar_url").order("nome"); S.perfis=r.error?[]:(r.data||[]); return S.perfis; }
async function addJogador(id){ var uid=val("me_addjog"); if(!uid)return; try{ var r=await sb.from("mesa_membros").insert({mesa_id:id,user_id:uid,papel:"jogador"}); if(r.error)throw r.error; await renderMembros(id); }catch(e){erro(e);} }
async function removerMembro(id,uid){ if(!confirm("Remover este jogador da mesa?"))return; try{ var r=await sb.from("mesa_membros").delete().eq("mesa_id",id).eq("user_id",uid); if(r.error)throw r.error; await renderMembros(id); }catch(e){erro(e);} }
async function subirMundoFundo(inp){ var f=inp.files&&inp.files[0]; if(!f)return; var st=document.getElementById("m_fundo_st"); if(st)st.textContent="enviando…";
  try{ var u=await uploadArquivo(f); document.getElementById("m_fundo").value=u; if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }

// ---------- gravações ----------
async function salvarMundo(){ try{ var n=val("m_nome").trim(); if(!n)return erro("Dê um nome ao mundo.");
  var r=await sb.from("mundos").insert({nome:n,slug:slug(n)+"-"+Date.now().toString(36),descricao:val("m_desc"),dono_id:S.user.id,publico:true,fundo_url:val("m_fundo").trim()||null,tema:(val("m_tema")||"medieval")}).select().single();
  if(r.error)throw r.error; S.mundos.push(r.data); S.mundo=r.data; await carregarMesas(); aplicarTema(r.data.tema); go("mundoHome"); }catch(e){erro(e);} }
async function salvarMundoEdit(){ try{ var upd={nome:val("w_nome").trim(),descricao:val("w_desc"),fundo_url:val("w_fundo").trim()||null,tema:(val("w_tema")||"medieval")};
  var r=await sb.from("mundos").update(upd).eq("id",S.mundo.id).select().single(); if(r.error)throw r.error; S.mundo=r.data; var i=S.mundos.findIndex(function(w){return w.id===r.data.id;}); if(i>=0)S.mundos[i]=r.data; aplicarTema(r.data.tema); go("mundoHome"); }catch(e){erro(e);} }
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
    estado:val("f_estado"), visibilidade:val("f_vis"), capa_url:(val("f_capa").trim()||null), personagem_id:(val("f_personagem")||null), jornal_id:(val("f_jornal")||null), sessao_id:(val("f_sessao")||null), arquivo_url:(val("f_arquivo_url")||null), arquivo_nome:(val("f_arquivo_nome")||null) };
  if(reg.tipo==="mapa") reg.categoria="mapa";
  if(editId){ var u=await sb.from("publicacoes").update(reg).eq("id",editId); if(u.error)throw u.error; go("pub",editId); }
  else { reg.mundo_id=S.mundo.id; reg.mesa_id=mesaId||null; reg.autor_id=S.user.id;
    var r=await sb.from("publicacoes").insert(reg).select().single(); if(r.error)throw r.error; go("pub",r.data.id); }
}catch(e){ erro(e); } }
async function excluirPub(id, mesaId){ if(!confirm("Excluir esta publicação? Não dá para desfazer.")) return;
  try{ var r=await sb.from("publicacoes").delete().eq("id",id); if(r.error)throw r.error; if(mesaId) go("mesa",mesaId); else go("lore"); }catch(e){erro(e);} }

function telaPerfil(){ if(!S.user){go("login");return;} var p=S.profile||{};
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Editar perfil</div>'
  +'<div class="autor-cap">'+(p.avatar_url?'<div class="av" id="av_prev" style="background-image:url('+esc(p.avatar_url)+')"></div>':'<div class="av" id="av_prev">'+esc(((p.nome||"?")[0]||"?").toUpperCase())+'</div>')+'<div><h2 style="margin:0">'+esc(p.nome||"Aventureiro")+'</h2><p class="vis-leg" style="font-style:italic">'+esc(p.epiteto||"")+'</p></div></div>'
  +'<div class="form">'+fHead(icon("person"),'Editar perfil','')
  +fGrupo('Quem é você','<label>Nome de aventureiro</label><input id="pf_nome" value="'+esc(p.nome||"")+'"><label>Epíteto / título</label><input id="pf_epiteto" value="'+esc(p.epiteto||"")+'" placeholder="ex.: o Errante, a Branca (opcional)">'+campoImagem('Foto de perfil','pf_avatar',(p.avatar_url||"")))
  +fGrupo('Sobre você','<label>Bio</label>'+mdEditor('pf_bio',p.bio||""))
  +fAcoes('Salvar perfil','salvarPerfil()',"go('autor','"+S.user.id+"')")+'</div>'); }
async function subirAvatar(inp){ var f=inp.files&&inp.files[0]; if(!f)return; var st=document.getElementById("pf_avatar_st"); if(st)st.textContent="enviando…";
  try{ var u=await uploadArquivo(f); var c=document.getElementById("pf_avatar"); if(c)c.value=u; var pv=document.getElementById("av_prev"); if(pv){pv.style.backgroundImage="url("+u+")"; pv.textContent="";} if(st)st.textContent="enviado ✓"; }catch(e){ if(st)st.textContent="erro: "+(e.message||e); } }
async function salvarPerfil(){ try{ var nome=val("pf_nome").trim()||"Aventureiro"; var upd={nome:nome, epiteto:(val("pf_epiteto").trim()||null), avatar_url:(val("pf_avatar").trim()||null), bio:val("pf_bio")};
  var r=await sb.from("profiles").update(upd).eq("id",S.user.id).select().single(); if(r.error)throw r.error; S.profile=r.data; S.nomes[S.user.id]=r.data.nome; if(S.perfilCache)delete S.perfilCache[S.user.id]; go("autor",S.user.id); }catch(e){erro(e);} }
// ===== Personagens (entidade / hub) =====
async function umPersonagem(id){ var r=await sb.from("personagens").select("*").eq("id",id).maybeSingle(); return r.data; }
async function pubsDoPersonagem(id){ var r=await sb.from("publicacoes").select("*").eq("personagem_id",id).order("titulo"); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
async function personagensDaMesa(id){ var r=await sb.from("personagens").select("*").eq("mesa_id",id).order("nome"); return r.error?[]:(r.data||[]); }
async function personagensMundo(){ if(!S.mundo)return []; var r=await sb.from("personagens").select("*").eq("mundo_id",S.mundo.id).order("nome"); return r.error?[]:(r.data||[]); }
async function meusPersonagens(){ if(!S.user||!S.mundo)return []; var r=await sb.from("personagens").select("id,nome").eq("mundo_id",S.mundo.id).eq("jogador_id",S.user.id).order("nome"); return r.error?[]:(r.data||[]); }
function cardPersonagem(c){ return '<div class="card clic" onclick="go(\'personagem\',\''+c.id+'\')">'+thumb(c.imagem_url,icon("hooded-figure"),c.nome)+'<h3>'+esc(c.nome)+'</h3>'+(c.epiteto?'<p class="res" style="font-style:italic">'+esc(c.epiteto)+'</p>':'')+'<p style="margin:.2em 0">'+visChip(c.visibilidade)+(c.tipo==="npc"?'<span class="tipo">NPC</span>':'')+(c.estado==="rascunho"?'<span class="chip-rascunho">'+icon("quill-ink")+' rascunho</span>':'')+'</p>'+(c.resumo?'<p class="res">'+esc(c.resumo)+'</p>':'')+'</div>'; }
async function telaPersonagem(id){ layout('<p>Carregando…</p>');
  var c=await umPersonagem(id); if(!c){ layout('<div class="aviso">Personagem não encontrado ou sem permissão.</div>'); return; } registrarVisita("personagem",id,c.nome);
  var nomeAutor=await nomeDe(c.jogador_id); var pubs=await pubsDoPersonagem(id);
  var podeEditar=(S.user&&(c.jogador_id===S.user.id||(S.profile&&S.profile.papel_global==="admin")));
  var contribs=await contribPersonagem(id); var souContrib=!!(S.user&&contribs.some(function(x){return x.user_id===S.user.id;}));
  var podeAdd=podeEditar||souContrib;
  var av=c.imagem_url?'<div class="av" style="width:152px;height:152px;cursor:zoom-in;background-image:url('+esc(c.imagem_url)+')" title="Ampliar" onclick="lightbox(\''+esc(c.imagem_url)+'\')"></div>':'<div class="av" style="width:152px;height:152px">'+esc((c.nome||"?")[0].toUpperCase())+'</div>';
  var mesaNome=c.mesa_id?((S.mesas.find(function(m){return m.id===c.mesa_id;})||{}).nome||null):null;
  var btnAdd=podeAdd?'<a class="btn" onclick="go(\'nova\',{personagem:\''+id+'\',mesa:'+(c.mesa_id?"'"+c.mesa_id+"'":"null")+'})">+ Adicionar texto</a> ':'';
  var btnEdit=podeEditar?'<a class="btn sec" onclick="go(\'editarPersonagem\',\''+id+'\')">'+icon("quill-ink")+' Editar</a> <button class="btn sec" style="border-color:#b23b3b" onclick="excluirPersonagem(\''+id+'\')">🗑 Excluir</button>':'';
  var acoes='<p>'+btnAdd+btnEdit+(S.user&&!podeEditar&&!souContrib?'<a class="btn sec" onclick="pedirAcesso(\'personagem\',\''+id+'\')">🔑 Pedir p/ escrever</a> ':'')+((btnAdd||btnEdit)?' ':'')+botaoCompartilhar()+' '+botaoFav("personagem",id,c.nome)+'</p>';
  var fichas=pubs.filter(function(x){return x.tipo==="ficha";}); var relPubs=pubs.filter(function(x){return x.tipo!=="ficha";});
  var fichaHtml='<div class="secao"><div class="sec-head"><h2>'+icon("tied-scroll")+' Ficha do personagem</h2>'+(podeAdd&&!fichas.length?'<div class="sec-acts"><a class="btn mini" onclick="go(\'nova\',{personagem:\''+id+'\',mesa:'+(c.mesa_id?"'"+c.mesa_id+"'":"null")+',tipo:\'ficha\'})">+ Disponibilizar ficha</a></div>':'')+'</div>';
  if(fichas.length){ fichaHtml+=fichas.map(function(fp){ return '<div class="ficha-bloco"><div class="ficha-top">'+visChip(fp.visibilidade)+(fp.estado==="rascunho"?'<span class="chip-rascunho">'+icon("quill-ink")+' rascunho</span>':'')+(meu(fp)?' <a class="btn mini sec" onclick="go(\'editar\',\''+fp.id+'\')">'+icon("quill-ink")+' Editar</a> <a class="btn mini sec" onclick="go(\'pub\',\''+fp.id+'\')">↗ Abrir</a>':'')+'</div>'+(fp.arquivo_url?'<p class="anexo-bloco">📎 <a class="btn mini" href="'+esc(fp.arquivo_url)+'" target="_blank" rel="noopener">↗ Abrir ficha (arquivo)</a>'+(fp.arquivo_nome?' <span class="vis-leg">'+esc(fp.arquivo_nome)+'</span>':'')+'</p>':'')+(fp.capa_url?'<img class="capa" src="'+esc(fp.capa_url)+'" loading="lazy">':'')+'<div class="corpo">'+md(fp.corpo||"")+'</div></div>'; }).join(""); }
  else { fichaHtml+='<div class="empty">Nenhuma ficha disponibilizada ainda.'+(podeAdd?' Use “+ Disponibilizar ficha” — você define se ela é privada, só da mesa ou pública.':'')+'</div>'; }
  fichaHtml+='</div>';
  var rel; if(relPubs.length){ abrirExplorador(relPubs); rel='<h2>Conteúdo relacionado</h2>'+exploradorHTML(); } else { rel='<h2>Conteúdo relacionado</h2><div class="empty">Nenhum conteúdo ligado a este personagem ainda.'+(podeAdd?' Use o botão “+ Adicionar texto”.':'')+'</div>'; }
  var painel=podeEditar?'<h2>Quem pode escrever histórias deste personagem</h2><p class="vis-leg">Autorize outros a adicionar textos na página deste personagem (além de você).</p><div id="contribpers">Carregando…</div><div id="pedidospers"></div>':'';
  layout('<div class="bread"><a onclick="go(\'pers\',\'jog\')">‹ Personagens</a></div>'
    +'<div class="autor-cap">'+av+'<div><h1 style="margin:0">'+esc(c.nome)+'</h1>'
    +(c.epiteto?'<p class="vis-leg" style="font-style:italic;margin:.1em 0">'+esc(c.epiteto)+'</p>':'')
    +'<p class="vis-leg">'+visChip(c.visibilidade)+(c.estado==="rascunho"?'<span class="chip-rascunho">'+icon("quill-ink")+' rascunho</span>':'')+' · por <a onclick="go(\'autor\',\''+c.jogador_id+'\')">'+esc(nomeAutor)+'</a>'+(mesaNome?' · <a onclick="go(\'mesa\',\''+c.mesa_id+'\')">⚔ '+esc(mesaNome)+'</a>':'')+'</p></div></div>'
    +(c.resumo?'<p>'+esc(c.resumo)+'</p>':'')
    +(c.corpo?'<div class="corpo">'+md(c.corpo)+'</div>':'')
    +acoes+fichaHtml+rel+painel+secaoComentarios("personagem",id,c.jogador_id));
  if(relPubs.length) renderExpl();
  if(podeEditar){ renderContribPers(id); renderPedidos("personagem",id,"pedidospers"); } renderComentarios("personagem",id); }
function formPersonagem(opts, c){
  var mesaId=c?c.mesa_id:(opts.mesa||null); var emMesa=!!opts.mesa;
  var visOpts=mesaId?[["publico","público (todos)"],["mesa","mesa (todos da campanha)"],["autor_mestre","autor + mestre"],["privado","privado (só eu)"],["mestre","só mestre"]]:[["publico","público (todos)"],["privado","privado (só eu)"]];
  var seletorMesa=(!emMesa && S.mesas.length)?'<label>Mesa (opcional)</label><select id="pc_mesa"><option value="">— sem mesa —</option>'+S.mesas.map(function(m){return '<option value="'+m.id+'"'+(c&&c.mesa_id===m.id?' selected':'')+'>'+esc(m.nome)+'</option>';}).join("")+'</select>':'';
  var tipoSel=c?(c.tipo||"jogador"):(opts.tp||"jogador");
  var podeAtribuir=donoMundo()||temMesaPropria()||(S.profile&&S.profile.papel_global==="admin");
  var seletorTipo='<label>Tipo de personagem</label><select id="pc_tipo">'+opt([["jogador","Personagem de jogador"],["npc","NPC do mestre"]],tipoSel)+'</select>';
  var seletorAtrib=(podeAtribuir && S.perfis && S.perfis.length)?'<label>Dono do personagem (atribuir a um jogador)</label><select id="pc_jogador">'+S.perfis.map(function(u){return '<option value="'+u.id+'"'+(((c?c.jogador_id:S.user.id)===u.id)?' selected':'')+'>'+esc(u.nome)+(u.id===S.user.id?' (você)':'')+'</option>';}).join("")+'</select>':'';
  var head=fHead(icon("hooded-figure"),(c?'Editar personagem':'Novo personagem'), c?'Atualize a identidade do personagem.':'Crie o personagem — depois adicione textos, histórias e a ficha completa na página dele.');
  var gId=fGrupo('Identidade','<label>Nome</label><input id="pc_nome" value="'+esc(c?c.nome:"")+'">'+'<label>Epíteto / título (opcional)</label><input id="pc_epiteto" value="'+esc(c&&c.epiteto?c.epiteto:"")+'" placeholder="ex.: o Errante, a Branca">'+seletorTipo+seletorAtrib);
  var gVinc=fGrupo('Vínculo & imagem',(seletorMesa||'<p class="campo-help">Sem mesa para vincular.</p>')+campoImagem('Foto do personagem (opcional)','pc_img',(c&&c.imagem_url?c.imagem_url:"")),'A que mesa pertence (se houver) e a imagem de capa.');
  var gHist=fGrupo('Apresentação','<label>Resumo curto (opcional)</label><input id="pc_resumo" value="'+esc(c&&c.resumo?c.resumo:"")+'" placeholder="uma linha sobre o personagem">'+'<label>Perfil / história</label>'+mdEditor('pc_corpo',c&&c.corpo?c.corpo:""));
  var gPub=fGrupo('Publicação','<div class="row"><div><label>Estado</label><select id="pc_estado">'+opt([["publicado","publicado"],["rascunho","rascunho"]],c?c.estado:"publicado")+'</select></div><div><label>Visibilidade</label><select id="pc_vis">'+opt(visOpts,c?c.visibilidade:(mesaId?"mesa":"publico"))+'</select></div></div>','Quem pode ver a página do personagem.');
  var acoes=fAcoes(c?'Salvar':'Criar personagem','salvarPersonagem('+(c?"'"+c.id+"'":"null")+')',(c?"go('personagem','"+c.id+"')":"go('pers','jog')"));
  return '<div class="bread">'+(c?'Editar personagem':'Novo personagem')+'</div><div class="form">'+head+gId+gVinc+gHist+gPub+acoes+'</div>';
}
async function telaNovoPersonagem(opts){ opts=opts||{}; if(donoMundo()||temMesaPropria()||(S.profile&&S.profile.papel_global==="admin")) await perfis(); layout(formPersonagem(opts,null)); }
async function telaEditarPersonagem(id){ layout('<p>Carregando…</p>'); var c=await umPersonagem(id); if(!c){layout('<div class="aviso">Sem permissão.</div>');return;} if(donoMundo()||temMesaPropria()||(S.profile&&S.profile.papel_global==="admin")) await perfis(); layout(formPersonagem({},c)); }
async function salvarPersonagem(editId){ try{
  var nome=val("pc_nome").trim(); if(!nome)return erro("Dê um nome ao personagem.");
  var mesaSel=document.getElementById("pc_mesa")?val("pc_mesa"):""; var jid=document.getElementById("pc_jogador")?(val("pc_jogador")||S.user.id):S.user.id;
  var reg={ nome:nome, slug:slug(nome), epiteto:(val("pc_epiteto").trim()||null), imagem_url:(val("pc_img").trim()||null), resumo:(val("pc_resumo").trim()||null), corpo:val("pc_corpo"), estado:val("pc_estado"), visibilidade:val("pc_vis"), tipo:(val("pc_tipo")||"jogador") };
  if(editId){ if(document.getElementById("pc_mesa")) reg.mesa_id=mesaSel||null; if(document.getElementById("pc_jogador")) reg.jogador_id=jid; var u=await sb.from("personagens").update(reg).eq("id",editId); if(u.error)throw u.error; go("personagem",editId); }
  else { reg.mundo_id=S.mundo?S.mundo.id:null; reg.mesa_id=mesaSel||null; reg.jogador_id=jid; var r=await sb.from("personagens").insert(reg).select().single(); if(r.error)throw r.error; go("personagem",r.data.id); }
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
  var linhas=ms.map(function(x){ return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(x.user_id))+'</span><span class="chip c-mesa">colaborador</span> <button class="btn mini sec" style="border-color:#b23b3b" onclick="removerColabMundo(\''+id+'\',\''+x.user_id+'\')">remover</button></li>'; }).join("");
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
  var linhas=ms.map(function(x){ return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(x.user_id))+'</span> <button class="btn mini sec" style="border-color:#b23b3b" onclick="removerContribPers(\''+id+'\',\''+x.user_id+'\')">remover</button></li>'; }).join("");
  var opc=perf.filter(function(p){return !ja[p.id];}).map(function(p){return '<option value="'+esc(p.id)+'">'+esc(p.nome)+'</option>';}).join("");
  var add=opc?'<div class="expbar" style="margin-top:10px"><select id="cp_add" style="max-width:260px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6">'+opc+'</select> <button class="btn mini" onclick="addContribPers(\''+id+'\')">+ Autorizar</button></div>':'<p class="vis-leg">Todos os usuários já estão autorizados.</p>';
  box.innerHTML='<ul class="lista2">'+(linhas||'<li class="vis-leg" style="list-style:none">Só você, por enquanto.</li>')+'</ul>'+add; }
// ===== Jornais do mundo =====
async function jornaisMundo(){ if(!S.mundo)return []; var r=await sb.from("jornais").select("*").eq("mundo_id",S.mundo.id).order("nome"); return r.error?[]:(r.data||[]); }
async function umJornal(id){ var r=await sb.from("jornais").select("*").eq("id",id).maybeSingle(); return r.data; }
async function pubsDoJornal(id){ var r=await sb.from("publicacoes").select("*").eq("jornal_id",id).order("criado_em",{ascending:false}); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
async function meusJornais(){ if(!S.user||!S.mundo)return []; var r=await sb.from("jornais").select("id,nome").eq("mundo_id",S.mundo.id).eq("dono_id",S.user.id).order("nome"); return r.error?[]:(r.data||[]); }
function cardJornal(j){ return '<div class="card clic" onclick="go(\'jornal\',\''+j.id+'\')">'+thumb(j.imagem_url,icon("scroll-unfurled"))+'<h3>'+esc(j.nome)+'</h3>'+(j.descricao?'<p class="res">'+esc(j.descricao)+'</p>':'')+'</div>'; }
function jornalCapa(j){ var img=j.imagem_url?'<div class="jc-img" style="background-image:url('+esc(j.imagem_url)+')"></div>':'<div class="jc-img jc-noimg">'+icon("scroll-unfurled")+'</div>'; return '<a class="jn-capa" onclick="go(\'jornal\',\''+j.id+'\')">'+img+'<div class="jc-mast">'+esc(j.nome)+'</div><div class="jn-rule"></div>'+(j.descricao?'<div class="jc-lema">'+esc(j.descricao)+'</div>':'')+'<div class="jc-foot">Abrir o jornal →</div></a>'; }
async function telaJornais(){ if(!S.mundo){go("mundos");return;} layout('<p>Carregando…</p>'); var js=await jornaisMundo();
  var criar=S.user?'<a class="btn" onclick="go(\'novoJornal\')">+ Criar jornal</a>':'';
  var cards=js.length?'<div class="jn-grid">'+js.map(jornalCapa).join("")+'</div>':'<div class="empty">Nenhum jornal ainda neste mundo.</div>';
  layout(hero("Jornais de "+S.mundo.nome,"Periódicos do mundo — notícias, crônicas e boatos publicados pelos jornais", S.mundo.fundo_url, criar, icon("scroll-unfurled"))+cards); }
async function telaJornal(id){ layout('<p>Carregando…</p>'); var j=await umJornal(id); if(!j){ layout('<div class="aviso">Jornal não encontrado ou sem permissão.</div>'); return; } registrarVisita("jornal",id,j.nome);
  var nomeDono=await nomeDe(j.dono_id); var noticias=await pubsDoJornal(id);
  var podeEditar=(S.user&&(j.dono_id===S.user.id||(S.profile&&S.profile.papel_global==="admin")));
  var escr=await escritoresJornal(id); var souEscr=!!(S.user&&escr.some(function(x){return x.user_id===S.user.id;}));
  var podePublicar=podeEditar||souEscr;
  var logo=j.imagem_url?'<div class="av" style="width:120px;height:120px;border-radius:12px;background-image:url('+esc(j.imagem_url)+')"></div>':'<div class="av" style="width:120px;height:120px;border-radius:12px">📰</div>';
  var btnPub=podePublicar?'<a class="btn" onclick="go(\'nova\',{jornal:\''+id+'\',tipo:\'jornal\'})">+ Publicar notícia</a> ':'';
  var btnEdit=podeEditar?'<a class="btn sec" onclick="go(\'editarJornal\',\''+id+'\')">'+icon("quill-ink")+' Editar</a> <button class="btn sec" style="border-color:#b23b3b" onclick="excluirJornal(\''+id+'\')">🗑 Excluir</button>':'';
  var acoes='<p>'+btnPub+btnEdit+((btnPub||btnEdit)?' ':'')+botaoCompartilhar()+' '+botaoFav("jornal",id,j.nome)+'</p>';
  var lista=noticias.length?jornalEdicoes(noticias,j.nome):'<div class="empty">Nenhuma notícia publicada ainda.'+(podePublicar?' Use o botão “+ Publicar notícia”.':'')+'</div>';
  var painel=podeEditar?'<h2>Escritores do jornal</h2><p class="vis-leg">Autorize quem pode publicar notícias por este jornal (além de você).</p><div id="escritores">Carregando…</div>':'';
  layout('<div class="bread"><a onclick="go(\'jornais\')">‹ Jornais</a></div>'
    +'<div class="autor-cap">'+logo+'<div><h1 style="margin:0">'+esc(j.nome)+'</h1>'+(j.descricao?'<p class="vis-leg" style="font-style:italic">'+esc(j.descricao)+'</p>':'')+'<p class="vis-leg">'+visChip(j.visibilidade)+' · fundado por <a onclick="go(\'autor\',\''+j.dono_id+'\')">'+esc(nomeDono)+'</a></p></div></div>'
    +acoes+'<h2>Edições / Notícias</h2>'+lista+painel+secaoComentarios("jornal",id,j.dono_id));
  if(podeEditar) renderEscritores(id); renderComentarios("jornal",id); }
function formJornal(j){
  var visOpts=[["publico","público (todos)"],["privado","privado (só eu)"]];
  return '<div class="bread">'+(j?'Editar jornal':'Novo jornal')+'</div><div class="form">'
    +fHead(icon("scroll-unfurled"),(j?'Editar jornal':'Criar jornal'),'Um periódico do mundo, com notícias publicadas por você e escritores autorizados.')
    +fGrupo('Identidade','<label>Nome do jornal</label><input id="j_nome" value="'+esc(j?j.nome:"")+'" placeholder="Ex.: A Trombeta de Dagor"><label>Descrição / lema (opcional)</label><input id="j_desc" value="'+esc(j&&j.descricao?j.descricao:"")+'">'+campoImagem('Logo do jornal (opcional)','j_img',(j&&j.imagem_url?j.imagem_url:"")))
    +fGrupo('Publicação','<label>Visibilidade</label><select id="j_vis">'+opt(visOpts,j?j.visibilidade:"publico")+'</select>')
    +fAcoes(j?'Salvar':'Criar jornal','salvarJornal('+(j?"'"+j.id+"'":"null")+')',(j?"go('jornal','"+j.id+"')":"go('jornais')"))+'</div>';
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
  var linhas=ms.map(function(x){ return '<li class="li-clic" style="cursor:default"><span class="li-tit">'+esc(nome(x.user_id))+'</span> <button class="btn mini sec" style="border-color:#b23b3b" onclick="removerEscritor(\''+id+'\',\''+x.user_id+'\')">remover</button></li>'; }).join("");
  var opc=perf.filter(function(p){return !ja[p.id];}).map(function(p){return '<option value="'+esc(p.id)+'">'+esc(p.nome)+'</option>';}).join("");
  var add=opc?'<div class="expbar" style="margin-top:10px"><select id="je_add" style="max-width:260px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6">'+opc+'</select> <button class="btn mini" onclick="addEscritor(\''+id+'\')">+ Autorizar escritor</button></div>':'<p class="vis-leg">Todos os usuários já podem escrever.</p>';
  box.innerHTML='<ul class="lista2">'+(linhas||'<li class="vis-leg" style="list-style:none">Só você, por enquanto.</li>')+'</ul>'+add; }
function telaCreditos(){ layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Créditos</div><h1>Créditos & Atribuições</h1>'
  +'<div class="corpo" style="max-width:740px">'
  +'<p><b>Mares de Sangue</b> — plataforma idealizada, projetada e desenvolvida por <b>Moisés Noah</b>.</p>'
  +'<h2>O cenário</h2>'
  +'<p>O mundo de <b>Skard</b> e o cenário <b>Mar de Sangue</b> foram criados coletivamente por <b>TOGA — The Older Gods Adventures</b>, o grupo original de RPG de mesa que construiu junto, ao longo dos anos, toda a história original deste universo.</p>'
  +'<p><b>O TOGA nasceu em 17 de julho de 2012.</b></p>'
  +'<figure class="toga-foto"><img src="toga.jpg" alt="O grupo TOGA — desde 17/07/2012" loading="lazy" onerror="var f=this.closest(&#39;figure&#39;); if(f)f.style.display=&#39;none&#39;"><figcaption>O grupo TOGA — desde 17 de julho de 2012</figcaption></figure>'
  +'<p><b>Membros fundadores do TOGA:</b> Thompson Moutinho (<b><i>O Primeiro Mestre</i></b>), Moisés Noah, Arnom Abner, Amós Gonzaga, Asafe Lucas, Cleudon Paulo e Matheus “Tharen”.</p>'
  +'<h2>Material original</h2>'
  +'<p>A história original permanece disponível no blog <a href="https://maresdesangue.blogspot.com/" target="_blank" rel="noopener">Mares de Sangue</a>.</p>'
  +'<h2>Ícones</h2><p>Ícones por <a href="https://game-icons.net" target="_blank" rel="noopener">game-icons.net</a> (CC BY 3.0), via <a href="https://iconify.design" target="_blank" rel="noopener">Iconify</a>.</p>'
  +'<hr>'
  +'<p class="vis-leg">© '+(new Date().getFullYear())+' Moisés Noah / TOGA — The Older Gods Adventures. Os direitos do cenário e das histórias originais pertencem aos seus criadores. Cada autor mantém os direitos sobre o conteúdo que publica nesta plataforma.</p>'
  +'</div>'); }
// ===== Sessões / Área do Mestre =====
async function sessoesDaMesa(id){ var r=await sb.from("sessoes").select("*").eq("mesa_id",id).order("ordem",{nullsFirst:false}).order("criado_em"); return r.error?[]:(r.data||[]); }
async function umaSessao(id){ var r=await sb.from("sessoes").select("*").eq("id",id).maybeSingle(); return r.data; }
async function pubsDaSessao(id){ var r=await sb.from("publicacoes").select("*").eq("sessao_id",id).order("criado_em"); var d=r.error?[]:(r.data||[]); regTags(d); return d; }
function cardSessao(se){ return '<div class="card clic" onclick="go(\'sessao\',\''+se.id+'\')">'+thumb(se.imagem_url,icon("dice-twenty-faces-twenty"),se.titulo)+'<h3>'+esc(se.titulo)+'</h3>'+(se.data?'<p class="res">'+esc(se.data)+'</p>':'')+'</div>'; }
async function telaMestre(id){ layout('<p>Carregando…</p>'); var mesa=S.mesas.find(function(m){return m.id===id;});
  if(!mesa){ layout('<div class="aviso">Mesa não encontrada.</div>'); return; }
  if(!mestreDe(mesa)){ layout('<div class="aviso">Área restrita ao mestre desta mesa.</div>'); return; }
  var pubs=await pubsDaMesa(id); var sess=await sessoesDaMesa(id);
  var geral=pubs.filter(function(p){return !p.sessao_id;});
  var cardsSess=sess.length?'<div class="cards">'+sess.map(cardSessao).join("")+'</div>':'<div class="empty">Nenhuma sessão ainda — crie a primeira.</div>';
  var heroActs='<a class="btn" onclick="go(\'novaSessao\',\''+id+'\')">+ Nova sessão</a> <a class="btn sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'planejamento do mestre\',vis:\'mestre\'})">+ Planejamento geral</a> <a class="btn sec" onclick="go(\'mesa\',\''+id+'\')">‹ Voltar à mesa</a>';
  var secGeral='<div class="secao">'+secHead(icon("quill-ink"),"Estrutura & preparação geral",geral.length,'<a class="btn mini sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'planejamento do mestre\',vis:\'mestre\'})">+ Planejamento</a>')+'<p class="vis-leg" style="margin-top:-4px">Argumento da campanha e notas que não pertencem a uma sessão específica.</p>'+(geral.length?listar(geral):'<div class="empty">Nada na preparação geral ainda.</div>')+'</div>';
  var secSess='<div class="secao">'+secHead(icon("dice-twenty-faces-twenty"),"Sessões",sess.length,'<a class="btn mini sec" onclick="go(\'novaSessao\',\''+id+'\')">+ Nova sessão</a>')+cardsSess+'</div>';
  layout('<div class="bread"><a onclick="go(\'mesa\',\''+id+'\')">‹ '+esc(mesa.nome)+'</a> › Área do Mestre</div>'
    +hero("Área do Mestre — "+mesa.nome, "Atrás da tela. Conteúdo “só mestre” não aparece para os jogadores.", mesa.fundo_url, heroActs, icon("drama-masks"))
    +secGeral+secSess); }
async function telaSessao(id){ layout('<p>Carregando…</p>'); var se=await umaSessao(id); if(!se){ layout('<div class="aviso">Sessão não encontrada.</div>'); return; }
  var mesa=S.mesas.find(function(m){return m.id===se.mesa_id;}); var ehMestre=!!(mesa&&mestreDe(mesa));
  var pubs=await pubsDaSessao(id);
  var plan=pubs.filter(function(p){return ['mestre','autor_mestre','privado'].indexOf(p.visibilidade)>=0;});
  var publi=pubs.filter(function(p){return ['publico','mesa'].indexOf(p.visibilidade)>=0;});
  var actsM=ehMestre?'<p><a class="btn" onclick="go(\'nova\',{mesa:\''+se.mesa_id+'\',sessao:\''+id+'\',tipo:\'planejamento do mestre\',vis:\'mestre\'})">+ Planejamento</a> <a class="btn sec" onclick="go(\'nova\',{mesa:\''+se.mesa_id+'\',sessao:\''+id+'\',tipo:\'resumo de sessão\',vis:\'mesa\'})">+ Resumo</a> <a class="btn sec" onclick="go(\'editarSessao\',\''+id+'\')">'+icon("quill-ink")+' Editar sessão</a> <button class="btn sec" style="border-color:#b23b3b" onclick="excluirSessao(\''+id+'\',\''+se.mesa_id+'\')">🗑 Excluir</button></p>':'';
  var recs=await recompensasDaSessao(id); var persMesa=await personagensDaMesa(se.mesa_id);
  var secRec='<h2>'+icon("round-star")+' Recompensas (XP, itens, prêmios)</h2>'+(ehMestre?'<p><a class="btn sec" onclick="go(\'novaRecompensa\',\''+id+'\')">+ Adicionar recompensa</a></p>':'')+(recs.length?renderRecsHTML(recs,persMesa,ehMestre,id):'<div class="empty">Nenhuma recompensa registrada nesta sessão ainda.</div>');
  layout('<div class="bread"><a onclick="go(\'mesa\',\''+se.mesa_id+'\')">‹ Mesa</a> › Sessão</div>'
    +'<h1>'+icon("dice-twenty-faces-twenty")+' '+esc(se.titulo)+'</h1>'+(se.data?'<p class="vis-leg">'+esc(se.data)+'</p>':'')+actsM
    +(ehMestre?'<h2>🔒 Planejamento (só o mestre vê)</h2>'+(plan.length?listar(plan):'<div class="empty">Nenhum planejamento nesta sessão ainda.</div>'):'')
    +'<h2>Resumos & público</h2>'+(publi.length?listar(publi):'<div class="empty">Nenhum resumo publicado nesta sessão ainda.</div>')+secRec); }
function formSessao(mesaId, se){ return '<div class="bread">'+(se?'Editar sessão':'Nova sessão')+'</div><div class="form">'
  +fHead(icon("dice-twenty-faces-twenty"),(se?'Editar sessão':'Nova sessão'),'Uma sessão de jogo. Depois você adiciona planejamento, resumos e recompensas.')
  +fGrupo('Sessão','<label>Título</label><input id="se_titulo" value="'+esc(se?se.titulo:"")+'" placeholder="Ex.: Sessão 1 — Ecos na Cidade dos Corvos"><div class="row"><div><label>Ordem (número, opcional)</label><input id="se_ordem" type="number" value="'+esc(se&&se.ordem!=null?se.ordem:"")+'"></div><div><label>Data (opcional)</label><input id="se_data" type="date" value="'+esc(se&&se.data?se.data:"")+'"></div></div>'+campoImagem('Imagem da sessão (opcional)','se_img',(se&&se.imagem_url?se.imagem_url:"")))
  +fAcoes(se?'Salvar':'Criar sessão',"salvarSessao('"+mesaId+"',"+(se?"'"+se.id+"'":"null")+")",(se?"go('sessao','"+se.id+"')":"go('areaMestre','"+mesaId+"')"))+'</div>'; }
function telaNovaSessao(mesaId){ layout(formSessao(mesaId,null)); }
async function telaEditarSessao(id){ layout('<p>Carregando…</p>'); var se=await umaSessao(id); if(!se){layout('<div class="aviso">Sem permissão.</div>');return;} layout(formSessao(se.mesa_id,se)); }
async function salvarSessao(mesaId, editId){ try{ var t=val("se_titulo").trim(); if(!t)return erro("Dê um título à sessão."); var ord=val("se_ordem").trim(); var dt=val("se_data").trim();
  var reg={ titulo:t, ordem:(ord!==""?parseInt(ord,10):null), data:(dt||null), imagem_url:(val("se_img").trim()||null) };
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
  layout('<div class="bread">Busca</div><h1>'+icon("magnifying-glass")+' Buscar em '+esc(S.mundo.nome)+'</h1><input class="expq" id="buscaq" value="'+esc(q)+'" placeholder="Digite e tecle Enter…" onkeydown="if(event.key===\'Enter\')go(\'busca\',this.value)"><div id="buscares"><p class="vis-leg">'+(q?'Buscando…':'Digite algo para buscar.')+'</p></div>');
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
async function eventosMundo(){ if(!S.mundo)return []; var r=await sb.from("eventos").select("*").eq("mundo_id",S.mundo.id).is("mesa_id",null).order("ordem",{nullsFirst:false}).order("criado_em"); return r.error?[]:(r.data||[]); }
async function umEvento(id){ var r=await sb.from("eventos").select("*").eq("id",id).maybeSingle(); return r.data; }
async function eventosDaMesa(mid){ var r=await sb.from("eventos").select("*").eq("mesa_id",mid).order("ordem",{nullsFirst:false}).order("criado_em"); return r.error?[]:(r.data||[]); }
async function periodosDe(mesaId){ var q=sb.from("periodos").select("*"); if(mesaId){ q=q.eq("mesa_id",mesaId); } else { q=q.eq("mundo_id",S.mundo.id).is("mesa_id",null); } var r=await q.order("ordem",{nullsFirst:false}).order("criado_em"); return r.error?[]:(r.data||[]); }
async function umPeriodo(id){ var r=await sb.from("periodos").select("*").eq("id",id).maybeSingle(); return r.data; }
async function carregarLinkMap(evs){ var linkMap={}; if(!evs.length) return linkMap; var ids=evs.map(function(e){return e.id;});
  var lk=await sb.from("evento_links").select("*").in("evento_id",ids); var links=lk.data||[];
  var pubIds=[],perIds=[]; links.forEach(function(l){ if(l.tipo==="personagem")perIds.push(l.alvo_id); else pubIds.push(l.alvo_id); });
  var tit={};
  if(pubIds.length){ var pr=await sb.from("publicacoes").select("id,titulo").in("id",pubIds); (pr.data||[]).forEach(function(x){tit["publicacao:"+x.id]={t:x.titulo,r:"pub"};}); }
  if(perIds.length){ var cr=await sb.from("personagens").select("id,nome").in("id",perIds); (cr.data||[]).forEach(function(x){tit["personagem:"+x.id]={t:x.nome,r:"personagem"};}); }
  links.forEach(function(l){ var info=tit[l.tipo+":"+l.alvo_id]; if(info){ (linkMap[l.evento_id]=linkMap[l.evento_id]||[]).push({t:info.t,r:info.r,id:l.alvo_id}); } });
  return linkMap; }
function renderEvento(e, linkMap, podeEditar, mesaId){
  var lks=linkMap[e.id]?'🔗 '+linkMap[e.id].map(function(x){return '<a onclick="go(\''+x.r+'\',\''+x.id+'\')">'+esc(x.t)+'</a>';}).join(" · "):'';
  return '<details class="tl2-ev"><summary><span class="dot" style="background:'+esc(e.cor||"#7c1c14")+'"></span>'+(e.quando?'<span class="qd">'+esc(e.quando)+'</span> ':'')+'<span class="evt">'+esc(e.titulo)+'</span></summary><div class="tl2-ev-body">'+(e.descricao?'<div class="corpo" style="font-size:16px;max-width:none">'+md(e.descricao)+'</div>':'')+(lks?'<p class="vis-leg" style="margin:6px 0 0">'+lks+'</p>':'')+(podeEditar?'<p class="vis-leg" style="margin:6px 0 0"><a class="ev-mv" title="Subir" onclick="moverEvento(\''+e.id+'\',-1,\''+(mesaId||"")+'\')">↑</a> <a class="ev-mv" title="Descer" onclick="moverEvento(\''+e.id+'\',1,\''+(mesaId||"")+'\')">↓</a> · <a onclick="go(\'editarEvento\',\''+e.id+'\')">'+icon("quill-ink")+' editar</a> · <a onclick="excluirEvento(\''+e.id+'\',\''+(mesaId||"")+'\')">🗑 excluir</a></p>':'')+'</div></details>'; }
function renderPeriodo(p, eventos, linkMap, podeEditar, mesaId){
  var head='<summary class="tl2-per-head">'+(p.imagem_url?'<span class="bg" style="background-image:url('+esc(p.imagem_url)+')"></span><span class="ov"></span>':'')+'<span class="nm">'+esc(p.nome)+'</span><span class="ct">'+eventos.length+'</span>'+((podeEditar&&p.id)?'<a class="ped" onclick="event.stopPropagation();go(\'editarPeriodo\',\''+p.id+'\')">✎</a>':'')+'</summary>';
  var evHtml=eventos.map(function(e){ return renderEvento(e, linkMap, podeEditar, mesaId); }).join("");
  if(!evHtml) evHtml='<p class="vis-leg" style="padding:4px 0 8px;margin:0">Nenhum evento neste período ainda.</p>';
  return '<details class="tl2-periodo" open>'+head+'<div class="tl2-eventos">'+evHtml+'</div></details>'; }
async function telaLinhaTempo(mesaId){ if(!S.mundo){go("mundos");return;}
  var emMesa=!!mesaId; var mesa=emMesa?S.mesas.find(function(m){return m.id===mesaId;}):null;
  if(emMesa && !mesa){ layout('<div class="aviso">Mesa não encontrada.</div>'); return; }
  layout('<p>Carregando…</p>');
  var evs= emMesa ? await eventosDaMesa(mesaId) : await eventosMundo();
  var pers= await periodosDe(mesaId);
  var podeEditarTL= emMesa ? mestreDe(mesa) : donoMundo();
  var linkMap= await carregarLinkMap(evs);
  var porPer={}, semPer=[];
  evs.forEach(function(e){ if(e.periodo_id){ (porPer[e.periodo_id]=porPer[e.periodo_id]||[]).push(e); } else semPer.push(e); });
  var blocos=pers.map(function(p){ return renderPeriodo(p, porPer[p.id]||[], linkMap, podeEditarTL, mesaId); }).join("");
  if(semPer.length) blocos+=renderPeriodo({id:null,nome:"Sem período definido"}, semPer, linkMap, podeEditarTL, mesaId);
  var criar= podeEditarTL ? '<a class="btn" onclick="go(\'novoEvento\',\''+(mesaId||"")+'\')">+ Novo evento</a> <a class="btn sec" onclick="go(\'novoPeriodo\',\''+(mesaId||"")+'\')">+ Novo período</a>' : '';
  var titulo= emMesa ? ("Linha do Tempo — "+mesa.nome) : ("Linha do Tempo — "+S.mundo.nome);
  var sub= emMesa ? "A cronologia desta campanha." : "A cronologia do mundo, dos primórdios aos dias atuais.";
  var fundo= emMesa ? mesa.fundo_url : S.mundo.fundo_url;
  var bread= emMesa ? '<div class="bread"><a onclick="go(\'mesa\',\''+mesaId+'\')">‹ Mesa</a> › Linha do tempo</div>' : '';
  layout(bread+hero(titulo, sub, fundo, criar, icon("sands-of-time"))+((evs.length||pers.length)?'<div class="tl2">'+blocos+'</div>':'<div class="empty">Nenhum acontecimento ainda.'+(podeEditarTL?' Crie um período e adicione eventos.':'')+'</div>')); }
function formEvento(e, mesaId){ var pers=S.periodosForm||[]; return '<div class="bread"><a onclick="go(\'linha\',\''+(mesaId||"")+'\')">‹ Linha do tempo</a></div><div class="form">'
  +fHead(icon("sands-of-time"),(e?'Editar evento':'Novo evento'),'Um acontecimento na cronologia. Agrupe por período e dê uma cor ao marcador.')
  +fGrupo('Acontecimento','<label>Título do acontecimento</label><input id="ev_titulo" value="'+esc(e?e.titulo:"")+'">'+(pers.length?'<label>Período (ano/era)</label><select id="ev_periodo"><option value="">— sem período —</option>'+pers.map(function(p){return '<option value="'+p.id+'"'+((e&&e.periodo_id===p.id)?' selected':'')+'>'+esc(p.nome)+'</option>';}).join("")+'</select>':'')+'<div class="row"><div><label>Quando (data/ano exato, opcional)</label><input id="ev_quando" value="'+esc(e&&e.quando?e.quando:"")+'" placeholder="ex.: Ano 2068"></div><div><label>Ordem (dentro do período)</label><input id="ev_ordem" type="number" value="'+esc(e&&e.ordem!=null?e.ordem:"")+'"></div></div>')
  +fGrupo('Descrição','<label>Texto do acontecimento</label>'+mdEditor('ev_desc',e&&e.descricao?e.descricao:""))
  +fGrupo('Aparência','<label>Cor do marcador na linha</label><input id="ev_cor" type="color" value="'+esc(e&&e.cor?e.cor:"#7c1c14")+'" style="width:64px;height:36px;padding:2px">')
  +fAcoes(e?'Salvar':'Criar evento','salvarEvento('+(e?"'"+e.id+"'":"null")+",'"+(mesaId||"")+"')","go('linha','"+(mesaId||"")+"')")+'</div>'; }
async function telaNovoEvento(mesaId){ S.evPendentes=[]; if(S.mundo){ await carregarLinkOpts(); S.periodosForm=await periodosDe(mesaId); } layout(formEvento(null, mesaId)+'<h2>Conteúdos vinculados</h2><p class="vis-leg">Vincule conteúdos agora — serão salvos junto ao criar o evento.</p><div id="evnovo"></div>'); renderEvNovo(); }
async function telaEditarEvento(id){ layout('<p>Carregando…</p>'); var e=await umEvento(id); if(!e){layout('<div class="aviso">Sem permissão.</div>');return;} S.periodosForm=await periodosDe(e.mesa_id); layout(formEvento(e, e.mesa_id)+'<h2>Conteúdos vinculados</h2><p class="vis-leg">Relacione este acontecimento a conteúdos — eles aparecem ao abrir o evento.</p><div id="evlinks">Carregando…</div>'); renderEventoLinks(id); }
async function salvarEvento(editId, mesaId){ try{ var t=val("ev_titulo").trim(); if(!t)return erro("Dê um título ao evento."); var ord=val("ev_ordem").trim();
  var reg={ titulo:t, quando:(val("ev_quando").trim()||null), ordem:(ord!==""?parseInt(ord,10):null), descricao:val("ev_desc"), cor:(val("ev_cor")||null), periodo_id:(val("ev_periodo")||null) };
  if(editId){ var u=await sb.from("eventos").update(reg).eq("id",editId); if(u.error)throw u.error; go("linha",mesaId||""); }
  else { reg.mundo_id=S.mundo.id; reg.autor_id=S.user.id; reg.mesa_id=mesaId||null; reg.visibilidade="publico"; reg.estado="publicado"; var r=await sb.from("eventos").insert(reg).select().single(); if(r.error)throw r.error; if(S.evPendentes&&S.evPendentes.length){ var rows=S.evPendentes.map(function(l){return {evento_id:r.data.id,tipo:l.tipo,alvo_id:l.alvo_id};}); var ri=await sb.from("evento_links").insert(rows); if(ri.error)throw ri.error; } S.evPendentes=[]; go("linha",mesaId||""); } }catch(e){erro(e);} }
async function excluirEvento(id, mesaId){ if(!confirm("Excluir este evento da linha do tempo?"))return; try{ var r=await sb.from("eventos").delete().eq("id",id); if(r.error)throw r.error; go("linha",mesaId||""); }catch(e){erro(e);} }
function formPeriodo(mundoId, mesaId, p){ return '<div class="bread"><a onclick="go(\'linha\',\''+(mesaId||"")+'\')">‹ Linha do tempo</a></div><div class="form">'
  +fHead(icon("sands-of-time"),(p?'Editar período':'Novo período'),'Um período agrupa eventos (um ano, uma era). Pode ter imagem de fundo.')
  +fGrupo('Período','<label>Nome do período / ano / era</label><input id="pr_nome" value="'+esc(p?p.nome:"")+'" placeholder="ex.: Ano 2068 · Era Primordial"><label>Ordem (número p/ a sequência dos blocos)</label><input id="pr_ordem" type="number" value="'+esc(p&&p.ordem!=null?p.ordem:"")+'">'+campoImagem('Imagem de fundo do período (opcional)','pr_img',(p&&p.imagem_url?p.imagem_url:"")))
  +'<div class="form-acoes"><button class="btn" onclick="salvarPeriodo(\''+(mesaId||"")+'\','+(p?"'"+p.id+"'":"null")+')">'+(p?'Salvar':'Criar período')+'</button> <button class="btn sec" onclick="go(\'linha\',\''+(mesaId||"")+'\')">Cancelar</button>'+(p?' <button class="btn sec" style="border-color:#b23b3b" onclick="excluirPeriodo(\''+p.id+'\',\''+(mesaId||"")+'\')">🗑 Excluir período</button>':'')+'</div></div>'; }
function telaNovoPeriodo(mesaId){ layout(formPeriodo(S.mundo.id, mesaId||null, null)); }
async function telaEditarPeriodo(id){ layout('<p>Carregando…</p>'); var p=await umPeriodo(id); if(!p){layout('<div class="aviso">Sem permissão.</div>');return;} layout(formPeriodo(p.mundo_id, p.mesa_id, p)); }
async function salvarPeriodo(mesaId, editId){ try{ var nome=val("pr_nome").trim(); if(!nome)return erro("Dê um nome ao período."); var ord=val("pr_ordem").trim();
  var reg={ nome:nome, ordem:(ord!==""?parseInt(ord,10):null), imagem_url:(val("pr_img").trim()||null) };
  if(editId){ var u=await sb.from("periodos").update(reg).eq("id",editId); if(u.error)throw u.error; }
  else { reg.mundo_id=S.mundo.id; reg.mesa_id=mesaId||null; var r=await sb.from("periodos").insert(reg); if(r.error)throw r.error; }
  go("linha",mesaId||""); }catch(e){erro(e);} }
async function excluirPeriodo(id, mesaId){ if(!confirm("Excluir este período? Os eventos não são apagados, só ficam sem período."))return; try{ var r=await sb.from("periodos").delete().eq("id",id); if(r.error)throw r.error; go("linha",mesaId||""); }catch(e){erro(e);} }

// ===== Pedidos de acesso (colaboração) =====
async function pedidosPendentes(tipo, alvoId){ var r=await sb.from("pedidos_acesso").select("*").eq("tipo",tipo).eq("alvo_id",alvoId).eq("estado","pendente").order("criado_em"); return r.error?[]:(r.data||[]); }
async function pedirAcesso(tipo, alvoId){ if(!S.user){go("login");return;} try{
  var ex=await sb.from("pedidos_acesso").select("id,estado").eq("tipo",tipo).eq("alvo_id",alvoId).eq("solicitante_id",S.user.id).limit(1);
  if(ex.data&&ex.data.length){ S.msg='<div class="ok">Você já tem um pedido ('+esc(ex.data[0].estado)+') para este item.</div>'; render(); return; }
  var r=await sb.from("pedidos_acesso").insert({tipo:tipo,alvo_id:alvoId,solicitante_id:S.user.id,estado:"pendente"}); if(r.error)throw r.error;
  var dono=await donoDoAlvo(tipo,alvoId); var nmp=(S.profile&&S.profile.nome)?S.profile.nome:"Alguém"; notificar(dono,"pedido",nmp+" pediu acesso a um conteúdo seu.",(tipo==="mundo"?null:tipo),(tipo==="mundo"?null:alvoId)); S.msg='<div class="ok">Pedido de acesso enviado! O criador será avisado para aprovar.</div>'; render();
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
// ===== Alternância cards/lista (telas de entidades) + tags =====
function alternarModo(){ S.modo=(S.modo==="lista"?"cards":"lista"); localStorage.setItem("mds_modo",S.modo); render(); }
function modoBtnHTML(){ return '<button class="modo-btn" onclick="alternarModo()" aria-label="Alternar entre cards e lista" title="Alternar entre cards e lista (vale para o site todo)">'+(S.modo==="lista"?"▦ Cards":"☰ Lista")+'</button>'; }
function togModo(){ S.modo=(S.modo==="cards"?"lista":"cards"); localStorage.setItem("mds_modo",S.modo); render(); }
function barraModo(){ return '<div class="expbar" style="margin:6px 0"><button class="btn mini sec" onclick="togModo()">'+(S.modo==="lista"?"▦ Ver em cards":"☰ Ver em lista")+'</button></div>'; }
function gridOuLista(items, cardFn, liFn){ return S.modo==="lista" ? '<ul class="lista2">'+items.map(liFn).join("")+'</ul>' : '<div class="cards">'+items.map(cardFn).join("")+'</div>'; }
function cardPersonagemRound(c){ var img=c.imagem_url?'<div class="pc-av" style="background-image:url('+esc(c.imagem_url)+')"></div>':'<div class="pc-av pc-av-ph">'+esc(((c.nome||"?")[0]||"?").toUpperCase())+'</div>'; return '<div class="pc-circ" onclick="go(\'personagem\',\''+c.id+'\')" title="'+esc(c.nome)+'">'+img+'<div class="pc-nm">'+esc(c.nome)+'</div>'+(c.epiteto?'<div class="pc-ep">'+esc(c.epiteto)+'</div>':'')+'<div class="pc-chips">'+(c.tipo==="npc"?'<span class="tipo">NPC</span>':'')+(c.estado==="rascunho"?'<span class="chip-rascunho">'+icon("quill-ink")+' rascunho</span>':'')+'</div></div>'; }
function gridPersRound(lista){ return S.modo==="lista" ? '<ul class="lista2">'+lista.map(liPersonagem).join("")+'</ul>' : '<div class="pers-circ-grid">'+lista.map(cardPersonagemRound).join("")+'</div>'; }
function liPersonagem(c){ return '<li class="li-clic" onclick="go(\'personagem\',\''+c.id+'\')"><span class="li-ic">'+icon("hooded-figure")+'</span><span class="li-tit">'+esc(c.nome)+'</span>'+(c.epiteto?'<span class="tipo">'+esc(c.epiteto)+'</span>':'')+visChip(c.visibilidade)+'</li>'; }
function liJornal(j){ return '<li class="li-clic" onclick="go(\'jornal\',\''+j.id+'\')"><span class="li-ic">'+icon("scroll-unfurled")+'</span><span class="li-tit">'+esc(j.nome)+'</span>'+(j.descricao?'<span class="vis-leg" style="flex:1">'+esc(j.descricao)+'</span>':'')+'</li>'; }
function tagChips(tags){ return (tags&&tags.length)?'<p style="margin:8px 0">'+tags.map(function(t){return '<a class="tagc" onclick="go(\'busca\',\''+esc(t)+'\')">#'+esc(t)+'</a>';}).join("")+'</p>':''; }
// ===== Vínculos de evento <-> conteúdo =====
async function carregarLinkOpts(){ if(S.linkOpts&&S.linkOpts._m===S.mundo.id) return S.linkOpts;
  var pr=await sb.from("publicacoes").select("id,titulo").eq("mundo_id",S.mundo.id).order("titulo");
  var cr=await sb.from("personagens").select("id,nome").eq("mundo_id",S.mundo.id).order("nome");
  S.linkOpts={_m:S.mundo.id, pubs:(pr.data||[]), pers:(cr.data||[])}; return S.linkOpts; }
async function eventoLinks(id){ var r=await sb.from("evento_links").select("*").eq("evento_id",id); return r.error?[]:(r.data||[]); }
async function addEventoLink(id){ var v=val("ev_link_sel"); if(!v)return; var i=v.indexOf(":"); var tipo=v.slice(0,i), alvo=v.slice(i+1); try{ var r=await sb.from("evento_links").insert({evento_id:id,tipo:tipo,alvo_id:alvo}); if(r.error)throw r.error; await renderEventoLinks(id); }catch(e){erro(e);} }
async function removerEventoLink(linkId, eventoId){ try{ var r=await sb.from("evento_links").delete().eq("id",linkId); if(r.error)throw r.error; await renderEventoLinks(eventoId); }catch(e){erro(e);} }
async function renderEventoLinks(id){ var box=document.getElementById("evlinks"); if(!box)return;
  var links=await eventoLinks(id); var op=await carregarLinkOpts();
  var nomePub=function(a){ var x=op.pubs.find(function(p){return p.id===a;}); return x?x.titulo:"(conteúdo)"; };
  var nomePer=function(a){ var x=op.pers.find(function(p){return p.id===a;}); return x?x.nome:"(personagem)"; };
  var ja={}; links.forEach(function(l){ja[l.tipo+":"+l.alvo_id]=1;});
  var linhas=links.map(function(l){ var nm=l.tipo==="personagem"?nomePer(l.alvo_id):nomePub(l.alvo_id); var ic=l.tipo==="personagem"?"🧝":"📄"; return '<li class="li-clic" style="cursor:default"><span class="li-ic">'+ic+'</span><span class="li-tit">'+esc(nm)+'</span> <button class="btn mini sec" style="border-color:#b23b3b" onclick="removerEventoLink(\''+l.id+'\',\''+id+'\')">remover</button></li>'; }).join("");
  var opcPer=op.pers.filter(function(p){return !ja["personagem:"+p.id];}).map(function(p){return '<option value="personagem:'+p.id+'">🧝 '+esc(p.nome)+'</option>';}).join("");
  var opcPub=op.pubs.filter(function(p){return !ja["publicacao:"+p.id];}).map(function(p){return '<option value="publicacao:'+p.id+'">📄 '+esc(p.titulo)+'</option>';}).join("");
  var add='<div class="expbar" style="margin-top:10px"><select id="ev_link_sel" style="max-width:340px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6"><option value="">— escolher conteúdo —</option>'+(opcPer?'<optgroup label="Personagens">'+opcPer+'</optgroup>':'')+(opcPub?'<optgroup label="Conteúdos">'+opcPub+'</optgroup>':'')+'</select> <button class="btn mini" onclick="addEventoLink(\''+id+'\')">+ Vincular</button></div>';
  box.innerHTML='<ul class="lista2">'+(linhas||'<li class="vis-leg" style="list-style:none">Nenhum conteúdo vinculado ainda.</li>')+'</ul>'+add; }
// ===== Vínculos pendentes na criação de evento =====
function renderEvNovo(){ var box=document.getElementById("evnovo"); if(!box)return; var op=S.linkOpts||{pubs:[],pers:[]}; S.evPendentes=S.evPendentes||[];
  var ja={}; S.evPendentes.forEach(function(l){ja[l.tipo+":"+l.alvo_id]=1;});
  var linhas=S.evPendentes.map(function(l,i){ var ic=l.tipo==="personagem"?"🧝":"📄"; return '<li class="li-clic" style="cursor:default"><span class="li-ic">'+ic+'</span><span class="li-tit">'+esc(l.nome)+'</span> <button class="btn mini sec" style="border-color:#b23b3b" onclick="removePendente('+i+')">remover</button></li>'; }).join("");
  var opcPer=op.pers.filter(function(p){return !ja["personagem:"+p.id];}).map(function(p){return '<option value="personagem:'+p.id+'">🧝 '+esc(p.nome)+'</option>';}).join("");
  var opcPub=op.pubs.filter(function(p){return !ja["publicacao:"+p.id];}).map(function(p){return '<option value="publicacao:'+p.id+'">📄 '+esc(p.titulo)+'</option>';}).join("");
  var add='<div class="expbar" style="margin-top:10px"><select id="ev_link_sel" style="max-width:340px;padding:8px;border:1px solid var(--ouro);border-radius:8px;background:#fffdf6"><option value="">— escolher conteúdo —</option>'+(opcPer?'<optgroup label="Personagens">'+opcPer+'</optgroup>':'')+(opcPub?'<optgroup label="Conteúdos">'+opcPub+'</optgroup>':'')+'</select> <button class="btn mini" onclick="addPendente()">+ Vincular</button></div>';
  box.innerHTML='<ul class="lista2">'+(linhas||'<li class="vis-leg" style="list-style:none">Nenhum conteúdo vinculado ainda.</li>')+'</ul>'+add; }
function addPendente(){ var v=val("ev_link_sel"); if(!v)return; var i=v.indexOf(":"); var tipo=v.slice(0,i), alvo=v.slice(i+1); var op=S.linkOpts||{pubs:[],pers:[]}; var nome=tipo==="personagem"?((op.pers.find(function(p){return p.id===alvo;})||{}).nome||"personagem"):((op.pubs.find(function(p){return p.id===alvo;})||{}).titulo||"conteúdo"); S.evPendentes=S.evPendentes||[]; S.evPendentes.push({tipo:tipo,alvo_id:alvo,nome:nome}); renderEvNovo(); }
function removePendente(i){ S.evPendentes.splice(i,1); renderEvNovo(); }
// ===== Recompensas (XP, itens, prêmios) na sessão =====
async function recompensasDaSessao(id){ var r=await sb.from("recompensas").select("*").eq("sessao_id",id).order("criado_em"); return r.error?[]:(r.data||[]); }
async function umaRecompensa(id){ var r=await sb.from("recompensas").select("*").eq("id",id).maybeSingle(); return r.data; }
function renderRecsHTML(recs, persMesa, ehMestre, sid){ var nm=function(pid){ if(!pid)return "Todos"; var x=(persMesa||[]).find(function(p){return p.id===pid;}); return x?x.nome:"(personagem)"; };
  var ic=function(t){ return t==="xp"?"⭐":(t==="item"?"⚔":"🏆"); };
  return '<ul class="lista2">'+recs.map(function(r){ return '<li class="li-clic" style="cursor:default"><span class="li-ic">'+ic(r.tipo)+'</span><span class="li-tit">'+esc(r.titulo)+(r.tipo==="xp"&&r.quantidade!=null?' ('+r.quantidade+' XP)':'')+'</span><span class="tipo">'+esc(nm(r.personagem_id))+'</span>'+(r.descricao?'<span class="vis-leg" style="flex:1"> — '+esc(r.descricao)+'</span>':'')+(ehMestre?' <a onclick="go(\'editarRecompensa\',\''+r.id+'\')">✎</a> <a onclick="excluirRecompensa(\''+r.id+'\',\''+sid+'\')">🗑</a>':'')+'</li>'; }).join("")+'</ul>'; }
function formRecompensa(sid, mid, r, persMesa){ return '<div class="bread"><a onclick="go(\'sessao\',\''+sid+'\')">‹ Sessão</a></div><div class="form">'
  +fHead(icon("round-star"),(r?'Editar recompensa':'Nova recompensa'),'XP, item ou prêmio desta sessão — geral ou para um personagem.')
  +fGrupo('Recompensa','<div class="row"><div><label>Tipo</label><select id="rc_tipo">'+opt([["xp","XP"],["item","Item"],["premio","Prêmio"]],r?r.tipo:"xp")+'</select></div><div><label>Para qual personagem?</label><select id="rc_pers"><option value="">— todos / geral —</option>'+(persMesa||[]).map(function(p){return '<option value="'+p.id+'"'+(r&&r.personagem_id===p.id?' selected':'')+'>'+esc(p.nome)+'</option>';}).join("")+'</select></div></div><label>Título / nome</label><input id="rc_titulo" value="'+esc(r?r.titulo:"")+'" placeholder="ex.: Derrotar o chefe · Espada Élfica"><label>Quantidade de XP (se for XP; negativo = perda)</label><input id="rc_qtd" type="number" value="'+esc(r&&r.quantidade!=null?r.quantidade:"")+'"><label>Observação (motivo, detalhes)</label><textarea id="rc_desc">'+esc(r&&r.descricao?r.descricao:"")+'</textarea>')
  +fAcoes(r?'Salvar':'Adicionar',"salvarRecompensa('"+sid+"','"+mid+"',"+(r?"'"+r.id+"'":"null")+")","go('sessao','"+sid+"')")+'</div>'; }
async function telaNovaRecompensa(sid){ layout('<p>Carregando…</p>'); var se=await umaSessao(sid); if(!se){layout('<div class="aviso">Sessão não encontrada.</div>');return;} var pm=await personagensDaMesa(se.mesa_id); layout(formRecompensa(sid, se.mesa_id, null, pm)); }
async function telaEditarRecompensa(id){ layout('<p>Carregando…</p>'); var r=await umaRecompensa(id); if(!r){layout('<div class="aviso">Sem permissão.</div>');return;} var pm=await personagensDaMesa(r.mesa_id); layout(formRecompensa(r.sessao_id, r.mesa_id, r, pm)); }
async function salvarRecompensa(sid, mid, editId){ try{ var t=val("rc_titulo").trim(); if(!t)return erro("Dê um título à recompensa."); var q=val("rc_qtd").trim();
  var reg={ tipo:val("rc_tipo"), titulo:t, personagem_id:(val("rc_pers")||null), quantidade:(q!==""?parseInt(q,10):null), descricao:(val("rc_desc")||null) };
  if(editId){ var u=await sb.from("recompensas").update(reg).eq("id",editId); if(u.error)throw u.error; }
  else { reg.sessao_id=sid; reg.mesa_id=mid; var ri=await sb.from("recompensas").insert(reg); if(ri.error)throw ri.error; }
  go("sessao",sid); }catch(e){erro(e);} }
async function excluirRecompensa(id, sid){ if(!confirm("Excluir esta recompensa?"))return; try{ var r=await sb.from("recompensas").delete().eq("id",id); if(r.error)throw r.error; go("sessao",sid); }catch(e){erro(e);} }
// ===== Favoritos & visitas recentes =====
async function carregarFavs(){ S.favs={}; if(!S.user)return; try{ var r=await sb.from("favoritos").select("tipo,alvo_id"); if(!r.error&&r.data){ r.data.forEach(function(f){ S.favs[f.tipo+":"+f.alvo_id]=1; }); } }catch(e){} }
function ehFav(tipo,id){ return !!(S.favs&&S.favs[tipo+":"+id]); }
async function toggleFav(tipo,id,titulo){ if(!S.user){ go("login"); return; } var k=tipo+":"+id; S.favs=S.favs||{};
  try{ if(S.favs[k]){ await sb.from("favoritos").delete().eq("tipo",tipo).eq("alvo_id",id); delete S.favs[k]; }
    else { await sb.from("favoritos").insert({user_id:S.user.id,mundo_id:(S.mundo?S.mundo.id:null),tipo:tipo,alvo_id:id,titulo:String(titulo||"")}); S.favs[k]=1; } }catch(e){ erro(e); return; }
  var b=document.getElementById("fav-"+id); if(b){ if(S.favs[k]){b.classList.add("on");b.innerHTML="★ Favoritado";}else{b.classList.remove("on");b.innerHTML="☆ Favoritar";} } }
function toggleFav2(btn){ toggleFav(btn.getAttribute("data-tipo"),btn.getAttribute("data-id"),btn.getAttribute("data-titulo")); }
function botaoFav(tipo,id,titulo){ if(!S.user)return ""; var on=ehFav(tipo,id); var tt=esc(String(titulo||"")).replace(/"/g,"&quot;"); return '<button class="btn mini sec fav-btn'+(on?' on':'')+'" id="fav-'+id+'" data-tipo="'+tipo+'" data-id="'+id+'" data-titulo="'+tt+'" onclick="toggleFav2(this)">'+(on?"★ Favoritado":"☆ Favoritar")+'</button>'; }
async function desfav(tipo,id){ try{ await sb.from("favoritos").delete().eq("tipo",tipo).eq("alvo_id",id); if(S.favs)delete S.favs[tipo+":"+id]; telaFavoritos(); }catch(e){erro(e);} }
async function telaFavoritos(){ if(!S.user){ go("login"); return; } layout('<p>Carregando…</p>'); await carregarFavs();
  var r=await sb.from("favoritos").select("*").order("criado_em",{ascending:false}); var favs=(r.error?[]:(r.data||[]));
  var rt={mesa:"mesa",publicacao:"pub",personagem:"personagem",jornal:"jornal"}; var ic={mesa:"⚔",publicacao:"📄",personagem:"🧝",jornal:"📰",mundo:"🌍"};
  var html=favs.length?'<ul class="lista2">'+favs.map(function(f){ var alvo=rt[f.tipo]; var acao=alvo?"go('"+alvo+"','"+f.alvo_id+"')":"selecionarMundo('"+f.alvo_id+"')"; return '<li class="li-clic" onclick="'+acao+'"><span class="li-tit">'+(ic[f.tipo]||"⭐")+' '+esc(f.titulo||"(sem título)")+'</span><span class="chip">'+esc(f.tipo)+'</span> <button class="btn mini sec" style="border-color:#b23b3b" onclick="event.stopPropagation();desfav(\''+f.tipo+'\',\''+f.alvo_id+'\')">remover</button></li>'; }).join("")+'</ul>':'<div class="empty">Nenhum favorito ainda. Use o botão ☆ Favoritar nos conteúdos.</div>';
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Favoritos</div><h1>★ Favoritos</h1>'+html); }
function registrarVisita(tipo,id,titulo){ try{ var arr=JSON.parse(localStorage.getItem("mds_recent")||"[]"); arr=arr.filter(function(x){return !(x.tipo===tipo&&x.id===id);}); arr.unshift({tipo:tipo,id:id,titulo:String(titulo||""),mundoId:(S.mundo?S.mundo.id:null),mundoNome:(S.mundo?S.mundo.nome:""),t:Date.now()}); arr=arr.slice(0,12); localStorage.setItem("mds_recent",JSON.stringify(arr)); }catch(e){} }
function visitasRecentes(mundoId){ try{ var arr=JSON.parse(localStorage.getItem("mds_recent")||"[]"); arr=mundoId?arr.filter(function(x){return x.mundoId===mundoId;}):arr; return arr.slice(0,6); }catch(e){ return []; } }
// ===== Cropper de imagem (reposicionar/recortar estilo LinkedIn) =====
function abrirCropper(fieldId){
  var inp=document.getElementById(fieldId); if(!inp)return;
  var url=(inp.value||"").trim(); if(!url){ toast("Escolha ou cole uma imagem primeiro.","erro"); return; }
  var ov=document.createElement("div"); ov.className="crop-ov";
  ov.innerHTML='<div class="crop-box"><h3>✂ Ajustar enquadramento</h3>'
    +'<div class="crop-asp"><button type="button" data-a="3" class="on">Largo 3:1</button><button type="button" data-a="1.7778">16:9</button><button type="button" data-a="1">Quadrado</button><button type="button" data-a="0.75">Retrato</button></div>'
    +'<div class="crop-frame" id="cropFrame"><img id="cropImg" alt=""></div>'
    +'<label class="crop-zoom">Zoom <input type="range" id="cropZoom" min="1" max="3" step="0.01" value="1"></label>'
    +'<p class="campo-help">Arraste a imagem para reposicionar, use o zoom e escolha a proporção acima.</p>'
    +'<div class="crop-acts"><button type="button" class="btn" id="cropOk">Cortar e usar</button> <button type="button" class="btn sec" id="cropCancel">Cancelar</button> <span class="vis-leg" id="cropMsg"></span></div></div>';
  document.body.appendChild(ov);
  var img=ov.querySelector("#cropImg"), frame=ov.querySelector("#cropFrame"), msg=ov.querySelector("#cropMsg");
  var st={aspect:3,scale:1,x:0,y:0,base:1,iw:0,ih:0,drag:false,px:0,py:0};
  var FW=Math.min(520, Math.round(window.innerWidth*0.8));
  function setAspect(a){ st.aspect=a; frame.style.width=FW+"px"; frame.style.height=Math.round(FW/a)+"px"; fit(); }
  function fit(){ if(!st.iw)return; var fw=frame.clientWidth, fh=frame.clientHeight; st.base=Math.max(fw/st.iw, fh/st.ih); st.x=(fw-st.iw*st.base*st.scale)/2; st.y=(fh-st.ih*st.base*st.scale)/2; clamp(); render(); }
  function clamp(){ var fw=frame.clientWidth, fh=frame.clientHeight, w=st.iw*st.base*st.scale, h=st.ih*st.base*st.scale; var minx=fw-w, miny=fh-h; if(st.x>0)st.x=0; if(st.x<minx)st.x=minx; if(st.y>0)st.y=0; if(st.y<miny)st.y=miny; }
  function render(){ var w=st.iw*st.base*st.scale, h=st.ih*st.base*st.scale; img.style.width=w+"px"; img.style.height=h+"px"; img.style.left=st.x+"px"; img.style.top=st.y+"px"; }
  img.crossOrigin="anonymous";
  img.onload=function(){ st.iw=img.naturalWidth; st.ih=img.naturalHeight; setAspect(3); };
  img.onerror=function(){ msg.textContent="Não foi possível carregar a imagem."; };
  img.src=url+(url.indexOf("?")<0?"?cb=":"&cb=")+Date.now();
  ov.querySelectorAll(".crop-asp button").forEach(function(b){ b.onclick=function(){ ov.querySelectorAll(".crop-asp button").forEach(function(x){x.classList.remove("on");}); b.classList.add("on"); setAspect(parseFloat(b.getAttribute("data-a"))); }; });
  ov.querySelector("#cropZoom").oninput=function(){ st.scale=parseFloat(this.value); clamp(); render(); };
  frame.onmousedown=function(e){ st.drag=true; st.px=e.clientX; st.py=e.clientY; e.preventDefault(); };
  function mover(e){ if(!st.drag)return; st.x+=e.clientX-st.px; st.y+=e.clientY-st.py; st.px=e.clientX; st.py=e.clientY; clamp(); render(); }
  function solta(){ st.drag=false; }
  window.addEventListener("mousemove",mover); window.addEventListener("mouseup",solta);
  function fechar(){ window.removeEventListener("mousemove",mover); window.removeEventListener("mouseup",solta); ov.remove(); }
  ov.querySelector("#cropCancel").onclick=fechar;
  ov.onclick=function(e){ if(e.target===ov) fechar(); };
  ov.querySelector("#cropOk").onclick=function(){
    msg.textContent="processando…";
    try{
      var fw=frame.clientWidth, OW=1200, OH=Math.round(OW/st.aspect), ratio=OW/fw;
      var cv=document.createElement("canvas"); cv.width=OW; cv.height=OH; var ctx=cv.getContext("2d");
      ctx.fillStyle="#000"; ctx.fillRect(0,0,OW,OH);
      ctx.drawImage(img, st.x*ratio, st.y*ratio, st.iw*st.base*st.scale*ratio, st.ih*st.base*st.scale*ratio);
      cv.toBlob(function(blob){ if(!blob){ msg.textContent="falha ao gerar imagem."; return; }
        var file=new File([blob],"recorte-"+Date.now()+".jpg",{type:"image/jpeg"});
        uploadArquivo(file).then(function(u){ inp.value=u; var stt=document.getElementById(fieldId+"_st"); if(stt)stt.textContent="recortada e enviada ✓"; fechar(); })
          .catch(function(err){ msg.textContent="erro ao enviar: "+(err.message||err); });
      }, "image/jpeg", 0.9);
    }catch(e){ msg.textContent="recorte bloqueado (imagem de link externo). Envie o arquivo e recorte."; }
  };
}

var ICN={
 medieval:{inicio:"⌂",mundo:"🏰",buscar:"🔎",enc:"📖",mapas:"🗺️",jornais:"📰",linha:"🕰",persJog:"👥",persMes:"🎭",mesa:"⚔",mestre:"🎭",fav:"★"},
 horror:{inicio:"⌂",mundo:"🏰",buscar:"🔎",enc:"📕",mapas:"🗺️",jornais:"📜",linha:"⏳",persJog:"🧛",persMes:"🦇",mesa:"⚰️",mestre:"🩸",fav:"🩸"},
 lovecraft:{inicio:"⌂",mundo:"🌀",buscar:"🔎",enc:"📜",mapas:"🗺️",jornais:"📜",linha:"⏳",persJog:"👁️",persMes:"🐙",mesa:"🌑",mestre:"👁️",fav:"👁️"},
 anos80:{inicio:"⌂",mundo:"🌆",buscar:"🔎",enc:"💾",mapas:"🗺️",jornais:"📻",linha:"📼",persJog:"🕹️",persMes:"🕶️",mesa:"🎮",mestre:"🕶️",fav:"⭐"},
 scifi:{inicio:"⌂",mundo:"🪐",buscar:"🔎",enc:"🛰️",mapas:"🗺️",jornais:"📡",linha:"⏳",persJog:"🤖",persMes:"👾",mesa:"🚀",mestre:"🛰️",fav:"⭐"},
 samurai:{inicio:"⌂",mundo:"🏯",buscar:"🔎",enc:"📜",mapas:"🗺️",jornais:"📜",linha:"🌸",persJog:"🥷",persMes:"👺",mesa:"⚔️",mestre:"👺",fav:"🌸"}
};
var ICONMAP={horror:{"crossed-swords":"fangs","hooded-figure":"vampire-dracula","person":"vampire-dracula"},lovecraft:{"castle":"octopus","crossed-swords":"tentacle-strike","hooded-figure":"evil-eyes","person":"evil-eyes"},scifi:{"castle":"ringed-planet","treasure-map":"ringed-planet","crossed-swords":"spaceship","hooded-figure":"robot-golem","person":"robot-golem"},anos80:{"crossed-swords":"joystick","scroll-unfurled":"vhs"},samurai:{"castle":"japan","crossed-swords":"katana","hooded-figure":"samurai-helmet","person":"samurai-helmet"}};
function icon(g){ if(!g)return ""; var t=(S&&S.mundo&&S.mundo.tema)||"medieval"; var m=(typeof ICONMAP!=="undefined"&&ICONMAP)?ICONMAP[t]:null; if(m&&m[g])g=m[g]; return '<iconify-icon icon="game-icons:'+g+'" class="gi"></iconify-icon>'; }
var ICN2={inicio:"house",mundo:"castle",buscar:"magnifying-glass",enc:"book-cover",mapas:"treasure-map",jornais:"scroll-unfurled",linha:"sands-of-time",persJog:"hooded-figure",persMes:"drama-masks",mesa:"crossed-swords",mestre:"drama-masks",fav:"round-star"};
function ic(n){ return icon(ICN2[n]); }
function temaIcone(t){ return ({medieval:"⚜",horror:"🦇",lovecraft:"🐙",anos80:"🕹️",scifi:"🛸",samurai:"⛩️"})[t]||"⚜"; }
function aplicarTema(t){ document.body.setAttribute("data-tema", t||"medieval"); }
function escolherTema(inputId,t,btn){ var h=document.getElementById(inputId); if(h)h.value=t; var bs=btn.parentNode.querySelectorAll(".tema-opt"); for(var i=0;i<bs.length;i++)bs[i].classList.remove("on"); btn.classList.add("on"); aplicarTema(t); }
function seletorTema(inputId,atual){ atual=atual||"medieval"; var temas=[["medieval","⚔ Medieval","D&D"],["horror","🦇 Horror","Vampiro"],["lovecraft","🐙 Lovecraft","Cthulhu"],["anos80","📼 Anos 80","Tales from the Loop"],["scifi","🚀 Sci-fi","Cyberpunk / Duna"],["samurai","🎴 Samurai","L5R"]]; return '<input type="hidden" id="'+inputId+'" value="'+esc(atual)+'"><div class="tema-grid">'+temas.map(function(t){return '<button type="button" class="tema-opt tema-sw-'+t[0]+(t[0]===atual?" on":"")+'" data-t="'+t[0]+'" onclick="escolherTema(\''+inputId+'\',\''+t[0]+'\',this)"><span class="tema-nm">'+t[1]+'</span><span class="tema-sub">'+t[2]+'</span></button>';}).join("")+'</div>'; }
function guiaCard(ic,tit,txt){ return '<div class="guia-card"><div class="gc-ic">'+ic+'</div><h3>'+tit+'</h3><p>'+txt+'</p></div>'; }
function telaGuia(){ layout(
 '<div class="bread"><a onclick="go(\'home\')">Início</a> › Guia de uso</div>'
 +hero("Guia de Uso","Aprenda a usar a plataforma — um guia rápido para mestres e jogadores", (S.mundo?S.mundo.fundo_url:null), "", icon("open-book"))
 +'<div class="secao"><div class="sec-head"><h2>① Primeiros passos</h2></div>'
 +'<div class="guia-passos">'
   +'<div class="gp"><span class="gp-n">1</span><div><b>Entrar</b><p>Crie sua conta ou entre. Sem conta você explora o conteúdo público; com conta você cria, comenta e favorita.</p></div></div>'
   +'<div class="gp"><span class="gp-n">2</span><div><b>Escolher um mundo</b><p>Na Home, clique no card de um mundo para entrar nele.</p></div></div>'
   +'<div class="gp"><span class="gp-n">3</span><div><b>Navegar</b><p>Pela barra lateral: Enciclopédia, Linha do tempo, Personagens, Jornais e Mapas. No topo, 🔎 busca e ☰/▦ alterna lista/cards.</p></div></div>'
 +'</div></div>'
 +'<div class="secao"><div class="sec-head"><h2>② O que dá para fazer</h2></div>'
 +'<div class="guia">'
   +guiaCard("📝","Criar conteúdo","Escreva em <b>Markdown</b> (com barra de formatação e pré-visualização), cole imagens, anexe arquivos e use <code>[[Links]]</code> entre artigos.")
   +guiaCard("🧝","Personagens & Fichas","Crie personagens com foto e história. Disponibilize a <b>ficha</b> em texto ou anexando o <b>PDF</b> — com visibilidade própria.")
   +guiaCard("⚔","Mesas & Mestre","Cada campanha tem personagens, mapas, sessões e linha do tempo próprios. O mestre organiza tudo na <b>Área do Mestre</b>.")
   +guiaCard("📰","Jornais & Linha do tempo","Publique notícias em jornais do mundo e registre a cronologia na linha do tempo, com eventos ligados aos artigos.")
   +guiaCard("★","Favoritos","Salve conteúdos para acesso rápido pelo atalho <b>★ Favoritos</b> na lateral.")
   +guiaCard("💬","Comentários & 🔔 Avisos","Comente em conteúdos; o <b>sino</b> avisa quando alguém comenta no seu conteúdo ou pede acesso.")
 +'</div></div>'
 +'<div class="secao"><div class="sec-head"><h2>③ Visibilidade — o segredo do mestre</h2></div>'
 +'<div class="guia-vis"><p>Todo conteúdo tem um <b>estado</b> e uma <b>visibilidade</b>. É assim que você prepara segredos e revela na hora certa:</p>'
   +'<div class="gv-row"><span class="chip-rascunho">'+icon("quill-ink")+' rascunho</span><span>só você vê, até publicar</span></div>'
   +'<div class="gv-row">'+visChip("publico")+'<span>todos veem</span></div>'
   +'<div class="gv-row">'+visChip("mesa")+'<span>só quem participa da campanha</span></div>'
   +'<div class="gv-row">'+visChip("privado")+'<span>só você</span></div>'
   +'<div class="gv-row">'+visChip("mestre")+'<span>bastidores — só o mestre da mesa</span></div>'
 +'</div></div>'
 +'<div class="secao"><div class="sec-head"><h2>④ Temas do mundo</h2></div>'
 +'<p class="guia-p">Ao <b>criar ou editar um mundo</b>, escolha um tema visual que muda cores, fontes e ícones do site: <b>Medieval, Horror, Lovecraft, Anos 80, Sci-fi</b> ou <b>Samurai</b>. Cada mundo guarda o seu.</p></div>'
 +'<div class="guia-dicas">'
   +'<div class="gd"><h3>'+icon("drama-masks")+' Para mestres</h3><p>Prepare segredos em <b>rascunho</b> ou visibilidade <b>só mestre</b>; quando for a hora, troque para <b>público/mesa</b>. Use a <b>linha do tempo da mesa</b> e as <b>sessões</b> para registrar o que aconteceu e distribuir <b>recompensas</b> (XP, itens).</p></div>'
   +'<div class="gd"><h3>🧝 Para jogadores</h3><p>Mantenha a página do seu personagem viva: adicione <b>histórias</b> e disponibilize sua <b>ficha</b>. <b>Comente</b> e <b>favorite</b> o que achar importante. Contribua com o mundo!</p></div>'
 +'</div>'
 +'<p class="guia-cta"><a class="btn" onclick="go(\'home\')">Começar a explorar →</a></p>'
 ); }

function muralItem(p, mesaId, podeDespinar){ return '<a class="mural-item" onclick="go(\'pub\',\''+p.id+'\')"><span class="mural-pin">'+icon("position-marker")+'</span>'+(podeDespinar?'<button type="button" class="mural-x" title="Remover do mural" onclick="event.stopPropagation();despinarMural(\''+mesaId+'\',\''+p.id+'\')">✕</button>':'')+'<span class="mural-tipo">'+esc(p.tipo)+'</span><span class="mural-tit">'+esc(p.titulo)+'</span></a>'; }
function jornalResumo(c){ c=(""+(c||"")).replace(/!\[[^\]]*\]\([^)]*\)/g,"").replace(/\[([^\]]*)\]\([^)]*\)/g,"$1").replace(/[#*_>`~]/g,"").replace(/\s+/g," ").trim(); return c.slice(0,200)+(c.length>200?"…":""); }
function jornalEdicao(p, jnome){ return '<a class="jn-ed" onclick="go(\'pub\',\''+p.id+'\')"><div class="jn-mast">'+esc(jnome)+'</div><div class="jn-rule"></div><h3 class="jn-hl">'+esc(p.titulo)+'</h3><div class="jn-corpo">'+esc(jornalResumo(p.corpo))+'</div><div class="jn-foot">Ler a edição →</div></a>'; }
function jornalEdicoes(noticias, jnome){ return '<div class="jn-grid">'+noticias.map(function(p){return jornalEdicao(p,jnome);}).join("")+'</div>'; }

function pinarMural(pubId){ var mm=(S.mesas||[]).filter(mestreDe); if(!mm.length){ toast("Você precisa ser mestre de uma mesa para fixar.","erro"); return; }
  var ov=document.createElement("div"); ov.className="crop-ov";
  ov.innerHTML='<div class="crop-box" style="max-width:380px"><h3>'+icon("position-marker")+' Fixar no Mural da Mesa</h3><p class="vis-leg" style="margin:0 0 10px">Em qual mesa você quer fixar este conteúdo?</p><div class="pin-mesas">'+mm.map(function(m){return '<button type="button" class="btn sec" onclick="confirmarPin(\''+pubId+'\',\''+m.id+'\',this)">⚔ '+esc(m.nome)+'</button>';}).join("")+'</div><div style="margin-top:14px"><button type="button" class="btn sec" onclick="this.closest(\'.crop-ov\').remove()">Cancelar</button></div></div>';
  ov.onclick=function(e){ if(e.target===ov)ov.remove(); };
  document.body.appendChild(ov);
}
async function confirmarPin(pubId, mesaId, btn){ try{ var _c=await sb.from("mural_pins").select("id",{count:"exact",head:true}).eq("mesa_id",mesaId).eq("tipo","publicacao"); if(!_c.error && _c.count>=6){ toast("Limite de 6 conteúdos fixados nesta mesa — remova um para fixar outro.","erro"); var _ov=btn.closest(".crop-ov"); if(_ov)_ov.remove(); return; } var r=await sb.from("mural_pins").insert({mesa_id:mesaId,tipo:"publicacao",alvo_id:pubId,fixado_por:(S.user?S.user.id:null)}); if(r.error&&!/duplicate|unique|already/i.test(r.error.message)) throw r.error; toast(r.error?"Esse conteúdo já está fixado nessa mesa.":"Fixado no mural! 📌","ok"); var ov=btn.closest(".crop-ov"); if(ov)ov.remove(); }catch(e){ toast(e.message||(""+e),"erro"); } }
async function despinarMural(mesaId, pubId){ try{ await sb.from("mural_pins").delete().eq("mesa_id",mesaId).eq("tipo","publicacao").eq("alvo_id",pubId); toast("Removido do mural.","ok"); go("mesa",mesaId); }catch(e){ toast(e.message||(""+e),"erro"); } }

function ehAdmin(){ return !!(S.profile&&S.profile.papel_global==="admin"); }
async function excluirMundo(id){ if(!ehAdmin()){ toast("Apenas admin pode excluir mundos.","erro"); return; } var w=S.mundos.find(function(x){return x.id===id;})||{}; if(!confirm('EXCLUIR o mundo "'+(w.nome||"")+'" e TODO o conteúdo dentro dele (mesas, personagens, artigos, jornais, linha do tempo)?\n\nIsso é PERMANENTE e irreversível.')) return; if(!confirm('Última confirmação: excluir "'+(w.nome||"")+'" para sempre?')) return; try{ var r=await sb.rpc("excluir_mundo",{p_id:id}); if(r.error)throw r.error; S.mundos=S.mundos.filter(function(x){return x.id!==id;}); try{ if(localStorage.getItem("mds_mundo")===id) localStorage.removeItem("mds_mundo"); }catch(e){} S.mundo=mundoSalvo()||S.mundos[0]||null; if(S.mundo) await carregarMesas(); toast("Mundo excluído.","ok"); go("home"); }catch(e){ toast(e.message||(""+e),"erro"); } }
async function excluirMesa(id){ if(!ehAdmin()){ toast("Apenas admin pode excluir mesas.","erro"); return; } var m=(S.mesas||[]).find(function(x){return x.id===id;})||{}; if(!confirm('EXCLUIR a mesa "'+(m.nome||"")+'" e seu conteúdo (sessões, mapas, personagens da mesa, fixados)?\n\nIsso é PERMANENTE.')) return; try{ var r=await sb.rpc("excluir_mesa",{p_id:id}); if(r.error)throw r.error; if(S.mundo) await carregarMesas(); toast("Mesa excluída.","ok"); go("mundoHome"); }catch(e){ toast(e.message||(""+e),"erro"); } }

async function moverEvento(id, dir, mesaId){
  try{
    var e=await umEvento(id); if(!e)return;
    var q=sb.from("eventos").select("id,ordem,criado_em");
    if(mesaId){ q=q.eq("mesa_id",mesaId); } else { q=q.eq("mundo_id",S.mundo.id).is("mesa_id",null); }
    if(e.periodo_id){ q=q.eq("periodo_id",e.periodo_id); } else { q=q.is("periodo_id",null); }
    var r=await q.order("ordem",{nullsFirst:false}).order("criado_em");
    var list=(r.data||[]); var idx=-1; for(var i=0;i<list.length;i++){ if(list[i].id===id){idx=i;break;} }
    var j=idx+dir; if(idx<0||j<0||j>=list.length) return;
    var tmp=list[idx]; list[idx]=list[j]; list[j]=tmp;
    for(var k=0;k<list.length;k++){ var u=await sb.from("eventos").update({ordem:k+1}).eq("id",list[k].id); if(u.error)throw u.error; }
    go("linha", mesaId||"");
  }catch(err){ toast(err.message||(""+err),"erro"); }
}

function lightbox(url){ if(!url)return; var ov=document.createElement("div"); ov.className="lightbox-ov"; ov.innerHTML='<img src="'+esc(url)+'" alt="">'; ov.onclick=function(){ ov.remove(); }; document.body.appendChild(ov); }
function render(){
  aplicarTema(S.mundo&&S.mundo.tema?S.mundo.tema:"medieval");
  document.body.classList.toggle("modo-lista", S.modo==="lista");
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
  else if(t==="guia") telaGuia();
  else if(t==="creditos") telaCreditos();
  else if(t==="busca") telaBusca(S.view.arg);
  else if(t==="novaRecompensa") telaNovaRecompensa(S.view.arg);
  else if(t==="editarRecompensa") telaEditarRecompensa(S.view.arg);
  else if(t==="linha") telaLinhaTempo(S.view.arg);
  else if(t==="novoEvento") telaNovoEvento(S.view.arg);
  else if(t==="editarEvento") telaEditarEvento(S.view.arg);
  else if(t==="novoPeriodo") telaNovoPeriodo(S.view.arg);
  else if(t==="editarPeriodo") telaEditarPeriodo(S.view.arg);
  else if(t==="areaMestre") telaMestre(S.view.arg);
  else if(t==="sessao") telaSessao(S.view.arg);
  else if(t==="novaSessao") telaNovaSessao(S.view.arg);
  else if(t==="editarSessao") telaEditarSessao(S.view.arg);
  else if(t==="mundoHome") telaMundoHome();
  else if(t==="favoritos") telaFavoritos();
  else telaHome();
}
// ===== Notificações =====
function tempoRel(ts){ try{ var d=(Date.now()-new Date(ts).getTime())/1000; if(d<60)return "agora"; if(d<3600)return Math.floor(d/60)+" min"; if(d<86400)return Math.floor(d/3600)+" h"; if(d<2592000)return Math.floor(d/86400)+" d"; return new Date(ts).toLocaleDateString("pt-BR"); }catch(e){ return ""; } }
async function carregarNotifs(){ S.notifs=[]; if(!S.user)return; try{ var r=await sb.from("notificacoes").select("*").order("criado_em",{ascending:false}).limit(20); S.notifs=r.error?[]:(r.data||[]); }catch(e){} }
async function notificar(userId,tipo,texto,lt,lid){ if(!userId||!S.user||userId===S.user.id)return; try{ await sb.from("notificacoes").insert({user_id:userId,tipo:tipo,texto:texto,link_tipo:lt||null,link_id:lid||null}); }catch(e){} }
function notifListHTML(){ var ns=S.notifs||[]; var top='<div class="sino-top"><b>Notificações</b>'+(ns.some(function(x){return !x.lida;})?' <a onclick="marcarTodasLidas()">marcar todas lidas</a>':'')+'</div>'; if(!ns.length)return top+'<div class="sino-vazio">Sem notificações ainda.</div>'; return top+ns.map(function(n){ return '<a class="sino-item'+(n.lida?'':' nlida')+'" onclick="abrirNotif(\''+n.id+'\',\''+(n.link_tipo||"")+'\',\''+(n.link_id||"")+'\')"><span class="sino-tx">'+esc(n.texto)+'</span><span class="sino-data">'+tempoRel(n.criado_em)+'</span></a>'; }).join(""); }
function bellHTML(){ var n=(S.notifs||[]).filter(function(x){return !x.lida;}).length; return '<div class="sino-wrap"><button class="sino-btn" onclick="toggleNotif(event)" title="Notificações" aria-label="Notificações">'+icon("ringing-bell")+(n?'<span class="sino-ct">'+(n>9?"9+":n)+'</span>':'')+'</button><div class="sino-menu" id="sinomenu">'+notifListHTML()+'</div></div>'; }
function toggleNotif(e){ if(e)e.stopPropagation(); var m=document.getElementById("sinomenu"); if(m)m.classList.toggle("aberto"); }
async function abrirNotif(id,lt,lid){ try{ await sb.from("notificacoes").update({lida:true}).eq("id",id); var n=(S.notifs||[]).find(function(x){return x.id===id;}); if(n)n.lida=true; }catch(e){} var rt={publicacao:"pub",personagem:"personagem",jornal:"jornal",mesa:"mesa"}[lt]; if(rt&&lid){ go(rt,lid); } else { render(); } }
async function marcarTodasLidas(){ try{ await sb.from("notificacoes").update({lida:true}).eq("user_id",S.user.id).eq("lida",false); (S.notifs||[]).forEach(function(n){n.lida=true;}); render(); }catch(e){} }
async function donoDoAlvo(tipo,id){ try{ if(tipo==="mundo"){ var a=await sb.from("mundos").select("dono_id").eq("id",id).maybeSingle(); return a.data&&a.data.dono_id; } if(tipo==="mesa"){ var b=await sb.from("mesas").select("mestre_id").eq("id",id).maybeSingle(); return b.data&&b.data.mestre_id; } if(tipo==="personagem"){ var c=await sb.from("personagens").select("jogador_id").eq("id",id).maybeSingle(); return c.data&&c.data.jogador_id; } }catch(e){} return null; }
// ===== Comentários =====
async function comentariosDe(tipo,id){ var r=await sb.from("comentarios").select("*").eq("alvo_tipo",tipo).eq("alvo_id",id).order("criado_em"); return r.error?[]:(r.data||[]); }
function secaoComentarios(tipo,id,donoId){ return '<div class="secao"><div class="sec-head"><h2>💬 Comentários</h2></div><div id="coms-lista">Carregando…</div>'+(S.user?'<div class="com-form"><textarea id="com_txt" placeholder="Escreva um comentário (Markdown)…"></textarea><div style="margin-top:8px"><button class="btn" onclick="enviarComentario(\''+tipo+'\',\''+id+'\','+(donoId?"'"+donoId+"'":"null")+')">Comentar</button></div></div>':'<p class="vis-leg"><a onclick="go(\'login\')">Entre</a> para comentar.</p>')+'</div>'; }
async function renderComentarios(tipo,id){ var c=document.getElementById("coms-lista"); if(!c)return; var cs=await comentariosDe(tipo,id); var perf=await perfis(); var pf=function(uid){ return perf.find(function(x){return x.id===uid;})||{}; }; if(!cs.length){ c.innerHTML='<div class="empty">Seja o primeiro a comentar.</div>'; return; } c.innerHTML=cs.map(function(cm){ var pp=pf(cm.autor_id); var av=pp.avatar_url?'<div class="com-av" style="background-image:url('+esc(pp.avatar_url)+')"></div>':'<div class="com-av">'+esc(((pp.nome||"?")[0]||"?").toUpperCase())+'</div>'; return '<div class="com-item">'+av+'<div class="com-body"><div class="com-top"><b>'+esc(pp.nome||"Alguém")+'</b> <span class="sino-data">'+tempoRel(cm.criado_em)+'</span>'+((S.user&&cm.autor_id===S.user.id)?' <a class="com-del" onclick="excluirComentario(\''+cm.id+'\',\''+tipo+'\',\''+id+'\')">excluir</a>':'')+'</div><div class="com-corpo corpo">'+md(cm.corpo)+'</div></div></div>'; }).join(""); }
async function enviarComentario(tipo,id,donoId){ var t=val("com_txt").trim(); if(!t)return; try{ var r=await sb.from("comentarios").insert({mundo_id:(S.mundo?S.mundo.id:null),alvo_tipo:tipo,alvo_id:id,autor_id:S.user.id,corpo:t}).select().single(); if(r.error)throw r.error; var ta=document.getElementById("com_txt"); if(ta)ta.value=""; var nome=(S.profile&&S.profile.nome)?S.profile.nome:"Alguém"; notificar(donoId,"comentario",nome+" comentou em algo seu.",tipo,id); renderComentarios(tipo,id); }catch(e){ erro(e); } }
async function excluirComentario(cid,tipo,id){ if(!confirm("Excluir este comentário?"))return; try{ var r=await sb.from("comentarios").delete().eq("id",cid); if(r.error)throw r.error; renderComentarios(tipo,id); }catch(e){ erro(e); } }

function toggleUserMenu(e){ if(e)e.stopPropagation(); var m=document.getElementById("usermenu"); if(m) m.classList.toggle("aberto"); }
function toggleWorldMenu(e){ if(e)e.stopPropagation(); var w=document.getElementById("worldmenu"); if(w) w.classList.toggle("aberto"); }
document.addEventListener("click", function(e){ var wl=(e.target&&e.target.closest)?e.target.closest(".wikilink"):null; if(wl){ e.preventDefault(); irPorTitulo(wl.getAttribute("data-alvo")); } var m=document.getElementById("usermenu"); if(m) m.classList.remove("aberto"); var w=document.getElementById("worldmenu"); if(w) w.classList.remove("aberto"); var sn=document.getElementById("sinomenu"); if(sn) sn.classList.remove("aberto"); });
init();
