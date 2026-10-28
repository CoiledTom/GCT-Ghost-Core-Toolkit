-- CoiledTom Key System | Loader: Panda Auth (Roblox SDK, PUSL-V4)
-- Docs: https://pandauth.com/docs/for-developers/pusl-v4

local CORE_URL = "https://raw.githubusercontent.com/CoiledTom/GCT-Ghost-Core-Toolkit/refs/heads/main/main.lua"

local PANDA = {
	ServiceId = "", -- Service ID do seu servico (Dashboard Panda)
}

-- ========== Adapter Panda (nao precisa editar) ==========
local PUSL
local function getPUSL()
	if PUSL then return PUSL end
	local ok, src = pcall(function() return game:HttpGet("https://secure.pandauth.com/pv4/lib") end)
	if not ok or not src then return nil end
	local okL, lib = pcall(function() return loadstring(src)() end)
	if not okL or type(lib) ~= "table" or type(lib.configure) ~= "function" then return nil end
	lib.configure({ serviceId = PANDA.ServiceId, debug = false, kickOnDetect = false })
	PUSL = lib
	return lib
end

local function PandaAdapter(key)
	if PANDA.ServiceId == "" then
		return { ok = false, status = "not_configured" }
	end
	local lib = getPUSL()
	if not lib then return { ok = false, status = "network", message = "Falha ao carregar a biblioteca da Panda." } end

	local ok, result = pcall(lib.validate, key)
	if not ok or type(result) ~= "table" then return { ok = false, status = "malformed" } end

	if result.success then
		return { ok = true, status = "valid", message = result.isPremium and "Key Premium validada!" or "Key validada com sucesso!" }
	end

	-- reason: INVALID_KEY | RATE_LIMITED | NETWORK | NO_SERVICE | NO_KEY | NO_HTTP | IDENTITY | PROTOCOL
	local reason = result.reason
	if reason == "INVALID_KEY" then return { ok = false, status = "invalid", message = "Key inv\u{E1}lida." } end
	if reason == "RATE_LIMITED" then return { ok = false, status = "error", message = "Muitas tentativas. Aguarde e tente novamente." } end
	return { ok = false, status = "error", message = "Falha ao validar (" .. tostring(reason) .. ")." }
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
		Repo = "CoiledTom/GCT-Ghost-Core-Toolkit.",
		Branch = "main",
		Fallback = "erro",
		Folder = "CoiledTom_KeySystem",
	},

	Orbit = { MinimizedGap = 5, MinimizedSpeedMul = 2.6 },

	-- { Name = "Meu Site", Url = "https://...", Icon = "link" },
	KeyProviders = {},

	Validation = { Timeout = 12, Adapter = PandaAdapter },

	RequireKeyToExecute = true,
	OnExecute = function()
		-- seu script principal aqui
	end,

	Credits = {},
}

loadstring(game:HttpGet(CORE_URL))()
