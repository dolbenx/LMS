//approve staff
$('#dt-basic-example').on('click', '.js-sweetalert2-client_enable_staff', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to Approve this Staff!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Client/Staff/Approve',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//decline client staff
$('#dt-basic-example').on('click', '.js-sweetalert2-client_decline_staff', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to decline this Staff!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Client/Staff/Decline',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});


//disable Company record
$('#dt-company').on('click', '.js-sweetalert2-disable_company', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to disable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Companies/disable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Enable Company record
$('#dt-company').on('click', '.js-sweetalert2-enable_company', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to enable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Companies/enable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 1) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//disable Product record
$('#dt-product').on('click', '.js-sweetalert2-disable_product', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to disable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/products/disable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Enable Product record
$('#dt-product').on('click', '.js-sweetalert2-enable_product', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to enable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/products/enable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 1) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//disable Staff record
$('#dt-staff').on('click', '.js-sweetalert2-disable_staff', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to disable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/staff/disable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Enable Staff record
$('#dt-staff').on('click', '.js-sweetalert2-enable_staff', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to enable this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/staff/enable',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 1) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});


//Approve Company 
$('#dt-company').on('click', '.js-sweetalert2-approve_company', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to approve!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Companies/approve',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Reject Company
$('#dt-company').on('click', '.js-sweetalert2-reject_company', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to reject!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Companies/reject',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 1) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Approve Product 
$('#dt-product').on('click', '.js-sweetalert2-approve_product', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to approve!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/products/approve',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Reject product
$('#dt-product').on('click', '.js-sweetalert2-reject_product', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to reject!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/products/reject',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 1) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

//Approve staff 
// $('#dt-staff').on('click', '.js-sweetalert2-approve_staff_1', function(e) {
//     alert('Russ')
//     e.preventDefault();
//     var button = $(this);
//     // prompt("Are you sure")
//     Swal.fire({
//         title: 'Are sure you?',
//         text: "You want to approve!",
//         type: "warning",
//         showCancelButton: true,
//         confirmButtonColor: '#23b05d',
//         cancelButtonColor: '#d33',
//         confirmButtonText: 'Yes!',
//         showLoaderOnConfirm: true
//     }).then((result) => {
//         if (result.value) {
//             $.ajax({
//                 url: '/staff/approve',
//                 type: 'POST',
//                 data: { id: button.attr("data-id"), _csrf_token: $("#csrf").val() },
//                 success: function(result) {
//                     console.log(result);
//                     if (result.status === 0) {
//                         Swal.fire(
//                             'Success',
//                             result.message,
//                             'success'
//                         ).then(() => {
//                             location.reload(true);
//                             spinner.hide();
//                         });
//                     } else {
//                         Swal.fire(
//                             'Error',
//                             result.message,
//                             'error'
//                         )
//                     }
//                 },
//                 error: function(request, msg, error) {
//                     Swal.fire(
//                         'Oops..',
//                         error,
//                         'error'
//                     )
//                 },
//             });
//         } else {
//             Swal.fire(
//                 'error',
//                 'Operation not performed :)',
//                 'error'
//             )
//         }
//     });
// });


//Activate_system_user
$('#dataTable1').on('click', '.js-sweetalert2-activate_sys_user', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to activate this record!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Activate/Syst_User',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#_csrf_token").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});




//Reject _system_user
$('#dataTable1').on('click', '.js-sweetalert2-reject_sys_user', function(e) {
    e.preventDefault();
    var button = $(this);
    // prompt("Are you sure")
    Swal.fire({
        title: 'Are sure you?',
        text: "You want to reject this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Reject/Syst_User',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $("#_csrf_token").val() },
                success: function(result) {
                    console.log(result);
                    if (result.status === 0) {
                        Swal.fire(
                            'Success',
                            result.message,
                            'success'
                        ).then(() => {
                            location.reload(true);
                            spinner.hide();
                        });
                    } else {
                        Swal.fire(
                            'Error',
                            result.message,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                },
            });
        } else {
            Swal.fire(
                'error',
                'Operation not performed :)',
                'error'
            )
        }
    });
});





var admin_loans_report_dt = $("#dt-basic-example-report").DataTable({
    responsive: true,
    processing: true,
    bFilter: false,
    bFilter: false,
    sInfo: false,
    dataTables_info: false,
    language: {
        loadingRecords: "&nbsp;",
        processing: '<i class="spinner spinner-primary spinner-lg mr-15"></i><span class="sr-only" style="color: black;">Loading...</span> ',
    },

    serverSide: true,
    paging: true,
    ajax: {
        type: "POST",
        url: "/all/customer/loans/records",
        data: {
            _csrf_token: $("#csrf").val(),
            id: $("#id").val(),
            firstname: $("#firstname").val(),
            lastname: $("#lastname").val(),
            company_name: $("#company_name").val(),
            phone_number: $("#phone_number").val(),
            loan_status: $("#loan_status").val(),
            loan_type: $("#loan_type").val(),
            principal_amount: $("#principal_amount").val(),
            total_expected_repayment: $("#total_expected_repayment").val(),
            from: $("#from").val(),
            to: $("#to").val(),
        },
    },

    columns: [
        { data: "company_name" },
        {
            data: null,
            render: function(data, type, row) {
                return data.first_name + "  " + data.last_name;
            },
        },
        { data: "phone_number" },
        { data: "principal_amount" },
        { data: "total_expected_repayment" },
        { data: "loan_type" },
        { data: "loan_status" },
        { data: "transacation_date" },
    ],
    lengthMenu: [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000],
    ],
    order: [
        [1, "asc"]
    ],
});

$("#loans-report-filter").on("click", function() {
    $("#loans_reports_form_filter").modal("show");
});

$("#loans-report-search").on("click", function() {
    admin_loans_report_dt.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.firstname = $("#firstname").val();
        data.lastname = $("#lastname").val();
        data.company_name = $("#company_name").val();
        data.phone_number = $("#phone_number").val();
        data.loan_status = $("#loan_status").val();
        data.loan_type = $("#loan_type").val();
        data.principal_amount = $("#principal_amount").val();
        data.total_expected_repayment = $("#total_expected_repayment").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
    });
    $("#loans_reports_form_filter").modal("hide");
    admin_loans_report_dt.draw();
});