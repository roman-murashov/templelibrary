/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.facebook.data.vo
{
	import temple.facebook.data.enum.FacebookFieldAlias;

	/**
	 * IFacebookFields are used to defined which properties of an object you want to receive from Facebook.
	 * Some property need special permissions, these permissions are handled automatically.
	 * 
	 * @author Thijs Broerse
	 */
	public interface IFacebookFields
	{
		/**
		 * The maximum result count
		 */
		function get limit():uint;
		
		/**
		 * @inheritDoc
		 */
		function set limit(value:uint):void;
		
		/**
		 * Set all fields in the list to <code>true</code>
		 */
		function select(fields:Vector.<String>):void;
		
		/**
		 * Returns a list with all fields
		 */
		function all():Vector.<String>
		
		/**
		 * Returns a list of all properties which are set to true.
		 * @param alias defines which alias for every property is used. If set to null no alias is used.
		 * 
		 * @see temple.facebook.data.enum.FacebookFieldAlias
		 */
		function getFieldsList(alias:FacebookFieldAlias):Vector.<String>;
		
		/**
		 * Returns a string of all properties which are set to true.
		 * @param alias defines which alias for every property is used. If set to null no alias is used.
		 * 
		 * @see temple.facebook.data.enum.FacebookFieldAlias
		 */
		function getFieldsString(alias:FacebookFieldAlias):String;

		/**
		 * Returns a list of needed permissions for getting all the selected fields in this object.
		 */
		function getPermissions(me:Boolean = true):Vector.<String>;

		/**
		 * Adds a field to the list which isn't defined by default. This can be a field in the FQL table.
		 */
		function addCustomField(field:String):void;
	}
}
