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
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.commands.Command;
	import com.effectiveui.component.TracTicket;
	import com.effectiveui.event.CreateNewTicketEvent;
	import com.effectiveui.model.TracModel;
	import com.mattism.http.xmlrpc.ConnectionImpl;
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;

	public class CreateNewTicketCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		public function execute(event:CairngormEvent):void
		{
			var ticket:TracTicket = (event as CreateNewTicketEvent).ticket;
			var conn:ConnectionImpl = new ConnectionImpl(model.serverURL, model.username, model.password);			
			conn.addParam(ticket.summary, XMLRPCDataTypes.STRING);
			conn.addParam(ticket.description, XMLRPCDataTypes.STRING);
			conn.addParam(ticket.toObject(), XMLRPCDataTypes.STRUCT);			
			conn.call("ticket.create"); 
			
			model.tickets.refresh();
		}
	}
}