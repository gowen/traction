package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetTicketsEvent extends CairngormEvent
	{
		public static const GET_TICKETS:String = "gettickets";
		
		public function GetTicketsEvent()
		{
			super(GET_TICKETS);
		}

	}
}