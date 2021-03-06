/**
 * @exampleText
 * 
 * <a name="CodeCollapseButton"></a>
 * <h1>CodeCollapseButton</h1>
 * 
 * <p>This is an example of the <a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/doc/temple/codecomponents/buttons/CodeCollapseButton.html">CodeCollapseButton</a>.</p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeCollapseButtonExample.swf" target="_blank">View this example</a></p>
 * 
 * <p><a href="http://templelibrary.googlecode.com/svn/trunk/modules/codecomponents/examples/temple/codecomponents/buttons/CodeCollapseButtonExample.as" target="_blank">View source</a></p>
 */
package
{
	import temple.codecomponents.buttons.CodeCollapseButton;

	[SWF(backgroundColor="#BBBBBB", frameRate="31", width="640", height="480")]
	public class CodeCollapseButtonExample extends DocumentClassExample
	{
		public function CodeCollapseButtonExample()
		{
			super("Temple - CodeCollapseButtonExample");
			
			addChild(new CodeCollapseButton(14, 14, 10, 10));
			addChild(new CodeCollapseButton(20, 20, 30, 10));
			addChild(new CodeCollapseButton(100, 30, 10, 40));
		}
	}
}
