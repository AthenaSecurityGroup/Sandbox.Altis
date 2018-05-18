/*

	ASG_fnc_advProgressBar -- 2016-05-25
	by Diffusion9
	
	Utilizes End Game Revive dialog system to generate a progress bar.
	Customizable action cancelling, messages, and accompanying animation.
	
	PARAMS:
	0	SCALAR		Time (seconds) to complete the action.
	1	ARRAY[3]	Text to display in the three string slots.
					Above, Below and On Button Hold.
	2	STRING		Animation to play on the player.
	3	ARRAY[4]	Display text and conditions for cancelling the action.
					Is the action cancellable, text to display when cancelling.
					Seconds to cancel, code to execute when cancelling.
	4	BOOL		Icon presence.
	5	BOOL		Progress bar type. True for decreasing. False for increasing.
	6	BOOL		Hide actions.
	7	SCRIPT		Associated script to terminate.
*/

params [
	["_actTime", 10],
	["_actTexts", ['','','']],
	["_actAnim", 'AinvPknlMstpSnonWnonDnon_medic_1'],
	["_actCancelData", [true, 'CANCELLING', 2, {ASG_keyHoldState}]],
	["_actIcons", false],
	["_actBarMode", true],
	["_actHideActions", true],
	["_actScript", scriptNull]
];
_actTexts params [["_actTopText",''],["_actBotText",''],["_actHoldText",'']];
_actCancelData params [["_actCancelState",true],["_actCancelMsg",'CANCELLING'],["_actCancelTime",2],["_actCancelCode",{ASG_keyHoldState}]];

//	INCLUDES, SERIALIZATION, VARIABLE RESETS.
ASG_progressBar_keyHold = false;
#include "\a3\ui_f\hpp\defineresincldesign.inc"
#include "\a3\ui_f\hpp\definecommongrids.inc"
#include "\A3\ui_f\hpp\defineCommonColors.inc"
#include "\A3\ui_f\hpp\defineDIKCodes.inc"
#include "\A3\ui_f\hpp\defineResIncl.inc"
#include "\A3\ui_f\hpp\rscCommon.inc"
disableSerialization;

//	TELL CLIENTS THIS CLIENT IS BUSY
// player setVariable ["isBusy", true, true];
// missionNamespace setVariable [format ["%1_isBusy", player], true, true];

//	ANIMATION EVENTHANDLER, TO FORCE ANIMATION LOOP
_origDIR = getDir player;
player playMoveNow _actAnim;
if (_actAnim != '') then {
	animState = _actAnim;
	animDone_EH = player addEventHandler ["AnimDone",
		{
			(_this select 0) playMoveNow "amovpknlmstpsnonwnondnon";
			(_this select 0) playMove animState;
		}
	];
};

//	CREATE DISPLAYS
private ["_layer"];
_layer = "bis_revive_progress" call bis_fnc_rscLayer;
_layer cutText ["", "PLAIN"];
_layer cutRsc ["RscRevive", "PLAIN"];
waitUntil {!(isNull (uiNamespace getVariable ["bis_revive_progress_display", displayNull]))};

//	GRAB DISPLAYS
private ["_display"];
_display = uiNamespace getVariable "bis_revive_progress_display";

//	GRAB CONTROLS
private [
	"_ctrlBar",
	"_ctrlBackground",
	"_ctrlProgress",
	"_ctrlText",
	"_ctrlDeath",
	"_ctrlText2",
	"_ctrlCountdown",
	"_ctrlInfo",
	"_ctrlMedikit",
	"_ctrlMedikitProgress"
];
_ctrlBar = _display displayCtrl IDC_RSCREVIVE_REVIVEBAR;							//	Dark band across the bottom of the screen.
_ctrlBackground = _display displayCtrl IDC_RSCREVIVE_REVIVEPROGRESSBACKGROUND;		//	Background behind progress bar.
_ctrlProgress = _display displayCtrl IDC_RSCREVIVE_REVIVEPROGRESS;					//	The progress bar.
_ctrlDeath = _display displayCtrl IDC_RSCREVIVE_REVIVEDEATH;						//	"Death" icon to the left of the progress bar.
_ctrlText = _display displayCtrl IDC_RSCREVIVE_REVIVETEXT;							//	Text inside progress bar.
_ctrlText2 = _display displayCtrl IDC_RSCREVIVE_REVIVETEXT2;						//	Text inside progress bar (same as above).
_ctrlCountdown = _display displayCtrl IDC_RSCREVIVE_REVIVECOUNTDOWN;				//	Large text at top of the screen (Small area).
_ctrlInfo = _display displayCtrl IDC_RSCREVIVE_REVIVEINFO;							//	Info Text at the top of the screen.
_ctrlMedikit = _display displayCtrl IDC_RSCREVIVE_REVIVEMEDIKIT;					//	"MediKit" icon to the right of the progress bar.
_ctrlMedikitProgress = _display displayCtrl IDC_RSCREVIVE_REVIVEMEDIKITPROGRESS;	//	

//	HIDE THE 'DEATH' AND 'MEDIKIT' ICONS IF NOT MEDICAL
if (!_actIcons) then {
	{_x ctrlSetFade 1} forEach [_ctrlDeath, _ctrlMedikit];
	{_x ctrlCommit 0} forEach [_ctrlDeath, _ctrlMedikit];
};
//	DARK BAND NEAR BOTTOM OF SCREEN
_ctrlBar ctrlSetBackgroundColor [0, 0, 0, 0.25];
_ctrlBar ctrlCommit 0;

//	BACKGROUND OF PROGRESS BAR
_ctrlBackground ctrlSetBackgroundColor [0,0,0,0.5];
_ctrlBackground ctrlCommit 0;

//	PROGRESS BAR TEXT	(TOP)
private ["_string", "_parsed"];
_string = format ["<t align = 'center'>%1</t>", _actTopText];
_parsed = parseText _string;
_ctrlText ctrlSetStructuredText _parsed;
_ctrlText ctrlSetPosition [0.26,0.92,0.48,0.04];
_ctrlText ctrlCommit 0;

//	SET START AND EXPECTED FINISH TIME.
_startTime = time;
_totalTime = time + _actTime;

//	SPACE KEYHOLD TRACKER
ASG_keyHoldState = true;
if (_actCancelState) then {
	keyHoldspawn = [_actCancelMsg, _actCancelTime, _actCancelCode] spawn {
		params ["_actCancelMsg", "_actCancelTime", "_actCancelCode"];
		ASG_progressBar_keyHold = [_actCancelMsg,_actCancelTime,{[] call _actCancelCode},[]] call BIS_fnc_keyHold;
	};
};

//	CODE FOR INCREASING OR DECREASING PROGRESS BAR.
private ["_actBarCode"];
if (_actBarMode) then {
	_actBarCode = {_ctrlProgress progressSetPosition (linearConversion[ _startTime, _totalTime, time, 0, 1 ]);};
} else {
	_actBarCode = {_ctrlProgress progressSetPosition (1 - (linearConversion[ _startTime, _totalTime, time, 0, 1 ]));};
};

//	HIDE ACTIONS
if (_actHideActions) then {
	{inGameUISetEventHandler [_x,"true"]} forEach ["Action","NextAction","PrevAction"];
};

//	UPDATE STATUS BAR UNTIL DRAINED.
waitUntil {
	_ctrlProgress progressSetPosition ([] call _actBarCode);
	//	IF ANIMATED, LOCK PLAYER INTO ANIMATION DIRECTION.
	if (_actAnim != '') then {player setDir _origDIR};
	if (missionNamespace getVariable ["BIS_keyHold_active", false]) then {
		//	TEXT TO DISPLAY WHEN KEY IS HELD (BOTTOM).
		_string = format ["<t align = 'center'>%1</t>", _actHoldText];
		_parsed = parseText _string;
		_ctrlText2 ctrlSetStructuredText _parsed;
		_ctrlText2 ctrlSetPosition [0.26,1.02,0.48,0.04];
		_ctrlText2 ctrlCommit 0;
	} else {
		//	DEFAULT TEXT DISPLAYED (BOTTOM).
		_string = format ["<t align = 'center'>%1</t>", _actBotText];
		_parsed = parseText _string;
		_ctrlText2 ctrlSetStructuredText _parsed;
		_ctrlText2 ctrlSetPosition [0.26,1.02,0.48,0.04];
		_ctrlText2 ctrlCommit 0;
	};
	//	END IF DEAD, TIMER DONE, OR ON KEYHOLD EVENT.
	(!alive player) || (time >= _totalTime) || (missionNamespace getVariable ["ASG_progressBar_keyHold", false] || (player getVariable ["#MOSES#incapacitated",false]))
};
sleep 0.25;

//	KILL ELEMENTS, RESET VARIABLES
"bis_revive_progress" call bis_fnc_rscLayer cutText ["", "PLAIN"];
ASG_keyHoldState = false;

//	KILL ANIMATIONS
if (_actAnim != '' && !(player getVariable ["#MOSES#incapacitated",false])) then {
	_curAnimState = animationState player;
	player playMoveNow "amovpknlmstpsnonwnondnon";
	//	CHECK IF ANIMATION HAS NOT TRANSITIONED WITHIN 1 SEC, AND FORCE SWITCHMOVE
	uiSleep 0.5;
	if (animationState player == _curAnimState) then {
		player switchMove "amovpknlmstpsnonwnondnon";
	};
	player removeEventHandler ["AnimDone", animDone_EH];
};

//	TERMINATE THE ASSOCIATED SCRIPT ON THE SERVER
//	Needs performance alternative; simpleSerialization optimization problem.
if isNil _actScript then {} else {
	(missionNamespace getVariable _actScript) remoteExec ["terminate", 2];
};

//	RETURN ACTION CONTROL
if (_actHideActions) then {
	{inGameUISetEventHandler [_x,"false"]} forEach ["Action","NextAction","PrevAction"];
};

//	REMOVE ANIM HANDLER
player removeAllEventHandlers "AnimDone";
