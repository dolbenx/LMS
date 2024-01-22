function formatDateForFilename(date) {
    const year = date.getFullYear().toString().slice(-2);
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');
    const seconds = date.getSeconds().toString().padStart(2, '0');
    
    const formattedDate = `${day}-${month}-${year}`;
    const formattedTime = `${hours}:${minutes}`;
    
    return `${formattedDate}_${formattedTime}`;
}

const currentDate = new Date();
const russ_formattedDateTime = formatDateForFilename(currentDate);


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
        "defaultContent": '<span style="color: red">N/A</span>'
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
        "defaultContent": '<span style="color: red">N/A</span>'
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
                "defaultContent": '<span style="color: red">N/A</span>'
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
                "defaultContent": '<span style="color: red">N/A</span>'
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
                "defaultContent": '<span style="color: red">N/A</span>'
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

    var repayment_type = document.getElementById('payment_type').value;

    var repayment_method = document.getElementById('repayment_status').value;

    var repayment_amount = document.getElementById('repayment_amount').value;


    if (repayment_type === "") 
        {
            Swal.fire({
                title: ("please provide repayment type"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (repayment_method === "") 
        {
            Swal.fire({
                title: ("please provide repayment status"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (repayment_amount === "") 
        {
            Swal.fire({
                title: ("please provide repayment amount"),
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
   
    // var choose_funder = document.getElementById('choose_funder').value;
 
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
                "messageTop": "Loan Aiging Report -" + russ_formattedDateTime,
                "filename": "Loan Aiging Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report -" + russ_formattedDateTime,
                "filename": "Loan Aiging Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report -" + russ_formattedDateTime,
                "filename": "Loan Aiging Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Aiging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aiging Report -" + russ_formattedDateTime,
                "filename": "Loan Aiging Report -" + russ_formattedDateTime,
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
            "targets": [4, 5, 6, 7],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
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
            "targets": [5, 6, 7, 8],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
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
            "targets": [5, 6, 7, 8],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
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
            "targets": [5, 6, 7, 8],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "filename": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "filename": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "filename": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "filename": "Debtor's Analysis Report -" + russ_formattedDateTime,
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
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
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
            "targets": [5, 6, 7, 8],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                    "extend": 'colvis',
                    "text": 'Column Visibility',
                    "titleAttr": 'Corporate Client Statement',
                    "className": "btn-outline-primary btn-sm mr-1",
                    "messageTop": "Corporate Client Report - " + russ_formattedDateTime,
                    "filename": "Corporate Client Report - " + russ_formattedDateTime,
                    "exportOptions": {
                        'columns': [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                    },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Corporate Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Corporate Client Report - " + russ_formattedDateTime,
                "filename": "Corporate Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Corporate Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Corporate Client Report - " + russ_formattedDateTime,
                "filename": "Corporate Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Corporate Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Corporate Client Report - " + russ_formattedDateTime,
                "filename": "Corporate Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Corporate Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Corporate Client Report - " + russ_formattedDateTime,
                "filename": "Corporate Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
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
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "disbursedon_date",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },
        {
            "data": "loan_type",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },

        {
            "data": "invoice_number",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.order_number; // Assuming "order_number" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            },
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "invoice_value",
            "render": function(data, _, row) {
                let show = "";
                let null_value = "0.0";
        
                if (data === "" || data === null) {
                    show = formatNumberWithCommas(row.order_value);
                } else {
                    show = formatNumberWithCommas(data);
                }
                 console.log("show")
                console.log(show)
                
                if (show != "") {
                    return "<span>" + show + "</span>";
                } else {
                    return "<span>" + null_value + "</span>";
                }
            },
            "defaultContent": "<span class=''>0.0</span>"
        },
        
        
        
        
      

          {
            "data": "principal_amount",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
          },

        // {
        //     "data": "principal_amount",
        //     "render": function(data, type, row) {
        //       // Check if "accrued_interest" exists in the row data
        //       if (row.principal_amount) {
        //         // Round off the number to two decimal places
        //         var roundedInterest = parseFloat(row.principal_amount).toFixed(2);
        //         return "<span>" + roundedInterest + "</span>";
        //       } else {
        //         return "<span class='text-danger'>N/A</span>";
        //       }
        //     }
        //   },

        // {
        //     // Using the 'render' option to apply the custom rendering function
        //     "render": calculateDateDifference,

        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        //   },
        // {
        //     "data": "accrued_no_days",
        //     "defaultContent": "<span class='text-danger'>0</span>"
        // },
        {
            "data": "accrued_no_days",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.accrued_no_days > 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Days" + "</span>";
              } else 
              if (row.accrued_no_days === 0) {
               
                return "<span>" + 0 + "</span>";
              }
              else
              if (row.accrued_no_days === 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Day" + "</span>";
              }
              else
              {
                return "<span class=''>0</span>";
              }
            }
          },
 
          {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_interest) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
          },
        // {
        //     "data": "finance_cost",
        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        // },
   

          {
            "data": "daily_accrued_finance_cost",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_finance_cost) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_finance_cost).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
          },
            {
                "data": "total_repaid",
                "render": function(data, type, row) {
                // Check if "daily_accrued_finance_cost" exists in the row data
                if (row.total_repaid) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.total_repaid).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },

        {
            "data": "oftaker",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "total_balance_acrued",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_balance_acrued) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.total_balance_acrued).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },
         
            {
                "data": "loan_id",
                "render": function(data, type, row) {
                    if (row.txn_loan_id != null) {
                        return `
                        <a href="/Admin/get/company/customer/statement/report?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-notes icon-sm"></i>Statement</a>
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
    columnDefs: [
        { "width": "20px", "targets": '_all' },
        {
            "targets": [4, 5, 6, 7, 8, 9, 10, 11, 12],
            "className": "text-right fw-500"
        },
    ],
});


function formatNumberWithCommas(number) {
    if (number === null || number === "") {
        return "";
    }

    const formattedNumber = new Intl.NumberFormat(undefined, {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    }).format(parseFloat(number));

    return formattedNumber;
}

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


    function calculateDateDifference(data, type, row) {
        // Check if the date columns exist in the row data
        const daysInMonth = 30;

        // if (row.periodType === "DAY") {
            if (row.start_date && row.end_date) {
                // Assuming your date columns are named 'start_date' and 'end_date'
                var startDate = moment(row.start_date);
                var endDate = moment(row.end_date);
        
                    
                // Calculate the difference in days
                var differenceInDays = endDate.diff(startDate, 'days');
                var months = Math.floor(row.accrued_no_days / daysInMonth);
                var remainingDays = row.accrued_no_days % daysInMonth;
                if (row.periodType === "MONTH" && row.accrued_no_days < 30)
                    {
                        return 1 + " month";
                    }
                else
                    {
                        if (months > 0)
                    
                            {
                                return months + " months" + "  " + remainingDays +  " days";
                            }
                            else
                            if (remainingDays === 1)
                                {
                                // Display "0 days" when either or both of the date columns are missing
                                return remainingDays + " day";
                                }
                            else

                            if (remainingDays === 0)
                                {
                                // Display "0 days" when either or both of the date columns are missing
                                return "0";
                                }
                            else
                            if (remainingDays > 0)
                                {
                                    return remainingDays + " days";
                                }

                    }
                        
            
                // Return the difference in days
                
                } 
            
    }


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
                "extend": 'colvis',
                "text": 'Column Visibility',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Client Report - " + russ_formattedDateTime,
                "filename": "Consumer Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
            },
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Client Report - " + russ_formattedDateTime,
                "filename": "Consumer Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8]
                },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Client Report - " + russ_formattedDateTime,
                "filename": "Consumer Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8]
                },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Client Report - " + russ_formattedDateTime,
                "filename": "Consumer Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8]
                },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Individual Client Statement',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Client Report - " + russ_formattedDateTime,
                "filename": "Consumer Client Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8]
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
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "disbursedon_date",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },
        {
            "data": "principal_amount",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.principal_amount) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },
        // {
        //     "data": "tenor",
        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        // },
        // {
        //     "data": "interest_amount",
        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        // },
      
        //   {
        //     // Using the 'render' option to apply the custom rendering function
        //     "render": individualcalculateDateDifference,

        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        //   },
        {
            "data": "accrued_no_days",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.accrued_no_days > 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Days" + "</span>";
              } else 
              if (row.accrued_no_days === 0) {
               
                return "<span>" + 0 + "</span>";
              }
              else
              if (row.accrued_no_days === 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Day" + "</span>";
              }
              else
              {
                return "<span class=''>0</span>";
              }
            }
          },
       
        {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.daily_accrued_interest) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },
        {
            "data": "daily_accrued_finance_cost",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.daily_accrued_finance_cost) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.daily_accrued_finance_cost).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },
        {
            "data": "total_repaid",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_repaid) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.total_repaid).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },
        {
            "data": "total_balance_acrued",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_balance_acrued) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.total_balance_acrued).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },

            {
                "data": "loan_id",
                "render": function(data, type, row) {
                    if (row.txn_loan_id != null) {
                        return `
                        <a href="/Admin/get/individual/customer/statement/report?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-notes icon-sm"></i>Statement</a>
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
    columnDefs: [
        { "width": "20px", "targets": '_all' },
        {
            "targets": [3, 5, 6, 7, 8],
            "className": "text-right fw-500"
        },
    ],
})

  
// function individualcalculateDateDifference(data, type, row) {
//     // Check if the date columns exist in the row data

//     if (row.periodType === "DAY") {
//         if (row.start_date && row.end_date) {
//             // Assuming your date columns are named 'start_date' and 'end_date'
//             var startDate = moment(row.start_date);
//             var endDate = moment(row.end_date);
    
                
//             // Calculate the difference in days
//             var differenceInDays = endDate.diff(startDate, 'days');
//             if (differenceInDays > 1)
    
//             {
//                 return differenceInDays + " days";
//             }
//             else
//             {
//                 return differenceInDays + " day";
//             }
        
//             // Return the difference in days
            
//             } else {
//             // Display "0 days" when either or both of the date columns are missing
//             return "0 days";
//             }
//         }
//         else
//         {
//             var no_of_month = moment(row.number_of_months);
//                 months = (no_of_month)
//                 if (months > 1)
//                 {
//                     return no_of_month + " months";
//                 }
//                 else
//                 {
//                     return months + " month";
//                 }
            
//         }
       
//   }


function individualcalculateDateDifference(data, type, row) {
	// Check if the date columns exist in the row data
	const daysInMonth = 30;
	// if (row.periodType === "DAY") {
	if(row.start_date && row.end_date) {
		// Assuming your date columns are named 'start_date' and 'end_date'
		var startDate = moment(row.start_date);
		var endDate = moment(row.end_date);
		// Calculate the difference in days
		var differenceInDays = endDate.diff(startDate, 'days');
		var months = Math.floor(row.accrued_no_days / daysInMonth);
		var remainingDays = row.accrued_no_days % daysInMonth;
		if(row.periodType === "MONTH" && row.accrued_no_days < 30) {
			return 1 + " month";
		} else {
			if(months > 0) {
				return months + " months" + "  " + remainingDays + " days";
			} else
			if(remainingDays === 1) {
				// Display "0 days" when either or both of the date columns are missing
				return remainingDays + " day";
			} else
			if(remainingDays === 0) {
				// Display "0 days" when either or both of the date columns are missing
				return "0";
			} else
			if(remainingDays > 0) {
				return remainingDays + " days";
			}
		}
	}
}

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
                "messageTop": "Transactions Report -" + russ_formattedDateTime,
                "filename": "Transactions Report-" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Transactions Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Transactions Report -" + russ_formattedDateTime,
                "filename": "Transactions Report-" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Transactions Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Transactions Report -" + russ_formattedDateTime,
                "filename": "Transactions Report-" + russ_formattedDateTime,
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
                "messageTop": "Transactions Report -" + russ_formattedDateTime,
                "filename": "Transactions Report-" + russ_formattedDateTime,
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
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "company_name",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "customer_names",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "company_reg_no",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "repayment_amount",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "productType",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "applied_date",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "status",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "approvedon_date",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "tenor",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "monthly_installment",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "balance",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "due_date",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "last_repayment_date",
            "defaultContent": "<span class='text-danger'>N/A</span>"
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
            "targets": [4, 10, 11],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "titleAttr": 'Loan Aging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aging Report -" + russ_formattedDateTime,
                "filename": "Loan Aging Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Aging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aging Report -" + russ_formattedDateTime,
                "filename": "Loan Aging Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Aging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aging Report -" + russ_formattedDateTime,
                "filename": "Loan Aging Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Aging Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Aging Report -" + russ_formattedDateTime,
                "filename": "Loan Aging Report -" + russ_formattedDateTime,
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
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },
        {
            "data": "customer_represe",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },
        {
            "data": "productType"
        },
        {
            "data": "principal_amount",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_interest) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "daily_accrued_finance_cost",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_finance_cost) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_finance_cost).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "total_repaid",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.total_repaid) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_repaid).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },

        // {
        //     // Using the 'render' option to apply the custom rendering function
        //     "render": calculateDateDifference,

        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        //   },
        {
            "data": "accrued_no_days",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.accrued_no_days > 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Days" + "</span>";
              } else 
              if (row.accrued_no_days === 0) {
               
                return "<span>" + 0 + "</span>";
              }
              else
              if (row.accrued_no_days === 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Day" + "</span>";
              }
              else
              {
                return "<span class=''>0</span>";
              }
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
            "targets": [4, 5, 6, 7],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loan Application Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Application Report -" + russ_formattedDateTime,
                "filename": "Loan Application Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
            "data": "applied_date"
        },
        {
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
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
            "data": "principal_amount",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_interest) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "daily_accrued_finance_cost",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_finance_cost) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_finance_cost).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "total_repaid",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.total_repaid) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_repaid).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        //   {
        //     // Using the 'render' option to apply the custom rendering function
        //     "render": calculateDateDifference,

        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        //   },
        {
            "data": "accrued_no_days",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.accrued_no_days > 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Days" + "</span>";
              } else 
              if (row.accrued_no_days === 0) {
               
                return "<span>" + 0 + "</span>";
              }
              else
              if (row.accrued_no_days === 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Day" + "</span>";
              }
              else
              {
                return "<span class=''>0</span>";
              }
            }
          },
        // {
        //     "data": "loan_id",
        //     "render": function(data, type, row) {

        //     },

        //     "defaultContent": "<span class='text-danger'>No Actions</span>"
        // }

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
            "targets": [6, 7, 8, 9, 10],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "titleAttr": 'Credit Assessment Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Credit Assessment Report -" + russ_formattedDateTime,
                "filename": "Credit Assessment Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Credit Assessment Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Credit Assessment Report -" + russ_formattedDateTime,
                "filename": "Credit Assessment Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Credit Assessment Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Credit Assessment Report -" + russ_formattedDateTime,
                "filename": "Credit Assessment Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Credit Assessment Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Credit Assessment Report -" + russ_formattedDateTime,
                "filename": "Credit Assessment Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
            "data": "applied_date"
        },
        // {
        //     "data": "company_client",
        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        // },

        
        {
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
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
            "data": "principal_amount",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_interest) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "daily_accrued_finance_cost",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_finance_cost) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_finance_cost).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "total_repaid",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.total_repaid) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_repaid).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },

        // {
        //     // Using the 'render' option to apply the custom rendering function
        //     "render": calculateDateDifference,

        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        //   },
        {
            "data": "accrued_no_days",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.accrued_no_days > 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Days" + "</span>";
              } else 
              if (row.accrued_no_days === 0) {
               
                return "<span>" + 0 + "</span>";
              }
              else
              if (row.accrued_no_days === 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Day" + "</span>";
              }
              else
              {
                return "<span class=''>0</span>";
              }
            }
          },
        // {
        //     "data": "loan_id",
        //     "render": function(data, type, row) {

        //     },

        //     "defaultContent": "<span class='text-danger'>No Actions</span>"
        // }

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
            "targets": [6, 7, 8, 9, 10],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "titleAttr": 'Approved Loans Awaiting Disbursement Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Approved Loans Awaiting Disbursement Report -" + russ_formattedDateTime,
                "filename": "Approved Loans Awaiting Disbursement Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Approved Loans Awaiting Disbursement Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Approved Loans Awaiting Disbursement Report -" + russ_formattedDateTime,
                "filename": "Approved Loans Awaiting Disbursement Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Approved Loans Awaiting Disbursement Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Approved Loans Awaiting Disbursement Report -" + russ_formattedDateTime,
                "filename": "Approved Loans Awaiting Disbursement Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Approved Loans Awaiting Disbursement Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Approved Loans Awaiting Disbursement Report -" + russ_formattedDateTime,
                "filename": "Approved Loans Awaiting Disbursement Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
            "data": "approvedon_date"
        },
        {
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
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
            "data": "principal_amount",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "interest_amount",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.interest_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.interest_amount).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },

        {
            "data": "finance_cost",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.finance_cost) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.finance_cost).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "total_repaid",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.total_repaid) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_repaid).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },

        {
            "data": "tenor"
        },

        // {
        //     "data": "loan_id",
        //     "render": function(data, type, row) {

        //     },

        //     "defaultContent": "<span class='text-danger'>No Actions</span>"
        // }

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
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "SME Loans Reports -" + russ_formattedDateTime,
                "filename": "SME Loans Reports -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'SME Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "SME Loans Reports -" + russ_formattedDateTime,
                "filename": "SME Loans Reports -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'SME Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "SME Loans Reports -" + russ_formattedDateTime,
                "filename": "SME Loans Reports -" + russ_formattedDateTime,
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
                "messageTop": "SME Loans Reports -" + russ_formattedDateTime,
                "filename": "SME Loans Reports -" + russ_formattedDateTime,
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
            "defaultContent": "<span class='text-warning'>N/A</span>" 
        },  
        {
            "data": "loan_status",
            render: function(data, _, row) {
                console.log(row)
                let show = "";
            
                if (row.loan_status == "PENDING_CREDIT_ANALYST" && row.status == "PENDING_CREDIT_ANALYST_UPLOAD"  && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT ANALYST MGT</span></td>";
                } else if (row.loan_status == "PENDING_CREDIT_ANALYST" && row.loan_type == "SME LOAN") {
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
                        
                        
                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Sme/Loan/Assement/By/Credit/Analyst?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Review </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>

                    `;

                    }
                    
                }  
                
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "SME LOAN" && row.status == "PENDING_CREDIT_ANALYST_UPLOAD" && row.approvedon_date != null){
                    if ($('#change_status').val() == "Y" ){
                        return `         
                        
                        
                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Sme/Loan/Review/Approve/Credit/Analyst/Upload?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Review </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>

                    `;

                    }
                    
                }  
             

                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.productType == "SME LOAN" && row.status == "APPROVED"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Accountant/Sme/Loan/approval?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Disburse </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>

                    `;

                    }
                    
                } 

            

                
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER" && row.productType == "SME LOAN" && row.status == "OPERATIONS AND CREDIT MANAGER APPROVAL"){
                    if ($('#change_status').val() == "Y" ){
                        return `

                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Approve/Operations/Credit/Sme/Loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Review </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;

                    }
                    
                }

                if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT" && row.productType == "SME LOAN"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Sme/Loan/Review/Approve/Management/director?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Review </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;

                    }
                    
                }

                if ( row.loan_status == "APPROVED" && row.productType == "SME LOAN"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;

                    }
                    
                }  
                if ($('#usertype').val() == "Sales" && row.productType == "SME LOAN"){
                    

                    if (row.loan_status == "PENDING_LOAN_OFFICER" && row.status =="REJECTED" ){
                    return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Admin/Loan/Officer/Order/Finance/Loan/Reject?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Check </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;   
                    } else if (row.loan_status == "PENDING_LOAN_OFFICER"){
                        return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Loan/Officer/Order/finance/approval/?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Aprove </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;          
                    }
                } 
                if (row.loan_type == "SME LOAN") {
                    return `

                    <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/sme/loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
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
            "targets": [2, 3, 4, 5, 8],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Purchase Order Loans Reports -" + russ_formattedDateTime,
                "filename": "Purchase Order Loans Reports -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Purchase Order Loans Reports',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Purchase Order Loans Reports -" + russ_formattedDateTime,
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
                "messageTop": "Purchase Order Loans Reports -" + russ_formattedDateTime,
                "filename": "Purchase Order Loans Reports -" + russ_formattedDateTime,
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
                "messageTop": "Purchase Order Loans Reports -" + russ_formattedDateTime,
                "filename": "Purchase Order Loans Reports -" + russ_formattedDateTime,
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
        "defaultContent": "<span class='text-warning'>N/A</span>" 
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

                if (row.loan_status == "PENDING_CREDIT_ANALYST" && row.status == "PENDING_CREDIT_ANALYST_UPLOAD"  && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT ANALYST MGT</span></td>";
                } else if (row.loan_status == "PENDING_CREDIT_ANALYST" && row.loan_type == "ORDER FINANCE") {
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


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Credit/Analyst/Order/finance/Assessment?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Review </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;}
                    
                } 
                
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "ORDER FINANCE" && row.status == "PENDING_CREDIT_ANALYST_UPLOAD" && row.approvedon_date != null ){
                    if ($('#change_status').val() == "Y" ){
                        return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Credit/Analyst/Order/finance/Doc/Upload?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Review </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;}
                    
                } 
             
           
                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.productType == "ORDER FINANCE" && row.status == "APPROVED"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Accountant/Order/finance/approval?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Disburse </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>

                    `;
                    } 
                } 
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER" && row.productType == "ORDER FINANCE" && row.status == "OPERATIONS AND CREDIT MANAGER APPROVAL"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Approve/Operations/Ordering/Finance/Loan?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Review </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;
                    } 
                }
                if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT" && row.productType == "ORDER FINANCE"){
                    if ($('#change_status').val() == "Y" ){
                        return `

                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Mgt/Order/Finance/Loan/Approval?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Aprove </a>

                                <a class="btn ripple btn-sm"  href="/Mgt/Order/Finance/Loan/Reject?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Reject </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;
                    } 
                }
                if ( row.loan_status == "APPROVED" && row.productType == "ORDER FINANCE"){
                    if ($('#change_status').val() == "Y" ){
                        return `

                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;

                    }
                    
                }  
                if ($('#usertype').val() == "Sales" && row.productType == "ORDER FINANCE"){
                    

                    if (row.loan_status == "PENDING_LOAN_OFFICER" && row.status =="REJECTED" ){
                    return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Admin/Loan/Officer/Order/Finance/Loan/Reject?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Check </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;   
                    } else if (row.loan_status == "PENDING_LOAN_OFFICER"){
                        return ` 


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/Loan/Officer/Order/finance/approval/?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> Aprove </a>

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;          
                    } 
                }

                if (row.loan_type == "ORDER FINANCE") {
                    return `


                    <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm"  href="/View/All/Documents/Per/loan?loan_id=${row.loan_id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm"  href="/View/Loan/Details/order/finance?loan_id=${row.loan_id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
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
            "targets": [2, 3, 4, 5, 6],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
        "bFilter": true,
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
                "messageTop": "Repayment Loans -" + russ_formattedDateTime,
                "filename": "Repayment Loans -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Repayment Loans',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Repayment Loans -" + russ_formattedDateTime,
                "filename": "Repayment Loans -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Repayment Loans',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Repayment Loans -" + russ_formattedDateTime,
                "filename": "Repayment Loans -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Repayment Loans',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Repayment Loans -" + russ_formattedDateTime,
                "filename": "Repayment Loans -" + russ_formattedDateTime,
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
            "targets": [6, 7, 8, 9, 11],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "filename": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "filename": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "Debtor's Analysis Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "filename": "Debtor's Analysis Report -" + russ_formattedDateTime,
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
                "messageTop": "Debtor's Analysis Report -" + russ_formattedDateTime,
                "filename": "Debtor's Analysis Report -" + russ_formattedDateTime,
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
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },

        {
            "data": "customer_represe",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },
        {
            "data": "loan_type"
        },
        {
            "data": "corporate_funder_name",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.individual_funder_name; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },
        {
            "data": "repayment_type"
        },

        {
            "data": "total_balance_acrued",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.total_balance_acrued) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_balance_acrued).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },
        {
            "data": "principal_amount",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },

        {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_interest) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
        },

        {
            "data": "total_repayment_amount",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.total_repayment_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_repayment_amount).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
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
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "Collection Report -" + russ_formattedDateTime,
                "filename": "Collection Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Collection Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Collection Report -" + russ_formattedDateTime,
                "filename": "Collection Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11, 12, 13]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Collection Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Collection Report -" + russ_formattedDateTime,
                "filename": "Collection Report -" + russ_formattedDateTime,
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
                "messageTop": "Collection Report -" + russ_formattedDateTime,
                "filename": "Collection Report -" + russ_formattedDateTime,
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
        { "data": "tenor" },
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
            "targets": [6, 7, 8, 9, 11],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "messageTop": "User Logs Report -" + russ_formattedDateTime,
                "filename": "User Logs Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                "action": function (e, dt, button, config) {
                    // Export the data to Excel
                    $.fn.dataTable.ext.buttons.csvHtml5.action.call(this, e, dt, button, config);
            
                    // Customize the Excel file here
                    var sheet = button[0].xlsx.xl.worksheets['sheet1.xml'];
                    var msgElement = sheet.getElementsByTagName('pageMargins')[0];
            
                    msgElement.setAttribute('left', '0.5in'); // Adjust the left margin as needed
                    msgElement.setAttribute('right', '0.5in'); // Adjust the right margin as needed
                    msgElement.setAttribute('top', '0.5in'); // Adjust the top margin as needed
                    msgElement.setAttribute('bottom', '0.5in'); // Adjust the bottom margin as needed
                }
            },
            
            {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'User Logs Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "User Logs Report -" + russ_formattedDateTime,
                "filename": "User Logs Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                "customize": function (data) {
                    // Create a custom message element
                    var messageElement = document.createElement('div');
                    messageElement.style.position = 'absolute';
                    messageElement.style.right = '20px'; // Adjust the right position as needed
                    messageElement.style.bottom = '20px'; // Adjust the bottom position as needed
                    messageElement.textContent = "User Logs Report -" + russ_formattedDateTime;
            
                    // Append the message element to the document body
                    document.body.appendChild(messageElement);
                }
            },
            
            {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'User Logs Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "User Logs Report -" + russ_formattedDateTime,
                "filename": "User Logs Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                "customize": function (win) {
                    // Create a custom message element
                    var messageElement = document.createElement('div');
                    messageElement.style.position = 'absolute';
                    messageElement.style.right = '20px'; // Adjust the right position as needed
                    messageElement.style.bottom = '20px'; // Adjust the bottom position as needed
                    messageElement.textContent = "User Logs Report -" + russ_formattedDateTime;
            
                    // Append the message element to the print window's body
                    win.document.body.appendChild(messageElement);
                }
            },
            {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'User Logs Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "User Logs Report -" + russ_formattedDateTime,
                "filename": "User Logs Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4]
                },
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                "customize": function (doc) {
                    // Add a custom message at the bottom right of the PDF using PDFMake
                    var message = "User Logs Report -" + russ_formattedDateTime;
            
                    // Calculate page dimensions based on A4 paper size (assuming portrait orientation)
                    var pageWidth = 595.28; // Width in points (A4 width)
                    var pageHeight = 841.89; // Height in points (A4 height)
            
                    // Define the custom message content
                    var messageDefinition = {
                        text: message,
                        alignment: 'right', // Align the message to the right
                        fontSize: 10, // Adjust the font size as needed
                        margin: [0, 0, 20, 20] // Adjust the margin to position the message at the bottom right
                    };
            
                    // Add the custom message to the PDF
                    doc.content.push(messageDefinition);
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
    "columnDefs": [
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                "titleAttr": "Loan Book Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Book Report -" + russ_formattedDateTime,
                "filename": "Loan Book Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "Loan Book Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Book Report -" + russ_formattedDateTime,
                "filename": "Loan Book Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "Loan Book Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Book Report -" + russ_formattedDateTime,
                "filename": "Loan Book Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "Loan Book Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loan Book Report -" + russ_formattedDateTime,
                "filename": "Loan Book Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
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
            // "first_name_filter": $('#first_name_filter').val(),
            // "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),
            // "disbursement_from": $('#disbursement_from').val(),
            // "disbursement_to": $('#disbursement_to').val(),
            // "applied_on_from": $('#applied_on_from').val(),
            // "applied_on_to": $('#applied_on_to').val(),
            // "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            // "contact_person_number_filter": $('#contact_person_number_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "outstanding_amount_filter": $('#outstanding_amount_filter').val(),
            "loan_status_filter": $('#loan_status_filter').val(),
            

        }
    },
    "columns": [

        {
            "data": "disbursedon_date"
        },

        {
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },

        {
            "data": "productType"
        },
        {
            "data": "funder_as_company",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.funder_names; // Assuming "funder_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },

        {
            "data": "principal_amount",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "total_daily_accrued_charges",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_daily_accrued_charges) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_daily_accrued_charges).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "total_collectable_amount",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_collectable_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_collectable_amount).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        // {
        //     "data": "tenor"
        // },
        // {
        //     // Using the 'render' option to apply the custom rendering function
        //     "render": calculateDateDifference,

        //     "defaultContent": "<span class='text-danger'>N/A</span>"
        //   },
        {
            "data": "accrued_no_days",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.accrued_no_days > 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Days" + "</span>";
              } else 
              if (row.accrued_no_days === 0) {
               
                return "<span>" + 0 + "</span>";
              }
              else
              if (row.accrued_no_days === 1) {
               
                return "<span>" + row.accrued_no_days + " " + "Day" + "</span>";
              }
              else
              {
                return "<span class=''>0</span>";
              }
            }
          },
        {
            "data": "total_repaid"
        },
        // {
        //     "data": "balance"
        // },

          {
            "data": "total_balance_acrued",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_balance_acrued) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_balance_acrued).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "days_under_due"  
        },
        {
            "data": "days_over_due"
        },
        {
            "data": "corporate_collateral",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) {
                    if (row.individual_client_collateral === "" ||  row.individual_client_collateral === null){
                        show = '<span style="color: red">N/A</span>';
                    } else
                     show = '<a href="/View/All/collateral/Documents/Per/loan?loan_id=' + row.loan_id + '&fileName=' + 'Post-dated cheques' +'" class="btn ripple btn-info btn-sm"><i class="flaticon-eye icon-sm"></i> Document</a>';
                } else {
                    show = '<a href="/View/All/collateral/Documents/Per/loan?loan_id=' + row.loan_id + '&fileName=' + "Original Collateral Document" +'" class="btn ripple btn-info btn-sm"><i class="flaticon-eye icon-sm"></i> Document</a>';
                }
        
                return show;
            }
        }
        
        // {
        //     "data": "company_id",
        //     "render": function(data, type, row) {

        //     },

        //     "defaultContent": "<span class='text-danger'>No Actions</span>"
        // }

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
            "targets": [4, 5, 6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
        // data.first_name_filter = $("#first_name_filter").val();
        // data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        // data.contact_person_number_filter = $("#contact_person_number_filter").val();
        // data.from = $("#from").val();
        // data.to = $("#to").val();
        // data.disbursement_from = $("#disbursement_from").val();
        // data.disbursement_to = $("#disbursement_to").val();
        // data.applied_on_from = $("#applied_on_from").val();
        // data.applied_on_to = $("#applied_on_to").val();
        // data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        // data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        data.outstanding_amount_filter = $("#outstanding_amount_filter").val();
        data.loan_status_filter = $("#loan_status_filter").val();
        
    });
    $("#loan_book_report-filter-modal").modal("hide");
    loan_loan_book_report_miz.draw();
});
$('#loan_book_report-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    loan_loan_book_report_miz.draw();
});


$("#loan_offtaker_report-listing-filter").on("click", function() {
    $("#loan_offtaker_report-filter-modal").modal("show");
});


$("#loan_offatker_report_listing_filter_miz").on("click", function() {
    loans_per_offtaker_report_miz.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_per_offtaker_filter = $("#first_name_per_offtaker_filter").val();
        data.last_name_per_offtaker_filter = $("#last_name_per_offtaker_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.contact_person_number_per_offtaker_filter = $("#contact_person_number_per_offtaker_filter").val();
        // data.from = $("#from").val();
        // data.to = $("#to").val();
        // data.disbursement_from = $("#disbursement_from").val();
        // data.disbursement_to = $("#disbursement_to").val();
        // data.applied_on_from = $("#applied_on_from").val();
        // data.applied_on_to = $("#applied_on_to").val();
        // data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        data.filter_by_number_of_days_per_offtaker_filter = $("#filter_by_number_of_days_per_offtaker_filter").val();
        data.loan_type_per_offtaker_filter = $("#loan_type_per_offtaker_filter").val();
        data.loan_per_offtaker_offtaker_id_filter = $("#loan_per_offtaker_offtaker_id_filter").val();
        data.requested_amount_per_offtaker_filter = $("#requested_amount_per_offtaker_filter").val();
        
    });
    $("#loan_offtaker_report-filter-modal").modal("hide");
    loans_per_offtaker_report_miz.draw();
});
$('#loan_ofttaker_report-listing-filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    loans_per_offtaker_report_miz.draw();
});






var loans_per_offtaker_report_miz = $('#loans_per_offtaker_report_miz').DataTable({
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
                "titleAttr": 'Loans Per Off-Taker Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loans Per Off-Taker Report - " + russ_formattedDateTime,
                "filename": "Loans Per Off-Taker Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Loans Per Off-Taker Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loans Per Off-Taker Report - " + russ_formattedDateTime,
                "filename": "Loans Per Off-Taker Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Loans Per Off-Taker Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loans Per Off-Taker Report - " + russ_formattedDateTime,
                "filename": "Loans Per Off-Taker Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Loans Per Off-Taker Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loans Per Off-Taker Report - " + russ_formattedDateTime,
                "filename": "Loans Per Off-Taker Report - " + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
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
        "url": '/Admin/Loan/Per/Offtaker/Report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_per_offtaker_filter": $('#first_name_per_offtaker_filter').val(),
            "last_name_per_offtaker_filter": $('#last_name_per_offtaker_filter').val(),
            // "requested_amount_filter": $('#requested_amount_filter').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),
            // "disbursement_from": $('#disbursement_from').val(),
            // "disbursement_to": $('#disbursement_to').val(),
            // "applied_on_from": $('#applied_on_from').val(),
            // "applied_on_to": $('#applied_on_to').val(),
            "filter_by_number_of_days_per_offtaker_filter": $('#filter_by_number_of_days_per_offtaker_filter').val(),
            "contact_person_number_per_offtaker_filter": $('#contact_person_number_per_offtaker_filter').val(),
            "loan_type_per_offtaker_filter": $('#loan_type_per_offtaker_filter').val(),
             "loan_per_offtaker_offtaker_id_filter": $('#loan_per_offtaker_offtaker_id_filter').val(),
             "requested_amount_per_offtaker_filter": $('#requested_amount_per_offtaker_filter').val(),
             

        }
    },
    "columns": [
        {
            "data": "disbursedon_date"
        },
        {
            "data": "company_client",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.customer_names; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },

        {
            "data": "invoice_no",
            "render": function(data, _, row) {
                let show = "";
        
                if (data === "" || data === null) { // "nil" should be replaced with "null"
                    show = row.order_finance_number; // Assuming "customer_names" is a property of the "row" object
                } else {
                    show = data;
                }
        
                return show;
            }
        },

        {

            "render": function(data, _, row) {
                let show = "";
                if (row.loan_type === "INVOICE DISCOUNTING") {

                    show = row.invoice_date;

                } else {

                    show = row.order_invoice_date;
                }

                return show;
            }
        },

        {
            "render": function(data, _, row) {
              let show = "";

              if (row.loan_type === "INVOICE DISCOUNTING") {
          
                if (row.currency_code === "ZMW" || row.currency_code === "ZMK") { // "nil" should be replaced with "null"
                    show = row.invoice_value; // Assuming "invoice_value" is a property of the "row" object

                   
                    if (row.loan_type === "INVOICE DISCOUNTING") {

                        show = row.invoice_value;

                    } else {

                        show = row.order_invoice_value;
                    }

                    return show;


                } else {
                    show = '<span style="color: red">N/A</span>'; // Assign the HTML content to the "show" variable
                }
              } else {
                if (row.currency_code === "ZMW" || row.currency_code === "ZMK") { // "nil" should be replaced with "null"
                    show = row.order_invoice_value; // Assuming "invoice_value" is a property of the "row" object
                } else {
                    show = '<span style="color: red">N/A</span>'; // Assign the HTML content to the "show" variable
                }
              }
          
              return show;
            }
          },
          {
            "render": function(data, _, row) {
                let show = "";
  
                if (row.loan_type === "INVOICE DISCOUNTING") {
            
                  if (row.currency_code === "USD") { // "nil" should be replaced with "null"
                      show = row.invoice_value; // Assuming "invoice_value" is a property of the "row" object
                  } else {
                      show = '<span style="color: red">N/A</span>'; // Assign the HTML content to the "show" variable
                  }
                } else {
                  if (row.currency_code === "USD") { // "nil" should be replaced with "null"
                      show = row.order_invoice_value; // Assuming "invoice_value" is a property of the "row" object
                  } else {
                      show = '<span style="color: red">N/A</span>'; // Assign the HTML content to the "show" variable
                  }
                }
            
                return show;
              }
          },
          {
            "data": "invoice_value",
            "render": function(data, _, row) {
              let show = "";
          
              if (row.currency_code === "RAND" || row.currency_code === "R") { // "nil" should be replaced with "null"
                show = row.invoice_value; // Assuming "invoice_value" is a property of the "row" object
              } else {
                show = '<span style="color: red">N/A</span>'; // Assign the HTML content to the "show" variable
              }
          
              return show;
            }
          },
        {
            "data": "tenor"
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
            "targets": [4, 5, 6],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
        },

        {
            "targets": 5,
            "className": "text-center"
        }
    ]
});

var last_five_disbursed_loans = $('#last_five_disbursed_loans').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": true,
    "select": {
        "style": 'multi'
    },
    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'><'col-sm-12 col-md-7 dataTables_pager'>>`,
        "buttons":[ 
            {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Disbursed Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loan Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loan Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Disbursed Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loan Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loan Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Disbursed Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loan Report",
                "filename": "Disbursed Loan Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Disbursed Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loan Report",
                "filename": "Disbursed Loan Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
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
        "url": '/Admin/Report/All/Disbursed',
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
            "data": "company_name",
            "render": function (data, type, row) {
                // Check if company_name is nil
                if (data === null || data === undefined || data === "") {
                    // Display customer_name if company_name is nil
                    return row.customer_name;
                } else {
                    // Display company_name if it's not nil
                    return data;
                }
            }
        },
        {
            "data": "product_name",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },

        {
            "data": "principal_amount",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.daily_accrued_interest) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "daily_accrued_finance_cost",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.daily_accrued_finance_cost) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_finance_cost).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "total_amount_repaid",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_amount_repaid) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_amount_repaid).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "total_balance_acrued",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_balance_acrued) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_balance_acrued).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "application_date",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "disbursedon_date",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "loan_status",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        }
    ],
    "lengthChange": true,
    "lengthMenu": [
        [5, 10, 20, 50, 100, 500, 1000, 10000, 20000],
        [5, 10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    columnDefs: [
        { "width": "20px", "targets": '_all' },
        {
            "targets": [2, 3, 4, 5],
            "className": "text-right fw-500"
        },
        
    ],
});

$("#last_five_disbursed_loans_filter").on("click", function() {
    $("#last_five_disbursed_loans_filter-modal").modal("show");
});


$("#last_five_disbursed_loans_filter_miz").on("click", function() {
    last_five_disbursed_loans.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        // data.contact_person_number_filter = $("#contact_person_number_filter").val();
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
    $("#last_five_disbursed_loans_filter-modal").modal("hide");
    last_five_disbursed_loans.draw();
});
$('#last_five_disbursed_loans_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    last_five_disbursed_loans.draw();
});






var last_per_product_disbursed_lookup_miz = $('#last_per_product_disbursed_lookup_miz').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": true,
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
                "titleAttr": 'Disbursed Loans Grouped By Product Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Disbursed Loans Grouped By Product Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Disbursed Loans Grouped By Product Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Disbursed Loans Grouped By Product Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3]
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
        "url": '/Admin/Report/All/Loans/Per/Product',
        "data": {
            _csrf_token: $("#csrf").val(),





        }
    },
    "columns": [
        {
            "data": "product_name",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "loan_count",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_interest) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
          },
        {
                "data": "daily_accrued_finance_cost",
                "render": function(data, type, row) {
                // Check if "daily_accrued_finance_cost" exists in the row data
                if (row.daily_accrued_finance_cost) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.daily_accrued_finance_cost).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },
        {
            "data": "principal_amount",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "total_repaid",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_repaid) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_repaid).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
          },
        {
            "data": "total_balance_acrued",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_balance_acrued) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.total_balance_acrued).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },

    ],
    "lengthChange": true,
    "lengthMenu": [
        [5, 10, 20, 50, 100, 500, 1000, 10000, 20000],
        [5, 10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    columnDefs: [
        { "width": "20px", "targets": '_all' },
        {
            "targets": [2, 3, 4],
            "className": "text-right fw-500"
        },

    ],
});


// function calculateDateDifference(data, type, row) {
//     // Check if the date columns exist in the row data

    // const daysInMonth = 30; // Assuming an average of 30 days per month
    // const totalDays = row.accrued_no_days; // Assuming an average of 30 days per month

    // var months = Math.floor(totalDays / daysInMonth);
    // const remainingDays = totalDays % daysInMonth;
  
    // return {
    //   months: months,
    //   days: remainingDays
    // };

    // if (row.periodType === "DAY") {
    //     if (row.start_date && row.end_date) {
    //         // Assuming your date columns are named 'start_date' and 'end_date'
    //         var startDate = moment(row.start_date);
    //         var endDate = moment(row.end_date);
    
                
    //         // Calculate the difference in days
    //         var differenceInDays = endDate.diff(startDate, 'days');
    //         if (differenceInDays > 1)
    
    //         {
    //             return differenceInDays + " days";
    //         }
    //         else
    //         {
    //             return differenceInDays + " day";
    //         }
        
    //         // Return the difference in days
            
    //         } else {
    //         // Display "0 days" when either or both of the date columns are missing
    //         return "0 days";
    //         }
    //     }
    //     else
    //     {
    //         var no_of_month = moment(row.number_of_months);
    //             months = (no_of_month)
    //             if (months > 1)
    //             {
    //                 return no_of_month + " months";
    //             }
    //             else
    //             {
    //                 return months + " month";
    //             }
            
    //     }
       
//   }

// function convertDaysToMonthsAndDays(totalDays) {
//     const daysInMonth = 30; // Assuming an average of 30 days per month
  
//     const months = Math.floor(totalDays / daysInMonth);
//     const remainingDays = totalDays % daysInMonth;
  
//     return {
//       months: months,
//       days: remainingDays
//     };
//   }








var last_per_product_disbursed_lookup_miz_per_funder = $('#last_per_product_disbursed_lookup_per_funder').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": true,
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
                "titleAttr": 'Disbursed Loans Grouped By Product Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Disbursed Loans Grouped By Product Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Disbursed Loans Grouped By Product Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Disbursed Loans Grouped By Product Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "filename": "Disbursed Loans Grouped By Product Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3]
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
        "url": '/Funder/Admin/Report/All/Loans/Per/Product',
        "data": {
            _csrf_token: $("#csrf").val(),





        }
    },
    "columns": [
        {
            "data": "product_name",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "loan_count",
            "defaultContent": "<span class='text-danger'>N/A</span>"
        },
        {
            "data": "daily_accrued_interest",
            "render": function(data, type, row) {
              // Check if "daily_accrued_finance_cost" exists in the row data
              if (row.daily_accrued_interest) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.daily_accrued_interest).toLocaleString(undefined, {
                  minimumFractionDigits: 2,
                  maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
              } else {
                return "<span class=''>0.0</span>";
              }
            }
          },
        {
                "data": "daily_accrued_finance_cost",
                "render": function(data, type, row) {
                // Check if "daily_accrued_finance_cost" exists in the row data
                if (row.daily_accrued_finance_cost) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.daily_accrued_finance_cost).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },
        {
            "data": "principal_amount",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.principal_amount) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_amount).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
        },
        {
            "data": "total_repaid",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_repaid) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_repaid).toLocaleString(undefined, {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
                });
                return "<span>" + formattedNumber + "</span>";
            } else {
                return "<span class=''>0.0</span>";
            }
          }
          },
        {
            "data": "total_balance_acrued",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_balance_acrued) {
                    // Parse the number and format it with commas and two decimal places
                    var formattedNumber = parseFloat(row.total_balance_acrued).toLocaleString(undefined, {
                    minimumFractionDigits: 2,
                    maximumFractionDigits: 2
                    });
                    return "<span>" + formattedNumber + "</span>";
                } else {
                    return "<span class=''>0.0</span>";
                }
              }
          },

    ],
    "lengthChange": true,
    "lengthMenu": [
        [5, 10, 20, 50, 100, 500, 1000, 10000, 20000],
        [5, 10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [
        [1, 'asc']
    ],
    columnDefs: [
        { "width": "20px", "targets": '_all' },
        {
            "targets": [2, 3, 4],
            "className": "text-right fw-500"
        },

    ],
});