params [
	["_obj", objNull, [objNull]]
];

if (isNull _obj) exitWith { ["Invalid Argument: must provide valid object"] call BIS_fnc_error};
if (_obj in playableUnits) exitWith { ["Playable units are not appropriate targets"] call BIS_fnc_error };

_obj setFace (selectRandom ["GreekHead_A3_01","GreekHead_A3_02","GreekHead_A3_05","GreekHead_A3_06","GreekHead_A3_07","GreekHead_A3_08","GreekHead_A3_09","IG_Leader","Miller","Nikos","O_Colonel","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","TanoanHead_A3_05","TanoanHead_A3_06","O_Colonel","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","PersianHead_A3_01","PersianHead_A3_02","PersianHead_A3_03","TanoanHead_A3_05","TanoanHead_A3_06"]);
_obj setSpeaker (selectRandom ["Male01PER","Male02PER","Male03PER","Male01PER","Male02PER","Male03PER","Male01PER","Male02PER","Male03PER","Male01GRE","Male02GRE","Male03GRE","Male04GRE","Male05GRE","Male06GRE"]);
private _uniform = (selectRandom ["U_I_CombatUniform","U_I_CombatUniform","U_I_CombatUniform","U_I_CombatUniform_shortsleeve","U_I_OfficerUniform"]);
private _vest = (selectRandom ["V_PlateCarrierIAGL_dgtl","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA1_dgtl","V_PlateCarrierIA2_dgtl"]);
private _goggles = (selectRandom ["","","","","","","G_Combat","G_Combat_Goggles_tna_F","G_Lowprofile"]);
private _pack = (selectRandom ["B_AssaultPack_blk","B_AssaultPack_cbr","B_AssaultPack_dgtl","B_AssaultPack_rgr"]);
private _carbine = (selectrandom ["arifle_Mk20C_F","arifle_Mk20C_plain_F"]);
private _launcher = (selectrandom ["arifle_Mk20_GL_F","arifle_Mk20_GL_plain_F"]);
private _marksman = (selectrandom ["arifle_Mk20_F","arifle_Mk20_plain_F"]);

// https://community.bistudio.com/wiki/Unit_Loadout_Array
// TODO: Use the randomized class names assigned above and drop them in.
// TODO: Additional base loadouts. Anything that's common to a set of vehicle classes should be defined once upfront.
private _baseLoadoutPrimaryWeapon = [_carbine, "", "", "optic_ACO_grn", ["30Rnd_556x45_Stanag_green", 30], [], ""];
private _baseLoadoutUniform = [_uniform, []];
private _baseLoadoutVest = [_vest, [["30Rnd_556x45_Stanag_green", 8, 30], ["SmokeShell", 4, 1]]];
private _baseLoadoutBackpack = [_pack, []];
private _baseLoadoutHelmet = "H_HelmetIA";
private _baseLoadoutGoggles = _goggles;
private _baseLoadoutItems = ["", "", "", "", "", ""];

private _baseLoadout = [
	_baseLoadoutPrimaryWeapon,
	[],
	[],
	_baseLoadoutUniform,
	_baseLoadoutVest,
	_baseLoadoutBackpack,
	_baseLoadoutHelmet,
	_baseLoadoutGoggles,
	[],
	_baseLoadoutItems
];

private _baseSpecOpsLoadout = [
	_baseLoadoutPrimaryWeapon,
	[],
	[],
	["U_I_GhillieSuit", []],
	["V_PlateCarrierIA1_dgtl", +(_baseLoadoutVest # 1)],
	_baseLoadoutBackpack,
	_baseLoadoutHelmet,
	"",
	[],
	["", "", "", "", "", "NVGoggles_INDEP"]
];

private _loadout = switch (typeOf _obj) do {
	case "I_soldier_F": {
		_baseLoadout
	};

	case "I_G_Soldier_F": {
		_baseSpecOpsLoadout
	};

	case "I_medic_F": {
		private _loadout = +_baseLoadout;
		_loadout # 5 # 1 pushback "Medikit";
		_loadout
	};

	case "I_G_medic_F": {
		private _loadout = +_baseSpecOpsLoadout;
		_loadout # 5 # 1 pushback "Medikit";
		_loadout
	};

	case "I_officer_F": {
		private _loadout = +_baseLoadout;
		_loadout # 4 # 1 + [["SmokeShellYellow", 2, 1], ["SmokeShellGreen", 2, 1]],
		_loadout
	};

	case "I_G_officer_F";
	case "I_G_Soldier_SL_F": {
		private _loadout = +_baseSpecOpsLoadout;
		_loadout # 4 # 1 + [["SmokeShellYellow", 2, 1], ["SmokeShellGreen", 2, 1]];
		_loadout
	};

	case "I_Soldier_AR_F": {
		private _loadout = +_baseLoadout;
		_loadout set [0, ["LMG_03_F", "", "", "optic_ACO_grn", ["200Rnd_556x45_Box_F", 200], [], ""]];
		_loadout # 3 set [1, [["SmokeShell", 4, 1]]]
		_loadout # 4 set [1, [["200Rnd_556x45_Box_F", 3, 200]]];
		_loadout
	};

	case "I_G_Soldier_AR_F": {
		private _loadout = +_baseSpecOpsLoadout;
		_loadout set [0, ["LMG_03_F", "", "", "optic_ACO_grn", ["200Rnd_556x45_Box_F", 200], [], ""]];
		_loadout # 3 set [1, [["SmokeShell", 4, 1]]]
		_loadout # 4 set [1, [["200Rnd_556x45_Box_F", 3, 200]]];
		_loadout
	};

	case "I_Soldier_SL_F": {
		private _loadout = +_baseLoadout;
		_loadout set [0, [_launcher, "", "", "optic_ACO_grn", ["30Rnd_556x45_Stanag_green", 30], ["1Rnd_HE_Grenade_shell", 1], ""]];
		_loadout # 4 # 1 = [["1Rnd_HE_Grenade_shell", 4, 1], ["1Rnd_Smoke_Grenade_shell", 4, 1]];
		_loadout
	};

	case "I_Soldier_TL_F": {
		private _loadout = +_baseLoadout;
		_loadout # 4 # 1 pushback ["HandGrenade", 2, 1];
		_loadout
	};

	case "I_G_Soldier_TL_F": {
		private _loadout = +_baseSpecOpsLoadout;
		_loadout # 4 # 1 pushback ["HandGrenade", 2, 1];
		_loadout
	};

	case "I_G_Soldier_GL_F": {
		_obj forceAddUniform "U_I_GhillieSuit";
		_obj addVest "V_PlateCarrierIA1_dgtl";
		_obj addHeadgear "H_HelmetIA";
		_obj linkItem "NVGoggles_INDEP";
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "1Rnd_HE_Grenade_shell";};
		for "_i" from 1 to 4 do {_obj addItemToVest "1Rnd_Smoke_Grenade_shell";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon _launcher;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_G_Soldier_LAT_F": {
		_obj forceAddUniform "U_I_GhillieSuit";
		_obj addVest "V_PlateCarrierIA1_dgtl";
		_obj addHeadgear "H_HelmetIA";
		_obj linkItem "NVGoggles_INDEP";
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addBackpack _pack;
		for "_i" from 1 to 2 do {_obj addItemToBackpack "NLAW_F";};
		_obj addWeapon "launch_NLAW_F";
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_G_Soldier_M_F": {
		_obj forceAddUniform "U_I_GhillieSuit";
		_obj addVest "V_PlateCarrierIA1_dgtl";
		_obj addHeadgear "H_HelmetIA";
		_obj linkItem "NVGoggles_INDEP";
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon _marksman;
		_obj addPrimaryWeaponItem "optic_MRCO";
	};

	case "I_crew_F": {
		_obj forceAddUniform "U_I_HeliPilotCoveralls";
		_obj addVest "V_PlateCarrierIA1_dgtl";
		_obj addHeadgear "H_HelmetCrew_I";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon "arifle_Mk20C_plain_F";
	};

	case "I_diver_exp_F": {
		_obj forceAddUniform "U_I_Wetsuit";
		_obj addVest "V_RebreatherIA";
		for "_i" from 1 to 8 do {_obj addItemToUniform "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToUniform "SmokeShell";};
		_obj addBackpack "B_AssaultPack_blk";
		_obj addItemToBackpack "ToolKit";
		_obj addItemToBackpack "MineDetector";
		for "_i" from 1 to 3 do {_obj addItemToBackpack "DemoCharge_Remote_Mag";};
		_obj addGoggles "G_I_Diving";
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "muzzle_snds_M";
		_obj addPrimaryWeaponItem "optic_ACO_grn";
		_obj linkItem "NVGoggles_INDEP";
	};

	case "I_diver_F": {
		_obj forceAddUniform "U_I_Wetsuit";
		_obj addVest "V_RebreatherIA";
		for "_i" from 1 to 2 do {_obj addItemToUniform "200Rnd_556x45_Box_F";};
		for "_i" from 1 to 4 do {_obj addItemToUniform "SmokeShell";};
		_obj addBackpack "B_AssaultPack_blk";
		for "_i" from 1 to 4 do {_obj addItemToBackpack "200Rnd_556x45_Box_F";};
		_obj addGoggles "G_I_Diving";
		_obj addWeapon "LMG_03_F";
		_obj addPrimaryWeaponItem "muzzle_snds_M";
		_obj addPrimaryWeaponItem "optic_ACO_grn";
		_obj linkItem "NVGoggles_INDEP";
	};

	case "I_diver_TL_F": {
		_obj forceAddUniform "U_I_Wetsuit";
		_obj addVest "V_RebreatherIA";
		for "_i" from 1 to 8 do {_obj addItemToUniform "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToUniform "SmokeShell";};
		_obj addBackpack "B_AssaultPack_blk";
		for "_i" from 1 to 10 do {_obj addItemToBackpack "1Rnd_HE_Grenade_shell";};
		for "_i" from 1 to 10 do {_obj addItemToBackpack "1Rnd_Smoke_Grenade_shell";};
		_obj addItemToBackpack "SatchelCharge_Remote_Mag";
		_obj addGoggles "G_I_Diving";
		_obj addWeapon _launcher;
		_obj addPrimaryWeaponItem "muzzle_snds_M";
		_obj addPrimaryWeaponItem "optic_ACO_grn";
		_obj linkItem "NVGoggles_INDEP";
	};

	case "I_engineer_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addBackpack _pack;
		_obj addItemToBackpack "ToolKit";
		_obj addItemToBackpack "MineDetector";
		for "_i" from 1 to 3 do {_obj addItemToBackpack "DemoCharge_Remote_Mag";};
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_helicrew_F": {
		_obj forceAddUniform "U_I_HeliPilotCoveralls";
		_obj addVest "V_TacVest_khk";
		_obj addHeadgear "H_CrewHelmetHeli_I";
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon "arifle_Mk20C_plain_F";
	};

	case "I_helipilot_F": {
		_obj forceAddUniform "U_I_HeliPilotCoveralls";
		_obj addVest "V_TacVest_khk";
		_obj addHeadgear "H_PilotHelmetHeli_I";
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon "arifle_Mk20C_plain_F";
	};

	case "I_pilot_F": {
		_obj forceAddUniform "U_I_pilotCoveralls";
		_obj addHeadgear "H_PilotHelmetFighter_I";
		for "_i" from 1 to 6 do {_obj addItemToUniform "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToUniform "SmokeShell";};
		_obj addWeapon "arifle_Mk20C_plain_F";
	};

	case "I_Sniper_F": {
		_obj forceAddUniform "U_I_FullGhillie_sard";
		_obj addVest "V_PlateCarrierIA1_dgtl";
		_obj addHeadgear "H_HelmetIA";
		_obj linkItem "NVGoggles_INDEP";
		for "_i" from 1 to 8 do {_obj addItemToVest "7Rnd_408_Mag";};
		for "_i" from 1 to 4 do {_obj addItemToVest "16Rnd_9x21_Mag";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon "srifle_LRR_F";
		_obj addWeapon "hgun_P07_F";
		_obj addPrimaryWeaponItem "optic_KHS_blk";
	};

	case "I_Soldier_AA_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addBackpack _pack;
		_obj addItemToBackpack "Titan_AA";
		_obj addWeapon "launch_B_Titan_tna_F";
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_Soldier_AT_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addBackpack _pack;
		_obj addItemToBackpack "Titan_AP";
		_obj addItemToBackpack "Titan_AT";
		_obj addWeapon "launch_B_Titan_short_tna_F";
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_Soldier_exp_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addBackpack _pack;
		_obj addItemToBackpack "ToolKit";
		_obj addItemToBackpack "MineDetector";
		for "_i" from 1 to 3 do {_obj addItemToBackpack "DemoCharge_Remote_Mag";};
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_Soldier_GL_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addBackpack _pack;
		for "_i" from 1 to 2 do {_obj addItemToBackpack "RPG7_F";};
		_obj addWeapon "launch_RPG7_F";
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_Soldier_LAT_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addBackpack _pack;
		for "_i" from 1 to 4 do {_obj addItemToBackpack "NLAW_F";};
		_obj addWeapon "launch_NLAW_F";
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_Soldier_lite_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 4 do {_obj addItemToVest "150Rnd_762x54_Box";};
		_obj addWeapon "LMG_Zafir_F";
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_Soldier_M_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon _marksman;
		_obj addPrimaryWeaponItem "optic_MRCO";
	};

	case "I_Soldier_repair_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addBackpack _pack;
		_obj addItemToBackpack "ToolKit";
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	case "I_soldier_UAV_F": {
		_obj forceAddUniform _uniform;
		_obj addVest _vest;
		_obj addHeadgear "H_HelmetIA";
		_obj addGoggles _goggles;
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
		_obj linkItem "I_UavTerminal";
		_obj addBackpack "I_UAV_01_backpack_F";

	};

	case "I_Spotter_F": {
		_obj forceAddUniform "U_I_FullGhillie_sard";
		_obj addVest "V_PlateCarrierIA1_dgtl";
		_obj addHeadgear "H_HelmetIA";
		_obj linkItem "NVGoggles_INDEP";
		for "_i" from 1 to 8 do {_obj addItemToVest "30Rnd_556x45_Stanag_green";};
		for "_i" from 1 to 4 do {_obj addItemToVest "SmokeShell";};
		_obj addWeapon _carbine;
		_obj addPrimaryWeaponItem "optic_ACO_grn";
	};

	default { _baseLoadout };
};

//[_obj, _loadout] remoteExec ["setUnitLoadout", _obj, false];
_obj setUnitLoadout _loadout;
_loadout
