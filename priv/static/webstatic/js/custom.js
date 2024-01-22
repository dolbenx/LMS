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

const my_currentDate = new Date();
const russ_formattedDateTime_1 = formatDateForFilename(my_currentDate);
const russ_formattedDateTime_3 = formatDateForFilename(my_currentDate);
const russ_formattedDateTime_5 = formatDateForFilename(my_currentDate);



function formatDateToDdMmYy(date) {
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0'); // Note: Months are zero-based
    const year = String(date.getFullYear()).slice(2); // Get the last two digits of the year
  
    return `${day}-${month}-${year}`;
  }
  
  function shiftDate(inputDate, numberOfDays) {
    // Create a new Date object based on the inputDate
    const shiftedDate = new Date(inputDate);
  
    // Calculate the new date by adding the number of days
    shiftedDate.setDate(shiftedDate.getDate() + numberOfDays);
  
    // Return the shifted date formatted as "dd-mm-yy"
    return formatDateToDdMmYy(shiftedDate);
  }

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

                            <div class="dropdown">
                                <button class="dropbtn">Options</button>
                                <div class="dropdown-content">

                                    <a class="btn ripple btn-sm js-approve-product-other" data-product-id="${row.id}" href="#">Approve</a>

                                    <a class="btn ripple btn-sm" href="/Admin/edit/products?product_id=${row.product_id}">Edit</a>

                                    <a class="btn ripple btn-sm" href="#"
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
                                    data-price_rate_id = "${price_rate_id}"
                                    >View</a>

                                </div>
                            </div>
                        `;
                    };

                    if (row.status == "ACTIVE") {
                        return `

                            <div class="dropdown">
                                <button class="dropbtn">Options</button>
                                <div class="dropdown-content">

                                    <a class="btn ripple btn-sm js-disable-product-other" data-product-id="${row.id}" href="#">Disable</a>

                                    <a class="btn ripple btn-sm" href="/Admin/edit/products?product_id=${row.product_id}">Edit</a>

                                    <a class="btn ripple btn-sm" href="#"
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
                                    data-price_rate_id = "${price_rate_id}"
                                    >View</a>

                                </div>
                            </div>
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
                "defaultContent": '<span style="color: red">N/A</span>'
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
                "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [0, 3],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "c_name": $('#c_name').val(),
            "p_type": $('#p_type').val(),

        }
    },
    "columns": [
        { "data": "company_name" },
        { "data": "loan_type" },
        { "data": "principal_amount" },
        { "data": "total_interest" },
        { "data": "balance" },
        { "data": "total_initiated" }   

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
            "targets": [2, 3, 4],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
        },
    ]
});

$("#active_loans_by_employer_filter_search").on("click", function() {
    dt_active_loans_employer.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.c_name = $("#c_name").val();
        data.p_type = $("#p_type").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_active_loans_employer.draw();
});

$('#active_loans_by_employer_filter_clear').on('click', function() {
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
        { "data": "product_principal" },
        { "data": "loan_type" },
        { "data": "principal_amount" },
        { "data": "total_interest" },
        { "data": "balance" },
        { "data": "total_initiated" }  

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
            "targets": [3, 5],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [2, 5],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [1, 4],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [4, 5],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [4, 5],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [5,6],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [4, 5],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [4, 5],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": 4,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
        { "data": "balance" },
        { "data": "total_repaid" },
        { "data": "total_balance" },


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
            "targets": 6,
            "defaultContent": '<span style="color: red">Loan Not Collected</span>'
        },
        {
            "targets": 2,
            "defaultContent": '<span style="color: red">Loan Not Disbursed</span>'
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
            "targets": [5, 6, 7, 8],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": 6,
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [3, 4, 5, 6],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "targets": [5, 6, 7, 8],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
    "columnDefs": [
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "defaultContent": '<span style="color: red">N/A</span>'
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
        return "<span class='text-danger'>N/A</span>";
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
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "defaultContent": '<span style="color: red">N/A</span>'
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
            "defaultContent": '<span style="color: red">N/A</span>'
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
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                }
            },
            {
                extend: 'pdfHtml5',
                text: 'PDF',
                titleAttr: 'Loans PDF File',
                messageTop: "Corporates Disbursed Loans Table -" + russ_formattedDateTime_1,
                filename: "Corporates Disbursed Loans -" + russ_formattedDateTime_1,
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'print',
                text: 'Print',
                messageTop: "Corporates Disbursed Loans Table",
                filename: "Corporates Disbursed Loans -" + russ_formattedDateTime_1,
                filename: "Loan Disbursed List -" + russ_formattedDateTime_1,
                exportOptions: {
                    columns: [ 0, 1, 2, 3, 4, 5, 6, 7,8,9,10]
                }
            },
            {
                extend: 'csvHtml5',
                text: 'CSV',
                messageTop: "Corporates Disbursed Loans Table -" + russ_formattedDateTime_1,
                filename: "Corporates Disbursed Loans -" + russ_formattedDateTime_1,
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
            "targets": [6, 7, 8, 9, 10],
            "className": "text-right fw-500"
        },
        {
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
                    extend: 'colvis',
                    text: 'Column Visibility',
                    messageTop: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    filename: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    }
                },
                {
                    extend: 'csvHtml5',
                    text: 'Excel',
                    messageTop: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    filename: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    }
                },
                {
                    extend: 'pdfHtml5',
                    text: 'PDF',
                    titleAttr: 'Loans PDF File',
                    messageTop: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    filename: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    }
                },
                {
                    extend: 'print',
                    text: 'Print',
                    messageTop: "Due Payment Loans Table",
                    filename: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    filename: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    }
                },
                {
                    extend: 'csvHtml5',
                    text: 'CSV',
                    messageTop: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    filename: "Due Payment Loans Table -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
        "url": '/Get/All/clients/Over/Due/Loans',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "first_name_due_loans_filter": $('#first_name_due_loans_filter').val(),
            // "rep_l_name": $('#rep_l_name').val(),
            // "corparate_name": $('#corparate_name').val(),
            // "offtaker_name": $('#offtaker_name').val(),
            // "funder_id": $('#funder_id').val(),
            // "loan_type": $('#loan_type').val(),
            // "interest_amount": $('#interest_amount').val(),
            // "principal_amount": $('#principal_amount').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),



        }
    },
    "columns": [
        { "data": "disbursedon_date" },
        { "data": "company_name" },  
        { "data": "customerName" },  
        { "data": "mobileNumber" },
        { "data": "loan_type" },
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
        { "data": "accrued_no_days" },
        { "data": "monthly_installment" },
        {
            "data": "disbursedon_date",
            "render": function(data, type, row) {
                // Check if "daily_accrued_finance_cost" exists in the row data
                if (row.disbursedon_date) {
                    // Parse the number and format it with commas and two decimal places
                    var shiftedDate = shiftDate(row.disbursedon_date, row.tenor);
                    return "<span>" + shiftedDate + "</span>";
                } else {
                    return "<span class=''>N/A</span>";
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
            "targets": [5, 6, 7, 8, 9, 10, 11],
            "className": "text-right fw-500"
        },
        {
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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

    let divisor = 30;
    var principal_amount = document.getElementById('numberInput').value;
    var months = document.getElementById('months').value;
    var remainder = months % divisor;
  

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

    if (remainder != 0) 
    {
        Swal.fire({
            title: ("please provide valid tenure in days "),
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



$('#create_funder_individual_submit').click(function() {

    var funder_first_name = document.getElementById('first_name').value;
    var funder_last_name = document.getElementById('last_name').value;
    var funder_dob = document.getElementById('dateOfBirth').value;
    var funder_email_address = document.getElementById('emailAddress').value;
    var funder_meansOfIdentificationType = document.getElementById('meansOfIdentificationType').value;
    var funder_meansOfIdentificationNumber = document.getElementById('meansOfIdentificationNumber').value;
    var funder_mobileNumber = document.getElementById('mobileNumber').value;
    var funder_gender = document.getElementById('gender').value;
    var funder_funder_type = document.getElementById('funder_type').value;

    if (funder_first_name === "") 
    {
        Swal.fire({
            title: ("please provide first name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
   
    if (funder_last_name === "") 
    {
        Swal.fire({
            title: ("please provide last name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_dob === "") 
    {
        Swal.fire({
            title: ("please provide funder's dob"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_email_address === "") 
    {
        Swal.fire({
            title: ("please provide funder's email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_meansOfIdentificationType === "") 
    {
        Swal.fire({
            title: ("please provide funder's ID type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_meansOfIdentificationNumber === "") 
    {
        Swal.fire({
            title: ("please provide funder's ID number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_mobileNumber === "") 
    {
        Swal.fire({
            title: ("please provide funder's phone number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_mobileNumber.length < 10 || funder_mobileNumber.length > 10) 
    {
        Swal.fire({
            title: ("Kindly Provide a valid phone number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_gender === "") 
    {
        Swal.fire({
            title: ("please provide funder's gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_funder_type === "") 
    {
        Swal.fire({
            title: ("please provide funder type"),
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
                $('#create_funder_individual_form').attr('action', '/Admin/Create/Funders');
                $('#create_funder_individual_form').attr('method', 'POST');
                $("#create_funder_individual_form").submit();

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




$('#create_funder_company_submit').click(function() {

    var funder_companyName = document.getElementById('companyName').value;
    var funder_com_companyPhone = document.getElementById('companyPhone').value;
    var funder_com_contactEmail = document.getElementById('contactEmail').value;
    var funder_com_companyRegistrationDate = document.getElementById('companyRegistrationDate').value;
    var funder_com_registrationNumber = document.getElementById('registrationNumber').value;
    var company_funder_funder_type = document.getElementById('funder_type_com').value;
    var funder_com_bank_id = document.getElementById('bank_id').value;
    var funder_com_companyAccountNumber = document.getElementById('companyAccountNumber').value;

    var funder_first_name = document.getElementById('com_first_name').value;
    var funder_last_name = document.getElementById('com_last_name').value;
    var funder_mobileNumber = document.getElementById('com_mobileNumber').value;
    var funder_dob = document.getElementById('com_dateOfBirth').value;
    var funder_email_address = document.getElementById('com_emailAddress').value;
    var funder_meansOfIdentificationNumber = document.getElementById('com_meansOfIdentificationNumber').value;
    var funder_gender = document.getElementById('com_gender').value;
   

    var funder_com_house_number = document.getElementById('com_house_number').value;
    var funder_com_area = document.getElementById('com_area').value;
    var funder_com_town = document.getElementById('com_town').value;
    var funder_com_accomodation_status = document.getElementById('com_accomodation_status').value;
    var funder_com_year_at_current_address = document.getElementById('com_year_at_current_address').value;
    var funder_com_funder_document = document.getElementById('com_funder_document').value;
    // alert(funder_com_funder_document.length)  type


    
    if (funder_companyName === "") 
    {
        Swal.fire({
            title: ("please provide company name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
    
  if (funder_com_companyPhone === "") 
    {
        Swal.fire({
            title: ("please provide company phone number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
    if (funder_com_companyPhone.length < 10 || funder_com_companyPhone.length > 10) 
    {
        Swal.fire({
            title: ("Kindly Provide a valid phone number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    
  if (funder_com_contactEmail === "") 
    {
        Swal.fire({
            title: ("please provide company email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
  if (funder_com_companyRegistrationDate === "") 
    {
        Swal.fire({
            title: ("please provide company registration date"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
  if (funder_com_registrationNumber === "") 
    {
        Swal.fire({
            title: ("please provide company registration number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
     if (funder_com_bank_id === "") 
    {
        Swal.fire({
            title: ("please select bank"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
     if (funder_com_companyAccountNumber === "") 
    {
        Swal.fire({
            title: ("please provide bank account number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    


      if (company_funder_funder_type === "") 
        {
            Swal.fire({
                title: ("please provide funder type"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

    if (funder_first_name === "") 
    {
        Swal.fire({
            title: ("please provide first name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
   
    if (funder_last_name === "") 
    {
        Swal.fire({
            title: ("please provide last name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_mobileNumber === "") 
    {
        Swal.fire({
            title: ("please provide funder's phone number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_mobileNumber.length < 10 || funder_mobileNumber.length > 10) 
    {
        Swal.fire({
            title: ("Kindly Provide a valid phone number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_dob === "") 
    {
        Swal.fire({
            title: ("please provide funder's dob"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (funder_email_address === "") 
    {
        Swal.fire({
            title: ("please provide funder's email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };


    if (funder_meansOfIdentificationNumber === "") 
    {
        Swal.fire({
            title: ("please provide funder's ID number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    

    if (funder_gender === "") 
    {
        Swal.fire({
            title: ("please provide funder's gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    
    if (funder_com_house_number === "") 
    {
        Swal.fire({
            title: ("please provide house number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
    
  if (funder_com_area === "") 
    {
        Swal.fire({
            title: ("please provide address area"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
  if (funder_com_town === "") 
    {
        Swal.fire({
            title: ("please provide town"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    
    if (funder_com_accomodation_status === "") 
        {
            Swal.fire({
                title: ("please provide accomodation status"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };
        
    if (funder_com_year_at_current_address === "") 
        {
            Swal.fire({
                title: ("please provide year(s) at current address"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

    if (funder_com_funder_document.length === 0) 
        {
            Swal.fire({
                title: ("Kindly Provide the required document"),
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
                $('#create_funder_company_form').attr('action', '/Create/Company/fund/Funder');
                $('#create_funder_company_form').attr('method', 'POST');
                $("#create_funder_company_form").submit();

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





$('#individual_editing_button').click(function() {

    // var loan_recommandation = document.getElementById('loan_recommandation').value;

    // if (loan_recommandation === "") 
    // {
    //     Swal.fire({
    //         title: ("please provide loan recommandation"),
    //         type: "warning",
    //         showCancelButton: false,
    //         confirmButtonColor: '#d33',
    //         cancelButtonColor: '#d33',
    //         confirmButtonText: 'Ok!',
    //         showLoaderOnConfirm: true
    //     })
    //     return false;
    // };
   

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
                $("#individual_editing").attr('action', '/Admin/client/maintain/edit_client_individual');
                $("#individual_editing").attr('method', 'POST');
                $("#individual_editing").submit();

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




var loan_pipeline_report_miz = $('#loan_pipeline_report_miz').DataTable({
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
                "titleAttr": "Loans Pipeline Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loans Pipeline Report -" + russ_formattedDateTime_1,
                "filename": "Loans Pipeline Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "Loans Pipeline Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loans Pipeline Report -" + russ_formattedDateTime_1,
                "filename": "Loans Pipeline Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "Loans Pipeline Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loans Pipeline Report -" + russ_formattedDateTime_1,
                "filename": "Loans Pipeline Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "Loans Pipeline Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Loans Pipeline Report -" + russ_formattedDateTime_1,
                "filename": "Loans Pipeline Report -" + russ_formattedDateTime_1,
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
        "url": '/Admin/Pipeline/Loan/Report',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "first_name_filter": $('#first_name_filter').val(),
            // "last_name_filter": $('#last_name_filter').val(),
            // "requested_amount_filter": $('#requested_amount_filter').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),
            // "disbursement_from": $('#disbursement_from').val(),
            // "disbursement_to": $('#disbursement_to').val(),
            // "applied_on_from": $('#applied_on_from').val(),
            // "applied_on_to": $('#applied_on_to').val(),
            // "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            // "contact_person_number_filter": $('#contact_person_number_filter').val(),
            // "loan_type_filter": $('#loan_type_filter').val(),
            

        }
    },
    "columns": [

        {
            "data": "application_date"
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
            "data": "principal_repaid_derived",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.principal_repaid_derived) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.principal_repaid_derived).toLocaleString(undefined, {
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
            "data": "accrued_no_days"
        },
      
        {
            "data": "status"
        },
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



var loan_disbursed_loans_per_funder_report = $('#loan_disbursed_loans_per_funder_report_miz').DataTable({
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
                "titleAttr": "Disbursed Loans Per Funder Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Per Funder Report -" + russ_formattedDateTime_1,
                "filename": "Disbursed Loans Per Funder Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "Disbursed Loans Per Funder Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Per Funder Report -" + russ_formattedDateTime_1,
                "filename": "Disbursed Loans Per Funder Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "Disbursed Loans Per Funder Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Per Funder Report -" + russ_formattedDateTime_1,
                "filename": "Disbursed Loans Per Funder Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10, 11]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "Disbursed Loans Per Funder Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loans Per Funder Report -" + russ_formattedDateTime_1,
                "filename": "Disbursed Loans Per Funder Report -" + russ_formattedDateTime_1,
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
        "url": '/Admin/disbursed/Loan/By/FunderReport',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "first_name_filter": $('#first_name_filter').val(),
            // "last_name_filter": $('#last_name_filter').val(),
            // "requested_amount_filter": $('#requested_amount_filter').val(),
            // "from": $('#from').val(),
            // "to": $('#to').val(),
            // "disbursement_from": $('#disbursement_from').val(),
            // "disbursement_to": $('#disbursement_to').val(),
            // "applied_on_from": $('#applied_on_from').val(),
            // "applied_on_to": $('#applied_on_to').val(),
            // "filter_by_number_of_days_filter": $('#filter_by_number_of_days_filter').val(),
            // "contact_person_number_filter": $('#contact_person_number_filter').val(),
            // "loan_type_filter": $('#loan_type_filter').val(),
            "disbursed_funder_id_filter": $('#disbursed_funder_id_filter').val(),
            "disbursed_offtaker_id_filter": $('#disbursed_offtaker_id_filter').val(),


            
            

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
        // {
        //     "data": "principal_amount"
        // },
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
        //     "data": "interest_amount"
        // },
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
        //     "data": "finance_cost"
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
       
        // {
        //     "data": "repayment_amount"
        // },
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




$("#loan_disbursed_loans-listing-filter").on("click", function() {
    $("#loan_disbursed_loans_report-filter-modal").modal("show");
});


$("#loan_disbursed_loans_per_funder_report_button").on("click", function() {
    loan_disbursed_loans_per_funder_report.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        // data.first_name_filter = $("#first_name_filter").val();
        // data.last_name_filter = $("#last_name_filter").val();
        // data.requested_amount_filter = $("#requested_amount_filter").val();
        // data.contact_person_number_filter = $("#contact_person_number_filter").val();
        // data.from = $("#from").val();
        // data.to = $("#to").val();
        // data.disbursement_from = $("#disbursement_from").val();
        // data.disbursement_to = $("#disbursement_to").val();
        // data.applied_on_from = $("#applied_on_from").val();
        // data.applied_on_to = $("#applied_on_to").val();
        // data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        // data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        // data.loan_type_filter = $("#loan_type_filter").val();
        data.disbursed_funder_id_filter = $("#disbursed_funder_id_filter").val();   
        data.disbursed_offtaker_id_filter = $("#disbursed_offtaker_id_filter").val();   
        
        
    });
    $("#loan_disbursed_loans_report-filter-modal").modal("hide");
    loan_disbursed_loans_per_funder_report.draw();
});

$('#loan_disbursed_loans_report_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    loan_disbursed_loans_per_funder_report.draw();
});




var var_end_of_day_totals_report = $('#end_of_day_totals_report').DataTable({
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
                "titleAttr": "End of Day Totals Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "End of Day Totals Report -" + russ_formattedDateTime_1,
                "filename": "End of Day Totals Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "End of Day Totals Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "End of Day Totals Report -" + russ_formattedDateTime_1,
                "filename": "End of Day Totals Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "End of Day Totals Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "End of Day Totals Report -" + russ_formattedDateTime_1,
                "filename": "End of Day Totals Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "End of Day Totals Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "End of Day Totals Report -" + russ_formattedDateTime_1,
                "filename": "End of Day Totals Report -" + russ_formattedDateTime_1,
                "exportOptions": {
                    'columns': [0, 1, 2, 3, 4, 5, 6]
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
        "url": '/Admin/post/all/Eod/logs/report',
        "data": {
            _csrf_token: $("#csrf").val(),
            // "id": $('#id').val(),
            "eod_start_date": $('#eod_start_date').val(),
            "eod_end_date": $('#eod_end_date').val()
            

        }
    },
    "columns": [
        { "data": "end_date", 
            render: function(data, type, row) {
                if (data) {
                    var options = {
                        // hour: "2-digit",
                        // minute: "2-digit",

                        year: "numeric",
                        month: "long",
                        day: "numeric",
                        hour: "numeric",
                        minute: "numeric",
                        second: "numeric",
                        // timeZoneName: "short",

                    };
                    var today = new Date(data);
                    return today.toLocaleTimeString("en-GB", options); //.dateFormat("dd-mmm-yyyy, HH:MM:SS")
                }
            },
        },

        { "data": "date_ran", 
            render: function(data, type, row) {
                if (data) {
                    var options = {
                        // hour: "2-digit",
                        // minute: "2-digit",

                        year: "numeric",
                        month: "long",
                        day: "numeric",
                        hour: "numeric",
                        minute: "numeric",
                        second: "numeric",
                        // timeZoneName: "short",

                    };
                    var today = new Date(data);
                    return today.toLocaleTimeString("en-GB", options); //.dateFormat("dd-mmm-yyyy, HH:MM:SS")
                }
            },
        },
        { "data": "date_ran", 
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
  
        {
            "data": "end_of_day_type"
        },
        {
            "data": "status"
        },

        {
            "data": "total_interest_accrued",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.total_interest_accrued) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.total_interest_accrued).toLocaleString(undefined, {
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
            "data": "penalties_incurred",
            "render": function(data, type, row) {
            // Check if "daily_accrued_finance_cost" exists in the row data
            if (row.penalties_incurred) {
                // Parse the number and format it with commas and two decimal places
                var formattedNumber = parseFloat(row.penalties_incurred).toLocaleString(undefined, {
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
            "data": "eod_ref_no",
            "render": function(data, type, row) {
                return `
                    <a href="/Admin/view/all/Eod/entries/report?eod_ref_no=${row.eod_ref_no}" class="btn ripple btn-success btn-sm">
                        <i class="flaticon-eye icon-sm"></i> View
                    </a>
                `;
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
        [0, 'asc']
    ],
    "columnDefs": [{
            "targets": [5, 6],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
        },

        // {
        //     "targets": 5,
        //     "className": "text-center"
        // }
    ]
});


    $("#loans_end_of_day-listing-filter").on("click", function() {
        $("#loans_end_of_day_filter-modal").modal("show");
    });

    $("#loans_end_of_day_listing_filter_miz").on("click", function() {
        var_end_of_day_totals_report.on("preXhr.dt", function(e, settings, data) {
            data._csrf_token = $("#csrf").val();
            data.eod_start_date = $("#eod_start_date").val();
            data.eod_end_date = $("#eod_end_date").val();   
        });
        $("#loans_end_of_day_filter-modal").modal("hide");
        var_end_of_day_totals_report.draw();
    });



    function reloadPage() {
        location.reload();
    }


    
function calculateDateDifference(data, type, row) {
    // Check if the date columns exist in the row data

    if (row.periodType === "DAY") {
        if (row.start_date && row.end_date) {
            // Assuming your date columns are named 'start_date' and 'end_date'
            var startDate = moment(row.start_date);
            var endDate = moment(row.end_date);
    
                
            // Calculate the difference in days
            var differenceInDays = endDate.diff(startDate, 'days');
            if (differenceInDays > 1)
    
            {
                return differenceInDays + " days";
            }
            else
            {
                return differenceInDays + " day";
            }
        
            // Return the difference in days
            
            } else {
            // Display "0 days" when either or both of the date columns are missing
            return "0 days";
            }
        }
        else
        {
            var no_of_month = moment(row.number_of_months);
                months = (no_of_month)
                if (months > 1)
                {
                    return no_of_month + " months";
                }
                else
                {
                    return months + " month";
                }
            
        }
       
  }


  var dt_over_due_client_loans = $('#dt-all-over-due-loans-report').DataTable({
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
                    extend: 'colvis',
                    text: 'Column Visibility',
                    messageTop: "Over Due Payment Loans Table -" + russ_formattedDateTime_1,
                    filename: "Over Due Payment Loans Table -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                    extend: 'csvHtml5',
                    text: 'Excel',
                    messageTop: "Over Due Payment Loans Report -" + russ_formattedDateTime_1,
                    filename: "Over Due Payment Loans Report -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                    extend: 'pdfHtml5',
                    text: 'PDF',
                    titleAttr: 'Loans PDF File',
                    messageTop: "Over Due Payment Loans Report -" + russ_formattedDateTime_1,
                    filename: "Over Due Payment Loans Report -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },  
                {
                    extend: 'print',
                    text: 'Print',
                    messageTop: "Over Due Payment Loans Table -" + russ_formattedDateTime_1,
                    filename: "Over Due Payment Loans Report -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    },
                    "orientation" : 'landscape',
                    "pageSize" : 'LEGAL',
                },
                {
                    extend: 'csvHtml5',
                    text: 'CSV',
                    messageTop: "Over Due Payment Loans Report -" + russ_formattedDateTime_1,
                    filename: "Over Due Payment Loans Report -" + russ_formattedDateTime_1,
                    exportOptions: {
                        columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
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
        "url": '/Admin/Get/All/Over/Due/Loans',
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
        { "data": "accrued_no_days" },
        { "data": "monthly_installment" },
        {
            "data": "disbursedon_date",
            "render": function(data, type, row) {
                // Check if "daily_accrued_finance_cost" exists in the row data
                if (row.disbursedon_date) {
                    // Parse the number and format it with commas and two decimal places
                    var shiftedDate = shiftDate(row.disbursedon_date, row.tenor);
                    return "<span>" + shiftedDate + "</span>";
                } else {
                    return "<span class=''>N/A</span>";
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
            "targets": [5, 6, 7, 8, 9, 10, 11],
            "className": "text-right fw-500"
        },
        {
            "targets": [6, 7, 8, 9],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
        },
    ]
});



$("#dt_due_client_loans_report_button-listing-filter").on("click", function() {
    $("#due_client_loans_report_button_report-filter-modal").modal("show");
});


$("#dt_due_client_loans_report_button").on("click", function() {
    dt_due_client_loans.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_due_loans_filter = $("#first_name_due_loans_filter").val();
        // data.last_name_filter = $("#last_name_filter").val();
        // data.requested_amount_filter = $("#requested_amount_filter").val();
        // data.contact_person_number_filter = $("#contact_person_number_filter").val();
        // data.from = $("#from").val();
        // data.to = $("#to").val();
        // data.disbursement_from = $("#disbursement_from").val();
        // data.disbursement_to = $("#disbursement_to").val();
        // data.applied_on_from = $("#applied_on_from").val();
        // data.applied_on_to = $("#applied_on_to").val();
        // data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        // data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        // data.loan_type_filter = $("#loan_type_filter").val();
        data.disbursed_funder_id_filter = $("#disbursed_funder_id_filter").val();   
        data.disbursed_offtaker_id_filter = $("#disbursed_offtaker_id_filter").val();   
        
        
    });
    $("#due_client_loans_report_button_report-filter-modal").modal("hide");
    dt_due_client_loans.draw();
});




$("#dt_over_due_client_loans_report_button-listing-filter").on("click", function() {
    $("#over_due_client_loans_report_button_report-filter-modal").modal("show");
});


$("#dt_over_due_client_loans_report_button").on("click", function() {
    dt_over_due_client_loans.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_due_loans_filter = $("#first_name_due_loans_filter").val();
        // data.last_name_filter = $("#last_name_filter").val();
        // data.requested_amount_filter = $("#requested_amount_filter").val();
        // data.contact_person_number_filter = $("#contact_person_number_filter").val();
        // data.from = $("#from").val();
        // data.to = $("#to").val();
        // data.disbursement_from = $("#disbursement_from").val();
        // data.disbursement_to = $("#disbursement_to").val();
        // data.applied_on_from = $("#applied_on_from").val();
        // data.applied_on_to = $("#applied_on_to").val();
        // data.loan_repayment_status_filter = $("#loan_repayment_status_filter").val();
        // data.filter_by_number_of_days_filter = $("#filter_by_number_of_days_filter").val();
        // data.loan_type_filter = $("#loan_type_filter").val();
        data.disbursed_funder_id_filter = $("#disbursed_funder_id_filter").val();   
        data.disbursed_offtaker_id_filter = $("#disbursed_offtaker_id_filter").val();   
        
        
    });
    $("#over_due_client_loans_report_button_report-filter-modal").modal("hide");
    dt_over_due_client_loans.draw();
});




var dt_active_loans_corporate_per_funder = $('#dt-active-loans-corporate-per-funder').DataTable({
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
                "titleAttr": "All Loan Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "All Loan Report -" + russ_formattedDateTime,
                "filename": "All Loan Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "All Loan Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "All Loan Report -" + russ_formattedDateTime,
                "filename": "All Loan Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "All Loan Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "All Loan Report -" + russ_formattedDateTime,
                "filename": "All Loan Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "All Loan Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "All Loan Report -" + russ_formattedDateTime,
                "filename": "All Loan Report -" + russ_formattedDateTime,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10]
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
        "url": '/Admin/All/Loans/Report/By/Funder',
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
        // {
        //     "data": "corporate_collateral",
        //     "render": function(data, _, row) {
        //         let show = "";
        
        //         if (data === "" || data === null) {
        //             if (row.individual_client_collateral === "" ||  row.individual_client_collateral === null){
        //                 show = '<span style="color: red">N/A</span>';
        //             } else
        //              show = '<a href="/View/All/collateral/Documents/Per/loan?loan_id=' + row.loan_id + '&fileName=' + 'Post-dated cheques' +'" class="btn ripple btn-info btn-sm"><i class="flaticon-eye icon-sm"></i> Document</a>';
        //         } else {
        //             show = '<a href="/View/All/collateral/Documents/Per/loan?loan_id=' + row.loan_id + '&fileName=' + "Original Collateral Document" +'" class="btn ripple btn-info btn-sm"><i class="flaticon-eye icon-sm"></i> Document</a>';
        //         }
        
        //         return show;
        //     }
        // }
        
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


$('#kt_datatable_funder').DataTable({
    dom: `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
    buttons:[
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Generate CSV',
            className: 'btn-outline-primary btn-sm mr-1'
        },
        {
            extend: 'copyHtml5',
            text: 'Copy',
            titleAttr: 'Copy to clipboard',
            className: 'btn-outline-primary btn-sm mr-1'
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Print Table',
            className: 'btn-outline-primary btn-sm mr-1'
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Generate PDF',
            className: 'btn-outline-primary btn-sm mr-1'
        },
        {
            extend: 'excelHtml5',
            text: 'Excel',
            titleAttr: 'Generate Excel',
            className: 'btn-outline-primary btn-sm mr-1'
        },

    ],
    "responsive": true,
    "processing": true,
    'language': {
        'loadingRecords': '&nbsp;',
        processing: '<i class="fa fa-spinner fa-spin fa-2x fa-fw"></i><span class="sr-only">Loading...</span> ',
        "EmptyTable": "No Records !"
    },
    "serverSide": false,
    "paging": true,
    "lengthMenu": [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [0, 'asc']
    ],
});




var dt_over_due_loans_per_funder = $('#dt-view-over-due-loans-per-funder').DataTable({
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
                "titleAttr": "All Overdue Loans Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "All Overdue Loans Report -" + russ_formattedDateTime_3,
                "filename": "All Overdue Loans Report -" + russ_formattedDateTime_3,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": "All Overdue Loans Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "All Overdue Loans Report -" + russ_formattedDateTime_3,
                "filename": "All Overdue Loans Report -" + russ_formattedDateTime_3,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": "All Overdue Loans Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "All Overdue Loans Report -" + russ_formattedDateTime_3,
                "filename": "All Overdue Loans Report -" + russ_formattedDateTime_3,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10]
                }, 
                "orientation" : 'landscape',
                "pageSize" : 'LEGAL',
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": "All Overdue Loans Report",
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "All Overdue Loans Report -" + russ_formattedDateTime_3,
                "filename": "All Overdue Loans Report -" + russ_formattedDateTime_3,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7,8, 9, 10]
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
        "url": '/Admin/Get/All/Over/Due/Loans/Report/By/Funder',
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
        // {
        //     "data": "corporate_collateral",
        //     "render": function(data, _, row) {
        //         let show = "";
        
        //         if (data === "" || data === null) {
        //             if (row.individual_client_collateral === "" ||  row.individual_client_collateral === null){
        //                 show = '<span style="color: red">N/A</span>';
        //             } else
        //              show = '<a href="/View/All/collateral/Documents/Per/loan?loan_id=' + row.loan_id + '&fileName=' + 'Post-dated cheques' +'" class="btn ripple btn-info btn-sm"><i class="flaticon-eye icon-sm"></i> Document</a>';
        //         } else {
        //             show = '<a href="/View/All/collateral/Documents/Per/loan?loan_id=' + row.loan_id + '&fileName=' + "Original Collateral Document" +'" class="btn ripple btn-info btn-sm"><i class="flaticon-eye icon-sm"></i> Document</a>';
        //         }
        
        //         return show;
        //     }
        // }
        
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


var last_five_disbursed_loans_per_funder = $('#last_five_disbursed_loans_for_funder').DataTable({
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
                "messageTop": "Disbursed Loan Report -" + russ_formattedDateTime_5,
                "filename": "Disbursed Loan Report -" + russ_formattedDateTime_5,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Disbursed Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Disbursed Loan Report -" + russ_formattedDateTime_5,
                "filename": "Disbursed Loan Report -" + russ_formattedDateTime_5,
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
        "url": '/Admin/Get/Funder/Report/All/Disbursed/Loans',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
    "columns": [
        {
            "data": "customer_name",
            "defaultContent": "<span class='text-danger'>N/A</span>"
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
    "lengthChange": false,
    "lengthMenu": [
        [5],
        [5]
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





$('#update_employer_details').click(function() {

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
                $('#update_employer_details_form').attr('action', '/Admin/Edit/Client/Management/Employer-Maintenance');
                $('#update_employer_details_form').attr('method', 'POST');
                $("#update_employer_details_form").submit();

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





$('#company_documents tbody').on('click', '.activate-company-document', function(e) {
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
                url: '/Admin/system/company/activate',
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


/////////////////////////////////////////////////////////////// RUSSELL ////////////////////////////////////////////////////////////////////////

