package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	
	import flash.events.Event;

	public class GetComponentsCommand implements Command
	{
		protected var conn:ConnectionImpl;
		protected var model:TracModel = TracModel.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.getURL());
			conn.addEventListener(Event.COMPLETE, handleComponentsReturn);
			conn.call("ticket.component.getAll");
		}
		
		protected function handleComponentsReturn(event:Event):void{
			model.components.removeAll();
			model.components.addItemAt(model.NO_VALUE, 0);
			var components:Array = (conn.getResponse() as Array);
			for each(var component:String in components){
				model.components.addItem(component);
			}			
		}
		
	}
}