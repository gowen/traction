package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;

	public class GetMilestonesCommand implements Command
	{
		public function GetMilestonesCommand()
		{
		}

		[Bindable]
		private var model:TracModel = TracModel.getInstance();

		public function execute(event:CairngormEvent):void
		{
			var conn:ConnectionImpl = new ConnectionImpl(model.getURL());
			
		}
		
	}
}