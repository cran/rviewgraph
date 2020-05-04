package rviewgraph;

import jpsgcs.alun.graph.Coord;
import jpsgcs.alun.graph.Network;
import jpsgcs.alun.viewgraph.PaintableGraph;
import jpsgcs.alun.viewgraph.StringNode;
import jpsgcs.alun.viewgraph.VertexRepresentation;

import java.util.Map;
import java.util.LinkedHashMap;
import java.util.Vector;
import java.util.Random;
import java.awt.Color;

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

			RViewGraph rvg = new RViewGraph(names,f,t,x,y,false,true);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.exit(1);
		}
	}

	public RViewGraph(String[] vv, int[] f, int[] t, double[] x, double[] y, boolean d, boolean r)
	{
		v = vv;

		Network<String,Object> net = new Network<String,Object>(d);
		Map<String,VertexRepresentation> map = new LinkedHashMap<String,VertexRepresentation>();

		for (int i=0; i<v.length; i++)
		{
			net.add(v[i]);
			map.put(v[i],new StringNode(v[i]));
			map.get(v[i]).setColor(Color.yellow);
		}

		for (int i=0; i<f.length; i++)
			net.connect(v[f[i]],v[t[i]]);

		g = new PaintableGraph<String,Object>(net,map);

		setCoords(x,y);

		rgf = new RGraphFrame();
		rgf.setGraph(g,r);
	}

	public void setCoords(double[] x, double[] y)
	{
		for (int i=0; i<v.length; i++)
		{
			Coord p = g.getCoord(v[i]);
			p.x = x[i];
			p.y = y[i];
		}
	}

	public double[] getXCoords()
	{
		double[] x = new double[v.length];
		for (int i=0; i<x.length; i++)
			x[i] = g.getCoord(v[i]).x;
		return x;
	}

	public double[] getYCoords()
	{
		double[] x = new double[v.length];
		for (int i=0; i<x.length; i++)
			x[i] = g.getCoord(v[i]).y;
		return x;
	}

// Private data.

	private RGraphFrame rgf = null;
	private String[] v = null;
	private PaintableGraph<String,Object> g = null;
}
