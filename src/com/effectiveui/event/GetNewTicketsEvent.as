package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetNewTicketsEvent extends CairngormEvent
	{
		public static const GET_NEW_TICKETS:String = "getnewtickets";
		public var timeStamp:String;
		public function GetNewTicketsEvent(time:String)
		{
			timeStamp = time;
			super(GET_NEW_TICKETS);
		}
	}
}