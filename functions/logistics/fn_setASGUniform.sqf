/*
	
	ASG_fnc_setASGuniform
	by: Diffusion9
	
	Set the target unit uniform to the Athena Security Group combat uniform.
	
	EXEC TYPE:	Call
	INPUT:	0	OBJECT	Object to change texture.
	OUTPUT:	0	BOOL	True when complete.
	
*/

params ["_unit"];

_tex = "textures\uniforms\ASG\uniform.paa";
_mat = "a3\characters_f_beta\indep\data\ia_soldier_01_clothing.rvmat";

_unit setObjectTextureGlobal [0, _tex];
_unit setObjectMaterialGlobal [0, _mat];
true
