/*
	ASG_fnc_setACOMstate
	by:	Diffusion9

	Initializes the core of the Athena Combat Medical module.
	Defines bleedout and UI calls, and all core medical elements.

	EXEC TYPE:	
	INPUT:		
	OUTPUT:		
*/

if (_this isEqualType true) then {_this = [_this]};
params [["_incapState",!(player getVariable ["ASGmedical_stateIncap",false]),[false]],["_incapTimer",180,[0]]];
player setVariable ["ASGmedical_stateIncap",_incapState,true];
player setCaptive _incapState;

//	CORE VALUES
ASGmedical_incapTimer = _incapTimer;

//	DEFINES FROM \a3\ui_f\hpp\defineresincldesign.inc FOR RSCREVIVE.
// #include "\a3\ui_f\hpp\defineCommonGrids.inc"
#define IDC_RSCREVIVE_REVIVEPROGRESSBACKGROUND	4817
#define IDC_RSCREVIVE_REVIVEPROGRESS			4818
#define IDC_RSCREVIVE_REVIVEKEYPROGRESS			4819
#define IDC_RSCREVIVE_REVIVEBAR					4820
#define IDC_RSCREVIVE_REVIVETEXT				4917
#define IDC_RSCREVIVE_REVIVECOUNTDOWN			4918
#define IDC_RSCREVIVE_REVIVEINFO				4919
#define IDC_RSCREVIVE_REVIVEKEYBACKGROUND		4920
#define IDC_RSCREVIVE_REVIVEKEY					4921
#define IDC_RSCREVIVE_REVIVEMEDIKIT				5017
#define IDC_RSCREVIVE_REVIVEMEDIKITPROGRESS		5018
#define IDC_RSCREVIVE_REVIVEDEATH				5019
#define IDC_RSCREVIVE_REVIVERESPAWN				6117
#define IDC_RSCREVIVE_REVIVETEXT2				6118

//	PREVENT DUPLICATION.
terminate (missionNamespace getVariable "ASGmedical_bleedoutThread");
(missionNamespace setVariable ["ASGmedical_bleedoutThread", nil]);

//	INCAPACITATING OR RESUSCITATING.
if _incapState then {
	ASGmedical_incapState = _incapState;

	//	SPAWN THE BLEEDOUT THREAD.
	missionNameSpace setVariable ["ASGmedical_bleedoutThread", [] spawn {
	
		disableSerialization;
		
		//	SET THE INITIAL INCAPACITATION STATES.
		player setVariable ["ASGmedical_stateIncap", ASGmedical_incapState, true];
		player setVariable ["ASGmedical_stateRagdoll", ASGmedical_incapState, true];
		player setCaptive ASGmedical_incapState;
		player allowDamage !(ASGmedical_incapState);
		player setUnconscious ASGmedical_incapState;

		//	INCAPACITATE THE PLAYER.
		if (vehicle player == player) then [{
			//	IF THE PLAYER IS NOT IN A VEHICLE.
			player spawn {
				scriptName "ASG Medical: Ragdoll";
				uiSleep 7;
				player setVariable ["ASGmedical_stateRagdoll", false, true];
			};
		},{
			//	IF THE PLAYER IS IN A VEHICLE, AND IS CARGO
			private _assignedRole = assignedVehicleRole player select 0;
			if (_assignedRole == "cargo") then {
				player playActionNow "Die";
			};
		}];

		//	DISABLE COLLISION
		{
			{
				player disableCollisionWith _x
			} forEach allPlayers
		} remoteExec ["call"];

		//	GENERATE THE POST-PROCESSING EFFECTS FOR BLEEDOUT
		ASGmedical_ppColor = ppEffectCreate ["ColorCorrections",1632];
		ASGmedical_ppVig = ppEffectCreate ["ColorCorrections",1633];
		ASGmedical_ppBlur = ppEffectCreate ["DynamicBlur",525];
		ASGmedical_ppColor ppEffectAdjust [1,1,0.15,[0.3,0.3,0.3,0],[0.3,0.3,0.3,0.3],[1,1,1,1]];
		ASGmedical_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[1,1,0,0,0,0.2,1]];
		ASGmedical_ppBlur ppEffectAdjust [0];
		{_x ppEffectCommit 0; _x ppEffectEnable true; _x ppEffectForceInNVG true} forEach [ASGmedical_ppColor,ASGmedical_ppVig,ASGmedical_ppBlur];

		//	SET THE BLEEDOUT TIMER.
		timeToKill = time + ASGmedical_incapTimer;
		startTime = time;

		//	DEFINE MEDICAL LAYER NAME.
		private ["_layer"];
		_layer = "ASGmedical_bleedoutLayer" call BIS_fnc_rscLayer;

		//	ACTIVATE RSCREVIVE.
		_layer cutRsc ["RscRevive","PLAIN"];

		//	GET THE MAIN AND REVIVE DISPLAYS.
		private ["_reviveDisplay", "_mainDisplay"];
		waitUntil {
			_reviveDisplay = uiNamespace getVariable "bis_revive_progress_display";
			_mainDisplay = [] call bis_fnc_displayMission;
			!(isNull _reviveDisplay) && !(isNull _mainDisplay)
		};

		//	GET UI ELEMENT REFERENCES.
		_ctrlProgress = _reviveDisplay displayCtrl IDC_RSCREVIVE_REVIVEPROGRESS;
		_ctrlBackground = _reviveDisplay displayCtrl IDC_RSCREVIVE_REVIVEPROGRESSBACKGROUND;
		_ctrlText = _reviveDisplay displayCtrl IDC_RSCREVIVE_REVIVETEXT;
		_ctrlText2 = _reviveDisplay displayCtrl IDC_RSCREVIVE_REVIVETEXT2;

		//	DEFINE MEDICAL TEXTS.
		_actTopText = "YOU ARE BLEEDING OUT";
		_actBotText = "AWAITING MEDICAL ATTENTION";

		//	DEFINITIONS FOR TEXT ABOVE THE BLEEDOUT BAR.
		private ["_string", "_parsed"];
		_string = format ["<t align = 'center'>%1</t>", _actTopText];
		_parsed = parseText _string;
		_ctrlText ctrlSetStructuredText _parsed;
		_ctrlText ctrlSetPosition [0.26,1.12491,0.48,0.04];
		_ctrlText ctrlCommit 0;

		//	DEFINITIONS FOR TEXT BELOW THE BLEEDOUT BAR.
		_string = format ["<t align = 'center'>%1</t>", _actBotText];
		_parsed = parseText _string;
		_ctrlText2 ctrlSetStructuredText _parsed;
		_ctrlText2 ctrlSetPosition [0.26,1.21121,0.48,0.04];
		_ctrlText2 ctrlCommit 0;

		//	DARK BACKGROUND OF PROGRESS BAR.
		_ctrlBackground ctrlSetBackgroundColor [0,0,0,0.5];
		_ctrlBackground ctrlCommit 0;

		//	ENABLE ACTION RESTRICTIONS
		_keyDownEH = _mainDisplay displayAddEventHandler
		[
			"KeyDown", {
				private["_key","_keys"];
				_key = _this select 1;
				if (true) then {
					_keys = [];
					{
						_keys append actionKeys _x;
					} forEach ["Throw","DeployWeaponManual","DeployWeaponAuto", "CommandingMenu0", "SelectAll", "SelectGroupUnit1", "SelectGroupUnit2", "SelectGroupUnit3", "SelectGroupUnit4", "SelectGroupUnit5", "SelectGroupUnit6", "SelectGroupUnit7", "SelectGroupUnit8", "SelectGroupUnit9", "SelectGroupUnit0", "NavigateMenu", "Gear"];
					if (_key in _keys) then {true} else {false};
				} else {
					false
				};		
			}
		];
		missionNamespace setVariable ["ASGmedical_keyDownEH", _keyDownEH];

		//	DISABLE THE ACTION MENU;
		{inGameUISetEventHandler [_x,"true"]} forEach ["Action","NextAction","PrevAction"];

		//	BLEEDOUT.
		waitUntil {
		
			//	BLEEDOUT BAR PROGRESS UPDATE
			_ctrlProgress progressSetPosition (1 - ( linearConversion [startTime, timeToKill, time, 0, 1 ]));
			
			//	POST PROCESSING EFFECTS UPDATE
			timePercentageElapsed = 1 / ASGmedical_incapTimer * (timeToKill - time);
			_brightness = 0.2 + (0.1 * timePercentageElapsed);
			ASGmedical_ppColor ppEffectAdjust [1,1, 0.15 * timePercentageElapsed,[0.3,0.3,0.3,0],[_brightness,_brightness,_brightness,_brightness],[1,1,1,1]];
			_intensity = 0.6 + (0.4 * timePercentageElapsed);
			ASGmedical_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[_intensity,_intensity,0,0,0,0.2,1]];
			ASGmedical_ppBlur ppEffectAdjust [0.7 * (1 - timePercentageElapsed)];
			{_x ppEffectCommit 0} forEach [ASGmedical_ppColor,ASGmedical_ppVig,ASGmedical_ppBlur];
			
			//	BLEEDING EFFECT
			player setBleedingRemaining (1 - ( linearConversion [startTime, timeToKill, time, 0, 1 ]));
			
			//	BLINK-OUT WHEN DEAD.
			if (time >= timeToKill) exitWith {
				moveOut player;
				if (!isNil {ASGmedical_exitVehicle}) then {
					terminate ASGmedical_exitVehicle;
					missionNameSpace setVariable ["ASGmedical_exitVehicle", nil];
				};
				_text = "";
				_layer cutText [_text,"BLACK",0.5];
				sleep 1;
				_layer cutText [_text,"BLACK IN",1];
				sleep 2.5;
				_layer cutText [_text,"BLACK",1];
				sleep 2;
				_layer cutText [_text,"BLACK IN",1];
				sleep 2;
				_layer cutText [_text,"BLACK",3];
				sleep 2;
				ASGmedical_incapState = nil;
				player setDamage 1;
				uiSleep 2;

				//	REMOVE THE INCAPACITATION STATES.
				ASGmedical_incapState = false;
				player setVariable ["ASGmedical_stateIncap", ASGmedical_incapState, true];
				player setVariable ["ASGmedical_stateRagdoll", ASGmedical_incapState, true];
				player setCaptive ASGmedical_incapState;
				player allowDamage !(ASGmedical_incapState);
				player setUnconscious false;
				
				//	SETUNCONSCIOUS FIX
				//		As of 2016-08-10 setUnconscious does not work properly with unarmed players.
				//		This forces unarmed players to prone after revive.
				if ((weapons player) isEqualTo []) then {
					player switchMove "amovppnemstpsnonwnondnon";
				};

				//	HIDE THE BLEEDOUT UI.
				_layer cutText ["", "PLAIN"];
				
				//	DISABLE PP EFFECTS IF ACTIVE.
				if (!isNil {ASGmedical_ppColor}) then {
					{_x ppEffectEnable false} forEach [ASGmedical_ppColor, ASGmedical_ppVig, ASGmedical_ppBlur];
				};

				//	DISABLE ACTION RESTRICTIONS
				_index = missionNamespace getVariable ["ASGMedical_keyDownEH", -1];
				if (_index != -1) then {
					_mainDisplay displayRemoveEventHandler ["KeyDown", _index];
					missionNamespace setVariable ["ASGMedical_keyDownEH", nil];
				};

				//	ENABLE THE ACTION MENU
				{inGameUISetEventHandler [_x,"false"]} forEach ["Action","NextAction","PrevAction"];

				//	RE-ENABLE THE HUD.
				showHUD [true,true,true,true,true,true,false,true];

				//	ENABLE COLLISION
				{
					{
						player enableCollisionWith _x
					} forEach allPlayers
				} remoteExec ["call"];

				//	TERMINATE THE BLEEDOUT THREAD.
				terminate (missionNamespace getVariable "ASGmedical_bleedoutThread");
				(missionNamespace setVariable ["ASGmedical_bleedoutThread", nil]);
				uiNamespace SetVariable ["bis_revive_progress_display", nil];
				(time >= timeToKill)
			};
		};
	}];
} else {

	//	PREVENT DUPLICATION.
	terminate (missionNamespace getVariable "ASGmedical_reviveThread");
	(missionNamespace setVariable ["ASGmedical_reviveThread", nil]);

	missionNameSpace setVariable ["ASGmedical_reviveThread", [] spawn {
		disableSerialization;
		
		//	DEFINE MEDICAL LAYER NAME.
		private ["_layer"];
		_layer = "ASGmedical_bleedoutLayer";

		//	GET THE MAIN AND REVIVE DISPLAYS.
		private ["_reviveDisplay", "_mainDisplay"];
		waitUntil {
			_reviveDisplay = uiNamespace getVariable "bis_revive_progress_display";
			_mainDisplay = [] call bis_fnc_displayMission;
			!(isNull _mainDisplay)
		};
		
		//	REMOVE THE INCAPACITATION STATES.
		ASGmedical_incapState = false;
		player setVariable ["ASGmedical_stateIncap", ASGmedical_incapState, true];
		player setVariable ["ASGmedical_stateRagdoll", ASGmedical_incapState, true];
		player setCaptive ASGmedical_incapState;
		player allowDamage !(ASGmedical_incapState);
		player setUnconscious false;
		
		//	SETUNCONSCIOUS FIX
		//		As of 2016-08-10 setUnconscious does not work properly with unarmed players.
		//		This forces unarmed players to prone after revive.
		if ((weapons player) isEqualTo []) then {
			player switchMove "amovppnemstpsnonwnondnon";
		};

		//	HIDE THE BLEEDOUT UI.
		_layer cutText ["", "PLAIN"];
		
		//	DISABLE PP EFFECTS IF ACTIVE.
		if (!isNil {ASGmedical_ppColor}) then {
			{_x ppEffectEnable false} forEach [ASGmedical_ppColor, ASGmedical_ppVig, ASGmedical_ppBlur];
		};

		//	DISABLE ACTION RESTRICTIONS
		_index = missionNamespace getVariable ["ASGMedical_keyDownEH", -1];
		if (_index != -1) then {
			_mainDisplay displayRemoveEventHandler ["KeyDown", _index];
			missionNamespace setVariable ["ASGMedical_keyDownEH", nil];
		};

		//	ENABLE THE ACTION MENU
		{inGameUISetEventHandler [_x,"false"]} forEach ["Action","NextAction","PrevAction"];

		//	RE-ENABLE THE HUD.
		showHUD [true,true,true,true,true,true,false,true];

		//	ENABLE COLLISION
		{
			{
				player enableCollisionWith _x
			} forEach allPlayers
		} remoteExec ["call"];

		//	TERMINATE THE BLEEDOUT THREAD.
		terminate (missionNamespace getVariable "ASGmedical_bleedoutThread");
		(missionNamespace setVariable ["ASGmedical_bleedoutThread", nil]);
	}];
};
