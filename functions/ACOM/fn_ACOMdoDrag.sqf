/*
	ASG_fnc_ACOMdoDrag
	by:	Diffusion9

	Enables a player to drag another player.
	Administrated via the Action menu.

	EXEC TYPE:	
	INPUT:		
	OUTPUT:		
*/

// DRAGGER
params [["_ct", player]];

//	UPDATE THE ACTION TEXT.
player setUserActionText [ACOM_actDrag, format ["Drop Wounded"]];

//	SET THE DRAG STATE FOR THE WOUNDED PLAYER.
_ct setVariable ["ASGmedical_stateDrag", true, true];

//	PLAY PICK UP ANIMATION
[player,"AcinPknlMstpSrasWrflDnon"] remoteExec ["playMoveNow",allPlayers];

//	ATTACH WOUNDED TO DRAGGER.
[_ct, [player, [0, 1, 0.092]]] remoteExec ["attachTo"];
[_ct, 180] remoteExec ["setDir", allPlayers];
[player,"AcinPknlMstpSrasWrflDnon"] remoteExec ["playMoveNow",allPlayers];

//	GRAB THE MAIN MISSION DISPLAY.
private ["_mainDisplay"];
disableSerialization;
waitUntil {
	_mainDisplay = [] call bis_fnc_displayMission;
	!(isNull _mainDisplay)
};

//	PREVENT EH DUPLICATION.
{
	_index = missionNamespace getVariable [_x, -1];
	if (_index != -1) then
	{
		_mainDisplay displayRemoveEventHandler ["KeyDown", _index];
		missionNamespace setVariable [_x, nil];
	};
} forEach ["ASGmedical_dragKeyDownEH"];

//	ENABLE DRAG RESTRICTIONS
_dragkeyDownEH = _mainDisplay displayAddEventHandler
[
	"KeyDown", {
		private["_key","_keys"];
		_key = _this select 1;
		if (true) then {
			_keys = [];
			{
				_keys append actionKeys _x;
			} forEach ["Throw","DeployWeaponManual","DeployWeaponAuto", "CommandingMenu0", "SelectAll", "SelectGroupUnit1", "SelectGroupUnit2", "SelectGroupUnit3", "SelectGroupUnit4", "SelectGroupUnit5", "SelectGroupUnit6", "SelectGroupUnit7", "SelectGroupUnit8", "SelectGroupUnit9", "SelectGroupUnit0", "NavigateMenu", "Gear", "Stand", "Crouch", "Prone", "MoveUp", "TactToggle", "GetOver"];
			if (_key in _keys) then {true} else {false};
		} else {
			false
		};		
	}
];
missionNamespace setVariable ["ASGmedical_dragKeyDownEH", _dragkeyDownEH];

//	DISCONNECT HANDLER.
if (!isNil{ASGmedical_disconnectEH}) then {
	removeMissionEventHandler ["HandleDisconnect", ASGmedical_disconnectEH];
};
ASGmedical_disconnectEH = addMissionEventHandler ["HandleDisconnect",{
	params ["_unit","_id","_uid","_name"];
	detach _unit;
}];

//	CANCEL IF CERTAIN CONDITIONS ARE MET.
ASGmedical_dragContThread = [_ct] spawn {
	scriptName "ASGmedical_dragContThread";
	params ["_ct"];
	waitUntil {
		if ( (!isPlayer _ct) || !(isPlayer player) || (player getVariable ["ASGmedical_stateIncap",false])) then {
			[] spawn ASG_fnc_ACOMdoDrop;
			[_ct] remoteExec ["ASG_fnc_ACOMgetDrop", _ct];
			missionNameSpace setVariable ["ASGmedical_dragContThread", nil];
			removeMissionEventHandler ["HandleDisconnect", ASGmedical_disconnectEH];
			detach _ct;
			terminate _thisScript;
		};
		uiSleep .5;
		false
	};
};
