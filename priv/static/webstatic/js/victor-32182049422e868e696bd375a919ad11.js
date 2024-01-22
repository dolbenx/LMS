
$('#example1 tbody').on('click', '.admin-deactivate-user', function (e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/admin/admin/view/system/users/deactivate',
                type: 'POST',
                data: { id: button.attr("data-deactivate-id"), _csrf_token: $('#csrf').val() },
                success: function (result) {
                    if (result.data) {
                        //    example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'error'
            )
        }
    });
});



$('#example1 tbody').on('click', '.admin-activate-user-employee', function (e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/admin/admin/view/system/users/activate',
                type: 'POST',
                data: { id: button.attr("data-activate-id"), _csrf_token: $('#csrf').val() },
                success: function (result) {
                    if (result.data) {
                        //    example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'error'
            )
        }
    });
});








$('#example1 tbody').on('click', '.activatedepartment', function (e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/admin/maintenance/department/activate',
                type: 'POST',
                data: { id: button.attr("data-activate-id"), _csrf_token: $('#csrf').val() },
                success: function (result) {
                    if (result.data) {
                        // example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'error'
            )
        }
    });
});



$('#example1 tbody').on('click', '.deactivatedepartment', function (e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/admin/maintenance/department/deactivate',
                type: 'POST',
                data: { id: button.attr("data-deactivate-id"), _csrf_token: $('#csrf').val() },
                success: function (result) {
                    if (result.data) {
                        // example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'error'
            )
        }
    });
});

$('#kt_datatable tbody').on('click', '.activate_qfin_branch', function(e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Admin/organization/management/branch/activate',
                type: 'POST',
                data: { id: button.attr("data-activate-id"), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        // example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

$('#kt_datatable tbody').on('click', '.approve_holiday', function(e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Admin/organization/management/holiday/activate',
                type: 'POST',
                data: { id: button.attr("data-activate-id"), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        // example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'Operation not performed :)',
                'error'
            )
        }
    });
});

$('#kt_datatable tbody').on('click', '.disapprove_holiday', function(e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Admin/organization/management/holiday/deactivate',
                type: 'POST',
                data: { id: button.attr("data-deactivate-id"), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        // example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'Operation not performed :)',
                'error'
            )
        }
    });
});



$('#kt_datatable tbody').on('click', '.deactivate_qfin_branch', function(e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Admin/organization/management/branch/deactivate',
                type: 'POST',
                data: { id: button.attr("data-deactivate-id"), _csrf_token: $('#csrf').val() },
                success: function(result) {
                    if (result.data) {
                        // example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'Operation not performed :)',
                'error'
            )
        }
    });
});



var dt_customer_all_loans_list = $('#dt-customer-loan-apraisals-list').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "buttons": [],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/all/customer/loan/apraisals/list',
        "data": {
            _csrf_token: $("#csrf").val(),
            userId: $("#userId").val(),
            "id": $('#id').val(),


            "filter_product_name": $('#filter_product_name').val(),
            "filter_product_type": $('#filter_product_type').val(),
            "filter_minimum_principal": $('#filter_minimum_principal').val(),
            "filter_maximum_principal": $('#filter_maximum_principal').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),

        }
    },
    "columns": [

        { "data": "product_name" },
        { "data": "principal_amount" },
        { "data": "interest_outstanding_derived" },
        { "data": "disbursedon_date" },
        { "data": "applied_date" },

        {
            "data": "loan_status",
            render: function (data, _, row) {
                let show = "";
                if (data === "INACTIVE") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>INACTIVE</span></td>";
                }
                if (data === "ACTIVE") {
                    show = "<td><span class='badge bg-success-light bg-pill'>ACTIVE </span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING </span></td>";
                }
                return show;
            }
        },
        { "data": "principal_repaid_derived" },
        { "data": "expected_maturity_date" },






    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
        "targets": 2,
        "className": "text-right fw-500"
    },
    {
        "targets": "_all",
        "defaultContent": '<span style="color: red">Not Set</span>'
    },


    ]
});





var dt_customer_all_loans_list = $('#dt-crm-bulk-reassignment-list').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "buttons": [],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/all/customer/loan/user/list',
        "data": {
            _csrf_token: $("#csrf").val(),
            userId: $("#userId").val(),
            "id": $('#id').val(),


            "filter_product_name": $('#filter_product_name').val(),
            "filter_product_type": $('#filter_product_type').val(),
            "filter_minimum_principal": $('#filter_minimum_principal').val(),
            "filter_maximum_principal": $('#filter_maximum_principal').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),

        }
    },
    "columns": [
        { "data": "customer_names" },
        { "data": "assignment_date" },
        { "data": "mobileNumber" },
    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
        "targets": 2,
        "className": "text-right fw-500"
    },
    {
        "targets": "_all",
        "defaultContent": '<span style="color: red">Not Set</span>'
    },


    ]
});





$(document).ready(function () {
    $('.relationship-manager-bulk-loopup').on('change', function () {
        if ($('#relationship_manager_id').val() == "") {
            return false;
        }
        $.ajax({
            url: '/client/relation/managers/bulk/lookup',
            type: 'post',
            data: {
                "userId": $('#relationship_manager_id').val(),
                "_csrf_token": $("#csrf").val()
            },
            success: function (result) {
                if (result.data.length < 1) {
                    // $('.clear-wizard').val('').prop('readonly', false);
                    // $('.clear-select-wizard').val(null);


                    return false;
                } else {
                    capa = result.data[0];
                    console.log("capa");
                    console.log(capa);
                    $('#identification_id').val(capa.branch ).prop('readonly', true);
                 
                }
            },
            error: function (request, msg, error) {
                $('.loading').hide();
            }
        });
    });
});




$('#kt_datatable tbody').on('click', '.deactivatealert', function (e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Admin/maintenance/alert/deactivate',
                type: 'POST',
                data: { id: button.attr("data-deactivate-id"), _csrf_token: $('#csrf').val() },
                success: function (result) {
                    if (result.data) {
                        // example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'error'
            )
        }
    });
});


$('#kt_datatable tbody').on('click', '.activatealert', function (e) {
    e.preventDefault();
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#23b05d',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/Admin/maintenance/alert/activate',
                type: 'POST',
                data: { id: button.attr("data-activate-id"), _csrf_token: $('#csrf').val() },
                success: function (result) {
                    if (result.data) {
                        // example1.ajax.reload();
                        Swal.fire(
                            'success',
                            result.data,
                            'success'
                        ).then((result) => {
                            location.reload(true);
                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        )
                    }
                }
            });
        } else {
            Swal.fire(
                'Cancelled!',
                'error'
            )
        }
    });
});




$('#mobile_payment_method').on('change', function () {

    let disbursement_type = $(this).find(':selected').attr('data-disbursement_method');

    if (disbursement_type == "MTN" || disbursement_type == "Airtel" || disbursement_type == "Zamtel" || disbursement_type == "Zamtel") {
        console.log("am here man!!!");
        console.log(disbursement_type);
        $("#receiver_number").show();
        $("#bank_details").hide();
        $("#wallet_number").hide();
        $("#bank_details_summary").hide();
    } else
        if (disbursement_type == "Bevura") {
            $("#wallet_number").show();
            $("#receiver_number").hide();
            $("#bank_details").hide();
            $("#bank_details_summary").hide();
        } else
            if (disbursement_type == "Bank") {
                $("#bank_details").show();
                $("#bank_details_summary").show();
                $("#receiver_number").hide();
                $("#wallet_number").hide();

            } else
                if (disbursement_type == "543") {
                    $("#receiver_number").show();
                    $("#bank_details").hide();
                    $("#wallet_number").hide();
                    $("#bank_details_summary").hide();
                }

});

$('#employement_type').on('change', function () {

    let get_employment_type = $(this).find(':selected').attr('data-employement_type');

    if (get_employment_type == "Employed") {
        console.log("am here man!!!");
        console.log(get_employment_type);
        $("#get_employment_type").show();
        $("#get_business_type").hide();
    } else{
        if (get_employment_type == "Business") {
            $("#get_business_type").show();
            $("#get_employment_type").hide();
        } else{}
    }
});




    $('.otc-employee-lookup').on('input', function () {
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
            success: function (result) {
                if (result.data.length < 1) {
                    $('.clear-wizard').val('').prop('readonly', false);
                    $('.clear-select-wizard').val(null);


                    return false;
                } else {
                    capa = result.data[0];
                    $('#identification_id').val(capa.meansOfIdentificationNumber);
                    $('#id_means').val(capa.meansOfIdentificationType).prop('readonly', true);
                    $('#id_gender').val(capa.gender).prop('readonly', true);
                    $('#first_name_id').val(capa.firstname).prop('readonly', true);
                    $('#last_name_id').val(capa.lastname).prop('readonly', true);
                    $('#other_name_id').val(capa.othername).prop('readonly', true);
                    $('#dob_id').val(capa.dateOfBirth).prop('readonly', true);
                    $('#mobile_id').val(capa.mobileNumber).prop('readonly', true);
                    $('#email_id').val(capa.emailAddress).prop('readonly', true);
                    $('#user_id').val(capa.userId).prop('readonly', true);
                    $('#user_role').val(capa.userrole);
                }
            },
            error: function (request, msg, error) {
                $('.loading').hide();
            }
        });
    });
































    
    var dt_customer_loans_list = $('#dt-customer-loans-list').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "buttons": [],
        'language': {
            'loadingRecords': '&nbsp;',
            processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
            searchPlaceholder: 'Search...',
            sSearch: '',

        },
        "serverSide": true,
        "paging": true,
        'ajax': {
            "type": "POST",
            "url": '/admin/customer/loans/list',
            "data": {
                _csrf_token: $("#csrf").val(),
                "id": $('#id').val(),
                // "filter_product_name": $('#filter_product_name').val(),
                // "filter_product_type": $('#filter_product_type').val(),
                // "filter_minimum_principal": $('#filter_minimum_principal').val(),
                // "filter_maximum_principal": $('#filter_maximum_principal').val(),
                // "from": $('#from').val(),
                // "to": $('#to').val(),

            }
        },
        "columns": [
            { "data": "customer_names" },
            { "data": "email_address" },
            { "data": "product_code" },
            { "data": "principal_amount" },
            { "data": "interest_outstanding_derived" },
            { "data": "total_principal_repaid" },
            { "data": "principal_outstanding_derived" },
            {
                "data": "loan_status",
                render: function(data, _, row) {
                    let show = "";
                    if (data === "INACTIVE") {
                        show = "<td><span class='badge bg-danger-light bg-pill'>INACTIVE</span></td>";
                    }
                    if (data === "ACTIVE") {
                        show = "<td><span class='badge bg-success-light bg-pill'>ACTIVE </span></td>";
                    }
                    if (data === "PENDING_APPROVAL") {
                        show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                    }
                    if (data === "PENDING") {
                        show = "<td><span class='badge bg-warning-light bg-pill'>PENDING </span></td>";
                    }
                    return show;
                }
            },




        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000]
        ],
        "order": [
            [1, 'asc']
        ],
        "columnDefs": [{
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },


        ]
    });



    // $("#admin-loan-products-filter").on("click", function() {
    //     $("#product_filter_model").modal("show");
    // });

    // $("#admin_loan_products_filter").on("click", function() {
    //     dt_customer_loans_list.on("preXhr.dt", function(e, settings, data) {
    //         data._csrf_token = $("#csrf").val();
    //         data.filter_product_name = $("#filter_product_name").val();
    //         data.filter_product_type = $("#filter_product_type").val();
    //         data.filter_minimum_principal = $("#filter_minimum_principal").val();
    //         data.filter_maximum_principal = $("#filter_maximum_principal").val();
    //         data.from = $("#from").val();
    //         data.to = $("#to").val();
    //     });
    //     $("#product_filter_model").modal("hide");
    //     dt_customer_loans_list.draw();
    // });




    var dt_offtaker_pending_loans_list = $('#dt-offtaker-pending-loans-list-miz').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
        {
        "extend": 'csvHtml5',
        "text": 'CSV',
        "titleAttr": 'Generate CSV',
        "className": 'btn-outline-primary btn-sm mr-1'
        },
        {
        "extend": 'copyHtml5',
        "text": 'Copy',
        "titleAttr": 'Copy to clipboard',
        "className": 'btn-outline-primary btn-sm mr-1'
        },
        {
        "extend": 'print',
        "text": 'Print',
        "titleAttr": 'Print Table',
        "className": 'btn-outline-primary btn-sm mr-1'
        },
        {
        "extend": 'pdfHtml5',
        "text": 'PDF',
        "titleAttr": 'Generate PDF',
        'className': 'btn-outline-primary btn-sm mr-1'
        },
        {
        "extend": "excelHtml5",
        "text": "Excel",
        "titleAttr": "Generate Excel",
        "className": "btn-outline-primary btn-sm mr-1"
        },

        ],
        'language': {
            'loadingRecords': '&nbsp;',
            processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
            searchPlaceholder: 'Search...',
            sSearch: '',

        },
        "serverSide": true,
        "paging": true,
        'ajax': {
            "type": "POST",
            "url": '/Offtaker/pending/loans/lookup',
            "data": {
                _csrf_token: $("#csrf").val(),
                "id": $('#id').val(),


            }
        },
        "columns": [
            { "data": "customer_names" },
            { "data": "product_name" },
            { "data": "principal_amount" },
            { "data": "interest" },
            { "data": "disbursedon_date" },
            { "data": "applied_date", 
                render: function(data, type, row) {
                    if (data) {
                        var options = {
                            year: "numeric",
                            month: "long",
                            day: "numeric",

                        };
                        var today = new Date(data);
                        return today.toLocaleDateString("en-GB", options); //.dateFormat("dd-mmm-yyyy, HH:MM:SS")
                    }
                },
            },
            { "data": "applied_date", 
                render: function(data, type, row) {
                    if (data) {
                        var options = {
                            hour: "2-digit",
                            minute: "2-digit",
                        };
                        var today = new Date(data);
                        return today.toLocaleTimeString("en-GB", options); //.dateFormat("dd-mmm-yyyy, HH:MM:SS")
                    }
                },
            },
            {"data": "loan_status"}, 
            { "data": "total_repaid" },
            { "data": "expected_maturity_date" },
            {
                "data": "loan_id",
                "render": function(data, type, row) {
                    if (row.loan_status == "PENDING_OFFTAKER_CONFIRMATION" ) {
                        return `
                            <a href="/Offtaker/Loan/Approval?loan_id=${row.loan_id}&userId=${row.userId}&company_id=${row.company_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>
                            <a href="#"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                            <a href="#" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
                            <a href="/Offtaker/Loan/Reject?loan_id=${row.loan_id}&userId=${row.userId}&company_id=${row.company_id}" class="btn ripple btn-danger btn-sm" ><i class= "ki ki-close icon-sm "></i>Reject</a>
                        `;
                    }
    
                },
    
                "defaultContent": "<span class='text-danger'>No Actions</span>"
            }
        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000]
        ],
        "order": [
            [1, 'asc']
        ],
        "columnDefs": [{
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },


        ]
    });

    
    // $("#admin-offtaker-loans-filter").on("click", function() {
    //     $("#offtaker_loans_filter_model").modal("show");
    // });

    // $("#admin_offtaker_loan_filter").on("click", function() {
    //     dt_offtaket_pending_loans_list.on("preXhr.dt", function(e, settings, data) {
    //         // data._csrf_token = $("#csrf").val();
    //         // data.filter_customer_first_name = $("#filter_customer_first_name").val();
    //         // data.filter_customer_last_name = $("#filter_customer_last_name").val();
    //         // data.filter_product_name = $("#filter_product_name").val();
    //         // data.filter_product_type = $("#filter_product_type").val();
    //         // data.filter_minimum_principal = $("#filter_minimum_principal").val();
    //         // data.filter_maximum_principal = $("#filter_maximum_principal").val();
    //         // data.from = $("#from").val();
    //         // data.to = $("#to").val();
    //     });
    //     $("#offtaker_loans_filter_model").modal("hide");
    //     dt_offtaket_pending_loans_list.draw();
    // });












    var dt_loan_approval_and_disbursement = $('#dt-loan-application-approval-disbursement-miz').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "buttons": [],
        'language': {
            'loadingRecords': '&nbsp;',
            processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
            searchPlaceholder: 'Search...',
            sSearch: '',
    
        },
        "serverSide": true,
        "paging": true,
        'ajax': {
            "type": "POST",
            "url": '/Credit/Management/loan_approval_and_disbursements',
            "data": {
                _csrf_token: $("#csrf").val(),
                // "id": $('#id').val(),
                // "filter_product_name": $('#filter_product_name').val(),
                // "filter_product_type": $('#filter_product_type').val(),
                // "filter_minimum_principal": $('#filter_minimum_principal').val(),
                // "filter_maximum_principal": $('#filter_maximum_principal').val(),
                // "from": $('#from').val(),
                // "to": $('#to').val(),
    
            }
        },
        "columns": [
            { "data": "id" },
            { "data": "closedon_date" },
            {
                "data": "repayment_amount",
                render: function(data, _, _) {
                    return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                }
            },
            {
                "data": "requested_amount",
                render: function(data, _, _) {
                    return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                }
            },
            {
                "data": "interest_amount",
                render: function(data, _, _) {
                    return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                }
            },
            {
                "data": "balance",
                render: function(data, _, _) {
                    return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                }
            },
    
            {
                "data": "loan_status",
                render: function(data, _, row) {
                    let show = "";
                    if (data === "PENDING_CREDIT_ANALYST") {
                        show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING_CREDIT_ANALYST</span></td>";
                    } else {
                        show = "<td><span class='btn ripple btn-warning btn-sm'>${data}</span></td>";
                    }
    
                    return show;
                }
            },
    
            {
                "data": "id",
                "render": function(data, type, row) {
                    if (row.loan_status == "PENDING_CREDIT_ANALYST") {
                        return `
                            
                            <a href="/Approve/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>
                            <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                            <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
                            <a href="#" data-id="${row.id}" data-target="#rejectmodal" data-toggle="modal" class="btn ripple btn-danger btn-sm"><i class= "ki ki-close icon-sm"></i>Reject</a>
                            
                        `;
                    }

                    if (row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "ORDER FINANCE") {

                        return `
                        <a href="/Approve/Accounts/Ordering/Finance/Loan?loan_id=${row.id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
                        <a href="#" data-id="${row.id}" data-target="#rejectmodal" data-toggle="modal" class="btn ripple btn-danger btn-sm"><i class= "ki ki-close icon-sm"></i>Reject</a>
                    `;
                     }
    
                    if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_OPERATIONS_MANAGER") {
                        return `
                            
                            <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                            <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
    
                        `;
                    }
                    
                    if (row.loan_status == "PENDING_APPROVAL") {
                        return `
                        <a href="/Approve/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
                        <a href="#" data-id="${row.id}" data-target="#rejectmodal" data-toggle="modal" class="btn ripple btn-danger btn-sm"><i class= "ki ki-close icon-sm"></i>Reject</a>
                        `;
                    };
    
                    if (row.loan_status == "REJECTED") {
                        return ` 
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
                        `;
                    };
    
                    if (row.loan_status == "DISBURSED") {
                        return `  
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
                        `;
                    }
    
                    if (row.loan_status == "APPROVED") {
                        return `  
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
    
                        `;
                    }
    
                },
    
                "defaultContent": "<span class='text-danger'>No Actions</span>"
            }
    
        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000]
        ],
        "order": [
            [1, 'asc']
        ],
        "columnDefs": [{
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
    
            {
                "targets": 5,
                "className": "text-center"
            }
        ]
    });


    $('#dt-offtaker-pending-loans-list-miz tbody').on('click', '.reject_loan_offtaker', function (e) {
        e.preventDefault();
        let button = $(this)
        Swal.fire({
            title: 'Are you sure you want to Proceed?',
            text: "You won't be able to revert this!",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: '#23b05d',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Confirm Reject!',
            showLoaderOnConfirm: true
        }).then((result) => {
            if (result.value) {
                $.ajax({
                    url: '/Admin/maintenance/alert/activate',
                    type: 'POST',
                    data: { id: button.attr("data-activate-id"), _csrf_token: $('#csrf').val() },
                    success: function (result) {
                        if (result.data) {
                            // example1.ajax.reload();
                            Swal.fire(
                                'success',
                                result.data,
                                'success'
                            ).then((result) => {
                                location.reload(true);
                            });
                        } else {
                            Swal.fire(
                                'Failed!',
                                result.error,
                                'error'
                            )
                        }
                    }
                });
            } else {
                Swal.fire(
                    'Cancelled!',
                    'error'
                )
            }
        });
    });





    $('#update-loco-detention').click(function() {

        var loan_document_upload = document.getElementById('loan_document_upload').value;

        var disbursement_amount = document.getElementById('disbursement_amount').value;

        var loan_document_upload_length = loan_document_upload.length;

        var document_upload = loan_document_upload_length
        

        if (document_upload === 0) 
        {
            Swal.fire({
                title: ("please provide required documents"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (disbursement_amount === "") 
            {
                Swal.fire({
                    title: ("please provide disbursed amount"),
                    type: "warning",
                    showCancelButton: false,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Ok!',
                    showLoaderOnConfirm: true
                })
                return false;
            };
    

        Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, continue!',
            showLoaderOnConfirm: true
        }).then((result) => {
            if (result.value) {
                    $('#reportSearchForm').attr('action', '/Accountant/Order/Finance/Disbursement');
                    $('#reportSearchForm').attr('method', 'POST');
                    $("#reportSearchForm").submit();

            } else {
                // spinner.hide();
                Swal.fire(
                    'Cancelled',
                    'Operation not performed :)',
                    'error'
                )
            }
        })
    });





$('#loan-repayment-for-all-products').click(function() {
   

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $('#loan-repayment').attr('action', '/Admin/Loan/Repayment/Submit');
                $('#loan-repayment').attr('method', 'POST');
                $("#loan-repayment").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });



$('#credit-analyst-loan-repayment-for-all-products').click(function() {
   

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $('#credit-analyst-loan-repayment').attr('action', '/Credit/Analyst/Update/Loan/Repayment');
                $('#credit-analyst-loan-repayment').attr('method', 'POST');
                $("#credit-analyst-loan-repayment").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });

$('#funder-disburse-loan-application').click(function() {

    var disbursed_amount = document.getElementById('disbursed_amount').value;
    var amount = document.getElementById('amount').value;
    var loan_document_upload = document.getElementById('loan_document_upload').value;
    var loan_document_upload_length = loan_document_upload.length;
    var document_upload = loan_document_upload_length

    if (document_upload === 0) 
    {
        Swal.fire({
            title: ("please provide required documents"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (disbursed_amount === "") 
    {
        Swal.fire({
            title: ("please provide disbursed amount"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (disbursed_amount > amount)
    {
        Swal.fire({
            title: ("Disbursed amount can not be more than the requested amount"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $('#funder_disburse_loan_form').attr('action', '/Aprrove/Funder/All/invoice/discounting/Loans');
                $('#funder_disburse_loan_form').attr('method', 'POST');
                $("#funder_disburse_loan_form").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });


$('#sme-credit_loan_application_form').click(function() {
   
    var choose_funder = document.getElementById('choose_funder').value;
    var sme_loan_documents = document.getElementById('sme_loan_documents').value;
   
    var loan_document_sme_loan_documents = sme_loan_documents.length;

    if (choose_funder === "") 
    {
        Swal.fire({
            title: ("please select the funder"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (loan_document_sme_loan_documents === 0) 
    {
        Swal.fire({
            title: ("please provide required documents"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $('#sme_credit_loan_application_form').attr('action', '/Sme/Loan/Assement/Reviewed/By/Credit/Analyst');
                $('#sme_credit_loan_application_form').attr('method', 'POST');
                $("#sme_credit_loan_application_form").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });






var loan_aging_report_miz = $('#loan-aging-report-miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report",
                "filename": "Loan Aiging Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report",
                "filename": "Loan Aiging Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report",
                "filename": "Loan Aiging Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report",
                "filename": "Loan Aiging Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Aging',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            // "filter_product_name": $('#filter_product_name').val(),
            // "filter_product_type": $('#filter_product_type').val(),
            // "filter_minimum_principal": $('#filter_minimum_principal').val(),
            // "filter_maximum_principal": $('#filter_maximum_principal').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});












var loan_application_report_miz = $('#loan-application-report-miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Application',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            // "filter_product_name": $('#filter_product_name').val(),
            // "filter_product_type": $('#filter_product_type').val(),
            // "filter_minimum_principal": $('#filter_minimum_principal').val(),
            // "filter_maximum_principal": $('#filter_maximum_principal').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "oftaker"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});

var loan_credit_assessment_report_miz = $('#loan_credit_assessment_report_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },

            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Credit/assessment',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            // "filter_product_name": $('#filter_product_name').val(),
            // "filter_product_type": $('#filter_product_type').val(),
            // "filter_minimum_principal": $('#filter_minimum_principal').val(),
            // "filter_maximum_principal": $('#filter_maximum_principal').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "oftaker"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});



var approve_loan_awaiting_disbursement_miz = $('#approve_loan_awaiting_disbursement_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Awaiting/Loan/Disbursement',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            // "filter_product_name": $('#filter_product_name').val(),
            // "filter_product_type": $('#filter_product_type').val(),
            // "filter_minimum_principal": $('#filter_minimum_principal').val(),
            // "filter_maximum_principal": $('#filter_maximum_principal').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "oftaker"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "approvedon_date"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});


var debtors_analysis_report_miz = $('#debtors_analysis_report_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Debtors/Analysis',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            // "filter_product_name": $('#filter_product_name').val(),
            // "filter_product_type": $('#filter_product_type').val(),
            // "filter_minimum_principal": $('#filter_minimum_principal').val(),
            // "filter_maximum_principal": $('#filter_maximum_principal').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),

        }
    },
    "columns": [
        {
            "data": "year"
        },
        {
            "data": "company_name"
        },
        {
            "data": "company_phone_number"
        },
        {
            "data": "loan_type"
        },
        {
            "data": "funder_name"
        },
        {
            "data": "repayment_type"
        },
        {
            "data": "total_outstanding_derived"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "total_repayment_amount"
        },
        {
            "data": "company_id",
            "render": function(data, type, ) {
                console.log(row)
            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 9,
            "className": "text-center"
        }
    ]
});


$('#sme-loan_application').click(function() {

    var sme_loan_documents = document.getElementById('sme_loan_documents').value;

    var disbursement_amount = document.getElementById('disbursement_amount').value;

    var amount = document.getElementById('amount').value;

    console.log(amount)
    console.log(disbursement_amount)
   
    var loan_document_sme_loan_documents = sme_loan_documents.length;

    if (loan_document_sme_loan_documents === 0) 
    {
        Swal.fire({
            title: ("please provide required documents"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (disbursement_amount === "") 
    {
        Swal.fire({
            title: ("please provide disbursed amount"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
   

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $('#reportSearchSme').attr('action', '/Accountant/Sme/Loan/Disbursements');
                $('#reportSearchSme').attr('method', 'POST');
                $("#reportSearchSme").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });


$('#loan-repayment-for-all-products').click(function() {
   

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $('#loan-repayment').attr('action', '/Admin/Loan/Repayment/Submit');
                $('#loan-repayment').attr('method', 'POST');
                $("#loan-repayment").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });


$('#credit-analyst-loan-repayment-for-all-products').click(function() {
   

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $('#credit-analyst-loan-repayment').attr('action', '/Credit/Analyst/Update/Loan/Repayment');
                $('#credit-analyst-loan-repayment').attr('method', 'POST');
                $("#credit-analyst-loan-repayment").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });

$('#approve-credit-order-finance').click(function() {
   
    var choose_funder = document.getElementById('choose_funder').value;

    var loan_document_upload = document.getElementById('loan_document_upload').value;

    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length

    if (choose_funder === "") 
        {
            Swal.fire({
                title: ("please select the funder"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (document_upload === 0) 
        {
            Swal.fire({
                title: ("please provide required documents"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $("#approve_credit_order_finance").attr('action', '/Credit/Analyst/Order/Finance/Assessment');
                $("#approve_credit_order_finance").attr('method', 'POST');
                $("#approve_credit_order_finance").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });



$('#final-credit-order-finance-upload').click(function() {
   
    // var choose_funder = document.getElementById('choose_funder').value;

    var loan_document_upload = document.getElementById('loan_document_upload').value;

    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length


        if (document_upload === 0) 
        {
            Swal.fire({
                title: ("please provide required documents"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $("#final_credit_order_finance_upload").attr('action', '/Credit/Order/Finance/Loan/Docs/Upload');
                $("#final_credit_order_finance_upload").attr('method', 'POST');
                $("#final_credit_order_finance_upload").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });



var approve_loan_awaiting_disbursement_miz = $('#approve_loan_awaiting_disbursement_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Awaiting/Loan/Disbursement',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            // "filter_product_name": $('#filter_product_name').val(),
            // "filter_product_type": $('#filter_product_type').val(),
            // "filter_minimum_principal": $('#filter_minimum_principal').val(),
            // "filter_maximum_principal": $('#filter_maximum_principal').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "oftaker"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});










// --------------------------------- New Stuff--------------------------









var corperate_customer_report_miz = $('#corperate_customer_report_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Corperate Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Corperate Client Statement",
                "filename": "Corperate Client Statement",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Corperate Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Corperate Client Statement",
                "filename": "Corperate Client Statement",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Corperate Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Corperate Client Statement",
                "filename": "Corperate Client Statement",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Corperate Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Corperate Client Statement",
                "filename": "Corperate Client Statement",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },

            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Credit/Management/Corperate/Customer/Report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "registration_number_filter": $('#registration_number_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),

        }
    },
    "columns": [
        {
            "data": "reference_no",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "company_name",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "customer_names",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "company_reg_no",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "repayment_amount",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "productType",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "applied_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "status",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "approvedon_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "tenor",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "monthly_installment",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "balance",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "due_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "last_repayment_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },

        {
            "data": "loan_id",
            
            "render": function(data, type, row) {
               
            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    columnDefs: [
        { "width": "20px", "targets": '_all' },
    ],
});

$("#corperate-listing-filter").on("click", function() {
    $("#corperate-customer-filter-modal").modal("show");
});

$("#corperate_customer_listing_filter").on("click", function() {
    corperate_customer_report_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.registration_number_filter = $("#registration_number_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
    });
    $("#corperate-customer-filter-modal").modal("hide");
    corperate_customer_report_miz.draw();
});

$('#corperate-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    corperate_customer_report_miz.draw();
});





var individual_customer_report_miz = $('#individual_customer_report_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Individual Client Statement",
                "filename": "Individual Client Statement",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Individual Client Statement",
                "filename": "Individual Client Statement",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Individual Client Statement",
                "filename": "Individual Client Statement",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Individual Client Statement",
                "filename": "Individual Client Statement",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },

            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Credit/Management/Individual/Customer/Report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            // "registration_number_filter": $('#registration_number_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),


        }
    },
    "columns": [
        {
            "data": "reference_no",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "customer_names",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "customer_reg_number",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "repayment_amount",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "productType",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "applied_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "status",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "approvedon_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "tenor",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "monthly_installment",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "balance",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "due_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "last_repayment_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },

        {
            "data": "loan_id",
            
            "render": function(data, type, row) {
               
            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    columnDefs: [
        { "width": "20px", "targets": '_all' },
    ],
})


$("#individual-listing-filter").on("click", function() {
    $("#individual-customer-filter-modal").modal("show");
});

$("#individual_customer_listing_filter").on("click", function() {
    individual_customer_report_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        // data.registration_number_filter = $("#registration_number_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
    });
    $("#individual-customer-filter-modal").modal("hide");
    individual_customer_report_miz.draw();
});

$('#individual-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    individual_customer_report_miz.draw();
});






var transaction_report_miz = $('#transaction_report_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Transactions Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Transactions Report",
                "filename": "Transactions Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Transactions Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Transactions Report",
                "filename": "Transactions Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Transactions Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Transactions Report",
                "filename": "Transactions Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Transactions Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Transactions Report",
                "filename": "Transactions Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },

            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Transaction/Report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "registration_number_filter": $('#registration_number_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),
            "applied_on_from": $('#applied_on_from').val(),
            "applied_on_to": $('#applied_on_to').val(),
            // "company_id_filter": $('#company_id_filter').val(),
            "reference_number_filter": $('#reference_number_filter').val(),
            "loan_status_filter": $('#loan_status_filter').val(),
            "loan_repayment_status_filter": $('#loan_repayment_status_filter').val(),
        }
    },
    "columns": [
        {
            "data": "reference_no",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "company_name",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "customer_names",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "company_reg_no",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "repayment_amount",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "productType",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "applied_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "status",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "approvedon_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "tenor",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "monthly_installment",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "balance",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "due_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },
        {
            "data": "last_repayment_date",
            "defaultContent": "<span class='text-danger'>No Set</span>"
        },

        {
            "data": "loan_id",
            
            "render": function(data, type, row) {
               
            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});



$("#transaction-listing-filter").on("click", function() {
    $("#transaction-filter-modal").modal("show");
});

$("#transaction_report_listing_filter").on("click", function() {
    transaction_report_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.registration_number_filter = $("#registration_number_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
        data.applied_on_from = $("#applied_on_from").val();
        data.applied_on_to = $("#applied_on_to").val();
        // data.company_id_filter = $("#company_id_filter").val();
        data.reference_number_filter = $("#reference_number_filter").val();
        data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.loan_status_filter = $("#loan_status_filter").val();
        
    });
    $("#transaction-filter-modal").modal("hide");
    transaction_report_miz.draw();
});

$('#transaction-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    transaction_report_miz.draw();
});

var loan_aging_report_miz_2 = $('#loan_aging_report_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report",
                "filename": "Loan Aiging Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report",
                "filename": "Loan Aiging Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report",
                "filename": "Loan Aiging Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report",
                "filename": "Loan Aiging Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Aging',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),
            "applied_on_from": $('#applied_on_from').val(),
            "applied_on_to": $('#applied_on_to').val(),
            "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            "contact_person_number_filter": $('#contact_person_number_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});


$("#loan_aging-listing-filter").on("click", function() {
    $("#loan_aging-filter-modal").modal("show");
});


$("#loan_aging_listing_filter_miz").on("click", function() {
    loan_aging_report_miz_2.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.contact_person_number_filter = $("#contact_person_number_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
        data.applied_on_from = $("#applied_on_from").val();
        data.applied_on_to = $("#applied_on_to").val();
        data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        
    });
    $("#loan_aging-filter-modal").modal("hide");
    loan_aging_report_miz_2.draw();
});
$('#loan_aging-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    loan_aging_report_miz_2.draw();
});



var loan_application_report_miz = $('#loan_application_report_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Application',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),
            "applied_on_from": $('#applied_on_from').val(),
            "applied_on_to": $('#applied_on_to').val(),
            "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            "contact_person_number_filter": $('#contact_person_number_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "oftaker"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});


$("#loan_application-listing-filter").on("click", function() {
    $("#loan_application-filter-modal").modal("show");
});


$("#loan_application_listing_filter_miz").on("click", function() {
    loan_application_report_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.contact_person_number_filter = $("#contact_person_number_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
        data.applied_on_from = $("#applied_on_from").val();
        data.applied_on_to = $("#applied_on_to").val();
        data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        
    });
    $("#loan_application-filter-modal").modal("hide");
    loan_application_report_miz.draw();
});
$('#loan_application-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    loan_application_report_miz.draw();
});


var credit_assessment_report_miz = $('#credit_assessment_report_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },

            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Credit/assessment',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),
            "applied_on_from": $('#applied_on_from').val(),
            "applied_on_to": $('#applied_on_to').val(),
            "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            "contact_person_number_filter": $('#contact_person_number_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "oftaker"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});


$("#loan_credit_assessment-listing-filter").on("click", function() {
    $("#loan_credit_assessment-filter-modal").modal("show");
});


$("#loan_credit_assessment_listing_filter_miz").on("click", function() {
    credit_assessment_report_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.contact_person_number_filter = $("#contact_person_number_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
        data.applied_on_from = $("#applied_on_from").val();
        data.applied_on_to = $("#applied_on_to").val();
        data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        
    });
    $("#loan_credit_assessment-filter-modal").modal("hide");
    credit_assessment_report_miz.draw();
});
$('#loan_credit_assessment-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    credit_assessment_report_miz.draw();
});



var loan_awaiting_disbursement_miz = $('#loan_awaiting_disbursement_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report",
                "filename": "Loan Application Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Awaiting/Loan/Disbursement',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),
            "applied_on_from": $('#applied_on_from').val(),
            "applied_on_to": $('#applied_on_to').val(),
            "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            "contact_person_number_filter": $('#contact_person_number_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "customer_phone_number"
        },
        {
            "data": "productType"
        },
        {
            "data": "oftaker"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "finance_cost"
        },
        {
            "data": "total_repaid"
        },
        {
            "data": "tenor"
        },
        {
            "data": "approvedon_date"
        },
        {
            "data": "loan_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});



$("#loan_awaiting_disbursement-listing-filter").on("click", function() {
    $("#loan_awaiting_disbursement-filter-modal").modal("show");
});


$("#loan_awaiting_disbursement_listing_filter_miz").on("click", function() {
    loan_awaiting_disbursement_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.contact_person_number_filter = $("#contact_person_number_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
        data.applied_on_from = $("#applied_on_from").val();
        data.applied_on_to = $("#applied_on_to").val();
        data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        
    });
    $("#loan_awaiting_disbursement-filter-modal").modal("hide");
    loan_awaiting_disbursement_miz.draw();
});
$('#loan_awaiting_disbursement-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    loan_awaiting_disbursement_miz.draw();
});




var sme_loan_reports_miz = $('#sme_loan_reports_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'SME Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "SME Loans Reports",
                "filename": "SME Loans Reports",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'SME Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "SME Loans Reports",
                "filename": "SME Loans Reports",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'SME Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "SME Loans Reports",
                "filename": "SME Loans Reports",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'SME Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "SME Loans Reports",
                "filename": "SME Loans Reports",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },

            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Credit/Management/Sme_loan/loan',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            // "filter_product_name": $('#filter_product_name').val(),
            // "filter_product_type": $('#filter_product_type').val(),
            // "filter_minimum_principal": $('#filter_minimum_principal').val(),
            // "filter_maximum_principal": $('#filter_maximum_principal').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),

        }
    },
    "columns": [
        {
            "data": "company_names"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "principal_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "interest_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "total_repayment_derived",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
     
        { "data": "disbursedon_date",
        "defaultContent": "<span class='text-warning'>Pending Disbursment</span>" 
        },
        { "data": "approvedon_date",
        "defaultContent": "<span class='text-warning'>Pending Approval</span>" 
        },
        { "data": "finance_cost",
            "defaultContent": "<span class='text-warning'>Not Set</span>" 
        },  
        {
            "data": "loan_status",
            render: function(data, _, row) {
                console.log(row)
                let show = "";

                if (row.loan_status == "PENDING_CREDIT_ANALYST" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT ANALYST </span></td>";
                } 

                if (row.loan_status == "PENDING_OPERATIONS_MANAGER" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT MANAGER </span></td>";
                }

                if (row.loan_status == "PENDING_MANAGEMENT" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING MANAGEMENT </span></td>";
                }

                if (row.loan_status == "APPROVED" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>APPROVED </span></td>";
                }
                if (row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" && row.loan_type == "SME LOAN" && row.repayment_type == "PARTIAL REPAYMENT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PARTIAL REPAYMENT</span></td>";
                }

                if (row.loan_status == "REPAID" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>FULL REPAYMENT DONE</span></td>";
                }
                if (row.loan_status == "DISBURSED" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>DISBURSED</span></td>";
                }

                if (row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }

                
                if (row.loan_status == "PENDING_LOAN_OFFICER" && row.loan_type == "SME LOAN" && row.status =="REJECTED") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>REJECTED BY MANAGEMENT</span></td>";
                } else if(row.loan_status == "PENDING_LOAN_OFFICER" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING LOAN OFFICER</span></td>";
                } else if(row.loan_status == "REJECTED" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>REJECTED</span></td>";
                } 


                return show;
            }
        },
        {
            "data": "id",
            "render": function(data, type, row) {
                console.log(row)
                my_user_id = row.userId

                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "SME LOAN" && row.status == "PENDING_CREDIT_ANALYST_ASSESSMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Sme/Loan/Assement/By/Credit/Analyst?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Submit</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>                

                    `;

                    }
                    
                }  
                
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "SME LOAN" && row.status == "PENDING_CREDIT_ANALYST_UPLOAD" && row.approvedon_date != null){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Sme/Loan/Review/Approve/Credit/Analyst/Upload?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Submit</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>                

                    `;

                    }
                    
                }  
             

                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.productType == "SME LOAN" && row.status == "APPROVED"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Accountant/Sme/Loan/approval?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Disburse</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>

                    `;

                    }
                    
                } 

            

                
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER" && row.productType == "SME LOAN" && row.status == "OPERATIONS AND CREDIT MANAGER APPROVAL"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Approve/Operations/Credit/Sme/Loan?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Review</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                    }
                    
                }

                if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT" && row.productType == "SME LOAN"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Sme/Loan/Review/Approve/Management/director?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Review</a>
                        <a href="/Mgt/Order/Finance/Loan/Reject?loan_id=${row.loan_id}" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                        <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                    }
                    
                }

                if ( row.loan_status == "APPROVED" && row.productType == "SME LOAN"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                    }
                    
                }  
                if ($('#usertype').val() == "Sales" && row.productType == "SME LOAN"){
                    

                    if (row.loan_status == "PENDING_LOAN_OFFICER" && row.status =="REJECTED" ){
                    return `  
                        <a href="/Admin/Loan/Officer/Order/Finance/Loan/Reject?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Check</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;   
                    } else if (row.loan_status == "PENDING_LOAN_OFFICER"){
                        return `  
                        <a href="/Loan/Officer/Order/finance/approval/?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;          
                    }
                } 
                if (row.loan_type == "SME LOAN") {
                    return `  
                    <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                    <a href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                `;
                } 
            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});



$('#final-credit-sme-loan-upload').click(function() {
   
    // var choose_funder = document.getElementById('choose_funder').value;

    var loan_document_upload = document.getElementById('loan_document_upload').value;

    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length


        if (document_upload === 0) 
        {
            Swal.fire({
                title: ("please provide required documents"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

    Swal.fire({
        title: 'Are you sure?',
        text: "You won't be able to revert this!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Yes, continue!',
        showLoaderOnConfirm: true
    }).then((result) => {
        if (result.value) {
                $("#final_credit_sme_loan_upload").attr('action', '/Credit/SME/Loan/Docs/Upload');
                $("#final_credit_sme_loan_upload").attr('method', 'POST');
                $("#final_credit_sme_loan_upload").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    });

var order_finance_loan_reports_miz = $('#order_finance_loan_reports_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Purchase Order Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Purchase Order Loans Reports",
                "filename": "Purchase Order Loans Reports",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Purchase Order Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Purchase Order Loans Reports",
                "filename": "Purchase Order Loans Reports",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Purchase Order Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Purchase Order Loans Reports",
                "filename": "Purchase Order Loans Reports",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Purchase Order Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Purchase Order Loans Reports",
                "filename": "Purchase Order Loans Reports",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },

            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Credit/Management/order_finance/loan',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            // "filter_product_name": $('#filter_product_name').val(),
            // "filter_product_type": $('#filter_product_type').val(),
            // "filter_minimum_principal": $('#filter_minimum_principal').val(),
            // "filter_maximum_principal": $('#filter_maximum_principal').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),

        }
    },
    "columns": [
        {
            "data": "company_names"
        },
        {
            "data": "customer_names"
        },
        {
            "data": "principal_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "interest_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "total_repayment_derived",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        { "data": "finance_cost",
        "defaultContent": "<span class='text-warning'>Not Set</span>" 
        }, 
        { "data": "disbursedon_date",
        "defaultContent": "<span class='text-warning'>Pending Disbursment</span>" 
        },
        { "data": "approvedon_date",
        "defaultContent": "<span class='text-warning'>Pending Approval</span>" 
        },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }

                if (row.loan_status == "PENDING_CREDIT_ANALYST" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT ANALYST </span></td>";
                } 

                if (row.loan_status == "PENDING_OPERATIONS_MANAGER" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT MANAGER </span></td>";
                }

                if (row.loan_status == "PENDING_MANAGEMENT" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING MANAGEMENT </span></td>";
                }

                if (row.loan_status == "APPROVED" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>APPROVED </span></td>";
                }
                if (row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" && row.loan_type == "ORDER FINANCE" && row.repayment_type == "PARTIAL REPAYMENT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PARTIAL REPAYMENT</span></td>";
                }
                if (row.loan_status == "REPAID" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>FULL REPAYMENT DONE</span></td>";
                }
                if (row.loan_status == "DISBURSED" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>DISBURSED</span></td>";
                }


                
                
                if (row.loan_status == "PENDING_LOAN_OFFICER" && row.loan_type == "ORDER FINANCE" && row.status =="REJECTED") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>REJECTED BY MANAGEMENT</span></td>";
                } else if(row.loan_status == "PENDING_LOAN_OFFICER" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING LOAN OFFICER</span></td>";
                } else if(row.loan_status == "REJECTED" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>REJECTED</span></td>";
                } 


                return show;
            }
        },
        {
            "data": "id",
            "render": function(data, type, row) {
                console.log(row)
                
                my_user_id = row.userId

                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "ORDER FINANCE" && row.status == "PENDING_CREDIT_ANALYST_ASSESSMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Credit/Analyst/Order/finance/Assessment?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Submit</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;}
                    
                } 
                
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "ORDER FINANCE" && row.status == "PENDING_CREDIT_ANALYST_UPLOAD" && row.approvedon_date != null ){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Credit/Analyst/Order/finance/Doc/Upload?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Submit</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;}
                    
                } 
             
           
                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.productType == "ORDER FINANCE" && row.status == "APPROVED"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Accountant/Order/finance/approval?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Disburse</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>

                    `;
                    } 
                } 
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER" && row.productType == "ORDER FINANCE" && row.status == "OPERATIONS AND CREDIT MANAGER APPROVAL"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Approve/Operations/Ordering/Finance/Loan?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Review</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;
                    } 
                }
                if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT" && row.productType == "ORDER FINANCE"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Mgt/Order/Finance/Loan/Approval?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>
                        <a href="/Mgt/Order/Finance/Loan/Reject?loan_id=${row.loan_id}" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                        <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;
                    } 
                }
                if ( row.loan_status == "APPROVED" && row.productType == "ORDER FINANCE"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                    }
                    
                }  
                if ($('#usertype').val() == "Sales" && row.productType == "ORDER FINANCE"){
                    

                    if (row.loan_status == "PENDING_LOAN_OFFICER" && row.status =="REJECTED" ){
                    return `  
                        <a href="/Admin/Loan/Officer/Order/Finance/Loan/Reject?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Check</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;   
                    } else if (row.loan_status == "PENDING_LOAN_OFFICER"){
                        return `  
                        <a href="/Loan/Officer/Order/finance/approval/?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>
                        <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                        <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;          
                    } 
                }

                if (row.loan_type == "ORDER FINANCE") {
                    return `  
                    <a href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> Documents </a>
                    <a href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                `;
                } 
            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});
// --------------------------------------- end ---------------------------

var dt_loan_td_loan_repayment = $('#loan_repayments_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'excel',
                "text": 'Excel',
                "titleAttr": 'Repayment Loans',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Repayment Loans",
                "filename": "Repayment Loans",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Repayment Loans',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Repayment Loans",
                "filename": "Repayment Loans",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Repayment Loans',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Repayment Loans",
                "filename": "Repayment Loans",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Repayment Loans',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Repayment Loans",
                "filename": "Repayment Loans",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12]
                }
                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Credit/Management/Loan/Repayment/List',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "first_name_filter": $('#first_name_filter').val(),
            // "last_name_filter": $('#last_name_filter').val(),
            // "requested_amount_filter": $('#requested_amount_filter').val(),
            // "loan_type_filter": $('#loan_type_filter').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),
            

        }
    },
    "columns": [
        { "data": "disbursedon_date" },
        { "data": "reference_no" },
        { "data": "application_date" },
        { "data": "customerName" },
        { "data": "mobileNumber" },
        { "data": "name" },
        { "data": "principal_amount" },
        { "data": "interest_amount" },
        { "data": "finance_cost" },
        { "data": "repayment_amount" },
        { "data": "tenor_in_days" },
        { "data": "monthly_installment" },
        { "data": "due_date" },
        {
            "data": "id",
            "render": function(data, type, row) {

                console.log(row)

                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/Admin/Credit/Analyst/Loan/Repayments/Review?reference_no=${row.reference_no}&loan_id=${row.id}&repayment_type=${row.repayment_type}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Review</a>
                        `;
                    }
                } 

                if ($('#usertype').val() != "Sales"){
                        return ` 
                        <a  href="/Admin/Mgt/Loan/Repayments?reference_no=${row.reference_no}&loan_id=${row.id}&repayment_type=${row.repayment_type}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>view</a>
                        `;
 
                } 
            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});


var loan_debtors_analysis_report_miz = $('#loan_debtors_analysis_report_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',

                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Debtors/Analysis',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),
            "applied_on_from": $('#applied_on_from').val(),
            "applied_on_to": $('#applied_on_to').val(),
            "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            "contact_person_number_filter": $('#contact_person_number_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
        
        }
    },
    "columns": [
        {
            "data": "year"
        },
        {
            "data": "company_name"
        },
        {
            "data": "company_phone_number"
        },
        {
            "data": "loan_type"
        },
        {
            "data": "funder_name"
        },
        {
            "data": "repayment_type"
        },
        {
            "data": "total_outstanding_derived"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "total_repayment_amount"
        },
        {
            "data": "company_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});





$("#debtors_analysis_report-listing-filter").on("click", function() {
    $("#debtors_analysis_report-filter-modal").modal("show");
});


$("#debtors_analysis_report_listing_filter_miz").on("click", function() {
    loan_debtors_analysis_report_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.contact_person_number_filter = $("#contact_person_number_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
        data.applied_on_from = $("#applied_on_from").val();
        data.applied_on_to = $("#applied_on_to").val();
        data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        
    });
    $("#debtors_analysis_report-filter-modal").modal("hide");
    loan_debtors_analysis_report_miz.draw();
});
$('#debtors_analysis_report-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    loan_debtors_analysis_report_miz.draw();
});



var Collection_reports_miz = $('#Collection_reports_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Collection Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Collection Report",
                "filename": "Collection Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Collection Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Collection Report",
                "filename": "Collection Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Collection Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Collection Report",
                "filename": "Collection Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12, 13]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Collection Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Collection Report",
                "filename": "Collection Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12, 13]
                }, 
                
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
              

                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Credit/Collections/reports/Repayment/stage',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "registration_number_filter": $('#registration_number_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),
            "applied_on_from": $('#applied_on_from').val(),
            "applied_on_to": $('#applied_on_to').val(),
            // "company_id_filter": $('#company_id_filter').val(),
            "reference_number_filter": $('#reference_number_filter').val(),
            "loan_status_filter": $('#loan_status_filter').val(),
            "loan_repayment_status_filter": $('#loan_repayment_status_filter').val(),
            

        }
    },
    "columns": [
        { "data": "disbursedon_date" },
        { "data": "reference_no" },
        { "data": "application_date" },
        { "data": "customerName" },
        { "data": "mobileNumber" },
        { "data": "name" },
        { "data": "principal_amount" },
        { "data": "interest_amount" },
        { "data": "finance_cost" },
        { "data": "repayment_amount" },
        { "data": "tenor_in_days" },
        { "data": "monthly_installment" },
        { "data": "due_date" },
        { "data": "repayment_type" },
        {
            "data": "id",
            "render": function(data, type, row) {

                console.log(row)

                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/Admin/Credit/Analyst/Loan/Repayments/Review?reference_no=${row.reference_no}&loan_id=${row.id}&repayment_type=${row.repayment_type}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Review</a>
                        `;
                    }
                } 

                if ($('#usertype').val() != "Sales"){
                        return ` 
                        <a  href="/Admin/Mgt/Loan/Repayments?reference_no=${row.reference_no}&loan_id=${row.id}&repayment_type=${row.repayment_type}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>view</a>
                        `;
 
                } 
            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});


$("#collection-listing-filter").on("click", function() {
    $("#collection-filter-modal").modal("show");
});

$("#collection_report_listing_filter").on("click", function() {
    Collection_reports_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.registration_number_filter = $("#registration_number_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
        data.applied_on_from = $("#applied_on_from").val();
        data.applied_on_to = $("#applied_on_to").val();
        // data.company_id_filter = $("#company_id_filter").val();
        data.reference_number_filter = $("#reference_number_filter").val();
        data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.loan_status_filter = $("#loan_status_filter").val();
        
    });
    $("#collection-filter-modal").modal("hide");
    Collection_reports_miz.draw();
});

$('#collection-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    Collection_reports_miz.draw();
});




var admin_user_logs_reports_miz = $('#admin_user_logs_reports_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
            {
            "extend": 'csvHtml5',
            "text": 'Excel',
            "titleAttr": 'User Logs Report',
            "className": "btn-outline-primary btn-sm mr-1",
            "messageTop": "User Logs Report",
            "filename": "User Logs Report",
            "exportOptions": {
                'columns': [  0, 1, 2, 3, 4]
            }
            },
            {
            "extend": 'copyHtml5',
            "text": 'Copy',
            "titleAttr": 'User Logs Report',
            "className": "btn-outline-primary btn-sm mr-1",
            "messageTop": "User Logs Report",
            "filename": "User Logs Report",
            "exportOptions": {
                'columns': [  0, 1, 2, 3, 4]
            }
            },
            {
            "extend": 'print',
            "text": 'Print',
            "titleAttr": 'User Logs Report',
            "className": "btn-outline-primary btn-sm mr-1",
            "messageTop": "User Logs Report",
            "filename": "User Logs Report",
            "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4]
                }
            },
            {
            "extend": 'pdfHtml5',
            "text": 'PDF',
            "titleAttr": 'User Logs Report',
            "className": "btn-outline-primary btn-sm mr-1",
            "messageTop": "User Logs Report",
            "filename": "User Logs Report",
            "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4]
                }
            }


        ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Credit/user/logs/reports',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "first_name_filter": $('#first_name_filter').val(),
            // "last_name_filter": $('#last_name_filter').val(),
            // "requested_amount_filter": $('#requested_amount_filter').val(),
            // "loan_type_filter": $('#loan_type_filter').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),
            

        }
    },
    "columns": [
        { "data": "log_date",
            render: function(data, type, row) {
                if (data) {
                    var options = {
                        year: "numeric",
                        month: "long",
                        day: "numeric",

                    };
                    var today = new Date(data);
                    return today.toLocaleDateString("en-GB", options); //.dateFormat("dd-mmm-yyyy, HH:MM:SS")
                }
            },
        },
        { "data": "log_date",
            render: function(data, type, row) {
                if (data) {
                    var options = {
                        hour: "2-digit",
                        minute: "2-digit",
                    };
                    var today = new Date(data);
                    return today.toLocaleTimeString("en-GB", options); //.dateFormat("dd-mmm-yyyy, HH:MM:SS")
                }
            },
        },
        { "data": "user_id" },
        { "data": "name" },
        { "data": "activity"},

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 4,
            "className": "text-center"
        }
    ]
});












var loan_loan_book_report_miz = $('#loan_loan_book_report_miz').DataTable({
    "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report",
                "filename": "Debtor's Analysis Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',

                },


            ],
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
        searchPlaceholder: 'Search...',
        sSearch: '',

    },
    "serverSide": true,
    "paging": true,
    'ajax': {
        "type": "POST",
        "url": '/Admin/Report/Loan/Book/Analysis',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "disbursement_from": $('#disbursement_from').val(),
            "disbursement_to": $('#disbursement_to').val(),
            "applied_on_from": $('#applied_on_from').val(),
            "applied_on_to": $('#applied_on_to').val(),
            "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            "contact_person_number_filter": $('#contact_person_number_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            

        }
    },
    "columns": [
        {
            "data": "year"
        },
        {
            "data": "company_name"
        },
        {
            "data": "company_phone_number"
        },
        {
            "data": "loan_type"
        },
        {
            "data": "funder_name"
        },
        {
            "data": "repayment_type"
        },
        {
            "data": "total_outstanding_derived"
        },
        {
            "data": "principal_amount"
        },
        {
            "data": "interest_amount"
        },
        {
            "data": "total_repayment_amount"
        },
        {
            "data": "company_id",
            "render": function(data, type, row) {

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    "columnDefs": [{
            "targets": 2,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});


$("#loan_book_report-listing-filter").on("click", function() {
    $("#loan_book_report-filter-modal").modal("show");
});


$("#loan_book_report_listing_filter_miz").on("click", function() {
    loan_loan_book_report_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.contact_person_number_filter = $("#contact_person_number_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.disbursement_from = $("#disbursement_from").val();
        data.disbursement_to = $("#disbursement_to").val();
        data.applied_on_from = $("#applied_on_from").val();
        data.applied_on_to = $("#applied_on_to").val();
        data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        
    });
    $("#loan_book_report-filter-modal").modal("hide");
    loan_loan_book_report_miz.draw();
});
$('#loan_book_report-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    loan_loan_book_report_miz.draw();
});