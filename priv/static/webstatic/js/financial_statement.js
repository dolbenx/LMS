///////////////////////////////////Balance Sheet
var txn_report_dtbalance_sheet = $('#balancesheet_dt').DataTable({
    "responsive": true,
    "processing": true,
    dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',
    buttons: [
        {
            extend: 'excelHtml5',
            text: 'Excel',
            titleAttr: 'Loans Excel File',
            messageTop: "GNC Balance Sheet",
            filename: "Balance Sheet",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC Balance Sheet",
            filename: "Balance Sheet",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC  Balance Sheet",
            filename: "Balance Sheet",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC Balance Sheet",
            filename: "Balance Sheet",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
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
        "url": '/balance/sheet/report',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "account_no": $('#account_no').val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val(),
        }
    },
    "columns": [

        { "data": "account_no" },
        { "data": "account_category" },
        { "data": "account_name" },
        {
            "data": "dr_amount",
            render: function(data, _, _) {
                console.log(data)
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },

        {
            "data": "cr_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
    ],
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000]
    ],
    "order": [
        [1, 'asc']
    ]
});

///////////////////////////////////Income statement
var txn_report_dtincome_statement = $('#incomestatement_dt').DataTable({
    "responsive": true,
    "processing": true,
    dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

    buttons: [
        {
            extend: 'excelHtml5',
            text: 'Excel',
            titleAttr: 'Loans Excel File',
            messageTop: "GNC Income Statment",
            filename: "Income Statment",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC Income Statment",
            filename: "Income Statment",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC Income Statment",
            filename: "Income Statment",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC Income Statment",
            filename: "Income Statment",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
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
        "url": '/income/statement/report',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "account_no": $('#account_no').val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val(),
        }
    },
    "columns": [

        { "data": "account_no" },
        { "data": "account_category" },
        { "data": "account_name" },
        {
            "data": "dr_amount",
            render: function(data, _, _) {
                console.log(data)
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },

        {
            "data": "cr_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
    ],
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000]
    ],
    "order": [
        [1, 'asc']
    ]
});


///////////////////////////////////Trial Balance
var txn_report_dtincome_statement = $('#trialbalance_dt').DataTable({
    "responsive": true,
    "processing": true,
    dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',

    buttons: [
        {
            extend: 'excelHtml5',
            text: 'Excel',
            titleAttr: 'Loans Excel File',
            messageTop: "GNC Trial Balance",
            filename: "Trial Balance",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC Trial Balance",
            filename: "Trial Balance",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC Trial Balance",
            filename: "Trial Balance",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC Trial Balance",
            filename: "Trial Balance",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4]
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
        "url": '/trial/balance/report',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "account_no": $('#account_no').val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val(),
        }
    },
    "columns": [

        { "data": "account_no" },
        { "data": "account_category" },
        { "data": "account_name" },
        {
            "data": "dr_amount",
            render: function(data, _, _) {
                console.log(data)
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },

        {
            "data": "cr_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
    ],
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000]
    ],
    "order": [
        [1, 'asc']
    ]
});



/////////////////////////////////// General Ledger
var txn_report_dtincome_statement = $('#generalledger_dt').DataTable({
    "responsive": true,
    "processing": true,
     dom: '<"top"flB><"text-right"><"clear">rt<"bottom"ip><"clear">',
   
    buttons: [
        {
            extend: 'excelHtml5',
            text: 'Excel',
            titleAttr: 'Loans Excel File',
            messageTop: "GNC General Ledger",
            filename: "General Ledger",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6]
            }
        },
        {
            extend: 'pdfHtml5',
            text: 'PDF',
            titleAttr: 'Loans PDF File',
            messageTop: "GNC General Ledger",
            filename: "General Ledger",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6]
            }
        },
        {
            extend: 'print',
            text: 'Print',
            titleAttr: 'Loans print Out File',
            messageTop: "GNC General Ledger",
            filename: "General Ledger",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6]
            }
        },
        {
            extend: 'csvHtml5',
            text: 'CSV',
            titleAttr: 'Loans CSV File',
            messageTop: "GNC General Ledger",
            filename: "General Ledger",
            exportOptions: {
                columns: [ 0, 1, 2, 3, 4, 5, 6]
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
        "url": '/general/ledger/report',
        "data": {
            "_csrf_token": $("#csrf").val(),
            "account_no": $('#account_no').val(),
            "start_date": $('#start_date').val(),
            "end_date": $('#end_date').val(),
        }
    },
    "columns": [

        { "data": "account_no" },
        { "data": "account_category" },
        { "data": "account_name" },
        { "data": "trn_dt" },
        { "data": "narration" },
        {
            "data": "dr_amount",
            render: function(data, _, _) {
                console.log(data)
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },

        {
            "data": "cr_amount",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
        // {
        //     "data": "runningBalance",
        //     render: function(data, _, _) {
        //         return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
        //     }
        // },
    ],
    "lengthMenu": [
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000],
        [10, 20, 50, 100, 500, 1000, 10000, 20000,100000, 1000000, 10000000]
    ],
    "order": [
        [1, 'asc']
    ]
});