--// variables

local stun_class_names = {
    ["PreventAction"] = true,
    ["OffhandAttack"] = true,
    ["MobileAction"] = true,
    ["Unequipping"] = true,
    ["LightAttack"] = true,
    ["Unconscious"] = true,
    ["UsingSpell"] = true,
    ["Equipping"] = true,
    ["NoAttack"] = true,
    ["Carried"] = true,
    ["Knocked"] = true,
    ["Action"] = true,
    ["Pinned"] = true,
    ["Stun"] = true,
    ["NoRoll"] = true
};

local effects_table = require(game:GetService("ReplicatedStorage").EffectReplicator).Effects;

--// main hook 

local old_pairs
old_pairs = replaceclosure(pairs, newcclosure(function(data)
    if data == effects_table then
        local fake_effects = {};

        for effect_id, effect_data in next, data do 
            local effect_class = effect_data.Class; 

            if not stun_class_names[effect_class] then 
                fake_effects[effect_id] = effect_data;
            end;
        end;

        return old_pairs(fake_effects);
    end;

    return old_pairs(data);
end));
