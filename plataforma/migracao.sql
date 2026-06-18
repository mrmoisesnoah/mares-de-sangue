-- Migracao do conteudo .md -> publicacoes (rodar no SQL Editor do Supabase).

-- Pre-requisitos: existir o mundo 'mares-de-sangue' e ao menos 1 usuario (profiles).

-- Idempotente: nao duplica publicacoes com o mesmo titulo no mundo.


insert into mesas (mundo_id, nome, slug, descricao, mestre_id)
select (select id from mundos where slug='mares-de-sangue'), 'Ecos na Cidade dos Corvos','ecos-na-cidade-dos-corvos','Campanha atual',
       (select id from profiles order by criado_em limit 1)
where exists (select 1 from mundos where slug='mares-de-sangue')
  and not exists (select 1 from mesas where slug='ecos-na-cidade-dos-corvos');

insert into mesas (mundo_id, nome, slug, descricao, mestre_id)
select (select id from mundos where slug='mares-de-sangue'), 'Sombras Vindas do Tempo','sombras-vindas-do-tempo','Campanha anterior (histórico)',
       (select id from profiles order by criado_em limit 1)
where exists (select 1 from mundos where slug='mares-de-sangue')
  and not exists (select 1 from mesas where slug='sombras-vindas-do-tempo');


insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'canone', 'A Queda da Dinastia Dranor e Dranorak', 'a-queda-da-dinastia-dranor-e-dranorak', $MDS$> 🟢 CANÔNICO · DOCUMENTO DE MESTRE (contém spoilers dos Arcos II–III).
> Fonte: Google Doc "A QUEDA DA DISNASTIA DRANOR E DRANORAK".

## O Fim da Dinastia Dranor

**O declínio gradual:** Antes mesmo da Aliança dos Suicidas, o império enfraqueceu pela Guerra dos Cem Anos e pela pressão do Conclave. Para vigiar Morcul, fez concessões a Elódia e deu maior independência à família Atom.

**A Era da Mistura:** Nesse período de abertura, Dranorak tornou-se um caldeirão cultural, recebendo raças bestiais (ferais, draconatos) e feéricas (elfos, gnomos).

**A Usurpação e a "limpeza" étnica:** A hegemonia das treze famílias foi estilhaçada pela guerra civil após a Aliança dos Suicidas. A divisão cristalizou dois reinos:
- **Império Ocidental (Dranorak):** continuidade institucional e a busca por uma glória idealizada.
- **Império Oriental (Atom):** tradição, exploração e alianças em prol de Dagorcain.

Sob **Erol, o Negro**, a tolerância foi revertida: povos bestiais e feéricos foram expulsos da cidade alta para as Costas e o Bairro do Musgo.

### Destino das Famílias
1. **Wiserdon (Usurpadores):** tomaram o poder alegando que os Dranor falharam em conter os Atom. Legitimidade por **casamentos forçados e consanguíneos**; homens Dranor executados, mulheres obrigadas a perpetuar o sangue real.
2. **Atom (Exilados):** inimigos do trono, em autoexílio nas cidades de **Erik Atom**; aliança rara com os Lordsear.
3. **Lordsear e Stormborn (Destruídas):** aniquiladas pelos Wiserdon por influência naval e ligações com a origem de Exar Khun.
4. **Bell'Hammer (Fusão):** Bloodhammer + Bellwar; poupados pela maestria na forja e força militar.
5. **Treefeets:** aliados dos Wiserdon, maior prestígio na corte.
6. **Pethfinder:** sobreviveram traindo refugiados Atom e Lordsear.
7. **Trarks:** braços armados e executores dos Wiserdon (responsáveis pela queda dos Rakkar).
8. **Rakkar:** subjugados, forçados a casar com linhagens aliadas aos Wiserdon.

## A Dinastia Wiserdon

**I. Erol, o Negro (Erol Wiserdon) — o primeiro usurpador:** arquiteto da queda dos Dranor, usou a instabilidade pós-Aliança dos Suicidas para alegar que a estirpe original perdera a "Chama de Poder". Morreu aos **120 anos** — precoce para os padrões dranorianos (vigor até ~90, morte por volta dos 140+) — visto como desfavor divino.

**II. Consanguinidade e subjugação:** Para reverter o "enfraquecimento" do sangue, instituíram casamentos forçados; absorveram as linhagens antigas (mulheres Dranor → Wiserdon, homens executados; Rakkar diluídos entre Wiserdon, Trarks e Treefeets). A busca pela "pureza" levou ao incesto.

**III. Dimitri Wiserdon I:** fruto dessa política (casamento entre primos Wiserdon-Dranor), definhou ainda mais rápido — morreu aos **102 anos**, debilitado. Confirmou para a corte que a dinastia não tinha a bênção dos Ancestrais.

**IV. Dimitri Wiserdon II — a loucura e o pacto abissal:** o atual monarca, obcecado pela imortalidade:
- Casou-se com a própria irmã, gerando a herdeira **Shiera Wiserdon**.
- Abandonou a reverência aos Ancestrais e contatou os **Devoradores de Mente**.
- Fundou o culto de **Anarion (Tharizdun)**, o "Vazio Onisciente", prometendo imortalidade que é, na verdade, um **Simulacro Coletivo** parasitário. Aos 141 anos, é uma "casca viva" sustentada por magia antiga e tecidos orgânicos, à espera de que Shiera assuma o reino.

## Dranorak (A Cidade dos Corvos)

Estrutura monumental imersa em melancolia gótica.

- **Distrito das Irmãs (Eixo do Poder):** **Acrópole Branca** (cinco torres, três muralhas; guardas com armaduras fundidas à pele por magia antiga) e **Irmã Cinzenta** (poder religioso; sino gigante e farol da "Chama do Poder"; hoje foco do culto parasitário).
- **Distrito de Azor (Bastião de Pedra):** reduto anão resistente à influência Wiserdon/Anar; **Praça Kazhad**; acessos à **Cidade Baixa**; **Rua da Moeda** e **Rua do Aço**. Anões teimosos não vendem suas posses; os Wiserdon temem retaliação do Reino Anão do Norte.
- **Distrito das Doze:** nobres sobreviventes; Jardins do Rei.
- **Distrito da Espada:** quartéis e força militar dos **Bell'Hammer**.
- **Distrito dos Viajantes:** comércio externo; Praça dos Torneios.
- **Distrito do Rei:** luxo e decadência; Rua da Seda (bordéis).
- **Distrito dos Templos:** fervor religioso e disseminação da magia antiga.
- **As Costas / Bairro do Musgo:** o setor mais pobre, em trevas perpétuas; submundo da **Praça das Pulgas**, **Rua sem Saída** (mercado negro) e **Rua do Buraco** (vício).

**Cinco Portões:** do Rei, Astral, da Espada, dos Peixes, dos Viajantes (convergem na Praça Central). **Vias:** Rua do Aço, Rua do Gato, Rua Arcana, Rua da Moeda.

## Organizações e Política

**Facções:** As Espadas de Anar (braço armado e místico do culto) · Os **Puristas de Sangue** (dissidentes Dranor/Rakkar/Bell'Hammer financiados pelos Atom) · Hunters de Elódia (infiltrados) · Resistência de Azor · Sindicato das Costas · Observadores de Elódia · Elmos de Dragão (polícia dos Trark).

**Tecnologia & Magia:** arquitetura dranoriana + engenharia anã + magia antiga; "**veios de mana**" (filamentos vivos). Os corvos atraídos por eles deram o apelido **Cidade dos Corvos**.

**Religião, Política, Cultura:** ver o doc do jogador. Os Trarks são "a mão direita que bate", os Treefeets "a mão oculta".

## O Anarianismo (Seio de Anar)

1. **Teologia:** subversão da fé nos Ancestrais. Prega que os mortos não vão ao **Mar Astral**, mas retornam ao **Seio de Anar** — plano nascido das energias do mundo. A divindade é o **Vazio Onisciente / Anarion**, identificado com **Tharizdun**, a besta abissal derrotada na guerra dos deuses, cujo sangue banhou o mundo. "**Anar**" seria o primeiro nome de Dranor, o Grande — disfarce para ocultar a conexão abissal.

2. **O Simulacro Coletivo e a natureza parasitária (jogadores não sabem a princípio):** o culto torna os fiéis dependentes de uma prisão mental — um mundo de sonhos de glória e abundância. Nos templos há os "**Seios**" (filamentos arcanos vivos); as estruturas orgânicas que sustentam o simulacro ficam escondidas na **Cidade Baixa**. Os corpos têm a vitalidade drenada para sustentar Dimitri II e seus senhores ocultos. Por trás de tudo agem os **Illithids / Devoradores de Mente**, servos de **Tharizdun**, autores da tecnologia dos filamentos vivos, com planos próprios por trás do pacto com Dimitri II.

3. **Braço armado:** **Espadas de Anar** (usam a rede de tecidos vivos). Agentes como o adolescente "**Espada**" abdicam de nome e identidade. Os mais devotos carregam a marca a ferro na testa.

4. **Figuras-chave:** **Dimitri II** (fundador, "casca viva") e **Shiera Wiserdon** (princesa albina, Suma Sacerdotisa, emissária de Tharizdun; acredita poder dominar os Devoradores de Mente em vez de servi-los).

5. **Locais de culto:** **Irmã Cinzenta** (sede); "conversão" de outros templos (purificados e dotados de um "Seio"); **Cidade Baixa** (laboratórios proibidos e a rede biopunk).

## Resumo da Campanha (argumento principal)

Dimitri II está morrendo (sua longevidade artificial chega ao fim). O culto anarianista se espalha, prendendo os fiéis no simulacro. **Shiera** planeja assumir o trono — suspeita-se que ela esteja por trás do enfraquecimento do pai. Sua ascensão é contestada pelos **Puristas de Sangue** e pelas famílias vassalas, que veem a chance de restaurar a autonomia das antigas linhagens ou iniciar nova dinastia.$MDS$, array['Cânone']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Queda da Dinastia Dranor e Dranorak');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'canone', 'O Mundo de Dagorcain — Contexto Geral para os Jogadores', 'o-mundo-de-dagorcain-contexto-geral-para-os-jogadores', $MDS$> 🟢 CANÔNICO · Material voltado ao jogador (sem spoilers da trama principal).
> Fonte: Google Doc "O Mundo de Dagorcain: Um contexto geral para os Jogadores".

## Um Breve Relato

Dagorcain é um continente marcado por glórias esquecidas e uma decadência palpável. No princípio, o domínio sobre o mundo de **Skard** travou-se em uma batalha titânica entre deuses e "Males Caóticos". A batalha fragmentou o supercontinente original, criando o **Mar de Sangue**, e o continente de Dagorcain tornou-se um dos centros da energia mística originada na guerra.

O sacrifício de um deus uniu sua essência à de uma abominação conhecida apenas como a **Besta** ou **Vazio Primordial**, banhando o mundo com a energia que deu origem à magia e aos demais planos que são como ecos do mundo original (**Agrestia das Fadas** e **Pendor das Sombras**).

Após eras de guerras entre magos, demônios e impérios, Dagorcain hoje é um reflexo fragmentado do seu passado. A antiga hegemonia Dranoriana foi substituída por feudos isolados, cidades-estado desconfiadas e uma capital que definha.

## Linha do Tempo: A Cicatriz das Eras

- **A Era Primordial:** Deuses e Males Caóticos lutam; o deus caído banha o mundo com sua energia e a da besta primordial, criando a magia, a Agrestia das Fadas e o Pendor das Sombras.
- **A Guerra dos Magos (~1000):** Conflito de 600 anos entre magos elementais e sombrios pelo domínio de Dagorcain. Termina com a criação das montanhas **Ered Gorgoroth** para isolar **Morcul**, onde os magos sombrios foram banidos.
- **Fundação de Dranor:** Dranor, o Grande, lidera os **Wikinings** (Marinheiros Perdidos) ao norte e funda o império após aliança com os anões.
- **Guerra dos Cem Anos:** Os Magos Sombrios retornam. Elódia cria o **Caixão das Almas** como arma arcana.
- **As Guerras Bestiais:** O império torna-se opressor. O **Conclave** (raças livres) rebela-se e vence, conquistando independência regional.
- **Guerra das Cinco Chaves (há 550 anos):** Conflito pelo controle do Caixão das Almas e a vingança de **Exar Khun**. Termina com a morte do vilão e o isolamento de Elódia.
- **Aliança dos Suicidas (há 350 anos):** Frota de exploração liderada pelas famílias **Atom** e **Lordsear**, aliada a Elódia, parte e nunca retorna, enfraquecendo as relações políticas do continente.
- **O Crepúsculo Atual:** A dinastia **Wiserdon** derruba a linhagem real Dranor, instaurando guerra civil.

## O Império Dranoriano

**Origem:** Fundado há cerca de mil anos por Dranor, o Grande, que liderou os Wikinings através do Mar de Sangue.

**Aparência e Sangue:** Homens altos e robustos, como anões em porte e barba, mas com a destreza dos feéricos. Possuem a "**Chama de Poder**" no sangue, com vigor e longevidade incomuns.

**Aliança com os Anões:** Aliança eterna com o Rei Anão **Azor**, do Norte, refinando metalurgia e engenharia naval.

**A Capital Dranorak:** Originalmente **Anar**; tornou-se Dranorak (sufixo "-ak" = "Grande Cidade").

## As Treze Famílias (Dranorhands)

1. **Dranor** (Família Real) — linhagem real e comando do império.
2. **Bloodhammer** (hoje **Bell'Hammer**) — os melhores ferreiros; fundidos aos Bellwar; defesa do Distrito da Espada.
3. **Lordsear** — mestres navais; exilados na guerra civil.
4. **Pethfinder** — engenheiros e artesãos; traíram refugiados no início da guerra civil.
5. **Atom** — exploradora e controversa; fundou cidades no Norte (Atom, Amon Tyr).
6. **Wiserdon** — antiga família de capitães; hoje a dinastia reinante.
7. **Stormborn** — comércio e pesca; dizimados pelos Wiserdon.
8. **Rakkar** — outrora a mais próxima do trono; hoje exilados/subjugados.
9. **Trarks** — executores e braço armado dos Wiserdon.
10. **Treefeets** — aliados dos Wiserdon, com alto prestígio na corte.
11. **Loneranger** — linhagem original de capitães.
12. **Bearclaws** — família fundadora.
13. **Bellwar** — antigos nobres, fundidos à Casa Bell'Hammer.

## Grandes Poderes e Impérios

- **Dranorak (A Cidade dos Corvos):** Antiga capital imperial, sob a Dinastia Wiserdon II.
- **Dranar (Sede do Conclave):** Símbolo de liberdade após as Guerras Bestiais; união das raças livres.
- **Elódia (Escola de Magia):** Maior Escola de Magia do continente; fundada na Guerra dos Magos.

## Alianças e Ordens

- **O Conclave:** Elfos, Anões e Bestiais; vigilância das fronteiras de Morcul.
- **Casa Atom e a Dranor Oriental (Os Exilados):** Recusam os Wiserdon; reino de **Rhumn**, guardião da tradição dranoriana.

## Organizações de Destaque

- **Sociedade Trade:** mercado negro e comércio ilegal.
- **Mãos de Prata:** clã mercenário fundado por Exar Khun; magia fúnebre do Caixão; inimigos dos lobisomens; hoje quase mito.
- **Gaurhoth (Altos Lobisomens):** de **Minas Ithil**; autocontrole bestial; aliados históricos dos Dranor; hoje quase mito.
- **Hunters de Elódia:** elite que caça portadores de segredos do Caixão das Almas.

## Geografia e Cidades

- **Atom, Amon Tyr e Icevalle (Dranor Oriental):** região noroeste dos Atom; Amon Tyr é o polo central.
- **Terras Meiji (Leste):** povo oriental; guardariam segredos da Era dos Dragões e de **Barahir**.
- **Deserto de Harad (Oeste/Sul):** vasto, outrora dranoriano, hoje isolado.
- **Minas Ithil (Cidade da Lua):** fortaleza de gelo; refúgio dos Gaurhoth; teria caído ao fim da Guerra das Chaves.
- **Morcul:** planície desolada atrás das Ered Gorgoroth; berço da magia negra.
- **Reinos Bárbaros e Minus:** nunca conquistados, no extremo leste e ao sul de Morcul.

---

## Dranorak: A Cidade dos Corvos (guia do jogador)

### Distritos
- **Distrito das Irmãs (Eixo do Poder):** **Acrópole Branca** (governo, cinco torres) e **Irmã Cinzenta** (religião, torre única com sino e farol perpétuo).
- **Distrito de Azor (Bastião de Pedra):** reduto anão e centro econômico — Praça Kazhad, Rua da Moeda, Rua do Aço.
- **Distrito da Espada:** centro militar.
- **Distrito das Doze:** região nobre; Jardins do Rei.
- **Distrito do Rei:** luxo e entretenimento; Rua da Seda.
- **Distrito dos Viajantes:** comércio; Praça dos Torneios.
- **As Costas e o Bairro do Musgo:** as regiões mais pobres, à sombra das torres.

### Os Cinco Portões (convergem na Praça Central)
1. Portão do Rei (Nobreza)
2. Portão Astral (Religiosos)
3. Portão da Espada (Militares)
4. Portão dos Peixes (Docas e Mercado)
5. Portão dos Viajantes (Comércio Externo)

### Facções Vigentes
- **Dinastia Wiserdon:** Rei **Dimitri II**, 141 anos, recluso na Acrópole Branca.
- **Casa Bell'Hammer:** mestres ferreiros e força de defesa.
- **Elmos de Dragão:** policiamento sob a família Trark.
- **A Resistência de Azor:** anões da metalurgia e economia do aço.
- **As Espadas de Anar:** braço armado do culto oficial, o **Anarianismo**.
- **O Sindicato das Costas:** contrabandistas dos distritos pobres.
- **Observadores de Elódia:** agentes da Escola de Magia.

### Criação de Personagem
- **Religião:** a fé nos **Ancestrais** vem sendo substituída pelo culto ao **Seio de Anar** (Anarianismo).
- **Tecnologia & Magia:** arquitetura dranoriana + engenharia anã + magia antiga; "**veios de mana**" (filamentos vivos de energia arcana). Os corvos atraídos por eles deram o apelido **Cidade dos Corvos**.
- **Cultura e Povos:** elite dranoriana; povo comum são os "**povos bestiais**", empurrados à periferia após a exclusão sob **Erol, o Negro**.$MDS$, array['Cânone']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='O Mundo de Dagorcain — Contexto Geral para os Jogadores');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'canone', 'Dagorcain e o Mundo de Skard — Resumo da História', 'dagorcain-e-o-mundo-de-skard-resumo-da-historia', $MDS$> 🟢 CANÔNICO · Bíblia cronológica oficial: da criação de Skard até 550 anos após a Guerra das Cinco Chaves.
> Fonte: Google Doc "DAGORCAIN E O MUNDO DE SKARD - RESUMO DA HISTÓRIA ANTERIOR A GUERRA DAS CINCO CHAVES E A ALIANÇA DOS SUICIDAS".

## Parte 1 — Pré-História do Mundo (Skard)

- **A Batalha Primordial:** Nos tempos em que os dias não eram contados, os deuses lutaram contra os **Males Caóticos** que desejavam destruir a vida. O deus mais poderoso caiu em combate, mas, antes de sua consciência partir, uniu seu poder ao da Abominação — o **Vazio Primordial** ou **Besta Primordial**, criatura evocada pelos Males Caóticos para consumir o mundo. Essa união banhou o mundo com sua energia, fragmentando o supercontinente e criando o **Mar de Sangue** imbuído em magia.
- **Origem da Magia e Mundos de Eco:** A fusão das energias do deus e da criatura deu origem às forças elementares. O conflito dessas essências criou a **Agrestia das Fadas** e o **Pendor das Sombras** como reflexos paralelos (ecos) do mundo de Skard.
- **Separação Continental:** O fim violento da guerra fragmentou o supercontinente em vários outros, cercados pelo Mar de Sangue.
- **A Primeira Era:** Durou entre 7.000 e 40.000 anos, marcada por conflitos entre Eladrins e demônios no norte. Terminou em uma batalha devastadora que quase extinguiu a vida, forçando os povos a migrarem para o sul e o centro, rumo a **Dagorcain**.
- **A Misteriosa Era dos Dragões:** Período pouco conhecido, nos primeiros milênios da Primeira Era, em que os Dragões reinavam. Dele surgiram os primeiros Draconatos. As facções dracônicas guerrearam pelo poder, escravizando raças "inferiores". Terminou quando os **Dragões Metálicos** venceram e subjugaram os **Cromáticos**, libertando as raças e dando início à **Era dos Povos**.

## Parte 2 — História de Dagorcain e Seus Grandes Eventos

- **A Grande Guerra dos Magos (Segunda Era):** Dagorcain, centro das energias do deus caído, tornou-se o local de magia mais potente. Guerra de 600 anos entre os **Magos do Caos Elemental** (feéricos e aliados) e os **Magos Sombrios** (Orcs, Goblins e seres do Pendor). Terminou com o isolamento dos Magos Sombrios no leste, pela criação das **Ered Gorgoroth** e da região de **Morcul**.
- **Fundação de Dranor:** Há cerca de mil anos, os **Wikinings** (Marinheiros Perdidos), liderados por **Dranor, o Grande**, chegaram ao norte de Dagorcain. Firmaram aliança eterna com os **Anões do Norte**, fundando o reino que se tornaria a maior potência militar do continente.
- **A Guerra dos Cem Anos:** Os Magos Sombrios retornaram, forçando aliança entre as raças. Elódia criou o **Caixão das Almas** como arma de energia arcana densa. A vitória foi garantida pela entrada surpresa dos **Minotauros** contra Morcul.
- **O Domínio Dranoriano e as Guerras Bestiais:** Dranor estabeleceu hegemonia sobre nove regiões. A opressão dos reis (como o **Massacre de Nagrod**, ordenado por **Bolg**) levou à fundação do **Conclave** (Elfos, Anões e Bestiais), que derrotou Dranor após 20 anos de guerra, conquistando independência regional.

### Detalhes sobre Dranor

**Origem (Wikinings):** Povo antigo de heróis e soldados que sobreviveu às guerras contra demônios no fim da Primeira Era. Liderados por Dranor, o Grande, chegaram ao norte de Dagorcain há ~mil anos (aprox. 51.200 ad) com doze famílias de capitães. São humanos altos e robustos, com porte e barbas de anão e a destreza dos feéricos; "sangue superior" abençoado, com vigor até idades avançadas (ultrapassando 300 anos). Devotos de **Heironeus** (coragem/honra) e **Bahamut** (justiça), com forte reverência aos ancestrais.

**As Treze Famílias (Dranorhands):** Dranor (real), Rakkar, Trarks, Atom, Wiserdon, Pethfinder (engenheiros/artesãos), Lordsear (mestres navais), Treefeets, Loneranger, Bellwar, Bloodhammer (melhores ferreiros), Bearclaws, Stormborn (comércio/pesca). Autonomia econômica, mas tributo mensal à família real.

**Cronologia imperial:** Fundação e aliança com os Anões (~51.200 ad) → Guerra dos Cem Anos (~52.000 ad) → Domínio e Guerras Bestiais (~52.232 ad, tirania de Bolg / Massacre de Nagrod) → Guerra das Cinco Chaves (há 550 anos) → Aliança dos Suicidas (há 350 anos).

## Parte 3 — A Campanha Anterior e a Guerra das Chaves

Durante a campanha principal: o retorno de **Exar Khun**, a influência da **Rainha Rapina** e a revelação do **Caixão das Almas**.

**Dranos e o Caixão das Almas:** Elódia criou o Caixão na Guerra dos Cem Anos. Morcul tentou criar sua própria arma, imbuindo um ovo de dragão com magia descomunal — nasceu **Dranos**, criatura cromática poderosíssima, e sua contraparte metálica. Não conseguiram controlar Dranos (nascido em fúria bestial) e o baniram para outro plano. O nascimento de Dranos e o Caixão coincidiram pelos poderes reunidos, e Dranos caiu no Caixão, onde se aliou a Exar Khun para planejar a fuga e a vingança.

### Exar Khun (Morgoth)
Principal antagonista histórico. **Shadar-Kai** do Pendor das Sombras, assassino pessoal da **Rainha Rapina**. Serviu no exército de Dranor por décadas (destaque nos últimos 42 anos da Guerra dos Cem Anos). Tornou-se o **primeiro prisioneiro do Caixão das Almas** ao ser tragado por um abismo mágico em Morcul. Casou-se com a dranoriana **Kira Goraukor** (dez filhos, cinco pares de gêmeos); a Rainha Rapina marcou cinco crianças, dividindo os clãs. Traído pelos filhos não marcados e pelos 21 Mestres de seu clã. Fundou o clã **Mãos de Prata**. Morto na Guerra das Cinco Chaves, possivelmente pelos próprios filhos.

### O Caixão das Almas (Túmulo das Almas)
Artefato de escala planar. Criado por Elódia (~52.000 ad). É um Plano Material para os não-vivos (pacto entre Morcul e a Rainha Rapina) que devora a vitalidade dos prisioneiros, convertendo-a em energia arcana catalisável por **Chaves**. Tempo distorcido ("Anos do Caixão"). Cortes internas: **Ogai** (Morgoth), **Dranos** (o dragão) e **Dôminus** (contato com os Magos Sombrios). Hoje custodiado por Elódia; chaves perdidas talvez em **Gaurgrod** ou na montanha **Thangor**.

### O Dragão Dranos
Autodeclarado Senhor dos Dragões de Dagorcain. Forma humanoide: escamas vermelhas, cabelos multicoloridos, olhos dourados de dragão. Desafiou Morgoth no Caixão; firmaram o **Pacto Dozarkin** (aliança de comércio e sabedoria). Reapareceu (como Lorde Drayco) oferecendo auxílio aos Dranorianos contra Exar Khun.

### O Fim da Campanha
Dranos é derrotado pelos jogadores em seu desafio final. Exar Khun liberta Dranos após reunir as chaves, mas os jogadores — influenciados pela Rainha Rapina — agem a tempo e o derrotam. Entra no continente uma segunda facção: os seguidores de **Barahir Yondur**, que desejavam trazer ordem ao mundo sob a tutela de um retorno da Era dos Dragões. Barahir e Exar Khun iniciam sua própria guerra.

## Parte 4 — Pós-Campanha e a Guerra das Cinco Chaves

- **A Guerra das Chaves:** Conflito pelo controle do Caixão e das chaves dimensionais da Rainha Rapina, envolvendo os dez filhos de Kira e Exar Khun: os cinco marcados (**Gaurhoth/Lobisomens**) e os cinco não marcados (**Mãos de Prata**).
- **Desfecho:** Morte de Exar Khun (provavelmente pelos filhos). O Caixão passa à custódia de **Elódia**, que se isola.
- **Aliança de Barahir:** Barahir une-se a Dranor e aos povos bestiais para vigiar Morcul.
- **A Aliança dos Suicidas:** Cem anos após a Guerra das Chaves, uma frota de exploração partiu de Elódia (famílias **Atom** e **Lordsear**) e jamais retornou — na verdade colonizou **Panimalia**, um arquipélago gigantesco, sem meios de voltar.

## A Queda de Dranor e o Mundo Atual (550 anos depois)

- **Império fragmentado:** Após o fracasso da Aliança dos Suicidas (há três séculos), as fortalezas dranorianas enfraqueceram, mergulhando o reino em guerras civis. A capital é hoje de uma dinastia usurpadora; o rei mantém o poder por um **pacto com os Devoradores de Mente** (oculto dos jogadores).
- **Elódia:** Teocracia arcana rigorosa e isolacionista ("Ceita dos Eródianos"); detém o Caixão; os **Hunters** caçam quem ameace sua hegemonia.
- **Morcul e o Conclave:** As Ered Gorgoroth ainda barram pragas e exércitos sombrios. Remanescentes do Conclave aliaram-se a Barahir num cerco de vigilância. **Ordem Monástica dos Ancestrais** e **Últimos Paladinos** guardam contra os "Poderes Antigos".
- **Barahir e as Terras Bárbaras:** "Soberano Dominador/Libertador" (dracônico). Primeira linha de defesa contra o ressurgimento do Pendor das Sombras no leste.
- **Regionalismo:** Ao norte, a **Terra dos Reis** (nobres "D'Sangue"). Ao sul, **Old'agor** (os "Miscigenados"/Mixta, com os últimos feéricos). Rumores de chaves perdidas em **Gaurgrod** e **Thangor** atraem Fomorianos e seguidores de Exar Khun.$MDS$, array['Cânone']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Dagorcain e o Mundo de Skard — Resumo da História');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '1 — O Princípio', '1-o-principio', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## O Princípio

Quando os dias ainda não eram contados, os deuses moldaram e lutaram pelo o Mundo criado pelos Primordiais, mas os Males Caóticos vieram com o intuito de destruir tudo o que os deuses criaram, mas naquele mundo havia algo diferente de tudo que já havia nascido ou destruído, vida.

Os deuses dali buscavam adoração, e os Males desejavam o domínio, e houve grande guerra, e os deuses defenderam o Mundo como puderam, e o sangue da batalha encheu o único mar imenso do mundo, que rodeava um único e gigantesco continente, até que um de seus lideres lutou contra a maior abominação criada pelos Males, feita para devorar e subjugar tudo o que os deuses haviam criado, pois se os Males não dominassem a destruição deveria ser seu destino.

E nessa luta o poderoso dos deuses caiu, mas antes deixou a criatura desprovida de quase toda sua força. O deus caiu sobre o mundo, mas enquanto caia teve uma visão das criaturas que ainda despertariam, e viu que as forças caóticas malignas continuariam a atormentar os filhos dos homens e de outros seres, então, antes que sua consciência fosse mandada para os palácios dos deuses mortos, uniu seu poder ao da criatura que derrotara, se desfez em pura energia, e banhou o mundo com ela, para que as criaturas que ali existissem aprendessem a manipulá-la e desse modo também se defendessem, pois ele também previu o desdém de muitos deuses sobre a vida do novo mundo.

Mas para banhar todo mundo, precisou usar do poder maligno da criatura, e esse também se espalhou, e assim, as forças Caóticas Elementares e o terrível poder do Pendor das Sombras se espalharam no mundo, e a vida, seja maligna ou abençoada, nasceu. E todas as criaturas começaram a despertar e se movimentar no grande continente.

Ora, o poder da criatura somada ao do deus caído era grande demais para se contiver no mundo. E as duas batalhavam como o deus e a criatura quando estavam vivos. E assim, o conflito dessas duas forças deixaram marcas no mundo e criaram a vida como ela é. Mas essas forças após muito lutarem deixaram a presença uma da outra, era como se um resquício da mente do deus e da criatura ainda existissem, e fugindo para o vazio se tornaram densas, e como se tivessem guardado uma imagem do mundo original, se transformaram em ecos do que ele era, mas moldados a partir da natureza de cada um. E estes mundos foram conhecidos como o Pendor das Sombras e a Agrestia das Fadas, aonde cada um refletia uma face do mundo original.

Mas a guerra nos campos fora do mundo não tinha acabado, e a criatura dos Males caóticos, já muito enfraquecida foi destruída e seus restos espirituais lançados entre as dimensões, e o fim da guerra foi tão violento que o mundo perdeu sua configuração original e se dividiu em vários continentes cercados e separados pelo grande mar de sangue.

E os deuses e os males se detiveram e pararam a luta, para que menos danos fossem causados, e ambos conquistassem seus objetivos. E um tratado foi feito, pois já que nasceram vidas e vidas, tanto dos caóticos males, quanto do poder dos deuses, eles permitiriam a elas escolher quem adorar, e as guerras não seriam mais entre os deuses, mas entre os seres em adoração ao lado que escolhessem.

E assim iniciou a primeira grande Era do mundo, do qual não existem memórias, pois seu fim, após mais de sete mil anos, se deu em uma terrível batalha que quase destruiu toda a vida no mundo, pois os deuses por um momento lutaram de novo, e o resultado foi devastador.

Apenas os Mestres Eladrins se lembram dessa guerra, e em suas bibliotecas guardam os últimos relatos daquele tempo. Os Feéricos tiveram muita importância nessa era, quando os Homens ainda eram jovens e perambulavam nas cidades dos Elfos, e foi nesse tempo que ouve a divisão e ódio entre as famílias de Agrestia das Fadas. Muitas raças ainda não tinham surgido, e os Eladrins foram à maior força usada pelos deuses contra os Demônios e Lordes dos Nove infernos, que tentaram destruir a criação.

Muitos continentes foram arrasados, e muitos que eram vazios se encheram, pois os povos fugiam para as bandas sul do mundo, pois a guerra dos deuses e demônios se travou no norte, e teve fim quando os demônios foram banidos novamente. Muitas nações e raças se perderam ou foram esquecidas, e o conhecimento se foi junto com elas, apenas nas terras de Agrestia, ou no mundo dos deuses, ainda são guardados muitos contos desse tempo antigo.

E a segunda Era se iniciou, mas dessa vez os continentes não mais buscaram se comunicar, mas em muitos casos viveram se souber da existência dos outros. Mas a história nessa Era se voltou para o Continente de Dagorcain, ou Dagor popularmente, aonde muitos diziam ter sido o lugar onde a massa das energias do deus havia caído inicialmente e se espalhado, e lá a magia era mais potente do que em qualquer outro lugar. Também fora o continente mais afetado pela guerra da criação, pois provavelmente fora o centro do Super Continente que existiu na primeira configuração do mundo.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='1 — O Princípio');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '1.0 — A Grande Guerra dos Magos', '10-a-grande-guerra-dos-magos', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## Os Primeiros Fatos de Dagorcain e a Grande Guerra dos Magos

Muitos seres, durante a terrível guerra contra os Demônios que definiu o final da Primeira Era, fugiram para Dagorcain, pois esse ficava mais ao centro do mundo, e a guerra ocorreu no norte, nas terríveis terras geladas, que provocaram grandes inundações, e terríveis vapores que vinham de vulcões escondidos debaixo do gelo, que foram acionados pelo poder dos deuses e seres que lutaram, e mancharam a luz do sol com cinzas que desolaram o mundo, e definharam muitas vidas.

Mas o céu foi limpo pelos deuses, e as raças puderam seguir novamente suas vidas. E muitos costumes se mantiveram, mas os feitos passados foram esquecidos entre as gerações, pois os registros e escrituras foram abandonados por muito tempo. E as raças voltaram a crescer e prosperar.

E como foi dito, a magia em Dagorcain era mais intensa do que em qualquer outro lugar, e muitos magos surgiram no continente, e uma grande ordem foi formada e se manteve por quinhentos anos, com aprendizes e reinos. Mas grande contenda aconteceu entre os magos, pois os deuses disputavam sua adoração, e muitos escolheram o Pendor das Sombras como fonte de poder, e houve discórdia entre o grande reino dos Magos que fora maior que qualquer outro reino que tenha existido no continente, pois sua vastidão ocupava toda a floresta indo de leste a oeste do continente, só não avançando os extremos norte e sul.

E a contenda teve inicio, uma terrível guerra foi travada, pois o continente se dividiu e os Magos do Caos Elemental eram em sua maioria das raças feéricas, e tinham Anões, Homens e seres benignos ao seu lado. Mas os Magos do Pendor das Sombras, conhecidos como Magos Sombrios, contavam com o Auxilio de raças malignas e seus enxames, com exércitos formados por Orcs, Goblins e seus parentes, Minotauros, Ogros e outras criaturas invocadas e movidas pelo Pendor das Sombras. E a guerra durou cerca de seiscentos anos, quando finalmente os Magos das Sombras fugiram para o extremo leste.

Muitos queriam persegui-los, mas os Magos temeram mais mortes, pois as quantidades de vidas perdidas foram tantas que nunca mais qualquer um dos lados chegará a um quarto do poder e quantidade que já tiveram um dia. E usaram uma poderosa magia que separou parte do continente, que ia do extremo leste fazendo uma curva ao norte, isolando a principal força e lideres dos Magos negros do continente naquela nova Ilha, e ergueram grandes Montanhas no continente, que formavam uma barreira na região de Morcul, que foi a mais afetada pela guerra e magia do Pendor, e estas era as Ered Gorgoroth, as montanhas do Terror Constante.

Muitos seres não conseguiram reagrupar no leste com os Magos, e ficaram soltos no continente. Os Magos do Continente sentiram que não deviam exterminá-los, pois apenas aos deuses era dado esse direito, mas podiam buscar controlar sua multiplicação exagerada. E os Orcs foram usados em muitos casos como escravos, ou eram como selvagens em florestas obscuras, a raça que já foi à maior força do Continente. Mas dentre os Orcs e homens, uma nova raça surgiu, e esses eram os Meio Orcs, que no futuro tiveram grande poder e importância política, pois eram menos violentos e mais diplomáticos do que seus parentes.

E o Grande Reino dos Magos teve seu fim para nunca mais existir. E as raças fundaram seus próprios reinos, onde os feéricos fortificaram a floresta, e os Anões cresceram nas montanhas, os Homens se espalharam entre elas e criaram um poderoso reino no Norte, que no futuro será o maior poder militar do continente. E as bestiais, como Gigantes, Golias, e seres mágicos variados, cresceram em seus habitats. E raças antigas como Lobisomens e seus parentes distantes, os Ferais, ressurgiram pela influencia dos deuses. E graças aos Magos Sombrios, as pragas mágicas, como o vampirismo e a magia negra e seres do Pendor das Sombras, também se espalharam no continente.

Os outros continentes cresceram de forma parecida, mas aos Homens, e seres feéricos foi dada grande benção reprodutiva e de longevidade, e aos Anões a resistência e fácil adaptação, repetida nos homens, que também lhes garantiu lugar entre as raças predominantes no Mundo.

E esses serão importantes personagens nas Guerras virão, seja nos tempos de continentes exilados, ou nas Grandes Guerras que envolveram novamente os continentes visinhos a Dagorcain.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='1.0 — A Grande Guerra dos Magos');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '1.1 — Sobre Dranor', '11-sobre-dranor', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## Sobre Dranor

Há muito, em tempos próximos a queda do Reino dos Magos, Homens Fortes se aventuraram nas terras frias de Dranor, e lá se instalaram, pois uma grande nevasca se abateu sobre eles, e ficaram presos. Muitas famílias tinham ali, de um povo que poucos conhecem sua origem, dizem que eram navegantes de terras fora do Continente, e durante a Era dos Magos chegaram ao Continente e viveram em ilhas ao Sul, mas lá empobreceram, e se lançaram ao Mar rumo ao Norte.

Hoje eles ficaram conhecidos como Wikinings, que em uma língua antiga significava Marinheiros Perdidos. Mas eles não eram homens comuns, eram um povo antigo, famílias de homens que sobreviveram aos combates na guerra contra os Demônios, e heróis de histórias épicas. E muitos deles viram a olho nu os próprios deuses lutarem contras as forças demoníacas. E diziam que aquela batalha fez com que seus capitães transcendessem a humanidade, mas ali muitos morreram, ou se uniram aos deuses. E os poucos sobreviventes seguiram em uma vida Errante e Perpétua com suas famílias, em busca de continentes ainda sustentáveis.

Entre eles, um nome se tornou Imortal, Dranor, o grande. Os Homens do Norte diziam que ele foi um general entre os Feéricos, das esquecidas guerras contra os Demônios, e perdeu quase toda sua família, restando apenas dois de seus filhos. Seu continente foi arrasado na Guerra, e reunindo o que restou dos Homens, viajaram pelo mar de Sangue, até Dagorcain, e apenas doze famílias vieram com ele, todas de soldados que o servira.

Muitas lutas enfrentaram nas terras geladas do norte, pois males também alcançaram o Continente, fugindo da fúria dos deuses, mas nenhuma eles perderam. Seus Homens eram altos e robustos, não tinham a aparência grosseira e feia dos Anões, mas se assemelhavam em porte e em suas barbas. E vieram a eles Anões que viviam no Norte, e fizeram aliança, e por um tempo essas famílias viveram em casas Anãs. Trabalharam, e à custa de seu suor começaram a construção de sua própria cidade.

E assim, uma nova cidade chamada Anar se ergueu sobre o gelo. E mais ao sul dali, existiam clãs de elfos e homens, que se mudou para as proximidades da cidade, e lá se fixaram e Dranor foi declarado rei sobre aquelas terras. E mesmo os Anões, que se apegaram aqueles homens que mais pareciam anões espichados, também reconheceram Dranor como rei e aliado. Pois grande amizade nasceu entre Dranor e o Rei dos Anões do Norte.

E os Homens de Dranor voltaram a construir seus barcos, e com a ajuda dos anões, refinaram sua arte e passaram a navegar com navios fortes sobre as águas geladas. E lá praticaram a caça de animais marinhos, e acreditasse que era uma pratica comum para eles em suas antigas terras. E desses animais aprenderam a extrair óleos e outras iguarias, que foram usadas para criação de lamparinas, forjas, trabalhos com metais, práticas arcanas, e muitas outras utilidades ela tinha.

E o comercio entre os Reinos sob a ordem dos Magos se virou para aquela cidade, trabalhadores para lá se mudaram, e novos povoados se instalaram naquela região. Os próprios Anões se beneficiaram com aquelas iguarias, e com pedras preciosas pagaram os homens.

E de uma pequena cidade, um forte estado se formou. E Dranor enriqueceu, e teve esposa, e seus filhos também, e os povos se misturaram com as Famílias de Dranor. Mas o sangue daqueles homens e mulheres era superior e uma chama de poder vinha deles, e mesmo o sangue feérico era subjugado, e até os meio elfos nasciam com poucas características feéricas, e mesmo as orelhas pontudas lhe eram privadas, e raríssimos casos foram diferentes.

E este sangue não enfraquecia com o tempo, mas se tornava cada vez mais superior. E os magos viram magia caótica sobre aqueles homens, e acreditaram que seu sangue foi abençoado pelos deuses.

Mas uma grande guerra alcançou o rei de Dranor. Orcs, milhares que se multiplicaram nas montanhas da floresta, junto com Goblins e seus primos, tentaram invadir as terras do norte. E os Homens estavam em desvantagem numérica, e muito sangue foi derramado ali. E se não fosse pela força dos anões, aquele povo teria caído.

E Dranor decidiu que o comercio enfraqueceu seu povo, e recolheu as principais famílias para mais ao Norte, e foram morar em uma cidade portuária. Essa cidade não comercializava, mas usava de terceiros para vender seu produto. E todas as cidades que ficavam atrás das colinas anãs se focaram no militarismo, e Dranor treinou e organizou um grande exercito. Ele construiu Fortes e definiu as Fronteiras de seu Reino. Espalhou suas forças ao sul, próximo aos rios de frente as Montanhas dos Anões, e lá construiu cidades para que comercializassem pelo seu reino, e ao mesmo tempo servissem de defesa.

E essa região é hoje chamada de Dranor, que depois das guerras bestiais, voltou a ser exatamente como o Rei Dranor a conquistou originalmente. E Dranor reinou por cem anos, e seu exercito se tornou inigualável. Pois seus homens tinham a destreza e habilidade comparadas com a dos Feéricos, e eram resistes e fortes como os Anões. E a linhagem de Dranor até hoje está entre os Reis e Governantes Dranorianos.

E os anões firmaram uma amizade e aliança eterna com os Dranorianos, e muito os Homens aprenderam com os mestres Anões, mas não tinham muita habilidade na forja, e para isso contratavam os Anões, mas eram grandes armadores e construtores, e suas embarcações eram usadas em todo o continente, pois eles deram inicio a esse costume, e receberam muito ouro em troca de seus barcos, mas nenhuma os conduziu com a maestria dos Marinheiros Dranorianos.

E mesmo dentro de sua política militar, os Dranorianos tinham cidades ricas e belas. Pois a construção era uma de suas especialidades, e muitas culturas ali se misturaram, trazendo maior variedade arquitetônica. E muitas estradas foram construíram entre as cidades, e os feéricos que para lá viajaram deram aos homens lamparinas que não apagavam, eram como cristais que tinham luz própria, e eles foram colocados nas cidades e nas estradas. E muito altas, são as Torres e muralhas dos Dranorianos, e sobre as bases das montanhas anãs eram construídas barreiras e casas de vigia. E seus muros iam tão alto que se diziam ser alcançadas apenas pelo vôo da águia. E as cidades também eram assim, enormes, e altas, pois os homens amavam os céus, e muito se multiplicaram, e as cidades eram cheias e seus exércitos eram vastos.

E muito belo foi o Reino de Dranor, que morreu velho quando finalmente a idade o alcançou, e ainda assim, a velhice de Dranor e seus descendentes são diferentes, pois apesar de grisalhos, se mantém fortes e de bom animo até o fim. E assim sempre será no grande Reino de Dranor.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='1.1 — Sobre Dranor');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '2.0 — A Guerra dos Cem Anos', '20-a-guerra-dos-cem-anos', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## A Guerra dos Cem Anos

Passado quase um milênio desde a primeira guerra contra os Magos Sombrios, que não eram mais que lendas naquele tempo, Dagorcain estava cheio de vida e variadas raças perambulavam e reinavam nas regiões do Continente. Os Homens eram a maior raça, pois se multiplicavam mais rápido que qualquer outra, e se adaptavam e se espalhavam entre as outras, só não se comparavam aos Goblins, Orcs e Kobolds, que pareciam mais pragas que se alastravam em ambientes mais sombrios.

Os Homens também foram responsáveis por mesclar muitas raças, e deles nasciam meio sangues, entre os Feéricos ou Bestiais, e esses também se espalharam no meio de seus parentes. Mas a maior força dos Homens era a região chamada Dranor, pois lá, Homens Fortes e robustos se multiplicaram e formaram uma poderosa força militar, e apesar de não serem os melhores manipuladores de magia, tinha armas inigualáveis, pois tinham aprendido o oficio dos forjadores Anões, que viviam livremente em sua terra.

Os Anões se dividiram em três Casas no Continente, e se espalharam em três regiões montanhosas, a Norte, Sul e Oeste. Os Anões do Norte eram grandes forjadores, e seus salões eram frios e ricos, e eles eram aliados e amigos dos Homens do Norte, e viviam livres nas terras de Dranor. E essa aliança foi poderosa, pois os Homens do Norte, ou Dranorianos, eram fortes e poderosos e combinando isso as habilidosas artes dos Anões de Dranor, formaram um reino inigualável, poderoso o suficiente para dominar em um momento de fraqueza das outras raças, todo o Continente, como veio a acontecer.

Os Anões do Sul eram uma força armada também muito poderosa e rica. Eram os maiores comerciantes e também os mais individualistas, pois era proibida a entrada de qualquer outra raça em seus domínios nas Montanhas, a menos em casos de negociação com Reis e Governantes, e mesmo isso era evitado. Defendiam a região Sul da floresta, próximo as Praias Brancas, e eles iniciaram o costume Anão de fundar ou custear o crescimento de cidades nas bases das Montanhas de seu Reino, que eram usadas como centro comercial, para que não fosse necessário que outros adentrassem seus Salões. E essas cidades sempre eram extremamente ricas e fortes.

Os Anões do Oeste, o Povo de Dirnem, eram os mais amistosos e liberais. Suas mansões eram ricas e belas, apesar de menores que as de seus parentes, mas comercializavam de bom grado com outras raças, e muitas festas realizavam em suas casas, e reuniam várias raças consigo nessas ocasiões. Eram grandes Arquitetos, construtores e Mineradores, e seu comercio era forte, mas se mesclava com outras cidades, e isso lhes impediu de enriquecer e se tornarem maiores que os outros reinos Anões.

Outras Casas se formaram com os anos, mas essas são histórias que não serão contadas aqui. Pois nesse tempo, a Região desolada de Morcul foi coberta por uma nuvem negra, e trovões e clarões vinham de lá, e parecia que fogo era lançado no meio das nuvens. Muitos temeram e tomaram como um alerta.

No final da Primeira Guerra, os Magos restantes decidiram que sua Ordem não deveria caminhar para o desaparecimento, muitos conhecimentos haviam sido salvos durante a guerra, e se não fizessem algo, provavelmente a ordem se dispersaria. Então, decidiram fundar a Grande Escola de Magia, que relembrava tudo o que um dia fora o Reino dos Magos. Muito conhecimento se perdeu, mas seus membros continuaram em beleza e poder comparados ao que foram os Grandes Magos.

E foi a Escola de Magia que tomou a iniciativa de proteger o continente do que eles previram ser a volta dos Magos Sombrios. Apesar de surpresos, pois esperavam que o Feitiço que conjuraram ao construir a muralha de Ered Gorgoroth, as montanhas que circundavam Morcul, era suficiente para deter qualquer tentativa dos Magos Exilados de passar. Mas eles não previram que os Sombrios teriam tanto poder, e resistiriam à barreira. E assim foi, pois os Magos das Sombras estavam retornando, e a planície de Morcul agora era habitada pelos exércitos inimigos, e a invasão estava começando.

Os Magos novamente cumpriram o seu Papel de generais e controladores da Batalha, e eles lideraram as tropas do exercito formado pela aliança das Raças contra o Inimigo. Os únicos que negaram parte do auxílio da Escola foram os Homens e Anões do Norte, que naquele tempo não só dominavam Dranor, como todo o Extremo Norte, fazendo a curva Leste-Oeste, e adentrando muitos reinos na Floresta e nos descampados depois delas, e seu reino findava na nascente Norte do Rio Divisa. E poderosa foi essa Guerra, e nesse tempo mesmo os Drows se uniram a Escola de Magia e as forças do Continente, mas as forças dos Magos sombrios eram muito numerosas, e seu poder de terror era denso e destruidor.

Porém Os Sombrios perderam sua maior força aliada, os Minotauros, pois estes criaram amizade com os Magos do Continente, que os ensinaram muito, e fizeram alianças. Mas os Minotauros não serviam a ninguém, e se mantiveram neutros na Guerra, e fizeram um acordo com os Sombrios, que continuariam neutros se suas terras não fossem tocadas durante a guerra, ou depois. E por cem anos as batalhas continuaram, e muitíssimos feitos foram realizados ali, muitos heróis se ergueram, e incontáveis batalhas mancharam os campos do Rio Divisa, e alcançaram as florestas.

Ora, as Terras de Minos eram ricas e os minotauros fortes soldados, e os Magos Sombrios esperaram o tempo em que suas forças estivessem acima dos poderes do continente e sua vitória quase certa, para tentar dominar Minos. E nos últimos quatro anos da guerra, eles invadiram as terras de Minos, porem o Senhor dos Minotauros fora avisado pelos Magos da Escola, que eles seriam traídos no final, e mesmo não dando ouvidos, preparou uma força por precaução, e os Magos Sombrios foram surpreendidos pelas forças de Minos, e pela traição o Senhor dos Minotauros declarou guerra contra os Sombrios, e invocou de seu povo e das florestas, um exército monstruoso, que lutou sem precisar de auxilio contra as forças Sul de Morcul, e as empurrou para as montanhas Gorgoroth, e os Magos dessa região ficaram desbaratados, e quando finalmente recuperaram a ordem e reuniram suas forças, os Homens do Norte e as forças lideradas Pela Escola de Magia tiveram tempo suficiente para se agruparem, e fizeram um ataque massivo pela frente norte, e rechaçaram as forças dos Magos.

Foi então que os Sombrios deram o Grito de Retirada, e fugiram se refugiando por de trás das Montanhas Morcul, mas muitos grupos da Aliança do continente os perseguiram e ousaram atravessar as montanhas Negras, e daí muitas histórias se seguiram, pois nesse tempo os Magos tinham criado a arma que seria usada caso os Minotauros não tivessem virado o quadro da Guerra, e esta arma era o Caixão das Almas.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='2.0 — A Guerra dos Cem Anos');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '2.1 — A Verdade de Morgoth', '21-a-verdade-de-morgoth', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## A Verdade de Morgoth

O Maior Inimigo de acordo com o povo da Corte Ogai, Morgoth, entre as multidões amaldiçoadas do Caixão, Dozarkin, que na língua dos Dragões era símbolo de honra, ou no Continente de Dagor, onde mesmo seu nome foi esquecido, era conhecido apenas como o Homem, nas lendas que vinham do Clã Mãos Prata. Mas seu verdadeiro nome era Exar Khun que ele mesmo abandonou.

Muitos o confundiram com um Homem Comum, mas sua verdadeira raça é mais uma lenda de terror entre as cidades de Dagor. Ele fora um dos assassinos pessoais de Rainha Rapina, um habilidoso Shadar-Kai.

Escolhido entre os jovens de seu povo, que viviam no Pendor das Sombras, ele foi lançando entre os homens, e ali ele trabalharia para a deusa Rapina em um de seus planos, que em vários momentos buscou criar entre os mortais, assassinos com o objetivo agradar e saciar seus desejos.

Ele não era tão forte quanto os outros de sua raça, ele era jovem e quando lançado no continente e afastado dos poderes do Pendor das Sombras, mais lembrava um Humano meio sangue do que sua Raça de Origem.

Poderoso e habilidoso entre os mortais, em pouco tempo se tornou homem de grande patente no exercito, e liderou grandes guerreiros na guerra contra Morcul, e atuou nos últimos quarenta e dois anos da Guerra dos Cem Anos. Os homens não o questionavam por sua idade avançada e aparência jovial, e desconfiavam que ele fosse vinculado aos seres Feéricos.

Mas como prometido pelas bruxas da deusa, ele foi guiado em suas decisões, mas não contemplara mais o rosto de sua Senhora ou deu seu povo, ele então invejou seus antigos companheiros e permitiu que a raiva crescesse em seu coração.

E assim ele foi levado às terras de Morcul, quando os Magos recuaram para as montanhas. Perseguindo uma tropa poderosa de inimigos, Exar Khun e seus homens se perderam nas Terras escuras. E por muito tempo vagaram lá sem rumo, desolados.

Quando então um grande poder explodiu e sangrou a terra. Forte estrondo e clarão trovejaram naquele momento a frente de Exar Khun e seus homens e o chão se rachou e uma poderosa magia rugia da terra. Os homens buscaram fugir, mas o abismo no momento que se abriu puxou para ele tudo que estava próximo, e Exar Khun e seus homens se encontraram caindo de um céu tempestuoso, rumo a um novo mundo grotesco e amaldiçoado.

Eles haviam adentrado o Caixão das Almas, quando ainda era jovem, recém nascido das magias dos Magos. Exar Khun reconheceu a manipulação de sua senhora, e tentou ser forte e resistir o Mal que angustiava e levava os homens à loucura.

E lá, torturados, muitos de seus homens sucumbiram à insanidade, e apenas vinte e um resistiram e mataram a charada do Caixão. Agora não mais sentiam dor, mas ela fazia parte deles, o Caixão era parte deles. Nesse momento a deusa acreditando ter alcançado grande sucesso em parte de seu plano retirou os homens de lá, mostrando a eles a única porta que já existiu dentro do caixão, hoje não se sabe se ainda existe.

A deusa falou a Exar Khun, dizendo que seu ultimo treinamento terminara, e ele e seus vinte e um homens liderariam o maior clã de assassinos daquele continente, que seriam gloriosos e levariam o nome da deusa por todos os cantos de Dagor, e ele seria seu líder, e depois de sua ultima labuta, se tornou mais poderoso que qualquer Shadar-kai. Exar Khun, como bom servo honrou as palavras da deusa e as seguiu com bom animo, mas por dentro não aceitou as torturas que ele passou e viu seus homens passar.

Exar Khun, diante da desconsideração da deusa, se sentiu abandonado por sua senhora, e se apegou a raça dos Homens e aos exércitos. E o Caixão alterou ainda mais seus sentimentos e os tornou mais imponentes e intensos, e o ódio alimentado pelo abandono cresceu a cada dia naquele maldito lugar, e ver suas guerreiras e guerreiros caírem na insanidade devido à opressão do Caixão, ô fez questionar as manipulações de Rainha Rapina.

Ao sair do Caixão, buscou ignorar seu ódio e seguir os intentos da deusa, sem duvidar ou questionar suas ordens. Ela os guiou para fora de Morcul, e daí segue a história dos Clãs Amaldiçoados, pois Exar Khun é considerado o pai desses clãs.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='2.1 — A Verdade de Morgoth');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '2.2 — De Kira Goraukor (A Mãe de Prata, e a Senhora da Lua)', '22-de-kira-goraukor-a-mae-de-prata-e-a-senhora-da-lua', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## A Mãe de Prata, e a Senhora da Lua

Assim como os Homens de Dranor são fortes, suas mulheres são belas. As damas Dranorianas se comparam as Senhoras Eladrins, em coragem e beleza. Seus espíritos são de um fogo violento, e compartilham a habilidade com armas dos Homens. Altas, de personalidade forte e de uma beleza divina. Artesãs, guerreiras e mães cuidadosas, sem dúvida elas superam de longe outras mulheres de outras raças.

Mas elas evitam olhar para o mundo fora de Dranor, e seu amor está ligado as suas cidades, e julgam não haver outros homens para elas fora de suas terras. Existem poucas histórias entre a união de homens de fora, seja qual for à raça, com mulheres Dranorianas. O que para os homens dranorianos é o inverso, pois muitos se apaixonam pelas senhoras de outras raças, muitas dessas, feéricas.

Mas em uma cidade de Dranor, que vinha da linhagem de uma das doze famílias, uma donzela se apaixonou por um errante da Floresta. Eles tiveram um belo romance, e dessa união nasceu uma bela menina, com a força e personalidade dos Dranorianos, mas com olhos feéricos e sonhadores como os Altos Elfos.

Mas uma tragédia atingiu a cidade, quando um clã de Feiticeiros e Bruxos vindos das beiradas das Montanhas Gorgoroth, golpearam a cidade comandando um exercito de mortos vivos, vampiros e lobisomens insanos. E a criança presenciou a morte de seus pais, e viu seus amigos e conhecidos serem raptados para rituais malignos, e no futuro serem usados e molestados como servos pelos imundos Bruxos.

Os reforços demoraram a chegar, e encontraram a cidade destruída e pilhada. Os moradores foram mortos ou levados, e apenas uma criança encontrou lá, chorando escondida em um guarda roupa. E como era de costume nas terras de Dranor, os órfãos eram levados para fortes militares, eles eram treinados e bem tratados a maneira de Dranor.

A menina cresceu sobre a supervisão dos mestres Dranorianos, e se destacou entre os aspirantes. Era conhecida como Kira, era bela e forte, e muito respeito ela adquiriu entre os guerreiros de Dranor.

Fora enviada em missões de Patrulha nas florestas, áreas que Dranor começou a conquistar. Caçava orcs e outros seres nas colinas em Menegroth, a grande floresta no centro do continente. E seus mestres a ensinava como se virar na mata, e lutar. Mas assim que atingiu a maioridade, se desvinculou do exercito, pois se apaixonou pela arte da Patrulha, e guiou homens em missões de exploração e reconhecimento.

Na maior parte do tempo viveu nas florestas, junto aos elfos e eladrins, e com eles aprendeu muito, e os seus Líderes em Dranor faziam questão de chamá-la para as missões mais importantes. Mas Kira tinha algo em seu coração e jamais esqueceu o desejo de vingança contra aquele clã de Bruxos, que outrora tirou tudo que ela tinha.

Esperou com paciência o momento em que as equipes de Dranor descobrissem o paradeiro daqueles bruxos, pois vingança era algo vivo nos corações dos Dranorianos, e assim como Kira, toda Dranor buscava por eles, pois eram inimigos declarados e deviam ser destruídos.

E um dia, Kira recebeu uma mensagem de seu general, dizendo que encontraram a sede dos Bruxos, que se intitulavam Senhores das Sombras. E uma tropa estava se movendo para floresta, pois eles se esconderam em uma toca a Leste próximo as fronteiras das planícies do Monte Dork.

Naquele tempo, Kira comandava um grande grupo de Patrulheiros na floresta, formado por homens e mulheres de Dranor e feéricos, na maioria. Ela os liderava e lutava contra as forças dos Magos Sombrios que tentavam se infiltrar na floresta. Eram os últimos anos da Segunda Guerra contra os Magos de Morcul, e os Senhores das Sombras eram comandados por eles.

Ao receber a noticia, Kira levou seus homens para se unir à tropa enviada por Dranor, e os alcançou quando a batalha já tinha começado. E por dois dias lutaram, até que conseguiram invadir a base inimiga que ficava em túneis e cavernas. E todos os bruxos e suas bestas foram mortos sem misericórdia, e a vingança de Kira e dos Dranorianos foi ali saciada.

Depois disso Kira pediu a seus senhores sua liberação, para que pudesse liderar com mais liberdade seus homens, e deu sua palavra que continuaria a auxiliar Dranor na patrulha da zona norte da Floresta. E os senhores Dranorianos a aliviaram de seus deveres com o Estado, e assim ela seguiu com seu Clã, e mais de duzentos homens e mulheres a seguiam. Ela era uma líder nata, e sua voz influenciava as mentes e comandava.

E ao final da guerra dos cem anos, perseguindo uma tropa inimiga que ia em direção as Ered Gorgoroth, ela se deparou com um grupo de guerreiros que vinham de Morcul, eram vinte e um homens e mulheres, e seu líder era alto e poderoso. E estes eram Exar Khun e seus homens, que vinham das Terras de Morcul.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='2.2 — De Kira Goraukor (A Mãe de Prata, e a Senhora da Lua)');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '2.3 — As Dez Crianças', '23-as-dez-criancas', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## As Dez Crianças

Saindo dos caminhos tortuosos entre as Ered Gorgoroth, Exar Khun e seus homens alcançaram as planícies Pantanosas, a leste do Rio Divisa. Aquelas planícies eram desoladas, e as águas que desciam das montanhas eram contaminadas e formavam pântanos gigantescos e cheios de moscas, mas eram limpas quando alcançavam as águas do Divisa, que eram rápidas e profundas. Os seres que cresciam ali eram em geral malignos, e ninhadas de orcs, goblins e kobolds cresciam as sombras das montanhas, e ogros e trolls perambulavam e caçavam ali.

Nos tempos de hoje muitas outras raças construíram reinos ali, e essas se aliaram aos Magos na guerra que tem tomado os campos a leste da Floresta. A desolação dos magos e outros seres se alastram até as fronteiras do rio Divisa, pelas magias vinculadas ao Pendor das Sombras, e demônios se escondem em cavernas nas montanhas de Gorgoroth. E uma escuridão toma aquelas terras, e para lá apenas os exércitos protegidos por magias de cura ou os povos negros dos Magos caminham.

Ora, Exar Khun e seus guerreiros conheceram uma loucura e terror mais obscuro do que qualquer uma que existia nas planícies pantanosas, e sua presença ali causava medo nas criaturas que para lá fugiam, pois a derrocada dos magos escuros era recente, muitas tropas de Morcul ainda estavam se retirando para as terras escuras. E Rainha Rapina observava seus novos soldados de perto, que avançavam para além do Rio Divisa. Exar Khun era mais poderoso e perigoso do que qualquer Shadar-Kai de seu povo, e muito orgulho a deusa tinha de seu plano, que até ali seguia perfeitamente.

E depois de atravessarem o rio encontraram uma tropa Tiefiling que fugia para as montanhas de Morcul, observaram de longe sobre a Colina, quando a deusa falou a Exar Khun que se lançassem contra eles. E assim fizeram, os emboscaram nas travessias do Rio Divisa, e nenhum alcançou a segurança de Gorgoroth.

E pouco depois do conflito, uma tropa de patrulheiros alcançou o campo de batalha, eram liderados por uma bela mulher dranoriana, e eles ficaram surpresos ao ver vinte e um guerreiros derrotarem mais de trezentos Tiefilings bem armados. E Exar Khun se encantou ao ver a bela mulher, e pediu que seus guerreiros pudessem acompanhar ela e seus homens.

Ela, porém, era de temperamento difícil e teimoso, e muito questionou Exar Khun e seus homens, mas se viu ainda mais impressionada quando soube quem ele era, pois era um general conhecido por seus grandes feitos no exercito Dranoriano. E com isso aceitou que Exar Khun os seguissem até a floresta.

Mas um forte sentimento tomou o coração de Kira, que sempre foi frio. E ela se apaixonou por Exar Khun, assim como ele por ela. E quando chegaram à floresta Kira permitiu que Exar Khun se juntassem a seus homens, e a presença deles influenciava os patrulheiros, pois o poder do caixão fluía neles e infestava.

E Rainha Rapina, que há muitos anos manipulava e influenciava os caminhos de Kira, abençoou a união entre ela e Exar Khun.

Muito poder havia em Exar Khun e seus homens, e a deusa os transmitia para todos os patrulheiros de Kira. E os vinte e um guerreiros se tornaram mestres, e treinaram os homens, assim como os novatos, e juntos Kira e Exar lideraram o Clã, que já tinham mais de quinhentos membros, e sua sede era como uma pequena cidade, que se enriquecia com as recompensas e contratos mercenários.

Ora, os patrulheiros de Kira após se desvincularem do exército de Dranor, tornaram-se grandes mercenários a comando de sua líder, que perseguia Bruxos e criaturas do Pendor das Sombras, pois Kira, apesar de uma militar dranoriana, era sedenta por liberdade e queria guiar seus homens longe da sombra dranoriana, e os contratos mercenários eram uma rica fonte, e ela fazia o que mais apreciava caçar e matar seres malignos.

E Exar Khun, como Kira, era um militar de mão cheia, e organizou o Clã junto com sua esposa, e muita riqueza e renome eles conquistaram. Mas com o tempo, Kira e todos os membros do clã se assemelhavam cada vez mais a Exar e seus homens, com uma aparência fria negra. Pois os membros eram contaminados com a magia que emanava deles, e suas habilidades eram aumentadas.

E o clã não era só composto por patrulheiros, ele cresceu muito e ultrapassava mais de mil membros, controlados com mão de ferro, e outras classes como magos e feiticeiros entraram no grupo, e com tempo, mesmo os membros mais comuns aprenderam lançar pequenos feitiços de loucura e horror, que tornava os inimigos em baratas para eles, e essa passou a ser uma marca do Clã.

E quando a deusa notou que o poder dos guerreiros estava limitado para alimentar todos os membros do clã. Ela mandou uma de suas bruxas Shadar-Kai a Exar Khun, e a ele entregou uma chave mágica, um cristal entalhado com caveiras, e com ele Exar Khun podia abrir portas para o Caixão das Almas, e extrair poder de lá. E a ele e aos vinte e um homens ela ensinou como abrir essas portas e lançar lá inimigos perigosos, mas não lhes deu o poder de tirá-los, e com uma arte que apenas os mais habilidosos dos vinte e um Mestres puderam aprender, ela ensinou como eles poderiam materializar seus espíritos no caixão, e assim saber sobre o que acontecia lá dentro.

O clã passou a crescer sob uma sombra, e todos os membros passavam por um ritual, e eles eram banhados pelas magias do caixão, e Kira viu seu clã mudar para um povo obscuro, mas a deusa manipulou sua mente para que não se incomodasse e até mesmo fosse afetada por sua proximidade com Exar Khun.

E dez filhos a deusa deu a eles, cinco pares de gêmeos, com meninos e meninas. Mas Exar Khun em seu interior guardava ódio e rancor pela deusa, mas isso escondia de todos. E sua família era para ele muito importante, e seu amor por sua esposa era tudo para ele. E a deusa não previu o rancor no coração de Exar Khun, o que poderia ter mudado o destino de muitas vidas.

Pois para as crianças a deusa reservou a herança de seus pais, a liderança sobre clã. Mas apenas cinco seriam soberanas, e elas criariam uma linhagem no clã de guerreiros superiores, e com isso concluiria a base do exercito que ela almejava a eras. E a noite, a casa de Exar Khun foi visitada por um espírito poderoso, um semideus aparentado a Rainha Rapina, em forma de um lobo branco, e deixou uma marca no braço dos gêmeos mais velhos de cada par.

E enquanto as crianças cresciam Exar Khun sempre demonstrou preferência por aqueles que não foram marcados. E os marcados estavam sempre debaixo dos olhos orgulhosos da mãe, que sempre seguiu e adorou Rainha Rapina. E essa posição dos pais gerou uma rivalidade entre os irmãos. Mas os vinte e um guerreiros, que agora eram lideres abaixo de Exar e Kira, chamados de Mestres Mão de Prata, odiaram as crianças, e pensar que elas poderiam liderá-los lhes provocava asco, pois foram tocadas por aquela que os lançou em um tormento quase eterno no maldito caixão.

Com o tempo eles envenenaram a mente do próprio Exar Khun, contra Kira e suas adoradas crianças. Diziam que eles seriam símbolo de desavenças e contaminariam a pureza que foi construída com tanto esforço. E esses pensamentos tomaram a mente de Kun, e Kira sentia que ele cada vez mais se afastava dela e de seus cinco filhos.

E quando Exar Khun já tinha sido consumido por aqueles pensamentos, os Mestres lançaram em sua mente desconfiança por Kira, dizendo que ela planejava tomar o Clã e se tornar novamente à única soberana, e com seus cinco filhos marcados, subjugar os outros cinco e o clã inteiro, traindo Exar Khun. E também aproveitaram o ódio que ele guardava pela deusa, e o convenceram que esse sempre fora o intuito de Rainha Rapina.

E completamente envenenado com aquelas mentiras, Exar Khun começou a observar Kira e impor suas ordens acima das dela, e cada vez mais deixava os cinco que não foram marcados longe de Kira. Mas aquilo não bastava para os Mestres, eles queriam os cinco marcados mortos, e Kira devia ir com eles, para não causar problemas.

Kira era poderosa e tinha homens de confiança no clã, e os mestres temiam tentar fazer algo contra ela, mas estavam decididos que isso seria para o bem de todos. Mas eles sabiam que os feitiços que eles lançaram sobre Exar Khun em breve perderiam efeito, pois o poder dele superava todos os Mestres juntos.

Então, em uma ultima jogada, lançaram o maior feitiço que podiam sobre a mente dele, e o fizeram acreditar que a Traição de Kira e seus homens eram eminentes, e que eles deviam atacar primeiro. Mas Exar Khun não se dispôs a participar do ataque, e escondeu os seus cinco filhos, e deu a permissão que os mestres queriam.

E Kira foi surpreendida, e um combate começou na sede do Clã. Kira não entendia o que estava acontecendo, mas sentiu a magia dos Mestres por trás daquilo, e fugiu com seus filhos, pois estava em menor numero, mas no processo matou dois dos Mestres. Eles a perseguiram pela floresta, mas algo muito maior que eles a escondeu.

Rainha Rapina se enfureceu com a traição dos Mestres e de Exar Khun, e protegeu e guiou Kira e seus filhos para um lugar seguro, mas esta história segue nos Relatos de Aegnor, que viveu próxima a Kira e os cinco, enquanto estes viveram entre os homens.

E os mestres dominaram o Clã, se aproveitando dos últimos resquícios dos feitiços que manipulavam Exar Khun, e o intitularam Mãos de Prata, e tornaram o Clã o que ele é hoje.

Mas seus feitiços tinham limite sobre a mente de Exar Khun, e quando o efeito deles passou, Exar Khun chorou e se arrependeu do que aconteceu, e enfurecido humilhou os mestres, e com duras palavras os colocou em seu lugar. Mas ele não viu toda a verdade, e não os destituiu de seus cargos. Mas buscou por sua esposa e filhos, e isso para os Mestres foram à gota d’água, e decidiram que o próprio Exar Khun não era um líder ao nível do Clã Mãos de Prata.

E desde crianças as mentes das crianças foram envenenadas por eles, e começaram a planejar um golpe, assim que as crianças chegassem à maioridade. E quando esse momento chegou, eles manipularam os cinco, que ajudaram na traição contra seu pai. E forjando um contrato, levaram Exar Khun para uma emboscada. Mas Exar Khun era poderoso, e matou maior parte de seus agressores, mas eram muitos, e ele estava em uma péssima situação. Ele fugiu e se escondeu, mas jurou vingança contra o Clã.

E os Mestres manipulavam os cinco filhos, que se tornaram os lideres. E então as Mãos de Prata se tornaram os homens amaldiçoados que são hoje, pois os Mestres tinham uma terrível tendência maligna. E os Mestres sabiam que os outros cinco e sua mãe ainda estavam vivos, e previram que ainda causariam problemas para eles. Assim, convenceram seus irmãos que os cinco marcados eram amaldiçoados, e que eles e tudo que viesse deles, eram inimigos e deviam ser exterminados.

E nesse tempo, os Cinco Marcados se mudavam para cidade que Dranor os concedeu, aonde formaria um grande exercito de Lobisomens, tão grande quanto o exercito da Mão de Prata. E eles procuraram e perseguiu o Clã Lican, Gaurhoth. E inimizade entre eles só cresceu, entre os dois séculos que se seguiram. E muitos morreram nesses combates, de inocentes a guerreiros de ambos os lados.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='2.3 — As Dez Crianças');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '2.4 — Da Organização dos Mãos de Prata', '24-da-organizacao-dos-maos-de-prata', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## A Organização dos Mãos de Prata

E a Rainha Rapina os amaldiçoou. E essa maldição alcançou o clã, como alcançou Exar Khun, e a glória da Mão de Prata se encheu de escuridão, e eles eram assassinos cruéis, e abandonaram os antigos códigos criados por Kira e Exar Khun. Espalharam mitos de terror entre o povo, e os lideres de todas as cidades temiam fazer contratos com eles, o que levou os membros a saquearem cidades, fazerem pilhagem e aceitarem contratos de outros Mestres Caóticos e Malignos.

Mas a deusa ainda viu potencial neles, e não os negou a chave do Caixão, e com o tempo voltou a usá-los para seus intuitos. Pois independentes de sua traição eles ainda eram uteis, e quando a nova Geração de Mestres e Lideres acendeu por descendência, ela os seduziu, e apesar do Clã ser composto por adoradores de vários tipos, muita atenção da liderança era prestada para Rainha Rapina.

E a deusa os guiou para a ruína de Tirith Gorgoroth, uma cidade que foi instalada na base das Montanhas de Morcul, com o intuito de vigiar o movimento dos magos, destruída no inicio da guerra dos Cem Anos. E eles a reconstruíram a sua maneira, e ela se tornou a sede dos Mãos de Prata. E mil guerreiros ela continha, e todos os anos eram escolhidos mais cem aspirantes a membros oficiais, e desses apenas vinte e um eram aceitos ao final do Treinamento.

Mas essa sede só era vista pelos membros mais antigos e honrados, e os cinco Lideres de quando em quando visitavam as bases fundadas na floresta para inspecionar os membros.

Eram vinte e uma bases espalhadas e escondidas nas montanhas Lammoth, e nas regiões negras da floresta a norte. Nelas os aspirantes eram treinados, e os aprovados mantidos até terem maior experiência. E todos os anos a liderança das bases era alterada, pois os vinte e um aprovados se tornavam os novos lideres, e acima deles havia um General dos Mãos de Prata. E eles treinavam os novos cem aspirantes.

Os Mestres agiam por traz dos Cinco Lideres, se intitulavam conselheiros, mas comandavam com mão de ferro todo o Clã. E a hierarquia seguia, abaixo dos cinco lideres e dos Mestres, com dez Generais, dois comandados por cada um dos Cinco, e cada um deles comandava trezentos homens. E vinte e um Comandantes, escolhidos entre os mais experientes guerreiros, para liderar e treinar os novos membros e seus cem aspirantes.

E todos os anos, quinhentos novos homens se uniam ao poderoso exercito, mas esse não crescia com facilidade, pois ao passo que quinhentos entravam, um número entre trezentos e setecentos morriam, ou debandavam.

E a base econômica era mantida pelos contratos mercenários caríssimos e na pilhagem que faziam depois dos ataques. Mas também enriqueciam quando invadiam clãs orcs, goblins, kobolds, ferais, vampiros, magos e bruxos caóticos malignos, bruxas, cambiontes, e uma lista interminável de seres infernais e malignos, que fora criada por Kira, que jurou vingança a esses pela morte de seus pais.

Mas os Mestres em muitos momentos, por ganância e cobiça, aceitaram contratos encomendados por esses seres, mas em uma boa parte deles, após cumprirem o contrato, invadiram e mataram a todos os contratantes, pois os consideravam imundos. E mais do que imundos eram para eles os Lobisomens. Um ódio enraizado na mente de todos pelos mestres que sequer Rainha Rapina conseguiu expurgá-lo, mas acabou em alguns momentos se divertindo com luta entre os Mãos de Prata e os Lobisomens.

Pois os Mãos de Prata odiavam toda a raça licantropa, fosse os insanos e selvagens, fosse os dotados de inteligência e controle. Pois diziam que eles queriam ser mais inteligentes, mas eram mais imundos que qualquer outro. E os Gaurhoth, eram os seus maiores inimigos, pois esses eram o clã fundado pelos Cinco Gêmeos malditos, e muitas batalhas eles enfrentaram, pois essa raça de lobisomens era páreo para qualquer soldado Mão de Prata.

E das cidades e clãs lobisomens nada era saqueado, mas tudo era queimado, assim como qualquer um que se misturasse a eles. Pois quando os Mão de Prata declaram alguém como inimigo, esse era complemente aniquilado, e tudo ligado a ele era imundo e devia ser expurgado do mundo.

E julgando serem agentes da ordem, os Mestres afundaram o clã em uma escuridão maior que os próprios Magos Sombrios, pois todos novos membros, como ultima parte do treinamento, tinham seus espíritos materializados no caixão, e lá absorviam o poder escuro do Caixão, e nunca mais se desgarravam deles.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='2.4 — Da Organização dos Mãos de Prata');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '2.5 — O Resumo do relato de Aegnor, a Branca', '25-o-resumo-do-relato-de-aegnor-a-branca', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## O Resumo do relato de Aegnor, a Branca

Eu era jovem, uma criança de doze anos, vinha de uma família de Elfos e Meio Elfos, e vivíamos em uma cidade a Norte na Floresta Menetrels, em Menegroth. Era bela, e Homens, Ferais e Feéricos viviam ali em harmonia. Eu nasci no final da Segunda Guerra contra os Magos, meu pai era um Soldado da horda Feérica liderada pelos Dranorianos, pois nossa cidade cresceu sobre o domínio de Dranor, mas éramos bem tratados, pois os Tiranos Reis ainda não tinham ascendido e se colocado entre os Nove.

Meu pai foi muito ferido na Guerra, e depois de servir fielmente por vinte anos foi aliviado de seus deveres, e voltou para minha mãe, e se tornou Guarda da Cidadela. Muita felicidade residia ali, e tínhamos fartura mesmo nos tempos da Guerra, pois os Homens do Norte tinham muito cuidado por aquela cidade, diziam que um poderoso entre os Reis Dranorianos tinha desposado uma bela elfa que morou conosco, e desde então recebemos muita atenção do Norte.

Muitos deuses eram adorados ali, mas a cidade fora construída em nome de Rainha Rapina, motivo pelo qual alguns Clãs Ferais se estabeleceram nos arredores da Cidade, e se misturaram ao povo, como comerciantes até Sacerdotes da deusa Rainha. E por muito tempo o mal não nos alcançou, nem mesmo através dos Magos Sombrios, isto viria mais tarde pela mão de Reis que envergonharam a imagem dos antigos Senhores Dranorianos.

Era tarde e chovia, e som do vento era melancólico, mas a noite ainda estava bonita, quando uma jovem bateu nos portões. Estava cansada e ferida, assim como os dois homens que a acompanhavam. Eles tinham cinco crianças consigo, e findaram seu trabalho trazendo a moça e seus filhos a salvo para a cidade, a protegendo de algum perseguidor, e pereceram nas casas de cura. Ela, apesar de cansada, resistiu aos ferimentos, e chorou ao saber que seus companheiros tinham morrido, mas se alegrou pelo bem estar de seus filhos.

Os Homens que estavam com ela eram Dranorianos, não faziam mais parte do exercito, mas seus traços não negavam sua origem, o que aumentou os cuidados pela mulher. Minha mãe era uma dos feéricos das Casas de cura, e acompanhei parte dessa história de perto. O nome da Moça era Kira, era conhecida naquelas terras. Era líder de um Clã de Patrulheiros de renome, mas há alguns anos pararam de dar noticias.

Ela foi muito questionada, mas evitou algumas perguntas, e os homens não insistiram. Kira era muito bela, e seu porte e traços vinham das terras do Norte, das damas Dranorianos, e dos Homens ela não podia negar sua origem. Apesar de durona como os de seu povo, era amorosa com seus filhos, e com qualquer outra criança, e eu me apeguei muito a ela.

Os Homens deram ordens para que não criassem alvoroço ou comentários que chegassem aos ouvidos dos estrangeiros, e ela viveu entre nós. Dentro da cidade ela ajudou os Homens, que receberam seus conselhos e ordens de bom grado, pois ela tinha o dom de comandar, e suas palavras eram dominadoras, e era uma grande Militar, pois isso corria no sangue dos descendentes de Dranor.

E seus filhos cresceram entre nós, e a cada dia revelavam seu parentesco com os Nortistas. Mas eles tinham algo mais, o espírito deles era ainda mais forte e ardente que qualquer Dranoriano, e tinham traços desconhecidos que não vinha de Dranor, o que nos assustou, pois o sangue Dranoriano era às vezes mais forte que o dos Feéricos. E eu me perguntava quem teria sido o pai dessas crianças. Eles eram queridos pelo povo, o três rapazes mais velhos eram fortes e altos, e suas duas irmãs eram belas como senhoras dos Altos Elfos. E mesmo elas se mostraram grandes guerreiras ao lado de seus irmãos.

Quando chegaram à cidade, os Sacerdotes Ferais de Rainha Rapina notaram uma marca que eles carregavam. Diziam ser a marca do Senhor dos Lobos, que era adorado por grande parte dos Clãs Ferais, um semideus aparentado a Rainha Rapina. E tomaram aquilo como um sinal da deusa, e que as crianças foram escolhidas.

E grandes feitos vieram deles, pois junto com sua mãe formaram um grupo de guerreiros poderosos na cidade, intitulados pelo povo como Imortais, e estes tiveram grande papel quando os Orcs invadiram as montanhas e lutaram contra os Homens. E Kira escondeu seu nome, comandava a seus homens, mas evitava sair da cidade.

Mas quando o mais velho chegou a seus vinte e um anos, fomos assombrados por um mal durante a madrugada. A Lua estava alta e gritos começaram a ser ouvidos na escuridão. Os guardas davam ordens, pois algo tinha entrado na cidade e pessoas tinham sido atacadas. Muitos estavam feridos, e todos os Imortais, os guerreiros de Kira, foram surpreendidos nos dormitórios e atacados sem poder se defender. Poucos morreram, mas todos sofreram ferimentos graves. Meu pai também foi atacado, e minha mãe, que estava atendendo os feridos nas ruas, viu uma fera se arrastando na escuridão, atacando a todos com uma fúria infernal. Os Guardas formaram barricadas em todas as saídas da cidade, mas uma delas foi rompida violentamente, e seja lá o que nos tinha atacado fugiu para as florestas.

O filho mais velho, líder dos Imortais, desapareceu do dormitório. Kira estava desesperada e mandou seus homens vasculharem as cidades e os arredores da floresta, mas nada encontraram. Os guardas e pessoas feridas foram tratadas, e houvera poucas mortes.

E por um mês Kira procurou seu filho, e ajudou pessoalmente nas buscas. E quando a lua subiu cheia nos céus, gritos novamente foram ouvidos, pessoas corriam, e minha mãe entrou em casa desesperada. Dizia para meu pai que os feridos estavam se transformando em bestas, os Imortais desapareceram, e todos estavam sendo atacados. Meu pai cobriria o próximo turno dos Guardas, mas quando ele terminou de se aprontar e a luz da lua adentrou nosso quarto pelas janelas e pela sacada, os olhos dele brilharam, e ele urrou de dor, minha mãe me protegeu em seus braços enquanto víamos meu pai se contorcer no quarto, quebrando móveis, rosnando como um animal.

Minha mãe fugiu comigo para a sacada no quarto, e de lá olhamos para a cidade, e víamos vultos correndo pelas ruas, destruindo as lamparinas, correndo sobre os telhados, uivando e atacando as pessoas e guardas. Tochas estavam acesas nas mãos dos defensores, mas elas não afastavam as bestas, e a cidade estava infestada. Saiam das casas, subiam nas torres, e uivavam para a lua. E quando voltamos nosso olhar para meu pai, um grande lobisomem estava em nossa frente, e ele vinha em nossa direção. Minha mãe me abraçava forte dizendo que tudo ficaria bem.

Então um uivo que superava a todos que eu tinha ouvido naquela noite, veio da direção das muralhas da cidade. E antes de nos atacar, meu pai parou como se tivesse recebido uma ordem, e rosnando olhou atentamente para a muralha. Saltou sobre nós e foi naquela direção. Olhamos para o Portão da cidade, e lá, posicionado no Arco sobre o Portão, a luz incendiou o olhar de um Lobisomem Branco, alto e poderoso.

E todas as bestas na cidade começaram a se reunir a frente do Portão, e mais quatro feras brancas, que também estavam a atacar a cidade se colocaram a frente de todas. E Kira, trajada com armadura e armas, avançou entre os lobisomens, que abriam caminho pra ela. Chegando ao portão a fera branca desceu e ficou a sua frente. E voltando a forma humana, em farrapos estava o Filho mais Velho de Kira, que abraçou a mãe naquele momento. E todos os Lobisomens atrás dela caíram e começaram a se dês transformar.

Os Guardas detiveram Maedhros, o filho desaparecido de Kira, pois estavam assustados e confusos. Também começaram a recolher os feridos e mortos. E os transformados também foram levados as casas de Cura, entre eles estavam os Imortais e os outros quatro filhos de Kira, e foram tratados pelos curandeiros Ferais, que conheciam bem a raça e eram parentes distantes.

Maedhros contou a mãe e aos Guardas, e aos Sacerdotes Ferais, que por três semanas ele esteve transformado, e não podia voltar à forma humana, e que na noite de sua primeira transformação não conseguia se controlar e sentia muita dor, que o deixou insano. E nas três semanas que se manteve vagando como que por instinto, compreendeu seus poderes e descobriu como se dês transformar. E a ele apareceu um espírito em forma de um Lobo Branco, que lhe deu muitos conselhos, mas disso ele não poderia falar.

Ele aprendeu a se comunicar em uma língua estranha com outros de sua raça, e podia controlar os novos transformados, e sabia como transmitir esse ensinamento. E assim ele garantiu que não haveria mais incidentes. Ele voltou ainda mais imponente e poderoso, e suas palavras eram firmes.

Os Homens informaram os Senhores Dranorianos, e um deles veio pessoalmente. Ele falou com Kira e seus cinco filhos, e Maedhros o convenceu de seus dons e de sua história, pois assim como a mãe, grande voz e poder sobre outros ele tinha. Mas o Rei não sabia o que fazer, pois não devia deixar uma cidade cheia de lobisomens, mas os outros Senhores viram aquelas pessoas como uma arma de guerra.

Falou em conselho com os outros reis que os Lobisomens eram uma questão de seu reino, pois aquela cidade esteve por debaixo de seu olhar e de sua esposa, que cresceu lá. Os Senhores aceitaram, mas disseram que ele não poderia desperdiçar tanto poder, e eles seriam um novo exército, um dos mais poderosos de Dranor, pois muitos dos transformados ali, inclusive os cinco filhos, eram da raça dos Dranorianos.

O Rei então achou uma solução, disse que a cidade se manteria, pois era importante para ele e sua mulher, mas os lobisomens não podiam ficar ali. Disse que uma grande obra começara pela mão dos Anões e Feéricos do Norte, em terras escondidas no reino de Dranor, e ali a cidade dos Lobisomens ficaria. Mas eles eram livres para andar disfarçados em outras cidades para comercio, desde que lá não se fixassem sem a autorização de Dranor, e qualquer incidente poderia levar a sérias conseqüências.

E nos garantiram prosperidade nessa nova vida, pois o novo Reino que Dranor começou no continente era a favor da liberdade, e parte dela nos foi tomado pela maldição. E em troca receberiamos moradas ricas, um governo separado e pouco influenciado por Dranor, livre entrada nas cidades, mas jamais poderíamos morar em outro lugar, ou passar um período muito longo fora de Dranor ou da cidade.

E passado um ano, os Homens de Dranor nos guiaram para o Norte, Kira e seus filhos lideravam a marcha, e depois de meses viajando nas terras geladas nos deparamos com um poderoso exemplo da belíssima arquitetura dos Anões, uma gigantesca cidade escavada nos paredões de Gelo.

Imensa como os salões das mansões Anãs, através de técnicas e engenharia que só os Anões e Feéricos conheciam, uma luz como a da lua, porém mais clara e quente, refletia em espelhos vinda de fora da fortaleza, e esquentava e iluminava o interior da cidade durante o dia, e grandes luminárias foram postas para noite, mas em dias de Lua cheia, no centro da cidade aonde o teto entalhado no gelo era transparente, uma grande e bela imagem da lua surgia para nós, e sua luz iluminava o grande salão. E só aos Dranorianos foi revelado o caminho que levava a cidade.

E a Kira foi dado o Governo da cidade, e belo foi aquele reino, e disfarçados entre os homens e outras raças, fizemos comercio com ajuda de Dranor, enriquecemos e prosperamos escondidos do mundo. Nossa relação com outros lobisomens era fria, pois eles eram ignorantes, feras incontroláveis e nos envergonhavam. E a Rainha Rapina foi adorada ali, e dizem que ela falava com Kira e seus filhos pessoalmente, e um grande dom os havia entregado, uma chave, para libertar os atormentados.

Mas nossa paz era assombrada por um inimigo que nos caçava como animais, as Mãos de Prata, que eram ligados a nossa história, e em pouco tempo nos perceberam entre os homens, e muitas vezes perseguiam nossos viajantes. E foi assim que passamos a fazer comercio acompanhado de tropas, e muitas vezes houvera confrontos entre o nosso clã e o deles. E esses combates só cresceram com o tempo, e muitas vezes sofremos repreensões de Dranor, pois devido aos conflitos com as Mãos de Prata nossa presença foi notada, e mitos sobre os Altos Lobisomens se espalharam.

As Mãos de Prata queriam descobrir aonde era nossa cidade, e invadiam pequenos vilarejos e comércios que fundávamos na floresta, pois a nós foi liberado esse direito, desde que nenhum um estrangeiro pudesse viver lá, eram cidades para facilitar o comercio. E eu e minha família vivíamos em uma dessas cidades. E os conflitos contra os Mãos de Prata foram à única guerra que conhecemos, porque os Reis queriam nos esconder, e só nos usariam contra algo maior que as tropas bestiais, nos tempos de Guerra.

E assim termina o relato de Aegnor, uma Senhora Élfica que viveu entre os lobisomens por duzentos anos, e seu pai se tornou um grande general entre eles. Ela morreu em um ataque das Mãos de Prata, lutou bravamente, mas caiu ao lado de seu pai. Ela nunca foi transformada. Deixou esses textos que passaram a fazer parte da biblioteca da cidade de Minas Ithil, a cidade da Lua, casa dos Lican, os Altos Lobisomens.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='2.5 — O Resumo do relato de Aegnor, a Branca');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '2.6 — Da Organização dos Gaurhoth', '26-da-organizacao-dos-gaurhoth', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## Da Organização dos Gaurhoth

Foi falado sobre a construção da grande cidade Minas Ithil, aonde vivia o mais poderoso Clã da raça dos Altos Lobisomens, por debaixo dos olhos de Dranor. E Kira e seus cinco filhos governavam a belíssima cidade. E estes eram os filhos de Kira, senhores sobre a cidade da Lua:

**Feänor o Branco**, Senhor Supremo de todos os Gaurhoth, sua forma bestial era de um lobisomem altivo e pardo, e todos de sua descendência adotavam essa características. E dele vieram os mais poderosos lobisomens de Minas Ithil. E ele mesmo criou e comandou a horda mais poderosa dos Lican, os Gorthaur, que em sua maioria era composta pelos pardos de sua espécie.

**Rumil o Alto**, pois sua linhagem era a de maior estatura, e seus filhos eram honrados. Junto com sábios Dranorianos, fundaram a biblioteca de Minas Ithil, que guardava histórias de todo o reino Dranoriano e Lican. E eles criaram a escrita para a língua que só os lobisomens falavam e entendiam. Tornaram-se mestres da tradição, e eram conhecidos mesmo nas cidades de Dranor.

**Hildor Pai dos Cinzentos**, pois dele veio uma grande linhagem de lobisomens cinzentos, que eram os únicos que tinha habilidade com magia dentro das cinco famílias, e esses eram os curandeiros e magos dos lobisomens. E muitas artes aprenderam com os Ferais e Feéricos que moravam e Minas Ithil, mas eram incapazes de usar sua magia quando transformados, essa era uma habilidade da casa de Narya, e assim pouco usavam seu poder licantropo, preferindo as artes do arcanismo e bruxaria.

**Narya Morgaur**, pois sua transformação era a de uma besta escura como o vazio, e sombras a rodeavam, através de uma magia estranha. E onde ela passava um pavor se espalhava entre os homens comuns, mas em sua forma humana, era bela como uma dama dranoriana, pois herdou de seu pai o poder obscuro dos Shadar-kai, e a beleza e destreza dranoriana de sua mãe. Mas seus descendentes não tinham o mesmo poder que a Dama Morgaur, e a cada geração era como se o poder se enfraquecesse, mas com ardo treinamento eles podiam ressuscitar aquelas trevas.

E **Rian Glincaran**, a dama dos olhos vermelhos, pois seus olhos eram penetrantes e escuros como os do corvo, característica do povo de seu pai. E em sua forma bestial, era a que enxergava mais além no horizonte. Era também conhecida como Farwenroth, a senhora dos caçadores. Pois ela liderou, treinou e comandou por muitos anos os mais poderosos patrulheiros dos lobisomens. E era bela, teimosa, corajosa e difícil como sua mãe.

Kira com o tempo passou a agir mais como uma conselheira, e deixou o governo da cidade para seus filhos. E o poder entre eles era dividido igualmente, e eles agiam como uma só mente, e lideraram com sabedoria.

A cidade era grande, uma fortaleza construída nos paredões de Gelo, parte dela, sua muralha e uma enorme torre, se apresentavam fora do Paredão. Mas seus salões se estendiam em cavernas escavadas no gelo e na rocha, pois os Paredões outrora foram grandes penhascos, e sua orla era tropical.

E eles tinham um exército de três mil homens, treinados por sua gente e militares de Dranor, pois a cidade não tinha apenas lobisomens, mas uma pequena parcela era de pessoas e guerreiros comuns, que se negavam a receber o dom dos licans. Pois junto com esse dom havia um cárcere que em muitos casos nem a grandeza ou beleza da cidade, suprimia.

Pois aos lobisomens era negado residirem em outros lugares, e nem deviam ficar muito tempo em outra cidade, mesmo dranoriana. Pois os Reis de Dranor acreditavam que os lobisomens eram uma força que devia permanecer oculta, e usada em extremo caso. E era proibido sobre pena de morte, que qualquer um sequer comentasse com estrangeiros, algo sobre os Altos Lobisomens, ou Gaurhoth, na língua dos feéricos.

E Minas Ithil no inicio teve riqueza, mas o limite de comercio estabelecido por Dranor fez com que a cidade começasse a ter problemas, e os cinco reuniram uma assembleia com os lideres Dranorianos, e imploraram que pudessem construir cidades em nome Dranor para comercializar com mais facilidade, e também abrir sua economia a outras cidades além de Dranor.

Os reis aceitaram com dificuldade, mas apenas os homens comuns de Minas Ithil poderiam se fixar nessas cidades comerciais, e Dranor não iria se responsabilizar pela defesa dessas, a não ser em caso de guerra. Mas os militares escalados para defender e policiar essas cidades podiam ser comuns e lobisomens. E foi definido que nessas cidades os guardas lobisomens deveriam retornar para Minas Ithil todo o mês e outro grupo deveria ficar em seu lugar, pois um mês era o limite dado a qualquer um da raça dos lican, para ficarem em uma cidade de fora.

E os lideres das cidades eram escolhidos pelos Cinco Senhores da Lua, os filhos de Kira, e a eles esses lideres deviam obediência.

E Dranor auxiliou a construção dessas cidades, e deu o chute inicial para que o comércio alavancasse, e assim, a cidade voltou a enriquecer. Mas isso fez com que um mal fosse atraído, pois os Mão de Prata perceberam essas atividades, e desconfiados e auxiliados por alguma força estranha, descobriram os Gaurhoth. Pois os Mão de Prata odiavam lobisomens de qualquer espécie, e seus lideres sabiam que os cinco filhos de Kira estavam vivos em algum lugar, e a todo tempo procurou por eles.

E começaram a invadir e queimar as cidades dos Lobisomens, e em resposta, Minas Ithil reforçou a defesa das cidades, e eles lutaram contra as invasões dos Mãos de Prata, e em muitos conflitos, revelavam sua forma bestial para enfrentar os poderosos guerreiros amaldiçoados, o que espalhou boatos e mexericos sobre os altos lobisomens que formavam exércitos e vagavam nas cidades e florestas disfarçados de homens.

Mas o Clã Mãos de Prata passou a ter muitas baixas, e se deteve nos ataques, mas estavam a todo tempo planejando novas invasões tentando descobrir onde ficava a sede dos malditos lobisomens metidos a espertos. Pois para eles todos os lobisomens eram uma praga asquerosa, seja qual for sua classe, pois odiavam ainda mais aqueles que se achavam mais inteligentes que outros.

### Dos Exércitos

Como foi dito, muitas raças viviam no meio dos Gaurhoth. Alguns indivíduos vinhas das famílias de transformados, ou se uniram a marcha dos lobisomens por amizade. Também vieram famílias ricas de Dranor, que muito se admiraram e desejavam viver entre aquele povo magnífico, naquela bela cidade. E para o exército vieram muitos soldados e aspirantes Dranorianos. Mas em muitos casos essas pessoas se negaram a se tornar lobisomens, por receio, ou medo de se prenderem a cidade, como dizia a lei.

E dos lobisomens nasciam filhos de raça pura, nascidos com o dom da licantropia. E a raça se multiplicou, mas não havia casos de preconceitos entre os comuns e os lobisomens, e todos viviam em uma bela harmonia. E mesmo os exércitos eram mesclados, mas em sua maioria era composto por lobisomens.

Há principio as tropas foram treinadas pelos Dranorianos, enquanto Fëanor e seus irmãos ensinavam o controle de sua forma bestial. E qualquer dessa raça tinha a habilidade de controlar novatos, utilizando uma espécie de ligação mágica, e mesmo a língua deles tinha poder de controle sobre os recém-transformados e classes baixas de lobisomens, e muitos se tornavam capazes de ensinar a outros o autocontrole.

E o exercito possuía Fëanor como comandante supremo, e abaixo dele estavam seus irmãos, que comandavam diferentes forças do exercito, com a exceção de Rumil e seus seguidores, que eram os estudiosos da cidade, e poucos deles seguiam o caminho militar, preferindo a sabedoria de livros antigos. E muitos dessa casa se uniram a casa de Hildor, aprendendo artes arcanas e canalização de divindades, com o auxilio de Mestres Dranorianos e Feéricos que viviam em seu meio. Muitos dessas casas se tornavam clérigos e paladinos, sendo treinados por mestres do reino de Dranor, e também seguiriam o caminho de Druidas e habilidosos feiticeiros.

E com exceção de Fëanor que era Senhor e Capitão de suas tropas, cada um dos Senhores da Lua tinha um Capitão sob seu comando, e este possuía subcapitães que o auxiliava a reger uma tropa de setecentos e cinquenta homens.

E o exercito possuía mais de três mil soldados, mas seu número crescia lentamente, pois depois de alguns anos pararam de ir mais homens de Dranor, e os lobisomens não se multiplicavam com facilidade. Mas entre os reis dranorianos existia uma lei, que caso fosse necessário, seus homens, ou outros recrutas, seriam enviados para recompor o exercito dos lobisomens.

O Exercito era dividido em três classes, os Homens, os Gaur e os Avari. Os Homens eram formados por todo aquele que não fosse um lican, mas estes se misturavam as tropas Gaur e Avari, pois seu treinamento rigoroso os deixava quase no mesmo páreo. E muitos eram usados para formar cavalarias e tropas de arqueiros.

Os Gaur eram formados por lobisomens, e estes se dividiam em classes de Patrulheiros, Guerreiros e Bárbaros. Mas seus ensinamentos eram sempre modificados para se adaptarem a suas formas bestiais. E compõem as tropas de Infantaria e assalto.

Os Avari são formados por lobisomens que negam suas transformações preferindo o uso de suas habilidades arcanas, usando sua forma bestial em casos extremos. São geralmente controladores das tropas de Minas Ithil, e todos os comandantes, com a exceção de três, são Avaris, e se dividem em Clérigos, Druidas e Feiticeiros Habilidosos.

A eles também se unem homens comuns, geralmente feéricos. Mas esses compõe a menor parte do exercito, sendo apenas pouco mais de trezentos homens e lobisomens, e todos os outros dois mil e setecentos homens são da classe dos Gaur.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='2.6 — Da Organização dos Gaurhoth');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '3.0 — O Domínio Dranoriano', '30-o-dominio-dranoriano', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## O Domínio Dranoriano

No fim da Guerra dos Cem Anos, os Homens e a Escola de Magia era a maior força Militar do Continente. Os Minotauros se retiraram para sua ilha Minos, E os exércitos das outras raças voltaram para suas terras e cidades, e estavam desgastados, e apenas um terço dos exércitos retornou para casa. Muitos não viam suas famílias há décadas, pois lutaram por anos intermináveis nas regiões do Rio Divisa, e nas fronteiras da Floresta.

Os Reinos Feéricos das Florestas também estavam enfraquecidos, pois muito batalharam quando os exércitos defensores falharam e os Sombrios quase invadiram a Floresta, pois se não fossem os exércitos de Minos, poucas esperanças restavam para o Continente. Os Anões do Sul se isolaram ainda mais em suas Cavernas e por causa do perigo que o continente correu a economia foi muito afetada. Os Magos ajudaram as raças no que podiam, mas os Homens tramavam algo maior.

Dranor enviou emissários por todas as cidades, e decretavam uma lei onde todas as cidades estariam submetidas ao poder de Dranor, porque maior parte das terras era do Reino Dranoriano, e mesmo a região norte da Floresta estava por debaixo de seu domínio. Era também a única força restante e forte o suficiente para buscar defender o Continente junto a Escola de Magia em caso de qualquer retaliação dos Magos Sombrios. Tinham um discurso que as terras deles ainda estavam em perigo, porque a força principal tinha recuado, mas as raças inimigas ainda perambulavam por ai, e as terras ainda deviam ser limpas das pragas Orcs e Goblins e outros seres Malignos que tinha se espalhado, como Trolls e Ogros.

A Escola de Magia sabia que os Dranorianos estavam certos, e também viram seu objetivo de dominar o continente, e aconselharam os feéricos, Anões e Bestiais a aceitarem os termos, pois temiam que Dranor buscasse o domínio pela da força bruta. A própria escola acabou auxiliando Dranor em recuperar e ajudar as cidades, mas ela continuou independente dos Homens, pois Dranor os respeitava e honrava.

Dranor, apesar de dominadora e exigente, era fiel em seus tratados, e sua honra era intocável, e providenciaram as raças e cidades arrasadas pela Guerra, comida e condições para se reestruturarem, e sua força militar limpou as terras e protegeu o povo. E apesar de rigoroso e às vezes opressor, o Governo absoluto de Dranor foi justo e muitas vezes lucrativo para as cidades e reinos submetidos a eles.

Os únicos que foram contra a ordem Dranoriana, era os Anões do Sul, que chamaram todas as raças de fracas, e se trancaram em suas cidades, e ameaçaram abertamente que se qualquer Homem ou Aliado viesse com intenções desagradáveis seriam mortos sem aviso prévio, e estavam prontos para o caso de Guerra contra os Homens Magotes. E essa reação dos Anões foi de grande importância para a Batalha Bestial que viria em um futuro distante.

Mas os Homens já estavam satisfeitos com o domínio que tinha conquistado, e resolveram tentar fazer acordos com os Anões. A aliança foi complicada e muitas vezes a suposta paz ficou por um fio. Mas os Homens usaram a relação que tinham com as outras raças para comercializar indiretamente com os Anões do Sul.

E Dranor Fundou Nove Grandes Cidades pelo Continente, usadas para manter vigilância e organização sobre as nove Regiões divididas por Dranor. E estes foram os Nove Reinos dos Homens, que duraram duzentos anos.

Eles recebiam impostos de todos os reinos inferiores, e o comercio devia ser centralizado sempre nas cidades representantes de Dranor, e os exércitos eram controlados e formados pelos Dranorianos. Os Homens eram sempre favorecidos, e alguns menosprezavam e maltratavam as outras raças, pois se sentiam superiores e dominadores. E na mesma medida que o governo era bom e trouxe progresso e justiça, em muitos casos foi opressor, mas esses males vinham da parte dos Homens das Regiões mais ao Sul, do que dos próprios Homens do Norte. Mas muitos líderes e grupos militares cometeram massacres e assassinatos por puro desdém e abuso de poder.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='3.0 — O Domínio Dranoriano');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '3.1 — A Ascensão do Reino Anão Leste', '31-a-ascensao-do-reino-anao-leste', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## A Ascensão do Reino Anão Leste

No extremo norte, seguindo pelos litorais lestes do continente, se ergueu Dranor, o poderoso reino dos Wikinings, os homens navegantes que desceram do norte, vindo de continentes perdidos no grande mar de sangue, após a guerra contra os demônios que definiu o fim da primeira era do mundo. Lá, antes da chegada dos Homens havia anões que reinavam sobre as montanhas no Norte.

Dranor, o rei dos Wikinings que fundou o grande reino humano, fez grande amizade com Azor, que era o Rei supremo dos Anões do Norte, e essa amizade resistiu aos anos, e mesmo depois da morte de ambos os reis, os Dranorianos e Anões viviam unidos e dependentes um do outro.

Os Anões do Norte acreditavam que esses homens eram parentes antigos, perdidos nas eras passadas, devido a sua aparência robusta e suas barbas, que apesar de serem belos e altos, muito se pareciam com os anões. E vincularam seu comercio ao dos Homens de Dranor, dependendo de seus produtos e fabricando suas armas, e essa troca rendia muita riqueza para ambos os reinos. E todo o continente voltava seu comercio para aquela região, rendendo lucro para os anões e para os homens.

Mas, com o passar das gerações de reis, algumas famílias anãs se angustiaram e se incomodavam com a dependência que eles tinham de Dranor. E com o passar da Guerra dos Cem anos, o reino ficou ainda mais agitado com os murmúrios daqueles que queriam por tudo se desvincular do Reino dos Homens.

Ora, o Rei anão desses tempos era Izenkar, e tinha cinco filhos, Thúrin, Mormegil, Thurambar, e os mais novos, Neithar e Gorthol. E os três mais velhos eram os lideres dessa revolta entre os Anões do Norte, e queriam sair daquelas terras, levar seu povo para longe da sombra dranoriana. Pois para eles aquela aliança era a Ruína dos Anões.

Porém, Izenkar era grande amigo dos reis humanos, e na primeira década do Reino Humano sobre o continente, os anões enriqueceram ainda mais as suas casas. E o Rei acreditava que ainda lucrariam mais se continuassem vinculados a Dranor, e maior parte de seu povo compartilhava esse pensamento, e não concordou com seus filhos e os mandou se aquietarem quanto a essas ideias.

Mas Thúrin não podia mais manter-se naquele reino subjugado, pois os anões são teimosos e orgulhosos, e se seu pai não lhe desse a liberdade que ele queria, ele lideraria os que o apoiassem para além daqueles reinos, e expandiria os reinos de Izenkar com glória e independência.

Pediu então a seu pai que lhe permitisse sair das regiões de Dranor, e guiar sua família e as que o seguissem para as cavernas a leste nas grandes Ered Lammoth. Prometeu que se manteria aliado ao pai, seja nas suas guerras ou nas de Dranor, mas apenas cobrou um governo e comercio livre, mesmo que tivesse de pagar os impostos que o novo reino Humano cobrava.

Izenkar, apesar de temeroso, apoiou seu filho e deu a ele liberdade para seguir como queria. E o príncipe anão e seus dois irmãos, Mormegil e Thurambar, lideraram uma grande marcha para Montanhas do Leste. E com eles vieram grandes engenheiros e trabalhadores. E os outros reinos anões enviaram auxilio, com grandes mestres de obras.

E assim, nos primeiros quinze anos do império Dranoriano, iniciou a construção das três grandes cidades anãs do Reino Leste. E era conhecido por todos sobre a grande maestria e habilidade anã em suas poderosas construção sob as montanhas, e seu trabalho era rápido e glorioso. E após sete anos, as cidades estavam prontas para serem habitadas. E depois dos novos moradores para lá se mudarem, acabamentos e outros afazeres continuaram por mais três anos.

E famílias de todos os reinos Anões se mudaram para lá, e um grande comercio se ergueu na floresta, entre seus moradores e os reinos anões Oeste e Sul. E com os anos, mais quatro cidades foram construídas nas montanhas. E por cem anos durou esse reino, e nenhum dos outros reis anões se comparavam a Thúrin e seus irmãos em poder.

E o reino era governado pelas três casas de Izenkar, mas Thúrin era o Rei supremo de todo o reino Leste.

Ora, o continente estava sob o domínio dos Dranorianos. E em troca de pequenas taxas de impostos, os Dranorianos nada fizeram quanto ao reino Anão Leste, dando a eles a liberdade que eles queriam, devido também à amizade e aliança que tinham com Izenkar. Mas entre os povos havia boatos sobre um acordo feito entre esses reinos, que se concretizou com uma grande e rica construção, que se realizou pelas mãos anãs e Dranorianas.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='3.1 — A Ascensão do Reino Anão Leste');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '3.2 — Da Construção de Gaurgrod', '32-da-construcao-de-gaurgrod', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## Da Construção de Gaurgrod

Os Anões construíram um grande Reino no Leste, e isso trouxe muita alegria não só aos anões como a todas as raças que muito se beneficiaram com esse novo comercio que se abriu na floresta. Nesse tempo, o inicio do império Dranoriano, os reis imprudentes ainda não haviam ascendido ao trono, e os tempos eram belos, e Dranor guardou as terras de muitos males.

Mas algo inquietou os habitantes da floresta, uma enorme construção que se iniciou nos Picos Sombrios, que eram três grandes montanhas que se sobressaiam no limite norte das Ered Lammoth, nas regiões altas de Menegroth.

Foi proibida a passagem para qualquer um que quisesse se aproximar das montanhas, e muitos anões e Dranorianos se movimentavam naquela região. E boatos diziam que um templo sagrado estava sendo construído, com o objetivo de guardar uma arma dos deuses.

De fato seria uma cidade sagrada, e lá guardariam um artefato de Grande Poder, mas Dranor escondia esses fatos a todo custo, e apenas aos Sacerdotes Dranorianos e Mestres Anões poderiam entrar naqueles salões. Pois ele foi construído por ordem de Minas Ithil, a cidade dos Altos Lobisomens.

Alguns anos depois do inicio do governo de Minas Ithil, a deusa visitou Kira e seus filhos se apresentando na forma de uma bela Shadar-Kai. E lhes aconselhou e falou sobre os Mãos de Prata, e como se deu o fim de seu Pai, Exar Khun.

— Minha maldição recaiu sobre aquele clã – disse a deusa –, e sobre seu pai também. Pois muito me decepcionei com sua traição, e com traição ele foi recompensado. Pois seus irmãos, unidos aos mestres do Clã, traíram Exar Khun, e atentaram contra sua vida. Ele fugiu e se perdeu na escuridão, e seguiu um caminho e uma sina terrível, pois retornou ao lugar aonde eu o treinei.

— Há anos entreguei a Exar Khun e seus guerreiros a chave para minha mais bela e terrível criação, O Caixão das Almas. Lá, Exar Khun e seus homens foram forçados pela dor a crescer em suas habilidades, e ao mesmo tempo, o Caixão lhes abasteceu de uma magia fúnebre que só ele pode conceder. Um poder que vem da vitalidade das almas que morrem ou caem na insanidade nas terras do caixão, e com essa chave eles poderiam lançar lá seus piores inimigos, e também se alimentar do poder. Eu planejava construir um exercito muito poderoso, mas agora percebi que os acidentes são a maior diversão para os deuses.

— Então vou lhes entregar essa chave, e a vocês eu dou o poder de retirar aqueles que apodrecem no Caixão, e usar seu poder para ferir os Mãos de Prata. E assim como eles, vocês saberão sobre quem entra e quem sai daquele lugar, como também lhes darei o ensinamento de como materializarem seus espíritos ali, para vigiarem os caminhos daqueles que não caem na morte ou loucura.

E dizendo isso, a deusa colocou nas mãos de Fëanor, o mais velho, um cristal transparente e entalhado, com uma caveira espectral, que se enrolava e insinuava em torno do cristal como uma serpente. E no momento que Fëanor o tocou, um poder saiu do cristal e adentrou em seus olhos e no de seus irmãos, e eles receberam toda a sabedoria que a deusa lhes deu.

Mas Fëanor, com tom de reprovação, encarou a deusa em forma mortal, e disse:

— Então é assim que vê a morte de homens de meu povo, como uma fonte de diversão para seus olhos. E com esse presente só busca aumentar o conflito entre nós e a prole de nossos irmãos, que enredados em seus planos se perderam em uma escuridão, e foram amaldiçoados por consequência dos males que você causou aos homens de meu pai e a ele mesmo.

— Não aceitamos seu presente, deusa, pois ao menos nisso vamos fugir de sua sede insaciável pela sina e pela morte. E nos negamos a usar um mundo de horror como foi este que tu criaste, e depois que despejou essa sabedoria em nossas mentes sem que fosse convidada, eu vi o quão maldito é aquele lugar. Padroeira de nossas terras você, é, e nunca negaremos sua influencia para nossa riqueza e prosperidade, e por isso continuaremos a servi-la, mas não ajudaremos a continuar esse fratricídio que por falta de escolha somos obrigados a lutar.

Mas a deusa riu das palavras de Fëanor, pois sabia que deu seu amor pelo seu povo, e sabia que no futuro seriam obrigados a usar do poder do caixão para guardar a suas terras. E disse a deusa:

— Suas palavras, jovem Rei, chegam a mim como as de uma criança que não entende o porquê de seus pais os colocarem na tutela de professores e mestres. Não sabem que para o futuro o conhecimento sobre as coisas do mundo em que vivem será crucial para sua sobrevivência. O que dei a vocês foi o ultimo poder que tinha sobre o caixão, que por motivo que desconheço se desligou de minha vontade. E agora, seu pai habita na escuridão do caixão, e guerra ele trará no futuro, por uma vingança alimentada pelas magias odiosas do caixão, que mudam a mente e a confundem.

— Com isso vocês poderão vigiar seus passos, e se preparar para uma necessidade. Pois não creio que o caixão prendera para sempre as forças que foram jogadas lá, pelos Mãos de Prata, e pelos Magos Sombrios, que eu manipulei para me auxiliarem na criação do caixão. E também, a força dos mãos de Prata em breve irão se impor contra as suas, pois muito poder eles tomam de minha criação, e isso vocês não tem, e sua única vantagem e o dom que eu lhes dei, mas essa, se não aperfeiçoada, ira sucumbir perante os homens do Clã de seus Irmãos.

— Mas uma sabedoria a mais eu dei a você e seus irmãos, algo que só tinha dado a Exar Khun. Independente desse cristal, vocês podem materializar seus espíritos no caixão, e de lá retirar forças. E seus irmãos dependem do cristal que eles têm para isso, e dele nunca podem se distanciar. Então, sugiro que escondam essa chave que lhes dei, já que estão indispostos a retirar alguém do caixão.

A deusa desapareceu depois de dizer essas palavras, e Fëanor ponderou sobre elas, e viu que se o que a deusa relevou fosse verdade, realmente era necessário o uso do poder que ela deu a eles. Mas a chave para o Caixão seria escondida, pois ninguém seria retirado de lá, pois poderosos de mais saiam às pessoas daquele mundo, e sua mente estava transtornada pelos poderes negros do caixão.

Então, se aconselharam com o Rei Dranor III, um rei bondoso e sábio dos Dranorianos, e muito fiel e amigo dos Lobisomens. Ele falou com sábias palavras, dizendo que era bom que um Templo fosse construído, e sobre a segurança dos deuses dranorianos ele fosse guarnecido.

Disse que o antigo povo do primeiro Rei Dranor, se uniu aos semideuses, e deles eles poderiam pedir auxilio, mas para isso um Templo Sagrado deveria ser construído. E lá, apenas sacerdotes e lideres como ele e os cinco, pudessem entrar, e assim, convocar a proteção de seus ancestrais para aqueles salões. Pois homens de Dranor, em sua maioria, reverenciam seus ancestrais, e acreditam que eles caminham entre os deuses, e são senhores de salões no Mar Astral.

Não se sabe se essas palavras são verdadeiras, mas não se pode negar o destino divino dos ancestrais Dranorianos, e que esses com poder auxiliam Dranor, às vezes mais que outros deuses adorados nos reinos humanos.

E assim, com auxilio dos Anões do novo reino do Leste, Minas Ithil e o Reino de Dranor III deram inicio a uma das maiores e mais belas obras do continente. Um templo tão grande e belo que suplantava os Salões de Thúrin, que em troca de seu trabalho, pediu total independência, inclusive dos impostos, de Dranor. Mas os Anões se apaixonaram tanto por aquela obra, que depois que terminaram, pediram aos homens que permitissem que eles visitassem os salões, para mais uma vez deslumbrarem a glória daquele templo.

Mas era negada a entrada a qualquer outro, que não fosse à família do próprio Rei Dranor III, e dos cinco Senhores da Lua, e aqueles que eles permitissem a entrada. E para lá foram enviados muitos sacerdotes Dranorianos, e naqueles salões os ancestrais Dranorianos foram adorados, e como foi previsto pelo Rei, eles enviaram uma poderosa força para guardar o Templo. E a chave para o Caixão foi colocada em uma torre, no pico mais alto das três montanhas, e apenas uma escada escondida no templo levava até lá, guardada pelos segredos dos anões.

E uma poderosa patrulha guardava aqueles salões. E eles continuaram cheios de sacerdotes e visitantes anões e do povo de Minas Ithil por muitos anos. Mas assim como a glória do Reino leste acabou suas portas foram lacradas pelos Dranorianos, temendo que algum mal daquele tempo alcançasse os salões sagrados.

Pois os reinos do Leste foram assolados por uma praga liberada pela imprudência de Thúrin, rei supremo daqueles anões. E grande ruína veio sobre aquele povo.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='3.2 — Da Construção de Gaurgrod');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '4.0 — Das Guerras Bestiais', '40-das-guerras-bestiais', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## O Prelúdio da Guerra Bestial

Muitas grandes histórias aconteceram dentre os duzentos anos que Dranor comandou Dagorcain, desde as guerras contra os Orcs que invadiram as montanhas, a contenda dos Elfos e Drows, a ascensão e queda do Reino Anão Leste, até As Guerras Goblins e a morte dos Senhores do Oeste. Muitos males perambularam o Continente de Dagorcain, terríveis feiticeiros que se levantaram na Guerra dos Cem Anos, Necromantes, Demônios e Bruxos, que comandavam bestas e pequenos exércitos. Mas o Reino de Dranor foi poderoso e não se abalou, mas defenderam suas terras com mãos de ferro.

Mas esses feitos não serão contados aqui. Os tempos desse poderoso reino terminaram quando os Anões do Sul cansaram da trégua forçada, e começaram a incitar os reinos próximos a eles a rebelião. Trancaram novamente suas portas impedindo todo o comercio sul que era extremamente importante para Dranor. Os Homens do Norte queriam evitar uma guerra declarada, mesmo que acreditassem que a vitória seria certa, mas os Anões são poderosos, e suas mansões quase impossíveis de serem invadidas.

Dranor ignorou as atitudes dos Anões do Sul, evitando qualquer conflito, mas isso era inevitável. Os Anões começaram e expandir seu reino, e avançaram para as montanhas Leste, desafiando Dranor, que dominava aquela área, construíram uma poderosa cidade nas montanhas e lá residiam Bestiais Feéricos e Anões, e alguns Homens que também não apoiavam o domínio dos Nortistas, que com o tempo se tornou opressor. Pois a cidade foi feita com o objetivo de unir as raças para instigá-las a rebelião, e ela ficou rica e forte, e os anões começaram a criar uma zona de livre comercio, e Dranor não recebia mais os impostos daquela região, e então houve o desafio final, quando os anões e seus aliados começaram a exibir forças militares, e seus trajes eram belíssimos, de obra de artista, pois os Feéricos e Anões do Sul eram exímios encantadores e forjadores de armas, e juntos superavam os Anões e Dranorianos no domínio da forja.

Dranor em resposta enviou uma força militar para a cidade Anã, outrora chamada de Nagrod, onde o próprio rei dos Anões Sulistas passou a morar, também em desafio aos Senhores Dranorianos. O objetivo era apenas cobrar os impostos e tentar recuperar a ordem, mas sem combates, e os soldados eram um alerta e demonstração de força. Mas o Rei os expulsou e os cidadãos desdenharam dos Homens. E disse o Rei ao Comandante da Força Dranoriana:

— Dranor é muito ousada em invadir meus salões com forças armadas, e eu devia tomar isso como atitude de Guerra, mas sou piedoso e não enviarei suas cabeças aos portões de Dranor em consideração a velhos acordos. Mas diga a seu Senhor, Rei do Forte Dranoriano da Floresta, que essa região e muitas outras estão livres das opressões dos Homens do Norte, e seremos implacáveis com qualquer outra demonstração de força ou ameaça. Não pagaremos imposto algum, e nem nos arrependemos de nossas atitudes. Vão agora, cães dos Homens, me envergonho dos meus parentes que vivem debaixo de suas sarnas.

Porém, o Rei Anão se meteu com o mais imprudente tirano dos Nove Senhores, e em uma assembléia ele buscou convencer os outros oito a aniquilar a Escória Anã do Sul, e todos os que o seguiam, pois estes poderiam trazer muitos problemas. E ele estava correto, apesar de seus defeitos, Bolg, O Rei Dranoriano do Norte da Floresta, era sábio e astuto.

Os outros Reis, com poucas exceções foram contra Bolg, e eles queriam evitar conflitos, enquanto Bolg acreditava que a queda dos Anões Sulistas serviria de exemplo para evitar qualquer atitude rebelde. Mas a reunião terminou com a decisão de que seria evitada a guerra, e mais uma vez apelariam para acordos, até encontrarem uma boa solução contra a rebeldia Anã.

Mas Bolg era sedento por guerras, e se sentiu humilhado pelas palavras do Anão, e não podia deixar aquele desafio como um rato medroso, ele era um Homem de Dranor, e aquela afronta deveria ser respondida com violência. Então, certo de que suas atitudes no futuro seriam louvadas, mandou que preparassem uma forte tropa e mandou chamar alguns anões do Norte, engenheiros de preferência. E mandou que atacassem a cidade pela madrugada, um pouco antes de fecharem as portas. E deu ordens de que todos ali fossem mortos, independente da raça.

E foi assim, durante a noite, quando os últimos comerciantes deixavam a cidade, e o Rei Anão terminava seus afazeres na Sala do Trono, as forças de Dranor invadiram as mansões. E sem piedade mataram homens, mulheres e crianças, anões, homens, feéricos ou bestiais. Muitos tentaram fugir da fúria dos Dranorianos, mas eles foram implacáveis, e depois de matar os moradores lançavam fogo sobre suas casas e barracas, os corpos também eram lançados no fogo, e não existia misericórdia.

As defesas foram surpreendidas, mas teve tempo de se reunir no centro da cidade, e assim as tropas dos homens do Norte se lançaram contra a linha de defesa dos Anões, e muito sangue foi derramado naquele momento, e não havia força que impedisse os Homens do Norte de avançar.

O Rei dos Anões estava ao lado dos soldados, e com bravura lutou e muitos homens caíram sob o Marchado do Rei, e para cada homem que ele derrotava, rugia seu nome como um urso. E o grito era tão forte que muitos homens se sentiram aterrorizados, e o Rei avançou sozinho entre os inimigos, e isolado de seus soldados, mais de cem vezes sua ira foi escutada, e só os mais bravos se mantinham firmes em sua presença, e mesmo esses temeram o urro do Rei.

Mas a Ira do Rei não foi suficiente e seus gritos se findaram. Ele caiu lutando contra o Comandante das forças de Dranor, que era o de maior Renome naqueles tempos. Mas ele também era conhecido por ser impiedoso, e depois de assassinar o Rei, ergueu sua cabeça a vista de todos, e a moral dos defensores caiu, e os últimos foram encurralados, mortos sem piedade. Poucos escaparam da crueldade de Dranor, e os homens pilharam a cidade, e todos os corpos foram queimados em uma enorme fogueira.

E as noticias do massacre se espalharam e a morte do Rei Anão foi tão terrível para seu povo que antes de praguejar choraram por dias, e com fúria, os Anões do Sul iniciaram a rebelião contra Dranor, com ou sem ajuda, para eles não importava, lutariam até a morte. E seus irmãos do Oeste ouviram seu chamado, e os novos Povos Anões do Leste também choraram a morte do Rei e se uniram a Rebelião.

E as outras Raças a muito se indignaram com as injustiças de alguns Reis dos Homens, se uniram a causa, e assim começaram os conflitos que em breve se tornariam a Grande Guerra Bestial, e aqui foram mostrados os principais eventos que levaram a esta Guerra Civil.

## O Conclave

Os Feéricos eram Raças Mágicas, e estes eram os Elfos e Meio-Elfos, Eladrins e Drows, entre outros seres mágicos como Gnomos. E depois dos Homens e Orcs, era uma das maiores raças do Continente. Eram caçadores habilidosos, sábios, grandes forjadores e artesãos, e suas cidades costumavam ser grandes e gloriosas. E suas forças militares também eram extremamente perigosas, mas nunca formaram um estado militar como os Homens de Dranor.

Eles eram belos e muito bem organizados, grandes governantes e sábios nos costumes, e deles vinham os mais poderosos Magos da Escola de Magia, que só não se igualavam aos Devas acolhidos pela escola. E sua amizade com a escola foi o único motivo de terem se submetido ao domínio Dranoriano sem luta, pois a escola não podia permitir mais derramamento de sangue, logo depois da invasão dos Magos Sombrios, que poderiam aproveitar isso. E os Homens certamente poderiam defender o continente de qualquer ameaça iminente dos Magos naquele período, mas seu domínio foi mais longo e forte do que a escola previra.

Mas a os Magos não mais podiam interferir nas Raças diretamente, mesmo porque os Homens do Norte também auxiliavam a Escola de Magia, porém eles não eram cegos para não ver a opressão que alguns reis dos Dranorianos submetiam as outras raças, e não poderiam controlar os Feéricos por muito tempo, e nem queriam. E com a Morte do Rei Anão viram uma oportunidade para aconselhar, mas não auxiliar.

Convocaram os principais lideres das cidades Feéricas e os aconselharam a Reunir todas as Raças sob a opressão Humana, agora que os conflitos entre alguns povos e os Anões contra os Homens tinham começado. E com essa união criassem um novo Governo sobre as raças bestiais, e escolhessem uma forte cidade ao Sul, aonde poderiam se agrupar e se defender mais facilmente das forças do Norte, e lá reunir as maiores forças, e assim, impor sobre os homens a liberdade das raças.

Mas os Magos sabiam que batalhas seriam inevitáveis, então aconselharam aos lideres Feéricos que se preparassem muito para um conflito contra as forças Humanas, com armas encantadas e recursos mágicos que era a deficiência nas forças do Norte. Mas que antes do fim procurassem um meio diplomático, seja na vitória ou derrota, evitando maiores massacres.

E os lideres Feéricos seguiram perfeitamente os conselhos e escolheu a poderosa cidade élfica a beira Mar de Brithon, que era rica e fortificada e lá, por ser o extremo Sul do Continente, tinha pouca resistência Dranoriana. Expulsaram as poucas forças dos Homens, e reuniram os grandes lideres das raças do sul. E as cidades dos Lideres Feéricos ali presentes foram evacuadas e migraram para o Sul, pois estas cidades eram o cinturão élfico que se estendia até o norte perto das terras de Dranor, sob o olhar dos Homens.

Muitas Raças estavam ali, e essas eram os Anões, com lideres representando os reinos Sul, Oeste, e as cidades restantes do reino caído do Leste, Os lideres Feéricos, representando as quatro famílias, e também vieram os Bestiais, representados pelos Meio Orcs, Minotauros, Ferais e clãs Draconatos. Também havia alguns homens ali, vindos dos desertos, das cidades de Harad e Khajit, e o povo de Xablau do Império Xablablau. Também estavam ali os homens que viviam entre os feéricos e apoiavam a causa. Clãs de Paladinos como o dos Draconatos também estavam lá, mas muitos não vieram por seu vinculo com a Escola de Magia.

E nessa assembléia foi decidido que todas as raças ali presentes entrariam em Guerra contra Dranor, e libertariam as cidades que ainda não tiveram condições de se rebelar. Mas também seguiram o conselho dos Magos, de buscar meios diplomáticos e pacíficos antes de qualquer sinal de extermínio.

Todas as outras raças ali guardavam rancores dos Homens de Dranor, pois todas tinham sofrido pela mão de ferro dranoriana. Os Meio Orcs tinham poucas cidades, mas um grande exército, e muitos de sua raça e seus parentes eram tratados como escravos por alguns dos Nove Reinos.

Os Ferais sofriam zombarias e maus tratos, viviam em clãs ou misturados nas cidades dos outros povos, e os que viviam entre os Homens eram muito humilhados e oprimidos. Existiam clãs escondidos na floresta, e esses não compareceram, eram como os Gigantes e Golias, indiferentes as questões de Dagorcain.

Os Minotauros também viviam isolados, mas receberam uma mensagem da Escola de Magia, pedindo auxilio, e como já foi dito, os Magos no passado ajudaram os Minotauros, e isso o povo de Minos jamais esqueceria.

Mas os Feéricos e os Anões eram os mais rancorosos e que mais desejavam essa liberdade, e então com todos os lideres ali, fundaram o Conclave, a união de todas as Raças Livres. E a cidade de Brithon foi chamada de Dranar, em desafio ao nome Dranor. E a guerra foi declarada abertamente, e o discurso era que a guerra seguiria até que os Homens do Norte abrissem mão de seu reino absoluto sobre o continente, e as raças fossem livres de seu poder opressor.

## As Guerras Bestiais

O Conclave reuniu um exército extremamente numeroso, algo que não se via desde a Guerra dos Cem Anos. Dranor reuniu toda sua força nas passagens das montanhas Lammoth, que vinham do Oeste, nos reinos de Dirnem e adentravam a floresta fazendo uma curva para o norte. E agrupou uma grande força composta pelos Homens de Dranor e exércitos de outras raças dominadas por eles, nas terras neutras comandadas pela Escola de Magia, a beira das montanhas, nas terras entre Elória e as montanhas de Dirnem. Sabiam que ali viria o maior ataque, pois eram estrategistas militares natos, e seus conhecimentos sobre guerra eram inigualáveis.

Não eram permitidos confrontos nas zonas neutras, mas a Escola de Magia queria manter a guerra mais afastada possível das montanhas Gorgoroth, e temiam confrontos na floresta, com medo da destruição enfurecer os entes e gigantes e a própria floresta receber sérios danos com isso. E nada disseram sobre o avanço e acampamento de Dranor naquela região.

Dirnem IV, o poderoso rei Anão do Oeste derrubou as defesas de Dranor em suas passagens, e defendeu suas terras da retaliação dos Homens, fazendo com que aquela área estivesse livre para quando os poderosos Exércitos do Conclave chegassem, mas sua força muito se enfraqueceu nessas primeiras batalhas, e não pode mais envolver seu povo na Guerra, pois precisava de defesas na cidade. Os Dranorianos os chamavam de Exercito Bestial, e com esse nome essa guerra foi conhecida.

Muitos confrontos ainda ocorreram na floresta, pois os Homens de Harad e Khajit, as cidades do deserto, libertaram o restante dos povos florestais do Sul do domínio de Dranor. Eram extremamente numerosos, sete mil homens, e suas habilidades no arco e na espada eram admiráveis, e eram liderados pela maior parte da força Feérica e junto com eles estava uma grande força Anã, e libertando essas cidades reuniram mais forças para guerrear e libertar as regiões Norte da Floresta.

E com a passagem de Dirnem livre e vigiada, as tropas principais de Dranar passaram e não sofreram emboscadas, pois o povo de Dirnem vigiava as montanhas, e as conheciam melhor que qualquer um. E assim, a Tropa Bestial se agrupou no centro do Continente, a trezentos quilômetros das tropas de Dranor.

Um exército de catorze mil soldados foi reunido ali, formados por Anões, Homens, Draconatos e meio Orcs e parte das forças Feéricas que lideravam junto com os Paladinos. E se dividiram em três frentes, a mais poderosa foi mais próxima ao mar, pelas regiões do Extremo Oeste, em direção as tropas de Dranor, com oito mil soldados; Dois mil seguiram nas bordas da floresta como objetivo de libertar algumas cidades nas fronteiras da Floresta, e os dois mil restantes seguiram na retaguarda da principal, e após um tempo de caminhada, seguiram a leste e depois de alguns quilômetros fizeram uma curva a oeste com o objetivo de flanquear as Tropas de Dranor.

Todos esses movimentos foram previstos por Dranor, mas não a quantidade de soldados, e muitos ainda viriam da floresta e das cidades que eram libertadas no caminho. E os Homens do Deserto reuniram mais três mil soldados das cidades libertas na floresta, que mais tarde foram enviados para auxilio na principal área de confronto fora da Floresta. E outros dois mil foram reunidos no extremo leste da floresta. Que seguiram para o Norte e lá, após libertarem as ultimas cidades, seguiriam para o Sul e depois Oeste, para auxiliar a força principal.

Dranor defendeu bem todos os ataques, porém a quantidade de inimigos era gigantesca, e em muitos casos abandonaram a defesa e recuaram. Os Dranorianos tinham uma força total de dezoito mil Homens, e cinco mil anões do Norte, mas estes foram deixados para defender Dranor, junto com mais cinco mil Homens. E apenas doze mil foram enviados para a zona de ataque principal. E os outros mil para guiar suas tropas mescladas, que era como eles chamavam sua força formada por outras raças de cidades dominadas, que eram no total menos de cinco mil.

Mas apesar da desvantagem em números, os Homens do Norte eram guerreiros extremamente poderosos, mesmo os feéricos que eram rápidos e habilidosos, não tinham a força e treinamento comparável aos Dranorianos. E eram exímios estrategistas, e seus homens equivaliam a quatro do inimigo. Dessa forma a desvantagem era apenas aparente, mas os Homens do Norte ainda seriam dificilmente vencidos.

E essa Guerra durou mais de vinte anos, e os Minotauros entraram tarde na batalha, pois eles seriam usados como uma "carta na manga" de Dranar, para uma defesa ou ataque desesperado. E assim aconteceu, pois os Homens enviaram reforços para a floresta, e conseguiram fazer as tropas inimigas recuarem, e os Homens do Deserto foram expulsos de lá antes de alcançar as ultimas cidades no Extremo Norte da Floresta, e um massacre aconteceria ali, e em pouco tempo alcançaria os Campos de Dranar, sem misericórdia. Mas a força dos Minotauros foi uma surpresa para aqueles homens, que eram comandados por Bolg, o Rei do Forte da Floresta.

E os Minotauros travaram o avanço das tropas de Dranor, mas com dificuldades, pois os Dranorianos eram quase páreos para os Minotauros Gingantes invocados pelos generais de Minos. E ao mesmo tempo, as forças a oeste do continente, fora das florestas, Guerreavam nas terras frias que eram próximas as Fronteiras de Dranor. A disputa ali fora a mais sangrenta e violenta de todas, e muitos caíram. Dranor apesar de mais forte não tinha a mesma facilidade de restaurar seus Homens como Dranar tinha. E decidiram recuar e se agruparem próximos a sua terra, e mais uma terrível batalha foi travada ali, e por um momento Dranor teria vencido se as Tropas Bestiais não tivessem recebido o reforço que veio da Floresta.

E quando viram que não tinham escolha, os Homens convocaram os Anões do Norte em seu auxilio, e com eles fizeram uma poderosa linha de defesa na fronteira dos Rios Gelados. Mas a maior força que estava nos exércitos Bestiais era de Anões, e quando as tropas estavam frente a frente, os Anões do Norte se negaram a lutar contra sua própria raça. Eles abandonaram o campo de Batalha, envergonhados, mas os Homens não tomaram aquilo como ato de Traição, pois a muito tempo um acordo sobre essa questão foi tratado entre eles.

Mas os Homens não recuaram, e os exércitos Bestiais vendo a retirada dos Anões, gritaram e se alegraram, e em um coro que podia ser escutado a quilômetros, eles diziam em várias línguas "é o fim", e foi nesse momento que os lideres feéricos enviaram mensagens aos últimos reis dos Homens, seguindo o conselho dos Magos impedindo mais uma chacina e tratando os últimos momentos da Guerra em um acordo de liberdade e pactos de não agressão.

Quatro dos nove reis Humanos pereceram em batalha, ou foram mortos quando suas cidades foram invadidas. O Rei Bolg, responsável pelo massacre de Nagrod e o Assassinato do Rei dos Anões do Sul, morreu defendendo sua cidade, e caiu aos pés da família do Rei Anão, e seu corpo foi lançado no rio para que se perdesse, e a força humana da floresta recuou buscando refúgio em suas terras no Norte, e assim a floresta foi totalmente liberta de Dranor.

E os Lideres de ambos os lados recuaram suas tropas, e uma assembléia entre o Conclave e os últimos cinco Reis de Dranor e seus arautos. Lá os homens tentaram recuperar suas terras na floresta, dizendo que elas lhes pertenciam desde os tempos anteriores a Guerra dos Cem Anos, mas o Conclave negou, pois muitos reinos Feéricos estavam a mais de oitocentos anos nas regiões frias da Floresta. Mas Dranar não se impôs contra Dranor manter-se dona de todas as regiões frias que a muito foram dominadas pelos Homens no Norte. E a eles foi entregue a passagem do Extremo Norte, uma região entre a fronteira Norte da Floresta e os Paredões de Gelo, assim como as regiões dos Vales do Monte Dork.

As outras Raças retornariam as suas terras, e a Escola de Magia abriu as portas da Zona Neutra para ocupação de áreas vazias. E Dranar continuou representando o Conclave, mas não dominava ou comandava as outras cidades ao redor ou qualquer raça, ela simbolizada liberdade, era uma grande e bela cidade com comercio poderoso, comandada por Eladrins e de maior população feérica, e aberta para todos, até mesmo Homens. E as Regiões Sul ficaram Ricas belas.

E assim terminaram os duzentos anos de domínio Dranoriano. E milhares foram mortos na Guerra Bestial, mas os civis foram poupados, tendo poucos incidentes em que a população foi atacada. E os Reinos se tornaram livres, pois Dranar rendeu as raças de sua obrigação, mas o Conclave se manteve. E houve paz, e a prosperidade retornou as terras de Dagorcain.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='4.0 — Das Guerras Bestiais');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '4.1 — O Maior Inimigo', '41-o-maior-inimigo', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Preservado na íntegra.

## O Maior Inimigo

Há incontáveis anos as Lideranças das Cortes tinham se fixado, pois no Caixão, mesmo os mais poderosos não tinham uma contagem certa de tempo, e após muito fazerem cálculos próximos ao que seriam dias no Caixão, perdiam as contas e voltavam do zero, chamavam isso de Anos do Caixão, pois esse momento era guardado entre os lideres mais sábios. Porém, as contas eram perdidas em momentos diferentes, então muitas cortes tinha uma idade diferente, de acordo com sua noção de tempo.

Mas os cálculos eram sempre muito próximos, e a maioria, depois do Acordo de Morgoth, entrava em consenso que a contagem de tempo do Caixão era pra mais de mil anos, e não tinham idéia de quanto tempo havia se passado fora do Caixão. A exatidão da conta vinha da Corte Dôminus, pois longe da vista das outras Cortes, Dôminus o Astuto, contatava os Magos Sombrios, e tinha mais certeza da contagem dos Anos do que quaisquer dos outros Lordes Negros. E já fazia duzentos anos desde que entrou no Caixão, quando soube da nova Guerra que se abriu no Continente, e as Bestas tinha conseguido sua liberdade dos Homens, e em breve os Magos iniciariam uma nova tentativa de dominar o Continente Dagorcain.

Ele foi avisado que seria necessária a sua força na Guerra, e que ele já estava lá a tempo demais. O ordenaram que buscasse um meio de sair do Caixão, pois depois de mais de duzentos anos de estudos ainda não tinham encontrado a resposta de como abrir o Caixão para que alguém saísse, mas aprenderam como usar o poder do Caixão através das portas que eles podiam abrir, e banhar seus magos e guerreiros com aquela magia rara e dolorosa. Não era o mesmo poder que recebiam os que entravam no Caixão, mas era o bastante para aumentar a força e resistência de seus soldados e as habilidades de seus magos em dominar os poderes do Pendor das Sombras.

Dôminus tinha um limite de mais de cinqüenta anos, na contagem do caixão, para descobrir como sair e auxiliar seus Senhores Magos na Guerra. Mesmo os Lordes Negros não tinham descoberto como sair daquele lugar, mesmo os maiores manipuladores das Forças do Caixão. E ele buscou todos os meios para sair, mas não chegaria nem tão perto de encontrar uma resposta dentro desses cinqüenta anos.

Ora, Morgoth após um longo período de conquistas no Caixão colocou a Corte Ogai entre as mais poderosas, pois seus seguidores eram resistentes como os servos da Corte Dranos, e quase tão numerosos quanto a Corte Dôminus. As palavras de Morgoth eram dominadoras e convincentes, de grande peso e sabedoria, e o controle das mentes era sua maior característica. E muitos acordos ele fez com outras Cortes, e outras conquistou sem a necessidade de batalhas. E com facilidade aprendeu os ofícios da manipulação da essência das almas no Caixão, pois como mestre teve o Gigante da Morte, Uruk-Ogai. E não só as aprendeu como as aperfeiçoou, e com suas artes fortaleceu seus homens e servos, multiplicou suas feras e expandiu a Escuridão criada por Ogai para esconder suas terras.

Mas as cortes nunca mais entraram em combate aberto, e além de Ogai, Ungoliant cresceu em poder e servos, e tornou-se uma das Cortes Dominantes do Caixão por de baixo das asas de Dranos e Morgoth, que a tinham como protegida. Morgoth, porém, conquistou Ungoliant como amante e aliada, sua lealdade e servidão, e apesar de Ungoliant por amizade manter-se próxima a Dranos, respeitava mais as ordens de Morgoth.

E o motivo do crescimento de Morgoth era seu objetivo de guerrear fora do caixão, e se vingar do Clã que o traiu e de Rainha Rapina. E Morgoth já não acreditava que podia sair do Caixão, mas alguém podia tirá-lo de lá. E dessa forma, ele encontraria um meio de trazer suas tropas do caixão para o continente. Ele sabia que o Dragão tinha descoberto um meio de influenciar o mundo material mesmo com a barreira dimensional. O Dragão não confiava em Morgoth, e apesar de ser um dos mais fiéis aos acordos entre as cortes liderados por Morgoth, não lhe abria as portas de suas terras.

Sabendo das dúvidas de Dranos, Morgoth viu que não descobriria seus segredos com trapaças ou planos. Mas sabia que ele honraria uma boa disputa e um acordo, pois Dragões, mesmo os mais poderosos, são bons com a fala e gostam de disputas de poder ou conhecimento, de políticas e diplomacias, negócios então, são como amantes da inteligência dos Dragões. Então buscou negociar com o Dragão, expondo seus objetivos reais, e a necessidade de uma aliança entre as duas Cortes.

Dranos se admirou com sua sinceridade e antes que Morgoth terminasse seu discurso, o Dragão falou:

— Grande poder você deseja, Morgoth, e seus objetivos são gigantescos e em muitos pontos mal planejados. Sua Corte é Grande e poderosa, o bastante para se comparar a minha, pois tu dominaste a manipulação para fortalecimento de suas tropas, e astutas palavras você tem, e muitos servos têm acumulado, quase que com a mesma habilidade do verme Dôminus, a quem tenho asco. Mas passei a ter certa admiração por sua pessoa, apesar de manter minhas desconfianças.

— Por não temer qualquer ameaça, seja tua ou de qualquer outra Corte, pois apesar de se compararem a minha, nenhum de vocês Lordes se compara a meu Poder, farei a ti uma proposta. Resista a meu mais terrível calabouço por um ano do Caixão, saia, e enfrente um golpe meu, e então poderemos negociar. Porém, se antes que bata à hora tu buscar escapar da dor ou loucura, ou cair subjugado a elas, tua corte será minha, Ogai e Qel-droma serão mortos para que não me causarem problemas, e você, se sobreviver, será um de meus soldados ou apenas um servo, isso depende de minha vontade.

Mesmo Morgoth sentiu um frio em sua espinha com as palavras do Dragão, pois delas saiam uma essência semelhante às vinhas do Caixão. Mas ele não podia vacilar, e aceitou o desafio. Então foi levado ao pior Calabouço de Dranos, ou mesmo o mais terrível que existia no Caixão. Lá havia sombras que submetiam os réus a loucura e dor, e a opressão do Caixão ali era quase impossível de suportar. O próprio Dragão em muitos momentos descia lá e cuidava da tortura de Morgoth, com palavras que buscavam envenenar a mente, trazer medo, e dobrar qualquer um a insanidade, pois elas corroíam o sangue, tornavam os músculos como puros veículos de dor, e muitas charadas eram impostos a ele, pois assim o Dragão testava sua resistência, confiança e poder.

Por um momento Morgoth quase sucumbiu à loucura, e por inúmeros instantes desejou a morte, ou fugir daquele lugar. Mas não se permitiu, pois seus planos não poderiam acabar ali. Já tinha desistido de viver ou qualquer coisa parecida, sua mente fora consumida, e se mantinha consciente falando repetidamente seu verdadeiro nome, buscava não esquecer quem ele era. Buscava a imagem de sua ex-mulher, que ele amou acima de tudo, e lhe tinha sido tirada pela maldita deusa.

Quando finalmente completou um ano de cárcere, ele despertou nos salões de Dranos. Quase sem forças, e com semblante destruído, ouviu as palavras do Dragão, e se lembrou do ultimo desafio, e preparou suas forças dentro de si, e planejou um desfecho para aquela situação:

— Tu me deixas ainda mais admirado, pois aquele lugar é a forma física do significado do Caixão; morte, loucura e dor. Resistindo a elas, mostrou-me que em algo você parece comigo, o que nos faz resistir a este lugar melhor do que outros. Nossos objetivos são poderosos, e testando sua mente com minhas charadas, provei como sua mente é poderosa e controladora. Eu vi muito de mim em você, nossas mentes são divinas, ou caóticas, você decidi. Mas ainda há um teste.

E olhando nos olhos de Morgoth, soltou um terrível feitiço sobre ele. Morgoth sentiu como se todas as dores das almas do Caixão estivessem em seu coração, e quando o Dragão levantou sua mão para atacá-lo, Morgoth desviou do golpe, desaparecendo na frente do Dragão, e com um passo feérico subiu a altura incomparável do rosto do Dragão, e desferiu um golpe com todo o poder que ele veio guardando desde que foi aprisionado, e uma marca foi registrada para sempre no rosto do Dragão, que se defendendo esbofeteou Morgoth no ar, e o lançou cinqüenta metros até se chocar contra o portão, que o fez quebrar muitos ossos, e desmaiar enquanto via a pata do dragão vindo sobre ele, como um golpe de misericórdia.

Contrario a todas suas expectativas, ele despertou em uma das Casas de Cura dos servos do Dragão, e logo quando pode andar foi chamado a presença do Soberano. E chegando aos salões do Dragão, foi recebido por risadas e tons de chacota:

— Então se preparou para desferir um ultimo golpe – disse o Dragão – e durante todo aquele ano aproveitou momentos para tentar vasculhar minha mente e encontrar um jeito de resistir aquele feitiço, que também descobriu ao tentar ler em mim que golpe eu investiria contra ti. Não tenha medo, mas não podia deixar que você me marcasse sem receber uma marca minha, pois o braço que me acertou, atingi de modo que você nunca mais o use para manejar uma espada sem sentir grande dor. E a marca de minha garra não o abandonará, tal como tua marca em meu rosto também não me abandonará.

— Esse é o nosso acordo, essas marcas o simbolizam, pois tu és digno de honra, comparável a mim em certos aspectos, mas não em Poder. E agora, podemos negociar. Preparei uma grande reunião, entre meus Arautos e os seus, e não se preocupe, pois dei data em tempo que você tenha se curado desse semblante humilhado. E sua Corte foi bem cuidada por seu braço direito, Ulic Qel-droma, que estará conosco quando discutirmos o acordo.

No principio quis o Dragão matar aquele insolente que se atreveu a tocá-lo, mas isso soou tão alto em sua mente, pois finalmente alguém o feriu, de tal modo que ele fora marcado, e antes que arrancasse a cabeça de Morgoth, ou o esmagasse com sua pata, maior que seu orgulho foi sua necessidade de honrar o acordo, pois Morgoth fizera sua parte, e não fora definido algo que o proibisse de feri-lo no processo.

Com ódio suportou a vontade de matá-lo, e num momento de espairecimento, lembrou-se dos feitos de Morgoth com orgulho, como se fosse mais uma de suas crias, pois ele foi submetido ao mesmo treinamento inicial de seus filhos, e um Homem, ou coisa parecida, resistir a uma tortura preparada para Dragões é um feito memorável.

O Dragão então analisou toda a situação, e lembrou-se que no inicio viu em Morgoth, ou Exar Khun, como descobrira, um potencial incrível e o submeteu ao teste para ver aonde ele chegaria, e ele novamente se surpreendeu com o fato de Morgoth ter resistido à tortura e ao golpe.

Foi quando mandou que o levassem para as casas de cura, e quando ele acordasse e estivesse parcialmente curado, com capacidade de andar, o que levou quatro meses do caixão, desse a ele os devidos avisos. E passando-se mais dois meses, que curaram totalmente os ferimentos de Morgoth, a reunião marcada teve seu inicio. E Morgoth fora apresentado como Dozarkin, que na língua dos Dragões era símbolo de honra e amizade.

E as discussões começaram, e a Corte Dranos propôs aliança e livre comercio entre as terras, e para benefício próprio, cobrou o auxilio dos servos da Corte Ogai nos trabalhos dos Dragões. Em acordo com as exigências de Dranos, Morgoth pediu que o Lorde dos Dragões compartilhasse sabedoria, enfatizando a manipulação do mundo exterior, e na criação de armas. E essa aliança era o marco de uma batalha que nunca deveria ter chegado ao continente. Pois aprendendo a manipular o mundo exterior, aprimorou a arte, e preparou finalmente sua saída para os campos de Dagorcain, o Continente da Guerra de Sangue.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='4.1 — O Maior Inimigo');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Cidade Fomoriana — Kal Gaadriz', 'cidade-fomoriana-kal-gaadriz', $MDS$> 📜 LORE DE MESTRE — material originalmente marcado "(não leia)" (segredo, não revelar aos jogadores). Autoria do grupo. Preservado na íntegra.

Construída nas ruínas da antiga grande mina de Thúrin na Montanha Thangor, a gigantesca e degenerada cidade de Kal Gaadriz serpenteia pelos túneis e cavernas deixadas pelos anões.

No continente existem apenas três clãs Fomorianos, uma raça realmente rara e oculta em Dagorcain. Ragnarus, Dark Wich de Morcul, conseguiu uma aliança com o Clã Gaadh secretamente no inicio da Guerra Bestial, dando ordens ao Lich Tar-Azel para subjugar os lideres Hobgoblins das Montanhas Lamentosas, para auxiliar na secreta infiltração do povo Gaadh na montanha Thangor.

Tanto Tar-Azel quanto os Gaadheris buscariam, respectivamente no Templo dranoriano Gaurgrod e na montanha Thangor, qualquer tipo de informação das perdidas chaves do Túmulo das Almas e formariam bases avançadas no continente.

O Lich de Gelo descobriu que o templo dranoriano era na verdade o latibulo que tanto procuravam e iniciou escavações no local, enquanto usava seus goblins para policiar as montanhas impedindo bisbilhoteiros que arriscariam a si e os Fomorianos.

Por outro lado, os Gaadheris tiveram pouca sorte em seu encargo. Descobriram que se de fato Thúrin encontrou a Principal das Cinco chaves do Túmulo das Almas, não deixou que ela fosse soterrada com ele na desolação da montanha, mas provavelmente a escondeu em outro lugar. Mas continuaram com a missão de firmar um secreto e poderoso posto avançado para Morcul, e então ergueram Kal Gaadriz.

Porém, com a queda de Tar-Azel e seus cinco líderes Hobgoblins, a cidade teve de se esconder ainda mais, aguardando o sinal de seu Mestre Ragnarus, já que não contavam com o apoio do Lich e seus Goblins para proteger e esconder a cidade.

Os Fomorianos são um povo de formidável capacidade arcana, criaturas perigosas com poder de subjugar outras criaturas a sua autoridade. Em grandes números podem formar exércitos temíveis.$MDS$, array['Lore Original']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Cidade Fomoriana — Kal Gaadriz');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Complemento de Exar Khun', 'complemento-de-exar-khun', $MDS$> 📜 LORE ORIGINAL (texto-fonte, autoria do grupo). Complemento aos textos 2.x. Preservado na íntegra.

## Complemento de Exar Khun

Mas Exar Khun nesse tempo já odiava a deusa de tal forma que ao descobrir a intromissão da deusa em sua família se indignou e foi contra os filhos, pois para ele aqui era uma maldição, e sua mulher fugiu com eles. Exar Khun guardou os outros cinco, tendo eles como os seus únicos filhos, e com eles fundou o Clã Mãos de Prata como ele é hoje, e os fez jurar que matariam seus irmãos e qualquer um que se assemelhasse a eles, ou coisa que viesse deles, pois esses já não eram os mesmo, estavam amaldiçoados, eram apenas bestas que se sentiam mais inteligentes que outras.

Ao mesmo tempo, os cinco abençoados e sua mãe fugiram para uma cidade, e lá, por seus informantes, Kira descobriu que seu ex-marido fora traído pelo clã, e tentaram assassiná-lo, e ele desapareceu. E a essa altura, ela e os outros cinco filhos já tinham formado o Clã Lycan, dos poderosos Lobisomens, nos reinos de Dranor, nos paredões de gelo.

Ora, Exar Khun fora traído por seus próprios filhos, quando o mais velho tinha alcançado a maior idade, e este havia sido manipulado pelos vinte e um guerreiros que saíram do Caixão com ele, que também faziam parte da liderança do Clã, e eram comandados pela Rainha Rapina, que cuidou de amaldiçoar Exar Khun, por sua traição. Mas os Filhos, que continuaram liderando o Clã, mantiveram a promessa de caçar e destruir tudo semelhante a seus irmãos. E desse modo a inimizade e ódio entre eles cresceu durante os séculos que se seguiram durante o reinado dos Homens e as Guerras Bestiais.

E Exar Khun, que todos pensaram ter sido morto voltou às terras de Morcul com seu seguidor, Ulic Qel-Droma, e buscou pela entrada do Caixão, e lá impôs um auto-exílico e jurou que voltaria para se vingar e destruir ambos os Clãs, e qualquer criação ou coisa guiada pela vontade dos deuses. E seu nome foi esquecido no Continente, e só seus próprios filhos que ainda restam se lembram dele.

Essa história ocorreu entre s quarenta últimos anos da Guerra dos Cem Anos, contra os magos de Morcul, e os primeiros 20 anos do Reinado dos Homens, a mais de 200 anos, em tempos por alguns já esquecidos. Muito dos conhecimentos das origens das Mãos de Prata foi apagado por eles mesmos, que também trataram de ocultar sua ligação e origem do Clã Lycan.

Hoje, os Clãs Amaldiçoados possuem mais de duzentos anos, sendo as Mãos de Prata os mais velhos, pois eles existem desde os tempos da Mãe, que era Kira, esposa de Exar Khun, que reuniu um clã de Patrulheiros poderosos, guiada pela deusa, que serviram como predecessores do Clã criado por Exar Khun. Mas essas histórias já não existem entre o povo, e não restam mais do que lendas místicas e aterrorizantes dessa época.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Complemento de Exar Khun');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Explicação — O Templo Solar das Terras Livres', 'explicacao-o-templo-solar-das-terras-livres', $MDS$> 📜 LORE / LOCAL (autoria do grupo). Arquivo "Explicação". Preservado na íntegra.

Uma antiga ordem de seguidores de Pelor (que aparentemente acabou durante a guerra dos 100 anos), possuía um grande monastério, o já esquecido "Templo Solar das Terras Livres". Em sua época, eles eram os maiores representantes de Pelor, o Templo Solar era um lugar de harmonia e prosperidade, mas também a maior força contra os seres da escuridão amaldiçoados pelo Sol.

Em sua época, seres obscuros e profanos eram uma ameaça mais presente do que nos dias atuais, seres como Vampiros, que é bastante improvável se ouvir qualquer relato na atualidade. Eles não só tinham a força e o poder para derrubar tais bestas, eles também possuíam o conhecimento necessário.

Durante a guerra dos 100 anos, as forças de Morcul marcharam sobre o lugar, destruindo a ordem e tomando a localização. Mesmo após o fim da guerra, ninguém se aventurou para retomar e reerguer o forte, todos temiam um novo retorno de Morcul.

Atualmente, o forte se encontra em uma área do domínio de Morcul, mas, após o cataclismo de Dranos, eles recuaram, então, por mais que arriscado, pode ser possível alcançar o Templo.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Explicação — O Templo Solar das Terras Livres');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Guerra das Cinco Chaves — Relato de Arok ''Rulhzahir'' Dranor', 'guerra-das-cinco-chaves-relato-de-arok-rulhzahir-dranor', $MDS$> 📜 LORE ORIGINAL / relato in-world (autoria do grupo). Arquivo originalmente chamado "Guerra[". Preservado na íntegra.

Arok 'Rulhzahir' Dranor, Yowandar (Novembro) 2297, 27º e Último Escriba da linhagem Zahir, sobrevivente da mortalha de fogo. Ancião, Sábio e Eremita forjado nas artes da guerra e das sagradas escrituras dos Ancestrais. Pertencente ao sangue Dranor, Guardião da Torre da Capital. Aqui chamarei de 'Relato' devido ter vivido no período em questão, esses escritos históricos, dispostos agora nas Bibliotecas dos Guardiões para a posteridade.

A chamada Guerra das Cinco Chaves, ou Guerra das Almas, de fato possuiu uma demasiada quantidade de fatores que conspiraram, retirando todo o sentido indicador de casualidade, a declaração aberta da peleja. Após grande estudo e procura por entre centenas de fontes escritas, reuni o máximo de informações que deixarei aqui buscando apresentar muito mais os aspectos políticos vigentes do período fugindo das fabulas e contos envolvendo os heróis e guerreiros de renome dessas batalhas. Claro que muito dos rolos e livros foram destruídos pelo tempo ou pelas pragas que perseguem estantes livrárias, perdendo-se muitos dados. Muito do que encontrei e aprendi veio de maneira aleatória, desorganizada dentro da linha temporal, então não seguirei o raciocínio da minha pesquisa mas da cronologia correta.

Retornei aos arquivos da alameda baixa da BC, e encontrei muitos rolos de Undallar 'Vellzahir' BloodHammer que remontam o ano de 1734, período final da Guerra dos Cem Anos, aonde encontraremos os primeiros elementos factuantes a serem tratados. O Caixão das Almas, ou Túmulo, fora sempre elemento circundante desta guerra distante, portanto retornamos trezentos anos, na sua fundação, quando Morcul pactuou com a Criatura Divina Astral conhecida como Rainha Rapina na construção de um novo Plano Material para os não vivos. O Plano devorava a vitalidade de seus prisioneiros, que poderia ser catalisada pelos Magos Escuros, como fonte de energia Arcana extremamente densa e eficiente, a partir do que eles chamavam "Chaves". Aqui as palavras de Undallar: "durante a ultima peleja, forçamos as forças de Morcul remanescentes contra as Gorgoroth - montanhas que circundam seu maldito reino; Czar StormRage liderava as principais forças dos Stormborns até então a nordeste, próximo ao marco do primeiro braço do Divisa; minhas forças estavam isoladas. Mas não importava pois as tropas Morcunianas estavam desesperadas tentando alcançar segurança, seus contra ataques eram desorganizados e falhos. Era a vigésima noite de perseguição quando uma imensa quantidade de luzes romperam de trás das Montanhas do Horror, nas terras negras. Era como se um sol de luz doente esverdeada, as vezes de um roxo bruxuleante nascesse naquele momento..."

Como repetidamente registrado nos históricos da Guerra das Chaves, diversas vezes essas luzes apareceram no continente acompanhada de manifestações das forças de Exar Khun, fazendo com que as palavras de Undallar sejam o primeiro registro do dia em que o Caixão das Almas foi criado. Nessa mesma noite, muito provavelmente, seu primeiro prisioneiro fora lançado em suas profundezas, já mencionado aqui, Exar Khun.$MDS$, array['Lore Original']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Guerra das Cinco Chaves — Relato de Arok ''Rulhzahir'' Dranor');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'campanha', 'Estrutura Geral da Campanha — \"Ecos na Cidade dos Corvos\" — v1.0', 'estrutura-geral-da-campanha-ecos-na-cidade-dos-corvos-v10', $MDS$> 🟢 CANÔNICO (documento de MESTRE — contém spoilers). Fonte: Google Doc "Estrutura Geral da Campanha - Versão 1.0".

## Arco I — Dranorak
**Tema:** Mistério, investigação e descoberta gradual da corrupção religiosa.
**Objetivo:** Levar os PJs de problemas locais até descobrir que os responsáveis são os servidores do **Anarianismo**.
**Situação inicial:** Começa no **Distrito das Costas**. Os inimigos reais são desconhecidos; o Seio de Anar ainda parece legítimo; conflitos parecem locais.

**Sub-arcos:**
- **Parte I – O Sindicato das Costas:** missões, contratos e conflitos; conhecem a estrutura do Distrito das Costas e de Dranorak.
- **Parte II – A Resistência de Azor:** maior envolvimento das Espadas de Anar; começam a temer a religião.
- **Parte III – A Resistência de Azor:** entendem o definhamento da cidade e a intriga da corte; primeiro conflito direto com o Seio de Anar.

**Revelação final:** O Seio de Anar é o verdadeiro vilão do primeiro arco.

## Arco II — O Seio de Anar
**Tema:** O Seio de Anar torna-se o antagonista principal; entram os conflitos entre famílias e a corte.
**Objetivo:** Passar da investigação ao enfrentamento.

**Sub-arcos:**
- **Parte I – As Espadas de Anar:** confrontos diretos com a religião.
- **Parte II – Os Puristas de Sangue:** esquemas políticos e relações com Elódia e Atom.
- **Parte III – A Irmã Cinzenta:** usam a Cidade Baixa para invadir a Irmã Cinzenta.

**Revelação final:** A religião é uma cortina de fumaça. A fé é ferramenta de manipulação; os verdadeiros responsáveis são os **Devoradores de Mente**, posicionando-se dentro de Dranorak.

## Arco III — A Rainha Albina
**Tema:** Conspiração, revelação e guerra final.
**Objetivo:** Confrontar os responsáveis finais.

**Sub-arcos:**
- **Parte I – A Cidade Baixa:** investigam o poder e os mistérios dos Devoradores de Mente.
- **Parte II – A Besta Primordial:** descobrem **Tharizdun** e seu plano para Dranor e Dagorcain.
- **Parte III – O Vazio:** enfrentam **Shiera Wiserdon** (Suma Sacerdotisa do Seio de Anar) e o Vazio Primordial **Tharizdun**.

**Encerramento:** O destino de Dranorak é decidido no confronto contra Shiera.

---

## Abertura — Introdução dos Jogadores (Arco I)

**Contexto geral:**
- **A Herdeira:** Shiera Wiserdon foi declarada herdeira oficial do trono. Há cerimônia de nomeação e muitos visitantes na cidade.
- **A Cerimônia:** Shiera será declarada nova Alta Sacerdotisa do Seio de Anar (1º passo simbólico da nomeação de herdeiro).
- **Legitimação:** fortalecer sua imagem e combater rumores sobre a degeneração de seu pai, Dimitri II.
- **O Chamado dos Dranor:** linhagens Dranor e Rakkar (ainda vivas) convocadas a prestar lealdade, incluindo a idosa **Valerah Dranor**.

**Núcleo 1 — O Incidente Central (Os Fugitivos):**
- Local: **Acrópole Branca**, Torre da Águia, durante a cerimônia.
- As Cinco Torres: Sol, Lua, Águia, Vigília e dos Homens.
- Personagens: o **Pupilo** (PJ) e sua mentora **Nienor Dranor** (364 anos, filha do último rei deposto).
- Evento: o Pupilo testemunha uma tentativa de assassinato contra Valerah e percebe uma Presença Estranha (vinculada ao Anarianismo/Vazio).
- A Fuga: o halfling **Eduardo** (caçador de ratos) os leva às passagens secretas ("Túnel do Grifo").
- O Sacrifício: Valerah fica para trás e lança o Pupilo e Eduardo por um mecanismo direto à **Cidade Baixa**.

**Núcleos de Perseguição (contratos iniciais):**
- **Núcleo Assassinos:** contratados pelo lacaio "Espada" (Espadas de Anar). Objetivo: eliminar o Pupilo e Eduardo.
- **Núcleo Resgatistas:** contratados por **Prestus Arlak** (Sindicato das Costas). Objetivo: trazê-los vivos.

**Encontro na Cidade Baixa:** os núcleos convergem; intervém a terceira facção — os **Hunters de Elódia**, que tentam eliminar todos para enterrar o segredo da Acrópole.

**Conclusão:** o perigo dos Hunters força os três núcleos a cooperar e escapar das profundezas rumo a um local seguro (Distrito de Azor ou esconderijos do Sindicato).$MDS$, array['Ecos na Cidade dos Corvos']::text[], 'publicado', 'mestre'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Estrutura Geral da Campanha — \"Ecos na Cidade dos Corvos\" — v1.0');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'campanha', 'Nota de Mestre — Aventura (Caravana de Prisão)', 'nota-de-mestre-aventura-caravana-de-prisao', $MDS$> 🗒️ NOTA DE MESTRE / aventura (autoria do grupo). Arquivo "Aventura - nova". Preservado na íntegra.

**Começo:** É fim de tarde, no norte de inverno. Está nevando, nas proximidades das fronteiras de Dranor. Eles estão no reino.

Caravana de prisão — todos são apresentados neste momento. Eles podem tentar escapar (estão todos presos, menos o pala-maligno). Seus armamentos estão em uma "carroça de armas" logo atrás da "carroça de prisioneiros".

Com o início ou falha da fuga, o **Pala-maligno** intercepta a caravana para intervir nos assuntos dos "Anti-Morcull", como ordenado por sua ordem/divindade. Enquanto o Paladino enfrenta os inimigos, em meio à confusão eles chegam à carroça de armas para se equipar. O Paladino os ajuda com as "correntes" se ainda não tiverem se libertado.

**Encontro da Caravana:**
- 1 Humano Enfurecido Nv.3 — PV 56 · CA 15
- 2 Humanos Sentinelas Nv.2 — PV 39 · CA 16 — XP: 1400
- 12 Humanos Plebeus Nv.2 — PV 1 · CA 15 — *PS: não deixar os jogadores morrerem*

Após a luta, rolar uma "pilhagem rápida"; então fogem do local. Vão para a cidade de **Caledon**, a poucos dias dali. A partir de um gancho, seguem para um lugar a poucas horas dali, onde se reúnem forças para começar as lutas pelo domínio estratégico das guerras.$MDS$, array['Ecos na Cidade dos Corvos']::text[], 'publicado', 'mestre'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Nota de Mestre — Aventura (Caravana de Prisão)');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'campanha', 'Nota de Mestre — Cidade de Caledon', 'nota-de-mestre-cidade-de-caledon', $MDS$> 🗒️ NOTA DE MESTRE / AVENTURA (autoria do grupo). NPCs, encontros e XP.

**Taberna "A Última Vela"** (é também estalagem).
- Taberneiro: **Lucan** — Meio-Elfo, 50 anos, cabelo grande trançado.
- Briga no Bar: XP final 50 para cada um.

A cidade de **Caledon** é "liderada" por um nobre Eladrin eleito por voto público: **Blödgarm**, grande e poderoso mago. Os habitantes são em maioria Elfos e Meio-Elfos, com número considerável de Eladrins e moderada quantidade de humanos. Os Eladrins moram em sua maioria no bairro **Vale da Lua**, onde fica o "Salão" de Blödgarm.

**Erevan e Luna** — companhia de viagem: ele é um Elfo Patrulheiro, ela é Eladrin Maga. Missão: encontrar um "item" e descobrir o que tem atrapalhado as ações mágicas na região.

- **1º encontro:** esquadrão de 20 Goblins lacaios, liderados por um Goblin Combatente montado num Rato Atroz. Total = 700 XP.
- **Grupo de ladrões na estrada:** 4 Halflings Batedores + 1 Halfling Ladrão. 250 XP.$MDS$, array['Ecos na Cidade dos Corvos']::text[], 'publicado', 'mestre'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Nota de Mestre — Cidade de Caledon');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'campanha', 'Nota de Mestre — \"Primeira Viagem\" (mapa de trilha sonora)', 'nota-de-mestre-primeira-viagem-mapa-de-trilha-sonora', $MDS$> 🗒️ AUXÍLIO DE MESTRE (autoria do grupo). Roteiro de cues musicais por cena de uma sessão.

## Primeira Parte
- **Primeira Viagem** — *The Medallion Calls* / *Fog Bound* / *Jack Sparrow*
- **Encontro dos homens** — *Underwater March* (2:45)
- **Entrada da Dungeon 1** — *Finale*
- **Outros encontros** — *Skull and Crossbones* / *Hello Beasti* / *Dinner is Served*
- **Solo zumbi** — *Fog Bound* (0:46) / *The Prophecy* (1:15)
- **Armadilhas** — Armadilha Zumbi: *Parlay*
- **Armadilha Final** — *Up is Down*
- **Último encontro** — *Riders of Rohan* / *Helm's Deep*

## Segunda Parte
- **Muralha Arbórea** — *The King of the Golden Hall*
- **Segunda Viagem** — *The Hornburg*
- **Ruínas de Agrestia** — *Foundations of Stone* (até 1:25) / *Star Trek*
- **Ruínas próximas à montanha** — *Enterprising Young Man*
- **Aparição do Orcus** — *Foundations of Stone* (2:30)
- **Encontram a líder e seguem viagem** — *Evenstar*
- **A entrada da Dungeon da montanha** — *Forth Eorlingas*
- **Dentro da montanha** — *Gollum's Song*$MDS$, array['Ecos na Cidade dos Corvos']::text[], 'publicado', 'mestre'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Nota de Mestre — \"Primeira Viagem\" (mapa de trilha sonora)');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'campanha', 'Nota de Planejamento — Meiji / Thangor / Era dos Dragões', 'nota-de-planejamento-meiji-thangor-era-dos-dragoes', $MDS$> 🗒️ NOTA DE MESTRE (rascunho/planejamento, autoria do grupo). Esboço de ganchos — não é texto narrativo final.

- **Montanha Thangor** — Reino das Criaturas; ligação com Morcul (Ragnarus).
- **O Berço do Dragão.**
- Exar Khun busca aliados para Dranos (Dragões liderados por **Rhaz**).
- Elódia se contém ao descobrir a aliança entre Dragões e Dranor.
- Líderes de Dranar ficam nervosos e apreensivos com tal aliança.
- Morcul é pressionada por todos os lados; suas tropas recuam, mas ainda têm trunfos (aliança com Reino Tiefiling).
- Jogadores vão para **Atom**; preparam viagem para o **Reino Bárbaro**.$MDS$, array['Ecos na Cidade dos Corvos']::text[], 'publicado', 'mestre'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Nota de Planejamento — Meiji / Thangor / Era dos Dragões');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'sessao', 'Sessão 1 — Planejamento (Introdução)', 'sessao-1-planejamento-introducao', $MDS$## Introdução (Planejamento pré-sessão)

*Campanha de RPG · Mundo de Dagorcain*
*A Noite da Cerimônia*

> **Nota:** Este é o documento de planejamento escrito **antes** da sessão. O que de fato aconteceu na mesa está nos arquivos de resumo (v1, v2, v3 e WhatsApp). Há divergências naturais entre o planejado e o jogado (ex.: "O Pupilo" → Seraphina; "Eduardo" → Betinho; os núcleos B e C convergiram em Kadmo e Bredi).

### Contexto do Narrador

Esta é a sessão de introdução da campanha. Ela não faz parte do Arco I — é o evento que empurra os personagens para dentro da história. Ao final dela, os três núcleos terão se encontrado, sobrevivido juntos à Cidade Baixa, e terão mais perguntas do que respostas.

### O Contexto Político (só o narrador sabe)

Shiera Wiserdon está prestes a ser declarada Alta Sacerdotisa do Seio de Anar — o primeiro passo formal para sua nomeação como herdeira do trono. A cerimônia é uma jogada política: com Dimitri II cada vez mais uma casca viva, Shiera precisa consolidar legitimidade antes que o vácuo de poder se torne público.

Como parte do protocolo da cerimônia, membros das linhagens originais — famílias Dranor e Rakkar ainda reconhecidas — foram convocados para prestar lealdade. Entre eles, a idosa Valerah Dranor, 364 anos, filha do último rei deposto.

Valerah foi. E trouxe o Pupilo.

### Os Três Núcleos

A sessão começa com três grupos separados. O Narrador conduz cada um independentemente até o momento em que convergem na Cidade Baixa.

**Núcleo A — O Pupilo e Valerah**

*Personagens:*
- O Pupilo (PJ)
- Valerah Dranor — 364 anos, filha do último rei deposto, convocada para a cerimônia
- Eduardo — halfling, caçador de ratos, aparece durante a fuga. Ou esse personagem será um PJ, talvez o gnomo.

*Localização inicial:* Torre da Águia, Acrópole Branca. Uma das cinco torres monumentais, destinada a membros menores da corte. Fica entre as Torres do Sol e da Lua e a Torre da Vigília. Na base: áreas de criados e corredores de serviço.

**Núcleo B — Os Assassinos**

*Personagens:* PJs contratados como assassinos.

*Localização inicial:* Em algum ponto da cidade — taverna, beco, local combinado. Recebem o contrato de um agente mascarado que se identifica apenas como 'Espada'.

*O contrato:* Eliminar duas testemunhas de 'um incidente interno' na Acrópole. Sem detalhes sobre o que viram. O pagamento é alto demais para fazer perguntas.

**Núcleo C — Os Resgatistas**

*Personagens:* PJs contratados pelo Sindicato das Costas.

*Localização inicial:* Distrito das Costas ou Bairro do Musgo. São convocados por Prestus Arlak, operador do Sindicato.

*O contrato:* Alguém foi jogado pela Torre da Águia durante a cerimônia. Trazer as testemunhas vivas — o Sindicato quer saber o que elas viram antes de qualquer outra pessoa. Informação é produto.

---

## Ato I — Na Torre da Águia

Somente o Núcleo A está presente neste ato. Os outros núcleos recebem seus contratos simultaneamente, fora de cena.

### Cena 1 — A Espera

*Atmosfera:* A Torre da Águia está silenciosa. Lá embaixo, há tumulto entre os criados enquanto os preparativos para cerimônia acontecem. Aqui em cima, só o som distante de cânticos e o vento entre as pedras.

Valerah e o Pupilo aguardam nos aposentos da torre. Valerah olha pela janela de seu quarto, com um olhar contente de quem volta para sua casa. Ela está estranhamente contente, considerando tudo o que está acontecendo. Usa o tempo de espera para preparar o Pupilo: ela usa histórias de sua infância para lhe dar dicas de como se comportar na cidade, em quem não confiar, um pouco da história sobre o que significa carregar um nome Dranor em Dranorak hoje.

Um jovem caçador de ratos entra para preparar armadilhas nos aposentos. Ele surge do nada, mas antes de aparecer, o pupilo percebe o momento em que um pouco de vento toca os cabelos de Valerah e ela anuncia que elas têm um visitante.

*O que Valerah diz — sugestões:*

> 'Quando criança eu explorava essa torre de cima abaixo. Era o lugar onde eu e meus irmãos mais nos divertíamos, longe dos olhos da Torre do Sol. E com os filhos dos criados, aprendemos os caminhos secretos desse lugar – lá eu aprendi que, se um dia você estiver no escuro, basta seguir o seu nariz'.

> 'Os corvos nessa cidade não são só praga. Alguns observam. Aprendi isso cedo.'

> 'O mundo é muito grande e o tempo muito curto para você continuar presa às regras. Talvez aqui você terá a oportunidade de recomeçar do zero'.

### Cena 2 — O Incidente

*A nomeação:* A nomeação é rápida, mas emblemática. Valerah, ou Mestre Val, e outros dois garotos – Rakkars sobreviventes e conhecidos na corte – e vários outros membros de famílias Dranorianas, fazem juramento à nova sacerdotisa. O pupilo está observando distante. Ele não pode entrar no salão principal. Lá ele se conecta com um dos criados que esbarra nele com uma armadilha de ratos. O mesmo que estava nos aposentos anteriormente.

Após a cerimônia, elas retornam para os aposentos, mas agora, Val está com algo estranho no olhar...

*O que acontece:* Assassinos entram pela torre. Alvo: Valerah. O Pupilo está no meio.

Durante o caos, algo mais está presente. Não uma criatura visível — uma sensação. Uma mácula. Algo que emana uma presença religiosa profunda e perturbadora, como se o ar ficasse mais pesado e as sombras se comportassem diferente. Não tem nome. Não tem forma. Só existe.

*Eduardo ou o PJ:* O halfling aparece magicamente mais uma vez — ele conhece todos os entremeios da torre, caça ratos aqui há anos. Valerah, surpreendentemente, pergunta se ele conhece o Túnel do Grifo. Ele conhece.

### Cena 3 — O Sacrifício

*O que acontece:* Valerah fica para trás. Ela vai segurar os assassinos e a Presença enquanto o Pupilo e Eduardo fogem pelo Túnel do Grifo.

Antes de lançá-los pelo portal, ela diz algo. Simples. Não é um discurso épico — é a última coisa que uma pessoa diz quando sabe que não tem mais tempo.

*Sugestão de fala final:*

> 'Você vai cair num lugar escuro. Eduardo vai te ajudar a sair. A partir daí, você está sozinho — mas não perdido. Dranorak é brutal com quem não a entende. Aprenda-a antes de tentar mudá-la.'

> 'E se tem algo que eu preciso que você faça por mim é... recomeçar. Isso não é o fim, esse lugar é onde sua vida realmente começa'.

---

## Ato II — Contratos e Túneis

Os três núcleos estão agora em movimento. O Pupilo e Eduardo emergem no nível de entrada da Cidade Baixa. Os outros dois grupos foram ativados e estão descendo para os túneis.

Cada núcleo enfrenta um encontro com monstros antes de se encontrarem. Os encontros são rápidos e tensos — suficientes para gastar recursos, estabelecer perigo, não para destruir o grupo.

### Encontro — Núcleo A: Fungo Violeta

*Contexto:* O Pupilo e Eduardo emergem no nível de entrada dos túneis. Musgo pulsante nas paredes, escuridão quase total, o cheiro de esgoto e algo orgânico e úmido que não deveriam estar ali. Eduardo conhece o cheiro do lugar — mas não seus perigos.

*O encontro:* Fungos Violeta estão espalhados pelo corredor, imóveis. Parecem crescimento comum até que alguém se aproxima. Eles não perseguem — quem entra no alcance sofre as consequências.
- Fungo Violeta (MM p. 146, CR 1/4)
- Sugestão: 2 a 3 fungos em posições que forçam o grupo a passar perto
- Eduardo pode ajudar a identificar um caminho alternativo — mas mais lento

*Gancho narrativo:* Ao perceber os fungos, Eduardo nota algo estranho: há Miconídeos mortos pelo corredor. Esmagados, como se algo grande tivesse passado por ali recentemente.

### Encontro — Núcleo B: Fúria de Ratos

*Contexto:* Os assassinos entram pelos túneis vindos de uma saída conhecida do submundo. O caminho parece limpo — até que as paredes começam a se mover.

*O encontro:*
- Fúria de Ratos (MM p. 339, CR 1/4)
- Sugestão: 1 fúria grande que sai de um buraco no teto ou parede
- O enxame se divide se receber dano de área

*Gancho narrativo:* No meio do combate, um dos personagens nota marcas nas paredes — arranhados recentes, altos demais para ratos. Algo com garras maiores esteve aqui.

### Encontro — Núcleo C: Miconídeo Bruto + Fúria de Insetos

*Contexto:* Os resgatistas descem pelos túneis do Bairro do Musgo. O caminho está coberto de esporos. Então encontram os Miconídeos.

*O encontro:*
- Miconídeo Bruto (MM p. 228, CR 1/2) + Fúria de Insetos (MM p. 338, CR 1/2)
- O Bruto está agitado, se movendo em círculos — comportamento atípico
- A Fúria de Insetos sai de dentro de um Miconídeo morto no chão

*O gancho de lore — importante:* Se algum personagem do Núcleo C tiver o conhecimento adequado (Nature, Arcana ou background relevante), ele reconhece: Miconídeos são criaturas das profundezas. Eles não deveriam estar nos níveis de entrada. Algo os está empurrando para cima — e isso significa que algo ainda pior está descendo lá embaixo.

---

## Ato III — Convergência

### Cena 4 — O Encontro dos Núcleos

*O que acontece:* Os três grupos convergem para o mesmo corredor. O Pupilo e Eduardo estão perdidos. Os assassinos chegam de um lado. Os resgatistas chegam do outro.

Momento de standoff. Quem atira primeiro? Quem negocia? Eduardo, com instinto de sobrevivência afinado, percebe imediatamente que matar qualquer um aqui vai atrair atenção — e que há algo se movendo nas sombras ao fundo do corredor.

*Como resolver:* Deixe os jogadores decidirem. Não há resposta certa. O objetivo é que os grupos se conheçam e criem tensão entre si — que vai durar muito além desta sessão.

### Encontro Final — O Otyugh

*Contexto:* Independentemente de como o standoff termina, a criatura aparece. Ela estava esperando. Ou talvez os barulhos do combate anterior a tenham atraído.

*A criatura:*
- Otyugh (MM p. 248, CR 2)
- Emerge de uma câmara inundada ao fundo do corredor
- É enorme para o espaço — os personagens percebem que ele mal cabe ali

*O elemento de mistério — telepatia rudimentar:* O Otyugh tem telepatia primitiva. No momento em que os personagens entram em combate com ele, alguns começam a receber flashes involuntários — imagens fragmentadas que a criatura carrega na memória:
- Calor vindo de baixo. Muito abaixo.
- Estruturas orgânicas pulsando nas paredes de cavernas profundas — como veias, mas enormes.
- Miconídeos fugindo em bando para cima. Fugindo de quê?
- Escuridão com forma. Algo que se move com propósito.

### Cena 5 — A Saída

*O que acontece:* Com o Otyugh derrotado ou afastado, o grupo precisa sair. Eduardo conhece uma saída que emerge no Bairro do Musgo, perto do Distrito de Azor — longe da Acrópole Branca e dos Elmos de Dragão.

A saída é a primeira decisão coletiva dos grupos: confiam uns nos outros o suficiente para seguir juntos? O Sindicato das Costas tem um esconderijo próximo. Os assassinos têm um contrato que tecnicamente ainda está em aberto.

*Final em aberto:*
- Quem era Valerah Dranor, afinal?
- O que era aquela Presença na Torre da Águia?
- Por que alguém pagou tão bem para silenciar duas testemunhas de um 'incidente interno'?
- O que está acontecendo nas profundezas da Cidade Baixa?

---

## Nota do Narrador — O Problema do Tempo

Os Núcleos B e C recebem contratos logo após o incidente na Torre. O problema: quanto tempo o Pupilo e Eduardo ficam perdidos nos túneis enquanto os outros são ativados?

Sugestão de solução: o incidente na Torre acontece à noite, durante a cerimônia. Os contratos são distribuídos nas horas seguintes — ainda na mesma madrugada. Os Núcleos B e C chegam ao nível de entrada dos túneis na mesma noite, talvez duas ou três horas depois da queda.

O Pupilo e Eduardo ficam presos o tempo suficiente para o encontro com os Fungos e para se perderem brevemente nos corredores. Não é tempo dramático — é tempo suficiente para estabelecer que eles estão desorientados e vulneráveis quando os outros chegam.$MDS$, array['Sessão 1']::text[], 'publicado', 'mestre'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Sessão 1 — Planejamento (Introdução)');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'sessao', 'Sessão 1 — Resumo (WhatsApp)', 'sessao-1-resumo-whatsapp', $MDS$## Resumo para WhatsApp (versão dos jogadores)

🎲 **ECOS NA CIDADE DOS CORVOS**
*Sessão 1 — Resumo*

Primeira sessão jogada. Dois grupos, um dia inteiro de história, e os quatro personagens se encontrando nas profundezas de Dranorak.

---

### 📍 Núcleo 1 — Tarde e Noite

A sessão abriu com Válerah e Seraphina chegando a Dranorak pela grande estrada. Na mesma estrada vinha o Circo Magnífico, com Seebo a bordo. Na entrada da cidade, Válerah tocou uma pedra da ponte e mencionou de passagem que faziam mais de trezentos anos desde sua última visita.

A cidade estava movimentada pela cerimônia. Os dois grupos notaram os corvos em número absurdo — e uns filamentos estranhos presos às estruturas e à iluminação pública, que os corvos tentavam bicar o tempo todo. Válerah disse não saber o que eram.

No caminho para o castelo, Válerah finalmente explicou: ela é a última descendente da família Dranor, a linhagem real que os Wiserdon derrubaram há 350 anos. Havia sido convocada para jurar lealdade à nova dinastia — a presença dela era o gesto de legitimidade mais poderoso que a cerimônia poderia ter. Veio também porque queria ver Dranorak uma última vez. Ela sabia que estava perto do fim.

Seebo, impedido pelos guardas de instalar o circo, se infiltrou no castelo escondido entre carruagens, fingiu ser carregador, foi derrubado por um cavalo e terminou num depósito. Lá conheceu Betinho — halfling caçador de ratos que conhecia cada passagem secreta do castelo. Uma parceria improvisada.

Na cerimônia, o velho rei anunciou a filha como futura rainha. As famílias antigas juraram lealdade. Quando Válerah Dranor se apresentou, o salão reagiu — a última Dranor ali era um símbolo enorme. A futura rainha também foi nomeada Alta Sacerdotisa do Seio de Anar: o primeiro passo formal da sucessão, que une poder político e religioso.

De volta à torre, Válerah avisou Seraphina que o que fosse acontecer naquela noite não era um fim, mas um começo. Seebo apareceu pela passagem secreta com Betinho. Válerah assinou a autorização do circo, pediu ao gnomo que cuidasse de Seraphina e foi direta:

> *"Teremos outros visitantes. E eles não serão amigáveis."*

Antes de mandá-los fugir, colocou as mãos nos ombros de Seraphina — e Seebo percebeu um movimento discreto: algo foi passado para as roupas da halfling. O que era ainda não foi revelado. A instrução final:

> *"Quando estiver nos lugares escuros e não souber para onde ir, siga seu nariz."*

Betinho guiou os três pelas passagens internas. Válerah apareceu depois, ferida, levou-os ao Túnel do Grifo e os empurrou pelo portal mágico. Betinho desobedeceu a ordem de entrar, olhou para trás e foi atingido por algo indescritível. Seus olhos mudaram. Ele morreu. Os três ainda viram Válerah em forma de combate — a Chama de Poder dos dranorianos — segurando aquilo que os perseguia. Depois só escuridão.

---

### 📍 Núcleo 2 — Madrugada

Kadmo e Bredi estavam numa taverna do Distrito das Costas sem dinheiro e sem trabalho. Prestus Arlak apareceu com uma proposta do Sindicato das Costas: mil pedras para encontrar duas pessoas vivas na Cidade Baixa — uma halfling e um gnomo. Trezentas se viessem mortas. Sem perguntas. Aceitaram.

A busca pela entrada levou os dois por uma cartomante (que tem algum vínculo com Bredi), por um homem chamado O Gordo na Rua do Gato, e finalmente por um guarda num bordel que revelou a entrada: pelos esgotos, depois por uma porta escondida nos níveis inferiores.

---

### 📍 Convergência — A Cidade Baixa

Seraphina e Seebo chegaram num salão subterrâneo enorme — pedras cristalinas como as de Dranorak, mas arquitetura anã. A capacidade de Seebo de se comunicar com animais, algo natural para gnomos, ajudou desde o início: ele percebeu os ratos se aproximando e entendeu a intenção antes do ataque. Após o combate, enquanto os ratos fugiam derrotados, Seebo captou o que diziam ao escapar — que se dirigiam a uma saída ou lugar seguro. Os dois os seguiram.

Kadmo e Bredi, pelos túneis, encontraram uma área de fungos com traços de cultivo. Despertaram um miconídeo que guardava o espaço. Depois de derrotá-lo, a estranheza ficou no ar: miconídeos não deveriam estar tão perto da superfície.

Os quatro chegaram ao mesmo reservatório — câmara enorme, cheia de canais de água. Os ratos chegaram primeiro, depois Seraphina e Seebo. Kadmo e Bredi reconheceram as descrições do contrato. Momento de tensão. Aí a água se moveu.

Kadmo tocou a superfície e despertou o Otyugh que vivia lá. Os quatro lutaram juntos pela primeira vez. No último golpe antes de a criatura morrer, Kadmo recebeu imagens involuntárias: profundezas, escuridão, e um medo enorme que havia forçado o Otyugh a subir. Seebo tocou o corpo e confirmou: o lugar era muito mais antigo que Dranorak, e algo lá embaixo estava empurrando criaturas milenares para cima.

A sessão terminou com os quatro ao redor do cadáver, na escuridão dos subterrâneos. Sem notícias de Válerah. Sem entender o que os perseguiu no castelo. Sem saber o que vem de baixo.

---

### ⭐ Sistema de Recompensas

A partir desta sessão, valem as seguintes recompensas:

- **Inspiração** — para grandes momentos de interpretação, a critério do mestre.
- **Bônus de XP por interpretação** — entrega ao personagem, decisões coerentes com o background, construção de relações com NPCs.
- **Bônus de XP por ações em combate** — criatividade, heroísmo, domínio tático. Regra já definida: encerrar um combate em um único turno, antes que as criaturas ataquem = dobro do XP normal daquelas criaturas. Outros atos heroicos também darão XP, com valores definidos pelo mestre caso a caso.

---
*Sessão 2 em breve.* 🎲$MDS$, array['Sessão 1']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Sessão 1 — Resumo (WhatsApp)');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'sessao', 'Sessão 1 — Resumo Narrativo', 'sessao-1-resumo-narrativo', $MDS$## Resumo v1 — Narrativo direto

### Parte I · O Caminho até a Cidade dos Corvos — A Última Dranor e Sua Aprendiz

A sessão começou na estrada que leva a Dranorak. Válerah Dranor viajava com sua aprendiz Seraphina Altacolina — a jovem halfling que ela havia recrutado anos antes, aparecendo inesperadamente em sua porta com uma oferta de aventura e bruxaria. Na mesma estrada seguia o Circo Magnífico, do tiefling Senhor Magnífico, com o gnomo mago Seebo entre seus integrantes.

Para Seraphina, a viagem era repleta de dúvidas. O aviso chegara por corvo, Válerah ficara hesitante antes de aceitar e depois demonstrou entusiasmo incomum — mais do que o normal para qualquer compromisso que já houvessem assumido juntas. A halfling não sabia o motivo real da viagem.

Seebo havia saído da Floresta Anã com o objetivo de levar magia às pessoas de forma pacífica e se juntou ao circo para viajar. A coroação em Dranorak era uma boa oportunidade para apresentações. Durante o caminho, ele e Seraphina se tornaram amigos — o gnomo gostava de truques e ilusões, e isso encantou a halfling desde o início.

### Parte II · Dentro das Muralhas — O Que a Cidade Escondia

Ao chegar em Dranorak, o grupo cruzou a ponte de entrada — construída com as pedras cristalinas características da cidade. Ao tocar uma dessas pedras, Válerah mencionou que faziam mais de trezentos anos desde sua última visita. A revelação pegou todos de surpresa.

A cidade estava movimentada pela chegada de famílias para a cerimônia. O grupo notou os corvos por toda parte e também estranhos filamentos presos às estruturas e à iluminação pública — que os corvos tentavam devorar. Seraphina perguntou a Válerah sobre eles. Ela disse não saber o que eram.

Os caminhos se separaram. Válerah indicou ao Circo uma praça entre o Distrito de Azor e o Distrito das Costas, e seguiu com Seraphina para o castelo. No caminho, finalmente contou a verdade: era a última descendente da família Dranor, a linhagem real derrubada pelos Wiserdon há cerca de trezentos e cinquenta anos. A futura rainha havia convocado representantes das antigas famílias para prestar juramento — e a presença da última Dranor seria o gesto de legitimidade mais poderoso que a cerimônia poderia ter. Válerah aceitou o convite porque queria ver Dranorak uma última vez. Ela sentia que estava perto do fim de sua vida.

### Parte III · As Confusões do Gnomo — Seebo no Castelo

O Circo Magnífico encontrou dificuldades para se instalar — os guardas não permitiram. Seebo foi ao castelo tentar falar com Válerah. Sem conseguir entrar pelos meios normais, escondeu-se entre as carruagens, fingiu ser carregador e acabou sendo derrubado por um cavalo. Terminou num depósito.

Lá encontrou Betinho, um halfling caçador de ratos que conhecia os corredores e passagens secretas do castelo melhor do que qualquer pessoa. Havia também um segundo homem no depósito, cujo nome não foi definido na sessão. Seebo mentiu, dizendo ter sido enviado para ajudá-los, e em troca conseguiu auxílio para se mover pelo castelo. Os dois ajudaram a transportar caixas enquanto Seebo tentava encontrar Válerah.

### Parte IV · A Cerimônia — O Peso de um Nome

O rei Dimitri II havia chegado ao salão antes dos convidados — para que ninguém visse o quanto lhe custava caminhar. Anunciou oficialmente sua filha como futura soberana. As famílias antigas prestaram juramento, uma a uma.

Quando Válerah Dranor se apresentou, o efeito foi imediato. A última herdeira da linhagem derrubada, ali, reconhecendo publicamente a nova dinastia — era exatamente o que a corte precisava para dar legitimidade à sucessão. Seraphina assistiu a tudo ao lado dela.

A futura rainha foi também nomeada Alta Sacerdotisa do Seio de Anar — a religião oficial do rei. Esse é o primeiro passo formal ao se indicar um herdeiro ao trono, unindo em uma só pessoa os poderes político e religioso.

### Parte V · O Último Conselho — O Que Vai Acontecer Esta Noite Não É Um Fim

De volta aos aposentos na torre, Válerah olhou para a cidade pela janela e explicou a Seraphina o real motivo pelo qual a havia trazido: queria que Dranorak fosse o começo de uma nova vida para ela. Disse, com calma, que acontecesse o que acontecesse naquela noite, Seraphina não devia encarar aquilo como um fim — mas como um começo.

Seebo apareceu pela passagem secreta com Betinho. Válerah não demonstrou surpresa. Assinou a autorização para o Circo se instalar na praça e pediu ao gnomo que ajudasse Seraphina. Quando a halfling perguntou o porquê, Válerah respondeu:

> "Teremos outros visitantes. E eles não serão amigáveis."

Antes de mandar os três fugirem, Válerah apoiou as mãos nos ombros de Seraphina e deixou uma instrução final. Seebo, que estava atento, percebeu um movimento discreto das mãos — algo foi passado para as roupas da halfling, mas o que era não foi revelado à mesa. A instrução de Válerah foi:

> "Quando estiver nos lugares escuros e não souber para onde ir, siga seu nariz."

### Parte VI · A Fuga — O Sacrifício no Túnel do Grifo

Betinho guiou os três pelas passagens secretas para baixo. Algum tempo depois, Válerah os alcançou — ferida. Levou-os até o Túnel do Grifo e ativou uma passagem mágica escondida. Sem hesitar, empurrou os três pelo portal.

Enquanto caíam, viram Válerah ficar para trás. Betinho desobedeceu e não entrou — olhou para trás e foi atingido por algo que não dava para descrever. Seus olhos mudaram de forma horrenda. Ele morreu ali.

Antes da escuridão fechar completamente, ainda puderam ver Válerah — assumindo a forma que os dranorianos tomam em combate, quando a chamada Chama de Poder se manifesta — segurando aquilo que os perseguia para que os três escapassem.

### Parte VII · A Madrugada no Distrito das Costas — Kadmo, Bredi e o Contrato

Do outro lado da cidade, horas depois, Kadmo e Bredi estavam numa taverna do Distrito das Costas sem dinheiro e sem trabalho. Kadmo é um meio-orc das Terras Bárbaras, em seu ritual de passagem — a tradição do Clã Duas Presas manda que jovens partam pelo mundo aos dezessete anos para conquistar glória. Bredi é um feiticeiro que veio de Elódia, onde um incidente ligado aos seus poderes o tornou proscrito. Desde então, tenta sobreviver evitando encarar o que aconteceu.

Apareceu Prestus Arlak, mensageiro do Sindicato das Costas. Os dois evitavam trabalhos do Sindicato, mas a proposta era difícil de recusar: mil pedras de ouro para encontrar duas pessoas vivas desaparecidas na Cidade Baixa — uma halfling e um gnomo. Trezentas pedras se fossem encontradas mortas. Parte do contrato era não fazer perguntas. Aceitaram.

Para achar a entrada da Cidade Baixa, procuraram uma cartomante do Distrito das Costas — que aparentemente tem algum vínculo com Bredi — e pagaram por informações. Ela os mandou procurar um homem chamado O Gordo, na Rua do Gato, conhecida pelas sopas feitas com carnes de procedência duvidosa. O Gordo os conectou a Gaspar, um guarda que frequentava um dos bordéis da região, e que finalmente revelou a entrada: pelos esgotos, e depois por uma porta escondida que levava aos níveis inferiores.

### Parte VIII · A Cidade Baixa — Onde Os Caminhos Se Encontraram

Seraphina e Seebo caíram num salão subterrâneo enorme — construído com as mesmas pedras cristalinas de Dranorak, mas com características de arquitetura anã. A habilidade de Seebo de se comunicar com animais, algo natural para os gnomos, foi útil logo de início: ele percebeu a aproximação dos ratos antes do ataque e entendeu a intenção deles. Após o combate, enquanto os ratos derrotados fugiam, Seebo captou o que diziam ao escapar — que se dirigiam a uma saída ou lugar seguro. Os dois decidiram segui-los.

Kadmo e Bredi, nos túneis, encontraram uma região dominada por fungos — parecida com uma plantação subterrânea. Ao perturbarem o local, despertaram um miconídeo que guardava o espaço. Depois de derrotá-lo, levantaram a questão: miconídeos não deveriam estar tão próximos da superfície.

Os dois grupos chegaram ao mesmo lugar: um reservatório subterrâneo enorme, uma câmara abobadada alimentada por canais de água. Os ratos chegaram primeiro. Depois, Seraphina e Seebo. Kadmo e Bredi reconheceram as descrições do contrato. Os quatro se encontraram com desconfiança mútua. Antes de qualquer acordo, algo se moveu nas águas.

### Parte IX · O Primeiro Combate — O Otyugh

Kadmo tocou a água e despertou o Otyugh — a criatura que habitava o reservatório. Ela emergiu e atacou. Os quatro lutaram juntos pela primeira vez.

Ao receber o último golpe dos tentáculos antes de a criatura morrer, Kadmo teve uma série de imagens involuntárias: profundezas, escuridão, e um medo enorme que havia forçado o Otyugh a fugir para mais perto da superfície. Seebo, curioso, tocou o corpo da criatura morta e usou sua sensibilidade mágica. Confirmou que o local era muito mais antigo do que Dranorak — e que algo nas profundezas estava empurrando criaturas milenares para cima.

### Encerramento · Quatro Estranhos, Um Lugar Escuro

A sessão terminou com os quatro ao redor do cadáver do Otyugh, cercados pela escuridão e pela água dos subterrâneos. Sem saber o que aconteceu com Válerah. Sem entender o que os havia perseguido no castelo. Sem compreender o que estava acontecendo nas profundezas. E sem imaginar o que vem a seguir.

---

## Sistema de Recompensas · Sessão 1

Os jogadores receberão bônus por interpretação e por ações em combate ao longo da campanha. Abaixo, as regras em vigor a partir desta sessão:

**Inspiração** — Concedida a critério do mestre para momentos de grande destaque na interpretação do personagem.

**Bônus de XP por Interpretação** — Jogadores que se entregarem à interpretação de seus personagens — decisões coerentes com o background, reações genuínas a eventos da história, construção de relações com NPCs — receberão bônus de XP ao final de cada sessão.

**Bônus de XP por Ações em Combate** — Ações que demonstrem criatividade, heroísmo ou domínio tático dentro do combate também geram XP adicional. Um critério já definido: encerrar um combate em um único turno, antes que as criaturas ataquem, vale o dobro do XP que aquelas criaturas dariam normalmente. Outros atos heroicos também darão XP — os valores específicos serão determinados pelo mestre caso a caso.$MDS$, array['Sessão 1']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Sessão 1 — Resumo Narrativo');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'sessao', 'Sessão 1 — Crônica de Mesa', 'sessao-1-cronica-de-mesa', $MDS$## Resumo v2 — Crônica de Mesa (como a história se desenrolou na mesa)

### Parte I · O Começo — A Estrada e os Dois Grupos

A sessão abriu com dois grupos separados chegando a Dranorak. De um lado, Válerah e Seraphina viajando juntas — mestra e aprendiz. Do outro, o Circo Magnífico, com Seebo a bordo. Os grupos se encontraram na estrada, mas ainda não tinham muito a ver um com o outro.

Seraphina sabia que a viagem era importante para Válerah, mas não sabia o porquê. O convite havia chegado por corvo, e a bruxa — que normalmente era cautelosa — ficou empolgada de uma hora para outra. A halfling foi junto sem saber no que estava se metendo.

Seebo estava no circo pela oportunidade de viajar e levar magia a novas pessoas. A coroação em Dranorak era perfeita para apresentações. No caminho, ele e Seraphina ficaram amigos — o gnomo fez alguns truques de ilusão que encantaram a halfling.

### Parte II · Entrando na Cidade — Trezentos Anos e os Filamentos Estranhos

A entrada em Dranorak pela grande ponte já deu o tom. Válerah tocou uma das pedras cristalinas da estrutura e mencionou, quase de passagem, que faziam mais de trezentos anos desde sua última visita. Os outros ficaram sem resposta.

A cidade estava cheia por causa da cerimônia. O que chamou atenção, além do movimento, foram os corvos — em número absurdo — e uns filamentos estranhos presos às estruturas e à iluminação pública. Os corvos ficavam tentando bicar esses filamentos. Seraphina perguntou a Válerah o que eram. A bruxa disse não saber. Talvez fosse verdade. Talvez não.

Válerah indicou uma praça para o circo se instalar e levou Seraphina em direção ao castelo. No caminho, finalmente contou: era a última descendente da família Dranor, a linhagem real derrubada pelos Wiserdon. A futura rainha precisava de legitimidade e havia convocado as famílias antigas para jurar lealdade. Ter a última Dranor presente era mais valioso do que qualquer discurso. Válerah aceitou porque queria ver a cidade uma última vez. Ela sabia que estava perto do fim.

### Parte III · A Infiltração do Gnomo — Seebo, o Carregador Acidental

O circo teve problema para se instalar — os guardas barraram. Seebo foi atrás de Válerah para pedir ajuda. Não conseguiu entrar pelos meios normais e decidiu se esconder entre as carruagens para entrar junto. Fingiu ser carregador, foi derrubado por um cavalo, e parou num depósito.

No depósito encontrou Betinho — um halfling que caçava ratos no castelo e conhecia cada corredor e passagem secreta do lugar. Havia também outro homem no depósito, que não chegou a ter nome definido na sessão. Seebo inventou que havia sido enviado para ajudá-los e, em troca de acesso ao castelo, ficou carregando caixas com os dois. Funcionou, mais ou menos.

### Parte IV · A Cerimônia — Válerah Dranor Entra no Salão

O rei chegou ao salão antes dos convidados para evitar que vissem o esforço que fazia para caminhar. Anunciou a filha como futura rainha. As famílias prestaram juramento na sequência.

Quando Válerah se apresentou, o salão reagiu. Trezentos e poucos anos de vida, última de uma linhagem derrubada, ali reconhecendo a nova dinastia — era exatamente o símbolo que a corte queria. Seraphina ficou ali ao lado, vendo tudo.

A futura rainha também foi nomeada Alta Sacerdotisa do Seio de Anar — o que significa que foi oficialmente designada herdeira, já que a tradição une os poderes político e religioso em uma mesma pessoa antes de qualquer coroação.

### Parte V · O Aviso — Teremos Outros Visitantes

Depois da cerimônia, Válerah e Seraphina voltaram para os aposentos na torre. Olhando a cidade pela janela, Válerah explicou por que havia trazido a aprendiz: queria que Dranorak fosse o ponto de partida de uma nova vida para ela. Disse que, acontecesse o que acontecesse naquela noite, Seraphina não devia ver aquilo como um fim — mas como um começo.

Seebo apareceu pela passagem secreta com Betinho. Válerah não se surpreendeu. Assinou a autorização do circo e pediu ao gnomo que ajudasse Seraphina. Quando a halfling perguntou por quê, Válerah foi direta:

> "Teremos outros visitantes. E eles não serão amigáveis."

Antes de mandar os três irem embora, Válerah colocou as mãos nos ombros de Seraphina e falou a instrução final. Seebo percebeu um movimento sutil das mãos nesse momento — algo foi colocado nas roupas da halfling. O que era, ainda não foi revelado à mesa. A instrução foi:

> "Quando estiver nos lugares escuros e não souber para onde ir, siga seu nariz."

### Parte VI · A Fuga — Betinho, o Portal e o Que Ficou Para Trás

Betinho guiou os três pelos corredores escondidos do castelo para baixo. Depois de um tempo, Válerah apareceu — ferida — e os levou até o Túnel do Grifo. Ativou uma passagem mágica e empurrou os três pelo portal sem hesitar.

Caindo na escuridão, viram Válerah permanecer do lado de fora. Betinho se recusou a entrar — desobedeceu a ordem e olhou para trás. Algo o atingiu. Seus olhos mudaram de uma forma que não dava para descrever direito. Ele morreu.

Nos últimos instantes antes de a passagem fechar, viram Válerah na forma de combate dos dranorianos — a Chama de Poder que se manifesta nos momentos de fúria — segurando aquilo que os perseguia para que pudessem escapar. Depois, só escuridão.

### Parte VII · O Outro Lado da Cidade — O Contrato de Kadmo e Bredi

Enquanto isso, horas depois na madrugada, Kadmo e Bredi estavam numa taverna do Distrito das Costas. Sem dinheiro e sem serviço. Kadmo é meio-orc das Terras Bárbaras, saiu do Clã Duas Presas para cumprir o ritual de passagem — a tradição manda que os jovens do clã partam pelo mundo aos dezessete anos para ganhar glória. Bredi é feiticeiro de Elódia — ou era, até que um incidente com seus poderes o tornou proscrito. Desde então, sobrevive na rua tentando não olhar para o passado.

Prestus Arlak apareceu. Mensageiro do Sindicato das Costas — os dois evitavam trabalhos assim, mas a proposta era boa demais: mil pedras para encontrar duas pessoas vivas desaparecidas na Cidade Baixa, uma halfling e um gnomo. Trezentas se viessem mortas. Sem perguntas. Aceitaram.

Para chegar à Cidade Baixa, passaram por uma cartomante do Distrito das Costas que tem alguma ligação com Bredi — pagaram por informação. Ela mandou falar com O Gordo, na Rua do Gato, famosa pelas sopas de carne de origem questionável. O Gordo os mandou falar com Gaspar, um guarda que estava num bordel ali perto. Gaspar revelou a entrada: pelos esgotos, depois por uma porta escondida que levava aos andares inferiores.

### Parte VIII · Convergência — O Reservatório

Seraphina e Seebo caíram num salão enorme, com a mesma pedra cristalina de Dranorak, mas com traços de construção anã. A capacidade de Seebo de se comunicar com animais — algo natural para gnomos — foi útil desde o início: ele percebeu os ratos se aproximando e entendeu a intenção antes do ataque. Depois do combate, enquanto os ratos fugiam derrotados, ele captou o que diziam ao escapar: que se dirigiam para uma saída ou lugar seguro. Os dois os seguiram.

Kadmo e Bredi, pelos túneis, encontraram uma região cheia de fungos que parecia uma plantação underground. Ao mexerem, acordaram um miconídeo que guardava o lugar. Depois de derrotá-lo, ficou a pergunta: por que um miconídeo estava tão perto da superfície?

Os quatro chegaram ao mesmo reservatório — uma câmara abobadada enorme com canais de água alimentando o espaço. Os ratos chegaram primeiro, depois Seraphina e Seebo. Kadmo e Bredi reconheceram as descrições do contrato. Houve um momento de tensão entre os quatro antes de qualquer acordo. Então a água se moveu.

### Parte IX · Primeiro Combate dos Quatro — O Otyugh e as Imagens das Profundezas

Kadmo tocou a água. Um Otyugh emergiu. Os quatro lutaram juntos pela primeira vez — ainda sem saber bem se podiam confiar uns nos outros, mas sem escolha.

No final do combate, quando os tentáculos da criatura tocaram Kadmo pela última vez antes de ela morrer, o meio-orc recebeu imagens que não eram suas: profundezas, escuridão, e um medo enorme que havia empurrado o Otyugh para cima. Seebo tocou o corpo e confirmou com sua sensibilidade mágica — o lugar era anterior a Dranorak, muito mais antigo, e algo lá embaixo estava forçando as criaturas a subirem.

### Encerramento · Fim da Sessão 1

Os quatro ficaram parados ao redor do Otyugh morto, na câmara escura, com a água antiga dos subterrâneos ao redor. Sem notícias de Válerah. Sem entender o que os perseguiu no castelo. Sem saber o que está vindo de baixo. E sem ainda terem decidido se confiam uns nos outros.

---

## Sistema de Recompensas · Sessão 1

Os jogadores receberão bônus por interpretação e por ações em combate ao longo da campanha. Abaixo, as regras em vigor a partir desta sessão:

**Inspiração** — Concedida a critério do mestre para momentos de grande destaque na interpretação do personagem.

**Bônus de XP por Interpretação** — Jogadores que se entregarem à interpretação de seus personagens — decisões coerentes com o background, reações genuínas a eventos da história, construção de relações com NPCs — receberão bônus de XP ao final de cada sessão.

**Bônus de XP por Ações em Combate** — Ações que demonstrem criatividade, heroísmo ou domínio tático dentro do combate também geram XP adicional. Um critério já definido: encerrar um combate em um único turno, antes que as criaturas ataquem, vale o dobro do XP que aquelas criaturas dariam normalmente. Outros atos heroicos também darão XP — os valores específicos serão determinados pelo mestre caso a caso.$MDS$, array['Sessão 1']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Sessão 1 — Crônica de Mesa');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'sessao', 'Sessão 1 — Registro Objetivo', 'sessao-1-registro-objetivo', $MDS$## Resumo v3 — Registro objetivo (Registro de Acontecimentos)

### Contexto Inicial — Personagens e Ponto de Partida

A sessão envolveu dois núcleos narrativos que aconteceram no mesmo dia — um durante a tarde e a noite, outro na madrugada — e convergiram ao final nas profundezas da Cidade Baixa.

**Núcleo A:** Seraphina Altacolina (halfling bruxo, jogadora Juliana) e Válerah Dranor, sua mentora. Acompanharam também o Gnomo Mago Seebo (jogador Lazo), integrante do Circo Magnífico.

**Núcleo B:** Kadmo (meio-orc guerreiro, jogador Amós) e Bredi (humano feiticeiro, jogador Arnom), mercenários baseados no Distrito das Costas.

### Núcleo A · Tarde e Noite — A Chegada de Válerah Dranor

Válerah e Seraphina chegaram a Dranorak via estrada, junto com o Circo Magnífico. Na entrada da cidade, ao tocar uma das pedras cristalinas da ponte, Válerah revelou ter mais de trezentos anos de idade. O grupo notou a presença de filamentos orgânicos presos às estruturas da cidade e à iluminação pública — os corvos locais tentavam devorar esses filamentos. Questionada, Válerah disse não conhecê-los.

Após separar o Circo (indicando uma praça entre o Distrito de Azor e o Distrito das Costas para as apresentações), Válerah levou Seraphina ao castelo e revelou sua identidade: última descendente da família Dranor, linhagem real derrubada pelos Wiserdon há aproximadamente trezentos e cinquenta anos. Havia sido convocada pela futura rainha para participar do juramento público de lealdade — sua presença representaria o reconhecimento simbólico mais significativo que a cerimônia poderia ter.

### A Infiltração de Seebo

Impedido pelos guardas de instalar o circo, Seebo foi ao castelo buscar Válerah. Sem acesso pelos meios normais, infiltrou-se escondido entre as carruagens, fingiu ser carregador e sofreu uma queda causada por um cavalo. Foi parar num depósito, onde encontrou Betinho — halfling caçador de ratos com conhecimento das passagens internas do castelo — e um segundo indivíduo não nomeado. Seebo alegou falsamente ter sido enviado para ajudá-los e, em troca de circulação pelo castelo, ajudou a transportar caixas.

### A Cerimônia de Nomeação

O rei Dimitri II chegou ao salão antes dos convidados — para que não vissem a dificuldade que tinha para se locomover. Anunciou oficialmente sua filha como futura soberana. Diversas famílias antigas prestaram juramento. Quando Válerah Dranor se apresentou, o impacto foi notável: a última herdeira da linhagem deposta reconhecendo publicamente a nova dinastia.

A futura rainha foi também nomeada Alta Sacerdotisa do Seio de Anar — a religião oficial. Essa nomeação é o primeiro passo formal da sucessão dranoriana, que une os poderes político e religioso antes de qualquer coroação.

### O Aviso e a Fuga

De volta à torre, Válerah informou a Seraphina que a havia trazido a Dranorak para que a cidade fosse o início de uma nova fase da vida da aprendiz. Disse explicitamente que, acontecesse o que acontecesse naquela noite, não devia ser interpretado como um fim.

Seebo apareceu pela passagem secreta com Betinho. Válerah assinou a autorização do circo e pediu ao gnomo que protegesse Seraphina, justificando com a afirmação de que outros visitantes chegariam e não seriam amigáveis. Ao despedir-se de Seraphina, colocou as mãos em seus ombros e deixou uma instrução final. Seebo percebeu um movimento discreto das mãos — algo foi transferido para as roupas da halfling. O objeto não foi identificado.

Betinho conduziu os três pelas passagens internas para baixo. Válerah os alcançou mais tarde, ferida, e os levou ao Túnel do Grifo, onde ativou uma passagem mágica e os empurrou pelo portal. Betinho desobedeceu a ordem de entrar, olhou para trás e foi atingido por algo não identificável — seus olhos sofreram alteração visível, e ele morreu. Antes de a passagem fechar, os três viram Válerah em estado de combate avançado, retendo aquilo que os perseguia.

### Núcleo B · Madrugada — O Contrato do Sindicato das Costas

Kadmo e Bredi estavam numa taverna do Distrito das Costas sem recursos ou trabalho disponível quando Prestus Arlak, mensageiro do Sindicato das Costas, apresentou uma proposta: localizar dois desaparecidos na Cidade Baixa — uma halfling e um gnomo. Remuneração: mil pedras de ouro se encontrados vivos, trezentas se mortos. Cláusula contratual: sem perguntas. Os dois aceitaram.

Para localizar a entrada da Cidade Baixa, consultaram uma cartomante do Distrito das Costas — que possui vínculo não especificado com Bredi — pagando por informação. A cartomante os direcionou a um homem conhecido como O Gordo, localizado na Rua do Gato. O Gordo os conectou a Gaspar, um guarda encontrado em um bordel próximo. Gaspar revelou a entrada: pelos esgotos, seguida por uma porta oculta que dava acesso aos andares inferiores.

### Convergência · Subterrâneos — A Cidade Baixa

Seraphina e Seebo chegaram aos subterrâneos via portal mágico, aterrissando num salão de arquitetura anã com pedras cristalinas similares às de Dranorak. A habilidade de Seebo de se comunicar com animais — característica natural dos gnomos — foi útil logo de início: ele percebeu a aproximação dos ratos e identificou a intenção deles antes do ataque. Após o combate, enquanto os ratos derrotados fugiam, Seebo captou o que diziam ao escapar — que se dirigiam a uma saída ou lugar seguro. Os dois os seguiram.

Kadmo e Bredi, pelos túneis regulares, encontraram uma área dominada por fungos que guardava traços de cultivo organizado. Um miconídeo que protegia o espaço foi despertado e derrotado. A presença do miconídeo tão próximo à superfície foi registrada como um dado anômalo.

Os quatro chegaram ao mesmo reservatório subterrâneo — câmara abobadada alimentada por múltiplos canais. Kadmo e Bredi reconheceram as descrições do contrato ao ver Seraphina e Seebo. O encontro foi tenso. Antes de qualquer resolução, Kadmo tocou a água do reservatório.

### O Otyugh e os Dados das Profundezas

O contato com a água despertou um Otyugh que habitava o reservatório. Os quatro combateram a criatura juntos. No contato final dos tentáculos com Kadmo, o meio-orc recebeu imagens involuntárias: profundezas, escuridão, e um medo enorme que havia forçado a criatura a migrar para cima. Seebo examinou o corpo e, usando sensibilidade mágica, concluiu que o local era anterior à fundação de Dranorak e que alguma força nas profundezas estava deslocando criaturas milenares em direção à superfície.

### Estado ao Final da Sessão

Os quatro personagens estavam juntos ao redor do cadáver do Otyugh.
- **Válerah Dranor:** situação desconhecida após o sacrifício no Túnel do Grifo.
- **Betinho:** morto.
- **A natureza do que perseguiu o grupo no castelo:** não identificada.
- **A causa do deslocamento de criaturas das profundezas:** não identificada.
- **Relação entre os quatro personagens:** recém-estabelecida, ainda instável.

---

## Sistema de Recompensas · Sessão 1

Os jogadores receberão bônus por interpretação e por ações em combate ao longo da campanha. Abaixo, as regras em vigor a partir desta sessão:

**Inspiração** — Concedida a critério do mestre para momentos de grande destaque na interpretação do personagem.

**Bônus de XP por Interpretação** — Jogadores que se entregarem à interpretação de seus personagens — decisões coerentes com o background, reações genuínas a eventos da história, construção de relações com NPCs — receberão bônus de XP ao final de cada sessão.

**Bônus de XP por Ações em Combate** — Ações que demonstrem criatividade, heroísmo ou domínio tático dentro do combate também geram XP adicional. Um critério já definido: encerrar um combate em um único turno, antes que as criaturas ataquem, vale o dobro do XP que aquelas criaturas dariam normalmente. Outros atos heroicos também darão XP — os valores específicos serão determinados pelo mestre caso a caso.$MDS$, array['Sessão 1']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Sessão 1 — Registro Objetivo');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='ecos-na-cidade-dos-corvos'), A.id, 'sessao', 'Sessão 1 — Ecos na Cidade dos Corvos (14/06/2026)', 'sessao-1-ecos-na-cidade-dos-corvos-14062026', $MDS$Sessão de introdução da campanha. Esta pasta segue o formato padrão das sessões:
**planejamento pré-sessão** + **resumos do que aconteceu na mesa**.

## Arquivos

- **Planejamento (Introducao).md** — documento escrito antes de jogar (atos, cenas, encontros, falas sugeridas, estatísticas de monstros). Material do narrador.
- **Resumo v1 - Narrativo.md** — narrativa direta do que aconteceu.
- **Resumo v2 - Cronica de Mesa.md** — relato de como a história se desenrolou na mesa.
- **Resumo v3 - Registro Objetivo.md** — registro factual e enxuto dos acontecimentos (inclui jogadores por personagem).
- **Resumo - WhatsApp.md** — versão curta enviada ao grupo de jogadores.
- **Imagens/** — referências visuais usadas na sessão (Dranorak, Cerimônia, Valerah, monstros).

## Elenco da Sessão 1

- **Seraphina Altacolina** — halfling bruxo, aprendiz de Válerah (jogadora: Juliana)
- **Seebo** — gnomo mago do Circo Magnífico (jogador: Lazo)
- **Kadmo** — meio-orc guerreiro das Terras Bárbaras, Clã Duas Presas (jogador: Amós)
- **Bredi** — humano feiticeiro de Elódia, proscrito (jogador: Arnom)

NPCs centrais: **Válerah Dranor** (última da linhagem Dranor), **Betinho** (caçador de ratos, morto na fuga), **Prestus Arlak** (Sindicato das Costas), **rei Dimitri II**, **Shiera Wiserdon** (futura rainha).

> **Nota de curadoria:** o planejamento e os resumos divergem em pontos (no plano, "O Pupilo" e "Eduardo"; na mesa, Seraphina e Betinho; os três núcleos previstos viraram dois grupos). As divergências foram preservadas como estão — cabe ao mestre decidir o que vira cânone.$MDS$, array['Sessão 1']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Sessão 1 — Ecos na Cidade dos Corvos (14/06/2026)');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'conto', 'Cidade Abrigo de Inverno', 'cidade-abrigo-de-inverno', $MDS$> 📜 LORE / LOCAL (texto-fonte, autoria do grupo). Região de Rhumn (domínio Atom), em Dagorcain. Preservado na íntegra.

## Cidade Abrigo de Inverno

Ao norte, logo após as Montanhas Anãs e no limiar das montanhas de Gelo, fica a região de Rhumn, dominada pela família Dranoriana Atom. Uma vasta quantidade de vilarejos e aldeias prestam tributos a grande cidade Icevalle, e um desses vilarejos é conhecido como Abrigo de Inverno.

Liderada por Joramund, Earl de grande renome entre os Vilarejos de Rhumn, Abrigo de Inverno se encontra em ponto estratégico para caravanas e comitivas que desbravam o frio reino do norte, o que possibilitou o seu crescimento despontado em relação a outros vilarejos e pequenas cidades.

Joramund partiu com seu herdeiro, Sergund Ironside, para o ultimo embate contra as forças morcurianas. Deixando sua filha caçula, Jorham Shild-made como burgomestre de seu povo. A jovem guerreira é uma governante sábia e bem treinada nas artes da guerra, e com a morte de seu pai e irmão, teme a reação do vilarejo que jamais teve uma mulher como Earl.

Já não bastando o descaso dos outros Earls devido ao baixo sangue de seu pai, que não é Dranoriano, e o falecimento de seus famíliares, Jorham precisa lidar com inverno intenso que veio sem avisos, os ataques de criaturas que aumentaram devido ao defict militar da cidade, a chegada de comitivas e caravanas que necessitam de Abrigo de Inverno para chegar em Dranor. E com estas, a chegada dos feridos da grande Guerra.$MDS$, array['Conto']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Cidade Abrigo de Inverno');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'conto', 'Vixen', 'vixen', $MDS$> 📖 CONTO / NARRATIVA ORIGINAL (autoria do grupo). Preservado na íntegra.

## Vixen

A taverna costuma ser um lugar convidativo em finais de tarde. Os bardos aproveitam os dias movimentados para suas apresentações, e a gerência garante todo o tipo de oferta para os fregueses.

Vixen também é atraída por esses festejos. Trajada em couro fervido escondido debaixo de lãs negras, é impossível para ela não roubar a atenção dos homens cansados de suas esposas, barrigudas e com poucos dentes sobrando, ou dos viajantes que não vêem belas donzelas a algumas semanas.

— Qual é o nome da bela moça que tirou minha platéia?! Deixe-me compor para ti, minha dama.

Os gracejos dos bardos também era algo comum, ignorá-los não era nada mais que pura rotina. Mas havia algo de especial nesse cantor, que a impediu de sua usual falta de cordialidade.

— Talvez meu nome verdadeiro não lhe renda belas notas, porque não aproveita da sua habilidade com galanteios e me presenteie com uma balada digna da suposta beleza que viu em mim?

— Ha! A senhorita é astuta. Quanto ímpeto em meio as palavras! Em minha próxima canção serás chamada Valavë, como na língua do elfos.

A canção começou, calma e poética mas seguiu por um caminho mais épico e filosófico. Claro dom de improvisação, quase divino e as vezes mágico, da natureza desses cantores aventureiros. Ai dela se fosse como outras garotas de sua idade. Os ouvintes assobiavam e lançavam moedas ao menestrel, muitas de fato. Era quase como se ouvissem aos mestres de Aianvalley.

O arcanismo por trás das notas era quase imperceptível. Um feitiço tão sutil requer bastante habilidade. Admirável, ela teve de admitir consigo mesma. Logo após o final da canção, ela estendeu a mão com delicadeza ao alcance do Bardo, e disse:

— Agora eu que lhe indago, qual o nome de tão formidável cantor?

— Brandonm, minha senhora! Será que agora mereço saber o teu? – disse ele acolhendo a mão oferecida com um beijo caloroso.

— Hm, como me chamava na sua canção? Valavë? Divina. Acho que gostaria mais de ouvi-lo me chamar assim.

— Que assim seja então. Aceita sentar-se comigo, senhora Valavë?

— Com prazer.

Não foi muito difícil induzir o cantor a beber além da conta. Assim como conduzi-lo para os quartos da taberna. As vezes seu trabalho era proveitoso, o jovem afinal era belo de rosto e de porte. Logo estavam quase despidos, em meio a beijos lascivos. Brandom demonstrou-se experiente na arte de desatar corseletes, assim como habilidoso quando já estavam sobre os lençóis.

Assim que o rapaz adormeceu, ela se levantou esgueirando-se no quarto. A bebida e o coito garantira um sono pesado ao Bardo. A luz do luar iluminava o quarto, enquanto uma leve brisa ouriçava a pele nua da moça. Vasculhou seus pertences, afanou as moedas, e encontrou o que realmente procurava. Escondido em um dos compartimentos da bolsa do aventureiro estava um modesto livro. Sem adornos na capa, folhas unidas por cordões de crina, o grimório seria facilmente ignorado por guardas em qualquer cidade de Falldragon.

O ultimo dos sete arcanos, finalmente encontrado. Quantas moedas a Rainha não lhe ofereceria por ele. Só o rápido pensamento lhe gerou ansiedade. Ela cobriu o livro com panos e o e amarrou com as cordas seguravam as calças de seu amante. Surrou na língua antiga, e em um estalar de dedos estava vestida. Beijou levemente o rosto de Brandom, e lamentou ter surrupiado seu ganha pão.

Ao abrir as janelas aproveitou o cheiro da madrugada, e por um minuto se deliciou com os sons do vespertino. Não haviam passos nas ruas, ou gritos nos mercados. Apensa o silêncio ornamentado com os tênues sons do ressonar da natureza. Aquela sensação de liberdade.

Mas não haviam tempo para aproveitar mais, o sol não demoraria para nascer, e a Senhora da Magia lhe aguardava.$MDS$, array['Conto']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Vixen');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Capítulo 1 - O Principio', 'capitulo-1-o-principio', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-14 · marcadores: História, Pré-história
> Fonte: https://maresdesangue.blogspot.com/2013/04/o-principio.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhCN9eujam2nUG-a9c0_lbmJzc8a5nDhyphenhyphenBTfyVD2e7P3UVkJ4gSuYZkwaR0QJdtEgONE-mcgRzNr21PGpiINNAe0P4ycb7oyfSYLbYZbW6oUZSOX3iobT_CvqzZVz6ujz3VhP0MOzSn9NnY/s400/1072228_259665480825464_1635658461_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhCN9eujam2nUG-a9c0_lbmJzc8a5nDhyphenhyphenBTfyVD2e7P3UVkJ4gSuYZkwaR0QJdtEgONE-mcgRzNr21PGpiINNAe0P4ycb7oyfSYLbYZbW6oUZSOX3iobT_CvqzZVz6ujz3VhP0MOzSn9NnY/s1600/1072228_259665480825464_1635658461_o.jpg)

</div>

  
  
Quando os dias ainda não eram contados, os deuses moldaram e lutaram pelo o Mundo criado pelos Primordiais, os Males Caóticos vieram com o intuito de destruir tudo o que os deuses criaram, mas naquele mundo havia algo diferente de tudo que já havia nascido ou destruído, vida.  
  
  
Os deuses dali buscavam adoração, e os Males desejavam o domínio, e houve grande guerra, os deuses defenderam o Mundo como puderam e o sangue da batalha encheu o único mar imenso do mundo que rodeava um único e gigantesco continente, até que um dos lideres dos bons deuses lutou contra a maior abominação criada pelos Males, feita para devorar e subjugar tudo o que os deuses haviam criado, pois se os Males não dominassem a destruição deveria ser seu destino.  
  
  
Nessa luta o poderoso dos deuses caiu, mas antes deixou a criatura desprovida de quase toda sua força. O deus caiu sobre o mundo, enquanto caia teve uma visão das criaturas que ainda despertariam e viu que as forças caóticas malignas continuariam a atormentar os filhos dos homens e de outros seres, então, antes que sua consciência fosse mandada para os palácios dos deuses mortos, uniu seu poder ao da criatura que derrotara, se desfez em pura energia e banhou o mundo com ela, para que as criaturas que ali existissem aprendessem a manipulá-la e desse modo também se defendessem, pois ele também previu o desdém de muitos deuses sobre a vida do novo mundo.  
  
  
Mas para banhar todo mundo precisou usar do poder maligno da criatura, e esse também se espalhou, e assim, as forças Caóticas Elementares e o terrível poder do Pendor das Sombras se espalharam no mundo, a vida, seja maligna ou abençoada, nasceu. E todas as criaturas começaram a despertar e se movimentar no grande continente.  
  
  
Ora, o poder da criatura somada ao do deus caído era grande demais para se conter no mundo. As duas batalhavam como o deus e a criatura quando estavam vivos. Assim, o conflito dessas duas forças deixaram marcas no mundo e criaram a vida como ela é. Mas essas forças após muito lutarem deixaram a presença uma da outra, era como se um resquício da mente do deus e da criatura ainda existissem, e fugindo para o vazio se tornaram densas como se estivessem guardado uma imagem do mundo original, se transformaram em ecos do que o mundo original era, mas moldados a partir da natureza das energias. E estes mundos foram conhecidos como o Pendor das Sombras e a Agrestia das Fadas, aonde cada um refletia uma face do mundo original.  
  
  
Mas a guerra nos campos fora do mundo não tinha acabado, e a criatura dos Males caóticos já muito enfraquecida foi destruída e seus restos espirituais lançados entre as dimensões, e o fim da guerra foi tão violento que o mundo perdeu sua configuração original e se dividiu em vários continentes cercados e separados pelo grande mar de sangue.  
  
  
Os deuses e os males se detiveram e pararam a luta, para que menos danos fossem causados e ambos conquistassem seus objetivos. Um tratado foi feito, pois já que nasceram vidas e vidas, tanto dos caóticos males quanto do poder dos deuses, eles permitiriam a elas escolher quem adorar, e as guerras não seriam mais entre os deuses mas entre os seres em adoração ao lado que escolhessem.  
  
  
E assim iniciou a primeira grande Era do mundo, do qual não existem memórias, pois seu fim, após mais de quarenta mil anos, se deu em uma terrível batalha que quase destruiu toda a vida no mundo, pois os deuses por um momento lutaram de novo e o resultado foi devastador.  
  
  
Apenas os Mestres Eladrins se lembram dessa guerra e em suas bibliotecas guardam os últimos relatos daquele tempo. Os Feéricos tiveram muita importância nessa Era, quando os Homens ainda eram jovens e perambulavam nas cidades dos Elfos, foi nesse tempo que ouve a divisão e ódio entre as famílias de Agrestia das Fadas. Muitas raças ainda não tinham surgido e os Eladrins foram à maior força usada pelos deuses contra os Demônios e Lordes dos Nove infernos, que tentaram destruir a criação.  
  
  
Muitos continentes foram arrasados, e muitos que eram vazios se encheram, pois os povos fugiam para as bandas sul do mundo, pois a guerra dos deuses e demônios se travou no norte e teve fim quando os demônios foram banidos novamente. Muitas nações e raças se perderam ou foram esquecidas, e o conhecimento se foi junto com elas, apenas nas terras de Agrestia, ou no mundo dos deuses, ainda são guardados muitos contos desse tempo antigo.  
  
  
E a segunda Era se iniciou, mas dessa vez os continentes não mais buscaram se comunicar, em muitos casos viveram sem saber da existência um dos outros. Mas a história nessa Era se voltou para o Continente de Dagorcain, ou Dagor popularmente, aonde muitos diziam ter sido o lugar onde a massa das energias do deus havia caído inicialmente e se espalhado, e lá a magia era mais potente do que em qualquer outro lugar. Também fora o continente mais afetado pela guerra da criação, pois provavelmente fora o centro do Super Continente que existiu na primeira configuração do mundo.$MDS$, array['História']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Capítulo 1 - O Principio');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Capítulo 2 - A Grande Guerra dos Magos', 'capitulo-2-a-grande-guerra-dos-magos', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-14 · marcadores: História
> Fonte: https://maresdesangue.blogspot.com/2013/04/os-primeiros-fatos-de-dagorcain-e.html

<div style="text-align: justify;">

<div style="text-align: left;">

  
  
[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiNrwMEo-MB1AaFxqqiuNlgg943F61wYLbFSGbURi5PLW7DYCxB1DlDzyHA0WowMQ1Uf8virsY8P4G-nHZJx_94vBsJ1KxGAbI_f2F3eJML0UWIDhRemcc0pf5CXtKACLuxYtAEWAt88wCV/s400/621999_341545189314141_1471822591_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiNrwMEo-MB1AaFxqqiuNlgg943F61wYLbFSGbURi5PLW7DYCxB1DlDzyHA0WowMQ1Uf8virsY8P4G-nHZJx_94vBsJ1KxGAbI_f2F3eJML0UWIDhRemcc0pf5CXtKACLuxYtAEWAt88wCV/s1600/621999_341545189314141_1471822591_o.jpg)       Muitos seres durante a terrível guerra contra os Demônios que definiu o final da Primeira Era fugiram para Dagorcain que ficava mais ao centro do mundo enquanto a guerra ocorria no norte nas terríveis terras geladas, que provocou grandes inundações e terríveis vapores que vinham de vulcões escondidos debaixo do gelo, que acionados pelo poder dos deuses e seres que lutaram mancharam a luz do sol com cinzas que desolaram o mundo, e definharam muitas vidas.

</div>

<div style="text-align: left;">

      Mas o céu foi limpo pelos deuses e as raças puderam seguir novamente suas vidas. E muitos costumes se mantiveram, mas os feitos passados foram esquecidos entre as gerações, pois os registros e escrituras foram abandonados por muito tempo. E as raças voltaram a crescer e prosperar nessa nova Grande Era.

</div>

<div style="text-align: left;">

        E como foi dito, a magia em Dagorcain era mais intensa do que em qualquer outro lugar e muitos magos surgiram no continente,  uma grande ordem foi formada e se manteve por quinhentos anos com aprendizes e reinos. Mas grande contenda aconteceu entre os magos, pois os deuses disputavam sua adoração e muitos escolheram o Pendor das Sombras como fonte de poder, e houve discórdia entre o grande reino dos Magos que fora maior que qualquer outro reino que tenha existido no continente, pois sua vastidão ocupava toda a floresta indo de leste a oeste do continente, só não avançando os extremos norte e sul.

</div>

<div style="text-align: left;">

       A contenda teve inicio, uma terrível guerra foi travada, pois o continente se dividiu e os Magos do Caos Elemental eram em sua maioria das raças feéricas, e tinham Anões, Homens e seres benignos ao seu lado. Mas os Magos do Pendor das Sombras, conhecidos como Magos Sombrios, contavam com o auxilio de raças malignas e seus enxames, com exércitos formados por Orcs, Goblins e seus parentes, Minotauros, Ogros e outras criaturas invocadas e movidas pelo Pendor das Sombras. E a guerra durou cerca de seiscentos anos, quando finalmente os Magos das Sombras fugiram para o extremo leste.

</div>

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiWluBwn3IcTI3_aUKyf1EEhZrF7TqtgcfjkjUbTtL3GlHCYsutkYTFR3VGnBI9NHcweo0rYMSHKnK61XAvq-VSQfq2VEaS4UYh6d4i8Q9lsN3SRpNNg0fGjOe1DOuzCtHzIy8Xtg1GUbCB/s640/943645_637857482892620_1246045748_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiWluBwn3IcTI3_aUKyf1EEhZrF7TqtgcfjkjUbTtL3GlHCYsutkYTFR3VGnBI9NHcweo0rYMSHKnK61XAvq-VSQfq2VEaS4UYh6d4i8Q9lsN3SRpNNg0fGjOe1DOuzCtHzIy8Xtg1GUbCB/s1600/943645_637857482892620_1246045748_n.jpg)

</div>

        Antes de persegui-los os Magos temeram mais mortes pois as quantidades de vidas perdidas foram tantas que nunca mais qualquer um dos lados chegará a um quarto do poder e quantidade que já tiveram um dia. Usaram uma poderosa magia que separou parte do continente, que ia do extremo leste fazendo uma curva ao norte, isolando a principal força e lideres dos Magos negros do continente naquela nova Ilha, e ergueram grandes Montanhas no continente que formavam uma barreira na região de Morcul a mais afetada pela guerra e magia do Pendor, e estas eram as Ered Gorgoroth, as montanhas do Terror Constante. E o Grande Reino dos Magos teve seu fim para nunca mais existir.

</div>

<div style="text-align: left;">

     Muitas criaturas não conseguiram reagrupar no leste com os Magos Sombrios, e ficaram soltos no continente. Os Magos Elementais sentiram que não deviam exterminá-los pois apenas aos deuses era dado esse direito, mas podiam buscar controlar sua multiplicação exagerada. Os Orcs, a raça que já foi à maior força do Continente, foram usados em muitos casos como escravos ou eram como selvagens em florestas obscuras. Mas entre os Orcs e homens uma nova raça surgiu, esses eram os Meio Orcs que no futuro tiveram grande poder e importância política, pois eram menos violentos e mais diplomáticos do que seus parentes.

</div>

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiypsq4FmEj-105_rNbne84hTtgldZ5zhmlQiDd8dLPgq2ITEdi1iGb-OQHwQFDHSD6nbRlvnKWaMnYofDCnrUFONh_QNwlScaaWNMNx0hK0d_PG-9qei885bPjwkG6xdES1mHAZ9b8_P1N/s400/1000504_262067247251954_530853630_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiypsq4FmEj-105_rNbne84hTtgldZ5zhmlQiDd8dLPgq2ITEdi1iGb-OQHwQFDHSD6nbRlvnKWaMnYofDCnrUFONh_QNwlScaaWNMNx0hK0d_PG-9qei885bPjwkG6xdES1mHAZ9b8_P1N/s1600/1000504_262067247251954_530853630_n.jpg)

</div>

       As raças fundaram seus próprios reinos, os feéricos fortificaram a floresta e os Anões cresceram nas montanhas; os Homens se espalharam entre elas e criaram um poderoso reino no Norte, que no futuro será o maior poder militar do continente. E as bestiais, como Gigantes, Golias e seres mágicos variados, cresceram em seus habitats. E raças antigas como Lobisomens e seus parentes distantes Ferais, ressurgiram pela influencia dos deuses. E graças aos Magos Sombrios as pragas mágicas, como o vampirismo e a magia negra e seres do Pendor das Sombras, também se espalharam no continente.

</div>

<div style="text-align: left;">

      Os outros continentes cresceram de forma parecida, mas aos Homens e seres feéricos foi dada grande benção reprodutiva e de longevidade e aos Anões a resistência e fácil adaptação, benção repetida nos homens, que  lhes garantiu lugar entre as raças predominantes no Mundo. E esses serão importantes personagens nas Guerras virão, seja nos tempos de continentes exilados, ou nas Grandes Guerras que envolveram novamente os continentes vizinhos a Dagorcain.

</div>

</div>$MDS$, array['História']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Capítulo 2 - A Grande Guerra dos Magos');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Capítulo 3 - Sobre Dranor', 'capitulo-3-sobre-dranor', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-14 · marcadores: História
> Fonte: https://maresdesangue.blogspot.com/2013/04/sobre-dranor.html

<div style="text-align: justify;">

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixKlcJdcZMJ2vSWL73Yjopfqcok1OxXfPfTHuXe9AUKHcdsmuATP9jNcq1Rjh7RCjO6EIzrT7rUzBFF4mUxWM7RLRg-kZjvtTmXq4A7MwpI2dVuPnv3GFlJvIhoNaYSbC_rmNJZWT4cJle/s320/1267032_163627637176691_2140433233_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixKlcJdcZMJ2vSWL73Yjopfqcok1OxXfPfTHuXe9AUKHcdsmuATP9jNcq1Rjh7RCjO6EIzrT7rUzBFF4mUxWM7RLRg-kZjvtTmXq4A7MwpI2dVuPnv3GFlJvIhoNaYSbC_rmNJZWT4cJle/s1600/1267032_163627637176691_2140433233_o.jpg)

</div>

        Há muito, em tempos próximos a queda do Reino dos Magos, Homens Fortes se aventuraram nas terras frias no extremo norte de Dagor, e lá se instalaram, pois uma grande nevasca se abateu sobre eles e ficaram presos. Muitas famílias tinham ali, de um povo que poucos conhecem sua origem, dizem que eram navegantes de terras fora do Continente e durante a Era dos Magos chegaram a Dagorcain e viveram em ilhas ao Sul, mas lá empobreceram e se lançaram ao Mar rumo ao Norte.

</div>

<div style="text-align: left;">

        Eles ficaram conhecidos como Wikinings, que em uma língua antiga significava Marinheiros Perdidos. Mas eles não eram homens comuns, eram um povo antigo, famílias de homens que sobreviveram aos combates na guerra contra os Demônios e heróis de histórias épicas. E muitos deles viram a olho nu os próprios deuses lutarem contras as forças demoníacas. E diziam que aquela batalha fez com que seus capitães transcendessem a humanidade, mas ali muitos morreram ou se uniram aos deuses. E os poucos sobreviventes seguiram em uma vida Errante e Perpétua com suas famílias, em busca de continentes ainda sustentáveis.

</div>

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEivcVNIGDZ9gRkTHgoobAywftc88wAa2QhX6eLg3CEE0sFRFIwrQyQEvfDIxTPXg71kdHGBFxSxStVgFnqvS6oN2q5qG5xi-zExRCJx99KrV9dLBPV20VLL2Bn1JiV1NfHB4RsAfLiDHDuQ/s320/1234199_156959677843487_1417836835_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEivcVNIGDZ9gRkTHgoobAywftc88wAa2QhX6eLg3CEE0sFRFIwrQyQEvfDIxTPXg71kdHGBFxSxStVgFnqvS6oN2q5qG5xi-zExRCJx99KrV9dLBPV20VLL2Bn1JiV1NfHB4RsAfLiDHDuQ/s1600/1234199_156959677843487_1417836835_n.jpg)

</div>

       Entre eles um nome se tornou imortal, Dranor, o grande. Os Homens do Norte diziam que ele foi um general entre os Feéricos, das esquecidas guerras contra os Demônios e perdeu quase toda sua família, restando apenas dois de seus filhos. Seu continente foi arrasado na Guerra e reunindo o que restou dos Homens, viajaram pelo mar de Sangue até Dagorcain, e apenas doze famílias vieram com ele, todas de soldados que o servira.

</div>

<div style="text-align: left;">

       Muitas lutas enfrentaram nas terras geladas do norte, muitos males também alcançaram o Continente fugindo da fúria dos deuses, mas nenhuma eles perderam. Seus Homens eram altos e robustos, não tinham a aparência grosseira e feia dos Anões, mas se assemelhavam em porte e em suas barbas. E vieram a eles Anões que viviam no Norte e fizeram aliança, e por um tempo essas famílias viveram em casas Anãs. Trabalharam, e à custa de seu suor começaram a construção de sua própria cidade.

</div>

<div style="text-align: left;">

        E assim, uma nova cidade chamada Anar se ergueu sobre o gelo. E mais ao sul dali, existiam clãs de elfos e homens que se mudaram para as proximidades da cidade,  lá se fixaram e Dranor foi declarado rei sobre aquelas terras. E mesmo os Anões, que se apegaram aqueles homens que mais pareciam anões espichados, também reconheceram Dranor como rei e aliado pois grande amizade nasceu entre Dranor e o Rei dos Anões do Norte.

</div>

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixcPOMdb7As95zF2zx-Nka7vQkU9UAmRt5PKcbO6fXjFWVfppCSiiNnxECzxjcNIwxmjOMEXrCSjXWWzQ7xlRO8l4jBPx_oqTqkL5hN5-ra8EEX3rg59xltNTXDA3DTgPFTD1zrXNhp6SH/s320/1012204_143823805823741_1823916312_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixcPOMdb7As95zF2zx-Nka7vQkU9UAmRt5PKcbO6fXjFWVfppCSiiNnxECzxjcNIwxmjOMEXrCSjXWWzQ7xlRO8l4jBPx_oqTqkL5hN5-ra8EEX3rg59xltNTXDA3DTgPFTD1zrXNhp6SH/s1600/1012204_143823805823741_1823916312_n.jpg)

</div>

        Os Homens de Dranor voltaram a construir seus barcos e, com a ajuda dos anões, refinaram sua arte e passaram a navegar com navios fortes sobre as águas geladas. E lá praticaram a caça de animais marinhos, acreditasse que era uma pratica comum para eles em suas antigas terras. Desses animais aprenderam a extrair óleos e outras iguarias, que foram usadas para criação de lamparinas, forjas, trabalhos com metais, práticas arcanas, e muitas outras utilidades ela tinha.

</div>

<div style="text-align: left;">

        O comercio entre os Reinos sob a ordem dos Magos se virou para aquela cidade, trabalhadores para lá se mudaram e novos povoados se instalaram naquela região. Os próprios Anões se beneficiaram com aquelas iguarias, e com pedras preciosas pagaram os homens.

</div>

<div style="text-align: left;">

        De uma pequena cidade um forte estado se formou. E Dranor enriqueceu, teve esposa e filhos, e os povos se misturaram com as Famílias de Dranor. Mas o sangue daqueles homens e mulheres era superior e uma chama de poder vinha deles, e mesmo o sangue feérico era subjugado, até os meio elfos nasciam com poucas características feéricas, mesmo as orelhas pontudas lhe eram privadas, raríssimos casos foram diferentes.

</div>

<div style="text-align: left;">

        Este sangue não enfraquecia com o tempo, mas se tornava cada vez mais superior. E os magos viram magia sobre aqueles homens, acreditaram que seu sangue foi abençoado pelos deuses.

</div>

<div style="text-align: left;">

Mas uma grande guerra alcançou o rei de Dranor. Orcs, milhares que se multiplicaram nas montanhas da floresta junto com Goblins e seus primos, tentaram invadir as terras do norte. Os Homens estavam em desvantagem numérica e muito sangue foi derramado ali. Se não fosse pela força dos anões, aquele povo teria caído.

</div>

<div style="text-align: left;">

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh0trFNgRDO4J58NZlmmfCtI0ITrciofjVEmInGF8Ewz_Mjhoq30p3hngMZm1DnHYj4cd2C7z7qKDphi_rxGUo9kwlF2KQSC6jnIYYa_NOPoaEfwas2DdJMqftu1rRUdk1XGpTTIlYhJAMo/s320/21091_240448916080454_1025724720_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh0trFNgRDO4J58NZlmmfCtI0ITrciofjVEmInGF8Ewz_Mjhoq30p3hngMZm1DnHYj4cd2C7z7qKDphi_rxGUo9kwlF2KQSC6jnIYYa_NOPoaEfwas2DdJMqftu1rRUdk1XGpTTIlYhJAMo/s1600/21091_240448916080454_1025724720_n.jpg) |
|                                                                                                                                                                                                                                                      Rei Dranor                                                                                                                                                                                                                                                      |

        Dranor decidiu que o comercio enfraqueceu seu povo, e recolheu as principais famílias para mais ao Norte, e foram morar em uma cidade portuária. Essa cidade não comercializava, mas usava de terceiros para vender seu produto. E todas as cidades que ficavam atrás das colinas anãs se focaram no militarismo, e Dranor treinou e organizou um grande exercito. Ele construiu Fortes e definiu as Fronteiras de seu Reino. Espalhou suas forças ao sul, próximo aos rios de frente as Montanhas dos Anões e lá construiu cidades para que comercializassem pelo seu reino e ao mesmo tempo servissem de defesa.

</div>

<div style="text-align: left;">

        Essa região é hoje chamada de Dranor, que depois das guerras bestiais, voltou a ser exatamente como o Rei Dranor originalmente a conquistou. Dranor reinou por cem anos e seu exercito se tornou inigualável. Seus homens tinham a destreza e habilidade comparadas com a dos Feéricos, e eram resistes e fortes como os Anões. A linhagem de Dranor até hoje está entre os Reis e Governantes Dranorianos.

</div>

<div style="text-align: left;">

       Os anões firmaram uma amizade e aliança eterna com os Dranorianos que muito aprenderam com os mestres Anões, mas já eram grandes armadores e construtores, suas embarcações eram usadas em todo o continente, pois eles deram inicio a esse costume e receberam muito ouro em troca de seus barcos, mas nenhuma outra raça os conduziu com a maestria dos Marinheiros Dranorianos.

</div>

<div style="text-align: left;">

       Mesmo dentro de sua política militar os Dranorianos tinham cidades ricas e belas. Pois a construção era uma de suas especialidades, muitas culturas ali se misturaram trazendo maior variedade arquitetônica. Muitas estradas foram construíram entre as cidades e os feéricos que para lá viajaram deram aos homens lamparinas que não apagavam, eram como cristais que tinham luz própria que foram colocados nas cidades e nas estradas.

</div>

<div style="text-align: left;">

        E muito altas são as Torres e muralhas dos Dranorianos, sobre as bases das montanhas anãs eram construídas barreiras e casas de vigia. Seus muros iam tão alto que se diziam ser alcançadas apenas pelo voo da águia. E as cidades também eram assim, enormes e altas, os Dranorianos amavam os céus. A cidades eram cheias e seus exércitos eram vastos. Muito belo foi o Reino de Dranor, que morreu velho quando finalmente a idade o alcançou,  a velhice de Dranor e seus descendentes são diferentes dos demais tipos de humanos, pois apesar de grisalhos se mantém fortes e de bom animo até o fim atingindo idades avançadas, para lá dos trezentos anos de idade. E assim sempre será no grande Reino de Dranor.  
  

<div class="separator" style="clear: both; text-align: center;">

</div>

  
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgbhXHkttO1z55ocYB2YACvUOJeuTpq2QMV19h_xNtxm-9fvIsAMFX3JAvbDjANcTrmV_KAVCDqOFwx8to4ymFuHxz1qfgkweS1HSIBblTP-C2UdUj_TxisZQVwyRfFOc9a-eD1vSGtgwo4/s640/965304_140698592802929_2072522893_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgbhXHkttO1z55ocYB2YACvUOJeuTpq2QMV19h_xNtxm-9fvIsAMFX3JAvbDjANcTrmV_KAVCDqOFwx8to4ymFuHxz1qfgkweS1HSIBblTP-C2UdUj_TxisZQVwyRfFOc9a-eD1vSGtgwo4/s1600/965304_140698592802929_2072522893_o.jpg)

</div>

  

</div>

</div>$MDS$, array['História']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Capítulo 3 - Sobre Dranor');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Capítulo 4 - Guerra dos Cem Anos', 'capitulo-4-guerra-dos-cem-anos', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-14 · marcadores: História, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/04/guerra-dos-cem-anos.html

<div style="text-align: justify;">

<div style="text-align: left;">

       Passado quase um milênio desde a primeira guerra contra os Magos Sombrios, que não eram mais que lendas naquele tempo, Dagorcain estava cheio de vida e variadas raças perambulavam e reinavam nas regiões do Continente. Os Homens eram a maior raça, pois se multiplicavam mais rápido que qualquer outra e se adaptavam e espalhavam, só não se comparam aos Goblins, Orcs e Kobolds, que pareciam mais pragas que se alastravam em ambientes mais sombrios.

</div>

<div style="text-align: left;">

       Os Homens também foram responsáveis por mesclar muitas raças, e deles nasciam meio sangues entre os Feéricos ou Bestiais, que também se espalharam no meio de seus parentes. Mas a maior força dos Homens era a região chamada Dranor, pois lá, Homens Fortes e robustos se multiplicaram e formaram uma poderosa força militar, e apesar de não serem os melhores manipuladores de magia tinha armas inigualáveis, pois tinham aprendido o oficio dos forjadores Anões que viviam livremente em sua terra.

</div>

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEij9HdYHuZ_uHK76qGaIx3X0aHdlGgB4WWVznkRGdV2kJylrGIri19LXc1ZGiD4WkLwPG4g5E-Qyr-yDLWuTkBSSTFXQeqejrw4wsFlKiAkYxtChWX-3aNGqi690mDuXT6Mx3JBfX-CyYdE/s320/11495_386459654815127_895964386_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEij9HdYHuZ_uHK76qGaIx3X0aHdlGgB4WWVznkRGdV2kJylrGIri19LXc1ZGiD4WkLwPG4g5E-Qyr-yDLWuTkBSSTFXQeqejrw4wsFlKiAkYxtChWX-3aNGqi690mDuXT6Mx3JBfX-CyYdE/s1600/11495_386459654815127_895964386_n.jpg)

</div>

       Os Anões se dividiram em três Casas no Continente, e se espalharam em três regiões montanhosas, ao Norte, Sul e Oeste. Os Anões do Norte eram grandes forjadores e seus salões eram frios e ricos, e eles eram aliados e amigos dos Homens do Norte, e viviam livres nas terras de Dranor. E essa aliança foi poderosa, pois os Dranorianos,eram fortes e poderosos e combinando isso as habilidosas artes dos Anões de Dranor formaram um reino inigualável, poderoso o suficiente para dominar, em um momento de fraqueza das outras raças, todo o Continente.

</div>

<div style="text-align: left;">

       Os Anões do Sul eram uma força armada também muito poderosa e rica. Eram os maiores comerciantes e também os mais individualistas, era proibida a entrada de qualquer outra raça em seus domínios nas Montanhas a menos em casos de negociação com Reis e Governantes, e mesmo isso era evitado. Defendiam a região Sul da floresta, próximo as Praias Brancas, e eles iniciaram o costume Anão de fundar ou custear o crescimento de cidades nas bases das Montanhas de seu Reino, que eram usadas como centro comercial para que não fosse necessário que outros adentrassem seus Salões. E essas cidades sempre eram extremamente ricas e fortes.

</div>

<div style="text-align: left;">

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiHJUT7I7cJ3CmuLVw5J2SYCdze9DgX_tQZ83WkRWlA30EqbEVXN60rJ3IkeueEjyA3NK7bk1yM1IVaHD5GI4aTqh9QneuRDjRzDgBIIoZYjBcPrnaOU6saDmpwlJNtrxDnRoAYxWxR6EKp/s320/6482neverwinter_art_060711_09.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiHJUT7I7cJ3CmuLVw5J2SYCdze9DgX_tQZ83WkRWlA30EqbEVXN60rJ3IkeueEjyA3NK7bk1yM1IVaHD5GI4aTqh9QneuRDjRzDgBIIoZYjBcPrnaOU6saDmpwlJNtrxDnRoAYxWxR6EKp/s1600/6482neverwinter_art_060711_09.jpg) |
|                                                                                                                                                                                                                                                   Elódia                                                                                                                                                                                                                                                   |

        Os Anões do Oeste, o Povo de Dirnem, eram os mais amistosos e liberais. Suas mansões eram ricas e belas, apesar de menores que as de seus parentes, mas comercializavam de bom grado com outras raças e muitas festas realizavam em suas casas, reuniam várias raças consigo nessas ocasiões. Eram grandes Arquitetos, construtores e Mineradores, e seu comercio era forte mas se mesclava com outras cidades, e isso lhes impediu de enriquecer e se tornarem maiores que os outros reinos Anões.

</div>

<div style="text-align: left;">

        Outras Casas se formaram com os anos, mas essas são histórias que não serão contadas aqui. Pois nesse tempo, a Região desolada de Morcul foi coberta por uma nuvem negra, e trovões e clarões vinham de lá,  parecia que fogo era lançado no meio das nuvens.  Muitos temeram e tomaram como um alerta.

</div>

<div style="text-align: left;">

        No final da Primeira Guerra contra os Magos Sombrios, os Magos Elementais restantes decidiram que sua Ordem não deveria caminhar para o desaparecimento, muitos conhecimentos haviam sido salvos durante a guerra e se não fizessem algo provavelmente a ordem se dispersaria. Então, decidiram fundar a Grande Escola de Magia, que relembrava tudo o que um dia fora o Reino dos Magos. Muito conhecimento se perdeu, mas seus membros continuaram em beleza e poder comparados ao que foram os Grandes Magos.

</div>

<div style="text-align: left;">

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjl3-_pk4cosJq87cJyprf38dSUxV4SzE6rjqxPKHkO1vqVN-4Twe1GZYvKJjuI4wg-YJmLwdO-HvJnB3WCvxFsmQMmC-oBSOOXo7q6mUEej51ijAulQP2WzyVq7kKeuCyRLt7kxJwU2gcn/s320/1293063_158525174353604_622114204_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjl3-_pk4cosJq87cJyprf38dSUxV4SzE6rjqxPKHkO1vqVN-4Twe1GZYvKJjuI4wg-YJmLwdO-HvJnB3WCvxFsmQMmC-oBSOOXo7q6mUEej51ijAulQP2WzyVq7kKeuCyRLt7kxJwU2gcn/s1600/1293063_158525174353604_622114204_o.jpg) |
|                                                                                                                                                                                                                                                   Exercito de Morcul                                                                                                                                                                                                                                                   |

       E foi a Escola de Magia da ultima cidade grande cidade dos Magos, Elódia, que tomou a iniciativa de proteger o continente do que eles previram ser a volta dos Magos Sombrios. Apesar de surpresos, pois esperavam que o Feitiço que conjuraram ao construir a muralha de Ered Gorgoroth, as montanhas que circundavam Morcul, era suficiente para deter qualquer tentativa dos magos exilados de passar. Mas eles não previram que os Sombrios teriam tanto poder e resistiriam à barreira. E assim foi, pois os Magos das Sombras estavam retornando e a planície de Morcul agora era habitada pelos exércitos inimigos e a invasão estava começando.

</div>

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgYlFWt4qUWyTJIuszVc4X856EGKVIXULwt9s5_fW2ZKb3UCWx-d-QlnFBWDvND7cCIhGtBQcT2hgeDn0Ttw4d49g9RxnP0yHIDK4AJButksA6g0sa_9oV4Ax8RkZkuKvQv9UhZ6Xjz8Gmd/s320/1237254_346443145491012_2034178104_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgYlFWt4qUWyTJIuszVc4X856EGKVIXULwt9s5_fW2ZKb3UCWx-d-QlnFBWDvND7cCIhGtBQcT2hgeDn0Ttw4d49g9RxnP0yHIDK4AJButksA6g0sa_9oV4Ax8RkZkuKvQv9UhZ6Xjz8Gmd/s1600/1237254_346443145491012_2034178104_o.jpg)

</div>

       Os Magos novamente cumpriram o seu papel de generais e controladores da batalha, eles lideraram as tropas do exercito formado pela aliança das Raças contra Morcul. Os únicos que negaram parte do auxílio da Escola foram os Homens e Anões do Norte, que naquele tempo não só dominavam Dranor como também todo o Extremo Norte, fazendo a curva Leste-Oeste, e adentrando muitos reinos na Floresta e nos descampados depois delas, e seu reino findava na nascente Norte do Rio Divisa. Poderosa foi essa Guerra, nesse tempo mesmo os Drows se uniram a Escola de Magia e as forças do Continente, mas as forças dos Magos Sombrios eram muito numerosas, e seu poder de terror era denso e destruidor.

</div>

<div style="text-align: left;">

        Porém os Sombrios perderam sua maior força aliada, os Minotauros, pois estes criaram amizade com os Magos do Continente, que os ensinaram muito e fizeram alianças. Mas os Minotauros não serviam a ninguém, e se mantiveram neutros na Guerra, fizeram um acordo com os Sombrios que continuariam neutros se suas terras não fossem tocadas durante a guerra, ou depois. E por cem anos as batalhas continuaram, e muitíssimos feitos foram realizados ali, muitos heróis se ergueram e incontáveis batalhas mancharam os campos do Rio Divisa, e alcançaram as florestas.

</div>

<div style="text-align: left;">

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqE3Z1H2zFIT1Esj2LoE6lRV35nRAygS0Alkj_9sS2dzQqlEo4AAwWJKb7JKtLwW3gPCr-BQCMFpdU8yLb3on9AAXD6fdLR0wVMRu4e82Lsj2pj-v5uG25hHTMLegaZfa4LceOlYvCmk6x/s320/537240_666840736659921_1481005568_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqE3Z1H2zFIT1Esj2LoE6lRV35nRAygS0Alkj_9sS2dzQqlEo4AAwWJKb7JKtLwW3gPCr-BQCMFpdU8yLb3on9AAXD6fdLR0wVMRu4e82Lsj2pj-v5uG25hHTMLegaZfa4LceOlYvCmk6x/s1600/537240_666840736659921_1481005568_n.jpg) |
|                                                                                                                                                                                                                                                      Minotauros\!                                                                                                                                                                                                                                                      |

       Ora, as Terras de Minos eram ricas e os minotauros fortes soldados, os Magos Sombrios esperaram o tempo em que suas forças estivessem acima dos poderes do continente e sua vitória quase certa para tentar dominar Minos. E nos últimos quatro anos da guerra eles invadiram as terras dos Minotauros, porem o Senhor dos Minotauros fora avisado pelos Magos da Escola que eles seriam traídos no final, e preparou uma força por precaução. Os Magos Sombrios foram surpreendidos pelas forças de Minos, e pela traição de Morcul o Senhor dos Minotauros declarou guerra e invocou de seu povo e os Minotauros das florestas, um exército monstruoso, que lutou sem precisar de auxilio contra as forças Sul de Morcul e as empurrou para as montanhas Gorgoroth.  
  
        Os Magos Sombrios  ficaram desbaratados, e quando finalmente recuperaram a ordem e reuniram suas forças os Dranorianos e as forças lideradas pela Escola de Magia tiveram tempo suficiente para se agruparem, e fizeram um ataque massivo pela frente norte rechaçando as forças dos Magos.

</div>

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgp6kE8WAkKbt8hAFzRJ3BqPrUPFDLmRMERafEVrxf6LyJ7KAWR8bzb_kLzC659H6DkCW19McTVOADC-Tsh71zP111q5lGd5dTRrNCdpttAVBipF5xF-Ub4Z-UbWr48_wpTGFp1v7wgpQrI/s400/1267436_663183940358934_493586524_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgp6kE8WAkKbt8hAFzRJ3BqPrUPFDLmRMERafEVrxf6LyJ7KAWR8bzb_kLzC659H6DkCW19McTVOADC-Tsh71zP111q5lGd5dTRrNCdpttAVBipF5xF-Ub4Z-UbWr48_wpTGFp1v7wgpQrI/s1600/1267436_663183940358934_493586524_o.jpg)

</div>

        Foi então que os Sombrios deram o grito de retirada e fugiram se refugiando por de trás das Montanhas Morcul, mas muitos grupos da Aliança do continente os perseguiram e ousaram atravessar as montanhas Negras, e daí muitas histórias se seguiram, pois nesse tempo os Magos tinham criado a arma que seria usada caso os Minotauros não tivessem virado o quadro da Guerra, e esta arma era o Caixão das Almas.

</div>

</div>$MDS$, array['História']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Capítulo 4 - Guerra dos Cem Anos');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Capítulo 5 - Domínio Dranoriano', 'capitulo-5-dominio-dranoriano', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-14 · marcadores: História
> Fonte: https://maresdesangue.blogspot.com/2013/04/dominio-dranoriano.html

<div style="text-align: justify;">

<div style="text-align: left;">

<div class="separator" style="clear: both; text-align: center;">

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgt0CHCOfnMos2GRxnqHHsdeWfX9ta5O8hvGNj31PSUhyZpU2Le22R_2Qj9gBX8NNVmmrjsFew-eq8q8C8ZRJ0a11tIvfygcCT7jw0Ni0o57v9639080KznBM0z6b64pqQHSACRoFyyxizy/s320/1234199_156959677843487_1417836835_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgt0CHCOfnMos2GRxnqHHsdeWfX9ta5O8hvGNj31PSUhyZpU2Le22R_2Qj9gBX8NNVmmrjsFew-eq8q8C8ZRJ0a11tIvfygcCT7jw0Ni0o57v9639080KznBM0z6b64pqQHSACRoFyyxizy/s1600/1234199_156959677843487_1417836835_n.jpg)

</div>

<div style="text-align: justify;">

       

</div>

<div style="text-align: justify;">

No fim da Guerra dos Cem Anos os Dranorianos e a Escola de Magia eram as maiores forças militares do Continente. Os Minotauros se retiraram para sua ilha Minos, e os exércitos das outras raças voltaram para suas terras e cidades. Estavam desgastados e apenas um terço dos exércitos retornou para casa. Muitos não viam suas famílias há décadas, pois lutaram por anos intermináveis nas regiões do Rio Divisa e nas fronteiras da Floresta.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Os Reinos Feéricos das Florestas também estavam enfraquecidos depois de muito batalharem quando os exércitos defensores falharam e os Sombrios quase invadiram a Floresta, se não fossem os exércitos de Minos poucas esperanças restavam para o Continente. Os Anões do Sul se isolaram ainda mais em suas Cavernas e a economia foi muito afetada. Os Magos ajudaram as raças no que podiam, mas os Dranorianos tramavam algo maior.

</div>

</div>

</div>

<div style="text-align: justify;">

<div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjNVT8nLkCFupUYOacLbeX-A3kLQhdteLwjT40SzCdrSPcpi8Avqv1kmbv_rpUMxoqmv1C_W6f4lqfg4N2sBHHGgAjzbpiWgGLCosopTCTujkGtqdu1AHkGP11jB7nZfa8r7-Kk78IwULEc/s320/mm219_newprahv_guildmage.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjNVT8nLkCFupUYOacLbeX-A3kLQhdteLwjT40SzCdrSPcpi8Avqv1kmbv_rpUMxoqmv1C_W6f4lqfg4N2sBHHGgAjzbpiWgGLCosopTCTujkGtqdu1AHkGP11jB7nZfa8r7-Kk78IwULEc/s1600/mm219_newprahv_guildmage.jpg) |
|                                                                                                                                                                                                                                       Emissários de Dranor                                                                                                                                                                                                                                       |

       
Dranor enviou emissários por todas as cidades, decretavam uma lei onde todas as cidades estariam submetidas ao poder de Dranor porque maior parte das terras era do Reino Dranoriano, e mesmo a região norte da Floresta estava por debaixo de seu domínio. Era também a única força restante e forte o suficiente para buscar defender o Continente junto a Escola de Magia em caso de qualquer retaliação dos Magos Sombrios. Tinham um discurso que as terras deles ainda estavam em perigo porque a força principal tinha recuado mas as raças inimigas ainda perambulavam por ai, e as terras ainda deviam ser limpas das pragas Orcs e Goblins e outros seres Malignos que tinha se espalhado, como Trolls e Ogros.  
  
A Escola de Magia sabia que os Dranorianos estavam certos, mas também viram seu objetivo de dominar o continente e aconselharam os feéricos, Anões e Bestiais a aceitarem os termos, pois temiam que Dranor buscasse o domínio pela da força bruta. A própria escola acabou auxiliando Dranor em recuperar e ajudar as cidades, mas ela continuou independente dos Homens, pois Dranor os respeitava e honrava.

</div>

</div>

<div style="text-align: justify;">

<div>

  

<div class="separator" style="clear: both;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEigi0rmr_c1JyPC192I4g1XU_j4NtegvEkCfd3vGchhKgG09Z2ufplpfZ_j8jWh0oa1aehnphdD5dqiMGjt9c2j4ckAGQCmlv5N7bdXQmeL5fZainImo3C3v43A6ts_jN-ZXPddKmkMbcGp/s320/10-argyle11.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEigi0rmr_c1JyPC192I4g1XU_j4NtegvEkCfd3vGchhKgG09Z2ufplpfZ_j8jWh0oa1aehnphdD5dqiMGjt9c2j4ckAGQCmlv5N7bdXQmeL5fZainImo3C3v43A6ts_jN-ZXPddKmkMbcGp/s1600/10-argyle11.jpg)

</div>

  
      Apesar de dominadora e exigente, Dranor era fiel em seus tratados e sua honra era intocável, providenciaram as raças e cidades arrasadas pela Guerra comida e condições para se reestruturarem, e sua força militar limpou as terras e protegeu o povo. E apesar de rigoroso, às vezes opressor, o Governo absoluto de Dranor foi justo e muitas vezes lucrativo para as cidades e reinos submetidos a eles.  
  
Os únicos que foram contra a ordem Dranoriana eram os Anões do Sul, que chamaram todas as raças de fracas e se trancaram em suas cidades, ameaçaram abertamente que se qualquer Homem ou Aliado viesse com intenções desagradáveis seriam mortos sem aviso prévio, e estavam prontos para o caso de Guerra contra os Homens Magotes. E essa reação dos Anões foi de grande importância para a Batalha Bestial que viria em um futuro distante.  
  
Mas os Homens já estavam satisfeitos com o domínio que tinha conquistado, e resolveram tentar fazer acordos com os Anões. A aliança foi complicada e muitas vezes a suposta paz ficou por um fio. Mas os Homens usaram a relação que tinham com as outras raças para comercializar indiretamente com os Anões do Sul.  
  
Dranor fundou Nove Grandes Cidades Fortes pelo Continente, usadas para manter vigilância e organização sobre as nove Regiões divididas por Dranor. E estes foram os Nove Reinos dos Homens, que duraram duzentos anos.

</div>

</div>

<div style="text-align: justify;">

<div>

<div class="separator" style="clear: both;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhBPLmok7l2lE_5ZCqhm40XwrpivxAM8e2TlMdKO-kNONy3QqJU218dzA_Jx_7y5HRJzPPMO1MzlNIIg7FczOdM1jJlrzKvDeceyyY8W1eMyFEVEMH2NPIonwyWyN1mjiIblrhjupXkizLN/s320/1175139_158217661051022_1547535709_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhBPLmok7l2lE_5ZCqhm40XwrpivxAM8e2TlMdKO-kNONy3QqJU218dzA_Jx_7y5HRJzPPMO1MzlNIIg7FczOdM1jJlrzKvDeceyyY8W1eMyFEVEMH2NPIonwyWyN1mjiIblrhjupXkizLN/s1600/1175139_158217661051022_1547535709_n.jpg)

</div>

        Eles recebiam impostos de todos os reinos inferiores, e o comercio devia ser centralizado sempre nas cidades representantes de Dranor, os exércitos eram controlados e formados pelos Dranorianos. Os Homens eram sempre favorecidos, e alguns menosprezavam e maltratavam as outras raças, pois se sentiam superiores e dominadores. E na mesma medida que o governo era bom e trouxe progresso e justiça, em muitos casos foi opressor, mas esses males vinham da parte dos Homens das Regiões mais ao Sul do que dos próprios Homens do Norte. Mas muitos líderes e grupos militares cometeram massacres e assassinatos por puro desdém e abuso de poder.

</div>

</div>$MDS$, array['História']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Capítulo 5 - Domínio Dranoriano');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Capítulo 6 - Ascenção do Reino Anão Leste', 'capitulo-6-ascencao-do-reino-anao-leste', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-14 · marcadores: História
> Fonte: https://maresdesangue.blogspot.com/2013/04/ascencao-do-reino-anao-leste.html

<div style="text-align: justify;">

<div>

         No extremo norte se ergueu Dranor, o poderoso reino dos Wikinings, os homens navegantes que desceram do norte, vindo de continentes perdidos no grande mar de sangue após a guerra contra os demônios que definiu o fim da primeira era do mundo. Lá, antes da chegada dos Homens, haviam anões que reinavam sobre as montanhas no Norte.

</div>

</div>

<div style="text-align: justify;">

<div>

        Dranor, o rei dos Wikinings que fundou o reino Dranoriano, fez grande amizade com Azor, que era o Rei supremo dos Anões do Norte, e essa amizade resistiu aos anos, mesmo depois da morte de ambos os reis os Dranorianos e Anões viviam unidos e dependentes um do outro.  

<div class="separator" style="clear: both; text-align: center;">

<http://www.socwall.com/images/wallpapers/19288-1680x1050.jpg>

</div>

</div>

</div>

<div style="text-align: justify;">

<div>

        Os Anões do Norte acreditavam que esses homens eram parentes antigos, perdidos nas eras passadas, devido a sua aparência robusta e suas barbas, apesar de serem belos e altos, muito se pareciam com os anões. E vincularam seu comercio ao dos Homens de Dranor, dependendo de seus produtos e fabricando suas armas, essa troca rendia muita riqueza para ambos os reinos. E todo o continente voltava seu comercio para aquela região, rendendo lucro para os anões e para os homens.

</div>

</div>

<div style="text-align: justify;">

<div>

         Mas, com o passar das gerações de reis, algumas famílias anãs se angustiaram e se incomodavam com a dependência que eles tinham de Dranor. E com o passar da Guerra dos Cem anos, o reino ficou ainda mais agitado com os murmúrios daqueles que queriam por tudo se desvincular do Reino dos Homens.

</div>

</div>

<div style="text-align: justify;">

<div>

        Ora, o Rei anão desses tempos era Izenkar- e tinha cinco filhos, Thúrin, Mormegil, Thurambar, e os mais novos, Neithar e Gorthol. E os três mais velhos eram os lideres dessa revolta entre os Anões do Norte, e queriam sair daquelas terras, levar seu povo para longe da sombra dranoriana. Pois para eles aquela aliança era a Ruína dos Anões.

</div>

</div>

<div style="text-align: justify;">

<div>

        Porém, Izenkar era grande amigo dos reis humanos, e na primeira década do Dominio Dranoriano sobre o continente os anões enriqueceram ainda mais as suas casas. O Rei acreditava que ainda lucrariam mais se continuassem vinculados a Dranor, e maior parte de seu povo compartilhava esse pensamento.O Rei não concordou com seus filhos e mandou se aquietarem quanto a essas ideias.

</div>

</div>

<div style="text-align: justify;">

<div>

        Mas Thúrin não podia mais manter-se naquele reino subjugado, pois os anões são teimosos e orgulhosos, se seu pai não lhe desse a liberdade que queria, ele lideraria os que o apoiassem para longe daquelas terras e expandiria os reinos de Izenkar com glória e independência.

</div>

</div>

<div style="text-align: justify;">

<div>

|                                                                                      |
| :----------------------------------------------------------------------------------: |
| <http://whatsyourbackground.net/wp-content/uploads/2010/10/khangle-dwarves-army.jpg> |
|                            Thúrin e seus irmãos viajando                             |

        Pediu então a seu pai que lhe permitisse sair das regiões de Dranor e guiar sua família e as que o seguissem para as cavernas a leste nas grandes Montanhas Lammoth. Prometeu que se manteria aliado ao pai, seja nas suas guerras ou nas de Dranor, mas apenas cobrou um governo e comercio livre, mesmo que tivesse de pagar os impostos que o novo reino Humano cobrava.

</div>

</div>

<div style="text-align: justify;">

<div>

       Izenkar, apesar de temeroso, apoiou seu filho e deu a ele liberdade para seguir como queria. E o príncipe anão e seus dois irmãos, Mormegil e Thurambar, lideraram uma grande marcha para Montanhas do Leste. E com eles vieram grandes engenheiros e trabalhadores. E os outros reinos anões enviaram auxilio, com grandes mestres de obras.

</div>

</div>

<div style="text-align: justify;">

<div>

       Assim, nos primeiros quinze anos do império Dranoriano, iniciou a construção das três grandes cidades anãs do Reino Leste. A grande maestria e habilidade anã em suas poderosas construção sob as montanhas era conhecido por todo o continente, e seu trabalho era rápido e glorioso. E após sete anos as cidades estavam prontas para serem habitadas. E depois dos novos moradores para lá se mudarem, acabamentos e outros afazeres continuaram por mais três anos.

</div>

</div>

<div style="text-align: justify;">

<div>

        E famílias de todos os reinos Anões se mudaram para lá, um grande comercio se ergueu na floresta entre seus moradores e os reinos anões Oeste e Sul. E com os anos mais quatro cidades foram construídas nas montanhas. E por cem anos durou esse reino, e nenhum dos outros reis anões se comparavam a Thúrin e seus irmãos em poder.

</div>

</div>

<div style="text-align: justify;">

<div>

        O reino era governado pelas três casas de Izenkar, mas Thúrin era o Rei supremo de todo o reino Leste.

</div>

</div>

<div style="text-align: justify;">

<div>

        Ora, o continente estava sob o domínio dos Dranorianos que em troca de pequenas taxas de impostos nada fizeram quanto ao reino Anão Leste, dando a eles a liberdade que eles queriam devido também à amizade e aliança que tinham com Izenkar. Mas entre os povos havia boatos sobre um acordo feito entre esses reinos, que se concretizou com uma grande e rica construção, que se realizou pelas mãos anãs e Dranorianas,o Templo Gaurgrod.

</div>

</div>$MDS$, array['História']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Capítulo 6 - Ascenção do Reino Anão Leste');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Capítulo 7 - Da ruína de Thúrin o Imprudente', 'capitulo-7-da-ruina-de-thurin-o-imprudente', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-14 · marcadores: História
> Fonte: https://maresdesangue.blogspot.com/2013/04/da-ruina-de-thurin-o-imprudente.html

<div style="text-align: justify;">

<div>

<http://www.biblioteca.templodeapolo.net/imagens/imagens/Hecatonquiros%200002%20www.templodeapolo.net.jpg>        Por debaixo das Ered Gorgoroth, as montanhas que cercavam Morcul, muitas raças que serviram aos magos Sombrios se esconderam na escuridão de túneis e cavernas. Lá havia grande maldição e pairava uma magia de pavor e horror que alimentava seres maus.

</div>

</div>

<div style="text-align: justify;">

<div>

        Ali esses seres cresceram sob o poder pavoroso se multiplicando de uma forma exagerada, e suas mentes eram envenenadas, eram ardilosos e sagazes possuindo um terrível desejo por destruição e morte. De baixo dessas montanhas estavam Orcs, Goblins e Hobgoblins que desgarrados da força  
principal de Morcul se perderam nos caminhos tortuosos de Gorgoroth. E na escuridão, impregnados das forças malignas que assombravam aquela região, se tornaram extremamente numerosos e mais horrendos e fortes que qualquer outro de suas raças.

</div>

</div>

<div style="text-align: justify;">

<div>

        Unidos com muito orgulho e arrogância, reuniram e preparam forças,  avançaram para os Vales de Gorgoroth atravessando o Rio Divisa, destruindo vilarejos e cidades pequenas. Assim tomaram mais armas e seguiram como um enxame nas florestas, mesmo os Entes não puderam causar danos em todas as tropas. E os seres malignos espalharam morte, fogo e profanaram rios e plantas.

</div>

</div>

<div style="text-align: justify;">

<div>

        Thúrin o Senhor Supremo dos Anãos Lestes, sabendo da aproximação da força bestial preparou suas forças e reuniu um exercito anão tão grande e poderoso tal qual nunca mais seria visto. E avançando para as bases Leste das Ered Lammoth preparam uma grande defesa liderada por Thúrin e seus Irmãos Thurambar e Mormegil. Seus elmos eram dourados, suas lanças e marchados afiados como vorpols, e os reis dos anões trajavam um armadura de uma prata brilhante e bela como a lua, e nelas estavam engastadas jóias caríssimas e raras. Grande poder arcano foi investido naquelas armaduras.  

<div class="separator" style="clear: both; text-align: center;">

<http://www.manticblog.com/wp-content/uploads/2010/06/Dwarfs-at-War.jpg>

</div>

</div>

</div>

<div style="text-align: justify;">

<div>

        Mas o exercito liderado pelos orcs com seus hobgoblins e goblins era duas vezes maior que o dos anões, e a magia negra que residia em seus espíritos os deixavam tão malignos que não se intimidaram com o brilho refletido das armas anãs e sem medo avançaram contra os anões nas bases das Ered Lammoth, e assim iniciou a Batalha Monstruosa que ainda é cantada em versos.

</div>

</div>

<div style="text-align: justify;">

<div>

        A batalha durou quatro dias e nenhuma das tropas recuou por momento algum, pois os orcs não cuidavam de seus feridos e nem reagrupava, mas atacavam com uma fúria demoníaca sem parar, obrigando os Anões que fizessem o mesmo. E Thúrin esteve em batalha em todo o tempo que ela durou, seus irmãos em alguns momentos recuavam e tentavam tratar o que eles podiam, enquanto Thúrin segurava os monstros na retaguarda.

</div>

</div>

<div style="text-align: justify;">

<div>

        Assim, com bravura e fúria, os anões derrotaram toda aquela horda maligna, mas tiveram muitas perdas, e Mormegil perdeu sua mão direita para um capitão das bestas. Thúrin, quando acabou a batalha, caiu desmaiado e atormentado pelo cansaço e horror da guerra amaldiçoada, fruto das bruxarias dos Sombrios, e ficou inconsciente e doente por muitos dias, pois dos orcs e hobgoblins emanava um poder doentio e amargo que infestava e infectava. E muitos hoje desconfiam que essa batalha foi um plano armado pelos Senhores de Morcul.

</div>

</div>

<div style="text-align: justify;">

<div>

  

</div>

</div>

<div style="text-align: justify;">

<div>

        Quando despertou, Thúrin retornou a seu trono cheio de honra e muitos povos vieram até ele para festejar e homenageá-lo por seus feitos. Porém, o Rei dos Anões foi tomado por uma doença que vive no centro do poder de Morcul, o orgulho e a arrogância que guiaram as bestas dos abismos de Gorgoroth.

</div>

</div>

<div style="text-align: justify;">

<div>

       Nesse tempo seu ouro e ganância cresceram por demais, e o rei voltou seus olhos para um lugar nas montanhas que todas as raças temiam sequer pronunciar seu nome, atraído pelas riquezas e minérios que ali existiam. Pois depois da guerra acreditava ser não só o maior entre os Naugrin, os anões, mas também ser o maior de todos os Senhores do Continente, e se sentiu imbatível, seja que força ele tivesse de enfrentar.

</div>

</div>

<div style="text-align: justify;">

<div>

        Ora, as Ered Lammoth eram as montanhas que vinham dos litorais centrais no extremo Oeste do Mundo, onde ficava o Reino de Dirnem, rei supremo dos anões do Oeste, e seguia fazendo uma curva para o Norte, entrando na região das Grandes Florestas, se findando em seus três últimos grandes Picos, onde estavam os misteriosos Salões de Gaurgrod. Mas essas três montanhas nos limites das Lammoth não eram os maiores Picos daquela cordilheira, porque acima delas estavam as Thangor, três picos que se erguiam separadamente de uma única base, atingindo os céus como torres construídas pelos deuses.

</div>

</div>

<div style="text-align: justify;">

<div>

|                                                                  |
| :--------------------------------------------------------------: |
| <http://www.wallpapersy.com/wp-content/uploads/2012/02/2349.jpg> |
|                    Gorthmog, o dragão demônio                    |

        Mas as Thangor eram malignas e um terrível mal habitava aquela montanha, um diabo em forma de um temível dragão, que há milênios se escondeu nas profundezas que existiam ali.

</div>

</div>

<div style="text-align: justify;">

<div>

        Enviado por Asmodeus nos tempos de sua guerra contra as divindades benignas, o diabo fugiu da fúria dos deuses na primeira era do mundo. Seu nome era Gorthmog, e se apaixonou pela grandeza da montanha e suas três torres de pedra que se erguiam nos céus, e possuiu suas cavernas que eram mais ricas que qualquer outra em todo Dagor, e lá enganado por sua cobiça foi condenado pelos deuses a adormecer por infinitos anos, e seu espírito vagar preso a montanha.

</div>

</div>

<div style="text-align: justify;">

<div>

      A montanha era rica, seus minérios apareciam nas beiradas e muitos desejavam aquele tesouro, mas temiam os mitos de Gorthmog e seu que espírito assombrava aquela região. O diabo lançou sobre tudo que era de valor sob a montanha um feitiço de condenação e insanidade, opressão e decadência, morte e tristeza.

</div>

</div>

<div style="text-align: justify;">

<div>

        Mas Thúrin ignorou os alertas de seus irmãos e seguindo sozinho com seus homens foi até as Thangor e inicio mineração nas cavernas. E muitos tesouros extraíram de lá, mas os males e o espírito do Dragão logo começaram a apresentar-se na vida dos anões. Thúrin em muitos momentos enfrentou o próprio espírito do diabo, lutando contra ele com fortes palavras de poder, tentando expulsar o espírito da montanha. Revoltado, o rei anão investiu com milhares de seu povo nas profundezas das Thangorodrim, buscando ainda mais ouro, atraindo a ira do espírito que ali vagava.

</div>

</div>

<div style="text-align: justify;">

<div>

        E planejava encontrar o corpo adormecido de Gorthmog com o objetivo de destrui-lo e trazer a cabeça do Dragão como troféu para seu reino e arrancar a força seu espírito de lá. Mas o anão não entendia com que força ele estava se metendo, pois Gorthmog já foi um senhor dos nove infernos e ali na caverna existiam outros espíritos sob seu comando.

</div>

</div>

<div style="text-align: justify;">

<div>

        Os anões cavaram muito fundo alcançando as profundezas do mundo aonde o Dragão se deitou sobre uma pedra gigantesca de diamante, e depois caiu em seu sono milenar. De lá demônios subiram contra os anões e Thúrin mais uma vez chamou seu exercito, mas seus irmãos se demoraram a chegar. Thúrin enfrentou e barrou as forças demoníacas nas cavernas e lá enfrentou o próprio Gorthmog, que conseguiu materializar seu espírito em uma forma mais decrepita de seu verdadeiro corpo

</div>

</div>

<div style="text-align: justify;">

<div>

        Iniciando uma batalha de espadas e palavras, o Anão e o diabo se enfrentaram. O Rei Anão brandia um martelo feito de uma pedra sagrada, e o choque de sua arma contra as Seregor, a laminas de Gorthmog, causava uma explosão de luz e fumaça negra. E a cada golpe desferido Thúrin urrava palavras mágicas de seu povo, em nome de seu deus, e Gorthmog desferia maldições e pragas.  

<div class="separator" style="clear: both; text-align: center;">

<http://digital-art-gallery.com/oid/43/1220x448_8567_Dwarf_vs_Hook_2d_fantasy_dwarf_warrior_monster_battle_picture_image_digital_art.jpg>

</div>

</div>

</div>

<div style="text-align: justify;">

<div>

        E o choque de suar armas e laminas ecoava por toda a caverna indo até os vales das Thangor, muitos ouviam a batalha de longe na floresta. Pois além das explosões das armas a montanha tremia. E isso provocou um terrível desabamento. Os diabos de Gorthmog fugiram para o abismo nas profundezas, e os guerreiros e mineradores de Thúrin correram para fora da montanha. Thúrin lutou contra o Dragão até que feriu seu espírito, e este também fugiu. Mas o rei anão morreu ali, soterrado sob a montanha. E dizem que seu espírito hoje habita os vales da montanha, vigiando para os deuses, a prisão de Gorthmog.

</div>

</div>

<div style="text-align: justify;">

<div>

        A dor pela morte de Thúrin foi grande de mais e seus filhos se negaram a subir ao trono, o povo não queria outro rei pois muito amavam seu falecido senhor. E a família de Thúrin deixou as montanhas seguindo para o Sul para morar perto do reino Anão daquela região. E Thurambar assumiu a regência do reino de Thúrin, mas não existiu mais um senhor supremo sobre os anões do leste, e as família de Thurambar e Mormegil se negaram a reinar, se contentando com a regência.

</div>

</div>

<div style="text-align: justify;">

<div>

       Mas o tesouro e riqueza dos anões do leste fora profanado pelos tesouros amaldiçoados de Gorthmog, e a cada ano o reino Leste decaiu. E tristeza residia no semblante daqueles anões. E se não fosse pelo rei Gorthol, irmão mais novo de Thúrin e novo rei dos anões do norte, herdeiro de Izenkar, os anões do leste teriam sucumbido à miséria e se perdido nos anos.

</div>

</div>

<div style="text-align: justify;">

<div>

        Os Dranorianos, temendo o mal que se levantou nas montanhas, mandaram que lacrassem os seus salões sagrados de Gaurgrod e dobrassem a vigília. E assim, muitas cidades dos anãos lestes caíram em desgraça devido ao pouco tráfego de mercadorias. Outras sobreviveram e se manterão de pé, negociando e mantendo comércio naquela região, mas o reino do Leste caiu.

</div>

</div>

<div style="text-align: justify;">

<div>

          É dito que Gorthol antes de morrer foi até os vales das Thangorodrim para prestar sua ultima homenagem para seu amado irmão. Mas a ele apareceu um espírito poderoso, alto, e de longos cabelos e barbas, e sua voz era a de Thúrin. E o espírito falou que num futuro distante, um dos filhos da casa de Izenkar retornaria ao mundo em outra forma, e repararia os erros de Thúrin o Imprudente, e chamaria seu povo, e o poderoso reino do Leste renasceria das cinzas e grandes feitos fariam em uma terrível guerra que viria com o findar do domínio dos homens.

</div>

</div>

<div style="text-align: justify;">

<div>

        E esta profecia foi talhada na antiga Mansão de Thúrin, aonde muitos de seu povo vão prestar homenagens e visitar a antiga casa do Maior de todos os Reis Anões. E o povo do Leste aguarda por este momento, quando seu tempo de vergonha ira terminar e novamente serão uma nação Anã como foram um dia.

</div>

</div>$MDS$, array['História']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Capítulo 7 - Da ruína de Thúrin o Imprudente');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Capítulo 8 - Das Guerras Bestiais', 'capitulo-8-das-guerras-bestiais', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-14 · marcadores: História
> Fonte: https://maresdesangue.blogspot.com/2013/04/das-guerras-bestiais.html

<div style="text-align: justify;">

  

## O Massacre de Nagrod        

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgTOAlJG11mIFL5OpWiwtM3hz-X7QYBMpsDQCfvbqosyzuelgw_vpNdB6hrbchFk3D4p6hoFqHHe0xG6pk88g1qlnY9iDyQz4D4k9OPtILjVrI1ihBkvmDSB8NjbAtzB6fzM0bvqNZjus1W/s320/1292327_154673398072115_256970298_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgTOAlJG11mIFL5OpWiwtM3hz-X7QYBMpsDQCfvbqosyzuelgw_vpNdB6hrbchFk3D4p6hoFqHHe0xG6pk88g1qlnY9iDyQz4D4k9OPtILjVrI1ihBkvmDSB8NjbAtzB6fzM0bvqNZjus1W/s1600/1292327_154673398072115_256970298_o.jpg)Grandes histórias aconteceram entre os duzentos anos que Dranor dominou Dagorcain, desde as guerras contra os Orcs que invadiram as montanhas as contendas dos Elfos e Drows, a ascensão e queda do Reino Anão Leste até As Guerras Goblins e a morte dos Senhores do Oeste. Muitos males perambularam o Continente de Dagorcain, terríveis feiticeiros que se levantaram na Guerra dos Cem Anos; Necromantes , Demônios e Bruxos, que comandavam bestas e pequenos exércitos. Mas o Império Dranoriano foi poderoso e não se abalou, mas defenderam suas terras com mãos de ferro.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Mas esses feitos não serão contados aqui. Os tempos desse poderoso Império terminaram quando os Anões do Sul cansaram da trégua forçada, e começaram a incitar os reinos próximos a eles a rebelião. Trancaram novamente suas portas impedindo todo o comercio sul que era extremamente importante para Dranor. Os Homens do Norte queriam evitar uma guerra declarada, mesmo que acreditassem que a vitória seria certa, mas os Anões são poderosos, e suas mansões quase impossíveis de serem invadidas. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Dranor ignorou as atitudes dos Anões do Sul, evitando qualquer conflito, mas isso era inevitável. Os Anões começaram e expandir seu reino, e avançaram para as montanhas Leste, desafiando Dranor, que dominava aquela área, construíram uma poderosa cidade nas montanhas e lá residiam Bestiais Feéricos e Anões, e alguns Homens que também não apoiavam o domínio dos Nortistas, que com o tempo se tornou opressor. Pois a cidade foi feita com o objetivo de unir as raças para instigá-las a rebelião, e ela ficou rica e forte, e os anões começaram a criar uma zona de livre comercio, e Dranor não recebia mais os impostos daquela região, e então houve o desafio final, quando os anões e seus aliados começaram a exibir forças militares, e seus trajes eram belíssimos, de obra de artista, pois os Feéricos e Anões do Sul eram exímios encantadores e forjadores de armas, e juntos superavam os Anões e Dranorianos no domínio da forja.

</div>

<div style="text-align: left;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhd0aM9B0uaEtRzLebZUhIWuSyfgcnmVe9kQGAAQEUP3kjWBfRYwjIM_fBKnT6j_rXH9yM-Nbmqut2mw6FQoeH60bPdC2ai2WCSJX9WS-XV0yP3qz4WhHf92oIrwQ5sR0d1rWuHVo3K0bld/s320/1240077_160901090782679_763401871_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhd0aM9B0uaEtRzLebZUhIWuSyfgcnmVe9kQGAAQEUP3kjWBfRYwjIM_fBKnT6j_rXH9yM-Nbmqut2mw6FQoeH60bPdC2ai2WCSJX9WS-XV0yP3qz4WhHf92oIrwQ5sR0d1rWuHVo3K0bld/s1600/1240077_160901090782679_763401871_n.jpg) |
|                                                                                                                                                                                                                                                        Rei Anão                                                                                                                                                                                                                                                        |

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Dranor em resposta enviou uma força militar para a cidade Anã, outrora chamada de Nagrod, onde o próprio rei dos Anões Sulistas passou a morar, também em desafio aos Senhores Dranorianos. O objetivo era apenas cobrar os impostos e tentar recuperar a ordem, mas sem combates, e os soldados eram um alerta e demonstração de força. Mas o Rei os expulsou e os cidadãos desdenharam dos Homens. E disse o Rei ao Comandante da Força Dranoriana:

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

\- Dranor é muito ousada em invadir meus salões com forças armadas, e eu devia tomar isso como atitude de Guerra, mas sou piedoso e não enviarei suas cabeças aos portões de Dranor em consideração a velhos acordos. Mas diga a seu Senhor, Rei do Forte Dranoriano da Floresta, que essa região e muitas outras estão livres das opressões dos Homens do Norte, e seremos implacáveis com qualquer outra demonstração de força ou ameaça. Não pagaremos imposto algum, e nem nos arrependemos de nossas atitudes. Vão agora, cães dos Homens, me envergonho dos meus parentes que vivem debaixo de suas sarnas.

</div>

<div style="text-align: left;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEimOQANa9Wu84ZJMGXVNVxbOEAbuf0XCOa33OgnKKJd757v0g5a1Dq18Bub3wB9ef09cLclXsau4tRIff_bxKqIpDHeqTsHkWcFPVDZV7ACUoT087dJ7NfNnZ2rIve-ve6GSow4bM_Dks8g/s320/1374847_392982657496160_226182528_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEimOQANa9Wu84ZJMGXVNVxbOEAbuf0XCOa33OgnKKJd757v0g5a1Dq18Bub3wB9ef09cLclXsau4tRIff_bxKqIpDHeqTsHkWcFPVDZV7ACUoT087dJ7NfNnZ2rIve-ve6GSow4bM_Dks8g/s1600/1374847_392982657496160_226182528_n.jpg) |
|                                                                                                                                                                                                                                                  Rei Dranoriano Bolg                                                                                                                                                                                                                                                   |

<div style="text-align: left;">

Porém, o Rei Anão se meteu com o mais imprudente tirano dos Nove Senhores, e em uma assembléia ele buscou convencer os outros oito a aniquilar a Escória Anã do Sul, e todos os que o seguiam, pois estes poderiam trazer muitos problemas. E ele estava correto, apesar de seus defeitos, Bolg, O Rei Dranoriano do Norte da Floresta, era sábio e astuto.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Os outros Reis, com poucas exceções foram contra Bolg, e eles queriam evitar conflitos, enquanto Bolg acreditava que a queda dos Anões Sulistas serviria de exemplo para evitar qualquer atitude rebelde. Mas a reunião terminou com a decisão de que seria evitada a guerra, e mais uma vez apelariam para acordos, até encontrarem uma boa solução contra a rebeldia Anã.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Mas Bolg era sedento por guerras, e se sentiu humilhado pelas palavras do Anão, e não podia deixar aquele desafio como um rato medroso, ele era um Homem de Dranor, e aquela afronta deveria ser respondida com violência. Então, certo de que suas atitudes no futuro seriam louvadas, mandou que preparassem uma forte tropa e mandou chamar alguns anões do Norte, engenheiros de preferência. E mandou que atacassem a cidade pela madrugada, um pouco antes de fecharem as portas. E deu ordens de que todos ali fossem mortos, independente da raça.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEieBHXdYva1ca4wMUuSozJ0njpf7NfCBGcrI_OC9SIDhzeSICMFIXXv-emfDbYoxEbyZSNPdTtm5BRwnORQILWQFI_hYR6_5FLFPl_SSFJOlBai_aV4uMgnyQQEZ6lCLiNKkMZXj6DPS_Vi/s320/1235301_159835897555865_1779861214_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEieBHXdYva1ca4wMUuSozJ0njpf7NfCBGcrI_OC9SIDhzeSICMFIXXv-emfDbYoxEbyZSNPdTtm5BRwnORQILWQFI_hYR6_5FLFPl_SSFJOlBai_aV4uMgnyQQEZ6lCLiNKkMZXj6DPS_Vi/s1600/1235301_159835897555865_1779861214_n.jpg)E foi assim, durante a noite, quando os últimos comerciantes deixavam a cidade, e o Rei Anão terminava seus afazeres na Sala do Trono, as forças de Dranor invadiram as mansões. E sem piedade mataram homens, mulheres e crianças, anões, homens, feéricos ou bestiais. Muitos tentaram fugir da fúria dos Dranorianos, mas eles foram implacáveis, e depois de matar os moradores lançavam fogo sobre suas casas e barracas, os corpos também eram lançados no fogo, e não existia misericórdia.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

As defesas foram surpreendidas, mas teve tempo de se reunir no centro da cidade, e assim as tropas dos homens do Norte se lançaram contra a linha de defesa dos Anões, e muito sangue foi derramado naquele momento, e não havia força que impedisse os Homens do Norte de avançar. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

O Rei dos Anões estava ao lado dos soldados, e com bravura lutou e muitos homens caíram sob o Marchado do Rei, e para cada homem que ele derrotava, rugia seu nome como um urso. E o grito era tão forte que muitos homens se sentiram aterrorizados, e o Rei avançou sozinho entre os inimigos, e isolado de seus soldados, mais de cem vezes sua ira foi escutada, e só os mais bravos se mantinham firmes em sua presença, e mesmo esses temeram o urro do Rei. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjDdFMZSZEKq5EqYymdAY07HcmA13Rk8UyGC7qc-h6l1McYOWInh7t1XoNFdfZ74Uc0gfXFZ1O462Pk9_rKK6U0vAaU7zePt65YvpV85dcJ3D2mONdd3NrXVu8cA7UKQLmS1J8uVSH58Kd2/s320/551421_240883182703694_1354967492_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjDdFMZSZEKq5EqYymdAY07HcmA13Rk8UyGC7qc-h6l1McYOWInh7t1XoNFdfZ74Uc0gfXFZ1O462Pk9_rKK6U0vAaU7zePt65YvpV85dcJ3D2mONdd3NrXVu8cA7UKQLmS1J8uVSH58Kd2/s1600/551421_240883182703694_1354967492_n.jpg)Mas a Ira do Rei não foi suficiente e seus gritos se findaram. Ele caiu lutando contra o Comandante das forças de Dranor, que era o de maior Renome naqueles tempos. Mas ele também era conhecido por ser impiedoso, e depois de assassinar o Rei, ergueu sua cabeça a vista de todos, e a moral dos defensores caiu, e os últimos foram encurralados, mortos sem piedade. Poucos escaparam da crueldade de Dranor, e os homens pilharam a cidade, e todos os corpos foram queimados em uma enorme fogueira.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

E as noticias do massacre se espalharam e a morte do Rei Anão foi tão terrível para seu povo que antes de praguejar choraram por dias, e com fúria, os Anões do Sul iniciaram a rebelião contra Dranor, com ou sem ajuda, para eles não importava, lutariam até a morte. E seus irmãos do Oeste ouviram seu chamado, e os novos Povos Anões do Leste também choraram a morte do Rei e se uniram a Rebelião.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

E as outras Raças a muito se indignaram com as injustiças de alguns Reis dos Homens, se uniram a causa, e assim começaram os conflitos que em breve se tornariam a Grande Guerra Bestial, e aqui foram mostrados os principais eventos que levaram a esta Guerra Civil. 

</div>

<div style="text-align: left;">

  

</div>

## <span style="text-align: justify;">O Conclave</span>

<div style="text-align: left;">

Os Feéricos eram Raças Mágicas, e estes eram os Elfos e Meio-Elfos, Eladrins e Drows, entre outros seres mágicos como Gnomos. E depois dos Homens e Orcs, era uma das maiores raças do Continente. Eram caçadores habilidosos, sábios, grandes forjadores e artesãos, e suas cidades costumavam ser grandes e gloriosas. E suas forças militares também eram extremamente perigosas, mas nunca formaram um estado militar como os Homens de Dranor.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiAKbe6PJErWCbWtBsCayMOJY8eirlaH1pE5ZZH-lvoEzC0NhufmBrU0DaiyrQ9t2Hq6_kDoZrw7SU9euWE442-nh02xa3438KxCAO4VUHxmKvFO-ecaMBbF0QEOTz6fBimrDMPzEtqALgq/s320/elderscrollsonline02.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiAKbe6PJErWCbWtBsCayMOJY8eirlaH1pE5ZZH-lvoEzC0NhufmBrU0DaiyrQ9t2Hq6_kDoZrw7SU9euWE442-nh02xa3438KxCAO4VUHxmKvFO-ecaMBbF0QEOTz6fBimrDMPzEtqALgq/s1600/elderscrollsonline02.jpg)Eles eram belos e muito bem organizados, grandes governantes e sábios nos costumes, e deles vinham os mais poderosos Magos da Escola de Magia, que só não se igualavam aos Devas acolhidos pela escola. E sua amizade com a escola foi o único motivo de terem se submetido ao domínio Dranoriano sem luta, pois a escola não podia permitir mais derramamento de sangue, logo depois da invasão dos Magos Sombrios, que poderiam aproveitar isso. E os Homens certamente poderiam defender o continente de qualquer ameaça iminente dos Magos naquele período, mas seu domínio foi mais longo e forte do que a escola previra. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Os Magos não mais podiam interferir nas Raças diretamente, mesmo porque os Homens do Norte também auxiliavam a Escola de Magia, porém eles não eram cegos para não ver a opressão que alguns reis dos Dranorianos submetiam as outras raças, e não poderiam controlar os Feéricos por muito tempo, e nem queriam. E com a Morte do Rei Anão viram uma oportunidade para aconselhar, mas não auxiliar.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh4XTkQ19R_S2vVljO9o_v8md9TqfxWNcIBZ1enAWBBJmevljxJSzi7fn6sDzMENgTvD2SqSfR8eTB901pB3Or0y-8P4hpeJb9lO7zwurrphS_SnOAqghwgVD1GbO2FugWceTb_KKoOfKIL/s320/eladrinphb.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh4XTkQ19R_S2vVljO9o_v8md9TqfxWNcIBZ1enAWBBJmevljxJSzi7fn6sDzMENgTvD2SqSfR8eTB901pB3Or0y-8P4hpeJb9lO7zwurrphS_SnOAqghwgVD1GbO2FugWceTb_KKoOfKIL/s1600/eladrinphb.jpg)Convocaram os principais lideres das cidades Feéricas e os aconselharam a Reunir todas as Raças sob a opressão Humana, agora que os conflitos entre alguns povos e os Anões contra os Homens tinham começado. E com essa união criassem um novo Governo sobre as raças bestiais, e escolhessem uma forte cidade ao Sul, aonde poderiam se agrupar e se defender mais facilmente das forças do Norte, e lá reunir as maiores forças, e assim, impor sobre os homens a liberdade das raças. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Mas os Magos sabiam que batalhas seriam inevitáveis, então aconselharam aos lideres Feéricos que se preparassem muito para um conflito contra as forças Humanas, com armas encantadas e recursos mágicos que era a deficiência nas forças do Norte. Mas que antes do fim procurassem um meio diplomático, seja na vitória ou derrota, evitando maiores massacres. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

E os lideres Feéricos seguiram perfeitamente os conselhos e escolheu a poderosa cidade élfica a beira Mar de Brithon, que era rica e fortificada e lá, por ser o extremo Sul do Continente, tinha pouca resistência Dranoriana. Expulsaram as poucas forças dos Homens, e reuniram os grandes lideres das raças do sul. E as cidades dos Lideres Feéricos ali presentes foram evacuadas e migraram para o Sul, pois estas cidades eram o cinturão élfico que se estendia até o norte perto das terras de Dranor, sob o olhar dos Homens.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj37RvXEd6HjLSOvHb55Z4HgxGD7stfDW5t84Rk4ENs71cVCjIgY2iv7ZC_tKgYEv7vElvFi2Jg2IL73CuTPZ6gm_6UbO3MMW8aSQ6CKHn-iJEg0y25L93p-0i_vJOKqAXn47Vy6Ye-pDDO/s320/PZO9009-Rakshasa.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj37RvXEd6HjLSOvHb55Z4HgxGD7stfDW5t84Rk4ENs71cVCjIgY2iv7ZC_tKgYEv7vElvFi2Jg2IL73CuTPZ6gm_6UbO3MMW8aSQ6CKHn-iJEg0y25L93p-0i_vJOKqAXn47Vy6Ye-pDDO/s1600/PZO9009-Rakshasa.jpg)Muitas Raças estavam ali, e essas eram os Anões, com lideres representando os reinos Sul, Oeste, e as cidades restantes do reino caído do Leste, Os lideres Feéricos, representando as quatro famílias, e também vieram os Bestiais, representados pelos Meio Orcs, Minotauros, Ferais e clãs Draconatos. Também havia alguns homens ali, vindos dos desertos, das cidades de Harad e Rakshasa, e o povo de Xablau do Império Xablablau. Também estavam ali os homens que viviam entre os feéricos e apoiavam a causa. Clãs de Paladinos como o dos Draconatos também estavam lá, mas muitos não vieram por seu vinculo com a Escola de Magia.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Nessa assembléia foi decidido que todas as raças ali presentes entrariam em Guerra contra Dranor, e libertariam as cidades que ainda não tiveram condições de se rebelar. Mas também seguiram o conselho dos Magos, de buscar meios diplomáticos e pacíficos antes de qualquer sinal de extermínio. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Todas as outras raças ali guardavam rancores dos Homens de Dranor, pois todas tinham sofrido pela mão de ferro dranoriana. Os Meio Orcs tinham poucas cidades, mas um grande exército, e muitos de sua raça e seus parentes eram tratados como escravos por alguns dos Nove Reinos. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiMofKh5bfD-lCk_U1SS6LhlDWrygEC0qYdYBOuZmQA3vKc98wbJ_ueH_tkKLfr8WJZMGEgrxLhDGXqMBMGkBBNvz7jpvi-SV_l4uatFqGZJvJU14Jb8IlKGLoFPhb_ZmxZJUrpj8FN7HMf/s320/10-argyle05.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiMofKh5bfD-lCk_U1SS6LhlDWrygEC0qYdYBOuZmQA3vKc98wbJ_ueH_tkKLfr8WJZMGEgrxLhDGXqMBMGkBBNvz7jpvi-SV_l4uatFqGZJvJU14Jb8IlKGLoFPhb_ZmxZJUrpj8FN7HMf/s1600/10-argyle05.jpg)Os Ferais sofriam zombarias e maus tratos, viviam em clãs ou misturados nas cidades dos outros povos, e os que viviam entre os Homens eram muito humilhados e oprimidos. Existiam clãs escondidos na floresta, e esses não compareceram, eram como os Gigantes e Golias, indiferentes as questões de Dagorcain. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Os Minotauros também viviam isolados, mas receberam uma mensagem da Escola de Magia, pedindo auxilio, e como já foi dito, os Magos no passado ajudaram os Minotauros, e isso o povo de Minos jamais esqueceria.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Mas os Feéricos e os Anões eram os mais rancorosos e que mais desejavam essa liberdade, e então com todos os lideres ali, fundaram o Conclave, a união de todas as Raças Livres. E a cidade de Brithon foi chamada de Dranar, em desafio ao nome Dranor. E a guerra foi declarada abertamente, e o discurso era que a guerra seguiria até que os Homens do Norte abrissem mão de seu reino absoluto sobre o continente, e as raças fossem livres de seu poder opressor.

</div>

<div style="text-align: left;">

  

</div>

## A Guerra Bestial

<div style="text-align: left;">

O Conclave reuniu um exército extremamente numeroso, algo que não se via desde a Guerra dos Cem Anos. Dranor reuniu toda sua força nas passagens das montanhas Lammoth, que vinham do Oeste, nos reinos de Dirnem e adentravam a floresta fazendo uma curva para o norte. E agrupou uma grande força composta pelos Homens de Dranor e exércitos de outras raças dominadas por eles, nas terras neutras comandadas pela Escola de Magia, a beira das montanhas, nas terras entre Elória e as montanhas de Dirnem. Sabiam que ali viria o maior ataque, pois eram estrategistas militares natos, e seus conhecimentos sobre guerra eram inigualáveis.

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhkflO5MUl-GC_Sayarsr9VBoTo6xRocUe8IunMrrXhu19Wk_5WomtIO5hnkK0jtTWyFcNUgyJpSrLT_DWRL24WHjnBV9VDcM_D8y43ydngyOuMBoludSbmqqpNJVBcK6j4NgDlyWfUXzXa/s320/magic_the_gathering_artwork_svetlin_velinov_1920x1080_21103.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhkflO5MUl-GC_Sayarsr9VBoTo6xRocUe8IunMrrXhu19Wk_5WomtIO5hnkK0jtTWyFcNUgyJpSrLT_DWRL24WHjnBV9VDcM_D8y43ydngyOuMBoludSbmqqpNJVBcK6j4NgDlyWfUXzXa/s1600/magic_the_gathering_artwork_svetlin_velinov_1920x1080_21103.jpg)

</div>

<div style="text-align: left;">

Não eram permitidos confrontos nas zonas neutras, mas a Escola de Magia queria manter a guerra mais afastada possível das montanhas Gorgoroth, e temiam confrontos na floresta, com medo da destruição enfurecer os entes e gigantes e a própria floresta receber sérios danos com isso. E nada disseram sobre o avanço e acampamento de Dranor naquela região.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Dirnem IV, o poderoso rei Anão do Oeste derrubou as defesas de Dranor em suas passagens, e defendeu suas terras da retaliação dos Homens, fazendo com que aquela área estivesse livre para quando os poderosos Exércitos do Conclave chegassem, mas sua força muito se enfraqueceu nessas primeiras batalhas, e não pode mais envolver seu povo na Guerra, pois precisava de defesas na cidade. Os Dranorianos os chamavam de Exercito Bestial, e com esse nome essa guerra foi conhecida.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Muitos confrontos ainda ocorreram na floresta, pois os Homens de Harad e Khajit, as cidades do deserto, libertaram o restante dos povos florestais do Sul do domínio de Dranor. Eram extremamente numerosos, sete mil homens, e suas habilidades no arco e na espada eram admiráveis, e eram liderados pela maior parte da força Feérica e junto com eles estava uma grande força Anã, e libertando essas cidades reuniram mais forças para guerrear e libertar as regiões Norte da Floresta. 

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjr_EU3l8CH9uHr4E9rT_iwjlIaSinPjLhdaWwK4i_cf-92OevbNHr2WcswAQujBypfBIijiR6oKM2I1BZZ0jyjbXaa6oQE4aXAueHCPUausWoLYf8JVdqTywg5ys6-fJILaWgQEkjpCTyW/s320/1278950_343173979151262_638771306_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjr_EU3l8CH9uHr4E9rT_iwjlIaSinPjLhdaWwK4i_cf-92OevbNHr2WcswAQujBypfBIijiR6oKM2I1BZZ0jyjbXaa6oQE4aXAueHCPUausWoLYf8JVdqTywg5ys6-fJILaWgQEkjpCTyW/s1600/1278950_343173979151262_638771306_o.jpg)

</div>

<div style="text-align: left;">

E com a passagem de Dirnem livre e vigiada, as tropas principais de Dranar passaram e não sofreram emboscadas, pois o povo de Dirnem vigiava as montanhas, e as conheciam melhor que qualquer um. E assim, a Tropa Bestial se agrupou no centro do Continente, a trezentos quilômetros das tropas de Dranor. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Um exército de catorze mil soldados foi reunido ali, formados por Anões, Homens, Draconatos e meio Orcs e parte das forças Feéricas que lideravam junto com os Paladinos. E se dividiram em três frentes, a mais poderosa foi mais próxima ao mar, pelas regiões do Extremo Oeste, em direção as tropas de Dranor, com oito mil soldados; Dois mil seguiram nas bordas da floresta como objetivo de libertar algumas cidades nas fronteiras da Floresta, e os dois mil restantes seguiram na retaguarda da principal, e após um tempo de caminhada, seguiram a leste e depois de alguns quilômetros fizeram uma curva a oeste com o objetivo de flanquear as Tropas de Dranor.

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjCbdEbyKUu5jqHUu7cBSZyxILrH7RWshj6sV5GGyiO-XfU9jNTxjMedzwt6YMD-F8k91yGhKunzvEk6H7osYdOtlXAmd53nwlc5GHW7r4uhQNyh3DzbHuOBzMBDI81r_eviuc2cD1tzrCK/s320/1077752_261677067290972_1783146157_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjCbdEbyKUu5jqHUu7cBSZyxILrH7RWshj6sV5GGyiO-XfU9jNTxjMedzwt6YMD-F8k91yGhKunzvEk6H7osYdOtlXAmd53nwlc5GHW7r4uhQNyh3DzbHuOBzMBDI81r_eviuc2cD1tzrCK/s1600/1077752_261677067290972_1783146157_o.jpg) |
|                                                                                                                                                                                                                                          Ataques as Cidades Fortes Dranorianas                                                                                                                                                                                                                                           |

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Todos esses movimentos foram previstos por Dranor, mas não a quantidade de soldados, e muitos ainda viriam da floresta e das cidades que eram libertadas no caminho. E os Homens do Deserto reuniram mais três mil soldados das cidades libertas na floresta, que mais tarde foram enviados para auxilio na principal área de confronto fora da Floresta. E outros dois mil foram reunidos no extremo leste da floresta. Que seguiram para o Norte e lá, após libertarem as ultimas cidades, seguiriam para o Sul e depois Oeste, para auxiliar a força principal.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Dranor defendeu bem todos os ataques, porém a quantidade de inimigos era gigantesca, e em muitos casos abandonaram a defesa e recuaram. Os Dranorianos tinham uma força total de dezoito mil Homens, e cinco mil anões do Norte, mas estes foram deixados para defender Dranor, junto com mais cinco mil Homens. E apenas doze mil foram enviados para a zona de ataque principal. E os outros mil para guiar suas tropas mescladas, que era como eles chamavam sua força formada por outras raças de cidades dominadas, que eram no total menos de cinco mil.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Mas apesar da desvantagem em números, os Homens do Norte eram guerreiros extremamente poderosos, mesmo os feéricos que eram rápidos e habilidosos, não tinham a força e treinamento comparável aos Dranorianos. E eram exímios estrategistas, e seus homens equivaliam a quatro do inimigo. Dessa forma a desvantagem era apenas aparente, mas os Homens do Norte ainda seriam dificilmente vencidos.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgLF7UFaDjNgm0gs0FWwnpXYmJEBn7iDztVdMNVNT6gYAY8EdHlJ1R2F3l1G3eoTSC0ukhA-wt0HQ-pN_o5gSrm3PNEiAKHfFnjnPBkv7GUAWdfHwpSGfv-2n0pVHbOluJa-sFGA2_8sCb4/s320/1271574_343175949151065_1345796231_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgLF7UFaDjNgm0gs0FWwnpXYmJEBn7iDztVdMNVNT6gYAY8EdHlJ1R2F3l1G3eoTSC0ukhA-wt0HQ-pN_o5gSrm3PNEiAKHfFnjnPBkv7GUAWdfHwpSGfv-2n0pVHbOluJa-sFGA2_8sCb4/s1600/1271574_343175949151065_1345796231_o.jpg)Essa Guerra durou mais de vinte anos, e os Minotauros entraram tarde na batalha, pois eles seriam usados como uma “carta na manga” de Dranar, para uma defesa ou ataque desesperado. E assim aconteceu, pois os Homens enviaram reforços para a floresta, e conseguiram fazer as tropas inimigas recuarem, e os Homens do Deserto foram expulsos de lá antes de alcançar as ultimas cidades no Extremo Norte da Floresta, e um massacre aconteceria ali, e em pouco tempo alcançaria os Campos de Dranar, sem misericórdia. Mas a força dos Minotauros foi uma surpresa para aqueles homens, que eram comandados por Bolg, o Rei do Forte da Floresta. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Os Minotauros travaram o avanço das tropas de Dranor, mas com dificuldades, pois os Dranorianos eram quase páreos para os Minotauros Gingantes invocados pelos generais de Minos. E ao mesmo tempo, as forças a oeste do continente, fora das florestas, Guerreavam nas terras frias que eram próximas as Fronteiras de Dranor. A disputa ali fora a mais sangrenta e violenta de todas, e muitos caíram. Dranor apesar de mais forte não tinha a mesma facilidade de restaurar seus Homens como Dranar tinha. E decidiram recuar e se agruparem próximos a sua terra, e mais uma terrível batalha foi travada ali, e por um momento Dranor teria vencido se as Tropas Bestiais não tivessem recebido o reforço que veio da Floresta.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

<https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgNBvgBSQbVtASC2RLUwBSByBqSzIajAxYCntZihHekyjIHeIkLx5S-ZM21Rk9cV1JACGKJekP7p51u4zDVymhJAh0W6uc798uV-Elq6FtG7ImFV3eWCY4NooKKLVSN6Qsk77K-2XadsVCX/s1600/Cairne_Bloodhoof_TCG.jpg>E quando viram que não tinham escolha, os Homens convocaram os Anões do Norte em seu auxilio, e com eles fizeram uma poderosa linha de defesa na fronteira dos Rios Gelados. Mas a maior força que estava nos exércitos Bestiais era de Anões, e quando as tropas estavam frente a frente, os Anões do Norte se negaram a lutar contra sua própria raça. Eles abandonaram o campo de Batalha, envergonhados, mas os Homens não tomaram aquilo como ato de Traição, pois a muito tempo um acordo sobre essa questão foi tratado entre eles.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Mas os Homens não recuaram, e os exércitos Bestiais vendo a retirada dos Anões, gritaram e se alegraram, e em um coro que podia ser escutado a quilômetros, eles diziam em várias línguas “é o fim”, e foi nesse momento que os lideres feéricos enviaram mensagens aos últimos reis dos Homens, seguindo o conselho dos Magos impedindo mais uma chacina e tratando os últimos momentos da Guerra em um acordo de liberdade e pactos de não agressão. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

Quatro dos nove reis Humanos pereceram em batalha, ou foram mortos quando suas cidades foram invadidas. O Rei Bolg, responsável pelo massacre de Nagrod e o Assassinato do Rei dos Anões do Sul, morreu defendendo sua cidade, e caiu aos pés da família do Rei Anão, e seu corpo foi lançado no rio para que se perdesse, e a força humana da floresta recuou buscando refúgio em suas terras no Norte, e assim a floresta foi totalmente liberta de Dranor.

</div>

<div style="text-align: left;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjNMnuFnN0o7emCv7AnBW_AkSuqj_95eC4vhM943jV2weQmtplZHQSY3DnHpWy1kw6Z9kNFRjZcBVs6xKNz01mv4utFc3fp8Bsm1nHAXYtXBmH6e4bkASM59yjl12J1tCEJ1hd3emFgzYHy/s320/1277793_733923966624773_1918672536_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjNMnuFnN0o7emCv7AnBW_AkSuqj_95eC4vhM943jV2weQmtplZHQSY3DnHpWy1kw6Z9kNFRjZcBVs6xKNz01mv4utFc3fp8Bsm1nHAXYtXBmH6e4bkASM59yjl12J1tCEJ1hd3emFgzYHy/s1600/1277793_733923966624773_1918672536_o.jpg)

</div>

<div style="text-align: left;">

Os Lideres de ambos os lados recuaram suas tropas, e se reuniram em uma assembléia entre o Conclave e os últimos cinco Reis de Dranor e seus arautos. Lá os homens tentaram recuperar suas terras na floresta, dizendo que elas lhes pertenciam desde os tempos anteriores a Guerra dos Cem Anos, mas o Conclave negou, pois muitos reinos Feéricos estavam a mais de mil e oitocentos anos nas regiões frias da Floresta. Mas Dranar não se impôs contra Dranor manter-se dona de todas as regiões frias que a muito foram dominadas pelos Homens no Norte. E a eles foi entregue a passagem do Extremo Norte, uma região entre a fronteira Norte da Floresta e os Paredões de Gelo, assim como as regiões dos Vales do Monte Dork. 

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

As outras Raças retornariam as suas terras, e a Escola de Magia abriu as portas da Zona Neutra para ocupação de áreas vazias. E Dranar continuou representando o Conclave, mas não dominava ou comandava as outras cidades ao redor ou qualquer raça, ela simbolizada liberdade, era uma grande e bela cidade com comercio poderoso, comandada por Eladrins e de maior população feérica, e aberta para todos, até mesmo Homens. E as Regiões Sul ficaram Ricas belas.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

E assim terminaram os duzentos anos de domínio Dranoriano. E milhares foram mortos na Guerra Bestial, mas os civis foram poupados, tendo poucos incidentes em que a população foi atacada. E os Reinos se tornaram livres, pois Dranar rendeu as raças de sua obrigação, mas o Conclave se manteve. E houve paz, e a prosperidade retornou as terras de Dagorcain.

</div>

</div>$MDS$, array['História']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Capítulo 8 - Das Guerras Bestiais');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Taverna Vomito de Dragão - 1° Parte', 'taverna-vomito-de-dragao-1-parte', $MDS$> 📰 Blog *Mar de Sangue* · 2014-12-31 · marcadores: História
> Fonte: https://maresdesangue.blogspot.com/2014/12/taverna-vomito-de-dragao-1-parte.html

<div class="separator" style="clear: both; text-align: justify;">

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhflwHbiKQInPlisbK7S8masffDOdKuv02vg9byR7TVjEMm4i40xQ1BJo7ZRNRAW4yL51N0Hv1fRycKtSp_g2GRfC9JBeK_Yg4fpyC4rnXAv071fBalSxM3a16aqWW8Z3D412IQVvOroJSe/s400/Logo+Vomito+de++Drag%C3%A3o.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhflwHbiKQInPlisbK7S8masffDOdKuv02vg9byR7TVjEMm4i40xQ1BJo7ZRNRAW4yL51N0Hv1fRycKtSp_g2GRfC9JBeK_Yg4fpyC4rnXAv071fBalSxM3a16aqWW8Z3D412IQVvOroJSe/s1600/Logo+Vomito+de++Drag%C3%A3o.png)

</div>

<div style="text-align: justify;">

A Taverna Vomito de Dragão constitui uma rede de tavernas e estalagens que cobrem boa parte do oeste do continente. Essa rede de tavernas foi idealizada por Kiloin Anatak II. Nascido numa cidade pertencente ao Reino Anão Leste nos tempos de seu auge, Kiloin era filho de um anão guerreiro, Kiloin Anatak I, que não tinha o costume de ficar em casa. Passava a maior parte de seu tempo lutando em guerras distantes dos anões e seus aliados Dranorianos ou na taverna da cidade, Donzela Embriagada. Cresceu querendo ser como seu pai, guerreiro, respeitado e além de tudo, com um fígado extremamente resistente a qualquer bébida.

</div>

<div style="text-align: justify;">

Os anos se passaram e uma tristeza veio a abater sobre a casa de Kiloin, seu pai faleceu num combate. Tudo que soube foi que viajava numa caravana voltando para sua casa quando um dragão chamado **Ordon Gritoalto** atacou o comboio, realizando uma chacina dessa forma.Kiloin não chorou, apenas realizou o funeral simbólico de seu pai. Depois disso procurou saber mais de Ordon, mas esse se migrou para o oeste e não se ouviu mais falar dele. Agora restava a Kiloin a tarefa de manter sua casa. Adentrou o exercito de sua cidade, dedicando todo seu soldo a família que lhe restava e todo seu esforço para aprender mais e mais nas táticas de guerrilha.

</div>

<div style="text-align: justify;">

No tempo que lhe restava procurava dar continuidade no hábito de seu pai, frequentar a taverna da Donzela Embriagada. Acabou por criar um grande laço de amizade - que mais tarde se tornaria noutra coisa - com Caratis, a anã que trabalhava na Donzela e era responsável pela manufatura das bebidas servidas na Taverna. Por ser seu maior lazer, Kiloin acabou por se tornar um grande conhecedor das formas de fabricação, sabor e fragrância de todo e qualquer tipo de líquido que contivesse álcool em sua fórmula.

</div>

<div style="text-align: justify;">

Passou de seus dezessete até seus trinta e oito anos nessa rotina de incursões de combate e frequentar a Donzela Embriagada, até que um dia uma simples notícia na Trombeta de Dagor lhe tirou a paz e reacendeu sua sede por vingança:

</div>

> 
> 
> <div style="text-align: justify;">
> 
> "Ataques de um dragão conhecido pela alcunha de Ordon Gritoalto vem assolando a ilha de Jordânia a noroeste de Elódia. Ele se alimenta de qualquer forma de vida que transite em seus novos domínios. O dragão era conhecido no continente por ter realizado dezenas de ataques a caravanas por todo o continente. Há a recompensa de cento e cinquenta peças de platina pela cabeça de Ordon."
> 
> </div>

<div style="text-align: justify;">

Lendo isso Kiloin não teve dúvida do que deveria fazer. Tendo certeza que estava deixando dinheiro para manter sua família por um bom período partiu para Jordânia, conquistar sua vingança. Não antes de receber como presente de Caratis um chifre de um javali atroz que era uma herança de família. Longa foi sua viagem em direção oeste. Perigos passou com criaturas de todas espécies. Desde goblins que o assaltaram na estrada até seguidores de Vecna que tentaram o sacrificar para invocar alguma besta qualquer. Porém, todos que lhe atrapalhavam provaram de seu martelo.

</div>$MDS$, array['História']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Taverna Vomito de Dragão - 1° Parte');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Czar StormRange e os StormBorns', 'czar-stormrange-e-os-stormborns', $MDS$> 📰 Blog *Mar de Sangue* · 2013-08-30 · marcadores: Exar Khun, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/08/czar-stormrange-e-os-stormborns_2712.html

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj-jn2AACUB7wt8YbPx62py6_o_YK4S-czE3O5PPEBVHuh-w6eOz_vUQFvLK36ymlE1cnNwvxGCkBfmu8j5VXsUqnVSlm93OTvOsbd6ya60mvwXS1nS9m2G-P32mGq8mc3bdk3Mx6fOA_-g/s320/385603_204280186363994_41474338_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj-jn2AACUB7wt8YbPx62py6_o_YK4S-czE3O5PPEBVHuh-w6eOz_vUQFvLK36ymlE1cnNwvxGCkBfmu8j5VXsUqnVSlm93OTvOsbd6ya60mvwXS1nS9m2G-P32mGq8mc3bdk3Mx6fOA_-g/s1600/385603_204280186363994_41474338_n.jpg) |
|                                                                                                                                                                                                                                          A Grande Capital dos StormBorns                                                                                                                                                                                                                                           |

<div class="MsoNormal">

<div style="text-align: left;">

  *(Essa história se passa entre os últimos 30 anos da Guerra dos Cem anos, há 250 anos atrás)*

</div>

</div>

<div style="text-align: left;">

     
  
O Reino Dranoriano possui treze grandes famílias, os Dranor, os Rakkar, os Trarks, os Atom, os Wiserdon, os Pethfinder, os Lordsear, os Treefeets, os Loneranger, os Bellwar, os BloodHammer os Bearclaws e os Stormborns. Todas essas famílias vêem dos doze Capitães que acompanharam o Rei Dranor e fundaram o Reino Dranoriano, eles eram os Dranorhands.  
  
Os Dranor são desde o principio a família mais importante e poderosa, e com eles está guardada a linhagem Real, o domínio sobre a cidade Capital de Dranor e o comando sobre todo o Reino . Todas as outras doze famílias possuem Cidades, Vilas e Aldeias espalhadas por toda Dranor, assim como seus próprios lideres chamados de Dranorhands. São em parte independentes comercialmente, pagando um tributo a Capital Dranor mensalmente.  
  
Cada família é conhecida por suas especialidades em áreas das artes Dranorianas. Os BloodHammer são os considerados os melhores ferreiros de Dagor, e suas armas são caríssimas mesmo no mercado Trade. Os Lordsear constroem os barcos mais belos e resistentes, enquanto os Pethfinder são os engenheiros e artesãos mais habilidosos. Outras famílias se voltaram para o comercio e pesca, e dentre estas os Stormborns se destacam.  
  
Acreditasse que Wild Stormborn fora o líder do comercio Dranoriano no inicio do reino, e que os negócios e barganhas correm no sangue de cada Stormborn. Dentre todos os Dranorianos eles são um dos maiores vendedores do óleo de Baleia Sangrenta, estando atrás apenas dos Atom. Mas a guerra é a característica mais forte no sangue Dranoriano, e os patrulheiros Stormborn causam calafrios nos inimigos de Dranor. No entanto, os Stormborn já quase caíram por brigas internas, isso ocorreu a mais de cem anos atrás, quando Czar surgiu entre os lideres da família.  
  
Próximo ao fim da Grande Guerra dos Cem Anos, a família principal dos Stormborns recebeu em sua porta um criança de colo, de cabelos brancos e olhos negros como os de um corvo, mas de pele corada e sangue forte. Não sabendo qual seria a origem dessa criança, que não aparentava um feérico ou um dranoriano, a família o guardou e criou como um bastardo e lhe deram o nome de Czar Storm. Os anciãos aconselharam a família que lançassem a criança em um abismo, pois suas características traziam marcas do Pendor das Sombras, mas os Dranorianos viram isso como uma marca de poder.

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjMehY3s8SFjloTjTpajh-aAxsfm7kvst2k89PDJkfTcb69c4yhh3lsDZ4dHRXZQ6qkGbZyiEPHwbTgDWprzFfcMXs5ylHFGTjaXelLtbbdhCD3IiytEs7i-2fmJepMnItmbMgSTvblm4jk/s400/1094680_645116865498975_328086267_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjMehY3s8SFjloTjTpajh-aAxsfm7kvst2k89PDJkfTcb69c4yhh3lsDZ4dHRXZQ6qkGbZyiEPHwbTgDWprzFfcMXs5ylHFGTjaXelLtbbdhCD3IiytEs7i-2fmJepMnItmbMgSTvblm4jk/s1600/1094680_645116865498975_328086267_o.jpg) |
|                                                                                                                                                                                                                                                 Czar em sua Juventude                                                                                                                                                                                                                                                  |

<div style="text-align: left;">

     
  
Criado entre os príncipes, Czar se tornou um grande guerreiro e líder glorioso, trazendo grandes vitórias sobre as tropas de Morcul que ocupavam o norte da Região das Florestas. Czar também mostrou-se um comerciante de mão cheia, e garantiu acordos comerciais e alianças de guerra que elevaram ainda mais o nome dos Stormborns. Mas ele era um homem ambicioso, e tinha uma voz de comando poderosa que arrastava multidões.  
  
Os Stormborns eram uma família muito grande, cheias de ramificações como os StormArrow, os StormShadow e os TakenStorm, e isso gerava certos conflitos entre lideres que traziam suas reclamações e contendas para os ouvidos do Dranorhand e dele para o Rei Dranoriano. Czar viu uma grande chance em meio a essa situação e ganhando a confiança de vários chefes de família, ele decidiu fundar uma nova família entre os StormBorns e induziu a outros lideres que também o fizessem.  
  
Intitulando-se Czar StormRange, ele definiu um acordo para a fundação de três famílias sobre o poder do Dranorhand StormBorn, semelhante a organização de Dranor e essa foi a grande divisão, que foi a fundação das famílias StormRange e StormCrow. Essas duas ramificações eram submissas aos StormBorns, que detinham a linhagem Dranorhand que teve mais tranqüilidade em resolver os problemas das ramificações que se fundiram e mudaram seus nomes para uma das três famílias.  
  
Quando Ectherion StormBorn o Dranorhand daquele tempo faleceu os StormRanges e os StormCrows começaram a discutir sobre quem deveria ascender ao trono, já que todos eram originalmente StormBorns, o que agradou Czar que buscava um meio de alcançar o título de Dranorhand. Isso, é claro, era impossível para ele, desde que ele não era sequer de sangue Dranoriano mas o fato não o impediu de mais uma vez opinar a respeito e trazer um novo acordo, aonde cada família teria seu candidato e o conselho Real Dranoriano decidiria quem deveria ser o novo Dranorhand, acordo que foi aceito de imediato.  
  
Czar já tinha sobre seu poder os StormCrows, pois seus líderes eram submissos a ele, mas para seu pesar o Grande Rei e seu Conselho escolheram Ecthor sobrinho de Ectherion StormBorn,como novo Dranorhand. Ecthor era um Feérico, filho da meia irmã de Ectherion, cujo sangue não era Dranoriano, o que levou os StormRange a se revoltarem com a decisão, pois não fora sequer permitido que Czar estivesse entre os candidatos por não ser de origem Dranoriana.  
  
Uma guerra civil estava prestes a se iniciar entre as três famílias, pois a influencia de Czar sobre os StormCrows era forte e os StormBorns, apesar de ainda os mais poderosos, talvez não poderiam enfrentar a ira das duas famílias menores. Mas os tambores da Guerra dos Cem anos bateram mais alto quando Morcul ameaçou uma investida que poderia romper a linha de defesa Dranoriana que já se encontrava muito próxima de seu reino. Porém Morcul havia se precipitado em atacar os domínios de Minus, que se enfureceu e levantou armas e pressionou as forças de Morcul que tentavam avançar pelo Sul do Continente, isso fez com que a investida contra o Norte perdesse mais de um terço de suas forças.  
  
O líder militar com maior renome entre os Storm ainda era Czar. Ele guiou as tropas das três famílias Storm para a batalha e perseguiu os que recuavam desesperadamente para se reagrupar em Morcul. Porém Czar não sabia que os StormCrows e StormBorns tramavam contra ele, em busca de restabelecer os StormBorns como uma única família. Eles abandonaram as forças dos StormRange que perseguiam as tropas de Morcul até os Vales Gorgoroth e como muitas tropas Dranorianas que avançaram para muito próximo das Montanhas de Morcul, eles foram pressionados e obrigados a buscar refúgio nos labirintos malditos daquelas montanhas. Lá eles se perderam e seus nomes foram esquecidos.

</div>

<div class="MsoNormal">

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhEVbLP9IxT7SBMbqmHAN2r3U4gz6TXhyphenhyphenO0F1t4bVj66fpCkFOX-nBGVQ2E4y5PQ4xqWfiOhd-E-MfUgc-MMSzntlQn-KPcawTgAqGdYO8Vab86PcFwUKNe-gQmA4TksTmz_2MhLwvToFBv/s400/580183_683149231702247_361515530_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhEVbLP9IxT7SBMbqmHAN2r3U4gz6TXhyphenhyphenO0F1t4bVj66fpCkFOX-nBGVQ2E4y5PQ4xqWfiOhd-E-MfUgc-MMSzntlQn-KPcawTgAqGdYO8Vab86PcFwUKNe-gQmA4TksTmz_2MhLwvToFBv/s1600/580183_683149231702247_361515530_n.jpg) |
|                                                                                                                                                                                                                                                         Czar nos Vales Gorgoroth                                                                                                                                                                                                                                                         |

<div style="text-align: left;">

            Ecthor StormBorn retornou a Dranor após vários meses de guerra que duraram até que Morcul finalmente debandou e recuou o que pode de suas tropas. O Dranorhand trouxe notícias de que em busca de um golpe Czar tentara traí-lo em batalha, mas os StormCrows suprimiram suas forças e Czar fugira para a região do Vale Gorgoroth.  
  
O Grande Rei de Dranor decidiu que Czar era na verdade um traidor enviado por Morcul, e como tal deveria ter seu nome apagado de todos os registros Dranorianos, e os StormRange deviam ser lembrados com vergonha. Czar nunca mais foi visto, e assumiram que ele foi morto ou trancado nos calabouços de Morcul por ter falhado em sua suposta missão. E de fato Czar StormRange havia morrido, ele e seus homens se perderam nas montanhas até chegar a terrível planície árida nas terras de Morcul. Lá foram tragados por uma nova arma que os Magos Sombrios de Morcul estavam estudando, uma prisão chamada Túmulo das Almas.

</div>

<div style="text-align: left;">

  

</div>

<div style="text-align: left;">

*A história continua em A Morte de Czar e a Ascensão de Exar Khun(esse título pode ser alterado).*

</div>

*  
* *StormBorns conhecidos - Quiryon StormBorn, da Irmandade Trade*  
                                       - *Úrion StormBorn e sua família da Cidade de Harad*                                                                                                      -Thalía StormBorn, filha de Úrion, segunda esposa de Hans o Bardo. **  
**

</div>$MDS$, array['Caixão das Almas','Exar Khun']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Czar StormRange e os StormBorns');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'A Morte de Czar StormRange', 'a-morte-de-czar-stormrange', $MDS$> 📰 Blog *Mar de Sangue* · 2013-09-26 · marcadores: Exar Khun, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/09/a-morte-de-czar-stormrange.html

*(Para ler esse texto é necessária a leitura do texto [Czar StormRange e os StormBorns](http://maresdesangue.blogspot.com.br/2013/08/czar-stormrange-e-os-stormborns_2712.html). Essa história se passa ao final da Guerra dos Cem Anos. Obs: palavras marcadas com '\*' terão notas ao final do texto)*  
  
     Como já foi dito nos textos históricos as montanhas Gorgoroth foram erguidas no final da Grande Guerra dos Magos, quando os Magos Elementais venceram a terrível batalha e baniram os Sombrios para fora do continente. As terríveis montanhas foram erguidas com o objetivo de garantir que os malditos magos caídos não pudessem voltar e ficassem isolados na ilha que foi separada do continente pelos bons magos elementais.  
  
Intituladas Ered Gorgoroth, na língua comum as Montanhas da Loucura, elas cercavam a região denominada Morcul - os povos do Oeste costumam chamá-las de Montanhas Morcul - uma terra árida incapaz de sustentar vida, pelo menos vida bondosa e natural. O mal dominou o lugar por anos durante a Guerra dos Magos, pois os Sombrios dominaram e região e as magias do Pendor e dos Nove Infernos impregnaram o local agindo de maneira quase tão terrível quanto os demônios fizeram nas floresta de Harad, as tornando o terrível deserto que é hoje.  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEihin-dUE5IKxuiMtccyjRTkZ3yzTizAAjewCVuQQB6EPjdt0faGOO_VTCrFfguinIaqGhdFdwPS2L0YqUSFBgUezNtNuiyWzPlLUcULuzhab_JkE1WGUBdCPELlSD2R-uaYWkyEsCHMaBY/s320/1263083_158558187683636_1644303717_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEihin-dUE5IKxuiMtccyjRTkZ3yzTizAAjewCVuQQB6EPjdt0faGOO_VTCrFfguinIaqGhdFdwPS2L0YqUSFBgUezNtNuiyWzPlLUcULuzhab_JkE1WGUBdCPELlSD2R-uaYWkyEsCHMaBY/s1600/1263083_158558187683636_1644303717_o.jpg) |
|                                                                                                                                                                                                                                              Os últimos guerreiros de Czar                                                                                                                                                                                                                                               |

      Os Magos Sombrios costumam se estabelecer nas terras de Morcul quando sua invasão é eminente. Mas demoram para atravessar as montanhas que os aprisionam, pois uma terrível magia opressora foi lançada no local, que poucas raças podem suportar, só as raças mais fortes entre orcs, goblins, ogros e trolls vivem nessas montanhas, e seres terríveis como as abominações são residentes da região. E a magia os torna mais selvagens, fortes e insanos do que eles deviam ser \[*vide* [Da ruína de Thúrin o Imprudente](http://maresdesangue.blogspot.com.br/2013/04/da-ruina-de-thurin-o-imprudente.html)\].  
       
  
Foi no meio de toda essa tormenta que Czar e seus homens se abrigaram para fugir das tropas de Morcul que os pressionaram nas montanhas Gorgoroth. Traído pelas outras famílias Storm, Czar foi cercado pelo inimigo e seus homens se desbarataram quando chegaram as bases das montanhas.  
  
Desnorteado e sem esperanças ele não teve escolha se não guiar seus companheiros, pouco mais de setecentos homens e mulheres que não debandaram ou caíram em batalham, em direção aqueles terríveis labirintos. Não havia plano ou chance de retorno, talvez um puro extinto de sobrevivência misturado a ira pela traição daqueles que um dia ele considerou seu próprio povo. Essa foi a primeira das traições que levaram Czar a sua vingança.  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh0daVC0jpl_e29XHe43y0CNMJc0X6ITQoLNDqLxOQx7rTcqX28leLd2OdQ9r6HnK8J9Wb0REg_mz-Kraf-F3w1OFysbAg2eq0eBLHILGSZVJy3oWzdT4uwWn_B-GOL6EQS9HBK_d_bwT4J/s320/eb_Dolgaunt.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh0daVC0jpl_e29XHe43y0CNMJc0X6ITQoLNDqLxOQx7rTcqX28leLd2OdQ9r6HnK8J9Wb0REg_mz-Kraf-F3w1OFysbAg2eq0eBLHILGSZVJy3oWzdT4uwWn_B-GOL6EQS9HBK_d_bwT4J/s1600/eb_Dolgaunt.jpg) |
|                                                                                                                                                                                                                        Abominação ou Aberração                                                                                                                                                                                                                         |

     
  
Os perseguidores dividiram o exercito StormRange enquanto os pressionavam, e conforme eles foram entrando nas trilhas e nos labirintos e cavernas das montanhas Morcul, os perseguidores iam diminuindo devido as baixas e pelo desespero em buscar abrigo atravessando as montanhas, em obediência a ordem de seus mestres. Ao final Czar se encontrava com menos de cem homens sobreviventes. E apesar de terem derrotado os últimos orcs, kobolds e hobgoblins eles estavam perdidos nos vales entre os precipícios das Gorgoroth.  
  
Czar vagou por semanas entre as montanhas, e a magia negra lançada sobre aquele lugar foi levando um a um de seus companheiros. Alguns foram levados a loucura e cortaram suas próprias gargantas, outros sumiam durante a noite quando eram perturbados por espíritos e aparições. A pior semana foi quando eles entraram na região das abominações, que toda noite capturava um dos homens ou mulheres. Esses eram mutilados, devorados, algumas vezes na frente dos seus companheiros, outras vezes seus restos eram encontrados na estrada. Isso não parou até que Czar enfrentou o líder maldito das criaturas, que uma noite antes havia matado e copulado com os restos do corpo de sua noiva\* enquanto ele assistia sob um feitiço de paralisia.  
  
Na tarde do outro dia, Czar chegou ao Vale Morcul, a planície além das montanhas Gorgoroth. Não sobraram mais de trinta de seus homens, não haviam mais lágrimas ou sentimento restante, tudo havia sido tirado do lider dos StormRange sua alma estava morta, Czar havia morrido junto com sua noiva. Ele mal conseguia se lembrar do próprio nome, pois a tristeza e magia negra havia consumido parte de sua sanidade. Alguns de seus homens estavam mutilados, mocos, alguns perderam a fala, eles comiam ratos e cobras, corpos de orcs e bebiam de lagoas envenenadas e assim caminharam por dias em Morcul, vendo ao longe as tropas inimigas indo para o Litoral Negro, se escondendo em buracos e usando o mínimo que podiam de magia, pois temiam que ela fosse sentida e revelasse a sua localização.  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj87BBh1ZSUkdw_-Mm_ehdoqMXucvJURsVvO_yafgne9s18aSkYrpzX9ERMY-pYTMzNGgzbmlYJHuocAFvBCfLMJcnxKKMvvW0IouG4Sl4PljHl2JGaT_y8eK8loTJ4XcXtkcfbxvRjG71V/s320/228399_241484009310278_711393251_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj87BBh1ZSUkdw_-Mm_ehdoqMXucvJURsVvO_yafgne9s18aSkYrpzX9ERMY-pYTMzNGgzbmlYJHuocAFvBCfLMJcnxKKMvvW0IouG4Sl4PljHl2JGaT_y8eK8loTJ4XcXtkcfbxvRjG71V/s1600/228399_241484009310278_711393251_n.jpg) |
|                                                                                                                                                                                                                               Czar retorna de sua luta contra o Líder das Abominações                                                                                                                                                                                                                                |

     
  
Durante uma noite medonha na quinta semana de sua longa viagem, todos despertaram ao ouvirem uma voz doce, acharam ter visto o espectro de uma bela dama que os chamava e os guiava por uma trilha tortuosa. Eles subiram um pequeno morro e ao longe viram os terríveis castelos e fortes de Morcul, aonde as tropas ainda se recolhiam, talvez na esperança de um contra-ataque ao continente. Foi quando, da maior construção no centro daquele cidade maligna, uma luz subiu ao céu. Roxa e doentia ela tocou as nuvens, e por todos os lados na planície do chão explodiam focos de luz semelhante.  
  
Eles buscaram se afastar dali, mas quando se viraram para fugir o chão se abriu a sua frente. De uma fissura uma luz verde emergiu bruxuleando e manchando os céus, partindo rochas e se tornando cada vez maior. Uma voz veio a mente de Czar, e ela dizia:  
  
\- Neste lugar, meu filho nascido nas trevas, você descobrirá quem você é, trará vingança em meu nome, pela minha vontade e seu prazer- a voz soou na cabeça de todos, quando o buraco começou a sugar tudo ao seu redor, e apanhados por aquela força Czar e seus últimos vinte e nove homens caíram naquele portal mágico, nas profundezas do Túmulo das Almas.  
  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjyU14ISiui5SqXu8EGEtYgpzfeme5BUF4nSXRfGLyMnN_JD2rHYpW07yoGS3c4OwklKgq8SpKlJOkkX0LqrOJRA9QKRPkhuwBoDSSed_iB4Ayls7ObFNJVJcWz6Vas0hp1CsERKtYmBpXp/s640/1009652_251512294974116_1914701408_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjyU14ISiui5SqXu8EGEtYgpzfeme5BUF4nSXRfGLyMnN_JD2rHYpW07yoGS3c4OwklKgq8SpKlJOkkX0LqrOJRA9QKRPkhuwBoDSSed_iB4Ayls7ObFNJVJcWz6Vas0hp1CsERKtYmBpXp/s1600/1009652_251512294974116_1914701408_o.jpg) |
|                                                                                                                                                                                                                                        Czar e seus homens alcançam o Vale Morcul.                                                                                                                                                                                                                                        |

  
Notas:  
1\. A Noiva de Czar: Sabe-se que as mulheres Dranorianas, se escolherem, podem se tornar soldados e oficiais do exercito Dranoriano. Existem grandes feitos nas histórias de Dranor realizados por heroínas. Obs: Os StormBorns são uma família Dranoriana, e as ramificações StormRange e StormCrow não diferem disso.  
  
Em Breve: O Nascimento do Túmulo das Almas. E a história de Czar continuará em *A Ascensão de Exar Khun.*$MDS$, array['Caixão das Almas','Exar Khun']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Morte de Czar StormRange');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'O Nascimento do Caixão das Almas', 'o-nascimento-do-caixao-das-almas', $MDS$> 📰 Blog *Mar de Sangue* · 2013-09-27 · marcadores: Exar Khun, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/09/o-nascimento-do-caixao-das-almas.html

<div class="MsoNormal">

(*Esse texto está vinculado a muitas das histórias do Continente, todas as mais importantes sobre o assunto estão com o marcador "caixão das almas". Obs: as marcações '\*' indicam notas ao final do texto*)          

</div>

<div class="MsoNormal">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixcVvtqGp3LxNurfqnrSlz7I55u62HDqWHi5fJHxg4MJGTahftnleHnCZCORu6ELeKTLCW6IwkjUf_7jWXqVCflMiKvdhqlDcC2PMI4EGF-pxIZO9dbL3Reu7YMMdeEvh5VjQACRydy0cK/s400/600984_249876775137668_635970867_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixcVvtqGp3LxNurfqnrSlz7I55u62HDqWHi5fJHxg4MJGTahftnleHnCZCORu6ELeKTLCW6IwkjUf_7jWXqVCflMiKvdhqlDcC2PMI4EGF-pxIZO9dbL3Reu7YMMdeEvh5VjQACRydy0cK/s1600/600984_249876775137668_635970867_n.jpg) |
|                                                                                                                                                                                                                                                    Rainha Rapina                                                                                                                                                                                                                                                     |

  
  
Rainha Rapina, não existem seres em nenhum dos mundos que possa se recordar do verdadeiro nome da deusa da morte e da vingança. Sentada sobre seu Trono ela observa e se diverte com os conflitos entre os mortais, e a execução das ordens da morte a quem ela controla. Seus domínios são vastos, e as pobres almas a servem após a morte. Melhor a ela que a algum dos Senhores dos Nove infernos.  
  
Orcus, um terrível demônio que se tornou tão poderoso que passou a desejar o reino da Senhora da Morte, começou um péssimo habito de roubar almas da rainha. Evocando mortos vivos ele tomava posse das almas das criaturas, ou enviava seus arautos para rouba-las dos mortais durante a passagem para o pós-vida. Assim ele começou a aumentar seu próprio reino e garantir um perigo para os domínios da deusa.  
  
  
Rapina, como a maioria dos deuses, é egoísta e se importa apenas com suas próprias vontades e preocupações. Ver suas almas seguindo rumos dos quais ela não desejava para ela foi como negar as vontades de uma criança mimada. E a ameaça sobre seu domínio a assustava e preocupava, e fazia seus jogos menos prazerosos . Foi quando ela iniciou seus planos para se defender.  
  
Em todos os mundos sempre houveram adoradores da deusa, e aproveitando-se disso ela iniciou a criação de seus próprios arautos. Vingadores e Paladinos, errantes do mundo, espalhavam sua palavra e tomavam de volta das garras dos necromantes e lichs de Orcus o que era de direito dos reinos de Rapina. Ela treinava seus adoráveis guerreiros, dando a eles vidas difíceis e cheias de dor, incitando o desejo por vingança e busca por poder, e assim, por um certo período, ela equilibrou a batalha e diminuiu os avanços do demônio usurpador.  
  
  
Por anos a deusa criou seus arautos, e passou a se divertir com isso. Ver um jovem perder tudo o que tinha, e o terrível e incontrolável desejo por vingança crescer em seu coração o levando a tomar almas em nome da deusa era extremamente prazeroso para ela. E assim muitos grandes heróis nasceram e suas histórias vagam pelo mundo. Mesmo na segunda Era ouvimos os contos de Belegor que liderou seu exercito sobre o terrível Reino Tielfiling de Devias\*, os fazendo fugir de seu antigo continente. Ou dos contos do Pai das Feras\*, semideus adorado por clãs Ferais e seus parentes Wargens, que venceu o Rei Esqueleto de Simbar\* e derrubou o reino dos necromantes de Orcus, e por isso recebeu um lugar ao lado de Rapina.  
  
Mas isso não bastou, Orcus é implacável e não desiste de seus objetivos, e conforme Rainha aumentava suas forças ele dobrava seus ataques. Rapina precisava expandir seu reino, criar uma força poderosa o bastante para guerrear contra continentes, e assim crescer ainda mais seu nome. Sabe-se que nos primórdios do mundo os deuses guerrearam entre si. Lutando pela posse do mundo os seguidores de Asmodeus enviaram sua maior besta contra o Campeão dos Deuses, ambos caíram na batalha, mas o sangue da besta caiu no grande Mar Astral, nas terras divinas. Lá o sangue maligno corrompeu as águas cheias de poder e criou sete seres insaciáveis em sua fome.  
  
Os Anjos lutaram contra eles antes que devorassem tudo o que viam, e necessitando da ajuda de Bahamut, finalmente eles aprisionaram as criaturas em uma Jóia. Bahamut deu a jóia a Rainha Rapina, como um presente e amostra de paz e desde então a deusa carregou a jóia consigo e passou a controlar as criaturas presas nela. Sabendo que as criaturas provaram da matéria astral, a deusa viu que poderia através dela criar um novo mundo entre os planos, aonde os deuses não pudessem interferir. Mas é proibido aos deuses fazer esse tipo de coisa, então rainha decidiu que seriam os mortais que fariam isso por ela.  
  
Juntando forças com Tiamat, a deusa usou os magos sombrios de Dagorcain. Prometendo a eles uma prisão para seus inimigos mais perigosos, e uma fonte de poder diferente de tudo que eles já haviam experimentado. Tiamat por anos queria dar a vida a um filho com poderes parecidos com o seu, um deus menor vindo de seus amados dragões cromaticos, e Rainha Rapina prometeu entregar a ela a chave para vida desde que os sombrios cooperassem com suas vontades.  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQHqvjgz_5O0_y3kcaGaBfgLh7cFg7DfKXtwShE-r2LAHupsyyoeLmvIb-1u9e2zOvtVbJmKKuy6vyjcutVSTZ0_yVcY12QZArmOtnheWpiasrGymbz9TNeeTAyTrIBlbccYqi0jOMyOgI/s400/901182_154222861450502_1827228507_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiQHqvjgz_5O0_y3kcaGaBfgLh7cFg7DfKXtwShE-r2LAHupsyyoeLmvIb-1u9e2zOvtVbJmKKuy6vyjcutVSTZ0_yVcY12QZArmOtnheWpiasrGymbz9TNeeTAyTrIBlbccYqi0jOMyOgI/s1600/901182_154222861450502_1827228507_o.jpg) |
|                                                                                                                                                                                                                                               Lideres dos Magos Sombrios                                                                                                                                                                                                                                               |

<div class="MsoNormal">

        Os Magos sombrios buscavam criar então duas novas armas para vencer a batalha contra Dagorcain, a primeira e provavelmente mais terrível seria uma versão menor da deusa Tiamat, que havia lhes prometido auxilio caso eles cumprissem o papel deles na criação desse ser, a segunda seria uma prisão para seus inimigos, aonde suas almas serviriam de fonte de poder para suas magias terríveis, logo eles aceitaram o acordo. Rapina então lançou em Morcul a jóia com os sete seres terríveis e sem nome, e ensinou aos magos um encantamento que funcionaria apenas uma vez e que daria vida ao monstro que eles estavam criando com Tiamat.  
  
Porém os magos não sabiam que naquele momento Czar e seus homens se aproximavam dos Vales Morcul, e que seriam esses os primeiros prisioneiros do Túmulo das Almas. Rainha Rapina a anos planejava não só a criação do Túmulo, como também a de seu maior Arauto. Ela guiou Czar, e garantiu que apenas os mais fortes entre seus companheiros sobrevivessem para segui-lo. Os Magos Sombrios demoraram três dias para preparem a maldição de sangue que enfeitiçaria a jóia de Rapina, para lançá-la no vazio entre os planos e assim a Jóia crescesse através do poder das criaturas e se tornassem um mundo plano.  
  
Quando usaram a magia e lançaram a pedra no vazio ela cresceu e começou a aparentar uma rocha de tamanho continental pairando com bases sobre as paredes do vazio. As criaturas haviam corrompido a matéria do mar astral, mas não haviam extinguido seu poder de criação. E um mundo contorcido, com florestas demoníacas e escuras, de rios negros e doentes havia sido criado sobre a luz da terceira Lua do mundo, a única fonte de luz que ele teria por toda a eternidade.  
  
A mente faminta das criaturas eram os ventos, os rios, a terra e o céu daquele mundo abominável. E todas as coisas vivas que caiam lá pertenciam a elas. As almas dos pobres acorrentados ali se ligavam ao Túmulo para sempre, e no lugar delas parte da magia dos sete seres preenchia o vazio deixado. E tudo que lá vivia era reduzido a loucura se não fosse suficientemente forte, e criaturas nojentas nasceram ali, diferentes de tudo que qualquer plano havia visto. E as sete criaturas pertenciam e obedeciam a Rapina, portanto aquele mundo pequeno e asqueroso era dela.  
  
Ela entregou aos magos uma Lasca da Jóia, que lhes daria poder para abrir os portais para o Caixão em Morcul. Mas em segredo manteve consigo cinco outras lascas com poderes de domínio sobre Túmulo das Almas.  
  
Os Magos lançaram no Caixão - ou Túmulo - milhares e milhares de seus prisioneiros, alimentando o Túmulo e recebendo em troca um pouco da magia negra que vinha de lá. Mas não podiam retirar seus prisioneiros. E Rainha Rapina se viu feliz ao ver que seus planos tinham se cumprindo, e com aquele novo reino ela criaria um novo exercito forte o bastante para fazer um continente inteiro só dela. E ela veria a partir disso, guerras e guerras, vingança e tudo mais daquilo que ela adorava ao assistir a vida dos mortais.

</div>

<div class="MsoNormal">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgYiaU0mJKXzeRWkzW1Yvfo31nRTfOtGro5qIKYkITKxu2k7489V5gLQmwv6cPHNeUZmIIn2a1j7Bm5ILey3LDVDtr_HFzt6RynLSvify3dwVg3AuxVwtdqkdxUQvITEECCsa3Fm37HB9LG/s640/1149408_265263343599011_354211473_o.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgYiaU0mJKXzeRWkzW1Yvfo31nRTfOtGro5qIKYkITKxu2k7489V5gLQmwv6cPHNeUZmIIn2a1j7Bm5ILey3LDVDtr_HFzt6RynLSvify3dwVg3AuxVwtdqkdxUQvITEECCsa3Fm37HB9LG/s1600/1149408_265263343599011_354211473_o.jpg) |
|                                                                                                                                                                                    Dizem que os prisioneiros do Caixão das Almas, que suportaram as tortura do lugar se uniram e formaram Reinos Terríveis e exércitos gigantescos.                                                                                                                                                                                    |

<div class="MsoNormal">

Notas: 1 - Os continentes Devias e Simbar deixaram de existir na primeira Era, sendo que Devias era o Lar dos primeiros Tielfilings, e Simbar fora também palco de batalhas envolvendo o reino demoníaco dessa raça. 

</div>

<div class="MsoNormal">

2 - Em breve será lançado um texto sobre o Pai das Feras, cuja história está vinculada aos Mãos de Prata e aos Wargens. 

</div>

  
Em Breve: ***A Ascensão de Exar Khun, a Morte do Homem e o Surgimento do lider Shadar-Kai***.$MDS$, array['Caixão das Almas','Exar Khun']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='O Nascimento do Caixão das Almas');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'A Ascensão de Exar Khun - parte um.', 'a-ascensao-de-exar-khun-parte-um', $MDS$> 📰 Blog *Mar de Sangue* · 2013-09-30 · marcadores: Exar Khun, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/09/a-ascensao-de-exar-kun-parte-um.html

## A Queda Sem Fim

<div>

*(Para melhor compreensão desse texto é necessária a leitura dos textos anteriores, contando a história Czar, todos na marcação Exar Khun. **<span class="underline">Nota</span>**: A pronuncia de Exar é "Eczar", o x não se compreende como CH, mas CZ, como "Equizar"\[Exar\]...)*

</div>

<div>

*  
*

</div>

<div class="MsoNormal">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjV0aT533OMYeKIQMTkDiEKc7MCShfVCNgAxPbWZsEScFfS64053QUbQh0sWJ0NPJXPOMyekrfL3TLm857diU4G41u5hhbb9D0Fe-SaeVz8Mj1kMwnD80kj20FyceDLno7woKhUqHYtEVvM/s400/lazarus-nebula-space-art-wallpaper-1280x720.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjV0aT533OMYeKIQMTkDiEKc7MCShfVCNgAxPbWZsEScFfS64053QUbQh0sWJ0NPJXPOMyekrfL3TLm857diU4G41u5hhbb9D0Fe-SaeVz8Mj1kMwnD80kj20FyceDLno7woKhUqHYtEVvM/s1600/lazarus-nebula-space-art-wallpaper-1280x720.jpg)        Só havia raios e escuridão, nuvens negras os selavam em uma queda eterna e profunda. Era possível ver uma das luas do mundo refletindo no céu e além da tempestade seus olhos demoraram a se acostumar com a falta de luz. Os gritos de alguns enchia suas mentes, e demorou para que se avistasse a floresta abaixo deles, que se aproximava a uma velocidade absurda.  
  
 Morte era o que qualquer um ali pensava - seria o único pensamento de alguém que estava caindo de aturas acima de montanhas. Czar não gritava, nem se desesperava, ele ansiava pelo chão, pelo firme e impenetrável chão. O limite que iria garantir que o pobre homem que nada tinha finalmente abandonasse o mundo miserável que deixou para trás. Seu povo havia sujado as mãos de sangue, traindo seus próprios irmãos e ele viu a morte de cada um. Não lhe sobrou nada se não o prazer de saber que tudo estava para acabar. "Mais perto, mais perto, VAMOS\! MATE-ME\!".  
  
Eu posso dizer a vocês que a morte os alcançou de fato, mas isso aconteceu no momento em que seus corpos foram capturados pelo portal. Aqueles pobres homens e mulheres de Dranor, guerreiros e soldados honrados, torturados até o fim de sua sanidade entre as montanhas Gorgoroth haviam morrido, pois aquela queda representava um novo nascimento para cada um deles.  
  
Seus ossos foram moídos pela queda. Sua pele rasgada pelos galhos das árvores negras e tortas, seus corpos não se mexeriam nem pela ordem de um deus. E ali eles ficaram por um mês, ou um ano, talvez uma eternidade, eles não poderiam dizer. A mente deles já estava fraca, mas um peso e uma opressão a invadia e violava, como se uma entidade que envolvia tudo, ar, terra, água e a própria escuridão, estivesse tentando destruir tudo o que sobrou nos trinta guerreiros que ali caíram.  
  
Seus músculos voltavam a responder, e aos poucos apenas vinte e cinco dos trinta guerreiros se levantaram. As risadas de Boriar, Diana e Gopim eram aterrorizantes, eles não respondiam, caídos com um sorriso doentio e sem sentindo em seus rostos, não tinham comando sobre si ou sequer personalidade, O Caixão os consumiu. Orlak e Dorá-Mel tinham convulsões, estatelados ali no chão era como se uma presença copulasse com seus corpos, como a Abominação fez com a noive de Czar. Era possível ver ervas daninhas enraizando e adentrando seus corpos, eles agora faziam parte daquele mundo asqueroso.  
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg6NlYfuMzIx49pkh8VrU4E8s06Rc8gRv-VrVyg2Aied0NlvJV8MyGGRRlwKB_a1mK_Gfqm6tIh5LHq9Pwh9YZBTJqiHPlbcjl0GlIx9p3v90f2zAA9qyuGoCorw3JcK0GQqKg6WBl77_hP/s400/env-glenwoodforest-full.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg6NlYfuMzIx49pkh8VrU4E8s06Rc8gRv-VrVyg2Aied0NlvJV8MyGGRRlwKB_a1mK_Gfqm6tIh5LHq9Pwh9YZBTJqiHPlbcjl0GlIx9p3v90f2zAA9qyuGoCorw3JcK0GQqKg6WBl77_hP/s1600/env-glenwoodforest-full.jpg)

</div>

Buscando sair daquela floresta obscura eles vagaram por dias. Se deparavam com criaturas horrendas, e as matavam para se alimentar. Era uma fome que não se satisfazia e nem matava o faminto. As águas de Morcul pareciam doces na lembrança quando provaram as águas daquele mundo, uma lembrança que retornava aos corpos junto com idéias, pensamentos. Levaram dias para de fato retornarem a si, quando suas mentes conseguiram se recuperar, mas em alguns casos isso não aconteceu. Dorian e Celena desapareceram na floresta, corriam loucos e desbaratados, fugindo de um inimigo invisível ou escondido nas trevas do mundo.  
  
Czar via e sofria ainda mais, seus irmãos, seus únicos irmãos a cada dia tragados pela loucura, "*quantos mais irei perder, quando somos tão poucos*?". Após o que pareceram semanas ou anos, eles alcançaram uma planície gigantesca, e sobre um monte observaram a distancia. A mais ou menos duzentas milhas a luz da lua refletia no que parecia ser gigantesco mar interno, a leste, um descampado árido se erguia e terminava em montanhas muito altas, e ao Oeste havia um amontoado de montes e cerras, com vales de gramados negros e sinistros, com pequenos bosques com arvores medonhas e secas, e o norte seguia até aonde a vista alcançava, variando entre montanhas, planícies e vales escuros.

</div>

<div class="MsoNormal">

  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgxbvd11gW8jVv8aERhg23AqZm0FX1oB-OfxLFVRtDKVj8L6NbxM0FofCKZirhZtlqNaTGps0pTkJioHVHxCrQ0Z83E5QEGarJpOv_86zior_JBwPE651tgyydcrKO0Ii9aF01HLq6ibJFw/s400/TheShadowfell.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgxbvd11gW8jVv8aERhg23AqZm0FX1oB-OfxLFVRtDKVj8L6NbxM0FofCKZirhZtlqNaTGps0pTkJioHVHxCrQ0Z83E5QEGarJpOv_86zior_JBwPE651tgyydcrKO0Ii9aF01HLq6ibJFw/s1600/TheShadowfell.jpg)

</div>

 Não havia beleza ou alegria, e a vida que nascia ali era tão grotesca que fazia de um Funesto uma bela visão. Eles não sabiam aonde estavam, o tempo não fazia sentido, ao mesmo tempo que pareciam ter passado eras, não parecia ter passado um minuto.  
  
Andaram milhas e milhas intermináveis quando finalmente chegaram ao  mar interno. As águas eram negras, haviam peixes estranhos e animais selvagens com definições anormais e terríveis de olhar. A cada dia que passava uma estranha força crescia em cada um dos guerreiros. Pareciam estar mais resistentes e o mundo ao seu redor mais normal.  
  
Mesmo ali haviam noites, quando uma tempestade diária surgia e cobria a luz da grade Lua. Em uma dessas noites uma matilha de criaturas velozes que pareciam cães crescidos cheios de chifres e carapaças, os cercaram quando algo estranho aconteceu. Czar olhava no fundo dos olhos do que parecia ser o líder da matilha e este sucumbiu a sua vontade. Imitando seu líder os outros guerreiros fizeram o mesmo, e ao final toda a matilha estava submissa aos vinte e três guerreiros.  
  
Czar passou a acreditar que o lugar estava dando poder a eles, aos sobreviventes. Como se os tivesse selecionado, garantido que os mais fortes sobrevivessem para serem amaldiçoados com sua magia escura que os tornava mais fortes a cada dia. Porém algo diferente atingia Czar, sua pele escurecia a cada dia, descascava, e seus olhos enegreciam e ficavam cada vez mais com os olhos de um corvo, isso o perturbava, pois não entendia o que estava acontecendo.      

<div>

  

</div>

</div>

## A Seguir: Parte 2 - A Morte do Homem

  

<div class="MsoNormal">

  

</div>$MDS$, array['Caixão das Almas','Exar Khun']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Ascensão de Exar Khun - parte um.');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'A Ascensão de Exar Khun - parte dois.', 'a-ascensao-de-exar-khun-parte-dois', $MDS$> 📰 Blog *Mar de Sangue* · 2013-10-01 · marcadores: Exar Khun, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/10/a-ascensao-de-exar-khun-parte-dois.html

## A Morte do Homem

*(Lembrem-se que as imagens podem ser visualizadas em tamanho grande ao clicar nelas\!)*  
*  
*  

<div class="MsoNormal">

     Foram uma vez despertados por uma forte luz, quando de longe viram o que parecia uma criatura cair do céu, ela era grande, possuía asas gigantescas. Aparentava um dragão, mas nunca tinham visto uma criatura da raça tão grande, nem mesmo dragões anciões chegavam aquele tamanho.  
  

<div class="separator" style="clear: both;">

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjCqVEjLs2OmGvig1AKLOmoHcX1UADwJCPY5oFI5mwKo8mmh0tgz-WAEkP_XMQ87-900s2RVoEqlttwt77_ohMcRvKdy0DI9RI_VvqucuUBedRs6fxOdIYGQrRgFMFoxeYxUIlduQ3R5jUe/s400/129534.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjCqVEjLs2OmGvig1AKLOmoHcX1UADwJCPY5oFI5mwKo8mmh0tgz-WAEkP_XMQ87-900s2RVoEqlttwt77_ohMcRvKdy0DI9RI_VvqucuUBedRs6fxOdIYGQrRgFMFoxeYxUIlduQ3R5jUe/s1600/129534.jpg) |
| Exar e Nara batalham contra os Emissários de Orgog                                                                                                                                                                                                                                                                                                                                                                                                           |

Luzes explodiram no céu por muitos dias. Uma vez, próximo a eles, uma criatura caiu, um soldado torturado, aparentava um dos paladinos de Elódia que agora parecia uma memória de Eras passadas. Foi quando Czar entendeu aonde eles estavam. Era uma prisão, um lugar aonde os inimigos e criaturas indesejáveis pelos Magos Sombrios estavam sendo lançadas.  
  
Czar e seus homens se mantinham afastados, sabiam que mais moradores chegavam ao local todos os dias, enquanto eles exploravam as terras desconhecidas. Com o tempo aprenderam a se guiar no lugar como ninguém, conseguiam chegar as cavernas pavorosas mais distantes e retornar em segurança pelos mesmos caminhos que tinha ido. Mas suas idas e vindas eram notadas por um ser obscuro que residia ali.  
  
Desprezível e gigantesco, Orgog possuia patas como as de um escorpião, e seus braços eram providos de laminas gigantescas que cortariam tudo, rocha, pedra ou aço. Sua raça existia em boa quantidade no Caixão, e ele era um dos chefes daquelas criaturas. Czar e seus homens já tinha visto muitas daquelas manadas a distancia enquanto as evitavam.  pareciam ser mais inteligentes que outros seres do Caixão, mas a malicia da mente de Orgog, o primeiro senhor das Bestas, era tão sádica quanto a dos magos Sombrios.  
  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgodo0Q8XpihN7pLDvNApIc8hyphenhyphensaGgAozl5pQSP1GQKqP0MAtXovv3SARdUyfOOPtMr_QECJTCbQ5XL8F3kBdW3F00MxMHqis6lqf8_RKWL0K_N0bGJikzeWCpLWvGR8DAmLoxC7AkTTonh/s400/Uberlisk_by_metalpiss.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgodo0Q8XpihN7pLDvNApIc8hyphenhyphensaGgAozl5pQSP1GQKqP0MAtXovv3SARdUyfOOPtMr_QECJTCbQ5XL8F3kBdW3F00MxMHqis6lqf8_RKWL0K_N0bGJikzeWCpLWvGR8DAmLoxC7AkTTonh/s1600/Uberlisk_by_metalpiss.jpg) |
|                                                                                                                                                                                                                                       Orgog o Primeiro Senhor das Feras                                                                                                                                                                                                                                        |

Orgog via um grande potencial em Czar e uma noite enviou um de seus emissários, criaturas humanóides que pareciam Abominações com músculos mais expostos e carapaças que cobriam toda sua pele. As criaturas não sabiam falar, mas emitiam um som horrível que torturava os ouvidos. Desse modo elas se comunicavam direto com a mente de quem ouvisse, e diziam:  
  
\- Nosso mestre os almeja para sua armada, o dominador das bestas lhes da a honra de servi-lo e chamá-lo de senhor, se vocês recusarem, serão entregues aos Setes Devoradores.  
  
Czar sempre fora conhecido por seu orgulho, que depois de tantas labutas se aflorou, e explodiu sobre os emissários dizendo:  
  
\-Quem são vocês e quem seria seu mestre covarde que manda criaturas nojentas aos meus pés implorar por meus serviços? Dominador de Feras você diz, mas olhem em volta, pois dominamos algumas para nos - da escuridão olhos verdes começaram a aparecer ao redor dos Emissários - antes que estes os devorem permitirei que um escape e que envie uma mensagem para seu lider, diga que Czar, o primeiro prisioneiro dessa terra negra ainda pisará sobre a sua cabeça\!  
  
Sem precisar de alguma ordem as criaturas que Czar chamava de Nydios, avançaram e destroçaram os emissários que não morreram sem lutar e demonstraram serem ferozes também. Czar deu ordens para que caçassem mais Nydios e outras criaturas para aumentar suas forças, pois um Orgog responderia logo.  
  

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td style="text-align: center;"><a href="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgshKqxojwXQk8_9perL5EdhSFjPi5gaGeTKzbSBbg2rXU1Blg_B39ZzXp2JrJHAgIuC1dXApdi0WDWmu7GT1-qeTIpmx1AG4qA3u-DNHz1izVQGQBCqBrA13_LSXams3OedvHqs94hFXj5/s1600/Zergling_by_artfreakguy.jpg"><img src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgshKqxojwXQk8_9perL5EdhSFjPi5gaGeTKzbSBbg2rXU1Blg_B39ZzXp2JrJHAgIuC1dXApdi0WDWmu7GT1-qeTIpmx1AG4qA3u-DNHz1izVQGQBCqBrA13_LSXams3OedvHqs94hFXj5/s320/Zergling_by_artfreakguy.jpg" width="320" height="232" /></a></td>
</tr>
<tr class="even">
<td style="text-align: center;">Nydio, ilustração presente no catálogo de Espécies<br />
de Elódia. (Extramente sigiloso) </td>
</tr>
</tbody>
</table>

 E mais cedo do que esperavam ele veio. Aquele ser colossal acompanhado de várias bestas a seu comando alcançou Czar depressa, e eles travaram uma grande batalha. Nara, uma Feérica Feiticeira consideráda bastarda dos StormBorn assim como Czar era sua amiga de infancia e lutava a seu lado quando Orgog com seu tamanho descomunal ficou impaciente e decidiu investir ele mesmo contra Czar que massacrava muitas de suas criaturas. Suas patas faziam a terra tremer, ele pisoteava os Nydeos e Hydras de Czar como se não passassem de pedras . Fugindo do caminho da fera Czar se lançou para o lado, e cortou com sua espada  a pata dianteira de Orgog. Mas a criatura havia pego Nara, e seu corpo jazia empalado pela lamina esquerda de Orgog, que riu da face surpresa de Czar. Orgog ergueu o corpo até a sua boca e deixou o sangue correr depois lançou os restos ao chão.  
  
A arma secreta dos homens de Czar era um Pútrido, como eles os chamavam, uma criatura cavadora de túneis, maligna e selvagem, que com muita dificuldade fora dominada. O Pútrido surgiu da terra e avançou contra Orgog que ia na direção de Czar que estava distraído e desesperado vendo o corpo de Nara. Os Vermes Pútridos são gigantescos, e mesmo Orgog teve dificuldades de se desvencilhar da criatura.  
  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjG_mqQaCUsRal55tLl7C5h_B2e26QUIUK18XnmdSUoAtK-ZNFfbDna6aG0_Bg5P1LLGBIXw4Lb0tFPmVPLZVgbHP8N4_1z3UYCt0dG0mfp49xF9uF1In_4AAKUhODY7ImQyYziZFWEEF-b/s320/magic+the+gathering+fantasy+art+creatures+artwork+jason+chan+1280x800+wallpaper_www.wallmay.com_35.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjG_mqQaCUsRal55tLl7C5h_B2e26QUIUK18XnmdSUoAtK-ZNFfbDna6aG0_Bg5P1LLGBIXw4Lb0tFPmVPLZVgbHP8N4_1z3UYCt0dG0mfp49xF9uF1In_4AAKUhODY7ImQyYziZFWEEF-b/s1600/magic+the+gathering+fantasy+art+creatures+artwork+jason+chan+1280x800+wallpaper_www.wallmay.com_35.jpg) |
|                                                                                                                                                                                                                                                                                                                   O Verme Pútrido                                                                                                                                                                                                                                                                                                                    |

Czar observou as ervas daninhas reclamarem sua amiga mais intima, a única que ele poderia amar um dia depois da morte de sua noiva, dos poucos companheiros que lhe restavam. Agora ela pertencia ao Caixão, e seus olhos veriam a eternidade passar enquanto os Sete Devoradores a tomavam para si. Orgog logo atordoou o Pútrido, e se sentiu satisfeito ao observar a sina de Czar. Quando todos os últimos guerreiros foram cercados ele deu um basta ao conflito, e disse:  
  
\-Todos os seus companheiros serão meus escravos, servirão até encurtarem as patas e mostrarem as ancas, e quando isso acontecer serão dados de alimento, e eu beberei o sangue deles como fiz com essa imunda. E quanto a você, deixarei para que enlouqueça, pois minha mente viu a sua e eu sei que estou tomando tudo o que lhe resta.  
  
Abandonado pela mais Vil criatura, atordoado por algum feitiço, Czar chorou sobre o corpo da amada. Ele urrou para o céu e antes de entregar sua sanidade e permitir que as ervas daninhas o reivindicassem, um desejo de vingança doentio tomou seu coração. Czar não existia mais, ele não fora forte o bastante e tudo que teve lhe foi tomado. Ele já não se importava com a morte, pois havia morrido nas terras de Morcul, e agora mesmo sua sanidade era uma grande tortura.  
  
 Foi quando a mesma voz que falara com ele antes que caísse no portal tomou a forma de uma bela mulher a sua frente, dizendo:  
  
\- Então, você finalmente está pronto para retornar, meu filho nascido nas Trevas, meu Exar Khun.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

  

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiUkljFB4bubaqrMNP3qk9ZAX_LjW7EekGjQt1F_jMRNC00c_ASmSXixVFauhhVfFkv9UXjAGJj_ysYhyphenhyphenDppttlUIQKIj6UKFiHbje6moNd4z19B3dib5PYzyJeGF30pm77hA0SlMKUXRXo/s320/sorin_markov_speedpaint_by_kaio89-d3bpdaz.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiUkljFB4bubaqrMNP3qk9ZAX_LjW7EekGjQt1F_jMRNC00c_ASmSXixVFauhhVfFkv9UXjAGJj_ysYhyphenhyphenDppttlUIQKIj6UKFiHbje6moNd4z19B3dib5PYzyJeGF30pm77hA0SlMKUXRXo/s1600/sorin_markov_speedpaint_by_kaio89-d3bpdaz.jpg)

</div>

### A Seguir: Parte 3 - O Nascimento do Lorde Shadar-Kai$MDS$, array['Caixão das Almas','Exar Khun']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Ascensão de Exar Khun - parte dois.');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'A Ascensão de Exar Khun - parte três.', 'a-ascensao-de-exar-khun-parte-tres', $MDS$> 📰 Blog *Mar de Sangue* · 2013-10-02 · marcadores: Exar Khun, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/10/a-ascensao-de-exar-khun-parte-tres.html

## O Nascimento do Lorde Shadar-Kai

<div>

  
  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgMgE22PjTgS6LsvqKZjqAdabu8EiaUpSG3f0zE0PPlr_HX1-WIWo2QBzemJyFukFTnb1ZxvVCDk85dTMppqEszMsAwODAaehyphenhyphenMHqL1ZmChnwFrSToJCN9kUHB8dKoOawvt_X6lLGWVF5mX/s400/download+\(1\).jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgMgE22PjTgS6LsvqKZjqAdabu8EiaUpSG3f0zE0PPlr_HX1-WIWo2QBzemJyFukFTnb1ZxvVCDk85dTMppqEszMsAwODAaehyphenhyphenMHqL1ZmChnwFrSToJCN9kUHB8dKoOawvt_X6lLGWVF5mX/s1600/download+\(1\).jpg) |
|                                                                                                                                                                                                                                  Mercados Localizados no Pendor                                                                                                                                                                                                                                  |

O Pendor das Sombras é conhecido por suas florestas perigosas e sombrias, seus céus que estão quase sempre tempestuosos trazem uma escuridão sobre as terras do plano das sombras. Criaturas perigosas e sombrias são oriundas do Pendor, como os conhecidos Shadar-Kai, e muitas almas no pós-vida são para lá enviadas.

</div>

  
Os Shadar-Kai são como a visão de um espelho maldito que reflete a imagem distorcida dos Eladrins, que vem de Agrestia, que nada mais é que o eco cheio de luz da boa mágica do mundo original, enquanto o Pendor foi o eco sem vida de sua magia maligna. Possuem Olhos negros como corvos, pele acinzentada e escura, seus cabelos são geralmente Brancos e Adornados mas variam as cores, podendo ter cabelos negros e castanhos. Usam piercings por todo seu corpo e se cobrem de tatuagens e símbolos mágicos em nome de sua fé e geralmente existe um ritual de passagem para iniciar o uso desses adornos.  
  
Reunidos em clãs, formam pequenas aldeias e são muito apegados a deusa Rapina. Deles vêem assassinos destemidos e bruxos com extraordinárias habilidades. São fortes por natureza e tem grande afinidade por magia negra, acima de tudo não temem a morte, jamais. Acreditam que a morte é um destino belo  que não poderia por nada ser alterado, e caso seja, a justiça em nome de Rapina deve ser levado aquele que desrespeita as leis da morte.  
  
Em um clã conhecido como Khun, o Lorde Odar Khun teve um filho com a rainha das bruxas Shadar-kai, Kiará Khun. Mas na noite do nascimento uma das Bruxas entrou em comunhão com a deusa Rapina, e recebera uma mensagem que simbolizava grande honra a qualquer Clã Shadar-Kai.  
  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi0B4nAZpGGJIXYb5SLWSTBX1Emmq5AfzKt8axcxb0jvIpvlpDLcCQ3Z-BFrq8njQJZtrUfGNLQhIDenAAWIpP-0xsEbDoItt7dy6xCyQ9tT1j23HupegMoev-UxMyLGWrw_Tyfps3gMUCd/s640/shadarkai_illo.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi0B4nAZpGGJIXYb5SLWSTBX1Emmq5AfzKt8axcxb0jvIpvlpDLcCQ3Z-BFrq8njQJZtrUfGNLQhIDenAAWIpP-0xsEbDoItt7dy6xCyQ9tT1j23HupegMoev-UxMyLGWrw_Tyfps3gMUCd/s1600/shadarkai_illo.jpg) |
|                                                                                                                                                                                                               Da direita para esquerda: Kiará Khun e Odar Khun                                                                                                                                                                                                               |

Há milênios a deusa visitava os clãs e escolhia um recém nascido para liderar uma elite de guerra em nome da Rapina nos continentes de Skard, o mundo Original. Levados quando jovens essas crianças fizeram grandes feitos em nome da deusa, liderando grandes clãs de assassinos. Mas uma raça sempre atrapalhava os planos da deusa, e ao mesmo tempo a divertia, pois seu noivo, o Pai das Feras, sempre escolhia arautos para si que formavam clãs poderosos de Ferais e Lobisomens contra os Assassinos de Rapina que possuem nomes diferentes em cada lugar que surgem.  
  
Mas algo peculiar foi decido na noite do nascimento de Exar Khun. Odar Khun, seu pai, já havia dominado cinco clãs inimigos e subjugado seus lideres os entregando para a deusa da morte, e Rainha muito contente com os feitos de Odar e a servidão de Kiará Khun, decidiu que seu filho serviria para um plano muito maior que qualquer clã de assassinos que ela houvera criado.  
  
Ao contrário de todos os outros, Exar Khun seria escondido na maior força de guerra do continente Dagorcain ainda bebê, e lá seria transformado em soldado pelos maiores militares do Continente. E os chamados Dranorianos jamais saberiam que estavam criando consigo um de seus maiores oponentes. A deusa já havia enganado os Magos Sombrios, fazendo eles criarem o Caixão das Almas, aonde seu filho das trevas seria moldado e retiraria poder para frear os malditos Sombrios que aliados a Orcus, auxiliaram o demônio a crescer sobre Dagorcain.  
  
A criança tinha sido disfarçada para aparentar um humano e certamente o orgulho e o desejo por poder dranoriano faria a família que a acolhesse o ver como um poderoso aliado no futuro. E assim Exar fora adotado pela prospera e poderosa família StormBorn e grandes feitos ele realizou ali sob o nome Czar StormRange. Mas tudo aquilo tinha um objetivo, e Czar StormRage logo trilharia seu verdadeiro caminho para se tornar o poderoso e impiedoso líder que Rainha Rapina desejava.  
  
Rainha Rapina fez com que Czar perdesse tudo o que ele tinha. Foi traído por quem ele acreditou ser seu próprio povo, foi obrigado a caminhar pelos caminhos mais horrendos de Dagorcain aonde viu sua própria noiva ser mutilada e dezenas de seus companheiros assassinados. Foi enviado para planícies impiedosas de Morcul e de lá lançado no terrível mundo do Caixão das Almas.  
  

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi_tLSBEo0wOqdhyphenhyphenE5fGFVLRubc-RSkquAMglDVkwKL8vwMYp4qGMTZckFqrIC3AnqpNk0Bv0OdwxKaHxpFZhTCMl8pZtKWmfNO2HpxiK4uAdBr7WcNydK3iOEYNUR0QDU4mHlzXy63xCUZ/s400/kyrion.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi_tLSBEo0wOqdhyphenhyphenE5fGFVLRubc-RSkquAMglDVkwKL8vwMYp4qGMTZckFqrIC3AnqpNk0Bv0OdwxKaHxpFZhTCMl8pZtKWmfNO2HpxiK4uAdBr7WcNydK3iOEYNUR0QDU4mHlzXy63xCUZ/s1600/kyrion.jpg) |
|                                                                                                                                                                                                                           Exar Khun na Cidade Cryptawn                                                                                                                                                                                                                           |

No Caixão, um ambiente coberto por uma magia muito próxima a do Pendor, já que as Sete criaturas vinham do sangue maligno da Besta de Asmodeus, também responsável pela magia do Pendor das Sombras, Czar não só se tornaria extremamente poderoso como revelaria a verdadeira forma de sua raça. E no momento certo, depois de caminhos terríveis que o treinariam e moldariam, ela o encontraria e lhe direcionaria para o verdadeiro caminho que deveria seguir.  
  
Seu verdadeiro nome lhe seria revelado, e depois de vencer seu maior desafio, retornaria a Dagorcain para liderar uma das forças mais podereosas daquele continente, junto com seus vinte um homens, selecionados e preparados pela deusa para auxiliá-lo. E a hora finalmente havia chegado.  
  
Sob a luz da Lua do Caixão das Almas estava um ser que não sabia sua verdadeira raça, e que não conhecia seu próprio nome. Ali de joelhos urrando pela morte de sua mais amada companheira, derrotado e sem nada, tudo lhe havia sido tomado, mesmo a luz do Sol. Este ser só possuía ódio, dor e agonia. E a deusa, ali, próximo a ele, moldou seus sentimentos e os guiou para a sua mais bela ferramenta, o desejo de vingança.  
  
A deusa moldou tudo o que ele era, e tornou tudo em um puro desejo de vingança que precisava apenas ser guiado. E Rainha Rapina, finalmente, pode chamar seu filho pelo seu nome. Seu filho o Lorde por direito do clã Shadar-kai Khun, arauto de sua palavra, Exar Khun, o nascido nas trevas.  
  

## A Seguir: Parte 4 - Libertação do Cativeiro$MDS$, array['Caixão das Almas','Exar Khun']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Ascensão de Exar Khun - parte três.');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'A Ascensão de Exar Khun - parte quatro. Final', 'a-ascensao-de-exar-khun-parte-quatro-final', $MDS$> 📰 Blog *Mar de Sangue* · 2013-10-03 · marcadores: Exar Khun, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/10/a-ascensao-de-exar-khun-parte-quatro.html

## 

## Libertação do Cativeiro

<div style="text-align: justify;">

*(Essa saga acompanhou a historia de Exar Khun e seus homens em sua primeira estadia no Caixão das Almas)*

</div>

<div style="text-align: justify;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgS8HoidXGLBCh_IeE1txDL_8IOir8ifyym5MpjxkdqnpXlZ7xJBXSFaJ8fC3EoMYuvOk_BLoTY7vVSylEFoG-ay1hq6LK-iHDTa9SIEm5UHi5a519qKLp_TilBsJ8LM3mzKhkbpthT0_uP/s640/women+redheads+fantasy+art+1920x1080+wallpaper_www.wallmay.com_76.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgS8HoidXGLBCh_IeE1txDL_8IOir8ifyym5MpjxkdqnpXlZ7xJBXSFaJ8fC3EoMYuvOk_BLoTY7vVSylEFoG-ay1hq6LK-iHDTa9SIEm5UHi5a519qKLp_TilBsJ8LM3mzKhkbpthT0_uP/s1600/women+redheads+fantasy+art+1920x1080+wallpaper_www.wallmay.com_76.jpg) |
|                                                                                                                                                                                                                                                   Quandro do Grande Artista de Dagorcain, Lucios Prestos. "O Mito de Exar Khun"                                                                                                                                                                                                                                                    |

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Meu ... Exar Khun, meu filho nascido das trevas. Lembre-se de quem você é\! Filho de Odar e Kiará.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

A voz bruxuleava a seu redor em forma de uma nevoa estranha. Ele não sabia que tipo de feitiço era aquele, mas agora sabia que a loucura não era o caminho que deveria seguir. Seus últimos companheiros lhe foram tomados para sofrer pela eternidade e por mais que a tristeza pela morte de Nara o torturasse ele não deveria ficar ali parado.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Seu ódio se tornou um desejo insaciável de vingança, ele não temia mais a morte. Salvaria seus homens ou morreria tentando. Czar StormRange não foi forte, mas ele seria.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- O que vai fazer? - Dizia a voz da deusa que dançava nos pensamentos do homem - Para onde vai?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Eu não sei se a loucura já tomou parte da minha sanidade, ou se você é algum feitiço que ainda desconheço - disse o homem - Sei que não há nada a perder, irei a caçada mais perigosa de meus anos e não permitirei que nada mais me seja tomado.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\-Você pode morrer\! Shhhh\! Que chances tem contra Orgog, filho das trevas? - A deusa brincava e moldava os sentimentos da pobre criatura.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Eu percebi que a morte é o destino de tudo e não há porque temê-la ou não desejá-la. Eu conheci a morte mais do que qualquer um, amiga intima de meus caminhos ela tem sido, agora posso abraçá-la.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- O que poderia fazer contra Orgog?\! Ele possui muitos servos sobre seu controle\!

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Orgog adentrou minha mente quando teve a chance, mas pude sentir a dificuldade que teve para fazer. Ele tentou me dominar como fez com as criaturas desse mundo, mas eu também posso fazer isso, por algum motivo tenho muita afinidade a magia deste lugar e me destaco entre meus homens quando tento dominar qualquer criatura, e Orgog, apesar de suas peculiaridades, continua sendo uma.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- É um plano arriscado. - disse a deusa - A mente de Orgog é poderosa, sua "peculiaridade" vem dos Sete Devoradores, ele não poderia ser facilmente derrotado por ninguém, a ele foi dado direitos nesse mundo que nenhuma outra criatura tem... shhhh\! Você vai morrer\!

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Eu não temo a morte. Porque me chama de Exar Khun? O que significa?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\-Shhhh\! Significa poder e vingança. Significa você\! - Tudo caminhava de acordo com as vontades da deusa.

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhMai8KtOo1Ry7mP_8Bu9AsejYxvQR0WPPIIUP80tUplwoy-sAbYwOTOiQLOoZIjIxEOLBHKl3Dq5tuvE_sZbrzI8jdmAqlq6bZ5_NH9ha5OTWGRT5j0aSCugsWAsK8nGtPRxhn3vv2yFhG/s640/_-World-of-Warcraft-The-Burning-Crusade-PC-_.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhMai8KtOo1Ry7mP_8Bu9AsejYxvQR0WPPIIUP80tUplwoy-sAbYwOTOiQLOoZIjIxEOLBHKl3Dq5tuvE_sZbrzI8jdmAqlq6bZ5_NH9ha5OTWGRT5j0aSCugsWAsK8nGtPRxhn3vv2yFhG/s1600/_-World-of-Warcraft-The-Burning-Crusade-PC-_.jpg) |
|                                                                                                                                                                                                                                                             Terra das Bestas                                                                                                                                                                                                                                                             |

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

A primeira batalha contra Orgog havia sido travada na grande planície do Caixão. Uma região coberta pela grama negra e arbustos até onde a vista alcançava. A sudeste dali havia a Terra das Bestas. Czar e seus homens descobriram que aquele lugar era cheio de ninhadas e gerava as mais diversas criaturas do Caixão, e agora Exar Khun seguia para lá, pois ali encontraria o esconderijo de Orgog.

</div>

<div style="text-align: justify;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgjPCkImdiu591WrniOvkVOGXQyQtK-xPj4rBvd4Wwmo0goEIsgF4aJviNjh7WkYRpXEuiia01mPOnM9maY3RnTEwroobBmnH4MXkg6Lx2ggft_aIz7cQG5TSn1zRuB9KyRksHA3RJs43Zp/s320/393188.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgjPCkImdiu591WrniOvkVOGXQyQtK-xPj4rBvd4Wwmo0goEIsgF4aJviNjh7WkYRpXEuiia01mPOnM9maY3RnTEwroobBmnH4MXkg6Lx2ggft_aIz7cQG5TSn1zRuB9KyRksHA3RJs43Zp/s1600/393188.jpg) |
|                                                                                                                                                                                                     Verme Alado, costuma viver no Mar Interno do Caixão                                                                                                                                                                                                      |

<div style="text-align: justify;">

A terra era negra, e sem qualquer tipo de mato ou arbusto, uma zona árida e rochosa. Das rachaduras no chão uma luz espectral verde subia como uma fumaça agourenta. Rochas pontiagudas surgiam do solo, e muitos perigos espreitavam a região.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Em vários momentos Exar foi atacado por Nydios e Hidras de todas as espécies, porém, muitos ele tomou para si, e conforme ele caminhava por aquela terra negra ele erguia uma tropa de bestas a cada ataque que sofria, e marchava na direção de Orgog. O lugar era tomado por Vermes Pútridos, e

</div>

<div style="text-align: justify;">

Esgueiradores, que vinham para defender as terras de seu Mestre, mas o ataque de Exar era implacável, e suas forças aumentavam cada vez mais.

</div>

<div style="text-align: justify;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgJ1-2zRRJqGqpbOhdPsfQUb9HrFB2fBkmVkm-6m5EsM9gnWi9W-7g36lB5xJKKUx_Q5CHxEgqkZBuvFxQJoWgL8L-2oYDCfRIK3MAwIQr5vNQzsUCSrfoWY6RreNcWIRr-sfHDgI7eIkeb/s320/kekai-kotaki-dragoes11.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgJ1-2zRRJqGqpbOhdPsfQUb9HrFB2fBkmVkm-6m5EsM9gnWi9W-7g36lB5xJKKUx_Q5CHxEgqkZBuvFxQJoWgL8L-2oYDCfRIK3MAwIQr5vNQzsUCSrfoWY6RreNcWIRr-sfHDgI7eIkeb/s1600/kekai-kotaki-dragoes11.jpg) |
|                                                                                                                                                                                                                                       Vermes Pútridos                                                                                                                                                                                                                                        |

<div style="text-align: justify;">

Vermes Alados vinham pelos ares e batalhas foram travadas ali, entre feras e feras. Muitos dos prisioneiros do Caixão falaram sobre essa guerra na eternidade daquele mundo. Uma batalha que tiveram medo de ver de perto, mas ouviam os sons e observaram os horrores a distancia.

</div>

<div style="text-align: justify;">

O Verme Pútrido que havia dominado tempos atrás o acompanhava, e ao longe Exar avistou uma fortaleza de rocha e pedras, que se erguiam como espinhos que espetavam o céu escuro. As rochas eram armadilhas ambulantes, suas pontas atravessavam carne com facilidade, mas uma carapaça poderia resistir.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Com o comando de Exar o Verme Pútrido saltou da terra em direção as rochas em forma de lanças que cercavam aquela pequena montanha negra. Abrindo um caminho em meio a desolação, o verme cavou um túnel que adentrava a montanha. Exar seguia logo atrás com seu novo exercito de bestas, indo de encontro com Orgog que tinha suas moradas nas profundezas.

</div>

<div style="text-align: justify;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj1BdWbfdR3VpJ-N71urcmovS0_bVifO34V5rpIoPc3wx2gOw04Up85F10AVrCaknGwmF0q-IuEL5b7U-IEvJNdkf-PV3Jsa7xAIHUA698uKLiNYEQwNYUy-AtlRXNTr8UzebHC97L7MGh5/s320/blades-edge-mountains-full.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj1BdWbfdR3VpJ-N71urcmovS0_bVifO34V5rpIoPc3wx2gOw04Up85F10AVrCaknGwmF0q-IuEL5b7U-IEvJNdkf-PV3Jsa7xAIHUA698uKLiNYEQwNYUy-AtlRXNTr8UzebHC97L7MGh5/s1600/blades-edge-mountains-full.jpg) |
|                                                                                                                                                                                                                                          Fortaleza de Orgog                                                                                                                                                                                                                                          |

<div style="text-align: justify;">

Apesar de novamente surpreendido pelo Verme Pútrido, Orgog havia se preparado para aquele ataque. Quando o Verme alcançou o grande vão de sua caverna e saltou sobre ele, um exercito de bestas aguardava Exar que logo chegou ao lugar através do Túnel.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

A batalha teve inicio, e as bestas  se mutilavam, haviam Mordedores, Pútridos, Torius e seres terríveis, e Exar aproveitava o momento em que Orgog estava ocupado com o Pútrido para abrir caminho até ele. Orgog se desvencilhou e vendo Exar partiu em sua direção com suas lâminas. Exar com muita habilidade desviava de seus golpes e desferia ataques com sua terrível espada que conseguia atravessar a carapaça da besta.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Quando teve a oportunidade necessária, Exar subiu nas costas de Orgog, escalou o corpo cheio de chifres e espinhos e cravou sua espada aonde parecia ser um ponto fraco . Por um segundo a criatura tombou e sem perder tempo Exar surgiu a sua frente. Tomou a gigantesca cabeça com as duas mãos e olhou direto nos olhos da criatura, e uma batalha pelo domínio iniciou.

</div>

<div style="text-align: justify;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiFNihcTuo-TNYsk6N4Z3nZlMRCLV9oQFZhQmGk47n5N4lY3-n_RUK9KyaJ3rrOq8AkELLizN7ydGUiJiWbSKVdr2OLGaqPAmf0SwgoEcuSmIleqOtsLa_wzG-LBwRSKpsfBYHIDZcpudjQ/s320/-Magic-The-Gathering-Fantasy-Art-Fresh-New-Hd-Wallpaper--.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiFNihcTuo-TNYsk6N4Z3nZlMRCLV9oQFZhQmGk47n5N4lY3-n_RUK9KyaJ3rrOq8AkELLizN7ydGUiJiWbSKVdr2OLGaqPAmf0SwgoEcuSmIleqOtsLa_wzG-LBwRSKpsfBYHIDZcpudjQ/s1600/-Magic-The-Gathering-Fantasy-Art-Fresh-New-Hd-Wallpaper--.jpg) |
|                                                                                                                                                                                                                                                                         Exar Khun e Orgog                                                                                                                                                                                                                                                                          |

<div style="text-align: justify;">

A mente de Orgog era densa e poderosa, mas o poder de Exar havia crescido muito e nada o fazia desistir. A criatura rosnava e tentava se debater, mas a concentração da besta estava na batalha mental, e seu corpo não desferia golpes. Com os dentes rígidos Exar parecia fazer um esforço físico enorme rompendo barreiras na mente da criatura, e um ruido gutural saia de sua garganta por causa do esforço.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

O chão começou a tremer, e uma chama brilhava nos olhos negros de Exar, os dois começaram a urrar em uma batalha final. A terra rachou ao redor deles, as outras criaturas fugiam e se arrastavam, e o grito de ambos alcançou a superfície, e a mente de Orgog foi finalmente vencida.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Exar Khun não dominou, mas a destroçou,  a enorme criatura caiu diante dele. A batalha das bestas ao seu redor havia terminado, pois todas fugiram de sua presença. Ele caminhou pelos túneis até finalmente encontrar uma ala de prisioneiros que Orgog mantinha. Homens e Feéricos jaziam ali, muitos dos novos prisioneiros do Caixão das Almas. Alguns entregues a loucura, outros ainda bem vivos. Exar Libertou a todos, até encontrar finalmente seus guerreiros.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Os homens e mulheres quase não reconheceram seu líder. Sua pele agora tinha um tom acinzentado, seus olhos tinha bordas vermelhas ao redor um poço escuro e sem fundo, e a sensação de estar ao lado dele era estranha, como se a qualquer momento ele pudesse submetê-los a sua vontade.

</div>

<div style="text-align: justify;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhiEKItcGeZeGTwvV6UxtB2cyM5Q31ZILM5Zw2Ujqj2xvz3-XD8AZ-HevH0b5btx7eneq3qC4TklEKZotVHwfa7WquiYqBaA3BKMwinjQ3x6SoGjEtHy9uUihJyTGnXBrQAJOiKkAjYgg9O/s320/flavor1_3+\(1\).jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhiEKItcGeZeGTwvV6UxtB2cyM5Q31ZILM5Zw2Ujqj2xvz3-XD8AZ-HevH0b5btx7eneq3qC4TklEKZotVHwfa7WquiYqBaA3BKMwinjQ3x6SoGjEtHy9uUihJyTGnXBrQAJOiKkAjYgg9O/s1600/flavor1_3+\(1\).jpg) |
|                                                                                                                                                                                                                               Floresta das Almas                                                                                                                                                                                                                               |

<div style="text-align: justify;">

Eles finalmente saíram da terra das bestas e alcançaram a Planície Negra. De lá Exar Khun os guiou novamente a floresta aonde eles haviam caído quando entraram no Caixão. A voz estranha da deusa o guiava, e falava coisas sobre os pais que ele nunca conheceu, sobre um povo e uma raça que eram dele.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\-Comandante Czar\! - disse Lílian, uma jovem Dranoriana que sempre seguiu Czar com fidelidade - porque está nos guiando de volta para a Floresta das Almas?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Exar...

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Senhor? - a guerreira estava confusa.

</div>

<div style="text-align: justify;">

  

</div>

|                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| [![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhtENqhIqVUM6RH_DSCx8mKeK7wg-uBuM-VEHpyFvEg_EO6qIRTti_9I-rmcUvmyG7WxZm1DEpTJUGq4H2VSrEN7cvO6bLJpgAD5_vUGOkCdwoxo33myMHiffPt-_HlKJh6sEZVWC3JbTf5/s320/cov33.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhtENqhIqVUM6RH_DSCx8mKeK7wg-uBuM-VEHpyFvEg_EO6qIRTti_9I-rmcUvmyG7WxZm1DEpTJUGq4H2VSrEN7cvO6bLJpgAD5_vUGOkCdwoxo33myMHiffPt-_HlKJh6sEZVWC3JbTf5/s1600/cov33.jpg) |
|                                                                                                                                                                                                      Czar StormRange morreu, e nasceu Lorde Exar Khun                                                                                                                                                                                                      |

<div style="text-align: justify;">

\- Comandante Exar Khun. É assim que devem me chamar agora. Estou lhes guiando para a saída deste lugar, voltaremos ao mundo, e nos vingaremos dos malditos StormBorns e Magos Sombrios.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Como sabe que seremos livres dessa terra, Senhor? Parece ter se passado Eras desde que perdemos nossa esperança.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Uma voz me contou. - Disse Exar Khun enquanto um leve sorriso se formava em seu rosto, talvez ria de sua própria loucura, ou por saber agora quem ele realmente era e que caminho devia seguir.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

*A Ascensão de Exar Khun, por Moisés Noah o Mestre Laufëa Kane;*

</div>$MDS$, array['Caixão das Almas','Exar Khun']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Ascensão de Exar Khun - parte quatro. Final');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'A história de Raukor, o segundo morador do Caixão', 'a-historia-de-raukor-o-segundo-morador-do-caixao', $MDS$> 📰 Blog *Mar de Sangue* · 2026-06-16 · marcadores: —
> Fonte: https://maresdesangue.blogspot.com/2013/11/a-historia-de-raukor-o-segundo-morador.html

(ESCRITO ORIGINALMENTE EM 2013)

<div style="text-align: justify;">

Exar Khun e seus homens foram os primeiros moradores do Caixão das Almas. E sabe-se que depois deles diversos seres foram lançados nessa prisão pelas mãos de Morcul. Mas o primeiro prisioneiro lançado por Morcul, e consequentemente o segundo morador do Caixão, foi um Eladrin chamado Aglar. 

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Aglar fora um estudioso entre os grandes Eladrins, mas ao contrário da maioria de sua raça, ele se apaixonou por Skard, o Mundo Original. Ele via uma beleza mais peculiar que a existente em Agrestia, seu mundo natal, que nada mais era para ele que uma versão exagerada da beleza do mundo original, que fez com que ela perdesse toda as belas características que os Primordiais deixaram. O Eladrin decidiu se tornar uma espécie de eremita, que viajou por todo o mundo de Skard, especialmente Dagorcain, passou a catalogar espécies de árvores, plantas e seres naturais de Skard, e elaborar estudos e livros sobre eles e sobre o que ele chamava de "corrupção dos outros mundos", que era o crescimento, surgimento e migração de seres originais dos outros Planos.

</div>

<div style="text-align: justify;">

  

</div>

  

<div style="text-align: justify;">

Morcul demorou meses para decidir usar o Caixão como uma prisão, pois antes decidiram estudar a natureza de sua magia. Entre os líderes dos Magos Sombrios, havia um Homem chamado Amorak, descendente da primeira geração de Líderes dos Sombrios da época da grande Guerra dos Magos. Amorak era jovem, pele pálida e olhos amarelos, apesar de sua natureza maldosa, consequência do mundo que ele vivia, ele costumava caminhar por Dagorcain disfarçado para admirar a beleza do continente. A cada nova paixão sua cobiça aumentava e sua sede de batalha se tornava imensa, pois gostaria de poder finalmente varrer as defesas da Aliança e tomar tudo para ele e seu povo.

</div>

<div style="text-align: justify;">

<div>

  

</div>

<div>

Amorak se deitou com muitas mulheres, caminhou por várias cidades, e sempre que pode espalhou rastros de sua natureza sombria. Pois se considerava algo belo, aquilo deveria ser seu a qualquer custo, e muito sangue inocente fora derramado em seus passeios. Até que um dia ele ouviu sobre um grande estudioso daquela época, diziam que ninguém conhecia sobre Dagorcain e todo o Mundo melhor que ele. Talvez motivado pelo desejo de tomar posse daquela sabedoria, Amorak decidiu encontrar este tal Feérico sabido.

</div>

<div>

  

</div>

<div>

Na antiga cidade de Agrestia Menor, destruída pelo Clã Mãos de Prata no período pós-Grito Bestial, Amorak finalmente encontrou o famoso feérico conhecido pelo povo como Taur-Raukor, o Demônio da Floresta, um nome antigo dado a entidade que vigia a Região das Grandes Florestas, nos dias de hoje,adorada como Lórien. Apesar de sua 'fama' entre os estudiosos das grandes cidades, o Eladrin era simples, mais próximo a seus primos elfos do que dos grandes Senhores de Agrestia. 

</div>

</div>

  

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

A primeira vista o Príncipe de Morcul desdenhou do feérico e seus trapos. Aglar se vestia com trajes comuns dos elfos-druidas, e pendurado a seu sinto haviam pergaminhos, potes com poções e amostras, em seus cabelos haviam folhas e pequenos galhos presos. Ele estava sentado na mesa mais humilde no canto mais escuro da Taberna que estava hospedado, uma vela iluminava um grande bloco de papeis empoeirados que ele lia com atenção. 

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Aproximando-se com seus trajes negros e finos, Amarok sem se importar com a altura de sua voz ou qualquer tipo de regra de conduta, disse:

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Um Eladrin que se rebaixa aos costumes de Elfos Druidas, pobres e imundos, acaba recebendo o título de sábio e o reconhecimento de uma grande entidade da floresta. Mato crianças ou mulheres e sequer me reconhecem com títulos, apenas como um mistério de assassinato nas ruas das cidades\! O que faz um sábio para ser mais reconhecido que pessoas armadas?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

É claro que em Dagorcain, em tempos de guerra como aqueles, não era de se surpreender esse tipo de discurso, em mundo cheio de mercenários e guerreiros. Mas Aglar prestou bem atenção no que o homem falou, ao contrário dos bêbados e farreadores daquela Taberna e respondeu:

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- O sábio se aproveita das palavras dos espadachins e dos arqueiros. Ao contrário deles ele as anota e toma para si as honrarias. Não há como assinar a voz, se não pelas artes dos Elodianos, que escrevem sem usar mãos mas sim encantamentos, porém mesmo estes  usam bem o que entendem sobre mundo para deixar escrito o que sabem e reconhecer o nome que está na assinatura. São estes os sábios que me reconhecem, afinal, que sábio reconhecerá a voz de violentos?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- De onde venho a violência é escrita pelos sábios, pois as artes que criamos veem para violência. - Disse Amorak, surpreso com a resposta que recebeu.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Então, seja famoso aonde você vive, e me permita ser reconhecido no meu mundo. Parece que tudo trata-se do ponto de vista, não? Mas creio que não me atrapalhou para discutir a ignorância dos combatentes e dos sábios, o que deseja?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Desejo conhecer as coisas que amo e que desejo para mim. E se você é considerado um dos grandes sábios dos assuntos que me interessam, talvez encontre em você alguma utilidade. 

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Também encontrara humildade, mas não parece ser algo do seu interesse. Mas sente-se comigo, pague-me uma bebida e conversaremos. 

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Amorak sentou-se na mesa. A sabedoria do Eladrin era cobiçada por ele, e tomá-la para si não seria difícil, o Instrumentous roubaria de sua mente o que precisava com facilidade. Mas Amorak também o invejava.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Me pergunto os poucos lugares no mundo dos quais você não visitou. Seria algum deles de muito interesse a você?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Não fui a muitos lugares, por não me interessar, ou por saber que não retornaria dali. O ultimo caso costumam ser lugares de muito interesse. 

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Morcul, há algum interesse em sua mente sobre este lugar?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Tanto interesse quanto temor. E eu temo muito aquele lugar. Mas lá encontraria muito do que preciso para meus argumentos quanto ao que eu acredito ser a corrupção do trabalho original, afinal, se cidades como essa e Elódia representam a corrupção que vem de Agrestia, Morcul seria com certeza um dos maiores reflexos da corrupção vinda do Pendor. 

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Eu posso levá-lo até lá - disse Amorak- e em troca, me permitiria dar uma boa olhada em seus documentos e catálogos, e daria instruções e conhecimentos que só você tem\! Uma troca justa, pois apenas eu poderia levá-lo em segurança a Terra dos Sombrios.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Aglar não confiou no homem desde o momento que ele se aproximou, mas a ideia de ao menos entrar nos Vales das Montanhas Gorgoroth em segurança acendeu sua mente. Não podia deixar uma oportunidade como essa passar. Mas ele também não podia correr o risco de caminhar com um louco. E após uma série de perguntas e uma longa conversa finalmente perguntou:

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Afinal, qual o motivo de tudo isso?

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Sou apenas mais um homem sedento por Poder, tal qual qualquer um dos lideres dos lados dessa Guerra que é travada a quase Cem anos. A diferença é que eu tenho algo a oferecer-lhe que nenhum deles tem.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

\- Amanhã partimos, então. A viagem será longa até lá.  

</div>$MDS$, array['Caixão das Almas','Exar Khun']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A história de Raukor, o segundo morador do Caixão');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'A Mãe de Prata, e a Senhora da Lua', 'a-mae-de-prata-e-a-senhora-da-lua', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-21 · marcadores: Altos Lobisomens, Mãos de Prata
> Fonte: https://maresdesangue.blogspot.com/2013/04/a-mae-de-prata-e-senhora-da-lua.html

(ESCRITO ORIGINALMENTE EM 21/04/2013, 11:23:00. Essa história ocorre nos últimos anos da Guerra dos Cem Anos)  

<div>

  
Assim como os Homens de Dranor são fortes, suas mulheres são belas. As damas Dranorianas se comparam as Senhoras Eladrins, em coragem e beleza. Seus espíritos são de um fogo violento, e compartilham a habilidade com armas dos Homens. Altas, de personalidade forte e de uma beleza divina. Artesãs, guerreiras e mães cuidadosas, sem dúvida elas superam de longe outras mulheres de outras raças.  
  
Mas elas evitam olhar para o mundo fora de Dranor, e seu amor está ligado as suas cidades, e julgam não haver outros homens para elas fora de suas terras. Existem poucas histórias entre a união de homens de fora, seja qual for à raça, com mulheres Dranorianas. O que para os homens dranorianos é o inverso, pois muitos se apaixonam pelas senhoras de outras raças, muitas dessas, feéricas.  
  
Mas em uma cidade de Dranor, que vinha da linhagem de uma das doze famílias, uma donzela se apaixonou por um errante da Floresta. Eles tiveram um belo romance, e dessa união nasceu uma bela menina, com a força e personalidade dos Dranorianos, mas com olhos feéricos e sonhadores como os Altos Elfos.  
  
Mas uma tragédia atingiu a cidade, quando um clã de Feiticeiros e Bruxos vindos das beiradas das Montanhas Gorgoroth, golpearam a cidade comandando um exercito de mortos vivos, vampiros e lobisomens insanos. E a criança presenciou a morte de seus pais, e viu seus amigos e conhecidos serem raptados para rituais malignos, e no futuro serem usados e molestados como servos pelos imundos Bruxos.  
  
Os reforços demoraram a chegar, e encontraram a cidade destruída e pilhada. Os moradores foram mortos ou levados, e apenas uma criança encontrou lá, chorando escondida em um guarda roupa. E como era de costume nas terras de Dranor, os órfãos eram levados para fortes militares, eles eram treinados e bem tratados a maneira de Dranor.  
  
A menina cresceu sobre a supervisão dos mestres Dranorianos, e se destacou entre os aspirantes. Era conhecida como Kira, dos StormBorns, era bela e forte. Muito respeito ela adquiriu entre os guerreiros de Dranor.  
  
Fora enviada em missões de Patrulha nas florestas, áreas que Dranor começou a conquistar. Caçava orcs e outros seres nas colinas em Menegroth, a grande floresta no centro do continente. E seus mestres a ensinava como se virar na mata, e lutar. Mas assim que atingiu a maioridade, se desvinculou do exercito, pois se apaixonou pela arte da Patrulha, e guiou homens em missões de exploração e reconhecimento.  
  
Na maior parte do tempo viveu nas florestas, junto aos elfos e eladrins, e com eles aprendeu muito, e os seus Líderes em Dranor faziam questão de chamá-la para as missões mais importantes. Mas Kira tinha algo em seu coração e jamais esqueceu o desejo de vingança contra aquele clã de Bruxos, que outrora tirou tudo que ela tinha.  
  
Esperou com paciência o momento em que as equipes de Dranor descobrissem o paradeiro daqueles bruxos, pois vingança era algo vivo nos corações dos Dranorianos, e assim como Kira, toda Dranor buscava por eles, pois eram inimigos declarados e deviam ser destruídos.  
  
E um dia, Kira recebeu uma mensagem de seu general, dizendo que encontraram a sede dos Bruxos, que se intitulavam Senhores das Sombras. E uma tropa estava se movendo para floresta, pois eles se esconderam em uma toca a Leste próximo as fronteiras das planícies do Monte Dork.  
  
Naquele tempo, Kira comandava um grande grupo de Patrulheiros na floresta, formado por homens e mulheres de Dranor e feéricos, na maioria. Ela os liderava e lutava contra as forças dos Magos Sombrios que tentavam se infiltrar na floresta. Eram os últimos anos da Segunda Guerra contra os Magos de Morcul, e os Senhores das Sombras eram comandados por eles.  
  
Ao receber a noticia, Kira levou seus homens para se unir à tropa enviada por Dranor, e os alcançou quando a batalha já tinha começado. E por dois dias lutaram, até que conseguiram invadir a base inimiga que ficava em túneis e cavernas. E todos os bruxos e suas bestas foram mortos sem misericórdia, e a vingança de Kira e dos Dranorianos foi ali saciada.  
  
Depois disso Kira pediu a seus senhores sua liberação, para que pudesse liderar com mais liberdade seus homens, e deu sua palavra que continuaria a auxiliar Dranor na patrulha da zona norte da Floresta. E os senhores Dranorianos a aliviaram de seus deveres com o Estado, e assim ela seguiu com seu Clã, e mais de duzentos homens e mulheres a seguiam. Ela era uma líder nata, e sua voz influenciava as mentes.  
  
E ao final da guerra dos cem anos, perseguindo uma tropa inimiga que ia em direção as Ered Gorgoroth, ela se deparou com um grupo de guerreiros que vinham de Morcul, eram vinte e um homens e mulheres, e seu líder era alto e poderoso. E estes eram Exar Khun e seus homens, que vinham das Terras de Morcul, os futuros e escuros lideres dos Mãos de Prata.

</div>$MDS$, array['Altos Lobisomens','Mãos de Prata']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Mãe de Prata, e a Senhora da Lua');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', '6.1 - Da Construção do Grande Templo Gaurgrod', '61-da-construcao-do-grande-templo-gaurgrod', $MDS$> 📰 Blog *Mar de Sangue* · 2013-05-22 · marcadores: Altos Lobisomens, História, O Caixão das Almas
> Fonte: https://maresdesangue.blogspot.com/2013/05/da-construcao-do-grande-templo-gaurgrod.html

ESCRITO ORIGINALMENTE EM 22/05/2013, 11:56:00 *(Essa história ocorre no período dos textos sobre o Reino Anão Leste e a Ruína de Thúrin. A história se trata da construção da Segunda Dungeon, o templo dos lobisomens, aonde os jogadores lutaram contra o Lich e conseguiram uma das chaves do Caixão)*  
  
        Os Anões construíram um grande Reino no Leste, e isso trouxe muita alegria não só aos anões como a todas as raças que muito se beneficiaram com esse novo comercio que se abriu na floresta. Nesse tempo, o inicio do império Dranoriano, os reis tolos ainda não haviam ascendido ao trono e os tempos eram belos, e Dranor guardou as terras de muitos males.  
  
        Mas algo inquietou os habitantes da floresta, uma enorme construção que se iniciou nos Picos Sombrios, que eram três grandes montanhas que se sobressaiam no limite norte das Ered Lammoth, nas regiões altas de Menegroth, a grande floresta.  
  
        Foi proibida a passagem para qualquer um que quisesse se aproximar das montanhas, e muitos anões e Dranorianos se movimentavam naquela região. E boatos diziam que um templo sagrado estava sendo construído, com o objetivo de guardar uma arma dos deuses.  
  
        De fato seria uma cidade sagrada, e lá guardariam um artefato de Grande Poder, mas Dranor escondia esses fatos a todo custo, e apenas os Sacerdotes Dranorianos e Mestres Anões poderiam entrar naqueles salões. Pois ele foi construído por ordem de Minas Ithil, a cidade dos Altos Lobisomens.  
  
        Alguns anos depois do inicio do governo de Minas Ithil, a deusa visitou Kira e seus filhos se apresentando na forma de uma bela Shadar-Kai. E lhes aconselhou e falou sobre os Mãos de Prata, e como se deu o fim de seu Pai, Exar Khun.  
  
\- Minha maldição recaiu sobre aquele clã – disse a deusa-, e sobre seu pai também. Pois muito me decepcionei com sua traição, e com traição ele foi recompensado. Pois seus irmãos gêmeos unidos aos mestres do Clã, traíram Exar Khun e atentaram contra sua vida. Ele fugiu e se perdeu na escuridão, seguiu um caminho e uma sina terrível, pois retornou ao lugar aonde eu o treinei.  
  
\- Há anos entreguei a Exar Khun e seus guerreiros a chave para minha mais bela e terrível criação, O Caixão das Almas. Lá, Exar Khun e seus homens foram forçados pela dor a crescer em suas habilidades e ao mesmo tempo o Caixão lhes abasteceu de uma magia fúnebre que só ele pode conceder. Um poder que vem da vitalidade das almas que morrem ou caem na insanidade das terras do caixão, e com essa chave eles poderiam lançar lá seus piores inimigos, e também se alimentar do poder. Eu planejava construir um exercito muito poderoso, mas agora percebi que os acidentes são a maior diversão para os deuses.  
  
\- Então vou lhes entregar essa chave, e a vocês eu dou o poder de retirar aqueles que apodrecem no Caixão e usar seu poder para ferir os Mãos de Prata. E assim como eles, vocês saberão sobre quem entra e quem sai daquele lugar, como também lhes darei o ensinamento de como materializarem seus espíritos ali, para vigiarem os caminhos daqueles que não caem na morte ou loucura.  
  

<div>

        E dizendo isso, a deusa colocou nas mãos de Fëanor, o mais velho dos Reis Lobisomens, um cristal transparente e entalhado, com uma caveira espectral, que se enrolava e insinuava em torno do cristal como uma serpente. E no momento que Fëanor o tocou, um poder saiu do cristal e adentrou em seus olhos e no de seus irmãos, e eles receberam toda a sabedoria que a deusa dissera.  
  
        Mas Fëanor, com tom de reprovação, encarou a deusa em forma mortal e disse:  
  
\-Então é assim que vê a morte de homens de meu povo, como uma fonte de diversão para seus olhos. E com esse presente só busca aumentar o conflito entre nós e a prole de nossos irmãos, que enredados em seus planos se perderam na escuridão e foram amaldiçoados por consequência dos males que você causou aos homens de meu pai e a ele mesmo.  
  
\-Não aceitamos seu presente, deusa, pois ao menos agora vamos fugir de sua sede insaciável pela sina e pela morte. E nos negamos a usar um mundo de horror como foi este que tu criast, e depois que despejou essa sabedoria em nossas mentes sem que fosse convidada, eu vi o quão maldito é aquele lugar. Padroeira de nossas terras você é, e nunca negaremos sua influencia para nossa riqueza e prosperidade, e por isso continuaremos a servi-la, mas não ajudaremos a continuar esse fratricídio que por falta de escolha somos obrigados a lutar.  
  
        Mas a deusa riu das palavras de Fëanor, pois sabia de seu amor por seu povo, e que no futuro seriam obrigados a usar do poder do caixão para guardar a suas terras. E disse a deusa:  
  
\-Suas palavras, jovem Rei, chegam a mim como as de uma criança que não entende o porquê de seus pais os colocarem na tutela de professores e mestres. Não sabem que para o futuro o conhecimento sobre as coisas do mundo em que vivem será crucial para sua sobrevivência. O que dei a vocês foi o ultimo poder que tinha sobre o caixão, que por motivo que desconheço se desligou de minha vontade. E agora seu pai habita na escuridão do caixão, e guerra ele trará no futuro, por uma vingança alimentada pelas magias odiosas do caixão, que mudam a mente e a confundem.  
  
\-Com isso vocês poderão vigiar seus passos, e se preparar para uma necessidade. Pois não creio que o caixão prendera para sempre as forças que foram jogadas lá, pelos Mãos de Prata, e pelos Magos Sombrios, que eu manipulei para me auxiliarem na criação do caixão. E também a força dos mãos de Prata em breve irão se impor contra as suas, pois muito poder eles tomam de minha criação, e isso vocês não tem, e sua única vantagem é o dom que eu lhes dei, mas essa, se não aperfeiçoada, ira sucumbir perante os homens do Clã de seus Irmãos.  
  
\-Mas uma sabedoria a mais eu dei a vocês, algo que só tinha dado a Exar Khun. Independente desse cristal, vocês podem materializar seus espíritos no caixão, e de lá retirar forças. E seus irmãos dependem do cristal que eles têm para isso, e dele nunca podem se distanciar. Então, sugiro que escondam essa chave que lhes dei, já que estão indispostos a retirar alguém do caixão.  
  
        A deusa desapareceu depois de dizer essas palavras e Fëanor ponderou sobre elas, e viu que se o que a deusa relevou fosse verdade, realmente era necessário o uso do poder que ela deu a eles. Mas a chave para o Caixão seria escondida, pois ninguém seria retirado de lá. Poderosos de mais saiam às pessoas daquele mundo, e sua mente estava transtornada pelos poderes negros do caixão.  
  
        Então, se aconselharam com o Rei Dranor III, um rei bondoso e sábio dos Dranorianos, e muito fiel e amigo dos Lobisomens. Ele falou com sábias palavras, dizendo que era bom que um Templo fosse construído e sobre a segurança dos deuses dranorianos ele fosse guarnecido.  
  
        Disse que o antigo povo do primeiro Rei Dranor se uniu aos semideuses, e a eles poderiam pedir auxilio, mas para isso um Templo Sagrado deveria ser construído. E lá, apenas sacerdotes e lideres como ele e os cinco Reis Lobisomens, pudessem entrar, e assim, convocar a proteção de seus ancestrais para aqueles salões. Pois homens de Dranor, em sua maioria, reverenciam seus ancestrais, e acreditam que eles caminham entre os deuses, e são senhores de salões no Mar Astral.  
  
        Não se sabe se essas palavras são verdadeiras, mas não se pode negar o destino divino dos ancestrais Dranorianos, e que esses com poder auxiliam Dranor, às vezes mais que outros deuses adorados nos reinos humanos.  
  
        E assim, com auxilio dos Anões do novo reino do Leste, Minas Ithil e o Reino de Dranor III deram inicio a uma das maiores e mais belas obras do continente. Um templo tão grande e belo que suplantava os Salões de Thúrin, que em troca de seu trabalho, pediu total independência, inclusive dos impostos, de Dranor. Mas os Anões se apaixonaram tanto por aquela obra que depois que terminaram pediram aos homens que permitissem que eles visitassem os salões, para mais uma vez deslumbrarem a glória daquele templo.  
  
        Mas era negada a entrada a qualquer outro que não fosse à família do próprio Rei Dranor III e dos cinco Senhores da Lua, e aqueles que eles permitissem a entrada. E para lá foram enviados muitos sacerdotes Dranorianos e naqueles salões os ancestrais Dranorianos foram adorados, e como foi previsto pelo Rei, eles enviaram uma poderosa força para guardar o Templo. E a chave para o Caixão foi colocada em uma torre, no pico mais alto das três montanhas, e apenas uma escada escondida no templo levava até lá, guardada pelos segredos dos anões.  
  
        E uma poderosa patrulha guardava o Templo. E eles continuaram cheios de sacerdotes e visitantes anões e do povo de Minas Ithil por muitos anos. Mas assim como a glória do Reino Anão Leste acabou suas portas foram lacradas pelos Dranorianos, temendo que algum mal daquele tempo alcançasse os salões sagrados.  
  
         Pois os reinos do Leste foram assolados por uma praga liberada pela imprudência de Thúrin, rei supremo daqueles anões. E grande ruína veio sobre aquele povo.  
  
  
  
  
  

</div>$MDS$, array['Altos Lobisomens','Mãos de Prata']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='6.1 - Da Construção do Grande Templo Gaurgrod');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'O Resumo do relato de Aegnor, a Branca', 'o-resumo-do-relato-de-aegnor-a-branca', $MDS$> 📰 Blog *Mar de Sangue* · 2013-05-22 · marcadores: Altos Lobisomens, Cultura
> Fonte: https://maresdesangue.blogspot.com/2013/05/o-resumo-do-relato-de-aegnor-branca.html

*(ESCRITO ORIGINALMENTE EM 22/05/2013, 12:30:00. Este relato conta como surgiram os Gaurhoth, os Altos Lobisomens da cidade de Minas Ithil)*  
  

<div>

Eu era jovem, uma criança de doze anos, vinha de uma família de Elfos e Meio Elfos, e vivíamos em uma cidade a Norte na Floresta Menetrels, em Menegroth. Era bela, e Homens, Ferais e Feéricos viviam ali em harmonia. Eu nasci no final da Segunda Guerra contra os Magos, meu pai era um Soldado da horda Feérica liderada pelos Dranorianos, pois nossa cidade cresceu sobre o domínio de Dranor, mas éramos bem tratados, pois os Tiranos Reis ainda não tinham ascendido e se colocado entre os Nove.  
  
Meu pai foi muito ferido na Guerra, depois de servir fielmente por vinte anos foi aliviado de seus deveres, voltou para minha mãe e se tornou Guarda da Cidadela. Muita felicidade residia ali, tínhamos fartura mesmo nos tempos da Guerra, pois os Homens do Norte tinham muito cuidado por aquela cidade, diziam que um poderoso entre os Reis Dranorianos tinha desposado uma bela elfa que morou conosco, e desde então recebemos muita atenção do Norte.  
  
Muitos deuses eram adorados ali, mas a cidade fora construída em nome de Rainha Rapina, motivo pelo qual alguns Clãs Ferais se estabeleceram nos arredores da Cidade, e se misturaram ao povo como comerciantes até Sacerdotes da deusa. E por muito tempo o mal não nos alcançou, nem mesmo através dos Magos Sombrios, isto viria mais tarde pela mão de Reis que envergonharam a imagem dos antigos Senhores Dranorianos.  
  
Era noite e chovia, o som do vento era melancólico, mas a noite ainda estava bonita, quando uma jovem bateu nos portões. Estava cansada e ferida, assim como os dois homens que a acompanhavam. Eles tinham cinco crianças consigo, e findaram seu trabalho trazendo a moça e seus filhos a salvo para a cidade, a protegendo de algum perseguidor, pereceram nas casas de cura. Ela, apesar de cansada, resistiu aos ferimentos e chorou ao saber que seus companheiros tinham morrido, mas se alegrou pelo bem estar de seus filhos.  
  
Os Homens que estavam com ela eram Dranorianos, não faziam mais parte do exercito, mas seus traços não negavam sua origem, o que aumentou os cuidados pela mulher. Minha mãe era uma dos feéricos das Casas de cura, e acompanhei parte dessa história de perto. O nome da moça era Kira, era conhecida naquelas terras. Era líder de um Clã de Patrulheiros de renome, mas há alguns anos pararam de dar noticias.  
  
Ela foi muito questionada mas evitou algumas perguntas, e os homens não insistiram. Kira era muito bela, e seu porte e traços vinham das terras do Norte, das damas Dranorianos, e dos Homens ela não podia negar sua origem. Apesar de durona como os de seu povo, era amorosa com seus filhos, e com qualquer outra criança, e eu me apeguei muito a ela.  
  
Os Homens deram ordens para que não criassem alvoroço ou comentários que chegassem aos ouvidos dos estrangeiros, e ela viveu entre nós. Dentro da cidade ela ajudou os Homens que receberam seus conselhos e ordens de bom grado, pois ela tinha o dom de comandar e suas palavras eram dominadoras, era uma grande Militar, pois isso corria no sangue dos descendentes de Dranor.  
  
E seus filhos cresceram entre nós, e a cada dia revelavam seu parentesco com o povo do norte. Mas eles tinham algo mais, o espírito deles era ainda mais forte e ardente que qualquer Dranoriano, e tinham traços desconhecidos que não vinha de Dranor, o que nos assustou, pois o sangue Dranoriano era às vezes mais forte que o dos Feéricos. E eu me perguntava quem teria sido o pai dessas crianças. Eles eram queridos pelo povo, os três rapazes mais velhos eram fortes e altos, e suas duas irmãs eram belas como senhoras dos Altos Elfos. E mesmo elas se mostraram grandes guerreiras ao lado de seus irmãos.  
  
Quando chegaram à cidade, os Sacerdotes Ferais de Rainha Rapina notaram uma marca que eles carregavam. Diziam ser a marca do Senhor dos Lobos, que era adorado por grande parte dos Clãs Ferais, um semideus aparentado a Rainha Rapina. E tomaram aquilo como um sinal da deusa, e que as crianças foram escolhidas.  
  
E grandes feitos vieram deles, pois junto com sua mãe formaram um grupo de guerreiros poderosos na cidade, intitulados pelo povo como Imortais, e estes tiveram grande papel quando os Orcs invadiram as montanhas e lutaram contra os Homens. E Kira escondeu seu nome, comandava a seus homens mas evitava sair da cidade.  
  
Quando o mais velho chegou a seus vinte e um anos, fomos assombrados por um mal durante a madrugada. A Lua estava alta e gritos começaram a ser ouvidos na escuridão. Os guardas davam ordens, pois algo tinha entrado na cidade e pessoas tinham sido atacadas. Muitos estavam feridos e todos os Imortais, os guerreiros de Kira, foram surpreendidos nos dormitórios e atacados sem poder se defender. Poucos morreram, mas todos sofreram ferimentos graves. Meu pai também foi atacado, e minha mãe, que estava atendendo os feridos nas ruas viu uma fera se arrastando na escuridão, atacando a todos com uma fúria infernal. Os Guardas formaram barricadas em todas as saídas da cidade, mas uma delas foi rompida violentamente, e seja lá o que nos tinha atacado fugiu para as florestas.  
  
O filho mais velho, líder dos Imortais, desapareceu do dormitório. Kira estava desesperada e mandou seus homens vasculharem as cidades e os arredores da floresta, mas nada encontraram. Os guardas e pessoas feridas foram tratadas, e houvera poucas mortes.  
  
E por um mês Kira procurou seu filho, e ajudou pessoalmente nas buscas. E quando a lua novamente subiu cheia nos céus, gritos foram ouvidos, pessoas corriam, e minha mãe entrou em casa desesperada. Dizia para meu pai que os feridos estavam se transformando em bestas, os Imortais desapareceram, e todos estavam sendo atacados. Meu pai cobriria o próximo turno dos Guardas, mas quando ele terminou de se aprontar e a luz da lua adentrou nosso quarto pelas janelas e pela sacada, os olhos dele brilharam, e ele urrou de dor, minha mãe me protegeu em seus braços enquanto víamos meu pai se contorcer no quarto, quebrando móveis, rosnando como um animal.  
  
Minha mãe fugiu comigo para a sacada, e de lá olhamos para a cidade, e víamos vultos correndo pelas ruas, destruindo as lamparinas, correndo sobre os telhados, uivando e atacando as pessoas e guardas. Tochas estavam acesas nas mãos dos defensores, mas elas não afastavam as bestas, e a cidade estava infestada. Saiam das casas, subiam nas torres, e uivavam para a lua. E quando voltamos nosso olhar para meu pai, um grande lobisomem estava em nossa frente, e ele vinha em nossa direção. Minha mãe me abraçava forte dizendo que tudo ficaria bem.  
  
Então um uivo que superava a todos que eu tinha ouvido naquela noite, veio na direção das muralhas da cidade. E antes de nos atacar, meu pai parou como se tivesse recebido uma ordem, e rosnando olhou atentamente para a muralha. Saltou sobre nós e foi naquela direção. Olhamos para o Portão da cidade, e lá, posicionado no arco do Portão, a luz incendiou o olhar de um Lobisomem Branco, alto e poderoso.  
  
E todas as bestas na cidade começaram a se reunir a frente do Portão, e mais quatro feras que também estavam a atacar a cidade se colocaram a frente de todas. E Kira, trajada com armadura e armas, avançou entre os lobisomens, que abriam caminho pra ela. Chegando ao portão a fera branca desceu e ficou a sua frente. E voltando a forma humana, em farrapos estava o Filho mais Velho de Kira, que abraçou a mãe naquele momento. E todos os Lobisomens atrás dela caíram e começaram a voltar as formas humanas.  
  
Os Guardas detiveram Fëanor, o filho desaparecido de Kira, pois estavam assustados e confusos. Também começaram a recolher os feridos e mortos. E os transformados também foram levados as casas de Cura, entre eles estavam os Imortais e os outros quatro filhos de Kira, e foram tratados pelos curandeiros Ferais, que conheciam bem a raça e eram parentes distantes.  
  
Fëanor contou a mãe, aos Guardas e aos Sacerdotes Ferais que por três semanas ele esteve transformado, e não podia voltar à forma humana, e que na noite de sua primeira transformação não conseguia se controlar e sentia muita dor, que o deixou insano. E nas três semanas que se manteve vagando, por instinto compreendeu seus poderes e descobriu como voltar a forma humana. E a ele apareceu um espírito em forma de um Lobo Branco, que lhe deu muitos conselhos, mas disso ele não poderia falar.  
  
Ele aprendeu a se comunicar em uma língua estranha com outros de sua raça, e podia controlar os novos transformados e sabia como transmitir esse ensinamento. E assim ele garantiu que não haveria mais incidentes. Ele voltou ainda mais imponente e poderoso, e suas palavras eram firmes.  
  
Os Homens informaram os Senhores Dranorianos, e um deles veio pessoalmente. Ele falou com Kira e seus cinco filhos, e Fëanor o convenceu de seus dons e de sua história, pois assim como a mãe, grande voz e poder sobre outros ele tinha. Mas o Rei não sabia o que fazer, pois não devia deixar uma cidade cheia de lobisomens, mas os outros Senhores viram aquelas pessoas como uma arma de guerra.  
  
Falou em conselho com os outros reis que os Lobisomens eram uma questão de seu reino, pois aquela cidade esteve por debaixo de seu olhar e de sua esposa, que cresceu lá. Os Senhores aceitaram, mas disseram que ele não poderia desperdiçar tanto poder, que seriam um novo exército, um dos mais poderosos de Dranor, pois muitos dos transformados ali, inclusive os cinco filhos, eram da raça dos Dranorianos.  
  
  
  
O Rei então achou uma solução, disse que a cidade se manteria, pois era importante para ele e sua mulher, mas os lobisomens não podiam ficar ali. Disse que uma grande obra começara pela mão dos Anões e Feéricos do Norte, em terras escondidas no reino de Dranor, e ali a cidade dos Lobisomens ficaria. Mas eles eram livres para andar disfarçados em outras cidades para comercio, desde que lá não se fixassem sem a autorização de Dranor, e qualquer incidente poderia levar a sérias conseqüências.  
  
E nos garantiram prosperidade nessa nova vida, pois o novo Reino que Dranor começou no continente era a favor da liberdade, e parte dela nos foi tomado pela maldição. E em troca receberiamos moradas ricas, um governo separado e pouco influenciado por Dranor, livre entrada nas cidades, mas jamais poderíamos morar em outro lugar, ou passar um período muito longo fora de Dranor ou da cidade.  
  
E passado um ano, os Homens de Dranor nos guiaram para o Norte, Kira e seus filhos lideravam a marcha, e depois de meses viajando nas terras geladas nos deparamos com um poderoso exemplo da belíssima arquitetura dos Anões, uma gigantesca cidade escavada nos paredões de Gelo.  
  
Imensa como os salões das mansões Anãs, através de técnicas e engenharia que só os Anões e Feéricos conheciam, uma luz como a da lua, porém mais clara e quente, refletia em espelhos vinda de fora da fortaleza, e esquentava e iluminava o interior da cidade durante o dia, e grandes luminárias foram postas para noite, mas em dias de Lua cheia, no centro da cidade aonde o teto entalhado no gelo era transparente, uma grande e bela imagem da lua surgia para nós, e sua luz iluminava o grande salão. E só aos Dranorianos foi revelado o caminho que levava a cidade.  
  
E a Kira foi dado o Governo da cidade, e belo foi aquele reino, e disfarçados entre os homens e outras raças, fizemos comercio com ajuda de Dranor, enriquecemos e prosperamos escondidos do mundo. Nossa relação com outros lobisomens era fria, pois eles eram ignorantes, feras incontroláveis e nos envergonhavam. E a Rainha Rapina foi adorada ali, e dizem que ela falava com Kira e seus filhos pessoalmente, e um grande dom os havia entregado, uma chave, para libertar os atormentados.  
  
Mas nossa paz era assombrada por um inimigo que nos caçava como animais, os Mãos de Prata, que eram ligados a nossa história, e em pouco tempo nos perceberam entre os homens, e muitas vezes perseguiam nossos viajantes. E foi assim que passamos a fazer comercio acompanhado de tropas, e muitas vezes houvera confrontos entre o nosso clã e o deles. E esses combates só cresceram com o tempo, muitas vezes sofremos repreensões de Dranor, pois devido aos conflitos com os Mãos de Prata nossa presença foi notada, e mitos sobre os Altos Lobisomens se espalharam.  
  
Os Mãos de Prata queriam descobrir aonde era nossa cidade, e invadiam pequenos vilarejos e comércios que fundávamos na floresta, pois a nós foi liberado esse direito, desde que nenhum um estrangeiro pudesse viver lá, eram cidades para facilitar o comercio. E eu e minha família vivíamos em uma dessas cidades. E os conflitos contra os Mãos de Prata foram à única guerra que conhecemos, porque os Reis queriam nos esconder.  
  
*E assim termina o relato de Aegnor, uma Senhora Élfica que viveu entre os lobisomens por duzentos anos, e seu pai se tornou um grande general entre eles. Ela morreu em um ataque dos Mãos de Prata, lutou bravamente, mas caiu ao lado de seu pai. Ela nunca foi transformada. Deixou esses textos que passaram a fazer parte da biblioteca da cidade de Minas Ithil, a cidade da Lua, casa dos Lican, os Altos Lobisomens.*

</div>$MDS$, array['Altos Lobisomens','Mãos de Prata']::text[], 'publicado', 'privado'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='O Resumo do relato de Aegnor, a Branca');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'A Cidade de Harad, no Grande Deserto de Dagorcain', 'a-cidade-de-harad-no-grande-deserto-de-dagorcain', $MDS$> 📰 Blog *Mar de Sangue* · 2013-06-30 · marcadores: Grandes Cidades, Mestragem
> Fonte: https://maresdesangue.blogspot.com/2013/06/a-cidade-de-harad-no-grande-deserto-de.html

<div class="MsoNormal">

*(Esse texto contem uma história importante para a cultura do continente, mas serve principalmente como fonte de informação para os jogadores)*

</div>

## 

## Quanto a História da Cidade

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

A Primeira Era terminou no final da Guerra do Caos, quando os demônios tentaram invadir o mundo. Muito sobre as histórias e conhecimentos dessa época se perdeu na transição para Segunda Era, já que todos os continentes haviam sido afetados pela guerra. Cidades foram destruídas, bibliotecas arrasadas e sábios degolados eram expostos em seus portões. Dagorcain não fugiu a  regra, pois anos antes da guerra terminar um grande exercito de demônios invadiu o continente.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

Eles chegaram pela região Norte, hoje conhecida como Dranor. Os Demônios não compreendem a vida, e a odeiam profundamente. Tudo que tem forma ou cor, tudo o que pode se mover, seja por vontade própria, pelo movimento do mundo ou pela vontade Elemental e Divina, para eles é odiosa e deve ser aniquilada. E assim eles agiram em Dagorcain.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

Naquele tempo o Continente possuía outros nomes, ainda falados em línguas antigas, nos povos Ferais, Gigantes e Golias. Mas a guerra trazida pelos demônios fora tão terrível que o continente foi manchado pelo sangue de milhões. Os Dragões se tornaram escassos no continente, raças foram extintas, exércitos aniquilados. Os Demônios não se davam sequer com raças malignas. Primus, que já fora aliado dos povos de Dagorcain, estava enfrentando seus próprios problemas, e a ajuda não veio de lugar algum.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

Os demônios arrasaram as terras que são hoje compreendidas como Morcul, reino e cárcere dos Magos Sombrios, a transformaram em um terreno árido, e as criaturas que cresciam lá eram corrompidas e odiosas. E na região das Garras a ultima batalha foi travada. Se sabe que um grande herói reuniu todas as forças restantes do continente, e recorreu aos Senhores Minotauros que viviam na ilha Minus,  e a todos aqueles que seu chamado alcançou. O local se tornou um terrível deserto, pois a presença dos demônios era devastadora e nada sobrevivia aonde eles se fixavam por menor tempo que fosse.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

Nessa região existia a cidade de Harad, rica e bela, dos povos Orientais restantes, já que Morcul havia sido destruída os sobreviventes migraram para Harad. Uma das maiores cidades do continente, com suas gigantes muralhas de Pedra, e seus castelos que cintilavam ouro e prata. A cidade foi sitiada durante a guerra, mas o cerco foi rompido quando finalmente chegaram os exércitos minotauros, liderados por Lorde Vandal, o Touro Xamã. Os demônios foram vencidos a um grande custo, pois os sobreviventes foram muito poucos. Um terço das cidades continuou de pé, e menos que isso se calculou dos sobreviventes de todo Dagorcain.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

Mas Harad se manteve de pé, ao Lado do Grande Rio do Mago, um braço do Divisa, que desce em grandes cataratas pelos Penhascos Drow e corta a região que fora uma belíssima floresta, e agora se compreende como o grande Deserto do Continente.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg5f5Dl6quVGV63vwIe7VMbl2WUbEiPg7hOuDWeLaxXcOWgV8aZOLSl1pPHB-B2GKspcLKIFJAdEgMd9klFgbC6y4z_ebuoHnAnUG-WcoQ1BID2CzEHSBztv_IUtseWBGLh7d8vJCyA1IAV/s320/164922_142243359315119_1885176467_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEg5f5Dl6quVGV63vwIe7VMbl2WUbEiPg7hOuDWeLaxXcOWgV8aZOLSl1pPHB-B2GKspcLKIFJAdEgMd9klFgbC6y4z_ebuoHnAnUG-WcoQ1BID2CzEHSBztv_IUtseWBGLh7d8vJCyA1IAV/s1600/164922_142243359315119_1885176467_n.jpg)

</div>

Utilizando o Rio Mago, que desaguava no Mar, a cidade de Harad era um ponto comercial entre Primus e Dagorcain. Alcançar Primus pelo Mar de Sangue, navegando entre os arquipélagos de Fogo, nome que os marinheiros dão ao pequeno conjunto de Ilhas entre os continentes, era um trabalho de grande honra e perigo. E fora um Poderoso Almirante que comandava esses corajosos homens que fundou a cidade de Harad e o Porto Rio-Mar.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

 A cidade cresceu devido ao grande comércio que lá havia. Pessoas de todo o continente a visitavam para provar das iguarias de Primus e outros lugares desconhecidos a muitos de Dagorcain. E ela é assim até hoje.

</div>

<div class="MsoNormal">

  

</div>

## Quanto a Organização

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

 Os lideres da cidade são descendentes desse grande Almirante, seu nome era Harador o Senhor das Embarcações. E por baixo do nariz da Escola de Magia, ainda empreendem-se no Arquipélago de Fogo, e a cidade ainda é um ponto aonde os povos do Sul viajam por comercio e curiosidade, em busca das atrações vindas de Primus, que hoje é muito mais desconhecido e estranho aos povos de Dagorcain.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

<div style="text-align: right;">

</div>

Os comerciantes tomam a cidade, que possui 7 Distritos e o Centro comercial, aonde os donos de mercados ambulantes e outros tipos de comercio pagam uma fortuna para ficar um dia no local. A cidade se divide em oito círculos, os 3 últimos fica a periferia da cidade, lugar perigoso para aventureiros novos na região. Podem ser enganados facilmente, levados a emboscadas ao pedirem informações. Guildas de Ladrões e comerciantes tratantes ficam no local, e vendem e contrabandeiam tudo que a Escola de Magia de Elódia considera como Ilegal. Aqui os mercadores pagam o menor preço pela estadia.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

Nos 2 próximos distritos estão as mansões e casarões dos Nobres, sócios dos navios comandados pelo Almirante Chefe da Cidade, Haradorion IV. Os moradores e mercantes da Região são sigilosos e cheios de pilantragens por debaixo dos panos. Ao contrário das periferias, aonde é necessário grande quantidade de guaritas e guardas, que trabalham dia e noite para manter a ordem, os Distritos dos Nobres são organizados, e qualquer ilegalidade é bem administrada. Os mercantes da Região são os que possuem maior informação em toda a cidade, e pagam um preço mediano para estadia.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

Os 2 últimos distritos antes do Centro Comercial, residem os parentes e associados dos Lideres do Comércio da Cidade, que vivem no Centro Comercial, liderados por Haradrak III, irmão mais velho do Almirante Chefe, cargo dado sempre ao mais novo dos irmãos da família Principal chefiada sempre pelo mais velho de cada geração . Os Distritos de Sangue é local de Mansões e pequenos Castelos, aonde a família dos Almirantes Chefe residem e administram. Os mercantes aqui são menos sigilosos, considerados fanfarrões, sabem algumas informações e as liberam sem dificuldade a vista de bons pagamentos, acreditam ser tão ricos e cultos quanto os mercantes e moradores do Centro Comercial, e adoram receber elogios sobre isso.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

O Centro Comercial é a residência de todos os Senhores comerciais da Cidade. Eles tem informantes a seu comando em cada nível da grande cidade, e tem como Líder o Coronel do Mar, cargo atualmente ocupado por Haradrak III, irmão mais velho da ultima geração. Seus irmãos, excluindo o casula, compõe o Conselho da cidade. Os membros do conselho podem ter cargos administrativos além de seu cargo garantido por nascimento.

</div>

<div class="MsoNormal">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqX5t1QcFjAOchlku3VrH8cgIVKGQct-DTnnRzxfNqNiMEVJGNJtdJySEPp7yPOSTAruUpcSzsaKzMAoQ4vbwdO7_WA6SiQArU_z1BealKO5g5566mXEiBXRrv-ASRAX8bgRLr5ku8k0dv/s640/cityone_towncenter.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqX5t1QcFjAOchlku3VrH8cgIVKGQct-DTnnRzxfNqNiMEVJGNJtdJySEPp7yPOSTAruUpcSzsaKzMAoQ4vbwdO7_WA6SiQArU_z1BealKO5g5566mXEiBXRrv-ASRAX8bgRLr5ku8k0dv/s1600/cityone_towncenter.jpg)

</div>

  

</div>

<div class="MsoNormal">

Esses Cargos Administrativos são geralmente ocupados por grandes Comerciantes que conseguiram o direito de morar na cidade e chefiam grandes caravanas que se instalam em todos os níveis de Harad. É necessária uma fortuna para instalar empreendimentos na região.

</div>

<div class="MsoNormal">

  

</div>

  

<div class="MsoNormal">

Existem mercadores fixos, que vivem no local e pagam todo mês pela sua estadia, e também existem aqueles que pagam a diária para vender na região. Esses não são muito informados, e cumprem ordens ao pé da letra. São extremante sigilosos. Mas existem alguns pequenos líderes desses comércios que podem saber tanto quanto os Administradores da Cidade.     

</div>

<div class="MsoNormal">

  

</div>

## Hierarquia

### Familia

<div>

#### *<span class="underline">Chefe da Família</span>* - Cargo dado ao Coronel do Mar anterior, e só seus filhos receberão os cargos principais da família.

<div class="MsoNormal">

 Haradior II

</div>

#### *<span class="underline">Coronel do Mar</span>* - Cargo dado ao Irmão mais velho da nova Geração.

<div class="MsoNormal">

Haradrak III, filho de Haradior II - Atual

</div>

#### *<span class="underline">Conselheiros</span>* - Cargo dado aos Irmãos do Meio

<div class="MsoNormal">

\- Horus VI

</div>

<div class="MsoNormal">

\-Haradril II

</div>

<div class="MsoNormal">

\-Helena V - Também Senhora dos Administradores

</div>

<div class="MsoNormal">

  

</div>

#### *<span class="underline">Almirante Chefe</span>* - Cargo exclusivo ao Casula de cada Geração

<div class="MsoNormal">

 (acredita-se que Harador, fundador da cidade, e primeiro Almirante Chefe era o mais novo de seus irmãos, e seu filho mais velho foi o primeiro Coronel do Mar, e assim seguiu o costume).

</div>

<div class="MsoNormal">

Haradorion IV - Atual

</div>

<div class="MsoNormal">

  

</div>

### Administração -

#### <span class="underline">*Senhor Administrador*</span> (Ocupado geralmente por um filho mais velho de um dos Conselheiros Anteriores, a decisão vira através de uma disputa feita em um grande festival).

<div class="MsoNormal">

\-Helena V 

</div>

<div class="MsoNormal">

  

</div>

#### <span class="underline">*Administradores*</span> - Um total de 7 por geração, aonde 2 lugares da mesa são destinados aos filhos do Almirante Chefe Anterior. Outros 5 serão dados a qualquer um que esteja ao nível de tal Cargo.

<div class="MsoNormal">

\-Haradior III, filho do Almirante;

</div>

<div class="MsoNormal">

\-Harendor , filho do Almirante;

</div>

<div class="MsoNormal">

\-Quirion Stormborn, que possui um representante no seu lugar;

</div>

<div class="MsoNormal">

\-Honesto, Senhor de Cavalos;

</div>

<div class="MsoNormal">

\-Valquiria, Senhora das Caravanas de Amonhain;

</div>

<div class="MsoNormal">

\-Samuell Grey, Representante de Primus;

</div>

<div class="MsoNormal">

\-Vanys Fëa, das Caravanas Drow;

</div>

</div>$MDS$, array['Elódia','Grandes Cidades']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Cidade de Harad, no Grande Deserto de Dagorcain');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Sobre a antiga cidade Anã Cryptawn', 'sobre-a-antiga-cidade-ana-cryptawn', $MDS$> 📰 Blog *Mar de Sangue* · 2013-07-24 · marcadores: Grandes Cidades, Mestragem
> Fonte: https://maresdesangue.blogspot.com/2013/07/sobre-antiga-cidade-ana-cryptawn.html

<div class="MsoNormal">

<span style="font-size: large;"><span class="underline">A História de Cryptawn</span></span>

</div>

<div class="MsoNormal">

<span style="font-size: large;"><span class="underline">  
</span></span>

</div>

<div class="MsoNormal">

(Cryptown é o local aonde Thúrin disse aos jogadores ter escondido a Chave Mestra do Caixão, local marcado no mapa)

</div>

<div class="MsoNormal">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi0gu-UfPU5xjn6cphRrksFrkdRShh0-4jHpNJFe5bMH9zYFEeK4FMCyxj02d_S5WAG_0JQj5XkmkNZgf5zClZlhyphenhyphenAkEJoblCO7Ip5pXcjEfY2rUg2q9CcpOWZAc5mJPvYJ2Q_8mrr5QLZ7/s400/dungeon-05.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEi0gu-UfPU5xjn6cphRrksFrkdRShh0-4jHpNJFe5bMH9zYFEeK4FMCyxj02d_S5WAG_0JQj5XkmkNZgf5zClZlhyphenhyphenAkEJoblCO7Ip5pXcjEfY2rUg2q9CcpOWZAc5mJPvYJ2Q_8mrr5QLZ7/s1600/dungeon-05.jpg)Udúrugun na língua anã, na língua comum se chama Cryptawn, a cidade cripta. Nos tempos que principiaram a Guerra contra os Demônios, na primeira Era, os anões chegaram ao continente de Dagorcain. Muitos se instalaram nas montanhas da Região que chamamos atualmente de Dranor,  outros na região das montanhas de Ferro, onde estão as ruinas dos reinos antigos dos Anões Viajantes.  Sabe-se que muitos desses anões se aventuraram na região Sudeste do Continente, na região compreendia como "As Garras", e lá fundaram uma grande cidade.

</div>

<div class="MsoNormal">

Naquele tempo ela era chamada de Mahîn, a cidade das grandes Criações. Esta belíssima cidade fora a primeira a fazer contato com os povos de Primus, o continente vizinho de Dagorcain a sudeste. Mas aqueles Anões não eram navegantes, mas grandes criadores de armaduras, armas, joias e outras coisas admiráveis.  A cidade aproveitou a maior riqueza que algum Reino Anão de Dagorcain já houvera experimentado, e foi ela quem proporcionou todas as condições necessárias para que Harador pudesse fundar a grande cidade de Harad, e assim, criar um verdadeiro ponto de comercio entre Dagorcain e Primus.

</div>

<div class="MsoNormal">

Dizem que seus salões são tão imensos e tão profundos  que alcançaram riquezas incompreensíveis mesmo aos olhos anões. Grandes coisas essa cidade construiu e desenvolveu. E grande riqueza ela trouxe para os povos de Dagor.

</div>

<div class="MsoNormal">

Mas durante a Guerra contra os Demônios a cidade foi invadida. Por longos dias os Anões resistiram ao cerco demoníaco,  e o número de mortos era absurdo. Depois de dias se defendendo os demônios foram finalmente derrotados, mas muito poucos sobreviveram, e o grande Rei da Cidade caiu na batalha.

</div>

<div class="MsoNormal">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhTMzZvwUWK5ZilLTZLxT8FSzt8GYzafcBmdJoSG_TnZ8KBefO1qLuDDYGSHM3nZXFxus2wEJs0ku88JtAVhPq-GipmF_6wdqxJeU-B4rhs21JkCC6YBdtAzAgftI_blsW02An7_eCThNUs/s320/dungeon-ulduar-02-full.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhTMzZvwUWK5ZilLTZLxT8FSzt8GYzafcBmdJoSG_TnZ8KBefO1qLuDDYGSHM3nZXFxus2wEJs0ku88JtAVhPq-GipmF_6wdqxJeU-B4rhs21JkCC6YBdtAzAgftI_blsW02An7_eCThNUs/s1600/dungeon-ulduar-02-full.jpg)A cidade se tornou um símbolo de tristeza e morte, então os anões decidiram torná-la o túmulo de todos os que morreram ali. Em todos os lugares na cidade eles construíram criptas e templos,  locais para mortos e tumbas para milhares. E o lugar foi fechado e consagrado pelos Anões. Um costume se iniciou, e lá foram colocados os túmulos dos maiores Reis, Senhores e Mestres anões.  E assim se seguiu até a morte de Thúrin, o Imprudente.

</div>

<div class="MsoNormal">

Sabe-se que pela amizade que existia entre Harad e a antiga Mahîn, agora chamada de Cryptawn na língua comum, o filho do falecido Rei de Mahîn entregou ao Coronel do Mar da cidade de Harad uma das três chaves que poderiam abrir as portas daquele lugar, não se sabe o porque, mas desde então essa chave é guardada por todo Coronel do Mar que lidera Harad. As outras duas chaves se perderam, a ultima delas se perdeu com Thúrin, no dia em que ele teria sido soterrado nas montanhas Thangor.

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

  

</div>

<div class="MsoNormal">

<span style="font-size: large;"><span class="underline">Conhecimentos:</span></span>

</div>

<div class="MsoNormal">

<span style="font-size: large;"><span class="underline">  
</span></span>

</div>

<div class="MsoNormal">

Cryptawn possui mais de 100 grandes Salões, com tamanhos descomunais(imaginem o grande salão de Moria). Todos estão divididos em níveis, pois a antiga cidade foi construída muito abaixo na terra.

</div>

<div class="MsoNormal">

A cidade possui um Salão principal, algo comum em construções anãs, com dezenas de corredores que levam para os 5 níveis a abaixo da terra, e os 3 níveis acima da base da montanha. 

</div>

<div class="MsoNormal">

Sabe-se que estranhos são reconhecidos, e a cidade é repleta de armadilhas, geralmente com painéis ocultos para serem desarmadas com chaves próprias, ou com um boa arte de ladinagem.  O uso de forjados e maquinarias mágicas é comum nesse tipo de construção.

</div>

<div class="MsoNormal">

As principais tumbas estão localizadas nos 3 níveis que sobem  o interior da montanha,  da base ao cume.  Porém os maiores tesouros se localizam nos níveis abaixo.

</div>

<div class="MsoNormal">

Cuidado com qualquer fonte de água que seja encontrada dentro da cidade, e não abaixe sua guarda em nenhum momento, armadilhas e meios de defesa que usam da furtividade são bastante comuns.

</div>

<div class="MsoNormal">

Os anões tem o costume de aprisionar ou "contratar" guardiões monstruosos em suas dungeons, como o Behouder enfrentado no Templo de Lórien que protegia a passagem para a sagrada Colina Anã, aonde os jogadores se encontraram com Thúrin.

</div>

<div class="MsoNormal">

Os caminhos para os salões principais foram os mais usados nos últimos tempos, e os que levam para as profundezas de Udúrugun estão abandonados a milhares de anos.

</div>

<div class="MsoNormal">

Blocos no chão, cordas escondidas, tesouros amostra, áreas mágicas são gatilhos muito traiçoeiros que infestam local.

</div>

<div class="MsoNormal">

Thúrin, antes de morrer, não disse aos jogadores aonde ele escondeu a chave, se junto aos tesouros nas profundezas da cidade, ou nos tão bem guardados salões aonde os grandes Reis descançam.

</div>

<div class="MsoNormal">

Qualquer outro detalhe necessário será compensado com as vantagens em perícias que serão dadas aos leitores.

</div>

<div class="MsoNormal">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhWRNjf6z8rifGxxW-bw9T_z2368pjgtHbpxOkrKYSDt2MqVQf19LXh7DkfOhcsphQGQ75ypsy6D5tNAifuuQuwXkJcY_XvRauY1zkTeynmx5A1ZJlX2NpkUIDBUsERmG9ue9cz1XgjuNjq/s640/env02-full.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhWRNjf6z8rifGxxW-bw9T_z2368pjgtHbpxOkrKYSDt2MqVQf19LXh7DkfOhcsphQGQ75ypsy6D5tNAifuuQuwXkJcY_XvRauY1zkTeynmx5A1ZJlX2NpkUIDBUsERmG9ue9cz1XgjuNjq/s1600/env02-full.jpg)

</div>

  

</div>

<div class="MsoNormal">

OUTROS TEXTOS SUGERIDOS(TODOS NA MARCAÇÃO "HISTÓRIA"):

</div>

<div class="MsoNormal">

  

</div>

### [Ascenção do Reino Anão Leste](http://maresdesangue.blogspot.com.br/2013/04/ascencao-do-reino-anao-leste.html)

  

<div class="MsoNormal">

  

</div>

### [Da ruína de Thúrin o Imprudente](http://maresdesangue.blogspot.com.br/2013/04/da-ruina-de-thurin-o-imprudente.html)

<div>

  

</div>

<div>

### [Da Construção do Grande Templo Gaurgrod](http://maresdesangue.blogspot.com.br/2013/05/da-construcao-do-grande-templo-gaurgrod.html)

</div>$MDS$, array['Elódia','Grandes Cidades']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Sobre a antiga cidade Anã Cryptawn');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Elódia a Escola de Magia - Guia 01', 'elodia-a-escola-de-magia-guia-01', $MDS$> 📰 Blog *Mar de Sangue* · 2013-09-19 · marcadores: Elódia, Grandes Cidades
> Fonte: https://maresdesangue.blogspot.com/2013/09/elodia-escola-de-magia-guia-01.html

<div class="MsoNormal" style="text-align: justify;">

<div>

         Elódia é uma das cidades mais antigas e poderosas do continente. Nela residem duas instituições que detém conhecimento incalculável e uma grande quantidade de poder mágico. 

</div>

</div>

  

## 1\. A Escola de Magia

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

A grande escola de magia de Elódia é considerada a mais antiga e poderosa escola das artes arcanas do continente.

</div>

  

### I. Recrutamento, Alunos e Anjos

<div>

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEivizAgdJTe13sPEAXDl7jr73kH9W6DhaJSymSae9VodYQcHu8o3iQ9v4OoYj95whFqS36VDlgsOvvxTqjBdt-DxmCxfn5Odds5VLUyJve9A3gA5I-f5EdCYmr5GyJ9YqqtzX6x59a6cGQ/s320/Escribano.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEivizAgdJTe13sPEAXDl7jr73kH9W6DhaJSymSae9VodYQcHu8o3iQ9v4OoYj95whFqS36VDlgsOvvxTqjBdt-DxmCxfn5Odds5VLUyJve9A3gA5I-f5EdCYmr5GyJ9YqqtzX6x59a6cGQ/s1600/Escribano.jpg)  

<div style="text-align: justify;">

A escola recruta e treina centenas de criaturas com potencial mágico. Essas criaturas são contatadas em geral por carta. Recebem um convite oficial que lhe permitirá receber a instrução de nível básico, que consiste num treinamento de um ano. Em troca desse treinamento é estabelecido um relacionamento deste aluno com a instituição, chamado de “corrente”. Uma “corrente” é um acordo de fidelidade em que esse aluno tem obrigações para com a cidade. Essas obrigações podem ter diversas naturezas. Desde enviar relatórios de suas ações, realizar alguma missão, receber um emissário ou aprendiz em sua residência até convocações para defender diretamente a cidade ou comparecer a algum campo de batalha designado. Essa, porem é uma corrente de “Duas Pontas” como é ensinado nas aulas de hierarquia e obrigações que se ministram no curso. Qualquer um que tenha participado de alguma das turmas da escola tem acesso a várias oportunidades. Participar desse treinamento significa de forma direta que muitos conhecimentos foram passados e que esse indivíduo dispõe de uma elevada capacidade de manipulação arcana em sua área de atuação, sendo assim ele terá grande facilidade de conseguir um cargo de confiança e destaque em qualquer cidade ou clã. Também ocorre que passar pela escola é o único caminho disponível para qualquer um que queira tecer uma carreira entre as muitas fusões publicas disponíveis em Elódia. Fora isso também vale dizer que, em geral, alguém que tenha passado por esse treinamento será bem recebido em qualquer cidade aliada e tratado com devido respeito na grande maioria do continente. Todo aluno também tem um mestre individual chamado de “anjo”. Um “anjo” é um mago que vive na cidade. É através deles que se mantem sempre a comunicação de cada antigo aluno com a cidade. Eles têm a capacidade de se comunicar mesmo que a distancia com seus protegidos e os defenderá caso estes forem acusados. São mentores, representantes e protetores. Todo mago em atividade no baixo concelho tem, por obrigação, vários protegidos sobre sua responsabilidade.

</div>

  

</div>$MDS$, array['Elódia','Grandes Cidades']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Elódia a Escola de Magia - Guia 01');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Elódia a Biblioteca - Guia II', 'elodia-a-biblioteca-guia-ii', $MDS$> 📰 Blog *Mar de Sangue* · 2015-01-13 · marcadores: Elódia, Grandes Cidades
> Fonte: https://maresdesangue.blogspot.com/2015/01/elodia-biblioteca-guia-ii.html

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">A segunda instituição de maior poder em Elódia. A biblioteca.</span>

</div>

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">  
</span>

</div>

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<div class="separator" style="clear: both; text-align: center;">

[<span style="color: white; font-size: large;">![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgE_tnx_F2KvcGQ12eqTns1Tdnsx2UfQqTI-RBsqRXmSkHRS0JH2UVh-PkNo7S1_n1iCB0o7F6NRP6BqLN6Xv_vVXLH2_oYR2T8uS33mnc5UiP-_o7FXB6OfpFR_iJdgOa5fomk_8p5DLg/s1600/2985593_orig.jpg)</span>](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgE_tnx_F2KvcGQ12eqTns1Tdnsx2UfQqTI-RBsqRXmSkHRS0JH2UVh-PkNo7S1_n1iCB0o7F6NRP6BqLN6Xv_vVXLH2_oYR2T8uS33mnc5UiP-_o7FXB6OfpFR_iJdgOa5fomk_8p5DLg/s1600/2985593_orig.jpg)

</div>

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">  
</span>

</div>

<span style="color: white; font-size: large;">**  
** </span>  

1.  
    
    <div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">
    
    <span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">A Biblioteca </span>
    
    </div>

<span style="color: white; font-size: large;">**  
** </span>  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">A grande biblioteca de Elódia é responsável por guardar segredos e poderes milenares adquiridos em séculos de existência da grande cidade. É reconhecida entre as instituições mais respeitáveis do continente e desponta imponente dentro dos muros da grande cidade.</span>

</div>

<span style="color: white; font-size: large;">**  
** </span>  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">II. Setores e níveis de acesso</span>

</div>

<span style="color: white; font-size: large;">**  
** </span>  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">A biblioteca de Elódia subdividisse em níveis e setores hierarquizados de acesso à informação. Esse modus operandi de controle é utilizado para que se preserve a segurança e o sigilo das informações. </span>

</div>

<span style="color: white; font-size: large;">**  
** </span>  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Existem duas grandes alas:</span>

</div>

<span style="color: white; font-size: large;">**  
** </span>  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Ala livre: contem textos de caráter acadêmico, ou seja, utilizados em estudos e pesquisas.</span>

</div>

<span style="color: white; font-size: large;">**  
** </span>  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-left: 36pt; margin-top: 0pt; text-indent: 36pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;"> Esses documentos subdivide-se em:</span>

</div>

<span style="color: white; font-size: large;">**  
** </span>  

  - 
    
    <div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">
    
    <span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Abertos: livres a toda criatura sem pendencias com o governo.</span>
    
    </div>

  - 
    
    <div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">
    
    <span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Sigilosos: exigem que a pessoa que requisita o documento seja um cidadão de Elódia ou tenha a devida autorização do conselho administrativo da biblioteca. </span>
    
    </div>

  - 
    
    <div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">
    
    <span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Muito Sigilosos: só pode ser acessado por cargos de alta relevância na esfera administrativa ou com devida autorização do conselho inferior.</span>
    
    </div>

  - 
    
    <div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">
    
    <span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Sigilo Eterno: só pode ser acessado com autorização do conselho superior.</span>
    
    </div>

<span style="color: white; font-size: large;">**  
** </span>  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Ala restrita: esta não pode ser adentrada fisicamente. Apenas a ordem dos guardiões transita em seus corredores. Nela estão guardados todo e qualquer texto de importância fundamental ou que representa um perigo crítico a Elódia ou ao continente. Suas instalações se encontram isoladas do restante do complexo e permanecem sobre permanente vigilância. Algum documento dessa ala pode ser solicitado ao concelho inferior, mas só será liberado sobre autorização do conselho superior. Se a liberação acontecer a criatura responsável pelo pedido será escoltada até uma antessala e nela poderá estudar o texto por tempo previamente determinado e sobre tutela ininterrupta.            </span>

</div>

<div class="separator" style="clear: both; text-align: center;">

[<span style="color: white; font-size: large;">![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixsW-Q9chvz_BGi-c9jtqLmjFw_Dk-uR0Cfr5QnFDHbq5Io9D2ylmCa5isnaAB0aGgWYJKvp-6JByO5tZS7j6wd4mXGbCEjEmDZdks30GrLTMmv1ymIqveBY_cspROYc4THLinn7nPNbs/s1600/monge.jpg)</span>](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEixsW-Q9chvz_BGi-c9jtqLmjFw_Dk-uR0Cfr5QnFDHbq5Io9D2ylmCa5isnaAB0aGgWYJKvp-6JByO5tZS7j6wd4mXGbCEjEmDZdks30GrLTMmv1ymIqveBY_cspROYc4THLinn7nPNbs/s1600/monge.jpg)

</div>

**<span style="color: white; font-size: large;">  
</span>**  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">III. Ordem de Alek ou Ordem dos Guardiões </span>

</div>

<span style="color: white; font-size: large;">**  
** </span>  

<div dir="ltr" style="line-height: 1.15; margin-bottom: 0pt; margin-top: 0pt;">

<span style="background-color: transparent; color: white; font-family: &#39;Times New Roman&#39;; font-size: large; font-style: normal; font-variant: normal; font-weight: normal; text-decoration: none; vertical-align: baseline; white-space: pre-wrap;">Esta é uma ordem dedicada a preservação e guarda da grande biblioteca. Foi fundada por Alek um mago lendário das primeiras eras. Reza a lenda que este foi um grande estudioso, que dedicou toda sua longa vida aos livros e a observação e que em seu impeto insaciável driblou por muitas vezes a morte na busca de mais tempo para seu conhecimento e seus escritos. Em sua encruzilhada Alek teria fundado a grande biblioteca e posteriormente a ordem. Não se sabe completamente seus passos, mas é de conhecimento comum que em algum momento sua mente perdeu se em seu saber e este passou a outros planos numa insana e eterna busca.</span>

</div>

<span style="color: white; font-size: large;">  
</span> <span style="color: white; font-size: large; vertical-align: baseline; white-space: pre-wrap;">Atualmente o grupo é composto de estudiosos dedicados que cumprem diversos votos e horas interináveis de estudo. São toda mão de obra interna da biblioteca, cumprem desde funções menores como a limpeza e jardinagem do espaço até sua gerencia e proteção. Seu líder máximo é integrante do conselho superior e mantem representantes também no conselho inferior.   </span>  
<span style="color: white; font-size: large;"><span style="vertical-align: baseline; white-space: pre-wrap;">  
</span> </span>  

<div class="separator" style="clear: both; text-align: center;">

[<span style="color: white; font-size: large;">![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhUAhB71J7degFxY4UyCLq4uxwCgJnPPLyC8lnsRrykqYbcgv9UFofUp2r41DcCfnGRjevgcuZ0Sqk2sMsuzG-mvPk2s6e1NNeq7Lx6HPL9oYm7KqmiUKh4zV6t63k2xu-BXB2wbipkZvU/s1600/mage.jpg)</span>](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhUAhB71J7degFxY4UyCLq4uxwCgJnPPLyC8lnsRrykqYbcgv9UFofUp2r41DcCfnGRjevgcuZ0Sqk2sMsuzG-mvPk2s6e1NNeq7Lx6HPL9oYm7KqmiUKh4zV6t63k2xu-BXB2wbipkZvU/s1600/mage.jpg)

</div>

<div class="separator" style="clear: both; text-align: center;">

<span style="color: white; font-size: large;">Alek em seus estudos</span>

</div>

<span style="font-size: 15px; vertical-align: baseline; white-space: pre-wrap;">  
</span>$MDS$, array['Elódia','Grandes Cidades']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Elódia a Biblioteca - Guia II');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'Trombeta de Dagor - Nº 1', 'trombeta-de-dagor-no-1', $MDS$> 📰 Blog *Mar de Sangue* · 2013-07-23 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/07/trombeta-de-dagor-n-1.html

## 

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Possível guerra a sudeste de Elódia causa preocupação

<div style="text-align: justify;">

 Um conflito tem causado preocupação aos magos de Elódia e a Dranar, pois o clã anão Espada de Cobre e a cidade elfa de Panroar (liderada pelo famosa sacerdotisa de Pelor, Cis) tem trocado hostilidades. Ataques vem ocorrendo de ambos os lados. Ambos negam atacar, mas confirmam que foram atacados pela força rival. Não se sabe qual dos lados está mentindo, mas algum  com toda certeza está. Grupos de aventureiros foram convocados para tentar achar a chave do problema, mas até agora não foi resolvido.

</div>

> 
> 
> <div style="text-align: justify;">
> 
> "Essa quase-guerra está trazendo prejuízo a todo mundo. Ninguém sabe onde e quando será o próximo ataque. Isso é realmente estranho."
> 
> </div>

<div style="text-align: justify;">

Diz o meio-elfo Markas, guarda de  caravana que fazia o trajeto Espada-de-Cobre/Panroar. Perguntada sobre os ataques a rainha Cis declarou que não sabia por que os anões acusavam suas cidade de hostilidade, garantindo não saber onde se embasa Prud, chefe do clã, para acusa-la de tal  forma.

</div>

  
  
  

### Ataques de Lobisomens por todo continente

<div style="text-align: justify;">

Uma onda de ataques por todo continente tem acontecido ultimamente. Não se tem explicação para o que está ocorrendo, mas o medo está se alastrando por todos os cantos. Bandos que costumavam habitar área específicas estão saindo de suas zonas para ataques em vilarejos e caravanas na estrada. Já chegam a mais de quinze os casos reportados ao conselho de Elódia. Se diz que medidas já estão sendo tomadas, mas até agora, nada aconteceu. 

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

### Torneio cervejeiro agita Pavio-Curto

<div style="text-align: justify;">

Uma legião de admiradores dessa amável bebida está se movendo para a cidade de Pavio-Curto, a leste de Elódia, pois lá está para  começar um torneio de quem consegue beber cerveja\! Organizado e patrocinado pela rede de Tavernas Vomito de  Dragão, o vencedor irá ganhar quinhentas peças de ouro, o anel Bafo de Dragão que dá ao dono o direito de  beber o quanto quiser em qualquer taverna afiliada além é claro da cobiçada Caneca do Dragão.

</div>

> 
> 
> <div style="text-align: justify;">
> 
> "Esse ano estou vindo com tudo. Já competi outras vezes mas nunca cheguei a final. Mas dessa vez já consigo sentir os meus dedos naquela Caneca. Irei vencer mas o meu fígado ira sofrer com certeza."
> 
> </div>

<div style="text-align: justify;">

Diz entre entra risadas, Frufrier, um halfling morador de Pavio-Curto famoso por seus desaforos e peripécias na região. A competição até o momento tem setecentos inscritos e estão comprometidos para o consumo mais de cem mil litros de cerveja. O torneio virá acompanhado de um festival na cidade com muitas competições, na arena inclusive. Um batalhão de duzentos homens estará reforçando a segurança no evento, eles foram cedidos pelo rei Eric da cidade de Aton, esse que estará competindo na arena nos dias de torneio.

</div>

<div class="separator" style="clear: both; text-align: center;">

<http://fairefinery.tripleflamingo.com/wp-content/uploads/Dragon-Tankard-4.jpg>

</div>

  

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

###$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Trombeta de Dagor - Nº 1');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Voz de Harad nº. 32 -  ano 2068', 'a-voz-de-harad-no-32-ano-2068', $MDS$> 📰 Blog *Mar de Sangue* · 2013-08-02 · marcadores: Jornal, Mestragem
> Fonte: https://maresdesangue.blogspot.com/2013/08/a-voz-de-harad-n-32-ano-2068.html

## (Jornal lançando durante uma mestragem, entregue aos jogadores pelo mestre)

## O GRANDE TORNEIO DE HARAD CONTINUA ATRAINDO O POVO DE DAGOR\!  
*"Em Harad nos esquecemos até mesmo da guerra e dos magos Sombrios\!" diz um viajante das cidades de Elódia.*

<div>

<div>

  

</div>

<div>

Ao contrário do que o governo esperava devido a guerra, o Torneio mais uma vez impressiona os povos do deserto atraindo uma quantidade absurda de famílias, aventureiros e mercadores a Harad\! A cidade que já é sempre movimentada está tendo problemas com a super lotação de tabernas. Mesmo com seus incríveis 700 mil habitantes, a cidade parece um formigueiro, tendo uma média de 7 mil mercadores entrando e saindo da cidade todos os dias, sem contar, é claro, com a Periferia de Harad, que causam terríveis problemas aos guardas e vigilantes das cidades\!

</div>

<div>

  

</div>

<div>

*"Acredito que a guerra tem tornado os outros reinos e cidades/capitais um local de tensão\! A cidade de Harad, assim como Rumenil, Elódia, Hurnburg e Centrelfica na floresta Morenhal, tem sido lugares que as pessoas buscam para fugir dos rumores e desprazeres da guerra\!" diz Olig, anão do Reino Oeste;*

</div>

<div>

*  
*

</div>

<div>

*  
*

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEivLOFiTkhtq6h93iIQxg_j2LNkq33oaaKkJJLgUBM1Akc2fH7CYiYospsWCJb2ZQZvaibQQxteejyMk3xVxNbdBDkHlyqpQWGs4N1aj1f4dQ4bBIzKcDsRlqqEdW1P0wye7XiITPNBmurG/s320/tavernaolpartu.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEivLOFiTkhtq6h93iIQxg_j2LNkq33oaaKkJJLgUBM1Akc2fH7CYiYospsWCJb2ZQZvaibQQxteejyMk3xVxNbdBDkHlyqpQWGs4N1aj1f4dQ4bBIzKcDsRlqqEdW1P0wye7XiITPNBmurG/s1600/tavernaolpartu.jpg)

</div>

<div>

  

</div>

## 

## E O TORNEIO TRÁS GRANDES SURPRESAS A PARTIR DE JOGADORES INÉDITOS\!

<div>

  

</div>

<div>

O grupo de aventureiros intitulado "Os Cangaceiros", surpreendeu ao derrotar os já 3 vezes finalistas "Drows de Chomôdo" durante a fase de Grupos\! Os Drows já estavam para ser desclassificados com a polêmica morte dos Ciclopes de Niss, um grupo também muito popular que, de acordo com os elfos negros, teriam morrido por um triste acidente. 

</div>

<div>

Os Cangaceiros também já haviam levado a arquibancada aos gritos e honrarias com a incrível e sofrida vitória sobre os Irmãos Marut, que detiveram a Manopla de Ouro em 2066.

</div>

<div>

  

</div>

<div>

*"O Paladino e o Anão foram certamente os favoritos, derrotaram Drakar Marut em uma velocidade surpreendente\!" Diz Mia Lenis, filha do Conselheiro Celennor.*

</div>

<div>

  

</div>

<div>

*"O Golias aguentou Trark Marut como ninguém, assim como suportou os continuos ataques de Hurion e Radir Chomôdo\! E o Feiticeiro fez milagres desferindo golpes certeiros\!"Diz um o Nobre apostador Rugor Tenur.*

</div>

<div>

  

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgxAEMMMV8VLTkcNKdDzwuHIduo7_mxe7cC9lBJ0v-Q0mYFfgYOLoiJllM13YM5ErrzZVTKYZptvB8pnlNVdpzzg0_ILj1wr08DzI0UGHvvI_l8GGUeDS6oVJGLB4st6nV0rxeTY6VaGSMB/s320/Gauntlet_of_Light_by_The_Great_Kubo.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgxAEMMMV8VLTkcNKdDzwuHIduo7_mxe7cC9lBJ0v-Q0mYFfgYOLoiJllM13YM5ErrzZVTKYZptvB8pnlNVdpzzg0_ILj1wr08DzI0UGHvvI_l8GGUeDS6oVJGLB4st6nV0rxeTY6VaGSMB/s1600/Gauntlet_of_Light_by_The_Great_Kubo.jpg)

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>

<div>

Agora o Torneio segue para as Quartas de Final, e os Cangaceiros se unem aos Ferais da Lua, como os favoritos para as finais\! Será que estamos presenciando a ascensão de um novo grupo na história do Torneio? Quem serão os detentores da Manopla de Ouro esse ano? O Torneio está em seu período de pausa, e recomeça suas atividades em uma semana\! AGUARDEM POR MAIS SURPRESAS\!

</div>

<div>

  

</div>

## A VIOLÊNCIA NA CIDADE AUMENTA JUNTO COM O NÚMERO DE VISITANTES\!

<div>

  

</div>

<div>

De todos os trabalhos oferecidos aos viajantes, o que mais cresceu certamente foi o de guardas e vigilantes\! O número de mortes tem crescido mesmo nos distritos nobres, e as gigantes periferias de Harad estão infestadas de crimes\! O governo tem conseguido contratar mercenários a preços altíssimos, já que estão competindo com os militares que contrataram mercenários para guerra, e pagam bons salários aos viajantes que venham se voluntariar para o serviço.

</div>

<div>

  

</div>

<div>

Essa madrugada, um grupo de guardas e mercenários que guarneciam os portões dos portos da cidade foram mortos a sangue frio\! Se o ocorrido trata-se de uma invasão as escondidas o governo não diz\! Mas se sabe que estão oferecendo uma boa recompensa aos que descobrirem e encontrarem/matarem os assassinos\!  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhtuvY5H0SA_Glp6i2ybI5R9Y00zbmeN7eVd0j6QMiDxGVHIlJAZgc76vccVuWSXtZ4DkB0wVm32Pe92PGKjbMfWSVtuVlbcf5GfMKfcT6W1OdNHV6909PmMH64_xjl5Wvk7N1tkJO3eE93/s320/2_20090121_taverna_004.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhtuvY5H0SA_Glp6i2ybI5R9Y00zbmeN7eVd0j6QMiDxGVHIlJAZgc76vccVuWSXtZ4DkB0wVm32Pe92PGKjbMfWSVtuVlbcf5GfMKfcT6W1OdNHV6909PmMH64_xjl5Wvk7N1tkJO3eE93/s1600/2_20090121_taverna_004.jpg)

</div>

  

</div>

<div>

  

</div>

<div>

AS TAVERNAS VODKAR ESTÃO PATROCINANDO O TORNEIO E GARANTEM OS MELHORES PREÇOS E LUGARES NO ESTÁDIO DE HARAD\! OS INGRESSOS ESTÃO ACABANDO, VENHA GARANTIR O SEU\!

</div>

<div>

<div class="separator" style="clear: both; text-align: center;">

<https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiy7aiRCAaAvZSOM_dvGg_0DO-SPS6bCa9TP3wxUMZLFaIFZ3S5RhSgl97FBB0Kq7NeUvCUowZNxxm_j3OK_fdAn_dIOMHce8MLffDkoMfVjqWGhLXsN9tW3Wcxc2bdb3vYXdAWDz6XjbWz/s1600/taberna.jpg>

</div>

  

</div>

<div>

  

</div>

<div>

</div>

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Voz de Harad nº. 32 -  ano 2068');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'Trombeta de Dagor - Nº 2', 'trombeta-de-dagor-no-2', $MDS$> 📰 Blog *Mar de Sangue* · 2013-08-02 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/08/trombeta-de-dagor-n-2.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Avanço de Morcul preocupa todo continente

<div style="text-align: justify;">

A guerra prossegue nas bordas orientais do continente. Dranor juntamente com Dranar e Elódia tem tentando manter as fronteiras a todo custo, mas Morcul, em acontecimentos recentes, conseguiu expandir sua fronteira para além do Rio Divisa. O Grande Forte Norte foi tomado de assalto e conquistado pelas hordas negras vindas do leste. As forças Dranorianas se reagrupam no forte sul para tentar uma retomada de território.

</div>

<div style="text-align: justify;">

Enquanto isso a **Liga da Grande Floresta** toma providências para proteger as bordas de possíveis ataques. Fazendo alianças com um grupo de habitantes da floresta (entes, sátiros e fadas) eles conseguem manter uma constante vigilância pela extensão de sua  fronteiras leste.

</div>

<div style="text-align: justify;">

Dranar tem mantido as defesas das regiões Sul, mas depois do avanço de Morcul e da conquista por parte do Grande Forte Norte está reunindo esforços para mandar um reforço aos dranorianos no norte. As tropas estão se reunindo e logo irão partir em direção do Grande Forte Sul. 

</div>

  
  
  

### Cerco de Amon Tyr prejudica à Guerra

<div style="text-align: justify;">

Forças de Morcul, com seu avanço de fronteira, conseguiram chegar a Amon Tyr. A cidade -que mais parece uma fortaleza- que pertence ao autointitulado Império de Aton estava sendo utilizado como posto avançado da cidade de Dranor, pois a proximidade com os conflitos e o pacto comercial firmado entre os líderes de Dranor e Eric Aton a tornaram a fortificação ideal para tal função. Amon Tyr está agora em estado de cerco. Se prevê que ela conseguirá se manter assim por enquanto, mas se reforços não forem enviados brevemente a força, Eric certamente perderá a cidade. Procurado pela Trombeta, Eric Aton não respondeu às nossas perguntas, afirmando somente que estava tomando as devidas providências.

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjEkf3xFG0_0911-LG0Ps7pU0CfETpmPTvQiQHlT8YIGxCb9f0rTpqnCEeDt0Gd_HcNQMiOLn-sP4N7nSNS4VF9VD6uIhd9AJgARSRtRHFnA_UOj7Pbi5eQzb2ELhPKgZUxWopNo0DL80TH/s320/Jonas+Jakobsson+-+Siege.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjEkf3xFG0_0911-LG0Ps7pU0CfETpmPTvQiQHlT8YIGxCb9f0rTpqnCEeDt0Gd_HcNQMiOLn-sP4N7nSNS4VF9VD6uIhd9AJgARSRtRHFnA_UOj7Pbi5eQzb2ELhPKgZUxWopNo0DL80TH/s1600/Jonas+Jakobsson+-+Siege.jpg)

</div>

  
  
  

</div>

### E começa o Grande Torneio Harador

<div style="text-align: justify;">

Harad teve nesses ultimos dias a abertura do Grande Torneio Harador, um evento anual que se baseia  em combate livre de equipes. O fluxo de viajantes indo para a cidade é colossal. Esse campeonato é famoso por reunir um largo número de equipes e pela riquíssima bolsa de apostas que correm por lá.

</div>

> 
> 
> <div style="text-align: justify;">
> 
> "Apostei uma quantia obscena numa determinada equipe. Torço para que ganhem realmente. É uma equipe tradicional, com certeza sairá campeã."
> 
> </div>

 Diz o comerciante humano Norize. O torneio já teve sua cerimonia de abertura e em breve os  combates vão ter  início. Nos próximos dias veremos quem será o  glorioso campeão.  
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjoniq2e7yIAxPziwTQBoPnRzkpHdlCm_9ct5aYw7QerV1bfSWMOyWYwEK876JBWusWqvV5Cle7W51deHi5HZ9rfPe9RXYFt5xeqSIMN2UDs7sKIFD57Pk8qXeEAWin18aFCGjCqv75-DAm/s400/640x314_7219_Gladiators_2d_characters_arena_fight_fantasy_picture_image_digital_art.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjoniq2e7yIAxPziwTQBoPnRzkpHdlCm_9ct5aYw7QerV1bfSWMOyWYwEK876JBWusWqvV5Cle7W51deHi5HZ9rfPe9RXYFt5xeqSIMN2UDs7sKIFD57Pk8qXeEAWin18aFCGjCqv75-DAm/s1600/640x314_7219_Gladiators_2d_characters_arena_fight_fantasy_picture_image_digital_art.jpg)

</div>

  
  
  
  

### Luzes estranhas avistadas no Norte

<div style="text-align: justify;">

Nesses ultimo dias notícias estranhas de avistamentos de luzes estranhas tem assombrado o norte do continente. Os astrônomos que trabalham pra Dranor não conseguem encontrar a motivação desses avistamentos, mas eles não param a mais de duas semanas seguidas. Os magos procuram em seus domos explicação, mas até achar a população do norte tem como presente essas estranhas luzes.

</div>

  

<div class="separator" style="clear: both; text-align: center;">

[  
](http://fairefinery.tripleflamingo.com/wp-content/uploads/Dragon-Tankard-4.jpg)

</div>

  

<div style="text-align: justify;">

  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Trombeta de Dagor - Nº 2');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'Trombeta de Dagor - Nº 3', 'trombeta-de-dagor-no-3', $MDS$> 📰 Blog *Mar de Sangue* · 2013-08-09 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/08/trombeta-de-dagor-n-3.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Hostilidades cessam entre Panroar e Espada de Cobre

<div style="text-align: justify;">

 O conflito que estava trazendo preocupação na região a sudeste de Elódia cessa. O conflito abordado na Edição Nº 1. da Trombeta a  abordava. Resumidamente a cidade Élfica Panroar culpava o clã anão Espada de Cobre por ataques a caravanas de comerciantes e os anões culpavam os elfos por postos avançados que foram atacados.  

> "Afinal de contas, nenhum de nós estava certo. Tudo recai sobre a Horda."

Declarou Cis, a rainha elfa da cidade de Panroar juntamente a Prud, o chefe do clã Espada. Ambos foram atacados numa Estalagem onde tentavam encontrar termos de paz. O ataque foi liderado por um dos três **Martelos** da Horda, Amok. Sim, toda essa confusão estava sendo arquitetada pela Horda do Caos. O motivo segue desconhecido, mas as forças de ambos lados afetados se esforçam para solucionar a dúvida. 

</div>

<div style="text-align: justify;">

</div>

  
  
  

### O Torneio de Harador segue belamente

<div style="text-align: justify;">

O famosíssimo Tornio de Harador segue para suas semifinais. Nossos enviados especiais comentam a ascendência do até então desconhecido grupo de combate Os Cangaceiros. Eles tomaram muito destaque de um combate feito a glória e sangue contra Drakimir, o draconato que competia sozinho desde que traiu e matou a própria equipe, e uma vitória fácil nas quartas de final contra o consagrado grupo dos Rufiões de Elódia. Eles seguem agora para as semifinais enquanto suas bolsas de apostas só crescem.  
  

<div class="separator" style="clear: both; text-align: center;">

</div>

<div class="separator" style="clear: both; text-align: center;">

</div>

<div class="separator" style="clear: both; text-align: center;">

<http://www.ideiasvip.com/wp-content/uploads/2011/11/chapeu-cangaceiro.jpg>

</div>

  

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

### Monopolista taverneiro ganha rival

<div style="text-align: justify;">

Ultimamente temos visto o crescimento de uma nova rede de tavernas que promete desmanchar o quase monopólio da rede Vomito de Dragão. Vodkar é o nome dessa nova rede. Com o atendimento dinâmico e o recente patrocínio dado pela marca para o Torneio de Harador eles tem conquistado muito destaque.  

> "Gosto muito da cerveja da Vomito, mas o sabor mais forte das de Vodkar tem me feito pensar bem."

Fala Norben, eladrin frequentador usual de tavernas. O cliente agora que sai no lucro, pois terá a competição de duas gigantes. Tanto em preço como em variedades e sabores. Veremos agora quem vencerá essa disputa de influência e clientes.  
  

</div>

<div class="separator" style="clear: both; text-align: center;">

<http://pt.wall-online.net/wp-content/uploads/2013/06/Beer-Barrel-Circles-Foam.jpg>

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Trombeta de Dagor - Nº 3');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'Trombeta de Dagor - Nº 4', 'trombeta-de-dagor-no-4', $MDS$> 📰 Blog *Mar de Sangue* · 2013-08-15 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/08/trombeta-de-dagor-n-4.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Navios somem misteriosamente na costa sul

<div style="text-align: justify;">

 Nessa última semana recebemos notícias de Toben Arroway, dono Companhia de Comércio Ventos do Mar. Ele nos informou com exclusividade que seis galeões e mais de doze fragatas sumiram de seus domínios. A Companhia que atua principalmente no Sul do continente não consegue achar uma explicação lógica.  

> > "Se esses barcos não retornarem muitas rotas de comércio terão de ser cortadas. Espero que eles decidam voltar pra cá."

Diz Toben, o dono meio-elfo com algum bom humor. O desaparecimento vai, como o dito por ele, infligir um prejuízo real ao Sul de Dagorcain. Além de diminuir a chegada de produtos de Primus, viagens e matérias-primas mais raras terão seus preços elevados astronomicamente.    
  
  
  

</div>

### Reunião do Reino Anão Leste sofre crise interna

<div style="text-align: justify;">

<span class="null">A reunião dos remanescentes do histórico Reino Anão Leste que todo o continente tem ouvido falar nos últimos tempos teve recentemente uma crise interna. Um líder - ainda de nome desconhecido - que despontava entre eles tentou recuperar as mansões de seu povo para dessa forma o reerguer o Reino mas encontrou obstáculo nos chefes de famílias e clãs que dizem que ele não é forte o suficiente para ser o novo rei. Boatos correm ainda pela região que esse mesmo "novo rei" foi sequestrado dias após a reunião, o que deixou os chefes aliados a ele bem aflitos. </span>  

> > <span class="null">"Sem a Herança de Thúrin não haverá reunião de nosso povo e muito menos o Reino Anão Leste ressurgirá\!"</span>
> 
> <span class="null"></span>

<span class="null">  
Diz, em tom misterioso, o anão Markas Escudocurto por meio de uma carta enviada para nós depois dessas ultimas notícias. Toda essa conjuntura de fatores estão basicamente sendo ignoradas por Elódia, que atualmente está concentrando todos seus esforços no conflito ao extremo leste contra Morcul.</span>  
  

<div class="separator" style="clear: both; text-align: center;">

<http://www.frankfort.usd380.com/news/january/Keith%20Huddleston%20Main%20Project/dwarf.jpg>

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>

  

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

### Queda Escarpada pede por ajuda

<div style="text-align: justify;">

<div class="clearfix">

<div class="clearfix _42ef">

<div>

<div class="_37">

<div id="mid.1376511097868:85226f332699f3cd12" class="_53">

  

<div class="_3hi clearfix">

<span class="null"></span>  

<div class="MsoNormal" style="text-align: justify;">

<span style="font-family: inherit;"><span style="font-size: 12pt; line-height: 115%;">Assim como todo o Continente a mais importante cidade da ilha de Jordânia, Queda Escarpada, tem passado por uma situação crítica. Ataques vem avassalando as fazendas  que sustentam a cidade com recursos.</span></span>

</div>

<span style="font-family: inherit;"> </span>  

> > 
> > 
> > <div class="MsoNormal" style="text-align: justify;">
> > 
> > <span style="font-family: inherit;"><span style="mso-bidi-font-style: normal;"><span style="font-size: 12pt; line-height: 115%;">“Não sabemos com certeza quem são os autores ou quais são seus objetivos, mas sabemos que eles não irão parar até que consigam o que querem.”</span></span></span>
> > 
> > </div>

<span style="font-family: inherit;"> </span>  

<div class="MsoNormal" style="text-align: justify;">

<span style="font-family: inherit;"><span style="font-size: 12pt; line-height: 115%;">Foi o que disse Sandor Battle-Born, Capitão da guarda de *Queda Escarpada* sobre os recentes e contínuos ataques que a cidade vem sofrendo. <span style="mso-spacerun: yes;"></span>Capitão Battle-Born e Walkas Baforte*, p*refeito da cidade oferecem uma <span style="mso-bidi-font-style: normal;">recompensa </span>aos <span style="mso-bidi-font-style: normal;">aventureiros</span> que descobrirem e acabarem com os inimigos, assim,  resolvendo o problema com os recursos.</span></span>

</div>

<span style="font-family: inherit;"></span>

</div>

</div>

</div>

</div>

</div>

</div>

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Trombeta de Dagor - Nº 4');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'Trombeta de Dagor - Nº 5', 'trombeta-de-dagor-no-5', $MDS$> 📰 Blog *Mar de Sangue* · 2013-08-23 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/08/trombeta-de-dagor-n-5.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Amon Tyr se livra de cerco

<div style="text-align: justify;">

Neste ultimo mês vimos a situação dramática da cidade fortalecida de Amon Tyr. É uma cidade pertencente ao Reino de Aton e estava sendo sitiada por forças de Morcul que conseguiram avançar suas fronteiras com vitórias recentes no Grandes Fortes da região. Porém com a chegada de um reforços vindos de Aton e das cidades de Dranor expurgaram as hordas de orcs que dominavam os portões da região.  

> > "Consegui reagrupar minhas forças e dar ordens para atacar. Pus a liderança nas mãos do diretor da Mão de Erathis e ele se provou sábio."

Diz Eric, o Imperador de Aton. Este que não pode participar da retomada de sua própria cidade pois estava indo combater nas proximidades da Floresta Drow - veja nessa mesma edição - e mandou essa declaração via carta à Trombeta. Agora com Amon Tyr novamente sobre o domínio Dranoriano a guerra poderá retornar a pender para o lado do continente.  
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEguO1EJk57r9lJ1gyW0NKApMDk_u-tVYuNqjfuCKeDaoT9C2w9K-uWtN8BVEFRPB3fULhSo4pojpv8l1DAIHWTDSQx3j7Dt_pMjdoaTSvIcCNNMDffNKMflr7BOQ0dXLAQ-d6Lm1sDl1QMX/s320/TAGHF05.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEguO1EJk57r9lJ1gyW0NKApMDk_u-tVYuNqjfuCKeDaoT9C2w9K-uWtN8BVEFRPB3fULhSo4pojpv8l1DAIHWTDSQx3j7Dt_pMjdoaTSvIcCNNMDffNKMflr7BOQ0dXLAQ-d6Lm1sDl1QMX/s1600/TAGHF05.jpg)

</div>

  
  
  
  

</div>

### Floresta Drow é palco de conflitos preocupantes

<div style="text-align: justify;">

<span class="null">Vimos nestes últimos dias combates nas redondezas da Floresta Drow tem posto Dagorcain em preocupação. A luta entre o que parecem ser quatro facções vêm trazendo desespero à região. As duas primeiras são lobisomens da raça worgen - dentro de sua raça, os mais inteligentes e racionais - e uma tropa de elite de Morcul. A terceira se insinua que poderia ser a lendária Mãos de Prata, mas até agora nada foi confirmado. Mas o que traz dor de cabeça é a quarta que perpetua um mistério no já apelidado Conflito das Facções. Ela vem sendo, ao que parece, vitoriosa sobre todas as outras facções.   </span>  

<div class="separator" style="clear: both; text-align: center;">

  

</div>

  

</div>

<div style="text-align: justify;">

  

</div>

### Reforços vindos de Dranar chegam à floresta

<div style="text-align: justify;">

<div class="clearfix">

<div class="clearfix _42ef">

<div>

<div class="_37">

<div id="mid.1376511097868:85226f332699f3cd12" class="_53">

  

<div class="_3hi clearfix">

  

<div class="MsoNormal" style="text-align: justify;">

<span style="font-family: inherit;"><span style="font-size: 12pt; line-height: 115%;">As ultimas notícias recebidas das Grandes Floresta é que os reforços oriundos de Dranar finalmente chegaram lá. A Aliança tem tido dificuldades em manter as bordas da floresta livres de incursões de Morcul vindas da proximidade do Rio Divisa. Os entes que habitavam lá e ajudavam no combate as hordas de orcs tem traído a confiança. Algo ainda não explicado vem afetando estas árvores vivas e levado-as ao lado de Morcul do guerra. Magos de Elódia já investigam o assunto. </span></span>

</div>

<span style="font-family: inherit;"> </span>

</div>

</div>

</div>

</div>

</div>

</div>

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Trombeta de Dagor - Nº 5');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 6', 'a-trombeta-de-dagor-no-6', $MDS$> 📰 Blog *Mar de Sangue* · 2013-08-30 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/08/a-trombeta-de-dagor-n-6.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Ataques da Horda se tornam mais frequente

<div style="text-align: justify;">

Após desvendarem a participação dessa facção na quase guerra que ocorreu entre o Clã Espada Cobre e Panroar muitos outros casos foram descobertos. Desde ataques a caravanas a saques a vilas e aldeias. Eles atuam principalmente no sul do Continente. Procuramos os Filhos de Uther - clã que persegue a Horda do Caos desde sua fundação - mas não encontramos Thor - o atual líder - para dar uma declaração.  
  
  
  

</div>

### Fofocas do Belnan, O Língua Cumprida

<div style="text-align: justify;">

<span class="null">Você ai aventureiro que se interessa pela vida da *high society* de Dagorcain agora terá uma coluna para você. Começaremos com o mais recente acontecimento, o Leon, Duque de Arcrenia se separou de sua esposa. Sim, o famoso eladrin conhecido por sua beleza e charme está solteiro. Você ai mulher que busca um marido ou quiçá um amante ele está disponível.  </span>  

<div class="separator" style="clear: both; text-align: center;">

  

</div>

  

</div>

<div style="text-align: justify;">

  

</div>

### Grupo de aventureiros busca inocência

<div style="text-align: justify;">

<div class="clearfix">

<div class="clearfix _42ef">

<div>

<div class="_37">

<div id="mid.1376511097868:85226f332699f3cd12" class="_53">

<div class="_3hi clearfix">

  

<div class="MsoNormal" style="text-align: justify;">

<span style="font-family: inherit;"><span style="font-size: 12pt; line-height: 115%;">"Campeões" do Campeonato de Harador, salvadores do apelidado Herdeiro de Turin, um grupo de aventureiro é perseguido por terem assassinado um general da aliança contra Morcul. Emissários de seus aliados pelo continente dizem que não se  tratava do verdadeiro general, mas sim de um doppelganger infiltrado nas forças. A Aliança se nega a confirmar, mas continua afirmando categoricamente que quem der informações sobre o grupo será beneficiado.</span></span>  

</div>

<span style="font-family: inherit;"> </span>

</div>

</div>

</div>

</div>

</div>

</div>

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 6');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 7', 'a-trombeta-de-dagor-no-7', $MDS$> 📰 Blog *Mar de Sangue* · 2013-09-06 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/09/a-trombeta-de-dagor-n-7.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Informações reveladas sobre conflitos na Floresta Drow

<div style="text-align: justify;">

Depois da confirmação que uma das facções eram de fato os Mãos de Prata a atuação destes em Dagorcain vem diminuindo. Será uma coincidência ou este clã está se reagrupando para enfrentar um grande rival? Apesar disto, Elódia permanece a não se pronunciar. A raça lobisomen Wargen, que também foi vista nos conflitos e continua sendo um mistério. Aliados ou inimigos?  
  
  
  

</div>

### Noticias da guerra

<div style="text-align: justify;">

<span class="null">O Grande Forte Sul permanece no domínio de Morcul enquanto na floresta a Aliança tem tidos muito problemas. A "peste" que vem atacando os entes permanece sem solução, dessa forma essas poderosíssimas forças continuam a atacar qualquer um que se aproxime. Muitos dos  Anões que tomavam viajem por dentro da floresta em direção do já apelidado Novo Reino Anão Leste tiveram de buscar outra rota para seu destino.</span>  
  

<div class="separator" style="clear: both; text-align: center;">

<http://lovely-pics.com/data/media/10/battle_dragon_attack_rpg.jpg>

</div>

<span class="null">   </span>  

<div class="separator" style="clear: both; text-align: center;">

  

</div>

  

</div>

<div style="text-align: justify;">

  

</div>

### Avanço de Morcul é barrado

  

<div class="MsoNormal" style="text-align: justify;">

<span style="font-family: inherit;"><span style="font-size: 12pt; line-height: 115%;">Após semanas de conflitos sangrentos a Aliança conseguiu se estabilizar ao sul do continente, dando inicio a obras de fortificações. As baixas estão sendo repostas por recrutamentos em massa enquanto as legiões de orcs de Morcul são expurgadas pelos veteranos. Ao norte Dranor pressiona e como ultima vitória conhecida fez a linha negra recuar para trás do Rio Divisa. Isso dará espaço para reagrupar a força dos Homens do Norte e quiçá contra-atacar em massa. </span></span>

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 7');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 8', 'a-trombeta-de-dagor-no-8', $MDS$> 📰 Blog *Mar de Sangue* · 2013-09-13 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/09/a-trombeta-de-dagor-n-8.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Dranor e Elódia criam força tarefa

#### 

<div style="text-align: justify;">

Ataques da Horda, assaltos nas estradas, revoltas de clãs e até entes insanos. Tudo isso tem sido tema de notícias aqui na Trombeta a algum tempo e finalmente vemos Dranor juntamente a Elódia se unirem em força para combater esse mau menor que aflige os inocentes do meio-norte do oeste do continente. Essa força tarefa foi chamada pelo nome de Escudo de Dagor. Ela reunirá uma força de assalto Dranoriana e algumas equipes de Elódia. Eles ainda pretendem criar divisões para voluntários. Então você ai aventureiro que pretende engajar em alguma organização, talvez essa seja sua chance de ouro\!  
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjJIGsTrYANY30LK7oPCyv8AESYP4Xeks2Wtt3g1v819dvnYheGIExwjsdjLw-nkZSkYSBDp-CmHzjpwTIus0g1HqKf5YEhSjMt3V2XJQF56ORl1mjqyfZd0n2iWmdWnuv9FKy7_xeBXKLD/s400/152676.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjJIGsTrYANY30LK7oPCyv8AESYP4Xeks2Wtt3g1v819dvnYheGIExwjsdjLw-nkZSkYSBDp-CmHzjpwTIus0g1HqKf5YEhSjMt3V2XJQF56ORl1mjqyfZd0n2iWmdWnuv9FKy7_xeBXKLD/s1600/152676.jpg)

</div>

  
  

</div>

### Noticias da guerra - Nº 2

<div style="text-align: justify;">

<span class="null">Os reforços de Dranar tem conseguido manter as fronteiras da floresta, mas os Entes não são mais ajuda confiável para os feéricos. Não se sabe o que acontece nas florestas, mas alguns soldados revelaram que eles não estão mais defendendo as fronteiras, mas atacando qualquer coisa que se aproxime deles, como feras selvagens e crueis. Algo muito ruim aconteceu a raça. Dranor continua Lutando pelo Forte Sul, Morcul tem tentado manter a posição a todo custo.</span>  
  
  

</div>

<div style="text-align: justify;">

  

</div>

### Leilão de Itens em Harad

<div style="text-align: justify;">

Após o curioso fim do campeonato chega o período de leilão. Serão vendidos na cidade itens utilizados durante o campeonato. Muitos colecionadores se interessam por tais produtos e a cidade deve voltar a ficar movimentadíssima. Com o título de maior cidade de Dagorcain, Harad se mantém no topo idealizando este tipo de evento, onde consegue atrair muito movimento e é claro, dinheiro.

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 8');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 9', 'a-trombeta-de-dagor-no-9', $MDS$> 📰 Blog *Mar de Sangue* · 2013-09-20 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/09/a-trombeta-de-dagor-n.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Acontecidos de teor divino preocupam alguns

#### 

<div style="text-align: justify;">

Novos focos de adoração ao novo deus chamado de Santo Ancestral, tem surgido por todo o continente. Acreditasse que esse deus tem ligação a religião Dranoriana que reverencia seus ancestrais. Apesar disso tudo um dos conselheiros de Dranor disse veemente que esse deus não é aceito e nem adorado no reino, que "apenas os ancestrais são os alvos dos joelhos sacerdotais dranorianos, e só eles nos garantem força e defesa\!". Sabe-se que um grande Templo, chamado de Monastério dos Pastores Ancestrais, passaram a treinar Paladinos, Vingadores e Clérigos envolvidos com esse novo deus, que vem disseminando ainda mais os cultos. Será isso uma presce desesperada a um deus inexistente devido ao horror da guerra? Ou terrível deus antigo buscando ascender no panteão de Dagorcain?  

<div class="separator" style="clear: both; text-align: center;">

</div>

  
  

</div>

###   Ataque ocorrido em fortaleza anã

<div style="text-align: justify;">

<span class="null">Uma fortaleza anã não muito longe de Elódia foi atacada por uma força desconhecida. Elódia não divulgou quem foi atacado e nem quem atacou, mas isso parece preocupar muito a Escola de Mágia de Dagorcain. Sabe-se que houve uma larga chacina e um grupo conseguiu escapar desse destino, mas além disso as informações são bem escassas. </span>  
  
  

</div>

### Festival pretende eleger as melhores flechas de Dagorcain

<div style="text-align: justify;">

Nessa semana vem ocorrendo no continente uma competição de arco e flecha que busca definir qual a melhor flecha de nosso continente. Esta disputa está acontecendo na cidade de Askimov, pertencente ao Reino de Atom, e vem reunindo os melhores arqueiros e artifices de flechas de toda região da Grande Floresta e proximidades. Ela busca eleger a flecha que se tornará a flecha oficial das tropas de Atom, flechas essas que irão auxiliar no combate das forças de Morcul que invadem o  continente.  
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj_9EhRUcXXaf-vik3jLi1tp7SAKGD-xcFLjrEK9q85MYigPqZ_55nnMXK3WGFHPedIbPEcqaGaYvrYhrvPjZzrmCet9bwe4REnzMSRqX0GHlp7tutqLryjLkKpISF2CvwHyPTsmmrN0vII/s320/20130201-100-bow+designs1.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEj_9EhRUcXXaf-vik3jLi1tp7SAKGD-xcFLjrEK9q85MYigPqZ_55nnMXK3WGFHPedIbPEcqaGaYvrYhrvPjZzrmCet9bwe4REnzMSRqX0GHlp7tutqLryjLkKpISF2CvwHyPTsmmrN0vII/s1600/20130201-100-bow+designs1.png)

</div>

  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 9');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 10', 'a-trombeta-de-dagor-no-10', $MDS$> 📰 Blog *Mar de Sangue* · 2013-09-27 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/09/a-trombeta-de-dagor-n-10.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Cidade de Dranar sofre com violência

#### 

<div style="text-align: justify;">

Todo esse conflito com Morcul tirou a estabilidade social de Dranar. A cidade, com sua massa de habitantes gigante, vem sofrendo com a violência e a criminalidade. Com a guarda da cidade desfalcada graças a guerra a cidade não tem  conseguido manter os criminosos em rédea curta, como era o costume. Lojistas estão tendo grandes prejuízos com furtos e assaltos que assolam a zona comercial da cidade.  
  

<div class="separator" style="clear: both; text-align: center;">

<http://fc04.deviantart.net/fs70/i/2010/071/3/0/beginning_the_Don_Salvara_game_by_TolmanCotton.jpg>

</div>

  
  

</div>

###   Ataque a fortaleza anã permanece um mistério

<div style="text-align: justify;">

<span class="null">Foi divulgado por Elódia que havia sim ordens para o mais novo grupo Escudo de Dagor averiguar o Forte Urso Negro. Porém, o grupo destacado para tal missão não foi encontrado após o acontecido, sumindo dos radares da Escola de Mágia. O fato é que eles deveriam retornar a Elódia para formar um relatório da missão, mas isso nunca chegou a acontecer. Uma chacina foi promovida no forte e agora resta a pergunta, o Escudo representa uma proteção ao povo de Dagorcain ou mais um lobo vestindo pele de cordeiro?</span>  
  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 10');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 11', 'a-trombeta-de-dagor-no-11', $MDS$> 📰 Blog *Mar de Sangue* · 2013-10-04 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/10/a-trombeta-de-dagor-n-11.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### E o Escudo de Dagor "ataca" novamente

#### 

<div style="text-align: justify;">

O grupo recém criado por Dranor juntamente a Elódia causa mais polêmicas nesta semana. Além de perseguir grupos revoltosos pelo continente agora atuam também prendendo qualquer aliado - é o que dizem ao menos - de Morcul que transite em sua área de influência. Em Grendall um necromante foi aprisionado e levado para Azerote - prisão famosa por ser uma das mais seguras de Dagorcain -  nas Montanhas de Ferro do Norte. Para lá também foi levado o Comandante Bestial Yunero, acusado de traição a Aliança.   
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgXugooQjcLsV_aPrT2tBk_16tHwDzr-gbZ1SChf51a9GDFoH1HyrBBlA9da0Vo3dhC4d_SzK9bjNY73gCbZWY2H5gXQpOz1Dg1HuNTn07KmaXBSjBxezIwcdrgkkjEgt_DBhyphenhyphenXqNeVjbws/s320/Army+of+Scorpions+2.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgXugooQjcLsV_aPrT2tBk_16tHwDzr-gbZ1SChf51a9GDFoH1HyrBBlA9da0Vo3dhC4d_SzK9bjNY73gCbZWY2H5gXQpOz1Dg1HuNTn07KmaXBSjBxezIwcdrgkkjEgt_DBhyphenhyphenXqNeVjbws/s400/Army+of+Scorpions+2.jpg)

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>

<div class="separator" style="clear: both; text-align: justify;">

Ainda há outros muitos suspeitos sob a mira do Escudo de Dagor. Muitas prisões tem sido ocupadas por vítimas do Escudo, mas o presídio que Elódia mantém - Runindal - vem mantendo em cárcere somente magos de Morcul capturados em batalhas no Leste. Mas ai fica a pergunta, será que o Escudo está fornecendo segurança ao povo de Dagorcain ou simplesmente cumprindo interesse dos poderosos?

</div>

<div class="separator" style="clear: both; text-align: justify;">

 

</div>

  

</div>

###   Facção recém atuante no continente é identificada

<div style="text-align: justify;">

<span class="null">Alvo de muitas especulações uma facção vem ascendendo de poder dentro de Dagorcain. Vistos por todas as partes, participaram dos conflitos na Floresta Drow. Mas até está edição d'A Trombeta nada se sabia além de boatos. Exar Khun é a resposta para nossas dúvidas. Muitos acreditavam que esse indivíduo não passava de uma figura mitológica da Guerra dos Cem Anos. Porém ele agora está de volta e não parece feliz com o clã - pelo o que dizem as lendas - que ele mesmo fundou, os Mãos de Prata. Perguntados sobre o acontecido, o Supremo Mago do Conselho de Inteligência de Elódia, Arkan respondeu:</span>

</div>

<div style="text-align: justify;">

  

</div>

> 
> 
> <div style="text-align: justify;">
> 
> <span class="null">"Em guerras a muito esquecidas aconteceram fatos curiosos. Um desses fatos vem agora nos atormentar. Essa nova força no continente não representa uma ameaça somente para Liga das Raças Livres (LRL), mas também para Morcul. Porém, nós (a Liga), continuaremos para combater qualquer força que vá contra nosso povo. Seja ela vinda do Leste ou de um longínquo passado."   </span>
> 
> </div>

  

<div class="separator" style="clear: both; text-align: center;">

<http://www.striemer.org/scales-of-war/images/kyrion.jpg>

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 11');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 12', 'a-trombeta-de-dagor-no-12', $MDS$> 📰 Blog *Mar de Sangue* · 2013-10-11 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/10/a-trombeta-de-dagor-n-12.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Pavio-Curto realiza torneio

#### 

<div style="text-align: justify;">

E mais uma vez Pavio-Curto realizará um torneio para decidir que é o melhor duelista desse trimestre. Sim, a cidade está de volta com essa nova proposta de realização. Após uma longa abstinência de grandes disputas por lá, devido a guerra contra Morcul, a cidade se vê novamente pronta para sediar um evento de grande porte. Esse se baseará no confronto entre somente duas pessoas. Qualquer arma, qualquer magia, tudo livre. Mas mortes serão descontadas das bolsa do vencedor. Vá participar você também\!  
  

<div class="separator" style="clear: both; text-align: center;">

<http://fc00.deviantart.net/fs33/f/2008/300/1/5/The_Duel_by_dcwj.jpg>

</div>

  

<div class="separator" style="clear: both; text-align: justify;">

 

</div>

  

</div>

###   Escudo prende criminosos famosos

<div style="text-align: justify;">

O trabalho do Escudo de Dagor tem dado bons frutos finalmente. Além de estarem massacrando orcs que escapuliram pela fronteira de guerra com Morcul e penetravam nos domínios da Liga das Raças Livres. Além disso conseguiram efetuar a prisão de um grupo de assassinos que era perseguido a muito tempo. Grupo esse que foi campeão no torneio de Harad sobre a alcunha de Cangaceiros. O grupo é composto por cinco salteadores. Natã, um deva aprendiz de Elódia; Stulk, um golias de pouca inteligência e muita força; Hans, um belíssimo humano bardo; um paladino eladrin da Blind Guardian, Althir e finalmente o anão Thor Adin. <span style="mso-spacerun: yes;"> </span>Esse grupo foi responsável pelo o assassinato de um dos principais generais - Túlios, de Muralha Arbóreas -  da União dos Povos Florestais. (UPF)

</div>

<div style="text-align: justify;">

<span class="null">   </span>  

<div class="separator" style="clear: both; text-align: center;">

<http://farm2.staticflickr.com/1021/628472844_a972b12aec_z.jpg>

</div>

</div>

  

<div class="separator" style="clear: both; text-align: center;">

  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 12');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 13', 'a-trombeta-de-dagor-no-13', $MDS$> 📰 Blog *Mar de Sangue* · 2013-10-18 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/10/a-trombeta-de-dagor-n-13.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Prisão de Azerote sitiada

#### 

<div style="text-align: justify;">

Após uma investida direta, a prisão de Azerote caiu em domínio de Morcul. Com uma invasão sem muita explicações, a cadeia foi alvo de uma marcha negra e em poucas horas foi totalmente conquistada. Os  guardas não foram o suficiente para proteger o cárcere dos magos, guerreiros e  soldados de Morcul. Esses agora voltaram a atuar. Não se há noticias de planos  de retomada/recaptura dos criminosos de lá.

</div>

<div style="text-align: justify;">

</div>

<div style="text-align: justify;">

</div>

<div style="text-align: justify;">

</div>

<div class="separator" style="clear: both; text-align: center;">

<http://images.wikia.com/grandlore/images/d/d8/War-castles-dragons-fantasy-art-battles-artwork-siege-arrows-ogre-swords-demon-catapult-HD-Wallpapers.jpg>

</div>

<div style="text-align: justify;">

  

</div>

###   Confronto secundário ascende no continente

<div style="text-align: justify;">

Ultimamente todos os olhos estão voltados para a guerra contra Morcul, mas um conflito entre forças do clã Mãos de Prata e os Wargens (lobisomens racionais). O problema real disso é que a inteligência de Elódia confirmou recentemente que a liderança do clã está nas mãos do famoso Exar Khun, que vem assombrando os sonhos de muita gente por toda Dagorcain. Batalhas tem destruído cidades e devastando campos, em locais aleatórios, até agora. 

</div>

<div style="text-align: justify;">

<span class="null">  </span>

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 13');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 14', 'a-trombeta-de-dagor-no-14', $MDS$> 📰 Blog *Mar de Sangue* · 2013-10-25 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/10/a-trombeta-de-dagor-n-14.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Grande Forte Sul retomado

#### 

<div style="text-align: justify;">

Um grande conflito aconteceu para finalmente as forças de Dranor retomarem o Grande Forte sul. Após a posse deste estar nas mãos de Morcul durante o período de quase três meses, uma investida de Dranor rompeu as defesas da fortaleza.  

> "Nós nos reagrupamos para nos estabilizar e fizemos esta investida. Foi uma batalha sangrenta, mas conseguimos invadir e massacrar os nossos sujos inimigos."

Diz Seadak Atom XVI, general responsável pela retomada do forte.  
  

</div>

<div class="separator" style="clear: both; text-align: center;">

</div>

<div style="text-align: justify;">

<div class="separator" style="clear: both; text-align: center;">

<http://static.giantbomb.com/uploads/original/1/17172/1374597-siege_by_martin_mckenna.jpg>

</div>

  

</div>

###   Fugitivos de Azerote semeiam caos

<div style="text-align: justify;">

Foi noticiado a queda da grande prisão no norte de Azerote, após um ataque surpresa de Morcul nas defesas atenuadas do local. Oficiais de alta patente foram resgatados e reintegrados nas forças de Morcul, mas soldados de baixa patente começam a criar caos em toda volta da região. O Escudo de Dagor e Elódia foram procurados para dar uma esperança, mas nossas cartas não foram respondidas por ambas forças.   
  

###   Anões migrantes são protegido pelo "Novo Rei"

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjU7MhLvpvqs5kRk8sFCDtc1tWhSeT3rEbvh6FP_cpFc2Polr1SF9xc18EvAlOFskIcT9K1cj_vTw0hWxTkLDiHHqCz7d1n90HfrBK8h6nbRMecZX1_hiowhhqxIWPzpzed0mm5Xx2zB4VU/s320/dwarf_by_armandeo64-d4sfgvm%5B1%5D.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjU7MhLvpvqs5kRk8sFCDtc1tWhSeT3rEbvh6FP_cpFc2Polr1SF9xc18EvAlOFskIcT9K1cj_vTw0hWxTkLDiHHqCz7d1n90HfrBK8h6nbRMecZX1_hiowhhqxIWPzpzed0mm5Xx2zB4VU/s1600/dwarf_by_armandeo64-d4sfgvm%5B1%5D.jpg)

</div>

  
Anões de todas regiões retomaram as ondas migratórios que recentemente tinha tido início e fim. O auto intitulado Grande Rei do Leste, Dúrin, está se estabelecendo novamente na antiga região do Reino Anão Leste. Ele promove forças expedicionárias para proteger as caravanas de anões que estão indo se unir a ele. Força militar bem preparada que protege os viajantes de ataques goblins que ultimamente tem infestado a região por onde eles passam.    

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 14');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 15', 'a-trombeta-de-dagor-no-15', $MDS$> 📰 Blog *Mar de Sangue* · 2013-11-01 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/11/a-trombeta-de-dagor-n-15.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Perseguição a Halflings preocupa Dranar

#### 

<div style="text-align: justify;">

Nos últimos dias viemos recebendo diversos relatos de verdadeiras diasporas de povoados halflings por todo continente. No cenário atual, todas as energias dos governos estão focadas na guerra contra Morcul. Dessa forma a violência urbana tem chegado a picos absurdos. Sempre associados ao crime de furto, assalto, roubo e etc, halflings acabam por serem alvo de grandes perseguições. Comerciantes desconfiados da culpa destes pequeninos contratam mercenários para a perseguição desses. O Conclave de Dranar não se declarou sobre o assunto.  
  

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhevXQNMQnZtAT8bzMcZ9DX6D8NBNk83eO28ktfYlAYFPw4uO5k5UsgiFjD0XvI2lEesfKNt3psbWj6eK6oiGhFYV5X-Qb6OfQVfslSrS9IYJODBgpVj0C_PpAVoewOlAeoJhaS3-hQSmtQ/s200/halfling_rogue_dnd_by_storminka-d5b6e45.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhevXQNMQnZtAT8bzMcZ9DX6D8NBNk83eO28ktfYlAYFPw4uO5k5UsgiFjD0XvI2lEesfKNt3psbWj6eK6oiGhFYV5X-Qb6OfQVfslSrS9IYJODBgpVj0C_PpAVoewOlAeoJhaS3-hQSmtQ/s1600/halfling_rogue_dnd_by_storminka-d5b6e45.jpg)

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>

<div style="text-align: justify;">

  

</div>

###   Reunião das guildas mercantis acontecerá dentre uma semana

<div style="text-align: justify;">

A união faz a força e isso é um fato. Uma proposta de reunião foi lançada para todas as grandes guildas comerciantes de Dagorcain para que essas mandem representantes a Elódia para tratar de negócios. As propostas pautadas são várias. Entre elas pode-se destacar o padrão de medidas entre si e o intercâmbio de informações estratégicas para o comércio.  
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh3o9g3GSX5p_T8q_WWfgXwaMkGAdwPXKObFwWhfcTlPC-St38fic0MEjcPMXV71NKcBcKjbOHv44KBx6oVgT2j0ofFryCJGYEZrhKZHoJpiJqJGle821uwGtTJvmAr4xBFnavi3VqkmP2D/s320/fantasy_art_scenery_wallpaper_rado_javor_pirate_ship_wallpaper-960x600.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh3o9g3GSX5p_T8q_WWfgXwaMkGAdwPXKObFwWhfcTlPC-St38fic0MEjcPMXV71NKcBcKjbOHv44KBx6oVgT2j0ofFryCJGYEZrhKZHoJpiJqJGle821uwGtTJvmAr4xBFnavi3VqkmP2D/s1600/fantasy_art_scenery_wallpaper_rado_javor_pirate_ship_wallpaper-960x600.jpg)

</div>

 

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 15');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 16', 'a-trombeta-de-dagor-no-16', $MDS$> 📰 Blog *Mar de Sangue* · 2013-11-08 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/11/a-trombeta-de-dagor-n-16.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Caravanas anãs avistam dragões

#### 

<div style="text-align: justify;">

As Caravanas Anãs, agora protegidas por forças enviadas pelo Suposto Novo Rei do Leste, tiveram dias conturbados. Algo que com os anos se tornou raro, mesmo nas Guerras que estamos enfrentando, é a aparição de dragões em Dagorcain. Existem relatos de aventureiros que os enfrentaram, e boatos sobre um Dragão comerciante no Oeste, nada mais. Porém nessa ultima semana os anões foram surpreendidos ao verem não um, mas vários dragões na região Montanhosa próxima do Antigo Reino Anão Leste. 

</div>

> 
> 
> <div style="text-align: justify;">
> 
> "Ficamos aterrorizados, afinal, eu não vejo um dragão de perto a 60 anos, e então, passamos três dias vendo vários deles sobrevoando o céu rumo as montanhas da floresta." 
> 
> </div>

<div style="text-align: justify;">

Disse Arúk, um dos lideres das Caravanas. Elódia tem se mantido fechada quanto a esses acontecimentos surpreendentes e misteriosos.

</div>

<div style="text-align: justify;">

 

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhYY-Bl3xefqHkx2G7WVssVUDvfFyCkrGMNN-yx90OLAYOsnszI_qm9CVDg0YURPfHJGfR2xBxWdhoHVcrpTbdDO4ZB7rXo8UwtGXHW5Bkx_8Bm0T9k3XsU-VIUWQ8uDgO1HjjqfnZJa88T/s320/Fantasy-Dragon-19559-272202.jpeg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhYY-Bl3xefqHkx2G7WVssVUDvfFyCkrGMNN-yx90OLAYOsnszI_qm9CVDg0YURPfHJGfR2xBxWdhoHVcrpTbdDO4ZB7rXo8UwtGXHW5Bkx_8Bm0T9k3XsU-VIUWQ8uDgO1HjjqfnZJa88T/s1600/Fantasy-Dragon-19559-272202.jpeg)

</div>

<div style="text-align: justify;">

 

</div>

<div style="text-align: justify;">

<div class="separator" style="clear: both; text-align: center;">

  

</div>

</div>

###   Império de Aton convoca refugiados

<div style="text-align: justify;">

Devido a situação de guerra, grandes fluxos migratórios tem corrido em todas as direções do continente. Uns saem das fronteiras para fugirem da guerra e outros vão em direção a fronteira para poderem criar negócios beligerantes nas fronteiras. Em vista disso, Eric, Imperador de Aton, convoca qualquer um que queira se mudar para suas cidades a o fazê-lo. Vá você também\!   

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 16');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 17', 'a-trombeta-de-dagor-no-17', $MDS$> 📰 Blog *Mar de Sangue* · 2013-11-15 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/11/a-trombeta-de-dagor-n-17.html

<span id="goog_545958894"></span><span id="goog_545958895"></span>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Mercenários são contratados por halflings

#### 

<div style="text-align: justify;">

Após uma onda de violência em grandes cidades - principalmente em Dranar - a população voltou os olhos contra os halflings. Esses pediram ajuda do governo e não alcançaram. Porém agora eles não estou despreparados. Se unindo em  bairros e guetos fechados, eles começaram a procurar e contratar grupos de mercenários para fazer a segurança de suas regiões. O administradores de Dranar não se pronunciaram ainda, mas enquanto isso só mais mercenários são contratados. 

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjo_Gt7kAPo6pKaeTQqjCjLHJWdH8J9yeu8beJNVGIzKdXEPpWu13Cb4P8xN6ULLA0pzsQRDaUb1JSYzP1pJP5PqzsGupw_6_Ezd3-tRGtzoxZnh5D_CiaiNMIzp34khw6m8IUxy94wW7JM/s320/14476_1066881600.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjo_Gt7kAPo6pKaeTQqjCjLHJWdH8J9yeu8beJNVGIzKdXEPpWu13Cb4P8xN6ULLA0pzsQRDaUb1JSYzP1pJP5PqzsGupw_6_Ezd3-tRGtzoxZnh5D_CiaiNMIzp34khw6m8IUxy94wW7JM/s1600/14476_1066881600.jpg)

</div>

<div style="text-align: justify;">

 

</div>

<div style="text-align: justify;">

 

</div>

###   Caravana caça talento parte de Elódia

<div style="text-align: justify;">

Elódia monta novamente sua caravana bienal para procurar talentos escondidos que possam um dia dobrar a poderosa magia arcana ensinada na escola. A guerra tem tirado a vida de muitos magos, mas o continente não se pode dar ao luxo de diminuir. Então a caravana que estava marcada somente para o próximo ciclo lunar foi adiantada para poder acelerar o encontro e treinamento de novos mago.

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 17');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 18', 'a-trombeta-de-dagor-no-18', $MDS$> 📰 Blog *Mar de Sangue* · 2013-11-29 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/11/a-trombeta-de-dagor-n-18.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiXK1YLB5IYRYlEHHRS3SbEZkvDKPoyyY1XPSUg3l7M2y4aQW93deu-mko5wRbrWfQtIxLqjFgNtWaXVANm2U6O4yMXH9mFNJ84u9K61l-BLBmv8CAca1SVAbMHkkfgcgNKH7CknS2aasAb/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiXK1YLB5IYRYlEHHRS3SbEZkvDKPoyyY1XPSUg3l7M2y4aQW93deu-mko5wRbrWfQtIxLqjFgNtWaXVANm2U6O4yMXH9mFNJ84u9K61l-BLBmv8CAca1SVAbMHkkfgcgNKH7CknS2aasAb/s1600/gondorhorn.jpg)

</div>

### As Caravanas dos Anões encontram segurança nas Montanhas\!

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

  

</div>

<div style="text-align: justify;">

Aqui no Trombeta já foi comentado sobre as Caravanas de anões que continuam viajando para as terras do antigo Reino Leste dos Anões. No entanto elas ainda tinham de seguir dado voltas imensas evitando as passagens pelas grandes Montanhas das florestas, para evitar o grande risco de serem atacadas pelos Goblins que enfestam a região. Mas algo mudou\! De acordo com relatos de alguns moradores dos vales dessas montanhas, o número Goblins tem diminuído na região, e seus grupos andam desbaratados e confusos. Conseguimos falar com o "novo Rei do Leste" Dúrin, descendente do Antigo Rei Thúrin, e ao perguntarmos sobre o acontecido ele disse:

</div>

<div style="text-align: justify;">

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhIRQ3V1hYcr0Ww5TMAFNN03TT18yfCiEiUwLrVl9Uxon7C2JSp2XskbJ2mwU1n7vfpbJ9dTZE2qo4s8oBQx9-o8BQ2ddJ1fRedZ2jntkbf_lJvKgIcx9WTiPi_yr12Y9l2yp1gvK22oSCZ/s400/300254_636934256323745_1528781051_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhIRQ3V1hYcr0Ww5TMAFNN03TT18yfCiEiUwLrVl9Uxon7C2JSp2XskbJ2mwU1n7vfpbJ9dTZE2qo4s8oBQx9-o8BQ2ddJ1fRedZ2jntkbf_lJvKgIcx9WTiPi_yr12Y9l2yp1gvK22oSCZ/s1600/300254_636934256323745_1528781051_n.jpg)

</div>

</div>

<div style="text-align: justify;">

"O novo Reino Leste se ergue novamente e sua maior missão no momento é garantir um ponto de defesa contra Morcul. Com tal responsabilidade nos ombros obviamente deveríamos acabar com as dificuldades das caravanas se agruparem na região do Reino Leste. E foi o que fizemos\! Temos forças lidando com o Senhor desses Goblins, e como vocês viram, os nossos esforços tem dado grande resultado. Assim esperamos mais apoio das forças da Aliança em nosso difícil trabalho de reerguer esse grande e necessário Reino\!"

</div>

<div style="text-align: left;">

  

</div>

###                  <span style="font-size: large;">Um novo grande mistério nas Terras do Norte\!</span>

<div style="text-align: justify;">

Anos atrás a rainha da grande cidade de Esgaroth pertencente ao Reino Dranoriano, a sudoeste de Amon Tyr, desapareceu misteriosamente. Muitos julgavam que havia sido obra de um Clã Bárbaro que era inimigo da cidade a séculos, e guerreava pelas posses da região. O que surpreendeu a cidade é que após a queda desse Clã Bárbaro, os sobreviventes que imploraram misericódia em troca de informações juraram nada saber sobre o desaparecimento da Rainha Nienor. Elódia que possuía uma ótima relação com Esgaroth prometeu investigar mais a fundo, apesar de não haver esperanças, mas prometem ao menos dar uma solução a esta triste situação.

</div>

<div style="text-align: justify;">

  

</div>

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhPcr5y150SrWKQ8RWpO8TVzgJobisR_G_1L-o6ytxzRFkoafQ4VXb_YSVH77dG06hapPsI6t7n7SDkjg6mbr-VI8-Qn2Ysln3hcMqZuGavahhM8Hwv8N0bZoqmtqDPunvQlZg4cahuK-D2/s320/1375016_664641223546539_1270795755_n.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhPcr5y150SrWKQ8RWpO8TVzgJobisR_G_1L-o6ytxzRFkoafQ4VXb_YSVH77dG06hapPsI6t7n7SDkjg6mbr-VI8-Qn2Ysln3hcMqZuGavahhM8Hwv8N0bZoqmtqDPunvQlZg4cahuK-D2/s1600/1375016_664641223546539_1270795755_n.jpg)

</div>

##$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 18');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 19', 'a-trombeta-de-dagor-no-19', $MDS$> 📰 Blog *Mar de Sangue* · 2013-12-06 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/12/a-trombeta-de-dagor-n-19.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Dragões avistados pelo continente

#### 

<div style="text-align: justify;">

Alguns reportes de dragões vinham acontecendo, mas dessa vez foi pior.  Caravanas anãs alegavam tê-los avistados, mas dessa vez várias cidades soltaram declarações oficiais do acontecido. Entre elas podemos citar Omari, Xablau e Sekai se pronunciaram. Nos relatos se diz que são diversos tipos de dragão, variando conforme a região.

</div>

<div class="separator" style="clear: both; text-align: center;">

<http://ffden-2.phys.uaf.edu/212_spring2011.web.dir/Dalton_Ellingson/dragons_flying.jpeg>

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>

<div style="text-align: justify;">

 O que assusta a todos é o retorno deles. Dragões são raramente vistos em  Dagorcain desde que eles, por iniciativa própria, partiram do continente durante a Guerra dos Cem Anos. O  que os levou a retornar  permanece um mistério.

</div>

<div style="text-align: justify;">

</div>

###   Elfos sofrem confrontando entes

<div style="text-align: justify;">

Como já foi noticiado na Trombeta, de uns tempos para cá os  entes parecem  estar sob o domínio de alguma força maligna, e isso tem gerado caos e destruição por toda a Grande Floresta. A Liga da Floresta não tem sabido lidar com isso e nem mesmo os mais "capacitados" de sanar o problema tem se pronunciado. Procurada pela Trombeta, falamos com a druida Mellian e ela alega que talvez eles estejam buscando algo, ou  fugindo de algo. Mas a final de contas, não se sabe ao certo.

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 19');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 20', 'a-trombeta-de-dagor-no-20', $MDS$> 📰 Blog *Mar de Sangue* · 2013-12-13 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/12/a-trombeta-de-dagor-n-20.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhqAQe6JZV1T_LZmnNJVIwmrzjK1kpmmy4aS72QLd4J4QUt34AfG36_jH1-NJWdvUhuI8Ig5AizCXdatjOK1OMXDZN3cvc3C-2CQekvdAgDiWgbKG4r1Q4kLq8kV3LNkmepuSmc90OAdaaz/s1600/gondorhorn.jpg)

</div>

## 

### Caçadora de dragões dá dicas pra essa situação

#### 

<div class="separator" style="clear: both; text-align: center;">

<http://fc00.deviantart.net/fs70/i/2011/303/d/6/dragon_hunter_redux_by_thebastardson-d4egg6q.jpg>

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>

<div style="text-align: justify;">

 Após a constante aparição de dragões em Dagorcain, a Trombeta procurar alguém para nos ajudar a melhor a situação dos nossos amados leitores. E essa pessoa foi achada, e foi Araatis, a Bravia. Uma caçadora de dragões originária de Muralha Arbórea, essa elfa paladina dedicada a Kord tem como profissão caçar e eliminar dragões que causam destruição pela continente. Com a chegada dessa horda ela foi procurada para dar dicas de sobrevivência em caso de ataque.  

>   
> "É fundamental correr. O poder de destruição de um dragão é impossível de se confrontar se você não tiver treinamento específico pra isso. Os sentidos super aguçados dele te impossibilitam de se esconder. A saída é dar as costas e sair  em fuga. Talvez ele se preocupe em destruir outra coisa e te esqueça."

</div>

###   Sorteio para comemorar a vigésima ed. da Trombeta

<div class="separator" style="clear: both; text-align: center;">

<http://upload.wikimedia.org/wikipedia/commons/c/cf/Hoard_of_ancient_gold_coins.jpg>

</div>

###  

<div style="text-align: justify;">

Para comemorar a vigésima edição da Trombeta de Dagor decidimos por sortear uma bolsa de moedas de duzentas e cinquenta peças de ouro\! Quem quiser participar dessa festa basta mandar uma carta para o nosso editorial e responder a pergunta: "Qual o jornal que zela por ti?" O vencedor receberá o prêmio junto com a assinatura eterna do jornal\! \[Off=Respondam a pergunta no comentário que eu vou sortear.\]

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 20');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 21', 'a-trombeta-de-dagor-no-21', $MDS$> 📰 Blog *Mar de Sangue* · 2013-12-20 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2013/12/a-trombeta-de-dagor-n-21.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiXK1YLB5IYRYlEHHRS3SbEZkvDKPoyyY1XPSUg3l7M2y4aQW93deu-mko5wRbrWfQtIxLqjFgNtWaXVANm2U6O4yMXH9mFNJ84u9K61l-BLBmv8CAca1SVAbMHkkfgcgNKH7CknS2aasAb/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiXK1YLB5IYRYlEHHRS3SbEZkvDKPoyyY1XPSUg3l7M2y4aQW93deu-mko5wRbrWfQtIxLqjFgNtWaXVANm2U6O4yMXH9mFNJ84u9K61l-BLBmv8CAca1SVAbMHkkfgcgNKH7CknS2aasAb/s1600/gondorhorn.jpg)

</div>

### Mudanças de horizonte para guildas mercantes

<div style="text-align: justify;">

Após constantes ataques a alguns navios sendo atacados, saqueados e destruídos o Concilio Mercante chegou a conclusão que terá de expandir seu ramo de construção naval. O comércio não pode parar. Por mais que essa competição com criminosos venha falindo pequenos navegadores, as grandes companhias conseguem manter-se firmes. Elas irão construir novos portos fortificados para poderem passar mais tempo em locais seguros, distantes do alto mar. Eles criarão esquadras que patrulharão as costas e a protegerão de ameaça.  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhdxRjIU6TUldRqnmFhq9UJ6O1PDQJ6k9sC6OSmwFwqfWhFhQnlhNbBiHsKkBPnATfTz5MoOPoRPeDa2yzvqZZ_Jh0yv_Bd8QgUkVhafWO_uAg8uIMV1iOysKTkddm4Y2yPQoBUei8anrIp/s320/Ship-of-Magic-port.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhdxRjIU6TUldRqnmFhq9UJ6O1PDQJ6k9sC6OSmwFwqfWhFhQnlhNbBiHsKkBPnATfTz5MoOPoRPeDa2yzvqZZ_Jh0yv_Bd8QgUkVhafWO_uAg8uIMV1iOysKTkddm4Y2yPQoBUei8anrIp/s1600/Ship-of-Magic-port.jpg)

</div>

</div>

<div style="text-align: justify;">

### Resultado do Sorteio da Vigésima Edição

</div>

<div style="text-align: justify;">

Após centenas de milhares de cartas, pedras e pombos, dragonetes e morcegos chegando aqui todos os dias aqui na sede da Trombeta aconteceu o grande sorteio. E o ganhador foi: \_\_\_\_\_ \_\_\_\_\_. Será revelado na próxima edição. Continuem acompanhando e comprando o jornal para mais informações desses glorioso sorteio com o magnifico prêmio de duzentas e cinquenta cintilantes peças de ouro.

</div>

<div style="text-align: justify;">

  

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 21');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'jornal', 'A Trombeta de Dagor - Nº 22', 'a-trombeta-de-dagor-no-22', $MDS$> 📰 Blog *Mar de Sangue* · 2014-01-03 · marcadores: Jornal
> Fonte: https://maresdesangue.blogspot.com/2014/01/a-trombeta-de-dagor-n-22.html

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiXK1YLB5IYRYlEHHRS3SbEZkvDKPoyyY1XPSUg3l7M2y4aQW93deu-mko5wRbrWfQtIxLqjFgNtWaXVANm2U6O4yMXH9mFNJ84u9K61l-BLBmv8CAca1SVAbMHkkfgcgNKH7CknS2aasAb/s320/gondorhorn.jpg)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiXK1YLB5IYRYlEHHRS3SbEZkvDKPoyyY1XPSUg3l7M2y4aQW93deu-mko5wRbrWfQtIxLqjFgNtWaXVANm2U6O4yMXH9mFNJ84u9K61l-BLBmv8CAca1SVAbMHkkfgcgNKH7CknS2aasAb/s1600/gondorhorn.jpg)

</div>

### Trombeta de Dagor é atacada\!

<div style="text-align: justify;">

Primeiramente viemos aqui para pedir desculpas pela não publicação do jornal na semana passada. O fato é que sofremos um ataque. Como é de conhecimento comum, nossa sede se localiza na cidade de Elódia, e justo aqui fomos atacados. Aparentemente um grupo de ladrões invadiu nosso prédio, rendendo nossos funcionários e furtando a premiação que havia sido oferecida no sorteio. A guarda da cidade já foi acionada e eles esperam resolver o caso em breve para dar continuação ao sorteio.  
  

<div class="separator" style="clear: both; text-align: center;">

[![](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhlG2lq-d_53ZyOZNywGCk0N8lahqkOObPxGiSRfvniR_7nq1NmzQ9wlGanqtZkx8RMPtfhKJkGUiR3yh7TvYVcnpUDuFLzdJ1C_lmSduVzIun9wko1gEoynCV0GC6Ql6YBI76XOQ6jvmkK/s400/vish123.png)](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhlG2lq-d_53ZyOZNywGCk0N8lahqkOObPxGiSRfvniR_7nq1NmzQ9wlGanqtZkx8RMPtfhKJkGUiR3yh7TvYVcnpUDuFLzdJ1C_lmSduVzIun9wko1gEoynCV0GC6Ql6YBI76XOQ6jvmkK/s1600/vish123.png)

</div>

<div class="separator" style="clear: both; text-align: center;">

  

</div>

</div>

<div style="text-align: justify;">

### Noticias do fronte

</div>

<div style="text-align: justify;">

A guerra não para nas fronteiras com Morcul. Após terem avançado além do Rio Divisa eles tentam expandir ainda mais seus domínios. A resistência oferecida pela Aliança das Raças Livres tem conseguido manter a linha constante. Se está sendo armado um largo contra-ataque para romper as linhas de Morcul e expurga-los para trás do Rio novamente. Elódia e Dranar estão juntas as forças de Dranor para o conseguir.

</div>$MDS$, array['Jornal']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Trombeta de Dagor - Nº 22');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'conto', 'Horda do Caos', 'horda-do-caos', $MDS$> 📰 Blog *Mar de Sangue* · 2013-04-16 · marcadores: Cultura
> Fonte: https://maresdesangue.blogspot.com/2013/04/orda-do-caos.html

<div class="MsoNormal" style="text-align: justify; text-indent: 35.4pt;">

Há uma lenda no continente bem popular ao sul de Dagorcain e de  forma geral por todos os draconatos. A cerca de seiscentos anos atrás um draconato paladino dedicado a Ioun vê num sonho que ele mesmo era a reencarnação de um deus caótico, Gruumsh. Acordando Krom, o draconato paladino, se vê com seus poderes elevados a níveis **épicos**. A mente dele entra em parafuso pois desde sua casca era dedicado a Ioun mas o sonho se repetia e ordenava a ele que deveria abandonar o culto do deus do saber e se dedicar a semear o caos.

</div>

<div class="MsoNormal" style="text-align: justify;">

<span style="mso-tab-count: 1;">                </span>Até que certo dia, ele acorda e num frenesi mata todos os paladinos da ordem sem tomar nem mesmo um arranhão de qualquer um dos paladinos que combateu. Cobre a marca de Ioun que havia no peito pelo símbolo de Gruumsh. A partir daí sai a viajar e além de trazer o caos por onde passa, traz com ele seus discursos carregado da mais torpe e poderosa magia que afeta os mais fracos de mente e coração. Enfim uma legião de seguidores começa a se formar sobre seus ideais.

</div>

<div class="MsoNormal" style="text-align: justify;">

<span style="mso-tab-count: 1;">                </span>Após duzentos anos vagando espalhando o caos sobre o mote: “Todos contra todos, isso é o caos”; viu-se como inimigo público número um do continente todo. Todos os governos cultivavam ódio por Krom e sua Horda do Caos. Encurralado na costa sul do continente, a leste do local que viria a ser Dranar lutou lado a lado com seus companheiros caóticos tentando massacrar as forças de uma aliança – chamado por Krom e a Orda de Cegos, pois esses não “veem” que o caos é a essência humana - formada por anões do sul, uma legião paladinos e<span style="mso-spacerun: yes;">  </span>clérigos dedicados a Ioun e um grupo de altos magos de Elódia.<span style="mso-spacerun: yes;">  </span>

</div>

<div class="MsoNormal" style="text-align: justify;">

<span style="mso-tab-count: 1;">                </span>Vendo que a derrota de suas forças era impossível de se impedir lançou seu ultimo discurso a Orda do Caos: “Meus filhos, o caos é a força que nos rege mas a força dos Cegos agora, e somente agora, é superior a nossa. Cabe a mim, Krom, Senhor do Caos, Possessor da Maça e Reencarnação de Gruumsh ir além dos horizontes<span style="mso-spacerun: yes;">  </span>de Dagorcain para semear o caos por toda ilha, país, cidade e vila que há no Mar de Sangue. Irei agora. Mas meus filhos, se acalmem, pois voltarei. Voltarei ao meio-dia, quando tiver sobre mim a imortalidade e a força para abrir os olhos destes cegos.”

</div>

<div class="MsoNormal" style="text-align: justify;">

<span style="mso-tab-count: 1;">                </span>Terminado esse discurso tocou com sua clava as águas vermelha do sangue da batalhas que ali haviam ocorrido e um barco da proa negra emergiu em alto mar vindo em sua direção. Vinte e uma criaturas adentraram esse barco, Krom entre elas e dali partiu rumando o horizonte. As forças da Aliança também extremamente desgastada pelo conflito não teve forma de perseguir Krom em sua fuga.

</div>

<div class="MsoNormal" style="text-align: justify;">

<span style="mso-tab-count: 1;">                </span>A Horda ali se debandou, deixando de ser uma ordem organizada e centralizada para se espalhar por toda Dagorcain e como um vírus que corromper a sociedade. De uma ordem com cabeça, códigos e leis se tornou uma força pulverizada organizada em células. Fanáticos eram os homens que pregavam as palavras de Krom, ansiosos por sua volta. Dentros dessas células algumas se destacaram, pois foram responsáveis por grandes atentados.

</div>

<div class="MsoNormal" style="text-align: justify;">

<span style="mso-tab-count: 1;">                </span>A Horda do Caos permanece até hoje ativa com seus membros tentando sempre trazer a desordem que eles acreditam. A hierarquia que eles seguem é regida unicamente pela força e segue a seguir um resumo desta.

</div>

<div class="separator" style="clear: both; text-align: center;">

</div>

<div class="separator" style="clear: both; text-align: center;">

</div>

<div class="separator" style="clear: both; text-align: center;">

</div>

<div class="separator" style="clear: both; text-align: center;">

</div>

<div class="separator" style="clear: both; text-align: center;">

<https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEh9pXhnsvziCYKn4LADpyuk5BvWTHXj5Nvj1O9d3CUOgvkWuIjiejNIp6LRlhQgW7pIVk-QdMNDZN7qRS6sZxbGZaD475K6qap2ev1v-o9f3hYb5izV5lRJdQ-bTUztSK7QjY4zeq9LMQwV/s1600/hierarquia.fw.png>

</div>

<div class="MsoNormal" data-align="center" style="text-align: center;">

<div style="text-align: justify;">

<span style="mso-fareast-language: PT-BR; mso-no-proof: yes;">  
</span>

</div>

<span style="mso-fareast-language: PT-BR; mso-no-proof: yes;">  
</span>

</div>

<div class="MsoNormal" style="text-align: justify;">

<span style="mso-tab-count: 1;">             Os membros da Horda tem características singulares que em determinadas situações é fácil de se identificar. Todo membro tem o símbolo de Gruumsh gravado em seu **olho esquerdo.** Tal marca não causa cegueira por se tratar de magia. Em alguma parte do corpo há uma marca á fogo, da arma que representa seu cargo  na hierarquia e no caso do individuo "evoluir" a nova marca será feita por cima da anterior.</span>

</div>$MDS$, array['Cultura']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Horda do Caos');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'conto', 'Filhos de Uther', 'filhos-de-uther', $MDS$> 📰 Blog *Mar de Sangue* · 2013-07-04 · marcadores: Cultura
> Fonte: https://maresdesangue.blogspot.com/2013/07/filhos-de-uther.html

<div class="MsoNoSpacing" style="text-align: justify;">

<span style="font-family: &quot;Times New Roman&quot;,&quot;serif&quot;; font-size: 14.0pt;"><span style="font-family: &quot;Times New Roman&quot;,&quot;serif&quot;; font-size: 14.0pt;"><span style="mso-tab-count: 1;">         </span></span>Filhos de Uther é um clã de guerreiros que descendem de Uther Peacemaker, Humano Paladino que em tempos remotos combateu Krom e sua Horda do Caos. Ele deu início a esse clã reunindo seus parentes e companheiros para empreender uma luta contra a desordem que se alastrava por Dagorcain.</span>

</div>

<div class="MsoNoSpacing" style="text-align: justify;">

<span style="font-family: &quot;Times New Roman&quot;,&quot;serif&quot;; font-size: 14.0pt;"><span style="mso-tab-count: 1;">         </span>Os Filhos de Uther – também chamada de Ordeiros por muitos – englobam devotos de todas divindades benignas ou neutras que presam pela paz a ordem. Não abrigam somente paladinos, mas sim todo tipo de pessoa forte disposta a lutar contra Krom e sua influencia.</span>

</div>

<div class="MsoNoSpacing" style="text-align: justify;">

<span style="font-family: &quot;Times New Roman&quot;,&quot;serif&quot;; font-size: 14.0pt;"><span style="mso-tab-count: 1;">         </span>Os Ordeiros tiveram seu auge junto ao auge de Krom, quando os combates entre as forças ocorriam todos os dias. Sua sede era na cidade de Sanstag na borda sudoeste da Floresta Fornost. Uma cidade que se sustentava basicamente só do militarismo e dos grandiosíssimos templos de todas divindades que lá haviam.</span>

</div>

<div class="MsoNoSpacing" style="text-align: justify;">

<span style="font-family: &quot;Times New Roman&quot;,&quot;serif&quot;; font-size: 14.0pt;"><span style="mso-tab-count: 1;">         </span>A cidade entrou em declínio depois que Uther Peacemaker e suas hostes conseguiu expulsar Krom para fora de Dagorcain. Os ataques da Horda diminuíram de intensidade e todo poderio da cidade já não era mais necessário como antigamente.</span>

</div>

<div class="MsoNoSpacing" style="text-align: justify;">

<span style="font-family: &quot;Times New Roman&quot;,&quot;serif&quot;; font-size: 14.0pt;"><span style="mso-tab-count: 1;">         </span>Anos depois Uther morreu, sendo humano comum, pois o seu tempo era chegado. Os Filhos então perderam muito prestígio tendo perdido seu lendário líder mas nunca acabaram realmente. Sempre se mantiveram na vigilância contra a Horda do Caos e seus remanescentes.</span>

</div>

<div class="MsoNoSpacing" style="text-align: justify;">

<span style="font-family: &quot;Times New Roman&quot;,&quot;serif&quot;; font-size: 14.0pt;"><span style="mso-tab-count: 1;">         </span>Atualmente Sanstag ainda existe, mas deixou de ser uma gloriosa cidade pra se tornar mais uma fortificação que abriga os templos e os Ordeiros que ainda estão em treinamento. O líder atual é Thor de Sanstag um humano dranoriano dedicado a Kord.</span>

</div>

<div class="MsoNoSpacing" style="text-align: justify;">

<span style="font-family: &quot;Times New Roman&quot;,&quot;serif&quot;; font-size: 14.0pt;"><span style="mso-tab-count: 1;">         </span>Sem a antiga fortuna que a cidade trazia aos Filhos de Uther eles tem passado por uma severa crise pois não tem como se sustentar. Eles pediam ajuda a Dranor, Elódia e Dranar, mas desde que a guerra contra Morcul teve início as verbas foram desviadas para tratar disso.</span>

</div>$MDS$, array['Cultura']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Filhos de Uther');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'conto', 'A Reunião - Parte 1', 'a-reuniao-parte-1', $MDS$> 📰 Blog *Mar de Sangue* · 2014-12-31 · marcadores: Guardiões Cegos
> Fonte: https://maresdesangue.blogspot.com/2014/12/a-reuniao-parte-1_27.html

<div style="text-align: justify;">

*Ele está vivo, eu posso sentir isso. Tudo bem que eles desapareceram depois do conselho vermelho, mas isso foi porque Elódia os colocou como traidores mais uma vez. Malditos elodianos, Althïr nunca cometeria um ato tão vil...*

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">Os devaneios de Allyria foram interrompidos quando Bellon, Capitão do pelotão, ordenou a parada. Já passava da meia-noite e os cavalos precisavam de descanso. O silencio se manteve entre o grupo, não seria agradável atrair atenções indesejadas com conversas e barulheiras, mas também, ninguém estava no clima para qualquer sorriso, foram vitoriosos no último combate, mas isso custou um terço do pelotão, amigos a muito conhecidos agora nas mãos dos deuses.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">– Descansaremos aqui por quatro horas – avisou o Capitão enquanto desmontava de sua montaria – Fiquem atentos e não abaixem sua guarda, não queremos nenhuma surpresa durante a noite.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">Estavam em marcha acelerada há trinta e dois dias, se nada mais os atrasasse chegariam nos próximos cinco. Já estariam na séde se não fosse pela emboscada de uma tropa de Morcul, que de alguma forma conseguiu se embrenhar pela floresta sem ser ao menos percebida pelos batedores da aliança. Por este motivo, Bellon reduziu o tempo de descanso e acelerou o ritmo da marcha, pois deviam assim compensar parte do tempo perdido.</span>

</div>

  

<div style="text-align: justify;">

  

</div>

<span style="font-family: inherit;"></span>  

<div style="text-align: justify;">

<span style="font-family: inherit;"><span style="font-family: inherit;">O próprio Elryon, líder de toda a Ordem, convocou uma grande reunião com todos os agentes presentes no continente. Após o conselho vermelho muitas coisas haviam mudado, toda a guerra agora tinha outro significado. Muitos agora, como o próprio Capitão, encaravam Allyria de outra forma, com olhares de incerteza, olhares que tentavam julgar se sua lealdade era real ou traiçoeira, uma desconfiança que começou a partir dos relatos de Elódia, os quais colocam Althïr como um grande traidor e assassino. Tal desconfiança era meio lógica, afinal de contas, eles eram Althïr e Allyria, os prodigiosos gêmeos Alcarin, fosse qual fosse a verdade, ela certamente estaria de acordo com o irmão. </span></span>

</div>

<span style="font-family: inherit;"> </span>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
*Malditos Elodianos, criam bodes expiatórios para que seus ganhos com aquela tragédia passem despercebidos.*</span><span style="font-family: inherit;"> </span><span style="font-family: inherit;">– Allyria bufava em seus pensamentos. </span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
A manhã se aproximava, todos se aprontaram e seguiram em sua marcha. Eles seguiam para Delfos Norte, com cidades élficas nas proximidades, a séde intermediária dos Guardiões Cegos tinha bom apoio e auxílio. Nessa rotina de marcha chegaram ao seu destino, aonde muitos já se reuniam e outros mais chegavam.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">Mais cinco dias foram necessários para que todos os pelotões remanescentes estivessem presentes - assim como uma comitiva de Elódia. No sexto dia a grande reunião foi finalmente realizada.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">Logo após o desjejum, Elryon e seus outros seis comandantes apareceram no enorme palanque construído em frente ao grande pavilhão central do conselho. Logo após eles, subiram também um elfo e um eladrín em suas suntuosas e características vestes de mago, eram representantes de Elódia. Haviam aproximadamente novecentos membros da Ordem ali presentes, pois cerca de quatrocentos haviam perecido em campo. Allyria pode contar cerca de cinquenta representantes na comitiva de Elódia, achou aquilo certamente exagerado para uma simples representância.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
No início da reunião, aqueles que morreram foram honrados com cantos e orações por suas almas, e ao findar as honrarias, os assuntos em questão foram abordados.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
– Há cerca de um ano, ocorreu a grande atrocidade conhecida como Conselho Vermelho.  – Começou Elryon.  – E como todos aqui devem saber, um dos nossos membros esteve envolvido em tal acontecimento.  – O alto e poderoso Eladrín falava com uma seriedade profunda, Allyria notou que tudo isso realmente parecia incomodá-lo.  – Mas muitos entre nós ainda não tem conhecimento de todos os fatos. Por esse motivo, Vardamir nos relatará todo o ocorrido de acordo com os registros de Elódia. – O elfo elodiano se pôs ao lado de Elryon, desenrolou um pergaminho, pigarreou e começou o relato.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
– A convite do Reino Anão Leste, três líderes do Supremo Militar Elodiano compareceram a um grande conselho que foi realizado em sua capital. – O tom arrogante e soberbo característico dos Elodianos sempre irritava Allyria. – O Rei Dúrin, Membros da aliança comercial Trade e outros ilustres representantes tiveram suas presenças confirmadas. Aredhel, uma emissária dranoriana, traiu a Aliança e assassinou brutalmente todos ali presentes, incluindo seu irmão e seu noivo. Além da grande traição, tivemos outras revelações, como o fato de Dranor ter criado e desenvolvido ocultamente uma sociedade de Lobisomens, bestas cruéis e sanguinolentas que assombram gerações. Aredhel, a assassina, representava essas criaturas, o que prova a sua natureza vil e traiçoeira. Após a grande carnificina, ela simplesmente desapareceu sem deixar rastros.</span>

</div>

  

<div style="text-align: justify;">

<span style="font-family: inherit;"> – E aonde exatamente um dos nossos se encaixa nessa história sangrenta? – Perguntou Elryon ao elodiano.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
– Althïr Alcarin, membro dos Guardiões Cegos; Thor Adim, mestre de armas anão; Hans, bardo humano; Natã, deva feiticeiro que estudou magia em Elódia; Stulk, golias com tendências bárbaras e Tharen, um elfo sem antecedentes registrados, formam um grupo já duas vezes suspeito de traição contra a Aliança. – Seu desdém e repulsa eram mais do que claros ao citar os nomes. – Sua atuação no Conselho Vermelho não é em si confirmada, uma vez que não tiveram contato direto com o ato, mas é confirmado que o grupo era de grande amizade com Dranor, com a sociedade de lobisomens e também de uma amizade pessoal com Aredhel, a traidora. Kane, o noivo de Aredhel, também fazia parte do grupo de Althïr e foi confirmado como uma das bestas, assim como sua noiva. – Com uma pequena pausa, ele continuou. – Com estes relatos sobre o grupo, podemos deduzir rapidamente que eram suspeitos em potencial e, com base nessas suspeitas, decidimos prendê-los até que as investigações fossem concluídas. Porém, com a sua liberdade ameaçada, todos eles, menos Thor Adim, que foi capturado e está agora nos calabouços do Reino Anão Leste, fugiram sem deixar qualquer rastro, indício de sua culpa nesta vil traição. – O discurso repetitivo e manipulador do elodiano só aumentava a frustração de Allyria, todo esse joguete realmente lhe dava nos nervos. – Althïr e seus companheiros são acusados, pela segunda vez, de alta traição e são fugitivos da Aliança. Qualquer um que lhes dê abrigo, esconderijo ou qualquer tipo de amparo será considerado cúmplice de seus planos e terá a mesma punição.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
Vardamir então se afastou e guardou seu pergaminho enquanto Elryon tomava a palavra.</span>

</div>

  

<div style="text-align: justify;">

<span style="font-family: inherit;">  
– Muito bem, agora todos estão cientes sobre os registros de Elódia. – A seriedade em seu tom era ainda mais severa, seu desgosto com aquele assunto era evidente. – Então, cabe a mim perguntar, o que Elódia quer com todo esse contato com os nossos e todo este terrível relato?</span>

</div>

<span style="font-family: inherit;"></span>  

<div style="text-align: justify;">

<span style="font-family: inherit;"><span style="font-family: inherit;">  
O Eladrín Elodiano foi à frente para responder.</span></span>

</div>

<span style="font-family: inherit;"> </span>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
– O que queremos aqui é a prova de que os Guardiões Cegos não fizeram parte desse horror que foi o Conselho Vermelho, a evidência de que não aprovam os vis atos de Althïr Alcarin. – Allyria achou aquele eladrín estranho, não só a sua arrogância elodiana não lhe agradava, havia algo nele que lhe dava calafrios, repugnância. – Nós temos conhecimento de que Althïr tem uma irmã gêmea, a qual também faz parte desta corporação, peço que a chamem para o palanque, para que possamos ter mais respostas.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
Todos encararam Allyria, muitos com olhos de acusação, outros de apoio, muitos a olhavam simplesmente com tristeza, desapontamento. Dentre a Ordem existiam muitas opiniões contrárias quanto às questões do continente, e é claro, sobre Althïr e Allyria. Mas também havia aqueles que não sabiam no que acreditar, seus olhos buscavam apenas por respostas.</span>

</div>

<div style="text-align: justify;">

<span style="font-family: inherit;">  
Elryon a chamou para o Palanque, e assim ela foi sob o olhar turvo de todos ali presentes, tanto membros dos Guardiões quanto dos Elodianos acusadores. O pesar em seu peito era maior a cada passo, sua força era menor a cada metro, o silêncio de todos era angustiante, um clima obscuro e ruim, era só o que isso representava. </span>

</div>$MDS$, array['Cultura']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='A Reunião - Parte 1');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Elrik — Da Aliança dos Suicidas', 'elrik-da-alianca-dos-suicidas', $MDS$> 📖 CONTO / NARRATIVA ORIGINAL (autoria do grupo). Fonte: Google Doc "Elrik.docx". Preservado na íntegra.

## Da Aliança dos Suicidas
*Dos diários do Septão Ancelmo de Tordesilhas*

Por quase um milênio, o domínio hegemônico dranoriano regeu as terras do noroeste de Dagorcain. Sua influência era temida desde a capital, Dranor, até os longínquos desertos de Harad e os limites das terras bárbaras.

O Império Dranoriano possuía treze grandes famílias: os Dranor (família real), os Rakkar, os Trarks, os Atom, os Wiserdon, os Pethfinder, os Lordsear, os Treefeets, os Loneranger, os Bellwar, os Bloodhammer, os Bearclaws e os Stormborn. Todas se originaram dos doze capitães que acompanharam o rei Dranor na fundação do reino — os chamados Dranorhands.

Desde o princípio, os Dranor foram a família mais poderosa. Detinham a linhagem real, o controle da capital e o comando sobre todo o reino. As demais famílias, lideradas pelos Dranorhands, governavam cidades, vilas e aldeias espalhadas por Dranor. Possuíam relativa autonomia econômica, mas pagavam tributo mensal à capital.

Cada família se destacava em uma área das artes dranorianas. Os Bloodhammer eram considerados os melhores ferreiros de Dagor; suas armas alcançavam preços altíssimos até mesmo no mercado dos Trade. Os Lordsear eram mestres na construção naval, produzindo embarcações belas e resistentes. Já os Pethfinder destacavam-se como engenheiros e artesãos. Outras famílias voltaram-se ao comércio e à pesca, com especial destaque para os Stormborn.

Entretanto, nenhuma família foi tão controversa quanto os Atom.

Politicamente distantes da corte, os Atom eram, paradoxalmente, presença constante nas discussões do salão real. Em seu cerne, mantinham vivo o desejo de exploração e expansão que outrora guiara as grandes navegações dranorianas.

O primeiro a desafiar abertamente a autoridade real foi Elrik Atom.

Elrik autoproclamou-se rei após conquistar uma cidade próxima ao Reino Anão do Oeste. Expandiu seus domínios e fundou uma nova cidade homônima, à sombra da velha Montanha Solitária. Sua relação diplomática com os anões — tanto do oeste quanto do leste — foi algo inédito, forçando a corte dranoriana a tolerar sua insubordinação.

Tal tolerância estabeleceu um precedente perigoso.

Acredita-se que essa ruptura tenha sido a semente do que mais tarde ficou conhecido como a Aliança dos Suicidas. A proximidade entre os Atom e os Lordsear, aliada às influências e alianças estabelecidas nas fronteiras de Elódia, foi determinante para que tal empreendimento fosse concebido.

A Aliança dos Suicidas talvez tenha sido responsável por grande parte da dor e do sofrimento das guerras mais recentes, devido ao enfraquecimento das fortalezas dranorianas e elodianas. Há cerca de cem anos, uma grande frota de exploração partiu dos portos de Elódia — e jamais retornou.

## O que só velhos e putas lembram...
*Dos relatos de um bêbado*

Atom... hah… imbecis filhos da puta…

– Sabe, garoto… – dizia o Alto Pedinte, com a voz arrastada e o cheiro de vinho barato – eu não queria ser quem eu sou... vir de gente que fez tanto e virou nada... Valik Erevan... Erevan...

Ele diz enquanto cospe de lado e ri, um riso seco, que vira tosse.

– Lideramos toda a maldita viagem. Peito estufado, olho no horizonte… achando que poderíamos conquistar o mundo. – Dá mais um gole, limpando a boca com o dorso da mão suja.

– Quando deu errado… e deu muito errado… ah – aponta um dedo trêmulo – Trouxemos gente demais pra morrer longe de casa… e aí… – abaixa a voz – meu pai dizia que, pode ter filho sem pai, homem sem pau e anão sem barba, mas não existe culpa sem dono por aí.

Ele fez silêncio, enquanto encarava o nada.

– Os Atom começaram a cair… devagarzinho… que nem dente podre. Primeiro os aliados somem. Depois… – faz um gesto de corte com a mão – mandam os meninos pra guerra. Os novos. Sempre os novos…

Ele encara o nada.

– Os velhos? Hah… esses morriam dormindo. "Morte tranquila", diziam… – ri, amargo – tranquila o caralho. Celeste dizia que nosso avô amanheceu com a cabeça roxa como uma beterraba... ela era tão pequena... mas nunca esqueceu os gritos.

Mais um gole.

– E as brigas… ah, as brigas… gente morrendo por qualquer coisa. Servo, criado, tanto faz… ninguém ligava mais. Já não tinha lei… só tinha medo.

Ele se inclina, quase sussurrando:

– Primeiro te ignoram… depois te evitam… depois… – faz um gesto lento com a mão, como quem estrangula o ar – depois te apagam.

Ele faz uma longa pausa, e volta olhar pro garoto.

– Foi assim que acabou, entendeu? – voz baixa, rouca – Os Atom não caíram de uma vez… não… foram sumindo.

Toma outro gole.

– Sumindo… até não sobrar ninguém pra dizer que eles existiram. Só velhos e putas como eu e Celeste, pra lembrar que esse lugar não deveria se chamar Erevan...

## Um nome de Rei

Elrik se lembra do chão frio da Casa de Prazeres.

Muitos órfãos viviam no cortiço adjacente ao prédio das meretrizes. Sua memória mais antiga é a de um empurrão de Madame Celeste. Ele caiu no chão gelado, ferindo o rosto e rompendo os lábios.

Algumas crianças eram reconhecidas por suas mães – ou, mais raramente, por seus pais. Outras sequer sabiam sua origem: se eram filhos de mulheres ainda vivas que os ignoravam ou de prostitutas que haviam morrido na sarjeta.

Elrik não se lembrava do rosto de sua mãe. Às vezes, questionava se algum dia a conhecera. Diziam que bebês não enxergam ao nascer – e prostitutas, segundo Madame Celeste, frequentemente morriam ao dar à luz "bandidinhos" como ele.

Ele não odiava Madame Celeste. O que odiava era o fato de que aquela brutalidade era o mais próximo de afeto materno que conhecera.

Amava algumas das outras crianças como irmãos. E, entre bêbados e frequentadores da casa, encontrou uma figura paterna: o homem que chamava de "avô feio".

O Alto Pedinte, como era conhecido, fora um clérigo dentre os Herdeiros de Dagor. Hoje, gastava seus soldos afogando as mágoas na bebida e entre as pernas de Madame Celeste – então passava o resto do mês pedindo esmolas. Dizia beber para esquecer as vidas que tirou, mas lamentava ainda mais aquelas que abandonou.

Seu avô comia sua mãe, disse Elrik a si mesmo enquanto olhava para o céu, na noite que se deitou com uma mulher pela primeira vez.

O Alto Pedinte era alto como Elrik e, por algum motivo, afeiçoou-se ao garoto.

Na noite em que Madame Celeste morreu de sífilis, o Alto Pedinte levou Elrik para "comemorar" seu aniversário. Elrik não sabia quando nascera, mas parecia ter a mesma idade dos garotos entre eles que diziam ter 15 anos.

Comeram, beberam, e Elrik deitou-se com uma jovem pela primeira vez.

O velho zombou, dizendo que a garota poderia ser sua irmã ou prima – afinal, muitas ali eram filhas de prostitutas que seguiram o mesmo destino. Mas, segundo ele, nada disso importava. Nada importava. Pois a mais maravilhosa de todas as putas se foi.

Naquela mesma noite, o Alto Pedinte começou a contar histórias.

Falou de seu verdadeiro nome, que escondia. Disse que Madame Celeste era a última descendente de uma família importante – e que entre eles havia existido um amor quase proibido, um segredo perigoso.

Foi quando revelou um velho lençol de bebê. Nele havia uma insígnia antiga, como as dos navios das histórias.

Segundo ele, aquele era o símbolo dos verdadeiros dranorianos que vieram de um lugar chamado Dagorcain – e fora o tecido que envolvera Elrik ao nascer. Disse ainda que Madame Celeste o proibira de manter o objeto, ou cobrir a criança com ele novamente.

"A desgraçada quase me negou o nome... Elrik... nome de rei"

Mas afirmou algo ainda mais estranho:

Elrik seria a última esperança de preservar o legado de sua família. Elrik nunca soube se aquilo era verdade, delírio ou sonho. Talvez jamais saberia.

Era alto como o Alto Pedinte – mas quantos bastardos dranorianos também não eram? Então, ainda que fosse verdade, de que valeria?

Ainda assim, aquele maldito lençol era tudo o que possuía.

Era a única coisa que dava sentido à sua existência.

Todas as noites, antes de dormir, ele o pendura como um brasão. E, antes de escondê-lo novamente, presta continência.

Como Elrik Atom.

## O Clérigo de Heironeus

O Alto Pedinte fora, em outros tempos, um clérigo de Heironeus.

Servira entre os Herdeiros de Dagor como pregador e arauto dos ideais de seu deus: coragem, guerra, justiça e honra. Foram esses mesmos valores que tentou ensinar a Elrik.

Mas também lhe ensinou outra coisa.

Contava como os Herdeiros haviam se desviado desse caminho – corrompidos pelo poder, tornaram-se aquilo que juraram combater. Agiam como rufiões, desprovidos de honra, usando o nome de Heironeus como justificativa para suas próprias vilezas.

Levou tempo, dizia ele, para reconhecer a própria vergonha. As vidas que tirou. Os atos que cometeu. As mentiras que contou a si mesmo.

Quando seu arrependimento se tornou público, veio o preço: o ostracismo. O abandono. Tornou-se aquilo que mais denunciava – um homem descartado por aqueles que um dia servira.

Ainda assim, não perdeu completamente a fé.

Acreditava que Heironeus – e até mesmo os próprios Herdeiros de Dagor – poderiam um dia ser o caminho para restaurar o que havia sido corrompido. Por isso, fez uma escolha.

Abdicou de suas vestes. Renunciou ao título. E jurou que jamais voltaria a usar o nome de seu deus como escudo para suas próprias falhas. Se houvesse redenção, ele a buscaria sozinho. Se iria se afogar em seus pecados, também o faria sozinho – como fez.

Sem autoridade. Sem desculpas.

Elrik cresceu ouvindo essa história. E, à sua maneira, entendeu aquilo como um chamado. Alguém precisava terminar o que o velho não conseguiu.

Ele acreditava que poderia crescer entre os Herdeiros e, por dentro, mudar aquilo que estava podre. Confiar que Heironeus ainda representava justiça – ou, se estivesse errado… então destruir tudo que carregasse esse nome.

Mudar o mundo. Expor a desonra de Erevan. Revelar a injustiça feita contra os Atom. E devolver à sua família o lugar que acreditava ser seu por direito.

## Um Guerreiro por Justiça

Nos últimos anos de vida, o Alto Pedinte dedicava seus raros momentos de sobriedade a ensinar Elrik a arte da espada e a honra de um guerreiro.

Era tudo o que tinha a oferecer.

Seu afeto era bruto, muitas vezes confundido com violência. Não foram poucas as vezes em que ensinou com golpes, tentando afastar o garoto de uma vida criminosa. Ainda assim, à sua maneira torta, era amor.

Mas o velho também deixou outra herança. Seu remorso. Sua frustração.

Após a morte de Celeste, a amargura que nutria pela elite de Valik Erevan e pelos Herdeiros de Dagor se aprofundou, e acabou enraizando-se em Elrik.

Porque, como o próprio velho dizia, toda desgraça precisa de um culpado.

E Elrik acreditou nisso.

Passou a alimentar um ódio particular pelas forças militares e pelas lideranças de sua cidade natal. A injustiça que via – e que vivia – tornou-se combustível. Revolta. Propósito.

Ele escolheu acreditar nas histórias do "avô feio". Que os Erevan tiveram parte na queda dos Atom. Que o mundo era como era por causa deles. Que sua própria miséria tinha origem em algo maior.

Elrik precisava disso. Precisava que seu sofrimento tivesse motivo. Que sua vida uma razão.

Foi com esse propósito que Elrik se alistou.$MDS$, array['Panimalia']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Elrik — Da Aliança dos Suicidas');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, null, A.id, 'lore', 'Panimalia — O Destino da Aliança dos Suicidas', 'panimalia-o-destino-da-alianca-dos-suicidas', $MDS$> Pasta dedicada ao arquipélago de **Panimalia**, o lugar para onde partiu a frota da **Aliança dos Suicidas** (famílias Atom e Lordsear) e de onde nunca retornou. As histórias e mapas ambientados em Panimalia ficam aqui, separados do continente de **Dagorcain**.

## Conteúdo
- **Elrik - Da Aliança dos Suicidas.md** — conto/narrativa de Elrik Atom (ambientado em Panimalia).
- **Atlas - Grande Panimalia** — mapa/atlas do arquipélago (no Drive, em `ARQUIVO/Atlas - Grande Panimalia.pdf`; copiar para cá quando possível).

## Ligação com o cânone
Panimalia é a colonização perdida da frota de exploração que partiu de Elódia há ~350 anos (ver `01 - Canone Atual/Resumo da História`, Parte 4). Os colonos nunca tiveram meios de voltar a Dagorcain.$MDS$, array['Panimalia']::text[], 'publicado', 'publico'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Panimalia — O Destino da Aliança dos Suicidas');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='sombras-vindas-do-tempo'), A.id, 'campanha', 'Arco 1 — A Aliança', 'arco-1-a-alianca', $MDS$> 📖 NARRATIVA (autoria do grupo). Abertura da campanha anterior. Preservado na íntegra.

## A Aliança

No horizonte uma figura caminha solitária pela larga estrada de Belthalas. Após uma viagem longa o jovem Eladrin finalmente começa a enxergar a luz do Sol, vê-la refletir sobre as águas do grande Delfos.

"[...] nos encontre em Tordesilhas, arranjei um contrato que nos fará ricos![...]"

Dizia a carta de Kane. Passaram-se dois anos desde o ultimo contrato, e Althir não conseguia deixar de se perguntar se Natã de fato estaria presente. Imagens do companheiro mercenário possuído por aquele maldito demônio ainda assombravam sua mente. Ele soube que Natã havia morrido em Elódia pois seu corpo não resistiu a corrupção do espirito, mas os magos haviam feito esforços para adiantar sua ressurreição - característica de sua natureza Deva - mas o resultado de tudo isso Althir desconhecia.

Poucas horas depois as muralhas de Tordesilhas, umas das maiores cidades mercantis do norte de Dagorcain, assomavam a sua frente. Sabia-se que sobre a cidade dominava a Sociedade Trade, controladora do mercado negro de Dagorcain. O famoso tipo de conhecimento público que, por falta de provas, era dado como pura balela pelos governantes.

O Centro da cidade se localizava sobre uma ilha de tamanho admirável em meio a torrente do Rio Delfos. Enquanto as periferias se localizavam entre as margens do exteriores do rio e a grande muralha, que nos pontos norte e sul abriam um grande portal gradeado por onde a corrente das águas não era refreada ou atrapalhada, garantindo a passagem de barcos de médio porte.

"[...] Taberna Vomito de Dragão será o ponto de encontro[...]". Não foi difícil encontrar o grande edifício. Assim que adentrou a sala, Althir Alcarin deparou-se com uma visão nostálgica quase saudosa de companheiros que não via a bastante tempo. Kane sentava-se em uma mesa num canto não tão "menos chamativo" como deveria. Mas já o acompanhavam, com bebidas a postos, Thor Adim, Tharen, Hans o Bardo, Stulk e Natã.

Era uma visão estranha, ver ali o Deva de cabeça raspada, sentado a mesa esquecido do que acontecera a dois anos. Não era ele, claro, quem tentou matar a todos do grupo, mas vê-lo sempre trazia a memória do Paladino a figura demoníaca que o possuiu.

— Ora, ora, ora! Se não é nosso Eladrin favorito! Althir Alcarin! - Disse Kane com um leve sorriso no rosto.

Todos se levantaram para cumprimentá-lo e fazer saudações, eles nunca foram do tipo de admitir a amizade e companheirismo que nasceu entre o grupo mercenário, mas era nítido tudo isso naquele reencontro.

— Porque não se senta, Althir?! Não se preocupe, estou longe o suficiente dessa sua bundinha feérica, não haverão maus tratos dessa vez... dessa vez!

— HaHa! Esse maldito bardo é o mais engraçado! HAHAHAHA! - Thor Adim ria a maneira espalhafatosa dos anões.

— Continuem, vou no bar pedir a bebida mais forte desse lugar! - O tamanho de Stulk sempre fazia o Paladino imaginar quanta bebida era necessária para de fato deixá-lo bêbado.$MDS$, array['Sombras Vindas do Tempo']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Arco 1 — A Aliança');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='sombras-vindas-do-tempo'), A.id, 'campanha', 'Nota de Mestre — Fios da Trama (\"não ler\")', 'nota-de-mestre-fios-da-trama-nao-ler', $MDS$> 🗒️ NOTA DE MESTRE (planejamento, autoria do grupo). Arquivo "não ler" (segredo). Ligado à campanha anterior.

**O que foi feito (nos dois anos):**
- Elódia tentou contactar os dragões.
- Investigaram a fundo os Doppelgangers e seu envolvimento com Elódia.
- Seguiram os pensamentos de Quiryon sobre "mentes que lucram com a guerra".
- Buscaram informações sobre o paradeiro das duas últimas chaves.

**Objetivos:**
- Matar Aredhel.
- Junto com os Dragões, derrotar Exar Khun.
- Descobrir a mente por trás de tudo isso.

**Ganchos:** Reunião com Dranor (Ilha ao Sul de Jordânia) · O Povo Meiji · As Montanhas Thangor.$MDS$, array['Sombras Vindas do Tempo']::text[], 'publicado', 'mestre'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Nota de Mestre — Fios da Trama (\"não ler\")');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='sombras-vindas-do-tempo'), A.id, 'campanha', 'Prelúdio Parte VI — Memórias de um Bardo', 'preludio-parte-vi-memorias-de-um-bardo', $MDS$> 📖 NARRATIVA (autoria do grupo). Preservado na íntegra.

> *Retornar para o Lar / Devo aqui ficar? / Vivo para seguir, / não para voltar...*
>
> *A estátua do Anão / Em glória estende sua sombra / Sobre muralhas de uma batalha antiga / De Goblins que assombraram aqui um dia / Nos tempos do Meio-Orc opressor...*
>
> *Mas os heróis aqui vieram / De suas histórias em Queda Escarpada / Aonde enfrentaram o Mago, Harpias / Mesmo um exercito de Kobolds, / por recompensas douradas...*
>
> *Venceram a guerra daquele tempo / Trouxeram boas notícias para essas terras / Que permaneceram por Eras / Histórias que espalham como vento...*
>
> *Querem ouvir mais desses contos? / Perguntem para o Bardo aqui presente*
>
> *A música ainda toca aqui pelo esforço de Althir / Mágicas ainda nos rondam como em agrestia / Porque Natã lutou e venceu com alegria / Thor derrubou-os com seu marchado / Enquanto Tharen dançava como a morte / Sim! Esse era o nome do seu arco...*
>
> *E o patrulheiro... / Seu arco descansa / Sua espada não tem mais fio / Ele dorme em uma noite sem fim / Talvez junto de heróis como Killoin...*

O público de Queda Escarpada ficou sem compreender o repentino silêncio do Bardo. O anão Killoin era o herói de uma de suas maiores cidades, morto em batalha. Era uma parte muito importante da música para todos que estavam ali presentes.

> *... Mas nos levantaremos / Sangue derramaremos, / O seu nome vingaremos / E um fim a esta guerra...*
>
> *Com espadas e magia / Adagas e arcos... Um fim / Um dia traremos...*

O fim da música arrebatou as pessoas de suas mesas em uma grande salva de palmas. Hans esvaziava sua mente cheia com o som ainda mais prazeroso da prata, do ouro e do cobre que lhe eram lançados. O povo de Jordânia sempre fora mão aberta, talvez seja esse o motivo de Hans adorar essa ilha.

— Essa sim é uma boa música, meu amigo...
— Eu a escrevi no caminho para cá – ver Natã abrir a porta da Taberna fora uma verdadeira surpresa – não o esperava aqui...
— É eu notei quando você parou a música de repente.
— Não foi por isso.
— Entendo... sei que Kane teria gostado bastante da parte que escreveu sobre ele.
— Tsc, ele provavelmente estaria bêbado dizendo que eu toco muito mal, o desgraçado mal sabia tocar o Alaúde que eu dei pra ele. Reclamar e fingir ser o líder eram suas melhores qualidades.
— Você devia dizer isso pra Lórien haha!
hahahaha!
— É bom ver você, veio para cá sozinho?
— Não, Tharen e Stulk estão lá fora...
— Se vieram me buscar, saiba que eu não entro no mesmo barco que aquele capiroto entrar.
— Deixe disso, Tharen já teria nos matado se quisesse. Ele nunca deixou de ser a moça que sempre foi. Ela só vive estressada agora hehe.
— Tsc., eu nunca vou confiar nesse cara de novo, ele quase me matou uma vez se você não se lembra!
— Baah! Não vamos discutir isso de novo... Precisamos ir. Você conseguiu o que precisávamos ou só ficou tocando e se embebedando por aqui?
— Eu posso muito bem beber, tocar e fazer missões ao mesmo tempo. Mas sim, eu consegui. Não é a melhor das embarcações, mas foi o melhor que o Prefeito conseguiu para nós. O barco zarpa para Dranor em dois dias.
— Perfeito, Thor Adin já está com Eric em Amon Tyr e de lá seguirão para Dranor. Althir, obviamente já está lá. O Rei aceitou nos ouvir, digamos que Drayco fez uma oferta que ele não poderia recusar.
— Amém... hehe., então vamos logo. O Taberneiro é conhecido meu, um antigo aluno da minha escola, mas, mesmo aqui, devemos evitar ficar no mesmo lugar por muito tempo.
— Vamos então.
LUZ AZUUUUL!!!!!!
O grito veio acompanhado com o Golias atravessando a porta da Taberna, arremessado por uma enorme bola de fogo. Natã e Hans se jogaram no chão, um reflexo muito bem ensaiado a bastante tempo. A taberna virou um caos, pessoas não sabiam se corriam ou se enfiavam de baixo das mesas.
Hans se arrastou para próximo do Golias, a fumaça cobria o rombo na frente da Taberna, mas o som de explosões se repetia por todos os lados.
— STULK! O QUE ESTÁ ACONTECENDO LÁ FORA?
— Huurr... Estão atacando a cidade! Catapultas, tropas, tudo... hurrr..
Tharen adentrou rapidamente a Taberno e ajudou Hans a colocar o gigante de pé. Natã já tinha encontrado outra saída de lá.
— Mas que diabos! Vocês acabam de chegar e já trazem tantos problemas!
— Acredite, estamos tão surpresos quanto vocês! Não havia sinal algum de tropas vindo para cá! Disse o Elfo enquanto carregavam o Golias.
— É ELÓDIA! PELOS DEUSES, COMO SOUBERAM QUE ESTAVAMOS AQUI? Gritou Natã enquanto saia da cozinha apontando para uma possível saída!
— Huuur... magos, por isso não os vimos chegar – o Golias estava acabado, mas conseguia andar amparado pelos companheiros.
— Não são catapultas, e provavelmente nem é uma tropa muito grande, VAMOS VAMOS! – Natã conhecia bem o jeito de Elódia.
Quando finalmente saíram da taberna, Natã guiou o grupo para as muralhas do outro lado da cidade. Parte da cidade já estava em chamas, pessoas tentavam salvar móveis, outros iam com escadas tentar tirar pessoas de andares ardentes. As forças da cidade preparavam uma defesa improvisada.
" POVO DE QUEDA ESCARPADA! Meu nome é Kalek Tanar – a voz do mago ecoava pela cidade como uma trovoada – sou subcomandante dos Hunters de Elódia e vocês guardam em sua cidade quatro fugitivos de Dagorcain, um Deva, um Golias, um elfo e um Bardo Humano. Os entreguem agora ou seremos obrigados a continuar o ataque!"
— Natã, pode nos falar um pouco sobre seus amigos? – pelo nome Hans já imaginava o tamanho do problema que eles estavam.
— Kalek Tanar... – a bastante tempo Natã não ouvia esse nome – ele e a sua organização são caçadores de Elódia.
— Hum, ótimo, eu não poderia imaginar afinal o nome deles não é nem um pouco sugestivo NÃO É MESMO?? – sobre pressão Hans adotava uma mistura de medo e sarcasmo odiáveis.
— A única coisa que vocês precisam saber é agora é que TEMOS QUE CORRER!
— Pessoal... – Stulk falou com dificuldade – parece que temos companhia...
Todos olharam para frente e montado sobre um cavalo estava um mago alto com um traje negro coberto de tecidos pintados de estrelas. Junto com ele, outros magos com cavalos começaram a cercar o grupo.
— Ora, ora, ora... Natã, meu querido amigo, nunca imaginei que as coisas terminassem assim.
— Kalek...
— Já que estamos todos nos apresentando, eu sou Hans o bardo e esses, como deve imaginar, são Stulk, o Golias burro, e Tharen o demônio encarnado.
— Sabemos muito bem quem vocês são. Seguimos os rastros do Elfo e Natã após aquela brincadeira deles em nossa caravana a caminho de Elódia. Pensei que eu o tinha treinado melhor, Natã.
— Porque não deixa de conversa mole e tenta logo nos prender? – Disse Stulk com sua paciência esgotada.
— Percebe, ai é que está o problema. Não estamos atrás de prisioneiros, na verdade, não poderíamos deixá-los viver com as informações que andaram colhendo pelo continente, especialmente a conversa que ouviram naquela carruagem a alguns meses.
— Os Hunters não são guardas, são assassinos, pessoal...
— Então espero que eles sejam bons no que fazem, pois vão precisar! – Disse Tharen antes de invocar uma muralha de espinhos para cima dos cavalos.
Natã não se conteve, entendo o nível da situação, estava se preparando para invocar sua conhecida foice de raios, quando um vento forte soprou sobre eles e uma baforada de gelo cobriu os cavaleiros inimigos.
Ao olharem pra cima, um dragão branco passa em voo raso.
— É ALTHIR! – Gritou Tharen.
O Paladino saltou do Dragão quando ele estava mais próximo chão. Os cavaleiros haviam caído, mas já se recuperavam quando Althir tomou todos pelo braço e simplesmente desapareceram...

— Senhor... por favor, ajude...
O jovem mago estava parcialmente congelado, não sobreviveria. Kalek lhe deu um golpe de misericórdia. Ele não era um Hunter, apenas mais um acólito.
— Os desgraçados fugiram...
— O que faremos agora, senhor?
— Destruam o resto da cidade, matem todos. Nada que aconteceu aqui pode chegar a Dagorcain.
— Mas senhor, isso não estava nos planos.
— Planos mudam, e ninguém pode duvidar da capacidade de Elódia.
— Sim senhor.
Ninguém escapa dos Hunters, não por muito tempo...$MDS$, array['Sombras Vindas do Tempo']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Prelúdio Parte VI — Memórias de um Bardo');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='sombras-vindas-do-tempo'), A.id, 'campanha', 'Prelúdio da próxima Mestragem — Parte II: O Paladino Maculado', 'preludio-da-proxima-mestragem-parte-ii-o-paladino-maculado', $MDS$> 📖 NARRATIVA (autoria do grupo). Preservado na íntegra.

A lua brilha no céu maior do que nunca, ela governa as humildes estrelas ao seu redor. Além disso só há escuridão e a respiração feros de uma besta.
— Aonde estou? - Não consigo enxergar arvores, não sinto grama sob meus pés, apenas... apenas... sangue!
De novo, estou aqui de novo. Meus pés estão mergulhados em sangue - minha culpa. Nossa culpa.
Posso ouvir o seu ruído, a carne sendo dilacerada. Noto sua presença em todos os lugares, ela dança ao meu redor uma balada de morte. Seu vulto é rápido e o cheiro é nauseante. Mas lá estão todos eles - de novo. A cabeça do Rei sobre seu corpo, sentado sobre um trono do ossos.
Posso ver Quiryion, a rainha Nienor, os Magos de Elódia, o Comandante de Dranor. Estão todos ali, banhados em sangue. Suas entranhas serpenteiam a água vermelha; e no centro de tudo isso está ela, bela, banhada pela luz do luar. Seus cabelos negros cobrem os seios nus, e o sangue esconde sua virtude. Ela está sorrindo, o mesmo sorriso daquele dia.
— Como deixei isso acontecer?... Como?!... COMO?! - Algo está segurando minha perna - Kane? - não pode ser, seu rosto está desfigurado, a espada ainda presa em seu peito. Ele se arrasta como uma criatura tumular.
— Nós perguntamos o mesmo, velho amigo, como você deixou isso acontecer?! - sua voz gutural o torna mais irreconhecível, mas sei que é ele. Alguma coisa segura meu braço!
— Não! Vocês estão mortos! - a gargalhada de Aredhel é ensurdecedora - ME SOLTEM! VOCÊS ESTÃO MORTOS! TODOS! - Sim, eles estão, por minha culpa...

— Althir! Althir! Acorde! - a voz do dragão é forte o bastante para acordar um vampiro durante a hibernação - Althir! Você está sonhando!
Minha cabeça dói, a meses não acordo de maneira diferente, sempre com essa forte dor de cabeça.
— Viseryon, fale baixo! - não importa o quão baixo ele fale, é um maldito dragão.
— Esse pesadelo está se tornando cada vez mais freqüente, não é ? - a língua dos dragões é difícil de se entender quando eles falam. É diferente de qualquer humanóide que finge ser um mestre na língua - você deve parar de beber tanto!
— E você deve parar de ser um dragão! Isso é possível? - já devia ter me acostumado. Essa droga de vento vai acabar arrancando meu rosto fora. - Ao invés de bancar a minha mãe, porque não voa mais devagar?

Os dias sempre são mais difíceis. Viver nas sombras é difícil, com dragões como babás então, pelos nove infernos! Mas era isso ou os calabouços de Elódia, ou pior. Aonde fui chegar? Sempre me pergunto, o que minha ordem pensa de mim? Devo confiar que eles conheciam minha honra, e acreditariam na minha inocência? Mas no fim eu sou culpado.
A mais de um ano tenho fugido, e isso só me convence mais de meus erros. Por anos servi minha ordem, sem questionar, sempre fiel. Busquei ser justo em minhas decisões, busquei ser sábio e cuidadoso para com meus companheiros. Fui severo ao escolher e confiar nas pessoas. Mas nada disso foi o bastante, e agora, o continente paga porque eu não fui capaz de perceber quem ela era.
Afogo minha cede de vingança em bebida, ou nessas coisas que os dragões chamam de vinho. Consigo algo decente mesmo só quando os convenço de sair e fazer meus serviços. Ao menos quando recebo contratos mato um pouco de minha cede. Mas ela nunca será satisfeita, não enquanto Aredhel respira.

— Você quase foi pego dessa vez! Elódia tem olhos em todos os lugares, principalmente agora que seus magos fazem parte da Corte de Dranar. Nós te avisamos, se queres dar seus passeios, vá para o norte! - nem o barulho do vento consegue ser pior que a voz de um dragão. Deuses!

— Era apenas um guarda, e nem deu tanto trabalho, para um mago - na verdade meus dedos ainda estão dormentes por causa daqueles malditos raios, ou será apenas a bebida? - vocês são dragões, como podem se preocupar?
— Estamos aguardando o momento certo, e suas saídas podem comprometer tudo! É com isso que nos preocupamos!
— Viseryon, você sabe que não consegue esconder esse seu amor, né?
— Cale a boca!

Tsc. Dragões... mas ele tem razão. Elódia tem a maior parte das cidades de Dranar, agora. Com os anões do leste taxados de traidores, nenhuma das casas anãs é de confiança, e Elódia assumiu todas as cidades que antes estavam sobre domínio dos anões na Corte das Cidades Bestiais. Sem falar é claro do Reino Leste está sendo comandado pelos malditos magos. Enquanto seu rei por direito vive como um refém, por mais bem tratado que ele seja.
Mas foi muito conveniente para Elódia. Afinal, o que são três magos, supostos líderes, em troca da expansão de seu poder, algo que eles anseiam a séculos! Eles sabiam, de alguma forma eles sabiam.
Elódia, doppelgangers... Quiryon sabia que havia algo estranho nisso tudo.
— Althir! Tenho notícias.
— Sou todo a ouvidos! - minha cabeça vai explodir!
— Thor Adim fugiu das forjas do Reino Anão Leste! Acreditam que o filho Durín, Thórin, o ajudou na fuga. Agora o príncipe Anão está nos calabouços, parece que o fizeram tomar o lugar daquele que escapou. - Por Bahamut! Será isso verdade?
— Vocês tem certeza?
— Sim, também temos notícias de seus outros companheiros.
— Terá finalmente chegado a hora?
— Talvez. Lord Drayco nos ordenou que levássemos você até ele. Exar Khun também se movimenta, tememos que ele tenha descoberto o paradeiro das ultimas chaves. Aredhel lidera uma tropa que segue para a região dos Bárbaros.
Finalmente, depois de dois anos, jurei pelos deuses que iria matá-la, que faria seu sangue escorrer.
— Então devemos encontrar os outros. É chegada a hora!$MDS$, array['Sombras Vindas do Tempo']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Prelúdio da próxima Mestragem — Parte II: O Paladino Maculado');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='sombras-vindas-do-tempo'), A.id, 'campanha', 'Prelúdio da próxima Mestragem — Parte III: O Mago', 'preludio-da-proxima-mestragem-parte-iii-o-mago', $MDS$> 📖 NARRATIVA (autoria do grupo). Preservado na íntegra.

O som das ferraduras contra a estrada se torna algo detestável após dois dias de viagem. O balançar da carruagem começa a dar náuseas, o traseiro fica dormente. "Báah! Acho que é como dizem, depois que temos o que queremos deixa de ser brilhante."
— Ei rapaz! Dá pra fazer essa joça andar mais rápido! - malditos cavalariços. Lentos, bobos, medrosos. Bom, pelo menos não sou eu quem está guiando os cavalos.
— Tudo ficou mais fácil após a expansão. O Conselho Vermelho, por mais bizarro e inesperado, acabou sendo a benção que Elódia aguardava a séculos. Com os Anões do Leste taxados de traidores, todas as Grandes Cidades Anãs perderam seus lugares na Corte das Cidades Bestiais, e passaram seus domínios para nós. E a morte de Quiryon StormBorn também nos rendeu um grande lucro. Haha! Quem diria que os Trade um dia acabariam auxiliando o Reino dos Magos!
— Sim, sim, sei bem como as coisas funcionaram. O que me admira é como a morte de três Líderes do Supremo Militar Elodiano tenha passado tão desapercebido por causa dos "lucros". Me parece muito conveniente, tudo isso, para falar a verdade.
— Bom, o que posso dizer? Hehe - disse Ardinas com sua costumeira piscadela.
— Hum, pode dizer que Morcul e Elódia são mais parecidas do que se imagina.
— Cuidado com o que fala, Kal - ele ficou irritado como previsto - Há! Tinha me esquecido dessa sua língua solta. Hahaha! - O mago gordo desatinou a rir. O vinho forte certamente tinha surtido efeito - Agora, vamos! Me diga! Como estão as coisas em Primus? O que aquele lugar conseguiu fazer com você nos últimos quatro anos? Dizem que as putas de lá fazem um mercenário esquecer seus contratos! Hehe!
— Primus tem suas peculiaridades, certamente as putas são uma delas, mas elas não conseguiram me fazer esquecer de minha missão. - não com aquele ajudante inútil que me deixaram me lembrando todos os dias.
— E então? O que conseguiu?
"Muita dor de cabeça seu gordo idiota"
— Pouca coisa, essa organização é mais ardilosa e escorregadia do que esperávamos. São astutos, só consegui descobri o que eles permitiram que descobríssemos.
— Rum, entendo, hehe, parece que nem o grande Kalek Tanar foi páreo para os ShadowRiders, ham? Hahaha! - a risada deveria estar infernizando até os cavalos.
— Não, eles são diferentes dos Doppelgangers de DagorCain. Não se trata de clãs, mas de uma organização equivalente a um Reino que vive na sombra política de Primus. São comparáveis aos Mãos de Prata, antes dos últimos acontecimentos, claro.
Ainda era difícil acreditar que um homem, por mais poderoso que seja, tenha tomado o controle de uma das maiores organizações do continente, até então sequer sabíamos aonde os Mãos de Prata se escondiam.
— É, você perdeu bastante coisa, Kal. Mas não se preocupe, saberá de tudo quando chegarmos a Elódia. Uma reunião nos aguarda. Desculpe ter demorado para me unir a sua comitiva, mas sabe como é, não consigo passar por Xablau sem visitar uma Vômito de Dragão e suas moças. Hehe! E não consigo viajar sem minha Carruagem.
Elodianos, tsc. Agora que o Reino Anão Leste está em suas mãos, acreditam que podem restabelecer um reino dos Magos. Não só o Reino Anão, mais, pelo menos, cem cidades ao Sul. Saber que eu estava espionando um grupo contratado por Elódia foi realmente um choque - até pra mim. Dessa vez eles realmente conseguiram guardar um segredo. Mas Elódia não entende com quem eles estão se metendo. Acredito que eles estão enganados sobre quem está usando quem.
— Mas me diga Kal, ouvi dizer que descobriram algo importante!
— Sim descobrimos algo. Um nome para falar a verdade, "Barahir Yondur". É uma língua antiga, uma vertente Dracônica perdida. Significa: O Soberano Dominador.
— Isso deve significar algo para mim? hehehe.
— Deveria! Para um suposto mago elodiano. Na primeira Era houve um Barahir, de acordo com os contos antigos, no Período da Era dos Dragões, seu nome era Barahir Vondur, o Soberano Libertador.
— Os contos da Era dos Dragões estão perdidos, pouquíssimos restam em nossas bibliotecas. Não me interesso por essas coisas.
— Deveria saber que nem todos estão perdidos, Ardinas. Acredito que os Meiji ainda possuam grandes conhecimentos escondidos sobre esse período. Acontece que esse nome é comentado no submundo de Primus com muita freqüência. Sempre acompanhado com contratos e pedidos de aliança. Talvez em Edo encontremos mais alguma coisa.
— É mas o malditos olhinhos puxados não permitem que nenhum "estrangeiro" conheça seus costumes, segredos. Veja só, "Estrangeiros"! Eles se mudaram para esse continente até depois do povo de Dranor. Eles sim são os estrangeiros. Se não possuíssem mulheres tão bonitas, há! Não continuariam por aqui, não se eu pudesse opinar sobre esse assunto! Haha.. - o riso gultural de Ardinas acabou sendo cortado pelo solavanco da carruagem - HEI! O QUE DIABOS ESTÁ FAZENDO AI!
Kalak colocou o rosto para fora e desferiu um insulto contra o cavalariço. Até então não tinha notada o corvo em seu ombro azul. "Azul?"
— Não sabia que estavam tão cheios Devas a seus serviços, a ponto de usá-los como guias para os cavalos.
— E não estamos. Deva? Que Deva? Lorél é um humano como eu! Hei Lorél, pare esta carruagem e desça até aqui! - não ouve resposta, apenas mais um grande solavanco e uma forte luz.
Os guardas gritavam comandos e pragas, e as outras pessoas estava assustadas, tal qual os cavalos. Kalek desceu rapidamente com seu cajado em punho, mas quando chegou era tarde. O cavalariço desaparecera.
— O que pelos nove infernos aconteceu aqui?!
— Não sabemos ao certo, senhor!! - a resposta não o agradou.
— COMO NÃO SABEM?! O QUE VIRAM?!
— O pássaro, Senhor, o corvo! Ele se transformou em... um tigre enorme senhor, negro! - "um druida" - o cavalariço lançou um Raio em forma de dragão contra nós - um Raio trovejante, provavelmente um feiticeiro - subiu na águia e eles fugiram! Dois de nossos homens foram atingidos, um dos cavalos morreu e...
— Chega! Já ouvi o bastante.
"Um druida, e pelo tipo de magia, um Raio Trovejante aparentemente, um Feiticeiro."
Ardinas estava saindo desajeitado da carruagem. Engasgado com a bebida, e boca suja de comida.
— Você sabe do que se trata, Ardinas?! Eles provavelmente ouviram tudo o que falamos!
— Sim. Malditos! Cof, cof. Um Deva não é? Cof, cof. Devem ser Natã e o Elfo Negro, Tharen. Foragidos de Elódia!
— Natã?! - Um nome difícil de se esquecer...$MDS$, array['Sombras Vindas do Tempo']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Prelúdio da próxima Mestragem — Parte III: O Mago');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='sombras-vindas-do-tempo'), A.id, 'campanha', 'Sombras Vindas do Tempo — Documento de Campanha', 'sombras-vindas-do-tempo-documento-de-campanha', $MDS$> 🗒️ DOCUMENTO DE MESTRE (desenho de campanha, autoria do grupo). Preservado na íntegra.

## Contexto
- **QUANDO:** (MISTÉRIO) 550 anos após o fim da Guerra das Cinco Chaves.
- **ONDE:** (MISTÉRIO) Dagorcain – O Escudo de Gelo (Montanhas de Ferro).
- **QUEM:** Cavaleiros reunidos no festival de inverno do Barão Blod, Lorde do Castelo Congelado.
- **CONTRA:** Ceita dos Eródianos (releitura do termo Elódia).
- **MITOLOGIA:** (MISTÉRIO) O mundo decaído, dividido em feudos espalhados sobre ruínas de antigos reinos, agora desconhecidos (Dagorcain).

## Lugares
- **Guerilla** – todo o mundo conhecido. Em Old'agor é conhecida como Vore'sDor.
- **A Terra dos Reis** – região ao norte das terras conhecidas, entre o Escudo de Gelo e o Rio de Gelo, fazendo fronteira com as Terras Proibidas ao Sul, a Floresta Imensa a Leste e o Mar do Poente a Oeste. Há aldeões que arriscam as regiões no entorno das Terras Proibidas, proclamadas por poucos Barões, produtivas mas sob ataques constantes dos Selvagens.
- **Old'agor** – região do extremo sul, próximo às praias brancas, de onde vêm caravanas. Habitada por povos estranhos; dizem que ali jazem os últimos anões e outras raças demoníacas cuja existência fere A Religião.
- **O Castelo Congelado** – antiga construção aos pés das montanhas Escudo de Gelo, na Terra dos Reis; ninguém sabe quem o construiu. Salões guardados a chave; poucos bardos e trovadores têm acesso para estudos.
- **Vila Velha** – antiga aldeia povoada, na encruzilhada da Estrada dos Elfos. **Lady Érica** é senhora da cidade e afirma descender dos altos elfos.
- **As Ruínas dos Altos** – no extremo norte, próximo aos abismos de gelo; labirintos gigantescos no gelo, atribuídos a gigantes de outrora. Boatos de que o lugar é amaldiçoado pelos poderes antigos.
- **As Terras Proibidas** – ao sul das Escudo de Gelo, terra deserta e amaldiçoada; habitada por humanos selvagens/bárbaros em contato com os poderes antigos e criaturas distorcidas.

## Mythos
- **Poderes Antigos** – entidade cultuada por selvagens e cultos secretos (prática punida com a morte na Terra dos Reis).
- **A Religião** – resquício de um antigo credo; seguida pelos Últimos Paladinos e a Ordem Monástica dos Ancestrais.
- **O Velho Mundo** – todos os resquícios (ruínas, murais, artefatos) de um período perdido; uma guerra titânica assolou Guerilla, com mortes e pragas atribuídas aos "Poderes Antigos".
- **Vore'sDare** – habitantes de Old'agor; na Terra dos Reis chamados pejorativamente de **Mixta** (Miscigenados). Creem ser resquício do Velho Mundo; carregam o sangue com orgulho e veem os últimos Feéricos como graça. Temem os Poderes Antigos (O'gûl) sem apelar a penas capitais.

## Organizações
- **D'Sangue** – elite da Terra dos Reis (Barões e famílias, exceto Lady Erica/Vila Velha). Creem descender dos Grandes Homens.
- **Ordem Monástica dos Ancestrais** – clero da Religião; guarda conhecimentos e ritos. Todo Barão carrega um Monge e seus guerrilheiros (Últimos Paladinos).
- **Últimos Paladinos** – elite militar da Religião, a serviço da Ordem. Vistos como zelotes sanguinários; têm autoridade sobre a guarda comum. Cavaleiros só são nomeados em sua presença.
- **Ceita dos Eródianos** – culto nascido dos ritos selvagens. Um estudioso D'Sangue estudou os Poderes Antigos e aliou-se a um xamã selvagem para adentrar as Terras Proibidas. Poucos feiticeiros, mas com magia perigosíssima.

## Roteiro — Atos
- **I – Ato:** A Fronteira de Gelo
- **II – Ato:** (a definir)
- **III – Ato:** (a definir)

## Prólogo: O Ocaso da Encruzilhada
A Hospedaria Encruzilhada fica onde a estrada Élfica e a estrada dos Grandes se cruzam, a algumas milhas de Vila Velha. Conhecida por sua cerveja ancestral e pela anfitriã **Marie Dragão Forte**. No inverno, fica pouco movimentada. Naquela noite, porém, não foi Marie quem recebeu os viajantes: ela jaz morta no porão, sob os galões de cerveja.

Em seu lugar no balcão, um indivíduo (que se diz sobrinho de Marie) e seu parceiro observam os que chegam, em busca de um ladrão chamado **Flint**, responsável pela morte de seu irmão — que diziam preso e sendo escoltado à Hospedaria. São surpreendidos quando chega um Cavaleiro Andante acompanhado de um Paladino.

O que ninguém sabe é que a morte de Marie — na verdade uma Feiticeira — engatilhou uma revolução que aguardava o menor sinal para incendiar Guerilla.

## Argumento
**Velás Erik**, sobrinho de Lady Erika, apossou-se das terras no baixio Norte do Rio de Gelo (menos pedregosas e boas para plantio). A região é disputada entre os pequenos lordes. Mas Velás teve empregados assassinados a mando de **Edduim Atomius**, genro de Urias Blodmor (filho do Barão Blodmor, dono por direito das terras do norte do Rio de Gelo).

O Barão envia forças para resolver a situação preservando boas relações com Lady Erika e Vila Velha. O aniversário de sua neta, **Valery Blodmor**, será celebrado com um **Torneio de Inverno**; os destaques serão considerados para o grupo de policiamento do conflito, liderado por um Paladino do Castelo Congelado.

Edduim Atomius e a esposa **Elwyn** são guiados pelo conselheiro **Yussef**, um Erodiano cujo plano é desviar a atenção dos Barões para facilitar a ação de sua seita.$MDS$, array['Sombras Vindas do Tempo']::text[], 'publicado', 'mestre'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Sombras Vindas do Tempo — Documento de Campanha');

insert into publicacoes (mundo_id, mesa_id, autor_id, tipo, titulo, slug, corpo, tags, estado, visibilidade)
select M.id, (select id from mesas where slug='sombras-vindas-do-tempo'), A.id, 'campanha', 'Campanha Anterior — \"Sombras Vindas do Tempo\', 'campanha-anterior-sombras-vindas-do-tempo', $MDS$> Pasta da campanha que antecede "Ecos na Cidade dos Corvos". Reúne o documento de desenho da mestragem e os textos narrativos da saga de **Althir Alcarin** e os **Guardiões Cegos** (ligada ao "Conselho Vermelho", à traidora **Aredhel**, a **Elódia/Ceita dos Eródianos** e ao dragão **Viseryon**). Material de referência — não é o cânone vigente de Ecos.

## Conteúdo
- **Sombras Vindas do Tempo** — documento de desenho da campanha (contexto, mythos, organizações, roteiro).
- **Arco 1 - A Aliança** — abertura narrativa (reencontro do grupo mercenário em Tordesilhas).
- **Prelúdios da próxima Mestragem (II, III, VI...)** — narrativa serializada de Althir e Viseryon.$MDS$, array['Sombras Vindas do Tempo']::text[], 'publicado', 'mesa'
from (select id from mundos where slug='mares-de-sangue') M, (select id from profiles order by criado_em limit 1) A
where not exists (select 1 from publicacoes p where p.mundo_id=M.id and p.titulo='Campanha Anterior — \"Sombras Vindas do Tempo\');
