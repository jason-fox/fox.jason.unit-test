/*
 *  This file is part of the DITA-OT Unit Test Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package fox.jason.unittest.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

// Task to set a given property to the current time of the local machine.
// This allows us to run performance testing.

public class UnixTimestampTask extends Task {
  /**
   * Field property.
   */
  private String property;

  /**
   * Creates a new <code>UnixTimestampTask</code> instance.
   */
  public UnixTimestampTask() {
    super();
    this.property = null;
  }

  /**
   * Method setProperty.
   *
   * @param property String
   */
  public void setProperty(String property) {
    this.property = property;
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    // @param property  - The ant property to set
    if (property == null) {
      throw new BuildException("You must supply an ANT property to set.");
    }
    long nowSeconds = System.currentTimeMillis() / 1000L;
    getProject().setProperty(property, String.valueOf(nowSeconds));
  }
}
