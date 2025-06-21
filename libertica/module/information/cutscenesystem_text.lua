Lib.Register("module/information/CutsceneSystem_Text");

Lib.CutsceneSystem = Lib.CutsceneSystem or {};
Lib.CutsceneSystem.Text = {
    FastForwardActivate   = {de = "Beschleunigen",      en = "Fast Forward", fr = "Accélérer"},
    FastForwardDeactivate = {de = "Zurücksetzen",       en = "Normal Speed", fr = "Réinitialiser"},
    FastFormardMessage    = {de = "SCHNELLER VORLAUF",  en = "FAST FORWARD", fr = "AVANCÉ RAPIDE"},

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

