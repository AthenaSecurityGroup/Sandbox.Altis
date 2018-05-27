//	ASG CATALOG DEFINITION
logistics_logItems = [["hgun_Rook40_F",500],["SMG_02_F",800],["arifle_SDAR_F",1600],["arifle_SPAR_01_blk_F",800],["arifle_SPAR_01_GL_blk_F",1600],["LMG_03_F",4000],["arifle_SPAR_03_blk_F",1600],["srifle_DMR_02_F",6000],["MMG_02_black_F",6000],["launch_RPG7_F",1000],["launch_NLAW_F",5000],["launch_B_Titan_short_tna_F",50000],["launch_B_Titan_tna_F",50000],["acc_flashlight",20],["acc_pointer_IR",20],["optic_Aco",800],["optic_Hamr",1600],["optic_SOS",2400],["optic_LRPS",3200],["bipod_01_F_blk",100],["muzzle_snds_M",500],["muzzle_snds_B",500],["muzzle_snds_338_black",500],["Binocular",100],["Rangefinder",1000],["NVGoggles_OPFOR",2000],["NVGogglesB_blk_F",3000],["Medikit",100],["MineDetector",200],["ToolKit",100],["FirstAidKit",200]];
logistics_logItemsV = [["B_AssaultPack_rgr",75],["B_Kitbag_rgr",150],["APERSMine",50],["ATMine",150],["DemoCharge_F",50]];
logistics_logMags = [["10Rnd_338_Mag",300],["130Rnd_338_Mag",4000],["16Rnd_9x21_Mag",40],["30Rnd_9x21_Mag",60],["30Rnd_9x21_Mag_SMG_02",60],["20Rnd_556x45_UW_mag",60],["30Rnd_556x45_Stanag",90],["200Rnd_556x45_Box_F",600],["200Rnd_556x45_Box_Tracer_F",600],["RPG7_F",100],["NLAW_F",20000],["Titan_AA",50000],["Titan_AP",50000],["Titan_AT",50000],["SmokeShell",100],["SmokeShellRed",100],["SmokeShellOrange",100],["SmokeShellYellow",100],["SmokeShellGreen",100],["SmokeShellBlue",100],["SmokeShellPurple",100],["Chemlight_red",5],["Chemlight_yellow",5],["Chemlight_green",5],["Chemlight_blue",5],["B_IR_Grenade",200],["HandGrenade",300],["MiniGrenade",200],["1Rnd_HE_Grenade_shell",400],["1Rnd_Smoke_Grenade_shell",300],["1Rnd_SmokeRed_Grenade_shell",300],["1Rnd_SmokeOrange_Grenade_shell",300],["1Rnd_SmokeYellow_Grenade_shell",300],["1Rnd_SmokeGreen_Grenade_shell",300],["1Rnd_SmokeBlue_Grenade_shell",300],["1Rnd_SmokePurple_Grenade_shell",300],["UGL_FlareWhite_F",100],["UGL_FlareRed_F",100],["UGL_FlareYellow_F",100],["UGL_FlareGreen_F",100],["UGL_FlareCIR_F",100],["Laserbatteries",200]];

disableSerialization;

//	INITIALIZE IDCs
_display = findDisplay 8559;
_catalogIDC = _display displayctrl 1500;		//	CATALOG
_orderIDC = _display displayctrl 1510;			//	ORDER
_totalsIDC = _display displayctrl 1520;			//	INVOICE

params ["_ctrlRef"];

_ctrlRef = (_ctrlRef select 0);
_ctrlIDC = ctrlIDC _ctrlRef;

//	- BUTTON
if (_ctrlIDC in [1501, 1511]) then {
	//	CURRENT SELECTED ROW TO VARIABLE
	_curRow = lnbCurSelRow _catalogIDC;
	
	//	GET VALUES FROM THE ROW
	_catAmount = _catalogIDC lnbValue [_curRow,0];
	_catItem = _catalogIDC lnbData [_curRow,1];
	_catItemName = _catalogIDC lnbText [_curRow,1];
	
	//	GET SIZE OF THE ORDER LISTBOX.
	_lnbOrderSize = lnbSize _orderIDC;
	_lnbOrderSize params ["_lnbOrderRowNum", "_lnbOrderColNum"];
	
	//	SUBTRACT FROM AN EXISTING ITEM
	for "_x" from 0 to _lnbOrderRowNum do {
		_ordAmount = _orderIDC lnbValue [_x,0];
		_ordItem = _orderIDC lnbData [_x,1];
		_ordItemName = _orderIDC lnbText [_x,1];
		_ordRow = _x;
		if (_ordItem == _catItem) exitWith {
			_ordAmount = _ordAmount - 1;
			_orderIDC lnbDeleteRow _ordRow;
			_row = _orderIDC lnbAddRow [str _ordAmount, _ordItemName];
			_orderIDC lnbSetValue [[_row, 0], _ordAmount];
			_orderIDC lnbSetData [[_row, 1], _ordItem];
			_orderIDC lnbSetCurSelRow _row;
			
			if (_ordAmount == 0) then {
				// _orderIDC ctrlEnable false;
				_orderIDC lnbDeleteRow _ordRow;
			};
		};
	};
};
	
//	+ BUTTON
if (_ctrlIDC in [1502,1512]) then {
	//	CURRENT SELECTED ROW TO VARIABLE
	_curRow = lnbCurSelRow _catalogIDC;
	
	//	GET VALUES FROM THE ROW
	_catAmount = _catalogIDC lnbValue [_curRow,0];
	_catItem = _catalogIDC lnbData [_curRow,1];
	_catItemName = _catalogIDC lnbText [_curRow,1];
	
	//	GET SIZE OF THE ORDER LISTBOX.
	_lnbOrderSize = lnbSize _orderIDC;
	_lnbOrderSize params ["_lnbOrderRowNum", "_lnbOrderColNum"];
	
	if (_lnbOrderRowNum isEqualTo 0) then {
		_orderIDC ctrlEnable true;
	};
	
	private ["_ordItem", "_ordAmount", "_ordRow"];
	//	ADD TO AN EXISTING ITEM
	for "_x" from 0 to _lnbOrderRowNum do {
		_ordAmount = _orderIDC lnbValue [_x,0];
		_ordItem = _orderIDC lnbData [_x,1];
		_ordItemName = _orderIDC lnbText [_x,1];
		_ordRow = _x;
		if (_ordItem == _catItem) exitWith {
			_ordAmount = _ordAmount + 1;
			_orderIDC lnbDeleteRow _ordRow;
			_row = _orderIDC lnbAddRow [str _ordAmount, _ordItemName];
			_orderIDC lnbSetValue [[_row, 0], _ordAmount];
			_orderIDC lnbSetData [[_row, 1], _ordItem];
			_orderIDC lnbSetCurSelRow _row;
		};
	};
	
	if (_ordItem == _catItem) exitWith {};
	
	//	ADD NEW ITEM
	_row = _orderIDC lnbAddRow [str 1, _catItemName];
	_orderIDC lnbSetValue [[_row, 0], 1];
	_orderIDC lnbSetData [[_row, 1], _catItem];
	_orderIDC lnbSetCurSelRow _row;
};

//	SUBMIT
if (_ctrlIDC in [1503]) then {
	hint "Yes";
	//	GET SIZE OF THE ORDER LISTBOX.
	_lnbOrderSize = lnbSize _orderIDC;
	_lnbOrderSize params ["_lnbOrderRowNum", "_lnbOrderColNum"];
	if (_lnbOrderRowNum isEqualTo 0) exitWith {
		hint "There are no items in this requisition request.";
	};
	private ["_ordItem", "_ordAmount", "_ordRow", "_order"];
	
	//	GATHER EXISTING ITEMS
	_order = [];
	for "_x" from 0 to _lnbOrderRowNum do {
		_ordAmount = _orderIDC lnbValue [_x,0];
		_ordItem = _orderIDC lnbData [_x,1];
		_itemData = [_ordItem, _ordAmount];
		if !(_itemData isEqualTo ["",0]) then {
			_order pushBack _itemData;
		};
	};
	hint "Requisition order has been submitted.";
	
	//	SEND THE FREIGHT DELIVERY REQ
	logistics_reqPVEH = ["FDR", _order];
	publicVariableServer "logistics_reqPVEH";
	
	//	CLOSE THIS DIALOG
	closeDialog 2;
};

//	UPDATE THE INVOICE
//	GET SIZE OF THE ORDER LISTBOX.
_lnbOrderSize = lnbSize _orderIDC;
_lnbOrderSize params ["_lnbOrderRowNum", "_lnbOrderColNum"];

private _cost = 0;
for "_x" from 0 to _lnbOrderRowNum-1 do {
	_ordItemName = _orderIDC lnbText [_x,1];
	_ordItem = _orderIDC lnbData [_x,1];
	_ordAmount = _orderIDC lnbValue [_x,0];
	[[logistics_logItems, logistics_logItemsV, logistics_logMags], _ordItem] call BIS_fnc_findNestedElement params ["_0","_1","_2"];
	_itemCost = [logistics_logItems, logistics_logItemsV, logistics_logMags] select _0 select _1 select (_2 + 1);
	_cost = _cost + (_ordAmount * _itemCost);
};

_deliveryBaseCost = 1000;
_deliveryTotal = _cost + _deliveryBaseCost;

lbClear _totalsIDC;
_totalsIDC lbAdd format ["Order Cost:		$%1", _cost];
_totalsIDC lbAdd format ["Delivery Cost:	$%1", _deliveryBaseCost];
_totalsIDC lbAdd format ["Total: $%1", _deliveryTotal];
_totalsIDC lbAdd format ["----------------------"];
_totalsIDC lbAdd format ["Current Balance: $ 999 999"];
_totalsIDC lbAdd format ["Adjusted Balance: $ 000 000"];
