package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	
	import flash.events.Event;

	public class GetPrioritiesCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.getURL());
			conn.addEventListener(Event.COMPLETE, handlePrioritiesReturn);
			conn.call("ticket.priority.getAll");
		}
		
		protected function handlePrioritiesReturn(event:Event):void{
			model.priorities.removeAll();
			model.priorities.addItemAt(model.NO_VALUE, 0);
			var priorities:Array = conn.getResponse() as Array;
			for each(var priority:String in priorities){
				model.priorities.addItem(priority);
			}			
		}
		
	}
}