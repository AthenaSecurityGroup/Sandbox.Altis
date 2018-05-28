/*

	ASG_fnc_getPlayerDBPos
	by:	Diffusion9

	Gets a player's saved position from the player database.

*/

params ["_player"];

//	FIND THE PLAYER IN THE DATABASE
private _playerDBindex = [ASG_pDB, name _player] call BIS_fnc_findNestedElement select 0;
//	SELECT THE INDEX IN THE PLAYER'S DB ENTRY
private ["_playerDBpos"];
if (_playerDBindex isEqualTo []) then {
	_playerDBpos = "";
} else {
	_playerDBpos = ASG_pDB select _playerDBindex select 3;
};
//	ASSIGN ON THE CLIENT
[_player, ["ASG_playerDBPos", _playerDBpos]] remoteExec ["setVariable", _player];
