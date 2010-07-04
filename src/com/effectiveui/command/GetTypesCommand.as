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

	public class GetTypesCommand implements Command
	{
		protected var conn:ConnectionImpl;
		protected var model:TracModel = TracModel.getInstance();
		public static const ALL_TYPES:String = "All Types";
		
		public function execute(event:CairngormEvent):void
		{
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addEventListener(Event.COMPLETE, handleTypesReturn);
			conn.call("ticket.type.getAll");
		}
		
		protected function handleTypesReturn(event:Event):void{
			model.types.removeAll();
			model.types.addItemAt(ALL_TYPES, 0);
			var types:Array = (conn.getResponse() as Array);
			for each(var type:String in types){
				model.types.addItem(type);
			}			
		}
		
	}
}