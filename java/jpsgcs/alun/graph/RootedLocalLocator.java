package jpsgcs.alun.graph;

import jpsgcs.alun.util.RadixPlaneSorter;
import java.util.Collection;
import java.util.LinkedHashSet;

public class RootedLocalLocator<V,E> extends LocalLocator<V,E>
{
	public double move(LocatedGraph<V,E> g)
	{
		double delta = 0;
		double d = par[0].getValue();
		double gamma = d*d;
		double alpha = 2*d;
		
		Collection<V> vertices = new LinkedHashSet<V>(g.getVertices());
		RadixPlaneSorter<Point> p = null;
		if (alpha > Double.MIN_VALUE)
		{
			p = new RadixPlaneSorter<Point>(Math.sqrt(gamma),Math.sqrt(gamma),40);
			for (V a : vertices)
				p.add(g.getPoint(a));
		}	
			
		for (V a : vertices)
		{
			Point pa = g.getPoint(a);
			if (!pa.m)
				continue;

			Derivatives D = new Derivatives();
			
			if (p != null)
			{
				p.remove(pa);
				addDerivatives(D, rootedLocalRepulsions(pa,p.getLocal(pa,Math.sqrt(gamma)),gamma), alpha);
			}

			addDerivatives(D, squaredAttractions(pa,g.getPoints(g.getNeighbours(a))), 1);
			delta += update(pa,D);

			if (p != null)
				p.add(pa);
		}

		return delta;
        }
}
