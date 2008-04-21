package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;

	public class GetMilestonesEvent extends CairngormEvent
	{
		public static const GET_MILESTONES:String = "getmilestones";
		
		public function GetMilestonesEvent()
		{
			super(GET_MILESTONES);
		}		
	}
}