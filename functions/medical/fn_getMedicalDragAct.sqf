/*
	ASG_fnc_getMedicalDragAct
	by:	Diffusion9

	Enables a player to be dragged by another player.
	Administrated via the Action menu.

	EXEC TYPE:	
	INPUT:		
	OUTPUT:		
*/

params [["_ct", player]];

//	PREVENT DRAG WATCH DUPLICATION.
if (!isNil {ASGmedical_dragSpeedThread}) then {
	terminate ASGmedical_dragSpeedThread;
	missionNameSpace setVariable ["ASGmedical_dragSpeedThread", nil];
};

//	GRABBED ANIMATION.
{
	[player, "AinjPpneMrunSnonWnonDb_grab"] remoteExec ["switchMove"];
	uiSleep 0.5;
	[player, "AinjPpneMrunSnonWnonDb_still"] remoteExec ["switchMove"];
} remoteExec ["bis_fnc_call", _ct];

//	DRAGGING MOVEMENT CHECK THREAD
ASGmedical_dragSpeedThread = [_ct] spawn {
	scriptName "ASGmedical_dragSpeedThread";
	params ["_ct"];
	_attachedTo = (attachedTo _ct);
	waitUntil {
		if ((abs speed vehicle (attachedTo _ct) > 2.8) && (_ct getVariable ["ASGmedical_stateDrag", false])) then {
			if !(animationState _ct == "AinjPpneMrunSnonWnonDb") then {
				[_ct,"AinjPpneMrunSnonWnonDb"] remoteExec ["switchMove"];
				sleep 1;
			};
		} else {
			[_ct,"AinjPpneMrunSnonWnonDb_still"] remoteExec ["switchMove"];
		};
		false;
	};
};

//	EXORCISM CAMERA.
{
	dragCamera = "camera" camCreate (position player);
	dragCamera attachTo [player, [0,0,0], "Head"];
	dragCamera setDir 180;
	dragCamera switchCamera "INTERNAL";	
} remoteExec ["call", _ct];
