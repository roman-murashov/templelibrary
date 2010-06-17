/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 *	
 */

package temple.data.collections 
{
	import temple.core.CoreObject;

	/**
	 * @author Thijs Broerse
	 */
	public class PropertyValueData extends CoreObject
	{
		private var _property:String;
		private var _value:*;
		
		public function PropertyValueData(property:String = null, value:* = null)
		{
			this._property = property;
			this._value = value;
		}

		/**
		 * Name of the property
		 */
		public function get property():String
		{
			return this._property;
		}
		
		/**
		 * @private
		 */
		[Inspectable(type="String")]
		public function set property(value:String):void
		{
			this._property = value;
		}
		
		/**
		 * Value of the property
		 */
		public function get value():*
		{
			return this._value;
		}
		
		/**
		 * @private
		 */
		[Inspectable(type="String")]
		public function set value(value:*):void
		{
			this._value = value;
		}

		/**
		 * 
		 */
		override public function toString():String
		{
			return super.toString() + ' (property="' + this._property + '", value="' + this._value + '")';
		}

		/**
		 * @private
		 */
		override public function destruct():void
		{
			this._value = null;
			this._property = null;
			
			super.destruct();
		}
	}
}
