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
                    var product_name = capa.product_name;

                    $('#product_id').val(product_id);
                    $('#product_code').val(product_code).prop('readonly', true);
                    $('#max_amount').val(max_amount).prop('readonly', true);
                    $('#min_amount').val(min_amount).prop('readonly', true);
                    $('#product_type').val(product_type).prop('readonly', true);
                    $('#period_type').val(period_type).prop('readonly', true);
                    $('#currency_name').val(currency_name).prop('readonly', true);
                    $('#product_name').val(product_name).prop('readonly', true);


                }

            },
            error: function(request, msg, error) {
                $('.loading').hide();
            }
        });
    });
});

$(document).ready(function() {
    $('.admin-employee-number').on('change', function() {
        if ($('#select_number').val() == "Un-Employed") {
            $('#number_disable').prop('readonly', true) 
            $('#number_disable').val("No Details")

            $('#number1_disable').prop('readonly', true) 
            $('#number1_disable').val("No Details")

            $('#number2_disable').prop('readonly', true) 
            $('#number2_disable').val("No Details")

            $('#number3_disable').prop('readonly', true) 
            $('#number3_disable').val("No Details")

            $('#number4_disable').prop('readonly', true) 
            $('#number4_disable').val("No Details")

            $('#number5_disable').prop('readonly', true) 
            $('#number5_disable').val("No Details")

            $('#number6_disable').prop('readonly', true) 
            $('#number6_disable').val("No Details")

            $('#number7_disable').prop('readonly', true) 
            $('#number7_disable').val("No Details")

            $('#number8_disable').prop('readonly', true) 
            $('#number8_disable').val("No Details")

            $('#number9_disable').prop('readonly', true) 
            $('#number9_disable').val("No Details")

            $('#number10_disable').prop('readonly', true) 
            $('#number10_disable').val("No Details")

            $('#number11_disable').prop('readonly', true) 
            $('#number11_disable').val("No Details")

            $('#number12_disable').prop('readonly', true) 
            $('#number12_disable').val("No Details")

            $('#number13_disable').prop('readonly', true) 
            $('#number13_disable').val("No Details")

            $('#number14_disable').prop('readonly', true) 
            $('#number14_disable').val("No Details")
           
        }
        else {
            $('#number_disable').prop('readonly', false)
            $('#number1_disable').prop('readonly', false)
            $('#number2_disable').prop('readonly', false)
            $('#number3_disable').prop('readonly', false)
            $('#number4_disable').prop('readonly', false)
            $('#number5_disable').prop('readonly', false)
            $('#number6_disable').prop('readonly', false)
            $('#number7_disable').prop('readonly', false)
            $('#number8_disable').prop('readonly', false)
            $('#number9_disable').prop('readonly', false)
            $('#number10_disable').prop('readonly', false)
            $('#number11_disable').prop('readonly', false)
            $('#number12_disable').prop('readonly', false)
            $('#number13_disable').prop('readonly', false)
            $('#number14_disable').prop('readonly', false)
            $('.clear_form').val('');
        }
       
    });
})

$(document).ready(function() {
    $('#client_type').on('change', function() {
        let client_type = $(this).find(':selected').attr('data-client_type_opt');
        if (client_type == "Employee"){
            console.log("am here man!!!");
            console.log(client_type);
            $("#select_company").hide();
            $("#select1_company").show();
            $("#select2_company").show();
            $("#select3_company").hide();
            $("#client_employment_Status").hide();
        }
        else
        if  (client_type == "Individual")
        {
            $("#select_company").show();
            $("#select1_company").hide();
            $("#select2_company").hide();
            $("#select3_company").show();
            $("#client_employment_Status").show(); 
        }
    })
});

$(document).ready(function() {

    $('#employment_type').on('change', function() {
     
        let employment_type = $(this).find(':selected').attr('data-employment_type');
        
        if (employment_type == "Permanent"){
            $("#employment_status").hide();
        }
        else
        if  (employment_type == "Contract")
        {
            $("#employment_status").show();

            
        }

    })

});

$(document).ready(function() {

    $('#payment_type').on('change', function() {
     
        let payment_type = $(this).find(':selected').attr('data-payment-type');
        
        if (payment_type == "Mobile"){
            $("#mobile").show();
            $("#bank").hide();
        }
        else
        if  (payment_type == "Bank")
        {
            $("#mobile").hide();
            $("#bank").show();

            
        }

    })

});

$(document).ready(function() {

    $('#offtaker_mou').on('change', function() {
     
        let offtaker_mou = $(this).find(':selected').attr('data-offtaker-mou');
        
        if (offtaker_mou == "YES"){
            $("#offtaker").show();
            $("#mou_yes").show();
            $("#mou_no").hide();
        }
        else
        if  (offtaker_mou == "NO")
        {
            $("#offtaker").hide();
            $("#mou_yes").hide();
            $("#mou_no").show();

            
        }

    })

});


$(document).ready(function() {
    $('.admin-disability-change').on('change', function() {
        if ($('#select_disability').val() == "N/A") {
            $('#disability_disable').prop('readonly', true) 
            $('#disability_disable').val("No Detail")
        }
        else {
            $('#disability_disable').prop('readonly', false)
            $('.clear_form').val('');
        }
       
    });
})

$(document).ready(function() {
    $('.admin-company-lookup').on('change', function() {
        if ($('#company_id').val() == "") {
            return false;
        }
        $.ajax({
            url: '/Admin/credit/operation/employee/lookup',
            type: 'post',
            data: {
                "company_id": $('#company_id').val(),
                "_csrf_token": $("#csrf").val()
            },
            success: function(result) {
                if (result.data.length < 1) {

                    return false
                } else {
                    capa = result.data[0];
                    console.log("capa");
                    console.log(capa);

                    var company_id = capa.company_id;
                    var company_phone = capa.companyPhone;
                    var registration_number = capa.registrationNumber;
                    var contact_email = capa.contactEmail;

                    var company_name = capa.companyName;
                    var company_accountNumber = capa.companyAccountNumber;
                    var company_registrationDate = capa.companyRegistrationDate;

                    var status = capa.status;

                    var taxno = capa.taxno;
                   
               

                    $('#company_id').val(company_id);
                    $('#company_phone').val(company_phone).prop('readonly', true);
                    $('#registration_number').val(registration_number).prop('readonly', true);
                    $('#contact_email').val(contact_email).prop('readonly', true);

                    $('#company_name').val(company_name).prop('readonly', true);
                    $('#company_accountNumber').val(company_accountNumber).prop('readonly', true);
                    $('#company_registrationDate').val(company_registrationDate).prop('readonly', true);
                    $('#status').val(status).prop('readonly', true);
                    $('#taxno').val(taxno).prop('readonly', true);
              
         
                 

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
        $('#product-name-summary').val($('#product_name').val()).prop('readonly', true);
        $('#product-code-summary').val($('#product_code').val()).prop('readonly', true);
        $('#product-type-summary').val($('#product_type').val()).prop('readonly', true);
        $('#currency-summary').val($('#currency_name').val()).prop('readonly', true);
        $('#min-amount-summary').val($('#min_amount').val()).prop('readonly', true);
        $('#max-amount-summary').val($('#max_amount').val()).prop('readonly', true);
        $('#repayment-type-summary').val($('#repayment_type').val()).prop('readonly', true);
        $('#disbursement-summary').val($('#disbursement').val()).prop('readonly', true);
        $('#amount-summary').val($('#amount_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);
        $('#user-role-summary').val($('#user_role').val()).prop('readonly', true);


    });
});




$(document).ready(function() {

    $('#product_id').on('change', function() {
        $('#identification-data-id').val($('#identification_id').val()).prop('readonly', true);
        $('#id-means-data').val($('#id_means').val()).prop('readonly', true);
        $('#first-name-data').val($('#first_name_id').val()).prop('readonly', true);
        $('#other-name-data').val($('#other_name_id').val()).prop('readonly', true);
        $('#last-name-data').val($('#last_name_id').val()).prop('readonly', true);
        $('#gender-data').val($('#id_gender').val()).prop('readonly', true);
        $('#dob-data').val($('#dob_id').val()).prop('readonly', true);
        $('#mobile-data').val($('#mobile_id').val()).prop('readonly', true);
        $('#email-data').val($('#email_id').val()).prop('readonly', true);
        $('#product-name-data').val($('#product_name').val()).prop('readonly', true);
        $('#product-id-data').val($('#product_id').val()).prop('readonly', true);
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


    $('#dob_id').on('change', function() {
        $("#user_role").show();

    })


});



$(document).ready(function() {

    $('#emp_disbursement_method').on('change', function() {

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

    })

});


$(document).ready(function() {

    $('#bank_account_no').on('input', function() {

        $('#summary-bank-name').val($('#bank_name').val()).prop('readonly', true);
        $('#summary-bank-account-no').val($('#bank_account_no').val()).prop('readonly', true);
        $('#summary-account-name').val($('#bank_account_name').val()).prop('readonly', true);

    });
});

//////////////////////////////////////////////////// RUSSELL ///////////////////////////////////////////////////////////////////

$(document).ready(function() {

    $('#emp_disbursement_method').on('change', function() {
        $('#identification-summary-id').val($('#identification_id').val()).prop('readonly', true);
        $('#id-means-summary').val($('#id_means').val()).prop('readonly', true);
        $('#first-name-summary').val($('#first_name_id').val()).prop('readonly', true);
        $('#other-name-summary').val($('#other_name_id').val()).prop('readonly', true);
        $('#last-name-summary').val($('#last_name_id').val()).prop('readonly', true);
        $('#gender-summary').val($('#id_gender').val()).prop('readonly', true);
        $('#dob-summary').val($('#dob_id').val()).prop('readonly', true);
        $('#mobile-summary').val($('#mobile_id').val()).prop('readonly', true);
        $('#email-summary').val($('#email_id').val()).prop('readonly', true);
        $('#product-name-summary').val($('#product_name').val()).prop('readonly', true);
        $('#product-code-summary').val($('#product_code').val()).prop('readonly', true);
        $('#product-type-summary').val($('#product_type').val()).prop('readonly', true);
        $('#currency-summary').val($('#currency_name').val()).prop('readonly', true);
        $('#min-amount-summary').val($('#min_amount').val()).prop('readonly', true);
        $('#max-amount-summary').val($('#max_amount').val()).prop('readonly', true);
        $('#repayment-type-summary').val($('#repayment_type').val()).prop('readonly', true);
        $('#disbursement-summary').val($('#disbursement_method').val()).prop('readonly', true);
        $('#amount-summary').val($('#amount_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);
        $('#user-role-summary').val($('#user_role').val()).prop('readonly', true);


    });



    var dt_loan_product = $('#dt-loan-product-other').DataTable({
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
            "url": '/products/items/view',
            "data": {
                _csrf_token: $("#csrf").val(),
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
            { "data": "profit" },
            { "data": "period_type" },
            { "data": "interest" },
            { "data": "interestMode" },
            {
                "data": "status",
                render: function(data, _, row) {
                    let show = "";
                    if (data === "INACTIVE") {
                        show = "<td><span class='badge bg-danger bg-pill'>INACTIVE</span></td>";
                    }
                    if (data === "ACTIVE") {
                        show = "<td><span class='badge bg-success bg-pill'>ACTIVE </span></td>";
                    }
                    if (data === "PENDING_APPROVAL") {
                        show = "<td><span class='badge bg-warning bg-pill'>PENDING APPROVAL </span></td>";
                    }
                    if (data === "PENDING") {
                        show = "<td><span class='badge bg-warning bg-pill'>PENDING </span></td>";    
                    }
                    return show;
                }
            },

            {

                data: "id",
                render: function (data, type, row) {
                    product_id = row.id;
                    product_name = row.product_name;
                    interest = row.interest;
                    details = row.details;
                    currencyId = row.currencyId + "|||" + row.currency_names;
                    interestMode = row.interestMode;
                    currency_name = row.currency_name;
                    interest_type = row.interest_type;
                    product_type = row.product_type;
                    max_amount = row.max_amount;
                    min_amount = row.min_amount;
                    period_type = row.period_type;
                    product_code = row.product_code;
                    yearLengthInDays = row.yearLengthInDays;
                    defaultPeriod = row.defaultPeriod;
                    principle_account_id = row.principle_account_id;
                    interest_account_id = row.interest_account_id;
                    charges_account_id = row.charges_account_id;
                    classification_id = row.classification_id;
                    interest_rates = row.interest_rates;
                    processing_fee = row.processing_fee;
                    repayment = row.repayment;
                    tenor = row.tenor;
                    price_rate_id = row.price_rate_id;
                    product_charge_id = row.product_charge_id.id || 0 ;


                    if (row.status != "ACTIVE") {
                        return `
 
                            <a data-product-id="${row.id}" class="js-approve-product-other btn ripple btn-sm btn-success">
                                <i class="ki ki-check icon-sm"></i> Aprove </a>
                             
                            <a  class="btn ripple btn-sm btn-info" href="/Admin/edit/products?product_id=${row.product_id}">
                            <i class="flaticon-edit-1 icon-sm"></i> Edit </a>

                            <a class="btn ripple btn-warning btn-sm"
                                data-target="#viewproductadmin"
                                data-toggle="modal"
                                data-product_id="${product_id}"
                                data-product_name= "${product_name}"
                                data-interest= "${interest}"
                                data-details= "${details}"
                                data-currency_name= "${currency_name}"
                                data-currency_id = "${currencyId}"
                                data-interest_mode= "${interestMode}"
                                data-interest_type= "${interest_type}"
                                data-product_type = "${product_type}"
                                data-max_amount ="${max_amount}"
                                data-min_amount = "${min_amount}"
                                data-period_type = "${period_type}"
                                data-product_code = "${product_code}"
                                data-year = "${yearLengthInDays}"
                                data-default_period ="${defaultPeriod}"
                                data-principle_account_id ="${principle_account_id}"
                                data-interest_account_id ="${interest_account_id}"
                                data-charges_account_id ="${charges_account_id}"
                                data-classification_id ="${classification_id}"
                                data-interest_rates ="${interest_rates}"
                                data-processing_fee ="${processing_fee}"
                                data-repayment ="${repayment}"
                                data-tenor ="${tenor}"
                                data-price_rate_id = "${price_rate_id}">
                            <i class="flaticon-eye icon-sm"></i> View </a> 
                        `;
                    };

                    if (row.status == "ACTIVE") {
                        return `

                            <a data-product-id="${row.id}" class="js-disable-product btn ripple btn-sm btn-danger">
                                <i class="ki ki-close icon-sm icon-sm"></i> Disable </a>
                            
                                
                                <a  class="btn ripple btn-sm btn-info" href="/Admin/edit/products?product_id=${row.product_id}">
                                <i class="flaticon-edit-1 icon-sm"></i> Edit </a>

                            <a class="btn ripple btn-sm btn-warning"
                                data-target="#viewproductadmin"
                                data-toggle="modal"
                                data-product_id="${product_id}"
                                data-product_name= "${product_name}"
                                data-interest= "${interest}"
                                data-details= "${details}"
                                data-currency_id = "${currencyId}"
                                data-currency_name= "${currency_name}"
                                data-interest_mode= "${interestMode}"
                                data-interest_type= "${interest_type}"
                                data-product_type = "${product_type}"
                                data-max_amount ="${max_amount}"
                                data-min_amount = "${min_amount}"
                                data-period_type = "${period_type}"
                                data-product_code = "${product_code}"
                                data-year = "${yearLengthInDays}"
                                data-default_period ="${defaultPeriod}"
                                data-principle_account_id ="${principle_account_id}"
                                data-interest_account_id ="${interest_account_id}"
                                data-charges_account_id ="${charges_account_id}"
                                data-classification_id ="${classification_id}"
                                data-interest_rates ="${interest_rates}"
                                data-processing_fee ="${processing_fee}"
                                data-repayment ="${repayment}"
                                data-tenor ="${tenor}"
                                data-price_rate_id = "${price_rate_id}">
                            <i class="flaticon-eye icon-sm"></i> View </a> 
                        `;
                    }


                },



                "defaultContent": "<span class='text-danger'>No Actions</span>"
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

            {
                "targets": 5,
                "className": "text-center"
            }
        ]
    });



    $("#admin-loan-products-filter").on("click", function() {
        $("#product_filter_model").modal("show");
    });

    $("#admin_loan_products_filter").on("click", function() {
        dt_loan_product.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_product_name = $("#filter_product_name").val();
            data.filter_product_type = $("#filter_product_type").val();
            data.filter_minimum_principal = $("#filter_minimum_principal").val();
            data.filter_maximum_principal = $("#filter_maximum_principal").val();
            data.from = $("#from").val();
            data.to = $("#to").val();
        });
        $("#product_filter_model").modal("hide");
        dt_loan_product.draw();
    });



    $('#dt-loan-product-other').on('click', '.js-approve-product-other', function(e) {
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
                    url: '/Admin/view/system/products/activate',
                    type: 'POST',
                    data: { id: button.attr("data-product-id"), _csrf_token: $('#csrf').val() },
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

    $('#dt-loan-product-other').on('click', '.js-disable-product', function(e) {
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
                    url: '/Admin/view/system/products/deactivate',
                    type: 'POST',
                    data: { id: button.attr("data-product-id"), _csrf_token: $('#csrf').val() },
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




    var dt_customer_all_loans_list = $('#dt-customer-all-loans-list').DataTable({
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
            "url": '/all/customer/loans/list',
            "data": {
                _csrf_token: $("#csrf").val(),
                "id": $('#id').val(),
                "filter_customer_first_name": $('#filter_customer_first_name').val(),
                "filter_customer_last_name": $('#filter_customer_last_name').val(),
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
            { "data": "product_name" },
            { "data": "principal_amount" },
            { "data": "interest_outstanding_derived" },
            { "data": "disbursedon_date" },
            { "data": "applied_date" },

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


    $("#admin-customer-loans-filter").on("click", function() {
        $("#customer_loans_filter_model").modal("show");
    });

    $("#admin_customer_loan_filter").on("click", function() {
        dt_customer_all_loans_list.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.filter_customer_first_name = $("#filter_customer_first_name").val();
            data.filter_customer_last_name = $("#filter_customer_last_name").val();
            data.filter_product_name = $("#filter_product_name").val();
            data.filter_product_type = $("#filter_product_type").val();
            data.filter_minimum_principal = $("#filter_minimum_principal").val();
            data.filter_maximum_principal = $("#filter_maximum_principal").val();
            data.from = $("#from").val();
            data.to = $("#to").val();
        });
        $("#customer_loans_filter_model").modal("hide");
        dt_customer_all_loans_list.draw();
    });
});
//////////////////////////////////////////////////// RUSSELL ///////////////////////////////////////////////////////////////////

// ######################################################### MOMO LOAN APPLICATION #########################################################

$(document).ready(function() {



    $('#hide_disbursement_method').on('change', function() {

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

    })

    $('#mobile_disbursement_method').on('change', function() {

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

    })

});

$(document).ready(function() {

    $('#bank_account_no').on('input', function() {

        $('#summary-bank-name').val($('#bank_name').val()).prop('readonly', true);
        $('#summary-bank-account-no').val($('#bank_account_no').val()).prop('readonly', true);
        $('#summary-account-name').val($('#bank_account_name').val()).prop('readonly', true);
        $('#summary-wallet-number').val($('#bevura_wallet_no').val()).prop('readonly', true);
        $('#summary-receipient-number').val($('#receipient_number').val()).prop('readonly', true);

    });

    $('#receipient_number').on('input', function() {

        $('#summary-wallet-number').val($('#bevura_wallet_no').val()).prop('readonly', true);
        $('#summary-receipient-number').val($('#receipient_number').val()).prop('readonly', true);

    });


    $('#mobile_disbursement_method').on('change', function() {
        $('#identification-summary-id').val($('#identification_id').val()).prop('readonly', true);
        $('#id-means-summary').val($('#id_means').val()).prop('readonly', true);
        $('#first-name-summary').val($('#first_name_id').val()).prop('readonly', true);
        $('#other-name-summary').val($('#other_name_id').val()).prop('readonly', true);
        $('#last-name-summary').val($('#last_name_id').val()).prop('readonly', true);
        $('#gender-summary').val($('#id_gender').val()).prop('readonly', true);
        $('#dob-summary').val($('#dob_id').val()).prop('readonly', true);
        $('#mobile-summary').val($('#mobile_id').val()).prop('readonly', true);
        $('#email-summary').val($('#email_id').val()).prop('readonly', true);
        $('#product-name-summary').val($('#product_name').val()).prop('readonly', true);
        $('#product-code-summary').val($('#product_code').val()).prop('readonly', true);
        $('#product-type-summary').val($('#product_type').val()).prop('readonly', true);
        $('#currency-summary').val($('#currency_name').val()).prop('readonly', true);
        $('#min-amount-summary').val($('#min_amount').val()).prop('readonly', true);
        $('#max-amount-summary').val($('#max_amount').val()).prop('readonly', true);
        $('#repayment-type-summary').val($('#repayment_type').val()).prop('readonly', true);
        $('#disbursement-summary').val($('#disbursement_method').val()).prop('readonly', true);
        $('#amount-summary').val($('#amount_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);
        $('#user-role-summary').val($('#user_role').val()).prop('readonly', true);


    });

    $('#hide_disbursement_method').on('change', function() {
        $('#identification-summary-id').val($('#identification_id').val()).prop('readonly', true);
        $('#id-means-summary').val($('#id_means').val()).prop('readonly', true);
        $('#first-name-summary').val($('#first_name_id').val()).prop('readonly', true);
        $('#other-name-summary').val($('#other_name_id').val()).prop('readonly', true);
        $('#last-name-summary').val($('#last_name_id').val()).prop('readonly', true);
        $('#gender-summary').val($('#id_gender').val()).prop('readonly', true);
        $('#dob-summary').val($('#dob_id').val()).prop('readonly', true);
        $('#mobile-summary').val($('#mobile_id').val()).prop('readonly', true);
        $('#email-summary').val($('#email_id').val()).prop('readonly', true);
        $('#product-name-summary').val($('#product_name').val()).prop('readonly', true);
        $('#product-code-summary').val($('#product_code').val()).prop('readonly', true);
        $('#product-type-summary').val($('#product_type').val()).prop('readonly', true);
        $('#currency-summary').val($('#currency_name').val()).prop('readonly', true);
        $('#min-amount-summary').val($('#min_amount').val()).prop('readonly', true);
        $('#max-amount-summary').val($('#max_amount').val()).prop('readonly', true);
        $('#repayment-type-summary').val($('#repayment_type').val()).prop('readonly', true);
        $('#disbursement-summary').val($('#disbursement_method').val()).prop('readonly', true);
        $('#amount-summary').val($('#amount_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);
        $('#user-id-summary').val($('#user_id').val()).prop('readonly', true);
        $('#user-role-summary').val($('#user_role').val()).prop('readonly', true);


    });
});

// ######################################################### MOMO LOAN APPLICATION #########################################################
//######################################################### MOMO MINI STATEMENT #########################################################

var dt_mini_statement = $('#dt-mini-statement').DataTable({
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
        "url": '/Sme/Reports/mini/statement',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val()

        }
    },
    "columns": [
        { "data": "principal_amount" },
        { "data": "currency_code" },
        { "data": "disbursedon_date" },
        { "data": "total_charges_repaid" },
        { "data": "expected_maturity_date" },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "INACTIVE") {
                    show = "<td><span class='badge bg-pill bg-danger'>INACTIVE</span></td>";
                }
                if (data === "ACTIVE") {
                    show = "<td><span class='badge bg-pill bg-success'>ACTIVE </span></td>";
                }
                return show;
            }    
        },
        {
            data: "id",
            render: function(data, type, row) {
                id = row.id;
                return `
                <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                <div class="dropdown-menu">

                <a data-activate-id="${id}" class="activate-sme-loan dropdown-item btn ripple text-success"><i class= "fe fe-check-circle"></i> Enable </a>    

                <a data-deactivate-id="${id}" class="deactivate-sme-loan dropdown-item btn ripple text-danger"><i class= "fe fe-x-circle"></i> Disable </a>
  
                </div>
                 `;
            },
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

$("#sme_filter_search").on("click", function() {
    dt_mini_statement.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_mini_statement.draw();
});


$('#mini-statement-filter-clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_mini_statement.draw();
});

var dt_active_loans_employer = $('#dt-active-loans-employer').DataTable({
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
        "url": '/active/loans/employer/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "role_type": $('#role_type').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "principal_amount" },
        { "data": "currency_code" },
        { "data": "disbursedon_date" },
        { "data": "total_charges_repaid" },
        { "data": "expected_maturity_date" },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='btn ripple btn-danger btn-sm'>REJECTED</span></td>";
                }
                if (data == "PENDING_ACCOUNTANT_DISBURSEMENT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING_FUNDER_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING FUNDER APPROVAL</span></td>";
                }
                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT ANALYST </span></td>";
                }
                if (data === "PENDING_ACCOUNTANT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTS</span></td>";
                }
                if (data === "PENDING_OPERATIONS_MANAGER") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING OPERATIONS MANAGER</span></td>";
                }
                if (data === "PENDING_OFFTAKER_CONFIRMATION") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING OFFTAKER CONFIRMATION</span></td>";
                }
                if (data === "PENDING_CLIENT_CONFIRMATION") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING OFFTAKER CONFIRMATION</span></td>";
                }
                if (data === "PENDING_MANAGEMENT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING MANAGEMENT</span></td>";
                }
                if (data === "PENDING_CRO") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CRO</span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING DISBURSEMENT</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>DISBURSED</span></td>";  
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

$("#active_loans_filter_search").on("click", function() {
    dt_active_loans_employer.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.role_type = $("#role_type").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_active_loans_employer.draw();
});

$('#active_loans_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_active_loans_employer.draw();
});


var dt_active_loan_product = $('#dt-active-loans-product').DataTable({
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
        "url": '/active/loans/product/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "loan_product": $('#loan_product').val()

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "productType" },
        { "data": "currency_code" },
        { "data": "principal_amount" },
        { "data": "disbursedon_date" },
        { "data": "total_charges_repaid" },
        { "data": "expected_maturity_date" },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='btn ripple btn-danger btn-sm'>REJECTED</span></td>";
                }
                if (data == "PENDING_ACCOUNTANT_DISBURSEMENT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING_FUNDER_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING FUNDER APPROVAL</span></td>";
                }
                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT ANALYST </span></td>";
                }
                if (data === "PENDING_ACCOUNTANT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTS</span></td>";
                }
                if (data === "PENDING_OPERATIONS_MANAGER") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING OPERATIONS MANAGER</span></td>";
                }
                if (data === "PENDING_OFFTAKER_CONFIRMATION") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING OFFTAKER CONFIRMATION</span></td>";
                }
                if (data === "PENDING_CLIENT_CONFIRMATION") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING OFFTAKER CONFIRMATION</span></td>";
                }
                if (data === "PENDING_MANAGEMENT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING MANAGEMENT</span></td>";
                }
                if (data === "PENDING_CRO") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CRO</span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING DISBURSEMENT</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>DISBURSED</span></td>";  
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

$("#active_loans_product_filter_search").on("click", function() {
    dt_active_loan_product.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.loan_product = $("#loan_product").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_active_loan_product.draw();
});

$('#active_loans_product_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_active_loan_product.draw();
});


var dt_active_loan_emoney = $('#dt-active-loans-emoney').DataTable({
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
        "url": '/active/loans/e_money/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "company": $('#company').val(),
            "taxno": $('#taxno').val()

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "companyName" },
        { "data": "principal_amount" },
        { "data": "currency_code" },
        { "data": "disbursedon_date" },
        { "data": "total_charges_repaid" },
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

$("#active_loans_emoney_filter_search").on("click", function() {
    dt_active_loan_emoney.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.company = $("#company").val();
        data.taxno = $("#taxno").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_active_loan_emoney.draw();
});

$('#active_loans_emoney_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_active_loan_emoney.draw();
});


var dt_loan_pending_approval = $('#dt-loan-pending-approval').DataTable({
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
        "url": '/active/loans/pending/approval/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "loan_type": $('#loan_type').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "amount": $('#amount').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "principal_amount" },
        { "data": "currency_code" },
        { "data": "disbursedon_date" },
        { "data": "total_charges_repaid" },
        { "data": "expected_maturity_date" },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-pill bg-danger'>REJECTED</span></td>";
                }
                if (data === "APROVED") {
                    show = "<td><span class='badge bg-pill bg-success'>APROVED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-pill bg-info'> PENDING_APPROVAL </span></td>";
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

$("#loan_panding_approval_filter_search").on("click", function() {
    dt_loan_pending_approval.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.loan_type = $("#loan_type").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.amount = $("#amount").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loan_pending_approval.draw();
});

$('#loan_panding_approval_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loan_pending_approval.draw();
});


var dt_loan_offtaker_info = $('#dt-loan-offtaker-info').DataTable({
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
        "url": '/active/loans/off/taker/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "nrc": $('#nrc').val(),
            "cell": $('#cell').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "meansOfIdentificationNumber" },
        { "data": "mobileNumber" },
        { "data": "emailAddress" },
        { "data": "principal_amount" },
        { "data": "total_charges_repaid" },
        { "data": "expected_maturity_date" },
        { "data": "disbursedon_date" }

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

$("#loan_offtaker_info_filter_search").on("click", function() {
    dt_loan_offtaker_info.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.nrc = $("#nrc").val();
        data.cell = $("#cell").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loan_offtaker_info.draw();
});

$('#loan_offtaker_info_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loan_offtaker_info.draw();
});


var dt_loan_client_summary = $('#dt-loan-client-summary').DataTable({
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
        "url": '/active/loans/client/summary/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "nrc": $('#nrc').val(),
            "cell": $('#cell').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "amount": $('#amount').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "meansOfIdentificationNumber" },
        { "data": "mobileNumber" },
        { "data": "emailAddress" },
        { "data": "principal_amount" },
        { "data": "total_charges_repaid" },
        { "data": "expected_maturity_date" },
        { "data": "disbursedon_date" }

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

$("#loan_client_summary_filter_search").on("click", function() {
    dt_loan_client_summary.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.nrc = $("#nrc").val();
        data.cell = $("#cell").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.amount = $("#amount").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loan_client_summary.draw();
});

$('#loan_client_summary_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loan_client_summary.draw();
});


var dt_loan_waiting_disbursement = $('#dt-loan-waiting-disbursement').DataTable({
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
        "url": '/active/loans/awaiting/disbursement/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "nrc": $('#nrc').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "loan_type": $('#loan_type').val(),
            "amount": $('#amount').val(),
            "cell": $('#cell').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "emailAddress" },
        { "data": "meansOfIdentificationNumber" },
        { "data": "loan_type" },
        { "data": "currency_code" },
        { "data": "principal_amount" },
        { "data": "total_charges_repaid" },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-pill bg-danger'>REJECTED</span></td>";
                }
                if (data === "APROVED") {
                    show = "<td><span class='badge bg-pill bg-success'>APROVED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-pill bg-info'> PENDING_APPROVAL </span></td>";
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

$("#loan_waiting_disbursement_filter_search").on("click", function() {
    dt_loan_waiting_disbursement.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.nrc = $("#nrc").val();
        data.cell = $("#cell").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.loan_type = $("#loan_type").val();
        data.amount = $("#amount").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loan_waiting_disbursement.draw();
});

$('#loan_waiting_disbursement_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loan_waiting_disbursement.draw();
});


var dt_loan_sol_brunch = $('#dt-loan-sol-brunch').DataTable({
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
        "url": '/active/loans/sol_brunch/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "loan_type": $('#loan_type').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "amount": $('#amount').val(),
            "branch": $('#branch').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "branchName" },
        { "data": "disbursedon_date" },
        { "data": "currency_code" },
        { "data": "principal_amount" },
        { "data": "balance" },

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

$("#loan_panding_approval_filter_search").on("click", function() {
    dt_loan_sol_brunch.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.loan_type = $("#loan_type").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.amount = $("#amount").val();
        data.branch = $("#branch").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loan_sol_brunch.draw();
});

$('#loan_panding_approval_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loan_sol_brunch.draw();
});


var dt_loan_outstansing_balance = $('#dt-loan-outstanding-balance').DataTable({
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
        "url": '/loans/outstanding/balance/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "amount": $('#amount').val(),
            "loan_type": $('#loan_type').val(),
            "to": $('#to').val(),
            "from": $('#from').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "loan_type" },
        { "data": "disbursedon_date" },
        { "data": "currency_code" },
        { "data": "principal_amount" },
        { "data": "balance" },

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

$("#loan_balance_filter_search").on("click", function() {
    dt_loan_outstansing_balance.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.amount = $("#amount").val();
        data.loan_type = $("#loan_type").val();
        data.to = $("#to").val();
        data.from = $("#from").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loan_outstansing_balance.draw();
});

$('#loan_balance_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loan_outstansing_balance.draw();
});



var dt_loan_classification_product = $('#dt-loan-classification-product').DataTable({
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
        "url": '/loans/classification/product/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "loan_type": $('#loan_type').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "amount": $('#amount').val()

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "loan_type" },
        { "data": "disbursedon_date" },
        { "data": "currency_code" },
        { "data": "principal_amount" },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-pill bg-danger'>REJECTED</span></td>";
                }
                if (data === "APROVED") {
                    show = "<td><span class='badge bg-pill bg-success'>APROVED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-pill bg-info'> PENDING_APPROVAL </span></td>";
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

$("#loan_classification_product_filter_search").on("click", function() {
    dt_loan_classification_product.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.loan_type = $("#loan_type").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.amount = $("#amount").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loan_classification_product.draw();
});

$('#loan_classification_product_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loan_classification_product.draw();
});


var dt_loans_dvc_employer = $('#dt-loans-dvc-employer').DataTable({
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
        "url": '/loans/due/v_collected/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "loan_type": $('#loan_type').val(),
            "amount": $('#amount').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "loan_type" },
        { "data": "disbursedon_date" },
        { "data": "currency_code" },
        { "data": "principal_amount" },
        { "data": "repayment_amount" },
        { "data": "total_repayment_derived" },
        { "data": "balance" },


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

$("#loans_dvc_filter_search").on("click", function() {
    dt_loans_dvc_employer.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.loan_type = $("#loan_type").val();
        data.amount = $("#amount").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loans_dvc_employer.draw();
});

$('#loans_dvc_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loans_dvc_employer.draw();
});


var dt_loans_dvc_emoney = $('#dt-loans-dvc-emoney').DataTable({
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
        "url": '/loans/due/v_collected/e_money/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "loan_type": $('#loan_type').val(),
            "amount": $('#amount').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "companyName" },  
        { "data": "loan_type" },
        { "data": "disbursedon_date" },
        { "data": "currency_code" },
        { "data": "principal_amount" },
        { "data": "repayment_amount" },
        { "data": "total_repayment_derived" },
        { "data": "balance" },


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

$("#loans_dvc_emoney_filter_search").on("click", function() {
    dt_loans_dvc_emoney.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.loan_type = $("#loan_type").val();
        data.amount = $("#amount").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loans_dvc_emoney.draw();
});

$('#loans_dvc_emoney_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loans_dvc_emoney.draw();
});


var dt_loans_dvc_corporate = $('#dt-loans-dvc-corporate').DataTable({
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
        "url": '/loans/due/v_collected/corporate_buyer/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "loan_type": $('#loan_type').val(),
            "amount": $('#amount').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "companyName" },  
        { "data": "taxno" },
        { "data": "loan_type" },
        { "data": "disbursedon_date" },
        { "data": "currency_code" },
        { "data": "principal_amount" },
        { "data": "repayment_amount" },
        { "data": "total_repayment_derived" },
        { "data": "balance" },



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

$("#loans_dvc_corporate_filter_search").on("click", function() {
    dt_loans_dvc_corporate.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.loan_type = $("#loan_type").val();
        data.amount = $("#amount").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loans_dvc_corporate.draw();
});

$('#loans_dvc_corporate_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loans_dvc_corporate.draw();
});



var dt_active_loans_corporate_buyer = $('#dt-active-loans-corporate-buyer').DataTable({
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
        "url": '/active/loans/corporate_buyer/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            "loan_type": $('#loan_type').val(),
            "amount": $('#amount').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "companyName" },  
        { "data": "taxno" },
        { "data": "loan_type" },
        { "data": "disbursedon_date" },
        { "data": "currency_code" },
        { "data": "principal_amount" }



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

$("#active_loans_corporate_buyer_filter_search").on("click", function() {
    dt_active_loans_corporate_buyer.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
        data.loan_type = $("#loan_type").val();
        data.amount = $("#amount").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_active_loans_corporate_buyer.draw();
});

$('#active_loans_corporate_buyer_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_active_loans_corporate_buyer.draw();
});


var dt_loans_employer_collection = $('#dt-loans-employer-collection').DataTable({
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
        "url": '/loans/employer/collection/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "cell": $('#cell').val(),
            "amount": $('#amount').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "duedate" },
        { "data": "currency_code" },
        { "data": "interest_amount" },
        { "data": "total_repaid" },
        { "data": "principal_amount" },
        { "data": "balance" }


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

$("#loans_employer_collection_filter_search").on("click", function() {
    dt_loans_employer_collection.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.cell = $("#cell").val();
        data.amount = $("#amount").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loans_employer_collection.draw();
});

$('#loans_employer_collection_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loans_employer_collection.draw();
});


var dt_loans_corporate_buyer_collection = $('#dt-loans-corporate-buyer-collection').DataTable({
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
        "url": '/loans/corporate_buyer/collection/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "cell": $('#cell').val(),
            "amount": $('#amount').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "companyName" },
        { "data": "taxno" },
        { "data": "duedate" },
        { "data": "currency_code" },
        { "data": "interest_amount" },
        { "data": "total_repaid" },
        { "data": "principal_amount" },
        { "data": "balance" }


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

$("#loans_corporate_buyer_collection_filter_search").on("click", function() {
    dt_loans_corporate_buyer_collection.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.cell = $("#cell").val();
        data.amount = $("#amount").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loans_corporate_buyer_collection.draw();
});

$('#loans_corporate_buyer_collection_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loans_corporate_buyer_collection.draw();
});

// ######################################################### MOMO MINI STATEMENT #########################################################
//######################################################### MOMO OFF TAKER #########################################################

var dt_off_taker = $('#dt-off-taker').DataTable({
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
        "url": '/Sme/Maintenance/off_taker',
        "data": {
            _csrf_token: $("#csrf").val(),  
            "id": $('#id').val(),
            "number": $('#reg_number').val()

        }
    },
    "columns": [
        { "data": "companyName" },
        { "data": "registrationNumber" },
        { "data": "taxno" },
        {
            "data": "status",
            render: function(data, _, row) {
                let show = "";
                if (data === "INACTIVE") {
                    show = "<td><span class='badge bg-pill bg-danger'>INACTIVE</span></td>";
                }
                if (data === "ACTIVE") {
                    show = "<td><span class='badge bg-pill bg-success'>ACTIVE </span></td>";
                }
                return show;
            }
        },
        {
            data: "id",
            render: function(data, type, row) {
                id = row.id;
                companyname = row.companyName;
                companyphone = row.companyPhone;
                registrationnumber = row.registrationNumber;
                contactemail = row.contactEmail;
                taxno = row.taxno;
                accountnumber = row.companyAccountNumber;
                registrationdate = row.companyRegistrationDate;

                return `

                <a data-activate-id="${id}" class="activate-sme-offtaker btn-success btn-sm btn ripple"><i class= "flaticon-check"></i> Enable </a>

                <a data-deactivate-id="${id}" class="deactivate-sme-offtaker btn-danger btn-sm btn ripple"><i class= "flaticon-cancel"></i> Disable </a>

                <a  class=" btn ripple btn-info btn-sm"
                    data-id="${id}" 
                    data-companyname="${companyname}" 
                    data-companyphone="${companyphone}" 
                    data-registrationnumber="${registrationnumber}" 
                    data-contactemail="${contactemail}" 
                    data-taxno="${taxno}" 
                    data-accountnumber="${accountnumber}" 
                    data-registrationdate="${registrationdate}"  
                    data-toggle="modal" data-target="#editofftaker"><i class= "flaticon-edit"> </i> Edit </a>

                <a  class=" btn ripple btn-warning btn-sm"
                    data-id="${id}"
                    data-companyname="${companyname}" 
                    data-companyphone="${companyphone}" 
                    data-registrationnumber="${registrationnumber}" 
                    data-contactemail="${contactemail}" 
                    data-taxno="${taxno}" 
                    data-accountnumber="${accountnumber}" 
                    data-registrationdate="${registrationdate}"  
                    data-toggle="modal" data-target="#viewofftaker"><i class= "flaticon-eye"> </i> View </a>
  
                </div>
                 `;
            },
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

$("#offtaker-filter-search").on("click", function() {
    dt_off_taker.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.reg_number = $("#reg_number").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_off_taker.draw();
});

$('#offtaker-filter-clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_off_taker.draw();
});

// ######################################################### MOMO OFF TAKER #########################################################




// ----------------------------------------------------------MOMO SWEET ALERT------------------------------------------------------------------------


$('#dt-off-taker').on('click', '.activate-sme-offtaker', function(e) {
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
                url: '/Sme/Maintenance/off_taker/activate',
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
                'error'
            )
        }
    });
});



$('#dt-off-taker').on('click', '.deactivate-sme-offtaker', function(e) {
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
                url: '/Sme/Maintenance/off_taker/deactivate',
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
                'error'
            )
        }
    });
});



$('#dt-mini-statement').on('click', '.activate-sme-loan', function(e) {
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
                url: '/Sme/Reports/mini/statement/activate',
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
                'error'
            )
        }
    });
});



$('#dt-mini-statement').on('click', '.deactivate-sme-loan', function(e) {
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
                url: '/Sme/Reports/mini/statement/deactivate',
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
                'error'
            )
        }
    });
});


// ----------------------------------------------------------MOMO SWEET ALERT END------------------------------------------------------------------------

/////////////////////////////////////////////////////////////// RUSSELL ////////////////////////////////////////////////////////////////////////


var dt_client_relationship_manager = $('#dt-client-relation-manager').DataTable({
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
        "url": '/admin/view/client/relation/managers',
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
        { "data": "cutomernames" },
        { "data": "cutomer_id_type" },
        { "data": "cutomer_id_no" },
        {
            data: null,
            render: function(data, type, row) {
                let show = "";
                if (data.loanofficerfirstnames === null) {
                    show = "<td><span class='badge bg-danger-light bg-pill'>INACTIVE</span></td>";
                }

                if (data.loanofficerfirstnames != null) {
                    return data.loanofficerfirstnames + "  " + data.loanofficerlastnames;
                }
            },
        },
        { "data": "loanofficer_idtype" },
        { "data": "loanofficer_idnumber" },
        {
            "data": "cutomer_status",
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

   

        {
            // data: "id",
            "request": "id",
            "data": "id",
            "render": function(data, type, row) {
                id = row.id;
                loanofficernames = row.loanofficernames;
                loanofficer_idnumber = row.loanofficer_idnumber_type;
                current_crm_id = row.loanofficer_userid;

                if (current_crm_id === null) {
                return `
              
                <a  class="btn btn-sm btn-info" data-bs-target="#change_loan_officer" data-bs-toggle="modal" title="Change Relationship Manager" data-id="${row.id}" data-loanofficer_idnumber="${row.loanofficer_idnumber_type}" data-account_id="${row.id}" data-loanofficernames="${row.loanofficernames}" 
                    data-current_crm_id="${row.loanofficer_userid}"
                    ><i class="si si-link"></i> </i>  Assign CRM </a>
                 `;

                 
                }

                if (current_crm_id != null) {
                    return `
                  
                    <a  class="btn btn-sm btn-info" data-bs-target="#change_loan_officer" data-bs-toggle="modal" title="Change Relationship Manager" data-id="${row.id}" data-loanofficer_idnumber="${row.loanofficer_idnumber_type}" data-account_id="${row.id}" data-loanofficernames="${row.loanofficernames}" 
                        data-current_crm_id="${row.loanofficer_userid}"
                        ><i class="fe fe-shuffle"></i> </i>  Change CRM </a>
                     `;
                    }
                
            },
            "defaultContent": "<span class='text-danger'>No Actions</span>"
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
    "columnDefs": [
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        }
    ],
});




$(document).ready(function() {
    $('.relationship-manager-loopup').on('change', function() {
        if ($('#relationship_manager_id').val() == "") {
            return false;
        }
        $.ajax({
            url: '/client/relation/managers/lookup',
            type: 'post',
            data: {
                "userId": $('#relationship_manager_id').val(),
                "_csrf_token": $("#csrf").val()
            },
            success: function(result) {
                if (result.data.length < 1) {
                    // $('.clear-wizard').val('').prop('readonly', false);
                    // $('.clear-select-wizard').val(null);


                    return false;
                } else {
                    capa = result.data[0];
                    console.log("capa");
                    console.log(capa);
                    $('#identification_id').val(capa.meansOfIdentificationType + ' - ' + capa.meansOfIdentificationNumber).prop('readonly', true);
                    $('#id_means').val(capa.meansOfIdentificationType).prop('readonly', true);
                }
            },
            error: function(request, msg, error) {
                $('.loading').hide();
            }
        });
    });
});


$('#change-client-relationship-manager').click(function(e) {
    e.preventDefault()
    Swal.fire({
        title: 'Are you sure?',
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
                url: '/admin/change/client/relation/managers',
                type: 'POST',
                data: { id: $('#account_id').val(), loan_officer_id: $('#relationship_manager_id').val(), _csrf_token: $('#csrf').val(), assignment_date: $('#assignment_date').val()},
                success: function(result) {
                    if (result.data) {
                        Swal.fire(
                            'Success',
                            result.data,
                            'success'
                        ).then((_) => {
                            location.reload();

                        });
                    } else {
                        Swal.fire(
                            'Failed!',
                            result.error,
                            'error'
                        ).then((_) => {
                            location.reload();
                        });
                    }
                },
                error: function(request, msg, error) {
                    Swal.fire(
                        'Oops..',
                        error,
                        'error'
                    )
                }
            });
        } else {
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
    })

});

function formatSearchDetails ( d ) {
    return '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">'+
        '<tr>'+
            '<td>Expected Repayment: '+format_value(d.total_expected_repayment)+'</td>'+ 
        '</tr>'+
        '<tr>'+
            '<td>Total Repaid: '+format_value(d.principal_repaid)+'</td>'+ 
        '</tr>'+
        '<tr>'+
            '<td>Disbursed on: '+format_value(d.disbursedon_date)+'</td>'+
        '</tr>'+
    '</table>';
}

function format_value(v) {
    if(v){
        return v;
    } else{
        return "<span class='text-danger'>Not Set</span>";
    }
}


var dt_client_all_loans_list = $('#dt_client_all_loans_list').DataTable({
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
        "url": '/client/write/off/loans/list',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            // "filter_customer_first_name": $('#filter_customer_first_name').val(),
            // "filter_customer_last_name": $('#filter_customer_last_name').val(),
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
            "className": 'details-control',
            "orderable": false,
            "data": null,
            "defaultContent": ''
        },
        { "data": "customer_names"},
        { "data": "loan_account_no" },
        { "data": "principal_amount" },
        { "data": "principal_amount" },
        
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
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING </span></td>";
                }
                if (data === "WRITTEN_OFF") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>WRITTEN OFF </span></td>";
                }
                return show;
            }
        },

        {
            // data: "id",
            "request": "id",
            "data": "id",
            "render": function(data, type, row) {
                id = row.id;
                loan_status = row.loan_status;
                // loanofficer_idnumber = row.loanofficer_idnumber_type;
                // current_crm_id = row.loanofficer_userid;

                if (loan_status != "WRITTEN_OFF") {
                return `
              
                <a  class="btn btn-sm btn-info write-off-loan" title="Change Relationship Manager" data-id="${row.id}" 
                  
                    ><i class="ti ti-brush"></i> </i> Write Off </a>
                 `;
                }
                
            },
            "defaultContent": "<span class='text-danger'>No Actions</span>"
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
    "columnDefs": [
        // {
        //     "targets": 2,
        //     "className": "text-right fw-500"
        // },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

     
    ]
});


$('#dt_client_all_loans_list tbody').on('click', '.write-off-loan', function(e) {
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
                url: '/admin/write/off/client/loan',
                type: 'POST',
                data: { id: button.attr("data-id"), _csrf_token: $('#csrf').val() },
                success: function(result) {
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




$('#dt_client_all_loans_list').on('click', 'td.details-control', function () {
    var tr = $(this).closest('tr');
    var row = dt_client_all_loans_list.row(tr);

    if (row.child.isShown()) {
        row.child.hide();
        tr.removeClass('shown');
    }
    else {
        row.child(formatSearchDetails(row.data())).show();
        tr.addClass('shown');
    }
});




var dt_client_loans_portfolio = $('#dt-client-loans-portfolio').DataTable({
    "responsive": false,
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
        "url": '/Credit/Monitoring/loan/portfolio/items',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
           
        } 
    },
    "columns": [
        {
            "className": 'details-control-loan-portfolio',
            "orderable": false,
            "data": null,
            "defaultContent": ''
        },
        { "data": "roleType"},
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
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING </span></td>";
                }
                if (data === "WRITTEN_OFF") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>WRITTEN OFF </span></td>";
                }
                return show;
            }
        },

        { "data": "principal_amount" },
        { "data": "interest_outstanding" },
        { "data": "principal_outstanding" },
        // { "data": "inserted_at" },
        
        // {
        //     "data": "disbursedon_date",
        //     render: function (data, type, row) {//data
        //         return moment(data).format('DD/MM/YYYY');
                
        //     }
            
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
    "columnDefs": [
        // {
        //     "targets": 2,
        //     "className": "text-right fw-500"
        // },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

     
    ]
});

$('#dt-client-loans-portfolio').on('click', 'td.details-control-loan-portfolio', function () {
    var tr = $(this).closest('tr');
    var row = dt_client_loans_portfolio.row(tr);

    if (row.child.isShown()) {
        row.child.hide();
        tr.removeClass('shown');
    }
    else {
        row.child(formatSearchDetails(row.data())).show();
        tr.addClass('shown');
    }
});


$('#kt_datatable tbody').on('click', '.employer_activate_employee', function(e) {
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
                url: '/Admin/employer/activate/employee',
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


$('#kt_datatable').on('click', '.employer-deactivate-employee', function(e) {
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
                url: '/Admin/employer/deactivate/employee',
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
                'error'
            )
        }
    });
});



$('#kt_datatable tbody').on('click', '.employer-activate-admin-employee', function(e) {
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
                url: '/Admin/employer/activate/Admin/employee',
                type: 'POST',
                data: { id: button.attr("data-user-id"), _csrf_token: $('#csrf').val() },
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


$('#kt_datatable tbody').on('click', '.employer-deactivate-admin-employee', function(e) {
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
                url: '/Admin/employer/deactivate/Admin/employee',
                type: 'POST',
                data: { id: button.attr("data-user-id"), _csrf_token: $('#csrf').val() },
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




var dt_all_employer_employee_loans = $('#dt_employer_employee_all_loans').DataTable({
    "responsive": false,
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
        "url": '/employer/get/all/employee/loans',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "emp_first_name": $('#emp_first_name').val(),
            "emp_last_name": $('#emp_last_name').val(),
            "emp_id_number": $('#emp_id_number').val(),
            "emp_phone_number": $('#emp_phone_number').val(),
            "from": $("#from").val(),
            "to": $("#to").val(), 
           
        } 
    },
    "columns": [

        { "data": "customer_names"},
        { "data": "customer_identification_number"},
        { "data": "product_code"},
        { "data": "customer_principal_amount"},
        { "data": "interest_outstanding_derived"},
        { "data": "total_principal_repaid"},
        { "data": "principal_outstanding_derived"},
        
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
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING </span></td>";
                }
                if (data === "WRITTEN_OFF") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>WRITTEN OFF </span></td>";
                }
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>REJECTED </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                return show;
            }
        },

        // { "data": "inserted_at" },
        
        // {
        //     "data": "disbursedon_date",
        //     render: function (data, type, row) {//data
        //         return moment(data).format('DD/MM/YYYY');
                
        //     }
            
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
    "columnDefs": [
        // {
        //     "targets": 2,
        //     "className": "text-right fw-500"
        // },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

     
    ]
});

var dt_pending_employer_employee_loans = $('#dt_employer_employee_pending_loans').DataTable({
    "responsive": false,
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
        "url": '/employer/get/all/pending/employee/loans',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
           
        } 
    },
    "columns": [

        { "data": "customer_names"},
        { "data": "customer_identification_number"},
        { "data": "product_code"},
        { "data": "customer_principal_amount"},
        { "data": "interest_amount"},
        { "data": "total_principal_repaid"},
        { "data": "balance"},
        
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "INACTIVE") {
                    show = "<td><span class='btn ripple btn-danger btn-sm'>INACTIVE</span></td>";
                }
                if (data === "PENDING_CLIENT_CONFIRMATION") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING_CLIENT_CONFIRMATION</span></td>";
                }
                if (data === "ACTIVE") {
                    show = "<td><span class='badge bg-success-light bg-pill'>ACTIVE</span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING APPROVAL</span></td>";
                }
                if (data === "PENDING") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING</span></td>";
                }
                if (data === "WRITTEN_OFF") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>WRITTEN OFF</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>DISBURSED</span></td>";
                }
                return show;
            }
        },

        {
            "data": "loan_id",
            "render": function(data, type, row) {
                if (row.loan_status == "PENDING_CLIENT_CONFIRMATION") {
                    return `
                        <a href="/Client/Upload/Loan/Documents?loan_id=${row.id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove </a>
                        <a href="#"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="#" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>
                        <a href="#" data-id="${row.loan_id}" data-target="#rejectmodal" data-toggle="modal" class="btn ripple btn-danger btn-sm"><i class= "ki ki-close icon-sm"></i>Reject</a>
                    `;
                }

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

        // { "data": "inserted_at" },
        
        // {
        //     "data": "disbursedon_date",
        //     render: function (data, type, row) {//data
        //         return moment(data).format('DD/MM/YYYY');
                
        //     }
            
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
    "columnDefs": [
        // {
        //     "targets": 2,
        //     "className": "text-right fw-500"
        // },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

     
    ]
});


var dt_rejected_employer_employee_loans = $('#dt_employer_employee_rejected_loans').DataTable({
    "responsive": false,
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
        "url": '/employer/get/all/rejected/employee/loans',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
           
        } 
    },
    "columns": [

        { "data": "customer_names"},
        { "data": "customer_identification_number"},
        { "data": "product_code"},
        { "data": "customer_principal_amount"},
        { "data": "interest_outstanding_derived"},
        { "data": "total_principal_repaid"},
        { "data": "principal_outstanding_derived"},
        
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
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING </span></td>";
                }
                if (data === "WRITTEN_OFF") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>WRITTEN OFF </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                return show;
            }
        },

        // { "data": "inserted_at" },
        
        // {
        //     "data": "disbursedon_date",
        //     render: function (data, type, row) {//data
        //         return moment(data).format('DD/MM/YYYY');
                
        //     }
            
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
    "columnDefs": [
        // {
        //     "targets": 2,
        //     "className": "text-right fw-500"
        // },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

     
    ]
});


var dt_all_disbursed_employer_employee_loans = $('#dt_employer_employee_disbursed_loans').DataTable({
    "responsive": false,
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
        "url": '/employer/get/all/disbursed/employee/loans',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
           
        } 
    },
    "columns": [

        { "data": "customer_names"},
        { "data": "customer_identification_number"},
        { "data": "product_code"},
        { "data": "customer_principal_amount"},
        { "data": "interest_outstanding_derived"},
        { "data": "total_principal_repaid"},
        { "data": "principal_outstanding_derived"},
        
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
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING </span></td>";
                }
                if (data === "WRITTEN_OFF") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>WRITTEN OFF </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                return show;
            }
        },

        // { "data": "inserted_at" },
        
        // {
        //     "data": "disbursedon_date",
        //     render: function (data, type, row) {//data
        //         return moment(data).format('DD/MM/YYYY');
                
        //     }
            
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
    "columnDefs": [
        // {
        //     "targets": 2,
        //     "className": "text-right fw-500"
        // },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },

     
    ]
});




$("#employer-employee-loan-report-filter").on("click", function() {
    $("#employer_staff_loan_filter_model").modal("show");
});


$("#employer_employee_loan_report_filter").on("click", function() {
    dt_all_employer_employee_loans.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.emp_first_name = $("#emp_first_name").val();
        data.emp_last_name = $("#emp_last_name").val();
        data.emp_id_number = $("#emp_id_number").val();
        data.emp_phone_number = $("#emp_phone_number").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
    });
    $("#employer_staff_loan_filter_model").modal("hide");
    dt_all_employer_employee_loans.draw();
});


$(document).ready(function() {
    $('.otc-product-charge-lookup').on('change', function() {
        if ($('#product_charge_id').val() == "") {
            return false;
        }
        $.ajax({
            url: '/product/over/counter/charge/lookup',
            type: 'post',
            data: {
                "product_charge_id": $('#product_charge_id').val(),
                "_csrf_token": $("#csrf").val()
            },
            success: function(result) {
                if (result.data.length < 1) {
                    console.log("russ");

                    return false
                } else {
                    capa = result.data[0];
                    console.log("capa");
                    console.log(capa);
                    var product_charge_id = capa.product_charge_id;
                    var product_charge_type = capa.product_charge_type;
                    var product_charge_name = capa.product_charge_name;
                    var product_charge_when = capa.product_charge_when;
                    var product_charge_amount = capa.product_charge_amount;

                  
                    $('#product_charge_type').val(product_charge_type).prop('readonly', true);
                    $('#product_charge_name').val(product_charge_name).prop('readonly', true);
                    $('#product_charge_when').val(product_charge_when).prop('readonly', true);
                    $('#product_charge_amount').val(product_charge_amount).prop('readonly', true);
                 
                   


                }

            },
            error: function(request, msg, error) {
                $('.loading').hide();
            }
        });
    });
});

$(document).ready(function() {
    
    $('#product-charge-edit').delegate('.product-charge-edit', 'change', function() {
        if ($('#product_charge_id').val() == "") {
            return false;
        }
        var $this = this;
        $.ajax({
            url: '/product/over/counter/charge/lookup',
            type: 'post',
            data: {
                "product_charge_id": $($this).closest("tr").find('.product-charge-edit').val(),
                "_csrf_token": $("#csrf").val()
            },
            success: function(result) {
                if (result.data.length < 1) {
                    console.log("russ");

                    return false
                } else {
                    capa = result.data[0];
                    console.log("capa");
                    console.log(this);
                    var product_charge_id = capa.product_charge_id;
                    var product_charge_type = capa.product_charge_type;
                    var product_charge_name = capa.product_charge_name;
                    var product_charge_when = capa.product_charge_when;
                    var product_charge_amount = capa.product_charge_amount;

                    // $($this).closest("tr").find('.description1').val(result.description);
                    $($this).closest("tr").find('.product_charge_type').val(product_charge_type).prop('readonly', true);
                    $($this).closest("tr").find('.product_charge_name').val(product_charge_name).prop('readonly', true);
                    $($this).closest("tr").find('.product_charge_when').val(product_charge_when).prop('readonly', true);
                    $($this).closest("tr").find('.product_charge_amount').val(product_charge_amount).prop('readonly', true);
                 

                }

            },
            error: function(request, msg, error) {
                $('.loading').hide();
            }
        });
    });
});





$(document).ready(function() {


    $('#net_pay').on('input', function() {
     
     
            $( "#limit" ).show();
            $( "#loan_amount" ).show();

            var numOne = document.getElementById("percentage");
            var numTwo = document.getElementById("net_pay");
        
            numTwo.addEventListener("input", add);
        
            function add(){
            var one = Number(numOne.value) || 0;
            var two = Number(numTwo.value) || 0;
            var sum = Number(((one*two/100)));
        
            addSum = sum;
                console.log("num-one");
                console.log(addSum.toFixed(2));
                $('#loan_limit').val(addSum.toFixed(2)).prop('readonly', true);
        
            }


    })









});






$('#create-usr-role').click(function() {


    if ($("#role_group").val() == "") 
    {
        swal({
            title: "Opps",
            text: "Select Access level !",
            confirmButtonColor: "#2196F3",
            type: "error"
        });
        return false;
    };

    if ($("#role-desc").val() == "")
    {
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
                success: function(result) {
                    if (result.info) {
                        // spinner.hide();
                        $("input[type='checkbox']").each(function() {
                            this.checked = false;
                        });
                        $('#role-desc').val('');
                        Swal.fire(
                            'Success!',
                            'Operation complete!',
                            'success'
                        )
                        window.setTimeout(function(){location.reload()},1600)
                    } else {
                        // spinner.hide();
                        Swal.fire(
                            'Oops...',
                            result.error,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
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



   // edit role form

   if ($('#edit-role-form').length) {
    $("input[type='checkbox']").each(function() {
        var $this = this;
        if ($this.getAttribute("data-role-val") == 'Y')
            $this.checked = true;
    });
}

$('#update-usr-role').click(function() {

    if ($("#role_group").val() == "") 
    {
        swal({
            title: "Opps",
            text: "Select Access level !",
            confirmButtonColor: "#2196F3",
            type: "error"
        });
        return false;
    };

    if ($("#role-desc").val() == "")
    {
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
            $.ajax({
                url: '/update/user/role',
                type: 'POST',
                data: data,
                success: function(result) {
                    if (result.info) {
                        // spinner.hide();
                        Swal.fire(
                            'Success!',
                            'Operation complete!',
                            'success'
                        )
                        .then(function() {
                            window.location = "/Admin/change/management/role/maintainence";
                        });
                    } else {
                        // spinner.hide();
                        Swal.fire(
                            'Oops...',
                            result.error,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
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




$('#kt_datatable tbody').on('click', '.role-change-status', function() {
    var button = $(this);
    var $tr = $(this).closest('tr');
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
            // spinner.show();
            //  var data = $("form").serialize();
            $.ajax({
                url: '/change/user/role/status',
                type: 'POST',
                data: {
                    id: button.attr("data-id"),
                    status: button.attr("data-status"),
                    _csrf_token: $("#csrf").val()
                },
                success: function(result) {
                    if (result.info) {
                        // spinner.hide();
                        Swal.fire(
                            'Success!',
                            'Operation complete!',
                            'success'

                            
                        )         
                        window.setTimeout(function(){location.reload()},1600)
     
                    } 
                    else {
                        // spinner.hide();
                        Swal.fire(
                            'Oops...',
                            result.error,
                            'error'
                        )
                    }
                },
                error: function(request, msg, error) {
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


$('#accountant-employee-consumer-loan_application').click(function() {

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
                $('#accountant_employee_consumer_appr').attr('action', '/Accountant/Aprove/Employee/Consumer/Loan');
                $('#accountant_employee_consumer_appr').attr('method', 'POST');
                $("#accountant_employee_consumer_appr").submit();

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



var dt_all_disbursed_loans_corporate = $('#dt-all-disbursed-corporate-loans').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    dom: 
    `<'row'<'col-sm-12 text-left'><'col-sm-12 text-right'B>>
    <'row'<'col-sm-12'tr>>
    <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,

    buttons: [
            {
                extend: 'csvHtml5',
                text: 'Excel',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans",
                filename: "Loan List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans",
                filename: "Loan Disbursed List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans",
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
        "url": '/Get/Corparate/Disbursed/Loans',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "rep_f_name": $('#rep_f_name').val(),
            "rep_l_name": $('#rep_l_name').val(),
            "corparate_name": $('#corparate_name').val(),
            "offtaker_name": $('#offtaker_name').val(),
            "funder_id": $('#funder_id').val(),
            "loan_type": $('#loan_type').val(),
            "interest_amount": $('#interest_amount').val(),
            "principal_amount": $('#principal_amount').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),



        }
    },
    "columns": [
        { "data": "disbursedon_date" },
        { "data": "company_name" },  
        { "data": "customerName" },  
        { "data": "mobileNumber" },
        { "data": "loan_type" },
        { "data": "offtaker_name" },
        { "data": "principal_amount" },
        { "data": "interest_amount" },
        { "data": "finance_cost" },
        { "data": "repayment_amount" },
        { "data": "tenor" },
        { "data": "funder_bio" }, 

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
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },
    ]
});


$("#admin-all-disbursed-loans-corporate").on("click", function() {
    $("#corpate_disbused_filter").modal("show");
});


$("#all_disbursed_loans_corporate").on("click", function() {
    dt_all_disbursed_loans_corporate.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.rep_f_name = $("#rep_f_name").val();
        data.rep_l_name = $("#rep_l_name").val();
        data.corparate_name = $("#corparate_name").val();
        data.offtaker_name = $("#offtaker_name").val();
        data.funder_id = $("#funder_id").val();
        data.loan_type = $("#loan_type").val();
        data.interest_amount = $("#interest_amount").val();
        data.principal_amount = $("#principal_amount").val();
        data.to = $("#to").val();
        data.from = $("#from").val();
       
        
    });
    $("#product_filter_model").modal("hide");
    dt_all_disbursed_loans_corporate.draw();
});

$('#all_disbursed_loans_corporate_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_all_disbursed_loans_corporate.draw();
});




var dt_due_client_loans = $('#dt-all-overdue-loans').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    dom: 
    `<'row'<'col-sm-12 text-left'><'col-sm-12 text-right'B>>
    <'row'<'col-sm-12'tr>>
    <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,

    buttons: [
            {
                extend: 'csvHtml5',
                text: 'Excel',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans",
                filename: "Loan List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans",
                filename: "Loan Disbursed List",
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans",
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
        "url": '/Get/All/Corparate/Over/Due/Loans',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "rep_f_name": $('#rep_f_name').val(),
            "rep_l_name": $('#rep_l_name').val(),
            "corparate_name": $('#corparate_name').val(),
            "offtaker_name": $('#offtaker_name').val(),
            "funder_id": $('#funder_id').val(),
            "loan_type": $('#loan_type').val(),
            "interest_amount": $('#interest_amount').val(),
            "principal_amount": $('#principal_amount').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),



        }
    },
    "columns": [
        { "data": "disbursedon_date" },
        { "data": "company_name" },  
        { "data": "customerName" },  
        { "data": "mobileNumber" },
        { "data": "loan_type" },
        { "data": "offtaker_name" },
        { "data": "principal_amount" },
        { "data": "interest_amount" },
        { "data": "finance_cost" },
        { "data": "repayment_amount" },
        { "data": "tenor" },
        { "data": "monthly_installment" },
        { "data": "funder_bio" }, 

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
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },
    ]
});


$('#order-finance-loan_application').click(function() {
   
    var input_invoice_value = document.getElementById('input_invoice_value').value;
    var principal_amount = document.getElementById('numberInput').value;
    var months = document.getElementById('months').value;
    var offtaker_selection = document.getElementById('offtaker_selection').value;

    var order_finance_documents = document.getElementById('order_finance_documents').value;
   
    var loan_document_order_finance_documents = order_finance_documents.length;


    if (input_invoice_value === "") 
    {
        Swal.fire({
            title: ("please provide loan limit amount"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (principal_amount === "") 
    {
        Swal.fire({
            title: ("please provide loan amount"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (months === "") 
    {
        Swal.fire({
            title: ("please provide tenure in days "),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (offtaker_selection === "") 
    {
        Swal.fire({
            title: ("please select offtaker"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };


    if (loan_document_order_finance_documents === 0) 
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
                $('#order_finance_application').attr('action', '/Admin/Loan/Initiation/Ordering/Finance/Applicatin');
                $('#order_finance_application').attr('method', 'POST');
                $("#order_finance_application").submit();

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



$('#employee-consumer-loan_application').click(function() {
   
   
    var principal_amount = document.getElementById('numberInput').value;
    var months = document.getElementById('months').value;
   

    var emp_consumer_app_docs = document.getElementById('emp_consumer_app_docs').value;
   
    var loan_document_emp_consumer_app_docs = emp_consumer_app_docs.length;



    if (principal_amount === "") 
    {
        Swal.fire({
            title: ("please provide loan amount"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (months === "") 
    {
        Swal.fire({
            title: ("please provide tenure in days "),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };


    if (loan_document_emp_consumer_app_docs === 0) 
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
                $('#emp_consumer_loan_application').attr('action', '/create/universal/loan/application');
                $('#emp_consumer_loan_application').attr('method', 'POST');
                $("#emp_consumer_loan_application").submit();

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



$('#sme-loan_application_form').click(function() {

    var principal_amount = document.getElementById('numberInput').value;
    var months = document.getElementById('months').value;
  

    var sme_loan_documents = document.getElementById('sme_loan_documents').value;
   
    var loan_document_sme_loan_documents = sme_loan_documents.length;


    if (principal_amount === "") 
    {
        Swal.fire({
            title: ("please provide loan amount"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (months === "") 
    {
        Swal.fire({
            title: ("please provide tenure in days "),
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
                $('#sme_loan_application_form').attr('action', '/Credit/Management/Sme_loan/Application');
                $('#sme_loan_application_form').attr('method', 'POST');
                $("#sme_loan_application_form").submit();

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








/////////////////////////////////////////////////////////////// RUSSELL ////////////////////////////////////////////////////////////////////////

