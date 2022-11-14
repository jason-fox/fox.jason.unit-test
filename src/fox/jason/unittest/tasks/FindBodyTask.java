/*
 *  This file is part of the DITA-OT Unit Test Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package fox.jason.unittest.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

// Task to extract the string between <article> tags.

public class FindBodyTask extends Task {

  /**
   * Creates a new <code>FindBodyTask</code> instance.
   */
  public FindBodyTask() {
    super();
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    String input = getProject().getProperty("htmlSource");
    int start = input.indexOf("<body");
    int end = input.indexOf("</body>") + 7;
    getProject().setProperty("fragment", input.substring(start, end));
  }
}
