package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	
	import flash.events.Event;

	public class GetVersionsCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addEventListener(Event.COMPLETE, handleVersionsReturn);
			conn.call("ticket.version.getAll");
		}
		
		protected function handleVersionsReturn(event:Event):void{
			model.versions.removeAll();
			model.versions.addItemAt(model.NO_VALUE, 0);
			var versions:Array = conn.getResponse() as Array;
			for each(var version:String in versions){
				model.versions.addItem(version);
			}						
		}
		
	}
}