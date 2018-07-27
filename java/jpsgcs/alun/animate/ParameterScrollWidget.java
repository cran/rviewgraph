package jpsgcs.alun.animate;

import jpsgcs.alun.markov.Parameter;
import java.awt.event.AdjustmentEvent;
import java.awt.event.AdjustmentListener;

public class ParameterScrollWidget extends ScrollWidget
{
	public ParameterScrollWidget(Parameter p)
	{
		super(p.name(), p.max(), p.def());
		par = p;
	}
		
	public void adjustmentValueChanged(AdjustmentEvent e)
	{
		super.adjustmentValueChanged(e);
		if (e != null)
			par.setValue(getRealValue());
	} 

	private Parameter par = null;
}
