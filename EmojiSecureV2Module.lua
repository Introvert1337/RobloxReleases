local Characters = {
    a = "✨😊❤️",
    A = "😎😂🔥",
    b = "😥😎❤️",
    B = "😍🍉🍍",
    c = "❤️🥭😊",
    C = "🐶🥭󠁠󠁠💯",
    d = "🍍💯🥑",
    D = "😎🥰🧱",
    e = "🥺💈💣",
    E = "➰🍆🤬",
    f = "🛀📘💼",
    F = "🐛🌛👲",
    g = "🍶👾🐴",
    G = "🔃⛪️⏳",
    h = "✋🎑🐵",
    H = "🔔😍🍜",
    i = "🌎❓🐺",
    I = "💲🚞😽",
    j = "👵🌊🍎",
    J = "🚆👹💴",
    k = "1️⃣🚋👱",
    K = "🌕🔀💯",
    l = "🤖📶📠",
    L = "🆘👴🐔",
    m = "🕔🚃🦁",
    M = "🌞1️⃣🏫",
    n = "🕌🍶😈",
    N = "💖🍌🍐",
    o = "🔜🕠💖",
    O = "✖️🍮📆",
    p = "🍖🎿💡",
    P = "🔢🐘🍮",
    q = "🚎🐃💇",
    Q = "😚👗🐊",
    r = "🚮🎼💍",
    R = "🖐🐞💑",
    s = "🚆🍊🕚",
    S = "💂🌍👩",
    t = "🚙☔️🌝",
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
    Y = "♉️😕🍰",
    z = "🚊🕡💍",
    Z = "❌🍗🍋",
    ["1"] = "💑✴️📏",
    ["2"] = "📏🍕🕍",
    ["3"] = "⛺️👣⏪",
    ["4"] = "🏅🙃🌖",
    ["5"] = "😗🍡🚴",
    ["6"] = "🏉🙌📗",
    ["7"] = "🍪⚠️🕟",
    ["8"] = "🏀7️⃣💬",
    ["9"] = "🍺🐮☕️",
    ["0"] = "🎸😣🎳",
    grave = "🐹👾⛹",
    ["/"] = "😗🚂1️⃣",
    backslash = "❌🤖🍞", 
    ["["] = "🍈↩️😵", 
    ["]"] = "💜💹🈲", 
    ["("] = "🚎👆✋",
    [")"] = "😴😍😵",
    ["+"] = "🆔📷👏",
    ["-"] = "✒️🐵🔮",
    ["="] = "🚹➗🏩",
    ["{"] = "🐧👎🤖",
    ["}"] = "🐍🍮♌️",
    [";"] = "🍛🕰📚",
    [":"] = "🍵🕎💀",
    [">"] = "🏣📝🎢",
    ["<"] = "😧📗🌵",
    ["'"] = "😨🍗😻",
    ['"'] = "🚋♓️📭",
    ["|"] = "🐱🚿🎷",
    ["_"] = "🚍🍵🌈",
    ["*"] = "✈️😔🔫",
    ["!"] = "⚠️💌💖",
    ["@"] = "🍉🐋🌂",
    ["#"] = "🍗🉑😁", 
    ["$"] = "😲🍁🙈", 
    ["%"] = "🏇🚛👢",
    ["^"] = "🚣😏🍰",
    ["&"] = "🎠🐘🙅",
    ["."] = "📚🐉㊙️",
    [","] = "⛄️🔆‼️",
    ["~"] = "😭🚈🍆",
    [" "] = " ",
}

local EmojiSecureV2 = {
    Encode = function(data)
        local Output = ""
        for i,v in next, data:split("") do 
            if Characters[v] then 
                Output = Output.."✅"..Characters[v] 
            elseif v == [[\]] then 
                Output = Output.."✅"..Characters["backslash"]
            elseif v == [[`]] then 
                Output = Output.."✅"..Characters["grave"]
            end
        end
        return Output
    end,
    Decode = function(data)
        local Output = ""
        for i,v in next, data:split("✅") do 
            for k,x in next, Characters do 
                if x == v then 
                    if k ~= "backslash" and k ~= "grave" then
                        Output = Output..k 
                    else 
                        if k == "backslash" then 
                            Output = Output..[[\]] 
                        elseif k == "grave" then 
                            Output = Output..[[`]] 
                        end 
                    end
                end
            end
        end
        return Output
    end
}

return EmojiSecureV2
