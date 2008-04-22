package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	
	import flash.events.Event;

	public class GetStatusesCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addEventListener(Event.COMPLETE, handleStatusesReturn);
			conn.call("ticket.status.getAll");
		}
		
		protected function handleStatusesReturn(event:Event):void{
			model.statuses.removeAll();
			model.statuses.addItemAt(model.NO_VALUE, 0);
			var statuses:Array = conn.getResponse() as Array;
			for each(var status:String in statuses){
				model.statuses.addItem(status);
			}			
		}		
	}
}