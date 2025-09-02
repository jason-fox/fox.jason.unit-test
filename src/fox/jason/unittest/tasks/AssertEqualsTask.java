/*
 *  This file is part of the DITA-OT Unit Test Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package fox.jason.unittest.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Exit;

//  Custom  task to invoke a conditional <fail>.

public class AssertEqualsTask extends Task {

  /**
   * Field body.
   */
  private String body;
  /**
   * Field message.
   */
  private String message;
  /**
   * Field arg1.
   */
  private String arg1;
  /**
   * Field arg2.
   */
  private String arg2;

  /**
   * Creates a new <code>AssertEqualsTask</code> instance.
   */
  public AssertEqualsTask() {
    super();
    this.body = "";
    this.message = "";
    this.arg1 = null;
    this.arg2 = null;
  }

  /**
   * Method setBody.
   *
   * @param body String
   */
  public void setBody(String body) {
    this.body = body;
  }

  /**
   * Method setMessage.
   *
   * @param message String
   */
  public void setMessage(String message) {
    this.message = message;
  }

  /**
   * Method setArg1.
   *
   * @param arg1 String
   */
  public void setArg1(String arg1) {
    this.arg1 = arg1;
  }

  /**
   * Method setArg2.
   *
   * @param arg2 String
   */
  public void setArg2(String arg2) {
    this.arg2 = arg2;
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
    //  @param arg1 - first argument for comparison
    //  @param arg2 - second argument for comparison
    // @param body - detail of the error message
    //  @param message - short text description of the error
    if (arg1 == null) {
      throw new BuildException("You must supply a first argument for comparison");
    }
    if (arg2 == null) {
      throw new BuildException("You must supply a second argument for comparison");
    }

    boolean os = "true".equals(getProject().getProperty("test.os.matches"));

    if (os && !arg1.equals(arg2)) {
      String escapeCode = Character.toString((char) 27);

      if (getUseColor()) {
        message = escapeCode + "[31m" + message + escapeCode + "[0m";
      }
      getProject().log("", 1);
      getProject().log(message, 1);

      Exit task = (Exit) getProject().createTask("fail");
      task.setMessage(body);

      task.perform();
    }
  }
}
