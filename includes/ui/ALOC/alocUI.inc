
//	ATHENA LOGISTICS CONTROL SYSTEM DIALOG
class ALC_dialog {
	idd = 8559;
	enableSimulation = true;
	enableDisplay = true;

	onLoad = "call ASG_fnc_alocDialogInit;";
	
	class controlsBackground {};
	class controls {
		//	PARENT CLASSES
		class ALC_iGUIBack_parent {
			type = 0;
			idc = -1;
			style = 128;
			text = "";
			colorText[] = {
				0,
				0,
				0,
				0
			};
			font = "PuristaMedium";
			sizeEx = 0;
			shadow = 0;
			x = 0.1;
			y = 0.1;
			w = 0.1;
			h = 0.1;
			colorbackground[] = {
				"(profilenamespace getvariable ['IGUI_BCG_RGB_R',0])",
				"(profilenamespace getvariable ['IGUI_BCG_RGB_G',1])",
				"(profilenamespace getvariable ['IGUI_BCG_RGB_B',1])",
				"(profilenamespace getvariable ['IGUI_BCG_RGB_A',0.8])"
			};
		};
		class ALC_rscText_parent {
			deletable = 0;
			fade = 0;
			access = 0;
			type = CT_STATIC;
			idc = -1;
			colorBackground[] = {
				0,
				0,
				0,
				0
			};
			colorText[] = {
				1,
				1,
				1,
				1
			};
			text = "";
			fixedWidth = 0;
			
			x = 0;
			y = 0;
			h = 0.037;
			w = 0.3;
			
			style = ST_LEFT;
			shadow = 1;
			colorShadow[] = {
				0,
				0,
				0,
				0.5
			};
			font = "PuristaMedium";
			SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			linespacing = 1;
			tooltipColorText[] = {
				1,
				1,
				1,
				1
			};
			tooltipColorBox[] = {
				1,
				1,
				1,
				1
			};
			tooltipColorShade[] = {
				0,
				0,
				0,
				0.65
			};
		};
		class ALC_rscListNBox_parent {
			access = 0; // Control access (0 - ReadAndWrite, 1 - ReadAndCreate, 2 - ReadOnly, 3 - ReadOnlyVerified)
			idc = -1;
			type = CT_LISTNBOX; // Type
			style = ST_LEFT + LB_TEXTURES; // Style
			default = 0; // Control selected by default (only one within a display can be used)
			blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.

			x = 29 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X; // Horizontal coordinates
			y = 15 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y; // Vertical coordinates
			w = 10 * GUI_GRID_CENTER_W; // Width
			h = 3 * GUI_GRID_CENTER_H; // Height

			colorSelectBackground[] = {1,0.5,0,1}; // Selected item fill color
			colorSelectBackground2[] = {0,0,0,1}; // Selected item fill color (oscillates between this and colorSelectBackground)

			sizeEx = GUI_GRID_CENTER_H; // Text size
			font = GUI_FONT_NORMAL; // Font from CfgFontFamilies
			shadow = 0; // Shadow (0 - none, 1 - directional, color affected by colorShadow, 2 - black outline)
			colorText[] = {1,1,1,1}; // Text and frame color
			colorDisabled[] = {1,1,1,0.5}; // Disabled text color
			colorSelect[] = {1,1,1,1}; // Text selection color
			colorSelect2[] = {1,1,1,1}; // Text selection color (oscillates between this and colorSelect)
			colorShadow[] = {0,0,0,0.5}; // Text shadow color (used only when shadow is 1)

			tooltip = ""; // Tooltip text
			tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
			tooltipColorText[] = {1,1,1,1}; // Tooltip text color
			tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color

			columns[] = {0.1,0.4}; // Horizontal coordinates of columns (relative to list width, in range from 0 to 1)

			drawSideArrows = 0;	// 1 to draw buttons linked by idcLeft and idcRight on both sides of selected line. They are resized to line height
			idcLeft = -1;		// Left button IDC
			idcRight = -1;	// Right button IDC

			period = 1; // Oscillation time between colorSelect/colorSelectBackground2 and colorSelect2/colorSelectBackground when selected

			rowHeight = GUI_GRID_CENTER_H; // Row height
			maxHistoryDelay = 1; // Time since last keyboard type search to reset it

			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1}; // Sound played when an item is selected

			// Scrollbar configuration (applied only when LB_TEXTURES style is used)
			class ListScrollBar {
				width = 0; // Unknown?
				height = 0; // Unknown?
				scrollSpeed = 0.01; // Unknown?

				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)

				color[] = {1,1,1,1}; // Scrollbar color
			};
		};
		class ALC_rscListBox_parent {
			access = 0; // Control access (0 - ReadAndWrite, 1 - ReadAndCreate, 2 - ReadOnly, 3 - ReadOnlyVerified)
			idc = -1; // Control identification (without it, the control won't be displayed)
			type = CT_LISTBOX; // Type
			style = ST_LEFT + LB_TEXTURES; // Style
			default = 0; // Control selected by default (only one within a display can be used)
			blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.

			x = 1 * GUI_GRID_CENTER_W + GUI_GRID_CENTER_X; // Horizontal coordinates
			y = 11 * GUI_GRID_CENTER_H + GUI_GRID_CENTER_Y; // Vertical coordinates
			w = 10 * GUI_GRID_CENTER_W; // Width
			h = 3 * GUI_GRID_CENTER_H; // Height

			// colorBackground[] = {0.2,0.2,0.2,1}; // Fill color
			colorSelectBackground[] = {1,0.5,0,1}; // Selected item fill color
			colorSelectBackground2[] = {0,0,0,1}; // Selected item fill color (oscillates between this and colorSelectBackground)

			sizeEx = GUI_GRID_CENTER_H; // Text size
			font = GUI_FONT_NORMAL; // Font from CfgFontFamilies
			shadow = 0; // Shadow (0 - none, 1 - directional, color affected by colorShadow, 2 - black outline)
			colorText[] = {1,1,1,1}; // Text and frame color
			colorDisabled[] = {1,1,1,1}; // Disabled text color
			colorSelect[] = {1,1,1,1}; // Text selection color
			colorSelect2[] = {1,1,1,1}; // Text selection color (oscillates between this and colorSelect)
			colorShadow[] = {0,0,0,0.5}; // Text shadow color (used only when shadow is 1)

			pictureColor[] = {1,0.5,0,1}; // Picture color
			pictureColorSelect[] = {1,1,1,1}; // Selected picture color
			pictureColorDisabled[] = {1,1,1,0.5}; // Disabled picture color

			// tooltip = "CT_LISTBOX"; // Tooltip text
			tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
			tooltipColorText[] = {1,1,1,1}; // Tooltip text color
			tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color

			period = 1; // Oscillation time between colorSelect/colorSelectBackground2 and colorSelect2/colorSelectBackground when selected

			rowHeight = GUI_GRID_CENTER_H; // Row height
			itemSpacing = 0; // Height of empty space between items
			maxHistoryDelay = 1; // Time since last keyboard type search to reset it
			canDrag = 1; // 1 (true) to allow item dragging

			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1}; // Sound played when an item is selected

			// Scrollbar configuration (applied only when LB_TEXTURES style is used)
			class ListScrollBar {
				width = 0; // Unknown?
				height = 0; // Unknown?
				scrollSpeed = 0.01; // Unknown?

				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)

				color[] = {1,1,1,1}; // Scrollbar color
			};			
		};	
		
		//	BACKGROUNDS IGUIs
		class ALC_iGUIBack_main: ALC_iGUIBack_parent {
			idc = 2200;
			type = 0;
			x = 0.250695 * safezoneW + safezoneX;
			y = 0.177967 * safezoneH + safezoneY;
			w = 0.498611 * safezoneW;
			h = 0.644066 * safezoneH;
		};
		class ALC_iGUIBack_catalog: ALC_iGUIBack_parent {
			idc = 2201;
			type = 0;
			x = 0.263816 * safezoneW + safezoneX;
			y = 0.20597 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.58806 * safezoneH;
		};
		class ALC_iGUIBack_order: ALC_iGUIBack_parent {
			idc = 2202;
			type = 0;
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.20597 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.308032 * safezoneH;
		};
		class ALC_iGUIBack_invoice: ALC_iGUIBack_parent {
			idc = 2203;
			type = 0;
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.556005 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.19602 * safezoneH;
		};
		
		//	BUTTONS
		class ALC_rscButtonMenuOK_submit {
			access = 0;
			idc = 1503;
			type = CT_SHORTCUTBUTTON;
			style = ST_LEFT;
			default = 0;
			blinkingPeriod = 0;
			text = "Submit";
			
			x = 0.631214 * safezoneW + safezoneX;
			y = 0.766027 * safezoneH + safezoneY;
			w = 0.104971 * safezoneW;
			h = 0.0280029 * safezoneH;
			
			colorBackground[] = {0.2,0.2,0.2,1};
			colorBackground2[] = {0,0,0,1};
			colorBackgroundFocused[] = {1,0.5,0,1};
			colorBackgroundActive[] = {0,0,0,1};

			size = GUI_GRID_CENTER_H;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
			font = GUI_FONT_NORMAL;
			shadow = 1; // Shadow (0 - none, 1 - directional, color cannot be changed, 2 - black outline)
			color[] = {1,1,1,1}; // Text color
			color2[] = {1,1,1,1}; // Selected fill color
			colorFocused[] = {1,1,1,1}; // Selected text color (oscillates between this and color2)
			colorDisabled[] = {1,1,1,0.5}; // Disabled text color
			
			animTextureNormal = "#(argb,8,8,3)color(1,1,1,1)"; // Background texture
			animTextureOver = "#(argb,8,8,3)color(1,1,1,1)"; // Mouse over background texture
			animTexturePressed = "#(argb,8,8,3)color(1,1,1,1)"; // Mouse pressed background texture
			animTextureFocused = "#(argb,8,8,3)color(1,1,1,1)"; // Focused background texture
			animTextureDisabled = "#(argb,8,8,3)color(1,1,1,1)"; // Disabled background texture
			animTextureDefault = "#(argb,8,8,3)color(1,1,1,1)"; // Unknown?

			tooltip = "Submit the requisition order."; // Tooltip text
			tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
			tooltipColorText[] = {1,1,1,1}; // Tooltip text color
			tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color

			period = 1; // Oscillation time between color2/colorBackground2 and colorFocused/colorBackgroundFocused when selected
			periodFocus = 1; // Oscillation time between color2/colorBackground2 and colorFocused/colorBackgroundFocused when focused
			periodOver = 0.5; // Oscillation time between color2/colorBackground2 and colorFocused/colorBackgroundFocused during mouse hover

			shortcuts[] = {KEY_XBOX_A}; // DIK codes of keyoboard shortcuts
			// textureNoShortcut = "";
			textureNoShortcut = "#(argb,8,8,3)color(0.28,0.98,0,0.4)"; // Icon displayed on ShortcutPos position when no shortcut key is found
			
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1}; // Sound played after control is activated in format {file, volume, pitch}
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1}; // Sound played when mouse cursor enters the control
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1}; // Sound played when the control is pushed down
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1}; // Sound played when the control is released after pushing down

			class Attributes {
				align = "left"; // Text align
				color = "#ffffff"; // Text color
				font = GUI_FONT_NORMAL; // Font from CfgFontFamilies
				shadow = 0; // Shadow (0 - none, 1 - directional, color affected by colorShadow, 2 - black outline)
			};
			class HitZone {
				left = 0; // Left border
				top = 0; // Top border
				right = 0; // Right border
				bottom = 0; // Bottom border
			};
			class TextPos {
				left = GUI_GRID_CENTER_W; // Left border
				top = 0; // Top border
				right = 0; // Right border
				bottom = 0; // Bottom border
			};
			class ShortcutPos {
				left = 0; // Horizontal coordinates
				top = 0; // Horizontal coordinates
				w = GUI_GRID_CENTER_W; // Width
				h = GUI_GRID_CENTER_H; // Height
			};
			class LineMarker {
				lineWidthThin=0.0080000004;
				lineWidthThick=0.014;
				lineDistanceMin=2.9999999e-005;
				lineLengthMin=5;
			};
			onButtonClick = "[_this] call ASG_fnc_alocProcUI; false";			
		};
		class ALC_rscButtonMenuOK_cancel: ALC_rscButtonMenuOK_Submit {
			text = "Cancel";
			// idc = 1504;
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.766027 * safezoneH + safezoneY;
			w = 0.104971 * safezoneW;
			h = 0.0280029 * safezoneH;
			
			shortcuts[] = {KEY_XBOX_B}; // DIK codes of keyoboard shortcuts
			textureNoShortcut = "#(argb,8,8,3)color(0.88,0.05,0,0.6)";
			
			tooltip = "Cancel this order.";
			onButtonClick = "closeDialog 2";
		};
		
		//	TEXT TITLES
		class ALC_rscText_catalog: ALC_rscText_parent {
			idc = 1000;
			text = "CATALOG"; 
			x = 0.263816 * safezoneW + safezoneX;
			y = 0.177967 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.0280029 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
		};
		class ALC_rscText_order: ALC_rscText_parent {
			idc = 1001;
			text = "ORDER"; 
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.177967 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.0280029 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
		};
		class ALC_rscText_invoice: ALC_rscText_parent {
			idc = 1002;
			text = "INVOICE"; 
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.528003 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.0280029 * safezoneH;
			sizeEx = 1 * GUI_GRID_H;
		};
		class ALC_rscText_title: ALC_rscText_parent {
			idc = 1003;
			text = "Athena Procurement System"; 
			sizeEx = 2 * GUI_GRID_H;
			style = ST_CENTER;
			
			x = 0.250695 * safezoneW + safezoneX;
			y = 0.135963 * safezoneH + safezoneY;
			w = 0.498611 * safezoneW;
			h = 0.0420043 * safezoneH;
		};
		
		//	CATALOG LIST BOX
		class ALC_rscListNBox_catalog: ALC_rscListNBox_parent {
			idc = 1500;
			drawSideArrows = 1;
			idcLeft = 1501;
			idcRight = 1502;
			sizeEx = GUI_GRID_CENTER_H / 1.25;
			columns[] = {0.06,0.25};
			
			x = 0.263816 * safezoneW + safezoneX;
			y = 0.247972 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.546056 * safezoneH;
		};
		class ALC_rscListNboxL_catalog {
			access = 0;	//	0-R/W 1-R/C 2-R/O 3-R/OV
			idc = 1501;
			type = CT_BUTTON; // Type
			style = ST_CENTER; // Style
			default = 1; // Control selected by default (only one within a display can be used)
			blinkingPeriod = 0; // Time in which control will fade out and back in. Use 0 to disable the effect.
			
			x = 0; // Horizontal coordinates
			y = 0; // Vertical coordinates
			w = 0; // Width
			h = 0; // Height

			colorBackground[] = {0.2,0.2,0.2,1}; // Fill color
			colorBackgroundDisabled[] = {0,0,0,0.5}; // Disabled fill color
			colorBackgroundActive[] = {0,0,0,1}; // Mouse hover fill color
			colorFocused[] = {1,0.5,0,1}; // Selected fill color (oscillates between this and colorBackground)

			text = "-";	//	TEXT
			sizeEx = GUI_GRID_CENTER_H; // Text size
			font = GUI_FONT_NORMAL; // Font from CfgFontFamilies
			shadow = 1; // Shadow (0 - none, 1 - N/A, 2 - black outline)
			colorText[] = {1,1,1,1}; // Text color
			colorDisabled[] = {1,1,1,0.5}; // Disabled text color

			tooltip = ""; // Tooltip text
			tooltipColorShade[] = {0,0,0,1}; // Tooltip background color
			tooltipColorText[] = {1,1,1,1}; // Tooltip text color
			tooltipColorBox[] = {1,1,1,1}; // Tooltip frame color

			borderSize = 0; // Left color width (border is a stripe of the control height on the left side)
			colorBorder[] = {1,1,1,1}; // Left border color

			colorShadow[] = {0,0,0,0};
			offsetX = 0.0075; // Horizontal background frame offset
			offsetY = 0.01; // Vertical background frame offset
			offsetPressedX = 0.0075; // Horizontal background offset when pressed
			offsetPressedY = 0.01; // Horizontal background offset when pressed

			period = 1; // Oscillation time between colorBackground and colorFocused when selected
			periodFocus = 2; // Unknown?
			periodOver = 0.5; // Unknown?

			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1}; // Sound played after control is activated in format {file, volume, pitch}
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1}; // Sound played when mouse cursor enters the control
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1}; // Sound played when the control is pushed down
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1}; // Sound played when the control is released after pushing down
			
			onButtonClick = "[_this] call ASG_fnc_alocProcUI; false";
		};
		class ALC_rscListNboxR_catalog : ALC_rscListNboxL_catalog {
			idc = 1502;
			text = "+";
		};		
		
		//	ORDER LIST BOX
		class ALC_rscListNBox_order: ALC_rscListNBox_parent {
			idc = 1510;
			drawSideArrows = 0;
			// idcLeft = 1511;
			// idcRight = 1512;
			sizeEx = GUI_GRID_CENTER_H / 1.25;
			columns[] = {0.05,0.2};
			
			colorSelectBackground[] = {0,0,0,0};
			colorSelectBackground2[] = {0,0,0,0};
			soundSelect[] = {};
			
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.247975 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.266027 * safezoneH;
		};
		class ALC_rscListNBoxL_order : ALC_rscListNboxL_catalog {
			idc = 1511;
			text = "-";
		};
		class ALC_rscListNBoxR_order : ALC_rscListNBoxL_order {
			idc = 1512;
			text = "+";
		};
		
		//	INVOICE LIST BOX
		class ALC_rscListbox_invoice: ALC_rscListBox_parent {
			idc = 1520;
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.565109 * safezoneH + safezoneY;	//	584009
			w = 0.223063 * safezoneW;
			h = 0.168100 * safezoneH;	//168017
		};
		
		//	LIST BOX HEADERS
		class ALC_rscListNbox_headerCatalog: ALC_rscListNBox_parent {
			idc = 1530;
			style = ST_SINGLE;
			columns[] = {0.06,0.25};
			
			x = 0.263816 * safezoneW + safezoneX;
			y = 0.20597 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.0280029 * safezoneH;
			class ListScrollBar {
				width = 0;
				height = 0;
				scrollSpeed = 0.01;

				arrowEmpty = "";
				arrowFull = "";
				border = "";
				thumb = "";

				color[] = {0,0,0,0}; // Scrollbar color
			};
		};
		class ALC_rscListNbox_headerOrder: ALC_rscListNBox_parent {
			idc = 1540;
			style = ST_SINGLE;
			
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.20597 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.0280029 * safezoneH;
			class ListScrollBar {
				width = 0;
				height = 0;
				scrollSpeed = 0.01;

				arrowEmpty = "";
				arrowFull = "";
				border = "";
				thumb = "";

				color[] = {0,0,0,0}; // Scrollbar color
			};			
		};
		class ALC_rscListNbox_headerInvoice: ALC_rscListNBox_parent {
			idc = 1550;
			style = ST_SINGLE;
			
			x = 0.513121 * safezoneW + safezoneX;
			y = 0.556006 * safezoneH + safezoneY;
			w = 0.223063 * safezoneW;
			h = 0.0280029 * safezoneH;
			class ListScrollBar {
				width = 0;
				height = 0;
				scrollSpeed = 0.01;

				arrowEmpty = "";
				arrowFull = "";
				border = "";
				thumb = "";

				color[] = {0,0,0,0}; // Scrollbar color
			};			
		};
	};
	class objects {};
};
