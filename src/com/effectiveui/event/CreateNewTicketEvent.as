package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.component.TracTicket;

	public class CreateNewTicketEvent extends CairngormEvent
	{
		public static const NEW_TICKET:String = "newticket";
		public var ticket:TracTicket;
		public function CreateNewTicketEvent(tic:TracTicket)
		{
			ticket = tic;
			super(NEW_TICKET);
		}
		
	}
}