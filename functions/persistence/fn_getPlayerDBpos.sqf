/*

	ASG_fnc_getPlayerDBPos
	by:	Diffusion9

	Gets a player's saved position from the player database.

*/

params ["_player"];

//	FIND THE PLAYER IN THE DATABASE
private _playerDBindex = [ASG_playerDatabase, name _player] call BIS_fnc_findNestedElement select 0;

//	SELECT THE INDEX IN THE PLAYER'S DB ENTRY
private ["_playerDBpos"];
if (_playerDBindex isEqualTo []) then {
	_playerDBpos = "";
} else {
	_playerDBpos = ASG_playerDatabase select _playerDBindex select 3;
};

//	ASSIGN AND BROADCAST TO THE CLIENT
[_player, ["ASG_playerDBPos", _playerDBpos]] remoteExec ["setVariable", _player];
