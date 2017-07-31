/*
	ASG_fnc_getASGrank
	by:	Diffusion9

	Gets the rank of the unit from the ASG database.
*/

params ["_player"];

//	LOCATE EXISTING DATABASE ENTRY.
_dbIndex = [ASG_pDB, getPlayerUID _player] call KK_fnc_findAll select 0 select 0;

//	PROCESS THE DATABASE ENTRY ACCORDINGLY.
private ["_playerRank"];
if isNil "_dbIndex" then {
	//	CREATE THE DATABASE ENTRY, PUSH TO DATABASE.
	_playerUID = getPlayerUID _player;
	_playerName = name _player;
	_playerRank = 0;
	_playerLoc = "";
	_playerEntry = [_playerName, _playerUID, _playerRank, _playerLoc];
	ASG_pDB pushback _playerEntry;
} else {
	//	GRAB THE RANK FROM THE DATABASE.
	_playerRank = ASG_pDB select _dbIndex select 2;
};

//	UPDATE THE SERVER AND THE PLAYER.
{
	[[_player,_playerRank], {
		params ["_player", "_playerRank"];
		_player setVariable ["ASG_rank", _playerRank];
	}] remoteExec ["call", _x];
} forEach [2, _player];
