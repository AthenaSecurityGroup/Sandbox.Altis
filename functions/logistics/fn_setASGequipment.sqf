/*
	
	ASG_fnc_setASGequipment
	by:	Diffusion9
	
	Set the target unit gear to the Athena Security Group standard.
	
	EXEC TYPE:	Call
	INPUT:	0	OBJECT	The unit to action on.
	OUTPUT:	0	BOOL	true when action completed.
	
*/

params ["_unit"];

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;
_unit forceAddUniform "U_BG_Guerrilla_6_1";
_unit addHeadgear "H_HelmetB_black";
_unit addVest "V_PlateCarrier1_blk";

if (missionNamespace getVariable ["ASG_fdInit", false]) then {

	for "_i" from 1 to 8 do {_unit addItemToVest "30Rnd_65x39_caseless_mag";};
	for "_i" from 1 to 4 do {_unit addItemToVest "SmokeShell";};
	_unit addWeapon "arifle_MX_Black_F";
	_unit addPrimaryWeaponItem "optic_Aco";
} else {};

_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "ItemWatch";
_unit linkItem "ItemRadio";

true
