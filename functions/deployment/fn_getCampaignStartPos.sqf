/*
	ASG_fnc_getCampaignStartPos
	by:	Diffusion9
	
	Process the position selected by the ACDEP Admin and executes based on terrain type (water or land).

	EXEC TYPE:	Call
	INPUT:		0	ARRAY	Spawn Position
	OUTPUT:		Nothing
*/

params ["_spawnPos"];

//	BROADCAST ACDEP_Pos
missionNamespace setVariable ["ACDEP_Pos", _spawnPos, true];

//	EXECUTE BASED ON TERRAIN TYPE.
if (surfaceIsWater _spawnPos) then {
	//	DEPLOY ON WATER
	//	COUNT TOTAL PLAYERS
	_fdPlayerCount = count allPlayers;
	_fdPlayerQueue = allPlayers;
	_fdAdmins = [];
	_fdAdminCount = 0;

	//	COUNT ADMINS
	private ["_fdAdminCount"];
	{
		if (name _x in ["Diffusion9", "DEL-J"]) then {
			_fdAdmins pushback _x;
			_fdAdminCount = _fdAdminCount + 1;
		};
	} forEach allPlayers;

	_fdBTransp = 4;
	_fdBType = "B_Boat_Transport_01_F";

	private ["_fdBTransp"];
	if (isNil "_fdAdmins") then {
		_fdBTransp = 5;
	};

	private ["_fdPlayerQueue"];
	if (count allPlayers <= 5) then {_fdBNeed = 0} else {_fdBNeed = (count allPlayers) / _fdBTransp};

	private ["_fdBCargoQueue"];
	waitUntil {
		//	SPAWN THE BOAT
		_fdVeh = _fdBType createVehicle _spawnPos;

		//	PROCESS THE CHALK
		_fdBCargoQueue = _fdPlayerQueue select [0, _fdBTransp];
		_fdPlayerQueue deleteRange [0, (count _fdBCargoQueue)];
		
		//	PROCESS IF NO RANKING PLAYERS.
		private ["_fdAdmins", "_fdBDriver"];
		if (isNil "_fdAdmins") then {
			_fdAdmins = _fdBCargoQueue;
			_fdBDriver = selectRandom _fdBCargoQueue;
			_fdBCargoQueue = _fdBCargoQueue - [_fdBDriver];
		} else {
			_fdBDriver = selectRandom _fdAdmins;
			_fdAdmins = _fdAdmins - [_fdBDriver];
			_fdBCargoQueue = _fdBCargoQueue - [_fdBDriver];	
		};

		//	FIND A RANKED PLAYER. LOAD INTO DRIVER.
		[_fdBDriver, _fdVeh] remoteExec ["assignAsDriver", _fdBDriver];
		[_fdBDriver, _fdVeh] remoteExec ["moveInDriver", 0];
		[false, "", 3] remoteExec ["ASG_fnc_setPlayerState", _fdBDriver];
		
		//	LOAD CHALK INTO BOAT
		{
			[_x, _fdVeh] remoteExec ["assignAsCargo", _x];
			[_x, _fdVeh] remoteExec ["moveInCargo", 0];
			[false, "", 3] remoteExec ["ASG_fnc_setPlayerState", _x];
		} forEach _fdBCargoQueue;
		
		//	CHECK QUEUE AND REPEAT AS NECESSARY
		(count _fdPlayerQueue) == 0;
	};
} else {
	//	DEPLOY ON LAND
	ACDEP_camp = ["FDB", _spawnPos, [0,0,-0.5], random 360] call LAR_fnc_spawnComp;
	{
		_spawnPos = _spawnPos getPos [20, random 360];
		_x setPos _spawnPos;
		[_x, "amovpercmstpsnonwnondnon"] remoteExec ["switchMove", allPlayers];
		uiSleep 1;
		[false, "", 3] remoteExec ["ASG_fnc_setPlayerState", _x];
	} forEach allPlayers;
};

//	TURN OFF ACDEP NOW THAT DEPLOYMENT HAS BEEN DONE.
missionNamespace setVariable ["ACDEP_State", false, true];
