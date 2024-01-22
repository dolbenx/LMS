
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





$('#example1 tbody').on('click', '.activateqfinbranch', function (e) {
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
                url: '/admin/organization/management/branch/activate',
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



$('#example1 tbody').on('click', '.deactivaqfintebranch', function (e) {
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
                url: '/admin/organization/management/branch/deactivate',
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




$('#example1 tbody').on('click', '.deactivatealert', function (e) {
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
                url: '/admin/maintenance/alert/deactivate',
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


$('#example1 tbody').on('click', '.activatealert', function (e) {
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
                url: '/admin/maintenance/alert/activate',
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


$('#business_type_section').on('change', function () {

    let business_type_section = $(this).find(':selected').attr('data-business_type_section');

    if (business_type_section == "Company") {
        console.log("am here man!!!");
        console.log(business_type_section);
        $("#get_business_as_company").show();
        $("#get_business_as_marketeer").hide();
    } else{
        if (business_type_section == "Marketeer") {
            $("#get_business_as_marketeer").show();
            $("#get_business_as_company").hide();
        } else{}
    }
});


$('#client_marital_status').on('change', function () {

    let client_marital_status = $(this).find(':selected').attr('data-marital_status');

    if (client_marital_status == "Married") {
        console.log("am here man!!!");
        $("#get_client_partner_details").show();
    } else{
        $("#get_client_partner_details").hide();
    }
});



$('#edit_individual_marital_status').on('change', function () {

    let client_marital_status = $(this).find(':selected').attr('data-marital_status');

    if (client_marital_status == "Married") {
        console.log("am here man!!!");
        $("#get_client_partner_details").show();
    } else{
        $("#get_client_partner_details").hide();
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




    var dt_all_loan = $('#dt-all-loan').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Loan List",
                filename: "Loan List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Loan List",
                filename: "Loan List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Loan List",
                filename: "Loan List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Loan List",
                filename: "Loan List",
                exportOptions: {
                    columns: [  0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
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
            "url": '/Admin/get/loans/lookup',
            "data": {
                _csrf_token: $("#csrf").val(),
                "filter_loan_id": $('#filter_loan_id').val(),
                "filter_loan_status": $('#filter_loan_status').val(),
                "filter_application_date": $('#filter_application_date').val(),
                "filter_application_date_to": $('#filter_application_date_to').val(),
                "approvedon_date_from": $('#approvedon_date_from').val(),
                "approvedon_date_to": $('#approvedon_date_to').val(),
                "filter_requested_amount": $('#filter_requested_amount').val(),

            }
        },
                

        "columns": [
            { "data": "id" },
            { "data": "client_name" },
            { "data": "requested_amount" },
            { "data": "application_date" },
            { "data": "approvedon_date",
                render: function(data, _, row) {
                    let show = "";
                    if (data === null) {
                        show = "<td><span class='badge bg-primary-light bg-pill'> 0 </span></td>";
                    }
                    if (data !== null) {

                        show = data;
                    }
                    return show;
                }
            },
            {
                "data": "loan_status",
                render: function(data, _, row) {
                    let show = "";
                    if (data !== "APPROVED") {
                        show = "<td><span class='badge bg-danger-light bg-pill'> No </span></td>";
                    }
                    if (data === "APPROVED" || data === "DISBURSED") {
                        show = "<td><span class='badge bg-success-light bg-pill'> Yes </span></td>";
                    }
                    return show;
                }
            },
            {
                "data": "loan_status",
                render: function(data, _, row) {
                    let show = "";
                    if (data !== "REJECTED") {
                        show = "<td><span class='badge bg-danger-light bg-pill'> No </span></td>";
                    }
                    if (data === "REJECTED") {
                        show = "<td><span class='badge bg-success-light bg-pill'> Yes </span></td>";
                    }
                    return show;
                }
            },

            {
                "data": "loan_status",
                render: function(data, _, row) {
                    let show = "";
                    if (data !== "PENDING_CREDIT_ANALYST") {
                        show = "<td><span class='badge bg-danger-light bg-pill'> No </span></td>";
                    }
                    if (data === "PENDING_CREDIT_ANALYST") {
                        show = "<td><span class='badge bg-success-light bg-pill'> Yes </span></td>";
                    }
                    return show;
                }
            },
            {
                "data": "approvedon_date",
                render: function(data, _, row) {
                    let show = "";
                    if (data === null) {
                        show = "<td><span class='badge bg-primary-light bg-pill'> 0 </span></td>";
                    }
                    if (data !== null) {
                        application_date = row.application_date;
                        const date1 = new Date(data);
                        const date2 = new Date(application_date);
                        const diffTime = Math.abs(date2 - date1);
                        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                        console.log(diffTime + " milliseconds");
                        console.log(diffDays + " days");

                        show = diffDays;
                    }
                    return show;
                }
            },
            { "data": "reason",
        
            render: function(data, _, row) {
                let show = "";
                if (data === null) {
                    show = "<td><span class='badge bg-primary-light bg-pill'> N/A </span></td>";
                }
                if (data !== null) {
                    show = data;
                }
                return show;
            }
            },
            { "data": "loan_officer" },
            

        ],
       
        
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "columnDefs": [
           
            
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
        
    });


    
    $("#admin-loan-miz-filter").on("click", function() {
        $("#loan_miz_filter_model").modal("show");
    });

    $("#admin_loan_miz_filter").on("click", function() {
        dt_all_loan.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_loan_id = $("#filter_loan_id").val();
            data.filter_loan_status = $("#filter_loan_status").val();
            data.filter_application_date = $("#filter_application_date").val();
            data.filter_application_date_to = $('#filter_application_date_to').val(),
            data.approvedon_date_from = $('#approvedon_date_from').val(),
            data.approvedon_date_to = $('#approvedon_date_to').val(),
            data.filter_requested_amount = $("#filter_requested_amount").val();
            // data.from = $("#from").val();
            // data.to = $("#to").val();
        });
        $("#loan_miz_filter_model").modal("hide");
        dt_all_loan.draw();
    });

    var dt_customer_miz = $('#dt-customer-miz').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Customer Excel File',
                messageTop: "GNC Customer List",
                filename: "Customer List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Customer PDF File',
                messageTop: "GNC Customer List",
                filename: "Customer List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Customer print Out File',
                messageTop: "GNC Customer List",
                filename: "Customer List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8, 9]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Customer CSV File',
                messageTop: "GNC Customer List",
                filename: "Customer List",
                exportOptions: {
                    columns: [  0, 1, 2, 3, 4, 5, 6, 7,8, 9]
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
            "url": '/Admin/get/customer/lookup',
            "data": {
                _csrf_token: $("#csrf").val(),
                "filter_registration_date": $('#filter_registration_date').val(),
                "filter_registration_date_to": $('#filter_registration_date_to').val(),
                "filter_gender": $('#filter_gender').val(),
                "filter_registration_id": $('#filter_registration_id').val(),
                "filter_phone_number": $('#filter_phone_number').val(),

            }
        },
                

        "columns": [
            { "data": "userId" },
            { "data": "firstName" },
            { "data": "otherName" },
            { "data": "lastName" },
            { "data": "gender" },
            { "data": "title" },
            { "data": "mobileNumber" },
            { "data": "number_of_dependants" },
            { "data": "meansOfIdentificationNumber" },
            { "data": "emailAddress" },

            

        ],
       
        
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "columnDefs": [
           
            
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
        
    });


    
    $("#admin-customer-miz-filter").on("click", function() {
        $("#customer_miz_filter_model").modal("show");
    });

    $("#admin_customer_miz_filter").on("click", function() {
        dt_customer_miz.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_status = $("#filter_status").val();
            data.filter_title = $("#filter_title").val();
            data.filter_registration_date = $("#filter_registration_date").val();
            data.filter_registration_date_to = $('#filter_registration_date_to').val();
            data.filter_gender = $('#filter_gender').val();
            data.filter_registration_id = $('#filter_registration_id').val();
            data.filter_phone_number = $("#filter_phone_number").val();
            // data.from = $("#from").val();
            // data.to = $("#to").val();
        });
        $("#customer_miz_filter_model").modal("hide");
        dt_customer_miz.draw();
    });































    var dt_disbursed_loan_miz = $('#dt-disbursed-loan-miz').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Disbursed Loan List",
                filename: "Disbursed Loans",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10, 11, 12]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Disbursed Loans",
                filename: "Disbursed Loans",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10, 11, 12]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Disbursed Loans",
                filename: "Disbursed Loans",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10, 11, 12]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Disbursed Loans",
                filename: "Disbursed Loans",
                exportOptions: {
                    columns: [  0, 1, 2, 3, 4, 5, 6, 7,8,9,10, 11, 12]
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
            "url": '/Admin/disbursed/loans/lookup',
            "data": {
                _csrf_token: $("#csrf").val(),
                "filter_application_date_from": $('#filter_application_date_from').val(),
                "filter_application_date_to": $('#filter_application_date_to').val(),
                "filter_approvedon_date_from": $('#filter_approvedon_date_from').val(),
                "filter_approvedon_date_to": $('#filter_approvedon_date_to').val(),
                "filter_loan_id": $('#filter_loan_id').val(),
                "filter_requested_amount": $('#filter_requested_amount').val(),

            }
        },
                

        "columns": [
            { "data": "id" },
            { "data": "client_name" },
            { "data": "approvedon_date", 
            "defaultContent": "<span class='text-warning'>Not Set</span>" 
            },
            { "data": "requested_amount"},
            {"data": "disbursedon_date",
            "defaultContent": "<span class='text-warning'>Not Set</span>" 
            },
            {"data": "application_date",
            "defaultContent": "<span class='text-warning'>Not Set</span>" 
            },
            { "data": "requested_amount" },
            {
                "data": "approvedon_date",
                render: function(data, _, row) {
                    let show = "";
                    if (data === null) {
                        show = "<td><span class='badge bg-primary-light bg-pill'> 0 Day(s)</span></td>";
                    }
                    if (data !== null) {
                        application_date = row.application_date;
                        const date1 = new Date(data);
                        const date2 = new Date(application_date);
                        const diffTime = Math.abs(date2 - date1);
                        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                        console.log(diffTime + " milliseconds");
                        console.log(diffDays + " days");

                        show = diffDays + " Day(s)";
                    }
                    return show;
                }
            },
            { "data": "duedate" },
            { "data": "net_loan" },
            { "data": "occupation" },
            { "data": "employer" },
            { "data": "loan_officer"},

        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "orientation": 'landscape',
        "columnDefs": [
           
            { "width": "20%", "targets": 0 },
            {
                "targets": 4,
                "width": "12",
                "className": "text-center"
            },
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
    
        
    });


    
    $("#admin-loan-disbursed-filter").on("click", function() {
        $("#loan_disbursed_filter_model").modal("show");
    });

    $("#admin_loan_disbursed_miz_filter").on("click", function() {
        dt_disbursed_loan_miz.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_loan_id = $("#filter_loan_id").val();
            // data.filter_loan_status = $("#filter_loan_status").val();
            data.filter_application_date_from = $("#filter_application_date_from").val();
            data.filter_application_date_to = $('#filter_application_date_to').val();
            data.filter_approvedon_date_from = $('#filter_approvedon_date_from').val();
            data.filter_approvedon_date_to = $('#filter_approvedon_date_to').val();
            data.filter_requested_amount = $("#filter_requested_amount").val();
            // data.from = $("#from").val();
            // data.to = $("#to").val();
        });
        $("#loan_disbursed_miz_filter_model").modal("hide");
        dt_disbursed_loan_miz.draw();
    });


    var dt_outstanding_loan_miz = $('#dt-outstanding-loan-miz').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Outstanding Loan Balance",
                filename: "Outstanding Loan Balance",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Outstanding Loan Balance",
                filename: "Outstanding Loan Balance",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Outstanding Loan Balance",
                filename: "Outstanding Loan Balance",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Outstanding Loan Balance",
                filename: "Outstanding Loan Balance",
                exportOptions: {
                    columns: [  0, 1, 2, 3, 4, 5, 6, 7,8]
                }
            },
        ],

        'language': {
            "orientation": 'landscape',
            'loadingRecords': '&nbsp;',
            processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
            searchPlaceholder: 'Search...',
            sSearch: '',

        },
        
        "serverSide": true,
        "paging": true,
        'ajax': {
            "type": "POST",
            "url": '/Admin/outstanding/loans/balance/lookup',
            "data": {
                _csrf_token: $("#csrf").val(),
                "filter_application_date_from": $('#filter_application_date_from').val(),
                "filter_application_date_to": $('#filter_application_date_to').val(),
                "filter_approvedon_date_from": $('#filter_approvedon_date_from').val(),
                "filter_approvedon_date_to": $('#filter_approvedon_date_to').val(),
                "filter_loan_id": $('#filter_loan_id').val(),
                "filter_requested_amount": $('#filter_requested_amount').val(),
                "filter_loan_cro": $('#filter_loan_cro').val(),

            }
        },
                

        "columns": [
            { "data": "id" },
            { "data": "client_name" },
            { "data": "requested_amount" },
            { "data": "interest"},
            { "data": "duedate"},
            {
                "data": "outstanding_balance",
                render: function(data, _, row) {
                    console.log(data)
                    console.log(row)
                    if (data == null){
                        return (row.payoff_amount ? parseFloat(row.payoff_amount).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                    } else {
                        return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                    }

                }
            },
            { "data": "lasttxn_date" },
            { "data": "product_name" },
            { "data": "loan_officer"},

        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "orientation": 'landscape',
        "columnDefs": [
           
            { "width": "20%", "targets": 0 },
            {
                "targets": 4,
                "width": "12",
                "className": "text-center"
            },
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
    
        
    });


    $("#admin-loan-outstanding-miz-filter").on("click", function() {
        $("#loan_outstanding_balance_miz_filter_model").modal("show");
    });

    $("#admin_loan_outstanding_miz_filter").on("click", function() {
        dt_outstanding_loan_miz.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_loan_id = $("#filter_loan_id").val();
            // data.filter_loan_status = $("#filter_loan_status").val();
            data.filter_application_date_from = $("#filter_application_date_from").val();
            data.filter_application_date_to = $('#filter_application_date_to').val();
            data.filter_approvedon_date_from = $('#filter_approvedon_date_from').val();
            data.filter_approvedon_date_to = $('#filter_approvedon_date_to').val();
            data.filter_requested_amount = $("#filter_requested_amount").val();
            data.filter_loan_cro = $("#filter_loan_cro").val();
            // data.from = $("#from").val();
            // data.to = $("#to").val();
        });
        $("#loan_outstanding_balance_miz_filter_model").modal("hide");
        dt_outstanding_loan_miz.draw();
    });
























    var dt_repayment_listing_loan_miz = $('#dt-repayment-listing-loan-miz').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Loan Repayment listing List",
                filename: "Loan Repayment listings",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Loan Repayment listings",
                filename: "Loan Repayment listings",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Loan Repayment listings",
                filename: "Loan Repayment listings",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Loan Repayment listings",
                filename: "Loan Repayment listings",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
        ],

        'language': {
            "orientation": 'landscape',
            'loadingRecords': '&nbsp;',
            processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
            searchPlaceholder: 'Search...',
            sSearch: '',

        },
        
        "serverSide": true,
        "paging": true,
        'ajax': {
            "type": "POST",
            "url": '/Admin/repayment/loans/listing/lookup',
            "data": {
                _csrf_token: $("#csrf").val(),
                "filter_application_date_from": $('#filter_application_date_from').val(),
                "filter_application_date_to": $('#filter_application_date_to').val(),
                "filter_loan_id": $('#filter_loan_id').val(),
               
            }
        },
                

        "columns": [
            { "data": "id" },
            { "data": "client_name" },
            { "data": "client_number" },
            { "data": "loan_officer"},
            {"data": "trans_date"},
            { "data": "installment" },
            { "data": "principle"},
            { "data": "interest" },

        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "orientation": 'landscape',
        "columnDefs": [
           
            { "width": "20%", "targets": 0 },
            {
                "targets": 4,
                "width": "12",
                "className": "text-center"
            },
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
    
        
    });


    $("#admin-loan-repayments-miz-filter").on("click", function() {
        $("#loan_repayments_miz_filter_model").modal("show");
    });

    $("#admin_loan_repayment_miz_filter").on("click", function() {
        dt_repayment_listing_loan_miz.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_loan_id = $("#filter_loan_id").val();
            // data.filter_loan_status = $("#filter_loan_status").val();
            data.filter_application_date_from = $("#filter_application_date_from").val();
            data.filter_application_date_to = $('#filter_application_date_to').val();
           // data.filter_requested_amount = $("#filter_requested_amount").val();
            //data.filter_nrc_number = $("#filter_nrc_number").val();
            // data.to = $("#to").val();
        });
        $("#loan_repayments_miz_filter_model").modal("hide");
        dt_repayment_listing_loan_miz.draw();
    });



    var dt_expected_repayment_report_miz = $('#dt-expected-repayment-report-miz').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Loan Expected Repayment listing List",
                filename: "Loan Expected Repayment listings",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Loan Expected Repayment listings",
                filename: "Loan Expected Repayment listings",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Loan Expected Repayment listings",
                filename: "Loan Expected Repayment listings",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Loan Expected Repayment listings",
                filename: "Loan Expected Repayment listings",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
                }
            },
        ],

        'language': {
            "orientation": 'landscape',
            'loadingRecords': '&nbsp;',
            processing: '<i class="spinner-border text-primary"></i><span class="sr-only">Loading...</span> ',
            searchPlaceholder: 'Search...',
            sSearch: '',

        },
        
        "serverSide": true,
        "paging": true,
        'ajax': {
            "type": "POST",
            "url": '/Admin/get/expected/repayment',
            "data": {
                _csrf_token: $("#csrf").val(),

            }
        },
                

        "columns": [
            { "data": "id" },
            { "data": "client_name" },
            { "data": "duedate" },
            {"data": "requested_amount",
            "defaultContent": "<span >0</span>" 
            },
            {"data": "interest",
            "defaultContent": "<span >0</span>" 
            },
            {"data": "payoff_amount",
            "defaultContent": "<span >0</span>" 
            },
            {
                "data": "outstanding_balance",
                render: function(data, _, row) {
                    console.log(data)
                    console.log(row)
                    if (data == null){
                        return (row.payoff_amount ? parseFloat(row.payoff_amount).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                    } else {
                        return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                    }

                }
            },
            {"data": "paid_amount",
            "defaultContent": "<span >0</span>" 
            },
            { "data": "loan_officer" },

        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "orientation": 'landscape',
        "columnDefs": [
           
            { "width": "20%", "targets": 0 },
            {
                "targets": 4,
                "width": "12",
                "className": "text-center"
            },
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
    
        
    });


    
    var dt_disbursed_loan = $('#dt-disbursed-loan').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Daily Disbursement",
                filename: "Daily Disbursement",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Daily Disbursement",
                filename: "Daily Disbursement",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Daily Disbursement",
                filename: "Daily Disbursement",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Daily Disbursement",
                filename: "Daily Disbursement",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
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
            "url": '/Admin/get/daily/disbursments',
            "data": {
                _csrf_token: $("#csrf").val(),
                "filter_application_date_from": $('#filter_application_date_from').val(),
                "filter_application_date_to": $('#filter_application_date_to').val(),
                "filter_approvedon_date_from": $('#filter_approvedon_date_from').val(),
                "filter_approvedon_date_to": $('#filter_approvedon_date_to').val(),
                "filter_loan_id": $('#filter_loan_id').val(),
                "filter_requested_amount": $('#filter_requested_amount').val(),
                "filter_nrc": $('#filter_nrc').val(),

            }
        },
                

        "columns": [
            { "data": "branch" },
            { "data": "client_no" },
            { "data": "id" },
            { "data": "loan_status" },
            { "data": "client_name" },
            { "data": "product_name" },
            { "data": "business_sector" },
            {"data": "application_date",
            "defaultContent": "<span class='text-warning'>Not Set</span>" 
            },
            { "data": "duedate" },
            { "data": "requested_amount"},
            { "data": "interest" },
            { "data": "interest_rate" },
            { "data": "repeat_loan" },
            { "data": "collateral_deposit"},
            { "data": "opening_date_deposit" },
            { "data": "expiration_date_deposit" },
            { "data": "pmec_value" },
            { "data": "pmec"},
            { "data": "phone_no" },
            { "data": "portfolio_category" },
            { "data": "loan_officer"},

        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "orientation": 'landscape',
        "columnDefs": [
           
            { "width": "20%", "targets": 0 },
            {
                "targets": 4,
                "width": "12",
                "className": "text-center"
            },
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
    
        
    });


    
    $("#admin-loan-disbursed-filter").on("click", function() {
        $("#loan_disbursed_filter_model").modal("show");
    });

    $("#admin_loan_disbursed_filter").on("click", function() {
        dt_disbursed_loan.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_loan_id = $("#filter_loan_id").val();
            // data.filter_loan_status = $("#filter_loan_status").val();
            data.filter_application_date_from = $("#filter_application_date_from").val();
            data.filter_application_date_to = $('#filter_application_date_to').val();
            data.filter_approvedon_date_from = $('#filter_approvedon_date_from').val();
            data.filter_approvedon_date_to = $('#filter_approvedon_date_to').val();
            data.filter_requested_amount = $("#filter_requested_amount").val();
            data.filter_nrc = $("#filter_nrc").val();
            // data.from = $("#from").val();
            // data.to = $("#to").val();
        });
        $("#loan_disbursed_filter_model").modal("hide");
        dt_disbursed_loan.draw();
    });


    var dt_dialy_deliquency = $('#dt-dialy-deliquency').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Daily Deliquency Per Agent",
                filename: "Deliquency Per Agent",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Daily Deliquency Per Agent",
                filename: "Deliquency Per Agent",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Daily Deliquency Per Agent",
                filename: "Deliquency Per Agent",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Daily Deliquency Per Agent",
                filename: "Deliquency Per Agent",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9]
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
            "url": '/Admin/get/daily/deliquency/report',
            "data": {
                _csrf_token: $("#csrf").val(),
                "filter_application_date_from": $('#filter_application_date_from').val(),
                "filter_application_date_to": $('#filter_application_date_to').val(),
                "filter_approvedon_date_from": $('#filter_approvedon_date_from').val(),
                "filter_approvedon_date_to": $('#filter_approvedon_date_to').val(),
                "filter_loan_id": $('#filter_loan_id').val(),
                "filter_requested_amount": $('#filter_requested_amount').val(),
                "filter_nrc": $('#filter_nrc').val(),

            }
        },
                

        "columns": [
            { "data": "credit_agent_ac" },
            {"data": "outstanding_portofilo",
            "defaultContent": "<span >0</span>" 
            },
            {"data": "amount_par1",
            "defaultContent": "<span >0</span>" 
            },
            {"data": "amount_par30",
            "defaultContent": "<span >0</span>" 
            },
            {"data": "amount_par60",
            "defaultContent": "<span >0</span>" 
            },
            {"data": "amount_par90",
            "defaultContent": "<span >0</span>" 
            },
            {
                "data": "par1",
                render: function(data, _, _) {
                    console.log(data)
                    return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                }
            },
            {
                "data": "par30",
                render: function(data, _, _) {
                    console.log(data)
                    return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                }
            },
            {
                "data": "par60",
                render: function(data, _, _) {
                    console.log(data)
                    return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                }
            },
            {
                "data": "par90",
                render: function(data, _, _) {
                    console.log(data)
                    return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
                }
            },
        
        ],
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "orientation": 'landscape',
        "columnDefs": [
           
            { "width": "20%", "targets": 0 },
            {
                "targets": 4,
                "width": "12",
                "className": "text-center"
            },
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
    
        
    });


    
    $("#admin-daily-deliquency-filter").on("click", function() {
        $("#daily_deliquency_filter_model").modal("show");
    });

    $("#admin_daily_deliquency_filter").on("click", function() {
        dt_dialy_deliquency.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_loan_id = $("#filter_loan_id").val();
            // data.filter_loan_status = $("#filter_loan_status").val();
            data.filter_application_date_from = $("#filter_application_date_from").val();
            data.filter_application_date_to = $('#filter_application_date_to').val();
            data.filter_approvedon_date_from = $('#filter_approvedon_date_from').val();
            data.filter_approvedon_date_to = $('#filter_approvedon_date_to').val();
            data.filter_requested_amount = $("#filter_requested_amount").val();
            data.filter_nrc = $("#filter_nrc").val();
            // data.from = $("#from").val();
            // data.to = $("#to").val();
        });
        $("#daily_deliquency_filter_model").modal("hide");
        dt_dialy_deliquency.draw();
    });




    var pending_loans_item_lookup = $('#pending-loans-item-lookup').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Pending Loans",
                filename: "Pending Loans",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Pending Loans",
                filename: "Pending Loans",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Pending Loans",
                filename: "Pending Loans",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Pending Loans",
                filename: "Pending Loans",
                exportOptions: {
                    columns: [  0, 1, 2, 3, 4, 5, 6, 7]
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
            "url": '/employee/get/all/pending/loans/lookup',
            "data": {
                _csrf_token: $("#csrf").val(),
                // "filter_loan_id": $('#filter_loan_id').val(),
                // "filter_loan_status": $('#filter_loan_status').val(),
                // "filter_application_date": $('#filter_application_date').val(),
                // "filter_application_date_to": $('#filter_application_date_to').val(),
                // "approvedon_date_from": $('#approvedon_date_from').val(),
                // "approvedon_date_to": $('#approvedon_date_to').val(),
                // "filter_requested_amount": $('#filter_requested_amount').val(),

            }
        },
                

        "columns": [
            { "data": "client_name" },
            { "data": "email_address" },
            { "data": "product_name" },
            { "data": "principal_amount" },
            { "data": "balance" },
            { "data": "total_repaid" },
            { "data": "balance" },
            { "data": "loan_status" },  
            { "data": "id" }        

        ],
       
        
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "columnDefs": [
           
            
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
        
    });















    var tracking_loans_item_lookup = $('#tracking-loans-item-lookup').DataTable({
        "responsive": true,
        "processing": true,
        "bFilter": false,
        "select": {
            "style": 'multi'
        },
        dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

        buttons: [
            {
                extend: 'excelHtml5',
                text: 'Excel',
                titleAttr: 'Loans Excel File',
                messageTop: "GNC Loan Tracker",
                filename: "Loan Tracker",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "GNC Loan Tracker",
                filename: "Loan Tracker",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                titleAttr: 'Loans print Out File',
                messageTop: "GNC Loan Tracker",
                filename: "Loan Tracker",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                titleAttr: 'Loans CSV File',
                messageTop: "GNC Loan Tracker",
                filename: "Loan Tracker",
                exportOptions: {
                    columns: [  0, 1, 2, 3, 4, 5, 6, 7]
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
            "url": '/employee/get/all/tracking/loans/lookup',
            "data": {
                _csrf_token: $("#csrf").val(),
                // "filter_loan_id": $('#filter_loan_id').val(),
                // "filter_loan_status": $('#filter_loan_status').val(),
                // "filter_application_date": $('#filter_application_date').val(),
                // "filter_application_date_to": $('#filter_application_date_to').val(),
                // "approvedon_date_from": $('#approvedon_date_from').val(),
                // "approvedon_date_to": $('#approvedon_date_to').val(),
                // "filter_requested_amount": $('#filter_requested_amount').val(),

            }
        },
                

        "columns": [
            { "data": "client_name" },
            { "data": "email_address" },
            { "data": "product_name" },
            { "data": "principal_amount" },
            { "data": "balance" },
            { "data": "total_repaid" },
            { "data": "balance" },
            { "data": "loan_status" },  
            { "data": "id" }        

        ],
       
        
        "lengthChange": true,
        "lengthMenu": [
            [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
            [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
        ],

        
        "order": [
            [1, 'asc']
        ],
        "columnDefs": [
           
            
            {
                "targets": 2,
                "className": "text-right fw-500"
            },
            {
                "targets": "_all",
                "defaultContent": '<span style="color: red">Not Set</span>'
            },
        ],
        
    });





    $('#example1 tbody').on('click', '.activatemsgresent', function (e) {
        e.preventDefault();
        let button = $(this)
        Swal.fire({
            title: 'Are you sure you want to Resend?',
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
                    url: '/Admin/maintenance/sms/activate',
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
                    'Resend Cancelled!'
                )
            }
        });
    });









    
  

