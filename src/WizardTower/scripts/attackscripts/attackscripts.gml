function AttackTest()
{
	show_debug_message("attack test ran successfully");
}
function AttackPellet(){
	for(var i=0; i<ds_list_size(targetList); i++)
	{
		var _inst = targetList[| i];
		if(!is_undefined(_inst)) && (instance_exists(_inst))
		{
			var _x1 = x+0.5*TILE_SIZE;
			var _y1 = y+0.5*TILE_SIZE;
			var _x2 = _inst.x;
			var _y2 = _inst.y;
			var _dir = point_direction(_x1,_y1,_x2,_y2);
			var _struct = {
				direction : _dir,
				speed : 8,
				creator : id,
				damage : damage
			}
			instance_create_layer(_x1,_y1, "Instances",oAttackPellet, _struct);
		}
	}
}
function AttackMinigun(_tgt){
	if(instance_exists(_tgt))
	{
		with(_tgt) instance_destroy();
	}
}
function AttackBomber(_tgt){
	if(instance_exists(_tgt))
	{
		with(_tgt) instance_destroy();
	}
}
function AttackBolt(_tgt){
	for(var i=0; i<ds_list_size(targetList); i++)
	{
		var _inst = targetList[| i];
		if(!is_undefined(_inst)) && (instance_exists(_inst))
		{
			var _x1 = x+0.5*TILE_SIZE;
			var _y1 = y;

			var _struct = {
				target : _inst,
				creator : id,
				damage : damage
			}
			instance_create_layer(_x1,_y1, "Instances",oAttackBolt, _struct);
		}
	}
}
function AttackSniper(_tgt){
	if(instance_exists(_tgt))
	{
		with(_tgt) instance_destroy();
	}
}
function AttackLaser(_tgt){
	if(instance_exists(_tgt))
	{
		with(_tgt) instance_destroy();
	}
}
function AttackIce(_tgt){
	AttackTest();
}
function AttackBrittle(_tgt){
	if(instance_exists(_tgt))
	{
		with(_tgt) instance_destroy();
	}
}
function AttackFrostbite(_tgt){
	if(instance_exists(_tgt))
	{
		with(_tgt) instance_destroy();
	}
}
function AttackIntel(){
	
}
function AttackSpotter(_tgt){
	if(instance_exists(_tgt))
	{
		with(_tgt) instance_destroy();
	}
}
function AttackStalker(_tgt){
	if(instance_exists(_tgt))
	{
		with(_tgt) instance_destroy();
	}
}