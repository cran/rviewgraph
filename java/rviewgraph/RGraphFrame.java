package rviewgraph;

import jpsgcs.alun.animate.ActiveCanvas;
import jpsgcs.alun.animate.Loop;
import jpsgcs.alun.graph.GraphLocator;
import jpsgcs.alun.graph.RootedLocalLocator;
import jpsgcs.alun.graph.DAGLocator;
import jpsgcs.alun.viewgraph.GraphPanel;
import jpsgcs.alun.viewgraph.PaintableGraph;

import java.awt.Frame;
import java.awt.event.WindowListener;
import java.awt.event.WindowEvent;

public class RGraphFrame extends Frame implements WindowListener
{
	public RGraphFrame()
	{
	}

	public RGraphFrame(PaintableGraph<Integer,Object> g, boolean d, boolean r, int w, int h)
	{
		setGraph(g,d,r);
		getCanvas().setSize(40+w,40+h);
		pack();
	}

	public void setGraph(PaintableGraph<Integer,Object> g, boolean d, boolean r)
	{
		running = r;

		GraphLocator<Integer,Object> loc = new RootedLocalLocator<Integer,Object>();
		if (d)
			loc = new DAGLocator<Integer,Object>();
	
		pan = new GraphPanel<Integer,Object>(g,loc,null,running);
		pan.getCanvas().setCentered(false);
		add(pan);
		pack();
		addWindowListener(this);
		setVisible(true);
	}

/*
	public void setDirected(boolean d)
	{
		if (d)
			pan.setLocator(new DAGLocator<Integer,Object>());
		else
			pan.setLocator(new RootedLocalLocator<Integer,Object>());
	}
*/

	public ActiveCanvas getCanvas()
	{
		return pan.getCanvas();
	}

	public void stop()
	{
		pan.getLoop().stop();
		running = false;
	}

	public void run()
	{
		setVisible(true);
		pan.getLoop().start();
		running = true;
	}

	public boolean isRunning()
	{
		return running;
	}

	public void myshow()
	{
		setVisible(true);
		if (running)
			pan.getLoop().start();
		pan.getCanvas().repaint();
	}

	public void myhide()
	{
		pan.getLoop().stop();
		setVisible(false);
	}

	public void windowClosing(WindowEvent e)
	{
		try
		{
			myhide();
		}
		catch (Throwable t)
		{
			t.printStackTrace();
		}
	}

	public void windowDeiconified(WindowEvent e)
	{
		if (running)
			pan.getLoop().start();
		pan.getCanvas().repaint();
	}

	public void windowIconified(WindowEvent e) 
	{	
		pan.getLoop().stop();
	}

	public void windowOpened(WindowEvent e) 
	{
		if (running)
			pan.getLoop().start();
		pan.getCanvas().repaint();
	}

	public void windowActivated(WindowEvent e) 
	{
		if (running)
			pan.getLoop().start();
		pan.getCanvas().repaint();
	}

	public void windowClosed(WindowEvent e) 
	{ 
		pan.getLoop().stop();
	}

	public void windowDeactivated(WindowEvent e) 
	{ 
	}

// Private data.

	private GraphPanel<Integer,Object> pan = null;
	private boolean running = false;
}
