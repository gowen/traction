package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.component.TracTicket;

	public class UpdateTicketEvent extends CairngormEvent
	{
		public static const UPDATE_TICKET:String = "updateticket";
		public var ticket:TracTicket;
		public function UpdateTicketEvent(tic:TracTicket)
		{
			ticket = tic;
			super(UPDATE_TICKET);
		}
		
	}
}