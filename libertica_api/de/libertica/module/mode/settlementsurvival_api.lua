--- Implementiert Überlebensaspekte von Siedlungen im Spiel.
---
--- Siedler (und Nutztiere) können nun an verschiedenen Ursachen erkranken und
--- möglicherweise sterben. Wenn ein Siedler stirbt, bleibt er weiterhin mit dem
--- Gebäude verbunden, sodass kein anderer Siedler ihn ersetzen kann. Nach
--- einiger Zeit wird ein neuer Siedler eintreffen. Außerdem ist das Bedürfnis
--- nach Kleidung auch für Sammler aktiv.
---
--- Dinge, die Gebäude entzünden:
--- * Hohe Temperatur
---
--- Dinge, die Siedler krank machen:
--- * Unzureichende Hygiene
--- * Unzureichende Unterhaltung
--- * Unzureichendes Brennholz
---
--- Dinge, die Siedler töten:
--- * Krankheit (5%ige Chance pro Periode)
--- * Hunger (5%ige Chance pro Periode)
---
--- Dinge, die Tiere töten:
--- * Krankheit (5%ige Chance pro Periode)
---
--- #### Reports
--- * `Report.AnimalDiedFromIllness` - Ein Tier ist an einer Krankheit gestorben.
--- * `Report.SettlerDiedFromStarvation` - Ein Siedler ist verhungert.
--- * `Report.SettlerDiedFromIllness` - Ein Siedler ist an einer Krankheit gestorben.
---
Lib.SettlementSurvival = Lib.SettlementSurvival or {};

--- Aktiviert oder deaktiviert das Sterben von Tieren an Krankheiten.
--- @param _Flag boolean Funktion ist aktiv
function AnimalPlagueActivate(_Flag)
end
API.AnimalPlagueActivate = AnimalPlagueActivate;

--- Aktiviert oder deaktiviert das Sterben von Tieren an Krankheiten für KI-Spieler.
--- @param _Flag boolean Funktion ist aktiv
function AnimalPlagueActivateForAI(_Flag)
end
API.AnimalPlagueActivateForAI = AnimalPlagueActivateForAI;

--- Aktiviert oder deaktiviert das automatische Erkranken von Tieren.
--- @param _Flag boolean Funktion ist aktiv
function AnimalInfectionActivateAutomatic(_Flag)
end
API.AnimalInfectionActivateAutomatic = AnimalInfectionActivateAutomatic;

--- Ändert das Intervall zwischen den Toden von kranken Tieren.
--- @param _Interval integer Neues Intervall
function AnimalPlagueSetDeathInterval(_Interval)
end
API.AnimalPlagueSetDeathInterval = AnimalPlagueSetDeathInterval;

--- Ändert die Sterbewahrscheinlichkeit für kranke Tiere.
--- @param _Chance integer Wahrscheinlichkeit (zwischen 1 und 100)
function AnimalPlagueSetDeathChance(_Chance)
end
API.AnimalPlagueSetDeathChance = AnimalPlagueSetDeathChance;

--- Ändert das Intervall zwischen Infektionen bei Tieren.
--- @param _Interval integer Neues Intervall
function AnimalPlagueSetInfectionInterval(_Interval)
end
API.AnimalPlagueSetInfectionInterval = AnimalPlagueSetInfectionInterval;

--- Ändert die Infektionswahrscheinlichkeit für Tiere.
--- @param _Chance integer Wahrscheinlichkeit (zwischen 1 und 100)
function AnimalPlagueSetInfectionChance(_Chance)
end
API.AnimalPlagueSetInfectionChance = AnimalPlagueSetInfectionChance;

--- Aktiviert oder deaktiviert Stadtbrände.
--- @param _Flag boolean Funktion ist aktiv
function HotWeatherActivate(_Flag)
end
API.HotWeatherActivate = HotWeatherActivate;

--- Aktiviert oder deaktiviert Stadtbrände für KI-Spieler.
--- @param _Flag boolean Funktion ist aktiv
function HotWeatherActivateForAI(_Flag)
end
API.HotWeatherActivateForAI = HotWeatherActivateForAI;

--- Legt die Temperatur fest, bei der Gebäude Feuer fangen.
--- @param _Temperature integer Start kalter Temperaturen 
function HotWeatherSetTemperature(_Temperature)
end
API.HotWeatherSetTemperature = HotWeatherSetTemperature;

--- Ändert die Chance, dass Gebäude Feuer fangen.
--- @param _Chance integer Wahrscheinlichkeit (zwischen 1 und 100)
function HotWeatherSetIgnitionChance(_Chance)
end
API.HotWeatherSetIgnitionChance = HotWeatherSetIgnitionChance;

--- Aktiviert oder deaktiviert den Bedarf an Brennholz.
--- @param _Flag boolean Funktion ist aktiv
function ColdWeatherActivate(_Flag)
end
API.ColdWeatherActivate = ColdWeatherActivate;

--- Aktiviert oder deaktiviert den Bedarf an Brennholz für KI-Spieler.
--- @param _Flag boolean Funktion ist aktiv
function ColdWeatherActivateForAI(_Flag)
end
API.ColdWeatherActivateForAI = ColdWeatherActivateForAI;

--- Legt die Temperatur fest, ab der das Wetter als unangenehm gilt.
--- @param _Temperature integer Start kalter Temperaturen 
function ColdWeatherSetTemperature(_Temperature)
end
API.ColdWeatherSetTemperature = ColdWeatherSetTemperature;

--- Ändert das Intervall zwischen zwei Brennholzverbrauchsvorgängen.
--- @param _Interval integer Neues Intervall
function ColdWeatherSetConsumptionInterval(_Interval)
end
API.ColdWeatherSetConsumptionInterval = ColdWeatherSetConsumptionInterval;

--- Ändert die Infektionswahrscheinlichkeit aufgrund kalten Wetters.
--- @param _Chance integer Wahrscheinlichkeit (zwischen 1 und 100)
function ColdWeatherSetInfectionChance(_Chance)
end
API.ColdWeatherSetInfectionChance = ColdWeatherSetInfectionChance;

--- Aktiviert oder deaktiviert das Verhungern von Siedlern.
--- @param _Flag boolean Funktion ist aktiv
function FamineActivate(_Flag)
end
API.FamineActivate = FamineActivate;

--- Aktiviert oder deaktiviert das Verhungern von Siedlern für KI-Spieler.
--- @param _Flag boolean Funktion ist aktiv
function FamineActivateForAI(_Flag)
end
API.FamineActivateForAI = FamineActivateForAI;

--- Ändert das Intervall zwischen den Toden aufgrund von Verhungern.
--- @param _Interval integer Neues Intervall
function FamineSetDeathInterval(_Interval)
end
API.FamineSetDeathInterval = FamineSetDeathInterval;

--- Ändert die Sterbewahrscheinlichkeit für verhungernde Siedler.
--- @param _Chance integer Wahrscheinlichkeit (zwischen 1 und 100)
function FamineSetDeathChance(_Chance)
end
API.FamineSetDeathChance = FamineSetDeathChance;

--- Aktiviert oder deaktiviert das Krankwerden von Siedlern durch Vernachlässigung.
--- @param _Flag boolean Funktion ist aktiv
function NegligenceActivate(_Flag)
end
API.NegligenceActivate = NegligenceActivate;

--- Aktiviert oder deaktiviert das Krankwerden von Siedlern durch Vernachlässigung für KI-Spieler.
--- @param _Flag boolean Funktion ist aktiv
function NegligenceActivateForAI(_Flag)
end
API.NegligenceActivateForAI = NegligenceActivateForAI;

--- Ändert das Intervall zwischen Infektionen aufgrund von Vernachlässigung.
--- @param _Interval integer Neues Intervall
function NegligenceSetInfectionInterval(_Interval)
end
API.NegligenceSetInfectionInterval = NegligenceSetInfectionInterval;

--- Ändert die Infektionswahrscheinlichkeit aufgrund von Vernachlässigung.
--- @param _Chance integer Wahrscheinlichkeit (zwischen 1 und 100)
function NegligenceSetInfectionChance(_Chance)
end
API.NegligenceSetInfectionChance = NegligenceSetInfectionChance;

--- Aktiviert oder deaktiviert das Sterben von Siedlern an Krankheiten.
--- @param _Flag boolean Funktion ist aktiv
function PlagueActivate(_Flag)
end
API.PlagueActivate = PlagueActivate;

--- Aktiviert oder deaktiviert das Sterben von Siedlern an Krankheiten für KI-Spieler.
--- @param _Flag boolean Funktion ist aktiv
function PlagueActivateForAI(_Flag)
end
API.PlagueActivateForAI = PlagueActivateForAI;

--- Ändert das Intervall zwischen den Toden von kranken Siedlern.
--- @param _Interval integer Neues Intervall
function PlagueSetDeathInterval(_Interval)
end
API.PlagueSetDeathInterval = PlagueSetDeathInterval;

--- Ändert die Sterbewahrscheinlichkeit für kranke Siedler.
--- @param _Chance integer Wahrscheinlichkeit (zwischen 1 und 100)
function PlagueSetDeathChance(_Chance)
end
API.PlagueSetDeathChance = PlagueSetDeathChance;



--- Ein Tier ist an Krankheit gestorben.
---
--- #### Parameter
--- `EntityID` - ID des Tieres
Report.AnimalDiedFromIllness = anyInteger;

--- Ein Siedler ist verhungert.
---
--- #### Parameter
--- `EntityID` - ID des Siedlers
Report.SettlerDiedFromStarvation = anyInteger;

--- Ein Siedler ist an Krankheit gestorben.
---
--- #### Parameter
--- `EntityID` - ID des Siedlers
Report.SettlerDiedFromIllness = anyInteger;

