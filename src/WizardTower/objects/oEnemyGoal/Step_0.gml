/// @description 

if(!enable_collision_checking) exit;
enemy_found = false
for(var i=0;i<global.game_grid_height;i++)
{
	// loop through occupied list of left-most grid nodes
	var _node = global.game_grid[# 0, i];
	for(var j=0;j<ds_list_size(_node.occupied_list);j++)
	{
		with(_node.occupied_list[| j])
		{	
			if(faction == ENEMY_FACTION)  
			{
				// set flag for enemy found
				if(!other.enemy_found) other.enemy_found = true;
				
				// deal damage directly to player, remove enemy
				if(collision_point(position[1], position[2],oEnemyGoal,false,true))
				{ HurtPlayerBySupply(); instance_destroy(); }
			}
		}
	}
}

// stop checking collisions if no enemies nearby
if(!enemy_found) 
{
	show_debug_message("disable col checking----------------");
	enable_collision_checking = false;
}

