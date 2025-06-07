-- Behavior des Core-Modul.

--- Aktiviert den Debug.
---
--- @param _Assertions boolean Assertions aktivieren
--- @param _CheckAtRun boolean Prüfe Quests zur Laufzeit
--- @param _DevelopingCheats boolean Aktiviert Cheats
--- @param _DevelopingShell boolean Aktiviert Eingabe
--- @param _TraceQuests boolean Aktiviert Questverfolgung
---
function Reward_DEBUG(_Assertions, _CheckAtRun, _DevelopingCheats, _DevelopingShell, _TraceQuests)
end

---
--- Ein Interaktives Objekt muss benutzt werden.
---
--- @param _ScriptName string Skriptname des interaktiven Objektes
---
function Goal_ActivateObject(_ScriptName)
end

---
--- Einem Spieler müssen Rohstoffe oder Waren gesendet werden.
---
--- In der Regel wird zum Auftraggeber gesendet. Es ist aber möglich auch zu
--- einem anderen Zielspieler schicken zu lassen. Wird ein Wagen gefangen
--- genommen, dann muss erneut geschickt werden. Optional kann dem Spieler
--- auch erlaubt werden, den Karren zurückzuerobern.
---
--- @param _GoodType       string Typ der Ware
--- @param _GoodAmount     integer Menga der Ware
--- @param _OtherTarget?   integer Anderes Ziel als Auftraggeber
--- @param _IgnoreCapture? boolean Wagen kann zurückerobert werden
---
function Goal_Deliver(_GoodType, _GoodAmount, _OtherTarget, _IgnoreCapture)
end

---
--- Es muss ein bestimmter Diplomatiestatus zu einer anderen Patei erreicht
--- werden. Der Status kann eine Verbesserung oder eine Verschlechterung zum
--- aktuellen Status sein.
---
--- Die Relation kann entweder auf kleiner oder gleich (<=), größer oder gleich
--- (>=), oder exakte Gleichheit (==) eingestellt werden. Exakte GLeichheit ist
--- wegen der Gefahr eines Soft Locks mit Vorsicht zu genießen.
---
--- @param _PlayerID integer Partei, die Entdeckt werden muss
--- @param _Relation string Größer-Kleiner-Relation
--- @param _State    string Diplomatiestatus
---
function Goal_Diplomacy(_PlayerID, _Relation, _State)
end

---
--- Das Heimatterritorium des Spielers muss entdeckt werden.
---
--- Das Heimatterritorium ist immer das, wo sich Burg oder Lagerhaus der
--- zu entdeckenden Partei befinden.
---
--- @param _PlayerID integer ID der zu entdeckenden Partei
---
function Goal_DiscoverPlayer(_PlayerID)
end

---
--- Ein Territorium muss erstmalig vom Auftragnehmer betreten werden.
---
--- Wenn ein Spieler zuvor mit seinen Einheiten auf dem Territorium war, ist
--- es bereits entdeckt und das Ziel sofort erfüllt.
---
--- @param _Territory any Name oder ID des Territorium
---
function Goal_DiscoverTerritory(_Territory)
end

---
--- Eine andere Partei muss besiegt werden.
---
--- Die Partei gilt als besiegt, wenn ein Hauptgebäude (Burg, Kirche, Lager)
--- zerstört wurde.
--- <p>
--- <b>Achtung:</b> Bei Banditen ist dieses Behavior wenig sinnvoll, da sie
--- nicht durch zerstörung ihres Hauptzeltes vernichtet werden. Hier bietet
--- sich Goal_DestroyAllPlayerUnits an.
---
--- @param _PlayerID integer ID des Spielers
---
function Goal_DestroyPlayer(_PlayerID)
end

---
--- Es sollen Informationen aus der Burg gestohlen werden.
---
--- Der Spieler muss einen Dieb entsenden um Informationen aus der Burg zu
--- stehlen. 
--- <p>
--- <b>Achtung:</b> Das ist nur bei Feinden möglich!
---
--- @param _PlayerID integer ID der Partei
---
function Goal_StealInformation(_PlayerID)
end

---
--- Alle Einheiten des Spielers müssen zerstört werden.
---
--- <b>Achtung</b>: Bei normalen Parteien, welche ein Dorf oder eine Stadt
--- besitzen, ist Goal_DestroyPlayer besser geeignet!
---
--- @param _PlayerID integer ID des Spielers
---
function Goal_DestroyAllPlayerUnits(_PlayerID)
end

---
--- Ein benanntes Entity muss zerstört werden.
---
--- Ein Entity gilt als zerstört, wenn es nicht mehr existiert oder während
--- der Laufzeit des Quests seine Entity-ID oder den Besitzer verändert.
---
--- <b>Achtung</b>: Helden können nicht direkt zerstört werden. Bei ihnen
--- genügt es, wenn sie sich "in die Burg zurückziehen".
---
--- @param _ScriptName string Skriptname des Ziels
---
function Goal_DestroyScriptEntity(_ScriptName)
end

---
--- Eine Menge an Entities eines Typs müssen zerstört werden.
---
--- <b>Achtung</b>: Wenn Raubtiere zerstört werden sollen, muss Spieler 0
--- als Besitzer angegeben werden.
---
--- @param _EntityType string Typ des Entity
--- @param _Amount     integer Menge an Entities des Typs
--- @param _PlayerID   integer Besitzer des Entity
---
function Goal_DestroyType(_EntityType, _Amount, _PlayerID)
end

---
--- Eine Entfernung zwischen zwei Entities muss erreicht werden.
---
--- Je nach angegebener Relation muss die Entfernung unter- oder überschritten
--- werden, um den Quest zu gewinnen.
---
--- @param _ScriptName1  string Erstes Entity
--- @param _ScriptName2  string Zweites Entity
--- @param _Relation     string Relation
--- @param _Distance     integer Entfernung
---
function Goal_EntityDistance(_ScriptName1, _ScriptName2, _Relation, _Distance)
end

---
--- Der Primary Knight des angegebenen Spielers muss sich dem Ziel nähern.
---
--- Die Distanz, die unterschritten werden muss, kann frei bestimmt werden.
--- Wird die Distanz 0 belassen, wird sie automatisch 2500.
---
--- @param _ScriptName string Skriptname des Ziels
--- @param _Disctande  integer (optional) Entfernung zum Ziel
---
function Goal_KnightDistance(_ScriptName, _Disctande)
end

---
--- Eine bestimmte Anzahl an Einheiten einer Kategorie muss sich auf dem
--- Territorium befinden.
---
--- Es kann entweder gefordert werden, weniger als die angegebene Menge auf
--- dem Territorium zu haben (z.B. "<"" 1 für 0) oder mindestens so
--- viele Entities (z.B. ">=" 5 für mindestens 5).
---
--- @param _Territory  integer TerritoryID oder TerritoryName
--- @param _PlayerID   integer PlayerID der Einheiten
--- @param _Category   string Kategorie der Einheiten
--- @param _Relation   string Mengenrelation (< oder >=)
--- @param _Amount     integer Menge an Einheiten
---
function Goal_UnitsOnTerritory(_Territory, _PlayerID, _Category, _Relation, _Amount)
end

---
--- Der angegebene Spieler muss einen Buff aktivieren.
---
--- <u>Buffs "Aufstieg eines Königreich"</u>
--- <li>Buff_Spice: Salz</li>
--- <li>Buff_Colour: Farben</li>
--- <li>Buff_Entertainers: Entertainer anheuern</li>
--- <li>Buff_FoodDiversity: Vielfältige Nahrung</li>
--- <li>Buff_ClothesDiversity: Vielfältige Kleidung</li>
--- <li>Buff_HygieneDiversity: Vielfältige Hygiene</li>
--- <li>Buff_EntertainmentDiversity: Vielfältige Unterhaltung</li>
--- <li>Buff_Sermon: Predigt halten</li>
--- <li>Buff_Festival: Fest veranstalten</li>
--- <li>Buff_ExtraPayment: Bonussold auszahlen</li>
--- <li>Buff_HighTaxes: Hohe Steuern verlangen</li>
--- <li>Buff_NoPayment: Sold streichen</li>
--- <li>Buff_NoTaxes: Keine Steuern verlangen</li>
--- <br/>
--- <u>Buffs "Reich des Ostens"</u>
--- <li>Buff_Gems: Edelsteine</li>
--- <li>Buff_MusicalInstrument: Musikinstrumente</li>
--- <li>Buff_Olibanum: Weihrauch</li>
---
--- @param _PlayerID integer Spieler, der den Buff aktivieren muss
--- @param _Buff     string Buff, der aktiviert werden soll
---
function Goal_ActivateBuff(_PlayerID, _Buff)
end

---
--- Zwei Punkte auf der Spielwelt müssen mit einer Straße verbunden werden.
---
--- @param _Position1 any Erster Endpunkt der Straße
--- @param _Position2 any Zweiter Endpunkt der Straße
--- @param _OnlyRoads boolean Keine Wege akzeptieren
---
function Goal_BuildRoad(_Position1, _Position2, _OnlyRoads)
end

---
--- Eine Mauer muss gebaut werden um die Bewegung eines Spielers einzuschränken.
--- 
--- Einschränken bedeutet, dass sich der angegebene Spieler nicht von Punkt A
--- nach Punkt B bewegen kann, weil eine Mauer im Weg ist. Die Punkte sind
--- frei wählbar. In den meisten Fällen reicht es, Marktplätze anzugeben.
---
--- Beispiel: Spieler 3 ist der Feind von Spieler 1, aber Bekannt mit Spieler 2.
--- Wenn er sich nicht mehr zwischen den Marktplätzen von Spieler 1 und 2
--- bewegen kann, weil eine Mauer dazwischen ist, ist das Ziel erreicht.
--- <p>
--- <b>Achtung:</b> Bei Monsun kann dieses Ziel fälschlicher Weise als erfüllt
--- gewertet werden, wenn der Weg durch Wasser blockiert wird!
---
--- @param _PlayerID  integer PlayerID, die blockiert wird
--- @param _Position1 any Erste Position
--- @param _Position2 any Zweite Position
---
function Goal_BuildWall(_PlayerID, _Position1, _Position2)
end

---
--- Ein bestimmtes Territorium muss vom Auftragnehmer eingenommen werden.
---
--- @param _Territory integer Territorium-ID oder Territoriumname
---
function Goal_Claim(_Territory)
end

---
--- Der Auftragnehmer muss eine Menge an Territorien besitzen.
--- Das Heimatterritorium des Spielers wird mitgezählt!
---
--- @param _Amount integer Anzahl Territorien
---
function Goal_ClaimXTerritories(_Amount)
end

---
--- Der Auftragnehmer muss auf dem Territorium einen Entitytyp erstellen.
---
--- Dieses Behavior eignet sich für Aufgaben vom Schlag "Baue X Getreidefarmen
--- Auf Territorium >".
---
--- @param _Type      string Typ des Entity
--- @param _Amount    integer Menge an Entities
--- @param _Territory any Territorium
---
function Goal_Create(_Type, _Amount, _Territory)
end

---
--- Der Auftragnehmer muss eine Menge von Rohstoffen produzieren.
---
--- @param _Type   string Typ des Rohstoffs
--- @param _Amount integer Menge an Rohstoffen
---
function Goal_Produce(_Type, _Amount)
end

---
--- Der Spieler muss eine bestimmte Menge einer Ware erreichen.
---
--- @param _Type     string Typ der Ware
--- @param _Amount   integer Menge an Waren
--- @param _Relation string Mengenrelation
---
function Goal_GoodAmount(_Type, _Amount, _Relation)
end

---
--- Die Siedler des Spielers dürfen nicht aufgrund des Bedürfnisses streiken.
---
--- <u>Bedürfnisse</u>
--- <ul>
--- <li>Clothes: Kleidung</li>
--- <li>Entertainment: Unterhaltung</li>
--- <li>Nutrition: Nahrung</li>
--- <li>Hygiene: Hygiene</li>
--- <li>Medicine: Medizin</li>
--- </ul>
---
--- @param _PlayerID integer ID des Spielers
--- @param _Need     string Bedürfnis
---
function Goal_SatisfyNeed(_PlayerID, _Need)
end

---
--- Der angegebene Spieler muss eine Menge an Siedlern in der Stadt haben.
---
--- @param _Amount   integer Menge an Siedlern
--- @param _PlayerID integer ID des Spielers (Default: 1)
---
function Goal_SettlersNumber(_Amount, _PlayerID)
end

---
--- Der Auftragnehmer muss eine Menge von Ehefrauen in der Stadt haben.
---
--- @param _Amount integer Menge an Ehefrauen
---
function Goal_Spouses(_Amount)
end

---
--- Ein Spieler muss eine Menge an Soldaten haben.
---
--- <u>Relationen</u>
--- <ul>
--- <li>>= - Anzahl als Mindestmenge</li>
--- <li>< - Weniger als Anzahl</li>
--- </ul>
---
--- Dieses Behavior kann verwendet werden um die Menge an feindlichen
--- Soldaten zu zählen oder die Menge an Soldaten des Spielers.
---
--- @param _PlayerID integer ID des Spielers
--- @param _Relation string Mengenrelation
--- @param _Amount   integer Menge an Soldaten
---
function Goal_SoldierCount(_PlayerID, _Relation, _Amount)
end

---
--- Der Auftragnehmer muss wenigstens einen bestimmten Titel erreichen.
---
--- Folgende Titel können verwendet werden:
--- <table border="1">
--- <tr>
--- <td><b>Titel</b></td>
--- <td><b>Übersetzung</b></td>
--- </tr>
--- <tr>
--- <td>Knight</td>
--- <td>Ritter</td>
--- </tr>
--- <tr>
--- <td>Mayor</td>
--- <td>Landvogt</td>
--- </tr>
--- <tr>
--- <td>Baron</td>
--- <td>Baron</td>
--- </tr>
--- <tr>
--- <td>Earl</td>
--- <td>Graf</td>
--- </tr>
--- <tr>
--- <td>Marquees</td>
--- <td>Marktgraf</td>
--- </tr>
--- <tr>
--- <td>Duke</td>
--- <td>Herzog</td>
--- </tr>
--- </tr>
--- <tr>
--- <td>Archduke</td>
--- <td>Erzherzog</td>
--- </tr>
--- <table>
---
--- @param _Title string Titel, der erreicht werden muss
---
function Goal_KnightTitle(_Title)
end

---
--- Der angegebene Spieler muss mindestens die Menge an Festen feiern.
---
--- Ein Fest wird gewertet, sobald die Metfässer auf dem Markt erscheinen. Diese
--- Metfässer erscheinen im normalen Spielverlauf nur durch ein Fest!
---
--- <b>Achtung</b>: Wenn ein Spieler aus einem anderen Grund Metfässer besitzt,
--- wird dieses Behavior nicht mehr richtig funktionieren!
---
--- @param _PlayerID integer ID des Spielers
--- @param _Amount   integer Menge an Festen
---
function Goal_Festivals(_PlayerID, _Amount)
end

---
--- Der Auftragnehmer muss eine Einheit gefangen nehmen.
---
--- @param _ScriptName string Ziel
---
function Goal_Capture(_ScriptName)
end

---
--- Der Auftragnehmer muss eine Menge von Einheiten eines Typs von einem
--- Spieler gefangen nehmen.
---
--- @param _Typ      string Typ, der gefangen werden soll
--- @param _Amount   integer Menge an Einheiten
--- @param _PlayerID integer Besitzer der Einheiten
---
function Goal_CaptureType(_Typ, _Amount, _PlayerID)
end

---
--- Der Auftragnehmer muss das angegebene Entity beschützen.
---
--- Wird ein Wagen zerstört oder in das Lagerhaus / die Burg eines Feindes
--- gebracht, schlägt das Ziel fehl.
---
--- @param _ScriptName string Zu beschützendes Entity
---
function Goal_Protect(_ScriptName)
end

---
--- Der Auftragnehmer muss eine Mine mit einem Geologen wieder auffüllen.
---
--- <b>Achtung</b>: Dieses Behavior ist nur in "Reich des Ostens" verfügbar.
---
--- @param _ScriptName string Skriptname der Mine
---
function Goal_Refill(_ScriptName)
end

---
--- Eine bestimmte Menge an Rohstoffen in einer Mine muss erreicht werden.
---
--- Dieses Behavior eignet sich besonders für den Einsatz als versteckter
--- Quest um eine Reaktion auszulösen, wenn z.B. eine Mine leer ist.
---
--- <u>Relationen</u>
--- <ul>
--- <li>> - Mehr als Anzahl</li>
--- <li>< - Weniger als Anzahl</li>
--- </ul>
---
--- @param _ScriptName string Skriptname der Mine
--- @param _Relation   string Mengenrelation
--- @param _Amount     integer Menge an Rohstoffen
---
function Goal_ResourceAmount(_ScriptName, _Relation, _Amount)
end

---
--- Der Quest schlägt sofort fehl.
---
function Goal_InstantFailure()
end

---
--- Der Quest wird sofort erfüllt.
---
function Goal_InstantSuccess()
end

---
--- Der Zustand des Quests ändert sich niemals
---
--- Wenn ein Zeitlimit auf dem Quest liegt, wird dieses Behavior nicht
--- fehlschlagen sondern automatisch erfüllt.
---
function Goal_NoChange()
end

---
--- Führt eine Funktion im Skript als Goal aus.
---
--- Die Funktion muss entweder true, false oder nichts zurückgeben.
--- <ul>
--- <li>true: Erfolgreich abgeschlossen</li>
--- <li>false: Fehlschlag</li>
--- <li>nichts: Zustand unbestimmt</li>
--- </ul>
---
--- Anstelle eines Strings kann beim Einsatz im Skript eine Funktionsreferenz
--- übergeben werden. In diesem Fall werden alle weiteren Parameter direkt an
--- die Funktion weitergereicht.
---
--- @param _FunctionName any Name der Funktion
--- @param ... any Optional parameters
---
function Goal_MapScriptFunction(_FunctionName, ...)
end

---
--- Eine benutzerdefinierte Variable muss einen bestimmten Wert haben.
---
--- Custom Variables können ausschließlich Zahlen enthalten. Bevor eine
--- Variable in einem Goal abgefragt werden kann, muss sie zuvor mit
--- Reprisal_CustomVariables oder Reward_CutsomVariables initialisiert
--- worden sein.
---
--- <p>Vergleichsoperatoren</p>
--- <ul>
--- <li>== - Werte müssen gleich sein</li>
--- <li>~= - Werte müssen ungleich sein</li>
--- <li>> - Variablenwert größer Vergleichswert</li>
--- <li>>= - Variablenwert größer oder gleich Vergleichswert</li>
--- <li>< - Variablenwert kleiner Vergleichswert</li>
--- <li><= - Variablenwert kleiner oder gleich Vergleichswert</li>
--- </ul>
---
--- @param _Name     string Name der Variable
--- @param _Relation string Vergleichsoperator
--- @param _Value    any Wert oder andere Custom Variable mit wert.
---
function Goal_CustomVariables(_Name, _Relation, _Value)
end

---
--- Deaktiviert ein interaktives Objekt.
---
--- @param _ScriptName string Skriptname des interaktiven Objektes
---
function Reprisal_ObjectDeactivate(_ScriptName)
end

---
--- Aktiviert ein interaktives Objekt.
---
--- Der Status bestimmt, wie das Objekt aktiviert wird.
--- <ul>
--- <li>0: Kann nur mit Helden aktiviert werden</li>
--- <li>1: Kann immer aktiviert werden</li>
--- <li>2: Kann niemals aktiviert werden</li>
--- </ul>
---
--- @param _ScriptName string Skriptname des interaktiven Objektes
--- @param _State      integer Status des Objektes
---
function Reprisal_ObjectActivate(_ScriptName, _State)
end

---
--- Der diplomatische Status zwischen Sender und Empfänger verschlechtert sich
--- um eine Stufe.
---
function Reprisal_DiplomacyDecrease()
end

---
--- Änder den Diplomatiestatus zwischen zwei Spielern.
---
--- @param _Party1   integer ID der ersten Partei
--- @param _Party2   integer ID der zweiten Partei
--- @param _State    string Neuer Diplomatiestatus
---
function Reprisal_Diplomacy(_Party1, _Party2, _State)
end

---
--- Ein benanntes Entity wird entfernt.
---
--- <b>Hinweis</b>: Das Entity wird durch ein XD_ScriptEntity ersetzt. Es
--- behält Name, Besitzer und Ausrichtung.
---
--- @param _ScriptName string Skriptname des Entity
---
function Reprisal_DestroyEntity(_ScriptName)
end

---
--- Zerstört einen über ein Behavior erzeugten Effekt.
---
--- @param _EffectName string Name des Effekts
---
function Reprisal_DestroyEffect(_EffectName)
end

---
--- Der Spieler verliert das Spiel.
---
function Reprisal_Defeat()
end

---
--- Zeigt die Niederlagedekoration am Quest an.
---
--- Es handelt sich dabei um reine Optik! Der Spieler wird nicht verlieren.
---
function Reprisal_FakeDefeat()
end

---
--- Ein Entity wird durch ein neues anderen Typs ersetzt.
---
--- Das neue Entity übernimmt Skriptname, Besitzer  und Ausrichtung des 
--- alten Entity.
---
--- @param _Entity string Skriptname oder ID des Entity
--- @param _Type   string Neuer Typ des Entity
--- @param _Owner  integer Besitzer des Entity
---
function Reprisal_ReplaceEntity(_Entity, _Type, _Owner)
end

---
--- Startet einen Quest neu.
---
--- @param _QuestName string Name des Quest
---
function Reprisal_QuestRestart(_QuestName)
end

---
--- Lässt einen Quest fehlschlagen.
---
--- @param _QuestName string Name des Quest
---
function Reprisal_QuestFailure(_QuestName)
end

---
--- Wertet einen Quest als erfolgreich.
---
--- @param _QuestName string Name des Quest
---
function Reprisal_QuestSuccess(_QuestName)
end

---
--- Triggert einen Quest.
---
--- @param _QuestName string Name des Quest
---
function Reprisal_QuestActivate(_QuestName)
end

---
--- Unterbricht einen Quest.
---
--- @param _QuestName string Name des Quest
---
function Reprisal_QuestInterrupt(_QuestName)
end

---
--- Unterbricht einen Quest, selbst wenn dieser noch nicht ausgelöst wurde.
---
--- @param _QuestName   string Name des Quest
--- @param _EndetQuests string Bereits beendete unterbrechen
---
function Reprisal_QuestForceInterrupt(_QuestName, _EndetQuests)
end

---
--- Ändert den Wert einer benutzerdefinierten Variable.
---
--- Benutzerdefinierte Variablen können ausschließlich Zahlen sein. Nutze
--- dieses Behavior bevor die Variable in einem Goal oder Trigger abgefragt
--- wird, um sie zu initialisieren!
---
--- <p>Operatoren</p>
--- <ul>
--- <li>= - Variablenwert wird auf den Wert gesetzt</li>
--- <li>- - Variablenwert mit Wert Subtrahieren</li>
--- <li>+ - Variablenwert mit Wert addieren</li>
--- <li>* - Variablenwert mit Wert multiplizieren</li>
--- <li>/ - Variablenwert mit Wert dividieren</li>
--- <li>^ - Variablenwert mit Wert potenzieren</li>
--- </ul>
---
--- @param _Name     string Name der Variable
--- @param _Operator string Rechen- oder Zuweisungsoperator
--- @param _Value    integer Wert oder andere Custom Variable
---
function Reprisal_CustomVariables(_Name, _Operator, _Value)
end

---
--- Führt eine Funktion im Skript als Reprisal aus.
---
--- Wird ein Funktionsname als String übergeben, wird die Funktion mit den
--- Daten des Behavors und des zugehörigen Quest aufgerufen (Standard).
---
--- Wird eine Funktionsreferenz angegeben, wird die Funktion zusammen mit allen
--- optionalen Parametern aufgerufen, als sei es ein gewöhnlicher Aufruf im
--- Skript.
--- <pre> Reprisal_MapScriptFunction(ReplaceEntity, "block", Entities.XD_ScriptEntity);
--- -- entspricht: ReplaceEntity("block", Entities.XD_ScriptEntity);</pre>
--- <p>
--- <b>Achtung:</b> Nicht über den Assistenten verfügbar!
---
--- @param _Function string any der Funktion oder Funktionsreferenz
--- @param ... any Optional parameters
---
function Reprisal_MapScriptFunction(_Function, ...)
end

---
--- Erlaubt oder verbietet einem Spieler ein Recht.
---
--- @param _PlayerID   integer ID des Spielers
--- @param _Lock       string Sperren/Entsperren
--- @param _Technology string Name des Rechts
---
function Reprisal_Technology(_PlayerID, _Lock, _Technology)
end

---
--- Deaktiviert ein interaktives Objekt
---
--- @param _ScriptName string Skriptname des interaktiven Objektes
---
function Reward_ObjectDeactivate(_ScriptName)
end

---
--- Aktiviert ein interaktives Objekt.
---
--- Der Status bestimmt, wie das objekt aktiviert wird.
--- <ul>
--- <li>0: Kann nur mit Helden aktiviert werden</li>
--- <li>1: Kann immer aktiviert werden</li>
--- <li>2: Kann niemals aktiviert werden</li>
--- </ul>
---
--- @param _ScriptName string Skriptname des interaktiven Objektes
--- @param _State integer Status des Objektes
---
function Reward_ObjectActivate(_ScriptName, _State)
end

---
--- Initialisiert ein interaktives Objekt.
---
--- Interaktive Objekte können Kosten und Belohnungen enthalten, müssen sie
--- jedoch nicht. Ist eine Wartezeit angegeben, kann das Objekt erst nach
--- Ablauf eines Cooldowns benutzt werden.
---
--- @param _ScriptName string Skriptname des interaktiven Objektes
--- @param _Distance   integer Entfernung zur Aktivierung
--- @param _Time       integer Wartezeit bis zur Aktivierung
--- @param _RType1     string Warentyp der Belohnung
--- @param _RAmount    integer Menge der Belohnung
--- @param _CType1     string Typ der 1. Ware
--- @param _CAmount1   integer Menge der 1. Ware
--- @param _CType2     string Typ der 2. Ware
--- @param _CAmount2   integer Menge der 2. Ware
--- @param _Status     integer Aktivierung (0: Held, 1: immer, 2: niemals)
---
function Reward_ObjectInit(_ScriptName, _Distance, _Time, _RType1, _RAmount, _CType1, _CAmount1, _CType2, _CAmount2, _Status)
end

---
--- Änder den Diplomatiestatus zwischen zwei Spielern.
---
--- @param _Party1   integer ID der ersten Partei
--- @param _Party2   integer ID der zweiten Partei
--- @param _State    string Neuer Diplomatiestatus
---
function Reward_Diplomacy(_Party1, _Party2, _State)
end

---
--- Verbessert die diplomatischen Beziehungen zwischen Sender und Empfänger
--- um einen Grad.
---
function Reward_DiplomacyIncrease()
end

--- Initialisiert einen Handelsposten, bereitet die Angebote für einen Spieler
--- vor und deaktiviert den Handelsposten danach.
---
--- @param _ScriptName string Skriptname des Handelsposten
--- @param _PlayerID integer Spieler der Angebot erhält
--- @param _pt1 string Typ der Bezahlung
--- @param _pa1 integer Menge der Bezehlung
--- @param _gt1 string Typ der Tauschware
--- @param _ga1 integer Menge der Tauschware
--- @param _pt2 string Typ der Bezahlung
--- @param _pa2 integer Menge der Bezehlung
--- @param _gt2 string Typ der Tauschware
--- @param _ga2 integer Menge der Tauschware
--- @param _pt3 string Typ der Bezahlung
--- @param _pa3 integer AMenge der Bezehlung
--- @param _gt3 string Typ der Tauschware
--- @param _ga3 integer Menge der Tauschware
--- @param _pt4 string Typ der Bezahlung
--- @param _pa4 integer Menge der Bezehlung
--- @param _gt4 string Typ der Tauschware
--- @param _ga4 integer Menge der Tauschware
---
function Reward_TradePost(_ScriptName, _PlayerID, _pt1, _pa1, _gt1, _ga1, _pt2, _pa2, _gt2, _ga2, _pt3, _pa3, _gt3, _ga3, _pt4, _pa4, _gt4, _ga4)
end

---
--- Erzeugt Handelsangebote im Lagerhaus des angegebenen Spielers.
---
--- Sollen Angebote gelöscht werden, muss "-" als Ware ausgewählt werden.
--- 
--- <p>
--- <b>Achtung:</b> Stadtlagerhäuser können keine Söldner anbieten!
---
--- @param _PlayerID integer Partei, die Anbietet
--- @param _Amount1  integer Menge des 1. Angebot
--- @param _Type1    string Ware oder Typ des 1. Angebot
--- @param _Amount2  integer Menge des 2. Angebot
--- @param _Type2    string Ware oder Typ des 2. Angebot
--- @param _Amount3  integer Menge des 3. Angebot
--- @param _Type3    string Ware oder Typ des 3. Angebot
--- @param _Amount4  integer Menge des 4. Angebot
--- @param _Type4    string Ware oder Typ des 4. Angebot
---
function Reward_TradeOffers(_PlayerID, _Amount1, _Type1, _Amount2, _Type2, _Amount3, _Type3, _Amount4, _Type4)
end

---
--- Ein benanntes Entity wird entfernt.
---
--- <b>Hinweis</b>: Das Entity wird durch ein XD_ScriptEntity ersetzt. Es
--- behält Name, Besitzer und Ausrichtung.
---
--- @param _ScriptName string Skriptname des Entity
---
function Reward_DestroyEntity(_ScriptName)
end

---
--- Zerstört einen über ein Behavior erzeugten Effekt.
---
--- @param _EffectName string Name des Effekts
---
function Reward_DestroyEffect(_EffectName)
end

---
--- Ersetzt ein Entity mit einem Batallion.
---
--- Ist die Position ein Gebäude, werden die Battalione am Eingang erzeugt und
--- Das Entity wird nicht ersetzt.
---
--- Das erzeugte Battalion kann vor der KI des Besitzers versteckt werden.
---
--- @param _Position    string Skriptname des Entity
--- @param _PlayerID    integer PlayerID des Battalion
--- @param _UnitType    string Einheitentyp der Soldaten
--- @param _Orientation integer Ausrichtung in °
--- @param _Soldiers    integer Anzahl an Soldaten
--- @param _HideFromAI  boolean Vor KI verstecken
---
function Reward_CreateBattalion(_Position, _PlayerID, _UnitType, _Orientation, _Soldiers, _HideFromAI)
end

---
--- Erzeugt eine Menga von Battalionen an der Position.
---
--- Die erzeugten Battalione können vor der KI ihres Besitzers versteckt werden.
---
--- @param _Amount      integer Anzahl erzeugter Battalione
--- @param _Position    string Skriptname des Entity
--- @param _PlayerID    integer PlayerID des Battalion
--- @param _UnitType    string EEinheitentyp der Soldaten
--- @param _Orientation integer Ausrichtung in °
--- @param _Soldiers    integer Anzahl an Soldaten
--- @param _HideFromAI  boolean Vor KI verstecken
---
function Reward_CreateSeveralBattalions(_Amount, _Position, _PlayerID, _UnitType, _Orientation, _Soldiers, _HideFromAI)
end

---
--- Erzeugt einen Effekt an der angegebenen Position.
---
--- Der Effekt kann über seinen Namen jeder Zeit gelöscht werden.
---
--- <b>Achtung</b>: Feuereffekte sind bekannt dafür Abstürzue zu verursachen.
--- Vermeide sie entweder ganz oder unterbinde das Speichern, solange ein
--- solcher Effekt aktiv ist!
---
--- @param _EffectName  string Einzigartiger Effektname
--- @param _TypeName    string Typ des Effekt
--- @param _PlayerID    integer PlayerID des Effekt
--- @param _Location    integer Position des Effekt
--- @param _Orientation integer Ausrichtung in °
---
function Reward_CreateEffect(_EffectName, _TypeName, _PlayerID, _Location, _Orientation)
end

---
--- Ersetzt ein Entity mit dem Skriptnamen durch ein neues Entity.
---
--- Ist die Position ein Gebäude, werden die Entities am Eingang erzeugt und
--- die Position wird nicht ersetzt.
---
--- Das erzeugte Entity kann vor der KI des Besitzers versteckt werden.
---
--- @param _ScriptName  string Skriptname des Entity
--- @param _PlayerID    integer PlayerID des Effekt
--- @param _TypeName    string Typname des Entity
--- @param _Orientation integer Ausrichtung in °
--- @param _HideFromAI  boolean Vor KI verstecken
---
function Reward_CreateEntity(_ScriptName, _PlayerID, _TypeName, _Orientation, _HideFromAI)
end

---
---  Erzeugt mehrere Entities an der angegebenen Position.
--- 
---  Die erzeugten Entities können vor der KI ihres Besitzers versteckt werden.
--- 
---  @param _Amount      integer Anzahl an Entities
---  @param _ScriptName  string Skriptname des Entity
---  @param _PlayerID    integer PlayerID des Effekt
---  @param _TypeName    string Einzigartiger Effektname
---  @param _Orientation integer Ausrichtung in °
---  @param _HideFromAI  boolean Vor KI verstecken
--- 
function Reward_CreateSeveralEntities(_Amount, _ScriptName, _PlayerID, _TypeName, _Orientation, _HideFromAI)
end

---
--- Bewegt einen Siedler, einen Helden oder ein Battalion zum angegebenen 
--- Zielort.
---
--- @param _Settler     string Einheit, die bewegt wird
--- @param _Destination string Bewegungsziel
---
function Reward_MoveSettler(_Settler, _Destination)
end

---
--- Der Spieler gewinnt das Spiel.
---
function Reward_Victory()
end

---
--- Der Spieler verliert das Spiel.
---
---
function Reward_Defeat()
end

---
--- Zeigt die Siegdekoration an dem Quest an.
---
--- Dies ist reine Optik! Der Spieler wird dadurch nicht das Spiel gewinnen.
---
function Reward_FakeVictory()
end

---
--- Erzeugt eine Armee, die das angegebene Territorium angreift.
---
--- Die Armee wird versuchen Gebäude auf dem Territrium zu zerstören.
--- <ul>
--- <li>Außenposten: Die Armee versucht den Außenposten zu zerstören</li>
--- <li>Stadt: Die Armee versucht das Lagerhaus zu zerstören</li>
--- </ul>
---
--- @param _PlayerID   integer PlayerID der Angreifer
--- @param _SpawnPoint string Skriptname des Entstehungspunkt
--- @param _Territory  string Zielterritorium
--- @param _Sword      integer Anzahl Schwertkämpfer (Battalion)
--- @param _Bow        integer Anzahl Bogenschützen (Battalion)
--- @param _Cata       integer Anzahl Katapulte
--- @param _Towers     integer Anzahl Belagerungstürme
--- @param _Rams       integer Anzahl Rammen
--- @param _Ammo       integer Anzahl Munitionswagen
--- @param _Type       string Typ der Soldaten
--- @param _Reuse      boolean Freie Truppen wiederverwenden
---
function Reward_AI_SpawnAndAttackTerritory(_PlayerID, _SpawnPoint, _Territory, _Sword, _Bow, _Cata, _Towers, _Rams, _Ammo, _Type, _Reuse)
end

---
--- Erzeugt eine Armee, die sich zum Zielpunkt bewegt und das Gebiet angreift.
---
--- Dabei werden die Soldaten alle erreichbaren Gebäude in Brand stecken. Ist
--- Das Zielgebiet eingemauert, können die Soldaten nicht angreifen und werden
--- sich zurückziehen.
---
--- @param _PlayerID   integer PlayerID des Angreifers
--- @param _SpawnPoint string Skriptname des Entstehungspunktes
--- @param _Target     string Skriptname des Ziels
--- @param _Radius     integer Aktionsradius um das Ziel
--- @param _Sword      integer Anzahl Schwertkämpfer (Battalione)
--- @param _Bow        integer Anzahl Bogenschützen (Battalione)
--- @param _Soldier    string Typ der Soldaten
--- @param _Reuse      boolean Freie Truppen wiederverwenden
---
function Reward_AI_SpawnAndAttackArea(_PlayerID, _SpawnPoint, _Target, _Radius, _Sword, _Bow, _Soldier, _Reuse)
end

---
--- Erstellt eine Armee, die das Zielgebiet verteidigt.
---
--- @param _PlayerID     integer PlayerID des Angreifers
--- @param _SpawnPoint   string Skriptname des Entstehungspunktes
--- @param _Target       string Skriptname des Ziels
--- @param _Radius       integer Bewachtes Gebiet
--- @param _Time         integer Dauer der Bewachung (-1 für unendlich)
--- @param _Sword        integer Anzahl Schwertkämpfer (Battalione)
--- @param _Bow          integer Anzahl Bogenschützen (Battalione)
--- @param _CaptureCarts integer Soldaten greifen Karren an
--- @param _Type         string Typ der Soldaten
--- @param _Reuse        boolean Freie Truppen wiederverwenden
---
function Reward_AI_SpawnAndProtectArea(_PlayerID, _SpawnPoint, _Target, _Radius, _Time, _Sword, _Bow, _CaptureCarts, _Type, _Reuse)
end

---
--- Ändert die Konfiguration eines KI-Spielers.
---
--- Optionen:
--- <ul>
--- <li>Courage/FEAR: Angstfaktor (0 bis ?)</li>
--- <li>Reconstruction/BARB: Wiederaufbau von Gebäuden (0 oder 1)</li>
--- <li>Build Order/BPMX: Buildorder ausführen (Nummer der Build Order)</li>
--- <li>Conquer Outposts/FCOP: Außenposten einnehmen (0 oder 1)</li>
--- <li>Mount Outposts/FMOP: Eigene Außenposten bemannen (0 oder 1)</li>
--- <li>max. Bowmen/FMBM: Maximale Anzahl an Bogenschützen (min. 1)</li>
--- <li>max. Swordmen/FMSM: Maximale Anzahl an Schwerkkämpfer (min. 1) </li>
--- <li>max. Rams/FMRA: Maximale Anzahl an Rammen (min. 1)</li>
--- <li>max. Catapults/FMCA: Maximale Anzahl an Katapulten (min. 1)</li>
--- <li>max. Ammunition Carts/FMAC: Maximale Anzahl an Minitionswagen (min. 1)</li>
--- <li>max. Siege Towers/FMST: Maximale Anzahl an Belagerungstürmen (min. 1)</li>
--- <li>max. Wall Catapults/FMBA: Maximale Anzahl an Mauerkatapulten (min. 1)</li>
--- </ul>
---
--- @param _PlayerID integer PlayerID des KI
--- @param _Fact     string Konfigurationseintrag
--- @param _Value    integer Neuer Wert
---
function Reward_AI_SetNumericalFact(_PlayerID, _Fact, _Value)
end

---
--- Stellt den Aggressivitätswert des KI-Spielers nachträglich ein.
---
--- @param _PlayerID         integer PlayerID des KI-Spielers
--- @param _Aggressiveness   integer Aggressivitätswert (1 bis 3)
---
function Reward_AI_Aggressiveness(_PlayerID, _Aggressiveness)
end

---
--- Stellt den Feind des Skirmish-KI ein.
---
--- Der Skirmish-KI (maximale Aggressivität) kann nur einen Spieler als Feind
--- behandeln. Für gewöhnlich ist dies der menschliche Spieler.
---
--- @param _PlayerID      integer PlayerID des KI
--- @param _EnemyPlayerID integer PlayerID des Feindes
---
function Reward_AI_SetEnemy(_PlayerID, _EnemyPlayerID)
end

---
--- Ein Entity wird durch ein neues anderen Typs ersetzt.
---
--- Das neue Entity übernimmt Skriptname, Besitzer und Ausrichtung des
--- alten Entity.
---
--- @param _Entity string Skriptname oder ID des Entity
--- @param _Type   string Neuer Typ des Entity
--- @param _Owner  integer Besitzer des Entity
---
function Reward_ReplaceEntity(_Entity, _Type, _Owner)
end

---
--- Setzt die Menge von Rohstoffen in einer Mine.
--- <p>
--- <b>Achtung:</b> Im Reich des Ostens darf die Mine nicht eingestürzt sein!
--- Außerdem bringt dieses Behavior die Nachfüllmechanik durcheinander.
---
--- @param _ScriptName string Skriptname der Mine
--- @param _Amount     integer Menge an Rohstoffen
---
function Reward_SetResourceAmount(_ScriptName, _Amount)
end

---
--- Fügt dem Lagerhaus des Auftragnehmers eine Menge an Rohstoffen hinzu. Die
--- Rohstoffe werden direkt ins Lagerhaus bzw. die Schatzkammer gelegt.
---
--- @param _Type   string Rohstofftyp
--- @param _Amount integer Menge an Rohstoffen
---
function Reward_Resources(_Type, _Amount)
end

---
--- Entsendet einen Karren zum angegebenen Spieler.
---
--- Wenn der Spawnpoint ein Gebäude ist, wird der Wagen am Eingang erstellt.
--- Andernfalls kann der Spawnpoint gelöscht werden und der Wagen übernimmt
--- dann den Skriptnamen.
---
--- @param _ScriptName    string Skriptname des Spawnpoint
--- @param _Owner         integer Empfänger der Lieferung
--- @param _Type          string Typ des Wagens
--- @param _Good          string Typ der Ware
--- @param _Amount        integer Menge an Waren
--- @param _OtherPlayer   integer Anderer Empfänger als Auftraggeber
--- @param _NoReservation boolean Platzreservation auf dem Markt ignorieren (Sinnvoll?)
--- @param _Replace       boolean Spawnpoint ersetzen
---
function Reward_SendCart(_ScriptName, _Owner, _Type, _Good, _Amount, _OtherPlayer, _NoReservation, _Replace)
end

---
--- Gibt dem Auftragnehmer eine Menge an Einheiten.
---
--- Die Einheiten erscheinen an der Burg. Hat der Spieler keine Burg, dann
--- erscheinen sie vorm Lagerhaus.
---
--- @param _Type   string Typ der Einheit
--- @param _Amount integer Menge an Einheiten
---
function Reward_Units(_Type, _Amount)
end

---
--- Startet einen Quest neu.
---
--- @param _QuestName string Name des Quest
---
function Reward_QuestRestart(_QuestName)
end

---
--- Lässt einen Quest fehlschlagen.
---
--- @param _QuestName string Name des Quest
---
function Reward_QuestFailure(_QuestName)
end

---
--- Wertet einen Quest als erfolgreich.
---
--- @param _QuestName string Name des Quest
---
function Reward_QuestSuccess(_QuestName)
end

---
--- Triggert einen Quest.
---
--- @param _QuestName string Name des Quest
---
function Reward_QuestActivate(_QuestName)
end

---
--- Unterbricht einen Quest.
---
--- @param _QuestName string Name des Quest
---
function Reward_QuestInterrupt(_QuestName)
end

---
--- Unterbricht einen Quest, selbst wenn dieser noch nicht ausgelöst wurde.
---
--- @param _QuestName   string Name des Quest
--- @param _EndetQuests boolean Bereits beendete unterbrechen
---
function Reward_QuestForceInterrupt(_QuestName, _EndetQuests)
end

---
--- Ändert den Wert einer benutzerdefinierten Variable.
---
--- Benutzerdefinierte Variablen können ausschließlich Zahlen sein. Nutze
--- dieses Behavior bevor die Variable in einem Goal oder Trigger abgefragt
--- wird, um sie zu initialisieren!
---
--- <p>Operatoren</p>
--- <ul>
--- <li>= - Variablenwert wird auf den Wert gesetzt</li>
--- <li>- - Variablenwert mit Wert Subtrahieren</li>
--- <li>+ - Variablenwert mit Wert addieren</li>
--- <li>* - Variablenwert mit Wert multiplizieren</li>
--- <li>/ - Variablenwert mit Wert dividieren</li>
--- <li>^ - Variablenwert mit Wert potenzieren</li>
--- </ul>
---
--- @param _Name     string Name der Variable
--- @param _Operator string Rechen- oder Zuweisungsoperator
--- @param _Value    any Wert oder andere Custom Variable
---
function Reward_CustomVariables(_Name, _Operator, _Value)
end

---
--- Führt eine Funktion im Skript als Reward aus.
---
--- Wird ein Funktionsname als String übergeben, wird die Funktion mit den
--- Daten des Behavors und des zugehörigen Quest aufgerufen (Standard).
---
--- Wird eine Funktionsreferenz angegeben, wird die Funktion zusammen mit allen
--- optionalen Parametern aufgerufen, als sei es ein gewöhnlicher Aufruf im
--- Skript.
--- <pre>Reward_MapScriptFunction(ReplaceEntity, "block", Entities.XD_ScriptEntity);
--- -- entspricht: ReplaceEntity("block", Entities.XD_ScriptEntity);</pre>
--- <p>
--- <b>Achtung:</b> Nicht über den Assistenten verfügbar!
---
--- @param _FunctionName any Name der Funktion oder Funktionsreferenz
--- @param ... any Optional parameters
---
function Reward_MapScriptFunction(_FunctionName, ...)
end

---
--- Erlaubt oder verbietet einem Spieler ein Recht.
---
--- @param _PlayerID   integer ID des Spielers
--- @param _Lock       string Sperren/Entsperren
--- @param _Technology string Name des Rechts
---
function Reward_Technology(_PlayerID, _Lock, _Technology)
end

---
--- Gibt dem Auftragnehmer eine Anzahl an Prestigepunkten.
---
--- Prestige hat i.d.R. keine Funktion und wird nur als Zusatzpunkte in der
--- Statistik angezeigt.
---
--- @param _Amount integer Menge an Prestige
---
function Reward_PrestigePoints(_Amount)
end

---
--- Besetzt einen Außenposten mit Soldaten.
---
--- @param _ScriptName string Skriptname des Außenposten
--- @param _Type       string Soldatentyp
---
function Reward_AI_MountOutpost(_ScriptName, _Type)
end

---
--- Startet einen Quest neu und lößt ihn sofort aus.
---
--- @param _QuestName string Name des Quest
---
function Reward_QuestRestartForceActive(_QuestName)
end

---
--- Baut das angegebene Gabäude um eine Stufe aus. Das Gebäude wird durch einen
--- Arbeiter um eine Stufe erweitert. Der Arbeiter muss zuerst aus dem Lagerhaus
--- kommen und sich zum Gebäude bewegen.
--- <p>
--- <b>Achtung:</b> Ein Gebäude muss erst fertig ausgebaut sein, bevor ein
--- weiterer Ausbau begonnen werden kann!
---
--- @param _ScriptName string Skriptname des Gebäudes
---
function Reward_UpgradeBuilding(_ScriptName)
end

---
--- Setzt das Upgrade Level des angegebenen Gebäudes.
---
--- Ein Geböude erhält sofort eine neue Stufe, ohne dass ein Arbeiter kommen
--- und es ausbauen muss. Für eine Werkstatt wird ein neuer Arbeiter gespawnt.
---
--- @param _ScriptName string Skriptname des Gebäudes
--- @param _Level integer Upgrade Level
---
function Reward_SetBuildingUpgradeLevel(_ScriptName, _Level)
end

---
--- Starte den Quest, wenn ein anderer Spieler entdeckt wurde.
---
--- Ein Spieler ist dann entdeckt, wenn sein Heimatterritorium aufgedeckt wird.
---
--- @param _PlayerID integer Zu entdeckender Spieler
---
function Trigger_PlayerDiscovered(_PlayerID)
end

---
--- Starte den Quest, wenn zwischen dem Empfänger und der angegebenen Partei
--- der geforderte Diplomatiestatus herrscht.
---
--- @param _PlayerID integer ID der Partei
--- @param _State    string Diplomatie-Status
---
function Trigger_OnDiplomacy(_PlayerID, _State)
end

---
--- Starte den Quest, sobald ein Bedürfnis nicht erfüllt wird.
---
--- @param _PlayerID integer ID des Spielers
--- @param _Need     string Bedürfnis
--- @param _Amount   integer Menge an skreikenden Siedlern
---
function Trigger_OnNeedUnsatisfied(_PlayerID, _Need, _Amount)
end

---
--- Startet den Quest, wenn die angegebene Mine erschöpft ist.
---
--- @param _ScriptName string Skriptname der Mine
---
function Trigger_OnResourceDepleted(_ScriptName)
end

---
--- Startet den Quest, sobald der angegebene Spieler eine Menge an Rohstoffen
--- im Lagerhaus hat.
---
--- @param  _PlayerID integer ID des Spielers
--- @param  _Type     string Typ des Rohstoffes
--- @param _Amount    integer Menge an Rohstoffen
---
function Trigger_OnAmountOfGoods(_PlayerID, _Type, _Amount)
end

---
--- Startet den Quest, sobald ein anderer aktiv ist.
---
--- @param _QuestName string Name des Quest
--- @param _Time      integer Wartezeit
--- return Table mit Behavior
function Trigger_OnQuestActive(_QuestName, _Time)
end
Trigger_OnQuestActiveWait = Trigger_OnQuestActive;

---
--- Startet einen Quest, sobald ein anderer fehlschlägt.
---
--- @param _QuestName string Name des Quest
--- @param _Time      integer Wartezeit
function Trigger_OnQuestFailure(_QuestName, _Time)
end
Trigger_OnQuestFailureWait = Trigger_OnQuestFailure;

---
--- Startet einen Quest, wenn ein anderer noch nicht ausgelöst wurde.
---
--- @param _QuestName string Name des Quest
function Trigger_OnQuestNotTriggered(_QuestName)
end

---
--- Startet den Quest, sobald ein anderer unterbrochen wurde.
---
--- @param _QuestName string Name des Quest
--- @param _Time      integer Wartezeit
function Trigger_OnQuestInterrupted(_QuestName, _Time)
end
Trigger_OnQuestInterruptedWait = Trigger_OnQuestInterrupted;

---
--- Startet den Quest, sobald ein anderer bendet wurde.
---
--- Dabei ist das Resultat egal. Der Quest kann entweder erfolgreich beendet
--- wurden oder fehlgeschlagen sein.
---
--- @param _QuestName string Name des Quest
--- @param _Time      integer Wartezeit
function Trigger_OnQuestOver(_QuestName, _Time)
end
Trigger_OnQuestOverWait = Trigger_OnQuestOver;

---
--- Startet den Quest, sobald ein anderer Quest erfolgreich abgeschlossen wurde.
---
--- @param _QuestName string Name des Quest
--- @param _Time      integer Wartezeit
function Trigger_OnQuestSuccess(_QuestName, _Time)
end
Trigger_OnQuestSuccessWait = Trigger_OnQuestSuccess;

---
--- Startet den Quest, wenn eine benutzerdefinierte Variable einen bestimmten
--- Wert angenommen hat.
---
--- Benutzerdefinierte Variablen müssen Zahlen sein. Bevor eine
--- Variable in einem Goal abgefragt werden kann, muss sie zuvor mit
--- Reprisal_CustomVariables oder Reward_CutsomVariables initialisiert
--- worden sein.
---
--- @param _Name     string Name der Variable
--- @param _Relation string Vergleichsoperator
--- @param _Value    any Wert oder Custom Variable
---
function Trigger_CustomVariables(_Name, _Relation, _Value)
end

---
--- Startet den Quest sofort.
---
function Trigger_AlwaysActive()
end

---
--- Startet den Quest im angegebenen Monat.
---
--- @param _Month integer Monat
---
function Trigger_OnMonth(_Month)
end

---
--- Startet den Quest sobald der Monsunregen einsetzt.
--- <p>
--- <b>Achtung:</b> Dieses Behavior ist nur für Reich des Ostens verfügbar.
---
function Trigger_OnMonsoon()
end

---
--- Startet den Quest sobald der Timer abgelaufen ist.
---
--- Der Timer zählt immer vom Start der Map an.
---
--- @param _Time integer Zeit bis zum Start
---
function Trigger_Time(_Time)
end

---
--- Startet den Quest sobald das Wasser gefriert.
---
function Trigger_OnWaterFreezes()
end

---
--- Startet den Quest niemals.
---
--- Quests, für die dieser Trigger gesetzt ist, müssen durch einen anderen
--- Quest über Reward_QuestActive oder Reprisal_QuestActive gestartet werden.
---
function Trigger_NeverTriggered()
end

---
--- Startet den Quest, sobald wenigstens einer von zwei Quests fehlschlägt.
---
--- @param _QuestName1 string Name des ersten Quest
--- @param _QuestName2 string Name des zweiten Quest
---
function Trigger_OnAtLeastOneQuestFailure(_QuestName1, _QuestName2)
end

---
--- Startet den Quest, sobald wenigstens einer von zwei Quests erfolgreich ist.
---
--- @param _QuestName1 string Name des ersten Quest
--- @param _QuestName2 string Name des zweiten Quest
---
function Trigger_OnAtLeastOneQuestSuccess(_QuestName1, _QuestName2)
end

---
--- Führt eine Funktion im Skript als Trigger aus.
---
--- Die Funktion muss entweder true or false zurückgeben.
---
--- Nur Skipt: Wird statt einem Funktionsnamen (String) eine Funktionsreferenz
--- übergeben, werden alle weiteren Parameter an die Funktion weitergereicht.
---
--- @param _FunctionName any Name der Funktion
--- @param ... any Optional parameters
---
function Trigger_MapScriptFunction(_FunctionName, ...)
end

---
--- Startet den Quest, sobald ein Effekt zerstört wird oder verschwindet.
---
--- <b>Achtung</b>: Das Behavior kann nur auf Effekte angewand werden, die
--- über Effekt-Behavior erzeugt wurden.
---
--- @param _EffectName string Name des Effekt
---
function Trigger_OnEffectDestroyed(_EffectName)
end

