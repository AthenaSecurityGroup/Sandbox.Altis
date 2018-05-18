/*
	ASG_fnc_initEarPro
	by:	Diffusion9
	
	Adds a keyDown eventHandler that watched the 'End' key, or UserAction 1 in the Custom Action menu.
	This should be run locally on the player.
	
	EXEC TYPE:	Call
	INPUT:		Nothing
	OUTPUT:		Nothing
*/

#include "\A3\Ui_F\hpp\defineDIKCodes.inc"

if (!isNil "earPro_handler") exitWith {true};

earPro_handler = findDisplay 46 displayAddEventHandler ["keyDown", {
    params ['_display', '_key', '_shift', '_ctrl','_alt'];
	private ['_conditions'];
	//	IF CUSTOM KEY IS UNDEFINED
	if (actionKeys 'User1' isEqualTo []) then {
		_conditions = (_key isEqualTo DIK_END)
	} else {
		_conditions = (_key in actionKeys 'User1')
	};
	//	ENABLE / DISABLE EARPLUGS
    if _conditions then {
        if (missionNamespace getVariable ['earPlugs_state', false]) then {
            .1 fadeSound 1;
            earPlugs_state = false;
        } else {
            1 fadeSound .04;
            earPlugs_state = true;
        };      
    };
}];
earPro_handler
