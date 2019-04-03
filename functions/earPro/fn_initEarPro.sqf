/*
	ASG_fnc_initEarPro
	by:	Diffusion9 and jmlane

	Adds a keyDown eventHandler that watched the 'End' key (0xCF), or UserAction 1 in the Custom Action menu.
	This should be run locally on the player.

	EXEC TYPE:	Call
	INPUT:		Nothing
	OUTPUT:		Nothing
*/
if !(isNull (uiNamespace getVariable ['ASG_earPro_ctrl', controlNull])) exitWith {};

#include "\A3\Ui_F\hpp\defineDIKCodes.inc"

waitUntil {!(isNull findDisplay 46)};

call {
	disableSerialization;

	private _earProCtrl = findDisplay 46 ctrlCreate ['RscPictureKeepAspect', -1];
	_earProCtrl ctrlShow FALSE;
	_earProCtrl ctrlSetText 'includes\ui\earpro_ca.paa';
	_earProCtrl ctrlSetPosition [
		((0.95 * safezoneW) + safezoneX),
		((0.39 * safezoneH) + safezoneY),
		0.075,
		0.075
	];
	_earProCtrl ctrlSetTextColor [0.8,0.8,0.8,1];
	_earProCtrl ctrlCommit 0;
	uiNamespace setVariable ['ASG_earPro_ctrl', _earProCtrl];
};

findDisplay 46 displayAddEventHandler ["keyDown", {
	params ['_display', '_key', '_shift', '_ctrl', '_alt'];
	private ['_conditions'];
	//	IF CUSTOM KEY IS UNDEFINED
	if (actionKeys 'User1' isEqualTo []) then {
		_conditions = (_key isEqualTo DIK_END)
	} else {
		_conditions = (_key in actionKeys 'User1')
	};
	//	ENABLE / DISABLE EARPLUGS
	if _conditions then {
		if (missionNamespace getVariable ['ASG_earPro_active', false]) then {
			.1 fadeSound 1;
			ASG_earPro_active = false;
			uiNamespace getVariable ['ASG_earPro_ctrl', controlNull] ctrlShow false;
		} else {
			if !(isStreamFriendlyUIEnabled) then {
				uiNamespace getVariable ['ASG_earPro_ctrl', controlNull] ctrlShow true;
			};
			1 fadeSound .04;
			ASG_earPro_active = true;
		};
	};
	false
}];
