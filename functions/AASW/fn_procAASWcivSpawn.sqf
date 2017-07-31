/*
	ASG_fnc_procAASWcivSpawn
	by:	Diffusion9
	"civilian spawning"
*/

//	SETTINGS
#define AASW_TRACKER_SLEEP 5
#define AASW_TRACKER_RADIUS 2500
#define AASW_VISITED_RADIUS 250
#define AASW_BUFFER_SIZE 3
#define AASW_VISITED_CD 3
#define AASW_LOCATION_TYPES ["NameCity","NameCityCapital","NameVillage"]
#define AASW_BUILDING_TYPES ["HOUSE","BUILDING","CHURCH","CHAPEL","FUELSTATION","HOSPITAL"]
#define AASW_CIV_RESP_LOW ["I don't want to talk to you.","Leave me alone, please.","I don't have anything to say.","Please leave me alone.","Like I told the last guy: I don't have anything to say.","I've got nothing to say.","I don't have any information for you.","I've not heard anything about anything.","I'm not interested in talking to you.","You don't have any right to interrogate me.","You're not the police; I don't have to talk to you.","I don't respect your authority.","Leave me alone.","I just want to be left alone.","I don't want to be hassled.","Even if there were militia nearby, I wouldn't tell you.","If you could just leave me alone, that would be great.","I'm gonna' need you to go ahead and leave me alone now.","You're a nuisance, go away.","Go away.","Get lost.","No thanks.","Get out of here, stalker.","Not without my lawyer."]
#define AASW_RADIUS 400
#define AASW_CENSUS_DIVISOR 3	//5
#define AASW_DEFAULT_REP 0
#define AASW_PATROL_RADIUS 100

params ["_loc"];

//	GET LOCATION DATA
_locPos = position _loc;
_locName = text _loc;
_loc = ((nearestLocations [_locPos, AASW_LOCATION_TYPES, AASW_RADIUS, _locPos]) select 0);

//	GET NEARBY STRUCTURES OF TYPE
_buildings = nearestTerrainObjects [_locPos, AASW_BUILDING_TYPES, AASW_RADIUS, true];

//	FIND VALID BUILDINGS WITH POSITIONS
_validBuildings = [];
private ["_validBuildings"];
{
	if (count (_x buildingPos -1) > 1) then {
		_validBuildings pushBackUnique _x;
	};
} forEach _buildings;

//	BEGIN AGENT SPAWNING
for "_b" from 0 to (round ceil (count _buildings / AASW_CENSUS_DIVISOR)) do {
	//	FIND BUILDING POSITION
	_randBuilding = selectRandom _validBuildings;
	_validBuildings = _validBuildings - [_randBuilding];
	_randBuildingPos = selectRandom (_randBuilding buildingPos -1);
	
	//	SPAWN IDLE CIVILIAN AGENT, SET ATTRIBUTES
	_civAgent = createAgent ["C_man_1", _randBuildingPos, [], 1, "NONE"];
	_civAgent setPosATL _randBuildingPos;
	_civAgent setDir random 360;
	// _civAgent disableAI "ALL";
	_civAgent setBehaviour "AWARE";
	_civAgent enableDynamicSimulation true;
	[_civAgent, _locName] remoteExec ["ASG_fnc_initAASWcivAction", allPlayers, true];
	
	//	OUTFIT CIVILIAN
	removeAllWeapons _civAgent;
	removeAllItems _civAgent;
	removeAllAssignedItems _civAgent;
	removeUniform _civAgent;
	removeVest _civAgent;
	removeBackpack _civAgent;
	removeHeadgear _civAgent;
	removeGoggles _civAgent;
	_civAgent setFace (selectRandom ["GreekHead_A3_01","GreekHead_A3_02","GreekHead_A3_03","GreekHead_A3_04","GreekHead_A3_05","GreekHead_A3_06","GreekHead_A3_07","GreekHead_A3_08","GreekHead_A3_09","IG_Leader","Miller","Nikos","O_Colonel","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","TanoanHead_A3_05","TanoanHead_A3_06","O_Colonel","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","TanoanHead_A3_05","TanoanHead_A3_06"]);
	_civAgent setSpeaker (selectRandom ["Male01PER","Male02PER","Male03PER","Male01PER","Male02PER","Male03PER","Male01PER","Male02PER","Male03PER","Male01GRE","Male02GRE","Male03GRE","Male04GRE","Male05GRE","Male06GRE"]);
	_civAgent forceAddUniform (selectRandom ["U_BG_Guerilla2_1","U_BG_Guerilla2_2","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_C_HunterBody_grn","U_C_Journalist","U_C_Man_casual_1_F","U_C_Man_casual_2_F","U_C_Man_casual_3_F","U_C_Man_casual_4_F","U_C_Man_casual_5_F","U_C_Man_casual_6_F","U_C_man_sport_1_F","U_C_man_sport_2_F","U_C_man_sport_3_F","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poor_1","U_Competitor","U_I_C_Soldier_Bandit_1_F","U_I_C_Soldier_Bandit_2_F","U_I_C_Soldier_Bandit_3_F","U_I_C_Soldier_Bandit_4_F","U_I_C_Soldier_Bandit_5_F","U_I_G_resistanceLeader_F","U_Marshal","U_NikosAgedBody","U_NikosBody","U_OrestesBody","U_Rangemaster"]);
	if (floor random 100 > 67) then {
		_civAgent addGoggles (selectRandom ["G_Aviator","G_Lady_Blue","G_Shades_Black","G_Shades_Blue","G_Shades_Green","G_Shades_Red","G_Spectacles","G_Sport_Red","G_Sport_Blackyellow","G_Sport_BlackWhite","G_Sport_Checkered","G_Sport_Blackred","G_Sport_Greenblack","G_Squares_Tinted","G_Squares","G_Spectacles_Tinted"]);
	};
	if (floor random 100 > 67) then {
		_civAgent addHeadgear (selectRandom ["H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_cbr","H_Bandanna_khk","H_Bandanna_mcamo","H_Bandanna_sgg","H_Bandanna_sand","H_Bandanna_surfer","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_camo","H_Beret_blk","H_Booniehat_khk","H_Booniehat_mcamo","H_Booniehat_oli","H_Booniehat_tan","H_Booniehat_tna_F","H_Booniehat_dgtl","H_Cap_grn_BI","H_Cap_blk","H_Cap_blu","H_Cap_blk_CMMG","H_Cap_grn","H_Cap_blk_ION","H_Cap_oli","H_Cap_red","H_Cap_surfer","H_Cap_tan","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_checker","H_Hat_grey","H_Hat_tan","H_StrawHat","H_StrawHat_dark"]);
	};
};

//	CALCULATE ACTIVE CIVILIAN GROUPS AND UNITS
_activeCivs = ceil sqrt (round ceil (count _buildings / AASW_CENSUS_DIVISOR));
_civGroups = ceil (_activeCivs / 2);
_civPerGroup = ceil (_activeCivs / _civGroups);
_simulGroups = [];
private ["_simulGroups"];

//	SPAWN CIVILIAN WITH GROUP SIZE
for "_g" from 0 to _civGroups do {
	_civGroup = createGroup [CIVILIAN, true];
	_groupName = format ["%1 Civilians (%2)", _locName, _g];
	_civGroup setGroupIDGlobal [_groupName];
	_civGroup setSpeedMode "LIMITED";
	_civGroup setFormation (selectRandom ["ECH LEFT", "COLUMN", "STAG COLUMN", "WEDGE", "DIAMOND", "VEE"]);	
	for "_c" from 0 to _civPerGroup do {
		//	CREATE CIVILIAN
		_civ = _civGroup createUnit ["C_man_1", _locPos, [], 200, "FORM"];
		[_civ, _locName] remoteExec ["ASG_fnc_initAASWcivAction", allPlayers, true];
		//	DISABLE CORE CONVERSATIONS (CALLOUTS)
		_civ setVariable ["BIS_noCoreConversations", true];
	
		//	OUTFIT CIVILIAN
		removeAllWeapons _civ;
		removeAllItems _civ;
		removeAllAssignedItems _civ;
		removeUniform _civ;
		removeVest _civ;
		removeBackpack _civ;
		removeHeadgear _civ;
		removeGoggles _civ;
		_civ setFace (selectRandom ["GreekHead_A3_01","GreekHead_A3_02","GreekHead_A3_03","GreekHead_A3_04","GreekHead_A3_05","GreekHead_A3_06","GreekHead_A3_07","GreekHead_A3_08","GreekHead_A3_09","IG_Leader","Miller","Nikos","O_Colonel","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","TanoanHead_A3_05","TanoanHead_A3_06","O_Colonel","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","TanoanHead_A3_05","TanoanHead_A3_06"]);
		_civ setSpeaker (selectRandom ["Male01PER","Male02PER","Male03PER","Male01PER","Male02PER","Male03PER","Male01PER","Male02PER","Male03PER","Male01GRE","Male02GRE","Male03GRE","Male04GRE","Male05GRE","Male06GRE"]);
		_civ forceAddUniform (selectRandom ["U_BG_Guerilla2_1","U_BG_Guerilla2_2","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_C_HunterBody_grn","U_C_Journalist","U_C_Man_casual_1_F","U_C_Man_casual_2_F","U_C_Man_casual_3_F","U_C_Man_casual_4_F","U_C_Man_casual_5_F","U_C_Man_casual_6_F","U_C_man_sport_1_F","U_C_man_sport_2_F","U_C_man_sport_3_F","U_C_Poloshirt_blue","U_C_Poloshirt_burgundy","U_C_Poloshirt_redwhite","U_C_Poloshirt_salmon","U_C_Poloshirt_stripped","U_C_Poloshirt_tricolour","U_C_Poor_1","U_Competitor","U_I_C_Soldier_Bandit_1_F","U_I_C_Soldier_Bandit_2_F","U_I_C_Soldier_Bandit_3_F","U_I_C_Soldier_Bandit_4_F","U_I_C_Soldier_Bandit_5_F","U_I_G_resistanceLeader_F","U_Marshal","U_NikosAgedBody","U_NikosBody","U_OrestesBody","U_Rangemaster"]);
		if (floor random 100 > 67) then {
			_civ addGoggles (selectRandom ["G_Aviator","G_Lady_Blue","G_Shades_Black","G_Shades_Blue","G_Shades_Green","G_Shades_Red","G_Spectacles","G_Sport_Red","G_Sport_Blackyellow","G_Sport_BlackWhite","G_Sport_Checkered","G_Sport_Blackred","G_Sport_Greenblack","G_Squares_Tinted","G_Squares","G_Spectacles_Tinted"]);
		};
		if (floor random 100 > 67) then {
			_civ addHeadgear (selectRandom ["H_Bandanna_gry","H_Bandanna_blu","H_Bandanna_cbr","H_Bandanna_khk","H_Bandanna_mcamo","H_Bandanna_sgg","H_Bandanna_sand","H_Bandanna_surfer","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Bandanna_camo","H_Beret_blk","H_Booniehat_khk","H_Booniehat_mcamo","H_Booniehat_oli","H_Booniehat_tan","H_Booniehat_tna_F","H_Booniehat_dgtl","H_Cap_grn_BI","H_Cap_blk","H_Cap_blu","H_Cap_blk_CMMG","H_Cap_grn","H_Cap_blk_ION","H_Cap_oli","H_Cap_red","H_Cap_surfer","H_Cap_tan","H_Hat_blue","H_Hat_brown","H_Hat_camo","H_Hat_checker","H_Hat_grey","H_Hat_tan","H_StrawHat","H_StrawHat_dark"]);
		};
	};
	_civGroup setSpeedMode "LIMITED";
	_dismissWP = _civGroup addWaypoint [_locPos, 1];
	_dismissWP setWaypointType "DISMISS";
	_dismissWP setWaypointBehaviour "AWARE";
	_dismissWP setWaypointPosition [_locPos, 25];
    [_civGroup,_locPos, AASW_PATROL_RADIUS] call BIS_fnc_taskPatrol;
	_simulGroups pushBack _civGroup;
};

_delayedSimul = [_simulGroups] spawn {
	params ["_simulGroups"];
	uiSleep 10;
	{_x enableDynamicSimulation true} forEach _simulGroups;
};
