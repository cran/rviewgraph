## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(rviewgraph)

oldgui = rViewGraph(sample(1:10,10,TRUE),sample(1:10,10,TRUE))
is.null(oldgui)
if (interactive() && !is.null(oldgui))
{
	oldgui.stop()
	oldgui.hide()
}

v = vg()
is.null(v)

## ----prob---------------------------------------------------------------------
edges = function(g)
{
	dim(g$getEdges())[1] / 2
}

logProb = function(g,a)
{
	-edges(g)*a
}

## ----flip---------------------------------------------------------------------
flip = function(g,x,y)
{
	if (g$connects(x,y))
		g$disconnect(x,y)
	else
		g$connect(x,y)
}

## ----step---------------------------------------------------------------------
step = function(g, a, t = 1)
{
	# Find the probability of the current graph.
	delta = logProb(g,a)

	# Choose a pair of random vertices to flip, and display them.
	x = sample(g$getVertices(),2,replace=FALSE)
	g$colour(x,"red")
	Sys.sleep(t/3)
	
	# Then make the flip.
	flip(g,x[1],x[2])
	Sys.sleep(t/3)

	# Find the ratio of the probabilities of the proposed new graph
	# and the previous incumbent.
	delta = logProb(g,a) - delta

	# Then with probability equal to the minimum of 1 and this ratio 
	# accept the new graph by doing nothing, otherwise reject it by 
	# undoing the flip.
	if (log(runif(1)) > delta)
		flip(g,x[1],x[2])

	# Reset the colours, and pause before the next step.
	g$colour(x)
	Sys.sleep(t/3)
}

## -----------------------------------------------------------------------------
	# To make the simulation reproducible.
	set.seed(1)

	n = 20
	v$add(1:n)

	pen = 0

	if (interactive())
	{
		wait = 1
		s = 50
	} else
	{
		wait = 0
		s = 1000
		for (i in 1:s)
			step(v,pen,wait)
	}

	medge = 0
	for (i in 1:s)
	{
		step(v,pen,wait)
		medge = medge + edges(v)
	}
	c(medge/s, n*(n-1)/4)

## -----------------------------------------------------------------------------
	pen = 1
	medge = 0
	for (i in 1:s)
	{
		step(v,pen,wait)
		medge = medge + edges(v)
	}
	medge/s

## -----------------------------------------------------------------------------
	pen = -1
	medge = 0
	for (i in 1:s)
	{
		step(v,pen,wait)
		medge = medge + edges(v)
	}
	medge/s

