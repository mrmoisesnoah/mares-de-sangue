var sb = supabase.createClient(window.SUPA.url, window.SUPA.anon);
var app = document.getElementById("app");
var S = { user:null, profile:null, mundo:null, mundos:[], mesas:[], view:{t:"home"}, msg:"" };

function esc(s){ s=(s==null?"":""+s); return s.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;"); }
function slug(s){ return (s||"").normalize("NFD").replace(/[̀-ͯ]/g,"").toLowerCase().replace(/[^\w\s-]/g,"").trim().replace(/[\s_-]+/g,"-")||("item-"+Date.now()); }
function visChip(v){ return '<span class="chip c-'+v+'">'+esc((v||"").replace("_","+"))+'</span>'; }
function val(id){ var e=document.getElementById(id); return e?e.value:""; }
function go(t,arg){ S.view={t:t,arg:arg}; S.msg=""; window.scrollTo(0,0); render(); }
function erro(e){ S.msg='<div class="aviso">'+esc(e&&e.message?e.message:e)+'</div>'; render(); }

// ---------- auth ----------
async function init(){
  var r = await sb.auth.getSession();
  S.user = r.data.session ? r.data.session.user : null;
  sb.auth.onAuthStateChange(function(_e, sess){
    var u = sess?sess.user:null;
    if((u&&!S.user)||(!u&&S.user)){ S.user=u; if(u){carregar();}else{render();} }
  });
  if(S.user){ await carregar(); } else { render(); }
}
async function login(){
  var r = await sb.auth.signInWithPassword({email:val("email"), password:val("senha")});
  if(r.error) return erro(r.error);
  S.user=r.data.user; await carregar();
}
async function criarConta(){
  var r = await sb.auth.signUp({email:val("email"), password:val("senha"), options:{data:{nome:val("nome")||"Aventureiro"}}});
  if(r.error) return erro(r.error);
  if(r.data.session){ S.user=r.data.user; await carregar(); }
  else { S.msg='<div class="ok">Conta criada! Se o projeto exige confirmação de e-mail, confirme e depois entre. Caso contrário, é só entrar.</div>'; S.view={t:"login"}; render(); }
}
async function sair(){ await sb.auth.signOut(); S.user=null; S.profile=null; S.mundo=null; render(); }

// ---------- dados ----------
async function carregar(){
  try{
    var p = await sb.from("profiles").select("*").eq("id",S.user.id).maybeSingle();
    S.profile = p.data;
    var m = await sb.from("mundos").select("*").order("criado_em");
    if(m.error) throw m.error;
    S.mundos = m.data||[];
    S.mundo = S.mundos[0]||null;
    if(S.mundo) await carregarMesas();
    go("home");
  }catch(e){ erro(e); }
}
async function carregarMesas(){
  var r = await sb.from("mesas").select("*").eq("mundo_id",S.mundo.id).order("criado_em");
  S.mesas = r.error?[]:(r.data||[]);
}
async function pubsDaMesa(mesaId){
  var r = await sb.from("publicacoes").select("*").eq("mesa_id",mesaId).order("criado_em",{ascending:false});
  return r.error?[]:(r.data||[]);
}
async function loreDoMundo(){
  var r = await sb.from("publicacoes").select("*").eq("mundo_id",S.mundo.id).is("mesa_id",null).order("titulo");
  return r.error?[]:(r.data||[]);
}

// ---------- telas ----------
function telaLogin(novo){
  app.innerHTML = '<div class="login"><h1>Mares de Sangue</h1><p class="sub">O Mundo de Skard</p>'
    + S.msg
    + (novo?'<input id="nome" placeholder="Seu nome de aventureiro">':'')
    + '<input id="email" type="email" placeholder="E-mail">'
    + '<input id="senha" type="password" placeholder="Senha">'
    + (novo
        ? '<button class="btn" onclick="criarConta()">Criar conta</button><p style="text-align:center;margin-top:12px"><button class="linkbtn" onclick="go(\'login\')">Já tenho conta — entrar</button></p>'
        : '<button class="btn" onclick="login()">Entrar</button><p style="text-align:center;margin-top:12px"><button class="linkbtn" onclick="go(\'signup\')">Criar uma conta</button></p>')
    + '</div>';
}

function layout(conteudo){
  var nav = '<a class="nav-home" onclick="go(\'home\')">⌂ '+esc(S.mundo?S.mundo.nome:"Mares de Sangue")+'</a>';
  if(S.mundo){
    nav += '<a onclick="go(\'lore\')">Lore do mundo</a><h4>Mesas</h4>';
    nav += S.mesas.length ? S.mesas.map(function(m){return '<a onclick="go(\'mesa\',\''+m.id+'\')">'+esc(m.nome)+'</a>';}).join("")
                          : '<a class="empty" style="cursor:default">nenhuma ainda</a>';
    nav += '<a onclick="go(\'novaMesa\')">+ Nova mesa</a>';
  }
  app.innerHTML = '<header class="topo"><div class="marca" onclick="go(\'home\')">Mares de Sangue<small>plataforma</small></div>'
    + '<div class="userbox">'+esc(S.profile?S.profile.nome:(S.user?S.user.email:""))+(S.profile&&S.profile.papel_global==="admin"?" · admin":"")
    + ' &nbsp;<button class="linkbtn" style="color:#cbb892" onclick="sair()">sair</button></div></header>'
    + '<div class="layout"><aside class="lateral">'+nav+'</aside><main class="conteudo">'+S.msg+conteudo+'</main></div>';
}

function telaHome(){
  if(!S.mundo){
    layout('<h1>Bem-vindo!</h1><p>Você ainda não tem um mundo. Crie o primeiro cenário para começar.</p>'
      +'<div class="form"><label>Nome do mundo</label><input id="m_nome" placeholder="Ex.: Mares de Sangue">'
      +'<label>Descrição</label><textarea id="m_desc" placeholder="Uma linha sobre o cenário"></textarea>'
      +'<p style="margin-top:14px"><button class="btn" onclick="salvarMundo()">Criar mundo</button></p></div>'); return;
  }
  var cards = S.mesas.map(function(m){return '<div class="card clic" onclick="go(\'mesa\',\''+m.id+'\')"><h3>'+esc(m.nome)+'</h3><p class="res">'+esc(m.descricao||"")+'</p></div>';}).join("");
  layout('<div class="bread">Mundo</div><h1>'+esc(S.mundo.nome)+'</h1><p>'+esc(S.mundo.descricao||"")+'</p>'
    +'<h2>Mesas</h2><div class="cards">'+(cards||'<div class="empty">Nenhuma mesa. Crie uma no menu lateral.</div>')+'</div>'
    +'<p style="margin-top:16px"><a class="btn sec" onclick="go(\'lore\')">Ver lore do mundo</a></p>');
}

async function telaLore(){
  layout('<p>Carregando…</p>');
  var lore = await loreDoMundo();
  var html = '<div class="bread">Mundo › Lore</div><h1>Lore de '+esc(S.mundo.nome)+'</h1>'
    +'<p><a class="btn" onclick="go(\'nova\',{mesa:null})">+ Nova publicação de mundo</a></p>'
    +'<ul class="lista">'+(lore.length?lore.map(itemLi).join(""):'<li class="empty">Nada ainda.</li>')+'</ul>';
  layout(html);
}

async function telaMesa(id){
  layout('<p>Carregando…</p>');
  var mesa = S.mesas.find(function(m){return m.id===id;});
  if(!mesa){ layout('<div class="aviso">Mesa não encontrada.</div>'); return; }
  var pubs = await pubsDaMesa(id);
  var html = '<div class="bread">Mundo › '+esc(mesa.nome)+'</div><h1>'+esc(mesa.nome)+'</h1><p>'+esc(mesa.descricao||"")+'</p>'
    +'<p><a class="btn" onclick="go(\'nova\',{mesa:\''+id+'\'})">+ Nova publicação</a></p>'
    +'<h2>Publicações</h2><ul class="lista">'+(pubs.length?pubs.map(itemLi).join(""):'<li class="empty">Nada visível ainda.</li>')+'</ul>';
  layout(html);
}
function itemLi(p){
  return '<li><a onclick="go(\'pub\',\''+p.id+'\')"><strong>'+esc(p.titulo)+'</strong></a> '
    +'<span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)
    +(p.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')+'</li>';
}

async function telaPub(id){
  layout('<p>Carregando…</p>');
  var r = await sb.from("publicacoes").select("*").eq("id",id).maybeSingle();
  if(r.error||!r.data){ layout('<div class="aviso">Publicação não encontrada ou sem permissão.</div>'); return; }
  var p = r.data;
  var mid = await sb.from("midias").select("*").eq("publicacao_id",id);
  var media = "";
  if(mid.data){ mid.data.forEach(function(m){
    media += (m.tipo==="video")? '<p class="vis-leg">🎬 <a href="'+esc(m.url)+'" target="_blank">'+esc(m.legenda||m.url)+'</a></p>'
                               : '<img class="capa" src="'+esc(m.url)+'" alt="">'; }); }
  var corpoHtml = esc(p.corpo||"").replace(/\n/g,"<br>");
  layout('<div class="bread">Publicação</div><h1>'+esc(p.titulo)+'</h1>'
    +'<p><span class="tipo">'+esc(p.tipo)+'</span>'+visChip(p.visibilidade)+(p.estado==="rascunho"?'<span class="tipo">rascunho</span>':'')+'</p>'
    +(p.tags&&p.tags.length?'<p class="vis-leg">'+p.tags.map(esc).join(", ")+'</p>':'')
    +media+'<div>'+corpoHtml+'</div>');
}

function telaNova(arg){
  var mesaId = arg?arg.mesa:null;
  var tipos=['conto','background','diário de personagem','mapa','cidade','facção','região','reino','criatura','item','evento histórico','história do mundo','resumo de sessão','crônica','planejamento do mestre','anotação privada'];
  var visOpts = mesaId
    ? '<option value="mesa">mesa (todos da campanha)</option><option value="publico">público (todos)</option><option value="autor_mestre">autor + mestre</option><option value="privado">privado (só eu)</option><option value="mestre">só mestre</option>'
    : '<option value="publico">público (todos)</option><option value="privado">privado (só eu)</option>';
  layout('<div class="bread">Nova publicação</div><h1>Nova publicação</h1>'
    +'<div class="form">'
    +'<label>Tipo</label><select id="f_tipo">'+tipos.map(function(t){return '<option>'+t+'</option>';}).join("")+'</select>'
    +'<label>Título</label><input id="f_titulo">'
    +'<label>Texto</label><textarea id="f_corpo"></textarea>'
    +'<div class="row"><div><label>Tags (vírgula)</label><input id="f_tags"></div>'
    +'<div><label>Estado</label><select id="f_estado"><option value="rascunho">rascunho</option><option value="publicado">publicado</option></select></div>'
    +'<div><label>Visibilidade</label><select id="f_vis">'+visOpts+'</select></div></div>'
    +'<label>Imagem/vídeo — link (opcional)</label><input id="f_midia" placeholder="https://…">'
    +'<p style="margin-top:16px"><button class="btn" onclick="salvarPub(\''+(mesaId||"")+'\')">Publicar</button> '
    +'<button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>');
}

function telaNovaMesa(){
  layout('<div class="bread">Nova mesa</div><h1>Nova mesa</h1>'
    +'<div class="form"><label>Nome da mesa/campanha</label><input id="me_nome" placeholder="Ex.: Ecos na Cidade dos Corvos">'
    +'<label>Descrição</label><textarea id="me_desc"></textarea>'
    +'<p style="margin-top:14px"><button class="btn" onclick="salvarMesa()">Criar mesa</button> <button class="btn sec" onclick="go(\'home\')">Cancelar</button></p></div>');
}

// ---------- gravações ----------
async function salvarMundo(){
  try{
    var nome=val("m_nome").trim(); if(!nome) return erro("Dê um nome ao mundo.");
    var r = await sb.from("mundos").insert({nome:nome, slug:slug(nome), descricao:val("m_desc"), dono_id:S.user.id, publico:true}).select().single();
    if(r.error) throw r.error;
    S.mundos=[r.data]; S.mundo=r.data; await carregarMesas(); go("home");
  }catch(e){ erro(e); }
}
async function salvarMesa(){
  try{
    var nome=val("me_nome").trim(); if(!nome) return erro("Dê um nome à mesa.");
    var r = await sb.from("mesas").insert({mundo_id:S.mundo.id, nome:nome, slug:slug(nome), descricao:val("me_desc"), mestre_id:S.user.id}).select().single();
    if(r.error) throw r.error;
    await carregarMesas(); go("mesa", r.data.id);
  }catch(e){ erro(e); }
}
async function salvarPub(mesaId){
  try{
    var titulo=val("f_titulo").trim(); if(!titulo) return erro("Dê um título.");
    var reg={ mundo_id:S.mundo.id, mesa_id:mesaId||null, autor_id:S.user.id,
      tipo:val("f_tipo"), titulo:titulo, slug:slug(titulo), corpo:val("f_corpo"),
      tags:val("f_tags").split(",").map(function(s){return s.trim();}).filter(Boolean),
      estado:val("f_estado"), visibilidade:val("f_vis") };
    var r = await sb.from("publicacoes").insert(reg).select().single();
    if(r.error) throw r.error;
    var midia=val("f_midia").trim();
    if(midia){ await sb.from("midias").insert({publicacao_id:r.data.id, mundo_id:S.mundo.id, autor_id:S.user.id,
      tipo:(midia.indexOf("youtu")>=0?"video":"imagem"), url:midia}); }
    go("pub", r.data.id);
  }catch(e){ erro(e); }
}

// ---------- router ----------
function render(){
  if(!S.user){ telaLogin(S.view.t==="signup"); return; }
  var t=S.view.t;
  if(t==="home") telaHome();
  else if(t==="lore") telaLore();
  else if(t==="mesa") telaMesa(S.view.arg);
  else if(t==="pub") telaPub(S.view.arg);
  else if(t==="nova") telaNova(S.view.arg);
  else if(t==="novaMesa") telaNovaMesa();
  else telaHome();
}
init();
