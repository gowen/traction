/*
	Copyright 2010 Greg Owen, Phil Owen, Jacob Henry
	
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

	public class GetPrioritiesCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;
		public static const ALL_PRIORITIES:String = "All Priorities";
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addEventListener(Event.COMPLETE, handlePrioritiesReturn);
			conn.call("ticket.priority.getAll");
		}
		
		protected function handlePrioritiesReturn(event:Event):void{
			model.priorities.removeAll();
			model.priorities.addItemAt(ALL_PRIORITIES, 0);
			var priorities:Array = conn.getResponse() as Array;
			for each(var priority:String in priorities){
				model.priorities.addItem(priority);
			}			
		}
		
	}
}