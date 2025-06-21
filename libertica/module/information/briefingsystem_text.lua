Lib.Register("module/information/BriefingSystem_Text");

Lib.BriefingSystem = Lib.BriefingSystem or {};
Lib.BriefingSystem.Text = {
    NextButton = {de = "Weiter",  en = "Forward",  fr = "Continuer"},
    PrevButton = {de = "Zurück",  en = "Previous", fr = "Retour"},
    EndButton  = {de = "Beenden", en = "Close",    fr = "Quitter"},

    Request = {
        Title = {
            de = "Grafik ändern",
            en = "Alternate Graphics",
            fr = "Graphiques alternatifs",
        },
        Text  = {
            de = "Während des Spiels können die Grafikeinstellungen durch das Mapscript vorübergehend geändert werden. Willst du das zulassen?",
            en = "During gameplay the graphic settings might be changed temporarily by the mapscript. Do you want to allow that?",
            fr = "Pendant le jeu, les paramètres graphiques peuvent être modifiés temporairement par le mapscript. Voulez-vous autoriser cela?",
        },
    },
};

