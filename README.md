# CoiledTom Key System

Painel de autenticação (Key System) para Roblox, com visual escuro, esferas orbitais animadas, temas de cor e suporte a três provedores de Key: **Panda Auth**, **Luarmor** e **Jnkie**.

---

## Estrutura do projeto

```
GCT-Ghost-Core-Toolkit/
├── main.lua                  <- o painel inteiro (GUI, animações, lógica). Não precisa editar.
├── README.md
├── LICENSE
├── Panda/
│   └── Loader_Panda.lua      <- use se sua Key estiver na Panda Auth
├── Luarmor/
│   └── Loader_Luarmor.lua    <- use se sua Key estiver na Luarmor
└── Jnkie/
    └── Loader_Jnkie.lua      <- use se sua Key estiver na Jnkie
```

Você só edita o **Loader** do provedor que escolher. Ele define a configuração e carrega o `main.lua` pelo link raw.

---

## Como usar

1. Suba o projeto no seu repositório do GitHub.
2. Abra o Loader do seu provedor e preencha:
   - `CORE_URL`: link **raw** do `main.lua` (já aponta para o repositório `CoiledTom/GCT-Ghost-Core-Toolkit.`; troque se for outro).
   - As credenciais do provedor (ver a seção do provedor abaixo).
   - A configuração visual em `env._CoiledTomConfig`.
3. Confirme que o link raw abre no navegador antes de distribuir.
4. Distribua o link raw do **Loader** para os usuários:
   ```lua
   loadstring(game:HttpGet("https://raw.githubusercontent.com/SEU_USUARIO/SEU_REPO/main/Panda/Loader_Panda.lua"))()
   ```

---

## Configuração geral

Tudo fica dentro de `env._CoiledTomConfig` no Loader. Campos não informados usam o padrão do `main.lua`.

### Nome, autor e tema

```lua
Name     = "CoiledTom Hub",
Subtitle = "Key System",
Author   = { Name = "CoiledTom", Image = "" },
Theme    = "obsidian",
```

- `Author.Image` vazio: o painel procura `Autor.png`, `Autor.webp` ou `Autor.jpg` no repositório configurado em `ExecutorImages`.
- Se `Author.Name` estiver preenchido, o subtítulo mostra "por CoiledTom".

**Temas disponíveis** (escolha um em `Theme`):

| Tema | Aparência |
|------|-----------|
| `obsidian` | padrão. Preto/grafite com violeta e laranja |
| `natal` | vermelho e verde sobre base escura |
| `halloween` | laranja e roxo sobre preto |
| `crimson` | vermelho e grafite |
| `candy` | rosa e ciano |
| `sakura` | rosa claro e violeta suave |
| `black` | preto puro com cinza claro |
| `white` | tema claro |
| `gold` | preto com dourado |
| `ocean` | azul profundo e ciano |
| `forest` | verde esmeralda sobre grafite |
| `cyberpunk` | magenta e ciano neon sobre preto azulado |
| `royal` | azul/roxo real com detalhes dourados |
| `mono` | cinza/grafite neutro, quase sem cor |

Só o dono do script escolhe o tema. Não existe seletor dentro da GUI. As cores de cada tema ficam em `Config.Themes` no `main.lua`.

### Transparência da GUI

```lua
Window = { Transparency = 0 },
```

- Valores aceitos: de `0` (opaco) até `0.9` (quase invisível). Valores fora do intervalo são limitados automaticamente.
- Afeta apenas o fundo do painel. Textos, botões, ícones e esferas continuam sólidos.

### Órbita e velocidade

```lua
Orbit = { MinimizedGap = 5, MinimizedSpeedMul = 2.6 },
```

- `MinimizedGap`: distância em pixels entre a borda da bolha principal e as esferas quando a GUI está minimizada (padrão: `5`).
- `MinimizedSpeedMul`: velocidade de rotação das esferas quando minimizado. `1` = mesma velocidade do painel aberto; valores maiores giram mais rápido (padrão: `2.6`).
- Com a GUI aberta, a disposição e a animação das esferas não mudam.

### Esferas orbitais

```lua
Spheres = {
    { Name = "Mapa",     Image = "auto:game"     },
    { Name = "Jogador",  Image = "auto:player"   },
    { Name = "GUI",      Image = "",             UseBrand = true },
    { Name = "Executor", Image = "auto:executor" },
},
```

- `Image` aceita `"auto:game"`, `"auto:player"`, `"auto:executor"`, um ID de imagem do Roblox (`"rbxassetid://ID"` ou apenas o número) ou um `rbxthumb://...`.
- Para adicionar ou remover uma esfera, inclua ou apague um item da lista. Elas se redistribuem sozinhas. `Orbit.PerRing` define quantas cabem por anel.

### Imagens do executor

```lua
ExecutorImages = {
    Enabled = true,
    Repo = "CoiledTom/GCT-Ghost-Core-Toolkit.",
    Branch = "main",
    Fallback = "erro",
    Folder = "CoiledTom_KeySystem",
},
```

- O painel baixa a foto do executor detectado a partir do repositório (ex.: `Delta.png`, `Synapse_Z.webp`). Sem foto, usa `erro`.
- Formatos aceitos: PNG, WEBP e JPEG.
- Precisa de `writefile` e `getcustomasset` no executor. Sem eles, mostra o ícone padrão.
- O `.` no final de `Repo` faz parte do nome do repositório.

### Links para pegar a Key (Get Key)

```lua
KeyProviders = {
    { Name = "Meu Site", Url = "https://...", Icon = "link" },
    { Name = "Discord",  Url = "https://...", Icon = "link" },
},
```

- **0 links**: o botão mostra um aviso de erro.
- **1 link**: o clique abre o link direto.
- **2 ou mais links**: o clique abre um dropdown para escolher.

### Créditos

```lua
Credits = {
    { Name = "CoiledTom", Role = "Owner", Image = "", Icon = "owner", Link = "https://..." },
},
```

Roles reconhecidos com cor e ícone próprios: `owner`/`creator`/`criador`, `scripter`/`dev`/`developer`, `ui designer`/`designer`, `tester`/`qa`, `support`/`suporte`. Outros roles usam o estilo padrão.

### Execução automática

```lua
RequireKeyToExecute = true,
AutoExecute = true,
```

- `AutoExecute = true` (padrão): assim que a Key é validada, o painel executa o script automaticamente, com a animação e o som de Execute — sem precisar clicar em nenhum botão.
- `AutoExecute = false`: mostra o botão "Execute" depois da Key validada, e o usuário clica para rodar.
- `RequireKeyToExecute = false`: libera o botão "Execute" imediatamente, sem exigir Key.

### Seu script principal

```lua
OnExecute = function()
    -- seu script aqui
end,
```

Roda uma vez, **depois** de uma Key validada (com `RequireKeyToExecute = true`) ou imediatamente se `RequireKeyToExecute = false`. A função não recebe a Key como argumento.

---

## Key salva automaticamente (cache local)

Ao validar uma Key, o painel a salva em um arquivo dentro da pasta `ExecutorImages.Folder` no executor do usuário. Na próxima execução:

1. Lê a Key salva e tenta validar sozinho, sem mostrar nada.
2. Se ainda for válida, entra direto.
3. Se estiver inválida ou expirada, avisa e deixa o campo pronto para uma nova Key. A nova Key validada substitui a antiga.

O vínculo da Key ao dispositivo (HWID) é feito pelo próprio provedor. O cache só evita que o usuário digite a Key de novo no mesmo aparelho. Como a validação roda a cada execução, o Jnkie recomenda não chamar `check_key` repetidamente; aqui ela é chamada uma vez por execução.

Requer `writefile`, `readfile`, `isfile` e `makefolder` no executor. Sem essas funções, o cache fica desativado e a Key é pedida a cada execução.

---

## Provedor: Panda Auth

**Arquivo:** `Panda/Loader_Panda.lua`
**Documentação oficial:** https://pandauth.com/docs/for-developers/pusl-v4

### Método 1: Panda-RBLX SDK (PUSL-V4)

**Como funciona:** o Loader baixa a biblioteca em `https://secure.pandauth.com/pv4/lib`, chama `configure` com o Service ID e depois `validate(key)`. A comunicação é só HTTP, sem WebSocket, então funciona em executores móveis como o Delta Android.

**Quando usar:** é o método para Keys da Panda Auth em Roblox. É o único método da Panda implementado neste projeto.

**Configuração necessária:**

Obtenha o **Service ID** no dashboard da Panda Auth, no seu serviço, e preencha:

```lua
local PANDA = {
    ServiceId = "SEU_SERVICE_ID",
}
```

O Service ID é público e pode ficar no Loader. Nunca coloque chaves administrativas da Panda aqui.

**Exemplo de código (adapter do Loader):**

```lua
local function PandaAdapter(key)
    local lib = getPUSL()
    if not lib then
        return { ok = false, status = "network", message = "Falha ao carregar a biblioteca da Panda." }
    end

    local ok, result = pcall(lib.validate, key)
    if not ok or type(result) ~= "table" then
        return { ok = false, status = "malformed" }
    end

    if result.success then
        return { ok = true, status = "valid", message = result.isPremium and "Key Premium validada!" or "Key validada com sucesso!" }
    end

    -- reason: INVALID_KEY | RATE_LIMITED | NETWORK | NO_SERVICE | NO_KEY | NO_HTTP | IDENTITY | PROTOCOL
    if result.reason == "INVALID_KEY" then
        return { ok = false, status = "invalid", message = "Key inválida." }
    end
    return { ok = false, status = "error", message = "Falha ao validar (" .. tostring(result.reason) .. ")." }
end
```

**Erros comuns:**

| Mensagem / reason | Causa provável | Solução |
|-------------------|----------------|---------|
| `NO_SERVICE` | Service ID errado ou vazio | Confira o Service ID no dashboard |
| `RATE_LIMITED` | Muitas tentativas seguidas | Aguarde alguns instantes |
| `NETWORK` | Falha de conexão | Tente novamente; verifique a conexão |
| `NO_HTTP` | Executor sem função de HTTP | Use um executor compatível |
| "Falha ao carregar a biblioteca" | Sem acesso a `secure.pandauth.com` | Verifique a rede e tente de novo |

**Métodos da Panda não implementados neste projeto:** a documentação também lista o Panda-SDK V5 (para ambientes não-Roblox) e o V3 External. Eles não são usados pelos Loaders deste projeto.

---

## Provedor: Luarmor

**Arquivo:** `Luarmor/Loader_Luarmor.lua`
**Documentação oficial:** https://docs.luarmor.net/luarmor-user-manual-and-f.a.q (seção "Key Check Library")

### Método 1: Key Check Library (`check_key`)

**Como funciona:** o Loader carrega `https://sdkapi-public.luarmor.net/library.lua`, define `script_id` e chama `check_key(key)` antes de qualquer script protegido. A resposta vem em `code` e o painel mostra a mensagem adequada, sem kickar o usuário.

**Quando usar:** para validar a Key dentro da GUI antes de liberar o script. O HWID-lock é feito pela própria Luarmor.

**Configuração necessária:**

Obtenha o **Script ID** no painel da Luarmor (Projects, ou o hash no seu link de loadstring) e preencha:

```lua
local LUARMOR = {
    ScriptId = "SEU_SCRIPT_ID", -- 32 caracteres hexadecimais
}
```

**Exemplo de código (adapter do Loader):**

```lua
local function LuarmorAdapter(key)
    local lib = getLuarmorLib()
    if not lib then
        return { ok = false, status = "network", message = "Falha ao carregar a biblioteca da Luarmor." }
    end

    local ok, res = pcall(lib.check_key, key)
    if not ok or type(res) ~= "table" or type(res.code) ~= "string" then
        return { ok = false, status = "malformed" }
    end

    if res.code == "KEY_VALID" then
        return { ok = true, status = "valid", message = "Key validada com sucesso!" }
    end
    if res.code == "KEY_EXPIRED" then
        return { ok = false, status = "expired", message = "Esta Key expirou." }
    end
    if res.code == "KEY_HWID_LOCKED" then
        return { ok = false, status = "invalid", message = "Key vinculada a outro dispositivo. Resete o HWID." }
    end
    if res.code == "KEY_BANNED" then
        return { ok = false, status = "invalid", message = "Esta Key foi banida." }
    end
    if res.code == "KEY_INCORRECT" or res.code == "KEY_INVALID" then
        return { ok = false, status = "invalid", message = "Key incorreta ou inexistente." }
    end
    return { ok = false, status = "error", message = res.message or ("Falha na Luarmor (" .. res.code .. ").") }
end
```

**Erros comuns:**

| Código | Causa provável | Solução |
|--------|----------------|---------|
| `KEY_HWID_LOCKED` | Key vinculada a outro dispositivo | Resete o HWID pelo bot (`/resethwid`) ou pelo painel |
| `KEY_EXPIRED` | Key vencida | Gere ou renove a Key |
| `SCRIPT_ID_INCORRECT` | Script ID não existe ou foi apagado | Confira o Script ID |
| `SCRIPT_ID_INVALID` | Script ID com formato inválido | Use os 32 caracteres hexadecimais do painel |
| `INVALID_EXECUTOR` | Executor não suportado | Use um executor compatível |
| `SECURITY_ERROR` | Requisição barrada pelo Cloudflare | Tente novamente; se persistir, fale com a Luarmor |
| `TIME_ERROR` | Relógio do dispositivo incorreto | Sincronize a hora do sistema |
| `UNKNOWN_ERROR` | Falha no servidor da Luarmor | Tente mais tarde; contate o suporte da Luarmor |

**Método da Luarmor não implementado neste projeto:** o método de whitelist embutida (o script protegido recebe `script_key` e se valida sozinho). O `OnExecute` do painel não recebe a Key como argumento, então não há como passá-la ao loadstring protegido sem alterar o `main.lua`.

---

## Provedor: Jnkie

**Arquivo:** `Jnkie/Loader_Jnkie.lua`
**Documentação oficial:**
- https://docs.jnkie.com/roblox-sdk/public-sdk
- https://docs.jnkie.com/roblox-sdk/configuration-for-sdk

### Método 1: Public SDK (`check_key`)

**Como funciona:** o Loader carrega `https://jnkie.com/sdk/library.lua`, define `service` e `identifier` e chama `check_key(key)`. O retorno indica `valid`, `is_premium` e `error`.

**Quando usar:** para validar a Key dentro da GUI com a validação oficial da Jnkie.

**Configuração necessária:**

```lua
local JNKIE = {
    Service    = "NOME_OU_ID_DO_SERVICO", -- painel Jnkie: Dashboard > seu serviço > Configuration
    Identifier = "SEU_USER_ID_JNKIE",     -- seu user ID na Jnkie (NÃO é o ID do jogador nem do Discord)
}
```

**Exemplo de código (adapter do Loader):**

```lua
local function JnkieAdapter(key)
    local sdk = getJunkieSDK()
    if not sdk then
        return { ok = false, status = "network", message = "Falha ao carregar o SDK da Jnkie." }
    end

    -- check_key pode lançar exceção (rede/decodificação), por isso o pcall
    local ok, res = pcall(sdk.check_key, key)
    if not ok then
        return { ok = false, status = "network", message = "Falha na validação. Tente novamente." }
    end
    if type(res) ~= "table" then
        return { ok = false, status = "malformed" }
    end

    if res.valid then
        return { ok = true, status = "valid", message = res.is_premium and "Key Premium validada!" or "Key validada com sucesso!" }
    end

    local err = tostring(res.error or "")
    if err == "RATE_LIMITTED" or err == "http 429" then
        return { ok = false, status = "error", message = "Muitas tentativas. Aguarde e tente novamente." }
    end
    return { ok = false, status = "invalid", message = "Key inválida (" .. err .. ")." }
end
```

**Erros comuns:**

| Erro | Causa provável | Solução |
|------|----------------|---------|
| `service not set` | `Service` vazio | Preencha o nome ou ID do serviço |
| `identifier not set` | `Identifier` vazio | Preencha com o seu user ID da Jnkie |
| `http 429` / `RATE_LIMITTED` | Muitas requisições | Aguarde e tente novamente |
| `http 400` (ou outro `http`) | Configuração do serviço incorreta | Confira `Service` e `Identifier` |
| "Falha ao carregar o SDK" | Sem acesso a `jnkie.com` | Verifique a rede |

**Observações:**
- O `check_key` pode vincular a Key ao dispositivo e iniciar um timer no primeiro uso. Não o chame repetidamente para manter a sessão ativa.
- Expiração e outros dados (execuções, notas) não vêm do `check_key`. Eles são lidos pelas *runtime variables* do script protegido, o que não está implementado neste projeto.

**Métodos da Jnkie não implementados neste projeto:**
- `get_key_link`: o painel usa os links definidos em `KeyProviders`.
- `load_script`: o `OnExecute` do painel não recebe a Key, então o script protegido não pode ser carregado por essa função sem alterar o `main.lua`.

---

## Adicionando um novo provedor

Crie um Loader com um adapter que receba a Key e retorne esta tabela:

```lua
{ ok = true/false, status = "valid" | "invalid" | "expired" | "error" | "network" | "malformed" | "not_configured", message = "opcional" }
```

Depois coloque o adapter em `Config.Validation.Adapter` (ex.: `Validation = { Adapter = MeuAdapter }`). Não é preciso alterar o `main.lua`.

---

## Migração (de `Core.lua` para `main.lua`)

Se você usava versões antigas com `Core.lua`, troque em **todos** os Loaders:

```lua
-- antes
local CORE_URL = "https://raw.githubusercontent.com/.../main/Core.lua"
-- depois
local CORE_URL = "https://raw.githubusercontent.com/CoiledTom/GCT-Ghost-Core-Toolkit./refs/heads/main/main.lua"
```

---

## Erros comuns (geral)

| Sintoma | Causa provável | Solução |
|---------|----------------|---------|
| GUI não abre | `CORE_URL` errado ou repositório privado | Confirme que o link raw abre no navegador |
| Ícone padrão no lugar da foto do executor | Executor sem `writefile`/`getcustomasset`, ou sem arquivo no repositório | Verifique as funções do executor e o nome do arquivo |
| Botão "Get Key" mostra erro | `KeyProviders` vazio | Adicione pelo menos um link |
| "Validador não configurado" | Adapter ou ID do provedor vazio | Preencha o ID no Loader |
| Tema não aplicado | Nome do tema com erro de digitação | Use um dos nomes da tabela de temas (minúsculo) |

---

## Avisos importantes

- **Nunca** coloque chaves administrativas ou secretas de nenhum provedor no Loader. Ele roda no dispositivo do usuário, e qualquer conteúdo fica visível. Use apenas os IDs públicos de validação.
- Se mudar o repositório ou a branch, atualize `CORE_URL` e `ExecutorImages.Repo`/`Branch` em todos os Loaders.

---

## Licença

Este projeto é distribuído sob a licença MIT. Veja o arquivo [LICENSE](LICENSE).
