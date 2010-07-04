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
	import com.mattism.http.xmlrpc.util.XMLRPCDataTypes;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;

	public class GetScoresCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
		protected var conn:ConnectionImpl;
		private var scores:ArrayCollection;
		private var ownerIndex:int = 0;
		
		public function execute(event:CairngormEvent):void{
			if(model.scoreBoard.length > 0){
				getScoreForOwner(ownerIndex);
			}
		}
		
		protected function getScoreForOwner(currentOwnerIndex:int):void{
			var ticketRequestArray:Array = new Array();
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			
			for(var priorityIndex:int = 1;priorityIndex < model.priorities.length; priorityIndex++){ 
				var query:String = "owner=" + model.scoreBoard.getItemAt(currentOwnerIndex)['owner'] + 
													 "&priority=" + model.priorities.getItemAt(priorityIndex) + 
													 "&status=closed" + 
													 "&resolution=" + model.resolutions.getItemAt(1);
				
				var request:Object = new Object();
				request["methodName"] = "ticket.query";
				request["params"] = new Array();
				(request["params"] as Array).push({type:XMLRPCDataTypes.STRING, value:query});
				ticketRequestArray.push(request);
			}
						
			var tempConn:ConnectionImpl = new ConnectionImpl(model.serverURL, model.username, model.password);
			tempConn.addParam(ticketRequestArray, XMLRPCDataTypes.ARRAY);
			tempConn.addEventListener(Event.COMPLETE, handleScoreReturn);
			tempConn.call("system.multicall");
			ticketRequestArray = new Array();
		}
		
		protected function handleScoreReturn(event:Event):void{
			var tempConn:ConnectionImpl = event.target as ConnectionImpl;
			var results:Array = tempConn.getResponse() as Array;
			var result:Array;
			var score:int;
			
			//results length is multiplied by weight of priority index  	
			for(var i:int = 0; i < results.length; i++){
				result = (results[i] as Array);
				score += (result[0] as Array).length * getWeight(i + 1);
			}
			var scoreCard:Object = new Object;
			scoreCard["owner"] = (model.scoreBoard.getItemAt(ownerIndex) as Object)["owner"]
			scoreCard["score"] = score;
			
			//refresh datagrid
  		model.scoreBoard.setItemAt(scoreCard, ownerIndex);
			
			// Once we have collected the score for the current user
			// move onto the next user
			ownerIndex++;
			if(ownerIndex < model.scoreBoard.length){
				getScoreForOwner(ownerIndex);
			}
		}
		
		// getWeight first tries to return the priority supplied by the user
		// as a number.  If the trac admin does not have the priorities
		// set to numbers, the weight will simply be the priority index + 1
		// Again we must account for the "ALL_X" value placed at index 0 
		protected function getWeight(priorityIndex:int):int{
			var weight:int = model.priorities.length - priorityIndex;
			var tempWeight:int = parseInt(model.priorities[priorityIndex] as String);
			
			if(tempWeight != 0){
				weight = tempWeight;
			}
			return weight;
		}
	}
}