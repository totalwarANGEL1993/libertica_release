Lib.Register("module/io/IO_Config");

Lib.IO = Lib.IO or {};
Lib.IO.Config = {
    Technology = {
        -- Tech name, Description, Icon, Extra Number
        {"R_CallGeologist",   {de = "Geologen rufen",       en = "Order geologist", fr = "Ordre géologue"},       {8, 1, 1}, 1},
        {"R_RefillIronMine",  {de = "Eisenmine auffüllen",  en = "Refill mine",     fr = "Recharger le mien"},    {8, 2, 1}, 1},
        {"R_RefillStoneMine", {de = "Steinbruch auffüllen", en = "Refill quarry",   fr = "Carrière de recharge"}, {8, 3, 1}, 1},
        {"R_RefillCistern",   {de = "Brunnen auffüllen",    en = "Refill well",     fr = "Bien remplir"},         {8, 4, 1}, 1},
        {"R_Tradepost",       {de = "Handelsposten bauen",  en = "Build Tradepost", fr = "Route commerciale"},    {3, 1, 1}, 1},
    }
}

