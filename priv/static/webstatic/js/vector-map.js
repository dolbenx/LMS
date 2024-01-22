$(function() {
	'use strict';
	$('#vmap').vectorMap({
		map: 'world_en',
		backgroundColor: 'transparent',
		color: '#ffffff',
		hoverOpacity: 0.7,
		selectedColor: '#77778e33',
		enableZoom: true,
		showTooltip: true,
		scaleColors: ['#3C66BF', '#6c4dc5'],
		values: sample_data,
		normalizeFunction: 'polynomial'
	});
	$('#vmap2').vectorMap({
		map: 'usa_en',
		color: '#3C66BF',
		showTooltip: true,
		backgroundColor: 'transparent',
		hoverColor: '#6c4dc5'
	});
	 $('#vmap3').vectorMap({
		map: 'canada_en',
		backgroundColor: null,
		color: '#3C66BF',
		hoverColor: '#6c4dc5',
		enableZoom: false,
		showTooltip: false
	});

});