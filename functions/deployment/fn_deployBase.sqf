/*
	ASG_fnc_deployBase
	by:	Diffusion9	
	:: Process an order sent by a player to deploy a base.
*/

params ["_player", "_baseDataIndex"];

private ["_deployPos", "_deployDir"];
//	DIRECTION, POSITION, AND TYPE.
if (typeName _player isEqualTo "OBJECT") then {
	_deployPos = (getPos _player) getPos [12, (getDir _player)];
	_deployDir = getDir _player;
};
if (typeName _player isEqualTo "STRING") then {
	_deployPos = baseData select _baseDataIndex select 4 select 0;
	_deployDir = baseData select _baseDataIndex select 4 select 1;
};

_baseVar = baseData select _baseDataIndex select 2;
_baseVar splitString "_" params ["_baseType","_baseCount"];
_deployNormals = true;
_deployOffset = [0,0,0];

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
		[_baseDataIndex,"CREATE",_deployPos,_deployDir] call ASG_fnc_selectMarkerAct;
	};
} else {
	[missionNamespace getVariable [_baseVar, nil]] call LAR_fnc_deleteComp;
	missionNamespace setVariable [_baseVar, nil];

	//	DELETE BASE MARKER
	[_baseDataIndex, "DELETE"] call ASG_fnc_selectMarkerAct;
};

//	PROCESS NEARBY MARKER RANKS (FOR HIDING)
[nil, "UPDATE", _deployPos] call ASG_fnc_selectMarkerAct;

//	ATTACH LOGISTICS REQUEST, IF APPLICABLE
[_deployPos,{
	_deployPos = _this;
	_logisticsObj = _deployPos nearestObject "Land_Laptop_unfolded_F";
	if (!isNil "_logisticsObj") then {
		logistics_reqAction = _logisticsObj addAction ["Request Logistics", {
			createDialog "logisticsdialog";
		}, nil, 0, false, true, "", "", 8, false];
	};
}] remoteExec ["call", 0, true];
