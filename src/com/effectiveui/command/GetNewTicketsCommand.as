package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.component.TracTicket;
	import com.effectiveui.event.GetNewTicketsEvent;
	import com.effectiveui.event.GetOwnersEvent;
	import com.effectiveui.model.TracModel;
	import com.effectiveui.util.IOUtil;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;
	
	import flash.events.Event;

	public class GetNewTicketsCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;		
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			var timeStamp:String = (event as GetNewTicketsEvent).timeStamp;
			conn.addParam(timeStamp, XMLRPCDataTypes.DATETIME);
			conn.addEventListener(Event.COMPLETE, handleTicketList);
			conn.call("ticket.getRecentChanges");
		} 
			
		protected function handleTicketList(event:Event):void{
			var ticketList:Array = (conn.getResponse() as Array);
			model.ticketCount += ticketList.length;
			if(ticketList.length == 0)
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
			var updated:Boolean = false;
			var tickets:Array = ((event.target as ConnectionImpl).getResponse() as Array);			
			model.tickets.disableAutoUpdate();			
			for(var i:int = 0; i < tickets.length; i++)
			{
				updated = false;									
				if(tickets[i][0].length >= 4)
				{					
					var ticket:TracTicket = new TracTicket();
					ticket.id = tickets[i][0][0];
					ticket.getFromTicketObject(tickets[i][0][3]);
					
					//check if its a new or just updated ticket
					for(var k:int=0;k< model.tickets.length && !updated;k++)
					{
						var id:String = model.tickets.getItemAt(k).id; 
						if(ticket.id == id)
						{
							model.tickets.removeItemAt(k);
							model.ticketCount--;
							updated = true;
						}
					}
					model.tickets.addItem(ticket);
					IOUtil.addTicketToDB(ticket);
				}
				if(!updated)
					model.numTicketsLoaded++;
				trace("NumTickets: " + model.numTicketsLoaded + " TicketCount: " + model.ticketCount);
			}			
			if(model.numTicketsLoaded == model.ticketCount){
				trace("ticketCount = numTicketsLoaded");
				model.ticketsLoaded = true;
				model.tickets.enableAutoUpdate();
				model.tickets.refresh();
				new GetOwnersEvent().dispatch();
			}
		}
	}
}