/*
 *  This file is part of the DITA-OT Unit Test Plug-in project.
 *  See the accompanying LICENSE file for applicable licenses.
 */

package fox.jason.unittest.tasks;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

//  Custom Task to apply some mathematical operations
//  This removes a dependency on the Ant Contrib <math> task.

public class CalculateValueTask extends Task {
  /**
   * Field operand.
   */
  private String operand1;

  /**
   * Field operand2.
   */
  private String operand2;

  /**
   * Field operation.
   */
  private String operation;

  /**
   * Field property.
   */
  private String property;

  /**
   * Creates a new <code>CalculateValueTask</code> instance.
   */
  public CalculateValueTask() {
    super();
    this.operand1 = null;
    this.operand2 = null;
    this.operation = null;
    this.property = null;
  }

  /**
   * Method setOperand1.
   *
   * @param operand1 String
   */
  public void setOperand1(String operand) {
    this.operand1 = operand;
  }

  /**
   * Method setOperand2.
   *
   * @param operand String
   */
  public void setOperand2(String operand) {
    this.operand2 = operand;
  }

  /**
   * Method setOperation.
   *
   * @param operation String
   */
  public void setOperation(String operation) {
    this.operation = operation;
  }

  /**
   * Method setResultProperty.
   *
   * @param property String
   */
  public void setResultProperty(String property) {
    this.property = property;
  }

  /**
   * Method execute.
   *
   * @throws BuildException if something goes wrong
   */
  @Override
  public void execute() {
    // @param operand1 - first operand
    // @param operand2 - second operand
    // @param operation - Mathematical operation to invoke - either subtract or percentage
    // @param resultproperty - the property to set with the result
    if (operand1 == null) {
      throw new BuildException("You must supply a first operand");
    }
    if (operand2 == null) {
      throw new BuildException("You must supply a second operand");
    }
    if (operation == null) {
      throw new BuildException(
        "Mathematical operation to invoke - either subtract or percentage"
      );
    }
    if (property == null) {
      throw new BuildException(
        "You must supply a property to set with the result"
      );
    }

    if ("-".equals(operation)) {
      getProject().setProperty(
        property,
        String.valueOf(Integer.parseInt(operand1) - Integer.parseInt(operand2))
      );
    } else if ("%".equals(operation)) {
      // Percentage, not modulus.
      getProject().setProperty(
        property,
        String.valueOf(
          (Integer.parseInt(operand1) * 100) / Integer.parseInt(operand2)
        )
      );
    }
  }
}
