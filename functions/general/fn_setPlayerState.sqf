/*
	ASG_fnc_setPlayerState
	by:	Diffusion9

	Combines the cutText and simulation state changes into a single function.
	TRUE	Disable the player.
	FALSE	Enable the player.

	EXEC TYPE:	Call
	INPUT:	0	BOOL	State
			1	STRING	Text
			2	SCALAR	Fade Timer
	OUTPUT:		Nothing	
*/

params ["_state", "_text", "_fadeTimer"];

//	DEFINE THE SCREEN LAYER
_playerStateLayer = "general_pStateLayer" call BIS_fnc_rscLayer;

private ["_type"];
if _state then {
	_type = "BLACK OUT";
} else {
	_type = "BLACK IN";
};

//	MODIFY SCREEN STATE
_playerStateLayer cutText [_text,_type,_fadeTimer];

//	MODIFY SIM & VISIBILITY STATE
[player, !_state] remoteExec ["enableSimulationGlobal", 2];
[player, _state] remoteExec ["hideObjectGlobal", 2];
