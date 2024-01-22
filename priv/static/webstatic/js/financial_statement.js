///////////////////////////////////Balance Sheet
var txn_report_dtbalance_sheet = $('#balancesheet_dt').DataTable({
    "responsive": true,
    "processing": true,
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
        { "data": "trn_dt" },

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
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});

///////////////////////////////////Income statement
var txn_report_dtincome_statement = $('#incomestatement_dt').DataTable({
    "responsive": true,
    "processing": true,
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
        { "data": "trn_dt" },

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
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});


///////////////////////////////////Trial Balance
var txn_report_dtincome_statement = $('#trialbalance_dt').DataTable({
    "responsive": true,
    "processing": true,
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
        { "data": "trn_dt" },

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
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});



/////////////////////////////////// General Ledger
var txn_report_dtincome_statement = $('#generalledger_dt').DataTable({
    "responsive": true,
    "processing": true,
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
        {
            "data": "runningBalance",
            render: function(data, _, _) {
                return (data ? parseFloat(data).toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,') : 0);
            }
        },
    ],
    "lengthMenu": [
        [10, 25, 50, 100, 500, 1000],
        [10, 25, 50, 100, 500, 1000]
    ],
    "order": [
        [1, 'asc']
    ]
});