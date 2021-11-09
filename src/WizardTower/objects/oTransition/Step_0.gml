/// @description progress transition

if(leading == OUT)
{
	percent = min(1, percent+transitionSpeed);
	if(percent >= 1)
	{
		// next room
		room_goto(target);
		leading = IN;
		// run an action halfway through the transition
		if(transitionScript != -1) script_execute(transitionScript);
	}
} else {
	percent = max(0, percent-transitionSpeed);
	if(percent <= 0)
	{		
		instance_destroy();
	}
}
