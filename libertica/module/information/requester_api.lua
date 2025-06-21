Lib.Require("comfort/IsMultiplayer");
Lib.Require("comfort/IsLocalScript");
Lib.Register("module/information/Requester_API");

function TextWindow(_Caption, _Content, _PlayerID)
    _PlayerID = _PlayerID or 1;
    _Caption = Localize(_Caption);
    _Content = Localize(_Content);
    if not GUI then
        ExecuteLocal(
            [[TextWindow("%s", "%s", %d)]],
            _Caption,
            _Content,
            _PlayerID
        );
        return;
    end
    Lib.Requester.Local:ShowTextWindow {
        PlayerID = _PlayerID,
        Caption  = _Caption,
        Content  = _Content,
    };
end
API.TextWindow = TextWindow;

function DialogInfoBox(_PlayerID, _Title, _Text, _Action)
    assert(IsLocalScript(), "Can not be used in global script.");
    if type(_PlayerID) ~= "number" then
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = Localize(_Text);
    end
    Lib.Requester.Local:OpenDialog(_PlayerID, _Title, _Text, _Action);
end
API.DialogInfoBox = DialogInfoBox;

function DialogRequestBox(_PlayerID, _Title, _Text, _Action, _OkCancel)
    assert(IsLocalScript(), "Can not be used in global script.");
    if type(_PlayerID) ~= "number" then
        --- @diagnostic disable-next-line: cast-local-type
        _OkCancel = _Action;
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = Localize(_Text);
    end
    Lib.Requester.Local:OpenRequesterDialog(_PlayerID, _Title, _Text, _Action, _OkCancel);
end
API.DialogRequestBox = DialogRequestBox;

function DialogSelectBox(_PlayerID, _Title, _Text, _Action, _List)
    assert(IsLocalScript(), "Can not be used in global script.");
    if type(_PlayerID) ~= "number" then
        --- @diagnostic disable-next-line: cast-local-type
        _List = _Action;
        _Action = _Text;
        _Text = _Title;
        _Title = _PlayerID;
        _PlayerID = GUI.GetPlayerID();
    end
    if type(_Title) == "table" then
        _Title = Localize(_Title);
    end
    if type(_Text) == "table" then
        _Text  = Localize(_Text);
    end
    _Text = _Text .. "{cr}";
    Lib.Requester.Local:OpenSelectionDialog(_PlayerID, _Title, _Text, _Action, _List);
end
API.DialogSelectBox = DialogSelectBox;

function DialogLanguageSelection(_PlayerID)
    _PlayerID = _PlayerID or 0
    if not GUI then
        ExecuteLocal([[DialogLanguageSelection(%d)]], _PlayerID);
        return;
    end

    local ReceiverID = _PlayerID;
    local PlayerID = GUI.GetPlayerID();
    local IsGuiPlayer = ReceiverID == 0 or ReceiverID == PlayerID;
    if ReceiverID ~= 0 and GUI.GetPlayerID() ~= ReceiverID then
        return;
    end

    local DisplayedList = {};
    for i= 1, #Lib.Core.Placeholder.Languages do
        table.insert(DisplayedList, Lib.Core.Placeholder.Languages[i][2]);
    end
    local Action = function(_Selected)
        SendReportToGlobal(Report.LanguageSelectionClosed, PlayerID, IsGuiPlayer, Lib.Core.Placeholder.Languages[_Selected][1]);
        SendReport(Report.LanguageSelectionClosed, PlayerID, IsGuiPlayer, Lib.Core.Placeholder.Languages[_Selected][1]);
    end
    DialogSelectBox(
        PlayerID,
        Localize(Lib.Requester.Text.ChooseLanguage.Title),
        Localize(Lib.Requester.Text.ChooseLanguage.Text),
        Action,
        DisplayedList
    );
end
API.DialogLanguageSelection = DialogLanguageSelection;

