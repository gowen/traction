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
package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetPrioritiesEvent extends CairngormEvent
	{
		public static const GET_PRIORITIES:String = "getpriorities";
		
		public function GetPrioritiesEvent()
		{
			super(GET_PRIORITIES);	
		}

	}
}