/*
	ASG_fnc_deploySpecial
	by:	Diffusion9
*/

params ["_baseType", "_deployPos", "_baseVar", "_player"];

//	DEPLOY CLOSER TO PLAYER.
_deployPos = (getPos _player) getPos [0.75, (getDir _player)];
_deployDir = getDir _player;
_deployNormals = false;
_deployOffset = [0,0,0];

//	PERSONALIZE BASEVAR
_playerBaseVar = format ["%1_%2", _baseVar, _player];
if (!isNil _playerBaseVar) then {
	[missionNamespace getVariable _playerBaseVar] call LAR_fnc_deleteComp;
};

//	REACT TO SPECIAL COMPOSITION TYPE
switch (_baseType) do {
	//	RECON HIDE
	case "RH": {};
	
	//	HASTY FIGHTING POSITION
	case "HFP": {
		_ABDEPtimer = 58;
		_deployOffset = [0,0,-0.780];

		//	SERVER DEPLOY THE FIGHTING POSITION
		missionNamespace setVariable [format ["%1_%2script", _baseVar, _player],[_playerBaseVar,_baseType,_deployPos,_deployOffset,_deployDir,_deployNormals] spawn ASG_fnc_deployFightingPos];

		//	REMOTE EXEC PROGRESS BAR ON PLAYER.
		[
			_ABDEPtimer,
			['Fortifying Position','',''],
			nil,
			nil,
			nil,
			nil,
			nil,
			format ["%1_%2script", _baseVar, _player]
		] remoteExec ["ASG_fnc_advProgressBar", _player];
	};
};

