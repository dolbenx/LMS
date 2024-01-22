var dt_chart_of_accounts = $('#tb-chart-of-accounts').DataTable({
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
        "url": '/chart/of/accounts',
        "data": {
            _csrf_token: $("#csrf").val(),
            "filter_ac_gl_no": $('#filter_ac_gl_no').val(),
            "filter_leaf_or_node": $('#filter_leaf_or_node').val(),
            "filter_gl_branch_res": $('#filter_gl_branch_res').val(),
            "start_date": $('#start_date').val(),
            "filter_ac_gl_descption": $('#filter_ac_gl_descption').val(),
            "filter_node_gl": $('#filter_node_gl').val(),
            "filter_gl_category": $('#filter_gl_category').val(),
            "end_date": $('#end_date').val(),

        }
    },
    "columns": [
        { "data": "ac_gl_no" },
        { "data": "ac_gl_descption" },
        { "data": "leaf_or_node" },
        { "data": "node_gl" },
        { "data": "gl_category" },
        {
            "data": "auth_status",
            render: function(data, _, row) {
                let show = "";
                if (data === "REJECTED") {
                    show = "<td><span class='badge bg-danger bg-pill'>REJECTED</span></td>";
                }
                if (data === "PENDING_APPROVAL") {
                    show = "<td><span class='badge bg-warning bg-pill'>PENDING APPROVAL </span></td>";
                }
                if (data === "AUTHORISED") {
                    show = "<td><span class='badge bg-success bg-pill'> AUTHORISED </span></td>";
                }
                return show;
            }
        },

        {
            "data": "id",
            "render": function(data, type, row) {
                if (row.auth_status == "PENDING_APPROVAL") {
                    return `  

                            <a  class="btn btn-sm btn-success" title="Authorise" data-target="#authoriseglmodal" data-toggle="modal"
                                data-id ="${row.id}"
                                data-ac_gl_no ="${row.ac_gl_no}"
                                data-revaluation ="${row.revaluation} "
                                data-ac_gl_ccy ="${row.ac_gl_ccy}"
                                data-leaf_or_node ="${row.leaf_or_node}"
                                data-gl_branch_res ="${row.gl_branch_res}"
                                data-gl_category ="${row.gl_category}"
                                data-ac_gl_descption ="${row.ac_gl_descption}"
                                data-ac_ccy_res ="${row.ac_ccy_res}"
                                data-gl_type ="${row.gl_type}"
                                data-node_gl ="${row.node_gl}"
                                data-gl_post_type ="${row.gl_post_type}"
                            data-overall_limit ="${row.overall_limit}"><i class="si si-check"></i> Authorise </a>

                            <a  class="btn btn-sm btn-info" title="Edit" data-target="#editglmodal" data-toggle="modal"
                                data-id ="${row.id}"
                                data-ac_gl_no ="${row.ac_gl_no}"
                                data-revaluation ="${row.revaluation} "
                                data-ac_gl_ccy ="${row.ac_gl_ccy}"
                                data-leaf_or_node ="${row.leaf_or_node}"
                                data-gl_branch_res ="${row.gl_branch_res}"
                                data-gl_category ="${row.gl_category}"
                                data-ac_gl_descption ="${row.ac_gl_descption}"
                                data-ac_ccy_res ="${row.ac_ccy_res}"
                                data-gl_type ="${row.gl_type}"
                                data-node_gl ="${row.node_gl}"
                                data-gl_post_type ="${row.gl_post_type}"
                            data-overall_limit ="${row.overall_limit}"><i class="si si-note"></i> Edit </a>
                          
                            <a  class="btn btn-sm btn-primary" title="view" data-target="#viewglmodal" data-toggle="modal"
                                data-id ="${row.id}"
                                data-ac_gl_no ="${row.ac_gl_no}"
                                data-revaluation ="${row.revaluation} "
                                data-ac_gl_ccy ="${row.ac_gl_ccy}"
                                data-leaf_or_node ="${row.leaf_or_node}"
                                data-gl_branch_res ="${row.gl_branch_res}"
                                data-gl_category ="${row.gl_category}"
                                data-ac_gl_descption ="${row.ac_gl_descption}"
                                data-ac_ccy_res ="${row.ac_ccy_res}"
                                data-gl_type ="${row.gl_type}"
                                data-node_gl ="${row.node_gl}"
                                data-gl_post_type ="${row.gl_post_type}"
                            data-overall_limit ="${row.overall_limit}"><i class="si si-eye"></i> View </a>
                        
                    `;
                };

                if (row.auth_status == "REJECTED") {
                    return `  
                     <a  class="btn btn-sm btn-primary" title="view" data-target="#viewglmodal" data-toggle="modal"
                        data-id ="${row.id}"
                        data-ac_gl_no ="${row.ac_gl_no}"
                        data-revaluation ="${row.revaluation} "
                        data-ac_gl_ccy ="${row.ac_gl_ccy}"
                        data-leaf_or_node ="${row.leaf_or_node}"
                        data-gl_branch_res ="${row.gl_branch_res}"
                        data-gl_category ="${row.gl_category}"
                        data-ac_gl_descption ="${row.ac_gl_descption}"
                        data-ac_ccy_res ="${row.ac_ccy_res}"
                        data-gl_type ="${row.gl_type}"
                        data-node_gl ="${row.node_gl}"
                        data-gl_post_type ="${row.gl_post_type}"
                    data-overall_limit ="${row.overall_limit}"><i class="si si-eye"></i> View </a>
                        
                    `;
                };

                if (row.auth_status == "AUTHORISED") {
                    return `  

                    <a  class="btn btn-sm btn-info" title="Edit" data-target="#editglmodal" data-toggle="modal"
                        data-id ="${row.id}"
                        data-ac_gl_no ="${row.ac_gl_no}"
                        data-revaluation ="${row.revaluation} "
                        data-ac_gl_ccy ="${row.ac_gl_ccy}"
                        data-leaf_or_node ="${row.leaf_or_node}"
                        data-gl_branch_res ="${row.gl_branch_res}"
                        data-gl_category ="${row.gl_category}"
                        data-ac_gl_descption ="${row.ac_gl_descption}"
                        data-ac_ccy_res ="${row.ac_ccy_res}"
                        data-gl_type ="${row.gl_type}"
                        data-node_gl ="${row.node_gl}"
                        data-gl_post_type ="${row.gl_post_type}"
                    data-overall_limit ="${row.overall_limit}"><i class="si si-note"></i> Edit </a>

                    <a  class="btn btn-sm btn-primary" title="view" data-target="#viewglmodal" data-toggle="modal"
                        data-id ="${row.id}"
                        data-ac_gl_no ="${row.ac_gl_no}"
                        data-revaluation ="${row.revaluation} "
                        data-ac_gl_ccy ="${row.ac_gl_ccy}"
                        data-leaf_or_node ="${row.leaf_or_node}"
                        data-gl_branch_res ="${row.gl_branch_res}"
                        data-gl_category ="${row.gl_category}"
                        data-ac_gl_descption ="${row.ac_gl_descption}"
                        data-ac_ccy_res ="${row.ac_ccy_res}"
                        data-gl_type ="${row.gl_type}"
                        data-node_gl ="${row.node_gl}"
                        data-gl_post_type ="${row.gl_post_type}"
                    data-overall_limit ="${row.overall_limit}"><i class="si si-eye"></i> View </a>
                  
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


$("#filter-chartofaccounts").on("click", function() {
    dt_chart_of_accounts.on("preXhr.dt", function(e, settings, data) {
        data._csrf_token = $("#csrf").val();
        data.filter_ac_gl_no = $("#filter_ac_gl_no").val();
        data.filter_leaf_or_node = $("#filter_leaf_or_node").val();
        data.filter_gl_branch_res = $("#filter_gl_branch_res").val();
        data.start_date = $("#start_date").val();
        data.filter_ac_gl_descption = $("#filter_ac_gl_descption").val();
        data.filter_node_gl = $("#filter_node_gl").val();
        data.filter_gl_category = $("#filter_gl_category").val();
        data.end_date = $("#end_date").val();

    });
    $("#chart-of-accounts-filtermodal").modal("hide");
    dt_chart_of_accounts.draw();
});

