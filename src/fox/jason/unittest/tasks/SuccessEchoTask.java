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

  private boolean getUseColor() {
    final String os = System.getProperty("os.name");
    if (os != null && os.startsWith("Windows")) {
      return false;
    } else if (System.getenv("NO_COLOR") != null) {
      return false;
    } else if ("dumb".equals(System.getenv("TERM"))) {
      return false;
    } else if (System.console() == null) {
      return false;
    }
    return !"false".equals(getProject().getProperty("cli.color"));
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    String escapeCode = Character.toString((char) 27);
    boolean testCopy = "true".equals(getProject().getProperty("test.copy"));

    String input = testCopy ? "[WARN] Updated all test expectations" : "[SUCCESS] All tests have passed";
    String ansiColor = testCopy ? "[33m" : "[32m";

    if (getUseColor()) {
      input = escapeCode + ansiColor + input + escapeCode + "[0m";
    }

    getProject().log("", 1);
    getProject().log(input, 1);
  }
}
