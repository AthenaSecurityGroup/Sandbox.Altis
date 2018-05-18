//	INITIALIZE THE REQUEST QUEUE
logistics_reqQueue = [[],[],[]];

//	DEFINE \\ LOAD COMPANY BANK BALANCE
profileNamespace getVariable ["logistics_bankBalance", 500000];

//	ADD THE REQUEST EVENT HANDLER
"logistics_reqPVEH" addPublicVariableEventHandler {
	params ["_pvehVar","_pvehVal"];
	_pvehVal params ["_reqType", "_reqVal"];
	logistics_reqQueue params ["_pdrQueue", "_fdrQueue", "_vdrQueue"];

	//	PROCESS THE REQUEST, ADD IT TO THE QUEUE
	switch (toUpper _reqType) do {
		//	PLAYER DELIVERY REQUEST
		case "PDR": {_pdrQueue pushbackUnique _reqVal};
		//	RESUPPLY DELIVERY REQUEST
		case "FDR": {_fdrQueue pushbackUnique _reqVal};
		//	VEHICLE DELIVERY REQUEST
		case "VDR": {_vdrQueue pushbackUnique _reqVal};
		//	DEFAULT, ERROR
		default {_debugMsg = format ["[logistics]:	reqPVEH default."]; ASG_DEBUG_LOG};
	};
};

//	QUEUE MONITOR. CHECKS THE logistics QUEUE EVERY FIVE MINUTES.
logistics_qMonitor = [] spawn {
	logistics_qMonitorLoop = false;
	waitUntil {
		waitUntil {isNil "logistics_logHelo"};
		{
			if (count _x > 0) then {
				switch (_forEachIndex) do {
					//	PLAYER DELIVERY REQUEST
					case 0: {call ASG_fnc_startPlayerDelivery};
					//	RESUPPLY DELIVERY REQUEST
					case 1: {call ASG_fnc_startFreightDelivery};
					//	VEHICLE DELIVERY REQUEST
					case 2: {call ASG_fnc_startVehicleDelivery};
					//	DEFAULT, ERROR
					default {_debugMsg = format ["[logistics]:	qMonitor default."]; ASG_DEBUG_LOG};
				};
			};
		} forEach logistics_reqQueue;
		uiSleep 10;
		logistics_qMonitorLoop
	};
};
