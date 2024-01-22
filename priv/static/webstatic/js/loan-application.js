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

const current_Date = new Date();
const russ_formattedDateTime_2 = formatDateForFilename(current_Date);


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
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),

        }
    },
    "columns": [
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
            "data": "arrangement_fee",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "finance_cost",
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
            "data": "repayment_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "monthly_installment",
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
                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT ANALYST </span></td>";
                }
                if (data === "PENDING_ACCOUNTANT") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING ACCOUNTS</span></td>";
                }
                if (data === "PENDING_OPERATIONS_MANAGER") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT MANAGER</span></td>";
                }
                if (data === "PENDING_MANAGEMENT") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING MANAGEMENT</span></td>";
                }
                if (data === "PENDING_CRO") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CRO</span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED</span></td>";
                }

                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {

                console.log(row)

                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/finance/manager/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Disburse</a>
                            <a  href="#"  data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                
                        `;

                    }
                } 
           
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/view/loan/application/pending/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Review</a>
                    
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                
                        `;

                    }
                } 



                
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/operations/application/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Review</a>
                            <a  href="#" data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal"  class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View</a>
                
                        `;

                    }
                } 
               
                if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/executive/committe/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                
                        `;

                    }
                } 

                if (row.loan_status == "REJECTED") {
                    return ` 
                        <a href="/edit/rejected/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "flaticon-edit-1 icon-sm"></i>Edit Rejected</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                        
                    `;

                }

                if (row.loan_status == "APPROVED") {
                    return ` 
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                }
                
                if ($('#change_status').val() == "Y" && $('#edit').val() == "Y" && $('#view').val() == "Y" ){
                    return ` 
                        <a href="/edit/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a  href="#"  data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                }
               
               
                if ($('#edit').val() == "Y" && $('#view').val() == "Y" ) {
                    return ` 
                       
                        <a href="/edit/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                }

                if ($('#view').val() == "Y" ) {
                    return ` 
                        
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
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
    "columnDefs": [
        {"targets": [3, 4, 5, 6, 7, 8, 9],
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

$("#loan-listing-filter-mgt").on("click", function() {
    $("#loan-listing-filter-modal-mgt").modal("show");
});

$("#loan_application_listing_filter-mgt").on("click", function() {
    dt_loan_mgt.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
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
        "url": '/Credit/Management/loan_appraisal',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),
            

        }
    },
    "columns": [
        { "data": "customerName" },
        { "data": "mobileNumber" },
        { "data": "company_name",
        "defaultContent": "<span class='text-warning'>N/A</span>" },
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

                // MIZ 
                if (row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" && row.loan_type == "SME LOAN" && row.repayment_type == "PARTIAL REPAYMENT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PARTIAL REPAYMENT</span></td>";
                }

                if (row.loan_status == "REPAID" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID FULLY</span></td>";
                }
                if (row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" && row.loan_type == "ORDER FINANCE" && row.repayment_type == "PARTIAL REPAYMENT") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>PARTIAL REPAYMENT</span></td>";
                }


                if (row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }
                if (row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }

                
                if (row.loan_status == "REPAID" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-success btn-sm-200'>REPAID FULLY</span></td>";
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
                if (row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-primary btn-sm'>PENDING C.R REPAYMENT STEP </span></td>";
                }
                if (row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" && row.loan_type == "INVOICE DISCOUNTING") {
                    show = "<td><span class='btn ripple btn-primary btn-sm'>PENDING C.R REPAYMENT STEP </span></td>";
                }
                if (row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" && row.loan_type == "CONSUMER LOAN") {
                    show = "<td><span class='btn ripple btn-primary btn-sm'>PENDING C.R REPAYMENT STEP </span></td>";
                }
                if (row.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" && row.loan_type == "SME LOAN") {
                    show = "<td><span class='btn ripple btn-primary btn-sm'>PENDING C.R REPAYMENT STEP </span></td>";
                }






                if (row.loan_status == "PENDING_LOAN_OFFICER" && row.loan_type == "ORDER FINANCE" && row.status =="REJECTED") {
                    show = "<td><span class='btn ripple btn-danger btn-sm'>REJECTED BY MANAGEMENT</span></td>";
                } else if(row.loan_status == "PENDING_LOAN_OFFICER" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING LOAN OFFICER</span></td>";
                } else if(row.loan_status == "REJECTED" && row.loan_type == "ORDER FINANCE") {
                    show = "<td><span class='btn ripple btn-danger btn-sm'>REJECTED</span></td>";
                }

                //  END MIZ
                // WHAT MIZ FOUND

                if (data === "REJECTED") {
                    show = "<td><span class='btn ripple btn-danger btn-sm'>REJECTED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT ANALYST </span></td>";
                }
                if (data === "PENDING_ACCOUNTANT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTS</span></td>";
                }
                if (data === "PENDING_OPERATIONS_MANAGER") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT MANAGER</span></td>";
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
                if (data === "PENDING_FUNDER_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING FUNDER APPROVAL</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>DISBURSED</span></td>";
                }
                if (row.loan_status == "REPAID" && row.loan_type == "CONSUMER LOAN") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID FULLY</span></td>";
                }
                if (row.loan_status == "REPAID" && row.loan_type == "INVOICE DISCOUNTING") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID FULLY</span></td>";
                }
                if (row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.loan_type == "INVOICE DISCOUNTING") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }
                if (row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" && row.loan_type == "CONSUMER LOAN") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTANT DISBURSEMENT</span></td>";
                }

                // END OF WHAT MIZ FOUND

                return show;
            }
        },

        {
            "data": "id",
           // "render": function(data, type, row) {


                // // MIZ --------------------------------------------------

                // if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "ORDER FINANCE" && row.status == "PENDING_CREDIT_ANALYST_ASSESSMENT"){
                //     if ($('#change_status').val() == "Y" ){
                //         return `  
                //         <a href="/Credit/Analyst/Order/finance/Assessment?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>

                //         <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        
                //         <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>

                //     `;

                //     }
                    
                // }              
             
           
                // if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST" && row.productType == "ORDER FINANCE"){
                //     if ($('#change_status').val() == "Y" ){
                //         return `  
                //         <a href="/Credit/Analyst/Order/finance/approval?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>

                //         <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        
                //         <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>

                //     `;

                //     }
                    
                // } 



                
                // if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER" && row.productType == "ORDER FINANCE" && row.status == "OPERATIONS AND CREDIT MANAGER APPROVAL"){
                //     if ($('#change_status').val() == "Y" ){
                //         return `  
                //         <a href="/Approve/Operations/Ordering/Finance/Loan?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>

                //         <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        
                //         <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                //     `;

                //     }
                    
                // }

                // if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT" && row.productType == "ORDER FINANCE"){
                //     if ($('#change_status').val() == "Y" ){
                //         return `  
                //         <a href="/Mgt/Order/Finance/Loan/Approval?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>

                //         <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        
                //         <a href="#" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>

                //         <a href="/Mgt/Order/Finance/Loan/Reject?loan_id=${row.loan_id}" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                //     `;

                //     }
                    
                // }

                // if ( row.loan_status == "APPROVED" && row.productType == "ORDER FINANCE"){
                //     if ($('#change_status').val() == "Y" ){
                //         return `  
                //         <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        
                //         <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                //     `;

                //     }
                    
                // }  
                // if ($('#usertype').val() == "Sales" && row.productType == "ORDER FINANCE"){
                    

                //     if (row.loan_status == "PENDING_LOAN_OFFICER" && row.status =="REJECTED" ){
                //     return `  
                //         <a href="/Admin/Loan/Officer/Order/Finance/Loan/Reject?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Check</a>
                //         <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                //         <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                //     `;   
                //     } else if (row.loan_status == "PENDING_LOAN_OFFICER"){
                //         return `  
                //         <a href="/Loan/Officer/Order/finance/approval/?loan_id=${row.loan_id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Aprove</a>
                //         <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                //         <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                //     `;          
                //     } else {
                //         return `  

                //         <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                //     `;
                //     }
                // } 


                // // MIZ END -------------------------------------------------------------------------------------------

           
               /* if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/view/loan/application/pending/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Submit</a>
                            <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                
                        `;

                    }
                } 

                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/finance/manager/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                
                        `;

                    }
                } 

                
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/operations/application/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Approve</a>
                            <a  href="#" data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal"  class="btn ripple btn-danger btn-sm"><i class= "ki ki-close icon-sm"></i>Reject</a>
                
                        `;

                    }
                } 
               
                if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/executive/committe/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Approve</a>
                            <a  href="#"  data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                
                        `;

                    }
                } 

                if (row.loan_status == "REJECTED") {
                    return ` 
                        <a href="/edit/rejected/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "flaticon-edit-1 icon-sm"></i>Edit Rejected</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                        
                    `;

                }

                if (row.loan_status == "APPROVED") {
                    return ` 
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                }
                
                if ($('#change_status').val() == "Y" && $('#edit').val() == "Y" && $('#view').val() == "Y" ){
                    return ` 
                        <a href="/edit/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a  href="#"  data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                }
               
               
                if ($('#edit').val() == "Y" && $('#view').val() == "Y" ) {
                    return ` 
                       
                        <a href="/edit/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-primary btn-sm "><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                }

                if ($('#view').val() == "Y" ) {
                    return ` 
                        
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View</a>
                    `;

                } 

            


            }, */
            "render": function(data, type, row) {
                console.log(row)

                if (row.loan_type == "SME LOAN") {
                    return `  
                    <a href="/View/All/Documents/Per/loan?loan_id=${row.id}&userId=${row.userId}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-eye icon-sm"></i> Documents </a>
                `;
                } 

                if (row.loan_type == "ORDER FINANCE") {
                    return `  
                    <a href="/View/All/Documents/Per/loan?loan_id=${row.id}&userId=${row.userId}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-eye icon-sm"></i> Documents </a>
                `;
                } 

                if (row.loan_type == "INVOICE DISCOUNTING") {
                    return `  

                    <a href="/View/All/Documents/Per/loan?loan_id=${row.id}&userId=${row.userId}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-eye icon-sm"></i> Documents </a>

                `;
                } 

                if (row.loan_type == "CONSUMER LOAN") {
                    return `  
                    <a href="/View/All/Documents/Per/loan?loan_id=${row.id}&userId=${row.userId}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-eye icon-sm"></i> Documents </a>
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
    "columnDefs": [

        {"targets": 5,
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

$("#loan-listing-filter").on("click", function() {
    $("#loan-listing-filter-modal").modal("show");
});

$("#loan_application_listing_filter").on("click", function() {
    dt_loan_application.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.first_name_filter = $("#first_name_filter").val();
        data.last_name_filter = $("#last_name_filter").val();
        data.requested_amount_filter = $("#requested_amount_filter").val();
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
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a  href="#" data-approve-id="${row.id}" class="approve-quick-loan dropdown-item btn ripple text-success"><i class= "ki ki-check icon-sm"></i>Approved</a>
                    <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" dropdown-item btn ripple text-primary"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                    <a href="#" data-id="${row.id}" data-toggle="#rejectmodal" data-toggle="modal" class=" dropdown-item btn ripple text-danger"><i class= "ki ki-close icon-sm"></i>Reject</a>
                    </div>
                `;
                };

                if (row.loan_status == "REJECTED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                    </div>
                    `;
                }

                if (row.loan_status == "APPROVED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
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
    "columnDefs": [
        {"targets": [1, 2, 3, 4],
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
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                        <div class="dropdown-menu">
                        <a href="#" data-approve-id="${row.id}"  class="approve-float-advance-loan dropdown-item btn ripple text-success"><i class= "ki ki-check icon-sm"></i>Approved</a>
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" dropdown-item btn ripple text-primary"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                        <a href="#" data-id="${row.id}" data-toggle="#rejectmodal" data-toggle="modal" class=" dropdown-item btn ripple text-danger"><i class= "ki ki-close icon-sm"></i>Reject</a>
                        </div>
                    `;
                };

                if (row.loan_status == "REJECTED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                    </div>
                    `;
                }

                if (row.loan_status == "APPROVED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
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
    "columnDefs": [
        {"targets": [1, 2, 3, 4],
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
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                        <div class="dropdown-menu">
                        <a href="#" data-approve-id="${row.id}" class="approve-trade-advance-loan dropdown-item btn ripple text-success"><i class= "ki ki-check icon-sm"></i>Approved</a>
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" dropdown-item btn ripple text-primary"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                        <a href="#" data-id="${row.id}" data-toggle="#rejectmodal" data-toggle="modal" class=" dropdown-item btn ripple text-danger"><i class= "ki ki-close icon-sm"></i>Reject</a>
                        </div>
                    `;
                };

                if (row.loan_status == "REJECTED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                    </div>
                    `;
                };

                if (row.loan_status == "APPROVED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
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
    "columnDefs": [
        {"targets": [1, 2, 3, 4],
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


var dt_invoice_discounting_loan = $('#dt-invoice-discounting-application').DataTable({

    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Consumer Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "filename": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Consumer Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "filename": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Consumer Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "filename": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Consumer Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "filename": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8]
                }
                },


            ],


    "responsive": true,
    "processing": true,
    "bFilter": true,
    "select": {
        "style": 'multi'
    },

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
        {
            "data": "company_name"
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
        { "data": "closedon_date",
        "defaultContent": "<span class='text-warning'>Pending Repayment</span>" 
        },
        { "data": "disbursedon_date",
        "defaultContent": "<span class='text-warning'>Pending Disbursement</span>" 
        },
        { "data": "finance_cost",
        "defaultContent": "<span class='text-warning'>N/A</span>" 
        },
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
                if (data === "REPAID") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID</span></td>";
                }
                if (data === "PENDING_OPERATIONS_MANAGER") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT MANAGER</span></td>";
                }

                if (data === "PENDING_CREDIT_ANALYST_REPAYMENT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING C.R REPAYMENT STEP</span></td>";
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
                if (data === "REPAID") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID</span></td>";
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
        {
            "data": "id",
            "render": function(data, type, row) {
                console.log(row)
                my_user_id = row.userId
           
                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return `  

                        <a href="/Accountant/invoice/discounting/approval?loan_id=${row.id}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-edit-1 icon-sm"></i>Disburse</a>

                    `;

                    }
                    
                } 
           
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Approve/Credit/Invoice/Discounting/Loan?loan_id=${data}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-edit-1 icon-sm"></i>Review</a>
                        
                    `;

                    }
                    
                }
                
                if ($('#usertype').val() == "Credit" && row.loan_status == "APPROVED"){
                    if ($('#change_status').val() == "Y" ){
                        return `  
                        <a href="/Approve/Credit/Invoice/Discounting/Loan?loan_id=${data}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-edit-1 icon-sm"></i>Attach</a>
                        
                    `;

                    }
                    
                } 

                if ($('#usertype').val() == "Credit" && row.loan_status != "PENDING_CREDIT_ANALYST"){
                        if ($('#change_status').val() == "Y" ){if ($('#change_status').val() == "Y" ){
                            return `

                                <div class="dropdown">
                                    <button class="dropbtn">Options</button>
                                    <div class="dropdown-content">

                                        <a class="btn ripple btn-sm" href="/View/All/Documents/Per/loan?loan_id=${row.id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                        <a class="btn ripple btn-sm" href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "> View </a>

                                    </div>
                                </div>
                            `;
                        }

                    }
                }

                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a href="/Approve/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-edit-1 icon-sm"></i>Disburse</a>
                
                        `;

                    }
                } 

                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER"){ 

                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/pending/operations/application/approval?userId=${my_user_id}&loan_id=${row.id}&product_id=${row.product_id}&reference_no=${row.reference_no}"  class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "ki ki-check icon-sm"></i>Review</a>
                
                        `;

                    }
                } 
               
                if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                            <div class="dropdown">
                                <button class="dropbtn">Options</button>
                                <div class="dropdown-content">

                                    <a class="btn ripple btn-sm" href="/Mgt/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "> Approve </a>

                                    <a class="btn ripple btn-sm" href="#" data-id="${row.id}" data-target="#rejectmodal" data-toggle="modal" class="btn ripple btn-info btn-sm "> Reject </a>

                                </div>
                            </div>
                
                        `;

                    }
                }

                if (row.loan_status == "REJECTED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                        <div class="dropdown-menu">
                        <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                }

                if (row.loan_status == "DISBURSED") {
                    return `  

                    <div class="dropdown">
                        <button class="dropbtn">Options</button>
                        <div class="dropdown-content">

                            <a class="btn ripple btn-sm" href="/View/All/Documents/Per/loan?loan_id=${row.id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                            <a class="btn ripple btn-sm" href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "> View </a>

                        </div>
                    </div>

                    `;
                }

                //   MOMO //

                if (row.loan_status != "PENDING_CREDIT_ANALYST") {
                    return `

                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/View/All/Documents/Per/loan?loan_id=${row.id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm" href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>

                    `;
                }

                if ($('#usertype').val() != "Credit") {
                    return `

                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm" href="/View/All/Documents/Per/loan?loan_id=${row.id}&userId=${row.userId}" class="btn ripple btn-info btn-sm "> Documents </a>

                                <a class="btn ripple btn-sm" href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>

                    `;
                }

                //   END MOMO   //

                if (row.loan_status == "APPROVED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                    <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"> View </a>
                    `;
                }
                
                // if ($('#change_status').val() == "Y" && $('#edit').val() == "Y" && $('#view').val() == "Y" ){
                //     return ` 

                //     <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>

                //     <a  href="#"  data-id="${row.id}" data-target="#rejectmodal" data-toggle="modal" class="btn ripple btn-danger btn-sm "><i class= "ki ki-close icon-sm"></i>Reject</a>

                //     <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    
                //     `;

                // }
               
               
                // if ($('#edit').val() == "Y" && $('#view').val() == "Y" ) {
                //     return ` 
                //     <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                //     <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                //     `;

                // }

                // if ($('#view').val() == "Y" ) {
                //     return ` 
                //     <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                //     `;

                // }
                
                // if ($('#change_status').val() == "Y" ) {
                //     return ` 
                //     <a href="/View/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                //     `;

                // } 

            },

            "defaultContent": "<span class='text-danger'>No Actions</span>"
        }

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    "order": [],
    "columnDefs": [
        {"targets": [1, 2, 3, 4, 7],
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
    "columnDefs": [
        {"targets": [4, 5, 6],
            "className": "text-right fw-500"
        },
        {
            "targets": "_all",
            "defaultContent": '<span style="color: red">N/A</span>'
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
        { "data": "disbursedon_date" },
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
            "data": "principal_disbursed_derived",
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
                    show = "<td><span class='btn ripple btn-danger btn-sm'>REJECTED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING APPROVAL </span></td>";
                }
                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT ANALYST </span></td>";
                }
                if (data === "PENDING_ACCOUNTANT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING ACCOUNTS</span></td>";   
                }
                if (data === "PENDING_OPERATIONS_MANAGER") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CREDIT MANAGER</span></td>";
                }
                if (data === "PENDING_OFFTAKER_CONFIRMATION") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING OFFTAKER CONFIRMATION</span></td>";
                }
                if (data === "PENDING_MANAGEMENT") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING MANAGEMENT</span></td>";
                }
                if (data === "PENDING_CRO") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING CRO</span></td>";
                }
                if (data === "PENDING_FUNDER_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING FUNDER APPROVAL</span></td>";
                }
                if (data === "REPAID") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID</span></td>";
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
                if (data === "PENDING_FUNDER_APPROVAL") {
                    show = "<td><span class='btn ripple btn-warning btn-sm'>PENDING FUNDER APPROVAL</span></td>";
                }
                if (data === "REPAID") {
                    show = "<td><span class='btn ripple btn-success btn-sm'>REPAID</span></td>";
                }

                return show;
            }
        },

        {
            // "data": "id",
            "render": function(data, type, row) {
                if (row.loan_status == "PENDING_ACCOUNTANT") {  
                    return `
                        
                        <a href="/Approve/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Disburse</a>

                    `;
                }

                if (row.loan_status != "PENDING_ACCOUNTANT") {  
                    return `

                    <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple text-white btn-sm" style="background-color: #24BFCD;"><i class= "flaticon-eye icon-sm"></i> View </a>


                    `;
                }

                if (row.loan_status == "PENDING_CREDIT_ANALYST") {
                    return `
                        
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>

                    `;
                }

                if (row.loan_status == "PENDING_OFFTAKER_CONFIRMATION") {
                    return `
                        
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>

                    `;
                }

                // if (row.loan_status == "PENDING_ACCOUNTANT") {
                //     return `
                        
                //         <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                //         <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>

                //     `;
                // }

                if (row.loan_status == "PENDING_MANAGEMENT") {
                    return `
                        
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>

                    `;
                }

                if (row.loan_status == "PENDING_OPERATIONS_MANAGER") {
                    return `
                        
                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class="btn ripple btn-primary btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Edit</a>
                        <a href="/View/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}" class="btn ripple btn-info btn-sm"><i class= "flaticon-eye icon-sm"></i> View </a>

                    `;
                }
                
                if (row.loan_status == "PENDING_APPROVAL") {
                    return `
                    <a href="/Approve/Accounts/Invoice/Discounting/Loan?loan_id=${row.id}"class="btn ripple btn-success btn-sm"><i class= "flaticon-edit-1 icon-sm"></i>Submit</a>
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
    "columnDefs": [
        {"targets": [1, 2, 3, 4, 5],
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
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                    <div class="dropdown-menu">
                      <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
                    </div>
                    `;
                };

                if (row.status == "FAILED") {
                    return `  <span data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>
                        <div class="dropdown-menu">
                          <a  href="#" data-approve-id="${row.id}" class="approve-quick-advance-loan dropdown-item btn ripple text-success"><i class= "ki ki-check icon-sm"></i>Make Payment</a>
                          <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" dropdown-item btn ripple text-info"><i class= "flaticon-eye icon-sm"></i> View </a>
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
    "columnDefs": [
        {"targets": 2,
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
    "columnDefs": [
        {"targets": [3, 4, 5],
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



var dt_loan_mgt = $('#dt-consumer-loan-application').DataTable({
    "responsive": true,

    "dom": `<'row'<'col-sm-6 text-left'f><'col-sm-6 text-right'B>>
        <'row'<'col-sm-12'tr>>
        <'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7 dataTables_pager'lp>>`,
        "buttons":[
                {
                "extend": 'csvHtml5',
                "text": 'Excel',
                "titleAttr": 'Consumer Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "filename": "Consumer Loan Report -" + russ_formattedDateTime_2,
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                }
                },
                {
                "extend": 'copyHtml5',
                "text": 'Copy',
                "titleAttr": 'Consumer Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Loan Report",
                "filename": "Consumer Loan Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                }
                },
                {
                "extend": 'print',
                "text": 'Print',
                "titleAttr": 'Consumer Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Loan Report",
                "filename": "Consumer Loan Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                }
                },
                {
                "extend": 'pdfHtml5',
                "text": 'PDF',
                "titleAttr": 'Consumer Loan Report',
                "className": "btn-outline-primary btn-sm mr-1",
                "messageTop": "Consumer Loan Report",
                "filename": "Consumer Loan Report",
                "exportOptions": {
                    'columns': [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                }
                },


            ],


    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
  
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
        "url": '/Credit/Management/Consumer/Loans/Lookup',
        "data": {
            _csrf_token: $("#csrf").val(),
            "first_name_filter": $('#first_name_filter').val(),
            "last_name_filter": $('#last_name_filter').val(),
            "requested_amount_filter": $('#requested_amount_filter').val(),
            "loan_type_filter": $('#loan_type_filter').val(),
            "from": $('#from').val(),
            "to": $('#to').val(),

        }
    },
    "columns": [
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
            "data": "arrangement_fee",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "finance_cost",
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
            "data": "repayment_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "monthly_installment",
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
                if (data === "PENDING_CREDIT_ANALYST") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT ANALYST </span></td>";
                }
                if (data === "PENDING_ACCOUNTANT") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING ACCOUNTS</span></td>";
                }
                if (data === "PENDING_OPERATIONS_MANAGER") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT MANAGER</span></td>";
                }
                if (data === "PENDING_MANAGEMENT") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING MANAGEMENT</span></td>";
                }
                if (data === "PENDING_CRO") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CRO</span></td>";
                }
                if (data === "APPROVED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>APPROVED </span></td>";
                }
                if (data === "PENDING_DISBURSEMENT") {
                    show = "<td><span class='badge bg-success-light bg-pill'>PENDING DISBURSEMENT</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-success-light bg-pill'>DISBURSED</span></td>";
                }
                if (data === "FROM_MGT_TO_CREDIT_ANALYST") {
                    show = "<td><span class='badge bg-warning-light bg-pill'>PENDING CREDIT ANALYST </span></td>";
                }

                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {

                console.log(row)

                if ($('#usertype').val() == "Accounts" && row.loan_status == "PENDING_ACCOUNTANT"){
                    if ($('#change_status').val() == "Y" ){
                        return ` 

                            <a  href="/pending/finance/manager/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>Disburse</a>
                      
                
                        `;

                    }
                } 
           
                if ($('#usertype').val() == "Credit" && row.loan_status == "PENDING_CREDIT_ANALYST"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                            <div class="dropdown">
                                <button class="dropbtn">Options</button>
                                <div class="dropdown-content">

                                    <a class="btn ripple btn-sm" href="/view/loan/application/pending/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> Review </a>

                                    <a class="btn ripple btn-sm"  href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> View </a>

                                </div>
                            </div>
                
                        `;

                    }
                } 

                if ($('#usertype').val() == "Credit" && row.loan_status == "FROM_MGT_TO_CREDIT_ANALYST"){
                    if ($('#change_status').val() == "Y" ){
                        return `

                            <div class="dropdown">
                                <button class="dropbtn">Options</button>
                                <div class="dropdown-content">

                                    <a class="btn ripple btn-sm" href="/view/loan/application/pending/credit/from/mgt?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> Review </a>

                                    <a class="btn ripple btn-sm"  href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> View </a>

                                </div>
                            </div>
                
                        `;

                    }
                } 

                
                if ($('#usertype').val() == "Operations" && row.loan_status == "PENDING_OPERATIONS_MANAGER"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                            <div class="dropdown">
                                <button class="dropbtn">Options</button>
                                <div class="dropdown-content">

                                    <a class="btn ripple btn-sm" href="/pending/operations/application/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> Review </a>

                                    <a class="btn ripple btn-sm"  href="#" data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class="btn ripple btn-info btn-sm "> Reject </a>

                                </div>
                            </div>
                
                        `;

                    }
                } 
               
                if ($('#usertype').val() == "Management" && row.loan_status == "PENDING_MANAGEMENT"){
                    if ($('#change_status').val() == "Y" ){
                        return `


                            <div class="dropdown">
                                <button class="dropbtn">Options</button>
                                <div class="dropdown-content">

                                    <a class="btn ripple btn-sm" href="/pending/executive/committe/approval?loan_id=${row.id}&userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> Review </a>

                                    <a class="btn ripple btn-sm"  href="#" data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class="btn ripple btn-info btn-sm "> Reject </a>

                                    <a class="btn ripple btn-sm"  href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> View </a>

                                </div>
                            </div>
                
                        `;

                    }
                } 

                if (row.loan_status == "REJECTED") {
                    return `

                        <div class="dropdown">
                                <button class="dropbtn">Options</button>
                                <div class="dropdown-content">

                                    <a class="btn ripple btn-sm"  href="/edit/rejected/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> Edit Rejected </a>

                                    <a class="btn ripple btn-sm"  href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> View </a>

                                </div>
                            </div>
                        
                    `;

                }

                if (row.loan_status == "APPROVED") {
                    return ` 
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
                    `;

                }
                
                if ($('#change_status').val() == "Y" && $('#edit').val() == "Y" && $('#view').val() == "Y" ){
                    return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm"  href="#" data-id="${row.id}" data-toggle="#loan-reject-modal" data-toggle="modal" class="btn ripple btn-info btn-sm "> Reject </a>

                                <a class="btn ripple btn-sm"  href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;

                }
               
               
                if ($('#edit').val() == "Y" && $('#view').val() == "Y" ) {
                    return `


                        <div class="dropdown">
                            <button class="dropbtn">Options</button>
                            <div class="dropdown-content">

                                <a class="btn ripple btn-sm"  href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class="btn ripple btn-info btn-sm "> View </a>

                            </div>
                        </div>
                    `;

                }

                if ($('#view').val() == "Y" ) {
                    return ` 
                        
                        <a href="/view/universal/loan/application?userId=${row.userId}&product_id=${row.productId}&reference_no=${row.reference_no}" class=" btn ripple btn-info btn-sm "><i class= "flaticon-eye icon-sm"></i> View </a>
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
    "columnDefs": [
        {"targets": [3, 4, 5, 6, 7, 8],
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






var dt_mgt_loan_td_loan_repayment = $('#td-mgt-loan-repayment').DataTable({
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
    "bFilter": true,
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
        "url": '/Management/Repayment/Loan/View/Items',
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

                if ($('#usertype').val() == "Management" ){
                    if ($('#change_status').val() == "Y" ){
                        return ` 
                            <a  href="/Admin/Mgt/Loan/Repayments?reference_no=${row.reference_no}&loan_id=${row.id}&repayment_type=${row.repayment_type}"  class=" btn ripple btn-success btn-sm "><i class= "ki ki-check icon-sm"></i>view</a>
                        `;
                    }
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
    "columnDefs": [
        {"targets": [6, 7, 8, 9, 11],
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


var dt_loan_portifolio_list = $('#tb-funder-invoice-table').DataTable({
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

    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],

  
});



$('#credit_analyst_upload_agrement_guarantor_form_button').click(function() {

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
                $("#credit_analyst_upload_guarantor_form_consummer").attr('action', '/post/loan/agreement/form/by/credit/analyst');
                $("#credit_analyst_upload_guarantor_form_consummer").attr('method', 'POST');
                $("#credit_analyst_upload_guarantor_form_consummer").submit();

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




$('#credit_analyst_approve_consumer_loan_application_button').click(function() {

    var loan_document_upload = document.getElementById('crb_loan_document_upload').value;

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
                $("#credit_analyst_approve_individual_consummer").attr('action', '/Credit/Analyst/Aprove/Employee/Consumer/Loan');
                $("#credit_analyst_approve_individual_consummer").attr('method', 'POST');
                $("#credit_analyst_approve_individual_consummer").submit();

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




$('#credit_manager_approve_consumer_loan_application_button').click(function() {

    var loan_recommandation = document.getElementById('loan_recommandation').value;

    if (loan_recommandation === "") 
    {
        Swal.fire({
            title: ("please provide loan recommandation"),
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
                $("#credit_manager_approve_individual_consummer").attr('action', '/Operation/Officer/Aprove/Employee/Consumer/Loan');
                $("#credit_manager_approve_individual_consummer").attr('method', 'POST');
                $("#credit_manager_approve_individual_consummer").submit();

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


$('#exco_approve_consumer_loan_application_button').click(function() {

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
                $("#exco_approve_individual_consummer").attr('action', '/Management/Aprove/Employee/Consumer/Loan');
                $("#exco_approve_individual_consummer").attr('method', 'POST');
                $("#exco_approve_individual_consummer").submit();

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





