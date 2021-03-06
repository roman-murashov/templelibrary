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

package temple.facebook.data.enum
{
	/**
	 * This class contains some possible values for <code>type</code> property of an <code>IFacebookObjectData</code>
	 * object.
	 * 
	 * @author Thijs Broerse
	 */
	public final class FacebookObjectType
	{
		/**
		 * @see temple.facebook.data.vo.IFacebookUserData
		 */
		public static const USER:String = "user";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookCommentData
		 */
		public static const COMMENT:String = "comment";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookAlbumData
		 */
		public static const ALBUM:String = "album";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookEventData
		 */
		public static const EVENT:String = "event";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookPostData
		 */
		public static const POST:String = "post";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookPostData
		 */
		public static const STATUS:String = "status";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookCheckinData
		 */
		public static const CHECKIN:String = "checkin";
		
		/**
		 * @see temple.facebook.data.vo.
		 */
		public static const APPLICATION:String = "application";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookPageData
		 */
		public static const PAGE:String = "page";

		/**
		 * @see temple.facebook.data.vo.IFacebookFriendListData
		 */
		public static const FRIENDLIST:String = "friendlist";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookAppRequestData
		 */
		public static const APP_REQUEST:String = "appRequest";
		
		/**
		 * @see temple.facebook.data.vo.IFacebookPhotoData
		 */
		public static const PHOTO:String = "photo";

		/**
		 * @see temple.facebook.data.vo.IFacebookGroupData
		 */
		public static const GROUP:String = "group";
	}
}
