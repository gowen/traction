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
package com.effectiveui.control
{	
	import com.adobe.cairngorm.control.FrontController;
	import com.effectiveui.command.CheckApplicationVersionCommand;
	import com.effectiveui.command.CreateNewTicketCommand;
	import com.effectiveui.command.GetComponentsCommand;
	import com.effectiveui.command.GetMilestonesCommand;
	import com.effectiveui.command.GetNewTicketsCommand;
	import com.effectiveui.command.GetOwnersCommand;
	import com.effectiveui.command.GetPrioritiesCommand;
	import com.effectiveui.command.GetResolutionsCommand;
	import com.effectiveui.command.GetScoresCommand;
	import com.effectiveui.command.GetSeveritiesCommand;
	import com.effectiveui.command.GetStatusesCommand;
	import com.effectiveui.command.GetTicketsCommand;
	import com.effectiveui.command.GetTypesCommand;
	import com.effectiveui.command.GetVersionsCommand;
	import com.effectiveui.command.UpdateTicketCommand;
	import com.effectiveui.event.CheckApplicationVersionEvent;
	import com.effectiveui.event.CreateNewTicketEvent;
	import com.effectiveui.event.GetComponentsEvent;
	import com.effectiveui.event.GetMilestonesEvent;
	import com.effectiveui.event.GetNewTicketsEvent;
	import com.effectiveui.event.GetOwnersEvent;
	import com.effectiveui.event.GetPrioritiesEvent;
	import com.effectiveui.event.GetResolutionsEvent;
	import com.effectiveui.event.GetScoresEvent;
	import com.effectiveui.event.GetSeveritiesEvent;
	import com.effectiveui.event.GetStatusesEvent;
	import com.effectiveui.event.GetTicketsEvent;
	import com.effectiveui.event.GetTypesEvent;
	import com.effectiveui.event.GetVersionsEvent;
	import com.effectiveui.event.UpdateTicketEvent;

	public class TractionController extends FrontController
	{
		public function TractionController()
		{
			super();
			initializeCommands();
		}
		
		protected function initializeCommands():void{
			addCommand(GetMilestonesEvent.GET_MILESTONES, GetMilestonesCommand);
			addCommand(GetComponentsEvent.GET_COMPONENTS, GetComponentsCommand);
			addCommand(GetPrioritiesEvent.GET_PRIORITIES, GetPrioritiesCommand);
			addCommand(GetSeveritiesEvent.GET_SEVERITIES, GetSeveritiesCommand);
			addCommand(GetResolutionsEvent.GET_RESOLUTIONS, GetResolutionsCommand);
			addCommand(GetStatusesEvent.GET_STATUSES, GetStatusesCommand);
			addCommand(GetTicketsEvent.GET_ACTIVE, GetTicketsCommand);
			addCommand(GetTicketsEvent.GET_ALL, GetTicketsCommand);
			addCommand(GetVersionsEvent.GET_VERSIONS, GetVersionsCommand);
			addCommand(GetTypesEvent.GET_TYPES, GetTypesCommand);
			addCommand(GetOwnersEvent.GET_OWNERS, GetOwnersCommand);
			addCommand(UpdateTicketEvent.UPDATE_TICKET, UpdateTicketCommand);
			addCommand(GetScoresEvent.GET_SCORES, GetScoresCommand);
			addCommand(CreateNewTicketEvent.NEW_TICKET, CreateNewTicketCommand);
			addCommand(GetNewTicketsEvent.GET_NEW_TICKETS, GetNewTicketsCommand);			
			addCommand(CheckApplicationVersionEvent.CHECK_VERSION, CheckApplicationVersionCommand);
		}
		
	}
}