/*
	ASG_fnc_ACOMgetDrop
	by:	Diffusion9

	Enables a player to get dropped by another played
	Administrated via the Action menu.

	EXEC TYPE:	
	INPUT:		
	OUTPUT:		
*/

params [["_ct", player]];
//	RELEASE ANIMATION.
_ct setVariable ["ASGmedical_stateDrag", false, true];
{
	[player, "AinjPpneMrunSnonWnonDb_release"] remoteExec ["switchMove"];
	player setUnconscious false;
	uiSleep 0.1;
	player setUnconscious true;
} remoteExec ["bis_fnc_call", _ct];

//	KILL THE DRAG WATCHER.
if (!isNil {ASGmedical_dragSpeedThread}) then {
	terminate ASGmedical_dragSpeedThread;
	missionNameSpace setVariable ["ASGmedical_dragSpeedThread", nil];
};

//	KILL THE EXCORCISM CAMERA.
{
	camDestroy dragCamera;
	player switchCamera "INTERNAL";
} remoteExecCall ["call", _ct];
