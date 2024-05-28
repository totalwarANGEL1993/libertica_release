Lib.Register("module/entity/EntitySelection_Text");

Lib.EntitySelection = Lib.EntitySelection or {};
Lib.EntitySelection.Text = {
    Tooltips = {
        KnightButton = {
            Title = {
                de = "Ritter selektieren",
                en = "Select Knight",
                fr = "Sélectionner le chevalier",
            },
            Text = {
                de = "- Klick selektiert den Ritter {cr}- Doppelklick springt zum Ritter{cr}- UMSCH halten selektiert alle Ritter",
                en = "- Click selects the knight {cr}- Double click jumps to knight{cr}- Press SHIFT to select all knights",
                fr = "- Clic sélectionne le chevalier {cr}- Double-clic saute au chevalier{cr}- Maintenir SHIFT sélectionne tous les chevaliers",
            },
        },

        BattalionButton = {
            Title = {
                de = "Militär selektieren",
                en = "Select Units",
                fr = "Sélectionner les unitées",
            },
            Text = {
                de = "- Selektiert alle Einheiten {cr}- UMSCH halten selektiert Militär {cr}- ALT halten selektiert Kriegsmaschinen {cr}- STRG halten selektiert Diebe",
                en = "- Selects all units {cr}- Holding SHIFT selects military {cr}- Holding ALT selects siege engines {cr}- Holding CTRL selects thieves",
                fr = "- Sélectionne toutes les unités {cr}- Maintenir SHIFT sélectionne les militaires {cr}- Maintenir ALT sélectionne les machines de guerre {cr}- Maintenir CTRL sélectionne les voleurs",
            },
        },

        ReleaseSoldiers = {
            Title = {
                de = "Militär entlassen",
                en = "Release military unit",
                fr = "licencier l'unitées",
            },
            Text = {
                de = "- Eine Militäreinheit entlassen {cr}- Soldaten werden nacheinander entlassen",
                en = "- Dismiss a military unit {cr}- Soldiers will be dismissed each after another",
                fr = "- Licencier une unité militaire {cr}- Les soldats sont licenciés les uns après les autres",
            },
            Disabled = {
                de = "Kann nicht entlassen werden!",
                en = "Releasing is impossible!",
                fr = "Ne peut pas être licencié!",
            },
        },

        TrebuchetCart = {
            Title = {
                de = "Trebuchetwagen",
                en = "Trebuchet cart",
                fr = "Chariot à trébuchet",
            },
            Text = {
                de = "- Kann einmalig zum Trebuchet ausgebaut werden",
                en = "- Can uniquely be transmuted into a trebuchet",
                fr = "- Peut être transformé une seule fois en trébuchet",
            },
        },

        Trebuchet = {
            Title = {
                de = "Trebuchet",
                en = "Trebuchet",
                fr = "Trébuchet",
            },
            Text = {
                de = "- Kann über weite Strecken Gebäude angreifen {cr}- Kann Gebäude in Brand stecken {cr}- Trebuchet kann manuell zurückgeschickt werden",
                en = "- Can perform long range attacks on buildings {cr}- Can set buildings on fire {cr}- The trebuchet can be manually send back to the city",
                fr = "- Peut attaquer des bâtiments sur de longues distances {cr}- Peut mettre le feu à des bâtiments {cr}- Le trébuchet peut être renvoyé manuellement",
            },
        },
    },
};

