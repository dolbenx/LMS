var dt_loan_mgt = $('#dt-quick-advance-loan-application').DataTable({
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
        "url": '/Credit/Management/quick_advance_application',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "loan_number_filter": $('#loan_number_filter').val(),
            "nrc_filter": $('#nrc_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),

        }
    },
    "columns": [
        { "data": "id" },
        { "data": "customerName" },
        { "data": "name" },
        { "data": "application_date" },
        {
            "data": "requested_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
      

        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>REJECTED</span></td>";
                }
                if (data === "WRITTEN_OFF") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>WRITTEN OFF</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                
                if (data === "PENDING_SALES") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING SALES</span></td>";
                } 

                if (data === "PENDING_OPERATIONS") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING OPERATIONS</span></td>";
                }

                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT ANALYST </span></td>";
                }

                if (data === "PENDING_CREDIT_MANAGER") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT MANAGER </span></td>";
                }
                if (data === "PENDING_LEGAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING LEGAL </span></td>";
                }
                if (data === "PENDING_ACCOUNTS_ASSISTANT") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING ACCOUNTS ASSISTANT</span></td>";
                }
                if (data === "PENDING_FINANCE_MANAGER") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING FINANCE MANAGER</span></td>";
                }

                if (data === "PENDING_CEO") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CEO</span></td>";
                }
                
                if (data === "PENDING_CRO") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CRO</span></td>";
                }
                
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                if (data === "DISBURSEMENT_PENDING_FINANCE_MANAGER") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSEMENT PENDING FINANCE MANAGER </span></td>";
                }
                if (data === "DISBURSEMENT_PENDING_CEO") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSEMENT PENDING CEO </span></td>";
                }

                if (data === "REPAID") {
                    show = "<td><span class='badge bg-success-light bg-pill'> REPAID </span></td>";
                }
                

                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {

                
                console.log("loading ------------------------")
                console.log($('#usertype').val())

                
                if ($('#usertype').val() == "Finance" && row.loan_status == "DISBURSEMENT_PENDING_FINANCE_MANAGER"){
                    if (row.loan_status == "DISBURSEMENT_PENDING_FINANCE_MANAGER") {
                        return `
                            <a href="/cfo/loan/payment/requisition?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i> Approve Disbursement </a> 
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        `;

                    }
                }

                if ($('#usertype').val() == "Finance" && row.loan_status == "PENDING_FINANCE_MANAGER"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/finance/manager/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                 } 


                if ($('#usertype').val() == "Sales" && row.loan_status == "PENDING_SALES"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/sales/application/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#" data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal"  class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 
           
                
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/operations/application/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#" data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal"  class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 
           
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/view/loan/application/pending/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#" data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal"  class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 

                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_MANAGER"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/credit/manager/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                           
                
                        `;

                    // }
                } 
               
                if ($('#usertype').val() == "Group Legal Counsel" && row.loan_status == "PENDING_LEGAL"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/legal/application/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 

                if ($('#usertype').val() == "Finance" && row.loan_status == "PENDING_ACCOUNTS_ASSISTANT"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/accounts/assistant/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 

                // if ($('#usertype').val() == "Finance" && row.loan_status == "PENDING_FINANCE_MANAGER"){
                //     // if ($('#change_status').val() == "Y" ){
                //         return ` 
                //             <a  href="/pending/finance/manager/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                //             <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                //             <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                //         `;

                //     // }
                // } 

                if ($('#usertype').val() == "Exco" && row.loan_status == "PENDING_CEO"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/executive/committe/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                }

               if ($('#edit').val() == "Y" && $('#view').val() == "Y" ) {
                    if (row.loan_status == "REJECTED") {
                        return ` 
                            <a href="/edit/rejected/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "fe fe-edit"></i>Edit Rejected</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                            
                        `;

                    }
                }
                if ($('#usertype').val() == "Finance" && row.loan_status == "APPROVED"){
                    if (row.loan_status == "APPROVED") {
                        return `
                            <a href="/initiate/disbursement?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i> Initiate Disbursement </a> 
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        `;

                    }
                }


                if ($('#usertype').val() == "Exco" && row.loan_status == "DISBURSEMENT_PENDING_CEO"){
                    if (row.loan_status == "DISBURSEMENT_PENDING_CEO") {
                        return `
                            <a href="/ceo/loan/payment/requisition?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i> Approve Disbursement </a> 
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        `;

                    }
                }


                if (row.loan_status == "DISBURSED") {
                    return ` 
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        <a  href="#"  data-id="${row.id}" data-payoff_amount="${row.payoff_amount}"  data-total_repaid="${row.total_repaid || 0}" data-bs-target="#loan-repaid-modal" data-bs-toggle="modal" class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Repaid</a>
                       <!-- <a  href="#"  data-id="${row.id}" data-bs-target="#loan-writeoff-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Write off loan</a> -->
                        
                    `;

                }

                if (row.loan_status == "REPAID") {
                    return ` 
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                          
                    `;

                }
                
               
                if ($('#edit').val() == "Y" && $('#view').val() == "Y" ) {
                    return ` 
                       
                        <a href="/edit/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "fe fe-edit"></i>Edit</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                    `;

                }

                if ($('#view').val() == "Y" ) {
                    return ` 
                        
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
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

$("#loan-listing-filter-mgt").on("click", function() {
    $("#loan-listing-filter-modal-mgt").modal("show");
});

$("#loan_application_listing_filter-mgt").on("click", function() {
    dt_loan_mgt.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.loan_number_filter = $("#loan_number_filter").val();
        data.nrc_filter = $("#nrc_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
    });
    $("#loan-listing-filter-modal-mgt").modal("hide");
    dt_loan_mgt.draw();
});


var dt_loan_application = $('#dt-loan-application').DataTable({
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
        "url": '/Credit/Management/loan_appraisal',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "loan_number_filter": $('#loan_number_filter').val(),
            "nrc_filter": $('#nrc_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            

        }
    },
    "columns": [
        { "data": "id" },
        {
            "data": "customerName",
            "render": function(data, _, row) {
                if (row.role_type === "EMPLOYEE") {
                return row.customer_name;
                } else {
                return data;
                }
            }
        },
        { "data": "name" },
        { "data": "application_date" },
        {
            "data": "requested_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
      

        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>REJECTED</span></td>";
                }
                if (data === "WRITTEN_OFF") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>WRITTEN OFF</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }

                if (data === "PENDING_OPERATIONS") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING OPERATIONS</span></td>";
                }

                if (data === "PENDING_SALES") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING SALES</span></td>";
                }

                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT ANALYST </span></td>";
                }

                if (data === "PENDING_CREDIT_MANAGER") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT MANAGER </span></td>";
                }
                if (data === "PENDING_LEGAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING LEGAL </span></td>";
                }

                if (data === "PENDING_ACCOUNTS_ASSISTANT") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING ACCOUNTS ASSISTANT</span></td>";
                }
                if (data === "PENDING_FINANCE_MANAGER") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING FINANCE MANAGER</span></td>";
                }

                if (data === "PENDING_CEO") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CEO</span></td>";
                }
                
                if (data === "PENDING_CRO") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CRO</span></td>";
                }
                
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                if (data === "DISBURSEMENT_PENDING_FINANCE_MANAGER") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSEMENT PENDING FINANCE MANAGER </span></td>";
                }
                if (data === "DISBURSEMENT_PENDING_CEO") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSEMENT PENDING CEO </span></td>";
                }
                if (data === "REPAID") {
                    show = "<td><span class='badge bg-success-light bg-pill'> REPAID </span></td>";
                }
                
                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {
                
                console.log("loading ------------------------")
                console.log($('#usertype').val())
                console.log(row.loan_status)

                if ($('#usertype').val() == "Group Legal Counsel" && row.loan_status == "PENDING_LEGAL"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/legal/application/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 
                
                if ($('#usertype').val() == "Finance" && row.loan_status == "DISBURSEMENT_PENDING_FINANCE_MANAGER"){
                    if (row.loan_status == "DISBURSEMENT_PENDING_FINANCE_MANAGER") {
                        return `
                            <a href="/cfo/loan/payment/requisition?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i> Approve Disbursement </a> 
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        `;

                    }
                }

                if ($('#usertype').val() == "Finance" && row.loan_status == "PENDING_FINANCE_MANAGER"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/finance/manager/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                 } 


                if ($('#usertype').val() == "Sales" && row.loan_status == "PENDING_SALES"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/sales/application/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#" data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal"  class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 
           
                
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/operations/application/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#" data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal"  class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 

                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_LEGAL"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/operations/application/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#" data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal"  class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        `;

                    // }
                } 
           
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a href="/edit/loan/application/credit/analyst?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "fe fe-edit"></i>Edit</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                            <a  href="/view/loan/application/pending/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#" data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal"  class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                   
                        `;

                    // }
                } 

                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_MANAGER"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a href="/edit/loan/application/credit/analyst?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "fe fe-edit"></i>Edit</a>
                            <a  href="/pending/credit/manager/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                           
                        `;

                    // }
                } 
               


                if ($('#usertype').val() == "Finance" && row.loan_status == "PENDING_ACCOUNTS_ASSISTANT"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/accounts/assistant/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                } 

                // if ($('#usertype').val() == "Finance" && row.loan_status == "PENDING_FINANCE_MANAGER"){
                //     // if ($('#change_status').val() == "Y" ){
                //         return ` 
                //             <a  href="/pending/finance/manager/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                //             <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                //             <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                //         `;

                //     // }
                // } 

                if ($('#usertype').val() == "Exco" && row.loan_status == "PENDING_CEO"){
                    // if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/executive/committe/approval?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-bs-target="#loan-reject-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                
                        `;

                    // }
                }

               if ($('#edit').val() == "Y" && $('#view').val() == "Y" ) {
                    if (row.loan_status == "REJECTED") {
                        return ` 
                            <a href="/edit/rejected/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "fe fe-edit"></i>Edit Rejected</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                            
                        `;

                    }
                }
                if ($('#usertype').val() == "Finance" && row.loan_status == "APPROVED"){
                    if (row.loan_status == "APPROVED") {
                        return `
                            <a href="/initiate/disbursement?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i> Initiate Disbursement </a> 
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        `;

                    }
                }


                if ($('#usertype').val() == "Exco" && row.loan_status == "DISBURSEMENT_PENDING_CEO"){
                    if (row.loan_status == "DISBURSEMENT_PENDING_CEO") {
                        return `
                            <a href="/ceo/loan/payment/requisition?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i> Approve Disbursement </a> 
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        `;

                    }
                }


                if (row.loan_status == "DISBURSED") {
                    return ` 
                       <a href="/edit/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "fe fe-edit"></i>Edit</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                        <a  href="#"  data-id="${row.id}" data-payoff_amount="${row.payoff_amount}"  data-total_repaid="${row.total_repaid || 0}" data-bs-target="#loan-repaid-modal" data-bs-toggle="modal" class=" btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Repaid</a>
                        <!--<a  href="#"  data-id="${row.id}" data-bs-target="#loan-writeoff-modal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Write off loan</a>-->
                    `;

                }

                if (row.loan_status == "REPAID") {
                    return ` 
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                          
                    `;

                }
                
               
                if ($('#edit').val() == "Y" && $('#view').val() == "Y" ) {
                    return ` 
                       
                        <a href="/edit/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "fe fe-edit"></i>Edit</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                    `;

                }

                if ($('#view').val() == "Y" ) {
                    return ` 
                        
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
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

$("#loan-listing-filter").on("click", function() {
    $("#loan-listing-filter-modal").modal("show");
});

$("#loan_application_listing_filter").on("click", function() {
    dt_loan_application.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
        data.loan_number_filter = $("#loan_number_filter").val();
        data.nrc_filter = $("#nrc_filter").val();
        data.loan_type_filter = $("#loan_type_filter").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
    });
    $("#loan-listing-filter-modal").modal("hide");
    dt_loan_application.draw();
});


var dt_quick_loan = $('#dt-quick-loan-application').DataTable({
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
        "url": '/Credit/Management/quick_loan_application',
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
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>REJECTED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {
                if (row.loan_status == "PENDING_APPROVAL") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a  href="#" data-approve-id="${row.id}" class="approve-quick-loan dropdown-item btn ripple text-success"><i class= "fe fe-check-circle"></i>Approved</a>
                    <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" dropdown-item btn ripple text-primary"><i class= "fe fe-edit"></i>Edit</a>
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    <a href="#" data-id="${row.id}" data-bs-target="#rejectmodal" data-bs-toggle="modal" class=" dropdown-item btn ripple text-danger"><i class= "fe fe-trash"></i>Reject</a>
                    </div>
                `;
                };

                if (row.loan_status == "REJECTED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                }

                if (row.loan_status == "APPROVED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
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


var dt_float_advance_loan = $('#dt-float-advance-application').DataTable({
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
        "url": '/Credit/Management/float_advance_application',
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
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>REJECTED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {
                if (row.loan_status == "PENDING_APPROVAL") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                        <div class="dropdown-menu">
                        <a href="#" data-approve-id="${row.id}"  class="approve-float-advance-loan dropdown-item btn ripple text-success"><i class= "fe fe-check-circle"></i>Approved</a>
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" dropdown-item btn ripple text-primary"><i class= "fe fe-edit"></i>Edit</a>
                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                        <a href="#" data-id="${row.id}" data-bs-target="#rejectmodal" data-bs-toggle="modal" class=" dropdown-item btn ripple text-danger"><i class= "fe fe-trash"></i>Reject</a>
                        </div>
                    `;
                };

                if (row.loan_status == "REJECTED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                }

                if (row.loan_status == "APPROVED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
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

var dt_order_finance_loan = $('#dt-trade-advance-application').DataTable({
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
        "url": '/Credit/Management/trade/advance',
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
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>REJECTED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {
                if (row.loan_status == "PENDING_APPROVAL") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                        <div class="dropdown-menu">
                        <a href="#" data-approve-id="${row.id}" class="approve-trade-advance-loan dropdown-item btn ripple text-success"><i class= "fe fe-check-circle"></i>Approved</a>
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" dropdown-item btn ripple text-primary"><i class= "fe fe-edit"></i>Edit</a>
                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                        <a href="#" data-id="${row.id}" data-bs-target="#rejectmodal" data-bs-toggle="modal" class=" dropdown-item btn ripple text-danger"><i class= "fe fe-trash"></i>Reject</a>
                        </div>
                    `;
                };

                if (row.loan_status == "REJECTED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "APPROVED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

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


var dt_invoice_discounting_loan = $('#dt-invoice-discounting-application').DataTable({
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
        "url": '/Credit/Management/invoice_discouting',
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
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>REJECTED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }
                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {
                if (row.loan_status == "PENDING_APPROVAL") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="#" data-approve-id="${row.id}"  class="approve-invoice-discounting-loan dropdown-item btn ripple text-success"><i class= "fe fe-check-circle"></i>Approved</a>
                    <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" dropdown-item btn ripple text-primary"><i class= "fe fe-edit"></i>Edit</a>
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    <a href="#" data-id="${row.id}" data-bs-target="#rejectmodal" data-bs-toggle="modal" class=" dropdown-item btn ripple text-danger"><i class= "fe fe-trash"></i>Reject</a>
                    </div>
                `;
                };

                if (row.loan_status == "REJECTED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "APPROVED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

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

$('#reject-loan').click(function(e) {
    e.preventDefault()
    Swal.fire({
        title: 'Are you sure you want to Reject Loan ?',
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
                url: '/Credit/Management/reject/loan',
                type: 'POST',
                data: { id: $('#id').val(), reason: $('#reason').val(), _csrf_token: $('#csrf').val() },
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

$('#dt-quick-advance-loan-application tbody').on('click', '.approve-quick-advance-loan', function(e) {
    e.preventDefault()
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Approve Loan with S/N: ' + button.attr("data-approve-id") + ' ?',
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
                url: '/Credit/Management/approve/loan',
                type: 'POST',
                data: { id: button.attr("data-approve-id"), _csrf_token: $('#csrf').val() },
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

$('#dt-quick-loan-application tbody').on('click', '.approve-quick-loan', function(e) {
    e.preventDefault()
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Approve Loan with S/N: ' + button.attr("data-approve-id") + ' ?',
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
                url: '/Credit/Management/approve/loan',
                type: 'POST',
                data: { id: button.attr("data-approve-id"), _csrf_token: $('#csrf').val() },
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

$('#dt-float-advance-application tbody').on('click', '.approve-float-advance-loan', function(e) {
    e.preventDefault()
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Approve Loan with S/N: ' + button.attr("data-approve-id") + ' ?',
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
                url: '/Credit/Management/approve/loan',
                type: 'POST',
                data: { id: button.attr("data-approve-id"), _csrf_token: $('#csrf').val() },
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

$('#dt-trade-advance-application tbody').on('click', '.approve-trade-advance-loan', function(e) {
    e.preventDefault()
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Approve Loan with S/N: ' + button.attr("data-approve-id") + ' ?',
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
                url: '/Credit/Management/approve/loan',
                type: 'POST',
                data: { id: button.attr("data-approve-id"), _csrf_token: $('#csrf').val() },
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

$('#dt-invoice-discounting-application tbody').on('click', '.approve-invoice-discounting-loan', function(e) {
    e.preventDefault()
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Approve Loan with S/N: ' + button.attr("data-approve-id") + ' ?',
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
                url: '/Credit/Management/approve/loan',
                type: 'POST',
                data: { id: button.attr("data-approve-id"), _csrf_token: $('#csrf').val() },
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


var dt_loan_client_statement = $('#dt-loan-client-statement').DataTable({
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
        "url": '/Credit/Management/client/statement',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val()

        }
    },
    "columns": [
        { "data": "transaction_date" },
        { "data": "id" },
        { "data": "narration" },
        {
            "data": "dr_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "cr_amount",
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


var dt_loan_approval_and_disbursement = $('#dt-loan-application-approval-disbursement').DataTable({
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
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },

        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger-light bg-pill'>REJECTED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT </span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED </span></td>";
                }

                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {
                if (row.loan_status == "PENDING_APPROVAL") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                        <div class="dropdown-menu">
                        <a  href="#" data-approve-id="${row.id}" class="approve-quick-advance-loan dropdown-item btn ripple text-success"><i class= "fe fe-check-circle"></i>Approved</a>
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" dropdown-item btn ripple text-primary"><i class= "fe fe-edit"></i>Edit</a>
                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                        <a href="#" data-id="${row.id}" data-bs-target="#rejectmodal" data-bs-toggle="modal" class=" dropdown-item btn ripple text-danger"><i class= "fe fe-trash"></i>Reject</a>
                        </div>
                    `;
                };

                if (row.loan_status == "REJECTED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                }

                if (row.loan_status == "APPROVED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
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


$('#dt-loan-application-approval-disbursement tbody').on('click', '.approve-quick-advance-loan', function(e) {
    e.preventDefault()
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Approve Loan with S/N: ' + button.attr("data-approve-id") + ' ?',
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
                url: '/Credit/Management/approve/loan',
                type: 'POST',
                data: { id: button.attr("data-approve-id"), _csrf_token: $('#csrf').val() },
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

var dt_repayment_maintenance_list = $('#tbl-repayment-maintenance').DataTable({
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
        "url": '/Credit/Management/repayment_maintenance',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
    "columns": [
        { "data": "dateOfRepayment" },
        { "data": "loan_product" },
        {
            "data": "amountRepaid",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        { "data": "modeOfRepayment" },
        { "data": "account_name" },
        { "data": "mno_mobile_no" },
        {
            "data": "status",
            render: function(data, _, row) {
                let show = "";
                if (data === "PAYMENT_COLLECTED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PAYMENT_COLLECTED</span></td>";
                }
                if (data === "FAILED") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>FAILED</span></td>";
                }


                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {
                if (row.status == "PAYMENT_COLLECTED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                      <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                    </div>
                    `;
                };

                if (row.status == "FAILED") {
                    return `  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                        <div class="dropdown-menu">
                          <a  href="#" data-approve-id="${row.id}" class="approve-quick-advance-loan dropdown-item btn ripple text-success"><i class= "fe fe-check-circle"></i>Make Payment</a>
                          <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "fe fe-eye"></i> View </a>
                        </div>
                    `;
                };

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

var dt_loan_portifolio_list = $('#tb-loan-portifolio-tbl').DataTable({
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
        "url": '/Credit/Monitoring/loan/portifolio',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
    "columns": [
        { "data": "approvedon_date" },
        { "data": "product_id" },
        { "data": "product_name" },
        {
            "data": "interest_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "repayment_amount",
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

$('#tbl-reference').on('click', '.js-delete-reference', function() {
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed',
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
                url: '/discard/reference/loan/application',
                type: 'POST',
                data: { id: button.attr("data-client_reference-id"), _csrf_token: $('#csrf').val() },
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

$('#tbl_client_reference').on('click', '.js-delete-client-reference', function() {
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed',
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
                url: '/discard/reference/loan/application',
                type: 'POST',
                data: { id: button.attr("data-client_reference-id"), _csrf_token: $('#csrf').val() },
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


$('#tbl_collateral').on('click', '.js-delete-collateral', function() {
    let button = $(this)
    Swal.fire({
        title: 'Are you sure you want to Proceed',
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
                url: '/discard/collateral/loan/application',
                type: 'POST',
                data: { id: button.attr("data-collateral-id"), _csrf_token: $('#csrf').val() },
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

function cal_month_installment(){
    var requested_amount = document.getElementById('requested_amount').value;
 
    var loan_duration_month = document.getElementById('loan_duration_month').value;
    var interest_rate = document.getElementById('interest_rate').value;
    var monthly_interest =  interest_rate * 12; // total number of payments is loan term in years times 12

    var monthlyInterestRate = monthly_interest / 1200;  // divide annual interest rate by 1200 to get monthly interest rate
    var monthlyInstallment = requested_amount * (monthlyInterestRate / (1 - Math.pow(1 + monthlyInterestRate, -loan_duration_month)) );
    var result = monthlyInstallment.toFixed(2);
   document.getElementById('monthly_installment').value = result;
}

    
function employee_month_installment(){
    var requested_amount = document.getElementById('requested_amount').value;

    var loan_duration_month = document.getElementById('loan_duration_month').value;
    var interest_rate = document.getElementById('interest_rate').value;
    var monthly_interest =  interest_rate * 12; // total number of payments is loan term in years times 12

    var monthlyInterestRate = monthly_interest / 1200;  // divide annual interest rate by 1200 to get monthly interest rate
    var monthlyInstallment = requested_amount * (monthlyInterestRate / (1 - Math.pow(1 + monthlyInterestRate, -loan_duration_month)) );
    var result = monthlyInstallment.toFixed(2);
    document.getElementById('monthly_installment').value = result;
}




function individual_instant_cal_month_installment(){
    var requested_amount = document.getElementById('requested_amount').value;
    var loan_duration_month = document.getElementById('loan_duration_month').value;
    var interest_rate = document.getElementById('interest_rate').value;
    var monthly_interest =  interest_rate * 12; // total number of payments is loan term in years times 12

    var monthlyInterestRate = monthly_interest / 1200;  // divide annual interest rate by 1200 to get monthly interest rate
    var monthlyInstallment = requested_amount * (monthlyInterestRate / (1 - Math.pow(1 + monthlyInterestRate, -loan_duration_month)) );
    var result = monthlyInstallment.toFixed(2);
   document.getElementById('monthly_installment').value = result;
}

function calculate_loan_disbursement(){
    var approved_amount = document.getElementById('approved_amount').value;
    var processing_fee = document.getElementById('processing_fee').value;
    var insurance = document.getElementById('insurance').value;
    var crb = document.getElementById('crb').value;
    var motor_insurance = document.getElementById('motor_insurance').value;
    var interet_per_month = document.getElementById('interet_per_month').value;
    var repayment_period = document.getElementById('repayment_period').value;
    var monthly_interest =  interet_per_month * 12; // total number of payments is loan term in years times 12
    
    var monthlyInterestRate = monthly_interest / 1200;  // divide annual interest rate by 1200 to get monthly interest rate
    var monthlyInstallment = approved_amount * (monthlyInterestRate / (1 - Math.pow(1 + monthlyInterestRate, -repayment_period)) );
    var result = monthlyInstallment.toFixed(2);
    document.getElementById('month_installment').value = result;

    var net_disbursement =  approved_amount - processing_fee - insurance - crb - motor_insurance
    var result_disbursement = net_disbursement.toFixed(2);
    document.getElementById('net_disbiursed').value = result_disbursement;

}

function calculate_credit_score(){

    $('#business_employment_experience, #family_situation, #borrowing_history, #dti_ratio, #collateral_assessment, #type_of_collateral, #applicant_character, #number_of_reference').change(function() {

    var business_employment_experience = parseFloat($('#business_employment_experience').val());
    var family_situation = parseFloat($('#family_situation').val());
    var borrowing_history = parseFloat($('#borrowing_history').val());
    var dti_ratio = parseFloat($('#dti_ratio').val());
    var collateral_assessment = parseFloat($('#collateral_assessment').val());
    var type_of_collateral = parseFloat($('#type_of_collateral').val());
    var applicant_character = parseFloat($('#applicant_character').val());
    var number_of_reference = parseFloat($('#number_of_reference').val());

    var business_percentage = 0.05
    var family_situation_percentage = 0.05
    var borrowing_history_percentage = 0.15
   
    var total_score =  business_employment_experience + family_situation + borrowing_history + dti_ratio + collateral_assessment + type_of_collateral + applicant_character + number_of_reference
    var weighted_credit_score = (business_employment_experience * business_percentage) + (family_situation * family_situation_percentage) + (borrowing_history * borrowing_history_percentage) 
    var weighted_credit_score_perce = weighted_credit_score *  100
    var weighted_credit_score_result = weighted_credit_score_perce.toFixed(2);
    document.getElementById('total_score').value = total_score;
    document.getElementById('weighted_credit_score').value = weighted_credit_score_result;
  
});


}



function calculate_income_statement_assessment(){
    var jan_bank_stat =  parseFloat($('#jan_bank_stat').val());
    var jan_mobile_stat = parseFloat($('#jan_mobile_stat').val());
    var dec_bank_stat = parseFloat($('#dec_bank_stat').val());
    var dec_mobile_stat = parseFloat($('#dec_mobile_stat').val());
    var nov_bank_stat = parseFloat($('#nov_bank_stat').val());
    var nov_mobile_stat = parseFloat($('#nov_mobile_stat').val());

    var dstv = parseFloat($('#dstv').val());
    var food = parseFloat($('#food').val());
    var school = parseFloat($('#school').val());
    var utilities = parseFloat($('#utilities').val());
    var loan_installment = parseFloat($('#loan_installment').val());
    var salaries = parseFloat($('#salaries').val());
    var stationery = parseFloat($('#stationery').val());
    var transport = parseFloat($('#transport').val());
    
     jan_total = jan_bank_stat +  jan_mobile_stat;
     dec_total =  dec_bank_stat + dec_mobile_stat;
     nov_total =  nov_bank_stat + nov_mobile_stat;
     average_income  =  (jan_total + dec_total + nov_total)/ 3;
     total_expenses =  dstv + food + school + utilities + salaries + stationery + transport;
     available_income =  average_income -  total_expenses;
     loan_installment_total = loan_installment;
     dsr = available_income / loan_installment_total
     jan_total_result =  jan_total.toFixed(2);
     dec_total_result =  dec_total.toFixed(2);
     nov_total_result =  nov_total.toFixed(2);
     average_income_result =  average_income.toFixed(2);
     total_expenses_result =  total_expenses.toFixed(2);
     available_income_result =  available_income.toFixed(2);
     loan_installment_total_result =  loan_installment_total.toFixed(2);
     debt_service_ratio_result =  dsr.toFixed(2);
    
     document.getElementById('jan_total').value = jan_total_result;
     document.getElementById('dec_total').value = dec_total_result;
     document.getElementById('nov_total').value = nov_total_result;
     document.getElementById('average_income').value = average_income_result;
     document.getElementById('total_expenses').value = total_expenses_result;
     document.getElementById('available_income').value = available_income_result;
     document.getElementById('loan_installment_total').value = loan_installment_total_result;
     document.getElementById('dsr').value = debt_service_ratio_result;
}


function calculate_gaurantor_income_statement_assessment(){
    var salary =  parseFloat($('#salary').val());
    var salary_loan = parseFloat($('#salary_loan').val());
    var other_income = parseFloat($('#other_income').val());
    var other_income_bills = parseFloat($('#other_income_bills').val());
    var business_sales = parseFloat($('#business_sales').val());
    var sale_business_rentals = parseFloat($('#sale_business_rentals').val());
    var cost_of_sales = parseFloat($('#cost_of_sales').val());
    var other_expenses = parseFloat($('#other_expenses').val());
    total_income = salary + other_income + business_sales
    total_income_expense = salary_loan + other_income_bills + sale_business_rentals +  cost_of_sales + other_expenses
    net_profit_loss =  total_income - total_income_expense
    total_income_result =  total_income.toFixed(2);
    total_income_expense_result =  total_income_expense.toFixed(2);
    net_profit_loss_result =  net_profit_loss.toFixed(2);

    document.getElementById('total_income').value = total_income_result;
    document.getElementById('total_income_expense').value = total_income_expense_result;
    document.getElementById('net_profit_loss').value = net_profit_loss_result;

}








//Download Loan Statement
$('#js-download-loan-statement').click(function() {
    $('#loanstatementSearchForm').attr('action', '/download/loan/statement/pdf/gnc');
    $('#loanstatementSearchForm').attr('method', 'GET');
    $("#loanstatementSearchForm").submit();
});

var dt_loan_client_statement = $('#client_loan_statement_dt').DataTable({
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
        "url": '/generate/client/loan/statement',
        "data": {
            _csrf_token: $("#csrf").val(),
            "fname": $('#fname').val(),
            "lname": $('#lname').val(),
            "amount": $('#amount').val(),
            "loanid": $('#loanid').val(),
            "idno": $('#idno').val(),
            "mobileno": $('#mobileno').val(),
          
        
        }
    },
    "columns": [
        { "data": "name" },
        { "data": "trn_dt" },
        { "data": "transaction" },
        {
            "data": "payment",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
            
        },
        {
            "data": "interest",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "principle",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "runningBalance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        
       
       
        
    ],
    "lengthChange": true,
    "lengthMenu": [
        [20, 40, 60, 80, 100, 500, 1000, 10000, 20000],
        [20, 40, 60, 80, 100, 500, 1000, 10000, 20000]
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

$("#statement-filtermodal-filter").on("click", function() {
    $("#statement-filtermodal").modal("show");
});

$("#filter-loan-statement").on("click", function() {
    dt_loan_client_statement.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.fname = $("#fname").val();
        data.lname = $("#lname").val();
        data.amount = $("#amount").val();
        data.loanid = $("#loanid").val();
        data.idno = $("#idno").val();
        data.mobileno = $("#mobileno").val();

    });
    $("#statement-filtermodal").modal("hide");
    dt_loan_client_statement.draw();
});



// function select2_search(){
// 	$('#loanid').each(function() {
// 		$(this).select2({
// 			dropdownParent: $(this).parent()
// 		});
// 	})
   
// }


// Function to open the modal
function openModal() {
    var modal = document.getElementById("statement-filtermodal");
    modal.style.display = "block";
    $('#loanid').select2({
      dropdownParent: $('#statement-filtermodal'),
      minimumResultsForSearch: 1
    });
  }
  
  // Function to close the modal
  function closeModal() {
    var modal = document.getElementById("statement-filtermodal");
    modal.style.display = "none";
  }
  
  // Function to handle the selected option
  function select2_search() {
    var selectedOption = document.getElementById('loanid').value;
    // Perform actions based on the selected option
    console.log('Selected option:', selectedOption);
  }





