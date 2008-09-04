/*
	Copyright 2008 Greg Owen, Phil Owen, Jacob Henry
	
	Website: http://github.com/gowen/traction 

    This file is part of Traction.

    Traction is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Traction is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Traction.  If not, see <http://www.gnu.org/licenses/>.

*/
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
		public static const ALL_STATUSES:String = "All Statuses";
		public static const NON_CLOSED:String = "All Open Tickets";		
		public static const CLOSED:String = "closed";
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addEventListener(Event.COMPLETE, handleStatusesReturn);
			conn.call("ticket.status.getAll");
		}
		
		protected function handleStatusesReturn(event:Event):void{
			model.statuses.removeAll();			
			model.statuses.addItemAt(ALL_STATUSES, 0);
			model.statuses.addItemAt(NON_CLOSED, 1);
			var statuses:Array = conn.getResponse() as Array;
			for each(var status:String in statuses){
				model.statuses.addItem(status);
			}			
		}		
	}
}