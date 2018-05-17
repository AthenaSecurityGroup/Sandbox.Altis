/*
	ASG_fnc_initMedical
	by:	Diffusion9
	
	Athena Combat Medical system. Similar to BIS revive.
	Also includes dragging and loading wounded into vehicles.
	
	EXEC TYPE:	Call
	INPUT:		Nothing
	OUTPUT:		Nothing
*/


//	PLAYER DAMAGE HANDLER
medical_handler = player addEventHandler ["HandleDamage",{ 
    if (_this select 2 > 0.95) then {
        if !(_this select 0 getVariable ["ASGmedical_stateIncap",false]) then {[true] call ASG_fnc_setMedicalState};
		0.95
	};
}];

//	MEDIC RESCUSCITATE
medical_actResuscitate = player addAction ["Resuscitate",{
    _ct = cursorTarget;
    if (_ct getVariable ["ASGmedical_stateIncap",false]) then {
		{inGameUISetEventHandler [_x,"true"]} forEach ["Action","NextAction","PrevAction"];	
		_pDir = getDir player;
		player playMoveNow "ainvpknlmstpsnonwnondr_medic3";
		{
			timeToKill = time + 180;
			startTime = time;
		} remoteExec ["call", _ct];
		waitUntil {
			player setDir _pDir;
			(animationState player == "ainvpknlmstpsnonwnondnon_medicend");
		};
		_ct setVariable ["ASGmedical_stateIncap",false];
		[false] remoteExec ["ASG_fnc_setMedicalState", _ct];
		{inGameUISetEventHandler [_x,"false"]} forEach ["Action","NextAction","PrevAction"];
    }
},nil,6,true,false,"",'
    player getUnitTrait "medic" &&
    "Medikit" in items player &&
	isPlayer cursorTarget &&
	cursorTarget isKindOf "Man" &&
	!surfaceIsWater getPos player &&
	{cursorTarget getVariable ["ASGmedical_stateIncap",false]} &&
	!(cursorTarget getVariable ["ASGmedical_stateRagdoll",false]) &&
	alive cursorTarget &&
	isNull attachedTo cursorTarget &&
	player distance cursorTarget <= 1.75
'];

//	NON-MEDIC STABILIZE
medical_actStabilize = player addAction ["Stabilize",{
    _ct = cursorTarget;
    if (_ct getVariable ["ASGmedical_stateIncap",false]) then {
		{
			startTime = time;
			timeToKill = time + 180;
		} remoteExec ["call", _ct];
		{inGameUISetEventHandler [_x,"true"]} forEach ["Action","NextAction","PrevAction"];
		_pDir = getDir player;
		player playMoveNow "ainvpknlmstpsnonwnondr_medic3";
		waitUntil {
			player setDir _pDir;
			(animationState player == "ainvpknlmstpsnonwnondnon_medicend");
		};
		{inGameUISetEventHandler [_x,"false"]} forEach ["Action","NextAction","PrevAction"];
    }
},nil,6,true,false,"",'
	!("Medikit" in items player) &&
	{cursorTarget getVariable ["ASGmedical_stateIncap",false]} &&
	!(cursorTarget getVariable ["ASGmedical_stateRagdoll",false]) &&
	!surfaceIsWater getPos player &&
	player distance cursorTarget <= 2.2 &&
	alive cursorTarget &&
	isNull attachedTo cursorTarget
'];

//	DRAGON DROP
medical_actDrag = player addAction ["Drag Wounded", {
	_ct = cursorTarget;
	if ({if (_x getVariable ["ASGmedical_stateIncap",false]) exitWith {TRUE}; FALSE} forEach crew _ct) then {
		if (_ct isKindOf "Man") exitWith {
			_isCarrying = {_x getVariable ["ASGmedical_stateIncap",false]} count attachedObjects player > 0;
			if _isCarrying then {
				//	TRUE, DROP THE WOUNDED
				[] spawn ASG_fnc_doMedicalDropAct;
				[_ct] remoteExec ["ASG_fnc_getMedicalDropAct", _ct];
				detach _ct;
			} else {
				//	FALSE, PICK UP THE WOUNDED.
				[_ct] spawn ASG_fnc_doMedicalDragAct;
				[_ct] remoteExec ["ASG_fnc_getMedicalDragAct", _ct];
			};
		};
	};
}, nil, 6, true, true, 'Action', '
	!surfaceIsWater getPos player &&
	player distance cursorTarget <= 2.2 &&
	{cursorTarget getVariable ["ASGmedical_stateIncap",false]} &&
	!(cursorTarget getVariable ["ASGmedical_stateRagdoll",false]) &&
	alive cursorTarget &&
	(isNull attachedTo cursorTarget || player == attachedTo cursorTarget)
'];

//	UNLOAD WOUNDED FROM VEHICLE
1 spawn { while {TRUE} do {
		scriptName "ASG Medical: Wounded Unloading";
        _ct = cursorTarget;
        _actions = [];
        _crew = [];
        if (_ct isKindOf "LandVehicle") then {
            _crew = crew _ct;
            if (_crew isEqualTo []) exitWith {};
            {
                if (_x getVariable ["ASGmedical_stateIncap",false]) then {
                    _action = _ct addAction [
                        format["Unload Wounded (%1)",name _x],
                        {
							params ["_vehicle", "_player", "_action", "_unit"]; // _vehicle = _this select 0; // _player = _this select 1; // _action = _this select 2; // _unit = _this select 3;
							[_unit, false] remoteExec ["setUnconscious"];
							uiSleep 0.5;
							[_unit, ["Eject", vehicle _unit]] remoteExec ["action"];
                            unassignVehicle _unit;
							uiSleep 1;
							[_unit, true] remoteExec ["setUnconscious"];
							uiSleep 6;
							(cursorTarget setVariable ["ASGmedical_stateRagdoll",false,true]);
                        },
                        _x,
                        1,
                        false,
                        true,
                        "",
                        '
                            alive _target && {_target distance player < 5}
                        '
                    ];
                    _actions pushBack _action;
                };
                false
            } count _crew;
            waitUntil {uiSleep _this; cursorTarget != _ct || !(crew _ct isEqualTo _crew)};
            {
                _ct removeAction _x;
            } count _actions;
        };
    };
};

//	LOAD WOUNDED INTO VEHICLES
medical_actLoad = player addAction ["Load Wounded", {
	_ct = cursorTarget;
	_pl = player;
	_vehicle = ((player nearEntities ["LandVehicle", 4]) select 0);
	_cargoAmount = _vehicle emptyPositions "Cargo";
	if (_cargoAmount > 0) then {
		ASGmedical_loadAnimation = [_ct, _vehicle, _pl] spawn {
			params ["_ct","_vehicle", "_pl"];
			[player, false] remoteExec ["setUnconscious", _ct];
			uiSleep 0.5;
			[_ct, ((player nearEntities ["LandVehicle", 3.4]) select 0)] remoteExec ["moveInCargo", _ct];
			sleep 2;
			[_ct, true] remoteExec ["setUnconscious", _ct];
			_ct playActionNow "Die";
			[_ct, "Die"] remoteExec ["playActionNow", _ct];
		};
	} else {
		systemChat format["This %2 has no remaining Cargo positions for the wounded.",name _unit,getText(configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName")];
	};
}, nil, 6, true, true, 'Action', '
	!surfaceIsWater getPos player &&
	player distance cursorTarget <= 2.2 &&
	{cursorTarget getVariable ["ASGmedical_stateIncap",false]} &&
	!(cursorTarget getVariable ["ASGmedical_stateRagdoll",false]) &&
	alive cursorTarget &&
	!((player nearEntities ["LandVehicle", 3.4]) isEqualTo []) &&
	!(cursorTarget getVariable ["ASGmedical_stateDrag", false]);
'];
