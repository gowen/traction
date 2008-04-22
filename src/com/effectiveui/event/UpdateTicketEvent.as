package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class UpdateTicketEvent extends CairngormEvent
	{
		public static const UPDATE_TICKET:String = "updateticket";
		public var ticket:Object;
		public function UpdateTicketEvent(tic:Object)
		{
			ticket = tic;
			super(UPDATE_TICKET);
		}
		
	}
}