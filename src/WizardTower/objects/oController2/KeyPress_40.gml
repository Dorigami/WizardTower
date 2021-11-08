/// @description remove a follower

if(instance_exists(oFollower2))
{
	with(oFollower2)
	{
		instance_destroy();
		break;
	}
}
