package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	
	import flash.events.Event;

	public class GetMilestonesCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;
		public static const ALL_MILESTONES:String = "All Milestones";

		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addEventListener(Event.COMPLETE, handleMilestoneReturn);
			conn.call("ticket.milestone.getAll");			
		}
		
		protected function handleMilestoneReturn(event:Event):void{
			model.milestones.removeAll();
			model.milestones.addItemAt(ALL_MILESTONES, 0);
			var milestones:Array = (conn.getResponse() as Array);
			for each(var milestone:String in milestones){
				model.milestones.addItem(milestone);
			}			
		}
		
	}
}