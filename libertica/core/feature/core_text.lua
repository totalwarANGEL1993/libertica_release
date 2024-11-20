Lib.Core = Lib.Core or {};
Lib.Core.Text = {
    Languages = {
        {"de", "Deutsch", "en"},
        {"en", "English", "en"},
        {"fr", "Français", "en"},
    },

    Colors = {
        none    = "{@color:none}",
        red     = "#ff5050",
        blue    = "#6868e8",
        yellow  = "#ffff50",
        green   = "#50b400",
        white   = "#ffffff",
        black   = "#000000",
        grey    = "#8c8c8c",
        azure   = "#00a0be",
        orange  = "#ffb01e",
        amber   = "#e0c575",
        violet  = "#b464be",
        pink    = "#ffaac8",
        scarlet = "#be0000",
        magenta = "#be0059",
        olive   = "#4a7800",
        celeste = "#91aad2",
        tooltip = "#333378",
    },

    Letters = {
        [4] = "ABCDEFGHKLMNOPQRSTUVWXYZÄÖÜÁÂÃÅÇÈÉÊËÐÐÑÒÓÔÕÖØÙÚÛÜÝ",
        [3] = "abcdeghkmnopqsuvwxyzäöüßIJÆÌÍÎÏÞàáâãåæçèéêëìíîïðñòóôõ÷øùúûüýþÿ",
        [2] = "\"#+*~_\\§$%&=?@fijlft",
        [1] = "!-/()?',.|[]{}",
    },

    StringTables = {},

    Placeholders = {
        Names = {},
        EntityTypes = {},
    },
}

CONST_LANGUAGE = "de";

Lib.Require("comfort/IsLocalScript");
Lib.Require("core/feature/Core_Report");
Lib.Register("core/feature/Core_Text");

-- -------------------------------------------------------------------------- --

function Lib.Core.Text:Initialize()
    Report.LanguageChanged = CreateReport("Event_LanguageChanged");

    self:DetectLanguage();
    if IsLocalScript() then
        self:OverwriteGetStringTableText();
    end
end

function Lib.Core.Text:OnSaveGameLoaded()
    if IsLocalScript() then
        self:OverwriteGetStringTableText();
    end
end

function Lib.Core.Text:OnReportReceived(_ID, ...)
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Text:OverwriteGetStringTableText()
    XGUIEng.GetStringTableText_Orig_Core = XGUIEng.GetStringTableText;
    XGUIEng.GetStringTableText = function(_key)
        return Lib.Core.Text:GetStringTableOverwrite(_key)
    end
end

function Lib.Core.Text:AddStringTableOverwrite(_Key, _Text)
    local i = string.find(_Key, "/[^/]*$");
    local File = _Key:sub(1, i-1):lower();
    local Key = _Key:sub(i+1):lower();
    self.StringTables[File] = self.StringTables[File] or {};
    self.StringTables[File][Key] = _Text;
end

function Lib.Core.Text:DeleteStringTableOverwrite(_Key)
    local i = string.find(_Key, "/[^/]*$");
    local File = _Key:sub(1, i-1):lower();
    local Key = _Key:sub(i+1):lower();
    self.StringTables[File] = self.StringTables[File] or {};
    self.StringTables[File][Key] = nil;
end

function Lib.Core.Text:GetStringTableOverwrite(_Key)
    local i = string.find(_Key, "/[^/]*$");
    local File = _Key:sub(1, i-1):lower();
    local Key = _Key:sub(i+1):lower();
    self.StringTables[File] = self.StringTables[File] or {};
    if self.StringTables[File][Key] then
        local Text = self.StringTables[File][Key];
        if type(Text) == "string" and Text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
            Text = XGUIEng.GetStringTableText_Orig_Core(Text);
        end
        return ConvertPlaceholders(Localize(Text));
    end
    return XGUIEng.GetStringTableText_Orig_Core(_Key);
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Text:DetectLanguage()
    local DefaultLanguage = Network.GetDesiredLanguage();
    if DefaultLanguage ~= "de" and DefaultLanguage ~= "fr" then
        DefaultLanguage = "en";
    end
    CONST_LANGUAGE = DefaultLanguage;
end

function Lib.Core.Text:ChangeSystemLanguage(_PlayerID, _IsGuiPlayer, _Language)
    local OldLanguage = CONST_LANGUAGE;
    local NewLanguage = _Language;

    if _IsGuiPlayer == nil or _IsGuiPlayer == true then
        CONST_LANGUAGE = _Language;
        ExecuteLocal([[CONST_LANGUAGE = "%s"]], _Language);
        SendReport(Report.LanguageChanged, OldLanguage, NewLanguage);
        SendReportToLocal(Report.LanguageChanged, OldLanguage, NewLanguage);
    end
end

function Lib.Core.Text:Localize(_Text)
    local LocalizedText = "ERROR_NO_TEXT";
    if type(_Text) == "table" then
        if _Text[CONST_LANGUAGE] then
            LocalizedText = _Text[CONST_LANGUAGE];
        else
            for k, v in pairs(self.Languages) do
                if v[1] == CONST_LANGUAGE and v[3] and _Text[v[3]] then
                    LocalizedText = _Text[v[3]];
                    break;
                end
            end
        end
    else
        LocalizedText = tostring(_Text);
    end
    return LocalizedText;
end

function Lib.Core.Text:ConvertPlaceholders(_Text)
    if type(_Text) == "string" then
        while true do
            local Before, Placeholder, After, Replacement, s1, e1, s2, e2;
            if _Text:find("{n:") then
                Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{n:");
                Replacement = self.Placeholders.Names[Placeholder];
                _Text = Before .. self:Localize(Replacement or ("n:" ..tostring(Placeholder).. ": not found")) .. After;
            elseif _Text:find("{t:") then
                Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{t:");
                Replacement = self.Placeholders.EntityTypes[Placeholder];
                _Text = Before .. self:Localize(Replacement or ("n:" ..tostring(Placeholder).. ": not found")) .. After;
            elseif _Text:find("{v:") then
                Before, Placeholder, After, s1, e1, s2, e2 = self:SplicePlaceholderText(_Text, "{v:");
                Replacement = self:ReplaceValuePlaceholder(Placeholder);
                _Text = Before .. self:Localize(Replacement or ("v:" ..tostring(Placeholder).. ": not found")) .. After;
            elseif _Text:find("#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]") then
                Before, Placeholder, After, s1, e1, s2, e2 = self:SpliceHexColors(_Text);
                Replacement = HexToColorString(Placeholder);
                _Text = Before .. self:Localize(Replacement or ("n:" ..tostring(Placeholder).. ": not found")) .. After;
            end
            if s1 == nil or e1 == nil or s2 == nil or e2 == nil then
                break;
            end
        end
        _Text = self:ReplaceColorPlaceholders(_Text);
    end
    return _Text;
end

function Lib.Core.Text:SplicePlaceholderText(_Text, _Start)
    local s1, e1      = _Text:find(_Start);
    local s2, e2      = _Text:find("}", e1);
    local Before      = _Text:sub(1, s1-1);
    local Placeholder = _Text:sub(e1+1, s2-1);
    local After       = _Text:sub(e2+1);
    return Before, Placeholder, After, s1, e1, s2, e2;
end

function Lib.Core.Text:SpliceHexColors(_Text)
    local hex3 = "#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]";
    local hex4 = "#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]";
    local hex6 = "#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]";
    local hex8 = "#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]";

    local s,e = _Text:find(hex8);
    if s == nil then s,e = _Text:find(hex6); end
    if s == nil then s,e = _Text:find(hex4); end
    if s == nil then s,e = _Text:find(hex3); end

    local Before = _Text:sub(1, s-1);
    local Placeholder = _Text:sub(s, e);
    local After = _Text:sub(e+1);
    return Before, Placeholder, After, s, s, e, e;
end

function Lib.Core.Text:ReplaceColorPlaceholders(_Text)
    for k, v in pairs(self.Colors) do
        local Color = (v:find("color") and v) or HexToColorString(v);
        _Text = _Text:gsub("{" ..k.. "}", Color);
    end
    return _Text;
end

function Lib.Core.Text:ReplaceValuePlaceholder(_Text)
    local Ref = _G;
    local Slice = string.slice(_Text, "%.");
    for i= 1, #Slice do
        local KeyOrIndex = Slice[i];
        local Index = tonumber(KeyOrIndex);
        if Index ~= nil then
            KeyOrIndex = Index;
        end
        if not Ref[KeyOrIndex] then
            return nil;
        end
        Ref = Ref[KeyOrIndex];
    end
    return Ref;
end

-- -------------------------------------------------------------------------- --

function Lib.Core.Text:GetAmountOfLines(_Text, _LineLength)
    local Lines = 0;
    if type(_Text) == "string" then
        local Text,cr = string.gsub(_Text, "{cr}", " ###CR### ");

        local Words = {};
        for Word in string.gmatch(Text, "%S+") do
            table.insert(Words, Word)
        end

        local Counter = 0;
        for _,Word in pairs(Words) do
            if Word == "###CR###" then
                Counter = 0;
                Lines = Lines + 1;
            else
                for Char in string.gmatch(Word, ".") do
                    local Size = self:GetLetterSize(Char);
                    if Counter + Size <= _LineLength then
                        Counter = Counter + Size;
                    else
                        Counter = 0;
                        Lines = Lines + 1;
                    end
                end
            end
        end
    end
    return Lines;
end

function Lib.Core.Text:GetLetterSize(_Byte)
    for Size, Letters in pairs(self.Letters) do
        if string.find(Letters, _Byte, nil, true) then
            return Size;
        end
    end
    return 2;
end

-- -------------------------------------------------------------------------- --

function Localize(_Text)
    return Lib.Core.Text:Localize(_Text);
end
API.Localize = Localize;

function ConvertPlaceholders(_Text)
    return Lib.Core.Text:ConvertPlaceholders(_Text);
end
API.ConvertPlaceholders = ConvertPlaceholders;

function AddNote(_Text)
    _Text = ConvertPlaceholders(Localize(_Text));
    if not IsLocalScript() then
        Logic.DEBUG_AddNote(_Text);
        return;
    end
    if _Text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _Text = GetStringText(_Text);
    end
    GUI.AddNote(_Text);
end
API.Note = AddNote;

function AddStaticNote(_Text)
    _Text = ConvertPlaceholders(Localize(_Text));
    if not IsLocalScript() then
        ExecuteLocal([[GUI.AddStaticNote("%s")]], _Text);
        return;
    end
    if _Text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _Text = GetStringText(_Text);
    end
    GUI.AddStaticNote(_Text);
end
API.StaticNote = AddStaticNote;

function AddMessage(_Text, _Sound)
    _Text = ConvertPlaceholders(Localize(_Text));
    if not IsLocalScript() then
        ExecuteLocal([[AddMessage("%s", "%s")]], _Text, _Sound or "");
        return;
    end
    if _Text:find("^[A-Za-z0-9_]+/[A-Za-z0-9_]+$") then
        _Text = GetStringText(_Text);
    end
    Message(_Text, (_Sound and _Sound ~= "" and _Sound:gsub("/", "\\")) or nil);
end
API.Message = AddMessage;

function ClearNotes()
    if not IsLocalScript() then
        ExecuteLocal([[ClearNotes()]]);
        return;
    end
    GUI.ClearNotes();
end
API.ClearNotes = ClearNotes;

function AddNamePlaceholder(_Name, _Replacement)
    error(
        type(_Replacement) ~= "function" and type(_Replacement) ~= "thread",
        "Only strings, numbers, or tables are allowed!"
    );
    Lib.Core.Text.Placeholders.Names[_Name] = _Replacement;
end
API.AddNamePlaceholder = AddNamePlaceholder;

function AddEntityTypePlaceholder(_Type, _Replacement)
    error(
        Entities[_Type] == nil,
        "EntityType does not exist!"
    );
    Lib.Core.Text.Placeholders.EntityTypes[_Type] = _Replacement;
end
API.AddEntityTypePlaceholder = AddEntityTypePlaceholder;

function AddStringText(_Key, _Text)
    assert(IsLocalScript(), "Text can only be set in local script!");
    Lib.Core.Text:AddStringTableOverwrite(_Key, _Text)
end
API.AddStringText = AddStringText;

function DeleteStringText(_Key)
    assert(IsLocalScript(), "Text can only be removed in local script!");
    Lib.Core.Text:DeleteStringTableOverwrite(_Key);
end
API.DeleteStringText = DeleteStringText;

function GetStringText(_Key)
    assert(IsLocalScript(), "Text can only be retrieved in local script!");
    return Lib.Core.Text:GetStringTableOverwrite(_Key)
end
API.GetStringText = GetStringText;

function DefineLanguage(_Shortcut, _Name, _Fallback, _Index)
    assert(type(_Shortcut) == "string");
    assert(type(_Name) == "string");
    assert(type(_Fallback) == "string");
    for k, v in pairs(Lib.Core.Text.Languages) do
        if v[1] == _Shortcut then
            return;
        end
    end
    _Index = _Index or #Lib.Core.Text.Languages +1
    table.insert(Lib.Core.Text.Languages, _Index, {_Shortcut, _Name, _Fallback});
    ExecuteLocal([[
        table.insert(Lib.Core.Text.Languages, %d, {"%s", "%s", "%s"})
    ]], _Index, _Shortcut, _Name, _Fallback);
end

function CountTextLines(_Text, _LineLength)
    assert(type(_Text) == "string");
    assert(type(_LineLength) == "number");
    assert(_LineLength > 0);
    return Lib.Core.Text:GetAmountOfLines(_Text, _LineLength);
end

