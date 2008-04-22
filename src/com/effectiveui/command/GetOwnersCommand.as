package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;
	
	import flash.events.Event;

	public class GetOwnersCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;
		public function execute(event:CairngormEvent):void{		
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addParam("CurrentUsers", XMLRPCDataTypes.STRING);
			conn.addEventListener(Event.COMPLETE, handleOwnersReturn);
			conn.call("wiki.getPage");
		}
		
		protected function handleOwnersReturn(event:Event):void{
			model.owners.removeAll();
			model.owners.addItem(model.NO_VALUE);
			var owners:Array = (conn.getResponse() as String).split("\r\n");
			for each(var owner:String in owners){
				model.owners.addItem(owner);
			}
		}
	}
}