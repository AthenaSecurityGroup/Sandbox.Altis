/*
	ASG_fnc_ACOMdoDrop
	by:	Diffusion9

	Enables a player to drop another player.
	Administrated via the Action menu.

	EXEC TYPE:	
	INPUT:		
	OUTPUT:		
*/

//	UPDATE THE ACTION TEXT.
player setUserActionText [ACOM_actDrag, format ["Drag Wounded"]];

//	GRAB THE MAIN MISSION DISPLAY.
private ["_mainDisplay"];
disableSerialization;
waitUntil {
	_mainDisplay = [] call bis_fnc_displayMission;
	!(isNull _mainDisplay)
};

//	DISABLE ACTION RESTRICTIONS
_index = missionNamespace getVariable ["ASGmedical_dragKeyDownEH", -1];
if (_index != -1) then {
	_mainDisplay displayRemoveEventHandler ["KeyDown", _index];
	missionNamespace setVariable ["ASGmedical_dragKeyDownEH", nil];
};

//	DROP WOUNDED PLAYER ANIMATION
if (vehicle player == player) then {
	if (primaryWeapon player isEqualto "") then {
		//	NO WEAPON
		[player,"AcinPknlMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon"] remoteExec ["switchMove", allPlayers];
	} else {
		//	RIFLE
		[player,"AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon"] remoteExec ["switchMove", allPlayers];
	};
};

if (!isNil{ASGmedical_dragContThread}) then {
	terminate ASGmedical_dragContThread;
	missionNameSpace setVariable ["ASGmedical_dragContThread", nil];
};

//	DISCONNECT HANDLER.
if (!isNil{ASGmedical_disconnectEH}) then {
	removeMissionEventHandler ["HandleDisconnect", ASGmedical_disconnectEH];
};
