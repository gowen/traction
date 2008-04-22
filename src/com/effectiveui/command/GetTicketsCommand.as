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
		protected var conn:ConnectionImpl;
		protected var model:TracModel = TracModel.getInstance();

		public function execute(event:CairngormEvent):void
		{
			//first we need to get the list of tickets for this user
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addParam("owner=" + model.username +"&status!=closed", XMLRPCDataTypes.STRING);
			conn.addEventListener(Event.COMPLETE, handleTicketList);
			conn.call("ticket.query");
		}
		
		protected function handleTicketList(event:Event):void{
			model.tickets.removeAll();
			var ticketList:Array = (conn.getResponse() as Array);
			var ticketRequestArray:Array = new Array();
			
			for(var i:int = 0; i < ticketList.length; i++){
				var request:Object = new Object();
				request["methodName"] = "ticket.get";
				request["params"] = new Array();
				(request["params"] as Array).push({type:XMLRPCDataTypes.DOUBLE, value:ticketList[i]});
				ticketRequestArray.push(request);
				
				if(ticketRequestArray.length > 50 || i == ticketList.length - 1){
					var tempConn:ConnectionImpl = new ConnectionImpl(model.serverURL, model.username, model.password);
					tempConn.addParam(ticketRequestArray, XMLRPCDataTypes.ARRAY);
					tempConn.addEventListener(Event.COMPLETE, handleTicketsReturn);
					tempConn.call("system.multicall");
					ticketRequestArray = new Array();
				}
			}			
		} 
		
		protected function handleTicketsReturn(event:Event):void{
			var tickets:Array = ((event.target as ConnectionImpl).getResponse() as Array);			
			model.tickets.disableAutoUpdate();
			for(var i:int = 0; i < tickets.length; i++){
				if(tickets[i][0].length >= 4){
					tickets[i][0][3]['id'] = tickets[i][0][0];
					model.tickets.addItem(tickets[i][0][3]);
				}
			}
			model.tickets.enableAutoUpdate();
			model.tickets.refresh();
			model.ticketsLoaded = true;
		}
		
	}
}