-- CoiledTom Key System | Loader: Luarmor (Key Check Library)
-- Docs: https://docs.luarmor.net/luarmor-user-manual-and-f.a.q (secao "Key Check Library")

local CORE_URL = "https://raw.githubusercontent.com/CoiledTom/GCT-Ghost-Core-Toolkit/refs/heads/main/main.lua"

local LUARMOR = {
	ScriptId = "", -- Script ID do seu projeto na Luarmor (32 caracteres hexadecimais)
}

-- ========== Adapter Luarmor (nao precisa editar) ==========
local LuarmorLib
local function getLuarmorLib()
	if LuarmorLib then return LuarmorLib end
	local ok, lib = pcall(function()
		return loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
	end)
	if ok and type(lib) == "table" then
		lib.script_id = LUARMOR.ScriptId
		LuarmorLib = lib
		return lib
	end
	return nil
end

local function LuarmorAdapter(key)
	if LUARMOR.ScriptId == "" then
		return { ok = false, status = "not_configured" }
	end
	local lib = getLuarmorLib()
	if not lib then return { ok = false, status = "network", message = "Falha ao carregar a biblioteca da Luarmor." } end

	local ok, res = pcall(lib.check_key, key)
	if not ok or type(res) ~= "table" or type(res.code) ~= "string" then
		return { ok = false, status = "malformed" }
	end

	local code = res.code
	if code == "KEY_VALID" then return { ok = true, status = "valid", message = "Key validada com sucesso!" } end
	if code == "KEY_EXPIRED" then return { ok = false, status = "expired", message = "Esta Key expirou." } end
	if code == "KEY_HWID_LOCKED" then
		return { ok = false, status = "invalid", message = "Key vinculada a outro dispositivo. Resete o HWID." }
	end
	if code == "KEY_BANNED" then return { ok = false, status = "invalid", message = "Esta Key foi banida." } end
	if code == "KEY_INCORRECT" or code == "KEY_INVALID" then
		return { ok = false, status = "invalid", message = "Key incorreta ou inexistente." }
	end
	-- SCRIPT_ID_INCORRECT, SCRIPT_ID_INVALID, INVALID_EXECUTOR, SECURITY_ERROR, TIME_ERROR, UNKNOWN_ERROR
	return { ok = false, status = "error", message = res.message or ("Falha na Luarmor (" .. code .. ").") }
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

	KeyProviders = {},

	Validation = { Timeout = 12, Adapter = LuarmorAdapter },

	RequireKeyToExecute = true,
	OnExecute = function()
		-- seu script principal aqui (defina script_key antes de usar loadstring da Luarmor)
	end,

	Credits = {},
}

loadstring(game:HttpGet(CORE_URL))()
