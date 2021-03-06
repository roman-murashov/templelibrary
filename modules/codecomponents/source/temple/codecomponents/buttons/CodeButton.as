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

package temple.codecomponents.buttons 
{
	import temple.codecomponents.graphics.CodeGraphicsRectangle;
	import temple.codecomponents.style.CodeStyle;
	import temple.ui.buttons.MultiStateButton;
	import temple.ui.states.focus.FocusFadeState;

	/**
	 * @includeExample CodeButtonExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class CodeButton extends MultiStateButton 
	{
		public function CodeButton(width:Number = 14, height:Number = 14, x:Number = 0, y:Number = 0)
		{
			addChild(new CodeGraphicsRectangle(width, height, CodeStyle.buttonColor, CodeStyle.buttonAlpha)).filters = CodeStyle.buttonFilters;
			
			this.x = x;
			this.y = y;
			
			addChild(new ButtonOverState(width, height));
			addChild(new ButtonSelectState(width, height));
			addChild(new ButtonDownState(width, height));
			
			// focus state
			var focus:FocusFadeState = new FocusFadeState(.2, .2);
			focus.graphics.beginFill(0xff0000, 1);
			focus.graphics.drawRect(0, 0, width, height);
			focus.graphics.endFill();
			addChildAt(focus, 0);
			focus.filters = CodeStyle.focusFilters;
			focus.y = 1;
		}

		override public function set width(value:Number):void
		{
			for (var i:int = 0, leni:int = numChildren; i < leni; i++) getChildAt(i).width = value;
		}
		
		override public function set height(value:Number):void
		{
			for (var i:int = 0, leni:int = numChildren; i < leni; i++) getChildAt(i).height = value;
		}
	}
}
import temple.codecomponents.style.CodeStyle;
import temple.ui.states.down.DownFadeState;
import temple.ui.states.over.OverFadeState;
import temple.ui.states.select.SelectFadeState;

class ButtonOverState extends OverFadeState
{
	public function ButtonOverState(width:Number, height:Number) 
	{
		super(.1, .25);
		
		draw(width, height);
	}

	override public function set width(value:Number):void
	{
		draw(value, height);
	}
	
	override public function set height(value:Number):void
	{
		draw(width, value);
	}

	private function draw(width:Number, height:Number):void
	{
		graphics.clear();
		graphics.beginFill(CodeStyle.buttonOverstateColor, CodeStyle.buttonOverstateAlpha);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		filters = CodeStyle.buttonFilters;
	}

}

class ButtonDownState extends DownFadeState
{
	public function ButtonDownState(width:Number, height:Number) 
	{
		super(0, .25);
		
		draw(width, height);
	}

	override public function set width(value:Number):void
	{
		draw(value, height);
	}
	
	override public function set height(value:Number):void
	{
		draw(width, value);
	}

	private function draw(width:Number, height:Number):void
	{
		graphics.clear();
		graphics.beginFill(CodeStyle.buttonDownstateColor, CodeStyle.buttonDownstateAlpha);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		filters = CodeStyle.buttonDownFilters;
	}
}

class ButtonSelectState extends SelectFadeState
{
	public function ButtonSelectState(width:Number, height:Number) 
	{
		super(0, .25);
		
		draw(width, height);
	}

	override public function set width(value:Number):void
	{
		draw(value, height);
	}
	
	override public function set height(value:Number):void
	{
		draw(width, value);
	}

	private function draw(width:Number, height:Number):void
	{
		graphics.clear();
		graphics.beginFill(CodeStyle.buttonSelectstateColor, CodeStyle.buttonSelectstateAlpha);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		filters = CodeStyle.buttonFilters;
	}
}