class ASG {
	class ADEP {
		class bdInit {};			//	Initializes Base Deployment elements.
		class bdProcMenu {};		//	Creates the Base Deployment menu, serves it to players.
		class bdProcOrder {};		//	Processes Base Deployment orders, and deploys bases.
		class bdProcMark {};		//	Creates, deletes, hides, and reveals base markers.
		class bdProcMarkA {};		//	Changes the Alpha value of a marker. Used in fn_bdProcMark.
		class initACDEP {};			//	Check the ACDEP_DB and initiates the Campaign Deployment system.
		class procACDEPpos {};		//	Actives the ACDEP gui for the admin, who selects the deploy location.
		class setACDEPpos {};		//	Processes the position based on LAND or WATER.
		class procABDEPspecial {};	//	Catches special deployment types, like fighting positions and recon hides.
		class ABDEPprocFP {};		//	Processes fighting position deployment.
	};
	class AASW {
		class initAASW {};			//	Initialize the module.
		class initAASWlpServer {};	//	Location tracker ping (SERVER)
		class initAASWlpClient {};	//	Location tracker functionality (CLIENT)
		class procAASWcivSpawn {};	//	Civilian spawn
		class procAASWmilSpawn {};	//	Militia spawn
		class setAASWdata {};		//	Set data from the AASW location database.
		class getAASWdata {};		//	Get data from the AASW location database.
		class initAASWcivAction {};	//	Add the Talk Action to civilians.
	};
	class AGEN {
		class setPlayerState {};	//	Enables or Disables the player with a black screen.
		class initAPDH {};			//	Player Disconnect Handler.
		class remPlayerObj {};		//	Deletes empty player body.
		class advProgressBar {};	//	Generalized progress bar.
		class getASGrank {};		//	Get rank from the rank database.
		class procASGloc {};		//	process logout location in the rank database.
	};
	class ANAT {
		class initANAT {};			//	Nametags above player heads at close range.
	};
	class ACOM {
		class initACOM {};			//	Athena Combat Medical module core.
		class setACOMstate {};		//	Set medical state.
		class ACOMdoDrag {};		//	Drag a wounded player.
		class ACOMdoDrop {};		//	Drop a wounded player being dragged.
		class ACOMgetDrag {};		//	Be dragged by another player when wounded.
		class ACOMgetDrop {};		//	Be dropped by another player who is dragging.
	};
	class AEAR {
		class initAEAR {};			//	Earplugs, activated with "USERACTION1", or the END key.
	};
	class AIMOR {
		class mortarLogic {};		//	Firing and targeting logic for the AI mortar.
		class deployMortar {};		//	Deploys a mortar crew to a specified position. See header for details.
		class mortarDefineFaction {};	//	Defines the faction of a mortar.
		class mortarAbandon {};		//	Orders a mortar crew to abandon the mortar in certain situations.
		class mortarDestroyed {};	//	React to a destroyed mortar by eliminating loose scripts and loops.
	};
	class ADYN {
		class initADYN {};			//	Initiate Dynamic Groups.
	};
	class ALOC {
		class setASGequipment {};	//	Equip the target player with ASG standardized equipment.
		class setASGuniform {};		//	Reskin the uniform to the ASG combat uniform.
		class alocDialogInit {};	//	Initializes the contents of the ALOC_DIALOG menu.
		class alocFDR {};			//	Freight Delivery Request.
		class alocFDRProc {};		//	Process an FDR.
		class alocInit {};			//	Initialize the logistics control system.
		class alocPDR {};			//	Player Delivery Request.
		class alocProcUI {};		//	Process UI elements.
		class alocVDR {};			//	Vehicle Deliver Request.
	};
	class ARCS {
		class ARCSinitFunctions {};	//	Initializes all ARCS-related functions.
		class ARCSinit {};			//	Initializes channel data and menu.
	};
};
