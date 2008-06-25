package com.effectiveui.command
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.Command;
	import com.effectiveui.component.TracTicket;
	import com.effectiveui.event.CreateNewTicketEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;

	public class CreateNewTicketCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		public function execute(event:CairngormEvent):void
		{
			var ticket:TracTicket = (event as CreateNewTicketEvent).ticket;
			var conn:ConnectionImpl = new ConnectionImpl(model.serverURL, model.username, model.password);			
			conn.addParam(ticket.summary, XMLRPCDataTypes.STRING);
			conn.addParam(ticket.description, XMLRPCDataTypes.STRING);
			conn.addParam(ticket.toObject(), XMLRPCDataTypes.STRUCT);			
			conn.call("ticket.create"); 
			
			model.tickets.refresh();
		}
	}
}