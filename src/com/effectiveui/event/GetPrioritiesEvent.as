package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetPrioritiesEvent extends CairngormEvent
	{
		public static const GET_PRIORITIES:String = "getpriorities";
		
		public function GetPrioritiesEvent()
		{
			super(GET_PRIORITIES);	
		}

	}
}