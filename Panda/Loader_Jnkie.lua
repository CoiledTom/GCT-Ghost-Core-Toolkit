-- CoiledTom Key System | Loader: Jnkie (Public SDK)
-- Docs: https://docs.jnkie.com/roblox-sdk/public-sdk

local CORE_URL = "https://raw.githubusercontent.com/CoiledTom/GCT-Ghost-Core-Toolkit/refs/heads/main/main.lua"

local JNKIE = {
	Service    = "", -- nome ou ID do servico (painel Jnkie)
	Identifier = "", -- SEU user ID na Jnkie (nao e o ID do jogador nem do Discord)
}

-- ========== Adapter Jnkie (nao precisa editar) ==========
local JunkieSDK
local function getJunkieSDK()
	if JunkieSDK then return JunkieSDK end
	local ok, sdk = pcall(function()
		return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
	end)
	if ok and type(sdk) == "table" then
		sdk.service = JNKIE.Service
		sdk.identifier = JNKIE.Identifier
		JunkieSDK = sdk
		return sdk
	end
	return nil
end

local function JnkieAdapter(key)
	if JNKIE.Service == "" or JNKIE.Identifier == "" then
		return { ok = false, status = "not_configured" }
	end
	local sdk = getJunkieSDK()
	if not sdk then return { ok = false, status = "network", message = "Falha ao carregar o SDK da Jnkie." } end

	-- check_key pode lancar excecao (rede/decodificacao): por isso o pcall
	local ok, res = pcall(sdk.check_key, key)
	if not ok then return { ok = false, status = "network", message = "Falha na validacao. Tente novamente." } end
	if type(res) ~= "table" then return { ok = false, status = "malformed" } end

	if res.valid then
		return { ok = true, status = "valid", message = res.is_premium and "Key Premium validada!" or "Key validada com sucesso!" }
	end

	-- res.error: codigo de validacao ou erro gerado pelo SDK (ex.: "http 429", "RATE_LIMITTED")
	local err = tostring(res.error or "")
	if err == "RATE_LIMITTED" or err == "http 429" then
		return { ok = false, status = "error", message = "Muitas tentativas. Aguarde e tente novamente." }
	end
	return { ok = false, status = "invalid", message = "Key inv\u{E1}lida (" .. err .. ")." }
end

-- ========== Configuracao da GUI ==========
local env = type(getgenv) == "function" and getgenv() or _G
env._CoiledTomConfig = {
	Name     = "CoiledTom Hub",
	Subtitle = "Key System",

	Author = { Name = "CoiledTom", Image = "" },

	-- "obsidian" | "natal" | "halloween" | "crimson" | "candy" | "sakura" | "black" | "white" | "gold" | "ocean" | "forest" | "cyberpunk" | "royal" | "mono"
	Theme = "obsidian",

	Window = { Transparency = 0 }, -- 0 = opaco ... 0.9 = quase transparente

	ExecutorImages = {
		Enabled = true,
		Repo = "CoiledTom/GCT-Ghost-Core-Toolkit",
		Branch = "main",
		Fallback = "erro",
		Folder = "CoiledTom_KeySystem",
	},

	Orbit = { MinimizedGap = 5, MinimizedSpeedMul = 2.6 },

	KeyProviders = {},

	Validation = { Timeout = 12, Adapter = JnkieAdapter },

	RequireKeyToExecute = true,
	OnExecute = function()
		-- seu script principal aqui
	end,

	Credits = {},
}

loadstring(game:HttpGet(CORE_URL))()
