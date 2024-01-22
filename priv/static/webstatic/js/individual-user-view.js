var dt_loan_statement = $('#dt-mini-statement-individual-role').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000]
    ],
    dom: '<"row"<"col-sm-6 text-left"B>>' +
        '<"row"<"col-sm-12"tr>>' +
        '<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7 dataTables_pager"lp>>',
    buttons: [
        {
            "extend": 'colvis',
            "text": 'Column Visibility',
            "titleAttr": 'Client Mini Statement',
            "className": "btn-outline-warning btn-sm mr-1",
            "messageTop": "Client Mini Statement",
            "filename": "Client Mini Statement",
            "exportOptions": {
                'columns': [ 0, 1, 2, 3, 4, 5, 6, 7]
            },
            "orientation" : 'landscape',
            "pageSize" : 'LEGAL',
        },
        'print',
        'copyHtml5',
        'excelHtml5',
        'csvHtml5',
        'pdfHtml5'
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
        "url": '/Individual/Mini-Statements',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val()

        }
    },
    "columns": [
        { "data": "sn" },
        { "data": "due_date", 
            "defaultContent": "<span class='text-warning'>Pending Approval</span>" 
        },
        { "data": "product_name" },
        {
            "data": "repayment_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') :  "<span class='text-warning'>Pending Disbursement</span>" );
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
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : "<span class='text-warning'>Pending Approval</span>" );
            },
        },
        {
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : "<span class='text-warning'>Pending Disbursement</span>");
            }
        },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data.includes("PENDING")) {
                    show = "<td><span class='badge bg-pill bg-warning text-white'>PENDING APPROVAL</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-pill bg-success'>DISBURSED </span></td>";
                }
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-pill bg-danger'>REJECTED </span></td>";
                }
                return show;
            }
        },


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

$("#statement-filter-search-statement").on("click", function() {
    dt_loan_statement.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_loan_statement.draw();
});


$('#statement-filter-clear-statement').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_loan_statement.draw();
});

//Loan Statement pdf
$('#export_loan_statement_pdf').click(function() {
    // $('#loan_statement_reportfilter').attr('action', '/download/loan/statement/pdf');
    // $('#loan_statement_reportfilter').attr('method', 'GET');
    // $("#loan_statement_reportfilter").submit();
    console.log("************************")
});




var dt_mini_statement = $('#dt-mini-statement-individual-role-historic').DataTable({
    "responsive": true,
    "processing": true,
    "bFilter": false,
    "select": {
        "style": 'multi'
    },
    dom: '<"row"<"col-sm-6 text-left"B>>' +
        '<"row"<"col-sm-12"tr>>' +
        '<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7 dataTables_pager"lp>>',
    buttons: [
        'print',
        'copyHtml5',
        'excelHtml5',
        'csvHtml5',
        'pdfHtml5'
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
        "url": '/Individual/Historic-Statements',
        "data": {
            _csrf_token: $("#csrf").val(),
            "id": $('#id').val(),
            "from": $('#from').val(),
            "to": $('#to').val()

        }
    },
    "columns": [
        { "data": "sn" },
        { "data": "due_date", 
            "defaultContent": "<span class='text-warning'>Pending Approval</span>" 
        },
        { "data": "product_name" },
        {
            "data": "repayment_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') :  "<span class='text-warning'>Pending Disbursement</span>" );
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
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : "<span class='text-warning'>Pending Approval</span>" );
            },
        },
        {
            "data": "balance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : "<span class='text-warning'>Pending Disbursement</span>");
            }
        },
        {
            "data": "loan_status",
            render: function(data, _, row) {
                let show = "";
                if (data.includes("PENDING")) {
                    show = "<td><span class='badge bg-pill bg-warning text-white'>PENDING APPROVAL</span></td>";
                }
                if (data === "DISBURSED") {
                    show = "<td><span class='badge bg-pill bg-success'>DISBURSED </span></td>";
                }
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-pill bg-danger'>REJECTED </span></td>";
                }
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-pill bg-danger'>${data}</span></td>";
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
                  <a data-deactivate-id="${id}" class="deactivate-sme-loans dropdown-item btn ripple text-danger"><i class= "fe fe-check-circle"></i> Export PDF </a>
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

$("#statement_filter_search").on("click", function() {
    dt_mini_statement.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.from = $("#from").val();
        data.to = $("#to").val();
    });
    // $("#customer_loans_filter_model").modal("hide");
    dt_mini_statement.draw();
});


$('#statement-filter-clear').on('click', function() {
    $('.clear_select').val(null).trigger("change")
    $('.clear_form').val('');
    dt_mini_statement.draw();
});