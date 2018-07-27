package jpsgcs.alun.graph;

import java.util.Collection;

public interface LocatedGraph<V,E> extends Graph<V,E>
{
	public V find(double x, double y);
	public Point getPoint(V v);
	public Collection<Point> getPoints(Collection<V> c);
	public Collection<Point> getPoints(V v);
	public Collection<Point> getPoints();
}
