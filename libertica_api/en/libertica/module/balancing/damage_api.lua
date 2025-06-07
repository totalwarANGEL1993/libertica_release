--- Allows the modification of unit damage values.
---
--- <b>Attention</b>: The functions `MakeVulnerable` and `MakeInvulnerable` have
--- been overridden. The function `Logic.SetEntityInvulnerabilityFlag` is now
--- used internally and should no longer be used!
---
--- #### Functions:
--- <li>Better balancing for archers</li>
--- <li>Close Wall catapults weaken each other (only for humans)</li>
--- <li>Adjusting unit combat strength via Lua</li>
--- <li>Granting additional armor to units</li>
--- <li>Adjusting the Own Territory bonus</li>
--- <li>Adjusting the Height Modifier</li>
---
--- <b>Attention</b>: This functionality will be active when the module is loaded.
---



--- Sets the damage for an entity type.
---
--- The specified damage replaces the base damage of the entity type. The actual
--- damage is derived from morale, height bonus, and territory bonus.
---
--- @param _Type integer Entity type
--- @param _Damage integer Amount of damage
function SetEntityTypeDamage(_Type, _Damage)
end
API.SetEntityTypeDamage = SetEntityTypeDamage;

--- Sets the damage for a named entity.
---
--- The specified damage replaces the base damage of the entity. The actual
--- damage is derived from morale, height bonus, and territory bonus.
---
--- @param _Name string Script name of the entity
--- @param _Damage integer Amount of damage
function SetEntityNameDamage(_Name, _Damage)
end
API.SetEntityNameDamage = SetEntityNameDamage;

--- Sets the armor for an entity type.
---
--- The armor value is subtracted from the remaining damage after the initial
--- damage calculation. Damage can never be less than 1.
---
--- @param _Type integer Entity type
--- @param _Armor integer Strength of the armor
function SetEntityTypeArmor(_Type, _Armor)
end
API.SetEntityTypeArmor = SetEntityTypeArmor;

--- Sets the armor for a named entity.
---
--- Categories can be listed to only use the damage value for those categories.
---
--- The armor value is subtracted from the remaining damage after the initial
--- damage calculation. Damage can never be less than 1.
---
--- @param _Name string Script name of the entity
--- @param _Armor integer Strength of the armor
--- @param ... integer? Optional category list
function SetEntityNameArmor(_Name, _Armor, ...)
end
API.SetEntityNameArmor = SetEntityNameArmor;

--- Sets the bonus factor for damage when fighting on own territory.
---
--- Categories can be listed to only use the damage value for those categories.
---
--- The specified factor is multiplied with the actual factor. For 0.5, this
--- means the territory bonus is halved. In the calculation, the territory
--- bonus is added to the morale.
---
--- @param _PlayerID integer Player ID
--- @param _Bonus number Factor
--- @param ... integer? Optional category list
function SetTerritoryBonus(_PlayerID, _Bonus, ...)
end
API.SetTerritoryBonus = SetTerritoryBonus;

--- Sets the bonus factor for damage when fighting from an elevated position.
---
--- The specified factor is multiplied with the actual factor. For 0.5, this
--- means the height bonus is halved. In the calculation, the sum of morale
--- and territory bonus is multiplied by the height bonus.
---
--- @param _PlayerID integer Player ID
--- @param _Bonus number Factor
function SetHeightModifier(_PlayerID, _Bonus)
end
API.SetHeightModifier = SetHeightModifier;

--- Checks if the entity is invulnerable.
--- @param _Entity any Script name or entity ID
--- @return boolean Invulnerable Entity is invulnerable
function IsInvulnerable(_Entity)
    return true;
end
API.IsInvulnerable = IsInvulnerable;

