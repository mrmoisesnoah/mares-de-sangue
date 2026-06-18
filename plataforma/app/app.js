var sb = supabase.createClient(window.SUPA.url, window.SUPA.anon);
var app = document.getElementById("app");
var S = { user:null, profile:null, mundo:null, mundos:[], mesas:[], view:{t:"home"}, msg:"" };

function esc(s){ s=(s==null?"":""+s); return s.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;"); }
function slug(s){ return (s||"").normalize("NFD").replace(/[̀-ͯ]/g,"").toLowerCase().replace(/[^\w\s-]/g,"").trim().replace(/[\s_-]+/g,"-")||("item-"+Date.now()); }
function visChip(v){ return '<span class="chip c-'+v+'">'+esc((v||"").replace("_","+"))+'</span>'; }
function val(id){ var e=document.getElementById(id); return e?e.value:""; }
function go(t,arg){ S.view={t:t,arg:arg}; S.msg=""; window.scrollTo(0,0); render(); }
function erro(e){ S.msg='<div class="aviso">'+esc(e&&e.message?e.message:e)+'</div>'; render(); }
function md(s){ return (window.marked ? marked.parse(s||"") : esc(s||"").replace(/\n/g,"<br>")); }
function resumo(c){ var t=(c||"").replace(/[#*`>\[\]_]/g,"").replace(/\s+/g," ").trim(); return t.length>120?t.slice(0,120)+"…":t; }
function meu(p){ return p && (p.autor_id===S.user.id || (S.profile&&S.profile.papel_global==="admin")); }

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
function thumb(url, icone){
  return url ? '<div class="thumb" style="background-image:url('+url+')"></div>' : '<div class="thumb noimg">'+(icone||"📜")+'</div>';
}
function iconeTipo(t){ t=(t||"").toLowerCase();
  if(t==="mapa")return "🗺️"; if(t==="jornal")return "📰"; if(t==="personagem"||t.indexOf("personagem")>=0||t==="background")return "🧝";
  if(t==="conto")return "📖"; if(t==="cidade"||t==="local")return "🏰"; if(t==="criatura")return "🐉"; return "📜"; }
function cardPub(p){
  return '<div class="card clic" onclick="go(\'pub\',\''+p.id+'\')">'
    + thumb(p.capa_url, iconeTipo(p.tipo))
    + '<h3>'+esc(p.titulo)+'</h3>'
    + '<p style="margin:.2em 0">'+'<span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')+'</p>'
    + '<p class="res">'+esc(resumo(p.corpo))+'</p></div>';
}
function blocos(pubs){
  var g={}; pubs.forEach(function(p){ var s=secaoDe(p.tipo); var k=s[0]+"|"+s[1]; (g[k]=g[k]||[]).push(p); });
  var ks=Object.keys(g).sort(function(a,b){return parseInt(a)-parseInt(b);});
  if(!ks.length) return '<div class="empty">Nada visível ainda.</div>';
  return ks.map(function(k){ var label=k.split("|")[1];
    return '<h2>'+esc(label)+' <span style="font-size:13px;color:var(--ouro)">'+g[k].length+'</span></h2><div class="cards">'+g[k].map(cardPub).join("")+'</div>';
  }).join("");
}

// ---------- auth ----------
async function init(){
  var r = await sb.auth.getSession();
  S.user = r.data.session ? r.data.session.user : null;
  sb.auth.onAuthStateChange(function(_e, sess){ var u=sess?sess.user:null;
    if((u&&!S.user)||(!u&&S.user)){ S.user=u; if(u){carregar();}else{render();} } });
  if(S.user){ await carregar(); } else { render(); }
}
async function login(){ var r=await sb.auth.signInWithPassword({email:val("email"),password:val("senha")}); if(r.error)return erro(r.error); S.user=r.data.user; await carregar(); }
async function criarConta(){ var r=await sb.auth.signUp({email:val("email"),password:val("senha"),options:{data:{nome:val("nome")||"Aventureiro"}}});
  if(r.error)return erro(r.error);
  if(r.data.session){S.user=r.data.user; await carregar();} else { S.msg='<div class="ok">Conta criada! Confirme o e-mail (se exigido) e entre.</div>'; S.view={t:"login"}; render(); } }
async function sair(){ await sb.auth.signOut(); S.user=null; S.profile=null; S.mundo=null; render(); }

// ---------- dados ----------
async function carregar(){
  try{
    var p=await sb.from("profiles").select("*").eq("id",S.user.id).maybeSingle(); S.profile=p.data;
    var m=await sb.from("mundos").select("*").order("criado_em"); if(m.error)throw m.error;
    S.mundos=m.data||[]; S.mundo=S.mundos[0]||null;
    if(S.mundo) await carregarMesas();
    go("home");
  }catch(e){ erro(e); }
}
async function carregarMesas(){ var r=await sb.from("mesas").select("*").eq("mundo_id",S.mundo.id).order("criado_em"); S.mesas=r.error?[]:(r.data||[]); }
async function pubsDaMesa(id){ var r=await sb.from("publicacoes").select("*").eq("mesa_id",id).order("titulo"); return r.error?[]:(r.data||[]); }
async function loreDoMundo(){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).is("mesa_id",null).order("titulo"); return r.error?[]:(r.data||[]); }
async function mapasDoMundo(){ var r=await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).eq("tipo","mapa").order("titulo"); return r.error?[]:(r.data||[]); }
async function umaPub(id){ var r=await sb.from("publicacoes").select("*").eq("id",id).maybeSingle(); return r.data; }

// ---------- layout ----------
function telaLogin(novo){
  app.innerHTML='<div class="login"><h1>Mares de Sangue</h1><p class="sub">O Mundo de Skard</p>'+S.msg
    +(novo?'<input id="nome" placeholder="Seu nome de aventureiro">':'')
    +'<input id="email" type="email" placeholder="E-mail"><input id="senha" type="password" placeholder="Senha">'
    +(novo?'<button class="btn" onclick="criarConta()">Criar conta</button><p style="text-align:center;margin-top:12px"><button class="linkbtn" onclick="go(\'login\')">Já tenho conta — entrar</button></p>'
          :'<button class="btn" onclick="login()">Entrar</button><p style="text-align:center;margin-top:12px"><button class="linkbtn" onclick="go(\'signup\')">Criar uma conta</button></p>')
    +'</div>';
}
function sidebar(){
  var on=function(x){return S.view.t===x?' class="on"':'';};
  var nav='<a class="nav-home"'+on("home")+' onclick="go(\'home\')">⌂ '+esc(S.mundo?S.mundo.nome:"Mares de Sangue")+'</a>';
  if(S.mundo){
    nav+='<a'+on("lore")+' onclick="go(\'lore\')">📖 Enciclopédia do mundo</a>';
    nav+='<a'+on("mapas")+' onclick="go(\'mapas\')">🗺️ Mapas</a>';
    nav+='<h4>Mesas</h4>';
    nav+= S.mesas.length ? S.mesas.map(function(m){return '<a onclick="go(\'mesa\',\''+m.id+'\')">⚔ '+esc(m.nome)+'</a>';}).join("") : '<a style="cursor:default;color:#b3a98f">nenhuma ainda</a>';
    nav+='<h4>Criar</h4>';
    nav+='<a onclick="go(\'nova\',{mesa:null})">+ Publicação de mundo</a>';
    nav+='<a onclick="go(\'novaMesa\')">+ Nova mesa</a>';
  }
  return nav;
}
function layout(conteudo){
  app.innerHTML='<header class="topo"><div class="marca" onclick="go(\'home\')">Mares de Sangue<small>plataforma</small></div>'
    +'<div class="userbox">'+esc(S.profile?S.profile.nome:(S.user?S.user.email:""))+(S.profile&&S.profile.papel_global==="admin"?" · admin":"")
    +' &nbsp;<button class="linkbtn" style="color:#cbb892" onclick="sair()">sair</button></div></header>'
    +'<div class="layout"><aside class="lateral">'+sidebar()+'</aside><main class="conteudo">'+S.msg+conteudo+'</main></div>';
}

// ---------- telas ----------
function telaHome(){
  if(!S.mundo){
    layout('<h1>Bem-vindo!</h1><p>Crie seu primeiro mundo para começar.</p>'
      +'<div class="form"><label>Nome do mundo</label><input id="m_nome" placeholder="Ex.: Mares de Sangue">'
      +'<label>Descrição</label><textarea id="m_desc"></textarea>'
      +'<p style="margin-top:14px"><button class="btn" onclick="salvarMundo()">Criar mundo</button></p></div>'); return;
  }
  var cards=S.mesas.map(function(m){return '<div class="card clic" onclick="go(\'mesa\',\''+m.id+'\')">'+thumb(m.capa_url,"⚔")+'<h3>'+esc(m.nome)+'</h3><p class="res">'+esc(m.descricao||"")+'</p></div>';}).join("");
  layout('<div class="bread">Mundo</div><h1>'+esc(S.mundo.nome)+'</h1><p>'+esc(S.mundo.descricao||"")+'</p>'
    +'<p><a class="btn" onclick="go(\'lore\')">📖 Enciclopédia</a> <a class="btn sec" onclick="go(\'mapas\')">🗺️ Mapas</a></p>'
    +'<h2>Mesas <span style="font-size:13px;color:var(--ouro)">'+S.mesas.length+'</span></h2>'
    +'<div class="cards">'+(cards||'<div class="empty">Nenhuma mesa. Crie uma no menu lateral.</div>')+'</div>');
}
async function telaLore(){ layout('<p>Carregando…</p>'); var lore=await loreDoMundo();
  layout('<div class="bread">Mundo › Enciclopédia</div><h1>Enciclopédia de '+esc(S.mundo.nome)+'</h1>'
    +'<p><a class="btn" onclick="go(\'nova\',{mesa:null})">+ Nova publicação de mundo</a></p>'+blocos(lore)); }
async function telaMapas(){ layout('<p>Carregando…</p>'); var mp=await mapasDoMundo();
  var cards=mp.map(function(p){return '<div class="card clic" onclick="go(\'pub\',\''+p.id+'\')">'+thumb(p.capa_url,"🗺️")+'<h3>'+esc(p.titulo)+'</h3><p style="margin:.2em 0"><span class="tipo">'+esc(p.categoria||"mapa")+'</span>'+visChip(p.visibilidade)+'</p></div>';}).join("");
  layout('<div class="bread">Mundo › Mapas</div><h1>🗺️ Mapas</h1>'
    +'<p><a class="btn" onclick="go(\'nova\',{mesa:null,tipo:\'mapa\'})">+ Novo mapa</a></p>'
    +'<div class="cards">'+(cards||'<div class="empty">Nenhum mapa visível ainda.</div>')+'</div>'); }
async function telaMesa(id){
  layout('<p>Carregando…</p>'); var mesa=S.mesas.find(function(m){return m.id===id;});
  if(!mesa){ layout('<div class="aviso">Mesa não encontrada.</div>'); return; }
  var pubs=await pubsDaMesa(id);
  layout('<div class="bread">Mundo › '+esc(mesa.nome)+'</div><h1>⚔ '+esc(mesa.nome)+'</h1><p>'+esc(mesa.descricao||"")+'</p>'
    +'<p><a class="btn" onclick="go(\'nova\',{mesa:\''+id+'\'})">+ Publicação</a> '
    +'<a class="btn sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'personagem\'})">+ Personagem</a> '
    +'<a class="btn sec" onclick="go(\'nova\',{mesa:\''+id+'\',tipo:\'mapa\'})">+ Mapa</a></p>'
    +blocos(pubs)); }
async function telaPub(id){
  layout('<p>Carregando…</p>'); var p=await umaPub(id);
  if(!p){ layout('<div class="aviso">Publicação não encontrada ou sem permissão.</div>'); return; }
  var mid=await sb.from("midias").select("*").eq("publicacao_id",id); var media="";
  if(mid.data){ mid.data.forEach(function(m){ media += (m.tipo==="video")?'<p class="vis-leg">🎬 <a href="'+esc(m.url)+'" target="_blank">'+esc(m.legenda||m.url)+'</a></p>':'<img class="capa" src="'+esc(m.url)+'" alt="">'; }); }
  var voltar = p.mesa_id ? "go('mesa','"+p.mesa_id+"')" : (p.tipo==="mapa"?"go('mapas')":"go('lore')");
  var acoes = meu(p) ? '<p style="margin-top:18px"><a class="btn sec" onclick="go(\'editar\',\''+p.id+'\')">✎ Editar</a> <button class="btn sec" style="border-color:#c08" onclick="excluirPub(\''+p.id+'\','+(p.mesa_id?"'"+p.mesa_id+"'":"null")+')">🗑 Excluir</button></p>' : '';
  layout('<div class="bread"><a onclick="'+voltar+'">‹ voltar</a></div><h1>'+esc(p.titulo)+'</h1>'
    +'<p><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')+'</p>'
    +(p.tags&&p.tags.length?'<p class="vis-leg">'+p.tags.map(esc).join(", ")+'</p>':'')
    +(p.capa_url?'<img class="capa" src="'+esc(p.capa_url)+'" alt="">':'')
    +media+'<div class="corpo">'+md(p.corpo)+'</div>'+acoes); }

var TIPOS=['conto','background','diário de personagem','personagem','mapa','cidade','facção','região','reino','religião','criatura','item','evento histórico','história do mundo','resumo de sessão','crônica','planejamento do mestre','anotação privada'];
function formPub(opts, p){
  var mesaId=opts.mesa||(p?p.mesa_id:null);
  var tipoSel=(p?p.tipo:opts.tipo)||"conto";
  var visOpts=mesaId
    ?[["mesa","mesa (todos da campanha)"],["publico","público (todos)"],["autor_mestre","autor + mestre"],["privado","privado (só eu)"],["mestre","só mestre"]]
    :[["publico","público (todos)"],["privado","privado (só eu)"]];
  function opt(arr,sel){return arr.map(function(o){var v=o[0]||o,l=o[1]||o;return '<option value="'+v+'"'+(sel===v?' selected':'')+'>'+l+'</option>';}).join("");}
  return '<div class="bread">'+(p?'Editar':'Nova')+' publicação</div><h1>'+(p?'Editar publicação':'Nova publicação')+'</h1>'
    +'<div class="form">'
    +'<label>Tipo</label><select id="f_tipo">'+opt(TIPOS,tipoSel)+'</select>'
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
  +'<p style="margin-top:14px"><button class="btn" onclick="salvarMesa()">Criar mesa</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>'); }

// ---------- gravações ----------
async function salvarMundo(){ try{ var n=val("m_nome").trim(); if(!n)return erro("Dê um nome ao mundo.");
  var r=await sb.from("mundos").insert({nome:n,slug:slug(n),descricao:val("m_desc"),dono_id:S.user.id,publico:true}).select().single();
  if(r.error)throw r.error; S.mundos=[r.data]; S.mundo=r.data; await carregarMesas(); go("home"); }catch(e){erro(e);} }
async function salvarMesa(){ try{ var n=val("me_nome").trim(); if(!n)return erro("Dê um nome à mesa.");
  var r=await sb.from("mesas").insert({mundo_id:S.mundo.id,nome:n,slug:slug(n),descricao:val("me_desc"),mestre_id:S.user.id}).select().single();
  if(r.error)throw r.error; await carregarMesas(); go("mesa",r.data.id); }catch(e){erro(e);} }
async function salvarPub(mesaId, editId){ try{
  var titulo=val("f_titulo").trim(); if(!titulo)return erro("Dê um título.");
  var reg={ tipo:val("f_tipo"), titulo:titulo, slug:slug(titulo), corpo:val("f_corpo"),
    tags:val("f_tags").split(",").map(function(s){return s.trim();}).filter(Boolean),
    estado:val("f_estado"), visibilidade:val("f_vis") };
  var capa=val("f_capa").trim(); if(capa) reg.capa_url=capa; else reg.capa_url=null;
  if(reg.tipo==="mapa") reg.categoria=reg.categoria||"mapa";
  if(editId){ var u=await sb.from("publicacoes").update(reg).eq("id",editId); if(u.error)throw u.error; go("pub",editId); }
  else { reg.mundo_id=S.mundo.id; reg.mesa_id=mesaId||null; reg.autor_id=S.user.id;
    var r=await sb.from("publicacoes").insert(reg).select().single(); if(r.error)throw r.error; go("pub",r.data.id); }
}catch(e){ erro(e); } }
async function excluirPub(id, mesaId){ if(!confirm("Excluir esta publicação? Não dá para desfazer.")) return;
  try{ var r=await sb.from("publicacoes").delete().eq("id",id); if(r.error)throw r.error; if(mesaId) go("mesa",mesaId); else go("lore"); }catch(e){erro(e);} }

function render(){
  if(!S.user){ telaLogin(S.view.t==="signup"); return; }
  var t=S.view.t;
  if(t==="lore") telaLore();
  else if(t==="mapas") telaMapas();
  else if(t==="mesa") telaMesa(S.view.arg);
  else if(t==="pub") telaPub(S.view.arg);
  else if(t==="nova") telaNova(S.view.arg);
  else if(t==="editar") telaEditar(S.view.arg);
  else if(t==="novaMesa") telaNovaMesa();
  else telaHome();
}
init();
