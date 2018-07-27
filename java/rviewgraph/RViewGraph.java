package rviewgraph;

import jpsgcs.alun.graph.Point;
import jpsgcs.alun.graph.Network;
import jpsgcs.alun.viewgraph.PaintableGraph;
import jpsgcs.alun.viewgraph.StringNode;
import jpsgcs.alun.viewgraph.VertexRepresentation;

import java.util.Map;
import java.util.LinkedHashMap;
import java.awt.Color;

public class RViewGraph extends RGraphFrame
{
	public RViewGraph(String[] vv, int[] f, int[] t, double[] x, double[] y, boolean d, boolean r)
	{
		v = vv;

		Network<String,Object> net = new Network<String,Object>(d);
		Map<String,VertexRepresentation> map = new LinkedHashMap<String,VertexRepresentation>();

		for (int i=0; i<v.length; i++)
		{
			net.add(v[i]);
			map.put(v[i],new StringNode(v[i]));
			map.get(v[i]).setColor(Color.cyan);
		}

		for (int i=0; i<f.length; i++)
			net.connect(v[f[i]],v[t[i]]);

		g = new PaintableGraph<String,Object>(net,map);

		setCoords(x,y);

		setGraph(g,r);
	}

	public void setCoords(double[] x, double[] y)
	{
		for (int i=0; i<v.length; i++)
		{
			Point p = g.getPoint(v[i]);
			p.x = x[i];
			p.y = y[i];
		}
	}

	public double[] getXCoords()
	{
		double[] x = new double[v.length];
		for (int i=0; i<x.length; i++)
			x[i] = g.getPoint(v[i]).x;
		return x;
	}

	public double[] getYCoords()
	{
		double[] x = new double[v.length];
		for (int i=0; i<x.length; i++)
			x[i] = g.getPoint(v[i]).y;
		return x;
	}

// Private data.

	private String[] v = null;
	private PaintableGraph<String,Object> g = null;

}
