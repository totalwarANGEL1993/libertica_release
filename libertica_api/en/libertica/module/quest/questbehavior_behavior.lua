--- Adds additional standard behaviors.

--- An entity needs to be moved to a position.
--- @param _ScriptName string Script name of the entity
--- @param _Target string Script name of the target
--- @param _Distance integer Distance
--- @param _UseMarker boolean Show marker
function Goal_MoveToPosition(_ScriptName, _Target, _Distance, _UseMarker)
end

--- A war machine needs to have a specific amount of ammunition.
--- @param _ScriptName string Script name of the entity
--- @param _Relation string Relation symbol
--- @param _Amount integer Amount
function Goal_AmmunitionAmount(_ScriptName, _Relation, _Amount)
end

--- A certain city reputation needs to be achieved.
--- @param _Reputation integer 
function Goal_CityReputation(_Reputation)
end

--- Spawned enemies or predators need to be eliminated.
--- @param _SpawnPoint string Script name of the spawn point
--- @param _Amount integer Amount
--- @param _Prefixed boolean Script name is prefixed
function Goal_DestroySpawnedEntities(_SpawnPoint, _Amount, _Prefixed)
end

--- A specific amount of gold needs to be earned through theft.
--- @param _Amount integer Amount
--- @param _PlayerID integer Player to steal from (-1 = all)
--- @param _CheatEarnings boolean Generate earnings
--- @param _ShowProgress boolean Show progress
function Goal_StealGold(_Amount, _PlayerID, _CheatEarnings, _ShowProgress)
end

--- A building needs to be stolen from by a thief. The thief must return the 
--- earnings first.
--- @param _ScriptName string Script name of the entity
--- @param _CheatEarnings boolean Generate earnings
function Goal_StealFromBuilding(_ScriptName, _CheatEarnings)
end

--- A building needs to be spied on by a thief. Once the thief enters the 
--- building, the goal is achieved.
--- @param _ScriptName string Script name of the entity
--- @param _CheatEarnings boolean Generate earnings
--- @param _DeleteThief boolean Delete thief
function Goal_SpyOnBuilding(_ScriptName, _CheatEarnings, _DeleteThief)
end

--- A player needs to defeat soldiers of another player.
--- @param _AttackerPlayerID integer Attacking player
--- @param _AttackedPlayerID integer Attacked player
--- @param _Amount integer Amount
function Goal_DestroySoldiers(_AttackerPlayerID, _AttackedPlayerID, _Amount)
end

--- Moves the entity to the position of another.
--- @param _ScriptName string Script name of the entity
--- @param _Target string Script name of the target
--- @param _LookAt boolean Look at target
--- @param _Distance integer Distance
function Reprisal_SetPosition(_ScriptName, _Target, _LookAt, _Distance)
end

--- Changes the owner of the entity.
--- @param _ScriptName string Script name of the entity
--- @param _PlayerID integer Player ID
function Reprisal_ChangePlayer(_ScriptName, _PlayerID)
end

--- Changes the visibility of the entity.
--- @param _ScriptName string Script name of the entity
--- @param _Visible boolean Is visible
function Reprisal_SetVisible(_ScriptName, _Visible)
end

--- Changes the vulnerability status of the entity.
--- @param _ScriptName string Script name of the entity
--- @param _Vulnerable boolean Is vulnerable
function Reprisal_SetVulnerability(_ScriptName, _Vulnerable)
end

--- Changes the model of the entity.
--- @param _ScriptName string Script name of the entity
--- @param _Model string Name of the model
function Reprisal_SetModel(_ScriptName, _Model)
end

--- Moves an entity to the position of another.
--- @param _ScriptName string Script name of the entity
--- @param _Target string Script name of the target
--- @param _LookAt boolean Look at target
--- @param _Distance integer Distance
function Reward_SetPosition(_ScriptName, _Target, _LookAt, _Distance)
end

--- Changes the owner of an entity.
--- @param _ScriptName string Script name of the entity
--- @param _PlayerID integer Player ID
function Reward_ChangePlayer(_ScriptName, _PlayerID)
end

--- Moves an entity to another.
--- @param _ScriptName string Script name of the entity
--- @param _Destination string Script name of the target
--- @param _Distance integer Distance
--- @param _Angle integer Angle
function Reward_MoveToPosition(_ScriptName, _Destination, _Distance, _Angle)
end

--- Allows the recipient to win the game and generates a victory celebration 
--- at the marketplace.
function Reward_VictoryWithParty()
end

--- Changes the visibility of the entity.
--- @param _ScriptName string Script name of the entity
--- @param _Visible boolean Is visible
function Reward_SetVisible(_ScriptName, _Visible)
end

--- Changes the vulnerability status of the entity.
--- @param _ScriptName string Script name of the entity
--- @param _Vulnerable boolean Is vulnerable
function Reward_SetVulnerability(_ScriptName, _Vulnerable)
end

--- Changes the model of the entity.
--- @param _ScriptName string Script name of the entity
--- @param _Model string Name of the model
function Reward_SetModel(_ScriptName, _Model)
end

--- Sets whether the entity is controlled by the AI.
--- @param _ScriptName string Script name of the entity
--- @param _Controlled boolean Entity is controlled
function Reward_AI_SetEntityControlled(_ScriptName, _Controlled)
end

--- Triggers the mission when the ammunition is depleted.
--- @param _ScriptName string Script name of the entity
function Trigger_AmmunitionDepleted(_ScriptName)
end

