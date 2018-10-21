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
		_loadout # 3 set [1, [["SmokeShell", 4, 1]]];
		_loadout # 4 set [1, [["200Rnd_556x45_Box_F", 3, 200]]];
		_loadout
	};

	case "I_G_Soldier_AR_F": {
		private _loadout = +_baseSpecOpsLoadout;
		_loadout set [0, ["LMG_03_F", "", "", "optic_ACO_grn", ["200Rnd_556x45_Box_F", 200], [], ""]];
		_loadout # 3 set [1, [["SmokeShell", 4, 1]]];
		_loadout # 4 set [1, [["200Rnd_556x45_Box_F", 3, 200]]];
		_loadout
	};

	case "I_Soldier_lite_F": {
		private _loadout = +_baseLoadout;
		_loadout set [0, ["LMG_Zafir_F", "", "", "optic_ACO_grn", ["150Rnd_762x54_Box", 150], [], ""]];
		_loadout # 4 set [1, [["150Rnd_762x54_Box", 4, 150]]];
		_loadout
	};

	case "I_Soldier_SL_F": {
		private _loadout = +_baseLoadout;
		_loadout set [0, [_launcher, "", "", "optic_ACO_grn", ["30Rnd_556x45_Stanag_green", 30], ["1Rnd_HE_Grenade_shell", 1], ""]];
		_loadout # 4 # 1 + [["1Rnd_HE_Grenade_shell", 4, 1], ["1Rnd_Smoke_Grenade_shell", 4, 1]];
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

	case "I_Soldier_GL_F": {
		private _loadout = +_baseLoadout;
		_loadout set [1, ["launch_RPG7_F", "", "", "", ["RPG7_F", 1], [], ""]];
		_loadout # 5 # 1 pushback ["RPG7_F", 4, 1];
		_loadout
	};

	case "I_G_Soldier_GL_F": {
		private _loadout = +_baseSpecOpsLoadout;
		_loadout set [0, [_launcher, "", "", "optic_ACO_grn", ["30Rnd_556x45_Stanag_green", 30], ["1Rnd_HE_Grenade_shell", 1], ""]];
		_loadout # 4 # 1 + [["1Rnd_HE_Grenade_shell", 4, 1], ["1Rnd_Smoke_Grenade_shell", 4, 1]];
		_loadout
	};

	case "I_Soldier_LAT_F": {
		private _loadout = +_baseLoadout;
		_loadout set [1, ["launch_NLAW_F", "", "", "", ["NLAW_F", 1], [], ""]];
		_loadout # 5 # 1 pushBack ["NLAW_F", 2, 1];
		_loadout
	};

	case "I_G_Soldier_LAT_F": {
		private _loadout = +_baseSpecOpsLoadout;
		_loadout set [1, ["launch_NLAW_F", "", "", "", ["NLAW_F", 1], [], ""]];
		_loadout # 5 # 1 pushBack ["NLAW_F", 2, 1];
		_loadout
	};

	case "I_Soldier_AT_F": {
		private _loadout = +_baseLoadout;
		_loadout set [1, ["launch_B_Titan_short_tna_F", "", "", "", ["Titan_AT", 1], [], ""]];
		_loadout # 5 # 1 + [["Titan_AP", 1, 1], ["Titan_AT", 1, 1]];
		_loadout
	};

	case "I_Soldier_AA_F": {
		private _loadout = +_baseLoadout;
		_loadout set [1, ["launch_B_Titan_tna_F", "", "", "", ["Titan_AA", 1], [], ""]];
		_loadout # 5 # 1 + [["Titan_AA", 1, 1]];
		_loadout
	};

	case "I_Soldier_M_F": {
		private _loadout = +_baseLoadout;
		_loadout set [0, [_marksman, "", "", "optic_MRCO", ["30Rnd_556x45_Stanag_green", 30], [], ""]];
		_loadout
	};

	case "I_G_Soldier_M_F": {
		private _loadout = +_baseSpecOpsLoadout;
		_loadout set [0, [_marksman, "", "", "optic_MRCO", ["30Rnd_556x45_Stanag_green", 30], [], ""]];
		_loadout
	};

	case "I_Sniper_F": {
		[
			["srifle_LRR_F", "", "", "optic_KHS_blk", ["7Rnd_408_Mag", 7], [], ""],
			[],
			["hgun_P07_F", "", "", "", ["16Rnd_9x21_Mag", 16], [], ""],
			["U_I_FullGhillie_sard", [["16Rnd_9x21_Mag", 4, 16], ["SmokeShell", 2, 1]]],
			["V_PlateCarrierIA1_dgtl", [["7Rnd_408_Mag", 8, 7], ["SmokeShell", 2, 1]]],
			[],
			_baseLoadoutHelmet,
			"",
			[],
			["", "", "", "", "", "NVGoggles_INDEP"]
		]
	};

	case "I_Spotter_F": {
		private _loadout = +_baseLoadout;
		_loadout set [3, ["U_I_FullGhillie_sard", []]];
		_loadout # 4 set [0, "V_PlateCarrierIA1_dgtl"];
		_loadout set [9, ["", "", "", "", "", "NVGoggles_INDEP"]];
		_loadout
	};

	case "I_crew_F": {
		private _loadout = +_baseLoadout;
		_loadout set [3, ["U_I_HeliPilotCoveralls", []]];
		_loadout # 4 set [0, "V_PlateCarrierIA1_dgtl"];
		_loadout set [6, "H_HelmetCrew_I"];
		_loadout
	};

	case "I_diver_exp_F": {
		[
			[_carbine, "muzzle_snds_M", "", "optic_ACO_grn", ["30Rnd_556x45_Stanag_green", 30], [], ""],
			[],
			[],
			["U_I_Wetsuit", [["30Rnd_556x45_Stanag_green", 8, 30], ["SmokeShell", 4, 1]]],
			["V_RebreatherIA", []],
			["B_AssaultPack_blk", ["ToolKit", "MineDetector", ["DemoCharge_Remote_Mag", 3, 1]]],
			"",
			"G_I_Diving",
			[],
			["", "", "", "", "", "NVGoggles_INDEP"]
		]
	};

	case "I_diver_F": {
		[
			["LMG_03_F", "muzzle_snds_M", "", "optic_ACO_grn", ["200Rnd_556x45_Box_F", 200], [], ""],
			[],
			[],
			["U_I_Wetsuit", [["200Rnd_556x45_Box_F", 1, 200], ["SmokeShell", 4, 1]]],
			["V_RebreatherIA", []],
			["B_AssaultPack_blk", [["200Rnd_556x45_Box_F", 4, 200]]],
			"",
			"G_I_Diving",
			[],
			["", "", "", "", "", "NVGoggles_INDEP"]
		]
	};

	case "I_diver_TL_F": {
		[
			[_launcher, "muzzle_snds_M", "", "optic_ACO_grn", ["30Rnd_556x45_Stanag_green", 30], [], ""],
			[],
			[],
			["U_I_Wetsuit", [["30Rnd_556x45_Stanag_green", 8, 30], ["SmokeShell", 4, 1]]],
			["V_RebreatherIA", []],
			["B_AssaultPack_blk", [["SatchelCharge_Remote_Mag", 1, 1], ["1Rnd_HE_Grenade_shell", 10, 1], ["1Rnd_Smoke_Grenade_shell", 10, 1]]],
			"",
			"G_I_Diving",
			[],
			["", "", "", "", "", "NVGoggles_INDEP"]
		]
	};

	case "I_engineer_F": {
		private _loadout = +_baseLoadout;
		_loadout # 5 # 1 + ["ToolKit", "MineDetector", ["DemoCharge_Remote_Mag", 3, 1]];
		_loadout
	};

	case "I_helicrew_F": {
		[
			_baseLoadoutPrimaryWeapon,
			[],
			[],
			["U_I_HeliPilotCoveralls", []],
			["V_TacVest_khk", _baseLoadoutVest # 1],
			[],
			"H_CrewHelmetHeli_I",
			"",
			[],
			_baseLoadoutItems
		]
	};

	case "I_helipilot_F": {
		[
			_baseLoadoutPrimaryWeapon,
			[],
			[],
			["U_I_HeliPilotCoveralls", []],
			["V_TacVest_khk", _baseLoadoutVest # 1],
			[],
			"H_PilotHelmetHeli_I",
			"",
			[],
			_baseLoadoutItems
		]
	};

	case "I_pilot_F": {
		[
			_baseLoadoutPrimaryWeapon,
			[],
			[],
			["U_I_pilotCoveralls", [["30Rnd_556x45_Stanag_green", 5, 30], ["SmokeShell", 4, 1]]],
			[],
			[],
			"H_PilotHelmetHeli_I",
			"",
			[],
			_baseLoadoutItems
		]
	};

	case "I_Soldier_exp_F": {
		private _loadout = +_baseLoadout;
		_loadout # 5 set [1, ["ToolKit", "MineDetector", ["DemoCharge_Remote_Mag", 3, 1]]];
		_loadout
	};

	case "I_Soldier_repair_F": {
		private _loadout = +_baseLoadout;
		_loadout # 5 set [1, ["ToolKit"]];
		_loadout
	};

	case "I_soldier_UAV_F": {
		private _loadout = +_baseLoadout;
		_loadout set [5, ["I_UAV_01_backpack_F", []]];
		_loadout set [9, ["", "I_UavTerminal", "", "", "", ""]];
		_loadout
	};

	default { _baseLoadout };
};

//[_obj, _loadout] remoteExec ["setUnitLoadout", _obj, false];
_obj setUnitLoadout _loadout;
_loadout
