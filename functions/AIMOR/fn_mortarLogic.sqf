/*

	ASG_fnc_mortarLogic
	
	Receives a string to create variable names, and a list of targets. Processes the targets and initiates the mortar logic.
	
	REQUIRED INPUTS:
	0 - STRING	Name to generate variables.
	1 - ARRAY	List of targets.
	OPTIONAL INPUTS:
	2 - BOOLEAN	Mortar ammo state. Unlimited or Not.

*/

params ['_mortarVarStr', '_mortarTargetArr', '_mortarAmmoState'];

//	SET STRINGS.
_mortarStsStr = format ['%1_stateScript', _mortarVarStr];
_mortarTrgStr = format ["%1_trigger", _mortarVarStr];
_mortarScrStr = format ["%1_script", _mortarVarStr];
_mortarPriStr = format ["%1_primary", _mortarVarStr];
_mortarSecStr = format ["%1_secondary", _mortarVarStr];
_mortarCrewStr = format ["%1_crew", _mortarVarStr];
_mortarDirStr = format ["%1_dir", _mortarVarStr];

//	SET WORKING VARIABLES.
_rangePairs = [ [350,250],[250,150],[150,50],[50,0],[0,0] ];
_strikeCounter = 0;			//	Starts the strike counter at 0.
_callForFireLoop = false;	//	If true, stops the mortar fire loop.
_mortarChance = 80;			//	Chance to trigger mortar engagement. (75 = 25%).
_callForFireRoll = 60;		//	Time between dice rolls after failing a dice roll.
_mortarCoolDown = 120;		//	Cooldown timer after an FFE before it restarts the sequence.
_mortarLoiterDist = 25;		//	How far the target must be from its last position to avoid zeroing.
_mortarBrackPOS = [0,0];	//	Default initial value for target bracketing.

//	RUN THE STATE CHECK THREAD, TO CHECK STATUS OF THE MORTAR AT INTERVALS.
missionNameSpace setVariable [_mortarStsStr, [_mortarVarStr] spawn {
	params ['_mortarVarStr'];
	_mortarPriStr = format ["%1_primary", _mortarVarStr];
	_mortarSecStr = format ["%1_secondary", _mortarVarStr];
	_mortarCrewStr = format ["%1_crew", _mortarVarStr];
	_statusCheck = false;
	waitUntil {
		sleep 2;
		if (_mortarVarStr call ASG_fnc_mortarDestroyed) exitWith {_statusCheck = true};
		if (_mortarVarStr call ASG_fnc_mortarAbandon) exitWith {
			sleep 1.5;
			{
				_x setDamage 1;
			} forEach [(missionNameSpace getVariable _mortarPriStr), (missionNameSpace getVariable _mortarSecStr)];
			sleep 5;
			{
				_x enableAI "TARGET";
				_x enableAI "AUTOTARGET";
			} forEach units (missionNameSpace getVariable _mortarCrewStr);
			terminate _thisScript;
		};
		if (!triggerActivated (missionNameSpace getVariable format ['%1_trigger', _mortarVarStr])) exitWith {_statusCheck = true};
		_statusCheck
	};
	terminate _thisScript;
}
];

//	'AUTHORIZATION DELAY' -- SO MORTARS DO NOT TRIGGER IMMEDIATELY ONACT
uiSleep 1;	// 60
waitUntil {
	sleep _callForFireRoll;
	(floor random 100 >= _mortarChance)
};	

//	WHEN CALL FOR FIRE HAS BEEN CLEARED, SELECT TARGET.
_mortarTarget = selectRandom _mortarTargetArr;
diag_log format ['[mortarLogic]:	Requesting fire at grid %1.', (mapGridPosition _mortarTarget)];

//	BEGIN CALL FOR FIRE LOOP.
private ['_targetPOS'];
waitUntil {
	_strikeCounter = _strikeCounter + 1;
	
	//	CHECK FOR FRIENDLIES DANGER-CLOSE.
	_nearList = (getPOS _mortarTarget nearEntities [["Man","Car","Tank"], 100]);
	{
		if (side _x == (side (missionNameSpace getVariable _mortarPriStr))) exitWith {
			_strikeCounter = 5;
			_mortarBrackPOS = [0,0,0];
			diag_log format ['[mortarLogic]:	Friendlies are too close for fire mission. Skipping.'];
		};
	} forEach _nearList;
	
	//	POINT MORTARS AT TARGET, RESET AMMO IF APPLICABLE
	{
		_x lookAt (getPOS _mortarTarget);
		if (_mortarAmmoState) then {_x setVehicleAmmoDef 1};
	} forEach [(missionNameSpace getVariable _mortarPriStr), (missionNameSpace getVariable _mortarSecStr)];
	
	//	BEGIN STRIKE LOGIC.
	if (_strikeCounter <= 4) then {
		//	BRACKETING SHOT
		private ['_adjustmentX', '_adjustmentY'];
		_rangeData = _rangePairs select (_strikeCounter - 1);
		waitUntil {
			_adjustmentX = round random [(0 - (_rangeData select 0)), 50 , (_rangeData select 0)];
			_adjustmentY = round random [(0 - (_rangeData select 0)), 50 , (_rangeData select 0)];
			( (abs _adjustmentX > (_rangeData select 1)) || (abs _adjustmentY > (_rangeData select 1)) );
		};
		_targetPOS = ((getPOS _mortarTarget) vectorAdd [_adjustmentX, _adjustmentY, 0]);
		diag_log format ['[mortarLogic]:	Firing solution at position %1. Strike %2', _targetPOS, _strikeCounter];
		(missionNameSpace getVariable _mortarPriStr) doArtilleryFire [_targetPOS, (currentMagazine (missionNameSpace getVariable _mortarPriStr)), 1]
	} else {
		_targetPOS = (getPOS _mortarTarget);
		if ((_mortarBrackPOS distance2D _mortarTarget) <= _mortarLoiterDist) then {
			//	FIRE FOR EFFECT
			diag_log format ['[mortarLogic]:	Firing solution at position %1. Strike %2', _targetPOS, _strikeCounter];
			_barrageCounter = 0;
			waitUntil {
				_barrageCounter = _barrageCounter + 1;
				{
					_x doArtilleryFire [(_targetPOS vectorAdd [(floor random [-25, 0, 25]), (floor random [-25, 0, 25]), 0]), (currentMagazine _x), 1];
					sleep random [2, 2, 6];
				} forEach [(missionNameSpace getVariable _mortarPriStr), (missionNameSpace getVariable _mortarSecStr)];
				(_barrageCounter == 2)
			};
		};
		//	RESET THE STRIKE COUNTER AFTER FFE
		_strikeCounter = 0;
		//	FFE COOL DOWN
		uiSleep _mortarCoolDown;
	};
	_mortarBrackPOS = (getPOS _mortarTarget);
	//	TIME BETWEEN MORTAR SHOTS
	uiSleep (round random [45, 100 , 200]);
	_callForFireLoop;
};
