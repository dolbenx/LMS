var dt_pending_funder_loans = $('#dt_funder_pending_loans').DataTable({
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
        "url": '/Funder/get/all/pending/employee/loans',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
           
        } 
    },
    "columns": [

        { "data": "customer_names"},
        { "data": "customer_identification_number"},
        { "data": "customer_principal_amount"},
        { "data": "interest_amount"},
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

$('#accountant_invoice_approve_button').click(function() {

    var has_mou = document.getElementById('has_mou').value;
    var disbursed_amount = document.getElementById('disbursement_amount').value;

    if (has_mou === "YES") {

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
                    $('#accountant_invoice_approve').attr('action', '/Accounts/Management/Approve/Loan/Application');
                    $('#accountant_invoice_approve').attr('method', 'POST');
                    $("#accountant_invoice_approve").submit();
    
            } else {
                // spinner.hide();
                Swal.fire(
                    'Cancelled',
                    'Operation not performed :)',
                    'error'
                )
            }
          })}

    else

    {

    var loan_document_upload_mou = document.getElementById('loan_document_upload').value;

    var loan_document_upload_mou_length = loan_document_upload_mou.length;

    var document_upload = loan_document_upload_mou_length

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
                    $('#accountant_invoice_approve').attr('action', '/Accounts/Management/Approve/Loan/Application');
                    $('#accountant_invoice_approve').attr('method', 'POST');
                    $("#accountant_invoice_approve").submit();
    
            } else {
                // spinner.hide();
                Swal.fire(
                    'Cancelled',
                    'Operation not performed :)',
                    'error'
                )
            }
          })
    }
    });

$('#invoice-capturing-loan_application').click(function() {
   
    var months = document.getElementById('months').value;
    var offtaker_mou = document.getElementById('offtaker_mou').value;
    var loanAmount = document.getElementById('numberInput').value;
    var input_invoice_value = document.getElementById('input_invoice_value').value;
    var offtaker_selection = document.getElementById('offtaker_selection').value;

    var invoice_percentage = document.getElementById('invoice_percentage').value;

    var invoice_no = document.getElementById('invoice_no').value;
    var date_of_issue = document.getElementById('date_of_issue').value;
    var payment_terms = document.getElementById('payment_terms').value;

    var loan_document_upload_mou = document.getElementById('loan_document_upload_mou').value;
    var loan_document_upload_no_mou = document.getElementById('loan_document_upload_no_mou').value;

    var loan_document_upload_mou_length = loan_document_upload_mou.length;
    var loan_document_upload_no_mou_length = loan_document_upload_no_mou.length;

    var document_upload = loan_document_upload_mou_length || loan_document_upload_no_mou_length


   


    if (offtaker_mou === "") 
    {
        Swal.fire({
            title: ("please indicate if loan has offtaker mou or not"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };


    if (input_invoice_value === "") 
    {
        Swal.fire({
            title: ("please provide invoice amount"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (invoice_percentage === "") 
    {
        Swal.fire({
            title: ("please provide invoice percentage"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (loanAmount === "") 
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

    if (invoice_no === "") 
    {
        Swal.fire({
            title: ("please provide invoice number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (date_of_issue === "") 
    {
        Swal.fire({
            title: ("please provide date of issue"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (payment_terms === "") 
    {
        Swal.fire({
            title: ("please provide payment terms"),
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
                $('#invoice_capturing_form').attr('action', '/create/invoice/discounting/application');
                $('#invoice_capturing_form').attr('method', 'POST');
                $("#invoice_capturing_form").submit();

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


$('#credit_invoice_approve_button').click(function() {

    var sec_loan_status = document.getElementById('sec_loan_status').value;

    if (sec_loan_status === "APPROVED_FROM_CEO") {

        var loan_document_upload_mou = document.getElementById('loan_document_upload_mou').value;

        var loan_document_upload_mou_length = loan_document_upload_mou.length;

        var document_upload = loan_document_upload_mou_length

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
                    $('#credit_invoice_approve').attr('action', '/Credit/Management/Approve/Loan/Application');
                    $('#credit_invoice_approve').attr('method', 'POST');
                    $("#credit_invoice_approve").submit();
    
            } else {
                // spinner.hide();
                Swal.fire(
                    'Cancelled',
                    'Operation not performed :)',
                    'error'
                )
            }
          })
    }

    else

    {

    var has_mou = document.getElementById('has_mou').value;
    var choose_funder = document.getElementById('funderID').value;

    if (has_mou === "YES") {

        var loan_document_upload_mou = document.getElementById('loan_document_upload_mou').value;
        var loan_document_upload_no_mou_internal = document.getElementById('loan_document_upload_no_mou_internal').value;

        var loan_document_upload_mou_length = loan_document_upload_mou.length;
        var loan_document_upload_no_mou_internal_length = loan_document_upload_no_mou_internal.length;

        var document_upload =( loan_document_upload_mou_length || loan_document_upload_no_mou_internal_length)

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
                    $('#credit_invoice_approve').attr('action', '/Credit/Management/Approve/Loan/Application');
                    $('#credit_invoice_approve').attr('method', 'POST');
                    $("#credit_invoice_approve").submit();

            } else {
                // spinner.hide();
                Swal.fire(
                    'Cancelled',
                    'Operation not performed :)',
                    'error'
                )
            }
          })}

    else

    {

    var loan_document_upload_mou = document.getElementById('loan_document_upload_mou').value;
    var loan_document_upload_no_mou_internal = document.getElementById('loan_document_upload_no_mou_internal').value;

    var loan_document_upload_mou_length = loan_document_upload_mou.length;
    var loan_document_upload_no_mou_internal_length = loan_document_upload_no_mou_internal.length;

    var document_upload =( loan_document_upload_mou_length || loan_document_upload_no_mou_internal_length)
        
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
                    $('#credit_invoice_approve').attr('action', '/Credit/Management/Approve/Loan/Application');
                    $('#credit_invoice_approve').attr('method', 'POST');
                    $("#credit_invoice_approve").submit();
    
            } else {
                // spinner.hide();
                Swal.fire(
                    'Cancelled',
                    'Operation not performed :)',
                    'error'
                )
            }
          })
    }}
    });

$('#operations_invoice_approve_button').click(function() {
   

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
                $('#operations_invoice_approve').attr('action', '/Operations/Management/Approve/Loan/Application');
                $('#operations_invoice_approve').attr('method', 'POST');
                $("#operations_invoice_approve").submit();

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

$('#management_invoice_approve_button').click(function() {
   

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
                $('#management_invoice_approve').attr('action', '/Mgt/Approve/Invoice/Discounting/Loan');
                $('#management_invoice_approve').attr('method', 'POST');
                $("#management_invoice_approve").submit();

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


$('#change_password').click(function() {

    Swal.fire({
      title: '<span class="custom-title">Change Password</span>',
      html:
        '<form name="myForm" id="change_password_post" method="post" onsubmit="return validateForm()">' +
            '<div class="form-group row fv-plugins-icon-container has-success">' +
                '<label class="col-3 col-form-label"><strong>Current Password:</strong> </label>' +
                '<div class="col-9">' +
                    '<div class="input-group input-group-sm">' +
                        '<input type="password" id="uname1" class="swal2-input" name="current_password" required>' +
                    '</div>' +
                '</div>' +
                '<div class="fv-plugins-message-container"></div>' +
            '</div>' +
            '<div class="form-group row fv-plugins-icon-container has-success">' +
                '<label class="col-3 col-form-label"><strong>New Password:</strong> </label>' +
                '<div class="col-9">' +
                    '<div class="input-group input-group-sm">' +
                        '<input type="password" id="pwd1" class="swal2-input" name="new_password" required>' +
                    '</div>' +
                '</div>' +
                '<div class="fv-plugins-message-container"></div>' +
            '</div>' +
            '<div class="form-group row">' +
                '<div class="col-9 offset-3">' +
                    '<input type="checkbox" id="show_password">' +
                    '<label for="show_password">Show Password</label>' +
                '</div>' +
            '</div>' +
        '</form>',
      customClass: {
        popup: 'my-custom-size',
        confirmButtonText: 'custom-confirm-button'
      },
      type: "warning",  
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Save Changes',
      showLoaderOnConfirm: true,
      didOpen: () => {
        var showPasswordCheckbox = document.getElementById('show_password');
        var passwordFields = document.querySelectorAll('input[type="password"]');
        showPasswordCheckbox.addEventListener('change', function() {
          var type = this.checked ? 'text' : 'password';
          passwordFields.forEach(function(field) {
            field.type = type;
          });
        });
      }
    }).then((result) => {
      if (result.value) {
        $('#change_password_post').attr('action', '/user/change/password');
        $('#change_password_post').attr('method', 'POST');
        $("#change_password_post").submit();
      } else {
        Swal.fire(
          'Cancelled',
          'Operation not performed :)',
          'error'
        );
      }
    });
  });
  
  function validateForm() {
    let validate = document.forms["myForm"]["current_password", "new_password"].value;
    if (validate == "") {
        Swal.fire(
            'Empty fields',
            'Please fill out all the required fields',
          );
      return false;
    }
  }

$('#credit_analyst_instant_loan_employee_approval_button').click(function() {

    var loan_document_upload = document.getElementById('loan_document_upload').value;
    var choose_funder = document.getElementById('choose_funder').value;

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
                $("#approve_credit_consummer").attr('action', '/Credit/Analyst/Aprove/Employee/Consumer/Loan');
                $("#approve_credit_consummer").attr('method', 'POST');
                $("#approve_credit_consummer").submit();

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

$(document).ready(function() {

    $('#funderID').on('change', function() {

        var element = document.getElementById('funderID').value;

        var splittedInput = element.split("|||");

        var funder_external = document.getElementById("funder_external");

        var funder_internal = document.getElementById("funder_internal");

        value = splittedInput[0]
        type = splittedInput[1]

        console.log(type)
        console.log(value)

        if (splittedInput[1] === "INTERNAL FUNDER") {
            funder_internal.style.display = "block"; // Show the input field
        } else {
            funder_internal.style.display = "none"; // Hide the input field    
        }

        if (splittedInput[1] === "EXTERNAL FUNDER") {
            funder_external.style.display = "block"; // Show the input field
        } else {
            funder_external.style.display = "none"; // Hide the input field    
        } 

    })

});

$('#product_creation_button').click(function() {

    var get_product_type = document.getElementById('product_type').value;

    if (get_product_type === "INVOICE DISCOUNTING") {

    var product_name = document.getElementById('product_name').value;
    var currency = document.getElementById('currency').value;
    var description = document.getElementById('description').value;
    var code = document.getElementById('code').value;
    var product_type = document.getElementById('product_type').value;

    var product_interest = document.getElementById('product_interest').value;
    var product_mode = document.getElementById('product_mode').value;
    var product_period = document.getElementById('product_period').value;
    var minimum_principle = document.getElementById('minimum_principle').value;
    var maxmum_principle = document.getElementById('maxmum_principle').value;

    var finance_coast = document.getElementById('finance_coast').value;
    var principal_account = document.getElementById('principal_account').value;
    var interest_account = document.getElementById('interest_account').value;
    var charges_account = document.getElementById('charges_account').value;

    var repayment = document.getElementById('repayment').value;
    var tenor = document.getElementById('tenor').value;
    var interest_rates = document.getElementById('interest_rates').value;
    var processing_fee = document.getElementById('processing_fee').value;
    var product_charge_id = document.getElementById('product_charge_id').value;


    if (product_name === "") 
    {
        Swal.fire({
            title: ("please provide product name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (currency === "") 
    {
        Swal.fire({
            title: ("please select the currency"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (description === "") 
    {
        Swal.fire({
            title: ("please provide description"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (code === "") 
    {
        Swal.fire({
            title: ("please provide product code"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_type === "") 
    {
        Swal.fire({
            title: ("please select product type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_interest === "") 
    {
        Swal.fire({
            title: ("please provide product interest"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_mode === "") 
    {
        Swal.fire({
            title: ("please select product interest mode"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_period === "") 
    {
        Swal.fire({
            title: ("please select product period type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (minimum_principle === "") 
    {
        Swal.fire({
            title: ("please provide minimum principal"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (maxmum_principle === "") 
    {
        Swal.fire({
            title: ("please provide maxmum principal"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (finance_coast === "") 
    {
        Swal.fire({
            title: ("please provide finance cost"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (principal_account === "") 
    {
        Swal.fire({
            title: ("please select principal account"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (interest_account === "") 
    {
        Swal.fire({
            title: ("please select interest account"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (charges_account === "") 
    {
        Swal.fire({
            title: ("please select charges account"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (repayment === "") 
    {
        Swal.fire({
            title: ("please select repayment method"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (tenor === "") 
    {
        Swal.fire({
            title: ("please provide tenor"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (interest_rates === "") 
    {
        Swal.fire({
            title: ("please provide interest rate"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (processing_fee === "") 
    {
        Swal.fire({
            title: ("please provide processing fee"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_charge_id === "") 
    {
        Swal.fire({
            title: ("please select charges"),
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
                $('#product_creation').attr('action', '/Admin/view/all/products/create');
                $('#product_creation').attr('method', 'POST');
                $("#product_creation").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })}

    else {

    var product_name = document.getElementById('product_name').value;
    var currency = document.getElementById('currency').value;
    var description = document.getElementById('description').value;
    var code = document.getElementById('code').value;
    var product_type = document.getElementById('product_type').value;

    var product_interest = document.getElementById('product_interest').value;
    var product_mode = document.getElementById('product_mode').value;
    var product_period = document.getElementById('product_period').value;
    var minimum_principle = document.getElementById('minimum_principle').value;
    var maxmum_principle = document.getElementById('maxmum_principle').value;

    var arrangement_fee = document.getElementById('arrangement_fee').value;
    var finance_coast = document.getElementById('finance_coast').value;
    var principal_account = document.getElementById('principal_account').value;
    var interest_account = document.getElementById('interest_account').value;
    var charges_account = document.getElementById('charges_account').value;

    var repayment = document.getElementById('repayment').value;
    var tenor = document.getElementById('tenor').value;
    var interest_rates = document.getElementById('interest_rates').value;
    var processing_fee = document.getElementById('processing_fee').value;


    if (product_name === "") 
    {
        Swal.fire({
            title: ("please provide product name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (currency === "") 
    {
        Swal.fire({
            title: ("please select the currency"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (description === "") 
    {
        Swal.fire({
            title: ("please provide description"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (code === "") 
    {
        Swal.fire({
            title: ("please provide product code"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_type === "") 
    {
        Swal.fire({
            title: ("please select product type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_interest === "") 
    {
        Swal.fire({
            title: ("please provide product interest"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_mode === "") 
    {
        Swal.fire({
            title: ("please select product interest mode"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_period === "") 
    {
        Swal.fire({
            title: ("please select product period type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (minimum_principle === "") 
    {
        Swal.fire({
            title: ("please provide minimum principal"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (maxmum_principle === "") 
    {
        Swal.fire({
            title: ("please provide maxmum principal"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (arrangement_fee === "") 
    {
        Swal.fire({
            title: ("please provide arrangement fee"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (finance_coast === "") 
    {
        Swal.fire({
            title: ("please provide finance cost"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (principal_account === "") 
    {
        Swal.fire({
            title: ("please select principal account"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (interest_account === "") 
    {
        Swal.fire({
            title: ("please select interest account"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (charges_account === "") 
    {
        Swal.fire({
            title: ("please select charges account"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (repayment === "") 
    {
        Swal.fire({
            title: ("please select repayment method"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (tenor === "") 
    {
        Swal.fire({
            title: ("please provide tenor"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (interest_rates === "") 
    {
        Swal.fire({
            title: ("please provide interest rate"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (processing_fee === "") 
    {
        Swal.fire({
            title: ("please provide processing fee"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (product_charge_id === "") 
    {
        Swal.fire({
            title: ("please select charges"),
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
                $('#product_creation').attr('action', '/Admin/view/all/products/create');
                $('#product_creation').attr('method', 'POST');
                $("#product_creation").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
    }
    });

$(document).ready(function() {

    $('#product_type').on('change', function() {

        var get_product_type = document.getElementById('product_type').value;

        var show_arrangement = document.getElementById("show_arrangement");

        console.log(get_product_type)

        if (get_product_type === "INVOICE DISCOUNTING") {
            show_arrangement.style.display = "none"; // Show the input field
        } else {
            show_arrangement.style.display = "block"; // Hide the input field    
        }

    })

});

$('#employer_onboarding_upload').click(function() {

    var companyName = document.getElementById('companyName').value;
    var companyPhone = document.getElementById('companyPhone').value;
    var contactEmail = document.getElementById('contactEmail').value;
    var companyRegistrationDate = document.getElementById('companyRegistrationDate').value;
    var taxno = document.getElementById('taxno').value;

    var registrationNumber = document.getElementById('registrationNumber').value;
    var bank_id = document.getElementById('bank_id').value;
    var companyAccountNumber = document.getElementById('companyAccountNumber').value;
    var title = document.getElementById('title').value;
    var firstName = document.getElementById('firstName').value;

    var lastName = document.getElementById('lastName').value;
    var mobileNumber = document.getElementById('mobileNumber').value;
    var dateOfBirth = document.getElementById('dateOfBirth').value;

    var emailAddress = document.getElementById('emailAddress').value;
    var meansOfIdentificationNumber = document.getElementById('meansOfIdentificationNumber').value;
    var gender = document.getElementById('gender').value;
    var house_number = document.getElementById('house_number').value;
    var street_name = document.getElementById('street_name').value;

    var area = document.getElementById('area').value;
    var town = document.getElementById('town').value;
    var accomodation_status = document.getElementById('accomodation_status').value;
    var year_at_current_address = document.getElementById('year_at_current_address').value;
    var loan_document_upload = document.getElementById('loan_document_upload').value;


    var loan_document_upload = document.getElementById('loan_document_upload').value;

    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length


    if (companyName === "") 
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

    if (companyPhone === "") 
    {
        Swal.fire({
            title: ("please provide company phone"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (contactEmail === "") 
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

    if (companyRegistrationDate === "") 
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

    if (taxno === "") 
    {
        Swal.fire({
            title: ("please provide company tax number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (registrationNumber === "") 
    {
        Swal.fire({
            title: ("please provide company regitration number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (bank_id === "") 
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

    if (companyAccountNumber === "") 
    {
        Swal.fire({
            title: ("please provide company account number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (title === "") 
    {
        Swal.fire({
            title: ("please select title"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (firstName === "") 
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

    if (lastName === "") 
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

    if (mobileNumber === "") 
    {
        Swal.fire({
            title: ("please provide mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (dateOfBirth === "") 
    {
        Swal.fire({
            title: ("please provide date of birth"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (emailAddress === "") 
    {
        Swal.fire({
            title: ("please provide email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (meansOfIdentificationNumber === "") 
    {
        Swal.fire({
            title: ("please provide NRC number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (gender === "") 
    {
        Swal.fire({
            title: ("please provide gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (house_number === "") 
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

    if (street_name === "") 
    {
        Swal.fire({
            title: ("please provide street name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (area === "") 
    {
        Swal.fire({
            title: ("please provide area name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (town === "") 
    {
        Swal.fire({
            title: ("please provide town name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (accomodation_status === "") 
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

    if (year_at_current_address === "") 
    {
        Swal.fire({
            title: ("please provide years at current address"),
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
                $('#employer_onboarding').attr('action', '/Admin/Management/create/employer_maintenance');
                $('#employer_onboarding').attr('method', 'POST');
                $("#employer_onboarding").submit();

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

$('#sme_onboarding_upload').click(function() {

    var companyName = document.getElementById('companyName').value;
    var companyPhone = document.getElementById('companyPhone').value;
    var contactEmail = document.getElementById('contactEmail').value;
    var companyRegistrationDate = document.getElementById('companyRegistrationDate').value;
    var taxno = document.getElementById('taxno').value;

    var registrationNumber = document.getElementById('registrationNumber').value;
    var bank_id = document.getElementById('bank_id').value;
    var companyAccountNumber = document.getElementById('companyAccountNumber').value;
    var title = document.getElementById('title').value;
    var firstName = document.getElementById('firstName').value;

    var lastName = document.getElementById('lastName').value;
    var mobileNumber = document.getElementById('mobileNumber').value;
    var dateOfBirth = document.getElementById('dateOfBirth').value;

    var emailAddress = document.getElementById('emailAddress').value;
    var meansOfIdentificationNumber = document.getElementById('meansOfIdentificationNumber').value;
    var gender = document.getElementById('gender').value;
    var house_number = document.getElementById('house_number').value;
    var street_name = document.getElementById('street_name').value;

    var area = document.getElementById('area').value;
    var town = document.getElementById('town').value;
    var accomodation_status = document.getElementById('accomodation_status').value;
    var year_at_current_address = document.getElementById('year_at_current_address').value;
    var loan_document_upload = document.getElementById('loan_document_upload').value;


    var loan_document_upload = document.getElementById('loan_document_upload').value;

    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length


    if (companyName === "") 
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

    if (companyPhone === "") 
    {
        Swal.fire({
            title: ("please provide company phone"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (contactEmail === "") 
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

    if (companyRegistrationDate === "") 
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

    if (taxno === "") 
    {
        Swal.fire({
            title: ("please provide company tax number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (registrationNumber === "") 
    {
        Swal.fire({
            title: ("please provide company regitration number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (bank_id === "") 
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

    if (companyAccountNumber === "") 
    {
        Swal.fire({
            title: ("please provide company account number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (title === "") 
    {
        Swal.fire({
            title: ("please select title"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (firstName === "") 
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

    if (lastName === "") 
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

    if (mobileNumber === "") 
    {
        Swal.fire({
            title: ("please provide mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (dateOfBirth === "") 
    {
        Swal.fire({
            title: ("please provide date of birth"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (emailAddress === "") 
    {
        Swal.fire({
            title: ("please provide email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (meansOfIdentificationNumber === "") 
    {
        Swal.fire({
            title: ("please provide NRC number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (gender === "") 
    {
        Swal.fire({
            title: ("please provide gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (house_number === "") 
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

    if (street_name === "") 
    {
        Swal.fire({
            title: ("please provide street name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (area === "") 
    {
        Swal.fire({
            title: ("please provide area name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (town === "") 
    {
        Swal.fire({
            title: ("please provide town name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (accomodation_status === "") 
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

    if (year_at_current_address === "") 
    {
        Swal.fire({
            title: ("please provide years at current address"),
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
                $('#sme_onboarding').attr('action', '/Admin/Client/Management/Create/SME');
                $('#sme_onboarding').attr('method', 'POST');
                $("#sme_onboarding").submit();

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

$('#offtaker_onboarding_upload').click(function() {

    var companyName = document.getElementById('companyName').value;
    var companyPhone = document.getElementById('companyPhone').value;
    var contactEmail = document.getElementById('contactEmail').value;
    var companyRegistrationDate = document.getElementById('companyRegistrationDate').value;
    var taxno = document.getElementById('taxno').value;

    var registrationNumber = document.getElementById('registrationNumber').value;
    var bank_id = document.getElementById('bank_id').value;
    var companyAccountNumber = document.getElementById('companyAccountNumber').value;
    var title = document.getElementById('title').value;
    var firstName = document.getElementById('firstName').value;

    var lastName = document.getElementById('lastName').value;
    var mobileNumber = document.getElementById('mobileNumber').value;
    var dateOfBirth = document.getElementById('dateOfBirth').value;

    var emailAddress = document.getElementById('emailAddress').value;
    var meansOfIdentificationNumber = document.getElementById('meansOfIdentificationNumber').value;
    var gender = document.getElementById('gender').value;
    var house_number = document.getElementById('house_number').value;
    var street_name = document.getElementById('street_name').value;

    var area = document.getElementById('area').value;
    var town = document.getElementById('town').value;
    var accomodation_status = document.getElementById('accomodation_status').value;
    var year_at_current_address = document.getElementById('year_at_current_address').value;
    var loan_document_upload = document.getElementById('loan_document_upload').value;


    var loan_document_upload = document.getElementById('loan_document_upload').value;

    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length


    if (companyName === "") 
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

    if (companyPhone === "") 
    {
        Swal.fire({
            title: ("please provide company phone"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (contactEmail === "") 
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

    if (companyRegistrationDate === "") 
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

    if (taxno === "") 
    {
        Swal.fire({
            title: ("please provide company tax number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (registrationNumber === "") 
    {
        Swal.fire({
            title: ("please provide company regitration number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (bank_id === "") 
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

    if (companyAccountNumber === "") 
    {
        Swal.fire({
            title: ("please provide company account number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (title === "") 
    {
        Swal.fire({
            title: ("please select title"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (firstName === "") 
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

    if (lastName === "") 
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

    if (mobileNumber === "") 
    {
        Swal.fire({
            title: ("please provide mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (dateOfBirth === "") 
    {
        Swal.fire({
            title: ("please provide date of birth"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (emailAddress === "") 
    {
        Swal.fire({
            title: ("please provide email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (meansOfIdentificationNumber === "") 
    {
        Swal.fire({
            title: ("please provide NRC number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (gender === "") 
    {
        Swal.fire({
            title: ("please provide gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (house_number === "") 
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

    if (street_name === "") 
    {
        Swal.fire({
            title: ("please provide street name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (area === "") 
    {
        Swal.fire({
            title: ("please provide area name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (town === "") 
    {
        Swal.fire({
            title: ("please provide town name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (accomodation_status === "") 
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

    if (year_at_current_address === "") 
    {
        Swal.fire({
            title: ("please provide years at current address"),
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
                $('#offtaker_onboarding').attr('action', '/Admin/Client/Management/Create/Offtaker');
                $('#offtaker_onboarding').attr('method', 'POST');
                $("#offtaker_onboarding").submit();

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

$('#employee_onboarding_upload').click(function() {

    var payment_type = document.getElementById('payment_type').value;

    if( payment_type === "Mobile") {

    var title = document.getElementById('title').value;
    var firstName = document.getElementById('firstName').value;

    var lastName = document.getElementById('lastName').value;
    var mobileNumber = document.getElementById('mobileNumber').value;
    var dateOfBirth = document.getElementById('dateOfBirth').value;

    var emailAddress = document.getElementById('emailAddress').value;
    var meansOfIdentificationNumber = document.getElementById('meansOfIdentificationNumber').value;
    var gender = document.getElementById('gender').value;
    var house_number = document.getElementById('house_number').value;
    var street_name = document.getElementById('street_name').value;

    var area = document.getElementById('area').value;
    var town = document.getElementById('town').value;
    var accomodation_status = document.getElementById('accomodation_status').value;
    var year_at_current_address = document.getElementById('year_at_current_address').value;
    var loan_document_upload = document.getElementById('loan_document_upload').value;


    var mobile_number = document.getElementById('mobile_number').value;
    var bank_id = document.getElementById('bank_id').value;
    var bank_account_number = document.getElementById('bank_account_number').value;
    var accountName = document.getElementById('accountName').value;
    var company_id = document.getElementById('company_id').value;


    var employer_industry_type = document.getElementById('employer_industry_type').value;
    var occupation = document.getElementById('occupation').value;
    var date_of_joining = document.getElementById('date_of_joining').value;
    var employee_number = document.getElementById('employee_number').value;


    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length

    if (title === "") 
    {
        Swal.fire({
            title: ("please select title"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (firstName === "") 
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

    if (lastName === "") 
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

    if (mobileNumber === "") 
    {
        Swal.fire({
            title: ("please provide mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (dateOfBirth === "") 
    {
        Swal.fire({
            title: ("please provide date of birth"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (emailAddress === "") 
    {
        Swal.fire({
            title: ("please provide email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (meansOfIdentificationNumber === "") 
    {
        Swal.fire({
            title: ("please provide NRC number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (gender === "") 
    {
        Swal.fire({
            title: ("please provide gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (house_number === "") 
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

    if (street_name === "") 
    {
        Swal.fire({
            title: ("please provide street name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (area === "") 
    {
        Swal.fire({
            title: ("please provide area name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (town === "") 
    {
        Swal.fire({
            title: ("please provide town name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (accomodation_status === "") 
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

    if (year_at_current_address === "") 
    {
        Swal.fire({
            title: ("please provide years at current address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (mobile_number === "") 
    {
        Swal.fire({
            title: ("please provide mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (company_id === "") 
    {
        Swal.fire({
            title: ("please select company"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (employer_industry_type === "") 
    {
        Swal.fire({
            title: ("please provide employer industry type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (occupation === "") 
    {
        Swal.fire({
            title: ("please provide occupation"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (date_of_joining === "") 
    {
        Swal.fire({
            title: ("please provide date of joining"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (employee_number === "") 
    {
        Swal.fire({
            title: ("please provide employee number"),
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
                $('#employee_onboarding').attr('action', '/Admin/client/maintain/employee/create/client');
                $('#employee_onboarding').attr('method', 'POST');
                $("#employee_onboarding").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })}
        else {
            var title = document.getElementById('title').value;
        var firstName = document.getElementById('firstName').value;

        var lastName = document.getElementById('lastName').value;
        var mobileNumber = document.getElementById('mobileNumber').value;
        var dateOfBirth = document.getElementById('dateOfBirth').value;

        var emailAddress = document.getElementById('emailAddress').value;
        var meansOfIdentificationNumber = document.getElementById('meansOfIdentificationNumber').value;
        var gender = document.getElementById('gender').value;
        var house_number = document.getElementById('house_number').value;
        var street_name = document.getElementById('street_name').value;

        var area = document.getElementById('area').value;
        var town = document.getElementById('town').value;
        var accomodation_status = document.getElementById('accomodation_status').value;
        var year_at_current_address = document.getElementById('year_at_current_address').value;
        var loan_document_upload = document.getElementById('loan_document_upload').value;

        var bank_id = document.getElementById('bank_id').value;
        var bank_account_number = document.getElementById('bank_account_number').value;
        var accountName = document.getElementById('accountName').value;
        var company_id = document.getElementById('company_id').value;

        var employer_industry_type = document.getElementById('employer_industry_type').value;
        var occupation = document.getElementById('occupation').value;
        var date_of_joining = document.getElementById('date_of_joining').value;
        var employee_number = document.getElementById('employee_number').value;


        var loan_document_upload_length = loan_document_upload.length;

        var document_upload = loan_document_upload_length

        if (title === "") 
        {
            Swal.fire({
                title: ("please select title"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (firstName === "") 
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

        if (lastName === "") 
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

        if (mobileNumber === "") 
        {
            Swal.fire({
                title: ("please provide mobile number"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (dateOfBirth === "") 
        {
            Swal.fire({
                title: ("please provide date of birth"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (emailAddress === "") 
        {
            Swal.fire({
                title: ("please provide email address"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (meansOfIdentificationNumber === "") 
        {
            Swal.fire({
                title: ("please provide NRC number"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (gender === "") 
        {
            Swal.fire({
                title: ("please provide gender"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (house_number === "") 
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

        if (street_name === "") 
        {
            Swal.fire({
                title: ("please provide street name"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (area === "") 
        {
            Swal.fire({
                title: ("please provide area name"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (town === "") 
        {
            Swal.fire({
                title: ("please provide town name"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (accomodation_status === "") 
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

        if (year_at_current_address === "") 
        {
            Swal.fire({
                title: ("please provide years at current address"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (bank_id === "") 
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

        if (bank_account_number === "") 
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

        if (company_id === "") 
        {
            Swal.fire({
                title: ("please select company"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (accountName === "") 
        {
            Swal.fire({
                title: ("please provide account name"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (employer_industry_type === "") 
        {
            Swal.fire({
                title: ("please provide employer industry type"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (occupation === "") 
        {
            Swal.fire({
                title: ("please provide occupation"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (date_of_joining === "") 
        {
            Swal.fire({
                title: ("please provide date of joining"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };

        if (employee_number === "") 
        {
            Swal.fire({
                title: ("please provide employee number"),
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
                    $('#employee_onboarding').attr('action', '/Admin/client/maintain/employee/create/client');
                    $('#employee_onboarding').attr('method', 'POST');
                    $("#employee_onboarding").submit();

            } else {
                // spinner.hide();
                Swal.fire(
                    'Cancelled',
                    'Operation not performed :)',
                    'error'
                )
            }
          })
        }
    });

$('#individual_onboarding_upload').click(function() {

    var employement_type = document.getElementById('employement_type').value;

    if( employement_type === "Employed") {

    var title = document.getElementById('title').value;
    var firstName = document.getElementById('firstName').value;

    var lastName = document.getElementById('lastName').value;
    var mobileNumber = document.getElementById('mobileNumber').value;
    var dateOfBirth = document.getElementById('dateOfBirth').value;

    var emailAddress = document.getElementById('emailAddress').value;
    var meansOfIdentificationNumber = document.getElementById('meansOfIdentificationNumber').value;
    var gender = document.getElementById('gender').value;
    var house_number = document.getElementById('house_number').value;
    var street_name = document.getElementById('street_name').value;

    var area = document.getElementById('area').value;
    var town = document.getElementById('town').value;
    var accomodation_status = document.getElementById('accomodation_status').value;
    var year_at_current_address = document.getElementById('year_at_current_address').value;
    var loan_document_upload = document.getElementById('loan_document_upload').value;

    var kin_first_name = document.getElementById('kin_first_name').value;
    var kin_last_name = document.getElementById('kin_last_name').value;
    var kin_ID_number = document.getElementById('kin_ID_number').value;
    var kin_mobile_number = document.getElementById('kin_mobile_number').value;
    var kin_relationship = document.getElementById('kin_relationship').value;
    var kin_gender = document.getElementById('kin_gender').value;
    var kn_marital_status = document.getElementById('kn_marital_status').value;


    var company_name = document.getElementById('company_name').value;
    var company_phone = document.getElementById('company_phone').value;
    var registration_number = document.getElementById('registration_number').value;
    var company_registration_date = document.getElementById('company_registration_date').value;
    var taxno = document.getElementById('taxno').value;
    var contact_email = document.getElementById('contact_email').value;

    var mobile_number = document.getElementById('account_mobile_number').value;
    var bank_id = document.getElementById('bank_id').value;
    var bank_account_number = document.getElementById('bank_account_number').value;
    var accountName = document.getElementById('accountName').value;
    var payment_type = document.getElementById('payment_type').value;
    var employement_type = document.getElementById('employement_type').value;


    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length

    if (title === "") 
    {
        Swal.fire({
            title: ("please select title"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (firstName === "") 
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

    if (lastName === "") 
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

    if (mobileNumber === "") 
    {
        Swal.fire({
            title: ("please provide mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (dateOfBirth === "") 
    {
        Swal.fire({
            title: ("please provide date of birth"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (emailAddress === "") 
    {
        Swal.fire({
            title: ("please provide email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (meansOfIdentificationNumber === "") 
    {
        Swal.fire({
            title: ("please provide NRC number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (gender === "") 
    {
        Swal.fire({
            title: ("please provide gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (house_number === "") 
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

    if (street_name === "") 
    {
        Swal.fire({
            title: ("please provide street name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (area === "") 
    {
        Swal.fire({
            title: ("please provide area name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (town === "") 
    {
        Swal.fire({
            title: ("please provide town name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (accomodation_status === "") 
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

    if (year_at_current_address === "") 
    {
        Swal.fire({
            title: ("please provide years at current address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_first_name === "") 
    {
        Swal.fire({
            title: ("please provide kin first name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_last_name === "") 
    {
        Swal.fire({
            title: ("please provide kin last name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_ID_number === "") 
    {
        Swal.fire({
            title: ("please provide kin NRC number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_mobile_number === "") 
    {
        Swal.fire({
            title: ("please provide kin mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_relationship === "") 
    {
        Swal.fire({
            title: ("please select kin relationship"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_gender === "") 
    {
        Swal.fire({
            title: ("please select kin gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kn_marital_status === "") 
    {
        Swal.fire({
            title: ("please select kin marital status"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (employement_type === "") 
    {
        Swal.fire({
            title: ("please select employment type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (company_name === "") 
    {
        Swal.fire({
            title: ("please provide employer name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (company_phone === "") 
    {
        Swal.fire({
            title: ("please provide employer mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (registration_number === "") 
    {
        Swal.fire({
            title: ("please provide employer registration number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (company_registration_date === "") 
    {
        Swal.fire({
            title: ("please provide employer registration date"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (taxno === "") 
    {
        Swal.fire({
            title: ("please provide employer tax number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (contact_email === "") 
    {
        Swal.fire({
            title: ("please provide employer contact email"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (payment_type === "") 
    {
        Swal.fire({
            title: ("please provide account type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };


    if(payment_type === "Mobile") {

        if (mobile_number === "") 
        {
            Swal.fire({
                title: ("please provide mobile number"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };
    }
    else {

        if (bank_id === "") 
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

    if (bank_account_number === "") 
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

    if (accountName === "") 
    {
        Swal.fire({
            title: ("please provide account name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };
    }


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
                $('#individual_onboarding').attr('action', '/Admin/Client/Maintain/Individual/Client');
                $('#individual_onboarding').attr('method', 'POST');
                $("#individual_onboarding").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })}
        else {
            var title = document.getElementById('title').value;
    var firstName = document.getElementById('firstName').value;

    var lastName = document.getElementById('lastName').value;
    var mobileNumber = document.getElementById('mobileNumber').value;
    var dateOfBirth = document.getElementById('dateOfBirth').value;

    var emailAddress = document.getElementById('emailAddress').value;
    var meansOfIdentificationNumber = document.getElementById('meansOfIdentificationNumber').value;
    var gender = document.getElementById('gender').value;
    var house_number = document.getElementById('house_number').value;
    var street_name = document.getElementById('street_name').value;

    var area = document.getElementById('area').value;
    var town = document.getElementById('town').value;
    var accomodation_status = document.getElementById('accomodation_status').value;
    var year_at_current_address = document.getElementById('year_at_current_address').value;
    var loan_document_upload = document.getElementById('loan_document_upload').value;

    var kin_first_name = document.getElementById('kin_first_name').value;
    var kin_last_name = document.getElementById('kin_last_name').value;
    var kin_ID_number = document.getElementById('kin_ID_number').value;
    var kin_mobile_number = document.getElementById('kin_mobile_number').value;
    var kin_relationship = document.getElementById('kin_relationship').value;
    var kin_gender = document.getElementById('kin_gender').value;
    var kn_marital_status = document.getElementById('kn_marital_status').value;

    var business_name = document.getElementById('business_name').value;
    var business_phone = document.getElementById('business_phone').value;
    var business_registration_number = document.getElementById('business_registration_number').value;
    var business_registration_date = document.getElementById('business_registration_date').value;
    var business_contact_email = document.getElementById('business_contact_email').value;

    var mobile_number = document.getElementById('account_mobile_number').value;
    var bank_id = document.getElementById('bank_id').value;
    var bank_account_number = document.getElementById('bank_account_number').value;
    var accountName = document.getElementById('accountName').value;
    var payment_type = document.getElementById('payment_type').value;
    var employement_type = document.getElementById('employement_type').value;


    var loan_document_upload_length = loan_document_upload.length;

    var document_upload = loan_document_upload_length

    if (title === "") 
    {
        Swal.fire({
            title: ("please select title"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (firstName === "") 
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

    if (lastName === "") 
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

    if (mobileNumber === "") 
    {
        Swal.fire({
            title: ("please provide mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (dateOfBirth === "") 
    {
        Swal.fire({
            title: ("please provide date of birth"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (emailAddress === "") 
    {
        Swal.fire({
            title: ("please provide email address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (meansOfIdentificationNumber === "") 
    {
        Swal.fire({
            title: ("please provide NRC number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (gender === "") 
    {
        Swal.fire({
            title: ("please provide gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (house_number === "") 
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

    if (street_name === "") 
    {
        Swal.fire({
            title: ("please provide street name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (area === "") 
    {
        Swal.fire({
            title: ("please provide area name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (town === "") 
    {
        Swal.fire({
            title: ("please provide town name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (accomodation_status === "") 
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

    if (year_at_current_address === "") 
    {
        Swal.fire({
            title: ("please provide years at current address"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_first_name === "") 
    {
        Swal.fire({
            title: ("please provide kin first name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_last_name === "") 
    {
        Swal.fire({
            title: ("please provide kin last name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_ID_number === "") 
    {
        Swal.fire({
            title: ("please provide kin NRC number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_mobile_number === "") 
    {
        Swal.fire({
            title: ("please provide kin mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_relationship === "") 
    {
        Swal.fire({
            title: ("please select kin relationship"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kin_gender === "") 
    {
        Swal.fire({
            title: ("please select kin gender"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (kn_marital_status === "") 
    {
        Swal.fire({
            title: ("please select kin marital status"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (employement_type === "") 
    {
        Swal.fire({
            title: ("please select employment type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (business_name === "") 
    {
        Swal.fire({
            title: ("please provide business name"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (business_phone === "") 
    {
        Swal.fire({
            title: ("please provide business mobile number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (business_registration_number === "") 
    {
        Swal.fire({
            title: ("please provide business registration number"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (business_registration_date === "") 
    {
        Swal.fire({
            title: ("please provide business registration date"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (business_contact_email === "") 
    {
        Swal.fire({
            title: ("please provide business contact email"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };

    if (payment_type === "") 
    {
        Swal.fire({
            title: ("please provide account type"),
            type: "warning",
            showCancelButton: false,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Ok!',
            showLoaderOnConfirm: true
        })
        return false;
    };


    if(payment_type === "Mobile") {

        if (mobile_number === "") 
        {
            Swal.fire({
                title: ("please provide mobile number"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };
    }

    else {

        if (bank_id === "") 
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

        if (bank_account_number === "") 
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

        if (accountName === "") 
        {
            Swal.fire({
                title: ("please provide account name"),
                type: "warning",
                showCancelButton: false,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Ok!',
                showLoaderOnConfirm: true
            })
            return false;
        };
    }


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
                $('#individual_onboarding').attr('action', '/Admin/Client/Maintain/Individual/Client');
                $('#individual_onboarding').attr('method', 'POST');
                $("#individual_onboarding").submit();

        } else {
            // spinner.hide();
            Swal.fire(
                'Cancelled',
                'Operation not performed :)',
                'error'
            )
        }
      })
        }
    });

if ($('#edit_company_funder_title').length) {
    var type = $('#edit_company_funder_title').attr('edit_company_funder_title');
    $('#edit_company_funder_title').val(type);
    $('#edit_company_funder_title').trigger('change');
}


var dt_all_innactive_clients = $('#dt-all-innactive-clients').DataTable({
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
        "url": '/all/innactive/clients',  
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "nrc": $('#nrc').val(),
            "mobile": $('#mobile').val(),
            "role_type": $('#role_type').val(),
            "email": $('#email').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "username" },
        { "data": "meansOfIdentificationNumber" },
        { "data": "mobileNumber" },
        { "data": "emailAddress" },
        { "data": "roleType" },
        { "data": "user_status" }

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
        },
    ]
});


$("#all_innactive_clients_filter_search").on("click", function() {
    dt_all_innactive_clients.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.nrc = $("#nrc").val();
        data.mobile = $("#mobile").val();
        data.role_type = $("#role_type").val();
        data.email = $("#email").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_all_innactive_clients.draw();
});

$('#all_innactive_clients_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_all_innactive_clients.draw();
});



var dt_active_loans_by_loan_officer = $('#dt-active-loans-by-loan-officer').DataTable({
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
        "url": '/admin/active/loans/by_loan_officer',  
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "p_type": $('#p_type').val(),

        }
    },
    "columns": [
        { "data": "name" },
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
    "columnDefs": [
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">Not Set</span>'
        },
    ]
});


$("#active_loans_by_loan_office_filter_search").on("click", function() {
    dt_active_loans_by_loan_officer.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.p_type = $("#p_type").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_active_loans_by_loan_officer.draw();
});

$('#active_loans_by_loan_office_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_active_loans_by_loan_officer.draw();
});


var dt_due_collected_by_loan_officer = $('#dt-due-collected-by-loan-officer').DataTable({
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
        "url": '/admin/due/collected/by_loan_officer',  
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "f_name": $('#f_name').val(),
            "l_name": $('#l_name').val(),
            "p_type": $('#p_type').val(),
            "p_amount": $('#p_amount').val(),
            "from_d_date": $('#from_d_date').val(),
            "to_d_date": $('#to_d_date').val(),

        }
    },
    "columns": [
        { "data": "name" },
        { "data": "loan_type" },
        { "data": "disbursedon_date" },
        { "data": "principal_amount" },
        { "data": "balance" },
        { "data": "total_repaid" },
        { "data": "total_balance" },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='btn ripple btn-danger btn-sm'>REJECTED</span></td>";
                }
                if (data == "PENDING_ACCOUNTANT_DISBURSEMENT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING_FUNDER_APPROVAL") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING FUNDER APPROVAL</span></td>";
                }
                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING CREDIT ANALYST </span></td>";
                }
                if (data === "PENDING_ACCOUNTANT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING ACCOUNTS</span></td>";
                }
                if (data === "REPAID") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID</span></td>";
                }
                if (data === "PENDING_OPERATIONS_MANAGER") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING CREDIT MANAGER</span></td>";
                }
                if (data === "PENDING_CREDIT_ANALYST_REPAYMENT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING C.R REPAYMENT STEP</span></td>";
                }
                if (data === "PENDING_OFFTAKER_CONFIRMATION") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING OFFTAKER CONFIRMATION</span></td>";
                }
                if (data === "PENDING_CLIENT_CONFIRMATION") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING OFFTAKER CONFIRMATION</span></td>";
                }
                if (data === "PENDING_MANAGEMENT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING MANAGEMENT</span></td>";
                }
                if (data === "REPAID") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID</span></td>";
                }
                if (data === "PENDING_CRO") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING CRO</span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PENDING DISBURSEMENT</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>DISBURSED</span></td>";  
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
    "columnDefs": [
        {
            "targets": 2,
            "defaultContent": '<span style="color: red">Loan Not Disbursed</span>'
        },

        {
            "targets": 5,
            "defaultContent": '<span style="color: red">Loan Not Collected</span>'
        },
    ]
});

$("#due_collected_by_loan_office_filter_search").on("click", function() {
    dt_due_collected_by_loan_officer.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.f_name = $("#f_name").val();
        data.l_name = $("#l_name").val();
        data.p_type = $("#p_type").val();
        data.p_amount = $("#p_amount").val();
        data.from_d_date = $("#from_d_date").val();
        data.to_d_date = $("#to_d_date").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_due_collected_by_loan_officer.draw();
});

$('#due_collected_by_loan_office_filter_clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_due_collected_by_loan_officer.draw();
});


