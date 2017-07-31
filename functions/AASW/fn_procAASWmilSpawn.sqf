/*
	ASG_fnc_procAASWmilSpawn
	by:	Diffusion9
	"militia spawning"
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
#define AASW_CENSUS_DIVISOR 5
#define AASW_DEFAULT_REP 0
#define AASW_PATROL_RADIUS 100

params ["_loc"];

//	GET LOCATION DATA
_locPos = position _loc;
_locName = text _loc;
_loc = ((nearestLocations [_locPos, AASW_LOCATION_TYPES, AASW_RADIUS, _locPos]) select 0);

//	SIMULATION DELAY GROUP
//	Allows these newly-created units to simulate for a time before being disabled.
_simulGroups = [];
private ["_simulGroups"];

//	MILITIA
//	DEFINE NUMBER OF GROUPS.
_militiaGroups = ceil random 5;
for "_g" from 0 to _militiaGroups do {
	//	DEFINE GROUPS DETAILS.
	_gSize = floor random [2,4,8];
	_groupName = format ["%1 Militia (%2)", _locName, _g];
	_militiaGroup = createGroup [independent, true];
	_militiaGroup setGroupIDGlobal [_groupName];
	_militiaGroup setFormation (selectRandom ["ECH LEFT", "COLUMN", "STAG COLUMN", "WEDGE", "DIAMOND", "VEE"]);
	for "_u" from 0 to _gSize do {
		//	SELECT MILITIA TYPE & CREATE
		_unitType = selectRandom ["I_medic_F","I_officer_F","I_Soldier_AA_F","I_Soldier_AR_F","I_Soldier_AT_F","I_Soldier_GL_F","I_Soldier_LAT_F","I_Soldier_M_F","I_Soldier_SL_F","I_Soldier_TL_F"];
		_obj = _militiaGroup createUnit [_unitType, _locPos, [], 200, "FORM"];
		_obj enableDynamicSimulation true;
		//	OUFIT MILITIA UNIT
		_type = typeof _obj;
		removeAllWeapons _obj;
		removeAllItems _obj;
		removeAllAssignedItems _obj;
		removeUniform _obj;
		removeVest _obj;
		removeBackpack _obj;
		removeHeadgear _obj;
		removeGoggles _obj;

		_obj setFace (selectRandom ["GreekHead_A3_01","GreekHead_A3_02","GreekHead_A3_03","GreekHead_A3_04","GreekHead_A3_05","GreekHead_A3_06","GreekHead_A3_07","GreekHead_A3_08","GreekHead_A3_09","IG_Leader","Miller","Nikos","O_Colonel","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","TanoanHead_A3_05","TanoanHead_A3_06","O_Colonel","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","TanoanHead_A3_05","TanoanHead_A3_06"]);
		_obj setSpeaker (selectRandom ["Male01PER","Male02PER","Male03PER","Male01PER","Male02PER","Male03PER","Male01PER","Male02PER","Male03PER","Male01GRE","Male02GRE","Male03GRE","Male04GRE","Male05GRE","Male06GRE"]);
		_obj forceAddUniform (selectRandom ["U_B_CombatUniform_mcam_tshirt","U_B_CTRG_2","U_B_CTRG_Soldier_2_F","U_B_CTRG_Soldier_urb_2_F","U_B_T_Soldier_AR_F","U_BG_Guerilla1_1","U_BG_Guerilla2_1","U_BG_Guerilla2_2","U_BG_Guerilla2_3","U_BG_Guerilla3_1","U_BG_Guerrilla_6_1","U_BG_leader","U_C_HunterBody_grn","U_I_C_Soldier_Bandit_2_F","U_I_C_Soldier_Bandit_3_F","U_I_C_Soldier_Camo_F","U_I_C_Soldier_Para_1_F","U_I_C_Soldier_Para_2_F","U_I_C_Soldier_Para_3_F","U_I_C_Soldier_Para_4_F","U_I_G_resistanceLeader_F","U_I_G_Story_Protagonist_F"]);
		_obj addVest (selectRandom ["V_BandollierB_blk","V_BandollierB_cbr","V_BandollierB_ghex_F","V_BandollierB_khk","V_BandollierB_oli","V_BandollierB_rgr","V_Chestrig_blk","V_Chestrig_khk","V_Chestrig_oli","V_Chestrig_rgr","V_HarnessO_brn","V_HarnessO_ghex_F","V_HarnessO_gry","V_HarnessOGL_brn","V_HarnessOGL_ghex_F","V_HarnessOGL_gry","V_PlateCarrier1_blk","V_PlateCarrier1_rgr_noflag_F","V_PlateCarrier2_blk","V_PlateCarrier2_rgr_noflag_F","V_PlateCarrierIA1_dgtl","V_TacChestrig_cbr_F","V_TacChestrig_grn_F","V_TacChestrig_oli_F","V_TacVest_blk","V_TacVest_brn","V_TacVest_camo","V_TacVest_khk","V_TacVest_oli","V_TacVestIR_blk"]);
		if (floor random 100 > 67) then {
			_obj addGoggles (selectRandom ["G_Balaclava_blk","G_Balaclava_oli","G_Bandanna_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_khk","G_Bandanna_oli","G_Bandanna_shades","G_Bandanna_sport","G_Bandanna_tan","G_Balaclava_TI_blk_F","G_Balaclava_TI_tna_F"]);
		};
		if (floor random 100 > 67) then {
			_obj addHeadgear (selectRandom ["H_Bandanna_blu","H_Bandanna_camo","H_Bandanna_cbr","H_Bandanna_gry","H_Bandanna_khk","H_Bandanna_mcamo","H_Bandanna_sand","H_Bandanna_sgg","H_Bandanna_surfer","H_Bandanna_surfer_blk","H_Bandanna_surfer_grn","H_Beret_blk","H_Booniehat_dgtl","H_Booniehat_khk","H_Booniehat_khk_hs","H_Booniehat_mcamo","H_Booniehat_oli","H_Booniehat_tan","H_Booniehat_tna_F","H_Cap_blk","H_Cap_blk_CMMG","H_Cap_blk_ION","H_Cap_blk_Raven","H_Cap_blu","H_Cap_brn_SPECOPS","H_Cap_grn","H_Cap_grn_BI","H_Cap_headphones","H_Cap_oli","H_Cap_oli_hs","H_Cap_red","H_Cap_surfer","H_Cap_tan","H_MilCap_blue","H_MilCap_dgtl","H_MilCap_ghex_F","H_MilCap_gry","H_MilCap_mcamo","H_MilCap_ocamo","H_MilCap_tna_F","H_Shemag_olive","H_ShemagOpen_khk","H_ShemagOpen_tan","H_Watchcap_blk","H_Watchcap_camo","H_Watchcap_cbr","H_Watchcap_khk"]);
		};

		switch (_type) do {

			case "I_helipilot_F": {
				removeHeadgear _obj;
				removeGoggles _obj;
				_obj addHeadgear (selectRandom ["H_Cap_marshal","H_Cap_headphones"]);
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addWeapon "arifle_AKS_F";
			};

			case "I_medic_F": {
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addBackpack (selectRandom ["B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_tna_F","B_AssaultPack_rgr"]);
				_obj addItemToBackpack "Medikit";
				_obj addWeapon "arifle_AKS_F";
			};

			case "I_officer_F": {
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addWeapon "arifle_AKS_F";
			};

			case "I_pilot_F": {
				removeHeadgear _obj;
				removeGoggles _obj;
				_obj addHeadgear (selectRandom ["H_Cap_marshal","H_Cap_headphones"]);
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addWeapon "arifle_AKS_F";
			};

			case "I_Sniper_F": {
				removeUniform _obj;
				_obj forceAddUniform "U_I_FullGhillie_sard";
				for "_i" from 1 to 10 do {_obj addItemToVest "7Rnd_408_Mag";};
				_obj addWeapon "srifle_LRR_F";
				_obj addPrimaryWeaponItem "optic_LRPS";
			};

			case "I_Soldier_AA_F": {
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addBackpack (selectRandom ["B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_tna_F","B_AssaultPack_rgr"]);
				_obj addItemToBackpack "Titan_AA";
				_obj addWeapon "launch_B_Titan_tna_F";
				_obj addWeapon "arifle_AKS_F";
			};

			case "I_Soldier_AR_F": {
				for "_i" from 1 to 2 do {_obj addItemToVest "200Rnd_556x45_Box_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addWeapon "LMG_03_F";
			};

			case "I_Soldier_AT_F": {
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addBackpack (selectRandom ["B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_tna_F","B_AssaultPack_rgr"]);
				_obj addItemToBackpack "Titan_AP";
				_obj addItemToBackpack "Titan_AT";
				_obj addWeapon "launch_B_Titan_short_tna_F";
				_obj addWeapon "arifle_AKS_F";
			};

			case "I_Soldier_GL_F": {
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addBackpack (selectRandom ["B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_tna_F","B_AssaultPack_rgr"]);
				for "_i" from 1 to 4 do {_obj addItemToBackpack "RPG7_F";};
				_obj addWeapon "launch_RPG7_F";
				_obj addWeapon "arifle_AKS_F";
			};

			case "I_Soldier_LAT_F": {
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addBackpack (selectRandom ["B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_tna_F","B_AssaultPack_rgr"]);
				for "_i" from 1 to 2 do {_obj addItemToBackpack "NLAW_F";};
				_obj addWeapon "launch_NLAW_F";
				_obj addWeapon "arifle_AKS_F";
			};

			case "I_Soldier_M_F": {
				for "_i" from 1 to 8 do {_obj addItemToVest "20Rnd_762x51_Mag";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addWeapon (selectRandom ["arifle_SPAR_03_blk_F","srifle_DMR_03_F","srifle_DMR_06_olive_F","srifle_EBR_F"]);
				_obj addPrimaryWeaponItem (selectRandom ["optic_Arco_blk_F","optic_ERCO_blk_F","optic_Hamr","optic_KHS_old","optic_SOS"]);
			};

			case "I_Soldier_SL_F": {
				for "_i" from 1 to 10 do {_obj addItemToVest "30Rnd_556x45_Stanag";};
				_obj addWeapon "arifle_SPAR_01_blk_F";
				_obj addPrimaryWeaponItem "optic_ACO_grn";
			};

			case "I_Soldier_TL_F": {
				for "_i" from 1 to 10 do {_obj addItemToVest "30Rnd_556x45_Stanag";};
				_obj addWeapon "arifle_SPAR_01_blk_F";
				_obj addPrimaryWeaponItem "optic_ACO_grn";
			};

			case "I_Spotter_F": {
				removeUniform _obj;
				_obj forceAddUniform "U_I_FullGhillie_sard";
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_545x39_Mag_F";};
				_obj addWeapon "arifle_AKS_F";
			};

			default {
				for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_762x39_Mag_F";};
				for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
				_obj addWeapon (selectRandom ["arifle_AKM_F","arifle_AKM_F","arifle_AKM_F","arifle_AKM_F","arifle_AK12_F"]);
			};
		};
    	[_militiaGroup,_locPos, 650] call BIS_fnc_taskPatrol;
		_simulGroups pushBack _militiaGroup;
	};
};

_delayedSimul = [_simulGroups] spawn {
	params ["_simulGroups"];
	uiSleep 10;
	{_x enableDynamicSimulation true} forEach _simulGroups;
};
