var dt_quick_advance_loan = $('#dt-quick-advance-loan-application').DataTable({
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
                    return ` 

                        <a  href="#" data-approve-id="${row.id}" class="approve-quick-advance-loan btn ripple btn-success btn-sm "><i class= "fe fe-check-circle"></i>Approved</a>

                        <a href="/Credit/Management/quick_advance_application/edit?loan_id=${row.id}"class=" btn ripple btn-primary btn-sm "><i class= "fe fe-edit"></i>Edit</a>

                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>

                        <a href="#" data-id="${row.id}" data-bs-target="#rejectmodal" data-bs-toggle="modal" class=" btn ripple btn-danger btn-sm "><i class= "fe fe-trash"></i>Reject</a>

                    `;
                };

                if (row.loan_status == "REJECTED") {
                    return `
                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                    `;
                };

                if (row.loan_status == "DISBURSED") {
                    return `
                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
                    `;
                }

                if (row.loan_status == "APPROVED") {
                    return `
                        <a href="/Credit/Management/quick_advance_application/view?loan_id=${row.id}" class=" btn ripple btn-info btn-sm "><i class= "fe fe-eye"></i> View </a>
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