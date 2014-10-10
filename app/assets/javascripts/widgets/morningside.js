function renderMorningside(node, path) {
    d3.json(path, function(error, json) {
        var WIDTH = 400, HEIGHT = 400;
        var data = json.json_object.value;
        var maxLinks = data.reduce(function(a, c) { return Math.max(a, c.inlink_cache); }, 0);
        var xScale = d3.scale.linear().domain([0, 1]).range([0, WIDTH]),
            yScale = d3.scale.linear().domain([0, 1]).range([0, HEIGHT]),
            rScale = d3.scale.linear().domain([0, maxLinks]).range([1, 6]).clamp(true),
            colorScale = d3.scale.category20();
            
        var svg = d3.select(node).append('svg').attr('width', WIDTH).attr('height', HEIGHT);

        svg.selectAll('g.node').data(data).enter()
        .append('g')
        .classed('node', true)
        .append('circle')
        .attr('cx', function(d) { return xScale(parseFloat(d.x)); })
        .attr('cy', function(d) { return yScale(parseFloat(d.y)); })
        .attr('r', function(d) { return rScale(d.inlink_cache); })
        .style('fill', function(d) { return colorScale(d.attentive_cluster_id); });
    });
}

$(function() {
  $('.morningside-fetcher').each(function() {
    $this = $( this );
    renderMorningside( $this.find( '.render' )[ 0 ] , $this.data( 'datum-path' ) );
  });
});
