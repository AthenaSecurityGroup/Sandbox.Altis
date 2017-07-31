/*
	ASG_fnc_initAASWmodule
	by:	Diffusion9

	Initializes the core elements of the Asymmetric Warfare Module on Client and Server.
*/

//	FOR DEDICATED SERVER, OR PLAYER HOST.
if (isServer) then {call ASG_fnc_initAASWlpServer};

//	FOR CLIENTS
if (hasInterface) then {call ASG_fnc_initAASWlpClient};
