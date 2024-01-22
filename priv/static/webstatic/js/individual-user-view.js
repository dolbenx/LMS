var dt_loan_statement = $('#dt-mini-statement-individual-role').DataTable({
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
        { "data": "closedon_date" },
        { "data": "product_name" },
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
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-pill bg-info'>PENDING_APPROVAL</span></td>";
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
        {
            data: "id",
            render: function(data, type, row) {
                console.log(data)
                console.log(row)
                return '  <span data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"> <i class="fe fe-chevron-down"></i> </span>' +
                    '<div class="dropdown-menu">' +
                    '<a href="/download/loan/statement/pdf?id=' + data + '" class=" dropdown-item btn ripple text-danger"><i class= "fe fe-check-circle"></i> Export PDF</a>' +
                    '</div>';
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
        { "data": "closedon_date" },
        { "data": "product_name" },
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
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-pill bg-info'>PENDING_APPROVAL</span></td>";
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