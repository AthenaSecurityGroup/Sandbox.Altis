/*
	
	ASG_fnc_deployBase
	by:	Diffusion9
	
	Process an order sent by a player to deploy a base. Receives the player who requested the deployment, and
	the base requested to be deployed. Includes a short-circuit for special base types that should not be
	deployed with the LARs spawning functions. (such as fighting positions).
	
	EXEC TYPE:	Call
	INPUT:
	0	OBJECT	Player requesting deployment of the base.
	1	SCALAR	Index of the base in baseData
	OUTPUT:
	None
	
*/

params ["_player", "_base"];

//	DIRECTION, POSITION, AND TYPE.
_deployDir = getDir _player;
_deployPos = (getPos _player) getPos [12, (getDir _player)];
_baseVar = baseData select _base select 2;
_baseVar splitString "_" params ["_baseType","_baseCount"];
_deployNormals = true;
_deployOffset = nil;

//	SHORT-CIRCUIT FOR RECON HIDE STANCE
if (_baseType == "RH" && !(stance player == "PRONE")) exitWith {
	"You must be prone to deploy a Recon Hide." remoteExec ["Hint", _player];
	true;
};

//	DEPLOY OR UN-DEPLOY.
if (isNil _baseVar) then {
	if (_baseType == "RH" || _baseType == "HFP") then {
		//	SHORT CIRCUIT SPECIAL DEPLOYMENT CONDITION
		[_baseType, _deployPos, _baseVar, _player] call ASG_fnc_deploySpecial;
	} else {
		//	DEPLOY
		missionNamespace setVariable [_baseVar, [_baseType, _deployPos, _deployOffset, _deployDir, _deployNormals] call LAR_fnc_spawnComp];
		
		//	CREATE BASE MAP MARKER
		[_base, "CREATE", _deployPos] call ASG_fnc_selectMarkerAct;
	};
} else {
	[missionNamespace getVariable [_baseVar, nil]] call LAR_fnc_deleteComp;
	missionNamespace setVariable [_baseVar, nil];

	//	DELETE BASE MARKER
	[_base, "DELETE"] call ASG_fnc_selectMarkerAct;
};

//	PROCESS NEARBY MARKER RANKS (FOR HIDING)
[nil, "UPDATE", _deployPos] call ASG_fnc_selectMarkerAct;

//	ATTACH LOGISTICS REQUEST, IF APPLICABLE
[_deployPos,{
	_deployPos = _this;
	_alocObj = _deployPos nearestObject "Land_Laptop_unfolded_F";
	if (!isNil "_alocObj") then {
		ALOC_reqAction = _alocObj addAction ["Request Logistics", {
			createDialog "ALC_dialog";
		}, nil, 0, false, true, "", "", 8, false];
	};
}] remoteExec ["call", allPlayers, true];
