package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	
	import flash.events.Event;

	public class GetTypesCommand implements Command
	{
		protected var conn:ConnectionImpl;
		protected var model:TracModel = TracModel.getInstance();
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.getURL());
			conn.addEventListener(Event.COMPLETE, handleTypesReturn);
			conn.call("ticket.type.getAll");
		}
		
		protected function handleTypesReturn(event:Event):void{
			model.types.removeAll();
			model.types.addItemAt(model.NO_VALUE, 0);
			var types:Array = (conn.getResponse() as Array);
			for each(var type:String in types){
				model.types.addItem(type);
			}			
		}
		
	}
}