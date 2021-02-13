/*
 *  This file is part of the DITA-OT Unit Test Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package fox.jason.unittest.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Copy;

// if test.copy.dir is set, make a copy of the expectation file
// This allows us to refresh the test expectations

public class CopyResultTask extends Task {
  /**
   * Field src.
   */
  private String src;

  /**
   * Field dest.
   */
  private String dest;

  /**
   * Creates a new <code>CopyResultTask</code> instance.
   */
  public CopyResultTask() {
    super();
    this.src = null;
    this.dest = null;
  }

  /**
   * Method setSrc.
   *
   * @param src String
   */
  public void setSrc(String src) {
    this.src = src;
  }

  /**
   * Method setDest.
   *
   * @param dest String
   */
  public void setDest(String dest) {
    this.dest = dest;
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    // @param dest - destination of the expecation
    // @param src -  source of the expecation
    if (src == null) {
      throw new BuildException("You must supply a source of the expecation");
    }
    if (dest == null) {
      throw new BuildException(
        "You must supply a destination of the expecation"
      );
    }

    boolean os = "true".equals(getProject().getProperty("test.os.matches"));

    String rootDir = getProject().getProperty("test.root.dir");
    String testCopyDir = getProject().getProperty("test.copy.dir");
    boolean testCopy = "true".equals(getProject().getProperty("test.copy"));

    if (testCopy && os) {
      Copy task = (Copy) getProject().createTask("copy");
      task.setFile(new java.io.File(src));
      task.setTofile(new java.io.File(dest.replace(rootDir, testCopyDir)));
      task.setOverwrite(true);
      task.perform();
    }
  }
}
