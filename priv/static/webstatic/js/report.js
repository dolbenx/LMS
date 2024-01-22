var dt_last_installment = $('#dt-last-installment-overpayment').DataTable({
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
            messageTop: "GNC Last Installment overpayment Report",
            filename: "Last Installment overpayment",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC Last Installment overpayment Report",
            filename: "Last Installment overpayment",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC Last Installment overpayment Report",
            filename: "Last Installment overpayment",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC Last Installment overpayment Report",
            filename: "Last Installment overpayment",
            exportOptions: {
                columns: [  0, 1, 2, 3, 4, 5, 6]
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
        "url": '/Admin/get/last/installment/overpayment',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
            

    "columns": [
        { "data": "id" },
        { "data": "client_name" },
        { "data": "lasttxn_date" },
        {"data": "payoff_amount",
        "defaultContent": "<span >0</span>" 
        },
        {"data": "paid_amount",
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
        { "data": "loan_officer" },
    
    ],
    "lengthChange": true,
    "lengthMenu": [
        [20, 30, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [20, 30, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
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

var dt_repayment_writeoff = $('#dt-repayment-writeoff').DataTable({
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
            messageTop: "GNC Repayment from Writtenoff Report",
            filename: "Repayment from Writtenoff",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC Repayment from Writtenoff Report",
            filename: "Repayment from Writtenoff",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC Repayment from Writtenoff Report",
            filename: "Repayment from Writtenoff",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC Repayment from Writtenoff Report",
            filename: "Repayment from Writtenoff",
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
        "url": '/Admin/get/repayment/writeoff',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
            

    "columns": [
        { "data": "id" },
        { "data": "client" },
        //{ "data": "trn_dt" },
        {
            "data": "loan_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "loan_interest",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "payoff_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "total_repaid",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {"data": "writeoff"},
        { "data": "writeoff_dt" },
        { "data": "loan_officer" },
    
    ],
    "lengthChange": true,
    "lengthMenu": [
        [20, 30, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [20, 30, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
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

var dt_writtenoff_loans = $('#dt-writtenoff_loans').DataTable({
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
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loanst",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
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
        "url": '/Admin/get/writtenoff/loans/report',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
            

    "columns": [
        { "data": "id" },
        { "data": "client_name" },
        { "data": "date_of_writtenoff" },
        {
            "data": "amount_writtenoff",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        { "data": "writtenoff_by"},
        
    
    ],
    "lengthChange": true,
    "lengthMenu": [
        [20, 30, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [20, 30, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
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


var dt_arrears_report = $('#dt-arrears_report').DataTable({
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
            messageTop: "GNC Arrears Report",
            filename: "Arrears Report",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC Arrears Report",
            filename: "Arrears Report",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC Arrears Report",
            filename: "Arrears Report",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6, 7, 8]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC Arrears Report",
            filename: "Arrears Report",
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
        "url": '/Admin/get/arrears/loans/report',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
            

    "columns": [
        { "data": "id" },
        { "data": "client_name" },
        { "data": "product" },
        {
            "data": "loan_amount",
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
            "data": "payoff_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
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
        { "data": "duedate" },
       
        { "data": "loan_officer"},
        
    
    ],
    "lengthChange": true,
    "lengthMenu": [
        [20, 30, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [20, 30, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
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


var dt_financial_position = $('#dt-financial_position').DataTable({
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
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loanst",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
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
        "url": '/Admin/get/arrears/loans/report',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
            

    "columns": [
        { "data": "id" },
        { "data": "client_name" },
        { "data": "product" },
        {
            "data": "loan_amount",
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
            "data": "principle_arrears",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "interest_arears",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "total_arrears",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        { "data": "last_repayment_dt" },
        { "data": "portifolio_at_risk" },
        { "data": "loan_officer"},
        
    
    ],
    "lengthChange": true,
    "lengthMenu": [
        [20, 30, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [20, 30, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
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

var dt_cashflow_statement = $('#dt-cashflow-statement').DataTable({
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
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loanst",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC writtenoff loans Report",
            filename: "writtenoff loans",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
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
        "url": '/Admin/get/cashflow/statement/report',
        "data": {
            _csrf_token: $("#csrf").val(),

        }
    },
            

    "columns": [
        { "data": "id" },
        { "data": "client_name" },
        { "data": "product" },
        {
            "data": "loan_amount",
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
            "data": "principle_arrears",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "interest_arears",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        {
            "data": "total_arrears",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        { "data": "last_repayment_dt" },
        { "data": "portifolio_at_risk" },
        { "data": "loan_officer"},
        
    
    ],
    "lengthChange": true,
    "lengthMenu": [
        [20, 30, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [20, 30, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000]
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



var dt_user_activity = $('#dt-user-activity').DataTable({
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
            messageTop: "GNC Audit Trail",
            filename: "GNC Audit Trail",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC Audit Trail",
            filename: "GNC Audit Trail",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC Audit Trail",
            filename: "GNC Audit Trail",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC Audit Trail",
            filename: "GNC Audit Trail",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
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
        "url": '/Admin/change/management/audit/trail',
        "data": {
            _csrf_token: $("#csrf").val(),
            "filter_application_date_from": $('#filter_application_date_from').val(),
            "filter_application_date_to": $('#filter_application_date_to').val(),
            "filter_mobileno": $('#filter_mobileno').val(),
            "filter_email_address": $('#filter_email_address').val(),
            "filter_user_role": $('#filter_user_role').val(),
            "filter_activity": $('#filter_activity').val(),

        }
    },
            

    "columns": [
        { "data": "mobileNumber" },
        { "data": "username" },
        { "data": "roleType" },
        { "data": "activity"},
        { "data": "inserted_at"},
        

    ],
    "lengthChange": true,
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000, 100000000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000, 100000, 1000000,10000000, 100000000]
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


$("#admin-user-activity-filter").on("click", function() {
    $("#loan_user_activity_model").modal("show");
});

$("#admin_user_activity_logs_filter").on("click", function() {
    dt_user_activity.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.filter_mobileno = $("#filter_mobileno").val();
        data.filter_application_date_from = $("#filter_application_date_from").val();
        data.filter_application_date_to = $('#filter_application_date_to').val();
        data.filter_email_address = $('#filter_email_address').val();
        data.filter_user_role = $('#filter_user_role').val();
        data.filter_activity = $("#filter_activity").val();
       
    });
    $("#loan_user_activity_model").modal("hide");
    dt_user_activity.draw();
});



