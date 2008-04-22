package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	
	import flash.events.Event;

	public class GetResolutionsCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addEventListener(Event.COMPLETE, handleResolutionsReturn);
			conn.call("ticket.resolution.getAll");
		}
		
		protected function handleResolutionsReturn(event:Event):void{
			model.resolutions.removeAll();
			model.resolutions.addItemAt(model.NO_VALUE, 0);
			var resolutions:Array = conn.getResponse() as Array;
			for each(var resolution:String in resolutions){	
				model.resolutions.addItem(resolution);
			}			
		}
		
	}
}