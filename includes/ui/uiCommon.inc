//	CONTROL TYPES
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_HITZONES         17
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102
#define CT_ITEMSLOT         103
#define CT_CHECKBOX         77

//	STATIC STYLES
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0
#define ST_UPPERCASE      0xC0
#define ST_LOWERCASE      0xD0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

//	SLIDER STYLES
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

//	PROGRESS BAR
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

//	LISTBOX STYLES.
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

//	TREE STYLES
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

//	MESSAGE BOX STYLES
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4
#define MB_ERROR_DIALOG   8

//	XBOX BUTTONS
#define KEY_XINPUT                0x00050000
#define KEY_XBOX_A                KEY_XINPUT + 0
#define KEY_XBOX_B                KEY_XINPUT + 1
#define KEY_XBOX_X                KEY_XINPUT + 2
#define KEY_XBOX_Y                KEY_XINPUT + 3
#define KEY_XBOX_Up               KEY_XINPUT + 4
#define KEY_XBOX_Down             KEY_XINPUT + 5
#define KEY_XBOX_Left             KEY_XINPUT + 6
#define KEY_XBOX_Right            KEY_XINPUT + 7
#define KEY_XBOX_Start            KEY_XINPUT + 8
#define KEY_XBOX_Back             KEY_XINPUT + 9
#define KEY_XBOX_LeftBumper       KEY_XINPUT + 10
#define KEY_XBOX_RightBumper      KEY_XINPUT + 11
#define KEY_XBOX_LeftTrigger      KEY_XINPUT + 12
#define KEY_XBOX_RightTrigger     KEY_XINPUT + 13
#define KEY_XBOX_LeftThumb        KEY_XINPUT + 14
#define KEY_XBOX_RightThumb       KEY_XINPUT + 15
#define KEY_XBOX_LeftThumbXRight  KEY_XINPUT + 16
#define KEY_XBOX_LeftThumbYUp     KEY_XINPUT + 17
#define KEY_XBOX_RightThumbXRight KEY_XINPUT + 18
#define KEY_XBOX_RightThumbYUp    KEY_XINPUT + 19
#define KEY_XBOX_LeftThumbXLeft   KEY_XINPUT + 20
#define KEY_XBOX_LeftThumbYDown   KEY_XINPUT + 21
#define KEY_XBOX_RightThumbXLeft  KEY_XINPUT + 22
#define KEY_XBOX_RightThumbYDown  KEY_XINPUT + 23

//	CONTROLS
#define IDC_OK            1
#define IDC_CANCEL        2
#define IDC_AUTOCANCEL    3
#define IDC_ABORT         4
#define IDC_RESTART       5
#define IDC_USER_BUTTON   6
#define IDC_EXIT_TO_MAIN  7

//	FONTS
#define GUI_FONT_NORMAL			PuristaMedium
#define GUI_FONT_BOLD			PuristaSemibold
#define GUI_FONT_THIN			PuristaLight
#define GUI_FONT_MONO			EtelkaMonospacePro
#define GUI_FONT_NARROW			EtelkaNarrowMediumPro
#define GUI_FONT_CODE			LucidaConsoleB
#define GUI_FONT_SYSTEM			TahomaB

// GENERAL GRIDS
#define GUI_GRID_CENTER_WAbs		((safezoneW / safezoneH) min 1.2)
#define GUI_GRID_CENTER_HAbs		(GUI_GRID_CENTER_WAbs / 1.2)
#define GUI_GRID_CENTER_W		(GUI_GRID_CENTER_WAbs / 40)
#define GUI_GRID_CENTER_H		(GUI_GRID_CENTER_HAbs / 25)
#define GUI_GRID_CENTER_X		(safezoneX + (safezoneW - GUI_GRID_CENTER_WAbs)/2)
#define GUI_GRID_CENTER_Y		(safezoneY + (safezoneH - GUI_GRID_CENTER_HAbs)/2)

//	ALC EXPORT GRIDS
#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)
#define GUI_GRID_WAbs	(1)
#define GUI_GRID_HAbs	(1)

//	ASG CATALOG DEFINITION
#define ALOC_logItems [["hgun_Rook40_F",500],["SMG_02_F",800],["arifle_SDAR_F",1600],["arifle_SPAR_01_blk_F",800],["arifle_SPAR_01_GL_blk_F",1600],["LMG_03_F",4000],["arifle_SPAR_03_blk_F",1600],["srifle_DMR_02_F",6000],["MMG_02_black_F",6000],["launch_RPG7_F",1000],["launch_NLAW_F",5000],["launch_B_Titan_short_tna_F",50000],["launch_B_Titan_tna_F",50000],["acc_flashlight",20],["acc_pointer_IR",20],["optic_Aco",800],["optic_Hamr",1600],["optic_SOS",2400],["optic_LRPS",3200],["bipod_01_F_blk",100],["muzzle_snds_M",500],["muzzle_snds_B",500],["muzzle_snds_338_black",500],["Binocular",100],["Rangefinder",1000],["NVGoggles_OPFOR",2000],["NVGogglesB_blk_F",3000],["Medikit",100],["MineDetector",200],["ToolKit",100],["FirstAidKit",200]]
#define ALOC_logItemsV [["B_AssaultPack_rgr",75],["B_Kitbag_rgr",150],["APERSMine",50],["ATMine",150],["DemoCharge_F",50]]
#define ALOC_logMags [["10Rnd_338_Mag",300],["130Rnd_338_Mag",4000],["16Rnd_9x21_Mag",40],["30Rnd_9x21_Mag",60],["30Rnd_9x21_Mag_SMG_02",60],["20Rnd_556x45_UW_mag",60],["30Rnd_556x45_Stanag",90],["200Rnd_556x45_Box_F",600],["200Rnd_556x45_Box_Tracer_F",600],["RPG7_F",100],["NLAW_F",20000],["Titan_AA",50000],["Titan_AP",50000],["Titan_AT",50000],["SmokeShell",100],["SmokeShellRed",100],["SmokeShellOrange",100],["SmokeShellYellow",100],["SmokeShellGreen",100],["SmokeShellBlue",100],["SmokeShellPurple",100],["Chemlight_red",5],["Chemlight_yellow",5],["Chemlight_green",5],["Chemlight_blue",5],["B_IR_Grenade",200],["HandGrenade",300],["MiniGrenade",200],["1Rnd_HE_Grenade_shell",400],["1Rnd_Smoke_Grenade_shell",300],["1Rnd_SmokeRed_Grenade_shell",300],["1Rnd_SmokeOrange_Grenade_shell",300],["1Rnd_SmokeYellow_Grenade_shell",300],["1Rnd_SmokeGreen_Grenade_shell",300],["1Rnd_SmokeBlue_Grenade_shell",300],["1Rnd_SmokePurple_Grenade_shell",300],["UGL_FlareWhite_F",100],["UGL_FlareRed_F",100],["UGL_FlareYellow_F",100],["UGL_FlareGreen_F",100],["UGL_FlareCIR_F",100],["Laserbatteries",200]]
