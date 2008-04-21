package com.effectiveui.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.effectiveui.command.GetTicketsCommand;
	import com.effectiveui.event.GetTicketsEvent;

	public class TracUIController extends FrontController
	{
		public function TracUIController()
		{
			super();
			initializeCommands();
		}
		
		protected function initializeCommands():void{
			/*addCommand(GetMilestonesEvent.GET_MILESTONES, GetMilestonesCommand);
			addCommand(GetComponentsEvent.GET_COMPONENTS, GetComponentsCommand);
			addCommand(GetPrioritiesEvent.GET_PRIORITIES, GetPrioritiesCommand);
			addCommand(GetResolutionsEvent.GET_RESOLUTIONS, GetResolutionsCommand);
			addCommand(GetStatusesEvent.GET_STATUSES, GetStatusesCommand); */
			addCommand(GetTicketsEvent.GET_TICKETS, GetTicketsCommand);
		}
		
	}
}