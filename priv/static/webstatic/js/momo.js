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

$('#disburse_finance_officer_button').click(function() {

    var disbursed_amount = document.getElementById('disbursement_amount').value;

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
                    $('#disburse_finance_officer').attr('action', '/Approve/Disbursed/Finance/Loan/Officer');
                    $('#disburse_finance_officer').attr('method', 'POST');
                    $("#disburse_finance_officer").submit();
    
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
        '<form id="change_password_post" method="post">' +
            '<div class="form-group row fv-plugins-icon-container has-success">' +
                '<label class="col-3 col-form-label"><strong>Current Password:</strong> </label>' +
                '<div class="col-9">' +
                    '<div class="input-group input-group-sm">' +
                        '<input type="text" id="uname1" class="swal2-input" name="current_password" required>' +
                    '</div>' +
                '</div>' +
                '<div class="fv-plugins-message-container"></div>' +
            '</div>' +
            '<div class="form-group row fv-plugins-icon-container has-success">' +
                '<label class="col-3 col-form-label"><strong>New Password:</strong> </label>' +
                '<div class="col-9">' +
                    '<div class="input-group input-group-sm">' +
                        '<input type="text" id="pwd1" class="swal2-input" name="new_password" required>' +
                    '</div>' +
                '</div>' +
                '<div class="fv-plugins-message-container"></div>' +
            '</div>'+   
        '</form>',
        customClass: {
            popup: 'my-custom-size',
            confirmButtonText: 'custom-confirm-button',
            content: 'custom-scrollbar',
        },
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Save Changes',
        showLoaderOnConfirm: true,
        preConfirm: () => {
          var current_password = document.getElementById('uname1').value;
          var new_password = document.getElementById('pwd1').value;

          if (current_password || new_password === "" ) {
            Swal.fire('Please fill out all the required fields');
          }
          return false;
        }
    }).then((result) => {
        if (result.value) {
            $('#change_password_post').attr('action', '/user/change/password');
            $('#change_password_post').attr('method', 'POST');
            $("#change_password_post").submit();
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

if ($('#edit_alert').length) {
    var type = $('#edit_alert').attr('edit_alert');
    $('#edit_alert').val(type);
    $('#edit_alert').trigger('change');
}

$(document).ready(function() {
    $('.rep_admin-gender-change').on('change', function() {
        if ($('#rep_select_title').val() == "Mrs" || $('#rep_select_title').val() == "Ms") {
            $('#rep_provide_gender').prop('readonly', true) 
            $('#rep_provide_gender').val("Female")
        }
        else {
            $('#rep_provide_gender').prop('readonly', true)
            $('#rep_provide_gender').val("Male")
        }
       
    });
})


$(document).ready(function() {
    $('.admin-gender-change').on('change', function() {
        if ($('#select_title').val() == "Mrs" || $('#select_title').val() == "Ms") {
            $('#provide_gender').prop('readonly', true) 
            $('#provide_gender').val("Female")
        }
        else {
            $('#provide_gender').prop('readonly', true)
            $('#provide_gender').val("Male")
        }
       
    });
})

$(document).ready(function() {
    $('.director-gender-change').on('change', function() {
        if ($('#dr_select_title').val() == "Mrs" || $('#select_title').val() == "Ms") {
            $('#dr_provide_gender').prop('readonly', true) 
            $('#dr_provide_gender').val("Female")
        }
        else {
            $('#dr_provide_gender').prop('readonly', true)
            $('#dr_provide_gender').val("Male")
        }
       
    });
})

$(document).ready(function() {
    $('.select-currency-lookup').on('change', function() {
        if ($('#id').val() == "") {
            return false;
        }
        $.ajax({
            url: '/Currency/update',
            type: 'post',
            data: {
                "id": $('#id').val(),
                "_csrf_token": $("#csrf").val()
            },
            success: function(result) {
                if (result.data.length < 1) {

                    return false
                } else {
                    capa = result.data[0];
                    console.log("capa");
                    console.log(capa);

                    var id = capa.id;
                    var isoCode = capa.isoCode;
                    var name = capa.name;



                    $('#id').val(id);
                    $('#isoCode').val(isoCode).prop('readonly', true);
                    $('#name').val(name).prop('readonly', true);

                }

            },
            error: function(request, msg, error) {
                $('.loading').hide();
            }
        });
    });
});

if ($('#edit_client_employee_town').length) {
    var type = $('#edit_client_employee_town').attr('edit_client_employee_town');
    $('#edit_client_employee_town').val(type);
    $('#edit_client_employee_town').trigger('change');
}

if ($('#edit_client_employee_province').length) {
    var type = $('#edit_client_employee_province').attr('edit_client_employee_province');
    $('#edit_client_employee_province').val(type);
    $('#edit_client_employee_province').trigger('change');
}

if ($('#edit_client_employee_bankName').length) {
    var type = $('#edit_client_employee_bankName').attr('edit_client_employee_bankName');
    $('#edit_client_employee_bankName').val(type);
    $('#edit_client_employee_bankName').trigger('change');
}

if ($('#company_id').length) {
    var type = $('#company_id').attr('company_id');
    $('#company_id').val(type);
    $('#company_id').trigger('change');
}


