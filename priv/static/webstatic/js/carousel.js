(function($) {
	
	var owl = $('.owl-carousel-icons2');
	owl.owlCarousel({
		loop: false,
		rewind: false,
		margin: 25,
		animateIn: 'fadeInDowm',
		animateOut: 'fadeOutDown',
		autoplay: false,
		autoplayTimeout: 5000, // set value to change speed
		autoplayHoverPause: true,
		dots: false,
		nav: true,
		autoplay: true,
		responsiveClass: true,
		responsive: {
			0: {
				items: 1,
				nav: true
			},
			600: {
				items: 2,
				nav: true
			},
			1300: {
				items: 4,
				nav: true
			}
		}
	});
	owlRtl();
	
})(jQuery);

function owlRtl(){
	var carousel = $('.rtl .owl-carousel');
			$.each(carousel ,function( index, element)  {
			var carouselData = $(element).data('owl.carousel');
			carouselData.settings.rtl = true; //don't know if both are necessary
			carouselData.options.rtl = true;
			$(element).trigger('refresh.owl.carousel');
			});
};

// If RTL calss added dynamically

$(document).ready (function(){
	let bodyRtl = $('body').hasClass('rtl');
	if (bodyRtl) {
		owlRtl();
	}
});