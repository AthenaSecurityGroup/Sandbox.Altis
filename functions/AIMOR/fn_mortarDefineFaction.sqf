/*

	ASG_fnc_mortarDefineFaction
	
	Takes an input String and determines information for mortar script.
	
	REQUIRED INPUT:
	0	STRING	['MILITIA','AAF','CSAT','NATO']

*/

params ['_mortarFaction'];

switch (toUpper _mortarFaction) do {
	case "AAF": {
		_mortarType = "I_Mortar_01_F";
		_mortarSide = Independent;
		_detectSide = "GUER D";
		_triggerActivate = "WEST";
		_mortarCrewType = 'I_soldier_F';
		[_mortarType, _mortarSide, _detectSide, _mortarCrewType, _triggerActivate];
	};
	case "CSAT": {
		_mortarType = "O_Mortar_01_F";
		_mortarSide = EAST;
		_detectSide = "EAST D";
		_triggerActivate = "WEST";
		_mortarCrewType = 'O_soldier_F';
		[_mortarType, _mortarSide, _detectSide, _mortarCrewType, _triggerActivate];
	};
	case "MILITIA": {
		_mortarType = "O_G_Mortar_01_F";
		_mortarSide = EAST ;
		_detectSide = "EAST D";
		_triggerActivate = "WEST";
		_mortarCrewType = 'O_soldierU_F';
		[_mortarType, _mortarSide, _detectSide, _mortarCrewType, _triggerActivate];
	};
	case "NATO": {
		_mortarType = "B_Mortar_01_F";
		_mortarSide = WEST ;
		_detectSide = "WEST D";
		_triggerActivate = "EAST";
		_mortarCrewType = 'B_soldier_F';
		[_mortarType, _mortarSide, _detectSide, _mortarCrewType, _triggerActivate];
	};
	default {
		diag_log "[ASG_fnc_mortarDefineFaction]:		Faction improperly defined.";
		terminate _thisScript;
	};
};
