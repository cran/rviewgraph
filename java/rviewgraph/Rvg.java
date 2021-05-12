package rviewgraph;

import jpsgcs.alun.graph.Coord;
import jpsgcs.alun.graph.Network;
import jpsgcs.alun.viewgraph.PaintableGraph;
import jpsgcs.alun.viewgraph.StringNode;
import jpsgcs.alun.viewgraph.VertexRepresentation;
import jpsgcs.alun.animate.PaperTypes;

import java.util.Map;
import java.util.LinkedHashMap;
import java.util.Set;
import java.util.Vector;
import java.util.Random;
import java.util.List;
import java.util.LinkedList;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.PrintJob;
import java.awt.Toolkit;

public class Rvg
{
	private Network<Integer,Object> net = null;
	private Map<Integer,VertexRepresentation> map = null;
	private PaintableGraph<Integer,Object> pgr = null;
	private RGraphFrame rgf = null;

	// A4 landscape
	//private int ht = (int) (72/2.54 * 21.0);
	//private int wd = (int) (72/2.54 * 29.7);

	// Letter landscape
	private int ht = (int) (72*8.5);
	private int wd = (int) (72*11);

	public Rvg(boolean directed, boolean running, boolean nogui)
	{
		net = new Network<Integer,Object>(directed);
		map = new LinkedHashMap<Integer,VertexRepresentation>();
		pgr = new PaintableGraph<Integer,Object>(net,map);
		rgf = nogui ? null : new RGraphFrame(pgr,directed,running,wd,ht);
	}

// Methods that change the graph.

	private void add(int i)
	{
		net.add(i);
		double x = wd/2 + (Math.random()-0.5) * wd/2;
		double y = ht/2 + (Math.random()-0.5) * ht/2;
		setCoord(i,x,y);
	}

	public void add(int[] x)
	{
		for (int i : x)
			add(i);
		flash();
	}

	public void remove(int[] x)
	{
		for (int i : x) 
			net.remove(i);
		flash();
	}

	public void connect(int[] x, int[] y)
	{
		for (int i=0; i<x.length; i++)
		{
			if (!net.contains(x[i]))
				add(x[i]);
			if (!net.contains(y[i]))
				add(y[i]);
			net.connect(x[i],y[i]);
		}
		flash();
	}

	public void disconnect(int[] x, int[] y)
	{
		for (int i=0; i<x.length; i++)
			net.disconnect(x[i],y[i]);
		flash();
	}

	public void clear()
	{
		net.clear();
		flash();
	}

// Methods that query the graph.

	public boolean isDirected()
	{
		return net.isDirected();
	}

	public boolean[] contains(int[] id)
	{
		boolean[] b = new boolean[id.length];
		for (int i=0; i<id.length; i++)
			b[i] = net.contains(id[i]);
		return b;
	}

	public int[] neighbours(int x)
	{
		Set<Integer> n = net.getNeighbours(x);
		if (n == null)
			return null;
		int[] a = new int[n.size()];
		int i=0;
		for (Integer y : n)
			a[i++] = y;
		return a;
	}

	public int[] outNeighbours(int x)
	{
		Set<Integer> n = net.outNeighbours(x);
		if (n == null)
			return null;
		int[] a = new int[n.size()];
		int i=0;
		for (Integer y : n)
			a[i++] = y;
		return a;
	}

	public int[] inNeighbours(int x)
	{
		Set<Integer> n = net.inNeighbours(x);
		if (n == null)
			return null;
		int[] a = new int[n.size()];
		int i=0;
		for (Integer y : n)
			a[i++] = y;
		return a;
	}

	public boolean[] connects(int[] x, int[] y)
	{
		boolean[] b = new boolean[x.length];
		for (int i=0; i<x.length; i++)
			b[i] = net.connects(x[i],y[i]);
		return b;
	}

	public int[] getIndexes()
	{
		int[] id = new int[map.size()];
		int i = 0;
		for (Integer k : map.keySet())
			id[i++] = k;
		return id;
	}

	public int[] getVertices()
	{
		int[] b = new int[net.getVertices().size()];
		int i = 0;
		for (Integer k : net.getVertices())
			b[i++] = k;
		return b;
	}

	public int[] getFrom()
	{
		List<Integer> l = new LinkedList<Integer>();
		for (Integer i : net.getVertices())
			for (Integer j : net.outNeighbours(i))
				l.add(i);
		int[] e = new int[l.size()];
		int i = 0;
		for (Integer k : l)
			e[i++] = k;
		return e;
	}

	public int[] getTo()
	{
		List<Integer> l = new LinkedList<Integer>();
		for (Integer i : net.getVertices())
			for (Integer j : net.outNeighbours(i))
				l.add(j);
		int[] e = new int[l.size()];
		int i = 0;
		for (Integer k : l)
			e[i++] = k;
		return e;
	}

// Methods that change the vertex coordinates.

	private void setCoord(int id, double x, double y)
	{
		Coord p = pgr.getCoord(id);
		if (p != null)
		{
			p.x = x;
			p.y = y;
		}
	}

	public void setCoords(int[] id, double[] x, double[] y)
	{
		for (int i=0; i<id.length; i++)
			setCoord(id[i],x[i],y[i]);
	}

// Methods that query the vertex coordinates.

	public double[] getXCoords(int[] id)
	{
		double[] x = new double[id.length];
		for (int i=0; i<id.length; i++)
			x[i] = map.get(id[i]) != null ? pgr.getCoord(id[i]).x : 0;
		return x;
	}

	public double[] getYCoords(int[] id)
	{
		double[] y = new double[id.length];
		for (int i=0; i<id.length; i++)
			y[i] = map.get(id[i]) != null ? pgr.getCoord(id[i]).y : 0;
		return y;
	}

// Methods that change the appearance.

	private StringNode find(int i)
	{
		StringNode nod = (StringNode)map.get(i);
		if (nod == null)
		{
			nod = new StringNode(i+"");
			map.put(i,nod);
		}
		return nod;
	}
	
	public void map(int[] x, String[] v, int[] r, int[] g, int[] b, int[] sh, int[] w, int[] h)
	{
		for (int i = 0; i<x.length; i++)
		{
			StringNode nod = find(x[i]);
			nod.setString(v[i]);
			nod.setColor(new Color(r[i],g[i],b[i]));
			nod.setShape(sh[i]);
			nod.fixSize(w[i],h[i]);
		}
		flash();
	}

	public void name(int[] x, String[] n)
	{
		for (int i=0; i<x.length; i++)
			find(x[i]).setString(n[i]);
		flash();
	}

	public void colour(int[] x, int[] r, int[] g, int[] b)
	{
		for (int i=0; i<x.length; i++)
			find(x[i]).setColor(new Color(r[i],g[i],b[i]));
		flash();
	}

	public void size(int[] x, int[] w, int[] h)
	{
		for (int i=0; i<x.length; i++)
			find(x[i]).fixSize(w[i],h[i]);
		flash();
	}

	public void shape(int[] x, int[] s)
	{
		for (int i=0; i<x.length; i++)
			find(x[i]).setShape(s[i]);
		flash();
	}

	public void clearMap()
	{
		map.clear();
		flash();
	}

// Methods that query the appearance.

	public String[] getNames(int[] id)
	{
		String[] s = new String[id.length];
		for (int i=0; i<id.length; i++)
			s[i] = find(id[i]).getString();
		return s;
	}

	public int[] getRed(int[] id)
	{
		int[] s = new int[id.length];
		for (int i=0; i<id.length; i++)
			s[i] = find(id[i]).getColor().getRed();
		return s;
	}

	public int[] getGreen(int[] id)
	{
		int[] s = new int[id.length];
		for (int i=0; i<id.length; i++)
			s[i] = find(id[i]).getColor().getGreen();
		return s;
	}

	public int[] getBlue(int[] id)
	{
		int[] s = new int[id.length];
		for (int i=0; i<id.length; i++)
			s[i] = find(id[i]).getColor().getBlue();
		return s;
	}

	public int[] getShape(int[] id)
	{
		int[] s = new int[id.length];
		for (int i=0; i<id.length; i++)
			s[i] = find(id[i]).getShape();
		return s;
	}
	
	public int[] getWidth(int[] id)
	{
		int[] s = new int[id.length];
		for (int i=0; i<id.length; i++)
		{
			StringNode v = find(id[i]);
			s[i] = v.isFixedSize() ? v.width() : -1;
		}
		return s;
	}

	public int[] getHeight(int[] id)
	{
		int[] s = new int[id.length];
		for (int i=0; i<id.length; i++)
		{
			StringNode v = find(id[i]);
			s[i] = v.isFixedSize() ? v.height() : -1;
		}
		return s;
	}

// Methods that control the GUI.

	private void flash()
	{
		if (rgf != null)
			rgf.getCanvas().repaint();
	}

	public boolean isRunning()
	{
		return rgf != null && rgf.isRunning();
	}

	public void run()
	{
		if (rgf != null)
		{
			rgf.run();
			flash();
		}
	}

	public void stop()
	{
		if (rgf != null)
		{
			rgf.stop();
			flash();
		}
	}

	public void show()
	{
		if (rgf != null)
		{
			rgf.myshow();
			flash();
		}
	}

	public void hide()
	{
		if (rgf != null)
		{
			rgf.myhide();
			flash();
		}
	}

	public void showPaper(int i)
	{
		if (rgf != null)
		{
			if (i >= 0 && i <PaperTypes.list.length)
				rgf.getCanvas().setPaper(PaperTypes.list[i]);
			flash();
		}
	}

	public void hidePaper()
	{
		if (rgf != null)
		{
			rgf.getCanvas().setPaper(null);
			flash();
		}
	}

	public void showAxes()
	{
		if (rgf != null)
		{
			rgf.getCanvas().setAxes(true);
			flash();
		}
	}

	public void hideAxes()
	{
		if (rgf != null)
		{
			rgf.getCanvas().setAxes(false);
			flash();
		}
	}

// A method to launch a plot dialog box. 

	public int writePostScript()
	{
		if (rgf == null)
			return 0;

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

		flash();

		return 0;
	}
}
