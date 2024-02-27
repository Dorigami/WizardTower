/// @description 













// Inherit the parent event
event_inherited();


// fill all attack charges
with(structure)
{
	supply_current = 0;
	repeat(supply_capacity)
	{
		StructureAddAttackCharge(self, oMagicBoltCharge);
	}
}
