Lib.Core = Lib.Core or {};
Lib.Core.Text = {
    Languages = {
        {"de", "Deutsch", "en"},
        {"en", "English", "en"},
        {"fr", "Français", "en"},
    },

    Colors = {
        red     = "{@color:255,80,80,255}",
        blue    = "{@color:104,104,232,255}",
        yellow  = "{@color:255,255,80,255}",
        green   = "{@color:80,180,0,255}",
        white   = "{@color:255,255,255,255}",
        black   = "{@color:0,0,0,255}",
        grey    = "{@color:140,140,140,255}",
        azure   = "{@color:0,160,190,255}",
        orange  = "{@color:255,176,30,255}",
        amber   = "{@color:224,197,117,255}",
        violet  = "{@color:180,100,190,255}",
        pink    = "{@color:255,170,200,255}",
        scarlet = "{@color:190,0,0,255}",
        magenta = "{@color:190,0,89,255}",
        olive   = "{@color:74,120,0,255}",
        celeste = "{@color:145,170,210,255}",
        tooltip = "{@color:51,51,120,255}",
        none    = "{@color:none}"
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

function Lib.Core.Text:ReplaceColorPlaceholders(_Text)
    for k, v in pairs(self.Colors) do
        _Text = _Text:gsub("{" ..k.. "}", v);
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
    GUI.AddNote(_Text);
end
API.Note = AddNote;

function AddStaticNote(_Text)
    _Text = ConvertPlaceholders(Localize(_Text));
    if not IsLocalScript() then
        ExecuteLocal([[GUI.AddStaticNote("%s")]], _Text);
        return;
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
    _Text = ConvertPlaceholders(Localize(_Text));
    Message(_Text, (_Sound and _Sound ~= "" and _Sound:gsub("/", "\\")) or nil);
end

function ClearNotes()
    if not IsLocalScript() then
        ExecuteLocal([[ClearNotes()]]);
        return;
    end
    GUI.ClearNotes();
end
API.ClearNotes = ClearNotes;

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

