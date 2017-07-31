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
	ALOC_reqPVEH = ["FDR", _order];
	publicVariableServer "ALOC_reqPVEH";
	
	//	CLOSE THIS DIALOG
	closeDialog 2;
};

//	UPDATE THE INVOICE
//	GET SIZE OF THE ORDER LISTBOX.
_lnbOrderSize = lnbSize _orderIDC;
_lnbOrderSize params ["_lnbOrderRowNum", "_lnbOrderColNum"];

private ["_cost"];
_cost = 0;
for "_x" from 0 to _lnbOrderRowNum-1 do {
	_ordItemName = _orderIDC lnbText [_x,1];
	_ordItem = _orderIDC lnbData [_x,1];
	_ordAmount = _orderIDC lnbValue [_x,0];
	[[ALOC_logItems, ALOC_logItemsV, ALOC_logMags], _ordItem] call BIS_fnc_findNestedElement params ["_0","_1","_2"];
	_itemCost = [ALOC_logItems, ALOC_logItemsV, ALOC_logMags] select _0 select _1 select (_2 + 1);
	_cost = _cost + (_ordAmount * _itemCost);
};

lbClear _totalsIDC;
_totalsIDC lbAdd format ["Order Cost: $ %1", _cost];
_totalsIDC lbAdd format ["Delivery Cost: $%1", "FakeNumber"];
_totalsIDC lbAdd format ["Total: $%1", "Every Dollars"];
_totalsIDC lbAdd format ["----------------------"];
_totalsIDC lbAdd format ["Current Balance: $ 999 999"];
_totalsIDC lbAdd format ["Adjusted Balance: $ 000 000"];
