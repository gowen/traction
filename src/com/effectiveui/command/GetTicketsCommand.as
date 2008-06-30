package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.component.TracTicket;
	import com.effectiveui.event.GetComponentsEvent;
	import com.effectiveui.event.GetTicketsEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;

	public class GetTicketsCommand implements Command
	{
		protected var conn:ConnectionImpl;
		protected var model:TracModel = TracModel.getInstance();

		public function execute(event:CairngormEvent):void
		{
			//first we need to get the list of tickets for this user
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			model.currentTimeStamp = model.dateToISO();
			if(GetTicketsEvent(event).owner && GetTicketsEvent(event).owner.length > 0){
				conn.addParam("owner=" + GetTicketsEvent(event).owner +"&status!=closed", XMLRPCDataTypes.STRING);
			} else {
				conn.addParam("status!=closed", XMLRPCDataTypes.STRING);
			}
			conn.addEventListener(Event.COMPLETE, handleTicketList);
			model.ticketsLoaded = false;
			model.numTicketsLoaded = 0;
			conn.call("ticket.query");
		}
		
		protected function handleTicketList(event:Event):void{
			var sort:Sort = model.tickets.sort;
			model.tickets = new ArrayCollection();
			model.tickets.sort = sort;
			
			var ticketList:Array = (conn.getResponse() as Array);
			model.ticketCount = ticketList.length;
			if(model.ticketCount == 0)
				model.ticketsLoaded = true;
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
					var ticket:TracTicket = new TracTicket();
					ticket.id = tickets[i][0][0];
					ticket.getFromTicketObject(tickets[i][0][3]);
					model.tickets.addItem(ticket);
				}
				model.numTicketsLoaded++;
			}			
			if(model.numTicketsLoaded == model.ticketCount){
				model.ticketsLoaded = true;
				model.tickets.enableAutoUpdate();
				model.tickets.refresh();
			}
		}
		
	}
}