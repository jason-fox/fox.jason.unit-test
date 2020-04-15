/*
 *  This file is part of the DITA-OT Unit Test Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package fox.jason.unittest.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Exit;

// Set a flag if the time limit has been exceeded.

public class CheckTimeLimitTask extends Task {
  /**
   * Field body.
   */
  private String body;
  /**
   * Field message.
   */
  private String message;
  /**
   * Field percentage.
   */
  private String percentage;

  /**
   * Creates a new <code>CheckTimeLimitTask</code> instance.
   */
  public CheckTimeLimitTask() {
    super();
    this.body = "";
    this.message = "";
    this.percentage = null;
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
   * Method setPercentage.
   *
   * @param percentage String
   */
  public void setPercentage(String percentage) {
    this.percentage = percentage;
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    if (percentage == null) {
      throw new BuildException("You must supply an percentage value");
    }
    if (Integer.parseInt(percentage) > 100) {
      getProject().log("", 1);
      getProject().log(message, 1);

      Exit task = (Exit) getProject().createTask("fail");
      task.setMessage(body);

      task.perform();
    }
  }
}
