Lib.Register("module/ui/UIBuilding_Text");

Lib.UIBuilding = Lib.UIBuilding or {};
Lib.UIBuilding.Text = {
    ExtraButton = {
        Downgrade = {
            Normal = {
                Title = {
                    de = "Rückbau",
                    en = "Downgrade",
                    fr = "Déconstruction",
                },
                Text = {
                    de = "- Reißt eine Ausbaustufe ab!",
                    en = "- Demolishes one upgrade level!",
                    fr = "- Réduit le niveau du bâtiment d'un niveau!",
                },
                Error = "UI_ButtonDisabled/AbilityNotReady",
            },
        },
        SingleReserve = {
            Normal = {
                Title = "UI_ObjectNames/BuildingsMenuStopConsumption",
                Text = "UI_ObjectDescription/BuildingsMenuStopConsumption",
                Error = "UI_ButtonDisabled/AbilityNotReady",
            },
            Stopped = {
                Title = "UI_ObjectNames/BuildingsMenuResumeConsumption",
                Text = "UI_ObjectDescription/BuildingsMenuResumeConsumption",
                Error = "UI_ButtonDisabled/AbilityNotReady",
            },
        },
        SingleStop = {
            Normal = {
                Title = "UI_ObjectNames/BuildingsMenuStopProduction",
                Text = {
                    de = "- Gebäude produziert keine Waren",
                    en = "- Building does not produce goods",
                    fr = "- le bâtiment ne produit pas de biens",
                },
                Error = "UI_ButtonDisabled/AbilityNotReady",
            },
            Stopped = {
                Title = "UI_ObjectNames/BuildingsMenuResumeProduction",
                Text = {
                    de = "- Gebäude produzieren Waren",
                    en = "- Building produces goods",
                    fr = "- Le bâtiment produit des biens",
                },
                Error = "UI_ButtonDisabled/AbilityNotReady",
            },
        },
    }
};

