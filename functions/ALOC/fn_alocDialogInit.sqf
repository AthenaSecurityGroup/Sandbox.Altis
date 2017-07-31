#include "..\..\includes\ui\uiCommon.inc"

//	INITIALIZE IDCs
_display = _this select 0;
_catalogIDC = _display displayctrl 1500;		//	CATALOG
_invoiceIDC = _display displayctrl 1510;		//	ORDER
_totalsIDC = _display displayctrl 1520;			//	INVOICE
_catalogHeaderIDC = _display displayCtrl 1530;	//	HEADER - CATALOG
_invoiceHeaderIDC = _display displayCtrl 1540;	//	HEADER - ORDER
_totalsHeaderIDC = _display displayCtrl 1550;	//	HEADER - INVOICE

//	CATALOG COLUMN HEADERS
_catalogHeaderIDC lnbAddRow ["COST", "DESCRIPTION"];

//	POPULATE THE CATALOG
private ["_rowCount"];
_rowCount = -1;
{
	_typeIndex = _forEachIndex;
	{
		_x params ["_item","_cost"];
		private ["_type"];
		switch (_typeIndex) do {
			case 0: {
				_type = "cfgWeapons";
			};
			case 1: {
				_type = "cfgVehicles";
			};
			case 2: {
				_type = "cfgMagazines";
			};
			default {};
		};
		_rowCount = _rowCount + 1;
		_itemName = gettext (configfile >> _type >> _item >> "displayName");
		_row = _catalogIDC lnbAddRow [str _cost, _itemName];
		_catalogIDC lnbSetValue [[_rowCount, 0], _cost];
		_catalogIDC lnbSetData [[_rowCount, 1], _item];
	} forEach _x;
} forEach [ALOC_logItems, ALOC_logItemsV, ALOC_logMags];
_catalogIDC lnbSetCurSelRow 0;

//	INVOICE COLUMN HEADERS
_invoiceHeaderIDC lnbAddRow ["AMOUNT", "DESCRIPTION"];

_invoiceIDC ctrlEnable false;
//	INVOICE
{
	_invoiceIDC lnbAddRow [str (_x select 1),_x select 0];
} forEach [];
_invoiceIDC lnbSetCurSelRow 0;

_totalsIDC ctrlEnable false;
_catalogHeaderIDC ctrlEnable false;
_invoiceHeaderIDC ctrlEnable false;
_totalsHeaderIDC ctrlEnable false;
