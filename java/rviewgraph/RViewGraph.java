package rviewgraph;

import jpsgcs.alun.graph.Coord;
import jpsgcs.alun.graph.Network;
import jpsgcs.alun.viewgraph.PaintableGraph;
import jpsgcs.alun.viewgraph.StringNode;
import jpsgcs.alun.viewgraph.VertexRepresentation;
import jpsgcs.alun.animate.PaperTypes;

import java.util.Map;
import java.util.LinkedHashMap;
import java.util.Vector;
import java.util.Random;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.PrintJob;
import java.awt.Toolkit;

public class RViewGraph
{
	public static void main(String[] args)
	{
		try 
		{
			Random rand = new Random();

			jpsgcs.alun.util.InputFormatter fin = new jpsgcs.alun.util.InputFormatter();
			
			Vector<Integer> from = new Vector<Integer>();
			Vector<Integer> to = new Vector<Integer>();

			while (fin.newLine())
			{
				from.add(fin.nextInt());
				to.add(fin.nextInt());
			}

			int[] f = new int[from.size()];
			int[] t = new int[to.size()];
			int n = 0;

			for (int i = 0; i<from.size();  i++)
			{
				f[i] = from.get(i).intValue();
				t[i] = to.get(i).intValue();

				if (n < f[i])
					n = f[i];
				if (n < t[i]) 
					n = t[i];
			}

			n++;

			String[] names = new String[n];

			int[] r = new int[n];
			int[] g = new int[n];
			int[] b = new int[n];
			int[] s = new int[n];

			for (int i=0; i<n; i++)
			{
				r[i] = 255;
				g[i] = 255;
				b[i] = 255;
				s[i] = 1;
			}

			double[] x = new double[n];
			double[] y = new double[n];

			for (int i=0; i<names.length; i++)
			{
				names[i] = ""+i;
				x[i] = rand.nextDouble() * 1000 - 500;
				y[i] = rand.nextDouble() * 1000 - 500;
			}
				
			if (java.awt.GraphicsEnvironment.isHeadless())
			{
				System.err.println("\tRViewGraph is an interactive graph viewing program that relies on mouse");
				System.err.println("\tand key input from the user to control the display and edit the graph.");
				System.err.println("\tIt will not, and is not intended to, function in a headless environment");
				System.err.println("\tthat does not support a display device, keyboard or mouse.");
				System.exit(0);
			}

			RViewGraph rvg = new RViewGraph(names.length,names,f,t,r,g,b,s,x,y,false,true);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.exit(1);
		}
	}

	public RViewGraph(int n, String[] vv, int[] fr, int[] to, 
		int[] red, int[] green, int[] blue, int[] shape, 
		double[] x, double[] y, boolean directed, boolean run)
	{
		v = vv;

		Network<Integer,Object> net = new Network<Integer,Object>(directed);
		Map<Integer,VertexRepresentation> map = new LinkedHashMap<Integer,VertexRepresentation>();

		//for (int i=0; i<v.length; i++)
		for (int i=0; i<n; i++)
		{
			net.add(i);
			StringNode nod = new StringNode(v[i]);
			nod.setColor(new Color(red[i],green[i],blue[i]));
			nod.setShape(shape[i]);
			map.put(i,nod);
		}

		for (int i=0; i<fr.length; i++)
			net.connect(fr[i],to[i]);

		g = new PaintableGraph<Integer,Object>(net,map);

		setCoords(x,y);

		rgf = new RGraphFrame();
		rgf.setGraph(g,false,run);
		// A4 landscape
		//int ht = (int) (72/2.54 * 21.0);
		//int wd = (int) (72/2.54 * 29.7);
		// Letter landscape
		int ht = (int) (72*8.5);
		int wd = (int) (72*11);
		rgf.getCanvas().setSize(40+wd,40+ht);
		rgf.pack();
	}

	public void setCoords(double[] x, double[] y)
	{
		for (int i=0; i<v.length; i++)
		{
			Coord p = g.getCoord(i);
			p.x = x[i];
			p.y = y[i];
		}
	}

	public double[] getXCoords()
	{
		double[] x = new double[v.length];
		for (int i=0; i<x.length; i++)
			x[i] = g.getCoord(i).x;
		return x;
	}

	public double[] getYCoords()
	{
		double[] x = new double[v.length];
		for (int i=0; i<x.length; i++)
			x[i] = g.getCoord(i).y;
		return x;
	}

	public void run()
	{
		rgf.run();
	}

	public void stop()
	{
		rgf.stop();
	}

	public void show()
	{
		rgf.myshow();
	}

	public void hide()
	{
		rgf.myhide();
	}

	public void showPaper(int i)
	{
		if (i >= 0 && i <PaperTypes.list.length)
			rgf.getCanvas().setPaper(PaperTypes.list[i]);
	}

	public void hidePaper()
	{
		rgf.getCanvas().setPaper(null);
	}

	public void showAxes()
	{
		rgf.getCanvas().setAxes(true);
	}

	public void hideAxes()
	{
		rgf.getCanvas().setAxes(false);
	}

	public int writePostScript(String s)
	// Can't seem to set the default file name in the screen dump window, but
	// will keep the argument there in case I figure it out.
	{
                Toolkit t = Toolkit.getDefaultToolkit();
                if (t == null)
			return 1;

                PaperTypes p = rgf.getCanvas().getPaper();
                if (p == null)
                        p = PaperTypes.list[1];

                PrintJob j = t.getPrintJob(rgf,"Canvas plot",null,p.getAttributes());

                if (j == null)
			return 2;

                Graphics g = j.getGraphics();
                if (g == null)
			return 3;

                rgf.getCanvas().plot(g);
                g.dispose();
                j.end();

                rgf.getCanvas().repaint();

		return 0;
	}

// Private data.

	private RGraphFrame rgf = null;
	private String[] v = null;
	private PaintableGraph<Integer,Object> g = null;
}
