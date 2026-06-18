var sb = supabase.createClient(window.SUPA.url, window.SUPA.anon);
var app = document.getElementById("app");
var S = { user:null, profile:null, mundo:null, mundos:[], mesas:[], view:{t:"home"}, msg:"", pubAtual:null, nomes:{}, expl:{pubs:[],q:"",cat:null} };

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

function secaoDe(tipo){
  var t=(tipo||"").toLowerCase();
  if(t==="jornal") return [5,"Jornais"];
  if(t==="canone"||t==="cânone") return [1,"Cânone do Mundo"];
  if(t==="conto") return [6,"Contos e Narrativas"];
  if(t==="mapa") return [7,"Mapas"];
  if(["background","diário de personagem","diario de personagem","personagem"].indexOf(t)>=0) return [11,"Personagens & Histórias"];
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
  if(t==="mapa")return "🗺️"; if(t==="jornal")return "📰"; if(t.indexOf("personagem")>=0||t==="background")return "🧝";
  if(t==="conto")return "📖"; if(t==="cidade"||t==="local")return "🏰"; if(t==="criatura")return "🐉"; if(t==="item")return "⚔"; return "📜"; }
function thumb(url, icone){ return url ? '<div class="thumb" style="background-image:url('+url+')"></div>' : '<div class="thumb noimg">'+(icone||"📜")+'</div>'; }
function cardPub(p){
  return '<div class="card clic" onclick="go(\'pub\',\''+p.id+'\')">'+thumb(p.capa_url, iconeTipo(p.tipo))
    +'<h3>'+esc(p.titulo)+'</h3>'
    +'<p style="margin:.2em 0"><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')+'</p>'
    +'<p class="res">'+esc(resumo(p.corpo))+'</p></div>';
}
function hero(titulo, sub, fundo, acts){
  return '<div class="hero2">'+(fundo?'<div class="bg" style="background-image:url('+esc(fundo)+')"></div>':'')+'<div class="ov"></div>'
    +'<div class="in"><h1>'+esc(titulo)+'</h1>'+(sub?'<p>'+esc(sub)+'</p>':'')+(acts?'<div class="acts">'+acts+'</div>':'')+'</div></div>';
}

// ===== Explorador: cards de categoria + filtro + abas retráteis =====
function abrirExplorador(pubs){ S.expl={pubs:pubs,q:"",cat:null}; }
function exploradorHTML(){
  return '<input class="expq" id="expq" placeholder="🔎 Filtrar por título, tag ou texto…" oninput="explBusca(this.value)">'
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
  var aberto=(q||cat!=null); // filtrando => abre; senão, abas recolhidas
  return ks.map(function(k){ var label=k.split("|")[1];
    return '<details class="bloco"'+(aberto?' open':'')+'><summary>'+(ICON_SEC[label]||"📄")+' '+esc(label)+' <span class="ct">'+g[k].length+'</span></summary><div class="cards">'+g[k].map(cardPub).join("")+'</div></details>';
  }).join("");
}
function renderExpl(){ var c=document.getElementById("expcats"), o=document.getElementById("expconteudo"); if(c)c.innerHTML=explCats(); if(o)o.innerHTML=explConteudo(); }
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
    S.mundos=m.data||[]; S.mundo=S.mundos[0]||null; go("home");
  }catch(e){ erro(e); }
}
async function carregarMesas(){ var r=await sb.from("mesas").select("*").eq("mundo_id",S.mundo.id).order("criado_em"); S.mesas=r.error?[]:(r.data||[]); }
async function pubsDaMesa(id){ var r=await sb.from("publicacoes").select("*").eq("mesa_id",id).order("titulo"); return r.error?[]:(r.data||[]); }
async function loreDoMundo(){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).is("mesa_id",null).order("titulo"); return r.error?[]:(r.data||[]); }
async function recentes(){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).order("criado_em",{ascending:false}).limit(6); return r.error?[]:(r.data||[]); }
async function pubsDoAutor(uid){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).eq("autor_id",uid).order("titulo"); return r.error?[]:(r.data||[]); }
async function umaPub(id){ var r=await sb.from("publicacoes").select("*").eq("id",id).maybeSingle(); return r.data; }
async function nomeDe(uid){ if(S.nomes[uid])return S.nomes[uid]; var r=await sb.from("profiles").select("nome").eq("id",uid).maybeSingle(); var n=r.data?r.data.nome:"Autor"; S.nomes[uid]=n; return n; }

// ---------- layout ----------
function telaLogin(novo){
  app.innerHTML='<div class="login"><h1>Mares de Sangue</h1><p class="sub">O Mundo de Skard</p>'+S.msg
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
    nav+='<a'+on("lore")+' onclick="go(\'lore\')">📖 Enciclopédia</a>';
    nav+='<a'+on("mapas")+' onclick="go(\'mapas\')">🗺️ Mapas</a>';
    if(S.user){
      nav+='<a onclick="go(\'autor\',\''+S.user.id+'\')">👤 Minha página</a>';
      if(donoMundo()) nav+='<a onclick="go(\'editarMundo\')">✎ Editar mundo</a>';
      nav+='<h4>Mesas</h4>';
      nav+= S.mesas.length ? S.mesas.map(function(m){return '<a onclick="go(\'mesa\',\''+m.id+'\')">⚔ '+esc(m.nome)+'</a>';}).join("") : '<a style="cursor:default;color:#b3a98f">nenhuma ainda</a>';
      nav+='<h4>Criar</h4><a onclick="go(\'nova\',{mesa:null})">+ Publicação de mundo</a><a onclick="go(\'novaMesa\')">+ Nova mesa</a>';
    } else {
      nav+='<a onclick="go(\'login\')">🔑 Entrar para participar</a>';
    }
  }
  return nav;
}
function layout(conteudo){
  var ub = S.user
    ? esc(S.profile?S.profile.nome:S.user.email)+(S.profile&&S.profile.papel_global==="admin"?" · admin":"")+' &nbsp;<button class="linkbtn" style="color:#cbb892" onclick="sair()">sair</button>'
    : '<button class="btn mini" onclick="go(\'login\')">Entrar</button>';
  app.innerHTML='<header class="topo"><div class="marca" onclick="go(\'home\')">Mares de Sangue<small>plataforma</small></div>'
    +'<div class="userbox">'+ub+'</div></header>'
    +'<div class="layout"><aside class="lateral">'+sidebar()+'</aside><main class="conteudo">'+S.msg+conteudo+'</main></div>';
}

// ---------- telas ----------
async function telaHome(){
  if(!S.mundo){
    if(!S.user){ layout('<h1>Mares de Sangue</h1><p>Nenhum mundo público disponível no momento.</p><p><a class="btn" onclick="go(\'login\')">Entrar</a></p>'); return; }
    layout('<h1>Bem-vindo!</h1><p>Crie seu primeiro mundo para começar.</p>'
      +'<div class="form"><label>Nome do mundo</label><input id="m_nome" placeholder="Ex.: Mares de Sangue">'
      +'<label>Descrição</label><textarea id="m_desc"></textarea>'
      +'<p style="margin-top:14px"><button class="btn" onclick="salvarMundo()">Criar mundo</button></p></div>'); return;
  }
  layout('<p>Carregando…</p>');
  var lore=await loreDoMundo(); var recs=await recentes();
  var nMesas=S.mesas.length, nLore=lore.length, nMapas=lore.filter(function(p){return p.tipo==="mapa";}).length;
  var acts=(donoMundo()?'<a class="btn sec" onclick="go(\'editarMundo\')">✎ Editar mundo</a> ':'')+'<a class="btn" onclick="go(\'lore\')">📖 Enciclopédia</a>'+(!S.user?' <a class="btn sec" onclick="go(\'login\')">Entrar</a>':'');
  var mesasCards=S.mesas.map(function(m){return '<div class="card clic" onclick="go(\'mesa\',\''+m.id+'\')">'+thumb(m.capa_url,"⚔")+'<h3>'+esc(m.nome)+'</h3><p class="res">'+esc(m.descricao||"")+'</p></div>';}).join("");
  var recCards=recs.map(cardPub).join("");
  layout(hero(S.mundo.nome, S.mundo.descricao||"O Mundo de Skard", S.mundo.fundo_url, acts)
    +'<div class="stats"><div class="stat"><b>'+nLore+'</b><span>artigos do mundo</span></div>'
      +'<div class="stat"><b>'+nMesas+'</b><span>mesas</span></div><div class="stat"><b>'+nMapas+'</b><span>mapas</span></div></div>'
    +(S.user?'<h2>Mesas</h2><div class="cards">'+(mesasCards||'<div class="empty">Nenhuma mesa ainda — crie no menu lateral.</div>')+'</div>':'')
    +(recCards?'<h2>Adições recentes</h2><div class="cards">'+recCards+'</div>':'')
    +'<p style="margin-top:14px"><a class="btn" onclick="go(\'lore\')">Explorar a Enciclopédia ›</a></p>');
}
async function telaLore(){ layout('<p>Carregando…</p>'); var lore=await loreDoMundo(); abrirExplorador(lore);
  layout(hero("Enciclopédia de "+S.mundo.nome,"Filtre por categoria, busque, abra as seções", S.mundo.fundo_url, (S.user?'<a class="btn" onclick="go(\'nova\',{mesa:null})">+ Nova publicação</a>':''))+exploradorHTML());
  renderExpl(); }
async function telaMapas(){ layout('<p>Carregando…</p>'); var lore=await loreDoMundo(); var mp=lore.filter(function(p){return p.tipo==="mapa";});
  var cards=mp.map(function(p){return '<div class="card clic" onclick="go(\'pub\',\''+p.id+'\')">'+thumb(p.capa_url,"🗺️")+'<h3>'+esc(p.titulo)+'</h3><p style="margin:.2em 0"><span class="tipo">'+esc(p.categoria||"mapa")+'</span>'+visChip(p.visibilidade)+'</p></div>';}).join("");
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mapas</div><h1>🗺️ Mapas</h1>'
    +(S.user?'<p><a class="btn" onclick="go(\'nova\',{mesa:null,tipo:\'mapa\'})">+ Novo mapa</a></p>':'')
    +'<div class="cards">'+(cards||'<div class="empty">Nenhum mapa visível ainda.</div>')+'</div>'); }
async function telaMesa(id){ layout('<p>Carregando…</p>'); var mesa=S.mesas.find(function(m){return m.id===id;});
  if(!mesa){ layout('<div class="aviso">Mesa não encontrada (ou você não é membro).</div>'); return; }
  var pubs=await pubsDaMesa(id); abrirExplorador(pubs);
  var acts='<a class="btn" onclick="go(\'nova\',{mesa:\''+id+'\'})">+ Publicação</a> '
    +'<a class="btn sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'personagem\'})">+ Personagem</a> '
    +'<a class="btn sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'mapa\'})">+ Mapa</a>'
    +(mestreDe(mesa)?' <a class="btn sec" onclick="go(\'editarMesa\',\''+id+'\')">✎ Editar mesa</a>':'');
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › Mesa</div>'+hero("⚔ "+mesa.nome, mesa.descricao||"", mesa.fundo_url, acts)+exploradorHTML());
  renderExpl(); }
async function telaAutor(uid){ layout('<p>Carregando…</p>'); var nome=await nomeDe(uid); var pubs=await pubsDoAutor(uid); abrirExplorador(pubs);
  var ehEu=(S.user&&uid===S.user.id);
  var av='<div class="av">'+(nome?esc(nome[0].toUpperCase()):"?")+'</div>';
  layout('<div class="bread"><a onclick="go(\'home\')">Início</a> › '+(ehEu?"Minha página":"Autor")+'</div>'
    +'<div class="autor-cap">'+av+'<div><h1 style="margin:0">'+esc(nome)+'</h1><p class="vis-leg">'+pubs.length+' publicações visíveis neste mundo'+(ehEu?" · esta é a sua página":"")+'</p></div></div>'
    +(ehEu?'<p><a class="btn" onclick="go(\'nova\',{mesa:null})">+ Nova publicação</a></p>':'')+exploradorHTML());
  renderExpl(); }
async function telaPub(id){ layout('<p>Carregando…</p>'); var p=await umaPub(id); S.pubAtual=p;
  if(!p){ layout('<div class="aviso">Publicação não encontrada ou sem permissão.</div>'); return; }
  var nomeAutor=await nomeDe(p.autor_id);
  var mid=await sb.from("midias").select("*").eq("publicacao_id",id); var media="";
  if(mid.data){ mid.data.forEach(function(m){ media += (m.tipo==="video")?'<p class="vis-leg">🎬 <a href="'+esc(m.url)+'" target="_blank">'+esc(m.legenda||m.url)+'</a></p>':'<img class="capa" src="'+esc(m.url)+'" alt="">'; }); }
  var voltar = p.mesa_id ? "go('mesa','"+p.mesa_id+"')" : (p.tipo==="mapa"?"go('mapas')":"go('lore')");
  var extra="";
  if((p.tipo||"").toLowerCase().indexOf("personagem")>=0 || p.tipo==="background"){
    var outros=(await pubsDoAutor(p.autor_id)).filter(function(x){return x.id!==p.id && x.mesa_id===p.mesa_id;});
    if(outros.length){ abrirExplorador(outros); extra='<h2>Mais textos de '+esc(nomeAutor)+'</h2>'+exploradorHTML(); }
  }
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
function opt(arr,sel){ return arr.map(function(o){var v=o[0]||o,l=o[1]||o;return '<option value="'+v+'"'+(sel===v?' selected':'')+'>'+l+'</option>';}).join(""); }
function formPub(opts, p){
  var mesaId=opts.mesa||(p?p.mesa_id:null); var tipoSel=(p?p.tipo:opts.tipo)||"conto";
  var visOpts=mesaId?[["mesa","mesa (todos da campanha)"],["publico","público (todos)"],["autor_mestre","autor + mestre"],["privado","privado (só eu)"],["mestre","só mestre"]]:[["publico","público (todos)"],["privado","privado (só eu)"]];
  return '<div class="bread">'+(p?'Editar':'Nova')+' publicação</div><h1>'+(p?'Editar publicação':'Nova publicação')+'</h1>'
    +'<div class="form"><label>Tipo</label><select id="f_tipo">'+opt(TIPOS,tipoSel)+'</select>'
    +'<label>Título</label><input id="f_titulo" value="'+esc(p?p.titulo:"")+'">'
    +'<label>Imagem de capa — link (opcional)</label><input id="f_capa" value="'+esc(p&&p.capa_url?p.capa_url:"")+'" placeholder="https://…">'
    +'<label>Texto (Markdown)</label><textarea id="f_corpo">'+esc(p?p.corpo:"")+'</textarea>'
    +'<div class="row"><div><label>Tags (vírgula)</label><input id="f_tags" value="'+esc(p&&p.tags?p.tags.join(", "):"")+'"></div>'
    +'<div><label>Estado</label><select id="f_estado">'+opt([["publicado","publicado"],["rascunho","rascunho"]],p?p.estado:"publicado")+'</select></div>'
    +'<div><label>Visibilidade</label><select id="f_vis">'+opt(visOpts,p?p.visibilidade:(mesaId?"mesa":"publico"))+'</select></div></div>'
    +'<p style="margin-top:16px"><button class="btn" onclick="salvarPub('+(mesaId?"'"+mesaId+"'":"null")+','+(p?"'"+p.id+"'":"null")+')">'+(p?'Salvar':'Publicar')+'</button> '
    +'<button class="btn sec" onclick="'+(mesaId?"go('mesa','"+mesaId+"')":"go('lore')")+'">Cancelar</button></p></div>';
}
function telaNova(opts){ layout(formPub(opts||{},null)); }
async function telaEditar(id){ layout('<p>Carregando…</p>'); var p=await umaPub(id); if(!p){layout('<div class="aviso">Sem permissão.</div>');return;} layout(formPub({mesa:p.mesa_id},p)); }
function telaNovaMesa(){ layout('<div class="bread">Nova mesa</div><h1>Nova mesa</h1>'
  +'<div class="form"><label>Nome</label><input id="me_nome"><label>Descrição</label><textarea id="me_desc"></textarea>'
  +'<label>Imagem de capa — link</label><input id="me_capa" placeholder="https://…">'
  +'<label>Imagem de fundo — link</label><input id="me_fundo" placeholder="https://…">'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMesa()">Criar mesa</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'); }
function telaEditarMundo(){ var w=S.mundo;
  layout('<div class="bread">Editar mundo</div><h1>Editar mundo</h1>'
  +'<div class="form"><label>Nome</label><input id="w_nome" value="'+esc(w.nome)+'">'
  +'<label>Descrição</label><textarea id="w_desc">'+esc(w.descricao||"")+'</textarea>'
  +'<label>Imagem de fundo (hero) — link</label><input id="w_fundo" value="'+esc(w.fundo_url||"")+'" placeholder="https://…">'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMundoEdit()">Salvar</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'); }
function telaEditarMesa(id){ var m=S.mesas.find(function(x){return x.id===id;}); if(!m){layout('<div class="aviso">Mesa não encontrada.</div>');return;}
  layout('<div class="bread">Editar mesa</div><h1>Editar mesa</h1>'
  +'<div class="form"><label>Nome</label><input id="me_nome" value="'+esc(m.nome)+'">'
  +'<label>Descrição</label><textarea id="me_desc">'+esc(m.descricao||"")+'</textarea>'
  +'<label>Imagem de fundo (hero) — link</label><input id="me_fundo" value="'+esc(m.fundo_url||"")+'" placeholder="https://…">'
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMesaEdit(\''+id+'\')">Salvar</button> <button class="btn sec" onclick="go(\'mesa\',\''+id+'\')">Cancelar</button></p></div>'); }

// ---------- gravações ----------
async function salvarMundo(){ try{ var n=val("m_nome").trim(); if(!n)return erro("Dê um nome ao mundo.");
  var r=await sb.from("mundos").insert({nome:n,slug:slug(n),descricao:val("m_desc"),dono_id:S.user.id,publico:true}).select().single();
  if(r.error)throw r.error; S.mundos=[r.data]; S.mundo=r.data; await carregarMesas(); go("home"); }catch(e){erro(e);} }
async function salvarMundoEdit(){ try{ var upd={nome:val("w_nome").trim(),descricao:val("w_desc"),fundo_url:val("w_fundo").trim()||null};
  var r=await sb.from("mundos").update(upd).eq("id",S.mundo.id).select().single(); if(r.error)throw r.error; S.mundo=r.data; S.mundos[0]=r.data; go("home"); }catch(e){erro(e);} }
async function salvarMesa(){ try{ var n=val("me_nome").trim(); if(!n)return erro("Dê um nome à mesa.");
  var reg={mundo_id:S.mundo.id,nome:n,slug:slug(n),descricao:val("me_desc"),mestre_id:S.user.id};
  var c=val("me_capa").trim(); if(c)reg.capa_url=c; var f=val("me_fundo").trim(); if(f)reg.fundo_url=f;
  var r=await sb.from("mesas").insert(reg).select().single(); if(r.error)throw r.error; await carregarMesas(); go("mesa",r.data.id); }catch(e){erro(e);} }
async function salvarMesaEdit(id){ try{ var upd={nome:val("me_nome").trim(),descricao:val("me_desc"),fundo_url:val("me_fundo").trim()||null};
  var r=await sb.from("mesas").update(upd).eq("id",id).select().single(); if(r.error)throw r.error; await carregarMesas(); go("mesa",id); }catch(e){erro(e);} }
async function salvarPub(mesaId, editId){ try{
  var titulo=val("f_titulo").trim(); if(!titulo)return erro("Dê um título.");
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

function render(){
  if(!S.user && (S.view.t==="login"||S.view.t==="signup")){ telaLogin(S.view.t==="signup"); return; }
  var t=S.view.t;
  if(t==="lore") telaLore();
  else if(t==="mapas") telaMapas();
  else if(t==="mesa") telaMesa(S.view.arg);
  else if(t==="autor") telaAutor(S.view.arg);
  else if(t==="pub") telaPub(S.view.arg);
  else if(t==="nova") telaNova(S.view.arg);
  else if(t==="editar") telaEditar(S.view.arg);
  else if(t==="editarMundo") telaEditarMundo();
  else if(t==="editarMesa") telaEditarMesa(S.view.arg);
  else if(t==="novaMesa") telaNovaMesa();
  else telaHome();
}
init();
