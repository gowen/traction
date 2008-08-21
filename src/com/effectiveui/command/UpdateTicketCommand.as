package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.component.TracTicket;
	import com.effectiveui.event.UpdateTicketEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;

	public class UpdateTicketCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		public function execute(event:CairngormEvent):void
		{			
			var ticket:TracTicket = (event as UpdateTicketEvent).ticket;
			if(ticket.component == model.NO_VALUE){
				ticket.component = "";
			} 
			if(ticket.version == model.NO_VALUE){
				ticket.version = "";
			}
			if(ticket.status == model.NO_VALUE){
				ticket.status = "";
			}
			if(ticket.type == model.NO_VALUE){
				ticket.type = "";
			}
			if(ticket.resolution == model.NO_VALUE){
				ticket.resolution = "";
			}
			if(ticket.milestone == model.NO_VALUE){
				ticket.milestone = "";
			}
			if(ticket.priority == model.NO_VALUE){
				ticket.priority = "";
			}
			
			
			var conn:ConnectionImpl = new ConnectionImpl(model.serverURL, model.username, model.password);			
			var comment:String = " ";
			conn.addParam(ticket.id, XMLRPCDataTypes.INT);
			conn.addParam(comment, XMLRPCDataTypes.STRING);
			conn.addParam(ticket.toObject(), XMLRPCDataTypes.STRUCT);			
			conn.call("ticket.update"); 
			model.tickets.refresh();
		}
		
	}
}