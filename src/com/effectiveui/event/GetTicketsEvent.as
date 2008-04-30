package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetTicketsEvent extends CairngormEvent
	{
		public static const GET_TICKETS:String = "gettickets";
		
		public var owner:String;
		
		public function GetTicketsEvent(owner:String = null)
		{
			super(GET_TICKETS);
			this.owner = owner;
		}

	}
}