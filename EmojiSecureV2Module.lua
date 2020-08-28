setreadonly(utf8, false)

function utf8.sub(s, i, j)
    i = utf8.offset(s, i)
    j = utf8.offset(s, j + 1) - 1
    return string.sub(s, i, j)
end

setreadonly(utf8, true)

local Characters = {
    a = "✨😊🍍",
    A = "😎😂🔥",
    b = "😥😎💯",
    B = "😍🍉🍍",
    c = "🔔🎑🤬",
    C = "🐶🐴💯",
    d = "🍍💯🥑",
    D = "😎🥰🧱",
    e = "🥺💈💣",
    E = "➰🍆🤬",
    f = "🛀📘💼",
    F = "🐛🌛👲",
    g = "🍶👾🐴",
    G = "🔃🍎⏳",
    h = "✋🎑🐵",
    H = "🔔😍🍜",
    i = "🌎❓🐺",
    I = "💲🚞😽",
    j = "👵🌊🍎",
    J = "🚆👹💴",
    k = "🐺🚋👱",
    K = "🌕🔀💯",
    l = "🤖📶📠",
    L = "🆘👴🐔",
    m = "🕔🚃🦁",
    M = "🌞💡🏫",
    n = "🕌🍶😈",
    N = "💖🍌🍐",
    o = "🔜🕠💖",
    O = "🎼🍮📆",
    p = "🍖🎿💡",
    P = "🔢🐘🍮",
    q = "🚎🐃💇",
    Q = "😚👗🐊",
    r = "🚮🎼💍",
    R = "🖐🐞💑",
    s = "🚆🍊🕚",
    S = "💂🌍👩",
    t = "🌍🍖🔫",
    T = "⏳📎🔫",
    u = "🎑👨💛", 
    U = "💄🚉🍧",
    v = "😫💉🐰",
    V = "🦀🤕💀",
    w = "👗🤕👭",
    W = "👙🔉🍮",
    x = "😩🚩🛄",
    X = "💠🍩📑",
    y = "🔂🦁💴",
    Y = "🌖😕🍰",
    z = "🚊🕡💍",
    Z = "❌🍗🍋",
    ["1"] = "💑🌖📏",
    ["2"] = "📏🍕🕍",
    ["3"] = "🍡👣⏪",
    ["4"] = "🏅🙃🌖",
    ["5"] = "😗🍡🚴",
    ["6"] = "🏉🙌📗",
    ["7"] = "🍪🈲🕟",
    ["8"] = "🏀🌂💬",
    ["9"] = "🍺🐮🚹",
    ["0"] = "🎸😣🎳",
    grave = "🐹👾⛹",
    ["/"] = "😗🚂🌖",
    backslash = "❌🤖🍞", 
    ["["] = "🍈⛹😵", 
    ["]"] = "💜💹🈲", 
    ["("] = "🚎👆✋",
    [")"] = "😴😍😵",
    ["+"] = "🆔📷👏",
    ["-"] = "🐘🌂🔮",
    ["="] = "🚹➗🏩",
    ["{"] = "🐧👎🤖",
    ["}"] = "🐍🍮🔮",
    [";"] = "🍛🕰📚",
    [":"] = "🍵🕎💀",
    [">"] = "🏣📝🎢",
    ["<"] = "😧📗🌵",
    ["'"] = "😨🍗😻",
    ['"'] = "🌈💀📭",
    ["|"] = "🐱🚿🎷",
    ["_"] = "🔮😴🌈",
    ["*"] = "😕😔🔫",
    ["!"] = "🏇🍵🐘",
    ["@"] = "🍉🐋🌂",
    ["#"] = "🍗🉑😁", 
    ["$"] = "😲🍁🙈", 
    ["%"] = "🏇🚛👢",
    ["^"] = "🚣😏🍰",
    ["&"] = "🎠🐘🙅",
    ["."] = "📚🐉😴",
    [","] = "🎠🔆😏",
    ["~"] = "😭🚈🍆",
    [" "] = " ",
}

local EmojiSecureV2 = {
    Encode = function(data)
        local Output = ""
        for i,v in next, data:split("") do 
            if Characters[v] then 
                Output = Output..Characters[v] 
            elseif v == [[\]] then 
                Output = Output..Characters["backslash"]
            elseif v == [[`]] then 
                Output = Output..Characters["grave"]
            end
        end
        return Output
    end,
    Decode = function(data)
        local Output = ""
        local last = 1
        for i = 3, utf8.len(data) do
            if i/3 == math.floor(i/3) then 
                local subbed = utf8.sub(data, i == 3 and last or last + 1, i)
                for k,x in next, Characters do 
                    if x == subbed then 
                        if k ~= "backslash" and k ~= "grave" then
                            Output = Output..k
                            break
                        else 
                            if k == "backslash" then 
                                Output = Output..[[\]] 
                            elseif k == "grave" then 
                                Output = Output..[[`]] 
                            end
                        end
                    end
                end
                last = i
            end
        end
        return Output
    end
}

return EmojiSecureV2
