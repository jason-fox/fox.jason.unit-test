/*
 *  This file is part of the DITA-OT Unit Test Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package fox.jason.unittest.tasks;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

// Task to check to see which XSL files have been covered.

public class InstrumentationScanTask extends Task {

  /**
   * Field input.
   */
  private String property;

  /**
   * Creates a new <code>InstrumentationScanTask</code> instance.
   */
  public InstrumentationScanTask() {
    super();
    this.property = null;
  }

  /**
   * Method setInput.
   *
   * @param input String
   */
  public void setInput(String input) {
    this.property = input;
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

    String input = getProject().getProperty(property);

    List<String> allMatches = new ArrayList<>();
    Matcher m = Pattern
      .compile("(([\\w|\\.\\-]*:$)|(\\w*:.*\\.xsl))", Pattern.MULTILINE | Pattern.CASE_INSENSITIVE)
      .matcher(input);
    while (m.find()) {
      allMatches.add(m.group());
    }

    getProject().setProperty("dita.ot.instrument", String.join("\n", allMatches));
  }
}
