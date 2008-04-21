package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;
	
	import flash.events.Event;

	public class GetTicketsCommand implements Command
	{
		public function GetTicketsCommand()
		{
		}

		protected var conn:ConnectionImpl;
		private var model:TracModel = TracModel.getInstance();

		public function execute(event:CairngormEvent):void
		{
			//first we need to get the list of tickets for this user
			conn = new ConnectionImpl(model.getURL());
			conn.addParam("owner=" + model.username, XMLRPCDataTypes.STRING);
			conn.addEventListener(Event.COMPLETE, handleTicketList);
			conn.call("ticket.query");
		}
		
		protected function handleTicketList(event:Event):void{
			var ticketList:Array = (conn.getResponse() as Array);
			var ticketRequestArray:Array = new Array();
			for each(var id:int in ticketList){
				var request:Object = new Object();
				request["methodName"] = "ticket.get";
				request["params"] = new Array();
				(request["params"] as Array).push({type:XMLRPCDataTypes.DOUBLE, value:id});
				ticketRequestArray.push(request);
			}
			conn.removeParams();
			conn.removeEventListener(Event.COMPLETE, handleTicketList);
			conn.addParam(ticketRequestArray, XMLRPCDataTypes.ARRAY);
			conn.addEventListener(Event.COMPLETE, handleTicketsReturn);
			conn.call("system.multicall");
		} 
		
		protected function handleTicketsReturn(event:Event):void{
			var tickets:Array = (conn.getResponse() as Array);
			model.tickets.removeAll();
			for(var i:int = 0; i < tickets.length; i++){
				if(tickets[i][0].length >= 4){
					model.tickets.addItem(tickets[i][0][3]);
				}
			}
		}
		
	}
}