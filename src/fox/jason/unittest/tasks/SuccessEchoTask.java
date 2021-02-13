/*
 *  This file is part of the DITA-OT Unit Test Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package fox.jason.unittest.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

// This function outputs a colorized success message.

public class SuccessEchoTask extends Task {

  /**
   * Creates a new <code>SuccessEchoTask</code> instance.
   */
  public SuccessEchoTask() {
    super();
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    String escapeCode = Character.toString((char) 27);
    boolean colorize = !"false".equals(getProject().getProperty("cli.color"));
    boolean testCopy = "true".equals(getProject().getProperty("test.copy"));

    String input = testCopy
      ? "[WARN] Updated all test expectations"
      : "[SUCCESS] All tests have passed";
    String ansiColor = testCopy ? "[33m" : "[32m";

    if (colorize) {
      input = escapeCode + ansiColor + input + escapeCode + "[0m";
    }

    getProject().log("", 1);
    getProject().log(input, 1);
  }
}
