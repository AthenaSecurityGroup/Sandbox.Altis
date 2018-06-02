/*
	ASG_fnc_requestPlayerDelivery
	by:	Diffusion9

	Send a logistics player delivery request to the server.
	
*/
params ["_player"];

logistics_reqPVEH = ["PDR", str _player];
publicVariableServer "logistics_reqPVEH";
