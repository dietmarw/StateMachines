within ;
package TapChanger
  model TCULState
    parameter Integer method=1 "Method number";
    parameter Real n=1 "Transformer Ratio";
    parameter Real stepsize=0.01 "Step Size";
    parameter Integer mintap=-12 "Minimum tap step";
    parameter Integer maxtap=12 "Maximum tap step";
    parameter Modelica.SIunits.Duration Tm0=10 "Mechanical Time Delay";
    parameter Modelica.SIunits.Duration Td0=20 "Controller Time Delay 1";
    parameter Modelica.SIunits.Duration Td1=20 "Controller Time Delay 2";
    parameter Modelica.SIunits.PerUnit DB=0.03
      "TCUL Voltage Deadband (double-sided)";
    parameter Modelica.SIunits.PerUnit Vref=1 "TCUL Voltage Reference";
    parameter Modelica.SIunits.PerUnit Vblock=0.82 "Tap locking voltage";
    parameter Boolean InitByVoltage=false "Initialize to V=Vref?";
    Real tappos(start=(n - 1)/stepsize) "Current tap step [number]";
    Modelica.SIunits.Time upcounter(start=-10, fixed=true);
    Modelica.SIunits.Time downcounter(start=-10, fixed=true);
    Modelica.SIunits.Time Td;
    Modelica.SIunits.Time Tm;

    parameter Real udev=0.1 "Transformer Ratio";

    model Wait1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end Wait1;
    Wait1 wait1 annotation (Placement(transformation(extent={{-10,60},{10,80}})));
    model CountDown1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end CountDown1;

    model ActionDown1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end ActionDown1;
    ActionDown1 actionDown1
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    CountDown1 countDown1
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    CountUp1 countUp1
      annotation (Placement(transformation(extent={{-42,20},{-22,40}})));
    ActionUp1 actionUp1
      annotation (Placement(transformation(extent={{-42,-20},{-22,0}})));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
    model CountUp1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end CountUp1;

    model ActionUp1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end ActionUp1;
  equation
    if method == 1 then
       Td = Td0;
       Tm = Tm0;
    end if;

    transition(
      countDown1,
      actionDown1,(time - downcounter) > Td,
      immediate=true,
      reset=true,
      synchronize=false,
      priority=2) annotation (Line(
        points={{30,18},{30,2}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      countDown1,
      wait1,
      not ((udev > DB/2) and (tappos > mintap)),
      priority=1,
      immediate=true,
      reset=true,
      synchronize=false) annotation (Line(
        points={{42,28},{58,28},{58,76},{46,76},{34,76},{12,76}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{4,4},{4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Left));
    transition(
      actionDown1,
      wait1,(time - downcounter) > (Td + Tm),immediate=true,reset=true,
      synchronize=false,priority=1) annotation (Line(
        points={{32,-22},{32,-40},{8,-40},{8,58}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{4,-4},{4,-10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Left));
    transition(
      wait1,
      countUp1,(udev < -DB/2) and (tappos < maxtap),
      priority=2,immediate=true,reset=true,synchronize=false)
                  annotation (Line(
        points={{-12,68},{-32,68},{-32,42}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      countUp1,
      actionUp1,(time - upcounter) > Td,
      priority=2,immediate=true,reset=true,synchronize=false)
                  annotation (Line(
        points={{-32,18},{-32,2}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      countUp1,
      wait1,
      not ((udev < -DB/2) and (tappos < maxtap))) annotation (Line(
        points={{-44,28},{-60,28},{-60,76},{-12,76}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      wait1,
      countDown1,(udev > DB/2) and (tappos > mintap),immediate=true,reset=true,
      synchronize=false,priority=1)    annotation (Line(
        points={{12,68},{32,68},{32,42}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      actionUp1,
      wait1,(time - upcounter) > (Td + Tm),immediate=true,reset=true,
      synchronize=false,priority=1)
                                  annotation (Line(
        points={{-32,-22},{-32,-34},{-32,-42},{-4,-42},{-4,58}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{4,-4},{4,-10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Left));
    initialState(wait1) annotation (Line(
        points={{0,82},{0,96},{8,96}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier,
        arrow={Arrow.Filled,Arrow.None}));
  end TCULState;

  model TCULStateTest
    parameter Integer method=1 "Method number";
    parameter Real n=1 "Transformer Ratio";
    parameter Real stepsize=0.01 "Step Size";
    parameter Integer mintap=-12 "Minimum tap step";
    parameter Integer maxtap=12 "Maximum tap step";
    parameter Modelica.SIunits.Duration Tm0=10 "Mechanical Time Delay";
    parameter Modelica.SIunits.Duration Td0=20 "Controller Time Delay 1";
    parameter Modelica.SIunits.Duration Td1=20 "Controller Time Delay 2";
    parameter Modelica.SIunits.PerUnit DB=0.03
      "TCUL Voltage Deadband (double-sided)";
    parameter Modelica.SIunits.PerUnit Vref=1 "TCUL Voltage Reference";
    parameter Modelica.SIunits.PerUnit Vblock=0.82 "Tap locking voltage";
    parameter Boolean InitByVoltage=false "Initialize to V=Vref?";
    Real tappos(start=(n - 1)/stepsize) "Current tap step [number]";
    Modelica.SIunits.Time upcounter(start=-10, fixed=true);
    Modelica.SIunits.Time downcounter(start=-10, fixed=true);
    Modelica.SIunits.Time Td;
    Modelica.SIunits.Time Tm;

    parameter Real udev=0.1 "Transformer Ratio";

    model Wait1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end Wait1;
    Wait1 wait1 annotation (Placement(transformation(extent={{-10,60},{10,80}})));
    model CountDown1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end CountDown1;

    model ActionDown1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end ActionDown1;
    ActionDown1 actionDown1
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    CountDown1 countDown1
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    CountUp1 countUp1
      annotation (Placement(transformation(extent={{-42,20},{-22,40}})));
    ActionUp1 actionUp1
      annotation (Placement(transformation(extent={{-42,-20},{-22,0}})));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
    model CountUp1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end CountUp1;

    model ActionUp1

      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end ActionUp1;
  equation
  //   if method == 1 then
  //      Td = Td0;
  //      Tm = Tm0;
  //   end if;

    transition(
      countDown1,
      actionDown1,time > 3,
      immediate=true,
      reset=true,
      synchronize=false,
      priority=2) annotation (Line(
        points={{30,18},{30,2}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      countDown1,
      wait1,time > 2,
      priority=1,
      immediate=true,
      reset=true,
      synchronize=false) annotation (Line(
        points={{42,28},{58,28},{58,76},{46,76},{34,76},{12,76}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{4,4},{4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Left));
    transition(
      actionDown1,
      wait1,time > 4,immediate=true,reset=true,synchronize=false,priority=1)
                                    annotation (Line(
        points={{32,-22},{34,-40},{8,-40},{8,58}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{4,-4},{4,-10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Left));
    transition(
      wait1,
      countUp1,time > 5,
      priority=2,immediate=true,reset=true,synchronize=false)
                  annotation (Line(
        points={{-12,68},{-32,68},{-32,42}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      countUp1,
      actionUp1,time > 6,
      priority=2,immediate=true,reset=true,synchronize=false)
                  annotation (Line(
        points={{-32,18},{-32,2}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      countUp1,
      wait1,time > 7,immediate=true,reset=true,synchronize=false,priority=1)
                                                  annotation (Line(
        points={{-44,28},{-60,28},{-60,76},{-12,76}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      wait1,
      countDown1,time > 1,immediate=true,reset=true,synchronize=false,priority=1)
                                       annotation (Line(
        points={{12,68},{32,68},{32,42}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      actionUp1,
      wait1,time > 8,immediate=true,reset=true,synchronize=false,priority=1)
                                  annotation (Line(
        points={{-32,-22},{-32,-34},{-32,-42},{-4,-42},{-4,58}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{4,-4},{4,-10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Left));
    initialState(wait1) annotation (Line(
        points={{0,82},{0,96},{8,96}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier,
        arrow={Arrow.Filled,Arrow.None}));
  end TCULStateTest;

  model TCULStateTest2
    parameter Integer method=1 "Method number";
    parameter Real n=1 "Transformer Ratio";
    parameter Real stepsize=0.01 "Step Size";
    parameter Integer mintap=-12 "Minimum tap step";
    parameter Integer maxtap=12 "Maximum tap step";
    parameter Modelica.SIunits.Duration Tm0=10 "Mechanical Time Delay";
    parameter Modelica.SIunits.Duration Td0=20 "Controller Time Delay 1";
    parameter Modelica.SIunits.Duration Td1=20 "Controller Time Delay 2";
    parameter Modelica.SIunits.PerUnit DB=0.03
      "TCUL Voltage Deadband (double-sided)";
    parameter Modelica.SIunits.PerUnit Vref=1 "TCUL Voltage Reference";
    parameter Modelica.SIunits.PerUnit Vblock=0.82 "Tap locking voltage";
    parameter Boolean InitByVoltage=false "Initialize to V=Vref?";
    Real tappos(start=(n - 1)/stepsize) "Current tap step [number]";
    Modelica.SIunits.Time upcounter(start=-10, fixed=true);
    Modelica.SIunits.Time downcounter(start=-10, fixed=true);
    Modelica.SIunits.Time Td;
    Modelica.SIunits.Time Tm;

    parameter Real udev=0.1 "Transformer Ratio";


    Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=DB/2)
      annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
    Modelica.Blocks.Interfaces.RealInput u1 "Connector of Boolean input signal"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Interfaces.RealInput u2 "Connector of Boolean input signal"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Math.Feedback feedback
      annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=Vref)
      annotation (Placement(transformation(extent={{-94,30},{-74,50}})));
    Modelica.Blocks.Logical.And and2
      annotation (Placement(transformation(extent={{0,34},{20,54}})));
    Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=mintap)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    Modelica.Blocks.Sources.RealExpression realExpression1(y=tappos)
      annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
    Modelica.Blocks.Logical.Timer timer
      annotation (Placement(transformation(extent={{40,40},{60,60}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{0,60},{20,80}})));
    Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
      annotation (Placement(transformation(extent={{-14,-28},{6,-8}})));
    Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold=Td +
          downcounter)
      annotation (Placement(transformation(extent={{80,40},{100,60}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{120,-10},{140,10}})));
    Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
      annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  equation
    connect(u1, feedback.u1) annotation (Line(
        points={{-120,60},{-68,60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(realExpression.y, feedback.u2) annotation (Line(
        points={{-73,40},{-60,40},{-60,52}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(greaterThreshold.u, feedback.y) annotation (Line(
        points={{-42,60},{-51,60}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(and2.u1, greaterThreshold.y) annotation (Line(
        points={{-2,44},{-12,44},{-12,60},{-19,60}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(greaterThreshold1.y, and2.u2) annotation (Line(
        points={{-19,30},{-14,30},{-14,36},{-2,36}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(realExpression1.y, greaterThreshold1.u) annotation (Line(
        points={{-49,30},{-42,30}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(and2.y, timer.u) annotation (Line(
        points={{21,44},{32,44},{32,50},{38,50}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(not1.u, greaterThreshold.y) annotation (Line(
        points={{-2,70},{-12,70},{-12,60},{-19,60}},
        color={255,0,255},
        smooth=Smooth.None));
    connect(timer.y, greaterThreshold2.u) annotation (Line(
        points={{61,50},{78,50}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(switch1.y, y) annotation (Line(
        points={{141,0},{170,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(greaterThreshold2.y, switch1.u2) annotation (Line(
        points={{101,50},{102,50},{102,50},{100,50},{110,50},{110,0},{118,0}},
        color={255,0,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{160,100}}), graphics), Icon(coordinateSystem(extent={{-100,
              -100},{160,100}})));

  //   if method == 1 then
  //      Td = Td0;
  //      Tm = Tm0;
  //   end if;

  end TCULStateTest2;
  annotation (uses(Modelica(version="3.2.1")));
  model Test

    inner Integer i( start=0);
    model State1
      outer output Integer i;
    equation

      i = previous(i)+2;
      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end State1;
    State1 state1
      annotation (Placement(transformation(extent={{-62,42},{-42,62}})));
    model State2
     outer output Integer i;
    equation

      i = previous(i)-1;
      annotation (
        Icon(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%name")}),
        Diagram(graphics={Text(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              textString="%stateName",
              fontSize=10)}),
        __Dymola_state=true,
        showDiagram=true,
        singleInstance=true);
    end State2;
    State2 state2
      annotation (Placement(transformation(extent={{-60,-8},{-40,12}})));
  equation
    transition(
      state1,
      state2,i > 10,
      immediate=false,
      reset=true,
      synchronize=false,
      priority=1) annotation (Line(
        points={{-50,40},{-50,14}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,-4},{-4,-10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    transition(
      state2,
      state1,i < 1,immediate=false,reset=true,synchronize=false,priority=1)
                annotation (Line(
        points={{-50,-10},{-14,-46},{14,34},{-40,52},{-40,54}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier), Text(
        string="%condition",
        extent={{-4,4},{-4,10}},
        lineColor={95,95,95},
        fontSize=10,
        textStyle={TextStyle.Bold},
        horizontalAlignment=TextAlignment.Right));
    initialState(state1) annotation (Line(
        points={{-48,64},{-52,82}},
        color={175,175,175},
        thickness=0.25,
        smooth=Smooth.Bezier,
        arrow={Arrow.Filled,Arrow.None}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end Test;
end TapChanger;
