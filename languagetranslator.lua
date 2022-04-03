PLUGIN.title = "Language Translator"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Translates most Text chat into the reservers language (Allowing for players to cross the language barrior)."

ix.lang.AddTable("english", {
    
	optLanguageTranslator = "Language Translator",
	optdLanguageTranslator = "The language you type in and want to reseave.",
})
ix.lang.AddTable("russian", {
	optLanguageTranslator = "Переводчик языков",
	optdLanguageTranslator = "Язык, который вы вводите и хотите получить.",
})

ix.option.Add("languageTranslator", ix.type.array, ix.config.languageTranslator or "en      ", {
	category = "Language Translator",
    bNetworked = true,
	populate = function()
		return {
            ["en      "] = "English (English?)",
            ["ru      "] = "Russian (русский)",
            ["es      "] = "Spanish (español)",
            ["fr      "] = "French (français)",
            ["pl      "] = "Polish (Polski)",
            ["uk      "] = "Ukrainian (український)",
            ["zh-TW      "] = "Chinese (Simplified) (简体中文)",
            ["zh-CN      "] = "Chinese (Traditonal) (中國傳統的)",
            ["hi      "] = "Hindi (हिन्दी)",
            ["ko      "] = "Korean (한국어)"
        }
	end
})

-- https://wiki.facepunch.com/gmod/coroutine.wrap
local function HTTPRequest( url, headers )
    local running = coroutine.running()

    local function onSuccess( body, length, header, code )
        coroutine.resume( running, true, body, header, code )
    end

    local function onFailure( err )
        coroutine.resume( running, false, err )
    end

    http.Fetch( url, onSuccess, onFailure, headers )

    return coroutine.yield()
end

-- https://github.com/lunarmodules/luasocket/blob/master/src/url.lua
local function escape(s) return (string.gsub(s, "([^A-Za-z0-9_])", function(c) return string.format("%%%02x", string.byte(c)) end)) end



--Thank you, https://gist.github.com/tomill/362661 for insperation
local function LanguageTranslator(speaker, receiver, query, chatType, rawText)
    local WritenLang  = string.Replace(ix.option.Get(speaker, "languageTranslator", "en      "), " ", "")
    local ReseaveLang = string.Replace(ix.option.Get(receiver, "languageTranslator", GetConVar("gmod_language")), " ", "")
    local query = query or ""
    if WritenLang == ReseaveLang or query == "" then return end
    coroutine.wrap( function() 
        local HTTPurl = "http://translate.googleapis.com/translate_a/single?client=gtx&sl="
        ..WritenLang 
        .."&tl="
        ..ReseaveLang 
        .."&dt=t&q="
        ..escape(query)

        local state, response, header, code = HTTPRequest(HTTPurl)
        if state then
            local fullyTranslated = (util.JSONToTable(response))[1][1][1]
            if fullyTranslated != query then
                ix.chat.Send(speaker, chatType, fullyTranslated, false, {receiver})
            end
        else
            print("(Contact Server Administation or Shooter#5269), code:".. code)
        end
    end)()
end

function PLUGIN:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText) 
    if (IsValid(speaker) and receivers) then
        for k, v in pairs(receivers) do
            LanguageTranslator(speaker, v , text, chatType, rawText)
        end
    end
end

