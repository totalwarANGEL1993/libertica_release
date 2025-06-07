Lib.Register("module/city/MilitiaSystem_Text");

Lib.MilitiaSystem = Lib.MilitiaSystem or {};
Lib.MilitiaSystem.Text = {
    Message = {
        NoConscripts = {
            de = "Nicht genügend Rekruten verfügbar!",
            en = "Not enough conscripts available!",
        },
    },
    Unit = {
        ["U_MilitaryBandit_Melee_AS"] = {
            Title = {de = "Hindun Schwertkämpfer", en = "Hindun Swordmen"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Ranged_AS"] = {
            Title = {de = "Hindun Bogenschütze", en = "Hindun Archers"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Melee_ME"] = {
            Title = {de = "Westerlin Keulenkämpfer", en = "Westerlin Macemen"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Ranged_ME"] = {
            Title = {de = "Westerlin Bogenschützen", en = "Westerlin Archers"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Melee_NA"] = {
            Title = {de = "Janub Schwertkämpfer", en = "Janub Swordmen"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Ranged_NA"] = {
            Title = {de = "Janub Bogenschützen", en = "Janub Archer"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Melee_NE"] = {
            Title = {de = "Narlind Axtkämpfer", en = "Narlind Axemens"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Ranged_NE"] = {
            Title = {de = "Narlind Axtwerfer", en = "Narlind Axethrower"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Melee_SE"] = {
            Title = {de = "Raudrlin Schwertkämpfer", en = "Raudrlin Swordmen"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
        ["U_MilitaryBandit_Ranged_SE"] = {
            Title = {de = "Raudrlin Bogenschützen", en = "Raudrlin Archers"},
            Text  = {de = "- Kann Gebäude anzünden",
                     en = "- Can tourch buildings"}
        },
    },
    Skills = {
        Dodge = {
            de = "- Kann einem Angriff ausweichen",
            en = "- Can dodge an attack",
        },
        Miracle = {
            de = "- Kann im Kampf vollständig geheilt werden",
            en = "- Can heal fully during a fight",
        },
        BraveStand = {
            de = "- Erleidet verwundet weniger Schaden",
            en = "- Suffers less damage when wounded",
        },
        Critical = {
            de = "- Kann kritische Treffer verursachen",
            en = "- Can inflict critical hits",
        },
        Bleeding = {
            de = "- Stark gegen Einheiten ohne Rüstung",
            en = "- Strong against units without armor",
        },
        Concussion = {
            de = "- Stark gegen Einheiten mit Rüstung",
            en = "- Strong against units with armor",
        },
        Execution = {
            de = "- Kann im Kampf tödliche Treffer landen",
            en = "- Can score fatal blows in battle",
        },
    }
};

