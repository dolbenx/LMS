//Approve Employer 
$('#dt-basic-example').on('click', '.js-sweetalert2-approve_employer', function(e) {
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
                url: '/Employer/Approve',
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


//Approve Employee
$('#dt-basic-example').on('click', '.js-sweetalert2-approve_employee', function(e) {
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
                url: '/Employee/Approve',
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


//Approve Offtaker 
$('#dt-basic-example').on('click', '.js-sweetalert2-approve_offtaker', function(e) {
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
                url: '/Offtaker/Approve',
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

//Approve Loan Product 
$('#dt-basic-example').on('click', '.js-sweetalert2-approve_loan_products', function(e) {
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
                url: '/Approve/Loan/Products',
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

//Approve Savings Product 
$('#dt-basic-example').on('click', '.js-sweetalert2-approve_savings_products', function(e) {
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
                url: '/Approve/Savings/Products',
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

//Approve Individual
$('#dt-basic-example').on('click', '.js-sweetalert2-approve_individual', function(e) {
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
                url: '/Approve/Individual',
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

//Approve SME
$('#dt-basic-example').on('click', '.js-sweetalert2-approve_sme', function(e) {
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
                url: '/Approve/SME',
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

//////////////////////////////////////////////////////////// May 2022 - RUSSELL ////////////////////////////////////////////////////

$("#admin-fixed-deposits-filter").on("click", function() {
    $("#fixed_deposits_filter_model").modal("show");
});

$("#admin_fixed_deposits_filter").on("click", function() {
    fixed_deposits_records_dt.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.customer_first_name = $("#customer_first_name").val();
        data.customer_last_name = $("#customer_last_name").val();
        data.product_name = $("#product_name").val();
        data.divestment_type = $("#divestment_type").val();
        data.fixed_deposit_status = $("#fixed_deposit_status").val();
        data.currency_id = $("#currency_id").val();
        data.product_minimum_amount = $("#product_minimum_amount").val();
        data.product_maximum_amount = $("#product_maximum_amount").val();
        data.deposit_date_from = $("#deposit_date_from").val();
        data.deposit_date_to = $("#deposit_date_to").val();
        data.maturity_date_from = $("#maturity_date_from").val();
        data.maturity_date_to = $("#maturity_date_to").val();

    });
    $("#fixed_deposits_filter_model").modal("hide");
    fixed_deposits_records_dt.draw();
});


var divestment_data_records_dt = $("#dt-divestment-entries").DataTable({
    responsive: true,
    processing: true,
    language: {
        loadingRecords: "&nbsp;",
        processing: '<i class="spinner spinner-primary spinner-lg mr-15"></i><span class="sr-only" style="color: black;">Loading...</span> ',
    },

    serverSide: true,
    paging: true,
    ajax: {
        type: "POST",
        url: "/Generate/Customer/Divestment/Reports",
        data: {
            _csrf_token: $("#csrf").val(),
            id: $("#id").val(),
            div_customer_first_name: $("#div_customer_first_name").val(),
            div_customer_last_name: $("#div_customer_last_name").val(),
            div_product_name: $("#div_product_name").val(),
            div_divestment_type: $("#div_divestment_type").val(),
            div_product_minimum_amount: $("#div_product_minimum_amount").val(),
            div_product_maximum_amount: $("#div_product_maximum_amount").val(),
            divestment_date_from: $("#divestment_date_from").val(),
            divestment_date_to: $("#divestment_date_to").val(),
           
           
        },
    },

    columns: [

    
       
        { data: "div_customerName" },
        { data: "div_divestmentType" },
        { data: "product_name" },
        { data: "div_divestmentDate" },
        { data: "div_fixedPeriod" },
        { data: "div_divestmentValuation" },
        { data: "div_principalAmount" },
        { data: "div_interestAccrued" },
        { data: "div_divestAmount" },
      
    
     
    ],
    lengthMenu: [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000],
    ],
    order: [
        [1, "asc"]
    ],
  
});


var fixed_deposits_records_dt = $("#dt-fixed-deposits-entries").DataTable({
    responsive: true,
    processing: true,
    language: {
        loadingRecords: "&nbsp;",
        processing: '<i class="spinner spinner-primary spinner-lg mr-15"></i><span class="sr-only" style="color: black;">Loading...</span> ',
    },

    serverSide: true,
    paging: true,
    ajax: {
        type: "POST",
        url: "/Generate/Fixed/Deposit/Reports",
        data: {
            _csrf_token: $("#csrf").val(),
            id: $("#id").val(),
            customer_first_name: $("#customer_first_name").val(),
            customer_last_name: $("#customer_last_name").val(),
            product_name: $("#product_name").val(),
            divestment_type: $("#divestment_type").val(),
            fixed_deposit_status: $("#fixed_deposit_status").val(),
            currency_id: $("#currency_id").val(),
            product_minimum_amount: $("#product_minimum_amount").val(),
            product_maximum_amount: $("#product_maximum_amount").val(),
            deposit_date_from: $("#deposit_date_from").val(),
            deposit_date_to: $("#deposit_date_to").val(),
            maturity_date_from: $("#maturity_date_from").val(),
            maturity_date_to: $("#maturity_date_to").val(),
           
        },
    },

    columns: [

    
       
        { data: "customerName" },
        { data: "date_details" },
        {
            data: null,
            render: function(data, type, row) {
                return data.product_name + " |  " + data.fixedPeriod + " " + data.fixedPeriodType;
            },
        },
        { data: "fixedDepositStatus" },
        { data: "div_divestmentType" },
        { data: "principalAmount" },
        { data: "expectedInterest" },
        { data: "user_totalCharges" },
        { data: "accruedInterest" },
      
    
     
    ],
    lengthMenu: [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000],
    ],
    order: [
        [1, "asc"]
    ],
  
});

$("#admin-divestment-filter").on("click", function() {
    $("#divestment_records_filter_model").modal("show");
});

$("#admin_divestment_report_filter").on("click", function() {
    divestment_data_records_dt.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.div_customer_first_name = $("#div_customer_first_name").val();
        data.div_customer_last_name = $("#div_customer_last_name").val();
        data.div_product_name = $("#div_product_name").val();
        data.div_divestment_type = $("#div_divestment_type").val();
        data.div_product_minimum_amount = $("#div_product_minimum_amount").val();
        data.div_product_maximum_amount = $("#div_product_maximum_amount").val();
        data.divestment_date_from = $("#divestment_date_from").val();
        data.divestment_date_to = $("#divestment_date_to").val();

    });
    $("#divestment_records_filter_model").modal("hide");
    divestment_data_records_dt.draw();
});


var customer_txn_data_records_dt = $("#dt-all-customer-txn-entries").DataTable({
    responsive: true,
    processing: true,
    language: {
        loadingRecords: "&nbsp;",
        processing: '<i class="spinner spinner-primary spinner-lg mr-15"></i><span class="sr-only" style="color: black;">Loading...</span> ',
    },

    serverSide: true,
    paging: true,
    ajax: {
        type: "POST",
        url: "/Generate/Customer/transaction/Reports",
        data: {
            _csrf_token: $("#csrf").val(),
            id: $("#id").val(),
            txn_customer_first_name: $("#txn_customer_first_name").val(),
            txn_customer_last_name: $("#txn_customer_last_name").val(),
            txn_customer_phone_number: $("#txn_customer_phone_number").val(),
            customer_txn_status: $("#customer_txn_status").val(),
            txn_product_name: $("#txn_product_name").val(),
            transaction_type: $("#transaction_type").val(),
            txn_product_minimum_amount: $("#txn_product_minimum_amount").val(),
            txn_product_maximum_amount: $("#txn_product_maximum_amount").val(),
            txn_date_from: $("#txn_date_from").val(),
            txn_date_to: $("#txn_date_to").val(),
           
        },
    },

    columns: [     
        { data: "txn_customerName" },
        { data: "txn_referenceNo" },
        { data: "product_name" },
        { data: "txn_isReversed" },
        { data: "txn_status" },
        { data: "txn_transactionTypeEnum" },
        { data: "txn_transactionType" },
        {
            data: "txn_inserted_at",
            render: function(data, type, row) {
                if (data) {
                    var options = {
                        year: "numeric",
                        month: "short",
                        day: "numeric",
                        hour: "2-digit",
                        minute: "2-digit",
                        second: "2-digit",
                    };
                    var today = new Date(data);
                    return today.toLocaleDateString("en-GB", options); //.dateFormat("dd-mmm-yyyy, HH:MM:SS")
                }
            },
        },
        { data: "txn_totalAmount" },
     
    ],
    lengthMenu: [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000],
    ],
    order: [
        [1, "asc"]
    ],
  
});


$("#admin-all-customer-txn-filter").on("click", function() {
    $("#customer_txn_filter_model").modal("show");
});

$("#admin_all_customer_txn_report_filter").on("click", function() {
    customer_txn_data_records_dt.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.txn_customer_first_name = $("#txn_customer_first_name").val();
        data.txn_customer_last_name = $("#txn_customer_last_name").val();
        data.txn_customer_phone_number = $("#txn_customer_phone_number").val();
        data.customer_txn_status = $("#customer_txn_status").val();
        data.txn_product_name = $("#txn_product_name").val();
        data.transaction_type = $("#transaction_type").val();
        data.txn_product_minimum_amount = $("#txn_product_minimum_amount").val();
        data.txn_product_maximum_amount = $("#txn_product_maximum_amount").val();
        data.txn_date_from = $("#txn_date_from").val();
        data.txn_date_to = $("#txn_date_to").val();

    });
    $("#customer_txn_filter_model").modal("hide");
    customer_txn_data_records_dt.draw();
});





var customer_data_records_dt = $("#dt-all-customer-entries").DataTable({
    responsive: true,
    processing: true,
    language: {
        loadingRecords: "&nbsp;",
        processing: '<i class="spinner spinner-primary spinner-lg mr-15"></i><span class="sr-only" style="color: black;">Loading...</span> ',
    },

    serverSide: true,
    paging: true,
    ajax: {
        type: "POST",
        url: "/Generate/all/Customer//Reports",
        data: {
            _csrf_token: $("#csrf").val(),
            id: $("#id").val(),
            txn_client_first_name: $("#txn_client_first_name").val(),
            txn_client_last_name: $("#txn_client_last_name").val(),
            txn_client_phone_number: $("#txn_client_phone_number").val(),
            client_txn_status: $("#client_txn_status").val(),
            txn_product_name: $("#txn_product_name").val(),
            transaction_type: $("#transaction_type").val(),
            txn_product_minimum_amount: $("#txn_product_minimum_amount").val(),
            txn_product_maximum_amount: $("#txn_product_maximum_amount").val(),
            txn_date_from: $("#txn_date_from").val(),
            txn_date_to: $("#txn_date_to").val(),
           
        },
    },

    columns: [     
        { data: "txn_customerName" },
        { data: "mobileNumber" },
        { data: "meansOfIdentificationNumber" },
        { data: "txn_totalAmount" },
        { data: "user_status" },
      

     
    ],
    lengthMenu: [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000],
    ],
    order: [
        [1, "asc"]
    ],
  
});


$("#admin-all-customer-filter").on("click", function() {
    $("#customer_filter_model").modal("show");
});

$("#admin_all_customer_report_filter").on("click", function() {
    customer_data_records_dt.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.txn_client_first_name = $("#txn_client_first_name").val();
        data.txn_client_last_name = $("#txn_client_last_name").val();
        data.txn_client_phone_number = $("#txn_client_phone_number").val();
        data.client_txn_status = $("#client_txn_status").val();
        data.txn_product_name = $("#txn_product_name").val();
        data.transaction_type = $("#transaction_type").val();
        data.txn_product_minimum_amount = $("#txn_product_minimum_amount").val();
        data.txn_product_maximum_amount = $("#txn_product_maximum_amount").val();
        data.txn_date_from = $("#txn_date_from").val();
        data.txn_date_to = $("#txn_date_to").val();

    });
    $("#customer_filter_model").modal("hide");
    customer_data_records_dt.draw();
});



$('#create-usr-role').click(function () {

    if ($("#role_group").val() == "") {
        swal({
            title: "Opps",
            text: "Select Access level !",
            confirmButtonColor: "#2196F3",
            type: "error"
        });
        return false;
    };

    if ($("#role-desc").val() == "") {
        swal({
            title: "Opps",
            text: "Select Access level !",
            confirmButtonColor: "#2196F3",
            type: "error"
        });
        return false;
    }

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
            var data = $("form").serialize();
            // spinner.show();
            console.log("Chech here");
            console.log(data);

            $.ajax({
                url: '/Create/New/User/Roles',
                type: 'POST',
                data: data,
                success: function (result) {
                    if (result.info) {
                        // spinner.hide();
                        $("input[type='checkbox']").each(function () {
                            this.checked = false;
                        });
                        $('#role-desc').val('');
                        Swal.fire(
                            'Success!',
                            'Operation complete!',
                            'success'
                        )
                        window.setTimeout(function () { location.reload() }, 1600)
                    } else {
                        // spinner.hide();
                        Swal.fire(
                            'Oops...',
                            result.error,
                            'error'
                        )
                    }
                },
                error: function (request, msg, error) {
                    // spinner.hide();
                    Swal.fire(
                        'Oops...',
                        'Something went wrong!',
                        'error'
                    )
                }
            });
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




//////////////////////////////////////////////////////////// May 2022 - RUSSELL ////////////////////////////////////////////////////