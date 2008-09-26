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
	import com.effectiveui.component.TracTicket;
	import com.effectiveui.event.UpdateTicketEvent;
	import com.effectiveui.model.TracModel;
	import com.effectiveui.util.IOUtil;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;
	
	import flash.events.Event;

	public class UpdateTicketCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		public function execute(event:CairngormEvent):void
		{			
			model.sendingData = true;
			
			var ticket:TracTicket = (event as UpdateTicketEvent).ticket;
			if(ticket.component == model.NO_VALUE){
				ticket.component = "";
			} 
			if(ticket.version == model.NO_VALUE){
				ticket.version = "";
			}
			if(ticket.status == model.NO_VALUE){
				ticket.status = "";
			}
			if(ticket.type == model.NO_VALUE){
				ticket.type = "";
			}
			if(ticket.resolution == model.NO_VALUE){
				ticket.resolution = "";
			}
			if(ticket.milestone == model.NO_VALUE){
				ticket.milestone = "";
			}
			if(ticket.priority == model.NO_VALUE){
				ticket.priority = "";
			}
			
		//	model.tickets.refresh();
			
			var conn:ConnectionImpl = new ConnectionImpl(model.serverURL, model.username, model.password);			
			var comment:String = " ";
			conn.addParam(ticket.id, XMLRPCDataTypes.INT);
			conn.addParam(comment, XMLRPCDataTypes.STRING);
			conn.addParam(ticket.toObject(), XMLRPCDataTypes.STRUCT);
			conn.addEventListener(Event.COMPLETE, handleCallComplete);			
			conn.call("ticket.update"); 
			IOUtil.addTicketToDB(ticket);
		}
		
		protected function handleCallComplete(event:Event):void{
			model.sendingData = false;
		}
		
	}
}