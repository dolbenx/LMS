$(function() {
    'use strict'


    // ______________ PAGE LOADING
    $("#global-loader").fadeOut("slow");

    // ______________ Card
    const DIV_CARD = 'div.card';

    // ______________ Function for remove card
    $(document).on('click', '[data-bs-toggle="card-remove"]', function(e) {
        let $card = $(this).closest(DIV_CARD);
        $card.remove();
        e.preventDefault();
        return false;
    });

    // ______________ Functions for collapsed card
    $(document).on('click', '[data-bs-toggle="card-collapse"]', function(e) {
        let $card = $(this).closest(DIV_CARD);
        $card.toggleClass('card-collapsed');
        e.preventDefault();
        return false;
    });

    // ______________ Card full screen
    $(document).on('click', '[data-bs-toggle="card-fullscreen"]', function(e) {
        let $card = $(this).closest(DIV_CARD);
        $card.toggleClass('card-fullscreen').removeClass('card-collapsed');
        e.preventDefault();
        return false;
    });

    // ______________Main-navbar
    if (window.matchMedia('(min-width: 992px)').matches) {
        $('.main-navbar .active').removeClass('show');
        $('.main-header-menu .active').removeClass('show');
    }
    $('.main-header .dropdown > a').on('click', function(e) {
        e.preventDefault();
        $(this).parent().toggleClass('show');
        $(this).parent().siblings().removeClass('show');
    });
    $('.mobile-main-header .dropdown > a').on('click', function(e) {
        e.preventDefault();
        $(this).parent().toggleClass('show');
        $(this).parent().siblings().removeClass('show');
    });
    $('.main-navbar .with-sub').on('click', function(e) {
        e.preventDefault();
        $(this).parent().toggleClass('show');
        $(this).parent().siblings().removeClass('show');
    });
    $('.dropdown-menu .main-header-arrow').on('click', function(e) {
        e.preventDefault();
        $(this).closest('.dropdown').removeClass('show');
    });
    $('#mainNavShow').on('click', function(e) {
        e.preventDefault();
        $('body').toggleClass('main-navbar-show');
    });
    $('#mainContentLeftShow').on('click touch', function(e) {
        e.preventDefault();
        $('body').addClass('main-content-left-show');
    });
    $('#mainContentLeftHide').on('click touch', function(e) {
        e.preventDefault();
        $('body').removeClass('main-content-left-show');
    });
    $('#mainContentBodyHide').on('click touch', function(e) {
        e.preventDefault();
        $('body').removeClass('main-content-body-show');
    })
    $('body').append('<div class="main-navbar-backdrop"></div>');
    $('.main-navbar-backdrop').on('click touchstart', function() {
        $('body').removeClass('main-navbar-show');
    });


    // ______________Dropdown menu
    $(document).on('click touchstart', function(e) {
        e.stopPropagation();
        var dropTarg = $(e.target).closest('.main-header .dropdown').length;
        if (!dropTarg) {
            $('.main-header .dropdown').removeClass('show');
        }
        if (window.matchMedia('(min-width: 992px)').matches) {
            var navTarg = $(e.target).closest('.main-navbar .nav-item').length;
            if (!navTarg) {
                $('.main-navbar .show').removeClass('show');
            }
            var menuTarg = $(e.target).closest('.main-header-menu .nav-item').length;
            if (!menuTarg) {
                $('.main-header-menu .show').removeClass('show');
            }
            if ($(e.target).hasClass('main-menu-sub-mega')) {
                $('.main-header-menu .show').removeClass('show');
            }
        } else {
            if (!$(e.target).closest('#mainMenuShow').length) {
                var hm = $(e.target).closest('.main-header-menu').length;
                if (!hm) {
                    $('body').removeClass('main-header-menu-show');
                }
            }
        }
    });

    // ______________MainMenuShow
    $('#mainMenuShow').on('click', function(e) {
        e.preventDefault();
        $('body').toggleClass('main-header-menu-show');
    })
    $('.main-header-menu .with-sub').on('click', function(e) {
        e.preventDefault();
        $(this).parent().toggleClass('show');
        $(this).parent().siblings().removeClass('show');
    })
    $('.main-header-menu-header .close').on('click', function(e) {
        e.preventDefault();
        $('body').removeClass('main-header-menu-show');
    })



    // ______________Popover
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
    var popoverList = popoverTriggerList.map(function(popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl)
    })

    // ______________Tooltip
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function(tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    })


    // ______________Toast
    $(".toast").toast();

    // ______________Back-top-button
    $(window).on("scroll", function(e) {
        if ($(this).scrollTop() > 0) {
            $('#back-to-top').fadeIn('slow');
        } else {
            $('#back-to-top').fadeOut('slow');
        }
    });
    $(document).on("click", "#back-to-top", function(e) {
        $("html, body").animate({
            scrollTop: 0
        }, 0);
        return false;
    });

    // ______________Full screen
    $(document).on("click", ".fullscreen-button", function toggleFullScreen() {
        $('html').addClass('fullscreen');
        if ((document.fullScreenElement !== undefined && document.fullScreenElement === null) || (document.msFullscreenElement !== undefined && document.msFullscreenElement === null) || (document.mozFullScreen !== undefined && !document.mozFullScreen) || (document.webkitIsFullScreen !== undefined && !document.webkitIsFullScreen)) {
            if (document.documentElement.requestFullScreen) {
                document.documentElement.requestFullScreen();
            } else if (document.documentElement.mozRequestFullScreen) {
                document.documentElement.mozRequestFullScreen();
            } else if (document.documentElement.webkitRequestFullScreen) {
                document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
            } else if (document.documentElement.msRequestFullscreen) {
                document.documentElement.msRequestFullscreen();
            }
        } else {
            $('html').removeClass('fullscreen');
            if (document.cancelFullScreen) {
                document.cancelFullScreen();
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
            } else if (document.webkitCancelFullScreen) {
                document.webkitCancelFullScreen();
            } else if (document.msExitFullscreen) {
                document.msExitFullscreen();
            }
        }
    })

    // ______________Cover Image
    $(".cover-image").each(function() {
        var attr = $(this).attr('data-image-src');
        if (typeof attr !== typeof undefined && attr !== false) {
            $(this).css('background', 'url(' + attr + ') center center');
        }
    });


    // ______________Horizontal-menu Active Class
    function addActiveClass(element) {
        if (current === "") {
            if (element.attr('href').indexOf("#") !== -1) {
                element.parents('.main-navbar .nav-item').last().removeClass('active');
                if (element.parents('.main-navbar .nav-sub').length) {
                    element.parents('.main-navbar .nav-sub-item').last().removeClass('active');
                }
            }
        } else {
            if (element.attr('href').indexOf(current) !== -1) {
                element.parents('.main-navbar .nav-item').last().addClass('active');
                if (element.parents('.main-navbar .nav-sub').length) {
                    element.parents('.main-navbar .nav-sub-item').last().addClass('active');
                }
            }
        }
    };
    var current = location.pathname.split("/").slice(-1)[0].replace(/^\/|\/$/g, '');
    $('.main-navbar .nav li a').each(function() {
        var $this = $(this);
        addActiveClass($this);
    });




    // ______________ SWITCHER-toggle ______________//

    /************Theme Layouts************/

    //$('body').addClass('theme-style');
    //$('body').addClass('light-theme');
    //$('body').addClass('dark-theme');

    /*Header Styles*/
    //$('body').addClass('color-header');
    //$('body').addClass('header-dark');

    /*Horizontal-menu Styles*/
    //$('body').addClass('light-horizontal');
    // $('body').addClass('color-horizontal');

    /*Left-menu Styles*/
    //$('body').addClass('light-leftmenu');
    //$('body').addClass('color-leftmenu');

    /*Leftmenu Icon-Style*/
    //$('body').addClass('icon-style');


    /*rtl version */
    //  $('body').addClass('rtl');

    /***********side-menu styles*******************/

    /*closed-sidemenu version */
    //  $('body').addClass('closed');
    //  $('body').addClass('main-sidebar-hide');

    /*hover-submenu1 version */
    //  $('body').addClass('hover-submenu');
    //  $('body').addClass('main-sidebar-hide');

    /*hover-submenu1 version */
    //  $('body').addClass('hover-submenu1');
    //  $('body').addClass('main-sidebar-hide');

    /*icon-overlay version */
    //  $('body').addClass('icon-overlay');
    //  $('body').addClass('main-sidebar-hide');

    /*icon-text version */
    //  $('body').addClass('icon-text');
    //   $('body').addClass('main-sidebar-hide');




});

$(document).ready(function() {
    let bodyiconText = $('body').hasClass('icon-text');
    if (bodyiconText) {
        $('body').addClass('icon-text');
        localStorage.setItem("icon-text", "True");
        $("head link#style").attr("href", $(this));
        // (document.getElementById("style") ? .setAttribute("href", "../../webstatic/plugins/sidemenu/sidemenu2.js"));
    } else {
        $('body').removeClass('icon-text');
        localStorage.setItem("icon-text", "false");
        $("head link#style").attr("href", $(this));
        // (document.getElementById("style") ? .setAttribute("href", "../../webstatic/plugins/sidemenu/sidemenu.js"));
    };
});

$(document).ready(function() {
    let bodyRtl = $('body').hasClass('rtl');
    if (bodyRtl) {
        $('body').addClass('rtl');
        localStorage.setItem("rtl", "True");
        $("head link#style").attr("href", $(this));
        // (document.getElementById("style") ? .setAttribute("href", "../../webstatic/plugins/bootstrap/css/bootstrap.rtl.min.css"));
    } else {
        $('body').removeClass('rtl');
        localStorage.setItem("rtl", "false");
        $("head link#style").attr("href", $(this));
        // (document.getElementById("style") ? .setAttribute("href", "../../webstatic/plugins/bootstrap/css/bootstrap.min.css"));
    };
});

$(document).ready(function() {
    $('.otc-user-lookup').on('input', function() {
        if ($('#identification_id').val() == "") {
            return false;
        }
        $.ajax({
            url: '/cutomer/over/counter/lookup',
            type: 'post',
            data: {
                "meansOfIdentificationNumber": $('#identification_id').val(),
                "_csrf_token": $("#csrf").val()
            },
            success: function(result) {
                if (result.data.length < 1) {

                    return false
                } else {
                    capa = result.data[0];
                    console.log("capa");
                    console.log(capa);
                    var identification = capa.meansOfIdentificationNumber;
                    var id_means = capa.meansOfIdentificationType;
                    var id_gender = capa.gender;
                    var first_name_id = capa.firstname;
                    var last_name_id = capa.lastname;
                    var other_name_id = capa.othername;
                    var dob_id = capa.dateOfBirth;
                    var mobile_id = capa.mobileNumber;
                    var email_id = capa.emailAddress;
                    var user_id = capa.userId;

                    $('#identification_id').val(identification);
                    $('#id_means').val(id_means).prop('disabled', true);
                    $('#id_gender').val(id_gender).prop('disabled', true);
                    $('#first_name_id').val(first_name_id).prop('disabled', true);
                    $('#last_name_id').val(last_name_id).prop('disabled', true);
                    $('#other_name_id').val(other_name_id).prop('disabled', true);
                    $('#dob_id').val(dob_id).prop('disabled', true);
                    $('#mobile_id').val(mobile_id).prop('disabled', true);
                    $('#email_id').val(email_id).prop('disabled', true);
                    $('#user_id').val(user_id).prop('disabled', true);

                }

            },
            error: function(request, msg, error) {
                $('.loading').hide();
            }
        });
    });
});



$(document).ready(function() {
    $('.otc-product-lookup').on('change', function() {
        if ($('#product_id').val() == "") {
            return false;
        }
        $.ajax({
            url: '/product/over/counter/lookup',
            type: 'post',
            data: {
                "product_id": $('#product_id').val(),
                "_csrf_token": $("#csrf").val()
            },
            success: function(result) {
                if (result.data.length < 1) {

                    return false
                } else {
                    capa = result.data[0];
                    console.log("capa");
                    console.log(capa);
                    var product_id = capa.product_id;
                    var product_code = capa.product_code;
                    var max_amount = capa.max_amount;
                    var min_amount = capa.min_amount;
                    var product_type = capa.product_type;
                    var period_type = capa.period_type;
                    var currency_name = capa.currency_name;

                    $('#product_id').val(product_id);
                    $('#product_code').val(product_code).prop('disabled', true);
                    $('#max_amount').val(max_amount).prop('disabled', true);
                    $('#min_amount').val(min_amount).prop('disabled', true);
                    $('#product_type').val(product_type).prop('disabled', true);
                    $('#period_type').val(period_type).prop('disabled', true);
                    $('#currency_name').val(currency_name).prop('disabled', true);


                }

            },
            error: function(request, msg, error) {
                $('.loading').hide();
            }
        });
    });
});


$(document).ready(function() {

    $('#disbursement').on('change', function() {
        $('#identification-summary-id').val($('#identification_id').val()).prop('readonly', true);
        $('#id-means-summary').val($('#id_means').val()).prop('readonly', true);
        $('#first-name-summary').val($('#first_name_id').val()).prop('readonly', true);
        $('#other-name-summary').val($('#other_name_id').val()).prop('readonly', true);
        $('#last-name-summary').val($('#last_name_id').val()).prop('readonly', true);
        $('#gender-summary').val($('#id_gender').val()).prop('readonly', true);
        $('#dob-summary').val($('#dob_id').val()).prop('readonly', true);
        $('#mobile-summary').val($('#mobile_id').val()).prop('readonly', true);
        $('#email-summary').val($('#email_id').val()).prop('readonly', true);
        $('#product-name-summary').val($('#product_id').val()).prop('readonly', true);
        $('#product-code-summary').val($('#product_code').val()).prop('readonly', true);
        $('#product-type-summary').val($('#product_type').val()).prop('readonly', true);
        $('#currency-summary').val($('#currency_name').val()).prop('readonly', true);
        $('#min-amount-summary').val($('#min_amount').val()).prop('readonly', true);
        $('#max-amount-summary').val($('#max_amount').val()).prop('readonly', true);
        $('#repayment-type-summary').val($('#repayment_type').val()).prop('readonly', true);
        $('#disbursement-summary').val($('#disbursement').val()).prop('readonly', true);
        $('#amount-summary').val($('#amount_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);


    });
});




$(document).ready(function() {

    $('#product_id').on('change', function() {
        $('#identification-data-id').val($('#identification_id').val()).prop('readonly', true);
        $('#id-means-summary').val($('#id_means').val()).prop('readonly', true);
        $('#first-name-data').val($('#first_name_id').val()).prop('readonly', true);
        $('#other-name-data').val($('#other_name_id').val()).prop('readonly', true);
        $('#last-name-data').val($('#last_name_id').val()).prop('readonly', true);
        $('#gender-data').val($('#id_gender').val()).prop('readonly', true);
        $('#dob-data').val($('#dob_id').val()).prop('readonly', true);
        $('#mobile-data').val($('#mobile_id').val()).prop('readonly', true);
        $('#email-data').val($('#email_id').val()).prop('readonly', true);
        $('#product-name-data').val($('#product_id').val()).prop('readonly', true);
        $('#product-code-data').val($('#product_code').val()).prop('readonly', true);
        $('#product-type-data').val($('#product_type').val()).prop('readonly', true);
        $('#currency-data').val($('#currency_name').val()).prop('readonly', true);
        $('#min-amount-data').val($('#min_amount').val()).prop('readonly', true);
        $('#max-amount-data').val($('#max_amount').val()).prop('readonly', true);
        $('#repayment-type-data').val($('#repayment_type').val()).prop('readonly', true);
        $('#disbursement-data').val($('#disbursement').val()).prop('readonly', true);
        $('#amount-data').val($('#amount_id').val()).prop('readonly', true);
        $('#user-id-data').val($('#user_id').val()).prop('readonly', true);


    });
});






// $('#identification-summary-id').val($('#identification_id').val());
//         alert("Teddy")